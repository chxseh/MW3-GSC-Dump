
main()
{
vehicle_scripts\_jeep_rubicon_payback::main( "vehicle_jeep_rubicon",undefined, "script_vehicle_jeep_rubicon_payback" );
vehicle_scripts\_hind::main( "payback_vehicle_hind", undefined, "script_vehicle_payback_hind" );
vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", undefined, "script_vehicle_pickup_technical_payback" );
vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", undefined, "script_vehicle_pickup_technical_payback_instant_death" );
common_scripts\_destructible_types_anim_light_fluo_on::main();
common_scripts\_destructible_types_anim_me_fanceil1_spin::main();
}
