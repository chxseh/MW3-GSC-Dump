#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\berlin_a_fx::main;
level.mainFXFunc = maps\berlin_a_fx::main;
maps\berlin_a_precache::main();
maps\berlin::main();
}