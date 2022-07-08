#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
if( issubstr( classname, "london" ) )
{
build_template( "uk_utility_truck_london", model, type, classname );
}
else
{
build_template( "uk_utility_truck", model, type, classname );
}
build_localinit( ::init_local );
build_destructible( model, "vehicle_uk_truck" );
build_deathfx( "explosions/large_vehicle_explosion", undefined, "car_explode_utility_truck", undefined, undefined, undefined, 0 );
build_radiusdamage( ( 0, 0, 32 ), 300, 200, 100, false );
build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
build_deathquake( 1, 1.6, 500 );
build_treadfx();
build_life( 999, 500, 1500 );
build_team( "axis" );
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "headlight_truck_left", "tag_headlight_left", "misc/uk_utility_truck_headlight", "headlights" );
build_light( lightmodel, "headlight_truck_right", "tag_headlight_right", "misc/uk_utility_truck_headlight", "headlights" );
build_light( lightmodel, "taillight_truck_right", "TAG_TAIL_LIGHT_RIGHT", "misc/car_taillight_bm21", "headlights" );
build_light( lightmodel, "taillight_truck_left", "TAG_TAIL_LIGHT_LEFT", "misc/car_taillight_bm21", "headlights" );
build_light( lightmodel, "brakelight_troops_right", "TAG_TAIL_LIGHT_RIGHT", "misc/car_taillight_bm21", "brakelights" );
build_light( lightmodel, "brakelight_troops_left", "TAG_TAIL_LIGHT_LEFT", "misc/car_taillight_bm21", "brakelights" );
anim_func = ::setanims;
build_aianims( anim_func, ::set_vehicle_anims );
build_hideparts( "script_vehicle_uk_utility_truck_no_rail", ["TAG_RAIL"] );
build_hideparts( "script_vehicle_uk_utility_truck_no_rail_player", ["TAG_RAIL"] );
}
init_local()
{
}
unload_groups()
{
unload_groups = [];
group = "passengers";
unload_groups[ group ] = [];
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
group = "all";
unload_groups[ group ] = [];
unload_groups[ group ][ unload_groups[ group ].size ] = 0;
unload_groups[ group ][ unload_groups[ group ].size ] = 1;
unload_groups[ "default" ] = unload_groups[ "all" ];
return unload_groups;
}
set_vehicle_anims( positions )
{
positions[ 0 ].vehicle_getoutanim = %uaz_passenger_exit_into_stand_door;
positions[ 1 ].vehicle_getoutanim = %uaz_driver_exit_into_stand_door;
positions[ 0 ].vehicle_getoutanim_clear = false;
positions[ 1 ].vehicle_getoutanim_clear = false;
positions[ 0 ].vehicle_getinanim = %london_utilitytruck_driver_mount_door;
positions[ 1 ].vehicle_getinanim = %london_utilitytruck_passenger_mount_door;
positions[ 0 ].vehicle_getoutsound = "uk_utility_door_open";
positions[ 1 ].vehicle_getoutsound = "uk_utility_door_open";
positions[ 0 ].vehicle_getinsound = "uk_utility_door_close";
positions[ 1 ].vehicle_getinsound = "uk_utility_door_close";
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 3;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].sittag = "tag_driver";
positions[ 1 ].sittag = "tag_passenger";
positions[ 2 ].sittag = "tag_gunner";
positions[ 0 ].idle[ 0 ] = %london_utilitytruck_driver_idle;
positions[ 0 ].idle[ 1 ] = %london_utilitytruck_driver_idle_bumpy;
positions[ 0 ].idle[ 2 ] = %london_utilitytruck_driver_flinch;
positions[ 0 ].idle[ 3 ] = %london_utilitytruck_driver_quickturnL;
positions[ 0 ].idle[ 4 ] = %london_utilitytruck_driver_quickturnR;
positions[ 0 ].idleoccurrence[ 0 ] = 450;
positions[ 0 ].idleoccurrence[ 1 ] = 100;
positions[ 0 ].idleoccurrence[ 2 ] = 100;
positions[ 0 ].idleoccurrence[ 3 ] = 100;
positions[ 0 ].idleoccurrence[ 4 ] = 100;
positions[ 1 ].idle[ 0 ] = %london_utilitytruck_passenger_idle_bumpy;
positions[ 1 ].idle[ 1 ] = %london_utilitytruck_passenger_idle_bumpy;
positions[ 1 ].idleoccurrence[ 0 ] = 100;
positions[ 1 ].idleoccurrence[ 1 ] = 100;
positions[ 0 ].getin = %london_utilitytruck_driver_mount;
positions[ 1 ].getin = %london_utilitytruck_passenger_mount;
positions[ 2 ].getin = %london_utilitytruck_gunner_mount;
positions[ 0 ].getout = %uaz_passenger_exit_into_stand;
positions[ 1 ].getout = %uaz_driver_exit_into_stand;
positions[ 0 ].death = %UAZ_driver_death;
positions[ 1 ].death = %UAZ_rear_driver_death;
positions[ 0 ].death_no_ragdoll = true;
positions[ 1 ].death_no_ragdoll = true;
positions[ 0 ].bHasGunWhileRiding = false;
positions[ 1 ].bHasGunWhileRiding = false;
return positions;
}


 

 

 

 

 


 


