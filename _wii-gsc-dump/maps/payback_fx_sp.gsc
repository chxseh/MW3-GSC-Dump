#include maps\_utility;
#include maps\_sandstorm;
#include maps\_shg_fx;
#include common_scripts\utility;
main()
{
treadfx_override();
maps\_sandstorm::blizzard_main();
level thread convertOneShot();
}
treadfx_override()
{
maps\_treadfx::setallvehiclefx("script_vehicle_payback_hind", "treadfx/heli_sand_pb");
}
setup_sandstorm_replacement_fx()
{
level.breakables_fx[ "barrel" ][ "explode" ] = loadfx( "props/barrel_exp_sandstorm" );
level.vtclassname = "script_vehicle_pickup_technical_payback";
level.vehicle_death_fx[ level.vtclassname ] = [];
maps\_vehicle::build_deathfx( "explosions/vehicle_explosion_pickuptruck_pb", "tag_deathfx", "car_explode", undefined, undefined, undefined, 2.9 );
maps\_vehicle::build_deathfx( "fire/firelp_med_pm_nolight", "tag_fx_tank", "smallfire", undefined, undefined, true, 0 );
maps\_vehicle::build_deathfx( "explosions/ammo_cookoff", "tag_fx_bed", undefined, undefined, undefined, undefined, 0.5 );
maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a_pb", "tag_fx_tire_right_r", "smallfire", undefined, undefined, true, 3 );
maps\_vehicle::build_deathfx( "fire/firelp_med_pm_nolight_hood", "tag_fx_cab", "fire_metal_medium", undefined, undefined, true, 3.01 );
maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a_pb", "tag_engine_left", "smallfire", undefined, undefined, true, 3.01 );
level.vtclassname = "script_vehicle_uaz_fabric";
level.vehicle_death_fx[ level.vtclassname ] = [];
maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion_pb", undefined, "explo_metal_rand" );
index = common_scripts\_destructible_types::getInfoIndex( "vehicle_80s_hatch1_green" );
if ( index > -1 )
{
level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx_filename" ][ 0 ][ 0 ] = "explosions/small_vehicle_explosion_pb";
level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx" ][ 0 ][ 0 ] = getfx("payback_small_vehicle_explosion");
}
index = common_scripts\_destructible_types::getInfoIndex( "vehicle_pickup" );
if ( index > -1 )
{
level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx_filename" ][ 0 ][ 0 ] = "explosions/small_vehicle_explosion_pb";
level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx" ][ 0 ][ 0 ] = getfx("payback_small_vehicle_explosion");
}
}