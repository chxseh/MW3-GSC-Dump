#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#include maps\_audio_zone_manager;
#include maps\_audio_music;
#include maps\_audio_mix_manager;
#include maps\_audio_vehicles;
#include maps\_audio_dynamic_ambi;
main()
{
if( getdvarint( "prologue_select" ) )
{
aud_set_level_fade_time(0);
}
else
{
aud_set_level_fade_time(3);
}
aud_init();
aud_config_system();
aud_init_flags();
aud_init_globals();
aud_launch_threads();
aud_launch_loops();
aud_create_level_envelop_arrays();
aud_register_trigger_callbacks();
aud_add_note_track_data();
aud_precache_presets();
aud_register_handlers();
MM_add_submix("intro_level_global_mix", 1);
}
aud_config_system()
{
set_stringtable_mapname("shg");
aud_set_occlusion("med_occlusion");
aud_set_timescale("shg_default", 20);
}
aud_init_flags()
{
flag_init("aud_rear_strafe_stomp");
flag_init("mi28_doctor_kill_flyout");
flag_init("aud_mi28_gun_occlusion_off");
flag_init("aud_maars_shed_heli_swap");
flag_init("aud_mars_dead");
flag_init("aud_stop_maars_impacts");
}
aud_init_globals()
{
if (!IsDefined(level.aud))
{
level.aud = SpawnStruct();
}
if( getdvarint( "prologue_select" ) )
{
level.aud.next_flash_back_index = 0;
level.aud.flashback_aliases =
[	["prolog_flashback1", 3.90],
["prolog_flashback2", 5.13],
["prolog_flashback3", 5.20],
["prolog_flashback4", 5.20]
];
level.aud.flashback_ent = undefined;
level.aud.maars_dmg_intensity = 0.01;
}
level.aud.first_attack_heli_played = false;
thread aud_ignore_slowmo();
}
aud_launch_threads()
{
thread aud_fireloops_start();
}
aud_launch_loops()
{
}
aud_create_level_envelop_arrays()
{
level.aud.envs["maars_lo_dmg_scale"]	=	[
[0.000, 0.000],
[0.050, 0.100],
[0.100, 0.150],
[0.200, 0.500],
[0.300, 0.600],
[0.400, 0.700],
[0.500, 0.500],
[0.600, 0.400],
[0.800, 0.200],
[1.000, 0.000]
];
level.aud.envs["maars_hi_dmg_scale"]	=	[
[0.000, 0.000],
[0.050, 0.000],
[0.100, 0.000],
[0.200, 0.000],
[0.300, 0.000],
[0.400, 0.000],
[0.500, 0.400],
[0.600, 0.600],
[0.800, 0.800],
[1.000, 1.000]
];
level.aud.envs["maars_mix_dmg_blend"]	=	[
[0.000, 0.000],
[0.050, 0.200],
[0.075, 0.300],
[0.100, 0.400],
[0.140, 0.500],
[0.180, 0.600],
[0.200, 0.800],
[0.250, 1.000],
[1.000, 1.000]
];
}
aud_register_trigger_callbacks()
{
}
aud_add_note_track_data()
{
anim.notetracks[ "aud_intro_river_sequence" ] = ::aud_intro_river_sequence;
}
aud_precache_presets()
{
}
aud_register_handlers()
{
aud_register_msg_handler(::audio_msg_handler);
aud_register_msg_handler(::music_msg_handler);
}
audio_msg_handler(msg, args)
{
msg_handled = true;
switch(msg)
{
case "start_intro":
{
MM_add_submix("prolog_intro_mix", 0.1);
wait(0.2);
heartheli = aud_play_2d_sound("prolog_intro");
heartheli scalevolume(0.25);
wait(0.05);
heartheli scalevolume(1, 6);
}
break;
case "start_intro_transition":
{
AZM_start_zone("intro_courtyard_interior");
aud_play_2d_sound("india_intro");
music_cue("mus_start_intro_transition");
}
break;
case "start_courtyard":
{
AZM_start_zone("intro_courtyard");
}
break;
case "start_escourt":
{
AZM_start_zone("intro_courtyard");
music_cue("mus_eyes_on_courtyard");
}
break;
case "start_regroup":
{
AZM_start_zone("intro_street");
music_cue("mus_eyes_on_courtyard");
}
break;
case "start_maars_shed":
{
AZM_start_zone("intro_street");
music_cue("mus_courtyard_gate_breach");
}
break;
case "start_maars_control":
{
AZM_start_zone("intro_street");
music_cue("mus_start_point_only_maars_control");
}
break;
case "start_slide":
{
AZM_start_zone("intro_shack_underground");
}
break;
case "enter_intro_temple_hallway":
{
zone_from = args;
}
break;
case "exit_intro_temple_hallway":
{
zone_to = args;
}
break;
case "enter_intro_temple_under":
{
zone_from = args;
}
break;
case "exit_intro_temple_under":
{
zone_to = args;
}
break;
case "enter_intro_courtyard_ground":
{
zone_from = args;
}
break;
case "exit_intro_courtyard_ground":
{
zone_to = args;
}
break;
case "enter_intro_street":
{
zone_from = args;
}
break;
case "exit_intro_street":
{
zone_to = args;
}
break;
case "enter_intro_street_room":
{
zone_from = args;
}
break;
case "exit_intro_street_room":
{
zone_to = args;
}
break;
case "enter_intro_street_house":
{
zone_from = args;
}
break;
case "exit_intro_street_house":
{
zone_to = args;
}
break;
case "enter_intro_shack":
{
zone_from = args;
}
break;
case "exit_intro_shack":
{
zone_to = args;
}
break;
case "enter_intro_shack_underground":
{
zone_from = args;
}
break;
case "exit_intro_shack_underground":
{
zone_to = args;
}
break;
case "enter_intro_street_maars":
{
zone_from = args;
}
break;
case "exit_intro_street_maars":
{
zone_to = args;
}
break;
case "intro_white_fade_in":
{
MM_clear_submix("prolog_intro_mix", 2);
MM_add_submix("prolog_gurney_mix", 2);
wait(6);
AZM_start_zone("intro_courtyard", 3);
music_cue("mus_gurney_scene", 3);
wait(3);
aud_start_gurney_heartbeat_loop();
}
break;
case "start_gurney_scene_heli":
{
heli = args;
assert(IsDefined(heli));
}
break;
case "cinematic_sequence_prep":
{
assert(!IsDefined(level.aud.flashback_ent));
level.aud.flashback_ent = spawn("script_origin", level.player.origin);
aud_prime_flashback();
}
break;
case "cinematic_sequence_cleanup":
{
assert(IsDefined(level.aud.flashback_ent));
level.aud.flashback_ent StopSounds();
wait(0.1);
level.aud.flashback_ent delete();
level.aud.flashback_ent = undefined;
}
break;
case "start_gurney_heartbeat":
{
aud_start_gurney_heartbeat_loop();
}
break;
case "stop_gurney_heartbeat":
{
aud_stop_gurney_heartbeat_loop();
}
break;
case "intro_fade_out_to_white":
{
aud_play_flashback_begin();
}
break;
case "intro_fade_in_from_white":
{
}
break;
case "begin_cinematic":
{
MM_add_submix("prolog_flashback_mix", 0);
alias = aud_get_curr_flashback_alias();
assert(IsString(alias));
level.aud.flashback_ent PlaySound(alias);
aud_release_primed_flashback();
if (alias == "prolog_flashback2")
{
thread aud_play_flashback2_gunshot();
}
else if (alias == "prolog_flashback3")
{
thread aud_play_flashback3_splash();
}
white_offset = aud_get_curr_flashback_white_offset();
white_offset = white_offset - 0.2;
DelayThread(white_offset, ::aud_play_flashback_end);
}
break;
case "end_cinematic":
{
MM_clear_submix("prolog_flashback_mix", 0);
aud_inc_flashback_index();
aud_prime_flashback();
}
break;
case "intro_shot_1_start":
{
level.player aud_prime_and_play_on_plr("prolog_gurney_se_chopper", 6.3);
}
break;
case "intro_shot_2_start":
{
aud_play_2d_sound("prolog_gurney_se_01");
}
break;
case "intro_shot_3_start":
{
aud_play_2d_sound("prolog_gurney_se_02");
}
break;
case "intro_shot_4_start":
{
aud_play_2d_sound("prolog_gurney_se_03");
}
break;
case "intro_shot_5_start":
{
aud_play_2d_sound("prolog_gurney_se_04");
}
break;
case "intro_opening_movie_start":
{
MM_start_preset("mute_all", 1);
}
break;
case "intro_soap_temple_start":
{
level.player thread aud_prime_stream("intro_soapcough_se");
wait(1.2);
aud_play_2d_sound("intro_soapcough_se");
}
break;
case "intro_shot_7":
{
aud_crashing_helicopter_flyin();
}
break;
case "intro_shot_8":
{
thread aud_crashing_helicopter_impact();
wait(11.0);
AZM_start_zone("intro_courtyard");
mm_add_submix("intro_courtyard_skybattle");
flag_set("aud_mi28_gun_occlusion_off");
}
break;
case "courtyard_magic_rpg_01":
{
fire_tag = args[0];
missile = args[1];
thread play_sound_in_space("heli_missile_launch", fire_tag);
aud_play_linked_sound("heli_death_missile_incoming", missile);
}
break;
case "courtyard_heli_Mi17_01":
{
if(!IsDefined(args))
return;
blade_lp = thread aud_play_linked_sound( "mi17_blades_loop", args, "loop", "kill_courtyard_heli_Mi17_01_loop");
args thread aud_heli_death_watch( blade_lp );
}
break;
case "courtyard_mi17_drone1":
{
if(!IsDefined(args[0]))
return;
}
break;
case "courtyard_mi17_drone3_kill":
{
if(!Isdefined(args))
return;
wait(7);
}
break;
case "attack_heli_mi28_1":
{
if(!IsDefined(args))
return;
}
break;
case "attack_heli_mi28_5":
{
if(!IsDefined(args))
return;
}
break;
case "attack_heli_mi28_6":
{
if(!IsDefined(args))
return;
}
break;
case "attack_heli_mi28_2":
{
if(!IsDefined(args))
return;
wait(3);
blade_ent = aud_play_linked_sound("mi28_blades_loop", args, "loop", "aud_attack_heli_mi28_2_kill_loop");
blade_ent scalevolume(0);
wait(0.05);
blade_ent scalevolume(1, 3);
wait(2);
aud_play_linked_sound("mi28_2_flyby_quick_1", args);
thread aud_delay_play_2d_sound("heli_by_lfe_long", 2.3);
thread aud_delay_play_2d_sound("heli_by_rattles_05", 2);
wait(3);
blade_ent scalevolume(0, 3);
wait(3);
}
break;
case "attack_heli_mi28_3":
{
if(!IsDefined(args))
return;
wait(6);
aud_play_linked_sound("mi28_3_long_by", args);
low_ent = aud_play_linked_sound("mi28_blades_loop", args, "loop", "aud_attack_heli_mi28_3_kill_loop");
thread aud_delay_play_2d_sound("heli_by_lfe_long", 5.6);
thread aud_delay_play_2d_sound("heli_by_rattles_04", 5.5);
wait(4);
aud_play_linked_sound("mi28_2_flyby_quick_1", args);
wait(3);
low_ent scalevolume(0.0, 3);
wait(3.05);
level notify("aud_attack_heli_mi28_3_kill_loop");
}
break;
case "attack_heli_mi28_8":
{
if(!IsDefined(args))
return;
rear_flyby_01 = aud_play_linked_sound("mi28_8_long_by", args);
wait(17.5);
second_flyby_01 = aud_play_linked_sound("mi28_8_second_pass", args);
second_flyby_02 = aud_play_linked_sound("mi28_8_second_pass_close", args);
wait(3.5);
thread aud_delay_play_2d_sound("heli_by_lfe_long", 3);
thread aud_delay_play_2d_sound("heli_by_rattles_03", 3.2);
second_flyby_03 = aud_play_linked_sound("intro_mi28_flyby_quick_3", args);
}
break;
case "attack_heli_mi28_7":
{
if(!Isdefined(args))
return;
aud_play_linked_sound("mi28_8_long_by", args);
wait(19.5);
second_flyby_01 = aud_play_linked_sound("mi28_7_second_pass", args);
second_flyby_02 = aud_play_linked_sound("mi28_7_second_pass_close", args);
level.player thread aud_prime_stream("intro_mi28_flyby_quick_2");
wait(4);
second_flyby_03 = aud_play_linked_sound("intro_mi28_flyby_quick_2", args);
}
break;
case "courtyard_helicopter4_kill":
{
if(!IsDefined(args))
return;
blades_ent = aud_play_linked_sound("mi28_blades_loop", args, "loop", "aud_courtyard_helicopter4_kill_loop");
args waittill("death");
thread play_sound_in_space("courtyard_helicopter4_kill", blades_ent.origin);
}
break;
case "escort_doc_down_mi28":
{
if(!IsDefined(args))
return;
wait(3);
blades_ent = aud_play_linked_sound("mi28_blades_loop", args, "loop", "aud_attack_heli_mi28_2_kill_loop");
blades_ent scalevolume(0);
wait(0.05);
blades_ent scalevolume(1, 5);
wait(2);
incoming_ent = aud_play_linked_sound("mi28_doctor_killer_fly_in", args);
flag_wait("mi28_doctor_kill_flyout");
blades_ent scalevolume(0.75, 1);
wait(3);
blades_ent scalevolume(0, 5);
}
break;
case "mi28_doctor_killed_flyout":
{
if(!IsDefined(args))
return;
wait(3);
thread aud_delay_play_2d_sound("heli_by_lfe_long", 2);
thread aud_delay_play_2d_sound("heli_by_rattles_02", 2.5);
flag_set("mi28_doctor_kill_flyout");
flyout = aud_play_linked_sound("mi28_doctor_killer_flyout", args);
wait(5);
mm_clear_submix("intro_courtyard_skybattle");
}
break;
case "escort_doorkick":
{
door = args;
wait(.6);
door playsound("intro_preshack_house_doorkick");
}
break;
case "aud_courtyard_gate_breach":
{
wait(.15);
play_sound_in_space("intro_courtyard_gatekick",(-1534, 1634, 260));
}
break;
case "aud_civilian_door_breach":
{
wait(.38);
play_sound_in_space("intro_preshack_house_doorkick",(-5177, 3759, -292));
}
break;
case "intro_civ_car_slide":
{
car = args;
car playsound("intro_carslide_slide");
}
break;
case "intro_civ_car_explode":
{
car_location = args;
play_sound_in_space("intro_carslide_explode", car_location);
}
break;
case "courtyard_start_breach":
{
static_gate_pos = (-1525, 1131, 371);
thread play_sound_in_space("courtyard_breach_explode_main", static_gate_pos);
thread play_sound_in_space("courtyard_breach_explode_dist_verb", static_gate_pos);
thread play_sound_in_space("courtyard_breach_debris_long", static_gate_pos);
}
break;
case "start_civ_runners_wave1a":
{
civ_ent_01 = args;
if (IsArray(civ_ent_01))
{
if(IsDefined( civ_ent_01[0] ))
{
civ_ent_01[0] play_loop_sound_on_entity("intro_civ_walla_male_01_firstwave");
}
}
}
break;
case "start_civ_runners_wave1b":
{
civ_ent_02 = args;
if (IsArray(civ_ent_02))
{
if(IsDefined( civ_ent_02[0] ))
{
civ_ent_02[0] play_loop_sound_on_entity("intro_civ_walla_male_01");
}
}
}
break;
case "start_civ_runners_wave1c":
{
civ_ent_03 = args;
if (IsArray(civ_ent_03))
{
if(IsDefined( civ_ent_03[0] ))
{
civ_ent_03[0] play_loop_sound_on_entity("intro_civ_walla_male_02");
}
}
}
break;
case "start_civ_runners_wave_2":
{
drones = args;
if (IsArray(drones))
{
if(IsDefined( drones[0] ))
{
drones[0] play_loop_sound_on_entity("intro_civ_walla_male_01_loud");
}
}
}
break;
case "escort_mi28_1":
{
if(!Isdefined(args))
return;
blades_ent = aud_play_linked_sound("mi28_blades_loop", args, "loop", "aud_escort_mi28_1_kill_loop");
blades_ent scalevolume(0);
wait(0.05);
blades_ent scalevolume(1, 4);
wait(2);
aud_play_linked_sound("mi28_courtyard_fly_in", args);
wait(5);
aud_play_linked_sound("mi28_courtyard_fly_out", args);
wait(4);
flag_clear("aud_mi28_gun_occlusion_off");
}
break;
case "courtyard_exit_flyby_01":
{
if(!Isdefined(args))
return;
aud_play_linked_sound("mi28_blades_loop", args, "loop","aud_courtyard_heli_flyby_kill_lp");
wait(8);
aud_play_linked_sound("mi28_streets_flyover_main", args);
}
break;
case "courtyard_exit_flyby_02":
{
if(!Isdefined(args))
return;
aud_play_linked_sound("mi28_blades_loop", args, "loop","aud_courtyard_heli_flyby_kill_lp");
wait(10);
aud_play_linked_sound("mi28_streets_flyover_02", args);
}
break;
case "regroup_mi17_1":
{
if(!Isdefined(args))
return;
aud_play_linked_sound("mi17_streets_fly_in", args);
blades_ent = aud_play_linked_sound("mi17_streets_blades_loop", args, "loop","aud_regroup_mi17_1_kill_lp");
blades_ent scalevolume(0.0);
wait(0.05);
blades_ent scalevolume(1, 3);
flag_wait( "regroup_mi17_unloaded" );
if(isdefined(args))
{
wait(0.8);
blades_ent scalevolume(0.5, 3);
aud_play_linked_sound("mi17_streets_fly_out", args);
}
}
break;
case "regroup_ending_start":
{
if(!IsDefined(args))
return;
blade_ent = aud_play_linked_sound("mi28_gate_block_blades_loop", args, "loop", "kill_gate_heli_loop");
wait(3);
inbound = aud_play_linked_sound("mi28_big_gate_inbound", args);
flag_wait("aud_maars_shed_heli_swap");
if (IsDefined(blade_ent))
{
blade_ent scalevolume(0, 3);
wait(3.05);
level notify("kill_gate_heli_loop");
}
}
break;
case "regroup_uav_gate_fly_by":
{
if(!IsDefined(args))
return;
wait(0.5);
aud_play_linked_sound("pred_by_courtyard_01", args);
}
break;
case "UAV_street_bombing":
{
if(!IsDefined(args))
return;
aud_play_linked_sound("pred_by_streets_bomb_run", args);
}
break;
case "uav_fire_missile":
{
if(!IsDefined(args))
return;
args waittill("missile_hit");
thread play_sound_in_space("pred_missile_impact_main", args.origin);
}
break;
case "worlds_slowest_helicopter_by":
{
if(!IsDefined(args))
return;
aud_play_linked_sound("mi28_by_slow", args, "loop", "aud_slow_flyby_kill_lp");
}
break;
case "intro_shed_bombshake_01":
{
aud_play_2d_sound("intro_shed_bombshake");
}
break;
case "intro_shed_bombshake_02":
{
aud_play_2d_sound("intro_shed_bombshake");
}
break;
case "maars_garage_door_opening":
{
wait(2.75);
aud_play_2d_sound("intro_shack_metaldoor_up");
}
break;
case "maars_ugv_start":
{
}
break;
case "player_maars_interact_start":
{
mm_add_submix("intro_maars_control_mix", 2);
wait(2.1);
aud_play_2d_sound("maars_bootcomp");
self thread aud_monitor_maars_impacts();
}
break;
case "maars_computer_boot_up":
{
aud_play_2d_sound("maars_comp_enter");
}
break;
case "maars_control_door_open":
{
door = args;
if(!IsDefined(door))
return;
}
break;
case "maars_player_control_start":
{
level.ugv_vehicle thread aud_maars_start_engine();
level.ugv_vehicle thread aud_maars_damage_intensity();
}
break;
case "maars_grenade_fired":
{
grenade = args;
grenade thread maars_grenade_fired();
}
break;
case "maars_damage_intensity":
{
dmg = args;
level.aud.maars_dmg_intensity = clamp(dmg, 0, 1);
}
break;
case "maars_takes_explosive_dmg":
{
}
break;
case "maars_takes_bullet_dmg":
{
}
break;
case "digital_distort_death":
{
}
break;
case "maars_attack_chopper":
{
if(!IsDefined(args))
return;
if(!level.aud.first_attack_heli_played)
{
flag_set("aud_maars_shed_heli_swap");
blade_lp = aud_play_linked_sound( "mi28_blades_loop", args, "loop", "kill_maars_attack_chopper_loop");
args thread aud_heli_death_watch( blade_lp );
blade_lp scalevolume(0);
wait(0.05);
blade_lp scalevolume(0.3, 2);
level.aud.first_attack_heli_played = true;
}
else
{
blade_lp = aud_play_linked_sound( "mi28_blades_loop", args, "loop", "kill_maars_attack_chopper_loop");
args thread aud_heli_death_watch( blade_lp );
}
}
break;
case "maars_transport_chopper":
{
if(!IsDefined(args))
return;
blade_lp = thread aud_play_linked_sound( "mi17_blades_loop_no_oc", args, "loop", "kill_maars_attack_chopper_loop");
args thread aud_heli_death_watch( blade_lp );
}
break;
case "maars_control_drone_inbound":
{
UAV = args;
thread aud_prime_and_play("maars_death_missile_incoming", 1.2);
aud_delay_play_2d_sound("maars_death_short_whoosh", 0.7, true);
wait(0.8);
MM_add_submix("intro_maars_death_mix", 0.1);
}
break;
case "uav_kill_maars":
{
flag_set("aud_mars_dead");
flag_set("aud_stop_maars_impacts");
MM_clear_submix_blend("static_death_blend", 0.2);
mm_clear_submix("intro_maars_control_mix", 2);
level notify("kill_maars_dmg_ent_lo");
level notify("kill_maars_dmg_ent_hi");
UAV = args;
thread VM_stop_preset_instance("ugv_motor_player");
thread VM_stop_preset_instance("ugv_treads_player");
thread VM_stop_preset_instance("ugv_idle_player");
explo_pos = level.player.origin;
aud_play_2d_sound("maars_death_drone_flyby");
level.player thread aud_prime_and_play_on_plr("maars_death_tumble", 1.5, true);
thread play_sound_in_space("finale_missile_impact_2d", explo_pos);
thread play_sound_in_space("finale_missile_impact_lyr", explo_pos);
thread play_sound_in_space("finale_missile_debris_long", explo_pos);
wait (.2);
thread play_sound_in_space("finale_missile_debris", explo_pos);
wait (.05);
thread aud_play_death_static();
thread aud_start_final_fires();
}
break;
case "heli_fire_missile":
{
missile = args;
thread play_sound_in_space("heli_missile_launch", missile.origin);
missile thread aud_missile_explode_watch();
}
break;
case "aud_heli_missile_explode":
{
missile = args;
}
break;
case "finale_missile_incoming":
{
missile = args;
thread aud_play_linked_sound("finale_missile_incoming", missile);
}
break;
case "finale_missile_impact":
{
explo_pos = args;
thread play_sound_in_space("finale_missile_impact_3d", explo_pos);
thread play_sound_in_space("finale_missile_impact_lyr", explo_pos);
thread play_sound_in_space("finale_mortar_lfe", explo_pos);
thread play_sound_in_space("finale_missile_debris", explo_pos);
wait(0.25);
thread play_sound_in_space("finale_missile_debris_long", explo_pos);
}
break;
case "building_event_start":
{
aud_intro_slide_sequence();
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
case "mus_gurney_scene":
{
MUS_play("intro_gurney_scene", 0);
}
break;
case "mus_start_intro_transition":
{
wait(2);
MUS_play("india_intro_transition", 5);
}
break;
case "mus_vo_nik_yurioverhere":
{
aud_set_music_submix(0.6, 10);
}
break;
case "mus_eyes_on_courtyard":
{
aud_set_music_submix(1, 3);
MUS_play("india_courtyard_combat", 3);
}
break;
case "mus_halfway_through_courtyard":
{
MUS_play("india_courtyard_half_way", 8);
}
break;
case "vo_price_moveup":
{
MUS_stop(20);
}
break;
case "mus_courtyard_gate_breach":
{
aud_set_music_submix(100, 1);
MUS_play("india_streets", 3);
}
break;
case "mus_civilian_door_breach":
{
MUS_play("india_streets_end", 3);
aud_set_music_submix(1, 5);
}
break;
case "mus_start_point_only_maars_control":
{
}
break;
case "mus_ugv_start":
{
aud_set_music_submix(100, 5);
MUS_play("india_ugv_control", 3);
}
break;
case "mus_ugv_destroyed":
{
aud_set_music_submix(1, 5);
MUS_play("india_ugv_destroyed", 3);
}
break;
case "mus_run_to_heli":
{
aud_set_music_submix(100, 5);
MUS_play("india_run_to_heli", 3);
}
break;
case "mus_player_slide":
{
MUS_stop(1);
aud_set_music_submix(1, 5);
}
break;
case "mus_emerge_from_river":
{
MUS_play("india_ending1", 5);
wait(8);
MUS_play("india_ending2", 5);
}
break;
default:
{
msg_handled = false;
}
}
return msg_handled;
}
aud_play_flashback_begin()
{
aud_play_2d_sound("intro_flashback_in");
}
aud_play_flashback_end()
{
aud_play_2d_sound("intro_flashback_out");
}
aud_play_flashback2_gunshot()
{
level.player aud_prime_and_play_on_plr("prolog_flashback2_gunshot", 5.2);
}
aud_play_flashback3_splash()
{
level.player aud_prime_and_play_on_plr("prolog_flashback3_splash", 5.1);
}
aud_start_gurney_heartbeat_loop()
{
if (!IsDefined(level.aud.gurney_heartbeat_ent))
{
level.aud.gurney_heartbeat_ent = spawn("script_origin", level.player.origin);
level.aud.gurney_heartbeat_ent PlayLoopSound("prolog_hearbeat_loop");
}
}
aud_stop_gurney_heartbeat_loop()
{
if (IsDefined(level.aud.gurney_heartbeat_ent))
{
level.aud.gurney_heartbeat_ent ScaleVolume(0.0, 0.1);
wait(0.1);
level.aud.gurney_heartbeat_ent StopLoopSound();
level.aud.gurney_heartbeat_ent delete();
level.aud.gurney_heartbeat_ent = undefined;
}
}
aud_prime_flashback()
{
alias = aud_get_curr_flashback_alias();
if (IsString(alias))
{
assert(IsString(alias));
assert(IsDefined(level.aud.flashback_ent));
level.aud.flashback_ent thread aud_prime_stream(alias, true);
}
}
aud_release_primed_flashback()
{
alias = aud_get_curr_flashback_alias();
assert(IsString(alias));
assert(IsDefined(level.aud.flashback_ent));
level.aud.flashback_ent aud_release_stream(alias);
}
aud_get_curr_flashback_alias()
{
alias = undefined;
sub_array = level.aud.flashback_aliases[level.aud.next_flash_back_index];
if (IsDefined(sub_array))
{
alias = sub_array[0];
}
return alias;
}
aud_get_curr_flashback_white_offset()
{
offset = undefined;
sub_array = level.aud.flashback_aliases[level.aud.next_flash_back_index];
if (IsDefined(sub_array))
{
offset = sub_array[1];
}
return offset;
}
aud_inc_flashback_index()
{
level.aud.next_flash_back_index++;
}
play_flashback_whoosh()
{
}
aud_start_helicopter( _name, _is_attack_heli, _alias, do_print)
{
if (!IsDefined(self))
return;
is_attack_heli = true;
name = "No_Name";
if(Isdefined( _is_attack_heli ))
{
is_attack_heli = _is_attack_heli;
}
if(Isdefined( _name ))
{
name = _name;
}
if(Isdefined( do_print ))
{
}
if( is_attack_heli )
self thread aud_attack_heli( name , _alias );
if(!is_attack_heli)
self thread aud_transport_heli( name, _alias );
}
aud_attack_heli( name , alias )
{
if(!Isdefined(self))
return;
if(!Isdefined( alias ))
alias = "mi28_blades_loop";
heli = aud_play_linked_sound( alias, self, "loop", "kill_" + name + "_loop");
heli scalevolume(0.0);
wait(0.05);
heli scalevolume(1, 3);
}
aud_transport_heli( name, alias )
{
if(!Isdefined(self))
return;
if(!Isdefined( alias ))
alias = "mi17_blades_loop";
heli = aud_play_linked_sound( alias, self, "loop", "kill_" + name + "_loop");
heli scalevolume(0.0);
wait(0.05);
heli scalevolume(1, 3);
}
aud_missile_explode_watch()
{
if(!IsDefined(self))
return;
loop_ent = aud_play_linked_sound("heli_missile_loop", self, "loop", "aud_stop_heli_missile_loop");
missile_ent = spawn( "script_origin", self.origin );
missile_ent linkto( self );
self waittill("missile_hit");
loop_ent delete();
thread play_sound_in_space("finale_missile_impact_3d", missile_ent.origin);
wait(1.5);
missile_ent delete();
}
aud_heli_death_watch( blade_lp )
{
if(!IsDefined(self))
return;
heli_track = spawn("script_origin", self.origin);
heli_track linkto( self );
self waittill("deathspin");
ds1 = thread play_sound_in_space("intro_helicopter_crash_hit", heli_track.origin);
ds2 = thread aud_play_linked_sound("intro_helicopter_crash_blades", heli_track);
ds_array = [ds1, ds2];
heli_track playloopsound("intro_heli_deathspin_engine_whine");
self waittill("death");
thread play_sound_in_space("intro_helicopter_crash_explo", heli_track.origin);
foreach( ds in ds_array)
{
if(IsDefined(ds))
ds stopsounds();
}
heli_track stopsounds();
wait(0.05);
heli_track delete();
}
aud_heli_print_msg( msg )
{
}
aud_maars_damage_intensity()
{
flag_wait("maars_control_door_open");
self thread maars_deathwatch();
level endon("aud_mars_dead");
maars_dmg_ent_lo = aud_play_linked_sound("maars_static_dmg_lo", self, "loop", "kill_maars_dmg_ent_lo");
maars_dmg_ent_hi = aud_play_linked_sound("maars_static_dmg_hi", self, "loop", "kill_maars_dmg_ent_hi");
max_dmg = 0.25;
min_dmg = 0.1;
prev_dmg = 0;
submix_added = false;
prev_maars_dmg_value = 0;
update_rate = 0.1;
while(1)
{
if(IsDefined(level.aud.maars_dmg_intensity))
{
current_dmg = level.aud.maars_dmg_intensity;
maars_dmg = aud_smooth(prev_dmg, current_dmg, 0.001);
prev_dmg = maars_dmg;
maars_lo_dmg_vol = aud_map_range(current_dmg, min_dmg, max_dmg, level.aud.envs["maars_lo_dmg_scale"]);
maars_hi_dmg_vol = aud_map_range(current_dmg, min_dmg, max_dmg, level.aud.envs["maars_hi_dmg_scale"]);
maars_dmg_value = aud_map_range(current_dmg, min_dmg, max_dmg, level.aud.envs["maars_mix_dmg_blend"]);
maars_dmg_value = clamp(maars_dmg_value, 0, 1);
maars_dmg_ent_lo scalevolume(maars_lo_dmg_vol, 0.3);
maars_dmg_ent_hi scalevolume(maars_hi_dmg_vol, 0.3);
if (!submix_added)
{
submix_added = true;
MM_add_submix_blend_to( "intro_maars_dying_mix", "static_death_blend", maars_dmg_value);
}
else if(maars_dmg_value != prev_maars_dmg_value)
{
prev_maars_dmg_value = maars_dmg_value ;
MM_set_submix_blend_value("static_death_blend", maars_dmg_value, update_rate);
}
}
wait(update_rate);
}
}
maars_deathwatch()
{
}
aud_maars_start_engine()
{
thread VM_start_preset("ugv_motor_player", "ugv_motor_player", self);
thread VM_start_preset("ugv_treads_player", "ugv_treads_player", self);
wait(1);
thread VM_start_preset("ugv_idle_player", "ugv_idle_player", self, 4.0);
}
maars_grenade_fired()
{
self thread aud_play_2d_sound("maars_grenade_launch");
self waittill("explode");
if(Isdefined(self.origin))
{
thread play_sound_in_space("maars_grenade_explode", self.origin);
}
}
aud_monitor_maars_impacts()
{
level endon("aud_stop_maars_impacts");
while(true)
{
level.player waittill( "damage", amount, attacker, direction, point, damage_type );
level.player playsound("maars_impact_dmg");
wait(0.05);
}
}
aud_ignore_slowmo()
{
SoundSetTimeScaleFactor( "announcer", 0 );
SoundSetTimeScaleFactor( "mission", 0 );
SoundSetTimeScaleFactor( "norestrict2d", 0 );
SoundSetTimeScaleFactor( "grondo2d", 0 );
}
aud_crashing_helicopter_flyin()
{
level.player aud_prime_and_play_on_plr("intro_helicrash_sequence", 3.0, true);
}
aud_crashing_helicopter_impact()
{
AZM_start_zone("intro_heli_crash", 0.05);
mus_stop();
aud_play_2d_sound("intro_helicrash_fall_impact");
level.player thread aud_prime_and_play_on_plr("intro_helicrash_aftermath", 1.7, true);
level.player thread aud_prime_and_play_on_plr("intro_helicrash_heli_fall", 9.5, true);
}
aud_intro_slide_sequence()
{
MM_add_submix("intro_slide_sequence", 0.05);
AZM_start_zone("intro_slide", 0.05);
mus_stop();
aud_delay_play_2d_sound("intro_slide_init_comp", 0.1, true);
level.player thread aud_prime_and_play_on_plr("intro_slide_drop_comp", 3.55, true);
level.player thread aud_prime_and_play_on_plr("intro_slide_house_comp", 9.84, true);
level.player thread aud_prime_and_play_on_plr("intro_slide_tube_comp", 15, true);
}
aud_intro_river_sequence( note, flagName )
{
if (!IsDefined(level.aud.aud_intro_river_sequence))
{
level.aud.aud_intro_river_sequence = true;
wait(0.05);
aud_delay_play_2d_sound("intro_river_plyr_splash_punch", 0.05, true);
level.player thread aud_prime_and_play_on_plr("intro_river_rapids_01_front", 2.834, true);
level.player thread aud_prime_and_play_on_plr("intro_river_uw_drown_front", 5.996, true);
aud_delay_play_2d_sound("intro_river_surface_02_front", 16.896, true);
level.player thread aud_prime_and_play_on_plr("intro_river_bank_rapids_rear", 18.4, true);
thread aud_river_sequence_heli_fade_in();
}
}
aud_river_sequence_heli_fade_in()
{
wait(22);
heli = aud_play_linked_sound("river_heli_pickup_2d", level.player, "loop", "aud_stop_exit_heli_lp");
heli scalevolume(0);
wait(0.05);
heli scalevolume(0.9, 8);
wait(11);
heli scalevolume(0, 15);
wait(18);
level notify("aud_stop_exit_heli_lp");
}
aud_fireloops_start()
{
DAMB_start_preset_at_point("fire_wood_med_tight", (-1484, -117, 695), "temple_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-1564, -172, 701), "temple_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-1666, -101, 699), "temple_03", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-1649, -80, 557), "temple_04", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-1539, -62, 501), "courtyard_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-1691, 53, 453), "heli_01", 1000, 1.0);
thread play_loopsound_in_space("emt_fire_metal_med", (-1691, 53, 453));
DAMB_start_preset_at_point("fire_wood_med_tight", (-1597, 125, 466), "heli_02", 1000, 1.0);
thread play_loopsound_in_space("emt_fire_metal_med", (-1597, 125, 466));
DAMB_start_preset_at_point("fire_wood_med_tight", (-1605, 277, 404), "heli_03", 1000, 1.0);
thread play_loopsound_in_space("emt_fire_metal_med", (-1491, 323, 328));
thread play_loopsound_in_space("emt_fire_metal_med", (-1672, 202, 367));
DAMB_start_preset_at_point("fire_wood_med_tight", (-749, 1985, 150), "woodtruck_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-596, 2022, 198), "woodtruck_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-2766, 2801, 201), "shoeshop_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2911, 2802, 36), "shoeshop_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-2935, 2797, 201), "tradeshop_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2648, 2806, 42), "tradeshop_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-2549, 2794, 19), "tradeshop_03", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-3397, 2463, -22), "crates_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-3498, 2380, 135), "crateshop_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med_tight", (-4246, 3717, -154), "housewall_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-3858, 3591, 1), "apt_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-4242, 3967, 93), "apt_02", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-4033, 4479, -114), "apt_03", 1000, 1.0);
}
aud_start_final_fires()
{
DAMB_start_preset_at_point("fire_wood_med", (-7493, 2992, -417), "finalhouse_01", 1000, 1.0);
DAMB_start_preset_at_point("fire_wood_med", (-7518, 2647, -587), "finalhouse_02", 1000, 1.0);
}
aud_play_death_static()
{
death_static = aud_play_linked_sound("maars_static_dmg_hi", level.player, "loop", "kill_dead_ugv_static_loop");
wait(2);
MM_clear_submix("intro_maars_death_mix", 4);
wait(2);
death_static scalevolume(0, 3);
wait(3.05);
level notify("kill_dead_ugv_static_loop");
}
