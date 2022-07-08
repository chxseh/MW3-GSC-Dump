
#include maps\_utility;
#include animscripts\shared;
#include animscripts\utility;
#include animscripts\combat_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
HandleDogSoundNoteTracks( note )
{
if ( note == "sound_dogstep_run_default" )
{
self playsound( "dogstep_run_default" );
return true;
}
prefix = getsubstr( note, 0, 5 );
if ( prefix != "sound" )
return false;
alias = "anml" + getsubstr( note, 5 );
if ( isalive( self ) )
self thread play_sound_on_tag_endon_death( alias, "tag_eye" );
else
self thread play_sound_in_space( alias, self GetEye() );
return true;
}
growling()
{
return isdefined( self.script_growl );
}
registerNoteTracks()
{
anim.notetracks[ "anim_pose = \"stand\"" ] = ::noteTrackPoseStand;
anim.notetracks[ "anim_pose = \"crouch\"" ] = ::noteTrackPoseCrouch;
anim.notetracks[ "anim_pose = \"prone\"" ] = ::noteTrackPoseProne;
anim.notetracks[ "anim_pose = \"crawl\"" ] = ::noteTrackPoseCrawl;
anim.notetracks[ "anim_pose = \"back\"" ] = ::noteTrackPoseBack;
anim.notetracks[ "anim_movement = \"stop\"" ] = ::noteTrackMovementStop;
anim.notetracks[ "anim_movement = \"walk\"" ] = ::noteTrackMovementWalk;
anim.notetracks[ "anim_movement = \"run\"" ] = ::noteTrackMovementRun;
anim.notetracks[ "anim_aiming = 1" ] = ::noteTrackAlertnessAiming;
anim.notetracks[ "anim_aiming = 0" ] = ::noteTrackAlertnessAlert;
anim.notetracks[ "anim_alertness = causal" ] = ::noteTrackAlertnessCasual;
anim.notetracks[ "anim_alertness = alert" ] = ::noteTrackAlertnessAlert;
anim.notetracks[ "anim_alertness = aiming" ] = ::noteTrackAlertnessAiming;
anim.notetracks[ "gunhand = (gunhand)_left" ] = ::noteTrackGunhand;
anim.notetracks[ "anim_gunhand = \"left\"" ] = ::noteTrackGunhand;
anim.notetracks[ "gunhand = (gunhand)_right" ] = ::noteTrackGunhand;
anim.notetracks[ "anim_gunhand = \"right\"" ] = ::noteTrackGunhand;
anim.notetracks[ "anim_gunhand = \"none\"" ] = ::noteTrackGunhand;
anim.notetracks[ "gun drop" ] = ::noteTrackGunDrop;
anim.notetracks[ "dropgun" ] = ::noteTrackGunDrop;
anim.notetracks[ "gun_2_chest" ] = ::noteTrackGunToChest;
anim.notetracks[ "gun_2_back" ] = ::noteTrackGunToBack;
anim.notetracks[ "pistol_pickup" ] = ::noteTrackPistolPickup;
anim.notetracks[ "pistol_putaway" ] = ::noteTrackPistolPutaway;
anim.notetracks[ "drop clip" ] = ::noteTrackDropClip;
anim.notetracks[ "refill clip" ] = ::noteTrackRefillClip;
anim.notetracks[ "reload done" ] = ::noteTrackRefillClip;
anim.notetracks[ "load_shell" ] = ::noteTrackLoadShell;
anim.notetracks[ "pistol_rechamber" ] = ::noteTrackPistolRechamber;
anim.notetracks[ "gravity on" ] = ::noteTrackGravity;
anim.notetracks[ "gravity off" ] = ::noteTrackGravity;
anim.notetracks[ "footstep_right_large" ] = ::noteTrackFootStep;
anim.notetracks[ "footstep_right_small" ] = ::noteTrackFootStep;
anim.notetracks[ "footstep_left_large" ] = ::noteTrackFootStep;
anim.notetracks[ "footstep_left_small" ] = ::noteTrackFootStep;
anim.notetracks[ "footscrape" ] = ::noteTrackFootScrape;
anim.notetracks[ "land" ] = ::noteTrackLand;
anim.notetracks[ "bodyfall large" ] = ::noteTrackBodyFall;
anim.notetracks[ "bodyfall small" ] = ::noteTrackBodyFall;
anim.notetracks[ "code_move" ] = ::noteTrackCodeMove;
anim.notetracks[ "face_enemy" ] = ::noteTrackFaceEnemy;
anim.notetracks[ "laser_on" ] = ::noteTrackLaser;
anim.notetracks[ "laser_off" ] = ::noteTrackLaser;
anim.notetracks[ "start_ragdoll" ] = ::noteTrackStartRagdoll;
anim.notetracks[ "wiisetallowragdoll" ] = ::noteTrackWiiSetAllowRagdoll;
anim.notetracks[ "fire" ] = ::noteTrackFire;
anim.notetracks[ "fire_spray" ] = ::noteTrackFireSpray;
anim.notetracks[ "bloodpool" ] = animscripts\death::play_blood_pool;
if ( isdefined( level._notetrackFX ) )
{
keys = getArrayKeys( level._notetrackFX );
foreach( key in keys )
anim.notetracks[ key ] = ::customNotetrackFX;
}
}
noteTrackFire( note, flagName )
{
if ( isdefined( anim.fire_notetrack_functions[ self.script ] ) )
thread [[ anim.fire_notetrack_functions[ self.script ] ]]();
else
thread [[ ::shootNotetrack ]]();
}
noteTrackLaser( note, flagName )
{
if ( isSubStr( note, "on" ) )
self.a.laserOn = true;
else
self.a.laserOn = false;
self animscripts\shared::updateLaserStatus();
}
noteTrackStopAnim( note, flagName )
{
}
unlinkNextFrame()
{
wait .1;
if ( isdefined( self ) )
self unlink();
}
noteTrackStartRagdoll( note, flagName )
{
if ( isdefined( self.noragdoll ) )
{
return;
}
if ( IsDefined( self.ragdolltime ) )
{
return;
}
if ( !IsDefined( self.dont_unlink_ragdoll ) )
{
self thread unlinkNextFrame();
}
self StartRagdoll();
}
noteTrackWiiSetAllowRagdoll( note, flagName )
{
self wiisetallowragdoll( true );
}
noteTrackMovementStop( note, flagName )
{
self.a.movement = "stop";
}
noteTrackMovementWalk( note, flagName )
{
self.a.movement = "walk";
}
noteTrackMovementRun( note, flagName )
{
self.a.movement = "run";
}
noteTrackAlertnessAiming( note, flagName )
{
}
noteTrackAlertnessCasual( note, flagName )
{
}
noteTrackAlertnessAlert( note, flagName )
{
}
stopOnBack()
{
self ExitProneWrapper( 1.0 );
self.a.onback = undefined;
}
setPose( pose )
{
self.a.pose = pose;
if ( isdefined( self.a.onback ) )
stopOnBack();
self notify( "entered_pose" + pose );
}
noteTrackPoseStand( note, flagName )
{
if ( self.a.pose == "prone" )
{
self OrientMode( "face default" );
self ExitProneWrapper( 1.0 );
}
setPose( "stand" );
}
noteTrackPoseCrouch( note, flagName )
{
if ( self.a.pose == "prone" )
{
self OrientMode( "face default" );
self ExitProneWrapper( 1.0 );
}
setPose( "crouch" );
}
noteTrackPoseProne( note, flagName )
{
if ( !issentient( self ) )
return;
self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
self EnterProneWrapper( 1.0 );
setPose( "prone" );
if ( isdefined( self.a.goingToProneAim ) )
self.a.proneAiming = true;
else
self.a.proneAiming = undefined;
}
noteTrackPoseCrawl( note, flagName )
{
if ( !issentient( self ) )
return;
self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_aiming, %prone_legs_up );
self EnterProneWrapper( 1.0 );
setPose( "prone" );
self.a.proneAiming = undefined;
}
noteTrackPoseBack( note, flagName )
{
if ( !issentient( self ) )
return;
setPose( "crouch" );
self.a.onback = true;
self.a.movement = "stop";
self setProneAnimNodes( -90, 90, %prone_legs_down, %exposed_aiming, %prone_legs_up );
self EnterProneWrapper( 1.0 );
}
noteTrackGunHand( note, flagName )
{
if ( isSubStr( note, "left" ) )
{
animscripts\shared::placeWeaponOn( self.weapon, "left" );
self notify( "weapon_switch_done" );
}
else if ( isSubStr( note, "right" ) )
{
animscripts\shared::placeWeaponOn( self.weapon, "right" );
self notify( "weapon_switch_done" );
}
else if ( isSubStr( note, "none" ) )
{
animscripts\shared::placeWeaponOn( self.weapon, "none" );
}
}
noteTrackGunDrop( note, flagName )
{
self DropAIWeapon();
self.lastWeapon = self.weapon;
}
noteTrackGunToChest( note, flagName )
{
animscripts\shared::placeWeaponOn( self.weapon, "chest" );
}
noteTrackGunToBack( note, flagName )
{
animscripts\shared::placeWeaponOn( self.weapon, "back" );
self.weapon = self getPreferredWeapon();
self.bulletsInClip = weaponClipSize( self.weapon );
}
noteTrackPistolPickup( note, flagName )
{
animscripts\shared::placeWeaponOn( self.sidearm, "right" );
self.bulletsInClip = weaponClipSize( self.weapon );
self notify( "weapon_switch_done" );
}
noteTrackPistolPutaway( note, flagName )
{
animscripts\shared::placeWeaponOn( self.weapon, "none" );
self.weapon = self getPreferredWeapon();
self.bulletsInClip = weaponClipSize( self.weapon );
}
noteTrackDropClip( note, flagName )
{
self thread handleDropClip( flagName );
}
noteTrackRefillClip( note, flagName )
{
if ( weaponClass( self.weapon ) == "rocketlauncher" )
self showRocket();
self animscripts\weaponList::RefillClip();
self.a.needsToRechamber = 0;
}
noteTrackLoadShell( note, flagName )
{
self playSound( "weap_reload_shotgun_loop_npc" );
}
noteTrackPistolRechamber( note, flagName )
{
self playSound( "weap_reload_pistol_chamber_npc" );
}
noteTrackGravity( note, flagName )
{
if ( isSubStr( note, "on" ) )
self animMode( "gravity" );
else if ( isSubStr( note, "off" ) )
self animMode( "nogravity" );
}
noteTrackFootStep( note, flagName )
{
is_left = IsSubStr( note, "left" );
is_large = IsSubStr( note, "large" );
playFootStep( is_left, is_large );
run_type = get_notetrack_movement();
self PlaySound( "gear_rattle" + "_" + run_type );
}
get_notetrack_movement()
{
run_type = "run";
if ( IsDefined( self.sprint ) )
{
run_type = "sprint";
}
if ( IsDefined( self.a ) )
{
if ( IsDefined( self.a.movement ) )
{
if ( self.a.movement == "walk" )
{
run_type = "walk";
}
}
if ( IsDefined( self.a.pose ) )
{
if ( self.a.pose == "prone" )
{
run_type = "prone";
}
}
}
return run_type;
}
customNotetrackFX( note, flagName )
{
assert( isdefined( level._notetrackFX[ note ] ) );
if ( isDefined( self.groundType ) )
groundType = self.groundType;
else
groundType = "dirt";
fxStruct = undefined;
if ( isdefined( level._notetrackFX[ note ][ groundType ] ) )
fxStruct = level._notetrackFX[ note ][ groundType ];
else if ( isdefined( level._notetrackFX[ note ][ "all" ] ) )
fxStruct = level._notetrackFX[ note ][ "all" ];
if ( !isdefined( fxStruct ) )
return;
if ( isAI( self ) )
playFXOnTag( fxStruct.fx, self, fxStruct.tag );
if ( !isdefined( fxStruct.sound_prefix ) && !isdefined( fxStruct.sound_suffix ) )
return;
soundAlias = "" + fxStruct.sound_prefix + groundType + fxStruct.sound_suffix;
self playsound( soundAlias );
}
noteTrackFootScrape( note, flagName )
{
if ( isDefined( self.groundType ) )
groundType = self.groundType;
else
groundType = "dirt";
self playsound( "step_scrape_" + groundType );
}
noteTrackLand( note, flagName )
{
if ( isDefined( self.groundType ) )
groundType = self.groundType;
else
groundType = "dirt";
self playsound( "land_" + groundType );
}
noteTrackCodeMove( note, flagName )
{
return "code_move";
}
noteTrackFaceEnemy( note, flagName )
{
if ( self.script != "reactions" )
{
self orientmode( "face enemy" );
}
else
{
if ( isdefined( self.enemy ) && distanceSquared( self.enemy.origin, self.reactionTargetPos ) < 64 * 64 )
self orientmode( "face enemy" );
else
self orientmode( "face point", self.reactionTargetPos );
}
}
noteTrackBodyFall( note, flagName )
{
suffix = "_small";
if ( IsSubStr( note, "large" ) )
{
suffix = "_large";
}
if ( isDefined( self.groundType ) )
{
groundType = self.groundType;
}
else
{
groundType = "dirt";
}
self PlaySound( "bodyfall_" + groundType + suffix );
}
HandleNoteTrack( note, flagName, customFunction )
{
if ( isAI( self ) && self.type == "dog" )
if ( HandleDogSoundNoteTracks( note ) )
return;
notetrackFunc = anim.notetracks[ note ];
if ( isDefined( notetrackFunc ) )
{
return [[ notetrackFunc ]]( note, flagName );
}
switch( note )
{
case "end":
case "finish":
case "undefined":
return note;
case "finish early":
if ( isdefined( self.enemy ) )
return note;
break;
case "swish small":
self thread play_sound_in_space( "melee_swing_small", self gettagorigin( "TAG_WEAPON_RIGHT" ) );
break;
case "swish large":
self thread play_sound_in_space( "melee_swing_large", self gettagorigin( "TAG_WEAPON_RIGHT" ) );
break;
case "rechamber":
if ( weapon_pump_action_shotgun() )
self playSound( "weap_reload_shotgun_pump_npc" );
self.a.needsToRechamber = 0;
break;
case "no death":
self.a.nodeath = true;
break;
case "no pain":
self.allowpain = false;
break;
case "allow pain":
self.allowpain = true;
break;
case "anim_melee = right":
case "anim_melee = \"right\"":
self.a.meleeState = "right";
break;
case "anim_melee = left":
case "anim_melee = \"left\"":
self.a.meleeState = "left";
break;
case "swap taghelmet to tagleft":
if ( isDefined( self.hatModel ) )
{
if ( isdefined( self.helmetSideModel ) )
{
self detach( self.helmetSideModel, "TAG_HELMETSIDE" );
self.helmetSideModel = undefined;
}
self detach( self.hatModel, "" );
self attach( self.hatModel, "TAG_WEAPON_LEFT" );
self.hatModel = undefined;
}
break;
case "stop anim":
anim_stopanimscripted();
return note;
case "break glass":
level notify( "glass_break", self );
break;
case "break_glass":
level notify( "glass_break", self );
break;
default:
if ( isDefined( customFunction ) )
return [[ customFunction ]]( note );
break;
}
}
DoNoteTracksIntercept( flagName, interceptFunction, debugIdentifier )
{
assert( isDefined( interceptFunction ) );
for ( ;; )
{
self waittill( flagName, note );
if ( !isDefined( note ) )
note = "undefined";
intercepted = [[ interceptFunction ]]( note );
if ( isDefined( intercepted ) && intercepted )
continue;
val = self HandleNoteTrack( note, flagName );
if ( isDefined( val ) )
return val;
}
}
DoNoteTracksPostCallback( flagName, postFunction )
{
assert( isDefined( postFunction ) );
for ( ;; )
{
self waittill( flagName, note );
if ( !isDefined( note ) )
note = "undefined";
val = self HandleNoteTrack( note, flagName );
[[ postFunction ]]( note );
if ( isDefined( val ) )
return val;
}
}
DoNoteTracksForTimeout( flagName, killString, customFunction, debugIdentifier )
{
DoNoteTracks( flagName, customFunction, debugIdentifier );
}
DoNoteTracksForever( flagName, killString, customFunction, debugIdentifier )
{
DoNoteTracksForeverProc( ::DoNoteTracks, flagName, killString, customFunction, debugIdentifier );
}
DoNoteTracksForeverIntercept( flagName, killString, interceptFunction, debugIdentifier )
{
DoNoteTracksForeverProc( ::DoNoteTracksIntercept, flagName, killString, interceptFunction, debugIdentifier );
}
DoNoteTracksForeverProc( notetracksFunc, flagName, killString, customFunction, debugIdentifier )
{
if ( isdefined( killString ) )
self endon( killString );
self endon( "killanimscript" );
if ( !isDefined( debugIdentifier ) )
debugIdentifier = "undefined";
for ( ;; )
{
time = GetTime();
returnedNote = [[ notetracksFunc ]]( flagName, customFunction, debugIdentifier );
timetaken = GetTime() - time;
if ( timetaken < 0.05 )
{
time = GetTime();
returnedNote = [[ notetracksFunc ]]( flagName, customFunction, debugIdentifier );
timetaken = GetTime() - time;
if ( timetaken < 0.05 )
{
println( GetTime() + " " + debugIdentifier + " animscripts\shared::DoNoteTracksForever is trying to cause an infinite loop on anim " + flagName + ", returned " + returnedNote + "." );
wait( 0.05 - timetaken );
}
}
}
}
DoNoteTracksWithTimeout( flagName, time, customFunction, debugIdentifier )
{
ent = spawnstruct();
ent thread doNoteTracksForTimeEndNotify( time );
DoNoteTracksForTimeProc( ::DoNoteTracksForTimeout, flagName, customFunction, debugIdentifier, ent );
}
DoNoteTracksForTime( time, flagName, customFunction, debugIdentifier )
{
ent = spawnstruct();
ent thread doNoteTracksForTimeEndNotify( time );
DoNoteTracksForTimeProc( ::DoNoteTracksForever, flagName, customFunction, debugIdentifier, ent );
}
DoNoteTracksForTimeIntercept( time, flagName, interceptFunction, debugIdentifier )
{
ent = spawnstruct();
ent thread doNoteTracksForTimeEndNotify( time );
DoNoteTracksForTimeProc( ::DoNoteTracksForeverIntercept, flagName, interceptFunction, debugIdentifier, ent );
}
DoNoteTracksForTimeProc( doNoteTracksForeverFunc, flagName, customFunction, debugIdentifier, ent )
{
ent endon( "stop_notetracks" );
[[ doNoteTracksForeverFunc ]]( flagName, undefined, customFunction, debugIdentifier );
}
doNoteTracksForTimeEndNotify( time )
{
wait( time );
self notify( "stop_notetracks" );
}
playFootStep( is_left, is_large )
{
if ( ! isAI( self ) )
{
self playsound( "step_run_dirt" );
return;
}
groundType = undefined;
if ( !isdefined( self.groundtype ) )
{
if ( !isdefined( self.lastGroundtype ) )
{
self playsound( "step_run_dirt" );
return;
}
groundtype = self.lastGroundtype;
}
else
{
groundtype = self.groundtype;
self.lastGroundtype = self.groundType;
}
foot = "J_Ball_RI";
if ( is_left )
{
foot = "J_Ball_LE";
}
run_type = get_notetrack_movement();
self playsound( "step_" + run_type + "_" + groundType );
if ( is_large )
{
if ( ![[ anim.optionalStepEffectFunction ]]( foot, groundType ) )
{
playFootStepEffectSmall( foot, groundType );
}
}
else
{
if ( ![[ anim.optionalStepEffectSmallFunction ]]( foot, groundType ) )
{
playFootStepEffect( foot, groundType );
}
}
}
playFootStepEffect( foot, groundType )
{
for ( i = 0;i < anim.optionalStepEffects.size;i++ )
{
if ( groundType != anim.optionalStepEffects[ i ] )
continue;
org = self gettagorigin( foot );
angles = self.angles;
forward = anglestoforward( angles );
back = forward * - 1;
up = anglestoup( angles );
playfx( level._effect[ "step_" + anim.optionalStepEffects[ i ] ], org, up, back );
return true;
}
return false;
}
playFootStepEffectSmall( foot, groundType )
{
for ( i = 0;i < anim.optionalStepEffectsSmall.size;i++ )
{
if ( groundType != anim.optionalStepEffectsSmall[ i ] )
continue;
org = self gettagorigin( foot );
angles = self.angles;
forward = anglestoforward( angles );
back = forward * - 1;
up = anglestoup( angles );
playfx( level._effect[ "step_small_" + anim.optionalStepEffectsSmall[ i ] ], org, up, back );
return true;
}
return false;
}
shootNotetrack()
{
waittillframeend;
if ( isdefined( self ) && gettime() > self.a.lastShootTime )
{
self shootEnemyWrapper();
self decrementBulletsInClip();
if ( weaponClass( self.weapon ) == "rocketlauncher" )
self.a.rockets -- ;
}
}
fire_straight()
{
if ( self.a.weaponPos[ "right" ] == "none" )
return;
if ( isdefined( self.dontShootStraight ) )
{
shootNotetrack();
return;
}
weaporig = self gettagorigin( "tag_weapon" );
dir = anglestoforward( self getMuzzleAngle() );
pos = weaporig + ( dir * 1000 );
self shoot( 1, pos );
self decrementBulletsInClip();
}
noteTrackFireSpray( note, flagName )
{
if ( !isalive( self ) && self isBadGuy() )
{
if ( isdefined( self.changed_team ) )
return;
self.changed_team = true;
teams[ "axis" ] = "team3";
teams[ "team3" ] = "axis";
assertex( isdefined( teams[ self.team ] ), "no team for " + self.team );
self.team = teams[ self.team ];
}
if ( !issentient( self ) )
{
self notify( "fire" );
return;
}
if ( self.a.weaponPos[ "right" ] == "none" )
return;
weaporig = self getMuzzlePos();
dir = anglestoforward( self getMuzzleAngle() );
ang = 10;
if ( isdefined( self.isRambo ) )
ang = 20;
hitenemy = false;
if ( isalive( self.enemy ) && issentient( self.enemy ) && self canShootEnemy() )
{
enemydir = vectornormalize( self.enemy geteye() - weaporig );
if ( vectordot( dir, enemydir ) > cos( ang ) )
{
hitenemy = true;
}
}
if ( hitenemy )
{
self shootEnemyWrapper();
}
else
{
dir += ( ( randomfloat( 2 ) - 1 ) * .1, ( randomfloat( 2 ) - 1 ) * .1, ( randomfloat( 2 ) - 1 ) * .1 );
pos = weaporig + ( dir * 1000 );
self shootPosWrapper( pos );
}
self decrementBulletsInClip();
}

