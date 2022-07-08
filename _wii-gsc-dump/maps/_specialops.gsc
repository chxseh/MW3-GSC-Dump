#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_specialops_code;
specialops_init()
{
foreach ( player in level.players )
player thread roundStat_init();
if ( is_coop() )
{
maps\_gameskill::setGlobalDifficulty();
foreach ( idx, player in level.players )
player maps\_gameskill::setDifficulty();
}
if ( !isdefined( level.so_override ) )
level.so_override = [];
if ( !IsDefined( level.friendlyfire_warnings ) )
{
level.friendlyfire_warnings = true;
}
level.no_friendly_fire_penalty = true;
PrecacheMinimapSentryCodeAssets();
precachemenu( "sp_eog_summary" );
precachemenu( "coop_eog_summary" );
precachemenu( "coop_eog_summary2" );
precacheMenu( "surHUD_display" );
PrecacheShellshock( "so_finished" );
precacheShader( "hud_show_timer" );
PrecacheShader( "specops_ui_equipmentstore" );
PrecacheShader( "specops_ui_weaponstore" );
PrecacheShader( "specops_ui_airsupport" );
so_precache_strings();
foreach ( player in level.players )
{
player.so_hud_show_time = gettime() + ( so_standard_wait() * 1000 );
player ent_flag_init( "so_hud_can_toggle" );
}
level.challenge_time_nudge = 30;
level.challenge_time_hurry = 10;
level.func_destructible_crush_player = ::so_crush_player;
setsaveddvar( "g_friendlyfireDamageScale", 2 );
setsaveddvar( "turretSentryRestrictUsageToOwner", 0 );
if ( isdefined( level.so_compass_zoom ) )
{
compass_dist = 0;
switch ( level.so_compass_zoom )
{
case "close":	compass_dist = 1500; break;
case "far": compass_dist = 6000; break;
default: compass_dist = 3000; break;
}
if ( !issplitscreen() )
compass_dist += ( compass_dist * 0.1 );
setsaveddvar( "compassmaxrange", compass_dist );
}
flag_init( "challenge_timer_passed" );
flag_init( "challenge_timer_expired" );
flag_init( "special_op_succeeded" );
flag_init( "special_op_failed" );
flag_init( "special_op_terminated" );
flag_init( "special_op_p1ready" );
flag_init( "special_op_p2ready" );
flag_init( "special_op_no_unlink" );
flag_init( "special_op_final_xp_given" );
thread disable_saving();
thread specialops_detect_death();
specialops_dialog_init();
if ( is_coop() )
maps\_specialops_battlechatter::init();
if ( !isdefined( level.so_dialog_func_override ) )
level.so_dialog_func_override = [];
if ( !is_coop() )
set_custom_gameskill_func( maps\_gameskill::solo_player_in_special_ops );
else if ( is_survival() )
set_custom_gameskill_func( maps\_gameskill::coop_player_in_special_ops_survival );
array_thread( getentarray( "trigger_multiple_SO_escapewarning", "classname" ), ::enable_escape_warning_auto );
array_thread( getentarray( "trigger_multiple_SO_escapefailure", "classname" ), ::enable_escape_failure_auto );
level.so_deadquotes_chance = 0.5;
setdvar( "ui_deadquote", "" );
thread so_special_failure_hint();
setdvar( "ui_skip_level_select", "1" );
setDvar( "ui_opensummary", 0 );
mainLeaderboard = "LB_" + level.script;
hiddenLeaderboard = "";
if( is_coop() )
mainLeaderboard += "_TEAM";
if( is_survival() )
{
hiddenLeaderboard = " LB_EXT_" + level.script;
if( is_coop() )
hiddenLeaderboard += "_TEAM";
}
precacheLeaderboards( mainLeaderboard + hiddenLeaderboard );
pick_starting_location_so();
level thread setSoUniqueSavedDvars();
maps\_audio::aud_set_spec_ops();
register_level_unlock( "so_mw3_mission_2", "mission" );
register_level_unlock( "so_mw3_mission_3", "mission" );
register_level_unlock( "so_mw3_mission_4", "mission" );
register_survival_unlock();
maps\_rank::init();
maps\_missions::init();
enable_damagefeedback();
add_global_spawn_function( "axis", maps\_specialops_code::so_ai_flashed_damage_feedback );
thread setup_XP();
thread Unlock_hint();
thread so_achievement_init();
}
roundStat_init()
{
wait 0.05;
self setplayerdata( "round", "kills", 0 );
self setplayerdata( "round", "killStreak", 0 );
self setplayerdata( "round", "deaths", 0 );
self setplayerdata( "round", "difficulty", 0 );
self setplayerdata( "round", "score", 0 );
self setplayerdata( "round", "timePlayed", 0 );
self setplayerdata( "round", "wave", 0 );
self setplayerdata( "round", "xuidTeammate", "0" );
self setplayerdata( "round", "totalXp", 0 );
self setplayerdata( "round", "scoreXp", 0 );
self setplayerdata( "round", "challengeXp", 0 );
}
setSoUniqueSavedDvars()
{
setsaveddvar( "hud_fade_ammodisplay", 30 );
setsaveddvar( "hud_fade_stance", 30 );
setsaveddvar( "hud_fade_offhand", 30 );
setsaveddvar( "hud_fade_compass", 0 );
}
so_precache_strings()
{
PrecacheString( &"SPECIAL_OPS_TIME_NULL" );
PrecacheString( &"SPECIAL_OPS_TIME" );
PrecacheString( &"SPECIAL_OPS_WAITING_P1" );
PrecacheString( &"SPECIAL_OPS_WAITING_P2" );
PrecacheString( &"SPECIAL_OPS_REVIVE_NAG_HINT" );
PrecacheString( &"SPECIAL_OPS_CHALLENGE_SUCCESS" );
PrecacheString( &"SPECIAL_OPS_CHALLENGE_FAILURE" );
PrecacheString( &"SPECIAL_OPS_FAILURE_HINT_TIME" );
PrecacheString( &"SPECIAL_OPS_ESCAPE_WARNING" );
PrecacheString( &"SPECIAL_OPS_ESCAPE_SPLASH" );
PrecacheString( &"SPECIAL_OPS_WAITING_OTHER_PLAYER" );
PrecacheString( &"SPECIAL_OPS_STARTING_IN" );
PrecacheString( &"SPECIAL_OPS_UI_TIME" );
PrecacheString( &"SPECIAL_OPS_UI_KILLS" );
PrecacheString( &"SPECIAL_OPS_UI_DIFFICULTY" );
PrecacheString( &"SPECIAL_OPS_UI_PLAY_AGAIN" );
PrecacheString( &"SPECIAL_OPS_DASHDASH" );
PrecacheString( &"SPECIAL_OPS_HOSTILES" );
PrecacheString( &"SPECIAL_OPS_INTERMISSION_WAVENUM" );
PrecacheString( &"SPECIAL_OPS_INTERMISSION_WAVEFINAL" );
PrecacheString( &"SPECIAL_OPS_WAVENUM" );
PrecacheString( &"SPECIAL_OPS_WAVEFINAL" );
PrecacheString( &"SPECIAL_OPS_PRESS_TO_CANCEL" );
PrecacheString( &"SPECIAL_OPS_PLAYER_IS_READY" );
PrecacheString( &"SPECIAL_OPS_PRESS_TO_START" );
PrecacheString( &"SPECIAL_OPS_PLAYER_IS_NOT_READY" );
PrecacheString( &"SPECIAL_OPS_EMPTY" );
}
so_standard_wait()
{
return 4;
}
specialops_remove_unused()
{
entarray = getentarray();
if ( !isdefined( entarray ) )
return;
special_op_state = is_specialop();
foreach ( ent in entarray )
{
if ( ent specialops_remove_entity_check( special_op_state ) )
ent Delete();
}
so_special_failure_hint_reset_dvars();
}
enable_triggeRed_start( challenge_id_start )
{
level endon( "challenge_timer_expired" );
trigger_ent = getent( challenge_id_start, "script_noteworthy" );
AssertEx( isdefined( trigger_ent ), "challenge_id (" + challenge_id_start + ") was unable to match with a valid trigger." );
trigger_ent waittill( "trigger" );
flag_set( challenge_id_start );
}
enable_triggered_complete( challenge_id, challenge_id_complete, touch_style )
{
level endon( "challenge_timer_expired" );
flag_set( challenge_id );
if ( !isdefined( touch_style ) )
touch_style = "freeze";
trigger_ent = getent( challenge_id, "script_noteworthy" );
AssertEx( isdefined( trigger_ent ), "challenge_id (" + challenge_id + ") was unable to match with a valid trigger." );
thread disable_mission_end_trigger( trigger_ent );
switch ( touch_style )
{
case "all" : wait_all_players_are_touching( trigger_ent ); break;
case "any" : wait_all_players_have_touched( trigger_ent, touch_style ); break;
case "freeze"	: wait_all_players_have_touched( trigger_ent, touch_style ); break;
}
level.challenge_end_time = gettime();
flag_set( challenge_id_complete );
}
fade_challenge_in( wait_time, doDialogue )
{
if ( !is_survival() )
{
foreach ( player in level.players )
player thread enable_kill_counter();
}
if ( !isdefined( wait_time ) )
wait_time = 0.5;
alpha = 1;
if ( isdefined( level.so_waiting_for_players_alpha ) )
alpha = level.so_waiting_for_players_alpha;
screen_fade = create_client_overlay( "black", alpha );
wait( wait_time );
level notify( "challenge_fading_in" );
fadeUpTime = 1;
screen_fade thread fade_over_time( 0, fadeUpTime );
level thread notify_delay( "challenge_fadein_complete", fadeUpTime );
if ( flag_exist( "slamzoom_finished" ) )
flag_wait( "slamzoom_finished" );
wait 0.75;
if( !IsDefined( doDialogue ) || doDialogue )
{
thread so_dialog_ready_up();
}
}
fade_challenge_out( challenge_id, skipDialog )
{
if ( !isdefined( skipDialog ) )
skipDialog = false;
if ( isdefined( challenge_id ) )
flag_wait( challenge_id );
do_sarcasm = undefined;
if ( is_survival() )
{
assert( isdefined( level.current_wave ) && isdefined( level.congrat_min_wave ) );
do_sarcasm = true;
if ( !skipDialog )
skipDialog = ( level.current_wave < level.congrat_min_wave );
}
if ( !skipDialog )
thread so_dialog_mission_success( do_sarcasm );
maps\_endmission::so_eog_summary_calculate( true );
specialops_mission_over_setup( true );
so_mission_complete_achivements();
if ( is_survival() )
level notify( "so_generate_deathquote" );
maps\_endmission::so_eog_summary_display();
}
override_summary_time( time_in_milliseconds )
{
self.so_eog_summary_data[ "time" ] = maps\_utility::round_millisec_on_sec( time_in_milliseconds, 1, false );
}
override_summary_kills( kills )
{
self.so_eog_summary_data[ "kills" ] = kills;
}
override_summary_score( score )
{
self.so_eog_summary_data[ "score" ] = score;
}
enable_countdown_timer( time_wait, set_start_time, message, timer_draw_delay )
{
level endon( "special_op_terminated" );
if ( !isdefined( message ) )
message = &"SPECIAL_OPS_STARTING_IN";
hudelem = so_create_hud_item( 0, so_hud_ypos(), message );
hudelem SetPulseFX( 50, time_wait * 1000, 500 );
hudelem_timer = so_create_hud_item( 0, so_hud_ypos() );
hudelem_timer thread show_countdown_timer_time( time_wait, timer_draw_delay );
wait time_wait;
level.player PlaySound( "arcademode_zerodeaths" );
if ( isdefined( set_start_time ) && set_start_time )
level.challenge_start_time = gettime();
thread destroy_countdown_timer( hudelem, hudelem_timer );
}
destroy_countdown_timer( hudelem, hudelem_timer )
{
wait 1;
hudelem Destroy();
hudelem_timer Destroy();
}
show_countdown_timer_time( time_wait, delay )
{
self.alignX = "left";
self settenthstimer( time_wait );
self.alpha = 0;
if ( !isdefined( delay ) )
delay = 0.625;
wait delay;
time_wait = int( ( time_wait - delay ) * 1000 );
self SetPulseFX( 50, time_wait, 500 );
self.alpha = 1;
}
enable_challenge_timer( start_flag, passed_flag, message, no_display )
{
assertex( isdefined( passed_flag ), "display_challenge_timer_down() needs a valid passed_flag." );
if ( isdefined( start_flag ) )
{
if ( !flag_exist( start_flag ) )
flag_init( start_flag );
level.start_flag = start_flag;
}
if ( isdefined( passed_flag ) )
{
if ( !flag_exist( passed_flag ) )
flag_init( passed_flag );
level.passed_flag = passed_flag;
}
if ( !isdefined( message ) )
message = &"SPECIAL_OPS_TIME";
if ( !isdefined( level.challenge_time_beep_start ) )
level.challenge_time_beep_start = level.challenge_time_hurry;
level.so_challenge_time_beep = level.challenge_time_beep_start + 1;
foreach ( player in level.players )
{
player thread challenge_timer_player_setup( start_flag, passed_flag, message, no_display );
}
}
enable_challenge_counter( line_index, label, message )
{
AssertEx( IsDefined( self ) && IsPlayer( self ), "Self must be player." );
if ( !IsDefined( self.hud_so_counter_messages ) )
{
self.hud_so_counter_messages = [];
}
if ( !IsDefined( self.hud_so_counter_values ) )
{
self.hud_so_counter_values = [];
}
self thread enable_challenge_counter_think( line_index, label, message );
}
enable_challenge_counter_think( line_index, label, message )
{
level endon( "special_op_terminated" );
Assert( IsDefined( self.hud_so_counter_messages ) && IsDefined( self.hud_so_counter_values ), "enable_challenge_counter_think() should not be called directly, use enable_challenge_counter()." );
disable_challenge_counter( line_index );
self endon( challenge_counter_get_disable_notify( line_index ) );
ypos = maps\_specialops::so_hud_ypos();
self.hud_so_counter_messages[ line_index ] = maps\_specialops::so_create_hud_item( line_index, ypos, label, self );
self.hud_so_counter_values[ line_index ] = maps\_specialops::so_create_hud_item( line_index, ypos, undefined, self );
self.hud_so_counter_values[ line_index ] SetText( 0 );
self.hud_so_counter_values[ line_index ].alignX = "left";
self childthread maps\_specialops::info_hud_handle_fade( self.hud_so_counter_messages[ line_index ] );
self childthread maps\_specialops::info_hud_handle_fade( self.hud_so_counter_values[ line_index ] );
if( !IsDefined( level.challenge_counter_start_immediately ) || !level.challenge_counter_start_immediately )
{
flag_wait( level.start_flag );
}
while( true )
{
self waittill( message, value );
assertex( isdefined( value ), "Incorrect use of enable_challenge_counter(), an integer must be passed as a parameter of notify '"+ message +"'." );
self.hud_so_counter_values[ line_index ] SetText( value );
}
}
disable_challenge_counter( line_index )
{
AssertEx( IsDefined( line_index ), "The line index must be defined." );
AssertEx( IsDefined( self ) && IsPlayer( self ), "Self must be player." );
line_index = Int( line_index );
self notify( challenge_counter_get_disable_notify( line_index ) );
if ( IsDefined( self.hud_so_counter_messages[ line_index ] ) )
{
self.hud_so_counter_messages[ line_index ] Destroy();
}
if ( IsDefined( self.hud_so_counter_values[ line_index ] ) )
{
self.hud_so_counter_values[ line_index ] Destroy();
}
}
disable_challenge_counter_all()
{
if ( IsDefined( self.hud_so_counter_messages ) )
{
foreach ( line_index, hud_msg in self.hud_so_counter_messages )
{
self disable_challenge_counter( line_index );
}
self.hud_so_counter_messages = [];
self.hud_so_counter_values = [];
}
}
challenge_counter_get_disable_notify( line_index )
{
AssertEx( IsDefined( line_index ), "The line index must be defined." );
line_index = int( line_index );
return "challenge_counter_disable" + line_index;
}
enable_kill_counter()
{
level.kill_counter_line_index = 2;
level endon( "special_op_terminated" );
self notify( "enabling_kill_counter" );
self endon( "enabling_kill_counter" );
self thread enable_challenge_counter( level.kill_counter_line_index, &"SPECIAL_OPS_KILL_COUNT", "ui_kill_count" );
self thread enable_kill_counter_think( level.kill_counter_line_index );
}
enable_kill_counter_think( line_index )
{
level endon( "special_op_terminated" );
self endon( challenge_counter_get_disable_notify( line_index ) );
while( true )
{
level waittill( "specops_player_kill", attacker, victim );
assert( isdefined( attacker.stats ) && isdefined( attacker.stats[ "kills" ] ) );
if( self == attacker )
self notify( "ui_kill_count", attacker.stats[ "kills" ] );
}
}
disable_kill_counter()
{
if ( !IsDefined( level.kill_counter_line_index ) )
return;
disable_challenge_counter( level.kill_counter_line_index );
}
disable_challenge_timer()
{
level notify( "stop_challenge_timer_thread" );
}
so_get_difficulty_menu_string( game_skill )
{
AssertEx( IsDefined( game_skill ) || IsDefined( level.specops_reward_gameskill ), "game_skill param and level.specops_reward_gameskill not defined." );
game_skill = ter_op( IsDefined( game_skill ), game_skill, level.specops_reward_gameskill );
AssertEx( Int( game_skill ) == game_skill, "game_skill param must be an integer" );
difficulty_string = "";
switch ( Int( game_skill ) )
{
case 0:
difficulty_string = "@MENU_RECRUIT";
break;
case 1:
difficulty_string = "@MENU_REGULAR";
break;
case 2:
difficulty_string = "@MENU_HARDENED";
break;
case 3:
difficulty_string = "@MENU_VETERAN";
break;
default:
AssertMsg( "Invalid game_skill param: " + game_skill + ". Must be >= 0 and <= 3" );
difficulty_string = "@MENU_REGULAR";
break;
}
return difficulty_string;
}
so_wait_for_players_ready()
{
if ( !isdefined( level.so_enable_wait_for_players ) )
return;
if ( !is_coop() || issplitscreen() )
return;
level.so_waiting_for_players = true;
level.so_waiting_for_players_alpha = 0.85;
level.player thread so_wait_for_player_ready( "special_op_p1ready", 2 );
level.player2 thread so_wait_for_player_ready( "special_op_p2ready", 3.25 );
screen_hold = create_client_overlay( "black", 1 );
screen_hold fade_over_time( level.so_waiting_for_players_alpha, 1 );
while ( !flag( "special_op_p1ready" ) || !flag( "special_op_p2ready" ) )
wait 0.05;
hold_time = 1;
level.player thread so_wait_for_player_ready_cleanup( hold_time );
level.player2 thread so_wait_for_player_ready_cleanup( hold_time );
wait hold_time;
screen_hold Destroy();
level.so_waiting_for_players = undefined;
}
so_wait_for_player_ready( my_flag, y_line )
{
self endon( "stop_waiting_start" );
self freezecontrols( true );
self disableweapons();
self.waiting_to_start_hud = so_create_hud_item( 0, 0, &"SPECIAL_OPS_PRESS_TO_START", self, true );
self.waiting_to_start_hud.alignx = "center";
self.waiting_to_start_hud.horzAlign = "center";
self.ready_indication_hud = so_create_hud_item( y_line, 0, &"SPECIAL_OPS_PLAYER_IS_NOT_READY", undefined, true );
self.ready_indication_hud.alignx = "center";
self.ready_indication_hud.horzAlign = "center";
self.ready_indication_hud settext( self.playername );
self.ready_indication_hud set_hud_yellow();
wait 0.05;
self setBlurForPlayer( 6, 0 );
NotifyOnCommand( self.unique_id + "_is_ready", "+gostand" );
NotifyOnCommand( self.unique_id + "_is_not_ready", "+stance" );
while ( 1 )
{
self waittill( self.unique_id + "_is_ready" );
flag_set( my_flag );
self PlaySound( "so_player_is_ready" );
self.waiting_to_start_hud.label = &"SPECIAL_OPS_PRESS_TO_CANCEL";
self.ready_indication_hud so_hud_pulse_success( &"SPECIAL_OPS_PLAYER_IS_READY" );
self waittill( self.unique_id + "_is_not_ready" );
flag_clear( my_flag );
self PlaySound( "so_player_not_ready" );
self.waiting_to_start_hud.label = &"SPECIAL_OPS_PRESS_TO_START";
self.ready_indication_hud so_hud_pulse_warning( &"SPECIAL_OPS_PLAYER_IS_NOT_READY" );
}
}
so_wait_for_player_ready_cleanup( hold_time )
{
self notify( "stop_waiting_start" );
self.waiting_to_start_hud thread so_remove_hud_item( true );
wait hold_time;
self.ready_indication_hud thread so_remove_hud_item( false, true );
self freezecontrols( false );
self enableweapons();
self setBlurForPlayer( 0, 0.5 );
}
attacker_is_p1( attacker )
{
if ( !isdefined( attacker ) )
return false;
return attacker == level.player;
}
attacker_is_p2( attacker )
{
if ( !is_coop() )
return false;
if ( !isdefined( attacker ) )
return false;
return attacker == level.player2;
}
enable_escape_warning()
{
level endon( "special_op_terminated" );
level.escape_warning_triggers = getentarray( "player_trying_to_escape", "script_noteworthy" );
assertex( level.escape_warning_triggers.size > 0, "enable_escape_warning() requires at least one trigger with script_noteworthy = player_trying_to_escape" );
add_hint_string( "player_escape_warning", &"SPECIAL_OPS_EMPTY", ::disable_escape_warning );
while( true )
{
wait 0.05;
foreach ( trigger in level.escape_warning_triggers )
{
foreach ( player in level.players )
{
if ( !isdefined( player.escape_hint_active ) )
{
if ( player istouching( trigger ) )
{
player.escape_hint_active = true;
player thread ping_escape_warning();
player display_hint_timeout( "player_escape_warning" );
}
}
else
{
if ( !isdefined( player.ping_escape_splash ) )
player thread ping_escape_warning();
}
}
}
}
}
enable_escape_failure()
{
level endon( "special_op_terminated" );
flag_wait( "player_has_escaped" );
level.challenge_end_time = gettime();
so_force_deadquote( "@DEADQUOTE_SO_LEFT_PLAY_AREA" );
maps\_utility::missionFailedWrapper();
}
so_delete_all_by_type( type1_def_func, type2_def_func, type3_def_func, type4_def_func, type5_def_func, should_notify_before_delete )
{
if(!isdefined(should_notify_before_delete))
should_notify_before_delete = false;
check_arr = [ type1_def_func, type2_def_func, type3_def_func, type4_def_func, type5_def_func ];
check_arr = array_removeUndefined(check_arr);
all_ents = getentarray();
foreach( ent in all_ents )
{
if ( !isdefined( ent.code_classname ) )
continue;
isSpecialOpEnt = ( isdefined( ent.script_specialops ) && ent.script_specialops == 1 );
if( isSpecialOpEnt )
continue;
isIntelItem = ( isdefined( ent.targetname ) && ent.targetname == "intelligence_item" );
if( isIntelItem )
continue;
foreach( f in check_arr )
{
if( ent [[ f ]]() )
{
if(should_notify_before_delete)
ent notify("delete");
ent delete();
}
}
}
}
type_spawners()
{
if ( !isdefined( self.code_classname ) )
return false;
return isSubStr( self.code_classname, "actor_" );
}
type_vehicle()
{
if ( !isdefined( self.code_classname ) )
return false;
if ( self.code_classname == "script_vehicle_collmap" )
return false;
return isSubStr( self.code_classname, "script_vehicle" );
}
type_spawn_trigger()
{
if ( !isdefined( self.classname ) )
return false;
if ( self.classname == "trigger_multiple_spawn" )
return true;
if ( self.classname == "trigger_multiple_spawn_reinforcement" )
return true;
if ( self.classname == "trigger_multiple_friendly_respawn" )
return true;
if ( isdefined( self.targetname ) && self.targetname == "flood_spawner" )
return true;
if ( isdefined( self.targetname ) && self.targetname == "friendly_respawn_trigger" )
return true;
if ( isdefined( self.spawnflags ) && self.spawnflags & 32 )
return true;
return false;
}
type_trigger()
{
if ( !isdefined( self.code_classname ) )
return false;
array = [];
array[ "trigger_multiple" ]	= 1;
array[ "trigger_once" ] = 1;
array[ "trigger_use" ] = 1;
array[ "trigger_radius" ]	= 1;
array[ "trigger_lookat" ]	= 1;
array[ "trigger_disk" ] = 1;
array[ "trigger_damage" ]	= 1;
return isdefined( array[ self.code_classname ] );
}
type_flag_trigger()
{
if ( !IsDefined( self.classname ) )
{
return false;
}
array = [];
array[ "trigger_multiple_flag_set" ] = 1;
array[ "trigger_multiple_flag_set_touching" ]	= 1;
array[ "trigger_multiple_flag_clear" ] = 1;
array[ "trigger_multiple_flag_looking" ] = 1;
array[ "trigger_multiple_flag_lookat" ] = 1;
return IsDefined( array[ self.classname ] );
}
type_killspawner_trigger()
{
if( !self type_trigger() )
{
return false;
}
if( IsDefined( self.script_killspawner ) )
{
return true;
}
return false;
}
type_goalvolume()
{
if( !IsDefined( self.classname ) )
{
return false;
}
if( self.classname == "info_volume" && IsDefined( self.script_goalvolume ) )
{
return true;
}
return false;
}
type_infovolume()
{
if( !IsDefined( self.classname ) )
{
return false;
}
return self.classname == "info_volume";
}
type_turret()
{
if ( !IsDefined( self.classname ) )
{
return false;
}
return self.classname == "misc_turret";
}
type_weapon_placed()
{
if( !IsDefined( self.classname ) || !IsDefined( self.model ) )
{
return false;
}
if( StrTok( self.classname, "_" )[ 0 ] == "weapon" )
{
return true;
}
return false;
}
so_delete_all_spawntriggers()
{
so_delete_all_by_type( ::type_spawn_trigger );
}
so_delete_all_triggers()
{
so_delete_all_by_type( ::type_trigger, ::type_spawn_trigger, ::type_flag_trigger, ::type_killspawner_trigger );
animscripts\battlechatter::update_bcs_locations();
}
so_delete_all_vehicles()
{
so_delete_all_by_type( ::type_vehicle, undefined, undefined, undefined, undefined, true );
}
so_delete_all_spawners()
{
so_delete_all_by_type( ::type_spawners );
}
so_make_specialops_ent( key, value, include_linked_ents )
{
ents = getentarray( key, value );
so_array_make_specialops( ents, include_linked_ents );
}
so_make_bcslocations_specialops_ent()
{
so_array_make_specialops( anim.bcs_locations );
}
so_array_make_specialops( array, include_linked_ents )
{
if ( !isdefined( include_linked_ents ) )
include_linked_ents = false;
level.so_traversed_list = [];
so_make_specialops_ent_internal( array, include_linked_ents );
level.so_traversed_list = undefined;
}
so_make_specialops_ent_internal( ents, include_linked_ents )
{
AssertEx( isdefined( level.so_traversed_list ), "level.so_traversed_list is undefined! You should not be using this function, use so_array_make_specialops instead!" );
foreach ( ent in ents )
{
if ( array_contains( level.so_traversed_list, ent ) )
continue;
level.so_traversed_list[ level.so_traversed_list.size ] = ent;
ent.script_specialops = 1;
if ( include_linked_ents )
{
if ( isdefined( ent.target ) )
{
attached = getentarray( ent.target, "targetname" );
so_make_specialops_ent_internal( attached, include_linked_ents );
}
if ( isdefined( ent.linkTo ) )
{
attached = ent get_linked_ents();
so_make_specialops_ent_internal( attached, include_linked_ents );
}
}
}
}
so_delete_breach_ents()
{
breach_solids = getentarray( "breach_solid", "targetname" );
foreach( ent in breach_solids )
{
ent connectPaths();
ent delete();
}
}
so_force_deadquote( quote, icon_dvar )
{
assertex( isdefined( quote ), "so_force_deadquote() requires a valid quote to be passed in." );
level.so_deadquotes = [];
level.so_deadquotes[ 0 ] = quote;
level.so_deadquotes_chance = 1.0;
so_special_failure_hint_reset_dvars( icon_dvar );
}
so_force_deadquote_array( quotes, icon_dvar )
{
assertex( isdefined( quotes ), "so_force_deadquote_array() requires a valid quote array to be passed in." );
level.so_deadquotes = quotes;
level.so_deadquotes_chance = 1.0;
so_special_failure_hint_reset_dvars( icon_dvar );
}
so_include_deadquote_array( quotes )
{
assertex( isdefined( quotes ), "so_include_deadquote_array() requires a valid quote array to be passed in." );
if ( !isdefined( level.so_deadquotes ) )
level.so_deadquotes = [];
level.so_deadquotes = array_merge( level.so_deadquotes , quotes );
}
so_create_hud_item( yLine, xOffset, message, player, always_draw )
{
if ( isdefined( player ) )
assertex( isplayer( player ), "so_create_hud_item() received a value for player that did not pass the isplayer() check." );
if ( !isdefined( yLine ) )
yLine = 0;
if ( !isdefined( xOffset ) )
xOffset = 0;
yLine += 2;
hudelem = undefined;
if ( isdefined( player ) )
hudelem = newClientHudElem( player );
else
hudelem = newHudElem();
hudelem.alignX = "right";
hudelem.alignY = "middle";
hudelem.horzAlign = "right";
hudelem.vertAlign = "middle";
hudelem.x = xOffset;
hudelem.y = -100 + ( 15 * yLine );
hudelem.font = "hudsmall";
hudelem.foreground = 1;
hudelem.hidewheninmenu = true;
hudelem.hidewhendead = true;
hudelem.sort = 2;
hudelem set_hud_white();
if ( isdefined( message ) )
hudelem.label = message;
if ( !isdefined( always_draw ) || !always_draw )
{
if ( isdefined( player ) )
{
if ( !player so_hud_can_show() )
player thread so_create_hud_item_delay_draw( hudelem );
else
{
if ( !self ent_flag( "so_hud_can_toggle" ) )
self ent_flag_set( "so_hud_can_toggle" );
}
}
}
return hudelem;
}
so_create_hud_item_data( yLine, xOffset, message, player, always_draw )
{
hudelem = so_create_hud_item( yLine, xOffset, message, player, always_draw );
hudelem.alignX = "left";
return hudelem;
}
so_create_hud_item_debug( yLine, xOffset, message, player, always_draw )
{
hudelem = so_create_hud_item( yLine, xOffset, message, player, always_draw );
hudelem.alignX = "left";
hudelem.horzAlign = "left";
return hudelem;
}
so_hud_pulse_create( new_value )
{
if ( !so_hud_pulse_init() )
return;
self notify( "update_hud_pulse" );
self endon( "update_hud_pulse" );
self endon( "destroying" );
if ( isdefined( new_value ) )
self.label = new_value;
if ( isdefined( self.pulse_sound ) )
level.player PlaySound( self.pulse_sound );
if ( isdefined( self.pulse_loop ) && self.pulse_loop )
so_hud_pulse_loop();
else
so_hud_pulse_single( self.pulse_scale_big, self.pulse_scale_normal, self.pulse_time );
}
so_hud_pulse_stop( new_value )
{
if ( !so_hud_pulse_init() )
return;
self notify( "update_hud_pulse" );
self endon( "update_hud_pulse" );
self endon( "destroying" );
if ( isdefined( new_value ) )
self.label = new_value;
self.pulse_loop = false;
so_hud_pulse_single( self.fontscale, self.pulse_scale_normal, self.pulse_time );
}
so_hud_pulse_default( new_value )
{
set_hud_white();
self.pulse_loop = false;
so_hud_pulse_create( new_value );
}
so_hud_pulse_close( new_value )
{
set_hud_green();
self.pulse_loop = true;
so_hud_pulse_create( new_value );
}
so_hud_pulse_success( new_value )
{
set_hud_green();
self.pulse_loop = false;
so_hud_pulse_create( new_value );
}
so_hud_pulse_warning( new_value )
{
set_hud_yellow();
self.pulse_loop = false;
so_hud_pulse_create( new_value );
}
so_hud_pulse_alarm( new_value )
{
set_hud_red();
self.pulse_loop = true;
so_hud_pulse_create( new_value );
}
so_hud_pulse_failure( new_value )
{
set_hud_red();
self.pulse_loop = false;
so_hud_pulse_create( new_value );
}
so_hud_pulse_disabled( new_value )
{
set_hud_grey();
self.pulse_loop = false;
so_hud_pulse_create( new_value );
}
so_hud_pulse_smart( test_value, new_value )
{
if ( !isdefined( self.pulse_bounds ) )
{
self so_hud_pulse_default( new_value );
return;
}
foreach ( i, bound in self.pulse_bounds )
{
if ( test_value <= bound )
{
switch ( i )
{
case "pulse_disabled" :	self so_hud_pulse_disabled( new_value );return;
case "pulse_failure" :	self so_hud_pulse_failure( new_value );	return;
case "pulse_alarm" :	self so_hud_pulse_alarm( new_value );	return;
case "pulse_warning" :	self so_hud_pulse_warning( new_value );	return;
case "pulse_default" :	self so_hud_pulse_default( new_value );	return;
case "pulse_close" :	self so_hud_pulse_close( new_value );	return;
case "pulse_success" :	self so_hud_pulse_success( new_value );	return;
}
}
}
self so_hud_pulse_default( new_value );
}
so_hud_ypos()
{
return -72;
}
so_remove_hud_item( destroy_immediately, decay_immediately )
{
if ( isdefined( destroy_immediately ) && destroy_immediately )
{
self notify( "destroying" );
self Destroy();
return;
}
self thread so_hud_pulse_stop();
if ( isdefined( decay_immediately ) && decay_immediately )
{
self SetPulseFX( 0, 0, 500 );
wait( 0.5 );
}
else
{
self SetPulseFX( 0, 1500, 500 );
wait( 2 );
}
self notify( "destroying" );
self Destroy();
}
set_hud_white( new_alpha )
{
if ( isdefined( new_alpha ) )
{
self.alpha = new_alpha;
self.glowAlpha = new_alpha;
}
self.color = ( 1, 1, 1 );
self.glowcolor = ( 0.6, 0.6, 0.6 );
}
set_hud_blue( new_alpha )
{
if ( isdefined( new_alpha ) )
{
self.alpha = new_alpha;
self.glowAlpha = new_alpha;
}
self.color = ( 0.8, 0.8, 1 );
self.glowcolor = ( 0.301961, 0.301961, 0.6 );
}
set_hud_green( new_alpha )
{
if ( isdefined( new_alpha ) )
{
self.alpha = new_alpha;
self.glowAlpha = new_alpha;
}
self.color = ( 0.8, 1, 0.8 );
self.glowcolor = ( 0.301961, 0.6, 0.301961 );
}
set_hud_yellow( new_alpha )
{
if ( isdefined( new_alpha ) )
{
self.alpha = new_alpha;
self.glowAlpha = new_alpha;
}
self.color = ( 1, 1, 0.5 );
self.glowcolor = ( 0.7, 0.7, 0.2 );
}
set_hud_red( new_alpha )
{
if ( isdefined( new_alpha ) )
{
self.alpha = new_alpha;
self.glowAlpha = new_alpha;
}
self.color = ( 1, 0.4, 0.4 );
self.glowcolor = ( 0.7, 0.2, 0.2 );
}
set_hud_grey( new_alpha )
{
if ( isdefined( new_alpha ) )
{
self.alpha = new_alpha;
self.glowAlpha = new_alpha;
}
self.color = ( 0.4, 0.4, 0.4 );
self.glowcolor = ( 0.2, 0.2, 0.2 );
}
info_hud_wait_for_player( endon_notify )
{
assertex( isplayer( self ), "info_hud_wait_for_player() must be called on a player." );
if ( isdefined( self.so_infohud_toggle_state ) )
return;
level endon( "challenge_timer_expired" );
level endon( "challenge_timer_passed" );
level endon( "special_op_terminated" );
self endon( "death" );
if ( isdefined( endon_notify ) )
level endon( endon_notify );
self setWeaponHudIconOverride( "actionslot1", "hud_show_timer" );
notifyoncommand( "toggle_challenge_timer", "+actionslot 1" );
self.so_infohud_toggle_state = info_hud_start_state();
if ( !so_hud_can_show() )
{
thread info_hud_wait_force_on();
self ent_flag_wait( "so_hud_can_toggle" );
}
self notify( "so_hud_toggle_available" );
while ( 1 )
{
self waittill( "toggle_challenge_timer" );
switch( self.so_infohud_toggle_state )
{
case "on":
self.so_infohud_toggle_state = "off";
setdvar( "so_ophud_" + self.unique_id, "0" );
break;
case "off":
self.so_infohud_toggle_state = "on";
setdvar( "so_ophud_" + self.unique_id, "1" );
break;
}
self notify( "update_challenge_timer" );
}
}
info_hud_wait_force_on()
{
self endon( "so_hud_toggle_available" );
notifyoncommand( "force_challenge_timer", "+actionslot 1" );
self waittill( "force_challenge_timer" );
self.so_hud_show_time = gettime();
self.so_infohud_toggle_state = "on";
setdvar( "so_ophud_" + self.unique_id, "1" );
}
info_hud_start_state()
{
if ( getdvarint( "so_ophud_" + self.unique_id ) == 1 )
{
self.so_hud_show_time = gettime() + 1000;
return "on";
}
if ( isdefined( level.challenge_time_limit ) )
return "on";
if ( isdefined( level.challenge_time_force_on ) && level.challenge_time_force_on )
return "on";
return "off";
}
info_hud_handle_fade( hudelem, endon_notify )
{
assertex( isplayer( self ), "info_hud_handle_fade() must be called on a player." );
assertex( isdefined( hudelem ), "info_hud_handle_fade() requires a valid hudelem to be passed in." );
level endon( "new_challenge_timer" );
level endon( "challenge_timer_expired" );
level endon( "challenge_timer_passed" );
level endon( "special_op_terminated" );
self endon( "death" );
if ( isdefined( endon_notify ) )
level endon( endon_notify );
hudelem.so_can_toggle = true;
self ent_flag_wait( "so_hud_can_toggle" );
info_hud_update_alpha( hudelem );
while( 1 )
{
self waittill( "update_challenge_timer" );
hudelem FadeOverTime( 0.25 );
info_hud_update_alpha( hudelem );
}
}
info_hud_update_alpha( hudelem )
{
switch( self.so_infohud_toggle_state )
{
case "on":	hudelem.alpha = 1;	break;
case "off":	hudelem.alpha = 0;	break;
}
}
info_hud_decrement_timer( time )
{
if ( !IsDefined( level.challenge_time_limit ) )
{
return;
}
if ( flag( "challenge_timer_expired" ) || flag( "challenge_timer_passed" ) )
{
return;
}
level.so_challenge_time_left -= time;
if ( level.so_challenge_time_left < 0 )
{
level.so_challenge_time_left = 0.01;
}
red = ( 0.6, 0.2, 0.2 );
red_glow = ( 0.4, 0.1, 0.1 );
foreach ( player in level.players )
{
player.hud_so_timer_time SetTenthsTimer( level.so_challenge_time_left );
}
thread challenge_timer_thread();
}
is_dvar_character_switcher( dvar )
{
val = getdvar( dvar );
return val == "so_char_client" || val == "so_char_host";
}
has_been_played()
{
best_time_name = tablelookup( "sp/specOpsTable.csv", 1, level.script, 9 );
if ( best_time_name == "" )
return false;
foreach( player in level.players )
{
current_best_time = player GetLocalPlayerProfileData( best_time_name );
if ( !isdefined( current_best_time ) )
continue;
if ( current_best_time != 0 )
return true;
}
return false;
}
is_best_wave( wave )
{
return false;
}
is_best_time( time_start, time_current, time_frac )
{
if ( !isdefined( time_start ) )
{
if ( isdefined( level.challenge_start_time ) )
time_start = level.challenge_start_time;
else
time_start = 300;
}
if ( !isdefined( time_current ) )
time_current = gettime();
if ( !isdefined( time_frac ) )
time_frac = 0.0;
m_seconds = ( time_current - time_start );
m_seconds = int( min( m_seconds, 86400000 ) );
best_time_name = tablelookup( "sp/specOpsTable.csv", 1, level.script, 9 );
if ( best_time_name == "" )
return false;
foreach( player in level.players )
{
current_best_time = player GetLocalPlayerProfileData( best_time_name );
if ( !isdefined( current_best_time ) )
continue;
never_played = ( current_best_time == 0 );
if ( never_played )
continue;
current_best_time -= ( current_best_time * time_frac );
if ( m_seconds < current_best_time )
return true;
}
return false;
}
is_poor_time( time_start, time_current, time_frac )
{
if ( !isdefined( time_start ) )
{
if ( isdefined( level.challenge_start_time ) )
time_start = level.challenge_start_time;
else
time_start = 300;
}
if ( !isdefined( time_current ) )
time_current = gettime();
if ( !isdefined( time_frac ) )
time_frac = 0.0;
m_seconds = ( time_current - time_start );
m_time_limit = ( level.challenge_time_limit * 1000 );
m_time_limit -= ( m_time_limit * time_frac );
return ( m_seconds > m_time_limit );
}
so_dialog_ready_up()
{
if ( isdefined( level.so_dialog_func_override[ "ready_up" ] ) )
{
[[ level.so_dialog_func_override[ "ready_up" ] ]]();
return;
}
so_dialog_play( "so_tf_1_plyr_prep", 0, true );
}
so_dialog_mission_success( do_sarcasm )
{
if ( !is_survival() && is_best_time( level.challenge_start_time, level.challenge_end_time ) )
{
if ( isdefined( level.so_dialog_func_override[ "success_best" ] ) )
{
thread [[ level.so_dialog_func_override[ "success_best" ] ]]();
return;
}
thread so_dialog_play( "so_tf_1_success_best", 0.5, true );
return;
}
if ( !isdefined( do_sarcasm ) )
{
do_sarcasm = false;
if ( level.gameSkill >= 3 )
{
if ( has_been_played() )
do_sarcasm = cointoss();
}
}
if ( isdefined( level.so_dialog_func_override[ "success_generic" ] ) )
{
[[ level.so_dialog_func_override[ "success_generic" ] ]](do_sarcasm);
return;
}
if ( do_sarcasm )
so_dialog_play( "so_tf_1_success_jerk", 0.5, true );
else
so_dialog_play( "so_tf_1_success_generic", 0.5, true );
}
so_dialog_mission_failed( sound_alias )
{
assertex( isdefined( sound_alias ), "so_dialog_mission_failed() requires a valid sound_alias." );
if ( isdefined( level.failed_dialog_played ) && level.failed_dialog_played )
return;
level.failed_dialog_played = true;
so_dialog_play( sound_alias, 0.5, true );
}
so_dialog_mission_failed_generic()
{
if ( isdefined( level.so_dialog_func_override[ "failed_generic" ] ) )
{
[[ level.so_dialog_func_override[ "failed_generic" ] ]]();
return;
}
if ( ( level.gameskill <= 2 ) || cointoss() )
so_dialog_mission_failed( "so_tf_1_fail_generic" );
else
so_dialog_mission_failed( "so_tf_1_fail_generic_jerk" );
}
so_dialog_mission_failed_time()
{
if ( isdefined( level.so_dialog_func_override[ "failed_time" ] ) )
{
[[ level.so_dialog_func_override[ "failed_time" ] ]]();
return;
}
so_dialog_mission_failed( "so_tf_1_fail_time" );
}
so_dialog_mission_failed_bleedout()
{
if ( isdefined( level.so_dialog_func_override[ "failed_bleedout" ] ) )
{
[[ level.so_dialog_func_override[ "failed_bleedout" ] ]]();
return;
}
so_dialog_mission_failed( "so_tf_1_fail_bleedout" );
}
so_dialog_time_low_normal()
{
if ( isdefined( level.so_dialog_func_override[ "time_low_normal" ] ) )
{
[[ level.so_dialog_func_override[ "time_low_normal" ] ]]();
return;
}
so_dialog_play( "so_tf_1_time_generic" );
}
so_dialog_time_low_hurry()
{
if ( isdefined( level.so_dialog_func_override[ "time_low_hurry" ] ) )
{
[[ level.so_dialog_func_override[ "time_low_hurry" ] ]]();
return;
}
so_dialog_play( "so_tf_1_time_hurry" );
}
so_dialog_killing_civilians()
{
if ( !isdefined( level.civilian_warning_time ) )
{
level.civilian_warning_time = gettime();
if ( !isdefined( level.civilian_warning_throttle ) )
level.civilian_warning_throttle = 5000;
}
else
{
if ( ( gettime() - level.civilian_warning_time ) < level.civilian_warning_throttle )
return;
}
wait_time = 0.5;
level.civilian_warning_time = gettime() + ( wait_time * 1000 );
if ( isdefined( level.so_dialog_func_override[ "killing_civilians" ] ) )
{
[[ level.so_dialog_func_override[ "killing_civilians" ] ]]();
return;
}
so_dialog_play( "so_tf_1_civ_kill_warning", 0.5 );
}
so_dialog_progress_update( current_value, current_goal )
{
if ( !isdefined( current_value ) )
return;
if ( !isdefined( current_goal ) )
return;
if ( !isdefined( level.so_progress_goal_status ) )
level.so_progress_goal_status = "none";
time_frac = undefined;
switch ( level.so_progress_goal_status )
{
case "none": time_frac = 0.75;	break;
case "3quarter":	time_frac = 0.5;	break;
case "half": time_frac = 0.25;	break;
default: return;
}
test_goal = current_goal * time_frac;
if ( current_value > test_goal )
return;
time_dialog = undefined;
switch ( level.so_progress_goal_status )
{
case "none":
level.so_progress_goal_status = "3quarter";
time_dialog = "so_tf_1_progress_3quarter";
break;
case "3quarter":
level.so_progress_goal_status = "half";
time_dialog = "so_tf_1_progress_half";
break;
case "half":
level.so_progress_goal_status = "quarter";
time_dialog = "so_tf_1_progress_quarter";
break;
}
if ( isdefined( level.so_dialog_func_override[ "progress_goal_status" ] ) )
{
[[ level.so_dialog_func_override[ "progress_goal_status" ] ]]();
return;
}
so_dialog_play( time_dialog, 0.5 );
}
so_dialog_progress_update_time_quality( time_frac )
{
if ( isdefined( level.challenge_time_limit ) )
{
if ( is_poor_time( level.challenge_start_time, gettime(), time_frac ) )
{
if ( isdefined( level.so_dialog_func_override[ "time_status_late" ] ) )
{
[[ level.so_dialog_func_override[ "time_status_late" ] ]]();
return;
}
so_dialog_play( "so_tf_1_time_status_late", 0.2 );
return;
}
}
if ( is_best_time( level.challenge_start_time, gettime(), time_frac ) )
{
if ( isdefined( level.so_dialog_func_override[ "time_status_good" ] ) )
{
[[ level.so_dialog_func_override[ "time_status_good" ] ]]();
return;
}
so_dialog_play( "so_tf_1_time_status_good", 0.2 );
}
}
so_dialog_counter_update( current_count, current_goal, countdown_divide )
{
if ( !isdefined( level.so_counter_dialog_time ) )
level.so_counter_dialog_time = 0;
if ( gettime() < level.so_counter_dialog_time )
return;
if ( !isdefined( current_count ) )
return;
if ( !isdefined( countdown_divide ) )
countdown_divide = 1;
adjusted_count = int( current_count / countdown_divide );
if ( adjusted_count > 5 )
{
if ( !isdefined( level.challenge_progress_manual_update ) || !level.challenge_progress_manual_update )
{
thread so_dialog_progress_update( current_count, current_goal );
level.so_counter_dialog_time = gettime() + 800;
}
return;
}
if ( isdefined( level.so_dialog_func_override[ "progress" ] ) )
{
thread [[ level.so_dialog_func_override[ "progress" ] ]](adjusted_count);
}
else
{
switch( adjusted_count )
{
case 5: thread so_dialog_play( "so_tf_1_progress_5more", 0.5 );	break;
case 4: thread so_dialog_play( "so_tf_1_progress_4more", 0.5 );	break;
case 3: thread so_dialog_play( "so_tf_1_progress_3more", 0.5 );	break;
case 2: thread so_dialog_play( "so_tf_1_progress_2more", 0.5 );	break;
case 1: thread so_dialog_play( "so_tf_1_progress_1more", 0.5 );	break;
}
}
level.so_counter_dialog_time = gettime() + 800;
}
so_crush_player( player, mod )
{
assert( isdefined( self ) );
assert( isdefined( player ) );
if ( !IsDefined( player.coop_death_reason ) )
{
player.coop_death_reason = [];
}
if ( !IsDefined( mod ) )
{
mod = "MOD_EXPLOSIVE";
}
player.coop_death_reason[ "attacker" ] = self;
player.coop_death_reason[ "cause" ] = mod;
player.coop_death_reason[ "weapon_name" ] = "none";
player kill_wrapper();
}
get_previously_completed_difficulty()
{
AssertEx( IsDefined( self ) && IsPlayer( self ), "Self must be player to get completed difficulty." );
levelIndex = level.specOpsSettings maps\_endmission::getLevelIndex( level.script );
difficulty = Int( ( self GetLocalPlayerProfileData( "missionSOHighestDifficulty" ))[ levelIndex ] );
difficulty = Int( max( 0, difficulty ) );
return difficulty;
}
so_hud_stars_precache()
{
PreCacheShader( "difficulty_star" );
}
so_hud_stars_init( flag_start, flag_end, time_regular, time_hard, time_veteran, line_index )
{
AssertEx( IsDefined( self ) && IsPlayer( self ), "Self must be a player." );
AssertEx( IsDefined( time_regular ) && IsDefined( time_hard ) && IsDefined( time_veteran ), "All difficulty times must be defined." );
level.race_times = [];
level.race_times[ "regular" ]	= time_regular;
level.race_times[ "hardened" ]	= time_hard;
level.race_times[ "veteran" ]	= time_veteran;
line_index = ter_op( IsDefined( line_index ), line_index, 4 );
self.stars_removed = [];
self thread so_hud_stars_single_think( flag_start, flag_end, 0, level.race_times[ "regular" ], "regular", line_index );
self thread so_hud_stars_single_think( flag_start, flag_end, 1, level.race_times[ "hardened" ], "hardened", line_index );
self thread so_hud_stars_single_think( flag_start, flag_end, 2, level.race_times[ "veteran" ], "veteran", line_index );
}
so_hud_stars_single_think( flag_start, flag_end, x_pos_offset, time_remove, difficulty, line_index )
{
AssertEx( IsDefined( flag_start ) && flag_exist( flag_start ), "Challenge start flag doesn't exist: " + flag_start );
AssertEx( IsDefined( flag_end ) && flag_exist( flag_end ), "Challenge end flag doesn't exist: " + flag_end );
AssertEx( IsDefined( x_pos_offset ), "X offset undefined." );
AssertEx( IsDefined( time_remove ), "Time before star item expires undefined." );
level endon( "special_op_terminated" );
level endon( flag_end );
if ( !IsDefined( self.so_hud_star_count ) )
{
self.so_hud_star_count = 0;
}
self.so_hud_star_count++;
star_width = 25;
ypos = so_hud_ypos();
star = so_create_hud_item( line_index, ypos, undefined, self );
star.x -= ( x_pos_offset * star_width ) - 30;
star.y += 5;
star SetShader( "difficulty_star", 25, 25 );
flag_wait( flag_start );
self thread so_hud_stars_single_force_alpha_end( star, flag_end );
if ( time_remove < 0 )
{
return;
}
self thread so_hud_stars_sound_and_flash( star, time_remove, flag_end );
level waittill_any_timeout( time_remove, "star_hud_remove_" + difficulty );
waittillframeend;
if ( flag( flag_end ) )
{
return;
}
self.so_hud_star_count--;
star Destroy();
}
so_hud_stars_remove( difficulty )
{
foreach ( player in level.players )
{
AssertEx( IsDefined( player.stars_removed ), "Stars removed array should have been initialized in so_hud_stars_init()." );
if ( !IsDefined( difficulty ) )
{
if ( !IsDefined( player.stars_removed[ "veteran" ] ) )
{
difficulty = "veteran";
}
else if ( !IsDefined( player.stars_removed[ "hardened" ] ) )
{
difficulty = "hardened";
}
else if ( !IsDefined( player.stars_removed[ "regular" ] ) )
{
difficulty = "regular";
}
}
if ( IsDefined( player.stars_removed[ difficulty ] ) )
{
return;
}
if	(
difficulty == "hardened"
&&	!IsDefined( player.stars_removed[ "veteran" ] )
)
{
Assert( "Star for difficulty " + difficulty + " should not be removed before veteran" );
return;
}
else if
(
difficulty == "regular"
&&	( !IsDefined( player.stars_removed[ "veteran" ] ) || !IsDefined( player.stars_removed[ "hardened" ] ) )
)
{
Assert( "Star for difficulty " + difficulty + " should not be removed before veteran or hardened" );
return;
}
player.stars_removed[ difficulty ] = 1;
level notify( "star_hud_remove_" + difficulty );
}
}
so_hud_stars_validate_difficulty( difficulty )
{
AssertEx( IsDefined( difficulty ), "Difficulty must be defined." );
switch( difficulty )
{
case "regular":
case "hardened":
case "veteran":
break;
default:
Assert( "Invalid difficulty parameter: " + difficulty + ". Must be regular, hardened or veteran." );
break;
}
}
so_hud_stars_sound_and_flash( star, time_remove, flag_end )
{
star endon( "death" );
level endon( flag_end );
level endon( "special_op_terminated" );
seconds_to_tick = 5;
seconds_before_tick = time_remove - seconds_to_tick;
Assert( seconds_before_tick > 0 );
wait( seconds_before_tick );
for ( i = 0; i < seconds_to_tick; i++ )
{
self PlayLocalSound( "star_tick" );
star.alpha = 1;
wait( 0.5 );
star.alpha = 0.3;
wait( 0.5 );
}
self PlayLocalSound( "star_lost" );
}
so_hud_stars_single_force_alpha_end( star, flag_end )
{
star endon( "death" );
flag_wait( flag_end );
waittillframeend;
star.alpha = 1;
}
Unlock_hint()
{
wait 0.05;
foreach( player in level.players )
player thread Unlock_hint_think();
}
Unlock_hint_think()
{
self surHUD_disable( "unlock" );
for( index=0; index<3; index++ )
self unlock_hint_reset( index );
while ( 1 )
{
self waittill( "update_rank" );
waittillframeend;
if ( !isdefined( self ) )
return;
player_rank = self maps\_rank::getRank();
assertex( isdefined( level.unlock_array ), "unlockable array setup failed" );
assertex( level.unlock_array.size > 0, "no unlockables registered, call: maps\_so_survival::unlock_register( ref, lvl, name, icon )" );
unlockable_array = level.unlock_array[ player_rank ];
if ( isdefined( unlockable_array ) )
{
for( index=0; index<3; index++ )
{
unlockable = unlockable_array[ index ];
if ( isdefined( unlockable ) )
{
self register_recent_unlock( unlockable );
self _setplayerdata_array( "surHUD_unlock_hint_" + index, "name", unlockable.name );
self _setplayerdata_array( "surHUD_unlock_hint_" + index, "icon", unlockable.icon );
self _setplayerdata_array( "surHUD_unlock_hint_" + index, "mode", unlockable.mode );
}
else
{
self unlock_hint_reset( index );
}
}
self surHUD_animate( "unlock" );
}
}
}
register_recent_unlock( unlock_struct )
{
assertex( isdefined( unlock_struct.name ), "Unlocked item is missing name." );
assertex( isdefined( unlock_struct.ref ), "Unlocked item is missing reference string." );
if ( !unlock_struct.feature )
{
item_type = tablelookup( "sp/survival_armories.csv", 1, unlock_struct.ref, 2 );
item_width_ratio = int( 1 + ( item_type == "weapon" ) );
item_icon = tablelookup( "sp/survival_armories.csv", 1, unlock_struct.ref, 6 );
item_desc = unlock_struct.desc;
self pass_recent_item_unlock( "recent_item_2", "recent_item_3" );
self pass_recent_item_unlock( "recent_item_1", "recent_item_2" );
self _setplayerdata_array( "recent_item_1", "name", unlock_struct.name );
self _setplayerdata_array( "recent_item_1", "icon", item_icon );
self _setplayerdata_array( "recent_item_1", "desc", item_desc );
self _setplayerdata_array( "recent_item_1", "icon_width_ratio", item_width_ratio );
}
else
{
feature_name = self getplayerdata( "recent_feature_1", "name" );
self _setplayerdata_array( "recent_feature_2", "name", feature_name );
self _setplayerdata_array( "recent_feature_1", "name", unlock_struct.name );
}
}
pass_recent_item_unlock( from, to )
{
item_name = self getplayerdata( from, "name" );
item_desc = self getplayerdata( from, "desc" );
item_icon = self getplayerdata( from, "icon" );
item_icon_width_ratio = self getplayerdata( from, "icon_width_ratio" );
self _setplayerdata_array( to, "name", item_name );
self _setplayerdata_array( to, "desc", item_desc );
self _setplayerdata_array( to, "icon", item_icon );
self _setplayerdata_array( to, "icon_width_ratio", item_icon_width_ratio );
}
unlock_hint_reset( index )
{
self _setplayerdata_array( "surHUD_unlock_hint_" + index, "name", "" );
self _setplayerdata_array( "surHUD_unlock_hint_" + index, "icon", "" );
self _setplayerdata_array( "surHUD_unlock_hint_" + index, "mode", "" );
}
surHUD_animate( ref )
{
level endon( "special_op_terminated" );
self endon( "stop_animate_" + ref );
self thread surHUD_animate_endon_clear( "stop_animate_" + ref );
if ( !isdefined( self.surHUD_busy ) )
self.surHUD_busy = false;
while ( self.surHUD_busy )
wait 0.05;
self.surHUD_busy = true;
if ( !surHUD_is_enabled( ref ) )
self surHUD_enable( ref );
self _setplayerdata_single( "surHUD_set_animate", ref );
wait 0.05;
self openmenu( "surHUD_display" );
wait 0.05;
self.surHUD_busy = false;
self notify( "surHUD_free" );
}
surHUD_animate_endon_clear( msg )
{
self endon( "surHUD_free" );
self waittill( msg );
self.surHUD_busy = false;
}
surHUD_challenge_label( slot, value )
{
if ( isdefined( self ) )
self _setplayerdata_array( "surHUD_challenge_label", "slot_" + slot, value );
}
surHUD_challenge_progress( slot, value )
{
if ( isdefined( self ) )
self _setplayerdata_array( "surHUD_challenge_progress", "slot_" + slot, value );
}
surHUD_challenge_reward( slot, value )
{
if ( isdefined( self ) )
self _setplayerdata_array( "surHUD_challenge_reward", "slot_" + slot, value );
}
surHUD_is_enabled( ref )
{
if ( isdefined( self ) && self getplayerdata( "surHUD", ref ) )
return true;
return false;
}
surHUD_enable( ref )
{
if ( isdefined( self ) )
self _setplayerdata_array( "surHUD", ref, 1 );
}
surHUD_disable( ref )
{
if ( isdefined( self ) )
self _setplayerdata_array( "surHUD", ref, 0 );
}
_setplayerdata_single( data_name, value )
{
self setplayerdata( data_name, value );
}
_setplayerdata_array( data_name, data_index, value )
{
self setplayerdata( data_name, data_index, value );
}
so_achievement_init()
{
wait 0.05;
foreach( player in level.players )
player thread so_achievement_reset();
}
so_achievement_reset()
{
if ( !isdefined( self.achievement_completed ) )
self.achievement_completed = [];
self.achievement_completed[ "ARMS_DEALER" ] = 0;
self.achievement_completed[ "DANGER_ZONE" ] = 0;
self.achievement_completed[ "DEFENSE_SPENDING" ] = 0;
self.achievement_completed[ "SURVIVOR" ] = 0;
self.achievement_completed[ "UNSTOPPABLE" ] = 0;
}
so_achievement_update( achievement_string, extra_arg )
{
if ( is_survival() )
{
switch ( achievement_string )
{
case "ARMS_DEALER":
case "DEFENSE_SPENDING":
case "DANGER_ZONE":
self thread so_achievement_item_collection( achievement_string, extra_arg );
return;
case "SURVIVOR":
self thread so_achievement_wave_count( achievement_string, 9 );
return;
case "UNSTOPPABLE":
self thread so_achievement_wave_count( achievement_string, 14 );
return;
case "I_LIVE":
case "GET_RICH_OR_DIE_TRYING":
self thread player_giveachievement_wrapper( achievement_string );
return;
}
}
else
{
switch ( achievement_string )
{
case "BRAG_RAGS":
self thread player_giveachievement_wrapper( achievement_string );
return;
case "TACTICIAN":
self thread so_achievement_star_count( achievement_string, 1 );
return;
case "OVERACHIEVER":
self thread so_achievement_star_count( achievement_string, 3 );
return;
}
}
}
so_achievement_item_collection( achievement_string, item_ref )
{
assertex( is_survival(), "SO ACHIEVEMENT: survival achievement function called in non-survival mode." );
if ( self.achievement_completed[ achievement_string ] )
return;
assertex( isdefined( level.armory_all_items ), "SO ACHIEVEMENT: survival mode started without armory items array built" );
assertex( isdefined( level.armory_all_items[ item_ref ] ), "SO ACHIEVEMENT: item does not exist in armory items array" );
item_type = level.armory_all_items[ item_ref ].type;
if ( self getplayerdata( item_type + "_purchased", item_ref ) == 0 )
self setplayerdata( item_type + "_purchased", item_ref, 1 );
else
return;
completed = false;
if ( item_type == "weapon" || item_type == "weaponupgrade" )
completed = self is_purchase_collection_complete( "weapon", "weapon_purchased" ) && self is_purchase_collection_complete( "weaponupgrade", "weaponupgrade_purchased" );
else
completed = self is_purchase_collection_complete( item_type, item_type + "_purchased" );
if ( completed )
{
self player_giveachievement_wrapper( achievement_string );
self.achievement_completed[ achievement_string ] = 1;
}
}
is_purchase_collection_complete( item_type, playerdata_array_string )
{
assertex( isdefined( item_type ) && isdefineD( level.armory[ item_type ] ), "SO ACHIEVEMENT: Armory type or armory does not exist..." );
foreach( item_struct in level.armory[ item_type ] )
{
if ( self getplayerdata( playerdata_array_string, item_struct.ref ) == 0 )
return false;
}
return true;
}
so_achievement_wave_count( achievement_string, count )
{
assertex( is_survival(), "SO ACHIEVEMENT: survival achievement function called in non-survival mode." );
assertex( isdefined( level.specOpsSettings ), "Survival level array not setup." );
if ( self.achievement_completed[ achievement_string ] )
return;
for( i=0; i<16; i++ )
{
assertex( isdefined( level.specOpsSettings.levels[i] ), "Survival level index: " + i +" is out of bound." );
bspname = level.specOpsSettings.levels[i].name;
assertex( isdefined( bspname ), "The map name is not defined inside levels array for spec ops!" );
best_score_var = tablelookup( "sp/specOpsTable.csv", 1, bspname, 9 );
assertex( IsDefined( best_score_var ) && best_score_var != "", "best wave var for this level does not exist!" );
best_wave = int( self GetLocalPlayerProfileData( best_score_var ) / 1000 );
assertex( isdefined( best_wave ), "Best wave is not defined for this player" );
if ( bspname == level.script )
best_wave = level.current_wave;
if ( best_wave < count )
return;
}
self player_giveachievement_wrapper( achievement_string );
self.achievement_completed[ achievement_string ] = 1;
if ( achievement_string == "UNSTOPPABLE" )
{
self setPlayerData( "challengeState", "ch_unstoppable", 2 );
}
}
so_achievement_star_count( achievement_string, count )
{
assertex( !is_survival(), "SO ACHIEVEMENT: SO Mission achievement function called in survival mode." );
assertex( isdefined( level.specOpsSettings ), "Survival level array not setup." );
for( i=16; i<32; i++ )
{
assertex( isdefined( level.specOpsSettings.levels[i] ), "Survival level index: " + i +" is out of bound." );
bspname = level.specOpsSettings.levels[i].name;
assertex( isdefined( bspname ), "The map name is not defined inside levels array for spec ops!" );
stars = Int( ( self GetLocalPlayerProfileData( "missionSOHighestDifficulty" ))[ i ] );
stars = Int( max( 0, stars ) ) - 1;
if ( stars < count )
return;
}
self player_giveachievement_wrapper( achievement_string );
if ( achievement_string == "OVERACHIEVER" )
{
self setPlayerData( "challengeState", "ch_overachiever", 2 );
}
}