#include maps\_utility;
#include common_scripts\utility;
main()
{
level._effect["pb_jeep_trail"] = loadfx("treadfx/pb_jeep_trail");
level._effect["pb_jeep_trail_water"] = loadfx("treadfx/pb_jeep_trail_water");
level._effect["pb_jeep_trail_water_left"] = loadfx("treadfx/pb_jeep_trail_water_left");
level._effect["pb_jeep_trail_road"] = loadfx("treadfx/pb_jeep_trail_road");
level._effect["pb_jeep_trail_road_skid"] = loadfx("treadfx/pb_jeep_trail_road_skid");
level._effect["bird_seagull_flock_large"] = loadfx("misc/bird_seagull_flock_large");
level._effect["sand_wall_payback_still_lg"] = loadfx("sand/sand_wall_payback_still_lg");
level._effect["trash_spiral_runner_nodust"] = loadfx("misc/trash_spiral_runner_nodust");
level._effect["payback_spark_sm"] = loadfx("maps/payback/payback_spark_sm");
level._effect["flesh_hit_body_fatal_exit"] = loadfx("impacts/flesh_hit_body_fatal_exit");
level._effect["remote_chopper_default"] = loadfx("explosions/remote_chopper_default");
level._effect["wood_plank2"] = loadfx("props/wood_plank2");
level._effect["fire_smoke_trail_L"] = loadfx("fire/fire_smoke_trail_L");
level._effect["water_wake_pb"] = loadfx("water/water_wake_pb");
level._effect["water_wake_pb2"] = loadfx("water/water_wake_pb2");
level._effect["water_wave_splash_runner"] = loadfx("water/water_wave_splash_runner");
level._effect["dust_kickup"] = loadfx("dust/dust_kickup_slide_runner");
level._effect["wall_dust_crumble"] = loadfx("dust/wall_dust_crumble");
level._effect["payback_sand_wall_impact"] = loadfx("maps/payback/payback_sand_wall_impact");
level._effect["payback_sand_wall_shake"] = loadfx("maps/payback/payback_sand_wall_shake");
level._effect["roof_debris"] = loadfx("misc/roof_debris");
level._effect["heli_rotor_rooftop"] = loadfx("maps/payback/heli_rotor_rooftop");
level._effect["fx_sparks_impact"] = loadfx("maps/payback/fx_sparks_impact");
level._effect["payback_const_chopper_wood_splint"] = loadfx("maps/payback/payback_const_chopper_wood_splint");
level._effect["payback_const_chopper_wood_splintb"] = loadfx("maps/payback/payback_const_chopper_wood_splintb");
level._effect["payback_const_chopper_spark_runner"] = loadfx("maps/payback/payback_const_chopper_spark_runner");
level._effect["payback_const_chopper_concrete_splat"] = loadfx("maps/payback/payback_const_chopper_concrete_splat");
level._effect["payback_const_chopper_concrete_splatb"] = loadfx("maps/payback/payback_const_chopper_concrete_splatb");
level._effect["helicopter_explosion_secondary_small"] = loadfx("explosions/helicopter_explosion_secondary_small");
level._effect["smoke_geotrail_rpg"] = loadfx("smoke/smoke_geotrail_rpg");
level._effect["debri_explosion"] = loadfx("explosions/debri_explosion");
level._effect["sand_wall_payback_still"] = loadfx("sand/sand_wall_payback_still");
level._effect["payback_window_glow2"] = loadfx("maps/payback/payback_window_glow2");
level._effect["sand_spray_rooftop_oriented_dark_runner"] = loadfx("sand/sand_spray_rooftop_oriented_dark_runner");
level._effect["payback_light_street_flicker"] = loadfx("maps/payback/payback_light_street_flicker");
level._effect["payback_light_street"] = loadfx("maps/payback/payback_light_street");
level._effect["lights_point_white_payback"] = loadfx("misc/light_glow_white_payback");
level._effect["sand_spray_detail_oriented_runner_400x400_puff"] = loadfx("sand/sand_spray_detail_oriented_runner_400x400_puff");
level._effect["sand_spray_detail_oriented_runner_0x0"] = loadfx("sand/sand_spray_detail_oriented_runner_0x0");
level._effect["sand_wall_payback_still_md"] = loadfx("sand/sand_wall_payback_still_md");
level._effect["rock_impact_large"] = loadfx("explosions/rock_impact_large");
level._effect["rollcar_fire_hood"] = loadfx("fire/firelp_med_pm_nolight_hood");
level._effect["rollcar_fire_body"] = loadfx("explosions/ammo_cookoff");
level._effect["rollcar_death"] = loadfx("explosions/Vehicle_Explosion_Pickuptruck");
level._effect["payback_car_blacksmoke_wind"] = loadfx("maps/payback/payback_car_blacksmoke_wind");
level._effect["paper_blowing_trash"] = loadfx("misc/paper_blowing_trash");
level._effect["sand_blowing"] = loadfx("sand/sand_blowing");
level._effect["blank"] = loadfx("misc/blank");
level._effect["sand_blowing_dark"] = loadfx("sand/sand_blowing_dark");
level._effect["light_dust_motes_blowing"] = loadfx("dust/light_dust_motes_blowing");
level._effect["payback_sand_rooftop"] = loadfx("maps/payback/payback_sand_rooftop");
level._effect["payback_car_blacksmoke_wind"] = loadfx("maps/payback/payback_car_blacksmoke_wind");
level._effect["payback_insects"] = loadfx("maps/payback/payback_insects");
level._effect["payback_int_dust"] = loadfx("maps/payback/payback_int_amb_dust");
level._effect["lightray_volumetric"] = loadfx("lights/lightray_volumetric");
level._effect["fluo_lightbeam"] = loadfx("lights/fluo_lightbeam");
level._effect["tinhat_beam"] = loadfx("lights/tinhat_beam");
level._effect["payback_spark_sm_r"] = loadfx("maps/payback/payback_spark_sm_r");
level._effect["payback_small_vehicle_explosion"] = loadfx("explosions/small_vehicle_explosion_pb");
level._effect[ "_breach_doorbreach_detpack" ] = loadfx( "explosions/exp_pack_doorbreach" );
if ( !getdvarint("r_reflectionProbeGenerate") )
{
maps\createfx\payback_a2_fx::main();
}
}

