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
prepare_dialogue()
{
add_radio([
"paris_lns_stilldirty_r",
"paris_lns_stilldirty",
"paris_lns_rogerwilco_r",
"paris_lns_ondeck",
"paris_lns_norook",
"paris_lns_patchmethrough",
"paris_lns_threeminutes",
"paris_lns_gogogo2_r",
"paris_lns_acrossthestreet_r",
"paris_lns_downthestairs_r",
"paris_lns_engageenagage_r",
"paris_lns_frostwithme_r",
"paris_lns_onbalcony_r",
"paris_lns_topfloorclear",
"paris_lns_yourstatus",
"paris_lns_getingame_r",
"paris_lns_getdownhere",
"paris_lns_restaurantahead",
"paris_lns_watchyourfirenorth",
"paris_lns_wheresvolk_r",
"paris_lns_gotyourback_r",
"paris_lns_linkup",
"paris_lns_acrosscourtyard_r",
"paris_lns_coverfire_r",
"paris_lns_gogogo_r",
"paris_lns_topofstairs_r",
"paris_lns_howmanywegot",
"paris_lns_closeairsupport_r",
"paris_lns_markirstrobes_r",
"paris_lns_idtargets",
"paris_lns_getstrobeson_r",
"paris_lns_multiplehits_r",
"paris_lns_amiss_r",
"paris_lns_nohits_r",
"paris_lns_zerokills_r",
"paris_lns_directhit_r",
"paris_lns_thatsahit_r",
"paris_lns_thatsamiss_r",
"paris_lns_endofalley_r",
"paris_lns_needastrobe_r",
"paris_lns_throwsmoke",
"paris_lns_putsmoke",
"paris_lns_useastrobe_r",
"paris_lns_markarmor_r",
"paris_lns_tosssmoke",
"paris_lns_gunshipcantsee",
"paris_lns_markwithsmoke",
"paris_lns_designatetarget",
"paris_lns_russiansroping",
"paris_lns_imiprovise",
"paris_lns_btrdestroyed",
"paris_lns_thanksforassist",
"paris_lns_goodworkbrother_r",
"paris_lns_belowground",
"paris_lns_getdowntheladder",
"paris_lns_downtheladder",
"paris_lns_headbelow"
]);
add_radio([
"paris_rno_lottarooks",
"paris_rno_watchyourstep_r",
"paris_rno_compromised",
"paris_rno_buildingacross",
"paris_rno_heavyfire",
"paris_rno_checkdoor_r",
"paris_rno_clear2_r",
"paris_rno_lesamis_r",
"paris_rno_allofem",
"paris_rno_moving_r",
"paris_rno_threeringcircus_r",
"paris_rno_tangosinbound_r"
]);
add_radio([
"paris_ggn_muchlonger",
"paris_ggn_threemins",
"paris_ggn_gladtosee",
"paris_ggn_fourmen",
"paris_ggn_downthealley_r",
"paris_ggn_movemove_r",
"paris_ggn_incatacombs_r",
"paris_ggn_entranceahead_r",
"paris_ggn_entranceahead2_r",
"paris_ggn_overhere2_r"
]);
add_radio([
"paris_fso_onracetrack"
]);
add_radio([
"paris_hqr_triagecivilians",
"paris_hqr_heavyresistance",
"paris_hqr_gignpinned"
]);
add_radio([
"paris_plt_goinghot",
"paris_plt_engaging",
"paris_plt_targetconfirmed",
"paris_plt_rogermark",
"paris_plt_rogerspot",
"paris_plt_ontheway",
"paris_plt_engaging2",
"paris_plt_goodmark",
"paris_plt_roundsondeck",
"paris_plt_shotoutdangerclose",
"paris_plt_firing",
"paris_plt_orbitreestablished",
"paris_plt_sensorsback",
"paris_plt_calltargets",
"paris_plt_readyformark",
"paris_plt_readyfortargets",
"paris_plt_bingofuel"
]);
add_radio([
"paris_grb_louvre_v2"
]);
add_radio([
"paris_trk_meetyou"
]);
add_radio([
"paris_ggn1_thiswayhurry",
"paris_ggn1_cmoncmon"
]);
add_radio([
"paris_ggn2_overhere",
"paris_ggn2_hurrycomeon"
]);
flag_init("flag_conversation_in_progress");
}
init_dialogue_flags()
{
flag_init( "flag_dialogue_opening" );
flag_init( "flag_dialogue_watch_your_step" );
flag_init( "flag_dialogue_gign_in_trouble" );
flag_init( "flag_dialogue_in_the_game" );
flag_init( "flag_dialogue_down_the_stairs" );
flag_init( "flag_dialogue_go_hot_complete" );
flag_init( "flag_dialogue_bookstore_balcony" );
flag_init( "flag_dialogue_bookstore_top_floor_clear_1" );
flag_init( "flag_dialogue_bookstore_heavy_fire_1" );
flag_init( "flag_dialogue_bookstore_heavy_fire_2" );
flag_init( "flag_dialogue_check_door" );
flag_init( "flag_dialogue_check_door_complete" );
flag_init( "flag_dialogue_bookstore_clear" );
flag_init( "flag_dialogue_press_the_attack_complete" );
flag_init( "flag_dialogue_restaurant_meeting" );
flag_init( "flag_rpg_top_of_stairs_dialogue" );
flag_init( "flag_dialogue_ac130_player_has_strobe" );
flag_init( "flag_dialogue_down_the_alley" );
flag_init( "flag_dialogue_heli_courtyard" );
flag_init( "flag_dialogue_courtyard_2_clear" );
flag_init( "flag_dialogue_btr_alley" );
flag_init( "flag_dialogue_destroyed_btr_with_rpg" );
flag_init( "flag_dialogue_entrance_ahead" );
flag_init( "flag_dialogue_manhole_prompt" );
flag_init( "flag_dialogue_catacombs_post_breach" );
flag_init( "flag_dialogue_everyone_in_truck" );
flag_init( "flag_dialogue_another_shooter" );
flag_init( "flag_dialogue_use_javelin" );
flag_init( "flag_dialogue_nice_shootin" );
flag_init( "flag_dialogue_ac130_player_killed_targets" );
flag_init( "flag_dialogue_makarov_men" );
flag_init( "flag_dialogue_escape_timer_started" );
flag_init( "flag_dialogue_in_the_truck" );
}
start_dialogue_threads()
{
switch( level.start_point )
{
case "default":
case "rooftops":
thread opening_dialogue();
thread watch_your_step_dialogue();
thread gign_in_trouble_gialogue();
thread across_the_street_dialogue();
case "stairwell":
thread in_the_game_dialogue();
thread check_for_survivors_dialogue();
thread on_balcony_dialogue();
thread bookstore_top_floor_clear_dialogue();
thread bookstore_heavy_fire_dialogue_1();
thread bookstore_heavy_fire_dialogue_2();
thread check_door_dialogue();
thread bookstore_clear_dialogue();
case "restaurant_approach":
thread restaurant_pre_meeting_dialogue();
thread restaurant_meeting_dialogue();
thread across_the_courtyard_dialogue();
thread rpg_top_of_stairs_dialogue();
thread follow_me_dialogue();
thread joga_studio_dialogue();
case "ac_moment":
thread ac130_dialogue();
thread air_support_strobe_dialogue();
thread down_the_alley_dialogue();
thread heli_unloading_dialogue();
thread btr_dialogue();
thread brt_destroyed_with_rpg_dialogue();
thread courtyard_2_clear_dialogue();
case "sewer_entrance":
thread manhole_dialogue();
break;
default:
AssertMsg("Unhandled start point " + level.start_point);
}
}
opening_dialogue()
{
flag_wait( "flag_dialogue_opening" );
wait 2.0;
conversation_begin();
radio_dialogue("paris_grb_louvre_v2");
wait 0.473;
radio_dialogue("paris_hqr_triagecivilians");
conversation_end();
wait 2.1;
conversation_begin();
radio_dialogue("paris_lns_stilldirty");
wait 0.15;
radio_dialogue("paris_lns_ondeck");
radio_dialogue("paris_trk_meetyou");
conversation_end();
wait 2;
conversation_begin();
radio_dialogue("paris_hqr_heavyresistance");
radio_dialogue("paris_lns_rogerwilco_r");
conversation_end();
flag_wait( "flag_check_vitals" );
wait 2;
conversation_begin();
radio_dialogue("paris_rno_lottarooks");
radio_dialogue("paris_lns_norook");
conversation_end();
}
watch_your_step_dialogue()
{
flag_wait ( "flag_dialogue_watch_your_step" );
wait 1;
conversation_begin();
radio_dialogue("paris_rno_watchyourstep_r");
conversation_end();
}
gign_in_trouble_gialogue()
{
flag_wait( "flag_dialogue_gignpinned" );
conversation_begin();
radio_dialogue("paris_hqr_gignpinned");
vo_waitframe();
radio_dialogue("paris_lns_patchmethrough");
vo_waitframe();
radio_dialogue("paris_ggn_muchlonger");
vo_waitframe();
radio_dialogue("paris_lns_threeminutes");
vo_waitframe();
radio_dialogue("paris_ggn_threemins");
vo_waitframe();
radio_dialogue("paris_lns_gogogo2_r");
conversation_end();
}
vo_waitframe()
{
wait(.21);
}
across_the_street_dialogue()
{
flag_wait( "player_rooftop_jump_complete" );
wait 1;
conversation_begin();
radio_dialogue("paris_lns_acrossthestreet_r");
conversation_end();
}
in_the_game_dialogue()
{
flag_wait( "flag_dialogue_in_the_game" );
wait .75;
conversation_begin();
line = random([
"paris_rno_buildingacross",
"paris_rno_compromised"
]);
radio_dialogue( line );
radio_dialogue("paris_lns_getingame_r");
flag_set( "flag_dialogue_go_hot_complete" );
wait .75;
radio_dialogue("paris_lns_downthestairs_r");
conversation_end();
}
check_for_survivors_dialogue()
{
flag_wait( "flag_obj_01_position_change_5" );
conversation_begin();
radio_dialogue("paris_lns_frostwithme_r");
conversation_end();
}
on_balcony_dialogue()
{
flag_wait( "flag_dialogue_bookstore_balcony" );
if(!flag( "flag_bookstore_combat_top_rear" ) && !flag( "flag_bookstore_combat_interior" ))
{
conversation_begin();
radio_dialogue("paris_lns_onbalcony_r");
conversation_end();
}
}
bookstore_top_floor_clear_dialogue()
{
flag_wait( "flag_dialogue_bookstore_top_floor_clear_1" );
wait 1;
conversation_begin();
radio_dialogue( "paris_lns_topfloorclear" );
conversation_end();
}
bookstore_heavy_fire_dialogue_1()
{
flag_wait( "flag_dialogue_bookstore_heavy_fire_1" );
time = randomfloatrange( 1.5, 3.5 );
wait time;
conversation_begin();
radio_dialogue( "paris_rno_heavyfire" );
conversation_end();
}
bookstore_heavy_fire_dialogue_2()
{
flag_wait( "flag_dialogue_bookstore_heavy_fire_2" );
time = randomfloatrange( 1.5, 3.5 );
wait time;
conversation_begin();
radio_dialogue( "paris_rno_heavyfire" );
radio_dialogue( "paris_lns_getdownhere" );
conversation_end();
}
bookstore_clear_dialogue()
{
flag_wait( "flag_dialogue_bookstore_clear" );
wait 1;
conversation_begin();
radio_dialogue( "paris_rno_clear2_r" );
conversation_end();
flag_set( "flag_dialogue_press_the_attack_complete" );
}
check_door_dialogue()
{
flag_wait( "flag_dialogue_check_door" );
wait 1;
conversation_begin();
radio_dialogue( "paris_rno_checkdoor_r" );
radio_dialogue( "paris_lns_restaurantahead" );
radio_dialogue( "paris_lns_watchyourfirenorth" );
delayThread(2.5, ::flag_set, "flag_dialogue_check_door_complete");
radio_dialogue( "paris_ggn_gladtosee" );
conversation_end();
}
restaurant_pre_meeting_dialogue()
{
flag_wait( "flag_dialogue_lasamis" );
conversation_begin();
level.player thread play_sound_on_tag(level.scr_radio[ "paris_ggn1_thiswayhurry" ], undefined, true );
wait 1.35;
thread radio_dialogue( "paris_rno_lesamis_r" );
wait 1.25;
level.player thread play_sound_on_tag(level.scr_radio[ "paris_ggn1_cmoncmon" ], undefined, true );
wait 1.25;
thread gign_waving_dialogue();
radio_dialogue( "paris_rno_allofem" );
conversation_end();
wait 2;
aud_send_msg( "mus_reached_gign" );
}
gign_waving_dialogue()
{
wait 1.25;
level.player thread play_sound_on_tag(level.scr_radio[ "paris_ggn2_hurrycomeon" ], undefined, true );
wait 1.25;
level.player play_sound_on_tag(level.scr_radio[ "paris_ggn2_overhere" ], undefined, true );
}
restaurant_meeting_dialogue()
{
flag_wait( "flag_dialogue_restaurant_meeting" );
conversation_begin();
radio_dialogue( "paris_lns_yourstatus" );
radio_dialogue( "paris_ggn_fourmen" );
radio_dialogue( "paris_lns_wheresvolk_r" );
radio_dialogue( "paris_ggn_incatacombs_r" );
radio_dialogue( "paris_lns_gotyourback_r" );
aud_send_msg( "mus_follow_gign" );
radio_dialogue( "paris_lns_linkup" );
conversation_end();
}
across_the_courtyard_dialogue()
{
flag_wait("flag_courtyard_1_wave_2");
conversation_begin();
aud_send_msg("mus_cross_courtyard1");
radio_dialogue( "paris_lns_acrosscourtyard_r" );
radio_dialogue( "paris_lns_coverfire_r" );
radio_dialogue( "paris_rno_moving_r" );
radio_dialogue( "paris_lns_gogogo_r" );
conversation_end();
flag_set( "flag_rpg_top_of_stairs_dialogue" );
}
rpg_top_of_stairs_dialogue()
{
flag_wait( "flag_rpg_top_of_stairs_dialogue" );
conversation_begin();
radio_dialogue( "paris_lns_topofstairs_r" );
conversation_end();
}
follow_me_dialogue()
{
flag_wait( "flag_cross_courtyard_complete" );
conversation_begin();
radio_dialogue( "paris_ggn_entranceahead_r" );
conversation_end();
}
joga_studio_dialogue()
{
flag_wait( "flag_joga_studio_dialogue" );
conversation_begin();
radio_dialogue("paris_lns_acrossthestreet_r");
conversation_end();
}
ac130_dialogue()
{
flag_wait( "flag_ac130_moment_dialogue" );
wait 2.0;
conversation_begin();
radio_dialogue( "paris_rno_tangosinbound_r" );
radio_dialogue( "paris_lns_howmanywegot" );
radio_dialogue( "paris_rno_threeringcircus_r" );
radio_dialogue( "paris_lns_closeairsupport_r" );
aud_send_msg("mus_ac130_replies");
radio_dialogue( "paris_fso_onracetrack");
conversation_end();
thread mark_initial_targets_dialogue();
}
mark_initial_targets_dialogue()
{
flag_wait( "flag_dialogue_ac130_player_has_strobe" );
last_line = undefined;
while(!flag("flag_dialogue_ac130_player_killed_targets"))
{
wait 1;
flag_waitopen("flag_strobes_in_use");
if(flag("flag_dialogue_ac130_player_killed_targets"))
break;
conversation_begin();
while(true)
{
line = random([
"paris_lns_markirstrobes_r",
"paris_lns_idtargets",
"paris_lns_throwsmoke",
"paris_lns_putsmoke",
"paris_lns_getstrobeson_r"
]);
if(!IsDefined(last_line) || last_line != line)
{
last_line = line;
break;
}
}
radio_dialogue( line );
conversation_end();
wait 10;
}
}
air_support_strobe_dialogue()
{
btr_courtyard_enemy_noteworthies = [
"enemy_courtyard_2_wave_1"
, "enemy_courtyard_2_wave_2"
, "enemy_courtyard_2_wave_3"
, "enemy_courtyard_2_brt_crew"
, "enemy_ai_initial_ac_moment"
, "enemy_ai_initial_ac_moment_gaz"
, "enemy_courtyard_2_heli_crew"
];
last_ready_line = undefined;
last_fired_upon_line = undefined;
while(1)
{
msg = level waittill_any_return( "air_support_strobe_no_targets", "air_support_strobe_popped", "air_suport_strobe_fired_upon", "air_support_strobe_killed", "air_support_strobe_ready");
switch(msg)
{
case "air_support_strobe_no_targets":
break;
case "air_support_strobe_popped":
break;
case "air_support_strobe_ready":
if(flag("btr_cortyard_killed") && spawn_metrics_number_alive(btr_courtyard_enemy_noteworthies) < 4)
{
break;
}
while(true)
{
line = random([
"paris_plt_orbitreestablished",
"paris_plt_sensorsback",
"paris_plt_calltargets",
"paris_plt_readyformark",
"paris_plt_readyfortargets"
]);
if(!IsDefined(last_ready_line) || line != last_ready_line)
{
last_ready_line = line;
break;
}
}
radio_dialogue(line);
break;
case "air_suport_strobe_fired_upon":
while(true)
{
line = random([
"paris_plt_goinghot",
"paris_plt_engaging",
"paris_plt_targetconfirmed",
"paris_plt_rogerspot",
"paris_plt_ontheway",
"paris_plt_engaging2",
"paris_plt_goodmark",
"paris_plt_roundsondeck",
"paris_plt_shotoutdangerclose",
"paris_plt_firing",
"paris_plt_rogermark"
]);
if(!IsDefined(last_fired_upon_line) || line != last_fired_upon_line)
{
last_fired_upon_line = line;
break;
}
}
radio_dialogue(line);
break;
case "air_support_strobe_killed":
air_support_strobe_kills_dialogue();
break;
}
}
}
air_support_strobe_kills_dialogue()
{
level endon( "stop_air_support_strobe_kill_dialogue" );
if ( level.air_support_strobe_btr_killed )
{
line = "paris_lns_btrdestroyed";
}
else
{
kills = maps\_air_support_strobe::get_num_kills();
while(true)
{
switch(kills)
{
case 0:
line = random(["paris_lns_nohits_r", "paris_lns_zerokills_r", "paris_lns_thatsamiss_r"]);
break;
case 1:
line = random(["paris_lns_directhit_r", "paris_lns_thatsahit_r"]);
break;
default:
line = random(["paris_lns_multiplehits_r", "paris_lns_directhit_r"]);
}
if(!IsDefined(level.last_killed_line) || line != level.last_killed_line)
{
level.last_killed_line = line;
break;
}
}
}
wait 2;
if(!flag("flag_dialogue_courtyard_2_clear"))
{
radio_dialogue(line);
}
}
down_the_alley_dialogue()
{
flag_wait("flag_dialogue_down_the_alley");
wait 1;
conversation_begin();
radio_dialogue( "paris_ggn_downthealley_r");
radio_dialogue( "paris_lns_gogogo2_r");
conversation_end();
}
heli_unloading_dialogue()
{
flag_wait("flag_dialogue_heli_unloading");
wait 1;
conversation_begin();
radio_dialogue( "paris_lns_russiansroping");
conversation_end();
}
heli_courtyard_dialogue()
{
flag_wait("flag_dialogue_heli_courtyard");
conversation_begin();
radio_dialogue( "paris_ggn_entranceahead2_r");
conversation_end();
}
btr_dialogue()
{
flag_wait("flag_dialogue_btr_alley");
if(flag("btr_cortyard_killed"))
return;
radio_dialogue( "paris_lns_endofalley_r");
wait_and_pause_for_strobe(5, 15);
if(flag("btr_cortyard_killed"))
return;
conversation_begin();
radio_dialogue( "paris_lns_markarmor_r");
conversation_end();
wait_and_pause_for_strobe(6, 15);
while(!flag("btr_cortyard_killed"))
{
conversation_begin();
radio_dialogue( "paris_lns_needastrobe_r");
conversation_end();
wait_and_pause_for_strobe(8, 15);
if(flag("btr_cortyard_killed"))
break;
conversation_begin();
radio_dialogue( "paris_lns_useastrobe_r");
conversation_end();
wait_and_pause_for_strobe(8, 15);
if(flag("btr_cortyard_killed"))
break;
conversation_begin();
radio_dialogue( "paris_lns_tosssmoke");
conversation_end();
wait_and_pause_for_strobe(8, 15);
if(flag("btr_cortyard_killed"))
break;
conversation_begin();
radio_dialogue( "paris_lns_gunshipcantsee");
conversation_end();
wait_and_pause_for_strobe(8, 15);
if(flag("btr_cortyard_killed"))
break;
conversation_begin();
radio_dialogue( "paris_lns_markwithsmoke");
conversation_end();
wait_and_pause_for_strobe(8, 15);
if(flag("btr_cortyard_killed"))
break;
conversation_begin();
radio_dialogue( "paris_lns_designatetarget");
conversation_end();
wait_and_pause_for_strobe(8, 15);
if(flag("btr_cortyard_killed"))
break;
}
}
brt_destroyed_with_rpg_dialogue()
{
flag_wait( "flag_dialogue_destroyed_btr_with_rpg" );
wait 2;
conversation_begin();
radio_dialogue( "paris_lns_imiprovise");
conversation_end();
}
Wait_and_pause_for_strobe(duration, extra_wait)
{
while(true)
{
add_wait(::_wait, duration);
add_wait(::flag_wait, "flag_strobes_in_use");
do_wait_any();
if(flag("flag_strobes_in_use"))
{
add_wait(::_wait, extra_wait);
add_wait(::flag_waitopen, "flag_strobes_in_use");
do_wait();
}
else
{
break;
}
}
}
courtyard_2_clear_dialogue()
{
flag_wait("flag_dialogue_courtyard_2_clear");
wait 3;
conversation_begin();
radio_dialogue( "paris_lns_goodworkbrother_r");
radio_dialogue( "paris_ggn_entranceahead2_r");
wait 1;
radio_dialogue( "paris_plt_bingofuel");
radio_dialogue( "paris_lns_thanksforassist");
conversation_end();
}
manhole_dialogue()
{
flag_wait("flag_dialogue_manhole_prompt");
conversation_begin();
radio_dialogue( "paris_ggn_overhere2_r");
conversation_end();
flag_wait( "flag_player_manhole_ready" );
wait 2;
if(flag("flag_player_manhole")) return;
conversation_begin();
radio_dialogue( "paris_lns_getdowntheladder");
conversation_end();
while(!flag("flag_player_manhole"))
{
wait 10;
conversation_begin();
radio_dialogue( "paris_lns_belowground");
conversation_end();
wait 20;
if(flag("flag_player_manhole"))
break;
conversation_begin();
radio_dialogue( "paris_lns_downtheladder");
conversation_end();
wait 30;
if(flag("flag_player_manhole"))
break;
conversation_begin();
radio_dialogue( "paris_lns_headbelow");
conversation_end();
wait 20;
}
}
