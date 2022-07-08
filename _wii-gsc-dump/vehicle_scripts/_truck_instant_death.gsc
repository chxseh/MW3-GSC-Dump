#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
vehicle_scripts\_truck::build_truck( model, type, classname );
build_truck_instant_death( classname );
build_life( 2750, 2500, 3000 );
}
build_truck_instant_death( classname )
{
build_deathmodel( "vehicle_pickup_roobars", "vehicle_pickup_roobars_destroyed", 0.1, classname );
build_deathfx( "fire/firelp_med_pm_nolight", "tag_body", "smallfire", undefined, undefined, true, 0, true );
build_deathfx( "explosions/small_vehicle_explosion", undefined, "car_explode", undefined, undefined, undefined, 0.1, true );
build_deathfx( "fire/firelp_small_pm_a", "tag_fx_tire_right_r", "smallfire", undefined, undefined, true, 0.1, true );
build_deathfx( "fire/firelp_med_pm_nolight", "tag_fx_cab", "smallfire", undefined, undefined, true, 0.11, true );
build_deathfx( "fire/firelp_small_pm_a", "tag_engine_left", "smallfire", undefined, undefined, true, 0.11, true );
build_radiusdamage( ( 0, 0, 32 ), 200, 150, 0, false, 2 );
}



