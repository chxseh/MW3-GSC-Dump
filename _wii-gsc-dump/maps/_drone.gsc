#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
DRONE_RUN_SPEED = 170;
TRACE_HEIGHT = 100;
MAX_DRONES_ALLIES = 99999;
MAX_DRONES_AXIS = 99999;
MAX_DRONES_TEAM3 = 99999;
MAX_DRONES_CIVILIAN = 99999;
DEATH_DELETE_FOV = 0.5;
initGlobals()
{
if ( getdvar( "debug_drones" ) == "" )
setdvar( "debug_drones", "0" );
assert( isdefined( level.drone_anims ) );
if ( !isdefined( level.lookAhead_value ) )
level.drone_lookAhead_value = 200;
if ( !isdefined( level.max_drones ) )
level.max_drones = [];
if ( !isdefined( level.max_drones[ "allies" ] ) )
level.max_drones[ "allies" ] = MAX_DRONES_ALLIES;
if ( !isdefined( level.max_drones[ "axis" ] ) )
level.max_drones[ "axis" ] = MAX_DRONES_AXIS;
if ( !isdefined( level.max_drones[ "team3" ] ) )
level.max_drones[ "team3" ] = MAX_DRONES_TEAM3;
if ( !isdefined( level.max_drones[ "neutral" ] ) )
level.max_drones[ "neutral" ] = MAX_DRONES_CIVILIAN;
if ( !isdefined( level.drones ) )
level.drones = [];
if ( !isdefined( level.drones[ "allies" ] ) )
level.drones[ "allies" ] = struct_arrayspawn();
if ( !isdefined( level.drones[ "axis" ] ) )
level.drones[ "axis" ] = struct_arrayspawn();
if ( !isdefined( level.drones[ "team3" ] ) )
level.drones[ "team3" ] = struct_arrayspawn();
if ( !isdefined( level.drones[ "neutral" ] ) )
level.drones[ "neutral" ] = struct_arrayspawn();
level.drone_spawn_func = ::drone_init;
}
drone_give_soul()
{
self useAnimTree( #animtree );
self startUsingHeroOnlyLighting();
if ( isdefined( self.script_moveplaybackrate ) )
self.moveplaybackrate = self.script_moveplaybackrate;
else
self.moveplaybackrate = 1;
if ( self.team == "allies" )
{
self maps\_names::get_name();
self setlookattext( self.name, &"" );
}
if ( isdefined( level.droneCallbackThread ) )
self thread [[ level.droneCallbackThread ]]();
if ( !IsDefined( self.script_friendly_fire_disable ) )
level thread maps\_friendlyfire::friendly_fire_think( self );
if( !isdefined( level.ai_dont_glow_in_thermal ) )
self ThermalDrawEnable();
}
drone_init()
{
assertEx( isdefined( level.max_drones ), "You need to put maps\_drone::init(); in your level script!" );
if ( level.drones[ self.team ].array.size >= level.max_drones[ self.team ] )
{
self delete();
return;
}
thread drone_array_handling( self );
level notify ( "new_drone" );
self setCanDamage( true );
drone_give_soul();
if ( isdefined( self.script_drone_override ) )
return;
thread drone_death_thread();
if ( isdefined( self.target ) )
{
if( !isdefined( self.script_moveoverride ) )
self thread drone_move();
else
self thread drone_wait_move();
}
if ( ( isdefined( self.script_looping ) ) && ( self.script_looping == 0 ) )
{
return;
}
self thread drone_idle();
}
drone_array_handling( drone )
{
structarray_add( level.drones[ drone.team ], drone );
team = drone.team;
drone waittill( "death" );
if ( isdefined( drone ) && isdefined( drone.struct_array_index ) )
structarray_remove_index( level.drones[ team ], drone.struct_array_index );
else
structarray_remove_undefined( level.drones[ team ] );
}
drone_death_thread()
{
self drone_wait_for_death();
if ( !IsDefined( self ) )
return;
stance = "stand";
if(isdefined(self.animset) && isdefined(level.drone_anims[ self.team ][ self.animset ]) && isdefined(level.drone_anims[ self.team ][ self.animset ][ "death" ]) )
{
stance = self.animset;
}
deathanim = level.drone_anims[ self.team ][ stance ][ "death" ];
if( isdefined( self.deathanim ) )
deathanim = self.deathanim;
self notify( "death" );
if( isdefined( level.drone_death_handler ) )
{
self thread [[level.drone_death_handler]](deathanim );
return;
}
if ( !( isdefined( self.noragdoll ) && isdefined( self.skipDeathAnim ) ) )
{
if ( isdefined( self.noragdoll ) )
{
self drone_play_scripted_anim( deathanim, "deathplant" );
}
else
if ( isdefined( self.skipDeathAnim ) )
{
self startragdoll();
self drone_play_scripted_anim( deathanim, "deathplant" );
}
else
{
self drone_play_scripted_anim( deathanim, "deathplant" );
self startragdoll();
}
}
self notsolid();
self thread drone_thermal_draw_disable( 2 );
if( isdefined( self ) && isdefined( self.nocorpsedelete ) )
return;
wait 10;
while( isdefined( self ) )
{
if ( !within_fov( level.player.origin, level.player.angles, self.origin, DEATH_DELETE_FOV ) )
self delete();
wait( 5 );
}
}
drone_wait_for_death()
{
self endon( "death" );
while ( isdefined( self ) )
{
self waittill( "damage" );
if ( isdefined( self.damageShield ) && self.damageShield )
{
self.health = 100000;
continue;
}
if ( self.health <= 0 )
break;
}
}
drone_thermal_draw_disable( delay )
{
wait delay;
if ( isdefined( self ) )
{
self ThermalDrawDisable();
}
}
drone_play_looping_anim( droneAnim, rate )
{
self ClearAnim( %body, 0.2 );
self StopAnimScripted();
self SetFlaggedAnimKnobAllRestart( "drone_anim", droneAnim, %body, 1, 0.2, rate );
}
drone_play_scripted_anim( droneAnim, deathplant )
{
self clearAnim( %body, 0.2 );
self stopAnimScripted();
mode = "normal";
if ( isdefined( deathplant ) )
mode = "deathplant";
flag = "drone_anim";
self animscripted( flag, self.origin, self.angles, droneAnim, mode );
self waittillmatch( "drone_anim", "end" );
}
drone_drop_real_weapon_on_death()
{
if ( !isdefined( self ) )
return;
self waittill( "death" );
if( !isdefined( self ) )
return;
weapon_model = getWeaponModel( self.weapon );
weapon = self.weapon;
if ( isdefined( weapon_model ) )
{
self detach( weapon_model, "tag_weapon_right" );
org = self gettagorigin( "tag_weapon_right" );
ang = self gettagangles( "tag_weapon_right" );
gun = Spawn( "weapon_" + weapon, ( 0, 0, 0 ) );
gun.angles = ang;
gun.origin = org;
}
}
drone_idle( lastNode, moveToDest )
{
if ( IsDefined( self.drone_idle_custom ) )
{
[[ self.drone_idle_override ]]();
return;
}
if ( ( isdefined( lastNode ) ) && ( isdefined( lastNode[ "script_noteworthy" ] ) ) && ( isdefined( level.drone_anims[ self.team ][ lastNode[ "script_noteworthy" ] ] ) ) )
{
self thread drone_fight( lastNode[ "script_noteworthy" ], lastNode, moveToDest );
}
else
{
if ( isdefined( self.idleAnim ) )
self drone_play_looping_anim( self.idleAnim, 1 );
else
self drone_play_looping_anim( level.drone_anims[ self.team ][ "stand" ][ "idle" ], 1 );
}
}
drone_get_goal_loc_with_arrival( dist, node )
{
animset = node[ "script_noteworthy" ];
if ( !isdefined( level.drone_anims[ self.team ][ animset ][ "arrival" ] ) )
return dist;
animDelta = GetMoveDelta( level.drone_anims[ self.team ][ animset ][ "arrival" ], 0, 1 );
animDelta = length( animDelta );
assertex( animDelta < dist, "Drone with export " + self.export + " does not have enough room to play an arrival anim. Space nodes out more and ensure he has a straight path into the last node" );
dist = ( dist - animDelta );
return dist;
}
drone_fight( animset, struct, moveToDest )
{
self endon( "death" );
self endon( "stop_drone_fighting" );
self.animset = animset;
self.weaponsound = undefined;
iRand = randomintrange( 1, 4 );
if( self.team == "axis" )
{
if( iRand == 1 )
self.weaponsound = "drone_ak47_fire_npc";
else if( iRand == 2 )
self.weaponsound = "drone_g36c_fire_npc";
if( iRand == 3 )
self.weaponsound = "drone_fnp90_fire_npc";
}
else
{
if( iRand == 1 )
self.weaponsound = "drone_m4carbine_fire_npc";
else if( iRand == 2 )
self.weaponsound = "drone_m16_fire_npc";
if( iRand == 3 )
self.weaponsound = "drone_m249saw_fire_npc";
}
self.angles = ( 0, self.angles[ 1 ], self.angles[ 2 ] );
if ( animset == "coverprone" )
self moveto( self.origin + ( 0, 0, 8 ), .05 );
self.noragdoll = true;
animset_obj = level.drone_anims[ self.team ][ animset ];
self.deathanim = animset_obj[ "death" ];
while( isdefined( self ) )
{
assertEx( isdefined(animset_obj[ "idle" ]), "a drone is being told to play animset " + animset + " but it doesnt have an idle. check _drone_ai.gsc to fix");
self drone_play_scripted_anim( animset_obj[ "idle" ][ randomint( animset_obj[ "idle" ].size ) ] );
if ( cointoss() && ( !isdefined( self.ignoreall ) ) )
{
assertEx( isdefined(animset_obj[ "pop_up_chance" ]), "animset " + animset + " does not have a pop_up_chance. defaulting to 1 ");
chance = 1;
if(isdefined(animset_obj[ "pop_up_chance" ]))
chance = animset_obj[ "pop_up_chance" ];
chance = chance * 100;
bPopUpToFire = 1;
if(randomfloat(100) > chance)
{
bPopUpToFire = 0;
}
if ( bPopUpToFire == 1 )
{
assertEx( isdefined(animset_obj[ "hide_2_aim" ]), "a drone is being told to play animset " + animset + " but it doesnt have an hide_2_aim. check _drone_ai.gsc to fix");
self drone_play_scripted_anim( animset_obj[ "hide_2_aim" ] );
wait( getanimlength( animset_obj[ "hide_2_aim" ] ) - .5 );
}
if ( isdefined( animset_obj[ "fire" ] ) )
{
if ( ( animset == "coverprone" ) && ( bPopUpToFire == 1 ) )
self thread drone_play_looping_anim( animset_obj[ "fire_exposed" ], 1 );
else
self thread drone_play_looping_anim( animset_obj[ "fire" ], 1 );
self drone_fire_randomly();
}
else
{
self drone_shoot();
wait(.15);
self drone_shoot();
wait(.15);
self drone_shoot();
wait(.15);
self drone_shoot();
}
if ( bPopUpToFire == 1 )
{
assertEx( isdefined(animset_obj[ "aim_2_hide" ]), "a drone is being told to play animset " + animset + " but it doesnt have an aim_2_hide. check _drone_ai.gsc to fix");
self drone_play_scripted_anim( animset_obj[ "aim_2_hide" ] );
}
assertEx( isdefined(animset_obj[ "reload" ]), "a drone is being told to play animset " + animset + " but it doesnt have an reload. check _drone_ai.gsc to fix");
self drone_play_scripted_anim( animset_obj[ "reload" ] );
}
}
}
drone_fire_randomly()
{
self endon( "death" );
if( cointoss() )
{
self drone_shoot();
wait( .1 );
self drone_shoot();
wait( .1 );
self drone_shoot();
if( cointoss() )
{
wait( .1 );
self drone_shoot();
}
if( cointoss() )
{
wait( .1 );
self drone_shoot();
wait( .1 );
self drone_shoot();
wait( .1 );
}
if( cointoss() )
wait( randomfloatrange( 1, 2 ) );
}
else
{
self drone_shoot();
wait( randomfloatrange( .25, .75 ) );
self drone_shoot();
wait( randomfloatrange( .15, .75 ) );
self drone_shoot();
wait( randomfloatrange( .15, .75 ) );
self drone_shoot();
wait( randomfloatrange( .15, .75 ) );
}
}
drone_shoot()
{
self endon( "death" );
self notify( "firing" );
self endon( "firing" );
drone_shoot_fx();
fireAnim = %exposed_crouch_shoot_auto_v2;
self setAnimKnobRestart( fireAnim, 1, .2, 1.0 );
self delaycall( .25, ::clearAnim, fireAnim, 0 );
}
drone_shoot_fx()
{
shoot_fx = getfx( "ak47_muzzleflash" );
if ( self.team == "allies" )
{
shoot_fx = getfx( "m16_muzzleflash" );
}
self thread drone_play_weapon_sound( self.weaponsound );
PlayFXOnTag( shoot_fx, self, "tag_flash" );
}
drone_play_weapon_sound( weaponsound )
{
self playsound( weaponsound );
}
drone_wait_move()
{
self endon( "death" );
self waittill( "move" );
self thread drone_move();
}
drone_init_path()
{
if ( !isdefined( self.target ) )
return;
if ( isdefined( level.drone_paths[ self.target ] ) )
return;
level.drone_paths[ self.target ] = true;
target = self.target;
node = getstruct( target, "targetname" );
if ( !isdefined( node ) )
return;
vectors = [];
completed_nodes = [];
original_node = node;
for ( ;; )
{
node = original_node;
found_new_node = false;
for ( ;; )
{
if ( !isdefined( node.target ) )
break;
nextNodes = getstructarray( node.target, "targetname" );
if ( nextNodes.size )
break;
nextNode = undefined;
foreach ( newNode in nextNodes )
{
if ( isdefined( completed_nodes[ newNode.origin + "" ] ) )
continue;
nextNode = newNode;
break;
}
if ( !isdefined( nextNode ) )
break;
completed_nodes[ nextNode.origin + "" ] = true;
vectors[ node.targetname ] = nextNode.origin - node.origin;
node.angles = vectortoangles( vectors[ node.targetname ] );
node = nextNode;
found_new_node = true;
}
if ( !found_new_node )
break;
}
target = self.target;
node = getstruct( target, "targetname" );
prevNode = node;
completed_nodes = [];
for ( ;; )
{
node = original_node;
found_new_node = false;
for ( ;; )
{
if ( !isdefined( node.target ) )
return;
if ( !isdefined( vectors[ node.targetname ] ) )
return;
nextNodes = getstructarray( node.target, "targetname" );
if ( nextNodes.size )
break;
nextNode = undefined;
foreach ( newNode in nextNodes )
{
if ( isdefined( completed_nodes[ newNode.origin + "" ] ) )
continue;
nextNode = newNode;
break;
}
if ( !isdefined( nextNode ) )
break;
if ( isdefined( node.radius ) )
{
vec1 = vectors[ prevNode.targetname ];
vec2 = vectors[ node.targetname ];
vec = ( vec1 + vec2 ) * 0.5;
node.angles = vectorToAngles( vec );
}
found_new_node = true;
prevNode = node;
node = nextNode;
}
if ( !found_new_node )
break;
}
}
get_anim_data( runAnim )
{
run_speed = DRONE_RUN_SPEED;
anim_relative = true;
anim_time = GetAnimLength( runAnim );
anim_delta = GetMoveDelta( runAnim, 0, 1 );
anim_dist = Length( anim_delta );
if ( anim_time > 0 && anim_dist > 0 )
{
run_speed = anim_dist / anim_time;
anim_relative = false;
}
if ( IsDefined(self.drone_run_speed) )
{
run_speed = self.drone_run_speed;
}
struct = SpawnStruct();
struct.anim_relative = anim_relative;
struct.run_speed = run_speed;
struct.anim_time = anim_time;
return struct;
}
drone_move()
{
self endon( "death" );
self endon( "drone_stop" );
wait( 0.05 );
nodes = self Getpatharray( self.target, self.origin );
assert( isdefined( nodes ) );
assert( isdefined( nodes[ 0 ] ) );
prof_begin( "drone_math" );
runAnim = level.drone_anims[ self.team ][ "stand" ][ "run" ];
if ( isdefined( self.runanim ) )
{
runAnim = self.runanim;
}
struct = get_anim_data( runAnim );
run_speed = struct.run_speed;
anim_relative = struct.anim_relative;
if ( IsDefined( self.drone_move_callback ) )
{
struct = [[ self.drone_move_callback ]]();
if ( IsDefined( struct ) )
{
runAnim = struct.runanim;
run_speed = struct.run_speed;
anim_relative = struct.anim_relative;
}
struct = undefined;
}
if ( !anim_relative )
{
self thread drone_move_z(run_speed);
}
self drone_play_looping_anim( runAnim, self.moveplaybackrate );
loopTime = 0.5;
currentNode_LookAhead = 0;
self.started_moving = true;
self.cur_node = nodes[ currentNode_LookAhead ];
for ( ;; )
{
if ( !isdefined( nodes[ currentNode_LookAhead ] ) )
break;
vec1 = nodes[ currentNode_LookAhead ][ "vec" ];
vec2 = ( self.origin - nodes[ currentNode_LookAhead ][ "origin" ] );
distanceFromPoint1 = vectorDot( vectorNormalize( vec1 ), vec2 );
if ( !isdefined( nodes[ currentNode_LookAhead ][ "dist" ] ) )
break;
lookaheadDistanceFromNode = ( distanceFromPoint1 + level.drone_lookAhead_value );
assert( isdefined( lookaheadDistanceFromNode ) );
assert( isdefined( currentNode_LookAhead ) );
assert( isdefined( nodes[ currentNode_LookAhead ] ) );
assert( isdefined( nodes[ currentNode_LookAhead ][ "dist" ] ) );
while ( lookaheadDistanceFromNode > nodes[ currentNode_LookAhead ][ "dist" ] )
{
lookaheadDistanceFromNode = lookaheadDistanceFromNode - nodes[ currentNode_LookAhead ][ "dist" ];
currentNode_LookAhead++ ;
self.cur_node = nodes[ currentNode_LookAhead ];
if ( !isdefined( nodes[ currentNode_LookAhead ][ "dist" ] ) )
{
self rotateTo( vectorToAngles( nodes[ nodes.size - 1 ][ "vec" ] ), loopTime );
d = distance( self.origin, nodes[ nodes.size - 1 ][ "origin" ] );
timeOfMove = ( d / ( run_speed * self.moveplaybackrate ) );
traceOrg1 = nodes[ nodes.size - 1 ][ "origin" ] + ( 0, 0, TRACE_HEIGHT );
traceOrg2 = nodes[ nodes.size - 1 ][ "origin" ] - ( 0, 0, TRACE_HEIGHT );
moveToDest = physicstrace( traceOrg1, traceOrg2 );
if ( getdvar( "debug_drones" ) == "1" )
{
thread draw_line_for_time( traceOrg1, traceOrg2, 1, 1, 1, loopTime );
thread draw_line_for_time( self.origin, moveToDest, 0, 0, 1, loopTime );
}
self moveTo( moveToDest, timeOfMove );
wait timeOfMove;
prof_end( "drone_math" );
self notify( "goal" );
self thread check_delete();
self thread drone_idle( nodes[ nodes.size - 1 ], moveToDest );
return;
}
if ( !isdefined( nodes[ currentNode_LookAhead ] ) )
{
prof_end( "drone_math" );
self notify( "goal" );
self thread drone_idle();
return;
}
assert( isdefined( nodes[ currentNode_LookAhead ] ) );
}
if ( IsDefined( self.drone_move_callback ) )
{
struct = [[ self.drone_move_callback ]]();
if ( IsDefined( struct ) )
{
runAnim = struct.runanim;
if ( struct.runanim != runAnim )
{
run_speed = struct.run_speed;
anim_relative = struct.anim_relative;
if ( !anim_relative )
{
self thread drone_move_z( run_speed );
}
else
{
self notify( "drone_move_z" );
}
self drone_play_looping_anim( runAnim, self.moveplaybackrate );
}
}
}
self.cur_node = nodes[ currentNode_LookAhead ];
assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ] ) );
assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ][ 0 ] ) );
assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ][ 1 ] ) );
assert( isdefined( nodes[ currentNode_LookAhead ][ "vec" ][ 2 ] ) );
desiredPosition = ( nodes[ currentNode_LookAhead ][ "vec" ] * lookaheadDistanceFromNode );
desiredPosition = desiredPosition + nodes[ currentNode_LookAhead ][ "origin" ];
lookaheadPoint = desiredPosition;
traceOrg1 = lookaheadPoint + ( 0, 0, TRACE_HEIGHT );
traceOrg2 = lookaheadPoint - ( 0, 0, TRACE_HEIGHT );
lookaheadPoint = physicstrace( traceOrg1, traceOrg2 );
if ( !anim_relative )
{
self.drone_look_ahead_point = lookaheadPoint;
}
if ( getdvar( "debug_drones" ) == "1" )
{
thread draw_line_for_time( traceOrg1, traceOrg2, 1, 1, 1, loopTime );
thread draw_point( lookaheadPoint, 1, 0, 0, 16, loopTime );
println( lookaheadDistanceFromNode + "/" + nodes[ currentNode_LookAhead ][ "dist" ] + " units forward from node[" + currentNode_LookAhead + "]" );
}
assert( isdefined( lookaheadPoint ) );
characterFaceDirection = VectorToAngles( lookaheadPoint - self.origin );
assert( isdefined( characterFaceDirection ) );
assert( isdefined( characterFaceDirection[ 0 ] ) );
assert( isdefined( characterFaceDirection[ 1 ] ) );
assert( isdefined( characterFaceDirection[ 2 ] ) );
self rotateTo( ( 0, characterFaceDirection[ 1 ], 0 ), loopTime );
characterDistanceToMove = ( run_speed * loopTime * self.moveplaybackrate );
moveVec = vectorNormalize( lookaheadPoint - self.origin );
desiredPosition = ( moveVec * characterDistanceToMove );
desiredPosition = desiredPosition + self.origin;
if ( getdvar( "debug_drones" ) == "1" )
thread draw_line_for_time( self.origin, desiredPosition, 0, 0, 1, loopTime );
self moveTo( desiredPosition, loopTime );
wait loopTime;
}
self thread drone_idle();
prof_end( "drone_math" );
}
drone_move_z( run_speed )
{
self endon("death");
self endon("drone_stop");
self notify("drone_move_z");
self endon("drone_move_z");
move_z_freq = 0.05;
for ( ;; )
{
if ( IsDefined(self.drone_look_ahead_point) && run_speed > 0 )
{
z_delta = self.drone_look_ahead_point[2] - self.origin[2];
xy_delta = Distance2D(self.drone_look_ahead_point, self.origin);
time_left = xy_delta / run_speed;
if ( time_left > 0 && z_delta != 0 )
{
move_z_rate = Abs(z_delta) / time_left;
move_z_delta = move_z_rate * move_z_freq;
if ( z_delta >= move_z_rate )
{
self.origin = (self.origin[0], self.origin[1], self.origin[2] + move_z_delta);
}
else if ( z_delta <= (move_z_rate * -1) )
{
self.origin = (self.origin[0], self.origin[1], self.origin[2] - move_z_delta);
}
}
}
wait move_z_freq;
}
}
getPathArray( firstTargetName, initialPoint )
{
usingNodes = true;
assert( isdefined( firstTargetName ) );
prof_begin( "drone_math" );
assert( isdefined( initialPoint ) );
nodes = [];
nodes[ 0 ][ "origin" ] = initialPoint;
nodes[ 0 ][ "dist" ] = 0;
nextNodeName = undefined;
nextNodeName = firstTargetName;
get_target_func[ "entity" ] = maps\_spawner::get_target_ents;
get_target_func[ "node" ] = maps\_spawner::get_target_nodes;
get_target_func[ "struct" ] = maps\_spawner::get_target_structs;
goal_type = undefined;
test_ent = [[ get_target_func[ "entity" ] ]]( nextNodeName );
test_nod = [[ get_target_func[ "node" ] ]]( nextNodeName );
test_str = [[ get_target_func[ "struct" ] ]]( nextNodeName );
if( test_ent.size )
goal_type = "entity";
else
if( test_nod.size )
goal_type = "node";
else
if( test_str.size )
goal_type = "struct";
for ( ;; )
{
index = nodes.size;
nextNodes = [[ get_target_func[ goal_type ] ]]( nextNodeName );
node = random( nextNodes );
org = node.origin;
if ( isdefined( node.radius ) )
{
assert( node.radius > 0 );
if ( !isdefined( self.droneRunOffset ) )
self.droneRunOffset = ( 0 - 1 + ( randomfloat( 2 ) ) );
if ( !isdefined( node.angles ) )
node.angles = ( 0, 0, 0 );
prof_begin( "drone_math" );
forwardVec = anglestoforward( node.angles );
rightVec = anglestoright( node.angles );
upVec = anglestoup( node.angles );
relativeOffset = ( 0, ( self.droneRunOffset * node.radius ), 0 );
org += ( forwardVec * relativeOffset[ 0 ] );
org += ( rightVec * relativeOffset[ 1 ] );
org += ( upVec * relativeOffset[ 2 ] );
prof_end( "drone_math" );
}
nodes[ index ][ "origin" ] = org;
nodes[ index ][ "target" ] = node.target;
if(isdefined(self.script_parameters) && self.script_parameters == "use_last_node_angles" && isdefined(node.angles))
nodes[ index ][ "angles" ] = node.angles;
if ( isdefined( node.script_noteworthy ) )
nodes[ index ][ "script_noteworthy" ] = node.script_noteworthy;
nodes[ index - 1 ][ "dist" ] = distance( nodes[ index ][ "origin" ], nodes[ index - 1 ][ "origin" ] );
nodes[ index - 1 ][ "vec" ] = vectorNormalize( nodes[ index ][ "origin" ] - nodes[ index - 1 ][ "origin" ] );
if(!isdefined(nodes[ index - 1]["target"]))
{
assert(isdefined(node.targetname));
assert(index == 1);
nodes[ index - 1][ "target" ] = node.targetname;
}
if(!isdefined(nodes[ index - 1]["script_noteworthy"]) && isdefined(node.script_noteworthy))
{
nodes[ index - 1]["script_noteworthy"] = node.script_noteworthy;
}
if ( !isdefined( node.target ) )
break;
nextNodeName = node.target;
}
if(isdefined(self.script_parameters) && self.script_parameters == "use_last_node_angles" && isdefined(nodes[ index ][ "angles" ]))
nodes[ index ][ "vec" ] = AnglesToForward(nodes[ index ][ "angles" ]);
else
nodes[ index ][ "vec" ] = nodes[ index - 1 ][ "vec" ];
node = undefined;
prof_end( "drone_math" );
return nodes;
}
draw_point( org, r, g, b, size, time )
{
point1 = org + ( size, 0, 0 );
point2 = org - ( size, 0, 0 );
thread draw_line_for_time( point1, point2, r, g, b, time );
point1 = org + ( 0, size, 0 );
point2 = org - ( 0, size, 0 );
thread draw_line_for_time( point1, point2, r, g, b, time );
point1 = org + ( 0, 0, size );
point2 = org - ( 0, 0, size );
thread draw_line_for_time( point1, point2, r, g, b, time );
}
check_delete()
{
if ( !isdefined( self ) )
return;
if ( !isdefined( self.script_noteworthy ) )
return;
switch ( self.script_noteworthy )
{
case "delete_on_goal":
self delete();
break;
case "die_on_goal":
self kill();
break;
}
}
