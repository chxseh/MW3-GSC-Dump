#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
main()
{
player_animations();
npc_animations();
drone_deaths();
drone_anim();
drone_doors();
script_models();
animated_props();
vehicles();
destructibles();
door_setup();
level.gunless_anims =
[ "bunker_toss_idle_guy1" ,
"prague_woundwalk_wounded",
"prague_civ_door_peek",
"prague_civ_door_runin",
"prague_resistance_hit_idle",
"DC_Burning_bunker_stumble",
"dc_burning_bunker_stumble",
"civilian_crawl_1",
"civilian_crawl_2",
"dying_crawl",
"DC_Burning_artillery_reaction_v1_idle",
"DC_Burning_artillery_reaction_v2_idle",
"DC_Burning_artillery_reaction_v3_idle",
"DC_Burning_artillery_reaction_v4_idle",
"DC_Burning_bunker_sit_idle",
"civilain_crouch_hide_idle",
"civilain_crouch_hide_idle_loop",
"DC_Burning_stop_bleeding_wounded_endidle",
"DC_Burning_stop_bleeding_medic_endidle",
"DC_Burning_stop_bleeding_wounded_idle",
"prague_woundwalk_wounded_idle",
"prague_bully_civ_survive_idle",
"training_basketball_rest",
"prague_mourner_man_idle",
"training_locals_kneel",
"doorpeek_deathA",
"pistol_death_3",
"drone_stand_death",
"death_run_onfront",
"ny_manhattan_wounded_drag_wounded" ];
}
#using_animtree( "player" );
player_animations()
{
level.scr_animtree[ "player_rig" ] = #animtree;
level.scr_model[ "player_rig" ] = "viewhands_player_yuri";
level.scr_animtree[ "player_legs" ] = #animtree;
level.scr_model[ "player_legs" ] = "viewlegs_generic";
level.scr_anim[ "player_rig" ]["intro_opening_shot01"] = %intro_opening_shot01_player;
level.scr_anim[ "player_rig" ]["intro_opening_shot02"] = %intro_opening_shot02_player;
level.scr_anim[ "player_rig" ]["intro_opening_shot03"] = %intro_opening_shot03_player;
level.scr_anim[ "player_rig" ]["intro_opening_shot04"] = %intro_opening_shot04_player;
level.scr_anim[ "player_rig" ]["intro_opening_shot05"] = %intro_opening_shot05_player;
level.scr_anim[ "player_rig" ]["intro_opening_shot06"] = %intro_opening_shot06_player;
level.scr_anim[ "player_rig" ]["intro_opening_shot07"] = %intro_opening_shot07_player;
level.scr_anim[ "player_rig" ]["intro_opening_shot08"] = %intro_opening_shot08_player;
addnotetrack_customfunction( "player_rig", "fade_white", maps\intro_code::intro_flash_to_white_crash, "intro_opening_shot07" );
addnotetrack_customfunction( "player_rig", "slowmo_start", ::start_intro_shot7_slowmo, "intro_opening_shot07" );
addnotetrack_customfunction( "player_rig", "start_heli_dust", ::start_heli_dust, "intro_opening_shot07" );
addnotetrack_customfunction( "player_rig", "slowmo_end", ::end_intro_shot8_slowmo, "intro_opening_shot08" );
addnotetrack_customfunction( "player_rig", "chopper_crash", maps\intro_code::intro_room_heli_crash_as_yuri, "intro_opening_shot07" );
level.scr_anim[ "player_rig" ][ "escort_help_soap" ] = %intro_docdown_needle_player;
level.scr_anim[ "player_rig" ][ "escort_help_soap_breach" ] = %intro_docdown_breach_player;
level.scr_anim[ "player_rig" ][ "roof_collapse_slide" ] = %intro_rooftop_collapse_player;
level.scr_anim[ "player_rig" ][ "river_ride" ] = %intro_river_ride_player;
level.scr_anim[ "player_legs" ][ "roof_collapse_slide" ] = %intro_rooftop_collapse_player_legs;
level.scr_anim[ "player_rig" ][ "roof_collapse_slide_loop" ] = %intro_rooftop_collapse_loop_player;
level.scr_anim[ "player_legs" ][ "roof_collapse_slide_loop" ] = %intro_rooftop_collapse_loop_player_legs;
addnotetrack_customfunction( "player_rig", "slomo_start", ::start_slowmo, "roof_collapse_slide" );
addnotetrack_customfunction( "player_rig", "slowmo_end", ::end_slowmo, "roof_collapse_slide" );
addnotetrack_customfunction( "player_legs", "boot_scrape_dust", maps\intro_fx::slide_player_dust, "roof_collapse_slide" );
addnotetrack_customfunction( "player_rig", "water_impact", maps\intro_fx::water_impact, "roof_collapse_slide" );
addnotetrack_customfunction( "player_rig", "slowmo_end", maps\intro_fx::slide_player_dust_hands, "roof_collapse_slide" );
addnotetrack_customfunction( "player_rig", "water_emerge_1", maps\intro_fx::water_emerge, "river_ride" );
addnotetrack_customfunction( "player_rig", "water_submerge_1", maps\intro_fx::water_submerge, "river_ride" );
addnotetrack_customfunction( "player_rig", "stop_bubbles", maps\intro_fx::stop_bubbles, "river_ride" );
addnotetrack_customfunction( "player_rig", "water_emerge_2", maps\intro_fx::water_emerge2, "river_ride" );
addnotetrack_customfunction( "player_rig", "exit_river_water", maps\intro_fx::exit_river_water, "river_ride" );
addnotetrack_customfunction( "player_rig", "hand_surface_splash", maps\intro_fx::hand_surface_splash, "river_ride" );
addnotetrack_customfunction( "player_rig", "dialog_1", maps\intro_vo::river_ride_dialog1, "river_ride" );
addnotetrack_customfunction( "player_rig", "dialog_2", maps\intro_vo::river_ride_dialog2, "river_ride" );
addnotetrack_customfunction( "player_rig", "dialog_3", maps\intro_vo::river_ride_dialog3, "river_ride" );
addnotetrack_customfunction( "player_rig", "dialog_4", maps\intro_vo::river_ride_dialog4, "river_ride" );
addnotetrack_customfunction( "player_rig", "dialog_5", maps\intro_vo::river_ride_dialog5, "river_ride" );
}
#using_animtree( "script_model" );
script_models()
{
level.scr_animtree[ "gurney" ] = #animtree;
level.scr_anim[ "gurney" ][ "intro_opening_shot01" ] = %intro_opening_shot01_gurney;
level.scr_anim[ "gurney" ][ "intro_opening_shot07" ] = %intro_opening_shot07_gurney;
level.scr_anim[ "gurney" ][ "intro_opening_shot08" ] = %intro_opening_shot08_gurney;
level.scr_anim[ "gurney" ][ "intro_work_on_soap" ][0] = %intro_docdown_gurney;
level.scr_model[ "gurney" ] = "intro_props_gurney";
level.scr_anim[ "surgery_cart" ][ "intro_opening_shot08" ] = %intro_opening_shot08_cart;
level.scr_animtree[ "surgery_cart" ] = #animtree;
level.scr_model[ "surgery_cart" ] = "intro_props_surgery_cart";
level.scr_anim[ "forceps" ][ "intro_opening_shot07" ] = %intro_opening_shot07_forceps;
level.scr_anim[ "forceps" ][ "intro_opening_shot08" ] = %intro_opening_shot08_forceps;
level.scr_anim[ "forceps" ][ "escort_doctor_dies" ] = %intro_docdown_docdie_forceps;
level.scr_anim[ "forceps" ][ "intro_work_on_soap" ][0] = %intro_docdown_forceps;
level.scr_animtree[ "forceps" ] = #animtree;
level.scr_model[ "forceps" ] = "intro_forceps";
level.scr_anim[ "gauze" ][ "intro_opening_shot07" ] = %intro_opening_shot07_gauze;
level.scr_anim[ "gauze" ][ "intro_opening_shot08" ] = %intro_opening_shot08_gauze;
level.scr_anim[ "gauze" ][ "escort_doctor_dies" ] = %intro_docdown_docdie_gauze;
level.scr_anim[ "gauze" ][ "intro_work_on_soap" ][0] = %intro_docdown_gauze;
level.scr_animtree[ "gauze" ] = #animtree;
level.scr_model[ "gauze" ] = "intro_gauze";
level.scr_animtree["helicrash_wallshards"] = #animtree;
level.scr_anim[ "helicrash_wallshards" ][ "wallshards" ] = %intro_helicrash_wallshards;
level.scr_animtree[ "intro_ceiling_woodbeam_01" ] = #animtree;
level.scr_model[ "intro_ceiling_woodbeam_01" ] = "intro_ceiling_woodbeam_01";
level.scr_anim[ "intro_ceiling_woodbeam_01" ][ "intro_opening_shot08" ] = %intro_opening_shot08_debris_beam;
level.scr_animtree[ "intro_ceiling_damage_med_01" ] = #animtree;
level.scr_model[ "intro_ceiling_damage_med_01" ] = "intro_ceiling_damage_med_01";
level.scr_anim[ "intro_ceiling_damage_med_01" ][ "intro_opening_shot08" ] = %intro_opening_shot08_debris_rubble;
level.scr_anim[ "breach_door_model" ][ "breach" ] = %breach_player_door_hinge_v1;
level.scr_animtree[ "breach_door_model" ] = #animtree;
level.scr_model[ "breach_door_model" ] = "intro_door_piece_hinge5";
level.scr_anim[ "cover_object" ][ "cover_object_pull_down" ] = %intro_npc_move_object_cover_object;
level.scr_animtree[ "cover_object" ] = #animtree;
level.scr_model[ "cover_object" ] = "intro_pillar_cover01";
addnotetrack_customfunction( "cover_object", "brick_impact", maps\intro_fx::courtyard_brick_impacts, "cover_object_pull_down" );
level.scr_anim[ "gate" ][ "price_to_nikolai" ] = %intro_price_reload_door;
level.scr_animtree[ "gate" ] = #animtree;
level.scr_model[ "gate" ] = "intro_props_front_gate";
level.scr_anim[ "rope" ][ "escort_rappel" ] = %intro_rope_rappel;
level.scr_animtree[ "rope" ] = #animtree;
level.scr_model[ "rope" ] = "weapon_rappel_rope_long";
level.scr_anim[ "syringe" ][ "escort_help_soap" ] = %intro_docdown_needle_injector;
level.scr_anim[ "syringe" ][ "escort_help_soap_breach" ] = %intro_docdown_breach_injector;
level.scr_animtree[ "syringe" ] = #animtree;
level.scr_model[ "syringe" ] = "weapon_syringe";
level.scr_anim[ "flashlight" ][ "intro_weapon_cache_start" ] = %intro_weapon_cache_flashlight_start;
level.scr_anim[ "flashlight" ][ "intro_weapon_cache_stairs_idle" ][ 0 ] = %intro_weapon_cache_flashlight_price_idle;
level.scr_anim[ "flashlight" ][ "intro_weapon_cache_idle" ][ 0 ] = %intro_weapon_cache_flashlight_idle;
level.scr_anim[ "flashlight" ][ "intro_weapon_cache_pullout" ] = %intro_weapon_cache_flashlight_price_end;
level.scr_anim[ "flashlight" ][ "intro_weapon_cache_end" ] = %intro_weapon_cache_flashlight_end ;
level.scr_animtree[ "flashlight" ] = #animtree;
level.scr_model[ "flashlight" ] = "com_flashlight_on";
level.scr_anim[ "crate_door" ][ "intro_weapon_cache_pullout" ] = %intro_weapon_cache_crate_door;
level.scr_animtree[ "crate_door" ] = #animtree;
level.scr_model[ "crate_door" ] = "intro_crate_sidewall01";
level.scr_anim[ "ugv_model" ][ "intro_weapon_cache_pullout" ] = %intro_weapon_cache_ugv_pullout;
level.scr_animtree[ "ugv_model" ] = #animtree;
level.scr_model[ "ugv_model" ] = "vehicle_ugv_robot";
level.scr_anim[ "rolling_door" ][ "intro_weapon_cache_end" ] = %intro_weapon_cache_rollingdoor;
level.scr_animtree[ "rolling_door" ] = #animtree;
level.scr_model[ "rolling_door" ] = "intro_rollingdoor_01";
addnotetrack_customfunction( "rolling_door", "rolling_door_open", maps\intro_fx::maars_rolling_door_openfx, "intro_weapon_cache_end" );
level.scr_anim[ "trap_door" ][ "intro_weapon_cache_start" ] = %intro_weapon_cache_trapdoor;
level.scr_animtree[ "trap_door" ] = #animtree;
level.scr_model[ "trap_door" ] = "intro_trapdoor_01";
addnotetrack_customfunction( "trap_door", "intro_trap_door_open", maps\intro_fx::maars_trap_door_openfx, "intro_weapon_cache_start" );
addnotetrack_customfunction( "trap_door", "intro_trap_door_impact", maps\intro_fx::maars_trap_door_impactfx, "intro_weapon_cache_start" );
level.scr_anim[ "crowbar" ][ "intro_weapon_cache_pullout" ] = %intro_weapon_cache_crowbar;
level.scr_animtree[ "crowbar" ] = #animtree;
level.scr_model[ "crowbar" ] = "paris_crowbar_01";
level.scr_animtree[ "animated_tree" ] = #animtree;
level.scr_anim[ "animated_tree" ][ "tree_fall"] = %intro_tree_fall;
level.scr_model[ "animated_tree" ] = "foliage_intro_tree_01_destroyed_stream";
level.scr_animtree[ "landslide_building_roof" ] = #animtree;
level.scr_anim[ "landslide_building_roof" ][ "intro_rooftop_collapse_sim_roof" ] = %intro_rooftop_collapse_sim_roof;
level.scr_animtree[ "landslide_building_roof2" ] = #animtree;
level.scr_anim[ "landslide_building_roof2" ][ "intro_rooftop_collapse_sim_roof2" ] = %intro_rooftop_collapse_sim_roof2;
level.scr_animtree[ "landslide_building_subfloor" ] = #animtree;
level.scr_anim[ "landslide_building_subfloor" ][ "intro_rooftop_collapse_sim_subfloor"] = %intro_rooftop_collapse_sim_subfloor;
level.scr_animtree[ "landslide_building_handkey" ] = #animtree;
level.scr_anim[ "landslide_building_handkey" ][ "intro_rooftop_collapse_handkey"] = %intro_rooftop_collapse_handkey;
level.scr_animtree[ "landslide_building_small_01" ] = #animtree;
level.scr_anim[ "landslide_building_small_01" ][ "intro_landslide_small"] = %intro_rooftop_collapse_small_building;
level.scr_anim[ "landslide_building_small_01" ][ "river_ride"] = %intro_river_ride_small_building;
level.scr_animtree[ "landslide_building_small_02" ] = #animtree;
level.scr_anim[ "landslide_building_small_02" ][ "intro_landslide_small"] = %intro_rooftop_collapse_small_building;
level.scr_animtree[ "intro_landslide_building_replaceshards" ] = #animtree;
level.scr_anim[ "intro_landslide_building_replaceshards" ][ "intro_rooftop_collapse_replaceshards"] = %intro_rooftop_collapse_replaceshards;
level.scr_animtree[ "landslide_building_water_heater" ] = #animtree;
level.scr_anim[ "landslide_building_water_heater" ][ "roof_collapse_slide"] = %intro_rooftop_collapse_heater;
level.scr_anim[ "landslide_building_water_heater" ][ "river_ride"] = %intro_river_ride_heater;
level.scr_model[ "landslide_building_water_heater" ] = "com_water_heater_nopipes_rigged";
}
#using_animtree( "door" );
door_setup()
{
level.scr_anim[ "door" ][ "door_breach" ] = %shotgunbreach_door_immediate;
level.scr_animtree[ "door" ] = #animtree;
level.scr_model[ "door" ] = "com_door_01_handleleft2";
precachemodel( level.scr_model[ "door" ] );
}
#using_animtree( "animated_props" );
animated_props()
{
}
#using_animtree( "generic_human" );
npc_animations()
{
level.scr_anim[ "nikolai" ][ "intro_opening_shot01" ] = %intro_opening_shot01_nikolai;
level.scr_anim[ "price" ][ "intro_opening_shot01" ] = %intro_opening_shot01_price;
level.scr_anim[ "player_body" ][ "intro_opening_shot01" ] = %intro_opening_shot01_playerbody;
level.scr_anim[ "player_body" ][ "intro_opening_shot02" ] = %intro_opening_shot02_playerbody;
level.scr_anim[ "player_body" ][ "intro_opening_shot03" ] = %intro_opening_shot03_playerbody;
level.scr_anim[ "player_body" ][ "intro_opening_shot04" ] = %intro_opening_shot04_playerbody;
level.scr_anim[ "player_body" ][ "intro_opening_shot05" ] = %intro_opening_shot05_playerbody;
level.scr_model[ "player_body" ] = "body_hero_soap_wounded";
level.scr_animtree[ "player_body" ] = #animtree;
level.scr_anim[ "nikolai" ][ "intro_opening_shot02" ] = %intro_opening_shot02_nikolai;
level.scr_anim[ "price" ][ "intro_opening_shot02" ] = %intro_opening_shot02_price;
level.scr_anim[ "bystander1" ][ "intro_opening_shot02" ] = %intro_opening_shot02_bystander_1;
level.scr_anim[ "bystander2" ][ "intro_opening_shot02" ] = %intro_opening_shot02_bystander_2;
level.scr_anim[ "bystander3" ][ "intro_opening_shot02" ] = %intro_opening_shot02_bystander_3;
level.scr_anim[ "nikolai" ][ "intro_opening_shot03" ] = %intro_opening_shot03_nikolai;
level.scr_anim[ "price" ][ "intro_opening_shot03" ] = %intro_opening_shot03_price;
level.scr_anim[ "bystander1" ][ "intro_opening_shot03" ] = %intro_opening_shot03_bystander_1;
level.scr_anim[ "bystander2" ][ "intro_opening_shot03" ] = %intro_opening_shot03_bystander_2;
level.scr_anim[ "bystander3" ][ "intro_opening_shot03" ] = %intro_opening_shot03_bystander_3;
level.scr_anim[ "bystander4" ][ "intro_opening_shot03" ] = %intro_opening_shot03_bystander_4;
level.scr_anim[ "bystander5" ][ "intro_opening_shot03" ] = %intro_opening_shot03_bystander_5;
level.scr_anim[ "nikolai" ][ "intro_opening_shot04" ] = %intro_opening_shot04_nikolai;
level.scr_face[ "nikolai" ][ "intro_opening_shot04_face" ] = %intro_opening_shot04_nikolai_face;
level.scr_anim[ "price" ][ "intro_opening_shot04" ] = %intro_opening_shot04_price;
level.scr_anim[ "bystander1" ][ "intro_opening_shot04" ] = %intro_opening_shot04_bystander_1;
level.scr_anim[ "bystander2" ][ "intro_opening_shot04" ] = %intro_opening_shot04_bystander_2;
level.scr_anim[ "bystander3" ][ "intro_opening_shot04" ] = %intro_opening_shot04_bystander_3;
level.scr_anim[ "bystander4" ][ "intro_opening_shot04" ] = %intro_opening_shot04_bystander_4;
level.scr_anim[ "bystander5" ][ "intro_opening_shot04" ] = %intro_opening_shot04_bystander_5;
level.scr_anim[ "bystander6" ][ "intro_opening_shot04" ] = %intro_opening_shot04_bystander_6;
level.scr_anim[ "bystander7" ][ "intro_opening_shot04" ] = %intro_opening_shot04_bystander_7;
level.scr_anim[ "nikolai" ][ "intro_opening_shot05" ] = %intro_opening_shot05_nikolai;
level.scr_anim[ "price" ][ "intro_opening_shot05" ] = %intro_opening_shot05_price;
level.scr_anim[ "doctor" ][ "intro_opening_shot05" ] = %intro_opening_shot05_doc;
level.scr_anim[ "nikolai" ][ "intro_opening_shot06" ] = %intro_opening_shot06_nikolai;
level.scr_anim[ "price" ][ "intro_opening_shot06" ] = %intro_opening_shot06_price;
level.scr_anim[ "doctor" ][ "intro_opening_shot06" ] = %intro_opening_shot06_doc;
level.scr_anim[ "yuri" ][ "intro_opening_shot06" ] = %intro_opening_shot06_yuri;
level.scr_anim[ "nikolai" ][ "intro_opening_shot07" ] = %intro_opening_shot07_nikolai;
level.scr_face[ "nikolai" ][ "intro_opening_shot07_face" ] = %intro_opening_shot07_nikolai_face;
level.scr_anim[ "price" ][ "intro_opening_shot07" ] = %intro_opening_shot07_price;
level.scr_anim[ "doctor" ][ "intro_opening_shot07" ] = %intro_opening_shot07_doc;
level.scr_anim[ "soap" ][ "intro_opening_shot07" ] = %intro_opening_shot07_soap;
addnotetrack_customfunction( "soap", "fx_blood_cough", ::fx_blood_cough, "intro_opening_shot07" );
level.scr_anim[ "nikolai" ][ "intro_opening_shot08" ] = %intro_opening_shot08_nikolai;
level.scr_face[ "nikolai" ][ "intro_opening_shot08_face" ] = %intro_opening_shot08_nikolai_face;
level.scr_anim[ "price" ][ "intro_opening_shot08" ] = %intro_opening_shot08_price;
level.scr_anim[ "doctor" ][ "intro_opening_shot08" ] = %intro_opening_shot08_doc;
level.scr_anim[ "soap" ][ "intro_opening_shot08" ] = %intro_opening_shot08_soap;
level.scr_anim[ "doctor" ][ "intro_work_on_soap" ][0] = %intro_docdown_idle1_doc;
level.scr_anim[ "nikolai" ][ "intro_work_on_soap" ][0] = %intro_docdown_idle1_nikolai;
level.scr_anim[ "soap" ][ "intro_work_on_soap" ][0] = %intro_docdown_idle1_soap;
level.scr_anim[ "breacher1" ][ "courtyard_breach" ] = %intro_courtyard_breach_guy1;
level.scr_anim[ "breacher2" ][ "courtyard_breach" ] = %intro_courtyard_breach_guy2;
level.scr_anim[ "breacher3" ][ "courtyard_breach" ] = %intro_courtyard_breach_guy3;
level.scr_anim[ "breacher4" ][ "courtyard_breach" ] = %intro_courtyard_breach_guy4;
level.scr_anim[ "breacher5" ][ "courtyard_breach" ] = %intro_courtyard_breach_guy5;
level.scr_anim[ "breacher6" ][ "courtyard_breach" ] = %intro_courtyard_breach_guy6;
level.scr_anim[ "generic" ][ "coverstand_hide_idle_wave02" ] = %coverstand_hide_idle_wave02;
level.scr_anim[ "object_puller1" ][ "cover_object_pull_down" ] = %intro_npc_move_object_for_cover_2;
level.scr_anim[ "object_puller2" ][ "cover_object_pull_down" ] = %intro_npc_move_object_for_cover_3;
level.scr_anim[ "doctor" ][ "escort_doctor_dies" ] = %intro_docdown_docdie_doc;
level.scr_anim[ "nikolai" ][ "escort_doctor_dies" ] = %intro_docdown_docdie_nikolai;
level.scr_anim[ "soap" ][ "escort_doctor_dies" ] = %intro_docdown_docdie_soap;
level.scr_anim[ "price" ][ "exposed_grenadeThrowB" ] = %exposed_grenadeThrowB;
level.scr_anim[ "nikolai" ][ "escort_wait_for_player_idle" ][0] = %intro_docdown_idle2_nikolai;
level.scr_anim[ "soap" ][ "escort_wait_for_player_idle" ][0] = %intro_docdown_idle2_soap;
level.scr_anim[ "nikolai" ][ "escort_help_soap" ] = %intro_docdown_needle_nikolai;
level.scr_anim[ "soap" ][ "escort_help_soap" ] = %intro_docdown_needle_soap;
level.scr_anim[ "price" ][ "escort_help_soap" ] = %intro_docdown_needle_price;
level.scr_anim[ "soap" ][ "soap_lie_down_idle" ][0] = %intro_docdown_idle3_soap;
addnotetrack_customfunction( "soap", "fx_soap_stop_bleeding", ::fx_soap_stop_bleeding, "escort_help_soap" );
level.scr_anim[ "nikolai" ][ "escort_help_soap_breach" ] = %intro_docdown_breach_nikolai;
level.scr_anim[ "price" ][ "escort_help_soap_breach" ] = %intro_docdown_breach_price;
level.scr_anim[ "soap" ][ "escort_help_soap_breach" ] = %intro_docdown_breach_soap;
level.scr_anim[ "breacher1" ][ "escort_help_soap_breach" ] = %intro_docdown_breach_npc1;
level.scr_anim[ "breacher2" ][ "escort_help_soap_breach" ] = %intro_docdown_breach_npc2;
addnotetrack_customfunction( "breacher1", "door_breach", ::breach_hotel_door, "escort_help_soap_breach" );
addnotetrack_customfunction( "breacher1", "dropgun", ::drop_weapon, "escort_help_soap_breach" );
addnotetrack_customfunction( "breacher1", "die", ::kill_me, "escort_help_soap_breach" );
addnotetrack_customfunction( "price", "chest_2_hand", ::equip_main_weapon, "escort_help_soap_breach" );
addnotetrack_customfunction( "price", "fx_pistolfire", maps\intro_fx::price_pistolfire, "escort_help_soap_breach" );
level.scr_anim[ "generic" ][ "escort_rappel" ] = %intro_npc_rappel;
level.scr_anim[ "price" ][ "door_kick_in" ] = %doorkick_2_cqbrun;
level.scr_anim[ "nikolai" ][ "pickup_soap" ] = %intro_docdown_exit_nikolai;
level.scr_anim[ "soap" ][ "pickup_soap" ] = %intro_docdown_exit_soap;
level.scr_anim[ "nikolai" ][ "putdown_soap_init" ] = %intro_fireman_carry_drop_guy_carrier_init;
level.scr_anim[ "soap" ][ "putdown_soap_init" ] = %intro_fireman_carry_drop_guy_carried_init;
level.scr_anim[ "price" ][ "price_to_nikolai_transition" ] = %intro_radio_price_to_idle;
level.scr_anim[ "price" ][ "price_to_nikolai" ] = %intro_radio_price_reload;
level.scr_face[ "price" ][ "price_to_nikolai_face" ] = %intro_radio_price_reload_face;
level.scr_anim[ "price" ][ "price_break_and_rake" ] = %intro_price_break_and_rake_entrance;
level.scr_anim[ "generic" ][ "coverstand_hide_idle_wave01" ] = %coverstand_hide_idle_wave01;
level.scr_anim["generic"]["intro_wounded_drag_carrier"] = %intro_wounded_drag_carrier;
level.scr_anim["generic"]["intro_wounded_drag_wounded"] = %intro_wounded_drag_wounded;
level.scr_anim["generic"]["intro_wounded_drag_carrier_idle"][0] = %intro_wounded_help_carrier;
level.scr_anim["generic"]["intro_wounded_drag_wounded_idle"][0] = %intro_wounded_help_wounded;
level.scr_anim["generic"]["regroup_wounded_civ_1"][0] = %arcadia_ending_sceneA_dead_civilian;
level.scr_anim["generic"]["regroup_wounded_civ_2"] = %civilian_crawl_2;
level.scr_anim["generic"]["regroup_wounded_civ_2_death"] = %civilian_crawl_2_death_A;
level.scr_anim[ "generic" ][ "fire_rocket" ] = %contengency_rocket_moment;
level.scr_anim[ "guy1" ][ "car_cover_start" ] = %intro_move_from_cover_start_guy1;
level.scr_anim[ "guy2" ][ "car_cover_start" ] = %intro_move_from_cover_start_guy2;
level.scr_anim[ "generic" ][ "car_cover_idle1" ][0] = %intro_move_from_cover_idle_guy1;
level.scr_anim[ "generic" ][ "car_cover_idle2" ][0] = %intro_move_from_cover_idle_guy2;
level.scr_anim[ "guy1" ][ "car_cover_end" ] = %intro_move_from_cover_end_guy1;
level.scr_anim[ "guy2" ][ "car_cover_end" ] = %intro_move_from_cover_end_guy2;
level.scr_anim[ "generic" ][ "car_door_cover" ] = %intro_npc_use_car_door_cover_entrance;
level.scr_anim[ "left_guy" ][ "breach_kick_stackL1_idle" ][ 0 ]	= %breach_kick_stackL1_idle;
level.scr_anim[ "left_guy" ][ "breach_kick" ] = %breach_kick_stackL1_enter;
level.scr_anim[ "right_guy" ][ "breach_kick" ] = %breach_kick_kickerR1_enter;
level.scr_anim[ "right_guy" ][ "door_breach_setup" ] = %intro_breach_shotgun_hinge_v1;
level.scr_anim[ "right_guy" ][ "door_breach_setup_idle" ][ 0 ] = %shotgunbreach_v1_shoot_hinge_idle;
level.scr_anim[ "right_guy" ][ "door_breach_idle" ][ 0 ] = %intro_breach_shotgun_hinge_ready_idle_v1;
level.scr_anim[ "right_guy" ][ "door_breach" ] = %intro_breach_shotgun_hinge_runin_v1;
level.scr_anim[ "left_guy" ][ "door_breach_setup" ] = %intro_breach_stackb_v1;
level.scr_anim[ "left_guy" ][ "door_breach_setup_idle" ][ 0 ]	= %shotgunbreach_v1_stackB_idle;
level.scr_anim[ "left_guy" ][ "door_breach_idle" ][ 0 ] = %shotgunbreach_v1_stackB_ready_idle;
level.scr_anim[ "left_guy" ][ "door_breach" ] = %intro_breach_stackb_runin_v1;
level.scr_anim[ "yuri" ][ "control_ugv" ][0] = %intro_weapon_cach_yuri_idle;
level.scr_anim[ "price" ][ "intro_weapon_cache_upto_shed" ] = %intro_price_upto_shed;
level.scr_anim[ "price" ][ "intro_weapon_cache_upto_shed_idle" ][0]	= %intro_price_upto_shed_idle;
level.scr_anim[ "price" ][ "intro_weapon_cache_start" ] = %intro_weapon_cache_price_start;
level.scr_anim[ "price" ][ "intro_weapon_cache_stairs_idle" ][0]	= %intro_weapon_cache_price_stairs_idle;
level.scr_anim[ "price" ][ "intro_weapon_cache_pullout" ] = %intro_weapon_cache_price_pullout;
level.scr_face[ "price" ][ "intro_weapon_cache_pullout_face" ] = %intro_weapon_cache_price_pullout_face;
level.scr_anim[ "price" ][ "intro_weapon_cache_idle" ][0] = %intro_weapon_cache_price_signal_idle;
level.scr_anim[ "price" ][ "intro_weapon_cache_end" ] = %intro_weapon_cache_price_end;
level.scr_anim[ "price" ][ "intro_weapon_cache_end_idle" ][0] = %intro_weapon_cache_price_end_idle;
addnotetrack_customfunction( "price", "light_on", ::maars_control_flashlight_on, "intro_weapon_cache_start" );
addnotetrack_customfunction( "price", "light_off", ::maars_control_flashlight_off, "intro_weapon_cache_end" );
level.scr_anim[ "soap" ][ "intro_ugv_helicopter" ] = %intro_helicopter_guy1;
level.scr_anim[ "nikolai" ][ "intro_ugv_helicopter" ] = %intro_helicopter_guy2;
level.scr_anim[ "price" ][ "intro_ugv_helicopter" ] = %intro_helicopter_guy3;
level.scr_anim[ "soap" ][ "intro_ugv_helicopter_idle" ][0] = %intro_helicopter_idle_guy1;
level.scr_anim[ "nikolai" ][ "intro_ugv_helicopter_idle" ][0] = %intro_helicopter_idle_guy2;
level.scr_anim[ "price" ][ "intro_ugv_helicopter_idle" ][0] = %intro_helicopter_idle_guy3;
level.scr_anim[ "soap" ][ "river_ride" ] = %intro_river_ride_soap;
level.scr_anim[ "nikolai" ][ "river_ride" ] = %intro_river_ride_nikolai;
level.scr_anim[ "price" ][ "river_ride" ] = %intro_river_ride_price;
}
#using_animtree( "generic_human" );
drone_anim()
{
level.scr_anim[ "generic" ][ "bunker_toss_idle_guy1" ][ 0 ] = %bunker_toss_idle_guy1;
level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v3_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v3_idle;
level.scr_anim[ "generic" ][ "DC_Burning_bunker_sit_idle" ][ 0 ] = %DC_Burning_bunker_sit_idle;
level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle" ][ 0 ] = %civilain_crouch_hide_idle;
level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle_loop" ][ 0 ] = %civilain_crouch_hide_idle_loop;
level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_endidle" ][ 0 ] = %DC_Burning_stop_bleeding_wounded_endidle;
level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_medic_endidle" ][ 0 ] = %DC_Burning_stop_bleeding_medic_endidle;
level.scr_anim[ "generic" ][ "DC_Burning_stop_bleeding_wounded_idle" ][ 0 ] = %DC_Burning_stop_bleeding_wounded_idle;
level.scr_anim[ "generic" ][ "death_explosion_run_R_v1" ] = %death_explosion_run_R_v1;
level.scr_anim[ "generic" ][ "death_explosion_stand_F_v4" ] = %death_explosion_stand_F_v4;
level.scr_anim[ "generic" ][ "stand_death_tumbleback" ] = %stand_death_tumbleback;
level.scr_anim[ "generic" ][ "prague_resistance_hit" ] = %prague_resistance_hit;
level.scr_anim[ "generic" ][ "prague_resistance_hit_idle" ][ 0 ] = %prague_resistance_hit_idle;
level.scr_anim[ "generic" ][ "prague_woundwalk_wounded" ] = %prague_woundwalk_wounded;
level.scr_anim[ "generic" ][ "prague_woundwalk_helper" ] = %prague_woundwalk_helper;
level.scr_anim[ "generic" ][ "prague_woundwalk_wounded_idle" ][ 0 ] = %prague_woundidle_wounded;
level.scr_anim[ "generic" ][ "prague_woundwalk_helper_idle" ][ 0 ] = %prague_woundidle_helper;
level.scr_anim[ "generic" ][ "prague_civ_door_peek" ] = %prague_civ_door_peek;
level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ] = %airport_civ_dying_groupB_pull;
level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded" ] = %airport_civ_dying_groupB_wounded;
level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull_death" ] = %airport_civ_dying_groupB_pull_death;
level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded_death" ] = %airport_civ_dying_groupB_wounded_death;
level.scr_anim["generic"]["civilian_crawl_2"] = %civilian_crawl_2;
level.scr_anim["generic"]["civilian_crawl_2_death"] = %civilian_crawl_2_death_A;
level.civ_runs = [];
level.civ_runs[ level.civ_runs.size ] = %civilian_run_hunched_C_relative;
level.civ_runs[ level.civ_runs.size ] = %civilian_run_hunched_A_relative;
level.civ_runs[ level.civ_runs.size ] = %unarmed_scared_run;
level.civ_runs[ level.civ_runs.size ] = %civilian_run_upright_relative;
level.civ_runs[ level.civ_runs.size ] = %ny_harbor_running_coughing_guy1_relative;
level.civ_runs[ level.civ_runs.size ] = %afchase_shepherd_flee_loop_relative;
level.civ_runs[ level.civ_runs.size ] = %prague_bully_civ_run_relative;
level.scr_anim["generic"]["unarmed_cowercrouch_react_A"] = %unarmed_cowercrouch_react_A;
level.scr_anim["generic"]["unarmed_cowercrouch_react_A_idle"][0] = %unarmed_cowerstand_pointidle;
level.scr_anim["generic"]["unarmed_cowercrouch_idle_duck"] = %unarmed_cowercrouch_idle_duck;
level.scr_anim["generic"]["unarmed_cowercrouch_idle_duck_idle"][0] = %unarmed_cowercrouch_idle;
level.scr_anim["generic"]["intro_docdown_idle1_soap"][0] = %intro_docdown_idle1_soap;
level.scr_anim["generic"]["unarmed_close_garage"] = %intro_garage_door_closing;
}
drone_deaths()
{
level.drone_deaths = [];
level.drone_deaths[ level.drone_deaths.size ] = %stand_death_tumbleback;
level.drone_deaths[ level.drone_deaths.size ] = %run_death_fallonback;
level.drone_deaths[ level.drone_deaths.size ] = %run_death_roll;
level.drone_deaths[ level.drone_deaths.size ] = %exposed_death_blowback;
level.drone_deaths[ level.drone_deaths.size ] = %exposed_death_firing_02;
level.drone_deaths_f = [];
level.drone_deaths_f[ level.drone_deaths_f.size ] = %death_run_forward_crumple;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_skid;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll_02;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll_03;
level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_legshot;
level.scr_anim[ "generic" ][ "civilian_leaning_death_shot" ] = %civilian_leaning_death_shot;
level.scr_anim[ "generic" ][ "CornerCrL_death_side" ] = %CornerCrL_death_side;
level.scr_anim[ "generic" ][ "pistol_death_3" ] = %pistol_death_3;
level.scr_anim[ "generic" ][ "drone_stand_death" ] = %drone_stand_death;
level.scr_anim[ "generic" ][ "death_run_onfront" ] = %death_run_onfront;
level.scr_anim[ "generic" ][ "doorpeek_deathA" ] = %doorpeek_deathA;
level.scr_anim[ "generic" ][ "death_run_onfront" ] = %death_run_onfront;
level.scr_anim[ "generic" ][ "arcadia_ending_sceneA_dead_civilian" ][0] = %arcadia_ending_sceneA_dead_civilian;
level.scr_anim[ "generic" ][ "prague_mourner_woman_idle" ][0] = %prague_mourner_woman_idle;
level.scr_anim[ "generic" ][ "prague_mourner_man_idle" ][0] = %prague_mourner_man_idle;
}
#using_animtree( "script_model" );
drone_doors()
{
level.scr_animtree[ "door_peek" ] = #animtree;
level.scr_anim[ "door_peek" ][ "prague_civ_door_peek_door" ] = %prague_civ_door_peek_door;
}
#using_animtree( "vehicles" );
vehicles()
{
level.scr_anim[ "littlebird" ][ "intro_opening_shot01" ] = %intro_opening_shot01_littlebird;
level.scr_anim[ "littlebird" ][ "river_ride" ] = %intro_river_ride_littlebird;
level.scr_animtree[ "littlebird" ] = #animtree;
level.scr_model[ "littlebird" ] = "vehicle_mh_6_little_bird";
level.scr_anim[ "mi28" ][ "intro_opening_shot06" ] = %intro_opening_shot06_mi28;
level.scr_anim[ "mi28" ][ "intro_opening_shot07" ] = %intro_opening_shot07_mi28;
level.scr_anim[ "mi28" ][ "intro_opening_shot08" ] = %intro_opening_shot08_mi28_destroyed;
addnotetrack_customfunction( "mi28", "fx_heli_hit_ground", ::fx_heli_hit_ground, "intro_opening_shot08" );
level.scr_animtree[ "mi28" ] = #animtree;
level.scr_model[ "mi28" ] = "vehicle_mi_28_destroyed";
level.scr_anim[ "cover_car" ][ "car_door_cover" ] = %intro_npc_use_car_door_cover_car;
level.scr_animtree[ "cover_car" ] = #animtree;
level.scr_model[ "cover_car" ] = "vehicle_80s_hatch1_brn_destructible_mp";
level.scr_anim[ "uav" ][ "roof_collapse_slide" ] = %intro_rooftop_collapse_uav;
level.scr_anim[ "uav" ][ "ugv_death" ] = %ugv_robot_uav_death;
level.scr_anim[ "uav" ][ "price_to_nikolai" ] = %intro_price_reload_uav;
level.scr_animtree[ "uav" ] = #animtree;
level.scr_model[ "uav" ] = "russian_dozor_600";
level.scr_anim[ "ugv" ][ "ugv_death" ] = %ugv_robot_death;
level.scr_anim[ "ugv" ][ "ugv_death_pos" ] = %ugv_robot_death_pos;
level.scr_animtree[ "ugv" ] = #animtree;
level.scr_model[ "ugv" ] = "vehicle_ugv_robot_viewmodel";
level.scr_anim[ "ugv_turret" ][ "ugv_death" ] = %ugv_robot_turret_death;
level.scr_anim[ "ugv_turret" ][ "ugv_death_pos" ] = %ugv_robot_turret_death_pos;
level.scr_anim[ "ugv_turret" ][ "ugv_fire_grenade" ] = %ugv_robot_grenade_launcher_fire;
level.scr_animtree[ "ugv_turret" ] = #animtree;
level.scr_model[ "ugv_turret" ] = "ugv_robot_gun";
level.scr_anim[ "ugv_grenade_launcher" ][ "ugv_death" ] = %ugv_robot_grenade_launcher_death;
level.scr_animtree[ "ugv_grenade_launcher" ] = #animtree;
level.scr_model[ "ugv_grenade_launcher" ] = "ugv_robot_grenade_launcher";
level.scr_anim[ "destructible_car" ][ "price_break_and_rake" ] = %intro_price_break_and_rake_car;
level.scr_animtree[ "destructible_car" ] = #animtree;
level.scr_model[ "destructible_car" ] = "vehicle_80s_hatch1_brn_destructible_mp";
}
#using_animtree( "destructibles" );
destructibles()
{
}
fake_notetrack_events( guys, anim_scene )
{
}
maars_control_flashlight_on( guy )
{
PlayFxOnTag(getfx("flashlight"), level.flashlight, "TAG_LIGHT");
}
maars_control_flashlight_off( guy )
{
if ( IsDefined( level.flashlight ) )
{
StopFxOnTag( getfx("flashlight"), level.flashlight, "TAG_LIGHT" );
}
}
breach_hotel_door( ent )
{
breach_door = GetEnt( "escort_hotel_door", "targetname" );
breach_door RotateTo( breach_door.angles + ( 0, 160, 0 ), .5, 0, 0 );
breach_door ConnectPaths();
flag_set( "escort_hotel_door_open" );
}
drop_weapon( ent )
{
ent.dropWeapon = true;
ent animscripts\shared::DropAIWeapon();
}
kill_me( ent )
{
ent maps\intro_utility::kill_no_react();
}
equip_main_weapon( ent )
{
ent animscripts\shared::PlaceWeaponOn( ent.weapon, "right" );
}
start_heli_dust(guy)
{
exploder(24);
wait 0.5;
pauseExploder("intro_godray");
}
fx_blood_cough(guy)
{
playfxontag(getfx("blood_cough"), guy, "J_Jaw");
}
start_slowmo( ent )
{
slomoLerpTime_in = 0.3;
slowmo_start();
slowmo_setspeed_slow( 0.3 );
slowmo_setlerptime_in( slomoLerpTime_in );
slowmo_lerp_in();
}
end_slowmo( ent )
{
slomoLerpTime_out = 0.5;
slowmo_setlerptime_out( slomoLerpTime_out );
slowmo_lerp_out();
slowmo_end();
}
start_building_slowmo( ent )
{
slomoLerpTime_in = 0.5;
slowmo_start();
slowmo_setspeed_slow( 0.8 );
slowmo_setlerptime_in( slomoLerpTime_in );
slowmo_lerp_in();
}
end_building_slowmo( ent )
{
slomoLerpTime_out = 0.8;
slowmo_setlerptime_out( slomoLerpTime_out );
slowmo_lerp_out();
slowmo_end();
}
start_intro_shot1_slowmo( ent )
{
slomoLerpTime_in = 0.5;
slowmo_start();
slowmo_setspeed_slow( .85 );
slowmo_setlerptime_in( slomoLerpTime_in );
slowmo_lerp_in();
}
end_intro_shot1_slowmo( ent )
{
slomoLerpTime_out = 2;
slowmo_setlerptime_out( slomoLerpTime_out );
slowmo_lerp_out();
slowmo_end();
}
start_intro_shot6_slowmo( ent )
{
slomoLerpTime_in = 0.5;
slowmo_start();
slowmo_setspeed_slow( 0.8 );
slowmo_setlerptime_in( slomoLerpTime_in );
slowmo_lerp_in();
}
end_intro_shot6_slowmo( ent )
{
slomoLerpTime_out = 0.8;
slowmo_setlerptime_out( slomoLerpTime_out );
slowmo_lerp_out();
slowmo_end();
}
start_intro_shot7_slowmo( ent )
{
slomoLerpTime_in = .7;
slowmo_start();
slowmo_setspeed_slow( 0.3 );
slowmo_setlerptime_in( slomoLerpTime_in );
slowmo_lerp_in();
}
end_intro_shot8_slowmo( ent )
{
slomoLerpTime_out = 2;
slowmo_setlerptime_out( slomoLerpTime_out );
slowmo_lerp_out();
slowmo_end();
}
break_glass( ent )
{
ent.glass_damage_state[3].v[ "currentState" ] = 2;
ent maps\intro_utility::update_glass( ent, 3, true );
}
fx_heli_hit_ground(guy)
{
exploder(23);
}
fx_soap_stop_bleeding(guy)
{
level notify("msg_soap_stop_bleeding");
}
