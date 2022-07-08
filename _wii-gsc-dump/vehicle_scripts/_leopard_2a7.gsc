#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "leopard_2a7", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_leopard_2a7", "vehicle_leopard_2a7_d" );
build_deathmodel( "vehicle_leopard_2a7_streamed", "vehicle_leopard_2a7_d_streamed" );
build_shoot_shock( "tankblast" );
build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
build_exhaust( "distortion/leopard_2a7_exhaust_cheap" );
build_deckdust( "dust/abrams_deck_dust" );
build_treadfx();
build_deathfx( "explosions/large_vehicle_explosion", undefined, "exp_armor_vehicle" );
if( issubstr( classname, "streamed" ) )
build_turret( "m1a1_coaxial_mg", "tag_coax_mg", "vehicle_m1a1_abrams_PKT_Coaxial_MG_streamed" );
else
build_turret( "m1a1_coaxial_mg", "tag_coax_mg", "vehicle_m1a1_abrams_PKT_Coaxial_MG" );
build_life( 999, 500, 1500 );
build_rumble( "tank_rumble", 0.15, 4.5, 900, 1, 1 );
build_team( "allies" );
build_mainturret();
build_aianims( ::setanims, ::set_vehicle_anims );
build_frontarmor( .33 );
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
for ( i = 0;i < 11;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].getout_delete = true;
return positions;
}





