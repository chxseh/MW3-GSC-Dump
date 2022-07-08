#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\payback_b_fx::main;
level.FXMainFunc = maps\payback_b_fx::main;
PreCacheModel( "chicken_black_white" );
PreCacheModel( "pb_gate_chain" );
PreCacheModel( "mil_emergency_flare" );
PreCacheModel( "payback_foliage_bush01" );
PreCacheModel( "payback_escape_debris" );
PreCacheModel( "pb_sstorm_chopper_rescue_propeller" );
PreCacheModel( "pb_sstorm_chopper_rescue_tail_anim" );
SetSavedDvar( "ai_count", 20 );
maps\payback_b_precache::main();
maps\payback::main();
maps\_loadout::RestorePlayerWeaponStatePersistent( "payback_a2", true );
}
