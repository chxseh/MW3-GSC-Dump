#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\paris_ac130_b_fx::main;
level.mainFXFunc = maps\paris_ac130_b_fx::main;
SetSavedDvar( "ui_hideMap", "1" );
maps\paris_ac130::main();
SetSavedDvar( "cg_fovScale", "0.75" );
SetSavedDvar( "ai_count", 32 );
rpg_com_units = GetEntArray( "rpg_building_com_units", "targetname" );
foreach ( unit in rpg_com_units )
unit Delete();
if( !IsDefined( level.flag[ "slamzoom_complete" ] ) )
flag_init( "slamzoom_complete" );
flag_wait_either( "slamzoom_complete", "FLAG_start_bridge_collapse" );
addforcestreamxmodel( "vehicle_mig29_low_pc" );
}