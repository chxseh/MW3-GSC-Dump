#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;
main()
{
prepare_dialogue();
}
prepare_dialogue()
{
Price = "price";
Nikolai = "nikolai";
Doctor = "doctor";
Soap = "soap";
level.scr_sound[Price][ "intro_pri_inside" ] = "intro_pri_inside";
level.scr_sound[Price][ "intro_pri_getdoctor" ] = "intro_pri_getdoctor";
level.scr_sound[Price][ "intro_pri_needshelp" ] = "intro_pri_needshelp";
level.scr_sound[Nikolai][ "intro_nik_howmany" ] = "intro_nik_howmany";
level.scr_sound[Nikolai][ "intro_nik_choppers" ] = "intro_nik_choppers";
level.scr_sound[Price][ "intro_pri_looseends" ] = "intro_pri_looseends";
level.scr_sound[Nikolai][ "intro_opening_shot02_nikolai_face" ][0] = "intro_nik_safehouse";
level.scr_sound[Price][ "intro_opening_shot02_price_face" ][0] = "intro_pri_keepmoving";
level.scr_sound[Price][ "intro_opening_shot04_price_face" ][0] = "intro_nik_keeppressure";
level.scr_sound[Nikolai][ "intro_opening_shot04_face" ][ 0 ] = "intro_nik_imtrying";
level.scr_sound[Nikolai][ "intro_opening_shot04_face" ][ 1 ] = "intro_nik_hanginthere";
level.scr_sound[Nikolai][ "intro_nik_charging" ] = "intro_nik_charging";
level.scr_sound[Nikolai][ "intro_nik_threetwoone" ] = "intro_nik_threetwoone";
level.scr_sound[Nikolai][ "intro_nik_321clear" ] = "intro_nik_321clear";
level.scr_radio[ "intro_loy1_attackchoppers" ] = "intro_loy1_attackchoppers";
level.scr_radio[ "intro_loy2_howmany" ] = "intro_loy2_howmany";
level.scr_radio[ "intro_loy1_fastroping" ] = "intro_loy1_fastroping";
level.scr_radio[ "intro_loy2_fireteam" ] = "intro_loy2_fireteam";
level.scr_sound[Soap][ "intro_nik_yuri" ] = "intro_nik_yuri";
level.scr_sound[Price][ "intro_pri_getsoap" ] = "intro_pri_getsoap";
level.scr_sound[Soap][ "" ] = "";
level.scr_sound[Nikolai][ "intro_opening_shot07_face" ][ 0 ] = "intro_nik_yurioverhere";
level.scr_sound[Nikolai][ "intro_opening_shot07_face" ][ 1 ] = "intro_nik_whatisthat";
level.scr_sound[Price][ "intro_pri_iseveryone" ] = "intro_pri_iseveryone";
level.scr_sound[Nikolai][ "intro_opening_shot08_face" ][ 0 ] = "intro_nik_da";
level.scr_sound[Nikolai][ "intro_opening_shot08_face" ][ 1 ] = "intro_nik_thismansays";
level.scr_radio[ "intro_loy1_ineedshooters" ] = "intro_loy1_ineedshooters";
level.scr_radio[ "intro_loy2_morechoppers" ] = "intro_loy2_morechoppers";
level.scr_radio[ "intro_loy1_runningout" ] = "intro_loy1_runningout";
level.scr_radio[ "intro_loy1_getcivilians" ] = "intro_loy1_getcivilians";
level.scr_sound[Price][ "intro_pri_balcony" ] = "intro_pri_balcony";
level.scr_sound[Price][ "intro_pri_holdthemoff" ] = "intro_pri_holdthemoff";
level.scr_sound[Price][ "intro_pri_eyesoncourtyard" ] = "intro_pri_eyesoncourtyard";
level.scr_sound[Price][ "intro_pri_theybreached" ] = "intro_pri_theybreached";
level.scr_sound[Nikolai][ "intro_nik_doctorsdown" ] = "intro_nik_doctorsdown";
level.scr_sound[Nikolai][ "intro_nik_needyourhelp" ] = "intro_nik_needyourhelp";
level.scr_sound[Nikolai][ "intro_nik_getoverhere" ] = "intro_nik_getoverhere";
level.scr_sound[Nikolai][ "intro_nik_theshot" ] = "intro_nik_theshot";
level.scr_sound[Price][ "escort_help_soap_breach_price_face" ][0] = "intro_pri_soaptochopper";
level.scr_sound[Nikolai][ "intro_nik_ivegothim" ] = "intro_nik_ivegothim";
level.scr_sound[Price][ "escort_help_soap_breach_price_face" ][1] = "intro_pri_yourewithme";
level.scr_sound[Price][ "intro_pri_yurioverhere" ] = "intro_pri_yurioverhere";
level.scr_sound[Price][ "intro_pri_downthestairs" ] = "intro_pri_downthestairs";
level.scr_sound[Price][ "intro_pri_yurionme" ] = "intro_pri_yurionme";
level.scr_sound[Price][ "intro_pri_throughcourtyard" ] = "intro_pri_throughcourtyard";
level.scr_radio[ "intro_loy1_pinneddown" ] = "intro_loy1_pinneddown";
level.scr_sound[Price][ "price_to_nikolai_face" ][ 0 ] = "intro_pri_overhead";
level.scr_sound[Price][ "price_to_nikolai_face" ][ 1 ] = "intro_pri_firepower";
level.scr_radio[ "intro_nik_weaponscache" ] = "intro_nik_weaponscache";
level.scr_sound[Price][ "price_to_nikolai_face" ][ 2 ] = "intro_pri_letsmove";
level.scr_sound[Price][ "price_to_nikolai_face" ][ 3 ] = "intro_pri_civilians";
level.scr_sound[Price][ "intro_pri_clearapath" ] = "intro_pri_clearapath";
level.scr_radio[ "intro_nik_roger" ] = "intro_nik_roger";
level.scr_sound[Price][ "intro_pri_watchbalconies" ] = "intro_pri_watchbalconies";
level.scr_sound[Price][ "intro_pri_doorwayright" ] = "intro_pri_doorwayright";
level.scr_sound[Price][ "intro_pri_protectsoap" ] = "intro_pri_protectsoap";
level.scr_radio[ "intro_loy2_courtyardsclear" ] = "intro_loy2_courtyardsclear";
level.scr_sound[Price][ "intro_pri_downthestreet" ] = "intro_pri_downthestreet";
level.scr_sound[Price][ "intro_pri_getsoapout" ] = "intro_pri_getsoapout";
level.scr_sound[Price][ "intro_pri_machinegunner" ] = "intro_pri_machinegunner";
level.scr_sound[Price][ "intro_pri_yurioverhere2" ] = "intro_pri_yurioverhere2";
level.scr_sound[Price][ "intro_pri_chopperthisway" ] = "intro_pri_chopperthisway";
level.scr_sound[Price][ "intro_pri_lookout" ] = "intro_pri_lookout";
level.scr_sound[Price][ "intro_pri_dronepass" ] = "intro_pri_dronepass";
level.scr_sound[Nikolai][ "intro_nik_directlyahead" ] = "intro_nik_directlyahead";
level.scr_sound[Price][ "intro_pri_toomanyofthem" ] = "intro_pri_toomanyofthem";
level.scr_sound[Price][ "intro_pri_needthatugv" ] = "intro_pri_needthatugv";
level.scr_sound[Nikolai][ "intro_nik_gothrough" ] = "intro_nik_gothrough";
level.scr_sound[Price][ "intro_pri_yurithisway" ] = "intro_pri_yurithisway";
level.scr_radio[ "intro_loy2_breaching" ] = "intro_loy2_breaching";
level.scr_sound[Price][ "intro_pri_ugvthisway" ] = "intro_pri_ugvthisway";
level.scr_sound[Price][ "intro_pri_overhere" ] = "intro_pri_overhere";
level.scr_sound[Price][ "intro_pri_holdup" ] = "intro_pri_holdup";
level.scr_sound[Price][ "intro_pri_getinside" ] = "intro_pri_getinside";
level.scr_sound[Price][ "intro_pri_letthempass" ] = "intro_pri_letthempass";
level.scr_sound[Nikolai][ "intro_nik_shippingcrate" ] = "intro_nik_shippingcrate";
level.scr_sound[Price][ "intro_pri_iseeit" ] = "intro_pri_iseeit";
level.scr_sound[Price][ "intro_pri_controlsrussian" ] = "intro_pri_controlsrussian";
level.scr_sound[Price][ "intro_pri_soapscondition" ] = "intro_pri_soapscondition";
level.scr_sound[Nikolai][ "intro_nik_gethimout" ] = "intro_nik_gethimout";
level.scr_sound[Price][ "intro_pri_wellbebehind" ] = "intro_pri_wellbebehind";
level.scr_sound[Price][ "intro_weapon_cache_pullout_face" ][ 0 ] = "intro_pri_ugv";
level.scr_radio[ "intro_pri_clearthepath" ] = "intro_pri_clearthepath";
level.scr_radio[ "intro_pri_keepfiring" ] = "intro_pri_keepfiring";
level.scr_radio[ "intro_pri_keeppushing" ] = "intro_pri_keeppushing";
level.scr_sound[Price][ "intro_pri_grabcontrols" ] = "intro_pri_grabcontrols";
level.scr_radio[ "intro_pri_targetanything" ] = "intro_pri_targetanything";
level.scr_radio[ "intro_pri_switchthermal" ] = "intro_pri_switchthermal";
level.scr_radio[ "intro_pri_usethermal" ] = "intro_pri_usethermal";
level.scr_radio[ "intro_pri_punchwalls" ] = "intro_pri_punchwalls";
level.scr_radio[ "intro_pri_uselauncher" ] = "intro_pri_uselauncher";
level.scr_radio[ "intro_pri_takeoutchoppers" ] = "intro_pri_takeoutchoppers";
level.scr_radio[ "intro_pri_weremovingup" ] = "intro_pri_weremovingup";
level.scr_radio[ "intro_pri_atthechopper" ] = "intro_pri_atthechopper";
level.scr_radio[ "intro_nik_notlookinggood" ] = "intro_nik_notlookinggood";
level.scr_radio[ "intro_pri_droneinbound" ] = "intro_pri_droneinbound";
level.scr_radio[ "intro_pri_runtochopper" ] = "intro_pri_runtochopper";
level.scr_radio[ "intro_pri_gogo" ] = "intro_pri_gogo";
level.scr_radio[ "intro_pri_lookout2" ] = "intro_pri_lookout2";
level.scr_sound[Price][ "intro_pri_holdon" ] = "intro_pri_holdon";
level.scr_sound[Price][ "intro_pri_aftermakarov" ] = "intro_pri_aftermakarov";
level.scr_radio[ "intro_mct_whosyuri" ] = "intro_mct_whosyuri";
level.scr_radio[ "intro_nik_thereheis" ] = "intro_nik_thereheis";
level.scr_radio[ "intro_pri_aftermakarov" ] = "intro_pri_aftermakarov";
}
intro_dialog()
{
flag_wait( "intro_dialog_shot_1" );
wait 5;
level.price dialogue_queue( "intro_pri_inside" );
flag_wait( "intro_dialog_shot_2" );
flag_wait( "intro_dialog_shot_3" );
level.price dialogue_queue( "intro_pri_getdoctor" );
flag_wait( "intro_dialog_shot_4" );
flag_wait( "intro_dialog_shot_5" );
wait 2;
level.price dialogue_queue( "intro_pri_needshelp" );
wait 2;
level.nikolai dialogue_queue( "intro_nik_321clear" );
flag_set( "intro_opening_movie_start" );
}
intro_dialog_transition()
{
radio_dialogue( "intro_loy1_attackchoppers" );
radio_dialogue( "intro_loy2_howmany" );
radio_dialogue( "intro_loy1_fastroping" );
radio_dialogue( "intro_loy2_fireteam" );
flag_set( "intro_transition_dialog_end" );
level.soap dialogue_queue( "intro_nik_yuri" );
flag_wait( "intro_dialog_shot_7" );
aud_send_msg("mus_vo_nik_yurioverhere");
wait 3;
level.price dialogue_queue( "intro_pri_getsoap" );
flag_wait( "intro_dialog_shot_8" );
wait 3;
level.price dialogue_queue( "intro_pri_iseveryone" );
flag_wait( "intro_dialog_shot_8_complete" );
flag_set( "courtyard_dialog_balcony_start" );
}
courtyard_dialog_intro()
{
flag_wait( "courtyard_dialog_balcony_start" );
thread courtyard_take_position_on_balcony();
flag_wait( "courtyard_dialog_intro_start" );
}
courtyard_take_position_on_balcony()
{
level.price dialogue_queue( "intro_pri_balcony" );
flag_set( "courtyard_dialog_intro_end" );
flag_set( "obj_take_position_on_balcony" );
}
courtyard_dialog_watch_breach()
{
level.price dialogue_queue( "intro_pri_eyesoncourtyard" );
aud_send_msg("mus_eyes_on_courtyard");
flag_set( "obj_watch_courtyard" );
}
courtyard_dialog_breached()
{
wait( .5 );
level.price dialogue_queue( "intro_pri_theybreached" );
wait 3;
level.price dialogue_queue( "intro_pri_holdthemoff" );
wait 3;
radio_dialogue( "intro_loy1_ineedshooters" );
radio_dialogue( "intro_loy2_morechoppers" );
}
courtyard_dialog_combat_done()
{
}
escort_dialog()
{
thread escort_dialog_help_soap();
thread escort_dialog_help_soap_give_shot();
thread escort_dialog_exit_hotel();
thread escort_dialog_at_stairs();
thread escort_dialog_courtyard();
}
escort_dialog_help_soap()
{
flag_wait( "escort_player_help_soap" );
level.nikolai dialogue_queue( "intro_nik_doctorsdown" );
wait .5;
level.nikolai dialogue_queue( "intro_nik_needyourhelp" );
thread escort_dialog_help_soap_nag();
}
escort_dialog_help_soap_nag()
{
level endon( "escort_player_helping_soap" );
while( !flag( "escort_player_helping_soap" ) )
{
level.nikolai dialogue_queue( "intro_nik_getoverhere" );
wait( 5 );
}
}
escort_dialog_help_soap_give_shot()
{
flag_wait( "escort_player_helping_soap" );
level.nikolai dialogue_queue( "intro_nik_theshot" );
}
escort_dialog_exit_hotel()
{
flag_wait( "escort_help_soap_breachers_dead" );
wait 2;
level.Nikolai dialogue_queue( "intro_nik_ivegothim" );
}
escort_dialog_at_stairs()
{
flag_wait( "escort_player_exited_room" );
level.price dialogue_queue( "intro_pri_yurioverhere" );
flag_wait( "escort_rappelers_dead" );
level.price dialogue_queue( "intro_pri_downthestairs" );
}
escort_dialog_courtyard()
{
flag_wait( "escort_player_starting_courtyard" );
level.price dialogue_queue( "intro_pri_yurionme" );
level.price dialogue_queue( "intro_pri_throughcourtyard" );
flag_wait( "escort_player_halfway_through_courtyard" );
aud_send_msg("mus_halfway_through_courtyard");
radio_dialogue( "intro_loy1_pinneddown" );
}
escort_dialog_courtyard_clear()
{
vol = getent( "escort_courtyard_clear_dialog", "targetname" );
while( vol get_ai_touching_volume( "axis" ).size > 0 )
wait .1;
radio_dialogue( "intro_loy2_courtyardsclear" );
}
regroup_dialog()
{
thread regroup_dialog_before_street_battle();
thread regroup_dialog_street_battle();
thread regroup_dialog_weapons_ahead();
}
regroup_dialog_before_street_battle()
{
flag_wait( "regroup_dialog_intro_start_all_clear" );
aud_send_msg("vo_price_moveup");
wait 3;
wait 8;
radio_dialogue( "intro_nik_weaponscache" );
flag_set( "regroup_dialog_intro_complete" );
}
regroup_dialog_street_battle()
{
flag_wait( "regroup_player_starting_street_battle" );
level.price dialogue_queue( "intro_pri_watchbalconies" );
level.price dialogue_queue( "intro_pri_protectsoap" );
level.price dialogue_queue( "intro_pri_doorwayright" );
thread regroup_dialog_uav_street();
wait 2;
level.price dialogue_queue( "intro_pri_downthestreet" );
level.price dialogue_queue( "intro_pri_getsoapout" );
flag_wait( "regroup_mg_dialog" );
if( !flag( "regroup_mg_gunner_dead" ) )
level.price dialogue_queue( "intro_pri_machinegunner" );
flag_wait( "regroup_roll_up_dialog" );
flag_wait( "regroup_player_moving_down_alleyway" );
level.price dialogue_queue( "intro_pri_chopperthisway" );
}
regroup_dialog_uav_street()
{
flag_wait( "regroup_uav_street_start" );
wait .5;
level.price dialogue_queue( "intro_pri_dronepass" );
}
regroup_dialog_weapons_ahead()
{
flag_wait( "regroup_player_approaching_maars_building" );
level.Nikolai dialogue_queue( "intro_nik_directlyahead" );
flag_wait( "regroup_ending_ugv_dialog_start" );
level.Price dialogue_queue( "intro_pri_toomanyofthem" );
level.Price dialogue_queue( "intro_pri_needthatugv" );
level.Nikolai dialogue_queue( "intro_nik_gothrough" );
flag_set( "regroup_ending_ugv_dialog_end" );
level.Price dialogue_queue( "intro_pri_yurithisway" );
thread regroup_dialog_get_to_shed_nag();
flag_wait( "regroup_ending_shotgun_breach_dialog" );
radio_dialogue( "intro_loy2_breaching" );
flag_wait( "regroup_ending_dialog_get_inside" );
}
regroup_dialog_get_to_shed_nag()
{
count = 0;
while( !flag( "regroup_ending_breaching" ) )
{
if( count % 2 )
{
level.Price dialogue_queue( "intro_pri_ugvthisway" );
}
else
{
level.Price dialogue_queue( "intro_pri_overhere" );
}
count++;
wait 5;
}
}
maars_shed_dialog()
{
thread maars_shed_dialog_start();
}
maars_shed_dialog_start()
{
flag_wait( "maars_shed_price_at_door" );
level.price dialogue_queue( "intro_pri_holdup" );
flag_wait( "maars_control_reinforcements" );
wait 2;
flag_wait( "maars_control_start_intro" );
level.price dialogue_queue( "intro_pri_getinside" );
level.Nikolai dialogue_queue( "intro_nik_shippingcrate" );
wait( 10 );
level.price dialogue_queue( "intro_pri_iseeit" );
flag_wait( "maars_control_dialog_ugv_intro" );
}
maars_control_dialog()
{
thread maars_control_dialog_start();
thread maars_control_dialog_moving();
thread maars_control_use_grenades();
thread maars_control_shoot_helicopters();
}
maars_control_dialog_start()
{
flag_wait( "player_to_maars_control" );
level.price dialogue_queue( "intro_pri_controlsrussian" );
thread maars_control_start_controlling_nag();
flag_wait( "maars_control_player_controlling_maars" );
level.price dialogue_queue( "intro_pri_soapscondition" );
level.nikolai dialogue_queue( "intro_nik_gethimout" );
level.price dialogue_queue( "intro_pri_wellbebehind" );
wait 5;
radio_dialogue( "intro_pri_punchwalls" );
}
maars_control_start_controlling_nag()
{
wait( 6 );
while( !flag( "maars_control_player_controlling_maars" ) )
{
level.price dialogue_queue( "intro_pri_grabcontrols" );
wait( 6 );
}
}
maars_control_use_grenades()
{
flag_wait( "maars_control_spawn1_retreat" );
radio_dialogue( "intro_pri_uselauncher" );
}
maars_control_shoot_helicopters()
{
flag_wait( "maars_control_mi17_1" );
radio_dialogue( "intro_pri_takeoutchoppers" );
}
maars_control_dialog_smoke()
{
flag_wait( "maars_control_smoke_hint" );
radio_dialogue( "intro_pri_switchthermal" );
thread maars_control_dialog_thermal_nag();
}
maars_control_dialog_thermal_nag()
{
wait( 2 );
if( !flag( "maars_thermal_on" ) )
{
radio_dialogue( "intro_pri_usethermal" );
}
}
maars_control_dialog_moving()
{
flag_wait( "maars_control_dialog_clear_path" );
radio_dialogue( "intro_pri_clearthepath" );
flag_wait( "maars_control_price_moving_up" );
radio_dialogue( "intro_pri_weremovingup" );
flag_wait( "maars_control_dialog_keep_pushing" );
radio_dialogue( "intro_pri_keeppushing" );
flag_wait( "maars_control_uav_start_dialog" );
wait 1;
radio_dialogue( "intro_pri_atthechopper" );
radio_dialogue( "intro_nik_notlookinggood" );
flag_set( "maars_control_drone_inbound" );
wait .5;
radio_dialogue( "intro_pri_droneinbound" );
flag_set( "maars_control_uav_start" );
}
building_slide_dialog()
{
radio_dialogue( "intro_pri_runtochopper" );
wait( 2 );
radio_dialogue( "intro_pri_gogo" );
flag_wait( "building_event_start" );
radio_dialogue( "intro_pri_lookout2" );
}
river_ride_dialog1( guy )
{
radio_dialogue( "intro_nik_thereheis" );
flag_set( "building_slide_pickup" );
radio_dialogue( "intro_pri_aftermakarov" );
radio_dialogue( "intro_mct_whosyuri" );
}
river_ride_dialog2( guy )
{
}
river_ride_dialog3( guy )
{
}
river_ride_dialog4( guy )
{
}
river_ride_dialog5( guy )
{
}
