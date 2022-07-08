
#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\paris_shared;
main()
{
player_anims();
generic_human_anims();
vehicles_anims();
animated_props_anims();
script_model_anims();
maps\_hand_signals::initHandSignals();
}
#using_animtree( "player" );
player_anims()
{
level.scr_animtree[ "player_rig" ] = #animtree;
level.scr_model[ "player_rig" ] = "viewhands_player_delta";
level.scr_anim[ "player_rig" ][ "a_b_switch_pt1" ] = %paris_a_b_switch_player_pt1;
level.scr_anim[ "player_rig" ][ "a_b_switch_pt2" ] = %paris_a_b_switch_player_pt2;
addNotetrack_customFunction( "player_rig", "mask_off", maps\paris_b_code::paris_b_intro_player_mask_off, "a_b_switch_pt1" );
level.scr_anim[ "player_rig" ][ "fallen_corridor_b" ]	= %paris_delta_corridor_player_b;
level.scr_anim[ "player_rig" ][ "fallen_corridor_f" ]	= %paris_delta_corridor_player_f;
level.scr_anim[ "player_rig" ][ "volk_escape" ] = %paris_volk_escape_player;
level.scr_anim[ "player_rig" ][ "player_enter_van" ] = %paris_van_player_enter_door;
addNotetrack_customFunction( "player_rig", "rumble_small", ::anim_rumble_small, "player_enter_van" );
addNotetrack_customFunction( "player_rig", "rumble_medium", ::anim_rumble_medium, "player_enter_van" );
addNotetrack_customFunction( "player_rig", "rumble_large", ::anim_rumble_large, "player_enter_van" );
addNotetrack_customFunction( "player_rig", "vfx_window_punch_start", ::fx_window_punch, "player_enter_van" );
addNotetrack_customFunction( "player_rig", "vfx_window_punch_end", ::fx_window_punch, "player_enter_van" );
addNotetrack_customFunction( "player_rig", "vfx_window_hit_hood", ::fx_window_hit_hood, "player_enter_van" );
level.scr_anim[ "player_rig" ][ "player_gaz_barricade" ]	= %paris_chase_gaz_barricade_player;
level.scr_anim[ "player_rig" ][ "player_front_to_back" ]	= %paris_van_player_front_to_back;
addNotetrack_customFunction( "player_rig", "rumble_medium", ::anim_rumble_medium, "player_front_to_back" );
addNotetrack_customFunction( "player_rig", "rumble_large", ::anim_rumble_large, "player_front_to_back" );
level.scr_anim[ "player_rig" ][ "player_back_to_front" ]	= %paris_van_player_back_to_front;
level.scr_anim[ "player_rig" ][ "chase_ending_start" ] = %paris_chase_ending_player_start;
addNotetrack_customFunction( "player_rig", "door_kick_fx", ::fx_door_kick, "chase_ending_start" );
level.scr_anim[ "player_rig" ][ "chase_final_crash" ] = %paris_chase_final_crash_player;
addNotetrack_customFunction( "player_rig", "rumble_medium", ::anim_rumble_medium, "chase_final_crash" );
addNotetrack_customFunction( "player_rig", "rumble_large", ::anim_rumble_large, "chase_final_crash" );
}
#using_animtree("generic_human");
generic_human_anims()
{
level.scr_anim[ "generic" ][ "DRS_sprint" ] = %sprint1_loop;
level.scr_anim[ "redshirt" ] [ "a_b_switch_pt1" ] = %paris_a_b_switch_npc_pt1;
level.scr_anim[ "redshirt" ] [ "a_b_switch_pt2" ] = %paris_a_b_switch_npc_pt2;
level.scr_anim[ "lonestar" ] [ "a_b_switch_pt1" ] = %paris_a_b_switch_sandman_pt1;
level.scr_anim[ "lonestar" ] [ "a_b_switch_pt2" ] = %paris_a_b_switch_sandman_pt2;
addNotetrack_customFunction("lonestar", "dialog", maps\paris_b_vo::one_light_dialogue_notetrack, "a_b_switch_pt2");
level.scr_anim[ "generic" ][ "plant_flare" ] = %paris_delta_deply_flare_crouched_alt;
level.scr_anim[ "generic" ][ "catacombs_signal_move_out" ] = %CQB_stand_signal_move_out;
level.scr_anim[ "generic" ][ "catacombs_signal_stop" ] = %CQB_stand_signal_stop;
level.scr_anim[ "generic" ][ "catacombs_signal_quick_stop" ] = %CQB_stop_2_signal;
level.scr_anim[ "generic" ][ "catacombs_signal_look" ] = %CQB_stand_signal_twitch_look;
level.scr_anim[ "generic" ][ "catacombs_signal_quick_look" ] = %CQB_stand_signal_twitch_quicklook;
level.scr_anim[ "gign_leader" ][ "catacombs_gate_enter_enter" ] = %paris_delta_door_pry_trans_guy2;
level.scr_anim[ "redshirt" ][ "catacombs_gate_enter_enter" ] = %paris_delta_door_pry_tans_guy1;
level.scr_anim[ "gign_leader" ][ "catacombs_gate_enter_idle" ] = [ %paris_delta_door_pry_idle_guy2 ];
level.scr_anim[ "redshirt" ][ "catacombs_gate_enter_idle" ] = [ %paris_delta_door_pry_idle_guy1 ];
level.scr_anim[ "gign_leader" ][ "catacombs_gate_enter" ] = %paris_delta_door_pry_guy2;
level.scr_anim[ "redshirt" ][ "catacombs_gate_enter" ] = %paris_delta_door_pry_guy1;
level.scr_anim[ "gign_leader" ][ "squeeze_through_fallen_corridor" ] = %paris_delta_squeeze_through_fallen_corridor_a;
level.scr_anim[ "lonestar" ][ "squeeze_through_fallen_corridor" ] = %paris_delta_squeeze_through_fallen_corridor_b;
level.scr_anim[ "reno" ][ "squeeze_through_fallen_corridor" ] = %paris_delta_squeeze_through_fallen_corridor_a;
level.scr_anim[ "redshirt" ][ "squeeze_through_fallen_corridor" ] = %paris_delta_squeeze_through_fallen_corridor_b;
level.scr_anim[ "generic" ]["gate_ambush"] = %paris_catacombs_gate_ambush_enemy;
level.scr_anim[ "gign_leader" ]["gate_ambush"] = %paris_catacombs_gate_ambush;
level.scr_anim[ "guard" ][ "volk_escape" ] = %paris_volk_escape_guard;
level.scr_anim[ "volk" ][ "volk_escape" ] = %paris_volk_escape_volk;
level.scr_anim[ "gign_leader" ][ "volk_escape" ] = %paris_volk_escape_reaction;
level.scr_anim[ "sedan_guard" ][ "sedan_escape_passengers_loop"] = [ %paris_sedan_idle_backr ];
level.scr_anim[ "volk" ][ "sedan_escape" ] = %paris_sedan_enter_frontR;
level.scr_anim[ "volk" ][ "sedan_escape_loop" ] = [ %paris_sedan_idle_frontR ];
level.scr_anim[ "generic" ][ "death_pose_window" ] = %death_pose_on_window;
level.scr_anim[ "generic" ][ "death_pose_desk" ] = %death_pose_on_desk;
level.scr_anim[ "generic" ][ "death_sitting_pose_1" ] = %death_sitting_pose_v1;
level.scr_anim[ "generic" ][ "death_sitting_pose_2" ] = %death_sitting_pose_v2;
level.scr_anim[ "generic" ][ "death_pose_farmer" ] = %hunted_farmsequence_farmer_deathpose;
level.scr_anim[ "lonestar" ][ "van_ride_enter" ] = %paris_delta_van_enter;
level.scr_anim[ "lonestar" ][ "van_ride_enter_idle" ] = [ %paris_delta_van_enter_idle ];
level.scr_anim[ "generic" ][ "chase_gaz_barricade" ] = %paris_chase_gaz_barricade_guy1;
level.scr_anim[ "lonestar" ][ "van_ride_to_combat" ] = %paris_van_sandman_to_combat;
level.scr_anim[ "reno" ][ "van_driver_bullet_react" ] = %paris_delta_van_driver_bullet_react;
level.scr_anim[ "reno" ][ "van_driver_driving" ] = [ %paris_delta_van_driver_driving ];
level.scr_anim[ "reno" ][ "van_driver_driving_braced" ] = [ %paris_delta_van_driver_driving_braced ];
level.scr_anim[ "reno" ][ "van_driver_enter" ] = %paris_delta_van_driver_enter;
level.scr_anim[ "reno" ][ "van_driver_exit" ] = %paris_delta_van_driver_exit;
level.scr_anim[ "reno" ][ "van_driver_idle" ] = [ %paris_delta_van_driver_idle ];
level.scr_anim[ "reno" ][ "van_driver_impact_big" ] = %paris_delta_van_driver_impact_big;
level.scr_anim[ "reno" ][ "van_driver_impact_small" ] = %paris_delta_van_driver_impact_small;
level.scr_anim[ "reno" ][ "van_driver_start_engine" ] = %paris_delta_van_driver_start_engine;
level.scr_anim[ "reno" ][ "van_driver_turn_full_left" ] = %paris_delta_van_driver_turn_full_left;
level.scr_anim[ "reno" ][ "van_driver_turn_full_right" ] = %paris_delta_van_driver_turn_full_right;
level.scr_anim[ "reno" ][ "van_driver_turn_pose_left" ] = [ %paris_delta_van_driver_turn_pose_left ];
level.scr_anim[ "reno" ][ "van_driver_turn_pose_right" ] = [ %paris_delta_van_driver_turn_pose_right ];
level.scr_anim[ "lonestar" ][ "van_ride_fire_fwd" ] = [ %paris_delta_van_ride_fire_fwd ];
level.scr_anim[ "lonestar" ][ "van_ride_fire_left" ] = [ %paris_delta_van_ride_fire_left ];
level.scr_anim[ "lonestar" ][ "van_ride_fire_right" ] = [ %paris_delta_van_ride_fire_right ];
level.scr_anim[ "lonestar" ][ "van_ride_fire_spray" ] = %paris_delta_van_ride_fire_spray;
level.scr_anim[ "lonestar" ][ "van_ride_fire_spray_variant" ] = %paris_delta_van_ride_fire_spray_variant;
level.scr_anim[ "lonestar" ][ "van_ride_hardslam_left" ] = %paris_delta_van_ride_hardslam_left;
level.scr_anim[ "lonestar" ][ "van_ride_hardslam_right" ] = %paris_delta_van_ride_hardslam_right;
level.scr_anim[ "lonestar" ][ "van_ride_idle_fwd" ] = [ %paris_delta_van_ride_idle ];
level.scr_anim[ "lonestar" ][ "van_ride_idle_left" ] = [ %paris_delta_van_ride_idle_left ];
level.scr_anim[ "lonestar" ][ "van_ride_idle_right" ] = [ %paris_delta_van_ride_idle_right ];
level.scr_anim[ "lonestar" ][ "van_noneride_idle" ] = [ %paris_delta_van_noneride_idle ];
level.scr_anim[ "lonestar" ][ "van_ride_idle_check" ] = %paris_delta_van_ride_idle_check;
level.scr_anim[ "lonestar" ][ "van_ride_lightslam_left" ] = %paris_delta_van_ride_lightslam_left;
level.scr_anim[ "lonestar" ][ "van_ride_lightslam_right" ] = %paris_delta_van_ride_lightslam_right;
level.scr_anim[ "lonestar" ][ "van_ride_slam_left" ] = %paris_delta_van_ride_slam_left;
level.scr_anim[ "lonestar" ][ "van_ride_slam_right" ] = %paris_delta_van_ride_slam_right;
addNotetrack_customFunction("lonestar", "fire", maps\paris_b_code::lonestar_handle_fire_event, "van_ride_fire_fwd");
addNotetrack_customFunction("lonestar", "fire", maps\paris_b_code::lonestar_handle_fire_event, "van_ride_fire_left");
addNotetrack_customFunction("lonestar", "fire", maps\paris_b_code::lonestar_handle_fire_event, "van_ride_fire_right");
addNotetrack_customFunction("lonestar", "fire", maps\paris_b_code::lonestar_handle_fire_event, "van_ride_fire_spray");
addNotetrack_customFunction("lonestar", "fire", maps\paris_b_code::lonestar_handle_fire_event, "van_ride_fire_spray_variant");
level.scr_anim[ "lonestar" ][ "van_climb_paired" ] = %paris_van_climb_paired_sandman_alt;
level.scr_anim[ "generic" ][ "van_climb_paired" ] = %paris_van_climb_paired_guy1_alt;
level.scr_anim[ "generic" ][ "van_climb_paired_death" ] = [ %paris_van_climb_paired_guy1_death ];
addNotetrack_customFunction("generic", "flesh_impact", ::fx_climber_shot, "van_climb_paired");
level.scr_animtree[ "player_rig_feet" ] = #animtree;
level.scr_model [ "player_rig_feet" ] = "viewlegs_generic";
level.scr_anim [ "player_rig_feet" ][ "player_front_to_back" ] = %paris_van_playerlegs_front_to_back;
level.scr_anim [ "player_rig_feet" ][ "chase_ending_start" ] = %paris_chase_ending_player_legs_start;
level.scr_anim[ "generic" ][ "escort_gaz_crash" ] = %paris_escort_gaz_crash_guy1;
level.scr_anim[ "sedan_guard_r" ][ "ending_breach_driving_loop" ] = [ %paris_sedan_idle_backr ];
level.scr_anim[ "sedan_guard_l" ][ "ending_breach_driving_loop" ] = [ %paris_sedan_idle_backr ];
level.scr_anim[ "volk" ][ "ending_breach_driving_loop" ] = [ %paris_sedan_idle_frontR ];
level.scr_anim[ "sedan_guard_r" ][ "ending_breach_intro" ] = %paris_chase_final_crash_rearright;
level.scr_anim[ "sedan_guard_l" ][ "ending_breach_intro" ] = %paris_chase_final_crash_rearleft;
level.scr_anim[ "sedan_driver" ][ "ending_breach_intro" ] = %paris_chase_final_crash_driver;
level.scr_anim[ "volk" ][ "ending_breach_intro" ] = %paris_chase_final_crash_volk;
level.scr_anim[ "sedan_guard_r" ][ "ending_breach_death" ] = %paris_chase_final_crash_rearright_death;
level.scr_anim[ "sedan_guard_l" ][ "ending_breach_death" ] = %paris_chase_final_crash_rearleft_death;
level.scr_anim[ "sedan_driver" ][ "ending_breach_death" ] = %paris_chase_final_crash_driver_death;
level.scr_anim[ "sedan_guard_r" ][ "ending_breach_death_pose" ] = [ %paris_chase_final_crash_rearright_death_pose ];
level.scr_anim[ "lonestar" ][ "van_dismount" ] = %paris_delta_van_dismount_01;
level.scr_anim[ "gign_leader"][ "van_dismount" ] = %paris_delta_van_dismount_03;
level.scr_anim[ "ali_guard_1" ][ "terrorists_wounded_vehicle_loop" ] = [ %paris_terrorists_wounded_vehicle_exit_a_loop ];
level.scr_anim[ "ali_guard_2" ][ "terrorists_wounded_vehicle_loop" ] = [ %paris_terrorists_wounded_vehicle_exit_b_loop ];
level.scr_anim[ "ali_guard_3" ][ "terrorists_wounded_vehicle_loop" ] = [ %paris_terrorists_wounded_vehicle_exit_c_loop ];
level.scr_anim[ "ali_guard_1" ][ "terrorists_wounded_vehicle_exit_simple" ]	= %paris_terrorists_wounded_vehicle_exit_simple_guy1;
level.scr_anim[ "ali_guard_2" ][ "terrorists_wounded_vehicle_exit_simple" ]	= %paris_terrorists_wounded_vehicle_exit_simple_guy2;
level.scr_anim[ "ali_guard_3" ][ "terrorists_wounded_vehicle_exit_simple" ]	= %paris_terrorists_wounded_vehicle_exit_simple_guy3;
level.scr_anim[ "volk" ][ "chase_ending_start" ] = %paris_chase_ending_volk_start;
level.scr_anim[ "lonestar" ][ "chase_ending_start" ] = %paris_chase_ending_sandman_start;
level.scr_anim[ "volk" ][ "chase_ending_end" ] = %paris_chase_ending_volk_end;
level.scr_anim[ "lonestar" ][ "chase_ending_end" ] = %paris_chase_ending_sandman_end;
addNotetrack_customFunction("volk", "fx_glass_drag_start", ::fx_glass_drag_start, "chase_ending_start");
addNotetrack_customFunction("volk", "fx_hood_slam", ::fx_hood_slam, "chase_ending_start");
addNotetrack_customFunction("volk", "fx_ground_slam", ::fx_ground_slam, "chase_ending_end");
addNotetrack_customFunction("volk", "fx_start_drag", ::fx_start_drag, "chase_ending_end");
}
#using_animtree("vehicles");
vehicles_anims()
{
level.scr_animtree[ "bomb_truck" ] = #animtree;
level.scr_anim[ "bomb_truck" ][ "van_ride_enter" ] = %paris_delta_van_enter_vehicle;
level.scr_anim[ "bomb_truck" ][ "van_driver_enter" ] = %paris_van_driver_enter;
level.scr_anim[ "bomb_truck" ][ "player_enter_van" ] = %paris_van_side_door_open;
level.scr_anim[ "bomb_truck" ][ "player_enter_van_glass" ] = %paris_van_side_door_open_glass;
level.scr_anim[ "bomb_truck" ][ "player_front_to_back" ] = %paris_van_back_door_open;
level.scr_anim[ "bomb_truck" ][ "van_back_door_idle" ] = %paris_van_back_door_idle;
level.scr_anim[ "bomb_truck" ][ "van_back_door_open" ] = %paris_van_back_door_open;
level.scr_anim[ "bomb_truck" ][ "van_back_door_rip_off" ] = %paris_van_back_door_rip_off;
level.scr_anim[ "bomb_truck" ][ "van_driver_driving" ] = %paris_van_driver_driving;
level.scr_anim[ "bomb_truck" ][ "van_driver_driving_braced" ] = %paris_van_driver_driving;
level.scr_anim[ "bomb_truck" ][ "van_driver_impact_big" ] = %paris_van_driver_driving;
level.scr_anim[ "bomb_truck" ][ "van_driver_turn_full_left" ] = %paris_van_driver_turn_full_left;
level.scr_anim[ "bomb_truck" ][ "van_driver_turn_full_right" ] = %paris_van_driver_turn_full_right;
level.scr_anim[ "bomb_truck" ][ "van_driver_turn_pose_right" ] = %paris_van_driver_turn_pose_right;
level.scr_anim[ "bomb_truck" ][ "van_driver_turn_pose_left" ] = %paris_van_driver_turn_pose_left;
level.scr_anim[ "bomb_truck" ][ "van_driver_idle" ] = %paris_van_driver_idle;
level.scr_anim[ "bomb_truck" ][ "chase_ending_start" ] = %paris_chase_ending_van_start;
level.scr_anim[ "bomb_truck" ][ "van_driver_exit" ] = %paris_van_driver_exit;
level.scr_anim[ "bomb_truck" ][ "chase_gaz_barricade" ] = %paris_chase_gaz_barricade_armored_van;
level.scr_anim[ "gaz1" ][ "chase_gaz_barricade" ] = %paris_chase_gaz_barricade_gaz1;
level.scr_anim[ "gaz2" ][ "chase_gaz_barricade" ] = %paris_chase_gaz_barricade_gaz2;
level.scr_animtree[ "escape_sedan" ] = #animtree;
level.scr_anim[ "escape_sedan" ][ "sedan_escape" ] = %paris_sedan_peel_out;
level.scr_anim[ "escape_sedan" ][ "chase_ending_start" ] = %paris_chase_ending_sedan_start;
level.scr_anim[ "escape_sedan" ][ "chase_ending_end" ] = %paris_chase_ending_sedan_end;
addNotetrack_customFunction( "escape_sedan", "wall_impact_1", ::fx_wall_impact_1, "chase_final_crash" );
level.scr_anim[ "escape_sedan" ][ "chase_final_crash" ] = %paris_chase_final_crash_sedan;
level.scr_anim[ "bomb_truck" ][ "chase_final_crash" ] = %paris_chase_final_crash_van;
addNotetrack_customFunction( "escape_sedan", "van_impact", ::fx_van_impact, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "wall_impact_1", ::fx_wall_impact_1, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "wall_impact_2", ::fx_wall_impact_2, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "potted_plant_impact", ::fx_potted_plant_impact, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "van_crash_1", ::fx_van_crash_1, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "slide_sparks_end", ::fx_slide_sparks_end, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "stair_impact", ::fx_fence_impact, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "sedan_flip_impact_1", ::fx_sedan_flip_impact_1, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "wheel_pop_1", ::fx_wheel_pop_1, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "sedan_flip_impact_2", ::fx_sedan_flip_impact_2, "chase_final_crash" );
addNotetrack_customFunction( "escape_sedan", "van_crash_end", ::fx_van_crash_end, "chase_final_crash" );
level.scr_animtree[ "sedan" ] = #animtree;
level.scr_sound [ "tank_crush" ] = "paris_tank_crush_car";
level.scr_anim[ "sedan" ][ "tank_crush" ] = %paris_80s_sedan1_tankcrush;
level.scr_anim[ "tank" ][ "tank_crush" ] = %paris_abrams_tankcrush;
level.scr_anim[ "gaz" ][ "escort_gaz_crash" ] = %paris_escort_gaz_crash_gaz;
}
#using_animtree( "animated_props" );
animated_props_anims()
{
}
#using_animtree( "script_model" );
script_model_anims()
{
level.scr_animtree[ "player_gasmask" ] = #animtree;
level.scr_model [ "player_gasmask" ] = "paris_player_gasmask";
level.scr_anim [ "player_gasmask" ][ "a_b_switch_pt2" ] = %paris_a_b_switch_mask_pt2;
level.scr_animtree[ "catacombs_flare" ] = #animtree;
level.scr_model[ "catacombs_flare" ] = "mil_emergency_flare";
level.scr_anim[ "catacombs_flare" ][ "plant_flare" ] = %paris_delta_deply_flare_crouched_alt_flare;
level.scr_anim[ "catacombs_flare" ][ "plant_flare_idle" ] = [ %paris_delta_deply_flare_crouched_alt_flare_idle ];
level.scr_animtree[ "catacombs_gate" ] = #animtree;
level.scr_anim[ "catacombs_gate" ][ "catacombs_gate_enter" ] = %paris_delta_door_pry_door;
level.scr_model[ "crowbar" ] = "paris_crowbar_01";
level.scr_animtree[ "crowbar" ] = #animtree;
level.scr_anim[ "crowbar" ] [ "catacombs_gate_enter" ] = %paris_delta_door_pry_crowbar;
level.scr_animtree[ "ambush_gate" ] = #animtree;
level.scr_anim[ "ambush_gate" ] [ "gate_ambush" ] = %paris_catacombs_gate_ambush_door;
addNotetrack_customFunction( "ambush_gate", "gate_push", ::fx_ambush_gate, "gate_ambush" );
addNotetrack_customFunction( "ambush_gate", "gate_fall", ::fx_ambush_gate, "gate_ambush" );
level.scr_animtree[ "volk_escape_table" ] = #animtree;
level.scr_anim [ "volk_escape_table" ][ "volk_escape" ] = %paris_volk_escape_table;
level.scr_animtree[ "volk_escape_table_props" ] = #animtree;
level.scr_anim [ "volk_escape_table_props" ][ "volk_escape" ] = %paris_volk_escape_table_clutter;
addNotetrack_customFunction( "volk_escape_table", "table_flip_dust", ::fx_table_flip, "volk_escape" );
level.scr_animtree[ "final_crash_fence" ] = #animtree;
level.scr_anim [ "final_crash_fence" ][ "chase_final_crash" ] = %paris_chase_final_crash_fence;
}
fx_window_punch(guy)
{
PlayFXOnTag( getfx( "glass_punch_paris" ), guy, "J_Wrist_LE" );
PlayFXOnTag( getfx( "glass_punch_paris" ), guy, "J_Wrist_RI" );
}
fx_window_hit_hood(guy)
{
guy = level.bomb_truck;
PlayFXOnTag( getfx( "window_hit_hood" ), guy, "tag_engine_left" );
}
fx_van_impact(guy)
{
destruct_state_a = [ "hitA", "trunk", "wheel_A_KL", "wheel_A_KR" ];
swap_destruct_parts( destruct_state_a );
playfxontag(getfx("sedan_trunk_papers"), guy, "trunk");
}
fx_wall_impact_1(guy)
{
flag_set("flag_final_crash_wall_impact_1");
struct = getstruct("fruit_cart_explosion1", "targetname");
physicsexplosionsphere(struct.origin, 100, 100, 1.2);
radiusdamage(struct.origin, 150, 5000, 5000);
}
fx_wall_impact_2(guy)
{
destruct_state_b = [ "hitB", "wheel_A_FL", "wheel_A_FR" ];
swap_destruct_parts( destruct_state_b );
struct = getstruct("postcard_rack_explosion1", "targetname");
radiusdamage(struct.origin, 100, 5000, 5000);
physicsExplosionSphere(struct.origin, 150, 150, 1.2);
wait (0.1);
radiusdamage(struct.origin, 100, 5000, 5000);
wait (0.1);
radiusdamage(struct.origin, 100, 5000, 5000);
struct = getstruct("postcard_rack_explosion2", "targetname");
radiusdamage(struct.origin, 150, 5000, 5000);
physicsExplosionSphere(struct.origin, 100, 100, 1.2);
wait 0.5;
struct = getstruct("postcard_rack_explosion3", "targetname");
radiusdamage(struct.origin, 150, 5000, 5000);
physicsExplosionSphere(struct.origin, 100, 100, 1.2);
}
fx_van_crash_1(guy)
{
destruct_state_c = [ "hitC",
"TAG_GLASS_LEFT_BACK", "TAG_GLASS_RIGHT_FRONT", "TAG_GLASS_RIGHT_BACK", "TAG_GLASS_FRONT",
"doorC_FL", "doorC_KL", "doorC_FR", "doorC_KR" ];
swap_destruct_parts( destruct_state_c );
playfxontag(getfx("car_glass_med_moving"), guy, "TAG_GLASS_LEFT_BACK_FX");
playfxontag(getfx("car_glass_med_moving"), guy, "TAG_GLASS_RIGHT_FRONT_FX");
playfxontag(getfx("car_glass_med_moving"), guy, "TAG_GLASS_RIGHT_BACK_FX");
playfxontag(getfx("car_glass_large_moving"), guy, "TAG_GLASS_FRONT_FX");
van = level.bomb_truck;
PlayFXOnTag( getfx( "van_crash_1" ), van, "tag_engine_left" );
setblur(2.0, 0.1);
level.player playrumbleonentity("damage_heavy");
wait .2;
setblur(0, 0.4);
PlayFXOnTag( getfx( "van_grill_smoke" ), van, "body_animate_jnt" );
orig_wheel_back_left = spawn_tag_origin();
orig_wheel_front_left = spawn_tag_origin();
orig_wheel_back_left linkto(guy, "tag_origin", (-95,30,0), (0,0,0));
orig_wheel_front_left linkto(guy, "tag_origin", (55,30,0), (0,0,0));
while (!flag("flag_slide_sparks_end"))
{
playfxontag(getfx("sedan_skid_sparks"), orig_wheel_back_left, "tag_origin");
playfxontag(getfx("sedan_skid_sparks"), orig_wheel_front_left, "tag_origin");
wait 0.1;
}
}
fx_potted_plant_impact(guy)
{
struct = getstruct("topiary_explosion1", "targetname");
branches = getentarray("oak_branch_destructible", "targetname");
foreach(ent in branches)
{
ent hide();
}
pot = getent("topiary_explosion_pot", "targetname");
fxorigin = pot.origin;
fxangles = pot.angles;
playfx(getfx("topiary_explosion_crash"), fxorigin, anglestoforward(fxangles), anglestoup(fxangles));
pot hide();
wait 0.05;
physicsExplosionSphere(struct.origin, 75, 75, 6);
}
fx_slide_sparks_end(guy)
{
flag_set("flag_slide_sparks_end");
}
fx_fence_impact(guy)
{
flag_set("flag_stair_impact");
final_crash_fence_model_swap();
destruct_state_d = [ "hitC",
"TAG_GLASS_LEFT_FRONT", "TAG_GLASS_ROOF",
"doorC_FL", "doorC_KL", "doorC_FR", "doorC_KR" ];
swap_destruct_parts( destruct_state_d );
playfxontag(getfx("car_glass_med"), guy, "TAG_GLASS_LEFT_FRONT_FX");
playfxontag(getfx("car_glass_sunroof"), guy, "TAG_GLASS_ROOF_FX");
van = level.bomb_truck;
PlayFXOnTag( getfx( "van_fence_impact" ), van, "tag_engine_left" );
setblur(2.0, 0.1);
level.player playrumbleonentity("damage_heavy");
wait .2;
setblur(0, 0.4);
}
final_crash_fence_model_swap()
{
foreach(fence in GetEntArray("final_crash_fence_undamaged", "script_noteworthy"))
{
fence Hide();
}
foreach(fence_base in GetEntArray("final_crash_fence_broken_base", "script_noteworthy"))
{
fence_base Show();
}
level.final_crash_fence Show();
}
fx_sedan_flip_impact_1(guy)
{
destruct_state_e = [ "hitD", "TAG_GLASS_BACK" ];
swap_destruct_parts( destruct_state_e );
playfxontag(getfx("car_glass_large_moving"), guy, "TAG_GLASS_FRONT_FX");
playfxontag(getfx("car_decal_spawner"), guy, "TAG_WHEEL_FRONT_LEFT");
playfxontag(getfx("sedan_tire_smoketrail"), guy, "left_wheel_01_jnt");
exploder(9208);
}
fx_wheel_pop_1(guy)
{
playfxontag(getfx("sedan_tire_smoketrail"), guy, "left_wheel_02_jnt");
}
fx_sedan_flip_impact_2(guy)
{
playfxontag(getfx("car_decal_spawner"), guy, "TAG_DOOR_RIGHT_BACK");
playfxontag(getfx("car_decal_spawner"), guy, "TAG_DOOR_RIGHT_FRONT");
}
fx_van_crash_end(guy)
{
for ( glass = 1; glass < 10; glass++ )
{
level.bomb_truck_model maps\paris_b_code::set_glass_broken( level.bomb_truck_model, glass, true );
}
level.bomb_truck_model SetModel( "vehicle_armored_van_destroyed" );
van = level.bomb_truck;
PlayFXOnTag( getfx( "van_final_crash" ), van, "tag_engine_left" );
setblur(2.0, 0.1);
level.player playrumbleonentity("grenade_rumble");
wait .5;
setblur(0, 0.4);
exploder(9207);
}
fx_door_kick(guy)
{
playfxontag(getfx("van_door_kick"), level.bomb_truck, "door_FR");
skidmarks = getentarray("final_crash_skidmarks", "targetname");
foreach (ent in skidmarks)
{
ent show();
}
}
swap_destruct_parts( parts )
{
foreach ( part in parts )
{
level.escape_sedan_model HidePart( part );
level.escape_sedan HidePart( part );
level.escape_sedan_model ShowPart( part + "_D" );
level.escape_sedan ShowPart( part + "_D" );
}
}
fx_ambush_gate(guy)
{
playfxontag(getfx("ambush_gate_dust"), guy, "tag_fx");
}
fx_table_flip(guy)
{
exploder(62001);
}
fx_climber_shot(guy)
{
bones = ["J_SpineLower", "J_SpineUpper", "J_Spine4", "J_Neck", "J_Hip_LE", "J_Knee_LE", "J_Hip_RI", "J_Knee_RI"];
boneNum = randomInt(bones.size);
fx = ["flesh_hit", "flesh_hit_small"];
fxNum = randomInt(fx.size);
playfxontag(getfx(fx[fxNum]), guy, bones[boneNum]);
}
fx_hood_slam(guy)
{
exploder(9205);
flag_set("msg_fx_end_drag_glass");
}
fx_ground_slam(guy)
{
exploder(9206);
}
fx_glass_drag_start(guy)
{
guy endon("death");
while(!flag("msg_fx_end_drag_glass"))
{
playfxontag(getfx("drag_glass_trail"), guy, "J_SpineUpper");
wait 0.1;
}
}
fx_start_drag(guy)
{
guy endon("death");
for(;;)
{
playfxontag(getfx("body_drag_trail"), guy, "J_SpineUpper");
wait 0.2;
}
}
anim_rumble_small( guy )
{
level.player PlayRumbleOnEntity( "viewmodel_small" );
}
anim_rumble_medium( guy )
{
level.player PlayRumbleOnEntity( "viewmodel_medium" );
}
anim_rumble_large( guy )
{
level.player PlayRumbleOnEntity( "viewmodel_large" );
}