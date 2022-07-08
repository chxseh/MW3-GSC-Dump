#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "zubr", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "russian_zubr_watercraft" );
build_life( 999, 500, 1500 );
build_team( "axis" );
}
init_local()
{
}







