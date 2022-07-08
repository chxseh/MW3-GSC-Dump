#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
template_level = get_template_level();
simple = ( IsDefined( template_level ) && template_level == "paris_a" );
build_template( "ac130", model, type, classname );
build_localinit( ::init_local );
build_team( "allies" );
build_bulletshield( true );
build_grenadeshield( true );
}
init_local()
{
}
