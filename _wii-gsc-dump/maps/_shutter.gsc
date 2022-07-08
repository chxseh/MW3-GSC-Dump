#include maps\_utility;
#include common_scripts\utility;
main()
{
if ( !isdefined( level.windStrength ) )
level.windStrength = 0.2;
level.animRate[ "awning" ] = 1.0;
level.animRate[ "palm" ] = 1.0;
level.animWeightMin = ( level.windStrength - 0.5 );
level.animWeightMax = ( level.windStrength + 0.2 );
if ( level.animWeightMin < 0.1 )
level.animWeightMin = 0.1;
if ( level.animWeightMax > 1.0 )
level.animWeightMax = 1.0;
level.inc = 0;
awningAnims();
palmTree_anims();
thread new_style_shutters();
array_levelthread( GetEntArray( "wire", "targetname" ), ::wireWander );
array_levelthread( GetEntArray( "awning", "targetname" ), ::awningWander );
array_levelthread( GetEntArray( "palm", "targetname" ), ::palmTrees );
leftShutters = [];
array = GetEntArray( "shutter_left", "targetname" );
leftShutters = array_combine( leftShutters, array );
array = GetEntArray( "shutter_right_open", "targetname" );
leftShutters = array_combine( leftShutters, array );
array = GetEntArray( "shutter_left_closed", "targetname" );
leftShutters = array_combine( leftShutters, array );
foreach ( shutter in leftShutters )
shutter AddYaw( 180 );
rightShutters = [];
array = GetEntArray( "shutter_right", "targetname" );
rightShutters = array_combine( rightShutters, array );
array = GetEntArray( "shutter_left_open", "targetname" );
rightShutters = array_combine( rightShutters, array );
array = GetEntArray( "shutter_right_closed", "targetname" );
rightShutters = array_combine( rightShutters, array );
wait( 0.05 );
array = array_combine( leftShutters, rightShutters );
foreach ( shutter in array )
{
shutter thread shutterSound();
shutter.startYaw = shutter.angles[ 1 ];
}
array = undefined;
windDirection = "left";
level endon( "stop_shutters" );
for ( ;; )
{
array_levelthread( leftShutters, ::shutterWanderLeft, windDirection );
array_levelthread( rightShutters, ::shutterWanderRight, windDirection );
level waittill( "wind blows", windDirection );
}
}
windController()
{
for ( ;; )
{
windDirection = "left";
if ( RandomInt( 100 ) > 50 )
windDirection = "right";
level notify( "wind blows", windDirection );
wait( 2 + RandomFloat( 10 ) );
}
}
new_style_shutters()
{
shutters = getentarray( "shutter", "targetname" );
foreach ( shutter in shutters )
{
target_ent = getent( shutter.target, "targetname" );
pivot = spawn( "script_origin", shutter.origin );
pivot.angles = target_ent.angles;
pivot.startYaw = pivot.angles[ 1 ];
shutter.pivot = pivot;
shutter linkto( pivot );
pivot addyaw( randomfloatrange( -90, 90 ) );
shutter thread shutterSound();
}
level endon( "stop_shutters" );
windDirection = "left";
for ( ;; )
{
array_levelthread( shutters, ::shutterWander, windDirection );
level waittill( "wind blows", windDirection );
}
}
shutterWander( shutter, windDirection )
{
level endon( "stop_shutters" );
level endon( "wind blows" );
pivot = shutter.pivot;
next_swap = randomint( 3 ) + 1;
modifier = 1;
if ( coinToss() )
modifier *= -1;
max_right_angle = 80;
max_left_angle = 80;
if ( isdefined( shutter.script_max_left_angle ) )
max_left_angle = shutter.script_max_left_angle;
if ( isdefined( shutter.script_max_right_angle ) )
max_right_angle = shutter.script_max_right_angle;
for ( ;; )
{
shutter notify( "shutterSound" );
rot = RandomIntRange( 50, 80 );
next_swap--;
if ( !next_swap )
{
next_swap = randomint( 3 ) + 1;
modifier *= -1;
}
rot *= modifier;
if ( modifier > 0 )
{
if ( rot > max_right_angle )
rot = max_right_angle;
}
else
{
if ( rot > max_left_angle )
rot = max_left_angle;
}
dest_yaw = pivot.startYaw + rot;
dif = abs( pivot.angles[ 1 ] - dest_yaw );
newTime = dif * 0.05 + RandomFloat( 1 ) + 0.25;
if ( newTime < 0.25 )
newTime = 0.25;
pivot RotateTo( ( 0, dest_yaw, 0 ), newTime, newTime * 0.5, newTime * 0.5 );
wait( newTime );
}
}
shutterWanderLeft( shutter, windDirection )
{
level endon( "stop_shutters" );
level.inc++;
level endon( "wind blows" );
newYaw = shutter.startYaw;
if ( windDirection == "left" )
newYaw += 179.9;
newTime = 0.2;
shutter RotateTo( ( shutter.angles[ 0 ], newYaw, shutter.angles[ 2 ] ), newTime );
wait( newTime + 0.1 );
for ( ;; )
{
shutter notify( "shutterSound" );
rot = RandomInt( 80 );
if ( coinToss() )
rot *= -1;
newYaw = shutter.angles[ 1 ] + rot;
altYaw = shutter.angles[ 1 ] + ( rot * -1 );
if ( ( newYaw < shutter.startYaw ) || ( newYaw > shutter.startYaw + 179 ) )
{
newYaw = altYaw;
}
dif = abs( shutter.angles[ 1 ] - newYaw );
newTime = dif * 0.02 + RandomFloat( 2 );
if ( newTime < 0.3 )
newTime = 0.3;
shutter RotateTo( ( shutter.angles[ 0 ], newYaw, shutter.angles[ 2 ] ), newTime, newTime * 0.5, newTime * 0.5 );
wait( newTime );
}
}
shutterWanderRight( shutter, windDirection )
{
level endon( "stop_shutters" );
level.inc++;
level endon( "wind blows" );
newYaw = shutter.startYaw;
if ( windDirection == "left" )
newYaw += 179.9;
newTime = 0.2;
shutter RotateTo( ( shutter.angles[ 0 ], newYaw, shutter.angles[ 2 ] ), newTime );
wait( newTime + 0.1 );
for ( ;; )
{
shutter notify( "shutterSound" );
rot = RandomInt( 80 );
if ( RandomInt( 100 ) > 50 )
rot *= -1;
newYaw = shutter.angles[ 1 ] + rot;
altYaw = shutter.angles[ 1 ] + ( rot * -1 );
if ( ( newYaw < shutter.startYaw ) || ( newYaw > shutter.startYaw + 179 ) )
{
newYaw = altYaw;
}
dif = abs( shutter.angles[ 1 ] - newYaw );
newTime = dif * 0.02 + RandomFloat( 2 );
if ( newTime < 0.3 )
newTime = 0.3;
shutter RotateTo( ( shutter.angles[ 0 ], newYaw, shutter.angles[ 2 ] ), newTime, newTime * 0.5, newTime * 0.5 );
wait( newTime );
}
}
shutterSound()
{
for ( ;; )
{
self waittill( "shutterSound" );
self waittill( "sounddone" );
wait( RandomFloat( 2 ) );
}
}
wireWander( wire )
{
origins = GetEntArray( wire.target, "targetname" );
org1 = origins[ 0 ].origin;
org2 = origins[ 1 ].origin;
angles = VectorToAngles( org1 - org2 );
ent = Spawn( "script_model", ( 0, 0, 0 ) );
ent.origin = ( org1 * 0.5 ) + ( org2 * 0.5 );
ent.angles = angles;
wire LinkTo( ent );
rottimer = 2;
rotrange = 0.9;
dist = 4 + RandomFloat( 2 );
ent RotateRoll( dist * 0.5, 0.2 );
wait( 0.2 );
for ( ;; )
{
rottime = rottimer + RandomFloat( rotRange ) - ( rotRange * 0.5 );
ent RotateRoll( dist, rottime, rottime * 0.5, rottime * 0.5 );
wait( rottime );
ent RotateRoll( dist * -1, rottime, rottime * 0.5, rottime * 0.5 );
wait( rottime );
}
}
#using_animtree( "desert_props" );
awningAnims()
{
}
awningWander( ent )
{
}
#using_animtree( "animated_props" );
palmTree_anims()
{
return;
}
palmTrees( ent )
{
ent UseAnimTree( #animtree );
switch( ent.model )
{
case "tree_desertpalm01":
ent.animname = "tree_desertpalm01";
break;
case "tree_desertpalm02":
ent.animname = "tree_desertpalm02";
break;
case "tree_desertpalm03":
ent.animname = "tree_desertpalm03";
break;
}
if ( !isdefined( ent.animname ) )
return;
wait RandomFloat( 2 );
for ( ;; )
{
fWeight = ( level.animWeightMin + RandomFloat( ( level.animWeightMax - level.animWeightMin ) ) );
fLength = 4;
ent SetAnim( level.scr_anim[ ent.animname ][ "wind" ][ 0 ], fWeight, fLength, level.animRate[ "palm" ] );
ent SetAnim( level.scr_anim[ ent.animname ][ "wind" ][ 1 ], 1 - fWeight, fLength, level.animRate[ "palm" ] );
wait( 1 + RandomFloat( 3 ) );
}
}