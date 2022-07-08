#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname, turret_info )
{
build_template( "super_dvora", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_russian_super_dvora_mark2" );
build_life( 999, 500, 1500 );
build_team( "axis" );
if (isdefined(turret_info))
{
turret_model = "weapon_m2_50cal_dshkVersion";
build_turret( turret_info, "tag_turret", turret_model, undefined, "auto_ai", 0.5, 20, -14 );
build_turret( turret_info, "tag_turret2", turret_model, undefined, "auto_ai", 0.5, 20, -14 );
}
build_aianims( ::setanims, ::set_vehicle_anims );
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0; i < 4; i++ )
positions[ i ] = SpawnStruct();
positions[ 0 ].sittag = "tag_guy";
positions[ 1 ].sittag = "tag_guy2";
positions[ 2 ].sittag = "tag_guy3";
positions[ 3 ].sittag = "tag_guy4";
positions[ 0 ].unload_ondeath = .9;
positions[ 1 ].unload_ondeath = .9;
positions[ 2 ].unload_ondeath = .9;
positions[ 3 ].unload_ondeath = .9;
positions[ 3 ].getout = %technical_driver_climb_out;
positions[ 2 ].getout = %technical_passenger_climb_out;
positions[ 0 ].mgturret = 0;
positions[ 1 ].mgturret = 1;
return positions;
}
set_vehicle_anims( positions )
{
return positions;
}
init_local()
{
}







