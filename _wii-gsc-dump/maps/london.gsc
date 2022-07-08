#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\london_code;
main()
{
test_ending_gas();
level.level_callbacks = [];
add_callback( "westminster_anim", maps\westminster_tunnels_anim::main );
add_callback( "force_door_shut", maps\westminster_tunnels_anim::force_door_shut );
add_callback( "manage_player_position", maps\westminster_truck_movement::manage_player_position );
add_callback( "stop_manage_player_position", maps\westminster_truck_movement::stop_manage_player_position );
maps\createart\london_art::main();
maps\london_precache::main();
if(!geoMode())
{
maps\london_fx::main();
level_precache();
maps\london_docks::pre_load();
maps\westminster_tunnels::pre_load();
maps\london_docks_script_starts::main();
maps\westminster_starts::main();
add_start( "start_of_level" );
add_start( "post_intro" );
add_start( "2nd_alley" );
add_start( "warehouse_breach" );
add_start( "warehouse_hallway" );
add_start( "docks_assault" );
add_start( "docks_assault_ambush" );
add_start( "docks_assault_streets" );
add_start( "train_start" );
add_start( "train_start_ride" );
add_start( "train_start_first_bend" );
add_start( "train_start_civilian_fly_by" );
add_start( "train_start_outside" );
add_start( "train_start_ghost_station" );
}
SetSavedDvar( "r_specularColorScale", 2 );
SetNorthYaw( 90 );
maps\_load::main();
SetSavedDvar( "ai_count", 32 );
while( geoMode() )
{
wait(10);
}
init_level();
maps\london_starts::start_thread();
}
test_ending_gas()
{
}
test_ending_gas_thread()
{
}































