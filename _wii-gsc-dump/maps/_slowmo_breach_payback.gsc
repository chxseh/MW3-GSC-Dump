#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
slowmo_breach_init()
{
level.last_player_damage = 0;
level.slomobreachduration = 3.5;
level.breachEnemies_active = 0;
level.breachignoreEnemy_count = false;
level.breachEnemies_alive = 0;
level.has_special_breach_anim = [];
level.breach_passive_time = 0;
SoundSetTimeScaleFactor( "Music", 0 );
SoundSetTimeScaleFactor( "Menu", 0 );
SoundSetTimeScaleFactor( "local3", 0.0 );
SoundSetTimeScaleFactor( "Mission", 0.0 );
SoundSetTimeScaleFactor( "Announcer", 0.0 );
SoundSetTimeScaleFactor( "Bulletimpact", .60 );
SoundSetTimeScaleFactor( "Voice", 0.40 );
SoundSetTimeScaleFactor( "effects2", 0.20 );
SoundSetTimeScaleFactor( "local", 0.40 );
SoundSetTimeScaleFactor( "physics", 0.20 );
SoundSetTimeScaleFactor( "ambient", 0.50 );
SoundSetTimeScaleFactor( "auto", 0.50 );
SetDvarIfUninitialized( "breach_debug", "0" );
PreCacheItem( "usp_scripted" );
PreCacheShader( "breach_icon" );
precacheString( &"SCRIPT_WAYPOINT_BREACH" );
precacheString( &"SCRIPT_PLATFORM_BREACH_ACTIVATE" );
precacheString( &"SCRIPT_BREACH_NEED_PLAYER" );
precacheString( &"SCRIPT_BREACH_TOO_MANY_ENEMIES" );
precacheString( &"SCRIPT_BREACH_ILLEGAL_WEAPON" );
precacheString( &"SCRIPT_BREACH_YOU_NOT_READY" );
precacheString( &"SCRIPT_BREACH_RELOADING" );
level._slowmo_functions = [];
level._effect[ "breach_door" ] = LoadFX( "explosions/breach_door" );
level._effect[ "breach_room" ] = LoadFX( "explosions/breach_room_payback" );
level._effect[ "breach_room_residual" ] = LoadFX( "explosions/breach_room_residual" );
player_animations();
create_slowmo_breaches_from_entities();
icon_triggers = GetEntArray( "trigger_multiple_breachIcon", "classname" );
array_thread( icon_triggers, ::icon_trigger_setup );
breach_deletables = GetEntArray( "breach_solid_delete", "targetname" );
array_call( breach_deletables, ::ConnectPaths );
array_thread( breach_deletables, ::self_delete );
breach_deletables = GetEntArray( "breach_delete", "targetname" );
array_thread( breach_deletables, ::self_delete );
breach_fx = GetEntArray( "breach_fx", "targetname" );
array_thread( breach_fx, ::breach_fx_setup );
level.has_special_breach_anim[ "ak47" ] = true;
level.has_special_breach_anim[ "ak47_acog" ] = true;
level.has_special_breach_anim[ "ak47_reflex" ] = true;
level.has_special_breach_anim[ "ak47_grenadier" ] = true;
level.has_special_breach_anim[ "alt_ak47_grenadier" ] = true;
level.has_special_breach_anim[ "deserteagle" ] = true;
level.has_special_breach_anim[ "dragunov" ] = true;
level.has_special_breach_anim[ "m4_grunt" ] = true;
level.has_special_breach_anim[ "m4m203_acog" ] = true;
level.has_special_breach_anim[ "alt_m4m203_acog" ] = true;
level.has_special_breach_anim[ "alt_m4m203_acog_payback" ] = true;
level.has_special_breach_anim[ "m4m203_acog_payback" ] = true;
level.has_special_breach_anim[ "m4_grenadier" ] = true;
level.has_special_breach_anim[ "alt_m4_grenadier" ] = true;
level.has_special_breach_anim[ "pecheneg" ] = true;
level.has_special_breach_anim[ "pecheneg_acog" ] = true;
level.has_special_breach_anim[ "pecheneg_reflex" ] = true;
level.has_special_breach_anim[ "rpd_acog" ] = true;
level.has_special_breach_anim[ "rpd_reflex" ] = true;
level.has_special_breach_anim[ "rpg_player" ] = true;
level.has_special_breach_anim[ "striker" ] = true;
level.has_special_breach_anim[ "usp" ] = true;
level.has_special_breach_anim[ "uzi" ] = true;
level.has_special_breach_anim[ "pp90m1" ] = true;
level.has_special_breach_anim[ "pp90m1_reflex" ] = true;
flag_init( "breaching_on" );
flag_init( "no_mercy" );
}
breach_fx_setup()
{
fxid = self.script_fxid;
index = self.script_slowmo_breach;
ent = createExploder( fxid );
ent.v[ "origin" ] = self.origin;
ent.v[ "angles" ] = self.angles;
ent.v[ "fxid" ] = fxid;
ent.v[ "delay" ] = 0;
ent.v[ "exploder" ] = "breach_" + index;
ent.v[ "soundalias" ] = "nil";
}
create_slowmo_breaches_from_entities()
{
breaches = [];
left_door_posts = GetEntArray( "breach_left_org", "targetname" );
right_door_posts = GetEntArray( "breach_right_org", "targetname" );
breach_enemy_spawners = GetEntArray( "breach_enemy_spawner", "targetname" );
breach_path_solids = GetEntArray( "breach_solid", "targetname" );
breach_door_volumes = GetEntArray( "breach_door_volume", "targetname" );
breach_triggers = GetEntArray( "trigger_use_breach", "classname" );
breach_lookat_triggers = GetEntArray( "trigger_multiple_breachIcon", "classname" );
breach_start_triggers = GetEntArray( "trigger_use_breach", "classname" );
foreach ( post in left_door_posts )
{
index = post.script_slowmo_breach;
doorType = "wood";
if ( IsDefined( post.script_slowmo_breach_doortype ) )
{
switch( post.script_slowmo_breach_doortype )
{
case "payback_wood":
case "none":
doorType = post.script_slowmo_breach_doortype;
break;
default:
}
}
ent = SpawnStruct();
ent.left_post = post;
ent.doorType = doorType;
ent.spawners = [];
ent.spawners[ "enemy" ] = [];
ent.spawners[ "friendlyenemy" ] = [];
ent.lookat_triggers = [];
ent.path_solids = [];
ent.enabled = true;
ent.door_volume = [];
ent.room_volume = [];
ent.safe_volume = undefined;
ent.friendly_anim_ent = [];
breaches[ index ] = ent;
}
foreach ( post in right_door_posts )
{
index = post.script_slowmo_breach;
breaches[ index ].right_post = post;
anim_org = Spawn( "script_origin", post.origin );
anim_org.angles = post.angles;
ent = SpawnStruct();
ent.entity = anim_org;
ent.yaw = -90;
ent translate_local();
breaches[ index ].friendly_anim_ent = anim_org;
}
foreach ( spawner in breach_enemy_spawners )
{
breaches = spawner breach_spawner_setup( breaches, "enemy" );
}
foreach ( trigger in breach_lookat_triggers )
{
index = trigger.script_slowmo_breach;
breaches[ index ].lookat_triggers[ breaches[ index ].lookat_triggers.size ] = trigger;
trigger_org = GetEnt( trigger.target, "targetname" );
trigger.breach_origin = trigger_org.origin;
room_volume = GetEnt( trigger_org.target, "targetname" );
room_volume.breached = false;
breaches[ index ].room_volume = room_volume;
trigger_org thread breach_icon_think( trigger, index, room_volume );
sFlagname = room_volume.script_flag;
flag_init( sFlagname );
}
foreach ( trigger in breach_start_triggers )
{
trigger UseTriggerRequireLookAt();
index = trigger.script_slowmo_breach;
breaches[ index ].trigger = trigger;
if ( IsDefined( trigger.script_breachgroup ) )
trigger thread breach_group_trigger_think();
}
foreach ( volume in breach_door_volumes )
{
index = volume.script_slowmo_breach;
breaches[ index ].door_volume = volume;
}
foreach ( pathSolid in breach_path_solids )
{
index = pathSolid.script_slowmo_breach;
breaches[ index ].path_solids[ breaches[ index ].path_solids.size ] = pathSolid;
}
foreach ( index, breach in breaches )
{
level thread slowmo_breach_think( breach, index );
}
level.breach_groups = breaches;
}
icon_trigger_setup()
{
self.script_flag = "breach_door_icon_" + self.script_slowmo_breach;
level thread maps\_load::trigger_looking( self );
}
breach_icon_think( trigger, index, room_volume )
{
icon = NewHudElem();
icon SetShader( "breach_icon", 1, 1 );
icon.alpha = 0;
icon.color = ( 1, 1, 1 );
icon.x = self.origin[ 0 ];
icon.y = self.origin[ 1 ];
icon.z = self.origin[ 2 ];
icon SetWayPoint( true, true );
model = Spawn( "script_model", self.origin );
model SetModel( "mil_frame_charge" );
model HidePart( "j_frame_charge" );
wait( 0.05 );
sFlag = "breach_door_icon_" + index;
flag_wait( sFlag );
wait( 0.05 );
while ( !room_volume.breached )
{
wait( 0.05 );
}
icon Destroy();
model Delete();
}
breach_spawner_setup( breaches, type )
{
index = self.script_slowmo_breach;
group = 0;
if ( !isdefined( breaches[ index ].spawners[ type ][ group ] ) )
breaches[ index ].spawners[ type ][ group ] = [];
array = breaches[ index ].spawners[ type ][ group ];
array[ array.size ] = self;
breaches[ index ].spawners[ type ][ group ] = array;
if ( breaches.size )
return breaches;
else
return undefined;
}
slowmo_breach_think( breach_array, breach_index )
{
left_door_post = breach_array.left_post;
right_door_post = breach_array.right_post;
breach_enemy_spawners = breach_array.spawners[ "enemy" ];
trigger = breach_array.trigger;
solids = breach_array.path_solids;
door_volume = breach_array.door_volume;
room_volume = breach_array.room_volume;
breach_friendlyenemy_spawners = [];
if ( IsDefined( breach_array.spawners[ "friendlyenemy" ][ 0 ] ) )
{
breach_friendlyenemy_spawners = breach_array.spawners[ "friendlyenemy" ][ 0 ];
breach_array.spawners[ "friendlyenemy" ] = breach_friendlyenemy_spawners;
}
ent = SpawnStruct();
ent.entity = left_door_post;
ent.forward = 5;
ent.right = 6;
ent.yaw = -90;
ent translate_local();
ent = SpawnStruct();
ent.entity = right_door_post;
ent.right = -2;
ent.yaw = 90;
ent translate_local();
keys = [];
foreach ( index, spawner in breach_enemy_spawners )
{
keys[ index ] = index;
}
if ( keys.size )
{
random_key = random( keys );
if ( IsDefined( breach_enemy_spawners[ random_key ] ) )
breach_enemy_spawners = breach_enemy_spawners[ random_key ];
else
breach_enemy_spawners = [];
}
breach_array.spawners[ "enemy" ] = breach_enemy_spawners;
array_thread( breach_enemy_spawners, ::add_spawn_function, ::breach_enemy_spawner_think );
array_thread( breach_friendlyenemy_spawners, ::add_spawn_function, ::breach_enemy_spawner_think );
trigger SetHintString( &"SCRIPT_PLATFORM_BREACH_ACTIVATE" );
if ( !isdefined( level.breach_use_triggers ) )
level.breach_use_triggers = [];
level.breach_use_triggers = array_add( level.breach_use_triggers, trigger );
chargeAnimModel = "breach_door_charge";
doorAnimModel = undefined;
switch( breach_array.doorType )
{
case "payback_wood":
doorAnimModel = "breach_door_model_payback";
chargeAnimModel = "breach_door_charge_payback";
break;
default:
break;
}
door = spawn_anim_model( doorAnimModel );
if ( breach_array.doorType == "none" || breach_array.doorType == "estate_wood_backwards" )
door Hide();
level.breach_doors = [];
level.breach_doors[ breach_index ] = door;
charge = spawn_anim_model( chargeAnimModel );
charge hide_notsolid();
left_door_post.scene_models = [];
left_door_post add_scene_model( "active_breacher_rig" );
active_breacher_rig = left_door_post.scene_models[ "active_breacher_rig" ];
active_breacher_rig Hide();
passive_breacher_rig = undefined;
left_door_post.door = door;
left_door_post.charge = charge;
left_door_post.post = right_door_post;
left_door_post.breach_index = breach_index;
left_door_post anim_first_frame_solo( door, "breach" );
left_door_post anim_first_frame_solo( charge, "breach" );
left_door_post anim_first_frame_solo( active_breacher_rig, "breach_player_anim" );
left_door_post wait_for_breach_or_deletion( breach_array );
foreach ( model in left_door_post.scene_models )
model Delete();
if ( IsDefined( trigger ) )
trigger Delete();
if ( IsDefined( door ) )
door Delete();
if ( IsDefined( charge ) )
charge Delete();
if ( IsDefined( left_door_post ) )
left_door_post Delete();
if ( IsDefined( right_door_post ) )
right_door_post Delete();
}
breach_should_be_skipped( script_slowmo_breach )
{
if ( !isdefined( level.skip_breach ) )
return false;
if ( !isdefined( level.skip_breach[ script_slowmo_breach ] ) )
return false;
return true;
}
wait_for_breach_or_deletion( ent )
{
trigger = ent.trigger;
if ( !isdefined( trigger ) )
{
return;
}
door_volume = ent.door_volume;
trigger endon( "death" );
for ( ;; )
{
trigger waittill( "trigger", other, passive );
if ( gettime() == level.breach_passive_time )
passive = level.breach_passive_player;
is_passive = isdefined( passive );
if ( !ent.enabled )
return;
if ( isalive( other ) && !is_passive )
{
if ( breach_failed_to_start() )
continue;
}
if ( ( IsDefined( ent.safe_volume ) ) )
{
if ( IsPlayer( other ) && IsAlive( other ) )
{
enemies = ent.safe_volume get_ai_touching_volume( "axis" );
if ( enemies.size )
{
thread breach_too_many_enemies_hint();
continue;
}
}
}
if ( IsPlayer( other ) && IsAlive( other ) )
{
if ( breach_should_be_skipped( trigger.script_slowmo_breach ) )
break;
if ( player_breach( ent, other ) )
break;
}
}
}
breach_too_many_enemies_hint()
{
thread breach_hint_create( &"SCRIPT_BREACH_TOO_MANY_ENEMIES" );
}
breach_reloading_hint()
{
thread breach_hint_create( &"SCRIPT_BREACH_RELOADING" );
}
breach_bad_weapon_hint()
{
thread breach_hint_create( &"SCRIPT_BREACH_ILLEGAL_WEAPON" );
}
breach_not_ready_hint()
{
thread breach_hint_create( &"SCRIPT_BREACH_YOU_NOT_READY" );
}
breach_hint_create( message )
{
level notify( "breach_hint_cleanup" );
level endon( "breach_hint_cleanup" );
hint_offset = 20;
if ( issplitscreen() )
hint_offset = -23;
thread hint( message, 3, hint_offset );
thread breach_hint_cleanup();
}
breach_hint_cleanup()
{
level notify( "breach_hint_cleanup" );
level endon( "breach_hint_cleanup" );
foreach ( trigger in level.breach_use_triggers )
{
if ( isdefined( trigger ) )
trigger SetHintString( "" );
}
level waittill_notify_or_timeout( "breaching", 3 );
hint_fade();
foreach ( trigger in level.breach_use_triggers )
{
if ( isdefined( trigger ) )
trigger SetHintString( &"SCRIPT_PLATFORM_BREACH_ACTIVATE" );
}
}
add_scene_model( animname )
{
self.scene_models[ animname ] = spawn_anim_model( animname );
self.scene_models[ animname ] Hide();
}
set_room_to_breached( trigger, room_volume )
{
room_volume.breached = true;
breach_notify = get_breach_notify( trigger.script_breachgroup );
if ( IsDefined( trigger.script_breachgroup ) )
level notify( breach_notify );
room_volume notify( "breached" );
trigger trigger_off();
}
player_breach( ent, player )
{
breach_players = [];
breach_players[ "active" ] = player;
active_breacher_rig = self.scene_models[ "active_breacher_rig" ];
passive_breacher_rig = undefined;
breach_players[ "active" ] EnableBreaching();
foreach ( player in breach_players )
{
if ( !isdefined( level.slowmo_breach_disable_stancemod ) )
{
player EnableInvulnerability();
player DisableWeaponSwitch();
player DisableOffhandWeapons();
player AllowCrouch( false );
player AllowProne( false );
player AllowSprint( false );
player AllowJump( false );
}
player _disableUsability();
if ( !isdefined( player.prebreachCurrentWeapon ) )
player.prebreachCurrentWeapon = player GetCurrentWeapon();
}
level notify( "breaching" );
level notify( "breaching_number_" + self.script_slowmo_breach );
setsaveddvar( "objectiveHide", true );
room_volume = ent.room_volume;
set_room_to_breached( ent.trigger, room_volume );
breach_sound_delay = undefined;
is_special_breach = IsDefined( level.has_special_breach_anim[ breach_players[ "active" ].prebreachCurrentWeapon ] );
if ( is_special_breach )
{
level.slowmo_breach_start_delay = 2.25;
set_door_charge_anim_special();
breach_sound_delay = 0.5;
}
else
{
level.slowmo_breach_start_delay = 2.15;
set_door_charge_anim_normal();
breach_sound_delay = 0.20;
}
breach_players[ "active" ] thread play_detpack_plant_sound( breach_sound_delay );
level.breachEnemies_alive = 0;
level.breachEnemies_active = 0;
breach_enemy_spawners = ent.spawners[ "enemy" ];
array_call( breach_enemy_spawners, ::StalingradSpawn );
breach_players[ "active" ] PlayerLinkToBlend( active_breacher_rig, "tag_player", 0.2, 0.1, 0.1 );
if ( IsDefined( breach_players[ "active" ].dont_unlink_after_breach ) )
thread open_up_fov( 0.2, active_breacher_rig, "tag_player", 45, 45, 90, 45 );
breach_players[ "active" ] thread take_prebreach_weapons();
if ( !is_special_breach )
wait( 0.05 );
charge = self.charge;
self thread anim_single_solo( charge, "breach" );
charge show();
breach_players[ "active" ] thread restore_prebreach_weapons();
self anim_single_solo( active_breacher_rig, "breach_player_anim" );
level notify( "sp_slowmo_breachanim_done" );
thread flag_set_when_room_cleared( room_volume );
solids = ent.path_solids;
array_call( solids, ::ConnectPaths );
array_thread( solids, ::self_delete );
foreach ( player in breach_players )
{
player Unlink();
player Show();
}
breach_players[ "active" ] DisableBreaching();
foreach ( player in breach_players )
{
if ( !isdefined( level.slowmo_breach_disable_stancemod ) )
{
player DisableInvulnerability();
player EnableWeaponSwitch();
player EnableOffhandWeapons();
player AllowCrouch( true );
player AllowProne( true );
player AllowSprint( true );
player AllowJump( true );
}
player _enableUsability();
}
return true;
}
play_detpack_plant_sound( breach_sound_delay )
{
self endon( "death" );
wait( breach_sound_delay );
self playsound( "detpack_wall_plant" );
}
flag_set_when_room_cleared( room_volume )
{
sFlagName = room_volume.script_flag;
level endon( sFlagName );
aEnemies = room_volume get_ai_touching_volume( "bad_guys" );
waittill_dead( aEnemies );
level notify( "breach_room_has_been_cleared" );
level.breachenemies = undefined;
flag_set( sFlagName );
}
take_prebreach_weapons()
{
self GiveWeapon( "usp_scripted" );
self SwitchToWeaponImmediate( "usp_scripted" );
if ( IsDefined( level.has_special_breach_anim[ self.prebreachCurrentWeapon ] ) )
self SwitchToWeaponImmediate( self.prebreachCurrentWeapon );
}
restore_prebreach_weapons()
{
wait( 0.5 );
self TakeWeapon( "usp_scripted" );
if ( IsDefined( self.prebreachCurrentWeapon ) )
{
weapon = self.prebreachCurrentWeapon;
self SwitchToWeapon( weapon );
if ( self should_topoff_breach_weapon( weapon ) )
{
clipSize = WeaponClipSize( weapon );
if ( self GetWeaponAmmoClip( weapon ) < clipSize )
self SetWeaponAmmoClip( weapon, clipSize );
}
self.prebreachCurrentWeapon = undefined;
}
}
should_topoff_breach_weapon( weapon )
{
if ( level.gameskill > 1 )
{
return false;
}
if ( !IsDefined( self.prebreachCurrentWeapon ) )
{
return false;
}
if ( weapon != self.prebreachCurrentWeapon )
{
return false;
}
return true;
}
get_breach_notify( script_breachgroup )
{
if ( !isdefined( script_breachgroup ) )
script_breachgroup = "none";
return "A door in breach group " + script_breachgroup + " has been activated.";
}
breach_group_trigger_think()
{
sBreachGroup = self.script_breachgroup;
breach_notify = get_breach_notify( sBreachGroup );
level waittill( breach_notify );
waittillframeend;
self notify( "trigger" );
}
slowmo_player_cleanup()
{
if ( IsDefined( level.playerSpeed ) )
self SetMoveSpeedScale( level.playerSpeed );
else
self SetMoveSpeedScale( 1 );
}
slowmo_begins( rig )
{
if ( ( IsDefined( level.breaching ) ) && ( level.breaching == true ) )
{
return;
}
level.breaching = true;
flag_set( "breaching_on" );
level notify( "slowmo_go" );
level endon( "slowmo_go" );
slomoLerpTime_in = 0.5;
slomoLerpTime_out = 0.75;
slomobreachplayerspeed = 0.2;
if ( IsDefined( level.slomobreachplayerspeed ) )
{
slomobreachplayerspeed = level.slomobreachplayerspeed;
}
player = level.player;
player thread play_sound_on_entity( "slomo_whoosh" );
player thread player_heartbeat();
thread slomo_breach_vision_change( ( slomoLerpTime_in * 2 ), ( slomoLerpTime_out / 2 ) );
thread slomo_difficulty_dvars();
flag_clear( "can_save" );
slowmo_start();
player thread set_breaching_variable();
player AllowMelee( false );
slowmo_setspeed_slow( 0.25 );
slowmo_setlerptime_in( slomoLerpTime_in );
slowmo_lerp_in();
player SetMoveSpeedScale( slomobreachplayerspeed );
startTime = GetTime();
endTime = startTime + ( level.slomobreachduration * 1000 );
player thread catch_weapon_switch();
player thread catch_mission_failed();
reloadIgnoreTime = 500;
switchWeaponIgnoreTime = 1000;
for ( ;; )
{
if ( IsDefined( level.forced_slowmo_breach_slowdown ) )
{
if ( !level.forced_slowmo_breach_slowdown )
{
if ( IsDefined( level.forced_slowmo_breach_lerpout ) )
slomoLerpTime_out = level.forced_slowmo_breach_lerpout;
break;
}
wait( 0.05 );
continue;
}
if ( GetTime() >= endTime )
break;
if ( (level.breachEnemies_active <= 0) && (level.breachignoreEnemy_count == false) )
{
slomoLerpTime_out = 1.15;
break;
}
if ( player.lastReloadStartTime >= ( startTime + reloadIgnoreTime ) )
{
break;
}
if ( player.switchedWeapons && ( ( GetTime() - startTime ) > switchWeaponIgnoreTime ) )
{
break;
}
if ( player.breach_missionfailed )
{
slomoLerpTime_out = 0.5;
break;
}
wait( 0.05 );
}
level notify( "slowmo_breach_ending", slomoLerpTime_out );
level notify( "stop_player_heartbeat" );
player thread play_sound_on_entity( "slomo_whoosh" );
slowmo_setlerptime_out( slomoLerpTime_out );
slowmo_lerp_out();
player AllowMelee( true );
player delaythread( slomoLerpTime_out, ::clear_breaching_variable );
slowmo_end();
flag_set( "can_save" );
player slowmo_player_cleanup();
level notify( "slomo_breach_over" );
level.breaching = false;
flag_clear( "breaching_on" );
setsaveddvar( "objectiveHide", false );
}
set_breaching_variable()
{
self endon( "clear_breaching_variable" );
self.isbreaching = 1;
self.breaching_shots_fired = 0;
self.achieve_slowmo_breach_kills = undefined;
ammo = self getcurrentweaponclipammo();
self notifyonPlayercommand( "player_shot_fired", "+attack" );
self notifyonPlayercommand( "player_shot_fired", "+attack_akimbo_accessible" );
while( isdefined( self.isbreaching ) )
{
self waittill( "player_shot_fired" );
self.breaching_shots_fired = ammo - self getcurrentweaponclipammo();
wait .05;
while( self isFiring() )
{
self.breaching_shots_fired = ammo - self getcurrentweaponclipammo();
wait .05;
}
}
}
clear_breaching_variable()
{
self.isbreaching = undefined;
self thread notify_delay( "clear_breaching_variable", .25 );
}
slomo_difficulty_dvars()
{
old_bg_viewKickScale = GetDvar( "bg_viewKickScale" );
old_bg_viewKickMax = GetDvar( "bg_viewKickMax" );
SetSavedDvar( "bg_viewKickScale", 0.3 );
SetSavedDvar( "bg_viewKickMax", "15" );
SetSavedDvar( "bullet_penetration_damage", 0 );
level waittill( "slowmo_breach_ending" );
SetSavedDvar( "bg_viewKickScale", old_bg_viewKickScale );
SetSavedDvar( "bg_viewKickMax", old_bg_viewKickMax );
wait( 2 );
SetSavedDvar( "bullet_penetration_damage", 1 );
}
slomo_breach_vision_change( lerpTime_in, lerpTime_out )
{
if ( !IsDefined( level.slomoBasevision ) )
{
return;
}
VisionSetNaked( "slomo_breach", lerpTime_in );
level waittill( "slowmo_breach_ending", newLerpTime );
if ( IsDefined( newLerpTime ) )
{
lerpTime_out = newLerpTime;
}
wait( 1 );
VisionSetNaked( level.slomoBasevision, lerpTime_out );
}
player_heartbeat()
{
level endon( "stop_player_heartbeat" );
while ( true )
{
self PlayLocalSound( "breathing_heartbeat" );
wait .5;
}
}
catch_weapon_switch()
{
level endon( "slowmo_breach_ending" );
self.switchedWeapons = false;
self waittill_any( "weapon_switch_started", "night_vision_on", "night_vision_off" );
self.switchedWeapons = true;
}
catch_mission_failed()
{
level endon( "slowmo_breach_ending" );
self.breach_missionfailed = false;
level waittill( "mission failed" );
self.breach_missionfailed = true;
}
breach_enemy_spawner_think()
{
reference = self.spawner;
self endon( "death" );
self add_damage_function( ::record_last_player_damage );
self thread breach_enemy_ignored_by_friendlies();
self thread breach_enemy_ragdoll_on_death();
level thread breach_enemy_track_status( self );
if ( IsDefined( self.script_parameters ) && string_starts_with( self.script_parameters , "reference" ) )
{
reference = GetEnt( self.script_parameters , "targetname" );
}
self.reference = reference;
reference anim_generic_first_frame( self, self.animation );
if ( IsDefined( level._slowmo_functions[ self.animation ] ) )
{
custom_function = level._slowmo_functions[ self.animation ];
self thread [[ custom_function ]]();
}
self.grenadeammo = 0;
self.allowdeath = true;
self.health = 10;
self.baseaccuracy = 5000;
if ( IsDefined( self.script_threatbias ) )
{
self.threatbias = self.script_threatbias;
}
wait( level.slowmo_breach_start_delay );
self script_delay();
self notify( "starting_breach_reaction" );
level notify( "breach_enemy_anims" );
reference anim_generic( self, self.animation );
self notify( "finished_breach_start_anim" );
}
record_last_player_damage( damage, attacker, direction_vec, point, type, modelName, tagName )
{
if ( !isalive( attacker ) )
return;
if ( !IsPlayer( attacker ) )
return;
if ( !self IsBadGuy() )
return;
level.last_player_damage = GetTime();
}
breach_enemy_ignored_by_friendlies()
{
self endon( "death" );
if ( !flag( "no_mercy" ) )
self.ignoreme = true;
level waittill_either( "slomo_breach_over", "friendlies_finished_breach" );
if ( IsDefined( self ) )
self.ignoreme = false;
}
breach_enemy_ragdoll_on_death()
{
self endon( "breach_enemy_cancel_ragdoll_death" );
self.ragdoll_immediate = true;
msg = self waittill_any_return( "death", "finished_breach_start_anim" );
if ( msg == "finished_breach_start_anim" )
{
self.ragdoll_immediate = undefined;
}
}
breach_enemy_cancel_ragdoll()
{
self notify( "breach_enemy_cancel_ragdoll_death" );
self.ragdoll_immediate = undefined;
}
breach_enemy_track_status( enemy )
{
level.breachEnemies_active++;
ent = SpawnStruct();
ent.enemy = enemy;
ent thread breach_enemy_waitfor_death( enemy );
ent thread breach_enemy_waitfor_death_counter( enemy );
ent thread breach_enemy_catch_exceptions( enemy );
ent thread breach_enemy_waitfor_breach_ending();
ent waittill( "breach_status_change", status );
level.breachEnemies_active--;
ent = undefined;
}
breach_enemy_waitfor_death( enemy )
{
self endon( "breach_status_change" );
enemy waittill( "death" );
self notify( "breach_status_change", "death" );
}
breach_enemy_waitfor_death_counter( enemy )
{
level.breachEnemies_alive++;
enemy waittill( "death" );
level.breachEnemies_alive--;
level notify( "breach_all_enemies_dead" );
}
breach_enemy_catch_exceptions( enemy )
{
self endon( "breach_status_change" );
while ( IsAlive( enemy ) )
{
wait( 0.05 );
}
self notify( "breach_status_change", "exception" );
}
breach_enemy_waitfor_breach_ending()
{
self endon( "breach_status_change" );
level waittill( "slowmo_breach_ending" );
self notify( "breach_status_change", "breach_ending" );
}
#using_animtree( "script_model" );
set_door_charge_anim_normal()
{
level.scr_anim[ "breach_door_charge" ][ "breach" ] = %breach_player_frame_charge_v3;
}
set_door_charge_anim_special()
{
level.scr_anim[ "breach_door_charge" ][ "breach" ] = %breach_player_frame_charge;
}
#using_animtree( "multiplayer" );
player_animations()
{
if ( !isdefined( level.slowmo_viewhands ) )
level.slowmo_viewhands = "viewhands_player_yuri";
level.scr_animtree[ "active_breacher_rig" ] = #animtree;
level.scr_model[ "active_breacher_rig" ] = level.slowmo_viewhands;
level.scr_anim[ "active_breacher_rig" ][ "breach_player_anim" ] = %breach_coop_player_1;
level._slowmo_breach_funcs = [];
add_breach_func( ::breach_explosion );
addNotetrack_customFunction( "active_breacher_rig", "explode", ::breach_functions );
addNotetrack_customFunction( "active_breacher_rig", "slowmo", ::slowmo_begins );
}
add_breach_func( func )
{
level._slowmo_breach_funcs[ level._slowmo_breach_funcs.size ] = func;
}
breach_functions( breach_rig )
{
foreach ( func in level._slowmo_breach_funcs )
{
thread [[ func ]]( breach_rig );
}
}
breach_explosion( breach_rig )
{
breach_array = level.breach_groups[ self.breach_index ];
expSound = undefined;
destroyedModelAlias = undefined;
switch( breach_array.doorType )
{
case "payback_wood":
expSound = "pybk_breach_blast";
destroyedModelAlias = "breach_door_hinge_payback";
break;
default:
break;
}
if ( IsDefined( expSound ) )
thread play_sound_in_space( expSound, self.charge.origin );
exploder( "breach_" + self.breach_index );
thread breach_rumble( self.charge.origin );
self.charge Delete();
level notify( "breach_explosion" );
if ( IsDefined( destroyedModelAlias ) )
{
destroyedModel = spawn_anim_model( destroyedModelAlias );
self.post thread anim_single_solo( destroyedModel, "breach" );
}
wait( 0.05 );
if ( IsDefined( self.door ) )
{
self.door Delete();
}
}
breach_rumble( org )
{
dummy = Spawn( "script_origin", org );
dummy.origin = org;
dummy PlayRumbleOnEntity( "grenade_rumble" );
wait( 4 );
dummy Delete();
}
breach_failed_to_start()
{
fail_funcs = [];
fail_funcs[ fail_funcs.size ] = ::isMeleeing;
fail_funcs[ fail_funcs.size ] = ::isSwitchingWeapon;
fail_funcs[ fail_funcs.size ] = ::IsThrowingGrenade;
foreach ( player in level.players )
{
if ( player IsReloading() )
{
thread breach_reloading_hint();
return true;
}
if ( player using_illegal_breach_weapon() )
{
thread breach_bad_weapon_hint();
return true;
}
foreach ( func in fail_funcs )
{
if ( player call [[ func ]]() )
{
thread breach_not_ready_hint();
return true;
}
}
}
return false;
}
using_illegal_breach_weapon()
{
illegal_weapons = [];
illegal_weapons[ "none" ] = true;
weapon = self getCurrentWeapon();
return isdefined( illegal_weapons[ weapon ] );
}