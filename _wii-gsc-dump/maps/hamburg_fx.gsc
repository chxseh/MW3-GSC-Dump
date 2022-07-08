#include maps\_utility;
main()
{
if ( !GetDvarInt( "r_reflectionProbeGenerate" ) )
{
maps\createfx\hamburg_fx::main();
}
level._effect[ "osprey_trail" ] = LoadFX( "fire/fire_smoke_trail_L" );
level._effect[ "osprey_explosion" ] = LoadFX( "explosions/helicopter_explosion_secondary_small" );
level._effect[ "hovercraft_side_spray" ] = LoadFX( "water/hovercraft_side_wake_hamburg" );
level._effect[ "blackhawk_explosion" ] = LoadFX( "explosions/heli_engine_osprey_explosion" );
level._effect[ "osprey_splash" ] = LoadFX( "water/osprey_water_crash" );
level._effect[ "explosion_type_1" ] = LoadFX( "explosions/bridge_explode" );
level._effect[ "explosion_type_4" ] = LoadFX( "explosions/building_explosion_london" );
level._effect[ "explosion_type_9" ] = LoadFX( "explosions/bridge_explode_hamburg_medium" );
level._effect[ "tank_god_ray" ] = LoadFX( "lights/hamburg_garage_godray" );
level._effect[ "tank_god_ray_light" ] = LoadFX( "lights/hamburg_garage_godray_light" );
level._effect[ "hamburg_garage_godray_small_light" ] = LoadFX( "lights/hamburg_garage_godray_small_light" );
level._effect[ "hamburg_garage_godray_small" ] = LoadFX( "lights/hamburg_garage_godray_small" );
level._effect[ "hamburg_tank_red_light" ] = LoadFX( "misc/hamburg_tank_red_light" );
level._effect[ "fire_sprinkler" ] = LoadFX( "water/fire_sprinkler_cheap" );
level._effect[ "flares_rockety_dodge" ] = LoadFX( "misc/flares_cobra" );
level._effect[ "tank_blows_up_building_left" ]	= LoadFX( "explosions/bridge_explode_hamburg" );
level._effect[ "smoke_two" ] = LoadFX( "smoke/hamburg_cover_smoke_runner" );
level._effect[ "hamburg_just_bricks" ] = LoadFX( "explosions/hamburg_brick_wall_just_bricks" );
level._effect[ "rpg_trail_garage" ] = LoadFX( "smoke/smoke_geotrail_rpg" );
level._effect[ "rpg_muzzle" ] = LoadFX( "muzzleflashes/at4_flash" );
level._effect[ "rpg_explode" ] = LoadFX( "explosions/rpg_wall_impact" );
level._effect[ "rpg_trail" ] = LoadFX( "smoke/smoke_geotrail_rpg" );
level._effect[ "FX_runner_air_light" ] = LoadFX( "misc/antiair_runner_cloudy" );
level._effect[ "FX_runner_air_flak" ] = LoadFX( "misc/antiair_runner_flak" );
level._effect[ "slamraam_explosion"] = LoadFX( "explosions/vehicle_explosion_slamraam_no_missiles");
level._effect[ "helic_engine_exhaust" ] = loadfx( "fire/heli_engine_exhaust" );
level._effect[ "tank_blows_up_sniper" ] = LoadFX( "explosions/bridge_explode_hamburg" );
level._effect[ "behind_bus_fire" ] = LoadFX( "fire/thick_building_fire" );
level._effect[ "tank_breach_brick_trail" ] = LoadFX( "dust/tank_breach_brick_trail" );
level._effect[ "trash_spiral_runner" ] = LoadFX( "misc/trash_spiral_runner" );
level._effect[ "thin_black_smoke_M" ] = LoadFX( "smoke/thin_black_smoke_M" );
level._effect[ "thin_black_smoke_M_HELICOPTER" ] = LoadFX( "smoke/thin_black_smoke_M" );
level._effect[ "fire_falling_runner_point" ] = LoadFX( "fire/fire_falling_runner_point" );
level._effect[ "electrical_transformer_spark_runner_loop" ] = LoadFX( "explosions/electrical_transformer_spark_runner_loop" );
level._effect[ "cloud_ash_lite_london" ] = LoadFX( "weather/cloud_ash_lite_london" );
level._effect[ "battlefield_smokebank_S_warm" ] = LoadFX( "smoke/battlefield_smokebank_S_warm" );
level._effect[ "thin_black_smoke_s_fast" ] = LoadFX( "smoke/thin_black_smoke_s_fast" );
level._effect[ "after_math_embers" ] = LoadFX( "fire/after_math_embers" );
level._effect[ "thin_black_smoke_hamburg" ] = LoadFX( "smoke/thin_black_smoke_hamburg" );
level._effect[ "insects_light_complex" ] = LoadFX( "misc/insects_light_complex" );
level._effect[ "thick_building_fire" ] = LoadFX( "fire/thick_building_fire" );
level._effect[ "ash_prague" ] = LoadFX( "weather/ash_prague" );
level._effect[ "embers_prague" ] = LoadFX( "weather/embers_prague" );
level._effect[ "ambient_ground_smoke" ] = LoadFX( "weather/ambient_ground_smoke" );
level._effect[ "car_fire_mp" ] = LoadFX( "fire/car_fire_mp" );
level._effect[ "insects_light_hunted" ] = LoadFX( "misc/insects_light_hunted" );
level._effect[ "firelp_cheap_mp" ] = LoadFX( "fire/firelp_cheap_mp" );
level._effect[ "room_dust_200_z150_mp" ] = LoadFX( "dust/room_dust_200_z150_mp" );
level._effect[ "burned_vehicle_sparks_hamburg" ] = LoadFX( "fire/burned_vehicle_sparks_hamburg" );
level._effect[ "room_dust_200_mp_vacant" ] = LoadFX( "dust/room_dust_200_blend_mp_vacant" );
level._effect[ "spark_fall_runner_mp" ] = LoadFX( "explosions/spark_fall_runner_mp" );
level._effect[ "paper_falling_burning" ] = LoadFX( "misc/paper_falling_burning" );
level._effect[ "building_hole_smoke_mp" ] = LoadFX( "smoke/building_hole_smoke_mp" );
level._effect[ "building_hole_embers_hamburg" ] = LoadFX( "fire/building_hole_embers_hamburg" );
level._effect[ "plane_crash_after_smoke" ] = LoadFX( "smoke/plane_crash_after_smoke" );
level._effect[ "thick_building_fire_small" ] = LoadFX( "fire/thick_building_fire_small" );
level._effect[ "building_fire_hamburg_thick_tower" ] = LoadFX( "fire/building_fire_hamburg_thick_tower" );
level._effect[ "building_fire_hamburg_thick_tower_small" ] = LoadFX( "fire/building_fire_hamburg_thick_tower_small" );
level._effect[ "smokebank_clouds_hamburg" ] = LoadFX( "smoke/smokebank_clouds_hamburg" );
level._effect[ "falling_dirt_hamburg_runner" ] = LoadFX( "dust/falling_dirt_hamburg_runner" );
level._effect[ "garage_office_exp_hamburg" ] = LoadFX( "explosions/garage_office_exp_hamburg" );
level._effect[ "apache_barage_dust_hang_hamburg" ] = LoadFX( "dust/apache_barage_dust_hang_hamburg" );
level._effect[ "tank_crush" ] = LoadFX( "explosions/car_flatten_garage_hamburg" );
level._effect[ "garage_floor_collapse_dust_hang" ] = LoadFX( "dust/garage_floor_collapse_dust_hang" );
level._effect[ "tank_wall_breach_hamburg" ] = LoadFX( "explosions/tank_wall_breach_hamburg" );
level._effect[ "garage_floor_coll_after_fall" ] = LoadFX( "dust/garage_floor_coll_after_fall" );
level._effect[ "garage_floor_coll_dust_hang_floor" ]	= LoadFX( "dust/garage_floor_coll_dust_hang_floor" );
level._effect[ "leaves_fall_gentlewind_green" ] = loadfx( "misc/leaves_fall_gentlewind_green" );
level._effect[ "debris_pile_smoke_hang_hamburg" ] = LoadFX( "dust/debris_pile_smoke_hang_hamburg" );
level._effect[ "spark_fall_runner_mp" ] = loadfx( "explosions/spark_fall_runner_mp" );
level._effect[ "ceiling_smoke_exchange" ] = loadfx( "weather/ceiling_smoke_exchange" );
level._effect[ "wispy_cloud_pass_ride_in_hamburg" ] = LoadFX( "smoke/wispy_cloud_pass_ride_in_hamburg" );
level._effect[ "tree_fire_hamburg" ] = LoadFX( "fire/tree_fire_hamburg" );
level._effect[ "building_hole_elec_short_runner" ] = loadfx( "explosions/building_hole_elec_short_runner" );
level._effect[ "wall_fire_mp" ] = loadfx( "fire/wall_fire_mp" );
level._effect[ "fire_ceiling" ] = loadfx( "fire/fire_ceiling_lg_slow" );
level._effect[ "steam_room_fill_dark_rescue2" ] = loadfx( "smoke/steam_room_fill_dark_rescue2" );
level._effect[ "glass_scrape_runner" ] = loadfx("misc/glass_scrape_runner");
level._effect[ "ash_hamburg_cheap" ] = LoadFX( "weather/ash_hamburg_cheap" );
level._effect[ "splash_constant_hamburg" ] = LoadFX( "water/splash_constant_hamburg" );
level._effect[ "tank_blast_brick" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_carpet" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_concrete" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_dirt" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_glass" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_grass" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_metal" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_mud" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_plaster" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_rock" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_sand" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_water" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_wood" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_asphalt" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_plastic" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_paintedmetal" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_default" ] = LoadFX( "explosions/tank_shell_impact_hamburg" );
level._effect[ "tank_blast_decal_brick" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_carpet" ] = LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
level._effect[ "tank_blast_decal_concrete" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_dirt" ] = LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
level._effect[ "tank_blast_decal_glass" ] = LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
level._effect[ "tank_blast_decal_grass" ] = LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
level._effect[ "tank_blast_decal_metal" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_mud" ] = LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
level._effect[ "tank_blast_decal_plaster" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_rock" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_sand" ] = LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
level._effect[ "tank_blast_decal_water" ] = LoadFX( "explosions/tank_impact_dirt_hamburg_decal" );
level._effect[ "tank_blast_decal_wood" ] = LoadFX( "explosions/wood_explosion_1_decal" );
level._effect[ "tank_blast_decal_asphalt" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_plastic" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_paintedmetal" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_blast_decal_default" ] = LoadFX( "explosions/tank_concrete_explosion_decal" );
level._effect[ "tank_concrete_cracks" ] = LoadFX( "misc/tank_concrete_crack" );
level._effect[ "tank_concrete_cracks_spitup" ] = LoadFX( "misc/tank_concrete_crackdust" );
level._effect[ "tank_concrete_crack_dust" ] = LoadFX( "misc/hamburg_garage_crack_dust" );
level._effect[ "mortar" ][ "water" ] = LoadFX( "water/big_hamburg_river_blowup" );
level._effect[ "mortar" ][ "water_ocean" ] = LoadFX( "water/big_hamburg_river_blowup" );
level._effect[ "mortar" ][ "dirt" ] = LoadFX( "impacts/beach_impact_hamburg" );
level._effect[ "strafe_building_1_wall_collapse" ] = LoadFX( "dust/hamburg_wall_collapse");
level._effect[ "strafe_building_2_wall_collapse" ] = LoadFX( "dust/hamburg_wall_collapse");
level._effect[ "hamburg_garage_spotlight" ] = LoadFX( "misc/hamburg_garage_spotlight" );
level._effect[ "hamburg_garage_spotlight_cheap" ] = LoadFX( "misc/hamburg_garage_spotlight_cheap" );
level._effect[ "flak_at_player1" ] = LoadFX( "misc/antiair_single_tracer01_cloudy");
level._effect[ "ash_hamburg_crash" ] = LoadFX( "weather/ash_hamburg_crash" );
level._effect[ "brains" ] = loadfx( "impacts/flesh_hit_body_fatal_exit_cheap" );
level._effect[ "building_explosion_tower_hole" ]	= LoadFX( "explosions/hamburg_tower_explosion" );
level._effect[ "building_explosion_roof_common" ]	= LoadFX( "explosions/building_explosion_metal_gulag" );
level._effect[ "f15_missile_trail" ] = LoadFX( "smoke/smoke_geotrail_sidewinder_halfrestrail" );
add_earthquake( "ride_in_quake", 0.6, 0.7, 3400 );
level._effect[ "ride_in_near_aa_explose" ] = LoadFX( "explosions/aa_flak_single_hamburg");
level._effect[ "tank_water_splash_loop" ] = LoadFX( "water/tank_splash" );
level._effect[ "tank_water_splash_ring" ] = LoadFX( "water/tank_splash_ring" );
level._effect[ "lights_point_white_payback" ] = LoadFX("lights/lights_point_white_payback");
level._effect[ "firelp_small_pm_a" ] = LoadFX( "fire/firelp_small_pm_a" );
thread treadfx_override();
level._effect[ "SUV_hazard_headlight" ] = LoadFX( "lights/lights_headlight_hazard" );
level._effect[ "SUV_hazard_taillight" ] = LoadFX( "lights/lights_taillight_hazard" );
level._effect[ "water_pipe_spray" ] = LoadFX("water/water_underground_pipe");
}
treadfx_override()
{
treadfx = "treadfx/heli_dust_hamburg";
LoadFX( treadfx );
level waittill ( "load_finished" );
heli_types = [
"script_vehicle_blackhawk_hero_hamburg"
, "script_vehicle_osprey_fly_streamed"
, "script_vehicle_apache_mg_streamed"
, "script_vehicle_blackhawk_low"
, "script_vehicle_mi17_woodland_fly_cheap"
, "script_vehicle_mi28_flying"
];
common_scripts\utility::array_levelthread( heli_types, maps\_treadfx::setallvehiclefx, treadfx );
}
