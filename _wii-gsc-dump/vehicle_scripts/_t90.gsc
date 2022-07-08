#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "t90", model, type, classname );
build_localinit( ::init_local );
if( classname == "script_vehicle_t90_tank_woodland_hamburg" )
{
build_deathmodel( "vehicle_t90_tank_woodland", "vehicle_t90_tank_woodland_dt" );
build_deathfx( "explosions/vehicle_explosion_t90_cheap", "tag_deathfx", "exp_armor_vehicle", undefined, undefined, undefined, 0, undefined, undefined, undefined, 8 );
}
else if( classname != "script_vehicle_t90_tank_woodland_paris_a" )
{
build_deathmodel( "vehicle_t90_tank_woodland", "vehicle_t90_tank_woodland_dt", 0.5 );
build_deathfx( "explosions/vehicle_explosion_t90", "tag_deathfx", "exp_armor_vehicle", undefined, undefined, undefined, 0 );
build_deathfx( "fire/t90_death_fire_smoke", "tag_deathfx", "fire_metal_medium", undefined, undefined, true, 0 );
}
build_shoot_shock( "tankblast" );
build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "spotlight", "TAG_LIGHT_TOP", "misc/spotlight_btr80", "spotlight_turret", 0.0 );
build_light( lightmodel, "frontlight_L", "TAG_FRONT_LIGHT_LEFT", "misc/car_headlight_bm21", "running", 0.1 );
build_light( lightmodel, "frontlight_R", "TAG_FRONT_LIGHT_RIGHT", "misc/car_headlight_bm21", "running", 0.1 );
if( common_scripts\utility::get_template_level() == "hamburg" )
build_turret( "t90_turret2", "tag_turret2", "vehicle_t90_PKT_Coaxial_MG", undefined, "auto_nonai" );
else
build_turret( "t90_turret2", "tag_turret2", "vehicle_t90_PKT_Coaxial_MG" );
add_turret = IsSubStr( classname, "_turret" ) || IsSubStr( classname, "berlin" ) || IsSubStr( classname, "hamburg" );
if ( add_turret )
build_turret( "dshk_gaz", "tag_turret_hatch", "weapon_dshk_turret_t90", 1028, "auto_ai", 0.2, 20, -14);
build_treadfx();
build_life( 999, 500, 1500 );
build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
build_team( "axis" );
build_mainturret();
build_frontarmor( .33 );
build_bulletshield( true );
if ( add_turret )
{
build_aianims( ::setanims, ::set_vehicle_anims );
}
}
init_local()
{
}
set_vehicle_anims( positions )
{
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
positions[ 0 ] = spawnstruct();
positions[ 0 ].sittag = "tag_turret_hatch";
positions[ 0 ].sittag_offset = ( 0, 0, -16 );
positions[ 0 ].bHasGunWhileRiding = false;
positions[ 0 ].idle = %gaz_turret_idle;
positions[ 0 ].mgturret = 1;
return positions;
}












