#include maps\_utility;
#include maps\hamburg_code;
main()
{
maps\createart\hamburg_art::main();
maps\hamburg_precache::main();
template_level("hamburg");
level_precache();
if( !is_split_level() || is_split_level_part("a") )
{
maps\hamburg_landing_zone::pre_load();
maps\hamburg_garage::pre_load();
}
if( !is_split_level() || is_split_level_part("b") )
{
maps\hamburg_end::pre_load();
}
if( !is_split_level() || is_split_level_part("a") )
{
maps\hamburg_a_starts::main();
add_start( "ride_in" );
add_start( "beach_landing" );
add_start( "hot_buildings" );
add_start( "tank_path_pre_bridge" );
add_start( "tank_path_bridge" );
add_start( "tank_path_blackout" );
add_start( "hamburg_garage" );
add_start( "hamburg_garage_post_entrance" );
add_start( "hamburg_garage_pre_ramp" );
add_start( "hamburg_garage_ramp" );
}
if( !is_split_level() || is_split_level_part("b") )
{
maps\hamburg_b_starts::main();
if( is_split_level() )
{
add_start( "tank_crash_exit" );
}
add_start( "hamburg_end_ramp" );
add_start( "hamburg_end_street" );
add_start( "hamburg_end_streetcorner" );
add_start( "hamburg_end_nest" );
add_start( "hamburg_end_ambush" );
add_start( "hamburg_end" );
add_start( "next_level" );
}
maps\_load::main();
if( is_split_level_part("a") )
{
SetSavedDvar( "ai_count", 20 );
}
else
{
SetSavedDvar( "ai_count", 24 );
}
init_level();
}