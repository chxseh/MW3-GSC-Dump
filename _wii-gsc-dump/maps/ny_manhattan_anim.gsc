#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
main()
{
player_anims();
actor_anims();
hind_anims();
vehicle_anims();
door_anims();
door_anims_02();
squad_vo();
script_models();
maps\cinematic_setups\nym_sewer_exit::main();
maps\cinematic_setups\nym_hind_finale::main();
}
#using_animtree( "player" );
player_anims()
{
level.scr_anim[ "player_rig" ][ "player_getin" ] = %roadkill_hummer_player_getin;
level.scr_anim[ "player_rig" ][ "ny_intro" ] = %ny_manhattan_intro_player;
level.scr_animtree[ "player_rig" ] = #animtree;
level.scr_model[ "player_rig" ] = "viewhands_player_delta_shg";
level.scr_anim[ "player_rig" ][ "ny_harbor_hind_entry" ] = %ny_harbor_hind_enter_viewmodel;
level.scr_animtree[ "player_legs" ] = #animtree;
level.scr_model[ "player_legs" ] = "viewlegs_generic";
level.scr_anim[ "player_legs" ][ "ny_harbor_hind_entry" ] = %ny_harbor_hind_enter_legs;
level.scr_anim[ "player_legs" ][ "ny_intro" ] = %ny_manhattan_intro_player_legs;
}
#using_animtree( "generic_human" );
actor_anims()
{
level.scr_anim[ "lonestar" ][ "mulekick_transition" ] = %ny_harbor_breech_mulekick_guy1_transition;
level.scr_anim[ "lonestar" ][ "mulekick_idle" ] = [%ny_harbor_breech_mulekick_guy1_idle];
level.scr_anim[ "lonestar" ][ "mulekick_kick" ] = %ny_harbor_breech_mulekick_guy1_kick;
level.scr_anim[ "lonestar" ][ "flashbang_training_start" ] = %ny_manhattan_signal_flashbang_delta_start;
level.scr_anim[ "lonestar" ][ "flashbang_training_end" ] = %ny_manhattan_signal_flashbang_delta_end;
level.scr_anim[ "lonestar" ][ "flashbang_training_trans" ] = %ny_manhattan_signal_flashbang_delta_intoWall;
level.scr_anim[ "lonestar" ][ "flashbang_training_idle" ] = [%ny_manhattan_signal_flashbang_delta_idleWall];
level.scr_anim[ "lonestar" ][ "ny_intro" ] = %ny_manhattan_intro_delta;
level.scr_anim[ "taxi_guy" ][ "taxi_guy_death" ] = %death_explosion_left11;
level.scr_anim[ "taxi_guy" ][ "taxi_guy_death2" ] = %death_explosion_back13;
level.scr_anim["lonestar"]["sandman_signal_go"] = %ny_manhattan_sandman_signal_towalk;
level.scr_anim["gaz_entrance_guy1"]["broad_enemy_entrance"] = %ny_manhattan_enemy_entrance_01;
level.scr_anim["gaz_entrance_guy2"]["broad_enemy_entrance"] = %ny_manhattan_enemy_entrance_02;
level.scr_anim["gaz_entrance_guy3"]["broad_enemy_entrance"] = %ny_manhattan_enemy_entrance_03;
level.scr_anim["gaz_entrance_guy4"]["broad_enemy_entrance"] = %ny_manhattan_enemy_entrance_04;
level.scr_anim["wounded_guy"]["wounded_idle"] = %ny_manhattan_wounded_drag_idle_wounded;
level.scr_anim["wounded_carrier"]["run_to"] = %ny_manhattan_wounded_run_to_carrier;
level.scr_anim["wounded_carrier"]["drag"] = %ny_manhattan_wounded_drag_carrier;
level.scr_anim["wounded_guy"]["drag"] = %ny_manhattan_wounded_drag_wounded;
level.scr_anim["wounded_carrier"]["help_loop"] [0] = %ny_manhattan_wounded_help_carrier;
level.scr_anim["wounded_guy"]["help_loop"] [0] = %ny_manhattan_wounded_help_wounded;
level.scr_anim["generic"]["radio_enter"] = %ny_manhattan_radio_into_talk;
level.scr_anim["generic"]["radio_idle"] [0] = %ny_manhattan_radio_talk_idle;
level.scr_anim["generic"]["radio_exit"] = %ny_manhattan_radio_exit_talk;
level.scr_anim["reaper_dummy"]["reaper_dummy_idle"] = %covercrouch_hide_idle;
level.scr_anim["flashbang_leader"]["pre_flashbang"] = %bog_javelin_dialogue_briefing;
level.scr_anim["lonestar"]["radio_in"] = %ny_manhattan_radio_sandman_transition_in;
level.scr_anim["lonestar"]["radio"]	= %ny_manhattan_radio_sandman_talk;
level.scr_anim["lonestar"]["radio_out"] = %ny_manhattan_radio_sandman_transition_out;
level.scr_anim["lonestar"]["blackhawk_jump"] = %ny_manhatten_rooftop_extraction_delta_jump;
level.scr_anim["lonestar"]["blackhawk_land"] = %ny_manhatten_rooftop_extraction_delta_land;
level.scr_anim["lonestar"]["blackhawk_land_idle"] [0]	= %ny_manhatten_rooftop_extraction_delta_land_idle;
level.scr_anim["lonestar"]["tower_destruct_react"] = %ny_manhattan_tower_react_guy2;
level.scr_anim["truck"]["tower_destruct_react"] = %ny_manhattan_tower_react_crouch_guy2;
level.scr_anim["reno"]["tower_destruct_react"] = %ny_manhattan_tower_react_crouch_guy1;
level.scr_anim[ "lonestar" ][ "ny_manhattan_blackhawk_idle_nl" ]= %ny_manhattan_rooftop_extraction_delta_ride_idleA;
level.scr_anim[ "lonestar" ][ "ny_manhattan_blackhawk_idle" ] [0]= %ny_manhattan_rooftop_extraction_delta_ride_idleA;
level.scr_tag[ "lonestar" ] = "tag_player";
level.scr_anim[ "truck" ][ "ny_manhattan_blackhawk_idle_nl" ]= %ny_manhattan_rooftop_extraction_delta_ride_idleB;
level.scr_anim[ "truck" ][ "ny_manhattan_blackhawk_idle" ] [0]= %ny_manhattan_rooftop_extraction_delta_ride_idleB;
level.scr_tag[ "truck" ] = "tag_player";
level.scr_anim[ "reno" ][ "ny_manhattan_blackhawk_idle_nl" ]= %ny_manhattan_rooftop_extraction_delta_ride_idleC;
level.scr_anim[ "reno" ][ "ny_manhattan_blackhawk_idle" ] [0]= %ny_manhattan_rooftop_extraction_delta_ride_idleC;
level.scr_tag[ "reno" ] = "tag_player";
level.scr_animtree[ "hind_deadguy" ] = #animtree;
level.scr_anim["hind_deadguy"]["dead_idle"] = %ny_manhattan_helicopter_dead_pose01;
level.scr_animtree[ "humvee_deadguy" ] = #animtree;
level.scr_anim["humvee_deadguy"]["dead_idle"] = %ny_manhattan_intro_deadguy;
maps\_minigun_viewmodel::anim_minigun_hands();
}
#using_animtree( "script_model" );
script_models()
{
level.scr_animtree[ "rope" ] = #animtree;
level.scr_animtree[ "nyse_flag" ] = #animtree;
level.scr_anim[ "nyse_flag" ][ "flag_flap" ][0] = %ny_manhattan_flappy_flag;
level.scr_animtree[ "tower" ] = #animtree;
level.scr_anim["tower"]["collapse"] = %ny_manhattan_radio_tower_fall;
level.scr_anim["tower"]["idle"] = %ny_manhattan_radio_tower_pre_idle;
level.scr_animtree[ "turret" ] = #animtree;
level.scr_anim["turret"]["ny_harbor_hind_entry"] = %ny_harbor_hind_enter_minigun;
level.scr_animtree[ "intro_m4" ] = #animtree;
level.scr_anim["intro_m4"]["ny_intro"] = %ny_manhattan_intro_m4;
level.scr_animtree[ "intro_knife" ] = #animtree;
level.scr_anim["intro_knife"]["ny_intro"] = %ny_manhattan_intro_spiderco_knife;
level.scr_animtree[ "intro_m4_scope" ] = #animtree;
level.scr_anim["intro_m4_scope"]["ny_intro"] = %ny_manhattan_intro_magnifier;
}
#using_animtree( "vehicles" );
hind_anims()
{
level.scr_animtree["ny_harbor_hind"] = #animtree;
level.scr_anim[ "ny_harbor_hind" ][ "rotors" ] = %bh_rotors;
level.scr_anim[ "ny_harbor_hind" ][ "approach" ]	= %ny_manhatten_rooftop_extraction_blackhawk_approach;
level.scr_anim[ "ny_harbor_hind" ][ "approach_idle" ] [0]	= %ny_manhatten_rooftop_extraction_blackhawk_idle;
load_hind_turret_anims();
}
#using_animtree( "animated_props" );
door_anims()
{
level.scr_animtree["door"] = #animtree;
level.scr_anim[ "door" ][ "closed" ] = %ny_manhattan_signal_flashbang_door_idle;
level.scr_anim[ "door" ][ "open" ] = %ny_manhattan_signal_flashbang_door_open;
}
#using_animtree( "script_model" );
door_anims_02()
{
level.scr_animtree["broad_door"] = #animtree;
level.scr_anim[ "broad_door" ][ "door_kick_door" ] = %ny_harbor_breech_mulekick_door_kick_open;
}
#using_animtree( "vehicles" );
vehicle_anims()
{
level.scr_animtree["intro_gaz"] = #animtree;
level.scr_anim[ "intro_gaz" ][ "gazcrash" ] = %ny_manhattan_gazcrash_gaz;
addNotetrack_customFunction( "intro_gaz", "vfx_wheel_smk_start", ::gazcrash_trailsmk_vfx_start, "gazcrash" );
addNotetrack_customFunction( "intro_gaz", "vfx_wheel_smk_stop", ::gazcrash_trailsmk_vfx_stop, "gazcrash" );
level.scr_animtree["intro_luxurysedan"] = #animtree;
level.scr_anim[ "intro_luxurysedan" ][ "gazcrash" ] = %ny_manhattan_gazcrash_luxurysedan;
addNotetrack_customFunction( "intro_luxurysedan", "vfx_glass_break_sedan", ::glass_break_vfx_start, "gazcrash" );
level.scr_animtree["intro_subcompact"] = #animtree;
level.scr_anim[ "intro_subcompact" ][ "gazcrash" ] = %ny_manhattan_gazcrash_subcompact;
addNotetrack_customFunction( "intro_subcompact", "vfx_glass_break_compact", ::glass_break_vfx_start, "gazcrash" );
level.scr_animtree[ "intro_humvee" ] = #animtree;
level.scr_anim[ "intro_humvee" ][ "ny_intro" ] = %ny_manhattan_intro_humvee;
level.scr_anim[ "intro_humvee" ][ "wheel_loop" ][0] = %ny_manhattan_intro_humvee_wheels;
level.scr_animtree[ "15_broad_hind" ] = #animtree;
level.scr_anim[ "15_broad_hind" ][ "blades_spin" ] [0] = %ny_manhattan_mi24p_destroy_idle;
}
gazcrash_trailsmk_vfx_start( guy )
{
PlayFXOnTag( getfx( "tread_smk_road_gaz_back" ), guy, "tag_wheel_back_left" );
PlayFXOnTag( getfx( "tread_smk_road_gaz_front" ), guy, "tag_wheel_front_left" );
PlayFXOnTag( getfx( "tread_smk_road_gaz_back" ), guy, "tag_wheel_back_right" );
PlayFXOnTag( getfx( "tread_smk_road_gaz_front" ), guy, "tag_wheel_front_right" );
}
gazcrash_trailsmk_vfx_stop( guy )
{
StopFXOnTag( getfx( "tread_smk_road_gaz_back" ), guy, "tag_wheel_back_left" );
StopFXOnTag( getfx( "tread_smk_road_gaz_front" ), guy, "tag_wheel_front_left" );
StopFXOnTag( getfx( "tread_smk_road_gaz_back" ), guy, "tag_wheel_back_right" );
StopFXOnTag( getfx( "tread_smk_road_gaz_front" ), guy, "tag_wheel_front_right" );
}
glass_break_vfx_start(guy)
{
PlayFXOnTag( getfx( "car_glass_xl" ), guy, "tag_glass_left_back_fx" );
PlayFXOnTag( getfx( "car_glass_xl" ), guy, "tag_glass_left_front_fx" );
PlayFXOnTag( getfx( "car_glass_xl" ), guy, "tag_glass_right_back_fx" );
PlayFXOnTag( getfx( "car_glass_xl" ), guy, "tag_glass_right_front_fx" );
PlayFXOnTag( getfx( "car_glass_xl" ), guy, "tag_glass_front_fx" );
PlayFXOnTag( getfx( "car_glass_xl" ), guy, "tag_glass_back_fx" );
}
#using_animtree( "vehicles" );
load_hind_turret_anims()
{
level.scr_animtree[ "hind_turret" ] = #animtree;
}
#using_animtree( "generic_human" );
squad_vo()
{
level.scr_radio[ "manhattan_hqr_newdirective" ] = "manhattan_hqr_newdirective";
level.scr_radio[ "manhattan_hqr_assaultvessel" ] = "manhattan_hqr_assaultvessel";
level.scr_radio[ "manhattan_hqr_enemybirds" ] = "manhattan_hqr_enemybirds";
level.scr_radio[ "manhattan_hqr_proceed" ] = "manhattan_hqr_proceed";
level.scr_radio[ "manhattan_hqr_backonline" ] = "manhattan_hqr_backonline";
level.scr_radio[ "manhattan_hqr_skiesclear" ] = "manhattan_hqr_skiesclear";
level.scr_radio[ "manhattan_snd_knockitout" ] = "manhattan_snd_knockitout";
level.scr_radio[ "manhattan_snd_rpgrpg" ] = "manhattan_snd_rpgrpg";
level.scr_radio[ "manhattan_snd_rogerlast" ] = "manhattan_snd_rogerlast";
level.scr_radio[ "manhattan_snd_scansectors" ] = "manhattan_snd_scansectors";
level.scr_radio[ "manhattan_snd_goodkill" ] = "manhattan_snd_goodkill";
level.scr_radio[ "manhattan_snd_russianbird" ] = "manhattan_snd_russianbird";
level.scr_radio[ "manhattan_snd_hindhindhind" ] = "manhattan_snd_hindhindhind";
level.scr_radio[ "manhattan_snd_beadonhim" ] = "manhattan_snd_beadonhim";
level.scr_radio[ "manhattan_snd_firefirefire" ] = "manhattan_snd_firefirefire";
level.scr_radio[ "manhattan_snd_werehit" ] = "manhattan_snd_werehit";
level.scr_radio[ "manhattan_snd_enroute" ] = "manhattan_snd_enroute";
level.scr_radio[ "manhattan_trk_hindsinbound" ] = "manhattan_trk_hindsinbound";
level.scr_radio[ "manhattan_trk_enemybird" ] = "manhattan_trk_enemybird";
level.scr_radio[ "manhattan_trk_stayonhim" ] = "manhattan_trk_stayonhim";
level.scr_radio[ "manhattan_trk_takingheavyfire" ] = "manhattan_trk_takingheavyfire";
level.scr_radio[ "manhattan_trk_lookout" ] = "manhattan_trk_lookout";
level.scr_radio[ "manhattan_trk_goingdown" ] = "manhattan_trk_goingdown";
level.scr_radio[ "manhattan_rno_lostem" ] = "manhattan_rno_lostem";
level.scr_radio[ "manhattan_rno_goodwork" ] = "manhattan_rno_goodwork";
level.scr_radio[ "manhattan_rno_behindbuilding" ] = "manhattan_rno_behindbuilding";
level.scr_radio[ "manhattan_rno_hangon" ] = "manhattan_rno_hangon";
level.scr_radio[ "manhattan_rno_holdon" ] = "manhattan_rno_holdon";
level.scr_radio[ "manhattan_hp1_exfilcomplete" ] = "manhattan_hp1_exfilcomplete";
level.scr_radio[ "manhattan_hp1_rightsidehigh" ] = "manhattan_hp1_rightsidehigh";
level.scr_radio[ "manhattan_hp1_evasiveaction" ] = "manhattan_hp1_evasiveaction";
level.scr_radio[ "manhattan_hp1_holdon" ] = "manhattan_hp1_holdon";
level.scr_radio[ "manhattan_hp1_pressure" ] = "manhattan_hp1_pressure";
level.scr_radio[ "manhattan_hp1_comeon" ] = "manhattan_hp1_comeon";
level.scr_radio[ "manhattan_hp1_fuel70percent" ] = "manhattan_hp1_fuel70percent";
level.scr_radio[ "manhattan_test_we_have_comms_fx" ] = "manhattan_test_we_have_comms_fx";
level.scr_radio[ "manhattan_snd_vertical" ] = "manhattan_snd_vertical";
level.scr_radio[ "manhattan_snd_getonit" ] = "manhattan_snd_getonit";
level.scr_sound["lonestar"]["lonestar_line15"] = "manhattan_snd_flankleft";
level.scr_sound["lonestar"]["lonestar_line18"] = "manhattan_snd_gohotengage";
level.scr_sound["lonestar"]["lonestar_line19"] = "manhattan_snd_presstheattack";
level.scr_sound["lonestar"]["lonestar_line23"] = "manhattan_snd_exchangemove";
level.scr_sound["lonestar"]["lonestar_line25"] = "manhattan_snd_rallytoeast";
level.scr_sound["lonestar"]["lonestar_line27"] = "manhattan_snd_inthealley";
level.scr_face["lonestar"]["lonestar_line27"] = %ny_manhattan_signal_flashbang_delta_face_start;
level.scr_sound["lonestar"]["lonestar_line28"] = "manhattan_snd_movemove";
level.scr_sound["lonestar"]["lonestar_line32"] = "manhattan_snd_provideoverwatch";
level.scr_sound["lonestar"]["lonestar_line33"] = "manhattan_snd_takecover";
level.scr_sound["lonestar"]["lonestar_line34"] = "manhattan_snd_holeinthewall";
level.scr_sound["lonestar"]["lonestar_line35"] = "manhattan_snd_westtostreet";
level.scr_sound["lonestar"]["lonestar_line37"] = "manhattan_snd_anybodyhit";
level.scr_sound["lonestar"]["lonestar_line39"] = "manhattan_snd_almostforward";
level.scr_sound["lonestar"]["lonestar_line41"] = "manhattan_snd_insideexchange";
level.scr_sound["lonestar"]["lonestar_line50"] = "manhattan_snd_pushmovemove";
level.scr_sound["lonestar"]["lonestar_line51"] = "manhattan_snd_headuptop";
level.scr_sound["lonestar"]["lonestar_line52"] = "manhattan_snd_quitdraggin";
level.scr_sound["lonestar"]["lonestar_line53"] = "manhattan_snd_rikitik";
level.scr_sound["lonestar"]["lonestar_line54"] = "manhattan_snd_speedsecurity";
level.scr_sound["lonestar"]["lonestar_line57"] = "manhattan_snd_frostupladder";
level.scr_sound["lonestar"]["lonestar_line58"] = "manhattan_snd_secondtier";
level.scr_sound["lonestar"]["lonestar_line78"] = "manhattan_snd_aimforboxesalt";
level.scr_sound["lonestar"]["lonestar_line102"] = "manhattan_snd_upthestairs";
level.scr_sound["lonestar"]["lonestar_line103"] = "manhattan_snd_holdtilmygo";
level.scr_sound["lonestar"]["lonestar_line104"] = "manhattan_snd_regroup";
level.scr_sound["lonestar"]["lonestar_line105"] = "manhattan_snd_move";
level.scr_sound["lonestar"]["lonestar_line106"] = "manhattan_snd_gogo";
level.scr_sound["lonestar"]["lonestar_line107"] = "manhattan_snd_thisway";
level.scr_sound["lonestar"]["lonestar_line108"] = "manhattan_snd_staytogether";
level.scr_sound["lonestar"]["lonestar_line116"] = "manhattan_snd_letsroll";
level.scr_sound["lonestar"]["lonestar_line123"] = "manhattan_snd_hoptherail";
level.scr_sound["lonestar"]["lonestar_line131"] = "manhattan_snd_midtown";
level.scr_sound["lonestar"]["lonestar_line132"] = "manhattan_snd_updateonair";
level.scr_sound["lonestar"]["lonestar_line133"] = "manhattan_snd_getthisdone";
level.scr_sound["lonestar"]["lonestar_line135"] = "manhattan_snd_switchedon";
level.scr_face["lonestar"]["lonestar_line135"] = %ny_manhattan_intro_delta_face_line1;
level.scr_sound["lonestar"]["lonestar_line136"] = "manhattan_snd_legit";
level.scr_face["lonestar"]["lonestar_line136"] = %ny_manhattan_intro_delta_face_line2;
level.scr_sound["lonestar"]["lonestar_line137"] = "manhattan_snd_checkpoint3b";
level.scr_sound["lonestar"]["lonestar_line138"] = "manhattan_snd_standingby";
level.scr_sound["lonestar"]["lonestar_line139"] = "manhattan_snd_establishuplink";
level.scr_sound["lonestar"]["lonestar_line140"] = "manhattan_snd_isrisopcon";
level.scr_sound["lonestar"]["lonestar_line142"] = "manhattan_snd_youownit";
level.scr_sound["lonestar"]["lonestar_line143"] = "manhattan_snd_reapersmissile";
level.scr_sound["lonestar"]["lonestar_line146"] = "manhattan_snd_hitexchange";
level.scr_sound["lonestar"]["manhattan_snd_sameasbefore"] = "manhattan_snd_sameasbefore";
level.scr_sound["lonestar"]["manhattan_snd_lessresistance"] = "manhattan_snd_lessresistance";
level.scr_sound["lonestar"]["manhattan_snd_frostfrost"] = "manhattan_snd_frostfrost";
level.scr_sound["lonestar"]["manhattan_snd_rogerthat"] = "manhattan_snd_rogerthat";
level.scr_sound["lonestar"]["manhattan_snd_youup"] = "manhattan_snd_youup";
level.scr_sound["lonestar"]["manhattan_rno_getinhere"] = "manhattan_rno_getinhere";
level.scr_sound["lonestar"]["manhattan_snd_holdup"] = "manhattan_snd_holdup";
level.scr_sound["lonestar"]["manhattan_snd_headingame"] = "manhattan_snd_headingame";
level.scr_sound["lonestar"]["pred_multiple_down"] = "manhattan_snd_multipledown";
level.scr_sound["lonestar"]["pred_multiple_eliminted"] = "manhattan_snd_multipleeliminated";
level.scr_sound["lonestar"]["pred_good_hit"] = "manhattan_snd_goodhit";
level.scr_sound["lonestar"]["pred_hit_confirmed"] = "manhattan_snd_hitconfirmed";
level.scr_sound["lonestar"]["pred_5_targets_down"] = "manhattan_snd_5targets";
level.scr_sound["lonestar"]["pred_good_effect"] = "manhattan_snd_goodeffect";
level.scr_sound["lonestar"]["pred_miss"] = "manhattan_snd_thatsamiss";
level.scr_sound["lonestar"]["pred_short_repeat"] = "manhattan_snd_shortrepeat";
level.scr_sound["lonestar"]["pred_zero_kills"] = "manhattan_snd_zerokills";
level.scr_sound["lonestar"]["manhattan_snd_pinneddown"] = "manhattan_snd_pinneddown";
level.scr_sound["lonestar"]["manhattan_snd_usethereaper"] = "manhattan_snd_usethereaper";
level.scr_sound["lonestar"]["manhattan_snd_alloverus"] = "manhattan_snd_alloverus";
level.scr_sound["lonestar"]["manhattan_snd_sendanothermissile"] = "manhattan_snd_sendanothermissile";
level.scr_sound["lonestar"]["manhattan_snd_hitemagain"] = "manhattan_snd_hitemagain";
level.scr_sound["lonestar"]["manhattan_snd_anothermissile"] = "manhattan_snd_anothermissile";
level.scr_sound["lonestar"]["lonestar_line157"] = "manhattan_snd_hindsmoking";
level.scr_sound["lonestar"]["lonestar_line158"] = "manhattan_snd_ourexfil";
level.scr_sound["lonestar"]["lonestar_line160"] = "manhattan_snd_stayinghere";
level.scr_sound["lonestar"]["lonestar_line161"] = "manhattan_snd_burningdaylight";
level.scr_sound["lonestar"]["lonestar_line162"] = "manhattan_snd_killingtime";
level.scr_sound["lonestar"]["lonestar_line163"] = "manhattan_snd_boardhelo";
level.scr_sound["lonestar"]["lonestar_line167"] = "manhattan_snd_aimforboxes2";
level.scr_sound["lonestar"]["lonestar_line168"] = "manhattan_snd_burnhole";
level.scr_sound["lonestar"]["lonestar_line169"] = "manhattan_snd_usethermite";
level.scr_sound["lonestar"]["lonestar_line171"] = "manhattan_snd_burnit";
level.scr_sound["lonestar"]["lonestar_line172"] = "manhattan_snd_lightthermite";
level.scr_sound["lonestar"]["lonestar_line173"] = "manhattan_snd_zerotime";
level.scr_sound["lonestar"]["lonestar_line177"] = "manhattan_snd_approaching";
level.scr_sound["truck"]["truck_line4"] = "manhattan_trk_threatabove";
level.scr_sound["truck"]["truck_line5"] = "manhattan_trk_friendlies";
level.scr_sound["truck"]["truck_line7"] = "manhattan_trk_tradingfloor";
level.scr_sound[ "truck" ][ "truck_line25" ] = "manhattan_trk_takecover";
level.scr_sound[ "truck" ][ "truck_line26" ] = "manhattan_trk_birdincoming";
level.scr_sound["truck"]["lonestar_line176"] = "manhattan_snd_flushemout";
level.scr_sound["truck"]["lonestar_line128"] = "manhattan_snd_blastradius";
level.scr_sound["truck"]["lonestar_line170"] = "manhattan_snd_comingdown";
level.scr_sound["truck"]["manhattan_trk_gameplan"] = "manhattan_trk_gameplan";
level.scr_sound["truck"]["manhattan_trk_dontshoothim"] = "manhattan_trk_dontshoothim";
level.scr_sound["truck"]["manhattan_trk_static"] = "manhattan_trk_static";
level.scr_sound["truck"]["manhattan_trk_clear"] = "manhattan_trk_clear";
level.scr_sound["truck"]["manhattan_trk_moving"] = "manhattan_trk_moving";
level.scr_sound["reno"]["reno_line3"] = "manhattan_rno_ruarmor";
level.scr_sound["reno"]["reno_line5"] = "manhattan_rno_morenatashas";
level.scr_sound["reno"]["reno_line6"] = "manhattan_rno_storebelow";
level.scr_sound["reno"]["reno_line7"] = "manhattan_rno_memorialbuilding";
level.scr_sound["reno"]["reno_line26"] = "manhattan_rno_birddown";
level.scr_sound["reno"]["reno_line27"] = "manhattan_rno_goodwork";
level.scr_sound["reno"]["reno_line28"] = "manhattan_rno_covering";
level.scr_sound["reno"]["reno_line29"] = "manhattan_rno_providingcover";
level.scr_sound["reno"]["reno_line30"] = "manhattan_rno_imonit";
level.scr_sound["reno"]["reno_line31"] = "manhattan_rno_balcony";
level.scr_sound["reno"]["reno_line32"] = "manhattan_rno_balconyclear";
level.scr_sound["reno"]["reno_line34"] = "manhattan_rno_rogerwithyou";
level.scr_sound["reno"]["reno_line36"] = "manhattan_rno_contact";
level.scr_sound["reno"]["manhattan_rno_likeit"] = "manhattan_rno_likeit";
level.scr_sound["reno"]["manhattan_rno_noshit"] = "manhattan_rno_noshit";
level.scr_sound["reno"]["manhattan_rno_adios"] = "manhattan_rno_adios";
level.scr_sound["reno"]["manhattan_rno_anythingoncomms"] = "manhattan_rno_anythingoncomms";
level.scr_sound["reno"]["manhattan_rno_weregood"] = "manhattan_rno_weregood";
level.scr_sound["reno"]["manhattan_rno_badguys"] = "manhattan_rno_badguys";
level.scr_sound["delta2_leader"]["d2_line1"] = "manhattan_dlt2_weregood";
level.scr_sound["delta2_leader"]["d2_line3"] = "manhattan_brvl_tradingfloor";
level.scr_sound["delta2_leader"]["d2_line4"] = "manhattan_brvl_lockeddown";
level.scr_sound["delta2_leader"]["d2_line5"] = "manhattan_brvl_jtac";
level.scr_sound["generic"]["radio_loop02"] = "manhattan_gm2_fortyprecent";
level.scr_sound["generic"]["radio_loop03"] = "manhattan_gm2_cryptochange";
}


			
			
			
			
			
			
			
  			
