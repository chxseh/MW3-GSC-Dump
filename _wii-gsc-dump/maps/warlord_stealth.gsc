#include common_scripts\utility;
#include maps\_stealth_utility;
#include maps\_stealth_shared_utilities;
#include maps\_utility;
#include maps\warlord_utility;
warlord_stealth_init()
{
stealth_set_default_stealth_function( "warlord_stealth_function", ::stealth_warlord );
stealth_set_default_stealth_function( "infiltration_stealth_function", ::stealth_infiltration );
stealth_set_default_stealth_function( "technical_rider_stealth_function", ::stealth_technical_rider );
level.global_callbacks[ "_patrol_endon_spotted_flag" ] = ::_warlord_patrol_endon_spotted_flag;
stealth_manager = SpawnStruct();
thread populate_stealth_sets( stealth_manager );
level.stealth_manager = stealth_manager;
}
stealth_warlord()
{
self stealth_plugin_basic();
if ( isplayer( self ) )
{
self thread stealth_player_settings();
return;
}
switch( self.team )
{
case "axis":
case "team3":
self stealth_plugin_threat();
self stealth_pre_spotted_function_custom( ::river_prespotted_func );
custom_array = [];
custom_array[ "attack" ] = maps\_stealth_threat_enemy::enemy_alert_level_attack;
self stealth_threat_behavior_custom( custom_array );
self stealth_enable_seek_player_on_spotted();
self thread delay_stealth_plugin_corpse();
self stealth_plugin_event_all();
awareness_array = [];
awareness_array[ "explode" ] = ::enemy_explode_reaction;
awareness_array[ "doFlashBanged" ] = ::enemy_flashbang_reaction;
foreach ( key, value in awareness_array )
self maps\_stealth_event_enemy::stealth_event_mod( key, value );
state_array = [];
state_array[ "hidden" ] = ::river_enemy_state_hidden;
state_array[ "spotted" ]	= ::river_enemy_state_spotted;
stealth_basic_states_custom( state_array );
break;
case "allies":
self stealth_friendly_state_init();
array = [];
array[ "hidden" ] = ::stealth_friendly_state_hidden;
array[ "spotted" ] = ::stealth_friendly_state_spotted;
stealth_basic_states_custom( array );
self._stealth_move_detection_cap = 0;
}
}
stealth_infiltration()
{
self stealth_plugin_basic();
if ( isplayer( self ) )
return;
switch( self.team )
{
case "axis":
case "team3":
self stealth_plugin_threat();
self stealth_pre_spotted_function_custom( ::inf_prespotted_func );
custom_array = [];
custom_array[ "attack" ] = maps\_stealth_threat_enemy::enemy_alert_level_attack;
self stealth_threat_behavior_custom( custom_array );
self thread delay_stealth_plugin_corpse();
self stealth_plugin_event_all();
awareness_array = [];
awareness_array[ "explode" ] = ::enemy_explode_reaction;
awareness_array[ "doFlashBanged" ] = ::enemy_flashbang_reaction;
foreach ( key, value in awareness_array )
self maps\_stealth_event_enemy::stealth_event_mod( key, value );
self.baseaccuracy = 3;
break;
case "allies":
AssertEx( false, "this stealth function only supported for bad guys" );
break;
}
}
stealth_technical_rider()
{
self stealth_plugin_basic();
if ( isplayer( self ) )
return;
switch( self.team )
{
case "axis":
case "team3":
self stealth_plugin_threat();
custom_array = [];
custom_array[ "attack" ] = ::stealth_rider_enemy_state_attack;
self stealth_threat_behavior_custom( custom_array );
self stealth_enable_seek_player_on_spotted();
self thread delay_stealth_plugin_corpse();
self stealth_plugin_event_all();
awareness_array = [];
awareness_array[ "explode" ] = ::enemy_explode_reaction;
awareness_array[ "doFlashBanged" ] = ::enemy_flashbang_reaction;
foreach ( key, value in awareness_array )
self maps\_stealth_event_enemy::stealth_event_mod( key, value );
state_array = [];
state_array[ "hidden" ] = ::river_enemy_state_hidden;
state_array[ "spotted" ]	= ::river_enemy_state_spotted;
stealth_basic_states_custom( state_array );
self.baseaccuracy = 3;
self maps\_stealth_shared_utilities::ai_create_behavior_function( "animation", "wrapper", ::technical_rider_animation_wrapper );
self ent_flag_set( "_stealth_behavior_reaction_anim" );
break;
case "allies":
AssertEx( false, "this stealth function only supported for bad guys" );
break;
}
}
delay_stealth_plugin_corpse()
{
waittillframeend;
self stealth_plugin_corpse();
}
enemy_explode_reaction( type )
{
thread notify_enemy_bad_event();
if ( IsDefined( self.vehicle_position ) )
{
wait 0.1;
rider_stealth_broken();
}
self maps\_stealth_event_enemy::enemy_event_reaction_explosion( type );
}
enemy_flashbang_reaction( type )
{
thread notify_enemy_bad_event();
if ( IsDefined( self.vehicle_position ) )
{
wait 1;
rider_stealth_broken();
}
self maps\_stealth_event_enemy::enemy_event_reaction_flashbang( type );
}
notify_enemy_bad_event()
{
wait RandomFloatRange( 1.5, 2.5 );
level notify( "enemy_bad_event" );
}
river_prespotted_func()
{
prespotted_wait_time = 1;
if ( IsDefined( self.script_noteworthy ) )
{
if ( self.script_noteworthy == "river_bridge_guys" )
{
wait_times = [];
wait_times[0] = 5;
wait_times[1] = 4;
wait_times[2] = 2;
wait_times[3] = 1;
prespotted_wait_time = wait_times[ level.gameskill ];
}
else if ( self.script_noteworthy == "river_prone_guys" )
{
if ( flag( "flag_in_crouch_stealth_range" ) )
{
prespotted_wait_time = 3;
}
else
{
prespotted_wait_time = 1;
}
}
}
wait prespotted_wait_time;
}
inf_prespotted_func()
{
if ( IsDefined( self.script_stealthgroup ) &&
( self.script_stealthgroup == "8" || self.script_stealthgroup == "400" ) )
{
wait 1;
}
else
{
wait 5;
}
}
stealth_player_settings()
{
self endon( "death" );
self._stealth_move_detection_cap = 0;
self.original_threatbias = self.threatbias;
self player_attacker_accuracy();
if ( IsDefined( self.trying_to_kill ) )
{
player_reset_attacker_accuracy();
}
}
player_attacker_accuracy()
{
self endon( "death" );
level endon( "_stealth_enabled" );
if ( !flag( "_stealth_enabled" ) )
return;
while ( true )
{
flag_wait( "_stealth_spotted" );
self.trying_to_kill = true;
self.noPlayerInvul = true;
self.threatbias = 1000;
flag_waitopen( "_stealth_spotted" );
player_reset_attacker_accuracy();
}
}
player_reset_attacker_accuracy()
{
self endon( "death" );
self.trying_to_kill = undefined;
self.noPlayerInvul = undefined;
self.threatbias = self.original_threatbias;
}
get_default_game_range( ai_event )
{
switch ( ai_event )
{
case "ai_eventDistFootstepWalk":	return 128;
case "ai_eventDistFootstep": return 256;
case "ai_eventDistFootstepSprint":	return 400;
case "ai_eventDistDeath": return 1024;
case "ai_eventDistPain": return 512;
case "ai_eventDistNewEnemy": return 1024;
case "ai_eventDistGunShot": return 1024;
case "ai_eventDistGunShotTeam": return 1024;
case "ai_eventDistExplosion": return 1024;
default:
AssertEx( false, "no default set for this ai event: " + ai_event );
break;
}
return undefined;
}
default_stealth_ranges()
{
maps\_stealth_visibility_system::system_default_event_distances();
river_start_stealth_ranges();
default_alert_duration();
no_detect_corpse_range();
}
set_stealth_ranges( range_set_name )
{
AssertEx( IsDefined( level.stealth_manager.ranges[ range_set_name ] ), "Unknown stealth ranges for set: " + range_set_name );
rangesHidden = level.stealth_manager.ranges[ range_set_name ][ "hidden" ];
rangesSpotted = level.stealth_manager.ranges[ range_set_name ][ "spotted" ];
stealth_detect_ranges_set( rangesHidden, rangesSpotted );
custom_ai_event_ranges = level.stealth_manager.ai_events[ range_set_name ];
ai_events = [ "ai_eventDistFootstep", "ai_eventDistFootstepWalk", "ai_eventDistFootstepSprint",
"ai_eventDistDeath", "ai_eventDistPain", "ai_eventDistNewEnemy", "ai_eventDistGunShot", "ai_eventDistGunShotTeam",
"ai_eventDistExplosion" ];
ai_event_states = [ "spotted", "hidden" ];
ai_event_set = [];
foreach ( ai_event in ai_events )
{
ai_event_set[ ai_event ] = [];
foreach ( ai_event_state in ai_event_states )
{
if ( IsDefined( custom_ai_event_ranges ) &&
IsDefined( custom_ai_event_ranges[ ai_event ] ) &&
IsDefined( custom_ai_event_ranges[ ai_event ][ ai_event_state ] ) )
{
ai_event_set[ ai_event ][ ai_event_state ] = custom_ai_event_ranges[ ai_event ][ ai_event_state ];
}
else
{
ai_event_set[ ai_event ][ ai_event_state ] = get_default_game_range( ai_event );
}
}
}
stealth_ai_event_dist_custom( ai_event_set );
}
populate_stealth_sets( stealth_manager )
{
stealth_manager.ranges = [];
stealth_manager.ai_events = [];
stealth_manager.ranges[ "river_short" ][ "hidden" ][ "prone" ] = 20 * 12;
stealth_manager.ranges[ "river_short" ][ "hidden" ][ "crouch" ] = 20 * 12;
stealth_manager.ranges[ "river_short" ][ "hidden" ][ "stand" ] = 20 * 12;
stealth_manager.ranges[ "river_short" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "river_short" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "river_short" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "river_short" ][ "ai_eventDistFootstep" ][ "hidden" ] = 20 * 12;
stealth_manager.ai_events[ "river_short" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 20 * 12;
stealth_manager.ai_events[ "river_short" ][ "ai_eventDistGunShotTeam" ][ "spotted" ] = 1;
stealth_manager.ai_events[ "river_short" ][ "ai_eventDistGunShotTeam" ][ "hidden" ] = 1;
stealth_manager.ranges[ "river_medium" ][ "hidden" ][ "prone" ] = 60 * 12;
stealth_manager.ranges[ "river_medium" ][ "hidden" ][ "crouch" ] = 60 * 12;
stealth_manager.ranges[ "river_medium" ][ "hidden" ][ "stand" ] = 60 * 12;
stealth_manager.ranges[ "river_medium" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "river_medium" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "river_medium" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "river_medium" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 22 * 12;
stealth_manager.ai_events[ "river_medium" ][ "ai_eventDistGunShotTeam" ][ "spotted" ] = 1;
stealth_manager.ai_events[ "river_medium" ][ "ai_eventDistGunShotTeam" ][ "hidden" ] = 1;
stealth_manager.ranges[ "river_far" ][ "hidden" ][ "prone" ] = 100 * 12;
stealth_manager.ranges[ "river_far" ][ "hidden" ][ "crouch" ] = 100 * 12;
stealth_manager.ranges[ "river_far" ][ "hidden" ][ "stand" ] = 100 * 12;
stealth_manager.ranges[ "river_far" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "river_far" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "river_far" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "river_far" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 22 * 12;
stealth_manager.ai_events[ "river_far" ][ "ai_eventDistGunShotTeam" ][ "spotted" ] = 1;
stealth_manager.ai_events[ "river_far" ][ "ai_eventDistGunShotTeam" ][ "hidden" ] = 1;
stealth_manager.ranges[ "river_start" ][ "hidden" ][ "prone" ] = 40 * 12;
stealth_manager.ranges[ "river_start" ][ "hidden" ][ "crouch" ] = 50 * 12;
stealth_manager.ranges[ "river_start" ][ "hidden" ][ "stand" ] = 60 * 12;
stealth_manager.ranges[ "river_start" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "river_start" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "river_start" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "river_start" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 22 * 12;
stealth_manager.ranges[ "river_crouch" ][ "hidden" ][ "prone" ] = 2 * 12;
stealth_manager.ranges[ "river_crouch" ][ "hidden" ][ "crouch" ] = 2 * 12;
stealth_manager.ranges[ "river_crouch" ][ "hidden" ][ "stand" ] = 60 * 12;
stealth_manager.ranges[ "river_crouch" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "river_crouch" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "river_crouch" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "river_crouch" ][ "ai_eventDistFootstep" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "river_crouch" ][ "ai_eventDistFootstepWalk" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "river_crouch" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 22 * 12;
stealth_manager.ai_events[ "river_crouch" ][ "ai_eventDistGunShotTeam" ][ "spotted" ] = 1;
stealth_manager.ai_events[ "river_crouch" ][ "ai_eventDistGunShotTeam" ][ "hidden" ] = 1;
stealth_manager.ranges[ "blind_and_deaf" ][ "hidden" ][ "prone" ] = 2 * 12;
stealth_manager.ranges[ "blind_and_deaf" ][ "hidden" ][ "crouch" ] = 2 * 12;
stealth_manager.ranges[ "blind_and_deaf" ][ "hidden" ][ "stand" ] = 16 * 12;
stealth_manager.ranges[ "blind_and_deaf" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "blind_and_deaf" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "blind_and_deaf" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "blind_and_deaf" ][ "ai_eventDistFootstep" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "blind_and_deaf" ][ "ai_eventDistFootstepWalk" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "blind_and_deaf" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "blind_and_deaf" ][ "ai_eventDistGunShotTeam" ][ "spotted" ] = 1;
stealth_manager.ai_events[ "blind_and_deaf" ][ "ai_eventDistGunShotTeam" ][ "hidden" ] = 1;
stealth_manager.ranges[ "river_big_moment_prone" ][ "hidden" ][ "prone" ] = 5 * 12;
stealth_manager.ranges[ "river_big_moment_prone" ][ "hidden" ][ "crouch" ] = 50 * 12;
stealth_manager.ranges[ "river_big_moment_prone" ][ "hidden" ][ "stand" ] = 50 * 12;
stealth_manager.ranges[ "river_big_moment_prone" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "river_big_moment_prone" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "river_big_moment_prone" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "river_big_moment_prone" ][ "ai_eventDistFootstep" ][ "hidden" ] = 5 * 12;
stealth_manager.ai_events[ "river_big_moment_prone" ][ "ai_eventDistFootstepWalk" ][ "hidden" ] = 5 * 12;
stealth_manager.ai_events[ "river_big_moment_prone" ][ "ai_eventDistGunShotTeam" ][ "spotted" ] = 1;
stealth_manager.ai_events[ "river_big_moment_prone" ][ "ai_eventDistGunShotTeam" ][ "hidden" ] = 1;
stealth_manager.ranges[ "inf_patroller" ][ "hidden" ][ "prone" ] = 2 * 12;
stealth_manager.ranges[ "inf_patroller" ][ "hidden" ][ "crouch" ] = 2 * 12;
stealth_manager.ranges[ "inf_patroller" ][ "hidden" ][ "stand" ] = 16 * 12;
stealth_manager.ranges[ "inf_patroller" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "inf_patroller" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "inf_patroller" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "inf_patroller" ][ "ai_eventDistFootstep" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "inf_patroller" ][ "ai_eventDistFootstepWalk" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "inf_patroller" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 2 * 12;
stealth_manager.ai_events[ "inf_patroller" ][ "ai_eventDistDeath" ][ "hidden" ] = 25 * 12;
stealth_manager.ai_events[ "inf_patroller" ][ "ai_eventDistPain" ][ "hidden" ] = 25 * 12;
stealth_manager.ai_events[ "inf_patroller" ][ "ai_eventDistGunShotTeam" ][ "spotted" ] = 1;
stealth_manager.ai_events[ "inf_patroller" ][ "ai_eventDistGunShotTeam" ][ "hidden" ] = 1;
stealth_manager.ranges[ "inf_stealth" ][ "hidden" ][ "prone" ] = 40 * 12;
stealth_manager.ranges[ "inf_stealth" ][ "hidden" ][ "crouch" ] = 40 * 12;
stealth_manager.ranges[ "inf_stealth" ][ "hidden" ][ "stand" ] = 40 * 12;
stealth_manager.ranges[ "inf_stealth" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "inf_stealth" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "inf_stealth" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistFootstep" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistFootstep" ][ "hidden" ] = 40 * 12;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistFootstepWalk" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistFootstepWalk" ][ "hidden" ] = 40 * 12;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistFootstepSprint" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 40 * 12;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistDeath" ][ "hidden" ] = 25 * 12;
stealth_manager.ai_events[ "inf_stealth" ][ "ai_eventDistPain" ][ "hidden" ] = 25 * 12;
stealth_manager.ranges[ "inf_aware_stealth" ][ "hidden" ][ "prone" ] = 100 * 12;
stealth_manager.ranges[ "inf_aware_stealth" ][ "hidden" ][ "crouch" ] = 100 * 12;
stealth_manager.ranges[ "inf_aware_stealth" ][ "hidden" ][ "stand" ] = 100 * 12;
stealth_manager.ranges[ "inf_aware_stealth" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "inf_aware_stealth" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "inf_aware_stealth" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistFootstep" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistFootstep" ][ "hidden" ] = 100 * 12;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistFootstepWalk" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistFootstepWalk" ][ "hidden" ] = 100 * 12;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistFootstepSprint" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 100 * 12;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistDeath" ][ "hidden" ] = 512;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistPain" ][ "hidden" ] = 256;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistNewEnemy" ][ "spotted" ] = 750;
stealth_manager.ai_events[ "inf_aware_stealth" ][ "ai_eventDistNewEnemy" ][ "hidden" ] = 750;
stealth_manager.ranges[ "inf_tower_stealth" ][ "hidden" ][ "prone" ] = 20 * 12;
stealth_manager.ranges[ "inf_tower_stealth" ][ "hidden" ][ "crouch" ] = 20 * 12;
stealth_manager.ranges[ "inf_tower_stealth" ][ "hidden" ][ "stand" ] = 20 * 12;
stealth_manager.ranges[ "inf_tower_stealth" ][ "spotted" ][ "prone" ] = 8192;
stealth_manager.ranges[ "inf_tower_stealth" ][ "spotted" ][ "crouch" ] = 8192;
stealth_manager.ranges[ "inf_tower_stealth" ][ "spotted" ][ "stand" ] = 8192;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistFootstep" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistFootstep" ][ "hidden" ] = 20 * 12;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistFootstepWalk" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistFootstepWalk" ][ "hidden" ] = 20 * 12;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistFootstepSprint" ][ "spotted" ] = 1024;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistFootstepSprint" ][ "hidden" ] = 20 * 12;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistDeath" ][ "hidden" ] = 25 * 12;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistPain" ][ "hidden" ] = 25 * 12;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistNewEnemy" ][ "spotted" ] = 750;
stealth_manager.ai_events[ "inf_tower_stealth" ][ "ai_eventDistNewEnemy" ][ "hidden" ] = 25 * 12;
}
river_short_stealth_ranges()
{
set_stealth_ranges( "river_short" );
}
river_medium_stealth_ranges()
{
set_stealth_ranges( "river_medium" );
}
river_start_stealth_ranges()
{
set_stealth_ranges( "river_start" );
}
river_far_stealth_ranges()
{
set_stealth_ranges( "river_far" );
}
river_crouch_stealth_ranges()
{
set_stealth_ranges( "river_crouch" );
}
blind_and_deaf_ranges()
{
set_stealth_ranges( "blind_and_deaf" );
}
river_big_moment_ranges()
{
blind_and_deaf_ranges();
}
river_big_moment_prone_ranges()
{
set_stealth_ranges( "river_big_moment_prone" );
}
inf_stealth_settings()
{
set_stealth_ranges( "inf_stealth" );
}
inf_aware_stealth_settings()
{
set_stealth_ranges( "inf_aware_stealth" );
}
inf_tower_stealth_settings()
{
set_stealth_ranges( "inf_tower_stealth" );
inf_detect_corpse_range();
}
no_detect_corpse_range()
{
array = [];
array[ "player_dist" ] = 1500;
array[ "sight_dist" ] = 50;
array[ "detect_dist" ] = 50;
array[ "found_dist" ] = 45;
array[ "found_dog_dist" ] = 50;
stealth_corpse_ranges_custom( array );
}
inf_detect_corpse_range()
{
array = [];
array[ "player_dist" ] = 1500;
array[ "sight_dist" ] = 100;
array[ "detect_dist" ] = 100;
array[ "found_dist" ] = 100;
array[ "found_dog_dist" ] = 100;
stealth_corpse_ranges_custom( array );
}
default_alert_duration()
{
alert_duration = [];
alert_duration[0] = 1;
alert_duration[1] = 1;
alert_duration[2] = 1;
alert_duration[3] = 0.75;
stealth_alert_level_duration( alert_duration[ level.gameskill ] );
}
inf_alert_duration()
{
alert_duration = [];
alert_duration[0] = 5;
alert_duration[1] = 4;
alert_duration[2] = 3;
alert_duration[3] = 2;
stealth_alert_level_duration( alert_duration[ level.gameskill ] );
}
stealth_friendly_state_init()
{
self endon( "death" );
self.default_baseaccuracy = self.baseaccuracy;
self.default_accuracy = self.accuracy;
self.spotted_accuracy = 0.1;
self.default_color = self.script_forcecolor;
}
stealth_friendly_state_hidden()
{
self endon( "death" );
self thread detectable_on_flashbang();
self set_shared_field_value( "no_pistol_switch" );
self set_shared_field_value( "dontevershoot" );
self set_shared_field_value( "ignoreme" );
self thread set_battlechatter( false );
self.baseaccuracy = self.default_baseaccuracy;
self.accuracy = self.default_accuracy;
self set_force_color_safe( self.default_color );
}
stealth_friendly_state_spotted()
{
self endon( "death" );
self notify( "end_detectable_on_bad_event" );
self unset_shared_field_value( "no_pistol_switch" );
self unset_shared_field_value( "dontevershoot" );
self unset_shared_field_value( "ignoreme" );
self thread set_battlechatter( true );
if ( flag( "_stealth_enabled" ) )
{
self.baseaccuracy = self.spotted_accuracy;
self.accuracy = self.spotted_accuracy;
self set_force_color_safe( self.spotted_color );
}
else
{
self.ignoreall = false;
self.baseaccuracy = self.default_baseaccuracy;
self.accuracy = self.default_accuracy;
self set_force_color_safe( self.default_color );
}
}
set_force_color_safe( new_color )
{
if ( IsDefined( self.script_forcecolor ) )
{
self set_force_color( new_color );
}
else
{
self.old_forcecolor = new_color;
}
}
change_friendly_stealth_spotted_accuracy( spotted_accuracy )
{
self endon( "death" );
AssertEx( flag( "_stealth_enabled" ), "stealth not enabled!" );
self.spotted_accuracy = spotted_accuracy;
if ( flag( "_stealth_spotted" ) )
{
self.baseaccuracy = self.spotted_accuracy;
self.accuracy = self.spotted_accuracy;
}
}
detectable_on_flashbang()
{
self notify( "end_detectable_on_bad_event" );
self endon( "end_detectable_on_bad_event" );
while ( true )
{
level waittill( "enemy_bad_event" );
self thread turn_off_ignoreme_for_awhile();
}
}
turn_off_ignoreme_for_awhile()
{
self unset_shared_field_value( "ignoreme" );
wait 10;
self set_shared_field_value( "ignoreme" );
}
river_enemy_state_hidden()
{
self.fovcosine = .5;
self.fovcosinebusy = .1;
self.favoriteenemy = undefined;
self.dontattackme = true;
self.dontevershoot = true;
self thread set_battlechatter( false );
if ( self.type == "dog" )
return;
self.dieQuietly = false;
self clearenemy();
}
river_enemy_state_spotted( internal )
{
self.fovcosine = .01;
self.ignoreall = false;
self.dontattackme = undefined;
self.dontevershoot = undefined;
if ( isdefined( self.oldfixednode ) )
self.fixednode = self.oldfixednode;
self thread set_battlechatter( true );
if ( self.type != "dog" )
{
self.dieQuietly = false;
if ( !isdefined( internal ) )
{
self clear_run_anim();
self enemy_stop_current_behavior();
}
}
else
{
self.script_growl = undefined;
self.script_nobark = undefined;
}
if ( isdefined( internal ) )
return;
enemy = level._stealth.group.spotted_enemy[ self.script_stealthgroup ];
if ( isdefined( enemy ) )
self getEnemyInfo( enemy );
}
rider_stealth_broken()
{
self endon( "death" );
if ( IsDefined( self.ridingvehicle ) )
{
if ( self.ridingvehicle maps\_vehicle_aianim::check_unloadgroup( self.vehicle_position, "passenger_and_driver" ) )
{
self.ridingvehicle notify( "unload_on_stealth_broken" );
if ( IsDefined( self.vehicle_position ) )
{
self waittill( "jumpedout" );
}
}
}
}
stealth_rider_enemy_state_attack()
{
self endon( "death" );
self endon( "pain_death" );
wait 1;
rider_stealth_broken();
}
patroller_logic( patrol_anim, patrol_twitch_weights )
{
self endon( "death" );
_flag = self stealth_get_group_spotted_flag();
if ( flag( _flag ) )
return;
level endon( _flag );
self.script_patroller = 1;
self.target = self.script_parameters;
if(!isdefined(patrol_anim) && isdefined(self.script_animation))
patrol_anim = self.script_animation;
if ( IsDefined( patrol_anim ) )
{
self.patrol_walk_anim = patrol_anim;
}
if ( IsDefined( patrol_twitch_weights ) )
{
self.patrol_walk_twitch = patrol_twitch_weights;
}
self thread maps\_patrol::patrol();
}
technical_rider_animation_wrapper( type )
{
self endon( "death" );
self endon( "pain_death" );
rider_stealth_broken();
if ( IsDefined( self.vehicle_position ) && self.vehicle_position == 1 )
return;
self maps\_stealth_shared_utilities::enemy_animation_wrapper( type );
}
unload_on_spotted()
{
self endon( "death" );
self waittill( "unload_on_stealth_broken" );
if ( self ent_flag_exist( "no_unload_zone" ) )
{
self ent_flag_waitopen( "no_unload_zone" );
}
self notify( "stealth_broken_unload" );
self notify( "newpath" );
self Vehicle_SetSpeed( 0, 15 );
wait 1;
self maps\_vehicle::vehicle_unload( "passenger_and_driver" );
}
_warlord_patrol_endon_spotted_flag()
{
self thread end_patrol_on_spotted();
}
end_patrol_on_spotted()
{
self endon( "death" );
flag1 = self stealth_get_group_spotted_flag();
flag2 = self stealth_get_group_corpse_flag();
flag_wait_either( flag1, flag2 );
if ( self ent_flag_exist( "_stealth_enabled" ) && self ent_flag( "_stealth_enabled" ) )
{
self notify( "end_patrol" );
}
}
