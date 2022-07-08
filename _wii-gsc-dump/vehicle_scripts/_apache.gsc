#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "apache", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_apache" );
build_deathmodel( "vehicle_apache_streamed" );
build_deathmodel( "vehicle_apache_dark" );
apache_death_fx = [];
apache_death_fx[ "vehicle_apache" ] = "explosions/helicopter_explosion_apache";
apache_death_fx[ "vehicle_apache_streamed" ] = "explosions/helicopter_explosion_apache";
apache_death_fx[ "vehicle_apache_dark" ] = "explosions/helicopter_explosion_apache_dark";
apache_aerial_death_fx = [];
apache_aerial_death_fx[ "vehicle_apache" ] = "explosions/aerial_explosion_apache_mp";
apache_aerial_death_fx[ "vehicle_apache_streamed" ] = "explosions/aerial_explosion_apache_mp";
apache_aerial_death_fx[ "vehicle_apache_dark" ] = "explosions/aerial_explosion_apache_dark_mp";
apache_aerial_death_fx[ "script_vehicle_apache" ] = "explosions/aerial_explosion_apache_mp";
apache_aerial_death_fx[ "script_vehicle_apache_dark" ] = "explosions/aerial_explosion_apache_dark_mp";
apache_aerial_death_fx[ "script_vehicle_apache_mg" ] = "explosions/aerial_explosion_apache_mp";
build_drive( %bh_rotors, undefined, 0 );
build_deathfx( "explosions/helicopter_explosion_secondary_small", "tag_engine_left", "apache_helicopter_secondary_exp", undefined, undefined, undefined, 0.0, true );
build_deathfx( "fire/fire_smoke_trail_L", "tag_engine_left", "apache_helicopter_dying_loop", true, 0.05, true, 0.5, true );
build_deathfx( "explosions/helicopter_explosion_secondary_small",	"tag_engine_left", "apache_helicopter_secondary_exp", undefined, undefined, undefined, 2.5, true );
build_deathfx( apache_death_fx[ model ], undefined, "apache_helicopter_crash", undefined, undefined, undefined, - 1, undefined, "stop_crash_loop_sound" );
build_rocket_deathfx( apache_aerial_death_fx[ model ], "tag_deathfx", "apache_helicopter_crash",	undefined, undefined, undefined, undefined, true, undefined, 0, 5 );
lightmodel = get_light_model( model, classname );
build_light( lightmodel, "wingtip_green", "tag_light_L_wing", "misc/aircraft_light_wingtip_green", "running", 0 );
build_light( lightmodel, "wingtip_red", "tag_light_R_wing", "misc/aircraft_light_wingtip_red", "running", 0.05 );
build_light( lightmodel, "white_blink", "tag_light_belly", "misc/aircraft_light_white_blink", "running", 0.1 );
build_light( lightmodel, "white_blink_tail", "tag_light_tail", "misc/aircraft_light_red_blink", "running", 0.25 );
build_life( 999, 500, 1500 );
build_treadfx();
build_team( "allies" );
if ( isdefined(classname) && IsSubStr( classname, "_mg" ) )
{
if( IsSubStr( classname, "_streamed" ) )
{
build_turret( "apache_turret", "tag_turret", "vehicle_apache_mg_streamed", undefined, "auto_nonai", 0.0, 20, -14 );
}
else
{
build_turret( "apache_turret", "tag_turret", "vehicle_apache_mg", undefined, "auto_nonai", 0.0, 20, -14 );
}
}
if( !IsSubStr( classname, "_berlin" ) )
{
precacheitem( "zippy_rockets_apache" );
PreCacheItem( "zippy_rockets_apache_nodamage" );
}
}
init_local()
{
self.script_badplace = false;
maps\_vehicle::lights_on( "running" );
if ( IsSubStr( self.classname, "_mg" ) )
{
self HidePart( "turret_animate_jnt" );
self HidePart( "tag_turret" );
self HidePart( "tag_barrel" );
self HidePart( "barrel_animate_jnt" );
}
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












