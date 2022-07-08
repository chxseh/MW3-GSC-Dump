#include animscripts\Utility;
#include animscripts\notetracks;
#include maps\_gameskill;
#include maps\_utility;
#include common_scripts\utility;
#include animscripts\SetPoseMovement;
#using_animtree( "generic_human" );
getTargetAngleOffset( target )
{
pos = self getshootatpos() + ( 0, 0, -3 );
dir = ( pos[ 0 ] - target[ 0 ], pos[ 1 ] - target[ 1 ], pos[ 2 ] - target[ 2 ] );
dir = VectorNormalize( dir );
fact = dir[ 2 ] * - 1;
return fact;
}
getSniperBurstDelayTime()
{
if ( isPlayer( self.enemy ) )
return randomFloatRange( self.enemy.gs.min_sniper_burst_delay_time, self.enemy.gs.max_sniper_burst_delay_time );
else
return randomFloatRange( anim.min_sniper_burst_delay_time, anim.max_sniper_burst_delay_time );
}
getRemainingBurstDelayTime()
{
timeSoFar = ( gettime() - self.a.lastShootTime ) / 1000;
delayTime = getBurstDelayTime();
return max( 0, delayTime - timeSoFar );
}
getBurstDelayTime()
{
if ( self usingSidearm() )
return randomFloatRange( .15, .55 );
else if ( weapon_pump_action_shotgun() )
return randomFloatRange( 1.0, 1.7 );
else if ( self isSniper() )
return getSniperBurstDelayTime();
else if ( self.fastBurst )
return randomFloatRange( .1, .35 );
else
return randomFloatRange( .4, .9 );
}
burstDelay()
{
if ( self.bulletsInClip )
{
if ( self.shootStyle == "full" && !self.fastBurst )
{
if ( self.a.lastShootTime == gettime() )
wait .05;
return;
}
delayTime = getRemainingBurstDelayTime();
if ( delayTime )
wait delayTime;
}
}
cheatAmmoIfNecessary()
{
assert( !self.bulletsInClip );
if ( !isdefined( self.enemy ) )
return false;
if ( self.team != "allies" )
{
if ( !isPlayer( self.enemy ) )
return false;
if ( self.enemy ent_flag( "player_is_invulnerable" ) )
return false;
}
if ( usingSidearm() || usingRocketLauncher() )
return false;
if ( gettime() - self.ammoCheatTime < self.ammoCheatInterval )
return false;
if ( !self canSee( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) > 256*256 )
return false;
self.bulletsInClip = int( weaponClipSize( self.weapon ) / 2 );
if ( self.bulletsInClip > weaponClipSize( self.weapon ) )
self.bulletsInClip = weaponClipSize( self.weapon );
self.ammoCheatTime = gettime();
return true;
}
dontShoot_totalTime = 3;
dontShoot_interval = 0.05;
dontShoot_loopCount = dontShoot_totalTime / dontShoot_interval;
aimButDontShoot()
{
loopCount = int( dontShoot_loopCount );
while ( loopCount > 0 )
{
assert( !isdefined( self.dontEverShoot ) || self.dontEverShoot != 0 );
if ( isdefined( self.dontEverShoot ) || ( isdefined( self.enemy ) && isdefined( self.enemy.dontAttackMe ) ) )
wait dontShoot_interval;
else
return false;
loopCount--;
}
return true;
}
shootUntilShootBehaviorChange()
{
self endon( "shoot_behavior_change" );
self endon( "stopShooting" );
if ( self isLongRangeAI() )
{
if ( isDefined( self.enemy ) && isAI( self.enemy ) && distanceSquared( level.player.origin, self.enemy.origin ) < 384 * 384 )
self.enemy animscripts\battlechatter_ai::addThreatEvent( "infantry", self, 1.0 );
if ( usingRocketLauncher() && isSentient( self.enemy ) )
wait( randomFloat( 2.0 ) );
}
if ( isdefined( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) > squared( 400 ) )
burstCount = randomintrange( 1, 5 );
else
burstCount = 10;
while ( 1 )
{
burstDelay();
if ( aimButDontShoot() )
break;
numShots = 1;
switch( self.shootStyle )
{
case "full":
self FireUntilOutOfAmmo( animArray( "fire" ), true, animscripts\shared::decideNumShotsForFull() );
break;
case "burst":
case "semi":
numShots = animscripts\shared::decideNumShotsForBurst();
case "single":
if ( numShots == 1 )
self FireUntilOutOfAmmo( animArrayPickRandom( "single" ), true, numShots );
else
self FireUntilOutOfAmmo( animArray( self.shootStyle + numShots ), true, numShots );
break;
default:
assert( self.shootStyle == "none" );
self waittill( "hell freezes over" );
break;
}
if ( !self.bulletsInClip )
break;
burstCount--;
if ( burstCount < 0 )
{
self.shouldReturnToCover = true;
break;
}
}
}
getUniqueFlagNameIndex()
{
anim.animFlagNameIndex++;
return anim.animFlagNameIndex;
}
setupAim( transTime )
{
assert( isDefined( transTime ) );
self setAnim( %exposed_aiming, 1, .2 );
self setAnimKnobLimited( animarray( "straight_level" ), 1, transTime );
self setAnimKnobLimited( animArray( "add_aim_up" ), 1, transTime );
self setAnimKnobLimited( animArray( "add_aim_down" ), 1, transTime );
self setAnimKnobLimited( animArray( "add_aim_left" ), 1, transTime );
self setAnimKnobLimited( animArray( "add_aim_right" ), 1, transTime );
}
startFireAndAimIdleThread()
{
if ( !isdefined( self.a.aimIdleThread ) )
{
setupAim( 0.2 );
self thread aimIdleThread();
self thread animscripts\track::trackShootEntOrPos();
}
}
endFireAndAnimIdleThread()
{
endAimIdleThread();
self clearAnim( %add_fire, .1 );
self notify( "stop tracking" );
}
showFireHideAimIdle()
{
if ( isdefined( self.a.aimIdleThread ) )
self setAnim( %add_idle, 0, .2 );
self setAnim( %add_fire, 1, .1 );
}
hideFireShowAimIdle()
{
if ( isdefined( self.a.aimIdleThread ) )
self setAnim( %add_idle, 1, .2 );
self setAnim( %add_fire, 0, .1 );
}
aimIdleThread( lean )
{
self endon( "killanimscript" );
self endon( "end_aim_idle_thread" );
if ( isdefined( self.a.aimIdleThread ) )
return;
self.a.aimIdleThread = true;
wait 0.1;
self setAnimLimited( %add_idle, 1, .2 );
for ( i = 0; ; i++ )
{
flagname = "idle" + i;
if ( isdefined( self.a.leanAim ) )
idleanim = animArrayPickRandom( "lean_idle" );
else
idleanim = animArrayPickRandom( "exposed_idle" );
self setFlaggedAnimKnobLimitedRestart( flagname, idleanim, 1, 0.2 );
self waittillmatch( flagname, "end" );
}
self clearAnim( %add_idle, .1 );
}
endAimIdleThread()
{
self notify( "end_aim_idle_thread" );
self.a.aimIdleThread = undefined;
self clearAnim( %add_idle, .1 );
}
shotgunFireRate()
{
if ( weapon_pump_action_shotgun() )
return 1.0;
if ( animscripts\weaponList::usingAutomaticWeapon() )
return animscripts\weaponList::autoShootAnimRate() * 0.7;
return 0.4;
}
FireUntilOutOfAmmo( fireAnim, stopOnAnimationEnd, maxshots )
{
animName = "fireAnim_" + getUniqueFlagNameIndex();
maps\_gameskill::resetMissTime();
while ( !aimedAtShootEntOrPos() )
wait .05;
prof_begin("FireUntilOutOfAmmo");
self showFireHideAimIdle();
rate = 1.0;
if ( isdefined( self.shootRateOverride ) )
rate = self.shootRateOverride;
else if ( self.shootStyle == "full" )
rate = animscripts\weaponList::autoShootAnimRate() * randomfloatrange( 0.5, 1.0 );
else if ( self.shootStyle == "burst" )
rate = animscripts\weaponList::burstShootAnimRate();
else if ( usingSidearm() )
rate = 3.0;
else if ( usingShotgun() )
rate = shotgunFireRate();
self setFlaggedAnimKnobRestart( animName, fireAnim, 1, .2, rate );
self updatePlayerSightAccuracy();
prof_end("FireUntilOutOfAmmo");
if (!isdefined(self.catch_shootbehaviorchange))
self.catch_shootbehaviorchange=0;
self.catch_shootbehaviorchange++;
FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots );
self.catch_shootbehaviorchange = 0;
self hideFireShowAimIdle();
}
FireUntilOutOfAmmoInternal( animName, fireAnim, stopOnAnimationEnd, maxshots )
{
self endon( "enemy" );
if ( isPlayer( self.enemy ) && ( self.shootStyle == "full" || self.shootStyle == "semi" ) )
level endon( "player_becoming_invulnerable" );
if ( stopOnAnimationEnd )
{
self thread NotifyOnAnimEnd( animName, "fireAnimEnd" );
self endon( "fireAnimEnd" );
}
if ( !isdefined( maxshots ) )
maxshots = -1;
numshots = 0;
hasFireNotetrack = animHasNoteTrack( fireAnim, "fire" );
usingRocketLauncher = ( weaponClass( self.weapon ) == "rocketlauncher" );
while ( numshots < maxshots && maxshots > 0 )
{
if ( hasFireNotetrack )
self waittillmatch( animName, "fire" );
if ( !self.bulletsInClip )
{
if ( !cheatAmmoIfNecessary() )
break;
}
prof_begin("FireUntilOutOfAmmoInternal");
if ( !aimedAtShootEntOrPos() )
break;
self shootAtShootEntOrPos();
assertex( self.bulletsInClip >= 0, self.bulletsInClip );
if ( isPlayer( self.enemy ) && self.enemy ent_flag( "player_is_invulnerable" ) )
{
if ( randomint( 3 ) == 0 )
self.bulletsInClip -- ;
}
else
{
self.bulletsInClip -- ;
}
if ( usingRocketLauncher )
{
self.a.rockets -- ;
if ( self.weapon == "rpg" )
{
self hidepart( "tag_rocket" );
self.a.rocketVisible = false;
}
}
numshots++;
self thread shotgunPumpSound( animName );
prof_end("FireUntilOutOfAmmoInternal");
if ( self.fastBurst && numshots == maxshots )
break;
if ( !hasFireNotetrack || (maxShots == 1 && self.shootStyle == "single") )
self waittillmatch( animName, "end" );
}
if ( stopOnAnimationEnd )
self notify( "fireAnimEnd" );
}
aimedAtShootEntOrPos()
{
prof_begin( "aimedAtShootEntOrPos" );
if ( !isdefined( self.shootPos ) )
{
assert( !isdefined( self.shootEnt ) );
prof_end( "aimedAtShootEntOrPos" );
return true;
}
weaponAngles = self getMuzzleAngle();
shootFromPos = animscripts\shared::getShootFromPos();
anglesToShootPos = vectorToAngles( self.shootPos - shootFromPos );
absyawdiff = AbsAngleClamp180( weaponAngles[ 1 ] - anglesToShootPos[ 1 ] );
if ( absyawdiff > anim.aimYawDiffFarTolerance )
{
if ( distanceSquared( self getEye(), self.shootPos ) > anim.aimYawDiffCloseDistSQ || absyawdiff > anim.aimYawDiffCloseTolerance )
{
prof_end( "aimedAtShootEntOrPos" );
return false;
}
}
prof_end( "aimedAtShootEntOrPos" );
return AbsAngleClamp180( weaponAngles[ 0 ] - anglesToShootPos[ 0 ] ) <= anim.aimPitchDiffTolerance;
}
NotifyOnAnimEnd( animNotify, endNotify )
{
self endon( "killanimscript" );
self endon( endNotify );
self waittillmatch( animNotify, "end" );
self notify( endNotify );
}
shootAtShootEntOrPos()
{
prof_begin("shootAtShootEntOrPos");
if ( isdefined( self.shootEnt ) )
{
if ( isDefined( self.enemy ) && self.shootEnt == self.enemy )
self shootEnemyWrapper();
}
else
{
assert( isdefined( self.shootPos ) );
self shootPosWrapper( self.shootPos );
}
prof_end("shootAtShootEntOrPos");
}
showRocket()
{
if ( self.weapon != "rpg" )
return;
self.a.rocketVisible = true;
self showpart("tag_rocket");
self notify( "showing_rocket" );
}
showRocketWhenReloadIsDone()
{
if ( self.weapon != "rpg" )
return;
self endon( "death" );
self endon( "showing_rocket" );
self waittill( "killanimscript" );
self showRocket();
}
decrementBulletsInClip()
{
if ( self.bulletsInClip )
self.bulletsInClip -- ;
}
shotgunPumpSound( animName )
{
if ( !weapon_pump_action_shotgun() )
return;
self endon( "killanimscript" );
self notify( "shotgun_pump_sound_end" );
self endon( "shotgun_pump_sound_end" );
self thread stopShotgunPumpAfterTime( 2.0 );
self waittillmatch( animName, "rechamber" );
self playSound( "ai_shotgun_pump" );
self notify( "shotgun_pump_sound_end" );
}
stopShotgunPumpAfterTime( timer )
{
self endon( "killanimscript" );
self endon( "shotgun_pump_sound_end" );
wait timer;
self notify( "shotgun_pump_sound_end" );
}
Rechamber( isExposed )
{
}
NeedToReload( thresholdFraction )
{
if ( self.weapon == "none" )
return false;
if ( isdefined( self.noreload ) )
{
assertex( self.noreload, ".noreload must be true or undefined" );
if ( self.bulletsinclip < weaponClipSize( self.weapon ) * 0.5 )
self.bulletsinclip = int( weaponClipSize( self.weapon ) * 0.5 );
if ( self.bulletsinclip <= 0 )
self.bulletsinclip = 0;
return false;
}
if ( self.bulletsInClip <= weaponClipSize( self.weapon ) * thresholdFraction )
{
if ( thresholdFraction == 0 )
{
if ( cheatAmmoIfNecessary() )
return false;
}
return true;
}
return false;
}
putGunBackInHandOnKillAnimScript()
{
self endon( "weapon_switch_done" );
self endon( "death" );
self waittill( "killanimscript" );
animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
}
Reload( thresholdFraction, optionalAnimation )
{
self endon( "killanimscript" );
if ( !NeedToReload( thresholdFraction ) )
return false;
prof_begin( "Reload" );
self animscripts\battleChatter_ai::evaluateReloadEvent();
self animscripts\battleChatter::playBattleChatter();
if ( isDefined( optionalAnimation ) )
{
self setFlaggedAnimKnobAll( "reloadanim", optionalAnimation, %body, 1, .1, 1 );
animscripts\shared::DoNoteTracks( "reloadanim" );
self animscripts\weaponList::RefillClip();
self.a.needsToRechamber = 0;
}
else
{
if ( self.a.pose == "prone" )
{
self setFlaggedAnimKnobAll( "reloadanim", %prone_reload, %body, 1, .1, 1 );
self UpdateProne( %prone_legs_up, %prone_legs_down, 1, 0.1, 1 );
}
else
{
println( "Bad anim_pose in combat::Reload" );
prof_end( "Reload" );
wait 2;
return;
}
animscripts\shared::DoNoteTracks( "reloadanim" );
animscripts\weaponList::RefillClip();
self.a.needsToRechamber = 0;
}
return true;
}
addGrenadeThrowAnimOffset( throwAnim, offset )
{
if ( !isdefined( anim.grenadeThrowAnims ) )
{
anim.grenadeThrowAnims = [];
anim.grenadeThrowOffsets = [];
}
assert( anim.grenadeThrowAnims.size == anim.grenadeThrowOffsets.size );
index = anim.grenadeThrowAnims.size;
anim.grenadeThrowAnims[ index ] = throwAnim;
anim.grenadeThrowOffsets[ index ] = offset;
}
initGrenadeThrowAnims()
{
addGrenadeThrowAnimOffset( %exposed_grenadethrowb, ( 41.5391, 7.28883, 72.2128 ) );
addGrenadeThrowAnimOffset( %exposed_grenadethrowc, ( 34.8849, -4.77048, 74.0488 ) );
addGrenadeThrowAnimOffset( %corner_standl_grenade_a, ( 41.605, 6.80107, 81.4785 ) );
addGrenadeThrowAnimOffset( %corner_standl_grenade_b, ( 24.1585, -14.7221, 29.2992 ) );
addGrenadeThrowAnimOffset( %cornercrl_grenadea, ( 25.8988, -10.2811, 30.4813 ) );
addGrenadeThrowAnimOffset( %cornercrl_grenadeb, ( 24.688, 45.0702, 64.377 ) );
addGrenadeThrowAnimOffset( %corner_standr_grenade_a, ( 37.1254, -32.7053, 76.5745 ) );
addGrenadeThrowAnimOffset( %corner_standr_grenade_b, ( 19.356, 15.5341, 16.5036 ) );
addGrenadeThrowAnimOffset( %cornercrr_grenadea, ( 39.8857, 5.92472, 24.5878 ) );
addGrenadeThrowAnimOffset( %covercrouch_grenadea, ( -1.6363, -0.693674, 60.1009 ) );
addGrenadeThrowAnimOffset( %covercrouch_grenadeb, ( -1.6363, -0.693674, 60.1009 ) );
addGrenadeThrowAnimOffset( %coverstand_grenadea, ( 10.8573, 7.12614, 77.2356 ) );
addGrenadeThrowAnimOffset( %coverstand_grenadeb, ( 19.1804, 5.68214, 73.2278 ) );
addGrenadeThrowAnimOffset( %prone_grenade_a, ( 12.2859, -1.3019, 33.4307 ) );
addGrenadeThrowAnimOffset( %CQB_stand_grenade_throw, ( 35.7494, 26.6052, 37.7086 ) );
}
getGrenadeThrowOffset( throwAnim )
{
prof_begin( "getGrenadeThrowOffset" );
offset = ( 0, 0, 64 );
if ( isdefined( throwAnim ) )
{
foreach( index, grenadeThrowAnim in anim.grenadeThrowAnims )
{
if ( throwAnim == grenadeThrowAnim )
{
offset = anim.grenadeThrowOffsets[ index ];
break;
}
}
}
if ( offset[ 2 ] == 64 )
{
if ( isdefined( throwAnim ) )
println( "^1Warning: undefined grenade throw animation used; hand offset unknown" );
else
println( "^1Warning: grenade throw animation ", throwAnim, " has no recorded hand offset" );
}
prof_end( "getGrenadeThrowOffset" );
return offset;
}
ThrowGrenadeAtPlayerASAP_combat_utility()
{
assert( self isBadGuy() );
for ( i = 0; i < level.players.size; i++ )
{
if ( level.players[ i ].numGrenadesInProgressTowardsPlayer == 0 )
{
level.players[ i ].grenadeTimers[ "fraggrenade" ] = 0;
level.players[ i ].grenadeTimers[ "flash_grenade" ] = 0;
}
}
anim.throwGrenadeAtPlayerASAP = true;
}
setActiveGrenadeTimer( throwingAt )
{
self.activeGrenadeTimer = spawnstruct();
if ( isPlayer( throwingAt ) )
{
self.activeGrenadeTimer.isPlayerTimer = true;
self.activeGrenadeTimer.player = throwingAt;
self.activeGrenadeTimer.timerName = self.grenadeWeapon;
assertex( isdefined( throwingAt.grenadeTimers[ self.activeGrenadeTimer.timerName ] ), "No grenade timer for " + self.activeGrenadeTimer.timerName );
}
else
{
self.activeGrenadeTimer.isPlayerTimer = false;
self.activeGrenadeTimer.timerName = "AI_" + self.grenadeWeapon;
assertex( isdefined( anim.grenadeTimers[ self.activeGrenadeTimer.timerName ] ), "No grenade timer for " + self.activeGrenadeTimer.timerName );
}
}
usingPlayerGrenadeTimer()
{
assert( isDefined( self.activeGrenadeTimer ) );
return self.activeGrenadeTimer.isPlayerTimer;
}
setGrenadeTimer( grenadeTimer, newValue )
{
if ( grenadeTimer.isPlayerTimer )
{
player = grenadeTimer.player;
oldValue = player.grenadeTimers[ grenadeTimer.timerName ];
player.grenadeTimers[ grenadeTimer.timerName ] = max( newValue, oldValue );
}
else
{
oldValue = anim.grenadeTimers[ grenadeTimer.timerName ];
anim.grenadeTimers[ grenadeTimer.timerName ] = max( newValue, oldValue );
}
}
getDesiredGrenadeTimerValue()
{
nextGrenadeTimeToUse = undefined;
if ( self usingPlayerGrenadeTimer() )
{
player = self.activeGrenadeTimer.player;
nextGrenadeTimeToUse = gettime() + player.gs.playerGrenadeBaseTime + randomint( player.gs.playerGrenadeRangeTime );
}
else
{
nextGrenadeTimeToUse = gettime() + 30000 + randomint( 30000 );
}
return nextGrenadeTimeToUse;
}
getGrenadeTimerTime( grenadeTimer )
{
if ( grenadeTimer.isPlayerTimer )
{
return grenadeTimer.player.grenadeTimers[ grenadeTimer.timerName ];
}
else
{
return anim.grenadeTimers[ grenadeTimer.timerName ];
}
}
considerChangingTarget( throwingAt )
{
prof_begin( "considerChangingTarget" );
if ( !isPlayer( throwingAt ) && self isBadGuy() )
{
if ( gettime() < getGrenadeTimerTime( self.activeGrenadeTimer ) )
{
if ( level.player.ignoreme )
{
prof_end( "considerChangingTarget" );
return throwingAt;
}
myGroup = self getthreatbiasgroup();
playerGroup = level.player getthreatbiasgroup();
if ( myGroup != "" && playerGroup != "" && getThreatBias( playerGroup, myGroup ) < - 10000 )
{
prof_end( "considerChangingTarget" );
return throwingAt;
}
if ( self canSee( level.player ) || ( isAI( throwingAt ) && throwingAt canSee( level.player ) ) )
{
if ( isdefined( self.covernode ) )
{
angles = VectorToAngles( level.player.origin - self.origin );
yawDiff = AngleClamp180( self.covernode.angles[ 1 ] - angles[ 1 ] );
}
else
{
yawDiff = self GetYawToSpot( level.player.origin );
}
if ( abs( yawDiff ) < 60 )
{
throwingAt = level.player;
self setActiveGrenadeTimer( throwingAt );
}
}
}
}
prof_end( "considerChangingTarget" );
return throwingAt;
}
mayThrowDoubleGrenade( throwingAt )
{
assert( self.activeGrenadeTimer.isPlayerTimer );
assert( self.activeGrenadeTimer.timerName == "fraggrenade" );
assert( isPlayer( throwingAt ) );
if ( player_died_recently() )
return false;
if ( !throwingAt.gs.double_grenades_allowed )
return false;
time = gettime();
if ( time < throwingAt.grenadeTimers[ "double_grenade" ] )
return false;
if ( time > throwingAt.lastFragGrenadeToPlayerStart + 3000 )
return false;
if ( time < throwingAt.lastFragGrenadeToPlayerStart + 500 )
return false;
return throwingAt.numGrenadesInProgressTowardsPlayer < 2;
}
myGrenadeCoolDownElapsed()
{
return( gettime() >= self.a.nextGrenadeTryTime );
}
grenadeCoolDownElapsed( throwingAt )
{
if ( player_died_recently() )
return false;
if ( self.script_forcegrenade == 1 )
return true;
if ( !myGrenadeCoolDownElapsed() )
return false;
if ( gettime() >= getGrenadeTimerTime( self.activeGrenadeTimer ) )
return true;
if ( self.activeGrenadeTimer.isPlayerTimer && self.activeGrenadeTimer.timerName == "fraggrenade" )
return mayThrowDoubleGrenade( throwingAt );
return false;
}
TryGrenadePosProc( throwingAt, destination, optionalAnimation, armOffset )
{
if ( !( self isGrenadePosSafe( throwingAt, destination ) ) )
return false;
else if ( distanceSquared( self.origin, destination ) < 200 * 200 )
return false;
prof_begin( "TryGrenadePosProc" );
trace = physicsTrace( destination + ( 0, 0, 1 ), destination + ( 0, 0, -500 ) );
if ( trace == destination + ( 0, 0, -500 ) )
return false;
trace += ( 0, 0, .1 );
prof_end( "TryGrenadePosProc" );
return TryGrenadeThrow( throwingAt, trace, optionalAnimation, armOffset );
}
TryGrenade( throwingAt, optionalAnimation )
{
if ( self.weapon == "mg42" || self.grenadeammo <= 0 )
return false;
self setActiveGrenadeTimer( throwingAt );
throwingAt = considerChangingTarget( throwingAt );
if ( !grenadeCoolDownElapsed( throwingAt ) )
return false;
armOffset = getGrenadeThrowOffset( optionalAnimation );
if ( isdefined( self.enemy ) && throwingAt == self.enemy )
{
if ( !checkGrenadeThrowDist() )
{
return false;
}
if ( isPlayer( self.enemy ) && is_player_down( self.enemy ) )
{
return false;
}
if ( self canSeeEnemyFromExposed() )
{
if ( !( self isGrenadePosSafe( throwingAt, throwingAt.origin ) ) )
{
return false;
}
return TryGrenadeThrow( throwingAt, undefined, optionalAnimation, armOffset );
}
else if ( self canSuppressEnemyFromExposed() )
{
return TryGrenadePosProc( throwingAt, self getEnemySightPos(), optionalAnimation, armOffset );
}
else
{
if ( !( self isGrenadePosSafe( throwingAt, throwingAt.origin ) ) )
{
return false;
}
return TryGrenadeThrow( throwingAt, undefined, optionalAnimation, armOffset );
}
return false;
}
else
{
return TryGrenadePosProc( throwingAt, throwingAt.origin, optionalAnimation, armOffset );
}
}
TryGrenadeThrow( throwingAt, destination, optionalAnimation, armOffset, fastThrow, withBounce, throwInThread )
{
if ( gettime() < 10000 && !isdefined( level.ignoreGrenadeSafeTime ) )
{
return false;
}
if ( !isdefined( withBounce ) )
withBounce = true;
prof_begin( "TryGrenadeThrow" );
if ( isDefined( optionalAnimation ) )
{
throw_anim = optionalAnimation;
gunHand = self.a.gunHand;
}
else
{
switch( self.a.special )
{
case "cover_crouch":
case "none":
if ( self.a.pose == "stand" )
{
armOffset = ( 0, 0, 80 );
throw_anim = %stand_grenade_throw;
}
else
{
armOffset = ( 0, 0, 65 );
throw_anim = %crouch_grenade_throw;
}
gunHand = "left";
break;
default:
throw_anim = undefined;
gunHand = undefined;
break;
}
}
if ( !isDefined( throw_anim ) )
{
prof_end( "TryGrenadeThrow" );
return( false );
}
if ( isdefined( destination ) )
{
if ( !isdefined( fastThrow ) )
throwvel = self checkGrenadeThrowPos( armOffset, destination, withBounce, "min energy", "min time", "max time" );
else
throwvel = self checkGrenadeThrowPos( armOffset, destination, withBounce, "min time", "min energy" );
}
else
{
randomRange = self.randomGrenadeRange;
dist = distance( throwingAt.origin, self.origin );
if ( dist < 800 )
{
if ( dist < 256 )
randomRange = 0;
else
randomRange *= (dist - 256) / (800 - 256);
}
assert( self.enemy == throwingAt );
if ( !isdefined( fastThrow ) )
throwvel = self checkGrenadeThrow( armOffset, randomRange, "min energy", "min time", "max time" );
else
throwvel = self checkGrenadeThrow( armOffset, randomRange, "min time", "min energy" );
}
self.a.nextGrenadeTryTime = gettime() + randomintrange( 1000, 2000 );
if ( isdefined( throwvel ) )
{
if ( !isdefined( self.oldGrenAwareness ) )
self.oldGrenAwareness = self.grenadeawareness;
self.grenadeawareness = 0;
nextGrenadeTimeToUse = self getDesiredGrenadeTimerValue();
setGrenadeTimer( self.activeGrenadeTimer, min( gettime() + 3000, nextGrenadeTimeToUse ) );
secondGrenadeOfDouble = false;
if ( self usingPlayerGrenadeTimer() )
{
assert( throwingAt == self.activeGrenadeTimer.player );
throwingAt.numGrenadesInProgressTowardsPlayer++ ;
self thread reduceGIPTPOnKillanimscript( throwingAt );
if ( throwingAt.numGrenadesInProgressTowardsPlayer > 1 )
secondGrenadeOfDouble = true;
if ( self.activeGrenadeTimer.timerName == "fraggrenade" )
{
if ( throwingAt.numGrenadesInProgressTowardsPlayer <= 1 )
throwingAt.lastFragGrenadeToPlayerStart = gettime();
}
}
if ( isdefined( throwInThread ) )
thread DoGrenadeThrow( throw_anim, throwVel, nextGrenadeTimeToUse, secondGrenadeOfDouble );
else
DoGrenadeThrow( throw_anim, throwVel, nextGrenadeTimeToUse, secondGrenadeOfDouble );
return true;
}
else
{
}
return false;
}
reduceGIPTPOnKillanimscript( throwingAt )
{
self endon( "dont_reduce_giptp_on_killanimscript" );
self waittill( "killanimscript" );
throwingAt.numGrenadesInProgressTowardsPlayer -- ;
}
DoGrenadeThrow( throw_anim, throwVel, nextGrenadeTimeToUse, secondGrenadeOfDouble )
{
self endon( "killanimscript" );
prof_begin( "DoGrenadeThrow" );
if ( self.script == "combat" || self.script == "move" )
self orientmode( "face direction", throwVel );
self animscripts\battleChatter_ai::evaluateAttackEvent( self.grenadeWeapon );
self notify( "stop_aiming_at_enemy" );
self SetFlaggedAnimKnobAllRestart( "throwanim", throw_anim, %body, fasterAnimSpeed(), 0.1, 1 );
self thread DoNoteTracksForever( "throwanim", "killanimscript" );
model = getGrenadeModel();
attachside = "none";
for ( ;; )
{
self waittill( "throwanim", notetrack );
prof_begin( "DoGrenadeThrow" );
if ( notetrack == "grenade_left" || notetrack == "grenade_right" )
{
attachside = attachGrenadeModel( model, "TAG_INHAND" );
self.isHoldingGrenade = true;
}
if ( notetrack == "grenade_throw" || notetrack == "grenade throw" )
break;
assert( notetrack != "end" );
if ( notetrack == "end" )
{
self.activeGrenadeTimer.player.numGrenadesInProgressTowardsPlayer -- ;
self notify( "dont_reduce_giptp_on_killanimscript" );
prof_end( "DoGrenadeThrow" );
return false;
}
}
self notify( "dont_reduce_giptp_on_killanimscript" );
if ( self usingPlayerGrenadeTimer() )
{
self thread watchGrenadeTowardsPlayer( self.activeGrenadeTimer.player, nextGrenadeTimeToUse );
}
self throwGrenade();
if ( !self usingPlayerGrenadeTimer() )
{
setGrenadeTimer( self.activeGrenadeTimer, nextGrenadeTimeToUse );
}
if ( secondGrenadeOfDouble )
{
assert( self.activeGrenadeTimer.isPlayerTimer );
player = self.activeGrenadeTimer.player;
assert( isPlayer( player ) );
if ( player.numGrenadesInProgressTowardsPlayer > 1 || gettime() - player.lastGrenadeLandedNearPlayerTime < 2000 )
{
player.grenadeTimers[ "double_grenade" ] = gettime() + min( 5000, player.gs.playerDoubleGrenadeTime );
}
}
self notify( "stop grenade check" );
if ( attachSide != "none" )
self detach( model, attachside );
else
{
print( "No grenade hand set: " );
println( throw_anim );
println( "animation in console does not specify grenade hand" );
}
self.isHoldingGrenade = undefined;
self.grenadeawareness = self.oldGrenAwareness;
self.oldGrenAwareness = undefined;
prof_end( "DoGrenadeThrow" );
self waittillmatch( "throwanim", "end" );
self notify( "done_grenade_throw" );
self notify( "weapon_switch_done" );
self setanim( %exposed_modern, 1, .2 );
self setanim( %exposed_aiming, 1 );
self clearanim( throw_anim, .2 );
}
watchGrenadeTowardsPlayer( player, nextGrenadeTimeToUse )
{
player endon( "death" );
watchGrenadeTowardsPlayerInternal( nextGrenadeTimeToUse );
player.numGrenadesInProgressTowardsPlayer -- ;
}
watchGrenadeTowardsPlayerInternal( nextGrenadeTimeToUse )
{
activeGrenadeTimer = self.activeGrenadeTimer;
timeoutObj = spawnstruct();
timeoutObj thread watchGrenadeTowardsPlayerTimeout( 5 );
timeoutObj endon( "watchGrenadeTowardsPlayerTimeout" );
type = self.grenadeWeapon;
grenade = self getGrenadeIThrew();
if ( !isdefined( grenade ) )
{
return;
}
setGrenadeTimer( activeGrenadeTimer, min( gettime() + 5000, nextGrenadeTimeToUse ) );
goodRadiusSqrd = 250 * 250;
giveUpRadiusSqrd = 400 * 400;
if ( type == "flash_grenade" )
{
goodRadiusSqrd = 900 * 900;
giveUpRadiusSqrd = 1300 * 1300;
}
playersToCheck = level.players;
prevorigin = grenade.origin;
while ( 1 )
{
wait .1;
if ( !isdefined( grenade ) )
break;
if ( distanceSquared( grenade.origin, prevorigin ) < 400 )
{
newPlayersToCheck = [];
for ( i = 0; i < playersToCheck.size; i++ )
{
player = playersToCheck[ i ];
distSqrd = distanceSquared( grenade.origin, player.origin );
if ( distSqrd < goodRadiusSqrd )
{
player grenadeLandedNearPlayer( activeGrenadeTimer, nextGrenadeTimeToUse );
}
else if ( distSqrd < giveUpRadiusSqrd )
{
newPlayersToCheck[ newPlayersToCheck.size ] = player;
}
}
playersToCheck = newPlayersToCheck;
if ( playersToCheck.size == 0 )
break;
}
prevorigin = grenade.origin;
}
}
grenadeLandedNearPlayer( activeGrenadeTimer, nextGrenadeTimeToUse )
{
player = self;
anim.throwGrenadeAtPlayerASAP = undefined;
if ( gettime() - player.lastGrenadeLandedNearPlayerTime < 3000 )
{
player.grenadeTimers[ "double_grenade" ] = gettime() + player.gs.playerDoubleGrenadeTime;
}
player.lastGrenadeLandedNearPlayerTime = gettime();
oldValue = player.grenadeTimers[ activeGrenadeTimer.timerName ];
player.grenadeTimers[ activeGrenadeTimer.timerName ] = max( nextGrenadeTimeToUse, oldValue );
}
getGrenadeIThrew()
{
self endon( "killanimscript" );
self waittill( "grenade_fire", grenade );
return grenade;
}
watchGrenadeTowardsPlayerTimeout( timerlength )
{
wait timerlength;
self notify( "watchGrenadeTowardsPlayerTimeout" );
}
attachGrenadeModel( model, tag )
{
self attach( model, tag );
thread detachGrenadeOnScriptChange( model, tag );
return tag;
}
detachGrenadeOnScriptChange( model, tag )
{
self endon( "stop grenade check" );
self waittill( "killanimscript" );
if ( !isdefined( self ) )
return;
if ( isdefined( self.oldGrenAwareness ) )
{
self.grenadeawareness = self.oldGrenAwareness;
self.oldGrenAwareness = undefined;
}
self detach( model, tag );
}
offsetToOrigin( start )
{
forward = anglestoforward( self.angles );
right = anglestoright( self.angles );
up = anglestoup( self.angles );
forward = ( forward * start[ 0 ] );
right = ( right * start[ 1 ] );
up = ( up * start[ 2 ] );
return( forward + right + up );
}
grenadeLine( start, end )
{
level notify( "armoffset" );
level endon( "armoffset" );
start = self.origin + offsetToOrigin( start );
for ( ;; )
{
line( start, end, ( 1, 0, 1 ) );
print3d( start, start, ( 0.2, 0.5, 1.0 ), 1, 1 );
print3d( end, end, ( 0.2, 0.5, 1.0 ), 1, 1 );
wait( 0.05 );
}
}
getGrenadeDropVelocity()
{
yaw = randomFloat( 360 );
pitch = randomFloatRange( 30, 75 );
amntz = sin( pitch );
cospitch = cos( pitch );
amntx = cos( yaw ) * cospitch;
amnty = sin( yaw ) * cospitch;
speed = randomFloatRange( 100, 200 );
velocity = ( amntx, amnty, amntz ) * speed;
return velocity;
}
dropGrenade()
{
grenadeOrigin = self GetTagOrigin( "tag_inhand" );
velocity = getGrenadeDropVelocity();
self MagicGrenadeManual( grenadeOrigin, velocity, 3 );
}
lookForBetterCover()
{
if ( !isdefined( self.enemy ) )
return false;
if ( self.fixedNode || self.doingAmbush )
return false;
prof_begin( "lookForBetterCover" );
node = self getBestCoverNodeIfAvailable();
if ( isdefined( node ) )
{
return useCoverNodeIfPossible( node );
}
prof_end( "lookForBetterCover" );
return false;
}
getBestCoverNodeIfAvailable()
{
prof_begin( "getBestCoverNodeIfAvailable" );
node = self FindBestCoverNode();
if ( !isdefined( node ) )
{
prof_end( "getBestCoverNodeIfAvailable" );
return undefined;
}
currentNode = self GetClaimedNode();
if ( isdefined( currentNode ) && node == currentNode )
{
prof_end( "getBestCoverNodeIfAvailable" );
return undefined;
}
if ( isdefined( self.coverNode ) && node == self.coverNode )
{
prof_end( "getBestCoverNodeIfAvailable" );
return undefined;
}
prof_end( "getBestCoverNodeIfAvailable" );
return node;
}
useCoverNodeIfPossible( node )
{
oldKeepNodeInGoal = self.keepClaimedNodeIfValid;
oldKeepNode = self.keepClaimedNode;
self.keepClaimedNodeIfValid = false;
self.keepClaimedNode = false;
if ( self UseCoverNode( node ) )
{
return true;
}
else
{
}
self.keepClaimedNodeIfValid = oldKeepNodeInGoal;
self.keepClaimedNode = oldKeepNode;
return false;
}
shouldHelpAdvancingTeammate()
{
if ( level.advanceToEnemyGroup[ self.team ] > 0 && level.advanceToEnemyGroup[ self.team ] < level.advanceToEnemyGroupMax )
{
if ( gettime() - level.lastAdvanceToEnemyTime[ self.team ] > 4000 )
return false;
leadAttacker = level.lastAdvanceToEnemyAttacker[ self.team ];
nearLeadAttacker = isdefined( leadAttacker ) && distanceSquared( self.origin, leadAttacker.origin ) < 256 * 256;
if ( ( nearLeadAttacker || distanceSquared( self.origin, level.lastAdvanceToEnemySrc[ self.team ] ) < 256 * 256 ) &&
( !isdefined( self.enemy ) || distanceSquared( self.enemy.origin, level.lastAdvanceToEnemyDest[ self.team ] ) < 512 * 512 ) )
{
return true;
}
}
return false;
}
checkAdvanceOnEnemyConditions()
{
if ( !isdefined( level.lastAdvanceToEnemyTime[ self.team ] ) )
return false;
if ( shouldHelpAdvancingTeammate() )
return true;
if ( gettime() - level.lastAdvanceToEnemyTime[ self.team ] < level.advanceToEnemyInterval )
return false;
if ( !isSentient( self.enemy ) )
return false;
if ( level.advanceToEnemyGroup[ self.team ] )
level.advanceToEnemyGroup[ self.team ] = 0;
advance_regardless_of_numbers = isdefined(self.advance_regardless_of_numbers) && self.advance_regardless_of_numbers;
if ( !advance_regardless_of_numbers && getAICount( self.team ) < getAICount( self.enemy.team ) )
return false;
return true;
}
tryRunningToEnemy( ignoreSuppression )
{
if ( !isdefined( self.enemy ) )
return false;
if ( self.fixedNode )
return false;
if ( self.combatMode == "ambush" || self.combatMode == "ambush_nodes_only" )
return false;
if ( !self isingoal( self.enemy.origin ) )
return false;
if ( self isLongRangeAI() )
return false;
if ( !checkAdvanceOnEnemyConditions() )
return false;
self FindReacquireDirectPath( ignoreSuppression );
if ( self ReacquireMove() )
{
self.keepClaimedNodeIfValid = false;
self.keepClaimedNode = false;
self.a.magicReloadWhenReachEnemy = true;
if ( level.advanceToEnemyGroup[ self.team ] == 0 )
{
level.lastAdvanceToEnemyTime[ self.team ] = gettime();
level.lastAdvanceToEnemyAttacker[ self.team ] = self;
}
level.lastAdvanceToEnemySrc[ self.team ] = self.origin;
level.lastAdvanceToEnemyDest[ self.team ] = self.enemy.origin;
level.advanceToEnemyGroup[ self.team ]++;
return true;
}
return false;
}
delayedBadplace( org )
{
self endon( "death" );
wait( 0.5 );
string = "" + anim.badPlaceInt;
badplace_cylinder( string, 5, org, 16, 64, self.team );
anim.badPlaces[ anim.badPlaces.size ] = string;
if ( anim.badPlaces.size >= 10 )
{
newArray = [];
for ( i = 1;i < anim.badPlaces.size;i++ )
newArray[ newArray.size ] = anim.badPlaces[ i ];
badplace_delete( anim.badPlaces[ 0 ] );
anim.badPlaces = newArray;
}
anim.badPlaceInt++ ;
if ( anim.badPlaceInt > 10 )
anim.badPlaceInt -= 20;
}
valueIsWithin( value, min, max )
{
if ( value > min && value < max )
return true;
return false;
}
getGunYawToShootEntOrPos()
{
if ( !isdefined( self.shootPos ) )
{
assert( !isdefined( self.shootEnt ) );
return 0;
}
yaw = self getMuzzleAngle()[ 1 ] - GetYaw( self.shootPos );
yaw = AngleClamp180( yaw );
return yaw;
}
getGunPitchToShootEntOrPos()
{
if ( !isdefined( self.shootPos ) )
{
assert( !isdefined( self.shootEnt ) );
return 0;
}
pitch = self getMuzzleAngle()[ 0 ] - VectorToAngles( self.shootPos - self getMuzzlePos() )[ 0 ];
pitch = AngleClamp180( pitch );
return pitch;
}
getPitchToEnemy()
{
if ( !isdefined( self.enemy ) )
return 0;
vectorToEnemy = self.enemy getshootatpos() - self getshootatpos();
vectorToEnemy = vectornormalize( vectortoenemy );
pitchDelta = 360 - vectortoangles( vectorToEnemy )[ 0 ];
return AngleClamp180( pitchDelta );
}
getPitchToSpot( spot )
{
if ( !isdefined( spot ) )
return 0;
vectorToEnemy = spot - self getshootatpos();
vectorToEnemy = vectornormalize( vectortoenemy );
pitchDelta = 360 - vectortoangles( vectorToEnemy )[ 0 ];
return AngleClamp180( pitchDelta );
}
watchReloading()
{
self.isreloading = false;
self.lastReloadStartTime = -1;
while ( 1 )
{
self waittill( "reload_start" );
self.isreloading = true;
self.lastReloadStartTime = GetTime();
self waittillreloadfinished();
self.isreloading = false;
}
}
waittillReloadFinished()
{
self thread timedNotify( 4, "reloadtimeout" );
self endon( "reloadtimeout" );
self endon( "weapon_taken" );
while ( 1 )
{
self waittill( "reload" );
weap = self getCurrentWeapon();
if ( weap == "none" )
break;
if ( self getCurrentWeaponClipAmmo() >= weaponClipSize( weap ) )
break;
}
self notify( "reloadtimeout" );
}
timedNotify( time, msg )
{
self endon( msg );
wait time;
self notify( msg );
}
maxFlashThrowDistSq = 768 * 768;
minGrenadeThrowDistSq = 200 * 200;
maxGrenadeThrowDistSq = 1250 * 1250;
checkGrenadeThrowDist()
{
diff = self.enemy.origin - self.origin;
distSq = lengthSquared( ( diff[ 0 ], diff[ 1 ], 0 ) );
if ( self.grenadeWeapon == "flash_grenade" )
return (distSq < maxFlashThrowDistSq);
return (distSq >= minGrenadeThrowDistSq) && (distSq <= maxGrenadeThrowDistSq);
}
monitorFlash()
{
self endon( "death" );
if ( !IsDefined( level.neverStopMonitoringFlash ) )
self endon( "stop_monitoring_flash" );
while ( 1 )
{
amount_distance = undefined;
origin = undefined;
amount_angle = undefined;
attacker = undefined;
attackerteam = undefined;
self waittill( "flashbang", origin, amount_distance, amount_angle, attacker, attackerteam );
if ( isDefined( self.flashBangImmunity ) && self.flashBangImmunity )
continue;
if ( isdefined( self.script_immunetoflash ) && self.script_immunetoflash != 0 )
continue;
if ( isdefined( self.onSnowMobile ) || isdefined( self.onATV ) )
continue;
if ( isdefined( self.team ) && isdefined( attackerteam ) && self.team == attackerteam )
{
amount_distance = 3 * ( amount_distance - .75 );
if ( amount_distance < 0 )
continue;
if ( isdefined( self.teamFlashbangImmunity ) )
continue;
}
minamountdist = 0.2;
if ( amount_distance > 1 - minamountdist )
amount_distance = 1.0;
else
amount_distance = amount_distance / ( 1 - minamountdist );
duration = 4.5 * amount_distance;
if ( duration < 0.25 )
continue;
self.flashingTeam = attackerteam;
self flashBangStart( duration );
self notify( "doFlashBanged", origin, attacker );
}
}
isShotgunAI()
{
return isShotgun( self.primaryweapon );
}
isSniper()
{
return isSniperRifle( self.primaryweapon );
}
isLongRangeAI()
{
return isSniper() || usingRocketLauncher();
}
fasterAnimSpeed()
{
return 1.5;
}
randomfasterAnimSpeed()
{
return randomfloatrange( 1, 1.2 );
}
getRandomCoverMode( modes )
{
if ( modes.size == 0 )
return undefined;
if ( modes.size == 1 )
return modes[0];
if ( isdefined( self.a.prevAttack ) && randomint( 100 ) > 20 )
{
foreach ( i, mode in modes )
{
if ( mode == self.a.prevAttack )
{
if ( i < modes.size - 1 )
modes[ i ] = modes[ modes.size - 1 ];
modes[ modes.size - 1 ] = undefined;
break;
}
}
}
return modes[ randomint( modes.size ) ];
}
player_sees_my_scope()
{
start = self geteye();
foreach ( player in level.players )
{
if ( !self cansee( player ) )
continue;
end = player GetEye();
angles = VectorToAngles( start - end );
forward = AnglesToForward( angles );
player_angles = player GetPlayerAngles();
player_forward = AnglesToForward( player_angles );
dot = VectorDot( forward, player_forward );
if ( dot < 0.805 )
continue;
if ( cointoss() && dot >= 0.996 )
continue;
return true;
}
return false;
}