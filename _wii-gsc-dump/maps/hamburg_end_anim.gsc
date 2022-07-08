#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
main()
{
models();
vehicles();
props();
generic_human();
}
#using_animtree( "generic_human" );
generic_human()
{
level.scr_sound[ "mortar" ][ "concrete" ] = "mortar_explosion_dirt";
level.scr_sound[ "sandman" ][ "hamburg_snd_frost" ] = "hamburg_snd_frost";
level.scr_radio[ "tank_rh1_22comein" ] = "tank_rh1_22comein";
level.scr_sound[ "sandman" ][ "hamburg_snd_guysok" ] = "hamburg_snd_guysok";
level.scr_sound[ "generic" ][ "hamburg_rhg_weregood" ] = "hamburg_rhg_weregood";
level.scr_sound[ "sandman" ][ "hamburg_snd_canyoushoot" ] = "hamburg_snd_canyoushoot";
level.scr_sound[ "generic" ][ "hamburg_rhg_holdmyown" ] = "hamburg_rhg_holdmyown";
level.scr_sound[ "sandman" ][ "hamburg_snd_basics" ] = "hamburg_snd_basics";
level.scr_sound[ "sandman" ][ "hamburg_snd_movefast" ] = "hamburg_snd_movefast";
level.scr_radio[ "tank_hqr_spottedtheconvoy" ] = "tank_hqr_spottedtheconvoy";
level.scr_sound[ "sandman" ][ "hamburg_snd_onourway" ] = "hamburg_snd_onourway";
level.scr_sound[ "generic" ][ "hamburg_rhg_tank" ] = "hamburg_rhg_tank";
level.scr_sound[ "sandman" ][ "hamburg_snd_takecover" ] = "hamburg_snd_takecover";
level.scr_sound[ "generic" ][ "hamburg_rhg_whereareyou" ] = "hamburg_rhg_whereareyou";
level.scr_radio[ "tank_rh1_threatneutralized" ] = "tank_rh1_threatneutralized";
level.scr_sound[ "generic" ][ "hamburg_rhg_incoming" ] = "hamburg_rhg_incoming";
level.scr_sound[ "sandman" ][ "hamburg_snd_getinside" ] = "hamburg_snd_getinside";
level.scr_radio[ "tank_f16_engagingtargets" ] = "tank_f16_engagingtargets";
level.scr_sound[ "sandman" ][ "hamburg_snd_rooftopsclear" ] = "hamburg_snd_rooftopsclear";
level.scr_sound[ "sandman" ][ "hamburg_snd_convoyatend" ] = "hamburg_snd_convoyatend";
level.scr_sound[ "rogers" ][ "hamburg_rhg_rpgs" ] = "hamburg_rhg_rpgs";
level.scr_radio[ "tank_hqr_reached" ] = "tank_hqr_reached";
level.scr_sound[ "sandman" ][ "hamburg_snd_affirmitive" ] = "hamburg_snd_affirmitive";
level.scr_sound[ "sandman" ][ "hamburg_snd_watchleft" ] = "hamburg_snd_watchleft";
level.scr_sound[ "rogers" ][ "hamburg_rhg_wereclear" ] = "hamburg_rhg_wereclear";
level.scr_sound[ "sandman" ][ "hamburg_snd_checkvehicles" ] = "hamburg_snd_checkvehicles";
level.scr_sound[ "rogers" ][ "hamburg_rhg_nothinhere" ] = "hamburg_rhg_nothinhere";
level.scr_sound[ "sandman" ][ "hamburg_snd_nothere" ] = "hamburg_snd_nothere";
level.scr_sound[ "sandman" ][ "hamburg_snd_negativecargo" ] = "hamburg_snd_negativecargo";
level.scr_radio[ "tank_hqr_anysign" ] = "tank_hqr_anysign";
level.scr_sound[ "sandman" ][ "hamburg_snd_copyyourlast" ] = "hamburg_snd_copyyourlast";
level.scr_sound[ "rogers" ][ "hamburg_rhg_lotofblood" ] = "hamburg_rhg_lotofblood";
level.scr_sound[ "rogers" ][ "hamburg_rhg_goinup" ] = "hamburg_rhg_goinup";
level.scr_sound[ "sandman" ][ "hamburg_snd_easy" ] = "hamburg_snd_easy";
level.scr_sound[ "rogers" ][ "hamburg_rhg_contact" ] = "hamburg_rhg_contact";
level.scr_sound[ "generic" ][ "hamburg_rhg_contact" ] = "hamburg_rhg_contact";
level.scr_sound[ "sandman" ][ "hamburg_snd_movenow" ] = "hamburg_snd_movenow";
level.scr_sound[ "sandman" ][ "hamburg_snd_getacharge" ] = "hamburg_snd_getacharge";
level.scr_sound[ "sandman" ][ "hamburg_snd_breachandclear" ] = "hamburg_snd_breachandclear";
level.scr_sound[ "sandman" ][ "hamburg_snd_damndoor" ] = "hamburg_snd_damndoor";
level.scr_sound[ "sandman" ][ "hamburg_snd_lookatme" ] = "hamburg_snd_lookatme";
level.scr_sound[ "sandman" ][ "hamburg_snd_itshim" ] = "hamburg_snd_itshim";
level.scr_sound[ "sandman" ][ "hamburg_snd_vicepres" ] = "hamburg_snd_vicepres";
level.scr_radio[ "tank_hqr_onscene" ] = "tank_hqr_onscene";
level.scr_sound[ "sandman" ][ "hamburg_snd_lzneptune" ] = "hamburg_snd_lzneptune";
level.scr_radio[ "hamburg_rno_firstround" ] = "hamburg_rno_firstround";
level.scr_anim[ "sandman" ][ "doorkick_2_stand" ] = %doorkick_2_stand;
level.scr_anim[ "generic" ][ "doorkick_2_stand" ] = %doorkick_2_stand;
level.scr_anim[ "sandman" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_sandman;
level.scr_anim[ "body1" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_body;
level.scr_anim[ "rogers" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_rogers;
level.scr_anim[ "body2" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_body;
level.scr_anim[ "leftside" ][ "hvt_search_scene_left" ] = %hamburg_convoy_search_left_side_ally;
level.scr_anim[ "rightside" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_right_side_ally;
level.scr_anim[ "body3" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_right_side_casualty;
level.scr_anim[ "generic" ][ "hamburg_convoy_search_curb_casualty" ] = %hamburg_convoy_search_curb_casualty;
level.scr_anim[ "generic" ][ "hamburg_convoy_search_front_gaz_russian_casualty" ] = %hamburg_convoy_search_front_gaz_russian_casualty;
level.scr_anim[ "generic" ][ "hamburg_convoy_search_rear_gaz_russian_casualty" ] = %hamburg_convoy_search_rear_gaz_russian_casualty;
level.scr_anim[ "generic" ][ "hamburg_convoy_search_suv1_casualty" ] = %hamburg_convoy_search_suv1_casualty;
level.scr_anim[ "generic" ][ "hamburg_convoy_search_briefcase_casualty" ] = %hamburg_convoy_search_briefcase_casualty;
level.scr_anim[ "generic" ][ "patrol_bored_react_walkstop" ] = %patrol_bored_react_walkstop;
level.scr_anim[ "generic" ][ "breach_react_blowback_v1" ] = %breach_react_blowback_v1;
level.scr_anim[ "generic" ][ "exposed_idle_reactA" ] = %exposed_idle_reactA;
level.scr_anim[ "generic" ][ "hostage_stand_react_front" ] = %hostage_stand_react_front;
level.scr_anim[ "generic" ][ "death_explosion_stand_B_v3" ] = %death_explosion_stand_B_v3;
level.scr_anim[ "generic" ][ "execution_knife_soldier" ] = %execution_knife_soldier;
level.scr_anim[ "generic" ][ "execution_knife_hostage" ] = %execution_knife_hostage;
level.scr_anim[ "generic" ][ "execution_knife_hostage_death" ] = %execution_knife_hostage_death;
level.scr_anim[ "generic" ][ "execution_knife_hostage_idle" ][ 0 ] = %hostage_knees_idle;
level.scr_anim[ "generic" ][ "execution_knife_hostage_manhandled" ] = %takedown_room2B_hostageA;
level.scr_anim[ "generic" ][ "execution_knife_hostage_manhandled_idle" ][ 0 ] = %takedown_room2B_hostageA_idle;
level.scr_anim[ "generic" ][ "melee_B_attack" ] = %melee_B_attack;
level.scr_anim[ "generic" ][ "melee_B_attack_death" ] = %death_shotgun_back_v1;
level.scr_anim[ "generic" ][ "execution_onknees_soldier" ] = %execution_onknees_soldier;
level.scr_anim[ "generic" ][ "execution_onknees_hostage" ] = %execution_onknees_hostage;
level.scr_anim[ "generic" ][ "execution_onknees_hostage_idle" ][ 0 ] = %execution_onknees_hostage_survives;
level.scr_anim[ "generic" ][ "execution_onknees_hostage_death" ] = %execution_onknees_hostage_death;
level.scr_anim[ "generic" ][ "execution_onknees_hostage_manhandled_guarded" ] = %takedown_room1A_hostageB;
level.scr_anim[ "generic" ][ "execution_onknees_hostage_manhandled_guarded_idle" ][ 0 ] = %takedown_room1A_hostageB_idle;
level.scr_anim[ "sandman" ][ "traverse_jumpdown_130" ]	=%traverse_jumpdown_130;
level.scr_anim[ "generic" ][ "dead_hvt5" ] = %hamburg_null_breach_hvt_5;
level.scr_animtree[ "breach_door_model" ] = #animtree;
level.scr_model[ "breach_door_model	" ] = "com_door_03_handleright";
level.scr_anim[ "generic" ][ "secure_hvi" ] = %hamburg_secure_hvi_vp;
level.scr_anim[ "sandman" ][ "secure_hvi" ] = %hamburg_secure_hvi_sandman;
}
#using_animtree( "script_model" );
models()
{
}
#using_animtree( "vehicles" );
vehicles()
{
level.scr_animtree["generic"] = #animtree;
level.scr_anim[ "generic" ][ "streets_bust_out_garage" ] = %hamburg_tank_entrance_tank;
level.scr_animtree["suv1"] = #animtree;
level.scr_anim[ "suv1" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_suv;
level.scr_animtree["suv2"] = #animtree;
level.scr_anim[ "suv2" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_suv;
level.scr_animtree["suv3"] = #animtree;
level.scr_anim[ "suv3" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_suv3;
level.scr_animtree["suv1b"] = #animtree;
level.scr_anim[ "suv1b" ][ "hvt_search_scene_sand" ] = %hamburg_convoy_search_suv1_suv;
level.scr_animtree["suv2b"] = #animtree;
level.scr_anim[ "suv2b" ][ "hvt_search_scene_rogers" ] = %hamburg_convoy_search_suv2_suv;
level.scr_animtree["suv3b"] = #animtree;
level.scr_anim[ "suv3b" ][ "hvt_search_scene_right" ] = %hamburg_convoy_search_suv3;
level.scr_animtree["gaz1"] = #animtree;
level.scr_anim[ "gaz1" ][ "hvt_search_scene_gaz" ] = %hamburg_convoy_search_gaz1;
level.scr_animtree["gaz2"] = #animtree;
level.scr_anim[ "gaz2" ][ "hvt_search_scene_gaz" ] = %hamburg_convoy_search_gaz2;
level.scr_animtree["gaz3"] = #animtree;
level.scr_anim[ "gaz3" ][ "hvt_search_scene_gaz" ] = %hamburg_convoy_search_gaz3;
addNotetrack_startFXonTag("suv2", "window_start", "hvt_search_scene_rogers", "glass_scrape_runner","tag_fx_glass_front_base" );
addNotetrack_stopFXonTag("suv2", "window_end", "hvt_search_scene_rogers", "glass_scrape_runner","tag_fx_glass_front_base" );
}
#using_animtree( "animated_props" );
props()
{
level.scr_animtree["streets_entrance"] = #animtree;
level.scr_anim[ "streets_entrance" ][ "streets_bust_out_garage" ] = %hamburg_tank_entrance_garage;
level.scr_animtree["construction_lamp"] = #animtree;
level.scr_anim["construction_lamp"]["wind_medium"][0] = %payback_const_hanging_light;
level.scr_animtree["suv_spin_wheel_joint"] = #animtree;
level.scr_model[ "suv_spin_wheel_joint" ]	= "generic_prop_raven";
level.scr_anim[ "suv_spin_wheel_joint" ][ "hamburg_suburban_wheel" ][0] = %hamburg_suburban_wheel;
level.scr_animtree["suv_spin_wheel"] = #animtree;
level.scr_model[ "suv_spin_wheel" ]	= "suburban_destroyed_wheel";
level.scr_animtree["hamburg_briefcase"] =#animtree;
level.scr_anim[ "hamburg_briefcase" ][ "scn_hamburg_briefcase" ] = %hamburg_convoy_search_briefcase;
}

