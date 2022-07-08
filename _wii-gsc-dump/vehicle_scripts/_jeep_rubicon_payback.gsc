#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "humvee", model, type, classname );
build_localinit( ::init_local );
build_humvee_anims();
build_deathmodel( "vehicle_jeep_rubicon", "vehicle_hummer_opentop_destroyed" );
rubicon_death_fx = [];
rubicon_death_fx[ "vehicle_jeep_rubicon" ] = "explosions/vehicle_explosion_hummer_nodoors";
build_unload_groups( ::Unload_Groups );
build_deathfx( "fire/firelp_med_pm", "TAG_CAB_FIRE", "fire_metal_medium", undefined, undefined, true, 0 );
build_deathfx( rubicon_death_fx[ model ], "tag_deathfx", "car_explode" );
build_drive( %rubicon_driving_idle_forward, %rubicon_driving_idle_backward, 10 );
build_life( 999, 500, 1500 );
build_team( "allies" );
build_aianims( ::setanims, ::set_vehicle_anims );
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "headlight_truck_left", "tag_headlight_left", "maps/payback/payback_headlights_l", "headlights" );
build_light( lightmodel, "headlight_truck_right", "tag_headlight_right", "maps/payback/payback_headlights_r", "headlights" );
build_light( lightmodel, "taillight_truck_right", "tag_brakelight_right", "misc/car_taillight_truck_R_pb", "headlights" );
build_light( lightmodel, "taillight_truck_left", "tag_brakelight_left", "misc/car_taillight_truck_L_pb", "headlights" );
build_light( lightmodel, "brakelight_truck_right", "tag_brakelight_right", "misc/car_brakelight_truck_R_pb", "brakelights" );
build_light( lightmodel, "brakelight_truck_left", "tag_brakelight_left", "misc/car_brakelight_truck_L_pb", "brakelights" );
}
#using_animtree( "vehicles" );
init_local()
{
if ( issubstr( self.vehicletype, "physics" ) )
{
anims = [];
anims[ "idle" ] = %humvee_antennas_idle_movement;
anims[ "rot_l" ] = %humvee_antenna_L_rotate_360;
anims[ "rot_r" ] = %humvee_antenna_R_rotate_360;
thread humvee_antenna_animates( anims );
}
}
build_humvee_anims()
{
build_aianims( ::setanims, ::set_vehicle_anims );
}
set_vehicle_anims( positions )
{
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0; i < 4; i++ )
positions[ i ] = SpawnStruct();
positions[ 0 ].sittag = "tag_driver";
positions[ 0 ].getin = %rubicon_mount_driver;
positions[ 0 ].getout = %rubicon_dismount_driver;
positions[ 0 ].idle[ 0 ] = %rubicon_idle_driver;
positions[ 0 ].idle[ 1 ] = %rubicon_duck_driver;
positions[ 0 ].idleoccurrence[ 0 ] = 1000;
positions[ 0 ].idleoccurrence[ 1 ] = 100;
positions[ 0 ].death = %rubicon_fallout_driver;
positions[ 1 ].sittag = "tag_passenger";
positions[ 1 ].getin = %rubicon_mount_passenger;
positions[ 1 ].getout = %rubicon_dismount_passenger;
positions[ 1 ].idle[ 0 ] = %rubicon_idle_passenger;
positions[ 1 ].idle[ 1 ] = %rubicon_duck_passenger;
positions[ 1 ].idleoccurrence[ 0 ] = 1000;
positions[ 1 ].idleoccurrence[ 1 ] = 100;
positions[ 1 ].death = %rubicon_fallout_passenger;
positions[ 2 ].sittag = "tag_guy0";
positions[ 2 ].getin = %rubicon_mount_backL;
positions[ 2 ].getout = %rubicon_dismount_backL;
positions[ 2 ].idle[ 0 ] = %rubicon_idle_backL;
positions[ 2 ].idle[ 1 ] = %rubicon_duck_backL;
positions[ 2 ].idleoccurrence[ 0 ] = 1000;
positions[ 2 ].idleoccurrence[ 1 ] = 100;
positions[ 2 ].death = %rubicon_fallout_backL;
positions[ 3 ].sittag = "tag_guy1";
positions[ 3 ].getin = %rubicon_mount_backR;
positions[ 3 ].getout = %rubicon_dismount_backR;
positions[ 3 ].idle[ 0 ] = %rubicon_idle_backR;
positions[ 3 ].idle[ 1 ] = %rubicon_duck_backR;
positions[ 3 ].idleoccurrence[ 0 ] = 1000;
positions[ 3 ].idleoccurrence[ 1 ] = 100;
positions[ 3 ].death = %rubicon_fallout_backR;
return positions;
}
unload_groups()
{
unload_groups = [];
unload_groups[ "passengers" ] = [];
unload_groups[ "passenger_and_gunner" ] = [];
unload_groups[ "passenger_and_driver" ] = [];
unload_groups[ "all" ] = [];
group = "passenger_and_gunner";
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 4;
group = "passenger_and_driver";
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
group = "all";
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
unload_groups[ group ][ unload_groups[ group ].size ] = 4;
group = "passengers";
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ group ][ unload_groups[ group ].size ] = 2;
unload_groups[ group ][ unload_groups[ group ].size ] = 3;
unload_groups[ "default" ] = unload_groups[ "all" ];
return unload_groups;
}





