
#include maps\_utility;
#include animscripts\notetracks;
#include animscripts\utility;
#include animscripts\combat_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
placeWeaponOn( weapon, position, activeWeapon )
{
assert( AIHasWeapon( weapon ) );
self notify( "weapon_position_change" );
curPosition = self.weaponInfo[ weapon ].position;
assert( curPosition == "none" || self.a.weaponPos[ curPosition ] == weapon );
if ( position != "none" && self.a.weaponPos[ position ] == weapon )
{
return;
}
self detachAllWeaponModels();
if ( curPosition != "none" )
self detachWeapon( weapon );
if ( position == "none" )
{
self updateAttachedWeaponModels();
return;
}
if ( self.a.weaponPos[ position ] != "none" )
self detachWeapon( self.a.weaponPos[ position ] );
if ( !isdefined( activeWeapon ) )
activeWeapon = true;
if ( activeWeapon && ( position == "left" || position == "right" ) )
{
self attachWeapon( weapon, position );
self.weapon = weapon;
}
else
{
self attachWeapon( weapon, position );
}
self updateAttachedWeaponModels();
}
detachWeapon( weapon )
{
self.a.weaponPos[ self.weaponInfo[ weapon ].position ] = "none";
self.weaponInfo[ weapon ].position = "none";
}
attachWeapon( weapon, position )
{
self.weaponInfo[ weapon ].position = position;
self.a.weaponPos[ position ] = weapon;
if ( self.a.weaponPosDropping[ position ] != "none" )
{
self notify( "end_weapon_drop_" + position );
self.a.weaponPosDropping[ position ] = "none";
}
}
getWeaponForPos( position )
{
weapon = self.a.weaponPos[ position ];
if ( weapon == "none" )
return self.a.weaponPosDropping[ position ];
assert( self.a.weaponPosDropping[ position ] == "none" );
return weapon;
}
detachAllWeaponModels()
{
positions = [];
positions[ positions.size ] = "right";
positions[ positions.size ] = "left";
positions[ positions.size ] = "chest";
positions[ positions.size ] = "back";
self laserOff();
foreach ( position in positions )
{
weapon = self getWeaponForPos( position );
if ( weapon == "none" )
continue;
if ( weapontype( weapon ) == "riotshield" && isDefined( self.shieldModelVariant ) )
{
if ( isdefined( self.shieldBroken ) && self.shieldBroken )
{
playfxontag( getfx( "riot_shield_dmg" ), self, "TAG_BRASS" );
self.shieldBroken = undefined;
}
self detach( getWeaponModel( weapon, self.shieldModelVariant ), getTagForPos( position ) );
}
else
self detach( getWeaponModel( weapon ), getTagForPos( position ) );
}
}
NO_COLLISION = true;
updateAttachedWeaponModels()
{
positions = [];
positions[ positions.size ] = "right";
positions[ positions.size ] = "left";
positions[ positions.size ] = "chest";
positions[ positions.size ] = "back";
foreach ( position in positions )
{
weapon = self getWeaponForPos( position );
if ( weapon == "none" )
continue;
variant = 0;
if ( weapontype( weapon ) == "riotshield" && isDefined( self.shieldModelVariant ) )
variant = self.shieldModelVariant;
weapon_model = getWeaponModel( weapon, variant );
assertEx( weapon_model != "", "No weapon model for '" + weapon + "', make sure it is precached" );
if ( weapontype( weapon ) == "riotshield" )
self attach( weapon_model, getTagForPos( position ) );
else
self attach( weapon_model, getTagForPos( position ), NO_COLLISION );
hideTagList = GetWeaponHideTags( weapon );
for ( i = 0; i < hideTagList.size; i++ )
{
self HidePart( hideTagList[ i ], weapon_model );
}
if ( self.weaponInfo[ weapon ].useClip && !self.weaponInfo[ weapon ].hasClip )
self hidepart( "tag_clip" );
}
self updateLaserStatus();
}
updateLaserStatus()
{
if ( isdefined( self.custom_laser_function ) )
{
[[ self.custom_laser_function ]]();
return;
}
if ( self.a.weaponPos[ "right" ] == "none" )
return;
if ( canUseLaser() )
self laserOn();
else
self laserOff();
}
canUseLaser()
{
if ( !self.a.laserOn )
return false;
if ( isShotgun( self.weapon ) )
return false;
return isAlive( self );
}
getTagForPos( position )
{
switch( position )
{
case "chest":
return "tag_weapon_chest";
case "back":
return "tag_stowed_back";
case "left":
return "tag_weapon_left";
case "right":
return "tag_weapon_right";
case "hand":
return "tag_inhand";
default:
assertMsg( "unknown weapon placement position: " + position );
break;
}
}
DropAIWeapon( weapon )
{
if ( !isDefined( weapon ) )
weapon = self.weapon;
if ( weapon == "none" )
return;
if ( isdefined( self.noDrop ) )
return;
self detachAllWeaponModels();
position = self.weaponInfo[ weapon ].position;
if ( self.dropWeapon && position != "none" )
self thread DropWeaponWrapper( weapon, position );
self detachWeapon( weapon );
if ( weapon == self.weapon )
self.weapon = "none";
self updateAttachedWeaponModels();
}
DropAllAIWeapons()
{
if ( isdefined( self.noDrop ) )
return "none";
positions = [];
positions[ positions.size ] = "left";
positions[ positions.size ] = "right";
positions[ positions.size ] = "chest";
positions[ positions.size ] = "back";
self detachAllWeaponModels();
foreach ( position in positions )
{
weapon = self.a.weaponPos[ position ];
if ( weapon == "none" )
continue;
self.weaponInfo[ weapon ].position = "none";
self.a.weaponPos[ position ] = "none";
if ( self.dropWeapon )
self thread DropWeaponWrapper( weapon, position );
}
self.weapon = "none";
self updateAttachedWeaponModels();
}
DropWeaponWrapper( weapon, position )
{
if ( self IsRagdoll() )
return "none";
assert( self.a.weaponPosDropping[ position ] == "none" );
self.a.weaponPosDropping[ position ] = weapon;
actualDroppedWeapon = weapon;
if ( issubstr( tolower( actualDroppedWeapon ), "rpg" ) )
actualDroppedWeapon = "rpg_player";
self DropWeapon( actualDroppedWeapon, position, 0 );
self endon( "end_weapon_drop_" + position );
wait .1;
if ( !isDefined( self ) )
return;
self detachAllWeaponModels();
self.a.weaponPosDropping[ position ] = "none";
self updateAttachedWeaponModels();
}
DoNoteTracks( flagName, customFunction, debugIdentifier )
{
for ( ;; )
{
self waittill( flagName, note );
if ( !isDefined( note ) )
note = "undefined";
val = self HandleNoteTrack( note, flagName, customFunction );
if ( isDefined( val ) )
return val;
}
}
getPredictedAimYawToShootEntOrPos( time )
{
if ( !isdefined( self.shootEnt ) )
{
if ( !isdefined( self.shootPos ) )
return 0;
return getAimYawToPoint( self.shootPos );
}
predictedPos = self.shootEnt.origin + ( self.shootEntVelocity * time );
return getAimYawToPoint( predictedPos );
}
getAimYawToShootEntOrPos()
{
if ( !isdefined( self.shootEnt ) )
{
if ( !isdefined( self.shootPos ) )
return 0;
return getAimYawToPoint( self.shootPos );
}
return getAimYawToPoint( self.shootEnt getShootAtPos() );
}
getAimPitchToShootEntOrPos()
{
pitch = getPitchToShootEntOrPos();
if ( self.script == "cover_crouch" && isdefined( self.a.coverMode ) && self.a.coverMode == "lean" )
pitch -= anim.coverCrouchLeanPitch;
return pitch;
}
getPitchToShootEntOrPos()
{
if ( !isdefined( self.shootEnt ) )
{
if ( !isdefined( self.shootPos ) )
return 0;
return animscripts\combat_utility::getPitchToSpot( self.shootPos );
}
return animscripts\combat_utility::getPitchToSpot( self.shootEnt getShootAtPos() );
}
getShootFromPos()
{
if ( isdefined( self.useMuzzleSideOffset ) )
{
muzzlePos = self getMuzzleSideOffsetPos();
return ( muzzlePos[ 0 ], muzzlePos[ 1 ], self getEye()[ 2 ] );
}
return ( self.origin[ 0 ], self.origin[ 1 ], self getEye()[ 2 ] );
}
getAimYawToPoint( point )
{
yaw = GetYawToSpot( point );
dist = distance( self.origin, point );
if ( dist > 3 )
{
angleFudge = asin( -3 / dist );
yaw += angleFudge;
}
yaw = AngleClamp180( yaw );
return yaw;
}
ramboAim( baseYaw )
{
self endon( "killanimscript" );
ramboAimInternal( baseYaw );
self clearAnim( %generic_aim_left, 0.5 );
self clearAnim( %generic_aim_right, 0.5 );
}
ramboAimInternal( baseYaw )
{
self endon( "rambo_aim_end" );
waittillframeend;
self clearAnim( %generic_aim_left, 0.2 );
self clearAnim( %generic_aim_right, 0.2 );
self setAnimLimited( %generic_aim_45l, 1, 0.2 );
self setAnimLimited( %generic_aim_45r, 1, 0.2 );
interval = 0.2;
yaw = 0;
for ( ;; )
{
if ( isDefined( self.shootPos ) )
{
newyaw = GetYaw( self.shootPos ) - self.coverNode.angles[1];
newyaw = AngleClamp180( newyaw - baseYaw );
if ( abs( newyaw - yaw ) > 10 )
{
if ( newyaw > yaw )
newyaw = yaw + 10;
else
newyaw = yaw - 10;
}
yaw = newyaw;
}
if ( yaw < 0 )
{
weight = yaw / -45;
if ( weight > 1 )
weight = 1;
self setAnimLimited( %generic_aim_right, weight, interval );
self setAnimLimited( %generic_aim_left, 0, interval );
}
else
{
weight = yaw / 45;
if ( weight > 1 )
weight = 1;
self setAnimLimited( %generic_aim_left, weight, interval );
self setAnimLimited( %generic_aim_right, 0, interval );
}
wait interval;
}
}
decideNumShotsForBurst()
{
numShots = 0;
fixedBurstCount = weaponBurstCount( self.weapon );
if ( fixedBurstCount )
numShots = fixedBurstCount;
else if ( animscripts\weaponList::usingSemiAutoWeapon() )
numShots = anim.semiFireNumShots[ randomint( anim.semiFireNumShots.size ) ];
else if ( self.fastBurst )
numShots = anim.fastBurstFireNumShots[ randomint( anim.fastBurstFireNumShots.size ) ];
else
numShots = anim.burstFireNumShots[ randomint( anim.burstFireNumShots.size ) ];
if ( numShots <= self.bulletsInClip )
return numShots;
assertex( self.bulletsInClip >= 0, self.bulletsInClip );
if ( self.bulletsInClip <= 0 )
return 1;
return self.bulletsInClip;
}
decideNumShotsForFull()
{
numShots = self.bulletsInClip;
if ( weaponClass( self.weapon ) == "mg" )
{
choice = randomfloat( 10 );
if ( choice < 3 )
numShots = randomIntRange( 2, 6 );
else if ( choice < 8 )
numShots = randomIntRange( 6, 12 );
else
numShots = randomIntRange( 12, 20 );
}
return numShots;
}
insure_dropping_clip( note, flagName )
{
}
handleDropClip( flagName )
{
self endon( "killanimscript" );
self endon( "abort_reload" );
clipModel = undefined;
if ( self.weaponInfo[ self.weapon ].useClip )
clipModel = getWeaponClipModel( self.weapon );
if ( self.weaponInfo[ self.weapon ].hasClip )
{
if ( usingSidearm() )
self playsound( "weap_reload_pistol_clipout_npc" );
else
self playsound( "weap_reload_smg_clipout_npc" );
if ( isDefined( clipModel ) )
{
self hidepart( "tag_clip" );
self thread dropClipModel( clipModel, "tag_clip" );
self.weaponInfo[ self.weapon ].hasClip = false;
self thread resetClipOnAbort( clipModel );
}
}
for ( ;; )
{
self waittill( flagName, noteTrack );
switch( noteTrack )
{
case "attach clip left":
case "attach clip right":
if ( isdefined( clipModel ) )
{
self attach( clipModel, "tag_inhand" );
self thread resetClipOnAbort( clipModel, "tag_inhand" );
}
self animscripts\weaponList::RefillClip();
break;
case "detach clip nohand":
if ( isdefined( clipModel ) )
self detach( clipModel, "tag_inhand" );
break;
case "detach clip right":
case "detach clip left":
if ( isdefined( clipModel ) )
{
self detach( clipModel, "tag_inhand" );
self showpart( "tag_clip" );
self notify( "clip_detached" );
self.weaponInfo[ self.weapon ].hasClip = true;
}
if ( usingSidearm() )
self playsound( "weap_reload_pistol_clipin_npc" );
else
self playsound( "weap_reload_smg_clipin_npc" );
self.a.needsToRechamber = 0;
return;
}
}
}
resetClipOnAbort( clipModel, currentTag )
{
self notify( "clip_detached" );
self endon( "clip_detached" );
self waittill_any( "killanimscript", "abort_reload" );
if ( !isDefined( self ) )
return;
if ( isDefined( currentTag ) )
self detach( clipModel, currentTag );
if ( isAlive( self ) )
{
if ( self.weapon != "none" && self.weaponinfo[ self.weapon ].position != "none" )
{
self showpart( "tag_clip" );
}
self.weaponInfo[ self.weapon ].hasClip = true;
}
else
{
if ( isDefined( currentTag ) )
self dropClipModel( clipModel, currentTag );
}
}
dropClipModel( clipModel, tagName )
{
clip = spawn( "script_model", self getTagOrigin( tagName ) );
clip setModel( clipModel );
clip.angles = self getTagAngles( tagName );
clip PhysicsLaunchClient( clip.origin, (0,0,0) );
wait 10;
if ( isDefined( clip ) )
clip delete();
}
moveToOriginOverTime( origin, time )
{
self endon( "killanimscript" );
distSq = distanceSquared( self.origin, origin );
if ( distSq < 1 )
{
self safeTeleport( origin );
return;
}
if ( distSq > 16 * 16 && !self mayMoveToPoint( origin ) )
{
return;
}
self.keepClaimedNodeIfValid = true;
offset = self.origin - origin;
frames = int( time * 20 );
offsetreduction = ( offset * 1.0 / frames );
for ( i = 0; i < frames; i++ )
{
offset -= offsetreduction;
self safeTeleport( origin + offset );
wait .05;
}
self.keepClaimedNodeIfValid = false;
}
returnTrue() { return true; }
playLookAnimation( lookAnim, lookTime, canStopCallback )
{
if ( !isdefined( canStopCallback ) )
canStopCallback = ::returnTrue;
for ( i = 0; i < lookTime * 10; i++ )
{
if ( isalive( self.enemy ) )
{
if ( self canSeeEnemy() && [[ canStopCallback ]]() )
return;
}
if ( self isSuppressedWrapper() && [[ canStopCallback ]]() )
return;
self setAnimKnobAll( lookAnim, %body, 1, .1 );
wait( 0.1 );
}
}
throwDownWeapon( swapAnim )
{
self endon( "killanimscript" );
self animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
self maps\_gameskill::didSomethingOtherThanShooting();
}
rpgPlayerRepulsor()
{
MISSES_REMAINING = rpgPlayerRepulsor_getNumMisses();
if ( MISSES_REMAINING == 0 )
return;
self endon( "death" );
for(;;)
{
level waittill( "an_enemy_shot", guy );
if ( guy != self )
continue;
if ( !isdefined( guy.enemy ) )
continue;
if ( guy.enemy != level.player )
continue;
if ( ( isdefined( level.createRpgRepulsors ) ) && ( level.createRpgRepulsors == false ) )
continue;
thread rpgPlayerRepulsor_create();
MISSES_REMAINING--;
if ( MISSES_REMAINING <= 0 )
return;
}
}
rpgPlayerRepulsor_getNumMisses()
{
skill = getdifficulty();
switch( skill )
{
case "gimp":
case "easy":
return 2;
case "medium":
case "hard":
case "difficult":
return 1;
case "fu":
return 0;
}
return 2;
}
rpgPlayerRepulsor_create()
{
repulsor = Missile_CreateRepulsorEnt( level.player, 5000, 800 );
wait 4.0;
Missile_DeleteAttractor( repulsor );
}