#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "mi28", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_mi-28_flying" );
build_deathmodel( "vehicle_mi-28_flying_low" );
build_drive( %mi28_rotors, undefined, 0, 3.0 );
build_deathfx( "explosions/helicopter_explosion_secondary_small", "tag_engine_left", "havoc_helicopter_secondary_exp", undefined, undefined, undefined, 0.0, true );
build_deathfx( "fire/fire_smoke_trail_L", "tag_engine_left", "havoc_helicopter_dying_loop", true, 0.05, true, 0.5, true );
build_deathfx( "explosions/helicopter_explosion_secondary_small",	"tag_engine_right", "havoc_helicopter_secondary_exp", undefined, undefined, undefined, 2.5, true );
build_deathfx( "explosions/helicopter_explosion_mi28_flying", undefined, "havoc_helicopter_crash", undefined, undefined,	undefined, - 1, undefined, "stop_crash_loop_sound" );
build_rocket_deathfx( "explosions/aerial_explosion_mi28_flying", "tag_deathfx", "havoc_helicopter_crash",	undefined, undefined, undefined, undefined, true, undefined, 0 );
build_deathquake( 0.8, 1.6, 2048 );
build_treadfx();
build_life( 799 );
build_team( "allies" );
build_mainturret();
build_aianims( ::setanims, ::set_vehicle_anims );
randomStartDelay = randomfloatrange( 0, 1 );
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "wingtip_green", "tag_light_L_wing", "misc/aircraft_light_wingtip_green", "running", randomStartDelay );
build_light( lightmodel, "wingtip_red", "tag_light_R_wing", "misc/aircraft_light_wingtip_red", "running", randomStartDelay );
build_light( lightmodel, "white_blink", "tag_light_belly", "misc/aircraft_light_white_blink", "running", randomStartDelay );
build_light( lightmodel, "white_blink_tail", "tag_light_tail", "misc/aircraft_light_red_blink", "running", randomStartDelay );
}
init_local()
{
self.script_badplace = false;
maps\_vehicle::lights_on( "running" );
}
set_vehicle_anims( positions )
{
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 2;i++ )
positions[ i ] = spawnstruct();
positions[ 0 ].sittag = "tag_pilot";
positions[ 1 ].sittag = "tag_gunner";
positions[ 0 ].idle[ 0 ] = %helicopter_pilot1_idle;
positions[ 0 ].idle[ 1 ] = %helicopter_pilot1_twitch_clickpannel;
positions[ 0 ].idle[ 2 ] = %helicopter_pilot1_twitch_lookback;
positions[ 0 ].idle[ 3 ] = %helicopter_pilot1_twitch_lookoutside;
positions[ 0 ].idleoccurrence[ 0 ] = 500;
positions[ 0 ].idleoccurrence[ 1 ] = 100;
positions[ 0 ].idleoccurrence[ 2 ] = 100;
positions[ 0 ].idleoccurrence[ 3 ] = 100;
positions[ 1 ].idle[ 0 ] = %helicopter_pilot2_idle;
positions[ 1 ].idle[ 1 ] = %helicopter_pilot2_twitch_clickpannel;
positions[ 1 ].idle[ 2 ] = %helicopter_pilot2_twitch_lookoutside;
positions[ 1 ].idle[ 3 ] = %helicopter_pilot2_twitch_radio;
positions[ 1 ].idleoccurrence[ 0 ] = 450;
positions[ 1 ].idleoccurrence[ 1 ] = 100;
positions[ 1 ].idleoccurrence[ 2 ] = 100;
positions[ 1 ].idleoccurrence[ 3 ] = 100;
positions[ 0 ].bHasGunWhileRiding = false;
positions[ 1 ].bHasGunWhileRiding = false;
return positions;
}




