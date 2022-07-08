#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include common_scripts\utility;
#include maps\_utility;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "hovercraft", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "vehicle_hovercraft" );
build_deathmodel( "vehicle_hovercraft_streamed" );
build_drive( %hovercraft_movement, undefined, 0);
build_life( 999, 500, 1500 );
build_team( "allies" );
level._effect[ "hovercraft_cheap_water" ] = loadfx( "treadfx/hovercraft_cheap" );
}
init_local()
{
self.dontdisconnectpaths = true;
thread hovercraft_treadfx();
}
set_vehicle_anims( positions )
{
return positions;
}
hovercraft_treadfx()
{
chaser = spawn_tag_origin();
chaser.angles = ( 0, self.angles[ 1 ], 0 );
chaser thread hovercraft_treadfx_chaser( self );
}
HOVERCRAFT_TREADFX_MOVETIME = 1.5;
HOVERCRAFT_TREADFX_MOVETIMEFRACTION = 1 / ( HOVERCRAFT_TREADFX_MOVETIME + .05 );
HOVERCRAFT_TREADFX_HEIGHTOFFSET = ( 0, 0, 16 );
CHEAP_WATER_SPLASH_DISTANCE = 64000000;
hovercraft_treadfx_chaser( chaseobj )
{
self.origin = chaseobj tag_project( "tag_origin" , -10000 );
wait 0.1;
PlayFXOnTag( getfx( "hovercraft_cheap_water" ), self, "tag_origin" );
self NotSolid();
self Hide();
rot_angle = ( 0, chaseobj.angles[ 1 ], 0 );
while ( IsAlive( chaseobj ) )
{
last_org = chaseobj.origin;
self MoveTo( chaseobj GetTagOrigin( "tag_origin" ) + HOVERCRAFT_TREADFX_HEIGHTOFFSET + ( chaseobj Vehicle_GetVelocity() / HOVERCRAFT_TREADFX_MOVETIMEFRACTION ), HOVERCRAFT_TREADFX_MOVETIME );
self RotateTo( rot_angle, HOVERCRAFT_TREADFX_MOVETIME ) ;
wait HOVERCRAFT_TREADFX_MOVETIME + .05;
waittillframeend;
if( IsAlive (chaseobj ) )
{
move_vect = ( chaseobj.origin - last_org);
rot_angle = flat_angle( VectorToAngles( move_vect ) );
}
}
self Delete();
}







