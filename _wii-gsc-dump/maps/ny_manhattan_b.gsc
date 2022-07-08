#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\ny_manhattan_b_fx::main;
level.mainFXFunc = maps\ny_manhattan_b_fx::main;
level.remote_missile_detonate_height = 1750;
toys = GetEntArray( "destructible_toy", "targetname" );
foreach( toy in toys )
{
if( toy.model == "com_firehydrant" )
toy Delete();
}
NYSE_Start = GetEnt( "start_nyse", "targetname" );
NYSE_Start.origin = (-336, 1824, 28);
maps\ny_manhattan::main();
SetSavedDvar( "ai_count", 24 );
maps\_loadout::RestorePlayerWeaponStatePersistent( "ny_manhattan_a", true );
}