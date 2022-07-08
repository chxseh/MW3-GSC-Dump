#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#using_animtree("generic_human");
main()
{
flag_init( "dialogue_in_progress" );
flag_init( "intro_line_1" );
flag_init( "intro_line_2" );
flag_init( "river_dialogue" );
flag_init( "river_intro_vo_done" );
flag_init( "dont_be_stupid_dialogue" );
flag_init( "river_technical_dialogue" );
flag_init( "second_beat_move_dialogue" );
flag_init( "river_technicals_move_dialogue" );
flag_init( "prone_encounter_start_dialogue" );
flag_init( "prone_encounter_well_done_dialogue" );
flag_init( "tire_necklace_dialogue" );
flag_init( "off_the_road_dialogue" );
flag_init( "river_big_moment_done_dialogue" );
flag_init( "river_spotted_dialogue" );
flag_init( "church_mouse_dialogue" );
flag_init( "bridge_go_loud_dialogue" );
flag_init( "bridge_guys_dead_dialogue" );
flag_init( "victim_burn_vo" );
flag_init( "technical_steal_broken_vo" );
flag_init( "cover_us_dialogue" );
flag_init( "multiple_guards_dialogue" );
flag_init( "more_militia_dialogue" );
flag_init( "push_forward_dialogue" );
flag_init( "rally_on_me_dialogue" );
flag_init( "go_noisy_dialogue" );
flag_init( "inf_both_moving_dialogue" );
flag_init( "large_militia_dialogue" );
flag_init( "inf_spotted_dialogue" );
flag_init( "large_group_dialogue" );
flag_init( "breaching_factory_dialogue" );
flag_init( "breaching_factory_dialogue_done" );
flag_init( "inf_encounter_2_vo_done" );
flag_init( "inf_nice_shot_vo" );
flag_init( "no_ak_vo" );
flag_init( "player_technical_dialogue" );
flag_init( "technical_1_dialogue" );
flag_init( "roof_right_dialogue" );
flag_init( "contact_front_1_dialogue" );
flag_init( "contact_left_1_dialogue" );
flag_init( "contact_left_2_dialogue" );
flag_init( "technical_2_dialogue" );
flag_init( "contact_front_2_dialogue" );
flag_init( "contact_right_1_dialogue" );
flag_init( "contact_left_3_dialogue" );
flag_init( "contact_left_4_dialogue" );
flag_init( "contact_front_3_dialogue" );
flag_init( "technical_ahead_dialogue" );
flag_init( "militia_vo_done" );
flag_init( "mortar_run_dialogue" );
flag_init( "mortar_door_dialogue" );
flag_init( "mortar_roof_fall_dialogue" );
flag_init( "head_to_mortar_dialogue" );
flag_init( "keep_firing_mortar" );
flag_init( "regroup_dialogue" );
flag_init( "mortar_targets_dialogue" );
flag_init( "house_door_dialogue" );
flag_init( "player_rpg_dialogue" );
flag_init( "getting_away_dialogue" );
flag_init( "cleanupcrew_dialogue" );
flag_init( "defensive_positions_dialogue" );
flag_init( "secure_dialogue" );
flag_init( "beautiful_relationship_dialogue" );
flag_init( "money_wired_dialogue" );
flag_init( "fast_pay_dialogue" );
flag_init( "confrontation_vo_finished" );
flag_init( "church_breach_ally_dialogue" );
level.vo_interupt = false;
prepare_dialogue();
thread play_dialogue();
}
prepare_dialogue()
{
level.scr_radio[ "warlord_nik_onehour" ] = "warlord_nik_onehour";
level.scr_sound[ "soap" ][ "warlord_pri_lowprofile" ] = "warlord_pri_lowprofile";
level.scr_sound[ "price" ][ "warlord_pri_trynottodie" ] = "warlord_pri_trynottodie";
level.scr_sound[ "soap" ][ "warlord_mct_rogerthat" ] = "warlord_mct_rogerthat";
level.scr_sound[ "soap" ][ "warlord_pri_somuch" ] = "warlord_pri_somuch";
level.scr_sound[ "militia" ][ "warlord_mlt1_everyonedead" ] = "warlord_mlt1_everyonedead";
level.scr_sound[ "militia" ][ "warlord_mlt2_notall" ] = "warlord_mlt2_notall";
level.scr_sound[ "militia" ][ "warlord_mlt1_findothers" ] = "warlord_mlt1_findothers";
level.scr_sound[ "soap" ][ "warlord_mct_tangosapproaching" ] = "warlord_mct_tangosapproaching";
level.scr_sound[ "price" ][ "warlord_pri_duck" ] = "warlord_pri_duck";
level.scr_sound[ "price" ][ "warlord_pri_move3" ] = "warlord_pri_move3";
level.scr_sound[ "soap" ][ "warlord_pri_twoxrays" ] = "warlord_pri_twoxrays";
level.scr_sound[ "price" ][ "warlord_pri_welldoneyuri" ] = "warlord_pri_welldoneyuri";
level.scr_sound[ "soap" ][ "warlord_mct_clear2" ] = "warlord_mct_clear2";
level.scr_sound[ "militia" ][ "warlord_mlt1_didyouknow" ] = "warlord_mlt1_didyouknow";
level.scr_sound[ "militia" ][ "warlord_mlt2_ohreally" ] = "warlord_mlt2_ohreally";
level.scr_sound[ "militia" ][ "warlord_mlt1_walkedright" ] = "warlord_mlt1_walkedright";
level.scr_sound[ "militia" ][ "warlord_mlt1_poppedhim" ] = "warlord_mlt1_poppedhim";
level.scr_sound[ "militia" ][ "warlord_mlt3_wasanidiot" ] = "warlord_mlt3_wasanidiot";
level.scr_sound[ "militia" ][ "warlord_mlt1_whydidthey" ] = "warlord_mlt1_whydidthey";
level.scr_sound[ "militia" ][ "warlord_mlt3_ratherbehere" ] = "warlord_mlt3_ratherbehere";
level.scr_sound[ "militia" ][ "warlord_mlt1_thatstrue" ] = "warlord_mlt1_thatstrue";
level.scr_sound[ "militia" ][ "warlord_mlt3_howmuch" ] = "warlord_mlt3_howmuch";
level.scr_sound[ "militia" ][ "warlord_mlt1_cigarette" ] = "warlord_mlt1_cigarette";
level.scr_sound[ "militia" ][ "warlord_mlt3_makeitlast" ] = "warlord_mlt3_makeitlast";
level.scr_sound[ "militia" ][ "warlord_mlt1_sob" ] = "warlord_mlt1_sob";
level.scr_sound[ "militia" ][ "warlord_mlt3_butyourwife" ] = "warlord_mlt3_butyourwife";
level.scr_sound[ "militia" ][ "warlord_mlt2_outsmart" ] = "warlord_mlt2_outsmart";
level.scr_sound[ "victim" ][ "warlord_civ_notlikethat" ] = "warlord_civ_notlikethat";
level.scr_sound[ "victim" ][ "warlord_civ_scream" ] = "warlord_civ_scream";
level.scr_sound[ "price" ][ "warlord_pri_handlethemlater" ] = "warlord_pri_handlethemlater";
level.scr_sound[ "militia_1" ][ "warlord_mlt2_wouldnt" ] = "warlord_mlt2_wouldnt";
level.scr_sound[ "civ_1" ][ "warlord_civ_myfamily" ] = "warlord_civ_myfamily";
level.scr_sound[ "militia_1" ][ "warlord_mlt2_timetopay" ] = "warlord_mlt2_timetopay";
level.scr_sound[ "civ_3" ][ "warlord_civ_noplease" ] = "warlord_civ_noplease";
level.scr_sound[ "militia_1" ][ "warlord_mlt2_whathewanted" ] = "warlord_mlt2_whathewanted";
level.scr_sound[ "price" ][ "warlord_pri_toomany" ] = "warlord_pri_toomany";
level.scr_sound[ "soap" ][ "warlord_mct_execution" ] = "warlord_mct_execution";
level.scr_sound[ "price" ][ "warlord_pri_yourcall" ] = "warlord_pri_yourcall";
level.scr_sound[ "soap" ][ "warlord_mct_bastards" ] = "warlord_mct_bastards";
level.scr_sound[ "price" ][ "warlord_pri_takethemout" ] = "warlord_pri_takethemout";
level.scr_sound[ "price" ][ "warlord_pri_bastards" ] = "warlord_pri_bastards";
level.scr_sound[ "price" ][ "warlord_pri_moveup2" ] = "warlord_pri_moveup2";
level.scr_sound[ "price" ][ "warlord_pri_alrightgetready" ] = "warlord_pri_alrightgetready";
level.scr_sound[ "price" ][ "warlord_pri_getdownnow" ] = "warlord_pri_getdownnow";
level.scr_sound[ "price" ][ "warlord_pri_getoffroad" ] = "warlord_pri_getoffroad";
level.scr_sound[ "price" ][ "warlord_pri_easy" ] = "warlord_pri_easy";
level.scr_sound[ "militia" ][ "warlord_mlt1_stormcoming" ] = "warlord_mlt1_stormcoming";
level.scr_sound[ "militia" ][ "warlord_mlt2_saywhen" ] = "warlord_mlt2_saywhen";
level.scr_sound[ "militia" ][ "warlord_mlt1_today" ] = "warlord_mlt1_today";
level.scr_sound[ "price" ][ "warlord_pri_allclear" ] = "warlord_pri_allclear";
level.scr_sound[ "soap" ][ "warlord_mct_holdup" ] = "warlord_mct_holdup";
level.scr_sound[ "soap" ][ "warlord_mct_2moreonbridge" ] = "warlord_mct_2moreonbridge";
level.scr_sound[ "price" ][ "warlord_pri_waitfortruck" ] = "warlord_pri_waitfortruck";
level.scr_sound[ "price" ][ "warlord_pri_dropem" ] = "warlord_pri_dropem";
level.scr_sound[ "price" ][ "warlord_pri_moveup" ] = "warlord_pri_moveup";
level.scr_sound[ "soap" ][ "warlord_pri_uptheroad" ] = "warlord_pri_uptheroad";
level.scr_sound[ "price" ][ "warlord_pri_coverus" ] = "warlord_pri_coverus";
level.scr_sound[ "price" ][ "warlord_pri_getupladder" ] = "warlord_pri_getupladder";
level.scr_sound[ "price" ][ "warlord_pri_getinposition" ] = "warlord_pri_getinposition";
level.scr_sound[ "price" ][ "warlord_pri_twohostiles" ] = "warlord_pri_twohostiles";
level.scr_sound[ "soap" ][ "warlord_pri_multipleguards" ] = "warlord_pri_multipleguards";
level.scr_sound[ "price" ][ "warlord_pri_militia" ] = "warlord_pri_militia";
level.scr_sound[ "soap" ][ "warlord_mct_boundingup" ] = "warlord_mct_boundingup";
level.scr_sound[ "price" ][ "warlord_pri_moving" ] = "warlord_pri_moving";
level.scr_sound[ "price" ][ "warlord_pri_move2" ] = "warlord_pri_move2";
level.scr_sound[ "soap" ][ "warlord_mct_moving" ] = "warlord_mct_moving";
level.scr_sound[ "price" ][ "warlord_pri_bounding" ] = "warlord_pri_bounding";
level.scr_sound[ "soap" ][ "warlord_mct_bounding2" ] = "warlord_mct_bounding2";
level.scr_sound[ "price" ][ "warlord_pri_breachingfactory" ] = "warlord_pri_breachingfactory";
level.scr_sound[ "price" ][ "warlord_mct_clear" ] = "warlord_mct_clear";
level.scr_sound[ "soap" ][ "warlord_mct_bloodyempty" ] = "warlord_mct_bloodyempty";
level.scr_radio[ "warlord_pri_dryhole" ] = "warlord_pri_dryhole";
level.scr_radio[ "warlord_kgr_rvthere" ] = "warlord_kgr_rvthere";
level.scr_sound[ "price" ][ "warlord_pri_hopetheydid" ] = "warlord_pri_hopetheydid";
level.scr_sound[ "soap" ][ "warlord_mct_headsup" ] = "warlord_mct_headsup";
level.scr_sound[ "price" ][ "warlord_pri_compromised" ] = "warlord_pri_compromised";
level.scr_sound[ "price" ][ "warlord_pri_yurirun" ] = "warlord_pri_yurirun";
level.scr_sound[ "price" ][ "warlord_pri_rallyonme2" ] = "warlord_pri_rallyonme2";
level.scr_sound[ "price" ][ "warlord_pri_pushforward" ] = "warlord_pri_pushforward";
level.scr_sound[ "price" ][ "warlord_pri_contactfront" ] = "warlord_pri_contactfront";
level.scr_sound[ "price" ][ "warlord_pri_magazine" ] = "warlord_pri_magazine";
level.scr_sound[ "price" ][ "warlord_pri_switchtoak" ] = "warlord_pri_switchtoak";
level.scr_sound[ "soap" ][ "warlord_mct_changingmags" ] = "warlord_mct_changingmags";
level.scr_sound[ "soap" ][ "warlord_mct_magazine" ] = "warlord_mct_magazine";
level.scr_sound[ "soap" ][ "warlord_mct_throughhere" ] = "warlord_mct_throughhere";
level.scr_sound[ "soap" ][ "warlord_mct_theyknow" ] = "warlord_mct_theyknow";
level.scr_sound[ "price" ][ "warlord_pri_makarovscargo" ] = "warlord_pri_makarovscargo";
level.scr_sound[ "price" ][ "warlord_pri_technical" ] = "warlord_pri_technical";
level.scr_sound[ "price" ][ "warlord_pri_man50cal" ] = "warlord_pri_man50cal";
level.scr_sound[ "price" ][ "warlord_pri_geton50" ] = "warlord_pri_geton50";
level.scr_sound[ "price" ][ "warlord_pri_enemyrooftop" ] = "warlord_pri_enemyrooftop";
level.scr_sound[ "price" ][ "warlord_pri_enemyrooftop" ] = "warlord_pri_enemyrooftop";
level.scr_sound[ "price" ][ "warlord_pri_contactleft" ] = "warlord_pri_contactleft";
level.scr_sound[ "price" ][ "warlord_pri_technicalincoming" ] = "warlord_pri_technicalincoming";
level.scr_sound[ "price" ][ "warlord_pri_putfire" ] = "warlord_pri_putfire";
level.scr_sound[ "soap" ][ "warlord_mct_contactleft" ] = "warlord_mct_contactleft";
level.scr_sound[ "soap" ][ "warlord_mct_rightright" ] = "warlord_mct_rightright";
level.scr_sound[ "price" ][ "warlord_pri_yurioverhere" ] = "warlord_pri_yurioverhere";
level.scr_sound[ "soap" ][ "warlord_mct_mortarfire" ] = "warlord_mct_mortarfire";
level.scr_sound[ "soap" ][ "warlord_mct_wholemilitia" ] = "warlord_mct_wholemilitia";
level.scr_sound[ "price" ][ "warlord_pri_gogogo" ] = "warlord_pri_gogogo";
level.scr_sound[ "price" ][ "warlord_pri_triangulating" ] = "warlord_pri_triangulating";
level.scr_sound[ "price" ][ "warlord_pri_move" ] = "warlord_pri_move";
level.scr_sound[ "price" ][ "warlord_pri_keepmoving" ] = "warlord_pri_keepmoving";
level.scr_sound[ "price" ][ "warlord_pri_go2" ] = "warlord_pri_go2";
level.scr_sound[ "price" ][ "warlord_pri_run" ] = "warlord_pri_run";
level.scr_sound[ "price" ][ "warlord_pri_dontstopmoving" ] = "warlord_pri_dontstopmoving";
level.scr_sound[ "price" ][ "warlord_pri_mortarincoming" ] = "warlord_pri_mortarincoming";
level.scr_sound[ "price" ][ "warlord_pri_incomingleft" ] = "warlord_pri_incomingleft";
level.scr_sound[ "price" ][ "warlord_pri_mortarleft" ] = "warlord_pri_mortarleft";
level.scr_sound[ "price" ][ "warlord_pri_incomingright" ] = "warlord_pri_incomingright";
level.scr_sound[ "price" ][ "warlord_pri_mortarright" ] = "warlord_pri_mortarright";
level.scr_sound[ "soap" ][ "warlord_mct_yurisdown" ] = "warlord_mct_yurisdown";
level.scr_sound[ "price" ][ "warlord_pri_keepmoving2" ] = "warlord_pri_keepmoving2";
level.scr_sound[ "price" ][ "warlord_pri_lostyou" ] = "warlord_pri_lostyou";
level.scr_sound[ "price" ][ "warlord_pri_slotmortar" ] = "warlord_pri_slotmortar";
level.scr_sound[ "soap" ][ "warlord_mct_mortardown" ] = "warlord_mct_mortardown";
level.scr_sound[ "price" ][ "warlord_pri_properwelcome" ] = "warlord_pri_properwelcome";
level.scr_sound[ "soap" ][ "warlord_pri_mortartube" ] = "warlord_pri_mortartube";
level.scr_sound[ "price" ][ "warlord_pri_takecontrol" ] = "warlord_pri_takecontrol";
level.scr_sound[ "price" ][ "warlord_pri_hosedown" ] = "warlord_pri_hosedown";
level.scr_sound[ "price" ][ "warlord_pri_lightemup" ] = "warlord_pri_lightemup";
level.scr_sound[ "price" ][ "warlord_pri_shellsdownrange" ] = "warlord_pri_shellsdownrange";
level.scr_sound[ "soap" ][ "warlord_mct_keepfiringmortar" ] = "warlord_mct_keepfiringmortar";
level.scr_sound[ "price" ][ "warlord_pri_targetsinvillage" ] = "warlord_pri_targetsinvillage";
level.scr_sound[ "soap" ][ "warlord_mct_sewerpipe" ] = "warlord_mct_sewerpipe";
level.scr_sound[ "price" ][ "warlord_pri_regroup" ] = "warlord_pri_regroup";
level.scr_sound[ "price" ][ "warlord_pri_hitthechurch" ] = "warlord_pri_hitthechurch";
level.scr_sound[ "price" ][ "warlord_pri_youcertain" ] = "warlord_pri_youcertain";
level.scr_radio[ "warlord_kgr_gotconfirmation" ] = "warlord_kgr_gotconfirmation";
level.scr_sound[ "soap" ][ "warlord_mct_letshope" ] = "warlord_mct_letshope";
level.scr_radio[ "warlord_kgr_weaponsinchurch" ] = "warlord_kgr_weaponsinchurch";
level.scr_sound[ "soap" ][ "warlord_mct_areaclear" ] = "warlord_mct_areaclear";
level.scr_sound[ "price" ][ "warlord_pri_otherside" ] = "warlord_pri_otherside";
level.scr_sound[ "price" ][ "warlord_pri_thereschurch" ] = "warlord_pri_thereschurch";
level.scr_sound[ "price" ][ "warlord_pri_pushtochurch" ] = "warlord_pri_pushtochurch";
level.scr_sound[ "soap" ][ "warlord_pri_justflewover" ] = "warlord_pri_justflewover";
level.scr_sound[ "price" ][ "warlord_pri_gettothatchurch" ] = "warlord_pri_gettothatchurch";
level.scr_sound[ "price" ][ "warlord_pri_keepmoving3" ] = "warlord_pri_keepmoving3";
level.scr_sound[ "price" ][ "warlord_pri_alrightlads" ] = "warlord_pri_alrightlads";
level.scr_sound[ "soap" ][ "warlord_mct_churchisclear" ] = "warlord_mct_churchisclear";
level.scr_sound[ "price" ][ "warlord_pri_outoftime" ] = "warlord_pri_outoftime";
level.scr_sound[ "price" ][ "warlord_pri_stackupletsgo" ] = "warlord_pri_stackupletsgo";
level.scr_sound[ "price" ][ "warlord_pri_getoverhere" ] = "warlord_pri_getoverhere";
level.scr_sound[ "price" ][ "warlord_pri_kamarashome" ] = "warlord_pri_kamarashome";
level.scr_radio[ "warlord_kgr_karamaalive" ] = "warlord_kgr_karamaalive";
level.scr_radio[ "warlord_kgr_onourway" ] = "warlord_kgr_onourway";
level.scr_radio[ "warlord_kgr_bulletmagnet" ] = "warlord_kgr_bulletmagnet";
level.scr_sound[ "kruger" ][ "warlord_kgr_loadup" ] = "warlord_kgr_loadup";
level.scr_sound[ "kruger" ][ "warlord_kgr_moneywired" ] = "warlord_kgr_moneywired";
level.scr_radio[ "warlord_nik_whatabout" ] = "warlord_nik_whatabout";
level.scr_radio[ "warlord_nik_sendingbird" ] = "warlord_nik_sendingbird";
level.scr_sound[ "price" ][ "warlord_pri_werespotted" ] = "warlord_pri_werespotted";
level.scr_sound[ "price" ][ "warlord_pri_theyveseen" ] = "warlord_pri_theyveseen";
level.scr_sound[ "price" ][ "warlord_pri_yurithisway" ] = "warlord_pri_yurithisway";
}
play_dialogue()
{
flag_wait( "allies_spawned" );
thread river_dialogue();
if( !is_split_level() || is_split_level_part("a") )
{
thread river_technical_militia_dialogue();
}
thread river_technical_stealth_broken_vo();
thread prone_encounter_dialogue();
thread executing_civilians_dialogue();
thread burn_interrupt_dialogue();
if( !is_split_level() || is_split_level_part("a") )
{
thread burn_happened_dialogue();
thread river_big_moment_dialogue();
}
thread river_spotted_dialogue();
if( !is_split_level() || is_split_level_part("a") )
{
thread bridge_dialogue();
}
thread cover_us_dialogue();
thread overwatch_dialogue();
thread rally_on_me_dialogue();
thread go_noisy_dialogue();
thread player_technical_dialogue();
thread player_technical_technical_blocker_dialogue();
thread player_technical_end_dialogue();
thread mortar_run_dialogue();
thread mortar_run_fire_dialogue();
thread player_mortar_dialogue();
thread assault_dialogue();
thread church_dialogue();
thread confrontation_dialogue();
}
dialogue_think(vo_line)
{
if (isDefined (level.vo_interupt) && level.vo_interupt == false)
{
self dialogue_queue( vo_line );
}
}
interupt_previous_lines(prev_lines_done_flag)
{
if (!flag(prev_lines_done_flag))
{
level.vo_interupt = true;
level.price stopSounds();
level.soap stopSounds();
wait (.5);
}
}
river_dialogue()
{
flag_wait( "play_river_dialogue" );
wait( 14 );
radio_dialogue( "warlord_nik_onehour" );
wait( 4 );
flag_set( "player_show_gun" );
aud_send_msg( "mus_stop_intro_music" );
wait( 4 );
level.soap dialogue_queue( "warlord_pri_lowprofile" );
level.price dialogue_queue( "warlord_pri_trynottodie" );
level.soap dialogue_queue( "warlord_mct_rogerthat" );
flag_set( "river_intro_vo_done" );
flag_wait( "river_technical_dialogue" );
level.soap dialogue_queue( "warlord_mct_tangosapproaching" );
level.price dialogue_queue( "warlord_pri_duck" );
flag_wait( "river_technicals_move_dialogue" );
level.price dialogue_queue( "warlord_pri_move3" );
}
ready_to_talk( guy )
{
if ( IsDefined( guy ) && IsAlive( guy ) && guy ent_flag( "_stealth_normal" ) )
{
return true;
}
return false;
}
river_technical_militia_dialogue()
{
level endon( "river_encounter_done" );
flag_wait( "river_technical_militia_dialogue" );
if ( ready_to_talk( level.river_technical_patrol[ 0 ] ) &&
ready_to_talk( level.river_technical_patrol[ 1 ] ) )
{
thread river_technical_militia_conversation();
}
}
river_technical_stealth_broken_vo()
{
level endon( "river_encounter_done" );
flag_wait( "technical_steal_broken_vo" );
level.price dialogue_queue( "warlord_pri_werespotted" );
}
river_technical_militia_conversation()
{
river_technical_militia_conversation_lines();
}
river_technical_militia_conversation_lines()
{
level endon( "conversation_interrupted" );
level.river_technical_patrol[ 0 ] endon( "death" );
level.river_technical_patrol[ 1 ] endon( "death" );
level.river_technical_patrol[ 0 ] thread interrupt_river_technical_militia_line();
level.river_technical_patrol[ 1 ] thread interrupt_river_technical_militia_line();
level.river_technical_patrol[ 0 ] dialogue_queue( "warlord_mlt1_everyonedead" );
level.river_technical_patrol[ 1 ] dialogue_queue( "warlord_mlt2_notall" );
level.river_technical_patrol[ 0 ] dialogue_queue( "warlord_mlt1_findothers" );
}
interrupt_river_technical_militia_line()
{
self endon( "death" );
level endon( "conversation_interrupted" );
self thread stop_speaking();
self ent_flag_waitopen( "_stealth_normal" );
level notify( "conversation_interrupted" );
}
stop_speaking()
{
self endon( "death" );
level waittill( "conversation_interrupted" );
self stopSounds();
}
prone_encounter_dialogue()
{
flag_wait( "prone_encounter_start_dialogue" );
level.soap dialogue_queue( "warlord_pri_twoxrays" );
level.price dialogue_queue( "warlord_pri_welldoneyuri" );
flag_wait( "river_encounter_3_complete" );
wait 0.05;
if ( flag( "prone_encounter_well_done_dialogue" ) )
{
level.soap dialogue_queue( "warlord_mct_clear2" );
}
}
executing_civilians_dialogue()
{
flag_wait( "tire_necklace_dialogue" );
level.soap dialogue_queue( "warlord_mct_execution" );
wait( 1 );
if( !flag( "river_burn_interrupted" ) )
{
level.price dialogue_queue( "warlord_pri_yourcall" );
}
flag_wait( "allies_path_to_big_moment" );
if( flag( "river_burn_interrupted" ) )
{
wait( 1 );
}
level.price dialogue_queue( "warlord_pri_move3" );
}
burn_interrupt_dialogue()
{
level endon( "river_house_burn_anim_finished" );
flag_wait( "river_burn_interrupted" );
level.price dialogue_queue( "warlord_pri_takethemout" );
}
burn_happened_dialogue()
{
level endon( "river_burn_interrupted" );
flag_wait( "river_house_burn_anim_finished" );
level.soap dialogue_queue( "warlord_mct_bastards" );
level.price dialogue_queue( "warlord_pri_handlethemlater" );
}
river_big_moment_dialogue()
{
level endon( "river_big_moment_stealth_spotted" );
flag_wait( "flag_player_first_beat" );
flag_waitopen( "_stealth_spotted" );
level.price dialogue_queue( "warlord_pri_moveup2" );
level.price dialogue_queue( "warlord_pri_toomany" );
flag_wait( "dont_be_stupid_dialogue" );
level.price dialogue_queue( "warlord_pri_bastards" );
wait( 9 );
level.price dialogue_queue( "warlord_pri_alrightgetready" );
flag_wait( "second_beat_move_dialogue" );
level.price dialogue_queue( "warlord_pri_move3" );
flag_wait( "off_road_vo" );
level.price dialogue_queue( "warlord_pri_getoffroad" );
flag_wait( "off_the_road_dialogue" );
level.price dialogue_queue( "warlord_pri_getdownnow" );
flag_wait( "river_burn_watchers_leave" );
wait( 3 );
level.price dialogue_queue( "warlord_pri_easy" );
wait( 9 );
if(isalive(level.river_dialogue_guys[0]))
{
level.river_dialogue_guys[ 0 ] dialogue_queue( "warlord_mlt1_stormcoming" );
wait( 1 );
if(isalive(level.river_dialogue_guys[1]))
{
level.river_dialogue_guys[ 1 ] dialogue_queue( "warlord_mlt2_saywhen" );
wait( 1 );
if(isalive(level.river_dialogue_guys[0]))
{
level.river_dialogue_guys[ 0 ] dialogue_queue( "warlord_mlt1_today" );
}
}
}
flag_wait( "river_big_moment_done_dialogue" );
wait( 2 );
level.price dialogue_queue( "warlord_pri_allclear" );
}
river_spotted_dialogue()
{
level endon ( "price_door_triggered" );
flag_wait( "river_spotted_dialogue" );
level.price dialogue_queue( "warlord_pri_compromised" );
}
bridge_dialogue()
{
level endon( "river_spotted_dialogue" );
flag_wait( "flag_player_at_third_beat" );
level.soap dialogue_queue( "warlord_mct_holdup" );
flag_wait( "flag_go_to_bridge" );
level.soap dialogue_queue( "warlord_mct_clear2" );
flag_wait( "church_mouse_dialogue" );
level.soap dialogue_queue( "warlord_mct_2moreonbridge" );
level.price dialogue_queue( "warlord_pri_waitfortruck" );
flag_wait( "bridge_go_loud_dialogue" );
level.price dialogue_queue( "warlord_pri_dropem" );
flag_wait( "bridge_guys_dead_dialogue" );
level.price dialogue_queue( "warlord_pri_moveup" );
}
cover_us_dialogue()
{
level.price endon( "death" );
level endon( "inf_stealth_spotted" );
flag_wait( "large_group_dialogue" );
level.soap dialogue_queue( "warlord_pri_uptheroad" );
flag_wait( "cover_us_dialogue" );
level.price dialogue_queue( "warlord_pri_coverus" );
thread cover_us_hurry_lines();
}
cover_us_hurry_lines()
{
level endon( "inf_teleport_allies" );
level endon( "infiltration_over" );
level endon( "inf_stealth_spotted" );
if ( flag( "infiltration_over" ) || flag( "inf_stealth_spotted" ) )
return;
current_line = "warlord_pri_getinposition";
next_line = "warlord_pri_getupladder";
while( !flag( "inf_teleport_allies" ) )
{
wait( 5 );
level.price dialogue_queue( current_line );
temp = current_line;
current_line = next_line;
next_line = temp;
}
}
overwatch_dialogue()
{
thread overwatch_sniper_dialogue();
thread factory_breach_dialogue();
}
overwatch_sniper_dialogue()
{
level endon( "infiltration_over" );
level endon( "inf_stealth_spotted" );
flag_wait( "multiple_guards_dialogue" );
level.price dialogue_queue( "warlord_pri_twohostiles" );
flag_set( "inf_encounter_2_vo_done" );
flag_wait( "inf_ramp_guys_dead" );
level.soap dialogue_queue( "warlord_pri_multipleguards" );
flag_wait_all( "inf_ramp_guys_dead", "inf_talkers_dead" );
level.soap dialogue_queue( "warlord_mct_boundingup" );
flag_wait( "more_militia_dialogue" );
level.price dialogue_queue( "warlord_pri_militia" );
flag_wait( "inf_both_moving_dialogue" );
wait( 1 );
level.soap dialogue_queue( "warlord_mct_moving" );
level.price dialogue_queue( "warlord_pri_moving" );
wait( 1 );
level.price dialogue_queue( "warlord_pri_breachingfactory" );
}
factory_breach_dialogue()
{
flag_wait( "breaching_factory_dialogue" );
wait( 1 );
level.price dialogue_queue( "warlord_mct_clear" );
level.soap dialogue_queue( "warlord_mct_bloodyempty" );
radio_dialogue( "warlord_pri_dryhole" );
radio_dialogue( "warlord_kgr_rvthere" );
level.price dialogue_queue( "warlord_pri_hopetheydid" );
if ( !flag( "inf_stealth_spotted" ) )
{
level.soap dialogue_queue( "warlord_mct_headsup" );
}
wait( 1 );
flag_set( "breaching_factory_dialogue_done" );
}
rally_on_me_dialogue()
{
level.soap endon( "death" );
level.price endon( "death" );
flag_wait_any( "breaching_factory_dialogue_done", "inf_stealth_spotted" );
aud_send_msg( "mus_go_hot" );
level.price dialogue_queue( "warlord_pri_compromised" );
wait( 3 );
weapons = level.player GetWeaponsList( "primary" );
flag_set( "no_ak_vo" );
foreach( weapon in weapons )
{
if( isSubStr( weapon, "ak47" ) )
{
flag_clear( "no_ak_vo" );
}
}
primary = level.player GetCurrentPrimaryWeapon();
if( isSubStr( primary, "ak47" ) )
{
flag_set( "no_ak_vo" );
}
if( !flag( "no_ak_vo" ) )
{
level.price dialogue_queue( "warlord_pri_switchtoak" );
}
wait( 3 );
level.price dialogue_queue( "warlord_pri_yurirun" );
wait( 3 );
level.price dialogue_queue( "warlord_pri_rallyonme2" );
}
advance_clear_and_nag_lines()
{
if ( flag( "player_technical_spawn" ) )
return;
flag_wait( "advance_combat_complete" );
wait( 1 );
level.soap dialogue_queue( "warlord_mct_areaclear" );
thread advance_nag_lines();
level.soap dialogue_queue( "warlord_mct_throughhere" );
flag_wait( "player_technical_spawn" );
wait( 1 );
level.soap dialogue_queue( "warlord_mct_theyknow" );
level.price dialogue_queue( "warlord_pri_makarovscargo" );
}
advance_nag_lines()
{
lines = [];
lines[0] = "warlord_pri_yurioverhere";
lines[1] = "warlord_pri_yurithisway";
thread maps\_shg_common::dialogue_reminder( level.price, "player_technical_spawn", lines, 5, 10 );
}
go_noisy_dialogue()
{
level.price endon( "death" );
flag_wait( "go_noisy_dialogue" );
thread advance_clear_and_nag_lines();
flag_wait( "push_forward_dialogue" );
level.price dialogue_queue( "warlord_pri_pushforward" );
flag_wait( "technical_ahead_dialogue" );
if ( IsDefined( level.price.at_technical_area ) )
{
level.price dialogue_queue( "warlord_pri_technical" );
}
}
player_technical_dialogue()
{
level.soap endon( "death" );
level.price endon( "death" );
flag_wait( "player_technical_dialogue" );
if ( IsDefined( level.price.at_technical_area ) )
{
level.price dialogue_queue( "warlord_pri_man50cal" );
}
thread player_technical_hurry_dialogue();
flag_wait( "technical_1_dialogue" );
if ( IsDefined( level.price.at_technical_area ) )
{
level.price dialogue_queue( "warlord_pri_putfire" );
}
flag_wait( "roof_right_dialogue" );
if ( IsDefined( level.price.at_technical_area ) )
{
level.price dialogue_queue( "warlord_pri_enemyrooftop" );
}
thread technical_call_out_guys( level.price, "contact_front_1_dialogue", "warlord_pri_contactfront" );
thread technical_call_out_guys( level.price, "contact_left_1_dialogue", "warlord_pri_contactleft" );
thread technical_call_out_guys( level.soap, "contact_left_2_dialogue", "warlord_mct_contactleft" );
thread technical_call_out_guys( level.price, "contact_front_2_dialogue", "warlord_pri_contactfront" );
thread technical_call_out_guys( level.soap, "contact_right_1_dialogue", "warlord_mct_rightright" );
thread technical_call_out_guys( level.price, "contact_left_3_dialogue", "warlord_pri_contactleft" );
thread technical_call_out_guys( level.price, "contact_left_4_dialogue", "warlord_pri_contactleft" );
thread technical_call_out_guys( level.price, "contact_front_3_dialogue", "warlord_pri_contactfront" );
}
technical_call_out_guys( ally, wait_flag, dialogue )
{
level endon( "technical_combat_complete" );
flag_wait( wait_flag );
if ( IsDefined( ally.at_technical_area ) )
{
ally dialogue_queue( dialogue );
}
}
player_technical_technical_blocker_dialogue()
{
flag_wait( "technical_2_dialogue" );
if ( IsDefined( level.price.at_technical_area ) )
{
level.price dialogue_queue( "warlord_pri_technicalincoming" );
}
}
player_technical_hurry_dialogue()
{
level endon( "player_boarding_technical" );
level endon( "technical_turret_combat_timer_complete" );
level endon( "technical_stalled_combat_complete" );
counter = 0;
while( !flag( "player_boarding_technical" ) && counter < 3 )
{
wait( 5 );
if( !flag( "player_boarding_technical" ) )
{
if ( IsDefined( level.price.at_technical_area ) )
{
level.price dialogue_queue( "warlord_pri_geton50" );
}
counter++;
}
}
}
player_technical_end_dialogue()
{
level.soap endon( "death" );
flag_wait( "player_technical_dialogue" );
flag_wait( "mortar_technical" );
level.soap dialogue_queue( "warlord_mct_mortarfire" );
if( flag( "player_on_technical" ) )
{
flag_wait( "mortar_technical_hit" );
wait 10;
flag_set( "militia_vo_done" );
}
if( !flag( "player_on_technical" ) )
{
wait( 2.5 );
level.soap dialogue_queue( "warlord_mct_wholemilitia" );
flag_set( "militia_vo_done" );
}
}
mortar_run_dialogue()
{
level.price endon( "death" );
flag_wait( "mortar_run_dialogue" );
wait( 2 );
level.price dialogue_queue( "warlord_pri_triangulating" );
flag_wait( "mortar_roof_fall_dialogue" );
level.soap dialogue_queue( "warlord_mct_yurisdown" );
level.price dialogue_queue( "warlord_pri_keepmoving2" );
flag_wait( "mortar_door_dialogue" );
level.price dialogue_queue( "warlord_pri_lostyou" );
flag_wait( "mortar_fight_shot" );
level.price dialogue_queue( "warlord_pri_slotmortar" );
flag_wait( "mortar_operator_off" );
flag_waitopen( "dialogue_in_progress" );
flag_set( "dialogue_in_progress" );
level.soap dialogue_queue( "warlord_mct_mortardown" );
flag_clear( "dialogue_in_progress" );
}
use_up_mortar_line( lines_array )
{
if ( IsDefined( lines_array ) && lines_array.size > 0 )
{
dialogue_index = RandomInt( lines_array.size );
level.vo_mortar_line = lines_array[ dialogue_index ];
lines_array = array_remove_index( lines_array, dialogue_index );
return lines_array;
}
return undefined;
}
mortar_run_fire_dialogue()
{
level.player endon( "death" );
level endon( "mortar_roof_fall_dialogue" );
move_lines = [];
move_lines[ move_lines.size ] = "warlord_pri_move";
move_lines[ move_lines.size ] = "warlord_pri_keepmoving";
move_lines[ move_lines.size ] = "warlord_pri_go2";
move_lines[ move_lines.size ] = "warlord_pri_run";
move_lines[ move_lines.size ] = "warlord_pri_dontstopmoving";
move_lines[ move_lines.size ] = "warlord_pri_gogogo";
mortar_lines = [];
mortar_lines[ mortar_lines.size ] = "warlord_pri_mortarincoming";
mortar_left_lines = [];
mortar_left_lines[ mortar_left_lines.size ] = "warlord_pri_incomingleft";
mortar_left_lines[ mortar_left_lines.size ] = "warlord_pri_mortarleft";
mortar_right_lines = [];
mortar_right_lines[ mortar_right_lines.size ] = "warlord_pri_incomingright";
mortar_right_lines[ mortar_right_lines.size ] = "warlord_pri_mortarright";
min_delay_between_lines = 3000;
last_mortar_line_time = min_delay_between_lines * -2;
flag_wait( "mortar_run_dialogue" );
while( 1 )
{
mortar_side = wait_on_mortar_line();
level.vo_mortar_line = undefined;
if ( IsDefined( mortar_side ) )
{
if ( mortar_side == "right_side" )
{
mortar_right_lines = use_up_mortar_line( mortar_right_lines );
}
else if ( mortar_side == "left_side" )
{
mortar_left_lines = use_up_mortar_line( mortar_left_lines );
}
else if ( mortar_side == "no_side" )
{
mortar_lines = use_up_mortar_line( mortar_lines );
}
else
{
AssertEx( false, "unrecognized mortar_side parameter: " + mortar_side );
}
}
if ( !IsDefined( level.vo_mortar_line ) )
{
move_lines = use_up_mortar_line( move_lines );
}
if ( IsDefined( level.vo_mortar_line ) )
{
if ( GetTime() - last_mortar_line_time > min_delay_between_lines )
{
level.price dialogue_queue( level.vo_mortar_line );
last_mortar_line_time = GetTime();
}
}
}
}
wait_on_mortar_line()
{
level endon( "mortar_line_timeout" );
thread mortar_line_timeout();
level waittill( "mortar_incoming_dialogue", mortar_side );
return mortar_side;
}
mortar_line_timeout()
{
level endon( "mortar_incoming_dialogue" );
wait 5;
level notify( "mortar_line_timeout" );
}
player_mortar_dialogue()
{
level.price endon( "death" );
flag_wait( "head_to_mortar_dialogue" );
waittillframeend;
flag_waitopen( "dialogue_in_progress" );
flag_set( "dialogue_in_progress" );
level.soap dialogue_queue( "warlord_pri_mortartube" );
level.price dialogue_queue( "warlord_pri_properwelcome" );
flag_clear( "dialogue_in_progress" );
thread player_use_mortar_nag();
flag_wait( "player_at_mortar" );
level.price dialogue_queue( "warlord_pri_shellsdownrange" );
wait( 2.0 );
level.price dialogue_queue( "warlord_pri_hosedown" );
flag_wait( "mortar_targets_dialogue" );
level.price dialogue_queue( "warlord_pri_lightemup" );
wait( 2.0 );
level.price dialogue_queue( "warlord_pri_targetsinvillage" );
flag_wait( "keep_firing_mortar" );
level.soap dialogue_queue( "warlord_mct_keepfiringmortar" );
}
player_use_mortar_nag()
{
level endon( "player_at_mortar" );
if ( flag( "player_at_mortar" ) )
return;
while ( true )
{
wait 8;
level.price dialogue_queue( "warlord_pri_takecontrol" );
}
}
assault_dialogue()
{
thread regroup_dialogue();
thread begin_assault_dialogue();
}
regroup_dialogue()
{
level.price endon( "death" );
flag_wait( "regroup_dialogue" );
aud_send_msg( "mus_player_mortar_done" );
level.price dialogue_queue( "warlord_pri_regroup" );
level.price dialogue_queue( "warlord_pri_hitthechurch" );
flag_wait( "assault_run_to_pipe" );
wait( 2.0 );
level.soap dialogue_queue( "warlord_mct_sewerpipe" );
}
begin_assault_dialogue()
{
flag_wait( "sewer_pipe_vo" );
level.price dialogue_queue( "warlord_pri_youcertain" );
radio_dialogue( "warlord_kgr_gotconfirmation" );
level.soap dialogue_queue( "warlord_mct_letshope" );
flag_wait( "assault_all_clear" );
guys = GetAiArray( "axis" );
if( !flag( "assault_compound_failsafe" ) && guys.size == 0 )
{
wait 2;
level.soap dialogue_queue( "warlord_mct_areaclear" );
}
flag_wait( "house_door_dialogue" );
level.price dialogue_queue( "warlord_pri_otherside" );
}
church_dialogue()
{
flag_wait( "theres_church_dialogue" );
level.price dialogue_queue( "warlord_pri_thereschurch" );
wait( 2 );
level.soap dialogue_queue( "warlord_pri_justflewover" );
level.price dialogue_queue( "warlord_pri_gettothatchurch" );
thread church_nag_lines();
flag_wait( "church_breach_complete" );
wait( 1 );
level.soap dialogue_queue( "warlord_mct_churchisclear" );
level.price dialogue_queue( "warlord_pri_outoftime" );
wait( 1 );
level.price dialogue_queue( "warlord_pri_alrightlads" );
thread breach_nag_lines();
}
church_nag_lines()
{
lines = [];
lines[0] = "warlord_pri_pushtochurch";
lines[1] = "warlord_pri_pushforward";
lines[2] = "warlord_pri_keepmoving3";
thread maps\_shg_common::dialogue_reminder( level.price, "end_church_nag_vo", lines, 7, 10 );
}
breach_nag_lines()
{
lines = [];
lines[0] = "warlord_pri_kamarashome";
lines[1] = "warlord_pri_stackupletsgo";
lines[2] = "warlord_pri_getoverhere";
wait( 5 );
thread maps\_shg_common::dialogue_reminder( level.price, "breach_starting", lines, 5, 6 );
}
confrontation_dialogue()
{
flag_wait( "getting_away_dialogue" );
radio_dialogue( "warlord_nik_whatabout" );
wait( 7 );
flag_set( "confrontation_vo_finished" );
}
