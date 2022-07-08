#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#include maps\paris_shared;
main()
{
prepare_dialogue();
init_dialogue_flags();
start_dialogue_threads();
}
#using_animtree("generic_human");
prepare_dialogue()
{
add_radio([
"paris_lns_checktoxins",
"paris_b_cin_negativecontam"
]);
add_lines("lonestar", [
"paris_lns_masksoff",
"paris_lns_onelight",
"paris_lns_restofgign",
"paris_lns_friendofmine",
"paris_lns_incatacombs",
"paris_lns_rogerlast",
"paris_lns_wontkillyou",
"paris_lns_frostmove",
"paris_lns_frostoverhere",
"paris_lns_keepmoving",
"paris_lns_letsgo",
"paris_lns_moveout",
"paris_lns_thisway",
"paris_lns_dontjointhem",
"paris_lns_stayfrosty",
"paris_lns_thatsvolk",
"paris_lns_jackpot",
"paris_lns_movemovemove",
"paris_lns_uptheladder",
"paris_lns_blacksedan",
"paris_lns_dontletescape",
"paris_lns_hotwirevehicle",
"paris_lns_gottaroll",
"paris_lns_gettingaway",
"paris_lns_layingdown",
"paris_lns_gunit",
"paris_rno_targetingus",
"paris_lns_drive2",
"paris_lns_steponit",
"paris_lns_anotherrun",
"paris_lns_upahead",
"paris_lns_rideshotgun",
"paris_lns_floorit",
"paris_lns_taketheshot",
"paris_lns_cargosecure",
"paris_lns_arentyou",
"paris_lns_hindincoming",
"paris_lns_backherenow",
"paris_lns_vehicledown",
"paris_lns_cmere"
]);
level.scr_face["lonestar"]["paris_lns_onelight"] = %paris_a_b_switch_sandman_pt2_facial;
add_lines("reno", [
"paris_rno_downhere",
"paris_rno_hewill",
"paris_rno_bodies",
"paris_rno_flashbang",
"paris_rno_gotarunner",
"paris_rno_uptheladder",
"paris_rno_enemytank",
"paris_ggn_shortcut",
"paris_ggn_deadahead",
"paris_ggn_igothim",
"paris_ggn_heshit",
"paris_rno_onourway"
]);
add_radio([
"paris_b_cin_negative"
]);
add_lines("gign_leader", [
"paris_ggn_understood",
"paris_ggn_followme",
"paris_ggn_chemstrike",
"paris_ggn_mustpay",
"paris_ggn_bienvenue",
"paris_rno_suspectedloc",
"paris_ggn_clear",
"paris_ggn_allclear",
"paris_ggn_keepmoving",
"paris_ggn_moveup",
"paris_ggn_checkright",
"paris_ggn_thisway",
"paris_ggn_yougo"
]);
add_radio([
"paris_hqr_fixonposition",
"paris_hqr_sendingqrf",
"paris_hqr_capturenokill",
"paris_hqr_bringhimin"
]);
add_radio([
"paris_trk_spinningup"
]);
flag_init("flag_conversation_in_progress");
}
init_dialogue_flags()
{
flag_init( "flag_intro_cinematic" );
flag_init( "flag_dialogue_one_light" );
flag_init( "flag_dialogue_one_light_complete" );
flag_init( "flag_dialogue_stay_close" );
flag_init( "flag_dialogue_this_way_post_squeeze" );
flag_init( "flag_dialogue_catacombs_post_breach" );
flag_init( "flag_dialogue_catacombs_lets_move" );
flag_init( "flag_dialogue_everyone_in_truck" );
flag_init( "flag_dialogue_another_shooter" );
flag_init( "flag_dialogue_frenchie_signal_clear_sewer" );
flag_init( "flag_dialogue_frenchie_check_right" );
flag_init( "flag_dialogue_plant_flares" );
flag_init( "flag_dialogue_tank_targeting_us" );
flag_init( "flag_dialogue_use_javelin" );
flag_init( "flag_dialogue_nice_shootin" );
flag_init( "flag_dialogue_ac130_player_killed_targets" );
flag_init( "flag_dialogue_makarov_men" );
flag_init( "flag_dialogue_in_the_truck" );
}
start_dialogue_threads()
{
switch( level.start_point )
{
case "intro_cinematic":
thread intro_cinematic_dialogue();
case "default":
case "catacombs_start":
thread stay_close_dialogue();
thread follow_me_dialogue();
thread catacombs_post_breach_dialogue();
case "catacombs_skull_chamber":
thread catacombs_bodies_dialogue();
thread catacombs_flashbang_dialogue();
thread catacombs_makarov_men_dialogue();
thread catacombs_lets_move();
thread volk_up_the_ladder_dialogue();
thread get_up_ladder_dialogue();
case "chase":
thread volk_up_ahead_dialogue();
thread load_truck_dialogue();
thread truck_ride_pre_tank();
thread truck_ride_start();
thread another_shooter_dialogue();
thread tank_moment_dialogue();
thread tank_targeting_us_dialogue();
thread drive_drive_dialogue();
case "chase_canal":
thread proceed_canal_dialogue();
thread hind_gallery_dialogue();
case "chase_ending":
thread van_behind_volk_dialogue();
thread take_the_shot_dialogue();
thread volk_sedan_hit_dialogue();
thread volk_secured_dialogue();
break;
default:
AssertMsg("Unhandled start point " + level.start_point);
}
}
intro_cinematic_dialogue()
{
flag_wait( "flag_intro_cinematic" );
wait 8;
thread radio_dialogue("paris_lns_checktoxins");
wait 12;
conversation_begin();
radio_dialogue("paris_b_cin_negativecontam");
conversation_end();
}
one_light_dialogue_notetrack(guy)
{
conversation_begin();
level.hero_lone_star thread dialogue_queue("paris_lns_onelight");
wait 3;
flag_set( "flag_dialogue_one_light_complete" );
level.hero_frenchie dialogue_queue("paris_ggn_understood");
conversation_end();
}
stay_close_dialogue()
{
flag_wait("flag_dialogue_stay_close");
conversation_begin();
level.hero_frenchie dialogue_queue("paris_ggn_followme");
conversation_end();
wait 1;
conversation_begin();
radio_dialogue( "paris_hqr_fixonposition" );
level.hero_lone_star dialogue_queue("paris_lns_incatacombs");
radio_dialogue( "paris_hqr_sendingqrf" );
level.hero_lone_star dialogue_queue("paris_lns_rogerlast");
conversation_end();
wait 2;
conversation_begin();
level.hero_reno dialogue_queue("paris_rno_downhere");
level.hero_lone_star dialogue_queue("paris_lns_wontkillyou");
conversation_end();
}
follow_me_dialogue()
{
flag_wait("flag_dialogue_frenchie_signal_clear_sewer");
conversation_begin();
level.hero_frenchie dialogue_queue("paris_ggn_allclear");
level.hero_frenchie dialogue_queue("paris_ggn_moveup");
conversation_end();
flag_wait( "flag_dialogue_follow_me" );
wait 1;
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_restofgign");
level.hero_frenchie dialogue_queue("paris_ggn_chemstrike");
level.hero_lone_star dialogue_queue("paris_lns_friendofmine");
level.hero_frenchie dialogue_queue("paris_ggn_mustpay");
level.hero_reno dialogue_queue("paris_rno_hewill");
conversation_end();
wait_for_flag_or_timeout( "flag_dialogue_smells_down_here", 4 );
flag_wait( "flag_dialogue_this_way_post_squeeze" );
conversation_begin();
level.hero_frenchie dialogue_queue("paris_ggn_thisway");
wait 1;
level.hero_frenchie dialogue_queue("paris_rno_suspectedloc");
conversation_end();
}
catacombs_nag_dialogue()
{
level notify("catacombs_nag_dialogue_stop");
level endon("catacombs_nag_dialogue_stop");
childthread catacombs_nag_dialogue_detect_movement();
frenchie_lines = randomizer_create(["paris_ggn_keepmoving", "paris_ggn_moveup", "paris_ggn_thisway"]);
lone_star_lines = randomizer_create(["paris_lns_frostmove", "paris_lns_frostoverhere", "paris_lns_keepmoving", "paris_lns_letsgo", "paris_lns_moveout", "paris_lns_thisway"]);
while(true)
{
catacombs_nag_dialogue_progression(frenchie_lines, lone_star_lines);
}
}
catacombs_nag_dialogue_progression(frenchie_lines, lone_star_lines)
{
level endon("catacombs_nag_dialogue_guy_moved");
wait RandomFloatRange(15, 25);
level.hero_frenchie thread catacombs_nag_dialogue_say(frenchie_lines randomizer_get_no_repeat());
wait RandomFloatRange(25, 35);
level.hero_frenchie thread catacombs_nag_dialogue_say(frenchie_lines randomizer_get_no_repeat());
level waittill("forever");
}
catacombs_nag_dialogue_say(line)
{
conversation_begin();
level.catacombs_nag_in_progress = true;
self dialogue_queue(line);
level.catacombs_nag_in_progress = undefined;
conversation_end();
}
catacombs_nag_dialogue_detect_movement()
{
guy = level.hero_frenchie;
radius = 39*2;
guy_old_origin = guy.origin;
for(;; wait 1)
{
if(Distance(guy.origin, guy_old_origin) > radius)
{
guy_old_origin = guy.origin;
level notify("catacombs_nag_dialogue_guy_moved");
}
else if(flag("flag_conversation_in_progress") && !IsDefined(level.catacombs_nag_in_progress))
{
level notify("catacombs_nag_dialogue_guy_moved");
}
}
}
catacombs_nag_dialogue_stop()
{
level notify("catacombs_nag_dialogue_stop");
}
catacombs_post_breach_dialogue()
{
flag_wait("flag_dialogue_catacombs_post_breach");
wait 8;
conversation_begin();
level.hero_frenchie dialogue_queue("paris_ggn_bienvenue");
wait .75;
level.hero_lone_star dialogue_queue("paris_lns_stayfrosty");
aud_send_msg("mus_catacombs_entrance");
conversation_end();
}
catacombs_bodies_dialogue()
{
flag_wait("flag_dialogue_catacombs_bodies");
conversation_begin();
level.hero_reno dialogue_queue("paris_rno_bodies");
level.hero_lone_star dialogue_queue("paris_lns_dontjointhem");
conversation_end();
}
catacombs_lets_move()
{
flag_wait("flag_dialogue_catacombs_lets_move");
wait 3;
if(!flag("flag_volk_catacombs_escape"))
{
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_letsgo");
conversation_end();
}
}
catacombs_flashbang_dialogue()
{
flag_wait("flag_volk_catacombs_escape");
level.hero_reno dialogue_queue("paris_rno_flashbang");
}
catacombs_makarov_men_dialogue()
{
flag_wait ( "flag_dialogue_makarov_men" );
wait 2;
conversation_begin();
level.hero_reno dialogue_queue("paris_rno_gotarunner");
aud_send_msg("mus_catacombs_chase");
level.hero_lone_star dialogue_queue("paris_lns_thatsvolk");
level.hero_lone_star dialogue_queue("paris_lns_jackpot");
radio_dialogue("paris_hqr_capturenokill");
level.hero_lone_star dialogue_queue("paris_lns_movemovemove");
conversation_end();
}
volk_up_the_ladder_dialogue()
{
flag_wait ( "flag_volk_boiler_room_escape" );
wait .5;
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_dontletescape");
level.hero_reno dialogue_queue("paris_rno_uptheladder");
conversation_end();
}
get_up_ladder_dialogue()
{
flag_wait ( "flag_dialogue_get_up_ladder" );
if(!flag("flag_obj_capture_volk_position_change_1"))
{
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_uptheladder");
conversation_end();
}
}
volk_up_ahead_dialogue()
{
flag_wait ( "trigger_found_bomb_truck" );
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_blacksedan");
conversation_end();
}
load_truck_dialogue()
{
flag_wait( "flag_dialogue_in_the_truck" );
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_hotwirevehicle");
level.hero_frenchie dialogue_queue("paris_ggn_yougo");
conversation_end();
wait 6;
if(!flag("flag_player_in_truck"))
{
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_gottaroll");
conversation_end();
}
}
truck_ride_pre_tank()
{
flag_wait("flag_player_in_truck");
wait 1.5;
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_gettingaway");
wait 3;
level.hero_lone_star dialogue_queue("paris_lns_layingdown");
conversation_end();
}
truck_ride_start()
{
flag_wait("flag_player_in_truck");
wait 12;
conversation_begin();
level.hero_lone_star dialogue_queue( "paris_lns_gunit" );
conversation_end();
}
another_shooter_dialogue()
{
flag_wait("flag_crash_gaz_barricade_started");
wait 5.5;
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_backherenow");
conversation_end();
}
tank_moment_dialogue()
{
flag_wait("spawn_tank_01");
wait 1;
conversation_begin();
level.hero_reno dialogue_queue( "paris_rno_enemytank" );
conversation_end();
}
tank_targeting_us_dialogue()
{
flag_wait( "flag_dialogue_tank_targeting_us" );
conversation_begin();
level.hero_lone_star dialogue_queue( "paris_rno_targetingus" );
conversation_end();
}
drive_drive_dialogue()
{
flag_wait( "flag_van_slam_storefront_01" );
wait 5.5;
conversation_begin();
level.hero_lone_star dialogue_queue( "paris_lns_steponit" );
conversation_end();
}
proceed_canal_dialogue()
{
flag_wait("spawn_tank_02");
wait 5;
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_hindincoming");
conversation_end();
flag_wait("flag_heli_canal_pass_01");
wait 7;
conversation_begin();
level.hero_lone_star dialogue_queue( "paris_lns_drive2" );
conversation_end();
wait 2;
conversation_begin();
level.hero_reno dialogue_queue("paris_ggn_shortcut");
conversation_end();
}
hind_gallery_dialogue()
{
flag_wait("flag_uaz_post_river");
wait .5;
conversation_begin();
level.hero_lone_star dialogue_queue("paris_lns_anotherrun");
conversation_end();
}
van_behind_volk_dialogue()
{
flag_wait("flag_dialogue_got_volk_chase");
conversation_begin();
level.hero_reno dialogue_queue("paris_ggn_igothim");
level.hero_lone_star dialogue_queue("paris_lns_rideshotgun");
level.hero_lone_star dialogue_queue("paris_lns_floorit");
conversation_end();
}
take_the_shot_dialogue()
{
flag_wait("flag_player_to_the_front_complete");
wait 1.25;
conversation_begin();
if(!flag("flag_player_shot_sedan_ending")) level.hero_reno dialogue_queue("paris_ggn_deadahead");
if(!flag("flag_player_shot_sedan_ending")) level.hero_lone_star dialogue_queue("paris_lns_taketheshot");
conversation_end();
}
volk_sedan_hit_dialogue()
{
flag_wait("flag_player_shot_sedan_ending");
if(!flag("flag_failure_did_not_shoot"))
{
level.hero_reno dialogue_queue("paris_ggn_heshit");
}
}
volk_secured_dialogue()
{
flag_wait( "flag_volk_ending_start" );
conversation_begin();
level.hero_lone_star dialogue_queue( "paris_lns_vehicledown" );
level.hero_lone_star dialogue_queue( "paris_lns_cmere" );
conversation_end();
wait 2;
conversation_begin();
level.hero_lone_star dialogue_queue( "paris_lns_cargosecure" );
level.hero_lone_star dialogue_queue( "paris_lns_arentyou" );
radio_dialogue( "paris_hqr_bringhimin" );
level.hero_reno dialogue_queue( "paris_rno_onourway" );
radio_dialogue( "paris_trk_spinningup" );
conversation_end();
}
	