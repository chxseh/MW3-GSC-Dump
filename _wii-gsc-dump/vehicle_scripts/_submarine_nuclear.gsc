#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "submarine_nuclear", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_submarine_nuclear" );
build_life( 999, 500, 1500 );
build_team( "allies" );
}
init_local()
{
}






