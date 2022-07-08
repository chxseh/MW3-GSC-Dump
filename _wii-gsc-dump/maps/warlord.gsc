
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\_stealth_utility;
#include maps\warlord_code;
#include maps\warlord_stealth;
#include maps\warlord_utility;
#include maps\warlord_obj;
#include maps\_shg_common;
main()
{
template_level( "warlord" );
level.friendlyFireDisabled = 0;
level.cosine[ "45" ] = cos( 45 );
level.confrontation_weapon = "fnfiveseven_warlord_end";
setsaveddvar("r_specularcolorscale", 2);
setsaveddvar("sm_sunshadowscale",.8);
PreCacheString( &"VARIABLE_SCOPE_SNIPER_MAG" );
PreCacheString( &"VARIABLE_SCOPE_SNIPER_ZOOM" );
PreCacheString( &"WARLORD_INTROSCREEN_LINE1" );
PreCacheString( &"WARLORD_INTROSCREEN_LINE2" );
PreCacheString( &"WARLORD_INTROSCREEN_LINE3" );
PreCacheString( &"WARLORD_INTROSCREEN_LINE4" );
PreCacheString( &"WARLORD_INTROSCREEN_LINE5" );
PreCacheString( &"WARLORD_OBJ_FOLLOW_PRICE" );
PreCacheString( &"WARLORD_OBJ_COVER_PRICE_AND_SOAP" );
PreCacheString( &"WARLORD_OBJ_MOVE_THROUGH_SHANTY" );
PreCacheString( &"WARLORD_OBJ_COMMANDEER_TECHNICAL" );
PreCacheString( &"WARLORD_OBJ_EVADE_MORTAR_FIRE" );
PreCacheString( &"WARLORD_OBJ_COVER_PRICE" );
PreCacheString( &"WARLORD_OBJ_ENTER_COMPOUND" );
PreCacheString( &"WARLORD_OBJ_DESTROY_TECHNICAL" );
PreCacheString( &"WARLORD_OBJ_CAPTURE_WARLORD" );
PreCacheString( &"WARLORD_OBJ_POINTER_PROTECT" );
PreCacheString( &"WARLORD_OBJ_POINTER_CAPTURE" );
PreCacheString( &"WARLORD_OBJ_POINTER_DESTROY" );
PreCacheString( &"WARLORD_HINT_CROUCH" );
PreCacheString( &"WARLORD_MORTAR_DEATH" );
PreCacheString( &"WARLORD_PRONE_DEATH" );
PreCacheString( &"WARLORD_STEALTH_DEATH" );
PreCacheModel( "viewmodel_m14_ebr" );
PreCacheModel( "projectile_rpg7" );
if( !is_split_level() || is_split_level_part("a") )
{
PreCacheModel( "weapon_truck_m2_50cal_mg_viewmodel" );
PreCacheModel( "com_folding_chair" );
}
PreCacheModel( "accessories_gas_canister_highrez" );
PreCacheModel( "com_crate01" );
PreCacheModel( "afr_pipe_gate_01" );
if( !is_split_level() || is_split_level_part("b") )
{
PreCacheModel( "paris_crowbar_01" );
PreCacheModel( "afr_chem_crate_01" );
}
PreCacheModel( "weapon_machette" );
PreCacheModel( "viewhands_yuri" );
PreCacheModel( "viewhands_player_yuri" );
PreCacheModel( "africa_civ_male_notburned" );
PreCacheModel( "africa_civ_male_burned" );
if( !is_split_level() || is_split_level_part("b") )
{
PreCacheModel( "vehicle_mi17_africa_palette" );
}
PreCacheItem( "ak47_silencer_reflex" );
PreCacheItem( level.confrontation_weapon );
PreCacheItem( "fnfiveseven" );
PreCacheShellshock( "slowview" );
PreCacheRumble( "falling_land" );
PreCacheRumble( "subtle_tank_rumble" );
PreCacheRumble( "viewmodel_small" );
PreCacheRumble( "viewmodel_medium" );
PreCacheRumble( "viewmodel_large" );
if( !geoMode() )
{
if( !is_split_level() || is_split_level_part( "a" ) )
{
add_start( "start_stealth_intro", ::start_stealth_intro, "", ::warlord_stealth_intro );
add_start( "start_log_encounter", ::start_log_encounter, "", ::warlord_log_encounter );
add_start( "start_burn_encounter", ::start_burn_encounter, "", ::warlord_burn_encounter );
add_start( "start_river_big_moment", ::start_river_big_moment, "", ::warlord_river_big_moment );
add_start( "start_infiltration", ::start_infiltration, "", ::warlord_infiltration );
add_start( "start_advance", ::start_advance, "", ::warlord_advance );
add_start( "start_technical", ::start_technical, "", ::warlord_technical );
add_start( "start_mortar_run", ::start_mortar_run, "", ::warlord_mortar_run );
add_start( "start_player_mortar", ::start_player_mortar, "", ::warlord_player_mortar );
}
if( !is_split_level() || is_split_level_part( "b" ) )
{
add_start( "start_assault", ::start_assault, "", ::warlord_assault );
add_start( "start_super_technical", ::start_super_technical, "", ::warlord_super_technical );
add_start( "start_confrontation", ::start_player_breach, "", ::warlord_player_breach );
}
}
maps\warlord_precache::main();
maps\sp_warlord_precache::main();
maps\createart\warlord_art::main();
maps\_load::set_player_viewhand_model( "viewhands_player_yuri" );
flag_init( "allies_spawned" );
flag_init( "play_river_dialogue" );
flag_init( "warlord_advance" );
flag_init( "warlord_technical" );
flag_init( "warlord_mortar_run" );
flag_init( "warlord_player_mortar" );
flag_init( "warlord_assault" );
flag_init( "warlord_protect" );
flag_init( "compound_technical_dead" );
flag_init( "church_breach_complete" );
flag_init( "mortar_technical" );
flag_init( "church_side_door_open" );
flag_init( "river_encounter_done" );
flag_init( "price_past_log" );
flag_init( "price_ready_to_reach_door" );
flag_init( "soap_ready_to_reach_door" );
flag_init( "river_big_moment_stealth_spotted" );
flag_init( "river_encounter_3_begin" );
flag_init( "river_encounter_3_complete" );
flag_init( "river_house_burn_execution_setup" );
flag_init( "river_house_burn_execution" );
flag_init( "river_burn_interrupted" );
flag_init( "jeer_guy_leave" );
flag_init( "price_post_bridge" );
flag_init( "soap_post_bridge" );
flag_init( "end_river_big_moment" );
flag_init( "clean_up_river" );
flag_init( "inf_stealth_spotted" );
flag_init( "start_inf_door_open" );
flag_init( "infiltration_over" );
flag_init( "inf_factory_breach" );
flag_init( "inf_factory_breach_done" );
flag_init( "advance_done" );
flag_init( "technical_combat_door_open" );
flag_init( "delete_destroyed_technicals" );
flag_init( "mortar_timer_done" );
flag_init( "mortar_introduce" );
flag_init( "mortar_fight_shot_2" );
flag_init( "compound_truck_left" );
flag_init( "price_moving_to_pipe" );
flag_init( "wii_assault_run_to_pipe" );
flag_init( "ready_to_open_grate" );
flag_init( "breach_starting" );
flag_init( "river_allies_stand" );
flag_init( "player_show_gun" );
maps\_patrol_anims::main();
maps\warlord_anim::main();
maps\_drone_civilian::init();
maps\_drone_ai::init();
maps\warlord_aud::main();
if(!geoMode())
maps\warlord_fx::main();
maps\_load::main();
maps\_stealth::main();
warlord_stealth_init();
while( geoMode() )
{
wait(10);
}
maps\warlord_vo::main();
add_hint_string( "neck_stab_hint", &"SCRIPT_PLATFORM_OILRIG_HINT_STEALTH_KILL", ::no_neck_stab_hint );
add_hint_string( "crouch_hint", &"WARLORD_HINT_CROUCH", ::no_crouch_hint );
add_hint_string( "crouch_hint_stance", &"WARLORD_HINT_CROUCH_STANCE", ::no_crouch_hint );
add_hint_string( "crouch_hint_toggle", &"WARLORD_HINT_CROUCH_TOGGLE", ::no_crouch_hint );
add_hint_string( "crouch_hint_hold", &"WARLORD_HINT_CROUCH_HOLD", ::no_crouch_hint );
add_hint_string( "prone_hint", &"WARLORD_HINT_PRONE", ::no_prone_hint );
add_hint_string( "prone_hint_stance", &"WARLORD_HINT_PRONE_STANCE", ::no_prone_hint );
add_hint_string( "prone_hint_toggle", &"WARLORD_HINT_PRONE_TOGGLE", ::no_prone_hint );
add_hint_string( "prone_hint_hold", &"WARLORD_HINT_PRONE_HOLD", ::no_prone_hint );
add_hint_string( "switch_hint", &"WARLORD_HINT_WEAPON_SWITCH", ::weapon_switch_hint );
level.hint_binding_map = [];
level.hint_binding_map[ "crouch" ][0] = [ "togglecrouch", "crouch_hint_toggle" ];
level.hint_binding_map[ "crouch" ][1] = [ "+stance", "crouch_hint_stance" ];
level.hint_binding_map[ "crouch" ][2] = [ "gocrouch", "crouch_hint" ];
level.hint_binding_map[ "crouch" ][3] = [ "+movedown", "crouch_hint_hold" ];
level.hint_binding_map[ "crouch" ][4] = [ "+zappermenu", "crouch_hint_stance" ];
level.hint_binding_map[ "prone" ][0] = [ "toggleprone", "prone_hint_toggle" ];
level.hint_binding_map[ "prone" ][1] = [ "+stance", "prone_hint_stance" ];
level.hint_binding_map[ "prone" ][2] = [ "goprone", "prone_hint" ];
level.hint_binding_map[ "prone" ][3] = [ "+prone", "prone_hint_hold" ];
level.hint_binding_map[ "prone" ][4] = [ "+zappermenu", "prone_hint_stance" ];
adjust_exploders();
maps\_weapon_mortar60mm::main(
&"WARLORD_HINT_USE_MORTAR",
32,
41,
9,
5,
448,
200,
15000,
150,
0.4,
256,
3100,
3100,
undefined,
false,
-50,-123,9.3,23.4
);
thread warlord_objectives();
level.variable_scope_weapons = ["m14ebr_scoped_silenced_warlord"];
thread maps\_shg_common::monitorScopeChange();
maps\_compass::setupMiniMap("compass_map_warlord");
manage_bullet_penetrate_triggers();
}
start_stealth_intro()
{
aud_send_msg("start_stealth_intro");
}
warlord_stealth_intro()
{
level.player stealth_warlord();
default_stealth_ranges();
start_allies();
thread river_corpses();
thread warlord_intro_text();
thread river_technicals_encounter();
thread restore_player_run_speed();
}
start_log_encounter()
{
aud_send_msg("start_river_big_moment");
start_point_common( "player_log_start", "price_log_start", "soap_log_start" );
vision_set_fog_changes( "warlord_intro", 0 );
level.player stealth_warlord();
default_alert_duration();
no_detect_corpse_range();
thread river_corpses();
flag_set( "obj_first_follow_price" );
delaythread( 2, ::price_play_log_anims );
delaythread( 4, ::soap_play_log_anims );
}
warlord_log_encounter()
{
thread village_corpse();
thread river_prone_encounter();
}
start_burn_encounter()
{
aud_send_msg("start_river_big_moment");
start_point_common( "player_burn_start", "price_burn_start", "soap_burn_start" );
vision_set_fog_changes( "warlord_intro", 0 );
level.player stealth_warlord();
default_alert_duration();
no_detect_corpse_range();
flag_set( "obj_first_follow_price" );
thread river_corpses();
thread village_corpse();
wait 2;
flag_set( "river_prone_encounter_spawn" );
flag_set( "price_ready_to_reach_door" );
flag_set( "soap_ready_to_reach_door" );
flag_set( "river_house_door_open" );
flag_set( "river_encounter_3_complete" );
}
warlord_burn_encounter()
{
thread river_house_door();
thread river_house_burn_execution();
thread allies_path_to_big_moment();
thread burn_ambient_walk();
}
start_river_big_moment()
{
aud_send_msg("start_river_big_moment");
start_point_common( "player_river_start", "price_river_start", "soap_river_start" );
vision_set_fog_changes( "warlord_intro", 0 );
level.player stealth_warlord();
default_alert_duration();
no_detect_corpse_range();
thread setup_jeer_guys();
flag_set( "obj_first_follow_price" );
delaythread( 2, ::activate_trigger_with_targetname, "trig_path_to_big_moment" );
}
warlord_river_big_moment()
{
SetSavedDvar( "ai_count", 22 );
thread river_big_moment_clip_blocker();
thread river_big_moment();
thread river_big_moment_prone_hint();
thread river_cleanup();
thread prone_patrol_dialogue();
thread inf_encounter_sleeping_guard();
start_infiltration_trigger = GetEnt( "start_infiltration_trigger", "targetname" );
start_infiltration_trigger waittill( "trigger" );
flag_set( "end_river_big_moment" );
wait 0.05;
}
start_point_common( player_start_point, price_start_point, soap_start_point )
{
spawn_allies();
move_player_to_start( player_start_point );
if ( IsDefined( price_start_point ) )
{
level.price move_entity_to_start( price_start_point );
level.price SetGoalPos( drop_to_ground( level.price.origin ) );
}
if ( IsDefined( soap_start_point ) )
{
level.soap move_entity_to_start( soap_start_point );
level.soap SetGoalPos( drop_to_ground( level.soap.origin ) );
}
}
start_point_after_stealth()
{
disable_stealth_system();
level.soap forceUseWeapon( "ak47_reflex", "primary" );
level.price forceUseWeapon( "ak47_reflex", "primary" );
}
switch_sniper_rifle()
{
level.player switch_player_weapon( "m14ebr_scoped_silenced_warlord", level.player.lastweapon );
}
start_infiltration()
{
aud_send_msg("start_infiltration");
start_point_common( "player_infiltration_start", "price_infiltration_start", "soap_infiltration_start" );
vision_set_fog_changes( "warlord_shanty", 0 );
level.player stealth_warlord();
blind_and_deaf_ranges();
default_alert_duration();
no_detect_corpse_range();
flag_set( "infiltrate_encounter_1" );
flag_set( "price_post_bridge" );
flag_set( "soap_post_bridge" );
thread inf_encounter_sleeping_guard();
}
warlord_infiltration()
{
flag_init( "start_inf_snipe_encounter_1" );
autosave_stealth();
level.price enable_arrivals();
level.soap enable_arrivals();
if ( !flag( "_stealth_spotted" ) )
{
level.price.ignoreall = true;
level.soap.ignoreall = true;
}
level.player.participation = 0;
setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
thread infiltrate_civilians();
thread inf_encounter_first_patroller();
thread inf_clear_graph_blocker();
mantle = getent( "inf_fence_down", "targetname" );
old_origin = mantle.origin;
mantle.origin = (0, 0, 0);
thread inf_fence_cleanup( mantle, old_origin );
flag_wait( "start_inf_door_open" );
autosave_stealth();
thread handle_mantle_brush();
thread infiltrate_cleanup();
thread inf_snipe_encounters();
thread inf_factory_breach();
thread yuri_advance();
thread show_switch_hint();
}
start_advance()
{
aud_send_msg("start_advance");
start_point_common( "player_advance_start", "price_advance_start", "soap_advance_start" );
vision_set_fog_changes( "warlord_shanty", 0 );
start_point_after_stealth();
flag_set( "obj_move_through_shanty_given");
flag_set( "inf_factory_breach_done" );
level.price enable_arrivals();
level.soap enable_arrivals();
level.price go_to_node_with_targetname("node_price_inf_6");
flag_set( "warlord_advance" );
}
warlord_advance()
{
flag_wait( "warlord_advance" );
SetSavedDvar( "ai_count", 24 );
start_autosave( "advance_start" );
level.price disable_cqbwalk();
level.soap disable_cqbwalk();
thread advance_soap_runs_for_cover();
thread advance_go_loud();
thread monitor_advance_skip();
flag_wait( "advance_done" );
flag_set( "warlord_technical" );
}
start_technical()
{
aud_send_msg("start_technical");
start_point_common( "player_technical_start", "price_technical_start", "soap_technical_start" );
vision_set_fog_changes( "warlord_shanty", 0 );
start_point_after_stealth();
level.price enable_arrivals();
level.soap enable_arrivals();
level.price.at_technical_area = true;
level.soap.at_technical_area = true;
flag_set( "advance_go_loud_complete" );
flag_set( "obj_move_through_shanty_given" );
flag_set( "obj_go_loud_given" );
flag_set( "obj_follow_price_advance_given" );
flag_set( "warlord_technical" );
flag_set( "inf_factory_breach_done" );
aud_send_msg( "mus_to_technical" );
}
warlord_technical()
{
flag_wait( "warlord_technical" );
SetSavedDvar( "Ai_Count", 24 );
flag_init( "move_anim_technical_clip" );
flag_init( "technical_gunner_dead" );
flag_init( "mortar_technical_hit" );
flag_init( "player_on_technical" );
flag_init( "player_get_on_technical_abort" );
flag_init( "player_boarding_technical" );
flag_init( "technical_combat_started" );
ground = getent( "technical_ground", "targetname" );
ground hide();
level.exploderFunction = ::warlord_technical_exploder;
level.soap.goalradius = 1024;
level thread technical_kill_player();
level thread technical_drivein_turret();
level thread technical_combat();
level thread technical_combat_complete();
thread move_anim_technical_clip();
thread monitor_player_at_back_of_truck();
rubble = getentarray( "mortar_rubble", "targetname" );
foreach( rubble_piece in rubble )
{
rubble_piece hide();
}
flag_wait( "turret_ready_to_use" );
flag_set( "player_technical_dialogue" );
flag_wait( "technical_combat_started" );
level.player_technical thread player_get_on_technical( level.player_technical_turret );
flag_set( "obj_follow_price_advance_complete" );
flag_set( "obj_commandeer_technical_given" );
level waittill( "turret_finished" );
flag_set( "warlord_mortar_run" );
level.exploderFunction = ::exploder_after_load;
}
start_mortar_run()
{
aud_send_msg("start_mortar_run");
start_point_common( "player_mortar_run_start", "price_mortar_run_start", "soap_mortar_run_start" );
vision_set_fog_changes( "warlord_shanty", 0 );
start_point_after_stealth();
level.price enable_arrivals();
level.soap enable_arrivals();
thread switch_sniper_rifle();
rubble = getentarray( "mortar_rubble", "targetname" );
foreach( rubble_piece in rubble )
{
rubble_piece show();
}
blockers = getentarray( "technical_blocker_graph", "targetname" );
foreach( blocker in blockers )
{
blocker ConnectPaths();
blocker delete();
}
flag_set( "warlord_mortar_run" );
}
warlord_mortar_run()
{
flag_wait( "warlord_mortar_run" );
flag_set( "mortar_run_dialogue" );
start_autosave( "mortar_run_start" );
level.soap mortar_run_ally_setup();
level.price mortar_run_ally_setup();
thread mortar_gauntlet();
thread setup_mortar_motivation_guys();
}
start_player_mortar()
{
aud_send_msg("start_player_mortar");
start_point_common( "player_player_mortar_start", "price_player_mortar_start", "soap_player_mortar_start" );
vision_set_fog_changes( "warlord_shanty", 0 );
start_point_after_stealth();
level.player switch_sniper_rifle();
level.price enable_arrivals();
level.soap enable_arrivals();
level.soap disable_awareness();
flag_set( "warlord_player_mortar" );
flag_set( "mortar_operator_off" );
flag_set( "flag_mortar_obj_2" );
flag_set( "flag_mortar_obj_3" );
flag_set( "flag_mortar_obj_mortar" );
}
warlord_player_mortar()
{
flag_wait( "warlord_player_mortar" );
level notify( "warlord_player_mortar" );
SetSavedDvar( "ai_count", 20 );
start_autosave( "player_mortar_start" );
thread mortar_introduce();
thread mortar_fight();
thread mortar_allies();
thread mortar_rpg_setup();
thread mortar_rpg_guys();
level.soap enable_arrivals();
level.soap disable_sprint();
level.price enable_arrivals();
level.price disable_sprint();
thread wii_assault_run_to_pipe();
}
start_assault()
{
aud_send_msg("start_assault");
start_point_common( "player_assault_start", "price_assault_start", "soap_assault_start" );
vision_set_fog_changes( "warlord_camp", 0 );
start_point_after_stealth();
level.player switch_sniper_rifle();
level.price enable_arrivals();
level.soap enable_arrivals();
level.soap disable_awareness();
flag_set( "warlord_assault" );
flag_set( "price_moving_to_pipe" );
flag_set( "assault_run_to_pipe" );
}
warlord_assault()
{
flag_wait( "warlord_assault" );
SetSavedDvar( "ai_count", 24 );
start_autosave( "assault_start" );
aud_send_msg( "warlord_assault" );
thread assault_run_to_pipe();
thread assault_pipe_crawl();
thread assault_disable_prone_on_stairs();
thread assault_roof_deaths();
thread post_warehouse_trigger();
thread assault_door_kick();
}
start_super_technical()
{
aud_send_msg("start_super_technical");
start_point_common( "player_super_technical_start", "price_super_technical_start", "soap_super_technical_start" );
vision_set_fog_changes( "warlord_camp", 0 );
start_point_after_stealth();
level.player switch_sniper_rifle();
level.price enable_arrivals();
level.soap enable_arrivals();
activate_trigger_with_targetname( "trig_price_enter_compound_house" );
activate_trigger_with_targetname( "trig_soap_enter_compound_house" );
}
warlord_super_technical()
{
level.player thread compound_autosave();
thread ally_lower_accuracy();
thread mi17_flyby();
thread setup_change_goal_radius_on_goal();
thread setup_ignore_until_goal();
thread setup_fire_while_moving();
thread setup_ignore_all_until_goal();
thread setup_first_guys();
thread setup_run_guys();
thread delete_roof_ai();
thread compound_church_doors();
}
start_player_breach()
{
aud_send_msg("start_player_breach");
start_point_common( "player_confrontation_start", "price_confrontation_start", "soap_confrontation_start" );
vision_set_fog_changes( "warlord_church", 0 );
start_point_after_stealth();
level.player switch_sniper_rifle();
flag_set( "warlord_player_breach" );
flag_set( "church_breach_complete" );
}
warlord_player_breach()
{
flag_wait( "warlord_player_breach" );
flag_set( "aud_warlord_player_breach" );
level notify( "warlord_church_breach" );
start_autosave( "player_breach_start" );
thread turn_off_compound_triggers();
thread player_exits_church_stage_fix();
thread warlord_confrontation();
}
player_exits_church_stage_fix()
{
flag_wait("exiting_courtyard");
srcEnt = getent( "church", "targetname" );
dstEnt = getent( "yard", "targetname" );
remapStage(srcEnt.origin,dstEnt.origin);
}
start_autosave( checkpoint_name )
{
wait 0.05;
autosave_by_name( checkpoint_name );
}
