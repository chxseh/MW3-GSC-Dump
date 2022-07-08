#include maps\_utility;
#include common_scripts\utility;
debugchains()
{
nodes = GetAllNodes();
fnodenum = 0;
fnodes = [];
for ( i = 0; i < nodes.size; i++ )
{
if ( ( !( nodes[ i ].spawnflags & 2 ) ) &&
(
( ( IsDefined( nodes[ i ].target ) ) && ( ( GetNodeArray( nodes[ i ].target, "targetname" ) ).size > 0 ) ) ||
( ( IsDefined( nodes[ i ].targetname ) ) && ( ( GetNodeArray( nodes[ i ].targetname, "target" ) ).size > 0 ) )
)
)
{
fnodes[ fnodenum ] = nodes[ i ];
fnodenum++;
}
}
count = 0;
while ( 1 )
{
if ( GetDvar( "chain" ) == "1" )
{
for ( i = 0; i < fnodes.size; i++ )
{
if ( Distance( level.player GetOrigin(), fnodes[ i ].origin ) < 1500 )
{
Print3d( fnodes[ i ].origin, "yo", ( 0.2, 0.8, 0.5 ), 0.45 );
}
}
friends = GetAIArray( "allies" );
for ( i = 0; i < friends.size; i++ )
{
node = friends[ i ] animscripts\utility::GetClaimedNode();
if ( IsDefined( node ) )
Line( friends[ i ].origin + ( 0, 0, 35 ), node.origin, ( 0.2, 0.5, 0.8 ), 0.5 );
}
}
waitframe();
}
}
debug_enemyPos( num )
{
ai = GetAIArray();
for ( i = 0; i < ai.size; i++ )
{
if ( ai[ i ] GetEntityNumber() != num )
continue;
ai[ i ] thread debug_enemyPosProc();
break;
}
}
debug_stopEnemyPos( num )
{
ai = GetAIArray();
for ( i = 0; i < ai.size; i++ )
{
if ( ai[ i ] GetEntityNumber() != num )
continue;
ai[ i ] notify( "stop_drawing_enemy_pos" );
break;
}
}
debug_enemyPosProc()
{
self endon( "death" );
self endon( "stop_drawing_enemy_pos" );
for ( ;; )
{
wait( 0.05 );
if ( IsAlive( self.enemy ) )
Line( self.origin + ( 0, 0, 70 ), self.enemy.origin + ( 0, 0, 70 ), ( 0.8, 0.2, 0.0 ), 0.5 );
if ( !self animscripts\utility::hasEnemySightPos() )
continue;
pos = animscripts\utility::getEnemySightPos();
Line( self.origin + ( 0, 0, 70 ), pos, ( 0.9, 0.5, 0.3 ), 0.5 );
}
}
debug_enemyPosReplay()
{
ai = GetAIArray();
guy = undefined;
for ( i = 0; i < ai.size; i++ )
{
guy = ai[ i ];
if ( !isalive( guy ) )
continue;
if ( IsDefined( guy.lastEnemySightPos ) )
Line( guy.origin + ( 0, 0, 65 ), guy.lastEnemySightPos, ( 1, 0, 1 ), 0.5 );
if ( IsDefined( guy.goodShootPos ) )
{
if ( guy IsBadGuy() )
color = ( 1, 0, 0 );
else
color = ( 0, 0, 1 );
nodeOffset = guy.origin + ( 0, 0, 54 );
if ( IsDefined( guy.node ) )
{
if ( guy.node.type == "Cover Left" )
{
cornerNode = true;
nodeOffset = AnglesToRight( guy.node.angles );
nodeOffset *=( -32 );
nodeOffset = ( nodeOffset[ 0 ], nodeOffset[ 1 ], 64 );
nodeOffset = guy.node.origin + nodeOffset;
}
else
if ( guy.node.type == "Cover Right" )
{
cornerNode = true;
nodeOffset = AnglesToRight( guy.node.angles );
nodeOffset *= ( 32 );
nodeOffset = ( nodeOffset[ 0 ], nodeOffset[ 1 ], 64 );
nodeOffset = guy.node.origin + nodeOffset;
}
}
draw_arrow( nodeOffset, guy.goodShootPos, color );
}
}
if ( 1 ) return;
if ( !isalive( guy ) )
return;
if ( IsAlive( guy.enemy ) )
Line( guy.origin + ( 0, 0, 70 ), guy.enemy.origin + ( 0, 0, 70 ), ( 0.6, 0.2, 0.2 ), 0.5 );
if ( IsDefined( guy.lastEnemySightPos ) )
Line( guy.origin + ( 0, 0, 65 ), guy.lastEnemySightPos, ( 0, 0, 1 ), 0.5 );
if ( IsAlive( guy.goodEnemy ) )
Line( guy.origin + ( 0, 0, 50 ), guy.goodEnemy.origin, ( 1, 0, 0 ), 0.5 );
if ( !guy animscripts\utility::hasEnemySightPos() )
return;
pos = guy animscripts\utility::getEnemySightPos();
Line( guy.origin + ( 0, 0, 55 ), pos, ( 0.2, 0.2, 0.6 ), 0.5 );
if ( IsDefined( guy.goodShootPos ) )
Line( guy.origin + ( 0, 0, 45 ), guy.goodShootPos, ( 0.2, 0.6, 0.2 ), 0.5 );
}
drawEntTag( num )
{
}
drawTag( tag, opcolor, drawtime )
{
org = self GetTagOrigin( tag );
ang = self GetTagAngles( tag );
drawArrow( org, ang, opcolor, drawtime );
}
drawOrgForever( opcolor )
{
org = undefined;
ang = undefined;
for ( ;; )
{
if ( IsDefined( self ) )
{
org = self.origin;
ang = self.angles;
}
drawArrow( org, ang, opcolor );
wait( 0.05 );
}
}
drawArrowForever( org, ang )
{
for ( ;; )
{
drawArrow( org, ang );
wait( 0.05 );
}
}
drawOriginForever()
{
while ( IsDefined( self ) )
{
drawArrow( self.origin, self.angles );
wait( 0.05 );
}
}
drawArrow( org, ang, opcolor, drawtime )
{
scale = 10;
forward = AnglesToForward( ang );
forwardFar = ( forward * scale );
forwardClose = ( forward * ( scale * 0.8 ) );
right = AnglesToRight( ang );
leftdraw = ( right * ( scale * -0.2 ) );
rightdraw = ( right * ( scale * 0.2 ) );
up = AnglesToUp( ang );
right = ( right * scale );
up = ( up * scale );
red = ( 0.9, 0.2, 0.2 );
green = ( 0.2, 0.9, 0.2 );
blue = ( 0.2, 0.2, 0.9 );
if ( IsDefined( opcolor ) )
{
red = opcolor;
green = opcolor;
blue = opcolor;
}
if ( !isdefined( drawtime ) )
drawtime = 1;
Line( org, org + forwardFar, red, 0.9, 0, drawtime );
Line( org + forwardFar, org + forwardClose + rightdraw, red, 0.9, 0, drawtime );
Line( org + forwardFar, org + forwardClose + leftdraw, red, 0.9, 0, drawtime );
Line( org, org + right, blue, 0.9, 0, drawtime );
Line( org, org + up, green, 0.9, 0, drawtime );
}
drawForwardForever( scale, color )
{
if ( !isdefined( scale ) )
scale = 100;
if ( !isdefined( color ) )
color = ( 0, 1, 0 );
for ( ;; )
{
if ( !isdefined( self ) )
return;
forward = AnglesToForward( self.angles );
Line( self.origin, self.origin + forward * scale, color );
wait( 0.05 );
}
}
drawPlayerViewForever()
{
for ( ;; )
{
drawArrow( level.player.origin, level.player GetPlayerAngles(), ( 1, 1, 1 ) );
wait( 0.05 );
}
}
drawTagForever( tag, opcolor )
{
for ( ;; )
{
if ( !isdefined( self ) )
return;
drawTag( tag, opcolor );
wait( 0.05 );
}
}
drawTagTrails( tag, opcolor )
{
for ( ;; )
{
if ( !isdefined( self.origin ) )
break;
drawTag( tag, opcolor, 1000 );
wait( 0.05 );
}
}
dragTagUntilDeath( tag, opcolor )
{
self endon( "death" );
for ( ;; )
{
if ( !isdefined( self ) )
break;
if ( !isdefined( self.origin ) )
break;
drawTag( tag, opcolor );
wait( 0.05 );
}
}
viewTag( type, tag )
{
if ( type == "ai" )
{
ai = GetAIArray();
for ( i = 0; i < ai.size; i++ )
ai[ i ] drawTag( tag );
}
}
debug_corner()
{
level.player.ignoreme = true;
nodes = GetAllNodes();
corners = [];
for ( i = 0; i < nodes.size; i++ )
{
if ( nodes[ i ].type == "Cover Left" )
corners[ corners.size ] = nodes[ i ];
if ( nodes[ i ].type == "Cover Right" )
corners[ corners.size ] = nodes[ i ];
}
ai = GetAIArray();
for ( i = 0; i < ai.size; i++ )
ai[ i ] Delete();
level.debugspawners = GetSpawnerArray();
level.activeNodes = [];
level.completedNodes = [];
for ( i = 0; i < level.debugspawners.size; i++ )
level.debugspawners[ i ].targetname = "blah";
covered = 0;
for ( i = 0; i < 30; i++ )
{
if ( i >= corners.size )
break;
corners[ i ] thread coverTest();
covered++;
}
if ( corners.size <= 30 )
return;
for ( ;; )
{
level waittill( "debug_next_corner" );
if ( covered >= corners.size )
covered = 0;
corners[ covered ] thread coverTest();
covered++;
}
}
coverTest()
{
coverSetupAnim();
}
#using_animtree( "generic_human" );
coverSetupAnim()
{
spawn = undefined;
spawner = undefined;
for ( ;; )
{
for ( i = 0; i < level.debugspawners.size; i++ )
{
wait( 0.05 );
spawner = level.debugspawners[ i ];
nearActive = false;
for ( p = 0; p < level.activeNodes.size; p++ )
{
if ( Distance( level.activeNodes[ p ].origin, self.origin ) > 250 )
continue;
nearActive = true;
break;
}
if ( nearActive )
continue;
completed = false;
for ( p = 0; p < level.completedNodes.size; p++ )
{
if ( level.completedNodes[ p ] != self )
continue;
completed = true;
break;
}
if ( completed )
continue;
level.activeNodes[ level.activeNodes.size ] = self;
spawner.origin = self.origin;
spawner.angles = self.angles;
spawner.count = 1;
spawn = spawner StalingradSpawn();
if ( spawn_failed( spawn ) )
{
removeActiveSpawner( self );
continue;
}
break;
}
if ( IsAlive( spawn ) )
break;
}
wait( 1 );
if ( IsAlive( spawn ) )
{
spawn.ignoreme = true;
spawn.team = "neutral";
spawn SetGoalPos( spawn.origin );
thread createLine( self.origin );
spawn thread debugorigin();
thread createLineConstantly( spawn );
spawn waittill( "death" );
}
removeActiveSpawner( self );
level.completedNodes[ level.completedNodes.size ] = self;
}
removeActiveSpawner( spawner )
{
newSpawners = [];
for ( p = 0; p < level.activeNodes.size; p++ )
{
if ( level.activeNodes[ p ] == spawner )
continue;
newSpawners[ newSpawners.size ] = level.activeNodes[ p ];
}
level.activeNodes = newSpawners;
}
createLine( org )
{
for ( ;; )
{
Line( org + ( 0, 0, 35 ), org, ( 0.2, 0.5, 0.8 ), 0.5 );
wait( 0.05 );
}
}
createLineConstantly( ent )
{
org = undefined;
while ( IsAlive( ent ) )
{
org = ent.origin;
wait( 0.05 );
}
for ( ;; )
{
Line( org + ( 0, 0, 35 ), org, ( 1.0, 0.2, 0.1 ), 0.5 );
wait( 0.05 );
}
}
debugMisstime()
{
self notify( "stopdebugmisstime" );
self endon( "stopdebugmisstime" );
self endon( "death" );
for ( ;; )
{
if ( self.a.misstime <= 0 )
Print3d( self GetTagOrigin( "TAG_EYE" ) + ( 0, 0, 15 ), "hit", ( 0.3, 1, 1 ), 1 );
else
Print3d( self GetTagOrigin( "TAG_EYE" ) + ( 0, 0, 15 ), self.a.misstime / 20, ( 0.3, 1, 1 ), 1 );
wait( 0.05 );
}
}
debugMisstimeOff()
{
self notify( "stopdebugmisstime" );
}
setEmptyDvar( dvar, setting )
{
}
debugJump( num )
{
}
debugDvars()
{
}
remove_reflection_objects()
{
}
create_reflection_objects()
{
}
create_reflection_object()
{
}
debug_reflection()
{
}
debug_reflection_buttons()
{
}
remove_fxlighting_object()
{
}
create_fxlighting_object()
{
}
play_fxlighting_fx()
{
self endon( "death" );
while ( true )
{
PlayFXOnTag( getfx( "lighting_fraction" ), self, "tag_origin" );
wait( 0.1 );
}
}
debug_fxlighting()
{
}
debug_fxlighting_buttons()
{
}
showDebugTrace()
{
startOverride = undefined;
endOverride = undefined;
startOverride = ( 15.1859, -12.2822, 4.071 );
endOverride = ( 947.2, -10918, 64.9514 );
Assert( !isdefined( level.traceEnd ) );
for ( ;; )
{
wait( 0.05 );
start = startOverride;
end = endOverride;
if ( !isdefined( startOverride ) )
start = level.traceStart;
if ( !isdefined( endOverride ) )
end = level.player GetEye();
trace = BulletTrace( start, end, false, undefined );
Line( start, trace[ "position" ], ( 0.9, 0.5, 0.8 ), 0.5 );
}
}
hatmodel()
{
}
debug_character_count_old()
{
drones = NewHudElem();
drones.alignX = "left";
drones.alignY = "middle";
drones.x = 10;
drones.y = 100;
drones.label = &"DEBUG_DRONES";
drones.alpha = 0;
allies = NewHudElem();
allies.alignX = "left";
allies.alignY = "middle";
allies.x = 10;
allies.y = 115;
allies.label = &"DEBUG_ALLIES";
allies.alpha = 0;
axis = NewHudElem();
axis.alignX = "left";
axis.alignY = "middle";
axis.x = 10;
axis.y = 130;
axis.label = &"DEBUG_AXIS";
axis.alpha = 0;
vehicles = NewHudElem();
vehicles.alignX = "left";
vehicles.alignY = "middle";
vehicles.x = 10;
vehicles.y = 145;
vehicles.label = &"DEBUG_VEHICLES";
vehicles.alpha = 0;
total = NewHudElem();
total.alignX = "left";
total.alignY = "middle";
total.x = 10;
total.y = 160;
total.label = &"DEBUG_TOTAL";
total.alpha = 0;
lastdvar = "off";
for ( ;; )
{
dvar = GetDvar( "debug_character_count" );
if ( dvar == "off" )
{
if ( dvar != lastdvar )
{
drones.alpha = 0;
allies.alpha = 0;
axis.alpha = 0;
vehicles.alpha = 0;
total.alpha = 0;
lastdvar = dvar;
}
wait .25;
continue;
}
else
{
if ( dvar != lastdvar )
{
drones.alpha = 1;
allies.alpha = 1;
axis.alpha = 1;
vehicles.alpha = 1;
total.alpha = 1;
lastdvar = dvar;
}
}
count_drones = GetEntArray( "drone", "targetname" ).size;
drones SetValue( count_drones );
count_allies = GetAIArray( "allies" ).size;
allies SetValue( count_allies );
count_axis = GetAIArray( "bad_guys" ).size;
axis SetValue( count_axis );
vehicles SetValue( GetEntArray( "script_vehicle", "classname" ).size );
total SetValue( count_drones + count_allies + count_axis );
wait 0.25;
}
}
nuke()
{
if ( !self.damageshield )
self Kill( ( 0, 0, -500 ), level.player, level.player );
}
debug_nuke()
{
}
debug_missTime()
{
}
camera()
{
wait( 0.05 );
cameras = GetEntArray( "camera", "targetname" );
for ( i = 0; i < cameras.size; i++ )
{
ent = GetEnt( cameras[ i ].target, "targetname" );
cameras[ i ].origin2 = ent.origin;
cameras[ i ].angles = VectorToAngles( ent.origin - cameras[ i ].origin );
}
for ( ;; )
{
ai = GetAIArray( "axis" );
if ( !ai.size )
{
freePlayer();
wait( 0.5 );
continue;
}
cameraWithEnemy = [];
for ( i = 0; i < cameras.size; i++ )
{
for ( p = 0; p < ai.size; p++ )
{
if ( Distance( cameras[ i ].origin, ai[ p ].origin ) > 256 )
continue;
cameraWithEnemy[ cameraWithEnemy.size ] = cameras[ i ];
break;
}
}
if ( !cameraWithEnemy.size )
{
freePlayer();
wait( 0.5 );
continue;
}
cameraWithPlayer = [];
for ( i = 0; i < cameraWithEnemy.size; i++ )
{
camera = cameraWithEnemy[ i ];
start = camera.origin2;
end = camera.origin;
difference = VectorToAngles( ( end[ 0 ], end[ 1 ], end[ 2 ] ) - ( start[ 0 ], start[ 1 ], start[ 2 ] ) );
angles = ( 0, difference[ 1 ], 0 );
forward = AnglesToForward( angles );
difference = VectorNormalize( end - level.player.origin );
dot = VectorDot( forward, difference );
if ( dot < 0.85 )
continue;
cameraWithPlayer[ cameraWithPlayer.size ] = camera;
}
if ( !cameraWithPlayer.size )
{
freePlayer();
wait( 0.5 );
continue;
}
dist = Distance( level.player.origin, cameraWithPlayer[ 0 ].origin );
newcam = cameraWithPlayer[ 0 ];
for ( i = 1; i < cameraWithPlayer.size; i++ )
{
newdist = Distance( level.player.origin, cameraWithPlayer[ i ].origin );
if ( newdist > dist )
continue;
newcam = cameraWithPlayer[ i ];
dist = newdist;
}
setPlayerToCamera( newcam );
wait( 3 );
}
}
freePlayer()
{
SetDvar( "cl_freemove", "0" );
}
setPlayerToCamera( camera )
{
SetDvar( "cl_freemove", "2" );
SetDebugAngles( camera.angles );
SetDebugOrigin( camera.origin + ( 0, 0, -60 ) );
}
anglescheck()
{
while ( 1 )
{
if ( GetDvar( "angles", "0" ) == "1" )
{
PrintLn( "origin " + level.player GetOrigin() );
PrintLn( "angles " + level.player.angles );
SetDvar( "angles", "0" );
}
wait( 1 );
}
}
dolly()
{
if ( !isdefined( level.dollyTime ) )
level.dollyTime = 5;
SetDvar( "dolly", "" );
thread dollyStart();
thread dollyEnd();
thread dollyGo();
}
dollyStart()
{
while ( 1 )
{
if ( GetDvar( "dolly" ) == "start" )
{
level.dollystart = level.player.origin;
SetDvar( "dolly", "" );
}
wait( 1 );
}
}
dollyEnd()
{
while ( 1 )
{
if ( GetDvar( "dolly" ) == "end" )
{
level.dollyend = level.player.origin;
SetDvar( "dolly", "" );
}
wait( 1 );
}
}
dollyGo()
{
while ( 1 )
{
wait( 1 );
if ( GetDvar( "dolly" ) == "go" )
{
SetDvar( "dolly", "" );
if ( !isdefined( level.dollystart ) )
{
PrintLn( "NO Dolly Start!" );
continue;
}
if ( !isdefined( level.dollyend ) )
{
PrintLn( "NO Dolly End!" );
continue;
}
org = Spawn( "script_origin", ( 0, 0, 0 ) );
org.origin = level.dollystart;
level.player SetOrigin( org.origin );
level.player LinkTo( org );
org MoveTo( level.dollyend, level.dollyTime );
wait( level.dollyTime );
org Delete();
}
}
}
deathspawnerPreview()
{
waittillframeend;
for ( i = 0; i < 50; i++ )
{
if ( !isdefined( level.deathspawnerents[ i ] ) )
continue;
array = level.deathspawnerents[ i ];
for ( p = 0; p < array.size; p++ )
{
ent = array[ p ];
if ( IsDefined( ent.truecount ) )
Print3d( ent.origin, i + ": " + ent.truecount, ( 0, 0.8, 0.6 ), 5 );
else
Print3d( ent.origin, i + ": " + ".", ( 0, 0.8, 0.6 ), 5 );
}
}
}
lastSightPosWatch()
{
}
watchMinimap()
{
PreCacheItem( "defaultweapon" );
while ( 1 )
{
updateMinimapSetting();
wait .25;
}
}
updateMinimapSetting()
{
requiredMapAspectRatio = GetDvarFloat( "scr_requiredMapAspectRatio", 1 );
if ( !isdefined( level.minimapcornertargetname ) )
{
SetDvar("scr_minimap_corner_targetname", "minimap_corner");
level.minimapcornertargetname = "minimap_corner";
}
if ( !isdefined( level.minimapheight ) ) {
SetDvar( "scr_minimap_height", "0" );
level.minimapheight = 0;
}
minimapheight = GetDvarFloat( "scr_minimap_height" );
minimapcornertargetname = GetDvar("scr_minimap_corner_targetname");
if ( minimapheight != level.minimapheight || minimapcornertargetname != level.minimapcornertargetname )
{
if ( IsDefined( level.minimaporigin ) ) {
level.minimapplayer Unlink();
level.minimaporigin Delete();
level notify( "end_draw_map_bounds" );
}
if ( minimapheight > 0 )
{
level.minimapheight = minimapheight;
level.minimapcornertargetname = minimapcornertargetname;
player = level.player;
corners = GetEntArray( minimapcornertargetname, "targetname" );
if ( corners.size == 2 )
{
viewpos = ( corners[ 0 ].origin + corners[ 1 ].origin );
viewpos = ( viewpos[ 0 ] * .5, viewpos[ 1 ] * .5, viewpos[ 2 ] * .5 );
maxcorner = ( corners[ 0 ].origin[ 0 ], corners[ 0 ].origin[ 1 ], viewpos[ 2 ] );
mincorner = ( corners[ 0 ].origin[ 0 ], corners[ 0 ].origin[ 1 ], viewpos[ 2 ] );
if ( corners[ 1 ].origin[ 0 ] > corners[ 0 ].origin[ 0 ] )
maxcorner = ( corners[ 1 ].origin[ 0 ], maxcorner[ 1 ], maxcorner[ 2 ] );
else
mincorner = ( corners[ 1 ].origin[ 0 ], mincorner[ 1 ], mincorner[ 2 ] );
if ( corners[ 1 ].origin[ 1 ] > corners[ 0 ].origin[ 1 ] )
maxcorner = ( maxcorner[ 0 ], corners[ 1 ].origin[ 1 ], maxcorner[ 2 ] );
else
mincorner = ( mincorner[ 0 ], corners[ 1 ].origin[ 1 ], mincorner[ 2 ] );
viewpostocorner = maxcorner - viewpos;
viewpos = ( viewpos[ 0 ], viewpos[ 1 ], viewpos[ 2 ] + minimapheight );
origin = Spawn( "script_origin", player.origin );
northvector = ( Cos( GetNorthYaw() ), Sin( GetNorthYaw() ), 0 );
eastvector = ( northvector[ 1 ], 0 - northvector[ 0 ], 0 );
disttotop = VectorDot( northvector, viewpostocorner );
if ( disttotop < 0 )
disttotop = 0 - disttotop;
disttoside = VectorDot( eastvector, viewpostocorner );
if ( disttoside < 0 )
disttoside = 0 - disttoside;
if ( requiredMapAspectRatio > 0 )
{
mapAspectRatio = disttoside / disttotop;
if ( mapAspectRatio < requiredMapAspectRatio )
{
incr = requiredMapAspectRatio / mapAspectRatio;
disttoside *= incr;
addvec = vecscale( eastvector, VectorDot( eastvector, maxcorner - viewpos ) * ( incr - 1 ) );
mincorner -= addvec;
maxcorner += addvec;
}
else
{
incr = mapAspectRatio / requiredMapAspectRatio;
disttotop *= incr;
addvec = vecscale( northvector, VectorDot( northvector, maxcorner - viewpos ) * ( incr - 1 ) );
mincorner -= addvec;
maxcorner += addvec;
}
}
if ( level.console )
{
aspectratioguess = 16.0 / 9.0;
angleside = 2 * ATan( disttoside * .8 / minimapheight );
angletop = 2 * ATan( disttotop * aspectratioguess * .8 / minimapheight );
}
else
{
aspectratioguess = 4.0 / 3.0;
angleside = 2 * ATan( disttoside * 1.05 / minimapheight );
angletop = 2 * ATan( disttotop * aspectratioguess * 1.05 / minimapheight );
}
if ( angleside > angletop )
angle = angleside;
else
angle = angletop;
znear = minimapheight - 1000;
if ( znear < 16 ) znear = 16;
if ( znear > 10000 ) znear = 10000;
player PlayerLinkToAbsolute( origin );
origin.origin = viewpos + ( 0, 0, -62 );
origin.angles = ( 90, GetNorthYaw(), 0 );
player GiveWeapon( "defaultweapon" );
SetSavedDvar( "cg_fov", angle );
level.minimapplayer = player;
level.minimaporigin = origin;
thread drawMiniMapBounds( viewpos, mincorner, maxcorner );
}
else
PrintLn( "^1Error: There are not exactly 2 \"minimap_corner\" entities in the level." );
}
}
}
getchains()
{
chainarray = [];
chainarray = GetEntArray( "minimap_line", "script_noteworthy" );
array = [];
for ( i = 0; i < chainarray.size; i++ )
{
array[ i ] = chainarray[ i ] getchain();
}
return array;
}
getchain()
{
array = [];
ent = self;
while ( IsDefined( ent ) )
{
array[ array.size ] = ent;
if ( !isdefined( ent ) || !isdefined( ent.target ) )
break;
ent = GetEnt( ent.target, "targetname" );
if ( IsDefined( ent ) && ent == array[ 0 ] )
{
array[ array.size ] = ent;
break;
}
}
originarray = [];
for ( i = 0; i < array.size; i++ )
originarray[ i ] = array[ i ].origin;
return originarray;
}
vecscale( vec, scalar )
{
return( vec[ 0 ] * scalar, vec[ 1 ] * scalar, vec[ 2 ] * scalar );
}
drawMiniMapBounds( viewpos, mincorner, maxcorner )
{
level notify( "end_draw_map_bounds" );
level endon( "end_draw_map_bounds" );
viewheight = ( viewpos[ 2 ] - maxcorner[ 2 ] );
diaglen = Length( mincorner - maxcorner );
mincorneroffset = ( mincorner - viewpos );
mincorneroffset = VectorNormalize( ( mincorneroffset[ 0 ], mincorneroffset[ 1 ], 0 ) );
mincorner = mincorner + vecscale( mincorneroffset, diaglen * 1 / 800 * 0 );
maxcorneroffset = ( maxcorner - viewpos );
maxcorneroffset = VectorNormalize( ( maxcorneroffset[ 0 ], maxcorneroffset[ 1 ], 0 ) );
maxcorner = maxcorner + vecscale( maxcorneroffset, diaglen * 1 / 800 * 0 );
north = ( Cos( GetNorthYaw() ), Sin( GetNorthYaw() ), 0 );
diagonal = maxcorner - mincorner;
side = vecscale( north, VectorDot( diagonal, north ) );
sidenorth = vecscale( north, abs( VectorDot( diagonal, north ) ) );
corner0 = mincorner;
corner1 = mincorner + side;
corner2 = maxcorner;
corner3 = maxcorner - side;
toppos = vecscale( mincorner + maxcorner, .5 ) + vecscale( sidenorth, .51 );
textscale = diaglen * .003;
chains = getchains();
while ( 1 )
{
Line( corner0, corner1 );
Line( corner1, corner2 );
Line( corner2, corner3 );
Line( corner3, corner0 );
array_levelthread( chains, ::plot_points );
Print3d( toppos, "This Side Up", ( 1, 1, 1 ), 1, textscale );
wait .05;
}
}
islookingatorigin( origin )
{
normalvec = VectorNormalize( origin - self GetShootAtPos() );
veccomp = VectorNormalize( ( origin - ( 0, 0, 24 ) ) - self GetShootAtPos() );
insidedot = VectorDot( normalvec, veccomp );
anglevec = AnglesToForward( self GetPlayerAngles() );
vectordot = VectorDot( anglevec, normalvec );
if ( vectordot > insidedot )
return true;
else
return false;
}
debug_colornodes()
{
wait( 0.05 );
ai = GetAIArray();
array = [];
array[ "axis" ] = [];
array[ "allies" ] = [];
array[ "neutral" ] = [];
for ( i = 0; i < ai.size; i++ )
{
guy = ai[ i ];
if ( !isdefined( guy.currentColorCode ) )
continue;
array[ guy.team ][ guy.currentColorCode ] = true;
color = ( 1, 1, 1 );
if ( IsDefined( guy.script_forcecolor ) )
color = level.color_debug[ guy.script_forcecolor ];
Print3d( guy.origin + ( 0, 0, 50 ), guy.currentColorCode, color, 1, 1 );
if ( guy.team == "axis" )
continue;
guy try_to_draw_line_to_node();
}
draw_colorNodes( array, "allies" );
draw_colorNodes( array, "axis" );
}
draw_colorNodes( array, team )
{
keys = GetArrayKeys( array[ team ] );
for ( i = 0; i < keys.size; i++ )
{
color = ( 1, 1, 1 );
color = level.color_debug[ GetSubStr( keys[ i ], 0, 1 ) ];
if ( IsDefined( level.colorNodes_debug_array[ team ][ keys[ i ] ] ) )
{
teamArray = level.colorNodes_debug_array[ team ][ keys[ i ] ];
for ( p = 0; p < teamArray.size; p++ )
{
Print3d( teamArray[ p ].origin, "N-" + keys[ i ], color, 1, 1 );
}
}
}
}
get_team_substr()
{
if ( self.team == "allies" )
{
if ( !isdefined( self.node.script_color_allies ) )
return;
return self.node.script_color_allies;
}
if ( self.team == "axis" )
{
if ( !isdefined( self.node.script_color_axis ) )
return;
return self.node.script_color_axis;
}
}
try_to_draw_line_to_node()
{
if ( !isdefined( self.node ) )
return;
if ( !isdefined( self.script_forcecolor ) )
return;
substr = get_team_substr();
if ( !isdefined( substr ) )
return;
if ( !issubstr( substr, self.script_forcecolor ) )
return;
Line( self.origin + ( 0, 0, 64 ), self.node.origin, level.color_debug[ self.script_forcecolor ] );
}
fogcheck()
{
if ( GetDvar( "depth_close" ) == "" )
SetDvar( "depth_close", "0" );
if ( GetDvar( "depth_far" ) == "" )
SetDvar( "depth_far", "1500" );
close = GetDvarInt( "depth_close" );
far = GetDvarInt( "depth_far" );
SetExpFog( close, far, 1, 1, 1, 1, 0 );
}
debugThreat()
{
{
level.last_threat_debug = GetTime();
thread debugThreatCalc();
}
}
debugThreatCalc()
{
}
displayThreat( entity, entityGroup )
{
if ( self.team == entity.team )
return;
selfthreat = 0;
selfthreat += self.threatBias;
threat = 0;
threat += entity.threatBias;
myGroup = undefined;
if ( IsDefined( entityGroup ) )
{
myGroup = self GetThreatBiasGroup();
if ( IsDefined( myGroup ) )
{
threat += GetThreatBias( entityGroup, myGroup );
selfThreat += GetThreatBias( myGroup, entityGroup );
}
}
if ( entity.ignoreme || threat < -900000 )
threat = "Ignore";
if ( self.ignoreme || selfthreat < -900000 )
selfthreat = "Ignore";
timer = 1 * 20;
col = ( 1, 0.5, 0.2 );
col2 = ( 0.2, 0.5, 1 );
pacifist = !isplayer( self ) && self.pacifist;
for ( i = 0; i <= timer; i++ )
{
Print3d( self.origin + ( 0, 0, 65 ), "Him to Me:", col, 3 );
Print3d( self.origin + ( 0, 0, 50 ), threat, col, 5 );
if ( IsDefined( entityGroup ) )
{
Print3d( self.origin + ( 0, 0, 35 ), entityGroup, col, 2 );
}
Print3d( self.origin + ( 0, 0, 15 ), "Me to Him:", col2, 3 );
Print3d( self.origin + ( 0, 0, 0 ), selfThreat, col2, 5 );
if ( IsDefined( mygroup ) )
{
Print3d( self.origin + ( 0, 0, -15 ), mygroup, col2, 2 );
}
if ( pacifist )
{
Print3d( self.origin + ( 0, 0, 25 ), "( Pacifist )", col2, 5 );
}
wait( 0.05 );
}
}
debugColorFriendlies()
{
level.debug_color_friendlies = [];
level.debug_color_huds = [];
for ( ;; )
{
level waittill( "updated_color_friendlies" );
draw_color_friendlies();
}
}
draw_color_friendlies()
{
level endon( "updated_color_friendlies" );
keys = GetArrayKeys( level.debug_color_friendlies );
colored_friendlies = [];
colors = [];
colors[ colors.size ] = "r";
colors[ colors.size ] = "o";
colors[ colors.size ] = "y";
colors[ colors.size ] = "g";
colors[ colors.size ] = "c";
colors[ colors.size ] = "b";
colors[ colors.size ] = "p";
rgb = get_script_palette();
for ( i = 0; i < colors.size; i++ )
{
colored_friendlies[ colors[ i ] ] = 0;
}
for ( i = 0; i < keys.size; i++ )
{
color = level.debug_color_friendlies[ keys[ i ] ];
colored_friendlies[ color ]++;
}
for ( i = 0; i < level.debug_color_huds.size; i++ )
{
level.debug_color_huds[ i ] Destroy();
}
level.debug_color_huds = [];
x = 15;
y = 365;
offset_x = 25;
offset_y = 25;
for ( i = 0; i < colors.size; i++ )
{
if ( colored_friendlies[ colors[ i ] ] <= 0 )
continue;
for ( p = 0; p < colored_friendlies[ colors[ i ] ]; p++ )
{
overlay = NewHudElem();
overlay.x = x + 25 * p;
overlay.y = y;
overlay SetShader( "white", 16, 16 );
overlay.alignX = "left";
overlay.alignY = "bottom";
overlay.alpha = 1;
overlay.color = rgb[ colors[ i ] ];
level.debug_color_huds[ level.debug_color_huds.size ] = overlay;
}
y += offset_y;
}
}
playerNode()
{
for ( ;; )
{
if ( IsDefined( level.player.node ) )
Print3d( level.player.node.origin + ( 0, 0, 25 ), "P-Node", ( 0.3, 1, 1 ), 1 );
wait( 0.05 );
}
}
drawUsers()
{
if ( IsAlive( self.color_user ) )
{
Line( self.origin + ( 0, 0, 35 ), self.color_user.origin + ( 0, 0, 35 ), ( 1, 1, 1 ), 1.0 );
Print3d( self.origin + ( 0, 0, -25 ), "in-use", ( 1, 1, 1 ), 1, 1 );
}
}
debuggoalpos()
{
for ( ;; )
{
ai = GetAIArray();
array_thread( ai, ::view_goal_pos );
wait( 0.05 );
}
}
view_goal_pos()
{
if ( !isdefined( self.goalpos ) )
return;
Line( self.origin + ( 0, 0, 35 ), self.goalpos + ( 0, 0, 35 ), ( 1, 1, 1 ), 1.0 );
}
colordebug()
{
wait( 0.5 );
col = [];
col[ col.size ] = "r";
col[ col.size ] = "g";
col[ col.size ] = "b";
col[ col.size ] = "y";
col[ col.size ] = "o";
col[ col.size ] = "p";
col[ col.size ] = "c";
for ( ;; )
{
for ( i = 0; i < col.size; i++ )
{
color = level.currentColorForced[ "allies" ][ col[ i ] ];
if ( IsDefined( color ) )
draw_colored_nodes( color );
}
wait( 0.05 );
}
}
draw_colored_nodes( color )
{
nodes = level.arrays_of_colorCoded_nodes[ "allies" ][ color ];
array_thread( nodes, ::drawUsers );
}
init_animSounds()
{
level.animSounds = [];
level.animSound_aliases = [];
waittillframeend;
waittillframeend;
animnames = GetArrayKeys( level.scr_notetrack );
for ( i = 0; i < animnames.size; i++ )
{
init_notetracks_for_animname( animnames[ i ] );
}
animnames = GetArrayKeys( level.scr_animSound );
for ( i = 0; i < animnames.size; i++ )
{
init_animSounds_for_animname( animnames[ i ] );
}
}
init_notetracks_for_animname( animname )
{
foreach ( anime, anime_array in level.scr_notetrack[ animname ] )
{
foreach ( notetrack, notetrack_array in anime_array )
{
foreach ( scr_notetrack in notetrack_array )
{
soundAlias = scr_notetrack[ "sound" ];
if ( !isdefined( soundAlias ) )
continue;
level.animSound_aliases[ animname ][ anime ][ notetrack ][ "soundalias" ] = soundalias;
if ( IsDefined( scr_notetrack[ "created_by_animSound" ] ) )
{
level.animSound_aliases[ animname ][ anime ][ notetrack ][ "created_by_animSound" ] = true;
}
}
}
}
}
init_animSounds_for_animname( animname )
{
animes = GetArrayKeys( level.scr_animSound[ animname ] );
for ( i = 0; i < animes.size; i++ )
{
anime = animes[ i ];
soundalias = level.scr_animSound[ animname ][ anime ];
level.animSound_aliases[ animname ][ anime ][ "#" + anime ][ "soundalias" ] = soundalias;
level.animSound_aliases[ animname ][ anime ][ "#" + anime ][ "created_by_animSound" ] = true;
}
}
add_hud_line( x, y, msg )
{
hudelm = NewHudElem();
hudelm.alignX = "left";
hudelm.alignY = "middle";
hudelm.x = x;
hudelm.y = y;
hudelm.alpha = 1;
hudelm.fontScale = 1;
hudelm.label = msg;
level.animsound_hud_extralines[ level.animsound_hud_extralines.size ] = hudelm;
return hudelm;
}
debug_animSound()
{
}
draw_animsounds_in_hud()
{
guy = level.animsound_tagged;
animsounds = guy.animSounds;
animname = "generic";
if ( IsDefined( guy.animname ) )
animname = guy.animname;
level.animsound_hud_animname.label = "Actor: " + animname;
if ( level.player ButtonPressed( "f12" ) )
{
if ( !level.animsound_locked_pressed )
{
level.animsound_locked = !level.animsound_locked;
level.animsound_locked_pressed = true;
}
}
else
{
level.animsound_locked_pressed = false;
}
if ( level.player ButtonPressed( "UPARROW" ) )
{
if ( level.animsound_input != "up" )
{
level.animsound_selected--;
}
level.animsound_input = "up";
}
else
if ( level.player ButtonPressed( "DOWNARROW" ) )
{
if ( level.animsound_input != "down" )
{
level.animsound_selected++;
}
level.animsound_input = "down";
}
else
level.animsound_input = "none";
for ( i = 0; i < level.animsound_hudlimit; i++ )
{
hudelm = level.animsound_hud[ i ];
hudelm.label = "";
hudelm.color = ( 1, 1, 1 );
hudelm = level.animsound_hud_timer[ i ];
hudelm.label = "";
hudelm.color = ( 1, 1, 1 );
hudelm = level.animsound_hud_alias[ i ];
hudelm.label = "";
hudelm.color = ( 1, 1, 1 );
}
keys = GetArrayKeys( animsounds );
highest = -1;
for ( i = 0; i < keys.size; i++ )
{
if ( keys[ i ] > highest )
highest = keys[ i ];
}
if ( highest == -1 )
return;
if ( level.animsound_selected > highest )
level.animsound_selected = highest;
if ( level.animsound_selected < 0 )
level.animsound_selected = 0;
for ( ;; )
{
if ( IsDefined( animsounds[ level.animsound_selected ] ) )
break;
level.animsound_selected--;
if ( level.animsound_selected < 0 )
level.animsound_selected = highest;
}
level.animsound_hud_anime.label = "Anim: " + animsounds[ level.animsound_selected ].anime;
level.animsound_hud[ level.animsound_selected ].color = ( 1, 1, 0 );
level.animsound_hud_timer[ level.animsound_selected ].color = ( 1, 1, 0 );
level.animsound_hud_alias[ level.animsound_selected ].color = ( 1, 1, 0 );
time = GetTime();
for ( i = 0; i < keys.size; i++ )
{
key = keys[ i ];
animsound = animsounds[ key ];
hudelm = level.animsound_hud[ key ];
soundalias = get_alias_from_stored( animSound );
hudelm.label = ( key + 1 ) + ". " + animsound.notetrack;
hudelm = level.animsound_hud_timer[ key ];
hudelm.label = Int( ( time - ( animsound.end_time - 60000 ) ) * 0.001 );
if ( IsDefined( soundalias ) )
{
hudelm = level.animsound_hud_alias[ key ];
hudelm.label = soundalias;
if ( !is_from_animsound( animSound.animname, animSound.anime, animSound.notetrack ) )
{
hudelm.color = ( 0.7, 0.7, 0.7 );
}
}
}
if ( level.player ButtonPressed( "del" ) )
{
animsound = animsounds[ level.animsound_selected ];
soundalias = get_alias_from_stored( animsound );
if ( !isdefined( soundalias ) )
return;
if ( !is_from_animsound( animSound.animname, animSound.anime, animSound.notetrack ) )
return;
level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ] = undefined;
debug_animSoundSave();
}
}
get_alias_from_stored( animSound )
{
if ( !isdefined( level.animSound_aliases[ animSound.animname ] ) )
return;
if ( !isdefined( level.animSound_aliases[ animSound.animname ][ animSound.anime ] ) )
return;
if ( !isdefined( level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ] ) )
return;
return level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ][ "soundalias" ];
}
is_from_animsound( animname, anime, notetrack )
{
return IsDefined( level.animSound_aliases[ animname ][ anime ][ notetrack ][ "created_by_animSound" ] );
}
display_animSound()
{
if ( Distance( level.player.origin, self.origin ) > 1500 )
return;
level.animSounds_thisframe[ level.animSounds_thisframe.size ] = self;
}
debug_animSoundTag( tagnum )
{
}
debug_animSoundTagSelected()
{
}
tag_sound( tag, tagnum )
{
if ( !isdefined( level.animsound_tagged ) )
return;
if ( !isdefined( level.animsound_tagged.animsounds[ tagnum ] ) )
return;
animSound = level.animsound_tagged.animsounds[ tagnum ];
soundalias = get_alias_from_stored( animSound );
if ( !isdefined( soundalias ) || is_from_animsound( animSound.animname, animSound.anime, animSound.notetrack ) )
{
level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ][ "soundalias" ] = tag;
level.animSound_aliases[ animSound.animname ][ animSound.anime ][ animSound.notetrack ][ "created_by_animSound" ] = true;
debug_animSoundSave();
}
}
debug_animSoundSave()
{
}
print_aliases_to_file( file )
{
tab = "    ";
FPrintLn( file, "#include maps\\_anim;" );
FPrintLn( file, "main()" );
FPrintLn( file, "{" );
FPrintLn( file, tab + "// Autogenerated by AnimSounds. Threaded off so that it can be placed before _load( has to create level.scr_notetrack first )." );
FPrintLn( file, tab + "thread init_animsounds();" );
FPrintLn( file, "}" );
FPrintLn( file, "" );
FPrintLn( file, "init_animsounds()" );
FPrintLn( file, "{" );
FPrintLn( file, tab + "waittillframeend;" );
animnames = GetArrayKeys( level.animSound_aliases );
for ( i = 0; i < animnames.size; i++ )
{
animes = GetArrayKeys( level.animSound_aliases[ animnames[ i ] ] );
for ( p = 0; p < animes.size; p++ )
{
anime = animes[ p ];
notetracks = GetArrayKeys( level.animSound_aliases[ animnames[ i ] ][ anime ] );
for ( z = 0; z < notetracks.size; z++ )
{
notetrack = notetracks[ z ];
if ( !is_from_animsound( animnames[ i ], anime, notetrack ) )
continue;
alias = level.animSound_aliases[ animnames[ i ] ][ anime ][ notetrack ][ "soundalias" ];
if ( notetrack == "#" + anime )
{
FPrintLn( file, tab + "addOnStart_animSound( " + tostr( animnames[ i ] ) + ", " + tostr( anime ) + ", " + tostr( alias ) + " ); " );
}
else
{
FPrintLn( file, tab + "addNotetrack_animSound( " + tostr( animnames[ i ] ) + ", " + tostr( anime ) + ", " + tostr( notetrack ) + ", " + tostr( alias ) + " ); " );
}
PrintLn( "^1Saved alias ^4" + alias + "^1 to notetrack ^4" + notetrack );
}
}
}
FPrintLn( file, "}" );
}
tostr( str )
{
newstr = "\"";
for ( i = 0; i < str.size; i++ )
{
if ( str[ i ] == "\"" )
{
newstr += "\\";
newstr += "\"";
continue;
}
newstr += str[ i ];
}
newstr += "\"";
return newstr;
}
linedraw( start, end, color, alpha, depth, timer )
{
if ( !isdefined( color ) )
color = ( 1, 1, 1 );
if ( IsDefined( timer ) )
{
timer *= 20;
for ( i = 0; i < timer; i++ )
{
Line( start, end, color, alpha, depth );
wait( 0.05 );
}
}
else
{
for ( ;; )
{
Line( start, end, color, alpha, depth );
wait( 0.05 );
}
}
}
print3ddraw( org, text, color )
{
for ( ;; )
{
Print3d( org, text, color );
wait( 0.05 );
}
}
complete_me()
{
if ( GetDvar( "credits_active" ) == "1" )
{
wait 7;
SetDvar( "credits_active", "0" );
maps\_endmission::credits_end();
return;
}
wait 7;
nextmission();
}
find_new_chase_target( ent_num )
{
}
chaseCam( ent_num )
{
if ( !isdefined( level.chase_cam_last_num ) )
{
level.chase_cam_last_num = -1;
}
if ( level.chase_cam_last_num == ent_num )
return;
find_new_chase_target( ent_num );
if ( !isdefined( level.chase_cam_target ) )
return;
level.chase_cam_last_num = ent_num;
if ( !isdefined( level.chase_cam_ent ) )
{
level.chase_cam_ent = level.chase_cam_target spawn_tag_origin();
}
thread chaseCam_onEnt( level.chase_cam_target );
}
chaseCam_onEnt( ent )
{
level notify( "new_chasecam" );
level endon( "new_chasecam" );
ent endon( "death" );
level.player Unlink();
level.player PlayerLinkToBlend( level.chase_cam_ent, "tag_origin", 2, 0.5, 0.5 );
wait( 2 );
level.player PlayerLinkToDelta( level.chase_cam_ent, "tag_origin", 1, 180, 180, 180, 180 );
for ( ;; )
{
wait( 0.2 );
if ( !isdefined( level.chase_cam_target ) )
return;
start = level.chase_cam_target.origin;
angles = level.chase_cam_target.angles;
forward = AnglesToForward( angles );
forward *= 200;
start += forward;
angles = level.player GetPlayerAngles();
forward = AnglesToForward( angles );
forward *= -200;
level.chase_cam_ent MoveTo( start + forward, 0.2 );
}
}
viewfx()
{
foreach ( fx in level.createfxent )
{
if ( IsDefined( fx.looper ) )
Print3d( fx.v[ "origin" ], ".", ( 1, 1, 0 ), 1, 1.5, 200 );
}
}
add_key( key, val )
{
PrintLn( "	\"" + key + "\" \"" + val + "\"" );
}
print_vehicle_info( noteworthy )
{
useOldPrint = false;
if( useOldPrint )
{
if ( !isdefined( level.vnum ) )
level.vnum = 9500;
level.vnum++;
layer = "bridge_helpers";
PrintLn( "entity " + level.vnum );
PrintLn( "{" );
add_key( "origin", self.origin[ 0 ] + " " + self.origin[ 1 ] + " " + self.origin[ 2 ] );
add_key( "angles", self.angles[ 0 ] + " " + self.angles[ 1 ] + " " + self.angles[ 2 ] );
add_key( "targetname", "helper_model" );
add_key( "model", self.model );
add_key( "classname", "script_model" );
add_key( "spawnflags", "4" );
add_key( "_color", "0.443137 0.443137 1.000000" );
PrintLn( "	layer \"" + layer + "\"" );
if ( IsDefined( noteworthy ) )
add_key( "script_noteworthy", noteworthy );
PrintLn( "}" );
}
else
{
PrintLn( "{" );
add_key( "classname", self.classname );
add_key( "origin", self.origin[ 0 ] + " " + self.origin[ 1 ] + " " + self.origin[ 2 ] );
add_key( "angles", self.angles[ 0 ] + " " + self.angles[ 1 ] + " " + self.angles[ 2 ] );
add_key( "model", self.model );
add_key( "vehicletype", self.vehicletype );
if( IsDefined( self.targetname ) )
{
add_key( "targetname", self.targetname );
}
if( IsDefined( self.script_noteworthy ) )
{
add_key( "script_noteworthy", self.script_noteworthy );
}
if( IsDefined( self.script_team ) )
{
add_key( "script_team", self.script_team );
}
if( IsDefined( self.riders ) && IsArray( self.riders ) && self.riders.size > 0 )
{
add_key( "riders", self.riders.size );
}
PrintLn( "}" );
}
}
draw_dot_for_ent( entnum )
{
}
draw_dot_for_guy()
{
player_angles = level.player GetPlayerAngles();
player_forward = AnglesToForward( player_angles );
end = level.player GetEye();
start = self GetEye();
angles = VectorToAngles( start - end );
forward = AnglesToForward( angles );
dot = VectorDot( forward, player_forward );
Print3d( start, dot, ( 1, 0.5, 0 ) );
}
debug_character_breakdown_create()
{
if( !IsDefined( level.debug_character_breakdown ) )
{
level.debug_character_breakdown = [];
}
index = level.debug_character_breakdown.size;
yPos = ( index * 14 ) + 100;
if( self.type == "main" )
{
self.alignX = "left";
self.horzAlign = "left";
self.x = 10;
self.y = yPos;
self.font = "small";
self.fontScale = 1.6;
self.color = ( 1, 1, 1 );
level.debug_character_breakdown[ level.debug_character_breakdown.size ] = self;
return self;
}
else
{
self.alignX = "left";
self.horzAlign = "left";
self.x = 20;
self.y = yPos;
self.fontScale = 1.3;
self.color = ( 1, 1, 1 );
level.debug_character_breakdown[ level.debug_character_breakdown.size ] = self;
return self;
}
return undefined;
}
debug_character_count()
{
if( !IsDefined( level.debug_character_count ) )
{
level.debug_character_count = true;
}
else
{
return;
}
while( GetDvar( "debug_character_count" ) == "off" )
{
wait 1;
}
debug_character_count = GetDvarInt( "debug_character_count" );
CharacterPanel = createCharacterPanels();
while( 1 )
{
drones_total = GetEntArray( "drone", "targetname" );
drones_allies_count = 0;
drones_axis_count = 0;
drones_neutral_count = 0;
drones_team3_count = 0;
if( IsDefined( drones_total ) && drones_total.size > 0 )
{
for( x = 0 ; x < drones_total.size ; x++ )
{
if( IsDefined( drones_total[ x ].team ) )
{
switch( drones_total[ x ].team )
{
case "allies":
drones_allies_count++;
break;
case "axis":
drones_axis_count++;
break;
case "neutral":
drones_neutral_count++;
break;
case "team3":
drones_team3_count++;
break;
}
}
}
}
CharacterPanel.Drones SetValue( drones_total.size );
CharacterPanel.Drones_Axis SetValue( drones_axis_count );
CharacterPanel.Drones_Allies SetValue( drones_allies_count );
CharacterPanel.Drones_Neutral SetValue( drones_neutral_count );
CharacterPanel.Drones_Team3 SetValue( drones_team3_count );
ai_total = GetAIArray().size;
ai_allies_count = GetAIArray( "allies" ).size;
ai_axis_count = GetAIArray( "axis" ).size;
ai_neutral_count = GetAIArray( "neutral" ).size;
ai_team3_count = GetAIArray( "team3" ).size;
ai_heroes_count = get_heroes().size;
CharacterPanel.AI SetValue( ai_total );
CharacterPanel.AI_Axis SetValue( ai_axis_count );
CharacterPanel.AI_Allies SetValue( ( ai_allies_count - ai_heroes_count ) );
CharacterPanel.AI_Neutral SetValue( ai_neutral_count );
CharacterPanel.AI_Team3 SetValue( ai_team3_count );
CharacterPanel.AI_Heroes SetValue( ai_heroes_count );
vehicles_total = getVehicleArray();
vehicles_allies_count = 0;
vehicles_axis_count = 0;
vehicles_neutral_count = 0;
vehicles_team3_count = 0;
if( IsDefined( vehicles_total ) && vehicles_total.size > 0 )
{
for( x = 0 ; x < vehicles_total.size ; x++ )
{
if( IsDefined( vehicles_total[ x ].script_team ) )
{
switch( vehicles_total[ x ].script_team )
{
case "allies":
vehicles_allies_count++;
break;
case "axis":
vehicles_axis_count++;
break;
case "neutral":
vehicles_neutral_count++;
break;
case "team3":
vehicles_team3_count++;
break;
}
}
}
}
CharacterPanel.Vehicles SetValue( vehicles_total.size );
CharacterPanel.Vehicles_Axis SetValue( vehicles_axis_count );
CharacterPanel.Vehicles_Allies SetValue( vehicles_allies_count );
CharacterPanel.Vehicles_Neutral SetValue( vehicles_neutral_count );
CharacterPanel.Vehicles_Team3 SetValue( vehicles_team3_count );
CharacterPanel.Total SetValue( drones_total.size +
ai_total +
vehicles_total.size );
if( GetDvar( "debug_character_count" ) == "off" )
{
if( IsDefined( level.debug_character_breakdown ) && level.debug_character_breakdown.size > 0 )
{
for( x = 0 ; x < level.debug_character_breakdown.size ; x++ )
{
level.debug_character_breakdown[ x ] Destroy();
}
}
level.debug_character_breakdown = array_removeUndefined( level.debug_character_breakdown );
while( GetDvar( "debug_character_count" ) == "off" )
{
wait 1;
}
CharacterPanel = createCharacterPanels();
}
wait 0.25;
}
}
createCharacterPanels()
{
CharacterPanel = SpawnStruct();
CharacterPanel.Drones = addMainDebug( "Drones: ");
CharacterPanel.Drones_Axis = addSubDebug( "Axis: ");
CharacterPanel.Drones_Allies = addSubDebug( "Allies: ");
CharacterPanel.Drones_Neutral = addSubDebug( "Neutral: ");
CharacterPanel.Drones_Team3 = addSubDebug( "Team3: ");
CharacterPanel.AI = addMainDebug( "AI: ");
CharacterPanel.AI_Axis = addSubDebug( "Axis: ");
CharacterPanel.AI_Allies = addSubDebug( "Allies: ");
CharacterPanel.AI_Neutral = addSubDebug( "Neutral: ");
CharacterPanel.AI_Team3 = addSubDebug( "Team3: ");
CharacterPanel.AI_Heroes = addSubDebug( "Heroes: ");
CharacterPanel.Vehicles = addMainDebug( "Vehicles: ");
CharacterPanel.Vehicles_Axis = addSubDebug( "Axis: ");
CharacterPanel.Vehicles_Allies = addSubDebug( "Allies: ");
CharacterPanel.Vehicles_Neutral = addSubDebug( "Neutral: ");
CharacterPanel.Vehicles_Team3 = addSubDebug( "Team3: ");
CharacterPanel.Total = addMainDebug( "Total: " );
return CharacterPanel;
}
addMainDebug( name )
{
temp = newHudElem();
temp.type = "main";
temp = temp debug_character_breakdown_create();
temp.label = ( name );
return temp;
}
addSubDebug( name )
{
temp = newHudElem();
temp.type = "sub";
temp = temp debug_character_breakdown_create();
temp.label = ( name );
return temp;
}
drawAxisOnMe( vColor, strText_1, strText_2 )
{
while( IsDefined( self ) )
{
Line( self.origin + ( 20, 0, 0 ), self.origin + ( -20, 0, 0 ), vColor );
Line( self.origin + ( 0, 20, 0 ), self.origin + ( 0, -20, 0 ), vColor );
Line( self.origin + ( 0, 0, 20 ), self.origin + ( 0, 0, -20 ), vColor );
if( IsDefined( strText_1 ) )
{
Print3d( self.origin, strText_1, ( 1, 0, 0 ), 4 );
}
if( IsDefined( strText_2 ) )
{
Print3d( self.origin + ( 0, 0, 12 ), strText_2, ( 1, 0, 0 ), 4 );
}
wait( 0.05 );
}
}
RemoteConsoleHideStuff()
{
level.RemoteConsoleHideStuff = [];
dvarTemp = "";
SetDvar( "RconHide", "" );
while( true )
{
while( GetDvar( "RconHide" ) == dvarTemp )
{
wait ( 1 );
}
dvarTemp = GetDvar( "RconHide" );
list = dvarTemp;
if( level.RemoteConsoleHideStuff.size > 0 )
{
foreach(entityName in level.RemoteConsoleHideStuff)
{
array_thread( GetEntArray( entityName, "targetname" ), ::show_entity );
array_thread( GetEntArray( entityName, "script_noteworthy" ), ::show_entity );
}
level.RemoteConsoleHideStuff = [];
}
if( list != "" )
{
list = StrTok( GetDvar( "RConHide" ), " " );
level.RemoteConsoleHideStuff = list;
foreach(entityName in level.RemoteConsoleHideStuff)
{
array_thread( GetEntArray( entityName, "targetname" ), ::hide_entity );
array_thread( GetEntArray( entityName, "script_noteworthy" ), ::hide_entity );
}
}
wait ( 0.07 );
}
}