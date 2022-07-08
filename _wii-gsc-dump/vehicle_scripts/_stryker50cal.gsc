#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "stryker50cal", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_stryker_wii", "vehicle_stryker_config2_destroyed" );
build_deathfx( "explosions/large_vehicle_explosion", undefined, "exp_armor_vehicle" );
build_drive( %stryker_movement, %stryker_movement_backwards, 10 );
build_treadfx();
build_life( 999, 500, 1500 );
build_team( "allies" );
build_mainturret();
build_frontarmor( .33 );
build_rumble( "stryker_rumble", 0.15, 4.5, 900, 1, 1 );
}
init_local()
{
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 11;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].getout_delete = true;
return positions;
}



