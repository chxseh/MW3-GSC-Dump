#include maps\_utility;
#include common_scripts\utility;
main()
{
level._effect["pb_jeep_trail"] = loadfx("treadfx/pb_jeep_trail");
level._effect["sand_wall_payback_still_lg"] = loadfx("sand/sand_wall_payback_still_lg");
level._effect["aerial_explosion_large_linger"] = loadfx("explosions/aerial_explosion_large_linger");
level._effect["trash_spiral_runner_nodust"] = loadfx("misc/trash_spiral_runner_nodust");
level._effect["breach_door_payback"] = loadfx("explosions/breach_door_payback");
level._effect["water_wake_pb"] = loadfx("water/water_wake_pb");
level._effect["dust_kickup"] = loadfx("dust/dust_kickup_slide_runner");
level._effect["payback_headlights_view"] = loadfx("maps/payback/payback_headlights_view");
level._effect["car_taillight_uaz_pb"] = loadfx("misc/car_taillight_uaz_pb");
level._effect["sand_wall_payback_still"] = loadfx("sand/sand_wall_payback_still");
level._effect["payback_window_glow"] = loadfx("maps/payback/payback_window_glow");
level._effect["payback_window_glow2"] = loadfx("maps/payback/payback_window_glow2");
level._effect["payback_window_glow3"] = loadfx("maps/payback/payback_window_glow3");
level._effect["payback_window_glow4"] = loadfx("maps/payback/payback_window_glow4");
level._effect["payback_window_glow5"] = loadfx("maps/payback/payback_window_glow5");
level._effect["payback_window_glow6"] = loadfx("maps/payback/payback_window_glow6");
level._effect["horizon_fireglow"] = loadfx("maps/payback/horizon_fireglow");
level._effect["horizon_fireglow_lg"] = loadfx("maps/payback/horizon_fireglow_lg");
level._effect["payback_blown_debris1"] = loadfx("maps/payback/payback_blown_debris1");
level._effect["payback_light_street_flicker"] = loadfx("maps/payback/payback_light_street_flicker");
level._effect["payback_light_street"] = loadfx("maps/payback/payback_light_street");
level._effect["payback_godray_beam_gate"] = loadfx("maps/payback/payback_godray_beam_gate");
level._effect["payback_godray_beam_win"] = loadfx("maps/payback/payback_godray_beam_win");
level._effect["flare_ambient"] = loadfx("misc/flare_ambient_payback");
level._effect["lights_point_white_payback"] = loadfx("misc/light_glow_white_payback");
level._effect["lights_flashlight_sandstorm_offset"] = loadfx("lights/lights_flashlight_sandstorm_offset");
level._effect["lights_flashlight_sandstorm"] = loadfx("lights/lights_flashlight_sandstorm");
level._effect["payback_powerline_runner"] = loadfx("maps/payback/payback_powerline_runner");
level._effect["payback_fire_transformer_md"] = loadfx("maps/payback/payback_fire_transformer_md");
level._effect["heli_crash_fire_payback"] = loadfx("fire/heli_crash_fire_payback");
level._effect["heli_crash_fire_payback_far"] = loadfx("fire/heli_crash_fire_payback_far");
level._effect["sand_wall_payback_still_md"] = loadfx("sand/sand_wall_payback_still_md");
level._effect["sand_extreme_placed"] = loadfx("sand/sand_extreme_placed");
level._effect["paper_blowing_trash"] = loadfx("misc/paper_blowing_trash");
level._effect["paper_blowing_trash_fast"] = loadfx("misc/paper_blowing_trash_fast");
level._effect["sand_blowing"] = loadfx("sand/sand_blowing");
level._effect["blank"] = loadfx("misc/blank");
level._effect["sand_blowing_dark"] = loadfx("sand/sand_blowing_dark");
level._effect["payback_sand_spray_detail"] = loadfx("maps/payback/payback_sand_spray_detail");
level._effect["payback_sand_rooftop"] = loadfx("maps/payback/payback_sand_rooftop");
level._effect["firelp_med_pm_nolight_pb"] = loadfx("fire/firelp_med_pm_nolight_pb");
level._effect["firelp_sm_pm_nolight_pb"] = loadfx("fire/firelp_sm_pm_nolight_pb");
level._effect["payback_small_vehicle_explosion"] = loadfx("explosions/small_vehicle_explosion_pb");
if ( !getdvarint("r_reflectionProbeGenerate") )
{
maps\createfx\payback_b_fx::main();
}
}

