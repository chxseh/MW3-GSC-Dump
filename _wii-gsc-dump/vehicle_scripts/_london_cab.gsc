#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "london_cab", model, type, classname );
build_localinit( ::init_local );
build_destructible( "vehicle_london_cab_black_destructible", "vehicle_london_cab_black" );
build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
build_treadfx();
build_life( 999, 500, 1500 );
build_team( "allies" );
build_aianims( ::setanims, ::set_vehicle_anims );
}
init_local()
{
}
set_vehicle_anims( positions )
{
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
positions = [];
positions[ 0 ] = spawnstruct();
positions[ 0 ].sittag = "tag_driver";
positions[ 0 ].bHasGunWhileRiding = false;
positions[ 0 ].idle = %technical_driver_idle;
return positions;
}



