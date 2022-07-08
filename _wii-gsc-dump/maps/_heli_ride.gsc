#include maps\_utility;
#include maps\_hud_util;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include maps\_loadout;
ride_setup( startnode, players_array )
{
godon();
getout_rigspawn( getanimatemodel(), 3 );
if ( !isdefined( players_array ) )
players_array = level.players;
foreach ( player in players_array )
thread attach_player( player, 3 );
speed = 95;
if ( isdefined( startnode.speed ) )
{
speed = startnode.speed;
}
self setairresistance( 30 );
self Vehicle_SetSpeed( speed, 40, level.heli_default_decel );
vehicle_paths( startnode );
}
attach_player( player, position, animfudgetime )
{
player thread player_in_heli( self );
if ( getdvar( "fastrope_arms" ) == "" )
setdvar( "fastrope_arms", "0" );
if ( !isdefined( animfudgetime ) )
animfudgetime = 0;
assert( isdefined( self.riders ) );
assert( self.riders.size );
guy = undefined;
for ( i = 0; i < self.riders.size; i++ )
{
if ( self.riders[ i ].vehicle_position == position )
{
guy = self.riders[ i ];
guy.drone_delete_on_unload = true;
guy.playerpiggyback = true;
break;
}
}
assertex( !isai( guy ), "guy in position of player needs to have script_drone set, use script_startingposition ans script drone in your map" );
assert( isdefined( guy ) );
animpos = maps\_vehicle_aianim::anim_pos( self, position );
guy notify( "newanim" );
guy detachall();
guy setmodel( "fastrope_arms" );
guy useanimtree( animpos.player_animtree );
thread maps\_vehicle_aianim::guy_idle( guy, position );
wait .1;
if( isdefined( level.little_bird ) )
player playerlinkto( guy, "tag_player", 0.35, 120, 28, 30, 30, false );
else
player playerlinkto( guy, "tag_player", 0.35, 60, 28, 30, 30, false );
player freezecontrols( false );
guy hide();
animtime = getanimlength( animpos.getout );
animtime -= animfudgetime;
self waittill( "unloading" );
if ( getdvar( "fastrope_arms" ) != "0" )
guy show();
player disableweapons();
wait animtime;
player unlink();
player enableweapons();
setSavedDvar( "hud_drawhud", "1" );
level notify( "stop_draw_hud_on_death" );
}
player_in_heli( heli )
{
setsavedDvar( "g_friendlyNameDist", 0 );
setsavedDvar( "g_friendlyfireDist", 0 );
self hide_player_model();
self allowsprint( false );
self allowprone( false );
self allowstand( false );
self EnableInvulnerability();
self.ignoreme = true;
wait .05;
self setplayerangles( ( 0, 35, 0 ) );
heli waittill( "unloading" );
self notify( "stop_quake" );
wait 6;
autosave_by_name( "on_the_ground" );
self allowprone( false );
self allowstand( true );
self allowcrouch( false );
wait .05;
self allowprone( true );
self allowcrouch( true );
self DisableInvulnerability();
self.ignoreme = false;
self allowsprint( true );
wait 4;
self show_player_model();
if ( self == level.player )
{
for ( i = 0;i < 24;i++ )
{
self setOrigin( self.origin + ( 2, 0, 0 ) );
wait 0.05;
}
}
setsavedDvar( "g_friendlyNameDist", 15000 );
setsavedDvar( "g_friendlyfireDist", 128 );
}
#using_animtree( "vehicles" );
player_heli_ropeanimoverride_idle( guy, tag, animation )
{
self endon( "unloading" );
while ( 1 )
maps\_vehicle_aianim::animontag( guy, tag, animation );
}
ride_start( optional_players_array, optional_max_riders )
{
targetname = "heli_ride_in";
pathstart = getentarray( targetname, "targetname" );
assertEx( pathstart.size <= 1, "too many script_origins with targetname \"" + targetname + "\" " );
if ( !pathstart.size )
{
pathstart = getstructarray( "heli_ride_in", "targetname" );
assertEx( pathstart.size <= 1, "too many script_structs with targetname \"heli_ride_in\" " );
if ( !pathstart.size )
assertMSG( "no helicopter paths with \"heli_ride_in\", can't start ride" );
}
pathstart = pathstart[ 0 ];
assertex( isdefined( level.gag_heliride_spawner ), "can't find heliride spawner. sure you placed the prefab?" );
if ( isdefined( optional_max_riders ) )
vehicle_spawn_group_limit_riders( level.gag_heliride_spawner.script_vehicleride, optional_max_riders );
vehicle = vehicle_spawn( level.gag_heliride_spawner );
vehicle thread ride_setup( pathstart, optional_players_array );
return vehicle;
}