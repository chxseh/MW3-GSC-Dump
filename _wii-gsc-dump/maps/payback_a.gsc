#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\payback_a_fx::main;
level.FXMainFunc = maps\payback_a_fx::main;
SetSavedDvar( "ai_count", 20);
PrecacheShader( "gasmask_overlay_delta2" );
PreCacheModel( "prop_sas_gasmask" );
PreCacheModel( "pb_gas_mask_prop" );
PreCacheModel( "projectile_us_smoke_grenade" );
PreCacheModel( "weapon_beretta" );
PreCacheModel( "weapon_desert_eagle_tactical" );
PreCacheModel( "weapon_frame_charge_iw5_water" );
PreCacheModel( "hjk_laptop_animated" );
PreCacheModel( "pb_weapon_casing_closed" );
PreCacheModel( "pb_weapon_casing_closed_splatter" );
PreCacheModel( "com_clipboard_wpaper" );
PreCacheModel( "hjk_cell_phone_off" );
PreCacheModel( "pb_door_breach" );
PreCacheModel( "pb_grenade_smoke" );
PreCacheModel( "pb_door_breach_anim" );
PreCacheModel( "pb_door_breach_hinge_anim" );
PreCacheModel( "hat_price_africa" );
PreCacheModel( "fullbody_price_africa_assault_a_nohat" );
PreCacheModel( "payback_vehicle_hind" );
PreCacheModel( "com_plasticcase_beige_big_us_dirt_animated" );
maps\payback_a_precache::main();
maps\payback::main();
}
