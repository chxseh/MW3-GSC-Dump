
#include animscripts\Utility;
#include maps\_utility;
#include animscripts\Combat_utility;
#include common_scripts\Utility;
#using_animtree( "generic_human" );
initWeapon( weapon )
{
self.weaponInfo[ weapon ] = spawnstruct();
self.weaponInfo[ weapon ].position = "none";
self.weaponInfo[ weapon ].hasClip = true;
if ( getWeaponClipModel( weapon ) != "" )
self.weaponInfo[ weapon ].useClip = true;
else
self.weaponInfo[ weapon ].useClip = false;
}
isWeaponInitialized( weapon )
{
return isDefined( self.weaponInfo[ weapon ] );
}
setGlobalAimSettings()
{
anim.coverCrouchLeanPitch = 55;
anim.aimYawDiffFarTolerance = 10;
anim.aimYawDiffCloseDistSQ = 64 * 64;
anim.aimYawDiffCloseTolerance = 45;
anim.aimPitchDiffTolerance = 20;
anim.painYawDiffFarTolerance = 25;
anim.painYawDiffCloseDistSQ = anim.aimYawDiffCloseDistSQ;
anim.painYawDiffCloseTolerance = anim.aimYawDiffCloseTolerance;
anim.painPitchDiffTolerance = 30;
anim.maxAngleCheckYawDelta = 65;
anim.maxAngleCheckPitchDelta = 65;
}
everUsesSecondaryWeapon()
{
if ( isShotgun( self.secondaryweapon ) )
return true;
if ( weaponClass( self.primaryweapon ) == "rocketlauncher" )
return true;
return false;
}
main()
{
prof_begin( "animscript_init" );
self.a = spawnStruct();
self.a.laserOn = false;
self.primaryweapon = self.weapon;
firstInit();
if ( self.primaryweapon == "" )
self.primaryweapon = "none";
if ( self.secondaryweapon == "" )
self.secondaryweapon = "none";
if ( self.sidearm == "" )
self.sidearm = "none";
self initWeapon( self.primaryweapon );
self initWeapon( self.secondaryweapon );
self initWeapon( self.sidearm );
assertex( self.primaryweapon != self.sidearm || self.primaryweapon == "none", "AI \"" + self.classname + "\" with export " + self.export + " has both a sidearm and primaryweapon of \"" + self.primaryweapon + "\"." );
assertex( self.secondaryweapon != self.sidearm || self.secondaryweapon == "none" || !self everUsesSecondaryWeapon(), "AI \"" + self.classname + "\" with export " + self.export + " has both a sidearm and secondaryweapon of \"" + self.primaryweapon + "\"." );
self setDefaultAimLimits();
self.a.weaponPos[ "left" ] = "none";
self.a.weaponPos[ "right" ] = "none";
self.a.weaponPos[ "chest" ] = "none";
self.a.weaponPos[ "back" ] = "none";
self.a.weaponPosDropping[ "left" ] = "none";
self.a.weaponPosDropping[ "right" ] = "none";
self.a.weaponPosDropping[ "chest" ] = "none";
self.a.weaponPosDropping[ "back" ] = "none";
self.lastWeapon = self.weapon;
self.root_anim = %root;
self thread beginGrenadeTracking();
hasRocketLauncher = usingRocketLauncher();
self.a.neverLean = hasRocketLauncher;
if ( hasRocketLauncher )
self thread animscripts\shared::rpgPlayerRepulsor();
self.a.rockets = 3;
self.a.rocketVisible = true;
self.a.pose = "stand";
self.a.grenadeThrowPose = "stand";
self.a.movement = "stop";
self.a.state = "stop";
self.a.special = "none";
self.a.gunHand = "none";
self.a.PrevPutGunInHandTime = -1;
self.dropWeapon = true;
self.minExposedGrenadeDist = 750;
animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
if ( isShotgun( self.secondaryweapon ) )
animscripts\shared::placeWeaponOn( self.secondaryweapon, "back" );
self.a.needsToRechamber = 0;
self.a.combatEndTime = gettime();
self.a.lastEnemyTime = gettime();
self.a.suppressingEnemy = false;
self.a.disableLongDeath = !( self isBadGuy() );
self.a.lookangle = 0;
self.a.painTime = 0;
self.a.lastShootTime = 0;
self.a.nextGrenadeTryTime = 0;
self.a.reactToBulletChance = 0.8;
if ( self.team != "allies" )
{
self.has_no_ir = true;
}
self.a.postScriptFunc = undefined;
self.a.stance = "stand";
self.choosePoseFunc = animscripts\utility::choosePose;
self._animActive = 0;
self._lastAnimTime = 0;
self thread enemyNotify();
self.baseAccuracy = 1;
self.a.missTime = 0;
self.a.nodeath = false;
self.a.missTime = 0;
self.a.missTimeDebounce = 0;
self.a.disablePain = false;
self.accuracyStationaryMod = 1;
self.chatInitialized = false;
self.sightPosTime = 0;
self.sightPosLeft = true;
self.needRecalculateGoodShootPos = true;
self.defaultTurnThreshold = 55;
self.a.nextStandingHitDying = false;
if ( !isdefined( self.script_forcegrenade ) )
self.script_forcegrenade = 0;
SetupUniqueAnims();
self animscripts\weaponList::RefillClip();
self.lastEnemySightTime = 0;
self.combatTime = 0;
self.suppressed = false;
self.suppressedTime = 0;
if ( self.team == "allies" )
self.suppressionThreshold = 0.5;
else
self.suppressionThreshold = 0.0;
if ( self.team == "allies" )
self.randomGrenadeRange = 0;
else
self.randomGrenadeRange = 256;
self.ammoCheatInterval = 8000;
self.ammoCheatTime = 0;
animscripts\animset::set_animset_run_n_gun();
self.exception = [];
self.exception[ "corner" ] = 1;
self.exception[ "cover_crouch" ] = 1;
self.exception[ "stop" ] = 1;
self.exception[ "stop_immediate" ] = 1;
self.exception[ "move" ] = 1;
self.exception[ "exposed" ] = 1;
self.exception[ "corner_normal" ] = 1;
keys = getArrayKeys( self.exception );
for ( i = 0; i < keys.size; i++ )
{
clear_exception( keys[ i ] );
}
self.reacquire_state = 0;
self thread setNameAndRank_andAddToSquad();
self.shouldConserveAmmoTime = 0;
self thread monitorFlash();
self thread onDeath();
prof_end( "animscript_init" );
}
weapons_with_ir( weapon )
{
weapons[ 0 ] = "m4_grenadier";
weapons[ 1 ] = "m4_grunt";
weapons[ 2 ] = "m4_silencer";
weapons[ 3 ] = "m4m203";
if ( !isdefined( weapon ) )
return false;
for ( i = 0 ; i < weapons.size ; i++ )
{
if ( issubstr( weapon, weapons[ i ] ) )
return true;
}
return false;
}
setNameAndRank_andAddToSquad()
{
self endon( "death" );
if ( !isdefined( level.loadoutComplete ) )
level waittill( "loadout complete" );
self maps\_names::get_name();
self thread animscripts\squadManager::addToSquad();
}
PollAllowedStancesThread()
{
for ( ;; )
{
if ( self isStanceAllowed( "stand" ) )
{
line[ 0 ] = "stand allowed";
color[ 0 ] = ( 0, 1, 0 );
}
else
{
line[ 0 ] = "stand not allowed";
color[ 0 ] = ( 1, 0, 0 );
}
if ( self isStanceAllowed( "crouch" ) )
{
line[ 1 ] = "crouch allowed";
color[ 1 ] = ( 0, 1, 0 );
}
else
{
line[ 1 ] = "crouch not allowed";
color[ 1 ] = ( 1, 0, 0 );
}
if ( self isStanceAllowed( "prone" ) )
{
line[ 2 ] = "prone allowed";
color[ 2 ] = ( 0, 1, 0 );
}
else
{
line[ 2 ] = "prone not allowed";
color[ 2 ] = ( 1, 0, 0 );
}
aboveHead = self getshootatpos() + ( 0, 0, 30 );
offset = ( 0, 0, -10 );
for ( i = 0 ; i < line.size ; i++ )
{
textPos = ( aboveHead[ 0 ] + ( offset[ 0 ] * i ), aboveHead[ 1 ] + ( offset[ 1 ] * i ), aboveHead[ 2 ] + ( offset[ 2 ] * i ) );
print3d( textPos, line[ i ], color[ i ], 1, 0.75 );
}
wait 0.05;
}
}
SetupUniqueAnims()
{
if ( !isDefined( self.animplaybackrate ) || !isDefined( self.moveplaybackrate ) )
{
set_anim_playback_rate();
}
}
set_anim_playback_rate()
{
self.animplaybackrate = 0.9 + randomfloat( 0.2 );
self.moveTransitionRate = 0.9 + randomfloat( 0.2 );
self.moveplaybackrate = 1;
self.sideStepRate = 1.35;
}
infiniteLoop( one, two, three, whatever )
{
anim waittill( "new exceptions" );
}
empty( one, two, three, whatever )
{
}
enemyNotify()
{
self endon( "death" );
if ( 1 ) return;
for ( ;; )
{
self waittill( "enemy" );
if ( !isalive( self.enemy ) )
continue;
while ( isplayer( self.enemy ) )
{
if ( hasEnemySightPos() )
level.lastPlayerSighted = gettime();
wait( 2 );
}
}
}
initWindowTraverse()
{
level.window_down_height[ 0 ] = -36.8552;
level.window_down_height[ 1 ] = -27.0095;
level.window_down_height[ 2 ] = -15.5981;
level.window_down_height[ 3 ] = -4.37769;
level.window_down_height[ 4 ] = 17.7776;
level.window_down_height[ 5 ] = 59.8499;
level.window_down_height[ 6 ] = 104.808;
level.window_down_height[ 7 ] = 152.325;
level.window_down_height[ 8 ] = 201.052;
level.window_down_height[ 9 ] = 250.244;
level.window_down_height[ 10 ] = 298.971;
level.window_down_height[ 11 ] = 330.681;
}
firstInit()
{
if ( isDefined( anim.NotFirstTime ) )
return;
anim.NotFirstTime = true;
animscripts\animset::init_anim_sets();
anim.useFacialAnims = false;
maps\_load::init_level_players();
level.player.invul = false;
level.nextGrenadeDrop = randomint( 3 );
level.lastPlayerSighted = 100;
anim.defaultException = animscripts\init::empty;
initDeveloperDvars();
setdvar( "scr_expDeathMayMoveCheck", "on" );
maps\_names::setup_names();
anim.animFlagNameIndex = 0;
animscripts\init_move_transitions::initMoveStartStopTransitions();
animscripts\reactions::initReactionAnims();
anim.combatMemoryTimeConst = 10000;
anim.combatMemoryTimeRand = 6000;
initGrenades();
initAdvanceToEnemy();
setEnv( "none" );
if ( !isdefined( anim.optionalStepEffectFunction ) )
{
anim.optionalStepEffectSmallFunction = animscripts\notetracks::playFootStepEffectSmall;
anim.optionalStepEffectFunction = animscripts\notetracks::playFootStepEffect;
}
if ( !isdefined( anim.optionalStepEffects ) )
anim.optionalStepEffects = [];
if ( !isdefined( anim.optionalStepEffectsSmall ) )
anim.optionalStepEffectsSmall = [];
anim.shootEnemyWrapper_func = ::shootEnemyWrapper_shootNotify;
anim.fire_notetrack_functions[ "scripted" ] = animscripts\notetracks::fire_straight;
anim.fire_notetrack_functions[ "cover_right" ] = animscripts\notetracks::shootNotetrack;
anim.fire_notetrack_functions[ "cover_left" ] = animscripts\notetracks::shootNotetrack;
anim.fire_notetrack_functions[ "cover_crouch" ] = animscripts\notetracks::shootNotetrack;
anim.fire_notetrack_functions[ "cover_stand" ] = animscripts\notetracks::shootNotetrack;
anim.fire_notetrack_functions[ "move" ] = animscripts\notetracks::shootNotetrack;
animscripts\notetracks::registerNoteTracks();
if ( !isdefined( level.flag ) )
common_scripts\utility::init_flags();
maps\_gameskill::setSkill();
level.painAI = undefined;
animscripts\SetPoseMovement::InitPoseMovementFunctions();
animscripts\face::InitLevelFace();
anim.burstFireNumShots = array( 1, 2, 2, 2, 3, 3, 3, 3, 4, 4, 5 );
anim.fastBurstFireNumShots = array( 2, 3, 3, 3, 4, 4, 4, 5, 5 );
anim.semiFireNumShots = array( 1, 2, 2, 3, 3, 4, 4, 4, 4, 5, 5, 5 );
anim.badPlaces = [];
anim.badPlaceInt = 0;
anim.player = getentarray( "player", "classname" )[ 0 ];
initBattlechatter();
initWindowTraverse();
animscripts\flashed::initFlashed();
animscripts\cqb::setupCQBPointsOfInterest();
initDeaths();
setGlobalAimSettings();
anim.lastCarExplosionTime = -100000;
setupRandomTable();
level.player thread watchReloading();
thread AITurnNotifies();
}
initDeveloperDvars()
{
}
initBattlechatter()
{
animscripts\squadmanager::init_squadManager();
anim.player thread animscripts\squadManager::addPlayerToSquad();
animscripts\battleChatter::init_battleChatter();
anim.player thread animscripts\battleChatter_ai::addToSystem();
anim thread animscripts\battleChatter::bcsDebugWaiter();
}
initDeaths()
{
anim.numDeathsUntilCrawlingPain = randomintrange( 0, 15 );
anim.numDeathsUntilCornerGrenadeDeath = randomintrange( 0, 10 );
anim.nextCrawlingPainTime = gettime() + randomintrange( 0, 20000 );
anim.nextCrawlingPainTimeFromLegDamage = gettime() + randomintrange( 0, 10000 );
anim.nextCornerGrenadeDeathTime = gettime() + randomintrange( 0, 15000 );
}
initGrenades()
{
for ( i = 0; i < level.players.size; i++ )
{
player = level.players[ i ];
player.grenadeTimers[ "fraggrenade" ] = randomIntRange( 1000, 20000 );
player.grenadeTimers[ "flash_grenade" ] = randomIntRange( 1000, 20000 );
player.grenadeTimers[ "double_grenade" ] = randomIntRange( 1000, 60000 );
player.numGrenadesInProgressTowardsPlayer = 0;
player.lastGrenadeLandedNearPlayerTime = -1000000;
player.lastFragGrenadeToPlayerStart = -1000000;
player thread setNextPlayerGrenadeTime();
}
anim.grenadeTimers[ "AI_fraggrenade" ] = randomIntRange( 0, 20000 );
anim.grenadeTimers[ "AI_flash_grenade" ] = randomIntRange( 0, 20000 );
anim.grenadeTimers[ "AI_smoke_grenade_american" ] = randomIntRange( 0, 20000 );
initGrenadeThrowAnims();
}
initAdvanceToEnemy()
{
level.lastAdvanceToEnemyTime = [];
level.lastAdvanceToEnemyTime[ "axis" ] = 0;
level.lastAdvanceToEnemyTime[ "allies" ] = 0;
level.lastAdvanceToEnemyTime[ "team3" ] = 0;
level.lastAdvanceToEnemyTime[ "neutral" ] = 0;
level.lastAdvanceToEnemyDest = [];
level.lastAdvanceToEnemyDest[ "axis" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemyDest[ "allies" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemyDest[ "team3" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemyDest[ "neutral" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemySrc = [];
level.lastAdvanceToEnemySrc[ "axis" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemySrc[ "allies" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemySrc[ "team3" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemySrc[ "neutral" ] = ( 0, 0, 0 );
level.lastAdvanceToEnemyAttacker = [];
level.advanceToEnemyGroup = [];
level.advanceToEnemyGroup[ "axis" ] = 0;
level.advanceToEnemyGroup[ "allies" ] = 0;
level.advanceToEnemyGroup[ "team3" ] = 0;
level.advanceToEnemyGroup[ "neutral" ] = 0;
level.advanceToEnemyInterval = 30000;
level.advanceToEnemyGroupMax = 3;
}
AITurnNotifies()
{
numTurnsThisFrame = 0;
maxAIPerFrame = 3;
while ( 1 )
{
ai = getAIArray();
if ( ai.size == 0 )
{
wait .05;
numTurnsThisFrame = 0;
continue;
}
for ( i = 0; i < ai.size; i++ )
{
if ( !isdefined( ai[ i ] ) )
continue;
ai[ i ] notify( "do_slow_things" );
numTurnsThisFrame++ ;
if ( numTurnsThisFrame == maxAIPerFrame )
{
wait .05;
numTurnsThisFrame = 0;
}
}
}
}
setNextPlayerGrenadeTime()
{
assert( isPlayer( self ) );
waittillframeend;
if ( isdefined( self.gs.playerGrenadeRangeTime ) )
{
maxTime = int( self.gs.playerGrenadeRangeTime * 0.7 );
if ( maxTime < 1 )
maxTime = 1;
self.grenadeTimers[ "fraggrenade" ] = randomIntRange( 0, maxTime );
self.grenadeTimers[ "flash_grenade" ] = randomIntRange( 0, maxTime );
}
if ( isdefined( self.gs.playerDoubleGrenadeTime ) )
{
maxTime = int( self.gs.playerDoubleGrenadeTime );
minTime = int( maxTime / 2 );
if ( maxTime <= minTime )
maxTime = minTime + 1;
self.grenadeTimers[ "double_grenade" ] = randomIntRange( minTime, maxTime );
}
}
beginGrenadeTracking()
{
self endon( "death" );
for ( ;; )
{
self waittill( "grenade_fire", grenade, weaponName );
grenade thread grenade_earthQuake();
}
}
setupRandomTable()
{
anim.randomIntTableSize = 60;
anim.randomIntTable = [];
for ( i = 0; i < anim.randomIntTableSize; i++ )
anim.randomIntTable[ i ] = i;
for ( i = 0; i < anim.randomIntTableSize; i++ )
{
switchwith = randomint( anim.randomIntTableSize );
temp = anim.randomIntTable[ i ];
anim.randomIntTable[ i ] = anim.randomIntTable[ switchwith ];
anim.randomIntTable[ switchwith ] = temp;
}
}
onDeath()
{
if( isDefined( level.disableStrangeOndeath ) )
return;
self waittill( "death" );
if ( !isdefined( self ) )
{
if ( isdefined( self.a.usingTurret ) )
self.a.usingTurret delete();
}
}
