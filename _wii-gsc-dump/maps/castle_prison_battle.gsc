#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_audio;
start_security_office()
{
flag_set( "ruins_done" );
move_player_to_start( "start_security_office" );
setup_price_for_start( "start_security_office" );
battlechatter_off( "allies" );
level.price thread price_stealth_think();
set_rain_level( 6 );
maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );
}
start_prison_battle_start()
{
move_player_to_start( "start_prison_battle_start" );
setup_price_for_start( "start_prison_battle_start" );
level thread open_inner_door(true);
battlechatter_off( "allies" );
maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
SetSavedDvar( "ai_count", 24 );
}
start_prison_battle_flare_room()
{
move_player_to_start( "start_prison_battle_flare_room" );
setup_price_for_start( "start_prison_battle_flare_room" );
maps\_compass::setupMiniMap("compass_map_castle_dungeon", "dungeon_minimap_corner");
battlechatter_on( "allies" );
level.price set_ai_bcvoice( "seal" );
maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
SetSavedDvar( "ai_count", 24 );
}
init_event_flags()
{
flag_init( "objective_clear_prison" );
flag_init( "objective_clear_prison_cleared" );
flag_init( "enter_security_office" );
flag_init( "inside_security_office" );
flag_init( "security_office_react" );
flag_init( "security_office_cleared" );
flag_init( "security_office_closed" );
flag_init( "security_office_react_done" );
flag_init( "chair_react_done" );
flag_init( "chair_guy_dead" );
flag_init( "non_chair_guys_dead" );
flag_init( "start_price_drag" );
flag_init( "entered_security_office_cage" );
flag_init( "prison_start" );
flag_init( "price_open_door" );
flag_init( "price_shot_chair_guard" );
flag_init( "inner_door_open" );
flag_init( "player_outside_office_alert" );
flag_init( "do_not_stop_price_anim" );
flag_init( "do_not_stop_guard_anim" );
flag_init( "at_power_switch" );
flag_init( "price_say_ready" );
flag_init( "harasser_damaged" );
flag_init( "player_impulsive" );
flag_init( "price_activate_switch" );
flag_init( "covercrouch_blindfire_1_alerted" );
flag_init( "guard_stumble_shot" );
flag_init( "harass_guard_dead" );
flag_init( "guard_stumble_dead" );
flag_init( "stop_prison_nvg_nag" );
flag_init( "path_selected" );
flag_init( "multipath_end" );
flag_init( "start_flare_room" );
flag_init( "start_price_nag_before_meatshield" );
flag_init( "meatshield_done" );
flag_init( "guard_died" );
flag_init( "prisoner_died" );
flag_init( "exited_prison" );
flag_init( "neither_died" );
flag_init( "price_say_door_open" );
flag_init( "price_say_inner_door" );
flag_init( "price_say_endtheirdays" );
flag_init( "price_say_waitforlights" );
flag_init( "price_say_split_up" );
flag_init( "price_say_flare" );
flag_init( "price_say_finddead" );
}
setup_spawn_funcs()
{
array_spawn_function_targetname( "guard_security_office", ::init_security_office_guards );
level.guard_to_say_vo = [];
array_spawn_function_targetname( "spawn_prison_halls_a", ::setup_animate_in_darkness );
array_spawn_function_targetname( "prison_ambient_runners",	::delete_on_goal );
}
security_office()
{
level thread enter_security_office();
flag_wait( "security_office_cleared" );
SetSavedDvar( "ai_count", 24 );
}
prison_battle_start()
{
level thread enter_prison();
flag_wait( "start_flare_room" );
}
prison_battle_flare_room()
{
level prison_flare_room_battle();
}
enter_security_office()
{
exploder( 701 );
cage_pad_light = GetEnt( "castle_security_office_lights2_cage_pad_light", "targetname" );
cage_pad_light SetLightIntensity( 1.0 );
clip = getent("player_security_door_clip", "targetname");
clip trigger_off();
entrance_door_clip = getent("player_security_entrance_clip", "targetname");
entrance_door_clip trigger_off();
gun = getent("dead_security_gun", "targetname");
gun trigger_off();
level thread set_power_switch_to_first_frame();
level.top_right_destructible = getent( "top_right_destructible", "script_noteworthy" );
level.top_right_destructible hide();
level.top_right_destructible SetCanDamage(false);
level.top_left_destructible = getent( "top_left_destructible", "script_noteworthy" );
level.top_left_destructible SetCanDamage(false);
level.bottom_left_destructible = getent( "bottom_left_destructible", "script_noteworthy" );
level.bottom_left_destructible hide();
level.bottom_left_destructible SetCanDamage(false);
level.bottom_right_destructible = getent( "bottom_right_destructible", "script_noteworthy" );
level.bottom_right_destructible hide();
level.bottom_right_destructible SetCanDamage(false);
level.right_top_right_destructible = getent( "right_top_right_destructible", "script_noteworthy" );
level.right_top_right_destructible SetCanDamage(false);
level.right_top_left_destructible = getent( "right_top_left_destructible", "script_noteworthy" );
level.right_top_left_destructible SetCanDamage(false);
level.right_bottom_left_destructible = getent( "right_bottom_left_destructible", "script_noteworthy" );
level.right_bottom_left_destructible SetCanDamage(false);
level.right_bottom_right_destructible = getent( "right_bottom_right_destructible", "script_noteworthy" );
level.right_bottom_right_destructible SetCanDamage(false);
level thread security_room_monitors();
level thread open_inner_door();
level.price thread price_security_office_animation();
level.price thread price_dialogue_security_office();
level thread security_office_guards();
exploder(762);
flag_wait( "at_power_switch" );
level thread cleanup_security_office();
}
enter_prison()
{
battlechatter_off("axis");
maps\_compass::setupMiniMap("compass_map_castle_dungeon", "dungeon_minimap_corner");
set_lightning( 3, 8, (14, 289, -35), "castle_light0_lightning_multipath_room" );
a_e_lights = GetEntArray( "castle_prison_stairwell4_dungeon_light", "targetname" );
foreach( e_light in a_e_lights )
{
e_light SetLightIntensity( 2.0 );
}
dungeon_light_models_off = GetEntArray( "dungeon_light_model_off", "targetname" );
foreach(dungeon_light_model_off in dungeon_light_models_off)
{
dungeon_light_model_off hide();
}
level.prison_path_end_left = GetEnt( "prison_path_end_left", "targetname" );
level.prison_path_end_left trigger_off();
level.prison_path_end_mid_right = GetEnt( "prison_path_end_mid_right", "targetname" );
level.prison_path_end_mid_right trigger_off();
level.e_darkness_targets = GetEntArray( "darkness_target", "targetname" );
level.darkness_maxVisibleDist = 100;
level.player.old_maxVisibleDist	= level.player.maxVisibleDist;
level.player.maxVisibleDist = level.darkness_maxVisibleDist;
level.player.n_detections = 0;
level.price.old_maxVisibleDist	= level.price.maxVisibleDist;
level.price.maxVisibleDist = level.darkness_maxVisibleDist;
level.price.n_detections = 0;
level.price thread price_dialogue_prison();
level.price thread price_prison_movement();
level.price thread monitor_price_prison_behavior();
thread turn_lights_off();
flag_wait( "entered_security_office_cage" );
harass_guard = spawn_targetname( "spawner_harass_guard" );
harass_prisoner1 = spawn_targetname( "prisoner1" );
harass_prisoner3 = spawn_targetname( "prisoner3" );
level.prisoner_to_say_vo = [];
level.prisoner_to_say_vo[0] = harass_prisoner1;
level.prisoner_to_say_vo[1] = harass_prisoner3;
harass_prisoner1 thread animate_harass_prisoners("prisoner1");
harass_prisoner3 thread animate_harass_prisoners("prisoner3");
harass_guard thread animate_harass_guards();
guard_stumble_ai = spawn_targetname( "guard_stumble" );
guard_stumble_ai thread guard_stumble();
covercrouch_blindfire_ai = spawn_targetname( "covercrouch_blindfire" );
covercrouch_blindfire_ai thread guard_covercrouch_blindfire();
level.find_wall_guard_lookat_trig = getent( "find_wall_guard_lookat_trig", "targetname" );
level.find_wall_guard_lookat_trig trigger_off();
thread spawn_stair_stumble_forward_guard();
thread spawn_find_wall_guard();
thread spawn_stair_stumble_back_guard();
thread player_multipath_movement();
level thread animate_prisoners_in_multipath_cells_script_structs();
level thread guard_lights_out_vo();
level thread spawn_ambient_runners();
flag_wait( "start_flare_room" );
level notify( "notify_flareroom" );
battlechatter_on("axis");
level.player.maxVisibleDist = level.player.old_maxVisibleDist;
level.player.old_maxVisibleDist	= undefined;
level.price.maxVisibleDist = level.price.old_maxVisibleDist;
level.price.old_maxVisibleDist = undefined;
level.player.maxvisibledist = 8196;
level.price.maxvisibledist = 8196;
autosave_by_name( "flare_room" );
}
price_prison_movement()
{
flag_wait( "prison_start" );
level.price set_ignoreall( true );
level.price set_ignoreme( true );
activate_trigger( "price_to_power_switch", "targetname" );
flag_set( "price_say_endtheirdays" );
autosave_by_name( "heading_down_to_prison" );
level.price thread price_explains_power_switch();
s_align = get_new_anim_node( "dungeon_cell" );
s_align anim_reach_solo( level.price, "goto_power_switch" );
s_align thread anim_single_solo( level.price, "goto_power_switch" );
animation = level.price getanim("goto_power_switch");
while( level.price getanimtime(animation) < 0.65 )
{
wait(0.05);
}
anim_set_rate_single( level.price, "goto_power_switch", 1.8 );
level.price waittillmatch( "single anim", "end" );
s_align thread anim_loop_solo( level.price, "power_switch_wait", "stop_wait" );
flag_wait( "at_power_switch" );
flag_set( "price_say_ready" );
s_align notify( "stop_wait" );
s_align thread anim_single_solo( level.price, "power_switch_off" );
thread anim_set_rate_single( level.price, "power_switch_off", 1.5 );
while( level.price getanimtime(level.price getanim("power_switch_off")) < 0.35 )
{
wait(0.05);
}
anim_set_time( [level.price], "power_switch_off", .6 );
level.price waittillmatch( "single anim", "end" );
level.price enable_ai_color();
level.price set_ignoreall( false );
level.price set_ignoreme( false );
level.price thread price_multipath_prison_movement();
}
prison_flare_room_battle()
{
set_lightning( 0, 0 );
level.a_m_flares = [];
level.price notify( "notify_flareroom" );
level.player notify( "notify_flareroom" );
level.player.maxvisibledist = 8196;
level.price.maxvisibledist = 8196;
e_exit_door = GetEnt( "prison_exit_door", "targetname" );
e_exit_door.animname = "door";
e_exit_door assign_animtree();
e_exit_door_clip = GetEnt( "prison_exit_clip", "targetname" );
e_exit_door_clip LinkTo( e_exit_door, "origin_animate_jnt" );
s_align = get_new_anim_node( "align_dungeon_exit" );
s_align anim_first_frame_solo( e_exit_door, "prison_exit_briefing_open" );
e_blocker = GetEnt( "prison_exit_blocker", "targetname" );
e_blocker NotSolid();
door1 = GetEnt( "dungeon_door1_model", "targetname" );
door1_clip = GetEnt( "dungeon_door1", "targetname" );
door1_clip LinkTo( door1 );
door2 = GetEnt( "dungeon_door2_model", "targetname" );
door2_clip = GetEnt( "dungeon_door2", "targetname" );
door2_clip LinkTo( door2 );
level thread animate_flare_thrower();
level thread rec_room_meatshield();
level.price price_prison_behavior( "flare_room" );
level.price thread price_dialogue_flare_room();
level.price enable_ai_color();
activate_trigger( "price_into_flareroom", "targetname" );
t_wave_1_start = GetEnt( "t_flare_room_wave_1", "targetname" );
t_wave_1_start waittill( "trigger" );
level thread flare_sequence();
wait 0.1;
ai_wave_1 = get_ai_group_ai( "flare_room_wave_1" );
waittill_dead_or_dying( ai_wave_1, ai_wave_1.size - 1 );
nd_top = GetNode( "n_flare_room_top", "targetname" );
e_new_goal = GetEnt( "prison_back_office_goalvol", "targetname" );
a_ai_remaining = GetAIArray( "axis" );
ai_wave_1_left = get_ai_group_ai( "flare_room_wave_1" );
foreach( guy in ai_wave_1_left )
{
guy SetGoalNode( nd_top );
guy SetGoalVolume( e_new_goal );
}
activate_trigger( "t_flare_room_wave_2", "targetname" );
wait( 1.0 );
ai_wave_2 = get_ai_group_ai( "flare_room_wave_2" );
waittill_dead_or_dying( ai_wave_2, ai_wave_2.size - 1 );
activate_trigger( "t_prison_final_wave", "targetname" );
wait 1.0;
activate_trigger( "price_into_back_office", "targetname" );
waittill_dead_or_dying( ai_wave_2, ai_wave_2.size - 1);
activate_trigger( "price_into_back_office_2", "targetname" );
ai_final_wave = get_ai_group_ai( "final_wave" );
waittill_dead_or_dying( ai_final_wave, ai_final_wave.size );
activate_trigger( "price_into_rec_room", "targetname" );
level.price waittill("goal");
flag_set( "start_price_nag_before_meatshield" );
flag_wait( "meatshield_start" );
flag_wait( "meatshield_done" );
set_lightning( 3, 8, (18, 269, 0), "castle_post_flare_room_lights5_lightning_prison_exit_hall", 3.25, (1.0, 1.0, 1.0) );
set_rain_level( 6 );
activate_trigger( "price_into_exit", "targetname" );
level.price disable_cqbwalk();
level.price enable_sprint();
level.price waittill( "goal" );
level.price enable_cqbwalk();
level.price disable_sprint();
a_exit_briefing_actors = make_array( level.price, e_exit_door );
s_align anim_reach_solo( level.price, "prison_exit_briefing_open" );
flag_set( "price_say_finddead" );
aud_send_msg("price_open_prison_exit_door");
s_align anim_single( a_exit_briefing_actors, "prison_exit_briefing_open" );
s_align thread anim_loop( a_exit_briefing_actors, "prison_exit_briefing_open_idle", "end_prison_exit_briefing_open_idle" );
flag_wait( "exited_prison" );
level notify( "exited_prison" );
VisionSetNight( "castle_nvg_grain" );
flag_set( "objective_clear_prison_cleared" );
_disable_local_lightning_lights( "castle_post_flare_room_lights5_lightning_prison_exit_hall" );
s_align notify( "end_prison_exit_briefing_open_idle" );
e_blocker Solid();
s_align anim_single( a_exit_briefing_actors, "prison_exit_briefing_close" );
level.price enable_ai_color();
activate_trigger( "price_onto_bridge", "targetname" );
cleanup_ents( "prison");
level prison_cleanup();
autosave_by_name( "under_bridge" );
}
flare_room_bottom_spawn()
{
}
destructible_security_monitor(screen_exploder_id)
{
exploder(screen_exploder_id);
self waittill_any("death", "damage", "screen_off");
stop_exploder(screen_exploder_id);
}
security_room_monitors()
{
level endon( "kill_security_cinematic");
SetSavedDvar( "cg_cinematicFullScreen", "0" );
level.top_left_destructible thread destructible_security_monitor(799);
level.top_right_destructible thread destructible_security_monitor(798);
level.bottom_left_destructible	thread destructible_security_monitor(797);
level.bottom_right_destructible	thread destructible_security_monitor(796);
level.right_top_left_destructible thread destructible_security_monitor(795);
level.right_bottom_left_destructible	thread destructible_security_monitor(794);
level.right_bottom_right_destructible	thread destructible_security_monitor(793);
while(1)
{
CinematicInGameLoopResident( "castle_securitycam" );
while ( IsCinematicPlaying() )
{
wait 1;
}
wait(0.05);
}
}
price_security_office_animation()
{
level.m_security_door = GetEnt( "security_front_door", "targetname" );
self endon( "death" );
level endon( "player_outside_office_alert" );
self thread check_player_inside_office();
flag_set( "objective_clear_prison" );
activate_trigger( "spawn_security_office", "targetname" );
s_align = get_new_anim_node( "security_room" );
self anim_stopanimscripted();
s_align anim_reach_solo( self, "security_office_run_up" );
s_align anim_single_solo( self, "security_office_run_up" );
s_align thread anim_loop_solo( self, "security_office_entry_idle" );
bm_security_door_clip = GetEnt( "front_door_clip", "targetname" );
level.m_security_door.animname = "door";
level.m_security_door assign_animtree();
bm_security_door_clip LinkTo( level.m_security_door, "origin_animate_jnt" );
self place_weapon_on( "mp5_silencer", "chest" );
level.m_security_door thread check_player_inside_office();
flag_wait( "enter_security_office" );
flag_set( "price_say_door_open" );
thread shut_door_behind_player(s_align, bm_security_door_clip);
aud_send_msg("price_enters_security_office");
s_align notify( "stop_loop" );
a_price_and_door = make_array( self, level.m_security_door );
flag_set( "price_open_door" );
s_align anim_single(a_price_and_door, "security_office_entry");
bm_security_door_clip ConnectPaths();
flag_wait( "inside_security_office" );
self set_ignoreall( false );
self set_ignoreme( false );
self.goalradius = 8;
self SetGoalPos( self.origin );
flag_wait( "security_office_cleared" );
level.price price_drags_guard_to_cage_door();
}
check_player_inside_office()
{
self endon("death");
level endon( "prison_start" );
if(self != level.price)
{
level endon( "do_not_stop_guard_anim" );
}
while(1)
{
if(!flag("inside_security_office"))
{
if(flag("_stealth_spotted"))
{
if(!flag("do_not_stop_price_anim"))
{
level notify( "player_outside_office_alert" );
flag_set( "player_outside_office_alert" );
if (self == level.m_security_door)
{
self anim_stopanimscripted();
}
else
{
if(IsAlive(self))
{
self anim_stopanimscripted();
if (IsDefined(self.magic_bullet_shield))
{
self stop_magic_bullet_shield();
}
if(self != level.price)
{
}
else
{
self disable_cqbwalk();
self.pacifist = false;
self.ignoreme = false;
security_office_stealth_spotted_node = GetNode("security_office_stealth_spotted_node", "targetname");
self SetGoalNode(security_office_stealth_spotted_node);
self.goalradius = 30;
self.allowdeath = true;
self.health = 1;
}
}
}
return;
}
}
}
wait(0.03);
}
}
shut_door_behind_player( s_align, bm_security_door_clip )
{
flag_wait( "inside_security_office" );
if(!flag("player_outside_office_alert") && !flag("_stealth_spotted"))
{
entrance_door_clip = getent("player_security_entrance_clip", "targetname");
entrance_door_clip trigger_on();
s_align thread anim_single_solo( level.m_security_door, "security_office_entry_door_close" );
anim_set_rate_single( level.m_security_door , "security_office_entry_door_close" , 50 );
entrance_door_clip delete();
bm_security_door_clip DisconnectPaths();
flag_set( "security_office_closed" );
flag_set( "stop_water_splash_fx" );
level notify( "price_stealth_end" );
flag_set( "security_office_cleared" );
}
}
grab_pistol(price)
{
level.price_pistol = spawn( "script_model", level.price GetTagOrigin( "TAG_WEAPON_RIGHT" ) );
level.price_pistol setmodel( "weapon_usp_silencer" );
level.price_pistol linkto( level.price, "TAG_WEAPON_RIGHT", (0, 0, 0), (0, 0, 0) );
level.price_knife = spawn( "script_model", level.price GetTagOrigin( "TAG_INHAND" ) );
level.price_knife setmodel( "weapon_commando_knife" );
level.price_knife linkto( level.price, "TAG_INHAND", (0, 0, 0), (0, 0, 0) );
}
knock1(price)
{
level.price PlaySound( "hijk_cockpit_bash" );
}
knock2(price)
{
level.price PlaySound( "hijk_cockpit_bash" );
wait(4);
flag_set( "security_office_react" );
}
kill_right(price)
{
PlayFXOnTag( level._effect[ "pistol_muzzle_flash" ] , level.price_pistol , "TAG_FLASH" );
PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , level.price_pistol , "TAG_BRASS" );
level.price_pistol thread play_sound_on_tag( "weap_usp45sd_fire_npc" , "TAG_FLASH" );
flag_set( "price_shot_chair_guard");
}
kill_left(price)
{
PlayFXOnTag( level._effect[ "pistol_muzzle_flash" ] , level.price_pistol , "TAG_FLASH" );
PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , level.price_pistol , "TAG_BRASS" );
level.price_pistol thread play_sound_on_tag( "weap_usp45sd_fire_npc" , "TAG_FLASH" );
level.security_guard_1 kill();
}
kill_mid(price)
{
PlayFXOnTag( level._effect[ "pistol_muzzle_flash" ] , level.price_pistol , "TAG_FLASH" );
PlayFXOnTag( level._effect[ "pistol_shell_eject" ] , level.price_pistol , "TAG_BRASS" );
level.price_pistol thread play_sound_on_tag( "weap_usp45sd_fire_npc" , "TAG_FLASH" );
level.security_guard_2 kill();
}
hide_pistol(price)
{
level.price_pistol Delete();
flag_clear( "do_not_stop_price_anim" );
level.price.dont_break_anim = false;
}
hide_knife(price)
{
level.price_knife Delete();
}
grab_rifle(price)
{
level.price place_weapon_on( "mp5_silencer", "right" );
}
security_office_guards()
{
flag_wait( "enter_security_office" );
a_ai_security_guards = get_ai_group_ai( "security_office" );
foreach ( ai_security_guard in a_ai_security_guards )
{
ai_security_guard disable_surprise();
if( ai_security_guard.script_noteworthy == "security_guard_chair" )
{
ai_security_guard thread chair_guard_animations();
level.security_guard_chair = ai_security_guard;
}
else if( ai_security_guard.script_noteworthy == "security_guard_3" )
{
ai_security_guard thread entry_door_guard_animations();
level.security_guard_3 = ai_security_guard;
}
else if( ai_security_guard.script_noteworthy == "security_guard_2" )
{
ai_security_guard thread security_guard_2_animations();
level.security_guard_2 = ai_security_guard;
}
else if( ai_security_guard.script_noteworthy == "security_guard_1" )
{
ai_security_guard thread guard_animations();
level.security_guard_1 = ai_security_guard;
}
}
flag_wait_either( "security_office_react", "inside_security_office" );
wait( 5.0 );
flag_set( "security_office_react_done" );
}
stop_animation_on_grenade_security()
{
self endon("death");
self waittill_any("flashbang", "grenade danger", "explode", "bulletwhizby" );
flag_set("_stealth_spotted");
self anim_stopanimscripted();
}
stop_animation_on_grenade_prison()
{
self endon("death");
level endon("price_activate_switch");
self waittill_any("flashbang", "grenade danger", "explode", "bulletwhizby", "pain_death" );
flag_set("player_impulsive");
self anim_stopanimscripted();
}
stop_animation_on_prison_guard_if_flashbang()
{
self endon("death");
self waittill_any("flashbang", "explode");
self anim_stopanimscripted();
}
guard_animations()
{
s_align = get_new_anim_node( "security_room" );
self.noragdoll = 1;
self set_allowdeath( true );
s_align thread anim_loop_solo( self, "security_office_idle" );
flag_wait( "security_office_react");
s_align notify( "stop_loop" );
s_align anim_single_solo( self, "security_office_react" );
self set_ai_guard_passive( false, 256 );
}
security_guard_2_animations()
{
flag_wait( "security_office_react" );
self.noragdoll = 1;
self.deathanim = getanim( "generic_death" );
self anim_single_solo(self, "security_office_react" );
}
entry_door_guard_animations()
{
self thread check_player_inside_office();
self gun_remove();
self magic_bullet_shield();
s_align = get_new_anim_node( "security_room" );
flag_wait( "price_open_door" );
if (flag( "_stealth_spotted" ))
{
return;
}
s_align anim_single_solo( self, "security_office_entry_guard" );
if(flag( "do_not_stop_guard_anim" ))
{
if(IsDefined(self.magic_bullet_shield))
{
self stop_magic_bullet_shield();
}
if(IsAlive(self))
{
self.allowDeath = true;
self.a.nodeath = true;
self.diequietly = true;
self.noragdoll = 1;
self kill();
}
}
}
stab_enter(guard)
{
level.price PlaySound( "temp_stab" );
level.security_guard_3.team = "neutral";
level.security_guard_3 SetCanDamage(false);
level.security_guard_3.ignoreme = 1;
flag_set( "do_not_stop_price_anim" );
flag_set( "do_not_stop_guard_anim" );
level.price.dont_break_anim = true;
}
throat_cut(guard)
{
level.price PlaySound( "temp_gurgle" );
}
land(guard)
{
}
kill_dude(guard)
{
}
chair_guard_animations()
{
s_align = get_new_anim_node( "security_room" );
level.ai_chair_guard = self;
m_guard_chair = GetEnt( "guard_chair", "targetname" );
m_guard_chair.animname = "chair";
m_guard_chair assign_animtree();
m_guard_chair thread animate_chair();
a_chair_actors = make_array( level.ai_chair_guard, m_guard_chair );
s_align thread anim_loop( a_chair_actors, "security_office_guard_chair_idle" );
flag_wait( "security_office_react");
s_align notify( "stop_loop" );
s_align anim_single_solo( self, "security_office_react" );
flag_set( "chair_react_done" );
s_align thread anim_single_solo( self, "security_office_react_stand" );
self deletable_magic_bullet_shield();
self disable_pain();
self thread maps\castle_anim::spawn_fake_security_office_dead_model();
s_align anim_first_frame_solo( level.fake_security_character, "security_office_react_death" );
self set_ignoreme( true );
self.ignoreall = 1;
flag_wait( "price_shot_chair_guard" );
wait(0.05);
anim_set_time( [self], "security_office_react_stand", 0.98 );
self.dropWeapon = true;
self animscripts\shared::DropAIWeapon();
wait(.1);
level.fake_security_character show();
self delete();
s_align anim_single_solo( level.fake_security_character, "security_office_react_death" );
flag_set( "chair_guy_dead" );
gun = getent("dead_security_gun", "targetname");
gun trigger_on();
s_align thread anim_loop_solo( level.fake_security_character, "security_office_guard_chair_death_idle", "end_death_loop" );
flag_wait( "security_office_cleared" );
s_align notify( "end_death_loop" );
}
animate_chair()
{
waittill_any_ents( level, "chair_react_done", level.ai_chair_guard, "damage" );
s_align = get_new_anim_node( "security_room" );
s_align anim_single_solo( self, "security_office_guard_chair_move" );
s_align anim_loop_solo( self, "security_office_guard_chair_death_idle" );
}
price_drags_guard_to_cage_door()
{
self endon( "death" );
s_align = get_new_anim_node( "security_room" );
m_cage_door = GetEnt( "security_door_1", "targetname" );
m_cage_door.animname = "airlock_door";
m_cage_door assign_animtree();
bm_cage_door_clip = GetEnt( "cage_door_clip", "targetname" );
bm_cage_door_clip LinkTo( m_cage_door, "origin_animate_jnt" );
level thread ready_to_close_security_door();
s_align anim_reach_solo( self, "security_office_drag" );
flag_set( "start_price_drag" );
aud_send_msg("price_use_dead_guard_hand");
s_align anim_single( make_array( self, level.fake_security_character, m_cage_door ), "security_office_drag" );
flag_set( "prison_start" );
flag_set( "price_say_inner_door" );
flag_wait( "entered_security_office_cage" );
s_align anim_single_solo( m_cage_door, "security_office_door_close" );
}
ready_to_close_security_door()
{
flag_wait( "entered_security_office_cage" );
clip = getent("player_security_door_clip", "targetname");
clip trigger_on();
}
cage_pad_open( ai_guy )
{
stop_exploder( 701 );
exploder( 702 );
cage_pad_light = GetEnt( "castle_security_office_lights2_cage_pad_light", "targetname" );
cage_pad_light SetLightColor( (0.0, 1.0, 0.0) );
}
door2_trigger(guy)
{
flag_set( "inner_door_open" );
}
monitor_trigger(monitor)
{
level.top_right_destructible show();
top_right = GetEnt( "top_right", "script_noteworthy" );
top_right Delete();
level.bottom_left_destructible show();
bottom_left = GetEnt( "bottom_left", "script_noteworthy" );
bottom_left Delete();
level.bottom_right_destructible show();
bottom_right = GetEnt( "bottom_right", "script_noteworthy" );
bottom_right Delete();
}
dialogue01(price)
{
level.price dialogue_queue( "castle_pri_camerasout" );
}
dialogue02(price)
{
level.price dialogue_queue( "castle_pri_knock" );
}
dialogue03(price)
{
level.price dialogue_queue( "castle_pri_cheers" );
}
open_inner_door(open_fast)
{
if ( !IsDefined( open_fast ))
{
open_fast = false;
}
dungeon_enter_door = GetEnt( "prison_enter_door", "targetname" );
dungeon_enter_door.animname = "door";
dungeon_enter_door assign_animtree();
e_inner_door_clip = GetEnt( "inner_door_clip", "targetname" );
e_inner_door_clip LinkTo( dungeon_enter_door, "origin_animate_jnt" );
s_align = get_new_anim_node( "align_dungeon_enter" );
s_align anim_first_frame_solo( dungeon_enter_door, "prison_exit_briefing_open" );
if ( !open_fast )
{
flag_wait( "inner_door_open" );
}
s_align thread anim_single_solo( dungeon_enter_door, "prison_exit_briefing_open" );
if ( open_fast )
{
anim_set_rate_single( dungeon_enter_door , "prison_exit_briefing_open" , 50 );
}
e_inner_door_clip ConnectPaths();
}
init_security_office_guards()
{
self set_ai_guard_passive( true, 32);
self.animname = self.script_noteworthy;
}
price_explains_power_switch()
{
level endon( "price_activate_switch" );
level endon( "player_entered_prison" );
t_price_power_switch = GetEnt( "price_light_switch", "targetname" );
t_price_power_switch waittill( "trigger", ent );
if ( ent == level.price )
{
flag_set( "price_say_waitforlights" );
}
}
lights_off( ai_price )
{
flag_set( "price_activate_switch" );
}
turn_lights_off()
{
flag_wait_any( "price_activate_switch", "player_entered_prison" );
level thread rotate_power_switch();
exploder( 703 );
a_e_lights = GetEntArray( "castle_prison_stairwell4_dungeon_light", "targetname" );
foreach( e_light in a_e_lights )
{
e_light SetLightIntensity( 0.1 );
}
dungeon_light_models_off = GetEntArray( "dungeon_light_model_off", "targetname" );
foreach(dungeon_light_model_off in dungeon_light_models_off)
{
dungeon_light_model_off show();
}
dungeon_light_models_on = GetEntArray( "dungeon_light_model_on", "targetname" );
foreach(dungeon_light_model_on in dungeon_light_models_on)
{
dungeon_light_model_on Delete();
}
stop_exploder(762);
VisionSetNaked( "castle_light_switch", 0 );
}
set_power_switch_to_first_frame()
{
s_align = get_new_anim_node( "dungeon_cell" );
power_switch = GetEnt( "power_switch_handle", "targetname" );
power_switch.animname = "power_switch";
power_switch assign_animtree();
s_align thread anim_first_frame_solo( power_switch, "power_off" );
}
rotate_power_switch()
{
s_align = get_new_anim_node( "dungeon_cell" );
power_switch = GetEnt( "power_switch_handle", "targetname" );
power_switch.animname = "power_switch";
power_switch assign_animtree();
aud_send_msg("price_cut_lights");
s_align thread anim_single_solo( power_switch, "power_off" );
}
check_player_used_nvgs( n_wait )
{
if ( flag( "nvg_on" ) )
{
return;
}
level endon( "nvg_on" );
wait( n_wait );
level.player display_hint( "nvg" );
flag_wait_or_timeout( "nvg_on", 5 );
}
player_multipath_movement()
{
level.t_prison_path_left = GetEnt( "prison_path_left", "targetname" );
level.t_prison_path_middle = GetEnt( "prison_path_middle", "targetname" );
level.t_prison_path_right = GetEnt( "prison_path_right", "targetname" );
at_paths = GetEntArray( "path", "script_noteworthy" );
array_thread( at_paths, ::select_path );
level.t_path_taken = undefined;
flag_wait( "path_selected" );
if ( level.t_path_taken == level.t_prison_path_left )
{
if (isDefined(level.t_prison_path_middle))
{
level.t_prison_path_middle Delete();
}
if (isDefined(level.t_prison_path_right))
{
level.t_prison_path_right Delete();
}
}
if ( level.t_path_taken == level.t_prison_path_middle )
{
if (isDefined(level.t_prison_path_left))
{
level.t_prison_path_left Delete();
}
if (isDefined(level.t_prison_path_right))
{
level.t_prison_path_right Delete();
}
}
if ( level.t_path_taken == level.t_prison_path_right )
{
if (isDefined(level.t_prison_path_middle))
{
level.t_prison_path_middle Delete();
}
if (isDefined(level.t_prison_path_left))
{
level.t_prison_path_left Delete();
}
}
}
price_multipath_prison_movement()
{
self set_ignoreall( false );
self set_ignoreme( false );
self set_ignoreSuppression( true );
thread move_price_into_multipath_start();
flag_wait( "path_selected" );
fake_targetname = "price_target_left";
if ( level.t_path_taken == level.t_prison_path_left )
{
fake_targetname = "price_target_right";
}
if ( level.t_path_taken == level.t_prison_path_middle )
{
fake_targetname = "price_target_left";
}
if ( level.t_path_taken == level.t_prison_path_right )
{
fake_targetname = "price_target_left";
}
self waittill( "goal" );
self.ignoreme = 1;
e_fake_target = GetEnt( fake_targetname, "targetname" );
for ( i=0; i<4; i++ )
{
if ( flag("multipath_end" ) )
{
break;
}
level.price shoot_at_fake_target( e_fake_target );
}
self ClearEntityTarget();
flag_wait( "multipath_end" );
wait 1;
activate_trigger( "price_move_to_path_end", "targetname" );
}
move_price_into_multipath_start()
{
flag_wait( "harass_guard_dead" );
activate_trigger( "prison_halls_a", "targetname" );
flag_set( "price_say_split_up" );
}
shoot_at_fake_target( e_fake_target )
{
level endon( "multipath_end" );
b_trace = true;
while ( b_trace )
{
wait( 0.1 );
b_trace = BulletTracePassed( level.player GetEye(), e_fake_target.origin, false, undefined );
}
self SetEntityTarget( e_fake_target, 0.7 );
wait( RandomFloatRange( 1.5, 2.0 ) );
self ClearEntityTarget();
wait( RandomFloatRange( 1.0, 2.0 ) );
}
spawn_ambient_runners()
{
level endon( "start_flare_event" );
flag_wait( "start_ambient_runners" );
activate_trigger( "spawn_ambient_runners", "targetname" );
}
delete_on_goal()
{
self endon( "death" );
self waittill( "goal" );
self Delete();
}
prisoner_init()
{
self.drone_idle_custom = 1;
self.drone_idle_override = ::prisoner_loop_idle;
self.name = "";
self.team = "neutral";
self.noragdoll = true;
}
prisoner_loop_idle()
{
}
animate_harass_prisoners(animname)
{
wait( 0.5 );
self.animname = animname;
self thread anim_loop_solo( self, "harass_loop" );
flag_wait_any( "price_activate_switch", "player_impulsive", "harasser_damaged", "player_entered_prison" );
if ( IsAlive( self ) )
{
self anim_stopanimscripted();
self thread harassed_prisoner_react();
}
}
animate_harass_guards( harass_guard )
{
wait( 0.5 );
s_align = get_new_anim_node( "dungeon_cell" );
self.allowdeath = true;
self.animname = "guard3";
self thread stop_animation_on_grenade_prison();
self thread has_player_killed_prematurely();
level thread harasser_damage_watcher( self );
m_baton = spawn_anim_model( "baton" );
add_cleanup_ent( m_baton, "prison" );
s_align thread anim_loop_solo( m_baton, "harass_loop", "stop_loop" );
s_align thread anim_loop_solo( self, "harass_loop", "stop_loop" );
flag_wait_any( "price_activate_switch", "player_impulsive", "harasser_damaged", "player_entered_prison" );
self anim_stopanimscripted();
s_align notify( "stop_loop" );
thread drop_baton(s_align, m_baton);
if(IsAlive(self))
{
self thread dialogue_queue( "castle_ru2_whatthehell" );
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
s_align anim_single_solo( self, "harass_react" );
}
if(IsAlive(self))
{
self thread anim_loop_solo( self, "blinded_react_loop" );
}
}
drop_baton(s_align, m_baton)
{
s_align anim_single_solo( m_baton, "harass_drop" );
s_align thread anim_loop_solo( m_baton, "harass_drop_idle" );
}
harassed_prisoner_react()
{
self endon( "death" );
if ( IsDefined( level.scr_anim[ self.animname ][ "harass_react" ] ) )
{
self anim_single_solo( self, "harass_react" );
self thread anim_loop_solo( self, "harass_end_loop" );
}
}
harasser_damage_watcher( harasser )
{
level endon( "path_selected" );
self waittill( "damage", amount, attacker, direction_vec, point, type );
flag_set( "harasser_damaged" );
}
has_player_killed_prematurely()
{
self waittill("death");
flag_set( "harass_guard_dead" );
if( !flag( "price_activate_switch" ) )
{
flag_set( "player_impulsive" );
}
}
animate_prisoners_in_multipath_cells_script_structs()
{
level.a_prisoner_multipath_actors = [];
sp_prisoner_spawner_multipath = GetEnt( "prisoner_spawner_multipath", "targetname" );
a_s_anim_locations = GetStructArray( "struct_cell_prisoner", "targetname" );
foreach( a_s_anim_location in a_s_anim_locations )
{
e_prisoner = sp_prisoner_spawner_multipath dronespawn();
wait 0.05;
level.a_prisoner_multipath_actors = array_add( level.a_prisoner_multipath_actors, e_prisoner );
add_cleanup_ent( e_prisoner, "prison" );
e_prisoner.name = "";
e_prisoner.animname = "generic";
a_s_anim_location thread anim_generic_loop( e_prisoner, a_s_anim_location.script_noteworthy );
}
thread prisoner_ambient_vo_setup();
thread prisoner_kill_count();
}
prisoner_kill_count()
{
level.prisoner_count_kill = 0;
level.prisoner_count_kill_max = 4;
level.friendlyfire[ "friend_kill_points" ] = 0;
level.friendlyfire[ "enemy_kill_points" ] = 0;
for(i = 0; i < level.a_prisoner_multipath_actors.size; i++)
{
level.a_prisoner_multipath_actors[i] thread keep_track_prisoners();
}
flag_wait("start_flare_room");
level.prisoner_count_kill = 0;
}
keep_track_prisoners()
{
level endon( "exited_prison" );
self waittill( "damage", amount, attacker, direction_vec, point, type );
if( IsDefined( attacker ) && IsPlayer( attacker ))
{
level.friendlyfire[ "friend_kill_points" ] = 0;
level.prisoner_count_kill ++;
if (level.prisoner_count_kill > level.prisoner_count_kill_max)
{
SetDvar( "ui_deadquote", &"CASTLE_KILLED_TOO_MANY_PRISONERS" );
level thread missionFailedWrapper();
}
}
}
prisoner_ambient_vo_setup()
{
pre_lights_out = [];
pre_lights_out[0] = "castle_rup3_innocents";
pre_lights_out[1] = "castle_rup2_doctor";
pre_lights_out[2] = "castle_rup2_letusout";
pre_lights_out[3] = "castle_rup3_helpusplease";
pre_lights_out[4] = "castle_rup1_help";
lights_out = [];
lights_out[0] = "castle_cop1_whatshappening";
lights_out[1] = "castle_cop1_whoarethose";
lights_out[2] = "castle_cop1_setusfree";
lights_out[3] = "castle_cop1_getusout";
lights_out[4] = "castle_cop1_abouttime";
lights_out[5] = "castle_rup1_whatsgoingon";
lights_out[6] = "castle_rup2_outthere";
flares_out = [];
flares_out[0] = "castle_cop1_hurray";
flares_out[1] = "castle_cop1_yeah";
flares_out[2] = "castle_cop1_shootthe";
flares_out[3] = "castle_rup1_hereforus";
flares_out[4] = "castle_rup2_wecanhelp";
flares_out[5] = "castle_rup3_deathtomakarov";
flares_out[6] = "castle_rup1_overhere";
flares_out[7] = "castle_rup3_openthedoors";
flares_out[8] = "castle_rup1_yes";
flares_out[9] = "castle_rup2_killthem";
level.prisoner_vo = [];
level.prisoner_vo = array_combine( level.prisoner_vo, pre_lights_out);
level.min_wait = 5.0;
level.max_wait = 7.0;
thread prisoner_ambient_vo();
flag_wait( "player_entered_prison" );
level.prisoner_vo = array_combine( level.prisoner_vo, lights_out);
for(i = 1; i <= (level.a_prisoner_multipath_actors.size - 20); i++)
{
level.prisoner_to_say_vo = add_to_array(level.prisoner_to_say_vo, level.a_prisoner_multipath_actors[i]);
}
level.min_wait = 2.0;
level.max_wait = 3.5;
flag_wait( "start_flare_room" );
level.prisoner_vo = array_combine( level.prisoner_vo, flares_out);
for(i = 1; i <= (level.a_prisoner_multipath_actors.size - 10); i++)
{
level.prisoner_to_say_vo = add_to_array(level.prisoner_to_say_vo, level.a_prisoner_multipath_actors[i]);
}
level.min_wait = 0.75;
level.max_wait = 1.5;
}
prisoner_ambient_vo()
{
level endon( "exited_prison" );
last_line = -1;
level.prisoner_to_say_vo = array_removeDead(level.prisoner_to_say_vo);
while(level.prisoner_to_say_vo.size > 0)
{
vo_index = RandomInt(level.prisoner_vo.size);
if (vo_index == last_line)
{
vo_index++;
if (vo_index >= level.prisoner_vo.size)
vo_index = 0;
}
random_vo = level.prisoner_vo[vo_index];
play_sound_in_space(random_vo, level.prisoner_to_say_vo[RandomInt(level.prisoner_to_say_vo.size)].origin);
last_line = vo_index;
wait(RandomFloatRange( level.min_wait, level.max_wait ));
level.prisoner_to_say_vo = array_removeDead(level.prisoner_to_say_vo);
}
}
guard_lights_out_vo()
{
guard_lights_out_vo_1 = [];
guard_lights_out_vo_1[0] = "castle_ru1_intruders";
guard_lights_out_vo_1[1] = "castle_ru1_soundalarm";
guard_lights_out_vo_1[2] = "castle_ru3_alertcommander";
guard_lights_out_vo_1[3] = "castle_ru1_lockdown";
guard_lights_out_vo_1[4] = "castle_ru2_powerback";
guard_lights_out_vo_2 = [];
guard_lights_out_vo_2[0] = "castle_ru1_gunfire";
guard_lights_out_vo_2[1] = "castle_ru2_spreadout";
guard_lights_out_vo_2[2] = "castle_ru3_wherearethey";
guard_lights_out_vo_2[3] = "castle_ru1_findthem";
guard_lights_out_vo_2[4] = "castle_ru2_unidentified";
flag_wait("price_activate_switch");
level.guard_vo = [];
level.guard_vo = array_combine( level.guard_vo, guard_lights_out_vo_1);
level.guard_min_wait = 7.0;
level.guard_max_wait = 12.0;
thread guard_ambient_vo();
flag_wait( "harass_guard_dead" );
level.guard_vo = array_combine( level.guard_vo, guard_lights_out_vo_2);
}
guard_ambient_vo()
{
level endon( "notify_flareroom" );
last_line = -1;
while(1)
{
level.guard_to_say_vo = array_removeDead(level.guard_to_say_vo);
if (level.guard_to_say_vo.size > 0)
{
vo_index = RandomInt(level.guard_vo.size);
if (vo_index == last_line)
{
vo_index++;
if (vo_index >= level.guard_vo.size)
vo_index = 0;
}
random_vo = level.guard_vo[vo_index];
play_sound_in_space(random_vo, level.guard_to_say_vo[RandomInt(level.guard_to_say_vo.size)].origin);
last_line = vo_index;
wait(RandomFloatRange( level.guard_min_wait, level.guard_max_wait ));
}
else
{
return;
}
}
}
setup_animate_in_darkness()
{
self endon( "death" );
self enable_cqbwalk();
self disable_long_death();
self.animname = "generic";
self.allowdeath = true;
self.allowpain = true;
self.ignoreme = true;
self thread price_sees_me();
level.guard_to_say_vo = add_to_array(level.guard_to_say_vo, self);
start_anim = self.animation + "_single";
if ( IsAlive( self ) && IsDefined(self.animation))
{
self thread anim_generic_first_frame( self, start_anim );
}
flag_wait( "player_entered_prison" );
if ( IsAlive( self ) && IsDefined(self.animation))
{
wait(RandomFloatRange(0.5,1.5));
self thread anim_generic_loop( self, self.animation );
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
}
}
price_sees_me()
{
trigger_wait_targetname( "price_into_prison" );
level.price waittill("goal");
if (isAlive(self))
{
self.ignoreme = false;
}
}
spawn_stair_stumble_forward_guard()
{
flag_wait( "player_entered_prison" );
stair_stumble_forward_guard_ai = spawn_targetname( "stair_stumble_forward_guard" );
s_align = get_new_anim_node( "dungeon_cell" );
stair_stumble_forward_guard_ai thread stair_stumble_forward_guard(s_align);
}
stair_stumble_forward_guard(s_align)
{
self endon("death");
self enable_cqbwalk();
self disable_long_death();
self.animname = "generic";
self.allowdeath = true;
self.noragdoll = 1;
self.ignoreme = 1;
if ( IsAlive( self ) )
{
s_align thread anim_generic_first_frame( self, "stair_stumble_forward_guard" );
}
flag_wait_any( "stair_stumble_forward_guard_mid_trig", "stair_stumble_forward_guard_left_trig", "stair_stumble_forward_guard_right_trig" );
if( flag( "stair_stumble_forward_guard_mid_trig" ) )
{
trig1 = GetEnt( "stair_stumble_forward_guard_left_targetname", "targetname" );
trig2 = GetEnt( "stair_stumble_forward_guard_right_targetname", "targetname" );
trig1 Delete();
trig2 Delete();
if ( IsAlive( self ) )
{
s_align thread anim_single_solo( self, "stair_stumble_forward_guard" );
wait(0.05);
anim_set_time( [self], "stair_stumble_forward_guard", .25 );
self.ignoreme = 0;
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
self waittillmatch( "single anim", "end" );
self anim_loop_solo(self,"corner_standR_alert_idle");
}
}
else if( flag( "stair_stumble_forward_guard_left_trig" ) )
{
trig1 = GetEnt( "stair_stumble_forward_guard_mid_targetname", "targetname" );
trig2 = GetEnt( "stair_stumble_forward_guard_right_targetname", "targetname" );
trig1 Delete();
trig2 Delete();
if ( IsAlive( self ) )
{
s_align thread anim_single_solo( self, "stair_stumble_forward_guard" );
self.ignoreme = 0;
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
self waittillmatch( "single anim", "end" );
self anim_loop_solo(self,"corner_standR_alert_idle");
}
}
else if( flag( "stair_stumble_forward_guard_right_trig" ) )
{
trig1 = GetEnt( "stair_stumble_forward_guard_mid_targetname", "targetname" );
trig2 = GetEnt( "stair_stumble_forward_guard_left_targetname", "targetname" );
trig1 Delete();
trig2 Delete();
if ( IsAlive( self ) )
{
s_align thread anim_single_solo( self, "stair_stumble_forward_guard" );
self.ignoreme = 0;
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
self waittillmatch( "single anim", "end" );
self anim_loop_solo(self,"corner_standR_alert_idle");
}
}
}
spawn_find_wall_guard()
{
level endon( "end_find_wall_guard_trig" );
flag_wait("find_wall_guard_spawn_trig");
find_wall_guard_ai = spawn_targetname( "find_wall_guard" );
level.find_wall_guard_lookat_trig trigger_on();
s_align = get_new_anim_node( "dungeon_cell" );
s_align thread anim_generic_first_frame( find_wall_guard_ai, "find_wall_guard" );
find_wall_guard_ai thread find_wall_guard(s_align);
}
find_wall_guard(s_align)
{
self endon("death");
self enable_cqbwalk();
self disable_long_death();
self.animname = "generic";
self.allowdeath = true;
flag_wait("find_wall_guard_lookat");
if ( IsAlive( self ))
{
s_align thread anim_single_solo( self, "find_wall_guard" );
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
}
}
spawn_stair_stumble_back_guard()
{
flag_wait_any( "stair_stumble_back_guard_mid_spawn", "stair_stumble_back_guard_right_spawn", "stair_stumble_back_guard_left_spawn" );
if( flag( "stair_stumble_back_guard_mid_spawn" ) )
{
trig_to_delete = GetEnt( "stair_stumble_back_guard_right_spawn_targetname", "targetname" );
trig_to_delete Delete();
trig_to_delete = GetEnt( "stair_stumble_back_guard_left_spawn_targetname", "targetname" );
trig_to_delete Delete();
level.prison_path_end_mid_right trigger_on();
level.prison_path_end_left Delete();
}
else if( flag( "stair_stumble_back_guard_right_spawn" ) )
{
trig_to_delete = GetEnt( "stair_stumble_back_guard_mid_spawn_targetname", "targetname" );
trig_to_delete Delete();
trig_to_delete = GetEnt( "stair_stumble_back_guard_left_spawn_targetname", "targetname" );
trig_to_delete Delete();
level.prison_path_end_mid_right trigger_on();
level.prison_path_end_left Delete();
}
else if( flag( "stair_stumble_back_guard_left_spawn" ) )
{
trig_to_delete = GetEnt( "stair_stumble_back_guard_mid_spawn_targetname", "targetname" );
trig_to_delete Delete();
trig_to_delete = GetEnt( "stair_stumble_back_guard_right_spawn_targetname", "targetname" );
trig_to_delete Delete();
level.prison_path_end_left trigger_on();
level.prison_path_end_mid_right Delete();
}
stair_stumble_back_guard_ai = spawn_targetname( "stair_stumble_back_guard" );
stair_stumble_back_guard_ai.ignoreme = 1;
s_align = get_new_anim_node( "dungeon_cell" );
stair_stumble_back_guard_ai thread stair_stumble_back_guard(s_align);
flag_wait( "multipath_end" );
if(IsAlive(stair_stumble_back_guard_ai))
{
stair_stumble_back_guard_ai.ignoreme = 0;
}
}
stair_stumble_back_guard(s_align)
{
self endon("death");
self enable_cqbwalk();
self disable_long_death();
self.animname = "generic";
self.allowdeath = true;
if ( IsAlive( self ) )
{
s_align thread anim_single_solo( self, "stair_stumble_back_guard" );
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
self waittillmatch( "single anim", "end" );
self anim_loop_solo( self, "castle_dungeon_blind_idle_guard" );
}
}
guard_stumble()
{
self endon( "death" );
self enable_cqbwalk();
self disable_long_death();
self.animname = "generic";
self.allowdeath = true;
self.ignoreme = 1;
self.health = 1;
self thread check_for_death();
start_anim = self.animation + "_single";
if ( IsAlive( self ) && IsDefined(self.animation))
{
self thread anim_generic_first_frame( self, start_anim );
}
flag_wait( "stumble_guy_go" );
if ( IsAlive( self ) && IsDefined(self.animation))
{
wait(RandomFloatRange(0.0,2.0));
self thread anim_generic_loop( self, self.animation );
self thread stop_animation_on_prison_guard_if_flashbang();
self thread guard_stumble_damage_watch();
flag_wait_or_timeout("guard_stumble_shot", 1.5);
self.ignoreme = 0;
wait(6.5);
if(IsAlive(self))
{
self kill();
}
}
}
check_for_death()
{
self waittill("death");
flag_set( "guard_stumble_dead" );
}
guard_stumble_damage_watch()
{
self endon("death");
level endon( "guard_stumble_shot" );
while(1)
{
self waittill( "damage", amount, attacker, direction_vec, point, type );
if( IsDefined( attacker ) && IsPlayer( attacker ))
{
flag_set( "guard_stumble_shot" );
}
}
}
guard_covercrouch_blindfire()
{
self endon( "death" );
self enable_cqbwalk();
self disable_long_death();
self.animname = "generic";
self.allowdeath = true;
self thread guard_covercrouch_blindfire_idle_anims();
self thread stop_animation_on_prison_guard_if_flashbang();
self thread check_for_attacker_close();
flag_wait( "covercrouch_blindfire_trigger" );
if ( IsAlive( self ) && IsDefined(self.animation))
{
self notify( "stop_looping_anim" );
self anim_single_solo( self, self.animation );
self thread guard_covercrouch_blindfire_idle_anims();
}
}
guard_covercrouch_blindfire_idle_anims()
{
self endon("death");
level endon("covercrouch_blindfire_trigger");
level endon( "covercrouch_blindfire_1_alerted" );
while(1)
{
self thread anim_generic_loop(self, "covercrouch_hide_idle", "stop_looping_anim");
wait(RandomFloatRange(0.5, 3.5));
self notify( "stop_looping_anim" );
if (flag("covercrouch_blindfire_trigger"))
{
twitch_anim = "cover_twitch_0" + randomintrange(1,3);
}
else
{
twitch_anim = "cover_twitch_01";
}
self anim_single_solo( self, twitch_anim );
}
}
check_for_attacker_close()
{
self endon( "notify_flareroom" );
self endon( "death" );
n_visible_distance_sq = level.darkness_maxVisibleDist * level.darkness_maxVisibleDist;
a_enemies = [level.player];
while (1)
{
foreach( e_enemy in a_enemies )
{
if ( DistanceSquared( self.origin, e_enemy.origin ) <= n_visible_distance_sq &&
self CanSee( e_enemy ) )
{
if ((IsDefined(self.animation) && self.animation == "covercrouch_blindfire_1"))
{
flag = self.animation + "_alerted";
flag_set(flag);
self notify("stop_looping_anim");
}
self anim_stopanimscripted();
self disable_ai_color();
self SetGoalEntity( e_enemy );
self.goalradius = 30;
e_enemy thread attacker_detected();
}
else
{
}
}
wait( 0.25 );
}
}
attacker_detected()
{
self endon( "notify_flareroom" );
self endon( "death" );
self.n_detections++;
self.maxVisibleDist = 800;
wait( RandomFloatRange( 4.0, 6.0 ) );
self.n_detections--;
if ( self.n_detections == 0 )
{
self.maxVisibleDist = level.darkness_maxVisibleDist;
}
}
ai_force_alertness()
{
self endon( "death" );
flag_wait( "player_impulsive" );
self set_ai_guard_passive( false, 384 );
self disable_ai_color();
self.ignoresuppression = true;
self.aggressivemode = true;
if ( self.script_aigroup == "prison_halls_a" )
{
level.player attacker_detected();
level.price attacker_detected();
self set_baseaccuracy( 0.5 );
e_goalvol = GetEnt( "prison_ambush_goalvol", "targetname" );
self.goalradius = 512;
self.combatmode = "ambush";
self GetEnemyInfo( level.player );
self SetGoalPos( e_goalvol.origin );
self SetGoalVolume( e_goalvol );
}
else
{
self SetGoalEntity( level.player, 2 );
self.goalradius = 384;
}
}
select_path()
{
self endon( "death" );
self waittill( "trigger" );
level.t_path_taken = self;
flag_set( "path_selected" );
flag_set( "stop_prison_nvg_nag" );
}
flare_sequence()
{
level thread toss_flare( "flare_toss_6", "castle_prison_flare_room3_light_flare_6" );
level thread toss_flare( "flare_toss_5", "castle_prison_flare_room3_light_flare_5" );
level thread toss_flare( "flare_toss_4", "castle_prison_flare_room3_light_flare_4" );
level thread toss_flare( "align_flare_room", "castle_prison_flare_room3_light_flare_3", "guard_flare_toss3" );
}
toss_flare( str_origin, str_light, str_animname )
{
s_origin = GetStruct( str_origin, "targetname" );
if ( !IsDefined( s_origin ) )
{
s_origin = GetEnt( str_origin, "targetname" );
}
m_flare = Spawn( "script_model", s_origin.origin );
m_flare SetModel( "ctl_emergency_flare_animated" );
array_add( level.a_m_flares, m_flare );
add_cleanup_ent( m_flare, "prison" );
m_flare ent_flag_init( "landed" );
aud_send_msg("toss_flare", m_flare);
PlayFXOnTag( level._effect["fx_flare_trail"], m_flare, "TAG_FIRE_FX" );
e_light = GetEnt( str_light, "targetname" );
if ( IsDefined( e_light ) )
{
wait_time = 0;
if( IsDefined( str_animname ) )
{
wait_time = 2.0;
}
e_light thread flare_flicker(wait_time);
}
if ( IsDefined( str_animname ) )
{
m_flare.animname = "flare";
m_flare assign_animtree();
s_align = get_new_anim_node( str_origin );
s_align anim_single_solo( m_flare, str_animname );
}
else
{
n_time = 1.0;
while ( IsDefined( s_origin.target) )
{
s_dest = GetStruct( s_origin.target, "targetname" );
if ( IsDefined( s_origin.script_float ) )
{
n_time = s_origin.script_float;
}
else
{
n_time = 1.0;
}
m_flare MoveTo( s_dest.origin, n_time );
if ( IsDefined( s_dest.angles ) )
{
m_flare RotateTo( s_dest.angles, n_time );
}
s_origin = s_dest;
wait( n_time );
}
}
wait( 0.05 );
m_flare thread handle_ambient_flare_fx();
exploder( 833 );
m_flare ent_flag_set( "landed" );
}
handle_ambient_flare_fx()
{
self endon("death");
while(1)
{
flag_wait("nvg_on");
wait 0.5;
flare_origin = self GetTagOrigin("TAG_FIRE_FX");
flare_forward = (0, -1, 0);
flare_up = (-1, 0, 0);
flareFXEnt = SpawnFX( level._effect["fx_flare_ambient"], flare_origin, flare_forward, flare_up );
TriggerFX(flareFXEnt, -1);
flag_waitopen("nvg_on");
flareFXEnt Delete();
}
}
animate_flare_thrower()
{
wait 0.5;
e_flare_toss_spawn = GetEnt( "enemy_flare_throw", "targetname" );
ai_flare_thrower = e_flare_toss_spawn spawn_ai();
if ( spawn_failed( ai_flare_thrower ) )
{
return;
}
ai_flare_thrower set_ignoreme( true );
ai_flare_thrower.animname = "generic";
s_align = get_new_anim_node( "align_flare_room" );
s_align thread anim_single_solo( ai_flare_thrower, "guard_flare_toss" );
flag_set( "price_say_flare" );
level toss_flare( "align_flare_room", "castle_prison_flare_room3_light_flare_1", "guard_flare_toss" );
if (flag("nvg_on"))
{
thread nvg_blowout(true);
}
else
{
thread nvg_blowout();
}
ai_flare_thrower SetGoalVolumeAuto( GetEnt( "prison_B2", "targetname" ) );
ai_flare_thrower set_ignoreme( false );
a_sp_support = GetEntArray( "enemy_flare_throw_support", "targetname" );
foreach( sp_guy in a_sp_support )
{
sp_guy spawn_ai();
}
level thread toss_flare( "align_flare_room", "castle_prison_flare_room3_light_flare_2", "guard_flare_toss2" );
}
nvg_blowout(nvg_on_now)
{
level endon("exited_prison");
if(IsDefined(nvg_on_now))
{
VisionSetNight( "castle_nvg_blowout", .5 );
}
while(1)
{
level.player waittill( "night_vision_on" );
VisionSetNight( "castle_nvg_blowout");
level.player waittill( "night_vision_off" );
wait(0.05);
}
}
flare_flicker(delay)
{
level endon( "exited_prison" );
if( IsDefined( delay ) )
{
wait delay;
}
self SetLightColor( (0.9, 0.44, 0.44) );
v_curr_color = self GetLightColor();
v_target_color = (1.0, 0.5, 0.5);
n_transition_time = 2000;
n_start_time = GetTime();
while (1)
{
if ( v_curr_color != v_target_color )
{
n_fraction = (GetTime() - n_start_time) / n_transition_time;
if ( n_fraction >= 1.0 )
{
v_curr_color = v_target_color;
}
else
{
v_curr_color = VectorLerp( v_curr_color, v_target_color, n_fraction );
}
self SetLightColor( v_curr_color );
}
if ( level.player ent_flag( "nightvision_on" ) )
{
self SetLightIntensity( RandomFloatRange( 1.6, 2.0 ) );
}
else
{
self SetLightIntensity( RandomFloatRange( 0.5, 1.0 ) );
}
wait( RandomFloatRange( 0.05, 0.10 ) );
}
}
rec_room_meatshield()
{
s_align = get_new_anim_node( "align_flare_room" );
e_spawn_meatshield_guard = GetEnt( "spawner_meatshield_guard", "targetname" );
e_spawn_meatshield_victim = GetEnt( "spawner_meatshield_prisoner", "targetname" );
flag_wait( "meatshield_start" );
level thread clear_prison_ai();
autosave_by_name( "meatshield_room" );
ai_guard = e_spawn_meatshield_guard spawn_ai();
ai_prisoner = e_spawn_meatshield_victim spawn_ai();
if ( spawn_failed( ai_guard ) || spawn_failed( ai_prisoner ) )
{
return;
}
ai_guard.animname = "meatshield_guard";
ai_guard set_ignoreme( true );
ai_guard deletable_magic_bullet_shield();
ai_prisoner.animname = "meatshield_prisoner";
ai_prisoner set_ignoreme( true );
ai_prisoner deletable_magic_bullet_shield();
ai_prisoner.name = "";
ai_prisoner.team = "neutral";
level thread meatshield_anim( s_align, ai_guard, ai_prisoner );
level thread guard_died_watcher( s_align, ai_guard, ai_prisoner );
level thread prisoner_dies_watcher( s_align, ai_guard, ai_prisoner );
level thread meatshield_resolution( s_align, ai_guard, ai_prisoner );
level thread check_player_distance( ai_guard );
level thread check_for_grenade_flashbang( ai_guard );
}
check_for_grenade_flashbang( ai_guard )
{
level endon( "meatshield_done" );
ai_guard endon( "death" );
ai_guard waittill_any("flashbang", "grenade danger" );
flag_set("neither_died");
}
check_player_distance( ai_guard )
{
level endon("meatshield_done");
ai_guard endon("death");
while(1)
{
if( DistanceSquared(level.player.origin, ai_guard.origin) < 250 * 250 )
{
flag_set("neither_died");
return;
}
wait(0.05);
}
}
clear_prison_ai()
{
a_enemies = GetAIArray( "axis" );
foreach( e_enemy in a_enemies )
{
if( IsAlive( e_enemy ) )
{
e_enemy Kill();
wait 1;
}
}
}
meatshield_anim( s_align, ai_guard, ai_prisoner )
{
level endon( "meatshield_done" );
ai_guard thread meatshield_shooting();
ae_meatshield_actors = [ ai_guard, ai_prisoner ];
s_align anim_single( ae_meatshield_actors, "meatshield_start" );
s_align thread anim_loop( ae_meatshield_actors, "meatshield_idle", "stop_meatshield_idle" );
}
meatshield_shooting()
{
self endon( "damage" );
self endon( "death" );
level endon ( "meatshield_done" );
while (1)
{
v_player_eye = level.player GetEye();
b_trace = BulletTracePassed( v_player_eye, self GetEye(), false, undefined );
if ( b_trace )
{
n_shots = RandomIntRange( 2, 6 );
for( i=0; i<n_shots; i++ )
{
self Shoot( 1.0, v_player_eye );
wait( 0.05 );
}
}
wait( RandomFloatRange( 0.5, 2.0 ) );
}
}
guard_died_watcher( s_align, ai_guard, ai_prisoner )
{
level endon( "meatshield_done" );
ai_guard waittill( "damage" );
flag_set( "guard_died" );
}
prisoner_dies_watcher( s_align, ai_guard, ai_prisoner )
{
level endon( "meatshield_done" );
ai_prisoner waittill( "damage" );
flag_set( "prisoner_died" );
}
meatshield_resolution( s_align, ai_guard, ai_prisoner )
{
flag_wait_any( "guard_died", "prisoner_died" , "neither_died");
wait( 0.1 );
flag_set( "meatshield_done" );
ai_guard stop_magic_bullet_shield();
ai_prisoner	stop_magic_bullet_shield();
s_align notify( "stop_meatshield_idle" );
if ( flag( "guard_died" ) && flag("prisoner_died" ) )
{
ai_guard thread meatshield_death( "meatshield_double_kill" );
ai_prisoner thread meatshield_death( "meatshield_double_kill" );
}
else if ( flag( "guard_died" ) && !flag( "prisoner_died" ) )
{
ai_guard anim_stopanimscripted();
ai_guard die();
ai_prisoner anim_stopanimscripted();
}
else if( flag("neither_died") )
{
ai_guard anim_stopanimscripted();
ai_prisoner anim_stopanimscripted();
}
else
{
ai_guard anim_stopanimscripted();
ai_prisoner thread meatshield_death( "meatshield_dies" );
}
}
meatshield_death( str_anim )
{
self.noragdoll = true;
self set_allowdeath(true);
self die();
}
monitor_price_prison_behavior()
{
self enable_cqbwalk();
self.pacifist = 0;
self disable_pain();
self disable_surprise();
self disable_bulletwhizbyreaction();
self set_ignoreSuppression( true );
self.aggressivemode = true;
level.price price_prison_behavior( "prison_tame" );
flag_wait( "harass_guard_dead" );
level.price price_prison_behavior( "prison_beast" );
flag_wait( "guard_stumble_dead" );
level.price price_prison_behavior( "prison_tame" );
}
price_prison_behavior( str_section )
{
switch( str_section )
{
case "flare_room":
self enable_cqbwalk();
self.pacifist = 0;
self enable_pain();
self enable_surprise();
self enable_bulletwhizbyreaction();
self set_ignoreSuppression( false );
self.aggressivemode = false;
self.baseaccuracy = 1;
self.ignoreme = false;
break;
case "prison_tame":
self.baseaccuracy = 0.5;
break;
default:
self.baseaccuracy = 100;
break;
}
}
set_ai_guard_passive( is_passive, n_goalradius )
{
if ( !IsAlive(self) )
{
return;
}
AssertEx( IsDefined( is_passive ), "is_passive not defined" );
AssertEx( IsDefined( n_goalradius ), "n_goalradius not defined" );
self set_goal_radius( n_goalradius );
if ( is_passive )
{
self set_ignoreall( true );
self set_battlechatter( false );
}
else
{
self set_ignoreall( false );
self set_battlechatter( true );
}
}
cleanup_security_office()
{
ae_cleanup = GetEntArray( "cleanup_security_office", "script_noteworthy" );
ae_spawners = GetEntArray( "guard_security_office", "targetname" );
ai_chair = get_ai_group_ai( "security_office" );
ae_cleanup = array_combine_unique( ae_cleanup, ae_spawners );
ae_cleanup = array_combine_unique( ae_cleanup, ai_chair );
if( isdefined( level.fake_security_character ) )
{
level.fake_security_character delete();
}
array_delete( ae_cleanup );
if( IsDefined(level.top_right_destructible) )
level.top_right_destructible notify("screen_off");
if( IsDefined(level.top_left_destructible) )
level.top_left_destructible notify("screen_off");
if( IsDefined(level.bottom_right_destructible) )
level.bottom_right_destructible	notify("screen_off");
if( IsDefined(level.bottom_left_destructible) )
level.bottom_left_destructible	notify("screen_off");
if( IsDefined(level.top_right_destructible) )
level.top_right_destructible notify("screen_off");
if( IsDefined(level.bottom_right_destructible) )
level.bottom_right_destructible	notify("screen_off");
if( IsDefined(level.bottom_left_destructible) )
level.bottom_left_destructible	notify("screen_off");
level notify("kill_security_cinematic");
StopCinematicInGame();
}
prison_cleanup()
{
ae_cleanup = GetEntArray( "cleanup_prison", "script_noteworthy" );
ae_spawners = GetEntArray( "spawner_harass_scene", "targetname" );
ae_cleanup = array_combine_unique( ae_cleanup, ae_spawners );
if ( IsDefined( level.a_prisoner_multipath_actors ) )
{
ae_cleanup = array_combine_unique( ae_cleanup, level.a_prisoner_multipath_actors );
}
for (i = 0; i < ae_cleanup.size; i++ )
{
if ( IsDefined( ae_cleanup[ i ] ) )
{
ae_cleanup[ i ] Delete();
}
}
stop_exploder( 831 );
stop_exploder( 832 );
stop_exploder( 833 );
stop_exploder( 702 );
level thread maps\castle_courtyard_activity::base_lights_on( level.price );
}
price_dialogue_security_office()
{
self endon( "death" );
flag_wait( "objective_clear_prison" );
a_nag_lines = make_array( "castle_pri_cmon", "castle_pri_overhere");
nag_vo_until_flag( a_nag_lines, "price_say_door_open", 15, false, false );
self dialogue_queue( "castle_pri_illhandle" );
}
price_cut_the_power_vo()
{
self endon( "death" );
level endon( "player_impulsive" );
level endon( "player_entered_prison" );
flag_wait( "price_say_waitforlights" );
self dialogue_queue( "castle_pri_nightvisionon" );
level.price.lastheadmodel = level.price.headmodel;
self thread wait_till_offscreen_then_switch_head_models("head_price_europe_c_nvg", "start_flare_room");
thread nvg_hint();
self dialogue_queue("castle_pri_takecare");
flag_wait( "price_say_ready" );
self dialogue_queue( "castle_pri_ready" );
}
nvg_hint(turnoff)
{
wait(1);
if(!IsDefined(turnoff))
{
turnoff = false;
}
if(turnoff)
{
if (flag("nvg_on"))
{
level.player thread display_hint_timeout( "disable_nvg", 3);
}
}
else if (!turnoff)
{
if ( !flag( "nvg_on" ) )
{
level.player display_hint( "nvg" );
flag_wait_or_timeout( "nvg_on", 3 );
}
}
}
price_impulsive_vo()
{
self endon( "death" );
flag_wait_any( "price_activate_switch", "player_impulsive", "player_entered_prison" );
if ( flag( "price_activate_switch" ) )
{
wait(1);
self dialogue_queue( "castle_pri_weaponsfree" );
}
else
{
if ( !flag( "player_impulsive" ) )
{
flag_set( "player_impulsive" );
}
flag_set( "at_power_switch" );
}
}
price_dialogue_prison()
{
self endon( "death" );
flag_wait( "price_say_endtheirdays" );
wait(1.5);
self dialogue_queue( "castle_pri_quiet" );
level.price thread price_cut_the_power_vo();
level.price price_impulsive_vo();
level endon( "price_say_flare" );
flag_wait( "price_say_split_up" );
wait( 2.0 );
self dialogue_queue("castle_pri_sweepthrough");
self dialogue_queue("castle_pri_howfew");
battlechatter_off( "allies" );
level.price set_ai_bcvoice( "seal" );
}
price_dialogue_flare_room()
{
flag_wait( "price_say_flare" );
wait( 3.0 );
self dialogue_queue( "castle_pri_usingflares" );
wait( 1.0 );
self dialogue_queue( "castle_pri_oldway" );
if(IsDefined(level.price.lastheadmodel) && level.price.headmodel == "head_price_europe_c_nvg")
{
self thread wait_till_offscreen_then_switch_head_models(level.price.lastheadmodel, "exited_prison");
}
thread nvg_hint(true);
level.price set_ai_bcvoice( "taskforce" );
battlechatter_on( "allies" );
flag_wait( "price_say_wave2" );
self dialogue_queue( "castle_pri_reinforcements2" );
thread nag_before_meatshield();
flag_wait( "meatshield_start" );
flag_wait_any( "prisoner_died", "guard_died", "neither_died" );
if(flag("prisoner_died"))
{
self dialogue_queue( "castle_pri_nevermind" );
}
else if(flag("guard_died"))
{
self dialogue_queue( "castle_pri_getoutofhere2" );
}
flag_wait( "price_say_finddead" );
self dialogue_queue( "castle_pri_tenminutes" );
wait 10.5;
if( !flag( "exited_prison" ) )
{
self dialogue_queue( "castle_pri_fallbehind" );
}
}
nag_before_meatshield()
{
flag_wait( "start_price_nag_before_meatshield" );
if(!flag("meatshield_start"))
{
self dialogue_queue( "castle_pri_onpoint" );
a_nag_lines = make_array( "castle_pri_startmoving", "castle_pri_onpoint" );
nag_vo_until_flag( a_nag_lines, "meatshield_start", 15, false, false );
}
}
wait_till_offscreen_then_switch_head_models(head, endon_flag)
{
level endon(endon_flag);
price_is_offscreen = false;
while(!price_is_offscreen)
{
if ( !within_fov_2d(level.player.origin,level.player.angles,self.origin,Cos(45)) )
{
price_is_offscreen = true;
}
else
{
wait(0.1);
}
}
level.price Detach( level.price.headmodel, "" );
level.price Attach( head, "", true );
level.price.headModel = head;
}
swap_nvg_fx()
{
old_fx = level.nightVision_DLight_Effect;
level.nightVision_DLight_Effect = level._effect[ "nvg_dlight"];
flag_wait( "exited_prison" );
level.nightVision_DLight_Effect = old_fx;
}
