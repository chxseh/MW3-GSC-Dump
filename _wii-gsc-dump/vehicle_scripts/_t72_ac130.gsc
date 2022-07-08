#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "t72_ac130", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_t72_tank", "vehicle_t72_tank_d_body", 3.7 );
build_deathmodel( "vehicle_t72_tank_pc", "vehicle_t72_tank_d_body", 3.7 );
build_deathmodel( "vehicle_t72_tank_low", "vehicle_t72_tank_d_body", 3.7 );
build_shoot_shock( "tankblast" );
build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
build_deathfx( "explosions/vehicle_explosion_t72", "tag_deathfx", "exp_armor_vehicle", undefined, undefined, undefined, 0 );
build_deathfx( "fire/firelp_large_pm", "tag_deathfx", "fire_metal_medium", undefined, undefined, true, 0 );
build_turret( "t72_ac130_turret2", "tag_turret2", "vehicle_t72_tank_pkt_coaxial_mg" );
build_life( 999, 500, 1500 );
build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
build_team( "axis" );
build_mainturret();
build_frontarmor( .33 );
}
init_local()
{
}



