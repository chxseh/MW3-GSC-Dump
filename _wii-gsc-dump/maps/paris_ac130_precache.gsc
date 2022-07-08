#include maps\_utility;
main()
{
vehicle_scripts\_ac130::main( "tag_origin", undefined, "script_vehicle_ac130" );
if( is_split_level_part_or_original( "b" ) )
{
vehicle_scripts\_blackhawk::main( "vehicle_blackhawk_pc", undefined, "script_vehicle_blackhawk_streamed" );
}
vehicle_scripts\_bm21_troops::main( "vehicle_bm21_mobile_cover_pc", undefined, "script_vehicle_bm21_mobile_cover_troops_streamed" );
vehicle_scripts\_btr80::main( "vehicle_btr80_low", undefined, "script_vehicle_btr80_ac130" );
if( is_split_level_part_or_original( "b" ) )
{
vehicle_scripts\_gaz::main( "vehicle_gaz_tigr_base", "gaz_tigr_turret_physics", "script_vehicle_gaz_tigr_turret_physics" );
vehicle_scripts\_hind::main( "vehicle_mi24p_hind_chernobyl", undefined, "script_vehicle_hind_chernobyl" );
}
if( is_split_level_part_or_original( "b" ) )
{
vehicle_scripts\_hummer_minigun::main( "vehicle_hummer_pc", undefined, "script_vehicle_hummer_minigun_ac130_streamed", "minigun_hummer_ac130" );
vehicle_scripts\_humvee::main( "vehicle_hummer_pc", undefined, "script_vehicle_hummer_streamed" );
vehicle_scripts\_littlebird::main( "vehicle_little_bird_bench_pc", undefined, "script_vehicle_littlebird_bench_streamed" );
}
vehicle_scripts\_mi17::main( "vehicle_mi17_woodland_fly_pc", undefined, "script_vehicle_mi17_woodland_fly_cheap_streamed" );
vehicle_scripts\_mi17::main( "vehicle_mi17_woodland_fly_pc", undefined, "script_vehicle_mi17_woodland_fly_streamed" );
vehicle_scripts\_mig29::main( "vehicle_mig29_low_pc", undefined, "script_vehicle_mig29_low_streamed" );
vehicle_scripts\_t72_ac130::main( "vehicle_t72_tank_pc", undefined, "script_vehicle_t72_tank_ac130_streamed" );
vehicle_scripts\_t72::main( "vehicle_t72_tank_pc", undefined, "script_vehicle_t72_tank_streamed" );
common_scripts\_destructible_types_anim_building_collapse::main();
}
