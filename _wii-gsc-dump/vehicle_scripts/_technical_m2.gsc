#include maps\_vehicle;
main( model, type, classname, turret_model, turret_info )
{
vehicle_scripts\_technical::build_technical( model, type, classname, turret_model, turret_info );
build_technical_m2_anims();
build_technical_m2_death( classname );
}
build_technical_m2_anims()
{
build_aianims( ::setanims, ::set_vehicle_anims );
}
build_technical_m2_death( classname )
{
build_deathmodel( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", 0.1, classname );
build_deathfx( "fire/firelp_med_pm_nolight", "tag_fx_tank", "smallfire", undefined, undefined, true, 0 );
build_deathfx( "explosions/Vehicle_Explosion_Pickuptruck", "tag_deathfx", "car_explode", undefined, undefined, undefined, 0.1 );
build_deathfx( "fire/firelp_small_pm_a", "tag_fx_tire_right_r", "smallfire", undefined, undefined, true, 0.1 );
build_deathfx( "fire/firelp_med_pm_nolight", "tag_fx_cab", "fire_metal_medium", undefined, undefined, true, 0.11 );
build_deathfx( "fire/firelp_small_pm_a", "tag_engine_left", "smallfire", undefined, undefined, true, 0.11 );
build_death_jolt( 0.05 );
build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, true, 0.05 );
}
set_vehicle_anims( positions )
{
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0; i < 3; i++ )
positions[ i ] = SpawnStruct();
positions[ 0 ].sittag = "tag_driver";
positions[ 1 ].sittag = "tag_gunner";
positions[ 2 ].sittag = "tag_passenger";
positions[ 0 ].idle[ 0 ] = %technical_driver_idle;
positions[ 0 ].idle[ 1 ] = %technical_driver_duck;
positions[ 0 ].idleoccurrence[ 0 ] = 1000;
positions[ 0 ].idleoccurrence[ 1 ] = 100;
positions[ 0 ].death = %technical_driver_fallout;
positions[ 2 ].death = %technical_passenger_fallout;
positions[ 0 ].unload_ondeath = .9;
positions[ 1 ].unload_ondeath = .9;
positions[ 2 ].unload_ondeath = .9;
positions[ 2 ].idle[ 0 ] = %technical_passenger_idle;
positions[ 2 ].idle[ 1 ] = %technical_passenger_duck;
positions[ 2 ].idleoccurrence[ 0 ] = 1000;
positions[ 2 ].idleoccurrence[ 1 ] = 100;
positions[ 0 ].getout = %technical_driver_climb_out;
positions[ 2 ].getout = %technical_passenger_climb_out;
positions[ 0 ].getin = %pickup_driver_climb_in;
positions[ 1 ].mgturret = 0;
return positions;
}



