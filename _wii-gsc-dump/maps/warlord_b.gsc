#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\warlord_b_fx::main;
maps\warlord::main();
setsaveddvar("ai_count", 24);
maps\_loadout::RestorePlayerWeaponStatePersistent( "warlord_a", true );
fencetarp = getent ("fencetarp", "script_noteworthy");
fencetarp DontCastShadows();
}