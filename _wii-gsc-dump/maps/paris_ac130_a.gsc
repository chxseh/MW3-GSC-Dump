#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\paris_ac130_a_fx::main;
level.mainFXFunc = maps\paris_ac130_a_fx::main;
maps\paris_ac130::main();
SetSavedDvar( "ai_count", 24 );
}