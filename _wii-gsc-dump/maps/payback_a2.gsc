#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\payback_a2_fx::main;
level.FXMainFunc = maps\payback_a2_fx::main;
SetSavedDvar( "ai_count", 20 );
PreCacheModel( "payback_const_rappel_rope" );
PreCacheModel( "payback_const_rappel_rope_obj" );
PreCacheModel( "pb_heli_crash_rappel_debris" );
PreCacheModel( "pb_door_breach" );
PreCacheModel( "payback_vehicle_hind" );
maps\payback_a2_precache::main();
maps\payback::main();
maps\_loadout::RestorePlayerWeaponStatePersistent( "payback_a", true );
SetSkyboxIndex(0);
}
