#include maps\_utility;
#include common_scripts\utility;
main()
{
level._effect["pb_jeep_trail"] = loadfx("treadfx/pb_jeep_trail");
level._effect["pb_jeep_trail_water"] = loadfx("treadfx/pb_jeep_trail_water");
level._effect["pb_jeep_trail_water_left"] = loadfx("treadfx/pb_jeep_trail_water_left");
level._effect["pb_jeep_trail_road"] = loadfx("treadfx/pb_jeep_trail_road");
level._effect["pb_jeep_trail_road_skid"] = loadfx("treadfx/pb_jeep_trail_road_skid");
level._effect["sand_vehicle_impact"] = loadfx("Sand/sand_vehicle_impact");
level._effect["birds_takeoff_seagull"] = loadfx("misc/birds_takeoff_seagull");
level._effect["bird_seagull_flock_large"] = loadfx("misc/bird_seagull_flock_large");
level._effect["gate_metal_impact"] = loadfx("maps/payback/gate_metal_impact");
level._effect["car_glass_large_moving"] = loadfx("props/car_glass_large_moving");
level._effect["a10_explosion"] = loadfx("explosions/a10_explosion");
level._effect["f15_missile"] = loadfx("smoke/smoke_geotrail_sidewinder");
level._effect["sand_wall_payback_still_lg"] = loadfx("sand/sand_wall_payback_still_lg");
level._effect["mortar_flash_120"] = loadfx("muzzleflashes/mortar_flash_120");
level._effect["mortarexp_mud_nofire"] = loadfx("explosions/mortarexp_mud_nofire");
level._effect["mortarExp_water"] = loadfx("explosions/mortarExp_water");
level._effect["aerial_explosion_large_linger"] = loadfx("explosions/aerial_explosion_large_linger");
level._effect["thick_building_fire_small"] = loadfx("fire/thick_building_fire_small");
level._effect["trash_spiral_runner_nodust"] = loadfx("misc/trash_spiral_runner_nodust");
level._effect["payback_spark_sm"] = loadfx("maps/payback/payback_spark_sm");
level._effect["payback_interrogation_gas_runner_0"] = loadfx("maps/payback/payback_interrogation_gas_runner_0");
level._effect["payback_interrogation_gas1"] = loadfx("maps/payback/payback_interrogation_gas1");
level._effect["payback_interrogation_gas2"] = loadfx("maps/payback/payback_interrogation_gas2");
level._effect["payback_interrogation_gas4"] = loadfx("maps/payback/payback_interrogation_gas4");
level._effect["poisonous_gas_ground_payback_200_light"] = loadfx("smoke/poisonous_gas_ground_payback_200_light");
level._effect["waraabe_head_shot"] = loadfx("maps/payback/waraabe_head_shot");
level._effect["waraabe_blood_drips"] = loadfx("maps/payback/waraabe_blood_drips");
level._effect["waraabe_leg_shot"] = loadfx("maps/payback/waraabe_leg_shot");
level._effect["flesh_hit_splat_exaggerated2"] = loadfx("impacts/flesh_hit_splat_exaggerated2");
level._effect["pistol_muzzle_flash"] = loadfx("muzzleflashes/pistolflash");
level._effect["pistol_shell_eject"] = loadfx("shellejects/pistol");
level._effect["waraabe_leg_kick"] = loadfx("maps/payback/waraabe_leg_kick");
level._effect["breach_door_payback"] = loadfx("explosions/breach_door_payback");
level._effect["remote_chopper_default"] = loadfx("explosions/remote_chopper_default");
level._effect["wood_plank2"] = loadfx("props/wood_plank2");
level._effect["fire_smoke_trail_L"] = loadfx("fire/fire_smoke_trail_L");
level._effect["water_wake_pb"] = loadfx("water/water_wake_pb");
level._effect["water_wake_pb2"] = loadfx("water/water_wake_pb2");
level._effect["water_wake_wave_runner"] = loadfx("water/water_wake_wave_runner");
level._effect["water_wave_splash_runner"] = loadfx("water/water_wave_splash_runner");
level._effect["sand_spray_detail_oriented_runner_400x400_puff"] = loadfx("sand/sand_spray_detail_oriented_runner_400x400_puff");
level._effect["sand_wall_payback_still_md"] = loadfx("sand/sand_wall_payback_still_md");
level._effect["gnats"] = loadfx("misc/gnats");
level._effect["sand_blowing"] = loadfx("sand/sand_blowing");
level._effect["leaves_blowing_light"] = loadfx("misc/leaves_blowing_light");
level._effect["blank"] = loadfx("misc/blank");
level._effect["payback_fog_ground_200_lite"] = loadfx("maps/payback/payback_fog_ground_200_lite");
level._effect["payback_water_drips"] = loadfx("maps/payback/payback_water_drips");
level._effect["light_drips_slow"] = loadfx("maps/payback/light_drips_slow");
level._effect["payback_insects"] = loadfx("maps/payback/payback_insects");
level._effect["payback_int_dust"] = loadfx("maps/payback/payback_int_amb_dust");
level._effect["payback_int_godrays"] = loadfx("maps/payback/payback_int_godrays");
level._effect["payback_pipe_steam"] = loadfx("maps/payback/payback_pipe_steam");
level._effect["lightray_volumetric"] = loadfx("lights/lightray_volumetric");
level._effect["lightray_volumetric_lg"] = loadfx("lights/lightray_volumetric_lg");
level._effect["lightroom_volumetric"] = loadfx("lights/lightroom_volumetric");
level._effect["lightroom_volumetric_xsm"] = loadfx("lights/lightroom_volumetric_xsm");
level._effect["fluo_lightbeam"] = loadfx("lights/fluo_lightbeam");
level._effect["payback_spark_sm_r"] = loadfx("maps/payback/payback_spark_sm_r");
level._effect["payback_small_vehicle_explosion"] = loadfx("explosions/small_vehicle_explosion_pb");
level._effect[ "_breach_doorbreach_detpack" ] = loadfx( "explosions/exp_pack_doorbreach" );
if ( !getdvarint("r_reflectionProbeGenerate") )
{
maps\createfx\payback_a_fx::main();
}
}

