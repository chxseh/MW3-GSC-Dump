#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "forklift", model, type, classname );
build_localinit( ::init_local );
build_radiusdamage( ( 0, 0, 32 ), 150, 200, 50, false );
build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
build_deathquake( 0.5, 0.5, 500 );
build_treadfx();
build_life( 999, 500, 1500 );
build_team( "axis" );
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
for ( i = 0;i < 2;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].sittag = "TAG_DRIVER";
positions[ 0 ].idle = %uaz_driver_idle_drive;
return positions;
}












