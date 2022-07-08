#include common_scripts\utility;
#include maps\_utility;
main()
{
maps\createfx\london_fx::main();
footstep_fx();
level_fx();
ambient_fx();
}
level_fx()
{
level._effect[ "forklift_blinklight" ] = LoadFX( "misc/light_blink_forklift" );
level._effect[ "forklift_headlight" ] = LoadFX( "misc/car_headlight_forklift" );
level._effect[ "chase_heli_spotlight" ] = LoadFX( "misc/docks_heli_spotlight_model_cheap" );
level._effect[ "chase_heli_spotlight_cheap" ] = LoadFX( "misc/docks_heli_spotlight_model_cheap" );
level._effect[ "docks_heli_spotlight" ] = LoadFX( "misc/docks_heli_spotlight_model_cheap" );
level._effect[ "docks_heli_spotlight_cheap" ] = LoadFX( "misc/docks_heli_spotlight_model_cheap" );
level._effect[ "impact_fx" ] = LoadFX( "impacts/flesh_hit_body_fatal_exit" );
level._effect[ "impact_fx_nonfatal" ] = LoadFX( "impacts/flesh_hit_body_nonfatal" );
level._effect[ "rpg_trail" ] = LoadFX( "smoke/smoke_geotrail_rpg" );
level._effect[ "rpg_muzzle" ] = LoadFX( "muzzleflashes/at4_flash" );
level._effect[ "rpg_explode" ] = LoadFX( "explosions/rpg_wall_impact" );
level._effect[ "interactive_tv_light" ] = LoadFX( "props/interactive_tv_light" );
level._effect[ "clouds_predator" ] = LoadFX( "misc/clouds_predator" );
level._effect[ "silencer_flash" ] = LoadFX( "muzzleflashes/m4m203_silencer" );
level._effect[ "minigun_shells" ] = LoadFX( "shellejects/20mm_cargoship" );
}
ambient_fx()
{
level._effect[ "waterfall_drainage_short_london" ]	= LoadFX( "water/waterfall_drainage_short_london" );
level._effect[ "waterfall_splash_medium_london" ]	= LoadFX( "water/waterfall_splash_medium_london" );
level._effect[ "ride_parallax_debris" ] = LoadFX( "misc/ride_parallax_debris" );
level._effect[ "light_glow_white_london" ] = LoadFX( "misc/light_glow_white_london" );
level._effect[ "mist_drifting" ] = LoadFX( "smoke/mist_drifting" );
level._effect[ "mist_distant_drifting" ] = LoadFX( "smoke/mist_distant_drifting" );
level._effect[ "mist_drifting_groundfog" ] = LoadFX( "smoke/mist_drifting_groundfog" );
level._effect[ "mist_drifting_london_docks" ] = LoadFX( "smoke/mist_drifting_london_docks" );
level._effect[ "ground_fog_london_river" ] = LoadFX( "smoke/ground_fog_london_river" );
level._effect[ "room_smoke_200" ] = LoadFX( "smoke/room_smoke_200" );
level._effect[ "room_smoke_400" ] = LoadFX( "smoke/room_smoke_400" );
level._effect[ "rain_london" ] = LoadFX( "weather/rain_london" );
level._effect[ "rain_london_fill" ] = LoadFX( "weather/rain_london_fill" );
level._effect[ "rain_noise_splashes" ] = LoadFX( "weather/rain_noise_splashes" );
level._effect[ "rain_splash_subtle_64x64" ] = LoadFX( "weather/rain_splash_subtle_64x64" );
level._effect[ "rain_splash_subtle_128x128" ] = LoadFX( "weather/rain_splash_subtle_128x128" );
level._effect[ "rain_splash_lite_64x64" ] = LoadFX( "weather/rain_splash_lite_64x64" );
level._effect[ "rain_splash_lite_128x128" ] = LoadFX( "weather/rain_splash_lite_128x128" );
level._effect[ "lighthaze_london" ] = LoadFX( "misc/lighthaze_london" );
level._effect[ "firelp_med_pm" ] = LoadFX( "fire/firelp_med_pm" );
level._effect[ "firelp_med_pm_cheap" ] = LoadFX( "fire/firelp_med_pm_cheap" );
level._effect[ "firelp_small_pm" ] = LoadFX( "fire/firelp_small_pm" );
level._effect[ "trash_spiral_runner" ] = LoadFX( "misc/trash_spiral_runner" );
level._effect[ "fx_rain_box250x250_london" ] = LoadFX( "weather/fx_rain_box250x250_london" );
level._effect[ "fx_rain_box200x500_london" ] = LoadFX( "weather/fx_rain_box200x500_london" );
level._effect[ "fx_rain_box500x500_london" ] = LoadFX( "weather/fx_rain_box500x500_london" );
level._effect[ "fx_rain_box1000_london" ] = LoadFX( "weather/fx_rain_box1000_london" );
level._effect[ "fx_rain_box2000_london" ] = LoadFX( "weather/fx_rain_box2000_london" );
level._effect[ "steam_vent_large_wind" ] = LoadFX( "smoke/steam_vent_large_wind" );
level._effect[ "fire_tree_london" ] = LoadFX( "fire/fire_tree_london" );
level._effect[ "fire_tree_slow_london" ] = LoadFX( "fire/fire_tree_slow_london" );
level._effect[ "fire_falling_runner_london" ] = LoadFX( "fire/fire_falling_runner_london" );
level._effect[ "fire_tree_distortion_london" ] = LoadFX( "fire/fire_tree_distortion_london" );
level._effect[ "collumn_explosion" ] = LoadFX( "explosions/collumn_explosion" );
level._effect[ "collumn_explosion_dense" ] = LoadFX( "explosions/collumn_explosion_dense" );
level._effect[ "uk_utility_truck_debris" ] = LoadFX( "misc/uk_utility_truck_debris" );
level._effect[ "uk_utility_truck_spew" ] = LoadFX( "misc/uk_utility_truck_spew" );
level._effect[ "truck_explosion_subway" ] = LoadFX( "explosions/truck_explosion_subway" );
level._effect[ "smoke_fill_subway" ] = LoadFX( "smoke/smoke_fill_subway" );
level._effect[ "smoke_fill_linger_subway" ] = LoadFX( "smoke/smoke_fill_linger_subway" );
level._effect[ "smoke_fill_linger_subway_rolling" ] = LoadFX( "smoke/smoke_fill_linger_subway_rolling" );
level._effect[ "smoke_fill_linger_subway_gap" ] = LoadFX( "smoke/smoke_fill_linger_subway_gap" );
level._effect[ "sparks_car_scrape_line" ] = LoadFX( "misc/sparks_car_scrape_line" );
level._effect[ "sparks_car_scrape_point" ] = LoadFX( "misc/sparks_car_scrape_point" );
level._effect[ "debris_subway_fallover" ] = LoadFX( "misc/debris_subway_fallover" );
level._effect[ "debris_subway_fallover_sparky" ] = LoadFX( "misc/debris_subway_fallover_sparky" );
level._effect[ "debris_subway_impact_line" ] = LoadFX( "misc/debris_subway_impact_line" );
level._effect[ "debris_subway_scrape_line" ] = LoadFX( "misc/debris_subway_scrape_line" );
level._effect[ "debris_subway_scrape_line_short" ] = LoadFX( "misc/debris_subway_scrape_line_short" );
level._effect[ "debris_subway_scrape_line_short_heavy" ] = LoadFX( "misc/debris_subway_scrape_line_short_heavy" );
level._effect[ "sparks_subway_scrape_line" ] = LoadFX( "misc/sparks_subway_scrape_line" );
level._effect[ "sparks_subway_scrape_line_short" ] = LoadFX( "misc/sparks_subway_scrape_line_short" );
level._effect[ "sparks_subway_scrape_line_short_diminishing" ]	= LoadFX( "misc/sparks_subway_scrape_line_short_diminishing" );
level._effect[ "sparks_subway_scrape_line_short_heavy" ] = LoadFX( "misc/sparks_subway_scrape_line_short_heavy" );
level._effect[ "sparks_subway_scrape_player" ] = LoadFX( "misc/sparks_subway_scrape_player" );
level._effect[ "sparks_subway_scrape_point" ] = LoadFX( "misc/sparks_subway_scrape_point" );
level._effect[ "sparks_subway_scrape_point_wheels" ] = LoadFX( "misc/sparks_subway_scrape_point_wheels" );
level._effect[ "sparks_truck_scrape_line_short_diminishing" ]	= LoadFX( "misc/sparks_truck_scrape_line_short_diminishing" );
level._effect[ "vehicle_sever_subway" ] = LoadFX( "explosions/vehicle_sever_subway" );
level._effect[ "light_blink_subway" ] = LoadFX( "lights/light_blink_subway" );
level._effect[ "light_blink_london_police_car_gassy" ] = LoadFX( "lights/light_blink_london_police_car_gassy" );
level._effect[ "light_blink_london_police_car_gassy_sat" ]	= LoadFX( "lights/light_blink_london_police_car_gassy_sat" );
level._effect[ "electrical_transformer_spark_runner_loop" ]	= LoadFX( "explosions/electrical_transformer_spark_runner_loop" );
level._effect[ "electrical_transformer_spark_runner_lon" ]	= LoadFX( "explosions/electrical_transformer_spark_runner_lon" );
level._effect[ "tread_dust_london_loop" ] = LoadFX( "treadfx/tread_dust_london_loop" );
level._effect[ "cloud_ash_lite_london" ] = LoadFX( "weather/cloud_ash_lite_london" );
level._effect[ "fire_sprinkler" ] = LoadFX( "water/fire_sprinkler" );
level._effect[ "fire_sprinkler_wide" ] = LoadFX( "water/fire_sprinkler_wide" );
level._effect[ "dirt_kickup_hands" ] = LoadFX( "misc/dirt_kickup_hands" );
level._effect[ "dirt_kickup_hands_light" ] = LoadFX( "misc/dirt_kickup_hands_light" );
level._effect[ "dirt_kickup_head" ] = LoadFX( "misc/dirt_kickup_head" );
level._effect[ "dirt_kickup_concrete_cylinder_loop" ] = LoadFX( "misc/dirt_kickup_concrete_cylinder_loop" );
}
footstep_fx()
{
animscripts\utility::setFootstepEffect( "asphalt", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffect( "brick", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffect( "concrete", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffect( "dirt", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffect( "mud", LoadFX( "impacts/footstep_mud" ) );
animscripts\utility::setFootstepEffect( "rock", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffect( "sand", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffect( "water", LoadFX( "impacts/footstep_water" ) );
animscripts\utility::setFootstepEffectSmall( "asphalt", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffectSmall( "brick", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffectSmall( "concrete", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffectSmall( "dirt", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffectSmall( "mud", LoadFX( "impacts/footstep_mud" ) );
animscripts\utility::setFootstepEffectSmall( "rock", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffectSmall( "sand", LoadFX( "impacts/footstep_dust" ) );
animscripts\utility::setFootstepEffectSmall( "water", LoadFX( "impacts/footstep_water" ) );
animscripts\utility::setNotetrackEffect( "bodyfall small", "J_SpineLower", "dirt", loadfx ( "impacts/bodyfall_dust_small_runner" ), "bodyfall_", "_small" );
animscripts\utility::setNotetrackEffect( "bodyfall small", "J_SpineLower", "concrete",	loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
animscripts\utility::setNotetrackEffect( "bodyfall small", "J_SpineLower", "asphalt",	loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
animscripts\utility::setNotetrackEffect( "bodyfall small", "J_SpineLower", "rock", loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
animscripts\utility::setNotetrackEffect( "bodyfall large", "J_SpineLower", "dirt", loadfx ( "impacts/bodyfall_dust_large_runner" ), "bodyfall_", "_large" );
animscripts\utility::setNotetrackEffect( "bodyfall large", "J_SpineLower", "concrete",	loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
animscripts\utility::setNotetrackEffect( "bodyfall large", "J_SpineLower", "asphalt",	loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
animscripts\utility::setNotetrackEffect( "bodyfall large", "J_SpineLower", "rock", loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
animscripts\utility::setNotetrackEffect( "knee fx left", "J_Knee_LE", "dirt", loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx left", "J_Knee_LE", "concrete",	loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx left", "J_Knee_LE", "asphalt",	loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx left", "J_Knee_LE", "rock", loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx left", "J_Knee_LE", "mud", loadfx ( "impacts/footstep_mud" ) );
animscripts\utility::setNotetrackEffect( "knee fx right", "J_Knee_RI", "dirt", loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx right", "J_Knee_RI", "concrete",	loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx right", "J_Knee_RI", "asphalt",	loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx right", "J_Knee_RI", "rock", loadfx ( "impacts/footstep_dust" ) );
animscripts\utility::setNotetrackEffect( "knee fx right", "J_Knee_RI", "mud", loadfx ( "impacts/footstep_mud" ) );
}
notetrack_footstep_wrapper( foot, groundtype )
{
if ( self is_touching_footstep_trigger() )
{
animscripts\notetracks::playFootStepEffect( foot, "water" );
return true;
}
return false;
}
notetrack_footstep_small_wrapper( foot, groundtype )
{
if ( self is_touching_footstep_trigger() )
{
animscripts\notetracks::playFootStepEffectSmall( foot, "water" );
return true;
}
return false;
}
is_touching_footstep_trigger()
{
foreach ( trigger in level.footstep_triggers )
{
if ( !IsDefined( trigger ) )
{
level.footstep_triggers = array_remove( level.footstep_triggers, trigger );
continue;
}
if ( self IsTouching( trigger ) )
{
return true;
}
}
return false;
}
