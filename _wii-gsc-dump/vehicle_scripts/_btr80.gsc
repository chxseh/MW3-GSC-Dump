#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "btr80", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_btr80", "vehicle_btr80_d", 0.1 );
build_deathmodel( "vehicle_btr80_snow", "vehicle_btr80_snow_d" );
build_deathmodel( "vehicle_btr80_low", "vehicle_btr80_d_pc" );
btr80_death_fx = [];
btr80_death_fx[ "vehicle_btr80" ] = "explosions/vehicle_explosion_btr80";
btr80_death_fx[ "vehicle_btr80_snow" ] = "explosions/vehicle_explosion_btr80_snow";
btr80_death_fx[ "vehicle_btr80_low" ] = "explosions/vehicle_explosion_btr80";
build_deathfx( "fire/firelp_med_pm", "TAG_CARGOFIRE", "fire_metal_medium", undefined, undefined, true, 0 );
build_deathfx( btr80_death_fx[ model ], "tag_deathfx", "exp_armor_vehicle" );
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "headlight_L", "TAG_FRONT_LIGHT_LEFT", "misc/car_headlight_btr80", "running", 0.0 );
build_light( lightmodel, "taillight_L", "TAG_REAR_LIGHT_LEFT", "misc/car_taillight_btr80", "running", 0.1 );
build_light( lightmodel, "taillight_R", "TAG_REAR_LIGHT_RIGHT", "misc/car_taillight_btr80", "running", 0.1 );
build_light( lightmodel, "brakeight_R", "TAG_REAR_LIGHT_RIGHT", "misc/car_brakelight_btr80", "brake", 0.0 );
build_light( lightmodel, "brakelight_L", "TAG_REAR_LIGHT_LEFT", "misc/car_brakelight_btr80", "brake", 0.0 );
build_light( lightmodel, "spotlight", "TAG_FRONT_LIGHT_RIGHT","misc/spotlight_btr80", "spotlight", 0.2 );
build_light( lightmodel, "spotlight_turret", "TAG_TURRET_LIGHT", "misc/spotlight_btr80", "spotlight_turret", 0.0 );
build_drive( %BTR80_movement, %BTR80_movement_backwards, 10 );
if ( issubstr( model, "_snow" ) )
build_turret( "btr80_turret2", "tag_turret2", "vehicle_btr80_machine_gun_snow" );
else if ( IsSubStr( classname, "_ac130" ) )
build_turret( "btr80_ac130_turret", "tag_turret2", "vehicle_btr80_machine_gun" );
else
build_turret( "btr80_turret2", "tag_turret2", "vehicle_btr80_machine_gun" );
build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, false );
build_treadfx();
build_life( 999, 500, 1500 );
build_team( "axis" );
build_unload_groups( ::unload_groups );
build_aianims( ::setanims, ::set_vehicle_anims );
build_frontarmor( .33 );
build_bulletshield( true );
build_grenadeshield( true );
}
init_local()
{
maps\_utility::ent_flag_init( "no_riders_until_unload" );
maps\_vehicle::lights_on( "running" );
}
test_brake_lights()
{
self endon( "death");
while ( true )
{
wait 5;
maps\_vehicle::lights_on( "brake" );
wait 3;
maps\_vehicle::lights_off( "brake" );
}
}
unload_groups()
{
unload_groups = [];
unload_groups[ "driver_and_rider" ] = [];
unload_groups[ "two_riders" ] = [];
unload_groups[ "all" ] = [];
group = "driver_and_rider";
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
group = "two_riders";
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
group = "all";
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
unload_groups[ "default" ] = unload_groups[ "all" ];
return unload_groups;
}
set_vehicle_anims( positions )
{
positions[ 0 ].vehicle_getoutanim = %BTR80_doorsL_open;
positions[ 1 ].vehicle_getoutanim = %BTR80_doorsR_open;
positions[ 2 ].vehicle_getoutanim = %BTR80_doorsL_open;
positions[ 3 ].vehicle_getoutanim = %BTR80_doorsR_open;
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 4;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].sittag = "tag_detach";
positions[ 1 ].sittag = "tag_detach";
positions[ 2 ].sittag = "tag_detach";
positions[ 3 ].sittag = "tag_detach";
positions[ 0 ].idle = %BTR80_crew_idle;
positions[ 1 ].idle = %BTR80_crew_idle;
positions[ 2 ].idle = %BTR80_crew_idle;
positions[ 3 ].idle = %BTR80_crew_idle;
positions[ 0 ].getout = %BTR80_exit_1;
positions[ 1 ].getout = %BTR80_exit_2;
positions[ 2 ].getout = %BTR80_exit_3;
positions[ 3 ].getout = %BTR80_exit_4;
positions[ 0 ].getin = %humvee_driver_climb_in;
positions[ 1 ].getin = %humvee_passenger_in_L;
positions[ 2 ].getin = %humvee_passenger_in_R;
positions[ 3 ].getin = %humvee_passenger_in_R;
return positions;
}












