#include common_scripts\utility;
#include maps\_utility;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_anim;
#include maps\_vehicle;
main()
{
thread precacheFX();
maps\createfx\paris_b_fx::main();
maps\_shg_fx::setup_shg_fx();
flag_init( "game_fx_started" );
flag_init("flag_catacombs_enemy_gate_gag_vfx");
flag_init("player_rooftop_jump_complete");
flag_init("msg_fx_staircase_helis");
flag_init("msg_fx_chase_start_helis");
flag_init("msg_fx_canal_helis");
flag_init("msg_fx_hood_impacts");
flag_init("flag_player_in_truck");
flag_init("msg_fx_landing_hit");
flag_init("msg_fx_umbrella1");
flag_init("msg_fx_umbrella2");
flag_init("msg_fx_umbrella3");
flag_init("flag_final_crash_wall_impact_1");
flag_init("enable_distant_bomb_shakes");
flag_init("flag_slide_sparks_end");
flag_init("msg_fx_end_drag_glass");
flag_init("msg_fx_sedan_sparks_left_start");
flag_init("msg_fx_sedan_sparks_left_stop");
flag_init("msg_fx_sedan_sparks_right_start");
flag_init("msg_fx_sedan_sparks_right_stop");
thread fx_zone_watcher(5900,"msg_fx_zone5900");
thread fx_zone_watcher(6000,"msg_fx_zone6000");
thread fx_zone_watcher(6100,"msg_fx_zone6100");
thread fx_zone_watcher(6200,"msg_fx_zone6200");
thread fx_zone_watcher(6300,"msg_fx_zone6300");
thread fx_zone_watcher(6400,"msg_fx_zone6400");
thread fx_zone_watcher(6500,"msg_fx_zone6500");
thread fx_zone_watcher(7000,"msg_fx_zone7000");
thread fx_zone_watcher(8000,"msg_fx_zone8000");
thread fx_zone_watcher(8100,"msg_fx_zone8100");
thread fx_zone_watcher(8200,"msg_fx_zone8200");
thread fx_zone_watcher(8300,"msg_fx_zone8300");
thread fx_zone_watcher(8400,"msg_fx_zone8400");
thread fx_zone_watcher(8500,"msg_fx_zone8500");
thread fx_zone_watcher(8600,"msg_fx_zone8600");
thread fx_zone_watcher(8700,"msg_fx_zone8700");
thread fx_zone_watcher(9000,"msg_fx_zone9000");
thread fx_trigger_manual_bombshake();
thread setup_poison_wake_volumes();
thread catacombs_enemy_gate_gag_vfx();
thread loop_chase_start_hind();
thread start_ambient_flak();
thread fx_van_hit_fences();
thread fx_van_galleria_physics_wake();
thread fx_umbrella_spin("umbrella1");
thread fx_umbrella_spin("umbrella3");
thread treadfx_override();
thread play_first_bombshake();
thread dynamic_lights_all_models();
thread fx_fruit_cart_destroyables();
thread init_smVals();
thread fx_turn_off_bombshakes();
thread fx_hide_skidmarks();
thread fx_sedan_escape_sparks_left();
thread fx_sedan_escape_sparks_right();
thread fx_toggle_dlights();
PreCacheShellShock( "default" );
}
precacheFX()
{
level._effect[ "wall_destruction" ] = loadfx( "explosions/transformer_explosion" );
level._effect[ "large_column" ] = loadfx( "props/dcburning_pillars" );
level._effect[ "glass_shatter_large" ] = loadfx( "misc/glass_falling_shatter" );
level._effect[ "firelp_small_pm" ] = LoadFX( "fire/firelp_small_pm" );
level._effect[ "firelp_med_pm" ] = LoadFX( "fire/firelp_med_pm" );
level._effect[ "heli_strafe_impact" ] = LoadFX( "impacts/large_ac130_concrete_paris" );
level._effect[ "flashlight_ai" ] = loadfx( "misc/flashlight_lensflare" );
level._effect["flashlight"] = loadfx( "misc/flashlight_lensflare" );
level._effect["falling_dirt_catacomb"] = loadfx ("dust/falling_dirt_light");
level._effect["pipe_steam"] = loadfx ("impacts/pipe_steam_small");
level._effect["pipe_steam_looping_small"] = loadfx ("impacts/pipe_steam_looping_small");
level._effect["falling_dirt_dark_2_paris"] = loadfx ("dust/falling_dirt_dark_2_paris");
level._effect["falling_dirt_dark_2_runner_paris"] = loadfx ("dust/falling_dirt_dark_2_runner_paris");
level._effect["falling_dirt_light_2_runner_paris"] = loadfx ("dust/falling_dirt_light_2_runner_paris");
level._effect["elevator_shaft_junk"] = loadfx ("maps/paris/elevator_shaft_junk");
level._effect[ "flare_catacombs" ] = loadfx( "misc/flare_ambient_paris" );
level._effect[ "flare_catacombs_moving" ] = loadfx( "misc/flare_ambient_paris_moving" );
level._effect[ "flare_catacombs_mist" ] = loadfx( "misc/flare_ambient_paris_mist" );
level._effect[ "lights_spotlight_fan_shadow" ] = loadfx( "lights/lights_spotlight_fan_shadow" );
level._effect[ "lights_uplight_haze_large" ] = loadfx( "lights/lights_uplight_haze_large" );
level._effect["lights_conelight_smokey"] = loadfx("lights/lights_conelight_smokey");
level._effect["lights_worklight_flare"] = loadfx("lights/lights_worklight_flare");
level._effect["light_glow_walllight_white"] = loadfx("misc/light_glow_walllight_white");
level._effect["light_glow_walllight_white_flicker"] = loadfx("misc/light_glow_walllight_white_flicker");
level._effect[ "door_kick" ] = loadfx( "dust/door_kick_catacombs" );
level._effect[ "falling_dirt_groundspawn" ] = loadfx( "dust/falling_dirt_groundspawn" );
level._effect[ "ambush_gate_dust" ] = loadfx( "maps/paris/ambush_gate_dust" );
level._effect[ "table_flip_dust" ] = loadfx( "maps/paris/table_flip_dust" );
level._effect[ "large_brick_impact" ] = loadfx( "impacts/expRound_brick" );
level._effect[ "water_noise" ] = loadfx( "weather/water_noise" );
level._effect[ "water_drips_fat_fast_speed" ] = loadfx( "water/water_drips_fat_fast_speed" );
level._effect[ "water_drips_fat_slow_speed" ] = loadfx( "water/water_drips_fat_slow_speed" );
level._effect[ "water_drips_fat_slow_speed_catacombs" ]= loadfx( "water/water_drips_fat_slow_speed_catacombs" );
level._effect[ "drips_fast" ] = loadfx( "misc/drips_fast" );
level._effect[ "drips_slow" ] = loadfx( "misc/drips_slow" );
level._effect[ "drips_splash_tiny" ] = loadfx( "water/drips_splash_tiny" );
level._effect[ "mist_drifting_catacomb" ] = loadfx( "smoke/mist_drifting_catacomb" );
level._effect[ "water_pipe_spray_dark" ] = loadfx( "water/water_pipe_spray_dark" );
level._effect[ "powerline_runner_sewer_paris"] = loadfx ("maps/paris/powerline_runner_sewer_paris");
level._effect[ "water_flow_sewage_catacomb" ] = loadfx( "water/water_flow_sewage_catacomb" );
level._effect[ "waterfall_splash_falling_mist" ] = loadfx( "water/waterfall_splash_falling_mist" );
level._effect[ "waterfall_splash_medium_dark" ] = loadfx( "water/waterfall_splash_medium_dark" );
level._effect[ "waterfall_splash_falling_mist_dark" ] = loadfx( "water/waterfall_splash_falling_mist_dark" );
level._effect[ "ground_dust_narrow_light" ] = loadfx( "dust/ground_dust_narrow_light" );
level._effect[ "ground_mist_narrow_dark" ] = loadfx( "dust/ground_mist_narrow_dark" );
level._effect[ "ground_mist_warm" ] = loadfx( "dust/ground_mist_warm" );
level._effect[ "fog_ground_200_light_lit" ] = loadfx( "smoke/fog_ground_200_light_lit" );
level._effect[ "smoke_warm_room_linger_s" ] = loadfx( "smoke/smoke_warm_room_linger_s" );
level._effect[ "catacombs_mist_wake" ] = loadfx( "smoke/catacombs_mist_wake" );
level._effect[ "amb_dust_small" ] = loadfx( "smoke/amb_dust_small" );
level._effect[ "lighthaze_sewer_ladder_bottom" ] = loadfx( "maps/paris/lighthaze_sewer_ladder_bottom" );
level._effect[ "falling_dirt_light_2_paris" ] = loadfx( "dust/falling_dirt_light_2_paris" );
level._effect["lights_godray_default"] = loadfx("lights/lights_conelight_default");
level._vehicle_effect[ "tankcrush" ][ "window_med" ] = loadfx( "props/car_glass_med" );
level._vehicle_effect[ "tankcrush" ][ "window_large" ] = loadfx( "props/car_glass_large" );
level._effect[ "littlebird_exhaust" ] = loadfx( "distortion/littlebird_exhaust" );
level._effect[ "scripted_flashbang" ] = loadfx( "explosions/flashbang" );
level._effect[ "bmp_flash_wv" ] = loadfx( "muzzleflashes/bmp_flash_wv" );
level._effect[ "tread_dust_paris" ] = loadfx( "treadfx/tread_dust_paris" );
level._effect[ "tread_dust_paris_small" ] = loadfx( "treadfx/tread_dust_paris_small" );
level._effect[ "heli_dust_ambush" ] = loadfx( "treadfx/heli_dust_ambush" );
level._effect[ "heli_water_paris" ] = loadfx( "treadfx/heli_water_paris" );
level._effect[ "no_effect" ] = loadfx( "misc/no_effect" );
level._effect[ "truck_sparks" ] = loadfx( "misc/vehicle_scrape_sparks_smokey" );
level._effect[ "sedan_skidmarks" ] = loadfx( "treadfx/vehicle_skidmarks" );
level._effect[ "dust_wind_fast_paper_oneshot" ] = loadfx( "dust/dust_wind_fast_paper_oneshot" );
level._effect[ "van_hood_impacts" ] = loadfx( "maps/paris/van_hood_impacts" );
level._effect[ "van_dashboard_glass" ] = loadfx( "maps/paris/van_dashboard_glass" );
level._effect[ "van_dashboard_glass_move" ] = loadfx( "maps/paris/van_dashboard_glass_move" );
level._effect[ "van_peelout" ] = loadfx( "maps/paris/van_peelout" );
level._effect[ "van_door_kick" ] = loadfx( "maps/paris/van_door_kick" );
level._effect[ "van_blockade_impact" ] = loadfx( "maps/paris/van_blockade_impact" );
level._effect[ "van_crash_1" ] = loadfx( "maps/paris/van_crash_1" );
level._effect[ "van_final_crash" ] = loadfx( "maps/paris/van_final_crash" );
level._effect[ "van_fence_impact" ] = loadfx( "maps/paris/van_fence_impact" );
level._effect[ "car_decal_spawner" ] = loadfx( "maps/paris/car_decal_spawner" );
level._effect[ "sedan_tire_smoketrail" ] = loadfx( "maps/paris/sedan_tire_smoketrail" );
level._effect[ "van_grill_smoke" ] = loadfx( "maps/paris/van_grill_smoke" );
level._effect[ "abrams_flash_wv_brightlite" ] = loadfx( "muzzleflashes/abrams_flash_wv_brightlite" );
level._effect[ "tankfall_dust_large" ] = loadfx( "impacts/tankfall_dust_large" );
level._effect[ "glass_punch_paris" ] = loadfx( "maps/paris/glass_punch_paris" );
level._effect[ "tank_shell_aftermath_paris" ] = loadfx( "maps/paris/tank_shell_aftermath_paris" );
level._effect[ "tread_burnout_reverse" ] = loadfx( "treadfx/tread_burnout_reverse" );
level._effect[ "window_hit_hood" ] = loadfx( "maps/paris/window_hit_hood" );
level._effect[ "topiary_explosion_crash" ] = loadfx( "maps/paris/topiary_explosion_crash" );
level._effect[ "galleria_gate_open_1" ] = loadfx( "maps/paris/galleria_gate_open_1" );
level._effect[ "phone_kiosk_dest_sparks" ] = loadfx( "props/phone_kiosk_dest_sparks" );
level._effect[ "tankShellImpact" ] = loadfx( "explosions/tankshell_wallImpact" );
level._effect[ "fire_line_sm" ] = loadfx( "fire/fire_line_sm" );
level._effect[ "paris_gallery_metal_gates" ] = loadfx( "props/paris_gallery_metal_gates" );
level._effect[ "tire_blowout_parent" ] = loadfx( "explosions/tire_blowout_parent" );
level._effect[ "fire_falling_localized_runner_paris" ] = loadfx( "fire/fire_falling_localized_runner_paris" );
level._effect[ "blood_gaz_driver" ] = loadfx( "misc/blood_gaz_driver" );
level._effect[ "van_window_broken" ] = loadfx( "props/car_glass_med" );
level._effect[ "sedan_trunk_papers" ] = loadfx( "maps/paris/sedan_trunk_papers" );
level._effect[ "car_glass_large_moving" ] = loadfx( "props/car_glass_large_moving" );
level._effect[ "car_glass_med_moving" ] = loadfx( "props/car_glass_med_moving" );
level._effect[ "car_glass_med" ] = loadfx( "props/car_glass_med" );
level._effect[ "car_glass_sunroof" ] = loadfx( "maps/paris/car_glass_sunroof" );
level._effect[ "sedan_body_impact" ] = loadfx( "maps/paris/sedan_body_impact" );
level._effect[ "sedan_skid_sparks" ] = loadfx( "maps/paris/sedan_skid_sparks" );
level._effect[ "drag_glass_trail" ] = loadfx( "maps/paris/drag_glass_trail" );
level._effect[ "body_drag_trail" ] = loadfx( "maps/paris/body_drag_trail" );
level._effect[ "oil_drip_small_continuous" ] = loadfx( "misc/oil_drip_small_continuous" );
level._effect[ "van_damage_whitesmoke_looping" ] = loadfx( "maps/paris/van_damage_whitesmoke_looping" );
level._effect[ "crash_debris" ] = loadfx( "maps/paris/crash_debris" );
level._effect[ "smoke_after_crash_smoulder" ] = loadfx( "maps/paris/smoke_after_crash_smoulder" );
level._effect[ "highrise_glass_56x59" ] = loadfx( "maps/paris/highrise_glass_56x59_cheap_paris" );
level._effect[ "guard_blood_splat" ] = loadfx( "impacts/flesh_hit_body_fatal_exit" );
level._effect[ "gallery_archway_01_dest" ] = loadfx( "props/gallery_archway_01_dest" );
level._effect[ "paris_glass_panel1" ] = loadfx( "props/paris_glass_panel1" );
level._effect[ "paris_glass_panel2" ] = loadfx( "props/paris_glass_panel2" );
level._effect[ "paris_chandelier_dest" ] = loadfx( "props/paris_chandelier_dest" );
level._effect[ "lights_godray_beam_gallery" ] = loadfx( "maps/paris/lights_godray_beam_gallery" );
level._effect["ambient_explosion"] = loadfx ("maps/paris/ambient_explosion_paris");
level._effect["building_explosion_gulag"] = loadfx ("explosions/building_explosion_gulag");
level._effect["belltower_explosion"] = loadfx ("explosions/building_explosion_gulag");
level._effect[ "smoke_column_skybox_paris" ] = loadfx( "maps/paris/smoke_column_skybox_paris" );
level._effect[ "thick_fakelit_smoke_paris" ] = loadfx( "maps/paris/thick_fakelit_smoke_paris" );
level._effect[ "antiair_runner_cloudy_paris" ] = loadfx( "maps/paris/antiair_runner_cloudy_paris" );
level._effect[ "skybox_hind_flyby" ] = loadfx( "misc/no_effect" );
level._effect[ "leaves_fall_gentlewind_paris" ] = loadfx( "misc/leaves_fall_gentlewind_paris" );
level._effect[ "leaves_heliblown_paris" ] = loadfx( "misc/leaves_heliblown_paris" );
level._effect[ "leaves_runner_1" ] = loadfx( "misc/leaves_runner_1" );
level._effect[ "moth_runner" ] = loadfx( "misc/moth_runner" );
level._effect[ "battlefield_smk_directional_white_m_cheap" ] = loadfx( "smoke/battlefield_smk_directional_white_m_cheap" );
level._effect[ "battlefield_smk_directional_grey_m_cheap" ] = loadfx( "smoke/battlefield_smk_directional_grey_m_cheap" );
level._effect[ "amb_smoke_distant_paris" ] = loadfx( "smoke/amb_smoke_distant_paris" );
level._effect[ "flesh_hit" ] = LoadFX( "impacts/flesh_hit_body_fatal_exit" );
level._effect[ "flesh_hit_small" ] = LoadFX( "impacts/flesh_hit" );
}
init_smVals()
{
setsaveddvar("fx_alphathreshold",10);
}
treadfx_override()
{
wait(0.1);
fx = "treadfx/tread_dust_paris";
no_fx = "misc/no_effect";
vehicletype_fx[0] = "script_vehicle_t72_tank_streamed";
vehicletype_fx[1] = "script_vehicle_gaz_tigr_harbor_streamed";
vehicletype_fx[2] = "script_vehicle_gaz_tigr_turret_physics_harbor_streamed";
vehicletype_fx[3] = "script_vehicle_armored_van_streamed";
vehicletype_fx[4] = "script_vehicle_paris_escape_sedan";
foreach(vehicletype in vehicletype_fx)
{
maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
maps\_treadfx::setvehiclefx( vehicletype, "none" );
}
fx = "treadfx/tread_dust_paris_small";
no_fx = "misc/no_effect";
vehicletype_fx[0] = "script_vehicle_paris_escape_sedan";
foreach(vehicletype in vehicletype_fx)
{
maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
maps\_treadfx::setvehiclefx( vehicletype, "none" );
}
vehicletype = "script_vehicle_mi24p_hind_woodland";
fx = "treadfx/heli_dust_ambush";
water_fx = "treadfx/heli_water_paris";
maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
maps\_treadfx::setvehiclefx( vehicletype, "plaster", no_fx );
maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
maps\_treadfx::setvehiclefx( vehicletype, "water", water_fx );
maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
maps\_treadfx::setvehiclefx( vehicletype, "ceramic", no_fx );
maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
maps\_treadfx::setvehiclefx( vehicletype, "none" );
}
ambient_room_battles()
{
}
play_first_bombshake()
{
wait 6;
flag_waitopen("msg_fx_zone7000");
flag_waitopen("msg_fx_zone8000");
flag_waitopen("msg_fx_zone8100");
flag_waitopen("msg_fx_zone8200");
flag_waitopen("msg_fx_zone8300");
flag_waitopen("msg_fx_zone8400");
flag_waitopen("msg_fx_zone8500");
flag_waitopen("msg_fx_zone8600");
flag_waitopen("msg_fx_zone8700");
flag_waitopen("msg_fx_zone9000");
play_distant_bombshake(level.player);
wait 7;
}
dynamic_lights_all_models()
{
waitframe();
flag_waitopen("msg_fx_zone6500");
flag_waitopen("msg_fx_zone7000");
flag_waitopen("msg_fx_zone8000");
flag_waitopen("msg_fx_zone8100");
flag_waitopen("msg_fx_zone8200");
flag_waitopen("msg_fx_zone8300");
flag_waitopen("msg_fx_zone8400");
flag_waitopen("msg_fx_zone8500");
flag_waitopen("msg_fx_zone8600");
flag_waitopen("msg_fx_zone8700");
flag_waitopen("msg_fx_zone9000");
setsaveddvar("sm_dynlightAllSmodels",1);
flag_wait("msg_fx_zone6500");
setsaveddvar("sm_dynlightAllSmodels",0);
}
play_distant_bombshake(to1, b_forceshake)
{
if(level.createfx_enabled) return 0;
if (!IsDefined (b_forceshake))
b_forceshake = 0;
aud_send_msg("generic_building_bomb_shake");
fx_bombShakes("falling_dirt_dark_2_paris","viewmodel_medium",.127,2,.3,.53, 1, b_forceshake);
}
fx_trigger_manual_bombshake()
{
manual_bombshake_triggers = getentarray( "manual_bombshake", "targetname" );
array_thread (manual_bombshake_triggers, ::fx_manual_bombshake);
}
fx_manual_bombshake()
{
self waittill("trigger", other);
play_distant_bombshake(level.player, 1);
}
fx_turn_off_bombshakes()
{
flag_wait("msg_fx_chase_start_helis");
flag_clear("enable_distant_bomb_shakes");
}
fx_doorkick_dust()
{
wait 6.6;
exploder(6105);
}
catacombs_enemy_gate_gag_vfx()
{
flag_wait("flag_catacombs_enemy_gate_gag_vfx");
wait(0.45);
exploder(6210);
}
setup_poison_wake_volumes()
{
poison_wake_triggers = getentarray( "poison_wake_volume", "targetname" );
array_thread( poison_wake_triggers, ::poison_wake_trigger_think);
}
poison_wake_trigger_think()
{
for( ;; )
{
self waittill( "trigger", other );
if (other ent_flag_exist("in_poison_volume"))
{}
else
other ent_flag_init("in_poison_volume");
if (DistanceSquared( other.origin, level.player.origin ) < 9250000)
{
if (other ent_flag("in_poison_volume"))
{}
else
{
other thread poison_wakefx(self);
other ent_flag_set ("in_poison_volume");
}
}
}
}
poison_wakefx( parentTrigger )
{
self endon( "death" );
speed = 200;
for ( ;; )
{
if (self IsTouching(parentTrigger))
{
if (speed > 0)
wait(max(( 1 - (speed / 120)),0.1) );
else
wait (0.15);
fx = parentTrigger.script_fxid;
if ( IsPlayer( self ) )
{
speed = Distance( self GetVelocity(), ( 0, 0, 0 ) );
if ( speed < 5 )
{
fx = "null";
}
}
if ( IsAI( self ) )
{
speed = Distance( self.velocity, ( 0, 0, 0 ) );
if ( speed < 5 )
{
fx = "null";
}
}
if (fx != "null")
{
start = self.origin + ( 0, 0, 64 );
end = self.origin - ( 0, 0, 150 );
trace = BulletTrace( start, end, false, undefined );
water_fx = getfx( fx );
start = trace[ "position" ];
angles = (0,self.angles[1],0);
forward = anglestoforward( angles );
up = anglestoup( angles );
PlayFX( water_fx, start, up, forward );
}
}
else
{
self ent_flag_clear("in_poison_volume");
return;
}
}
}
loop_chase_start_hind()
{
wait(0.2);
for(;;)
{
flag_wait("msg_fx_chase_start_helis");
wait(18);
exploder(7099);
}
}
start_ambient_flak()
{
wait(0.2);
flag_waitopen("msg_fx_zone6000");
flag_waitopen("msg_fx_zone6100");
flag_waitopen("msg_fx_zone6200");
flag_waitopen("msg_fx_zone6300");
flag_waitopen("msg_fx_zone6400");
flag_waitopen("msg_fx_zone6500");
exploder(10001);
}
fx_fruit_cart_destroyables()
{
}
fx_fruit_cart_watcher()
{
}
fx_car_chase(van)
{
PlayFXOnTag( getfx( "van_dashboard_glass" ), van, "body_animate_jnt" );
flag_wait("msg_fx_hood_impacts");
PlayFXOnTag( getfx( "van_hood_impacts" ), van, "tag_engine_left" );
}
fx_car_peelout(van)
{
stopfxontag( getfx( "van_dashboard_glass" ), van, "body_animate_jnt");
PlayFXOnTag( getfx( "van_dashboard_glass_move" ), van, "body_animate_jnt" );
PlayFXOnTag( getfx( "van_peelout" ), van, "tag_wheel_front_right" );
}
fx_volk_sedan_peelout(car)
{
wait 0.15;
exploder(7001);
wait 0.65;
PlayFXOnTag( getfx( "tread_burnout_reverse" ), car, "tag_wheel_front_right" );
PlayFXOnTag( getfx( "tread_burnout_reverse" ), car, "tag_wheel_front_left" );
}
fx_blockade_impact(van, rate)
{
wait(2.2 / rate);
maps\paris_shared::bomb_truck_hide_windshield();
PlayFXOnTag( getfx( "van_blockade_impact" ), van, "tag_engine_left" );
setblur(2.0, 0.1 / rate);
wait .5;
setblur(0, 0.4 / rate);
PlayFXOnTag( getfx( "van_grill_smoke" ), van, "body_animate_jnt" );
wait 5;
}
fx_toggle_dlights()
{
level waitframe();
if ( !flag_exist( "flag_canal_combat_01" ) )
{
flag_init( "flag_canal_combat_01" );
}
flag_wait("flag_canal_combat_01" );
setsaveddvar("r_dlightlimit",1);
if ( !flag_exist( "flag_chase_canal_uaz_02" ) )
{
flag_init( "flag_chase_canal_uaz_02" );
}
flag_wait("flag_chase_canal_uaz_02" );
setsaveddvar("r_dlightlimit",4);
if ( !flag_exist( "flag_final_crash_begin" ) )
{
flag_init( "flag_final_crash_begin" );
}
flag_wait("flag_final_crash_begin");
setsaveddvar("r_dlightlimit",1);
}
fx_tank_chasefire_1(tank)
{
PlayFXOnTag( getfx( "abrams_flash_wv_brightlite" ), tank, "tag_flash" );
wait 0.06;
Earthquake( 0.5, 2.0, level.player.origin, 1600 );
wait(0.25);
exploder(999);
}
fx_tank_chasefire_2(tank)
{
exploder(8101);
wait(0.25);
if ( ( level.Console && level.ps3 ) || !level.Console )
{
SetHalfResParticles( true );
}
exploder(8102);
wait (0.05);
Earthquake( 0.65, 1.0, level.player.origin, 1600 );
fxOrigin = (-8587, 3573, 330);
RadiusDamage(fxorigin, 128, 301, 301);
setblur(2.0, 0.1);
wait .1;
level.player dirtEffect(fxOrigin);
wait .15;
setblur(0, 0.4);
wait 6;
if ( ( level.Console && level.ps3 ) || !level.Console )
{
SetHalfResParticles( false );
}
}
fx_behindview_impact_planters(shakeAmt)
{
}
fx_behindview_impact_flowers(shakeAmt)
{
}
fx_behindview_impact_diningset(shakeAmt)
{
}
fx_behindview_impact_topiaryright(shakeAmt)
{
}
fx_behindview_impact_topiaryleft(shakeAmt)
{
}
fx_behindview_impact_fenceleft(shakeAmt)
{
}
fx_behindview_impact_fenceright(shakeAmt)
{
}
fx_van_galleria_physics_wake()
{
for(;;)
{
flag_wait("msg_fx_zone8500");
magnitude = 0.06;
vanDirection = vectornormalize(anglestoforward(level.bomb_truck.angles));
physicsOrigin = level.bomb_truck.origin - (vanDirection * 250);
forceDirection = (vanDirection * magnitude) + (0,0,0.075);
PhysicsJolt(physicsOrigin, 90, 75, forceDirection);
wait(0.05);
}
}
fx_umbrella_spin(umbrella)
{
flag_wait("msg_fx_" + umbrella);
umbrellaEnt = getEnt(umbrella, "targetname");
if(isDefined(umbrellaEnt))
{
umbrellaEnt RotateVelocity((0,-180,0), 3, 0, 2.75);
}
}
fx_sedan_damaged(sedan)
{
blowout = spawn_tag_origin();
blowout LinkTo(sedan, "tag_wheel_back_right", (0,0,13), (0,-120,0));
PlayFXOnTag( getfx( "tire_blowout_parent" ), blowout, "tag_origin" );
aud_send_msg("player_shot_sedan_ending", sedan);
sedan ShowPart("wheel_A_KR_D");
sedan HidePart("wheel_A_KR");
while(!flag("flag_final_crash_wall_impact_1"))
{
PlayFXOnTag( getfx( "truck_sparks" ), sedan, "tag_wheel_back_right" );
waitframe();
}
skid_timer = 0;
wheel_back_left = spawn_tag_origin();
wheel_back_left LinkTo(sedan, "tag_wheel_back_left", (0,0,0), (-90,0,0));
wheel_front_left = spawn_tag_origin();
wheel_front_left LinkTo(sedan, "tag_wheel_front_left", (0,0,0), (-90,0,0));
wheel_front_right = spawn_tag_origin();
wheel_front_right LinkTo(sedan, "tag_wheel_front_right", (0,0,0), (-90,0,0));
while (skid_timer < 30)
{
PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_back_left, "tag_origin" );
PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_left, "tag_origin" );
PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_right, "tag_origin" );
wait(0.03);
skid_timer++;
}
wheel_front_left delete();
wheel_back_left delete();
wheel_front_right delete();
}
fx_hide_skidmarks()
{
skidmarks = getentarray("final_crash_skidmarks", "targetname");
foreach (ent in skidmarks)
{
ent hide();
}
}
fx_van_hit_fences()
{
flag_wait("msg_fx_staircase_helis");
wait 0.6;
fx_behindview_impact_fenceleft();
wait 0.15;
fx_behindview_impact_fenceleft();
wait 0.15;
fx_behindview_impact_fenceleft();
wait 0.15;
fx_behindview_impact_fenceleft();
wait 0.15;
fx_behindview_impact_fenceleft();
wait 0.15;
fx_behindview_impact_fenceleft();
}
fx_sedan_escape_sparks_left()
{
wait 1;
flag_wait("msg_fx_sedan_sparks_left_start");
if(!flag("flag_player_shot_sedan_ending"))
{
aud_send_msg("pars_volk_escape_failstate");
wheel_front_right = spawn_tag_origin();
wheel_front_right LinkTo(level.escape_sedan, "tag_wheel_front_right", (0,0,0), (-90,0,0));
while(!flag("msg_fx_sedan_sparks_left_stop"))
{
PlayFXOnTag( getfx( "truck_sparks" ), level.escape_sedan, "tag_door_left_front" );
PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_right, "tag_origin" );
wait(0.03);
}
wheel_front_right delete();
}
}
fx_sedan_escape_sparks_right()
{
wait 1;
flag_wait("msg_fx_sedan_sparks_right_start");
if(!flag("flag_player_shot_sedan_ending"))
{
wheel_back_left = spawn_tag_origin();
wheel_back_left LinkTo(level.escape_sedan_model, "tag_wheel_back_left", (0,0,0), (-90,0,0));
wheel_front_left = spawn_tag_origin();
wheel_front_left LinkTo(level.escape_sedan, "tag_wheel_front_left", (0,0,0), (-90,0,0));
while(!flag("msg_fx_sedan_sparks_right_stop"))
{
PlayFXOnTag( getfx( "truck_sparks" ), level.escape_sedan, "tag_door_right_back" );
PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_back_left, "tag_origin" );
PlayFXOnTag( getfx( "sedan_skidmarks" ), wheel_front_left, "tag_origin" );
wait(0.03);
}
wheel_back_left delete();
wheel_front_left delete();
}
}
