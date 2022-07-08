#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\berlin_b_fx::main;
level.mainFXFunc = maps\berlin_b_fx::main;
maps\berlin_b_precache::main();
maps\berlin::main();
maps\_loadout::RestorePlayerWeaponStatePersistent( "berlin_a", true );
}