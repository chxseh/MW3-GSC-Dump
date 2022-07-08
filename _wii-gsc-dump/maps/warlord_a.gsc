#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\warlord_a_fx::main;
maps\warlord::main();
SetSavedDvar( "ai_count", 24);
}