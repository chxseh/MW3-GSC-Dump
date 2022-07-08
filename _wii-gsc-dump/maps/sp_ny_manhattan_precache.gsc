#include maps\_utility;
main()
{
if( is_split_level_part_or_original( "b" ) )
{
vehicle_scripts\_blackhawk_minigun::main( "vehicle_ny_blackhawk", "ny_harbor_blackhawk", "script_vehicle_ny_blackhawk", undefined, "nym_blackhawk_minigun" );
}
if( is_split_level_part_or_original( "a" ) )
{
vehicle_scripts\_stryker50cal::main( "vehicle_stryker_config2", "stryker50cal_notrophy", "script_vehicle_stryker50cal_notrophy" );
}
if( is_split_level_part_or_original( "b" ) )
{
vehicle_scripts\_ucav::main( "vehicle_ucav", undefined, "script_vehicle_ucav" );
}
}