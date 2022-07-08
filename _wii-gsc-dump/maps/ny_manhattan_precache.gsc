#include maps\_utility;
main()
{
if( is_split_level_part_or_original( "a" ) )
{
vehicle_scripts\_gaz_dshk::main( "vehicle_gaz_tigr_base", undefined, "script_vehicle_gaz_tigr_turret" );
vehicle_scripts\_ss_n_12::main( "vehicle_s300_pmu2", undefined, "script_vehicle_s300_pmu2" );
vehicle_scripts\_hind::main( "vehicle_mi24p_hind_manhattan", undefined, "script_vehicle_hind_manhattan" );
}
if( is_split_level_part_or_original( "b" ) )
{
vehicle_scripts\_hind::main( "vehicle_mi24p_hind_woodland", undefined, "script_vehicle_hind_woodland" );
}
}