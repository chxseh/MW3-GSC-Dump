#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_music;
#include maps\_audio_dynamic_ambi;
#include maps\_shg_fx;
#include maps\_audio_vehicles;
#include maps\_audio_stream_manager;
main()
{
aud_init();
set_stringtable_mapname("shg");
aud_set_occlusion("med_occlusion");
aud_set_timescale();
if (!IsDefined(level.aud))
{
level.aud = SpawnStruct();
}
flag_init("aud_player_in_sewers");
flag_init("aud_door_kick_threshold");
flag_init("aud_missile_death");
flag_init("aud_flag_flashbang_training_anim_begin");
level.aud.jam_tower_state = false;
level.aud.jam_tower_player_on_platform	= false;
level.aud.jam_min_vol = 0.00;
level.aud.jam_tower_stairs_min_vol = 0.00;
level.aud.jam_tower_stairs_max_vol = 0.40;
level.aud.jam_max_vol = 0.80;
level.aud.enable_fx_bombshake_duck	= true;
aud_launch_threads();
aud_create_level_envelop_arrays();
aud_register_trigger_callbacks();
aud_add_note_track_data();
aud_precache_presets();
MM_add_submix("nymn_level_global_mix");
aud_register_msg_handler(::audio_msg_handler);
aud_register_msg_handler(::music_msg_handler);
}
aud_precache_presets()
{
MM_precache_preset("nymn_level_global_mix");
MM_precache_preset("sewer_bomb_submix");
MM_precache_preset("nymn_intro_humvee_crash");
MM_precache_preset("nymn_intro_humvee_int");
MM_precache_preset("nymn_intro_cinematic");
MM_precache_preset("nymn_battle");
MM_precache_preset("broad_hind_off");
MM_precache_preset("broad_hind_on");
MM_precache_preset("nymn_broadway_entrance");
MM_precache_preset("nymn_broadway_blownout");
MM_precache_preset("nymn_broadway_interior");
MM_precache_preset("nymn_broadway_stairwell");
MM_precache_preset("nymn_back_alley");
MM_precache_preset("nymn_jewelry_store");
MM_precache_preset("nymn_jewelry_store_street");
MM_precache_preset("nymn_pre_stock_exchange_plaza");
MM_precache_preset("nymn_stock_exchange");
MM_precache_preset("nymn_rooftop");
MM_precache_preset("nymn_tower_collapse");
MM_precache_preset("nymn_predator");
MM_precache_preset("nymn_hind_ride");
MM_precache_preset("nymn_hind_ride_pre_chase");
MM_precache_preset("nymn_hind_ride_enemy_flyby");
MM_precache_preset("nymn_hind_ride_rockets");
MM_precache_preset("mus_blackhawk_cover_blown_submix");
MM_precache_preset("nymn_hind_ride_finale");
MM_precache_preset("nymn_hind_ride_end_vo");
}
aud_launch_threads()
{
if (aud_is_specops())
return;
thread aud_alley_environment_sfx();
thread aud_bathroom_sinkleak_sfx();
thread aud_metal_fire_broad();
thread aud_briefing_done();
thread aud_explode_jamming_tower();
thread aud_static_television();
thread damb_nymn_fire_start();
thread damb_nymn_15th_broad_stairwell();
thread aud_chopper_bladespin();
thread aud_15th_broad_gasoline_spilling();
thread aud_street_flares();
thread aud_15_broad_breach_flags();
thread aud_15_broad_flourescent_lights();
thread aud_intro_car_debris_fall();
thread aud_intro_car_metal_heatcreaks_damb();
thread aud_intro_car_axel_squeak();
thread aud_start_flies_in_dumpsters();
thread aud_intro_taxi_engine_steam();
thread aud_mus_flashbang_open_door();
thread aud_mus_jamming_tower_distance_mix_thread();
thread aud_mus_player_enters_hind();
thread aud_mus_dialog_get_up_ladder();
thread aud_mus_to_stock_exchange_roof();
}
aud_add_note_track_data()
{
anim.notetracks[ "aud_nymn_intro_start" ] = ::aud_nymn_intro_start;
addNotetrack_sound( "enemyhind", "ps_nymn_hind_tail_impact", "ny_manhattan_hind_finale", "nymn_hind_tail_impact" );
}
aud_create_level_envelop_arrays()
{
level.aud.envs["aud_broadway_heli_mix_off"]	=
[
[0.000, 0.000],
[0.182, 0.426],
[0.338, 0.736],
[0.608, 0.844],
[0.856, 0.953],
[1.000, 1.000]
];
level.aud.envs["aud_broadway_heli_mix_on"] =
[
[0.000, 0.000],
[0.082, 0.426],
[0.238, 0.736],
[0.408, 0.844],
[0.756, 0.953],
[1.000, 1.000]
];
level.aud.envs["remote_missle_proximity_scale"] =
[
[0.000, 0.000],
[0.182, 0.226],
[0.238, 0.356],
[0.708, 0.844],
[0.900, 0.953],
[1.000, 1.000]
];
level.aud.envs["jam_tower_sfx_ladder_mix"] =
[
[0.00, level.aud.jam_min_vol],
[1.00, level.aud.jam_tower_stairs_min_vol]
];
level.aud.envs["jam_tower_sfx_stairs_mix"] =
[
[0.00, level.aud.jam_tower_stairs_min_vol],
[1.00, level.aud.jam_tower_stairs_max_vol]
];
level.aud.envs["jam_tower_sfx_dist_mix"] =
[
[0.00, level.aud.jam_max_vol],
[0.50, level.aud.jam_tower_stairs_max_vol + ((level.aud.jam_max_vol - level.aud.jam_tower_stairs_max_vol) * 0.33)],
[1.00, level.aud.jam_tower_stairs_max_vol]
];
level.aud.envs["nymn_hind_fire"] =
[
[0.0, 1.0],
[1.0, 0]
];
}
aud_register_trigger_callbacks()
{
callbacks = [
["aud_broadway_heli_mix_progress", ::aud_broadway_heli_mix_progress],
["aud_blownout_heli_mix_progress", ::aud_blownout_heli_mix_progress]
];
trigger_multiple_audio_register_callback(callbacks);
}
audio_msg_handler(msg, args)
{
msg_handled = true;
switch(msg)
{
case "e3_demo_fade_out":
{
fade_time = args;
assert(IsDefined(fade_time));
MM_add_submix("mute_all", fade_time);
level.aud.mus_steffanys_combat_start_e3demo_itiot = true;
}
break;
case "e3_demo_fade_in":
{
fade_time = args;
assert(IsDefined(fade_time));
AZM_start_zone("nymn_jewelry_store_street");
wait(0.05);
MM_clear_submix("mute_all", fade_time);
}
break;
case "start_manhattan_battle":
{
wait(0.05);
thread aud_intro_humvee_crash();
music_cue("mus_intro");
}
break;
case "start_no_briefing":
{
AZM_start_zone("nymn_intro_street");
music_cue("mus_taxi_smash");
}
break;
case "start_fifteen_broad":
{
AZM_start_zone("nymn_broadway_entrance");
music_cue("mus_broad_lobby");
}
break;
case "start_stephanies_battle":
{
AZM_start_zone("nymn_back_alley");
}
break;
case "start_nyse":
{
AZM_start_zone("nymn_stock_exchange");
music_cue("mus_stock_exchange_lobby");
}
break;
case "start_jammer":
{
AZM_start_zone("nymn_rooftop");
music_cue("mus_to_stock_exchange_roof");
aud_jam_tower_set_enable(true);
aud_jam_tower_scale_vol(level.aud.jam_tower_stairs_min_vol);
}
break;
case "start_hind_ride_flight":
{
level.player_hind Vehicle_TurnEngineOff();
VM_start_preset("blackhawk", "nymn_player_hind", level.player_hind);
AZM_start_zone("nymn_hind_ride");
MM_add_submix("nymn_hind_ride_pre_chase", 3);
}
break;
case "start_hind_finale":
{
level.player_hind Vehicle_TurnEngineOff();
VM_start_preset("blackhawk", "nymn_player_hind", level.player_hind);
AZM_start_zone("nymn_hind_ride");
}
break;
case "enter_intro_broadway_street":
{
zone_from = args;
}
break;
case "exit_intro_broadway_street":
{
zone_to = args;
}
break;
case "enter_broadway_street_entrance":
{
zone_from = args;
if (zone_from == "nymn_broadway_street")
{
level.aud.entered_15_broadway = true;
}
}
break;
case "exit_broadway_street_entrance":
{
zone_to = args;
if (zone_to == "nymn_broadway_street")
{
level.aud.entered_15_broadway = undefined;
}
}
break;
case "enter_broadway_entrance_blownout":
{
zone_from = args;
if (zone_from == "nymn_broadway_entrance")
{
VM_stop_preset_instance("broad_hind", 0.1);
}
}
break;
case "exit_broadway_entrance_blownout":
{
zone_to = args;
if (zone_to == "nymn_broadway_entrance")
{
if (IsDefined(level.broad_hind_fly))
{
VM_start_preset("broad_hind", "nymn_broad_hind", level.broad_hind_fly);
MM_set_submix_blend_value("vehicle_blend", 1.0);
}
}
}
break;
case "enter_blownout_interior_doorway":
{
zone_from = args;
}
break;
case "exit_blownout_interior_doorway":
{
zone_to = args;
if (zone_to == "back")
{
music_cue("mus_broad_hallway");
}
}
case "enter_broadway_interior_stairwell":
{
zone_from = args;
if (zone_from == "nymn_broadway_interior")
{
}
}
break;
case "exit_broadway_interior_stairwell":
{
zone_to = args;
if (zone_to == "nymn_broadway_stairwell")
{
thread aud_do_flashbang_occlusion();
music_cue("mus_broad_stairwell");
}
else
{
music_cue("mus_broad_hallway");
}
}
break;
case "enter_broadway_stairwell_alley":
{
zone_from = args;
}
break;
case "exit_broadway_stairwell_alley":
{
zone_to = args;
}
break;
case "enter_alley_jewelry_store":
{
zone_from = args;
if (zone_from == "nymn_back_alley")
{
thread aud_mus_tiffs_first_encounter();
}
}
break;
case "exit_alley_jewelry_store":
{
zone_to = args;
if (zone_to == "nymn_jewelry_store")
{
aud_set_music_submix(1.0, 3.0);
}
}
break;
case "enter_jewelry_store_street":
{
zone_from = args;
}
break;
case "exit_jewelry_store_street":
{
zone_to = args;
if (zone_to == "nymn_jewelry_store_street")
{
if (!IsDefined(level.aud.mus_jewelry_store_street))
{
level.aud.mus_jewelry_store_street = true;
wait(0.25);
aud_play_2d_sound("nymn_stephanys_flyby");
}
}
}
break;
case "enter_street_stock_exchange":
{
zone_from = args;
if (zone_from == "nymn_jewelry_store_street")
{
music_cue("mus_stock_exchange_lobby");
}
}
break;
case "exit_street_stock_exchange":
{
zone_to = args;
}
break;
case "enter_stock_exchange_rooftop":
{
zone_from = args;
}
break;
case "exit_stock_exchange_rooftop":
{
zone_to = args;
}
break;
case "aud_exit_jamming_tower_stairs":
{
}
break;
case "aud_enter_jamming_tower_stairs":
{
}
break;
case "aud_ladder_to_jammer_progress":
{
progress = args;
if (!flag("thermite_detonated"))
{
if (progress > 0)
{
if (!aud_jam_tower_get_enable())
{
aud_jam_tower_set_enable(true);
}
vol = aud_map_range(progress, 0, 1.0, level.aud.envs["jam_tower_sfx_ladder_mix"]);
aud_jam_tower_scale_vol(vol);
}
else
{
aud_jam_tower_set_enable(false);
}
}
}
break;
case "aud_stairs_to_jammer_progress":
{
progress = args;
if ( aud_jam_tower_get_enable() && !flag("thermite_detonated"))
{
vol = aud_map_range(progress, 0, 1.0, level.aud.envs["jam_tower_sfx_stairs_mix"]);
aud_jam_tower_scale_vol(vol);
level.aud.jam_tower_player_on_platform = (progress == 1.0);
}
}
break;
case "entering_stockexchange_before_vo":
{
}
break;
case "entering_stockexchange_after_vo":
{
}
break;
case "broadway_heli_mix_enter":
{
if (args == "front")
{
MM_add_submix_blend("broad_hind_on", "broad_hind_off", "vehicle_blend", 0.0);
level.aud.broadway_heli_mix_blend_preset = "vehicle_blend";
level.aud.broadway_heli_mix_env	= "aud_broadway_heli_mix_off";
}
else
{
MM_set_submix_blend_value("vehicle_blend", 1.0);
level.aud.broadway_heli_mix_blend_preset = "vehicle_blend";
level.aud.broadway_heli_mix_env	= "aud_broadway_heli_mix_off";
}
}
break;
case "blownout_heli_mix_enter":
{
}
break;
case "reset_broadway_heli_mix":
{
if (args == "front")
{
MM_clear_submix_blend("vehicle_blend");
}
}
break;
case "reset_blownout_heli_mix":
{
}
break;
case "Stryker_fire_weapon":
{
bullet_target = args;
if(IsDefined(bullet_target))
{
thread play_sound_in_space("stryker_bullet_impact", bullet_target.origin);
}
}
break;
case "intro_gaz":
{
intro_gaz = args;
if(IsDefined(intro_gaz))
{
intro_gaz waittill("death");
thread play_sound_in_space("exp_armor_vehicle", intro_gaz.origin);
}
}
break;
case "15_broad_breach_door_anim":
{
music_cue("mus_broad_door_breach");
}
break;
case "msg_audio_fx_bombshake":
{
if (level.aud.enable_fx_bombshake_duck)
{
duck_time = 2.0;
fade_in_time	= 0.3;
fade_out_time	= 2.0;
aud_duck("sewer_bomb_submix", duck_time, fade_in_time, fade_out_time);
}
thread play_sound_in_space("sewer_bombs", level.player.origin);
}
break;
case "ladder_climb_moment_explosion":
{
aud_play_2d_sound("shg_bomb_shakes_huge_ladder");
aud_play_2d_sound("nymn_falling_dirt_debris");
}
break;
case "broad_hallway_explosion":
{
}
break;
case "stairwell_bombshake_explosion":
{
aud_play_2d_sound("shg_bomb_shakes_huge_ladder");
aud_play_2d_sound("nymn_falling_dirt_debris");
}
break;
case "msg_audio_fx_ambientExp":
{
dist_explos = args;
if(!flag("aud_player_in_sewers"))
{
}
}
break;
case "russian_radio_chatter":
{
wait(2.0);
russian_radio_chatter = getent("aud_radiochatter_rus_01", "targetname");
russian_radio_chatter playsound("nymn_radiochatter_russian");
}
break;
case "aud_beehind01_spawn":
{
hind01 = args;
thread MM_add_submix("nymn_pre_stock_exchange_plaza", 0.5);
hind01 playsound("nymn_amb_hind_flyby_01");
}
break;
case "aud_beehind02_spawn":
{
hind02 = args;
hind02 playsound("nymn_amb_hind_flyby_02");
}
break;
case "aud_beehind03_spawn":
{
hind03 = args;
hind03 playsound("nymn_amb_hind_flyby_03");
}
break;
case "gaz_pre_nyse_explode":
{
tiff_hummer2 = args;
tiff_hummer2 playsound("gaz_explode_big");
DAMB_start_preset_at_point("fire_metal_med", (-381, 525, 60), "gaz_fire_nyse_01", 600, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-373, 528, 39), "gaz_fire_nyse_02", 600, 1.0);
}
break;
case "intro_stryker":
{
intro_stryker = args;
intro_stryker vehicle_TurnEngineOff();
intro_stryker thread aud_ground_vehicle_start("veh_engine_low_lp" , "null", "veh_stryker_roll_lp", "veh_stryker_idle_lp", "veh_stryker_rev", "veh_stryker_rev", "veh_stryker_breaks", "null", "intro_stryker");
}
break;
case "kill_guy_missile_incoming":
{
data_array = args;
assert(IsArray(data_array));
pos = data_array[0];
dur = data_array[1];
assert(IsDefined(pos));
assert(IsDefined(dur));
thread aud_play_sound_at("nymn_mortar_incoming", pos, dur);
}
break;
case "kill_guy_missile_explosion":
{
pos = args;
assert(IsDefined(pos));
thread play_sound_in_space("street_exploder_big_01", pos);
thread play_sound_in_space("exp_remote_missile_debris", pos);
}
break;
case "exploder_incoming":
{
data_array = args;
assert(IsArray(data_array));
exp_num = data_array[0];
exp_dur = data_array[1];
assert(IsDefined(exp_num));
assert(IsDefined(exp_dur));
exp_ent = aud_find_exploder(exp_num);
if(IsDefined(exp_ent))
{
assert(IsDefined(exp_ent.v));
pos = exp_ent.v["origin"];
assert(IsDefined(pos));
thread aud_play_sound_at("nymn_mortar_incoming", pos, exp_dur);
}
else
{
aud_print_warning("aud_find_exploder() couldn't find exploder " + exp_num);
}
}
break;
case "exploder_explosion":
{
exp_num = args;
assert(IsDefined(exp_num));
exp_ent = aud_find_exploder(exp_num);
assert(IsDefined(exp_ent));
assert(IsDefined(exp_ent.v));
pos = exp_ent.v["origin"];
assert(IsDefined(pos));
choice = RandomIntRange(0, 3);
if (choice == 0)
{
thread play_sound_in_space("street_exploder_big_01", pos);
}
else if (choice == 1)
{
thread play_sound_in_space("street_exploder_big_02", pos);
}
else
{
thread play_sound_in_space("street_exploder_big_02", pos);
thread play_sound_in_space("exp_remote_missile_debris", pos);
}
}
break;
case "building_chunk":
{
data_array = args;
assert(IsArray(data_array));
exp_num = data_array[0];
exp_delay	= data_array[1];
assert(IsDefined(exp_num));
assert(IsDefined(exp_delay));
if (exp_num == 968) return;
wait(exp_delay);
exp_ent = aud_find_exploder(exp_num);
assert(IsDefined(exp_ent));
assert(IsDefined(exp_ent.v));
pos = exp_ent.v["origin"];
assert(IsDefined(pos));
thread play_sound_in_space("nymn_intro_building_chunk_impact", pos);
}
break;
case "broad_hind_missiles":
{
hind = args[0];
NumRockets = args[1];
target = args[2];
}
break;
case "missile_fired":
{
missile = args;
if(IsDefined(missile))
missile aud_hind_handle_missiles();
}
break;
case "broad_stryker":
{
broad_stryker = args;
broad_stryker vehicle_TurnEngineOff();
broad_stryker thread aud_ground_vehicle_start("veh_engine_low_lp" , "null", "veh_stryker_roll_lp", "veh_stryker_idle_lp", "veh_stryker_rev", "veh_stryker_rev", "veh_stryker_breaks", "null", "broad_stryker_01");
}
break;
case "broad_stryker02":
{
broad_stryker02 = args;
broad_stryker02 vehicle_TurnEngineOff();
broad_stryker02 thread aud_ground_vehicle_start("veh_engine_low_lp" , "null", "veh_stryker_roll_lp", "veh_stryker_idle_lp", "veh_stryker_rev", "veh_stryker_rev", "veh_stryker_breaks", "null", "broad_stryker_02");
}
break;
case "taxi_explode":
{
music_cue("mus_taxi_smash");
}
break;
case "broad_humvee_02":
{
wait(2);
music_cue("mus_broad_frendly_humvee");
}
break;
case "humvee_1_heat_battle":
{
thread play_sound_in_space("nymn_gaz_rubble_drive_L", (-1969, 663, 138));
wait(0.3);
thread play_sound_in_space("nymn_gaz_rubble_drive_R", (-1892, 271, 138));
music_cue("mus_broad_enemy_humvees");
}
break;
case "humvee_2_heat_battle":
{
aud_print_synch("humvee_2_heat_battle");
}
break;
case "broad_hind_start":
{
broad_hind = args;
if (IsDefined(broad_hind))
{
music_cue("mus_broad_hind_arrives");
aud_print_synch("AUDIO: BROAD HIND START");
thread aud_hind_hover_gun_burst(broad_hind);
thread aud_play_linked_sound("broad_hind_inbound", broad_hind);
wait(4.0);
VM_start_preset("broad_hind", "nymn_broad_hind", broad_hind);
broad_hind Vehicle_TurnEngineOff();
}
}
break;
case "15_broad_lobby_first_vo_line":
{
music_cue("mus_broad_lobby");
}
break;
case "broad_hind_flyby":
{
thread aud_play_linked_sound("broad_hind_flyby", level.broad_hind_fly);
MM_clear_submix_blend("vehicle_blend", 1.0);
}
break;
case "broad_tvs_prime":
{
}
break;
case "broad_tvs_play":
{
}
break;
case "mulekick_kick":
{
if (!IsDefined(level.aud.mus_broadway_blownout))
{
level.aud.mus_broadway_blownout = true;
wait(3);
music_cue("mus_lobby_to_blown_out_building");
}
}
break;
case "flashbang_training_anim_begin":
{
flag_set("aud_flag_flashbang_training_anim_begin");
}
break;
case "play_fake_9_bang_chatter":
{
thread play_sound_in_space("RU_0_callout_cardinal_e", (-2435, -2120, 92));
}
break;
case "tiff_hummer2_start":
{
music_cue("mus_wall_and_broad_hummer");
}
break;
case "nyse_hind_flyover":
{
nyse_rooftop_hind = args;
if (IsDefined(nyse_rooftop_hind) && IsDefined(nyse_rooftop_hind[0]))
{
aud_print_synch("AUDIO: NYSE HIND FLYOVER");
thread aud_play_linked_sound("se_hind_flyover", nyse_rooftop_hind[0]);
wait(1.0);
thread aud_play_linked_sound("hind_missiles_flyover_01", nyse_rooftop_hind[0]);
wait(0.5);
thread aud_play_linked_sound("hind_missiles_flyover_02", nyse_rooftop_hind[0]);
}
}
break;
case "thermite_plant":
{
play_sound_in_space("thermite_attach", level.player.origin);
}
break;
case "player_UAV_use":
{
AZM_start_zone("amb_nymn_uav_rooftops", 1.5);
thread aud_remote_missile_watch();
}
break;
case "abort_UAV_control":
{
AZM_start_zone("nymn_rooftop", 0.2);
}
break;
case "remote_missle_impact":
{
explo_pos = args;
thread aud_ny_predator_explode(explo_pos);
AZM_start_zone("nymn_rooftop", 0.1);
}
break;
case "predator_dist_update":
{
dist = args;
level.aud.pred_missile_height = dist;
}
break;
case "aud_predator_hind":
{
predator_hind = args;
predator_hind Vehicle_TurnEngineOff();
VM_start_preset("predator_hind", "nymn_broad_hind", predator_hind);
predator_hind thread aud_heli_deathspin_watch();
}
break;
case "blackhawk_approach":
{
if (IsDefined(level.player_hind))
{
thread aud_play_linked_sound("se_blackhawk_approach", level.player_hind);
level.player_hind Vehicle_TurnEngineOff();
wait(2.0);
heli_loop = spawn("script_origin", level.player_hind.origin);
heli_loop linkto(level.player_hind);
thread aud_fade_sound_in(heli_loop,"nymn_blackhawk_blades_loop", 1.0, 5, true);
wait(3.0);
VM_start_preset("blackhawk", "nymn_player_hind", level.player_hind);
}
}
break;
case "blackhawk_at_roof":
{
thread aud_start_hind_ride_zone();
}
break;
case "predator_disabled":
{
MM_clear_submix("nymn_predator", 1);
}
break;
case "begin_hind_conversation":
{
}
break;
case "end_hind_conversation":
{
}
break;
case "spawn_hind02b":
{
hind02b = args;
if (IsDefined(hind02b))
{
hind02b thread monitor_hind_missiles();
wait (4);
thread aud_play_linked_sound("enemy_hind_02b", hind02b);
MM_add_submix("nymn_hind_ride_enemy_flyby", .5);
MM_add_submix("nymn_hind_ride_rockets", 1);
wait(1.5);
MM_clear_submix("nymn_hind_ride_enemy_flyby", 1);
}
}
break;
case "spawn_hind02":
{
thread aud_mus_blackhawk_cover_blown();
hind02 = args;
if (IsDefined(hind02))
{
hind02 thread monitor_hind_missiles();
}
}
break;
case "cover_blown":
{
alarm = spawn("script_origin", level.player.origin);
alarm playloopsound("heli_missile_warning");
wait(1.3);
alarm stoploopsound();
}
break;
case "start_blown_cover":
{
alarm = spawn("script_origin", level.player.origin);
wait(1);
alarm playloopsound("heli_missile_warning");
wait(1);
thread play_sound_in_space("nymn_hind_multi_rocket_by", level.player.origin);
thread play_sound_in_space("exp_missile_inc_impact_rock_02", level.player.origin);
wait(0.3);
alarm stoploopsound();
alarm delete();
MM_clear_submix("nymn_hind_ride_pre_chase", 3);
}
break;
case "spawn_hind06b":
{
hind06b = args;
MM_clear_submix("nymn_hind_ride_rockets", 0.2);
thread play_sound_in_space("enemy_hind_06b", level.player.origin);
if (IsDefined(hind06b))
{
hind06b thread monitor_hind_missiles();
}
}
break;
case "spawn_hind03b":
{
hind03b = args;
if (IsDefined(hind03b))
{
hind03b thread monitor_hind_missiles();
}
}
break;
case "surprise_follower":
{
thread play_sound_in_space("nymn_helicopter_by_close_02", level.player.origin);
}
break;
case "ny_hind_lastHit":
{
thread play_sound_in_space("nymn_hind_finale_boom_01", level.player.origin);
}
break;
case "finale_playing":
{
enemy_hind_model = args;
if (IsDefined(enemy_hind_model))
{
aud_print_synch("AUDIO: START FINALE");
thread MM_add_submix("nymn_hind_ride_finale", 0.5);
thread aud_start_hind_finale_se();
music_cue("mus_mhtn_finale");
wait(1);
thread VM_stop_preset_instance("blackhawk", 6);
}
}
break;
case "aud_hind_finale_rotor_impact":
{
aud_play_2d_sound("heli_blades_impact_concrete");
}
break;
case "ny_manhattan_fade_to_black":
{
assert(IsArray(args) && IsDefined(args[0]) && IsDefined(args[1]));
delay_time	= args[0];
fade_time = args[1];
wait(delay_time);
sfx_fade_time = fade_time * 0.5;
MM_start_preset("solo_music", sfx_fade_time);
wait(sfx_fade_time);
music_fade_time = fade_time - sfx_fade_time;
MM_start_preset("mute_all", music_fade_time);
}
break;
default:
{
msg_handled = false;
}
}
return msg_handled;
}
music_cue(msg, args)
{
thread music_msg_handler(msg, args);
}
music_msg_handler(msg, args)
{
msg_handled = true;
if (GetSubStr(msg, 0, 4) != "mus_")
return false;
level notify("kill_other_music");
level endon("kill_other_music");
switch(msg)
{
case "mus_intro":
{
wait(10);
MUS_play("nymh_intro", aud_default_music_fade_time());
}
break;
case "mus_taxi_smash":
{
aud_set_music_submix(10, 1);
wait(0.05);
MUS_play("nymh_taxi_smash", 2);
}
break;
case "mus_broad_frendly_humvee":
{
wait(0.2);
aud_set_music_submix(1, 5);
}
break;
case "mus_broad_enemy_humvees":
{
if (!IsDefined(level.aud.entered_15_broadway))
{
wait(2.5);
wait(0.5);
aud_set_music_submix(0.75, 15);
}
}
break;
case "mus_broad_hind_arrives":
{
if (!IsDefined(level.aud.entered_15_broadway))
{
wait(2);
MUS_Stop(5);
}
}
break;
case "mus_broad_lobby":
{
aud_set_music_submix(1, 0.1);
MUS_play("nymh_broad_lobby", 3);
}
break;
case "mus_broad_door_breach":
{
MUS_play("nymh_broad_door_breach", 8);
}
break;
case "mus_lobby_to_blown_out_building":
{
level.aud.mus_broadway_blownout = true;
MUS_play("nymh_blown_out_building", 0, 6);
wait(1);
aud_set_music_submix(1.0, 30);
}
break;
case "mus_broad_hallway":
{
if (!IsDefined(level.aud.mus_broad_hallway))
{
level.aud.mus_broad_hallway = true;
MUS_play("nymh_broad_hallway", 5, undefined, undefined, true);
}
}
break;
case "mus_broad_stairwell":
{
if (!IsDefined(level.aud.mus_broad_stairwell))
{
level.aud.mus_broad_stairwell = true;
wait(4);
MUS_stop(20.0);
}
}
break;
case "mus_broad_stairwell_to_interior":
{
aud_set_music_submix(1.0, 5.0);
}
break;
case "mus_flashbang_open_door":
{
MUS_play("nymh_flashbang_open_door", 0, undefined, undefined, true);
aud_set_music_submix(1, 4);
}
break;
case "mus_steffanys_first_encounter":
{
aud_set_music_submix(1.0, 0.05);
MUS_play("nymh_flashbang_open_door", 0, undefined, undefined, true);
}
break;
case "mus_steffanys_combat_start":
{
if (!IsDefined(level.aud.mus_steffanys_combat_start_e3demo_itiot))
{
aud_set_music_submix(100, 2);
MUS_play("nymh_steffanys_combat_start", 2, 4);
wait(11);
aud_set_music_submix(1, 2);
MUS_play("nymh_steffanys_vamp", 0, 2);
}
}
break;
case "mus_steffanys_combat_done":
{
wait(1);
MUS_play("nymh_steffanys_combat_done", 5, 10);
}
break;
case "mus_wall_street_ambush":
{
}
break;
case "mus_wall_and_broad_hummer":
{
}
break;
case "mus_stock_exchange_lobby":
{
if (!IsDefined(level.aud.mus_stock_exchange_lobby))
{
level.aud.mus_stock_exchange_lobby = true;
aud_set_music_submix(100.0, 5);
wait(0.1);
MUS_play("nymh_stock_exchange_lobby", 1);
wait(3);
MM_clear_submix("nymn_pre_stock_exchange_plaza", 5);
}
}
break;
case "mus_nyse_combat_start":
{
aud_set_music_submix(1.0, 5);
wait(0.1);
MUS_play("nymh_stock_exchange_combat_start", 10);
}
break;
case "mus_to_stock_exchange_roof":
{
aud_set_music_submix(100, 1);
MUS_play("nymh_to_stock_exchange_roof", 16);
}
break;
case "mus_dialog_get_up_ladder":
{
}
break;
case "mus_stock_exchange_roof_combat_done":
{
aud_set_music_submix(.75, 1.5);
wait(2);
MUS_play("nymh_to_stock_exchange_end", 0, 4);
wait(2);
aud_set_music_submix(1, 2);
MUS_play("nymh_destroy_the_jammer", 8);
}
break;
case "mus_jamming_tower_explodes":
{
MUS_stop(3);
wait(3);
aud_set_music_submix(1, 1);
}
break;
case "mus_predetor":
{
wait(0.1);
MUS_play("nymh_predetor", 0);
}
break;
case "mus_player_enters_hind":
{
MUS_Stop(3);
wait(3);
aud_set_music_submix(1, 1);
}
break;
case "mus_blackhawk_cover_blown":
{
MM_add_submix("mus_blackhawk_cover_blown_submix", 0.1);
wait(4);
MUS_play("nymh_blackhawk_cover_blown", 0);
wait(4);
MM_clear_submix("mus_blackhawk_cover_blown_submix", 10);
}
break;
case "mus_mhtn_finale":
{
aud_set_music_submix(100.0, 0);
MUS_play("nymh_mhtn_finale");
}
break;
case "mus_vo_sandman_enroute":
{
}
break;
default:
{
msg_handled = false;
}
}
return msg_handled;
}
aud_mus_flashbang_open_door()
{
flag_wait ("flashbang_open_door");
music_cue("mus_flashbang_open_door");
}
aud_mus_tiffs_combat_start()
{
wait(3);
flag_wait("dialog_sandman_tiff_takecover");
music_cue("mus_steffanys_combat_start");
}
aud_mus_tiffs_first_encounter()
{
while (aud_get_threat_level(2) <= 0)
{
wait(0.1);
}
music_cue("mus_steffanys_first_encounter");
thread aud_mus_tiffs_combat_start();
thread aud_mus_steffanys_combat_done();
thread aud_mus_between_tiffs_and_stock_exchange();
}
aud_mus_steffanys_combat_done()
{
flag_wait("change_ally_color");
music_cue("mus_steffanys_combat_done");
}
aud_mus_to_stock_exchange_roof()
{
if( is_split_level_part( "a" ) )
{
return;
}
wait(1);
flag_wait ( "dialog_head_up_top" );
music_cue("mus_to_stock_exchange_roof");
}
aud_mus_between_tiffs_and_stock_exchange()
{
wait(1);
flag_wait("color_flag_03");
music_cue("mus_wall_street_ambush");
}
aud_mus_dialog_get_up_ladder()
{
if( is_split_level_part( "a" ) )
{
return;
}
wait(3);
flag_wait("dialog_get_up_ladder");
music_cue("mus_dialog_get_up_ladder");
}
aud_mus_player_enters_hind()
{
flag_wait("entering_hind");
music_cue("mus_player_enters_hind");
}
aud_mus_blackhawk_cover_blown()
{
flag_wait("cover_blown");
music_cue("mus_blackhawk_cover_blown");
}
aud_broadway_heli_mix_progress(progress)
{
assert(IsDefined(progress));
assert(IsDefined(level.aud.envs[level.aud.broadway_heli_mix_env]));
scalevalue = aud_map(progress, level.aud.envs[level.aud.broadway_heli_mix_env]);
fade_time = 0.01;
assert(IsDefined(level.aud.broadway_heli_mix_blend_preset));
MM_set_submix_blend_value(level.aud.broadway_heli_mix_blend_preset, scalevalue, fade_time);
}
aud_blownout_heli_mix_progress(progress)
{
}
aud_intro_humvee_crash()
{
MM_add_submix("nymn_intro_humvee_crash", 0.05);
aud_play_2d_sound("nymn_intro_humv_crash");
AZM_start_zone("nymn_intro_street");
wait(3);
aud_play_2d_sound("manhattan_hmvd_rpg");
wait(4);
MM_clear_submix("nymn_intro_humvee_crash", 3);
MM_add_submix("nymn_intro_humvee_int", 2);
}
aud_nymn_intro_start( note, flagName )
{
MM_add_submix("nymn_intro_cinematic", 1.0);
MM_clear_submix("nymn_intro_humvee_int", 1);
wait(12);
MM_clear_submix("nymn_intro_cinematic", 2);
}
aud_hind_missile_watch(hind, NumRockets, target)
{
}
aud_hind_handle_missiles()
{
missile_track = spawn("script_origin", self.origin);
missile_track linkto(self);
thread play_sound_in_space("heli_missile_launch", self.origin);
aud_play_linked_sound("heli_missile_travel_lp", self, "loop", "aud_kill_heli_missile_loop");
self waittill("death");
level notify("aud_kill_heli_missile_loop");
thread play_sound_in_space("heli_missile_explo_main", missile_track.origin);
wait(1);
if(IsDefined(missile_track))
missile_track delete();
}
aud_missile_explode_watch()
{
flag_wait("aud_missile_death");
}
aud_ny_predator_explode(explo_pos)
{
level notify("aud_predator_exploded");
thread play_sound_in_space("exp_remote_missile_boom", explo_pos);
thread play_sound_in_space("exp_remote_missile_debris", explo_pos);
thread play_sound_in_space("predator_impact_2d", explo_pos);
thread play_sound_in_space("predator_impact_boom_2d", explo_pos);
move_ent_01 = Spawn("script_origin", explo_pos);
streamer_height = (explo_pos + (0,0,3000));
move_ent_01 playsound("explo_streamer", explo_pos);
wait(0.2);
move_ent_01 moveto(streamer_height, 1);
}
aud_remote_missile_watch(dist)
{
dist = level.aud.pred_missile_height;
}
aud_heli_deathspin_watch()
{
self waittill("deathspin");
thread VM_stop_preset_instance("predator_hind", 2);
self playsound("broad_hind_shot_down_right", "sounddone");
self playsound("broad_hind_shot_down_left");
wait(0.4);
self playsound("heli_explode_sweetener");
}
aud_ground_vehicle_start(move_lo_lp ,move_hi_lp, rolling_lp, idle_lp, engine_rev_lo_os, engine_rev_hi_os, breaks_os, random_os, instance_name)
{
death = "_died!";
flag_init(instance_name + death);
level endon(instance_name + death);
vehicle_ent = self;
if(!IsDefined(vehicle_ent))
{
AssertMsg( "vehicle you are trying to use is undefined");
}
veh_aliases = [];
veh_aliases[0] = move_lo_lp;
veh_aliases[1] = move_hi_lp;
veh_aliases[2] = rolling_lp;
veh_aliases[3] =	idle_lp;
veh_aliases[4] =	engine_rev_lo_os;
veh_aliases[5]	=	engine_rev_hi_os;
veh_aliases[6]	=	breaks_os;
veh_aliases[7] =	random_os;
aud_vehicle_engine(vehicle_ent, veh_aliases, instance_name);
}
aud_vehicle_engine(vehicle_ent, veh_aliases, instance_name)
{
death = "_died!";
level endon(instance_name + death);
level.aud.stryker_revd = false;
level.aud.ents_mixed_in = false;
move_lo_lp = veh_aliases[0];
move_hi_lp =	veh_aliases[1];
rolling_lp = veh_aliases[2];
idle_lp =	veh_aliases[3];
engine_rev_lo_os	= veh_aliases[4];
engine_rev_hi_os	= veh_aliases[5];
breaks_os = veh_aliases[6];
random_os =	veh_aliases[7];
idle_ent = Spawn( "script_origin", (vehicle_ent.origin));
idle_ent linkto(vehicle_ent);
rev_ent = Spawn( "script_origin", (vehicle_ent.origin));
rev_ent linkto(vehicle_ent);
move_ent = Spawn( "script_origin", (vehicle_ent.origin));
move_ent linkto(vehicle_ent);
roll_ent = Spawn( "script_origin", (vehicle_ent.origin));
roll_ent linkto(vehicle_ent);
veh_mix_ents = [];
veh_mix_ents[0] = idle_ent;
veh_mix_ents[1] = rev_ent;
veh_mix_ents[2] = move_ent;
veh_mix_ents[3] = roll_ent;
thread aud_ground_vehicle_deathwatch(vehicle_ent, instance_name);
thread aud_ground_vehicle_cleanup(vehicle_ent, instance_name, veh_mix_ents);
while(1)
{
vehicle_speed = vehicle_ent Vehicle_GetSpeed();
if(vehicle_speed > 0.5)
{
vehicle_ent speed_watch(vehicle_ent, vehicle_speed, veh_mix_ents, veh_aliases);
}
wait(0.25);
}
}
speed_watch(vehicle_ent, vehicle_speed, veh_mix_ents, veh_aliases)
{
self endon("vehicle_stopped_moving");
move_lo_lp = veh_aliases[0];
move_hi_lp = veh_aliases[1];
rolling_lp = veh_aliases[2];
idle_lp = veh_aliases[3];
engine_rev_lo_os	= veh_aliases[4];
engine_rev_hi_os	= veh_aliases[5];
breaks_os = veh_aliases[6];
random_os = veh_aliases[7];
idle_ent = veh_mix_ents[0];
rev_ent = veh_mix_ents[1];
move_ent = veh_mix_ents[2];
roll_ent = veh_mix_ents[3];
in_time = 0.5;
out_time = 1.5;
while(1)
{
old_speed = vehicle_speed;
wait(0.1);
new_speed = 0.5 + vehicle_ent Vehicle_GetSpeed();
if(new_speed >= old_speed)
{
idle_ent thread aud_ent_fade_out(0.5);
if(level.aud.stryker_revd == true)
{
roll_ent playloopsound(rolling_lp);
move_ent playloopsound(move_lo_lp);
if(level.aud.ents_mixed_in == false)
{
move_ent thread aud_ent_fade_in(in_time);
roll_ent thread aud_ent_fade_in(in_time);
level.aud.ents_mixed_in = true;
}
}
else if(level.aud.stryker_revd == false)
{
rev_ent playsound(engine_rev_lo_os);
roll_ent playloopsound(rolling_lp);
move_ent playloopsound(move_lo_lp);
if(level.aud.ents_mixed_in == false)
{
move_ent thread aud_ent_fade_in(in_time);
level.aud.ents_mixed_in = true;
}
level.aud.stryker_revd = true;
}
thread vehicle_oneshots(vehicle_ent);
}
else if(new_speed < old_speed)
{
level.aud.stryker_revd = false;
level.aud.ents_mixed_in = false;
idle_ent playloopsound(idle_lp);
idle_ent thread aud_ent_fade_in(0.5);
vehicle_ent playsound(breaks_os);
move_ent thread aud_ent_fade_out(0.5);
roll_ent stoploopsound(rolling_lp);
self notify("vehicle_stopped_moving");
}
wait(0.2);
}
}
vehicle_suspension_watch(vehicle_ent)
{
}
vehicle_oneshots(vehicle_ent)
{
rand = RandomIntRange( 1, 100 );
vehicle_oneshot = "null";
if(rand > 85)
{
}
else if(rand < 99)
{
return;
}
}
aud_ent_fade_out(fadetime)
{
assert(fadetime >= 0);
self ScaleVolume(0.0, fadetime);
}
aud_ent_fade_in(fadetime, vol_)
{
vol = 1.0;
if (IsDefined(vol_))
vol = vol_;
assert(fadetime >= 0);
self ScaleVolume(0.0);
wait(0.01);
self ScaleVolume(vol, fadetime);
}
aud_ground_vehicle_deathwatch(ent, instance_name)
{
death = "_died!";
ent waittill("death");
flag_set(instance_name + death);
}
aud_ground_vehicle_cleanup(vehicle_ent, instance_name, veh_mix_ents)
{
death = "_died!";
cleanup = "cleaned_up!";
flag_wait(instance_name + death);
play_sound_in_space("gaz_explode_debris", vehicle_ent.origin);
foreach(mix_ent in veh_mix_ents)
{
thread aud_fade_out_and_delete(mix_ent, 0.3);
}
}
aud_bathroom_sinkleak_sfx()
{
play_loopsound_in_space("emt_bathroom_sinkleak_lp", (-3425,-683,364));
}
aud_alley_environment_sfx()
{
vent_fan_large_01 = GetEnt( "aud_vent_fan_large_01", "targetname" );
vent_fan_large_01 playloopsound("emt_vent_fan_large_lp");
}
aud_metal_fire_broad()
{
burning_debris = Spawn( "script_origin", (-2513, -1271, 361));
burning_debris playloopsound("emt_metal_debris_fire");
burning_debris_car = Spawn( "script_origin", (-2712, -403, -47));
burning_debris_car playloopsound("emt_metal_debris_fire");
burning_debris_stairs = Spawn( "script_origin", (-2754, -1261, 290));
burning_debris_stairs playloopsound("emt_metal_debris_fire");
burning_debris_heliroom = Spawn( "script_origin", (-2770, -574, 345));
burning_debris_heliroom playloopsound("emt_metal_debris_fire");
burning_debris_caroutside = Spawn( "script_origin", (-686, -2120, 91));
burning_debris_caroutside playloopsound("emt_metal_debris_fire");
}
aud_15_broad_flourescent_lights()
{
play_loopsound_in_space("emt_light_fluorescent_hum_nymn",(-2231,-1378,466));
play_loopsound_in_space("emt_light_fluorescent_hum_nymn",(-2232,-1787,368));
play_loopsound_in_space("emt_light_fluorescent_hum_nymn",(-2226,-1383,269));
}
aud_briefing_done()
{
flag_wait("briefing_done" );
wait(1.5);
flag_set("enable_distant_bombShakes");
}
aud_tv_bink_movie_prime(org_name)
{
if(!IsDefined(level.aud.bink_ents))
{
level.aud.bink_ents = [];
}
level.aud.bink_ents[org_name] = getent(org_name, "targetname");
level.aud.bink_ents[org_name] thread aud_prime_stream("nymn_emt_tvnews");
}
aud_tv_bink_movie_play(org_name, damage_trigger_name)
{
if (IsDefined(level.aud.bink_ents))
{
isprimed = level.aud.bink_ents[org_name] aud_is_stream_primed("nymn_emt_tvnews");
assert(isprimed);
level.aud.bink_ents[org_name] thread aud_play_tv_syncd("nymn_emt_tvnews", damage_trigger_name);
flag_wait("flashbang_start");
if (level.aud.bink_ents[org_name])
{
level.aud.bink_ents[org_name] stopsounds();
wait(0.05);
level.aud.bink_ents[org_name] delete();
}
}
}
aud_play_tv_syncd(alias, damage_trigger)
{
if(IsDefined(self))
{
self playloopsound(alias);
trigger_wait_targetname(damage_trigger);
self stoploopsound();
wait(0.3);
self stoploopsound();
self delete();
}
}
aud_static_television()
{
thread aud_play_sound_on_tv("trigger_15_broad_lobby_tv", "org_15_broad_lobby_tv", "nymn_emt_tvnews");
thread aud_play_sound_on_tv("trigger_15_broad_upstairs_tv", "org_15_broad_upstairs_tv", "emt_tv_static_lp");
thread aud_play_sound_on_tv("trigger_15_broad_downstairs_tv", "org_15_broad_downstairs_tv", "nymn_emt_tvnews");
thread aud_play_sound_on_tv("trigger_nyse_tv", "org_nyse_tv", "nymn_emt_tvnews");
thread aud_play_loops_on_destructables_array("static_tv", "emt_tv_static_lp");
}
damb_nymn_15th_broad_stairwell()
{
DAMB_start_preset_at_point("nymn_15th_broad_stairwell", (-2709, -1263, -146), "broad_fire_stairwell", 550, 1.0);
DAMB_start_preset_at_point("nymn_15_broad_wood_stress_verb", (-2788, -1255, 175));
DAMB_start_preset_at_point("nymn_15_broad_wood_stress_verb", (-2727, -1923, 36));
}
aud_15th_broad_gasoline_spilling()
{
play_loopsound_in_space("emt_gasoline_spill_splatter", (-2792, -184, 134));
play_loopsound_in_space("nymn_emt_water_drip_splat_close", (-2963,-160,171));
play_loopsound_in_space("nymn_emt_water_drain_splash", (-2963,-160,171));
play_loopsound_in_space("nymn_emt_water_drip_splat_close", (-2576,-390,243));
play_loopsound_in_space("nymn_emt_water_drain_splash", (-2576,-390,243));
}
damb_nymn_fire_start()
{
DAMB_start_preset_at_point("fire_wood_med_tight", (-4112, -3241, -67), "intro_car_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_metal_med", (-4112, -3241, -67), "intro_car_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-945, -2847, 262), "tiff_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-1181, -2926, 55), "tiff_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-1004, -2927, 42), "tiff_03", 1000, 1.0);
DAMB_start_preset_at_point("fire_crackle_med_tight", (-902, -2716, 66), "tiff_04", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-909, -2636, 36), "tiff_05", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_sml_tight", (-2701, -456, -31), "wood_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_rock_sml", (-3826, -814, 185), "rock_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-3565, -690, 343), "wood_04", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-3664, -750, 243), "wood_12", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-3550, -175, 350), "wood_13", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2781, -379, 177), "wood_05", 600, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2515, -158, 235), "rock_03", 600, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2747, -529, 314), "wood_07", 600, 1.0);
DAMB_start_preset_at_point("fire_metal_med", (-2835, -328, 331), "metal_01", 600, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-2870, -294, 389), "wide_spread_01", 600, 1.0);
DAMB_start_preset_at_point("fire_crackle_med", (-2877, -327, 405), "wide_spread_02", 600, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2794, -396, 313), "wood_18", 700, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2513, -1271, 361), "wood_08", 600, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2781, -379, 177), "wood_15", 600, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-686, -2120, 91), "wood_06", 1000, 1.0);
DAMB_start_preset_at_point("fire_crackle_med_tight", (-471, 1856, -22), "prestock_01", 1000, 1.0);
}
aud_intro_car_debris_fall()
{
if( is_split_level_part( "b" ) )
{
return;
}
wait(11);
thread play_sound_in_space("car_debris_dust_light_03",(-4266, -3639, -42));
thread play_sound_in_space("car_debris_dust_light_01",(-4266, -3639, -40));
}
aud_intro_car_metal_heatcreaks_damb()
{
DAMB_start_preset_at_point("car_crash_interior_oneshots", (-4191, -3668, -60), "car_heatcreaks_01", 600, 1.0);
DAMB_start_preset_at_point("car_crash_interior_oneshots", (-4250, -3550, -60), "car_heatcreaks_02", 600, 1.0);
wait(9);
DAMB_start_preset_at_point("fire_wood_med_tight", (-4300, -3592, -80), "carcrash_01", 600, 1.0);
wait(10);
DAMB_stop_preset_at_point("fire_wood_med_tight", "carcrash_01", 5.0);
}
aud_intro_car_axel_squeak()
{
wait(38);
play_loopsound_in_space("car_dest_axel_idle", (-4222, -3606, -64));
play_loopsound_in_space("car_dest_axel_spin", (-4248, -3550, -44));
}
aud_intro_taxi_engine_steam()
{
play_loopsound_in_space("car_engine_steam_hiss_loop", (-4133, -3181, -75));
}
aud_street_flares()
{
play_loopsound_in_space("road_flare_lp_tight",(-141,271,2));
play_loopsound_in_space("road_flare_lp_tight",(-259,579,2));
play_loopsound_in_space("road_flare_lp_tight",(-475,980,10));
play_loopsound_in_space("road_flare_lp_tight",(-704,311,-7));
}
aud_start_flies_in_dumpsters()
{
play_loopsound_in_space("nymn_emt_fly_loop_ext", (580, -979, 70));
play_loopsound_in_space("nymn_emt_fly_loop_ext", (-2276, -2177, 66));
play_loopsound_in_space("nymn_emt_fly_loop_ext", (-2625, -2121, 65));
}
aud_15_broad_breach_flags()
{
if( is_split_level_part( "b" ) )
{
return;
}
wait(3);
flag_wait ( "15_broad_breach" );
level.aud.enable_fx_bombshake_duck = false;
flag_wait ( "15_broad_breach_go" );
level.aud.enable_fx_bombshake_duck = true;
}
aud_jam_tower_set_enable(on_state)
{
alias_L = "nymn_jamming_tower_left_lp";
alias_R = "nymn_jamming_tower_right_lp";
if (on_state && !level.aud.jam_tower_state)
{
alias_L = "nymn_jamming_tower_left_lp";
alias_R = "nymn_jamming_tower_right_lp";
level.aud.jam_ent_L = spawn("script_origin", (-1951,1323,1651));
level.aud.jam_ent_R = spawn("script_origin", (-2059,1545,1651));
assert(IsDefined(level.aud.jam_ent_L) && IsDefined(level.aud.jam_ent_R));
level.aud.jam_ent_L playloopsound(alias_L);
level.aud.jam_ent_R playloopsound(alias_R);
}
else if (!on_state & level.aud.jam_tower_state)
{
level.aud.jam_ent_L stoploopsound(alias_L);
level.aud.jam_ent_R stoploopsound(alias_R);
}
level.aud.jam_tower_state = on_state;
}
aud_jam_tower_get_enable()
{
assert(IsDefined(level.aud.jam_tower_state));
return level.aud.jam_tower_state;
}
aud_jam_tower_scale_vol(vol, fade_time_)
{
if (IsDefined(level.aud.jam_ent_L) && IsDefined(level.aud.jam_ent_R))
{
fade_time = aud_get_optional_param(fade_time_, 0.2);
level.aud.jam_ent_L ScaleVolume(vol, fade_time);
level.aud.jam_ent_R ScaleVolume(vol, fade_time);
}
}
aud_mus_jamming_tower_distance_mix_thread()
{
if( is_split_level_part( "a" ) )
{
return;
}
ent = getent ("org_thermite", "targetname");
assert(IsDefined(ent));
flag_wait("obj_climb_ladder_complete");
delta_t = 0.3;
range_min	= 0;
range_max	= undefined;
prev_dist	= 0;
next_dist	= 0;
while (!flag("thermite_detonated"))
{
wait(delta_t);
if (level.aud.jam_tower_player_on_platform)
{
next_dist = distance(level.player.origin, ent.origin);
if (!IsDefined(range_max))
{
range_max = next_dist;
}
if (next_dist != prev_dist)
{
jam_vol = aud_map_range(next_dist, range_min, range_max, level.aud.envs["jam_tower_sfx_dist_mix"]);
aud_jam_tower_scale_vol(jam_vol, delta_t);
prev_dist = next_dist;
}
}
}
music_cue("mus_jamming_tower_explodes");
}
aud_explode_jamming_tower()
{
if( is_split_level_part( "a" ) )
{
return;
}
ent = getent ( "org_thermite", "targetname" );
assert(IsDefined(ent));
flag_wait("thermite_detonated");
level.player thread aud_prime_stream("jam_tower_boom_02");
thread MM_add_submix("nymn_tower_collapse", 0.1);
aud_jam_tower_set_enable(false);
thread play_sound_in_space("jam_tower_boom_01", ent.origin);
ent playloopsound("thermite_flare_lp");
wait(1.2);
level.player playsound ("jam_tower_boom_02");
wait(1.6);
wait(3.6);
wait(4.0);
wait(0.5);
thread aud_start_jammer_area_fires();
thread MM_clear_submix("nymn_tower_collapse", 5);
wait(4.0);
thread play_sound_in_space("jam_tower_final_explo", (-2125, 1900, 1640));
thread MM_add_submix("nymn_predator", 0.1);
wait(26.0);
thread aud_start_jammer_base_fires();
ent ScaleVolume(0.0, 0.5);
wait(0.5);
ent stoploopsound("thermite_flare_lp");
ent delete();
}
aud_start_jammer_area_fires()
{
DAMB_start_preset_at_point("fire_rock_lrg", (-1999, 1970, 1562), "radar_dish_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-2038, 1895, 1564), "radar_dish_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-1758, 1655, 1559), "wire_fire_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-1557, 1789, 1559), "wire_fire_02", 1000, 1.0);
}
aud_start_jammer_base_fires()
{
DAMB_start_preset_at_point("fire_wood_med_tight", (-1975, 1361, 1582), "tower_base_side_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2110, 1381, 1634), "tower_base_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_metal_med", (-2094, 1449, 1612), "tower_base_metal_01", 1000, 1.0);
}
aud_play_sound_on_tv(damage_trigger_name, org_name, alias)
{
org = getent(org_name, "targetname");
if (IsDefined(org))
{
org playloopsound(alias);
trigger_wait_targetname(damage_trigger_name);
org stoploopsound();
}
}
aud_chopper_bladespin()
{
}
aud_hind_kill(instance)
{
assert(IsDefined(instance));
self waittill_any("deathspin", "death");
thread VM_stop_preset_instance(instance, 3.0);
}
aud_start_hind_finale_se()
{
aud_prime_and_play("nymn_hind_finale_front", 0.7);
wait(0.2);
SM_stop_ambience(1);
flag_wait("aud_hind_finale_rotor_hit");
thread aud_play_linked_sound("nymn_hind_finale_blades_impact", level.player_hind);
thread VM_start_preset("blackhawk", "nymn_player_hind", level.player_hind);
MM_clear_submix("nymn_hind_ride_finale", 2);
MM_add_submix("nymn_hind_ride_end_vo", 2);
}
aud_nymn_final_explo( note, flagName )
{
wait(1.5);
thread play_sound_in_space("nymn_explo_ammo_dump2", ( -10167, -6322.88, 3458.43 ));
}
get_nearby_teammates( dist )
{
nearby_teammates	= [];
team	= GetAIArray("allies");
if (IsDefined(team))
{
for ( i = 0; i < team.size; i++ )
{
if ( (team[ i ] != self) && ( distance( self.origin, team[ i ].origin ) <= dist ) )
{
nearby_teammates[ nearby_teammates.size ] = team[ i ];
}
}
}
return nearby_teammates;
}
aud_default_music_fade_time()
{
return 4.0;
}
aud_hind_hover_gun_burst(broad_hind)
{
aud_do_hind_hover_gun_burst(broad_hind);
if (IsDefined(level.aud.entered_15_broadway) && level.aud.entered_15_broadway)
{
if (IsDefined(level.aud.nymn_hind_fire_ent))
{
level.aud.nymn_hind_fire_ent stoploopsound();
wait(1.0);
level.aud.nymn_hind_fire_ent delete();
level.aud.nymn_hind_fire_ent = undefined;
}
}
}
aud_do_hind_hover_gun_burst(broad_hind)
{
assert(IsDefined(broad_hind));
broad_hind endon("death");
was_firing = false;
while (!IsDefined(level.aud.entered_15_broadway) || !level.aud.entered_15_broadway)
{
wait(0.1);
if (IsDefined(broad_hind.is_firing) && broad_hind.is_firing && !was_firing)
{
was_firing = true;
level.aud.nymn_hind_fire_ent = Spawn( "script_origin", level.player.origin);
level.aud.nymn_hind_fire_ent playloopsound("nymn_hind_fire");
wait(0.05);
dist = distance(broad_hind.origin, level.aud.nymn_hind_fire_ent.origin);
vol = aud_map_range(dist, 0, 36 * 200, level.aud.envs["nymn_hind_fire"]);
level.aud.nymn_hind_fire_ent ScaleVolume(vol, 0.05);
}
else if (IsDefined(broad_hind.is_firing) && !broad_hind.is_firing && was_firing)
{
was_firing = false;
ent = level.aud.nymn_hind_fire_ent;
level.aud.nymn_hind_fire_ent = undefined;
thread aud_kill_hind_hover_gun_burst(ent);
}
}
}
aud_kill_hind_hover_gun_burst(ent)
{
if (IsDefined(ent))
{
fade_time = 0.25;
ent ScaleVolume(0, fade_time);
wait(fade_time);
ent stoploopsound();
ent delete();
}
}
aud_hind_strafe_shot_down(broad_hind)
{
}
aud_hind_strafe_rpg(rpg)
{
rpg waittill("death");
if (isdefined(rpg))
rpg playsound("broad_hind_rocket_imp2", "sounddone");
}
aud_do_flashbang_occlusion()
{
isOccluded = level.player IsOcclusionEnabled("voice");
level.player SetEq("voice", 0, 0, "highshelf", -8, 850, 2);
level.player SetEq("voice", 1, 0, "highshelf", -8, 850, 2);
aud_disable_filter_setting("voice");
flag_wait("aud_flag_flashbang_training_anim_begin");
wait(4.0);
aud_enable_filter_setting("voice");
if (isOccluded)
{
level.player SetOcclusion("voice", 800, "highshelf", -8, 2);
}
else
{
level.player DeactivateEq(0, "voice", 0);
level.player DeactivateEq(1, "voice", 0);
}
}
aud_start_hind_ride_zone()
{
flag_wait("entering_hind");
AZM_start_zone("nymn_hind_ride");
MM_add_submix("nymn_hind_ride_pre_chase", 3);
}
monitor_hind_missiles()
{
self endon("deathspin");
self endon("death");
while(IsDefined(self))
{
self waittill("missile_fired", eMissile);
if (IsDefined(eMissile))
{
eMissile thread hind_missile_audio_control();
}
}
}
hind_missile_audio_control()
{
thread aud_play_linked_sound("enemy_hind_missile", self);
self waittill( "explode", origin );
thread play_sound_in_space("enemy_hind_missile_explo", origin);
}
