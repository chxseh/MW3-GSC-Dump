#include maps\_utility;
main()
{
if( is_split_level_part_or_original( "a" ) )
{
vehicle_scripts\_truck::main( "vehicle_pickup_roobars", undefined, "script_vehicle_pickup_roobars" );
vehicle_scripts\_truck_instant_death::main( "vehicle_pickup_roobars", undefined, "script_vehicle_pickup_roobars_instant_death" );
vehicle_scripts\_truck_warlord::main( "vehicle_pickup_roobars", undefined, "script_vehicle_pickup_roobars_warlord" );
vehicle_scripts\_technical_custom_fx::main( "vehicle_pickup_technical_pb_rusted", undefined, "script_vehicle_pickup_technical_custom_fx" );
vehicle_scripts\_technical_m2::main( "vehicle_pickup_technical_pb_rusted", undefined, "script_vehicle_pickup_technical_m2", "weapon_truck_m2_50cal_mg", "m2_50cal_turret_technical" );
vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", undefined, "script_vehicle_pickup_technical_payback" );
vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", undefined, "script_vehicle_pickup_technical_payback_instant_death" );
vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", "technical_physics", "script_vehicle_pickup_technical_payback_physics" );
}
if( is_split_level_part_or_original( "b" ) )
{
vehicle_scripts\_mi17_africa::main( "vehicle_mi17_africa", undefined, "script_vehicle_mi17_africa" );
}
common_scripts\_destructible_types_anim_afr_shanty01::main();
common_scripts\_destructible_types_anim_chicken::main();
common_scripts\_destructible_types_anim_wallfan::main();
maps\animated_models\afr_mort_hanging_sheet_wind_medium::main();
maps\animated_models\hanging_apron_wind_medium::main();
maps\animated_models\hanging_longsleeve_wind_medium::main();
maps\animated_models\hanging_sheet_wind_medium::main();
maps\animated_models\hanging_shortsleeve_wind_medium::main();
maps\animated_models\highrise_fencetarp_03::main();
}
