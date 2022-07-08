#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_utility;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "m1a1", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_m1a1_abrams_viewmodel", "vehicle_m1a1_abrams_minigun_destroy", undefined, "script_vehicle_m1a1_abrams_minigun" );
build_deathmodel( "vehicle_m1a1_abrams_minigun", "vehicle_m1a1_abrams_minigun_destroy", undefined, "script_vehicle_m1a1_abrams_minigun" );
build_deathmodel( "vehicle_m1a1_abrams_viewmodel", "vehicle_m1a1_abrams_minigun_destroy", undefined, "script_vehicle_m1a1_abrams_player_tm" );
build_shoot_shock( "tankblast" );
build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
build_exhaust( "distortion/abrams_exhaust" );
build_deckdust( "dust/abrams_deck_dust" );
build_deathfx( "explosions/vehicle_explosion_m1a1", "tag_deathfx", "exp_armor_vehicle", undefined, undefined, undefined, 0, undefined, undefined, undefined, 10 );
build_Turret( "m1a1_coaxial_mg", "tag_coax_mg", "vehicle_m1a1_abrams_PKT_Coaxial_MG_woodland", undefined, undefined, undefined, 0, 0 );
build_turret( "minigun_m1a1", "tag_turret_mg_r", "weapon_m1a1_minigun", undefined, "sentry", undefined, 0, 0 );
build_treadfx();
build_life( 999, 500, 1500 );
build_rumble( "tank_rumble", 0.15, 4.5, 900, 1, 1 );
build_team( "allies" );
build_mainturret();
build_aianims( ::setanims, ::set_vehicle_anims );
build_frontarmor( .33 );
}
init_local()
{
waittillframeend;
foreach( rider in self.riders )
{
rider thread magic_bullet_shield( true );
}
}
#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
this_position = 0;
positions[ this_position ].vehicle_turret_fire = %abrams_loader_shell;
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
this_position = 0;
position = spawnstruct();
position.idle = %hamburg_tank_loader_afterfall_loop;
position.turret_fire = %abrams_loader_load;
position.turret_fire_tag = "tag_guy1";
position.sittag = "tag_guy0";
positions[ this_position ] = position;
this_position = 1;
position = spawnstruct();
position.idle = %hamburg_tank_driver_afterfall_loop;
position.sittag = "tag_guy0";
positions[ this_position ] = position;
this_position = 2;
position = spawnstruct();
position.mgturret = 1;
position.passenger_2_turret_func = ::humvee_turret_guy_gettin_func;
position.sittag = "tag_turret_mg_r";
position.sittag_offset = (0,0,-40);
positions[ this_position ] = position;
return positions;
}
humvee_turret_guy_gettin_func( vehicle, guy, pos, turret )
{
animation = %humvee_passenger_2_turret;
guy animscripts\hummer_turret\common::guy_goes_directly_to_turret( vehicle, pos, turret, animation );
}









