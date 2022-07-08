
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle_aianim;
#include common_scripts\utility;
#using_animtree( "vehicles" );
CONST_MPHCONVERSION = 17.6;
CONST_bp_height = 300;
init_vehicles()
{
if ( IsDefined( level.disableVehicleScripts ) && level.disableVehicleScripts )
return;
level.heli_default_decel = 10;
init_helicopter_list();
init_airplane_list();
setup_dvars();
setup_levelvars();
setup_vehicle_spawners();
array_thread( GetEntArray( "truckjunk", "targetname" ), ::truckjunk );
array_thread( GetEntArray( "truckjunk", "script_noteworthy" ), ::truckjunk );
array_thread( getstructarray( "truckjunk", "targetname" ), ::truckjunk );
array_thread( getstructarray( "truckjunk", "script_noteworthy" ), ::truckjunk );
setup_ai();
setup_triggers();
allvehiclesprespawn = precache_scripts();
setup_vehicles( allvehiclesprespawn );
array_levelthread( level.vehicle_processtriggers, ::trigger_process, allvehiclesprespawn );
array_thread( getstructarray( "gag_stage_littlebird_unload", "script_noteworthy" ), ::setup_gag_stage_littlebird_unload );
array_thread( getstructarray( "gag_stage_littlebird_load", "script_noteworthy" ), ::setup_gag_stage_littlebird_load );
level.vehicle_processtriggers = undefined;
init_level_has_vehicles();
add_hint_string( "invulerable_frags", &"SCRIPT_INVULERABLE_FRAGS", undefined );
add_hint_string( "invulerable_bullets", &"SCRIPT_INVULERABLE_BULLETS", undefined );
}
init_helicopter_list()
{
level.helicopter_list = [];
level.helicopter_list[ "blackhawk" ] = true;
level.helicopter_list[ "blackhawk_minigun" ] = true;
level.helicopter_list[ "apache" ] = true;
level.helicopter_list[ "seaknight" ] = true;
level.helicopter_list[ "seaknight_airlift" ] = true;
level.helicopter_list[ "hind" ] = true;
level.helicopter_list[ "ny_harbor_hind" ] = true;
level.helicopter_list[ "ny_harbor_blackhawk" ] = true;
level.helicopter_list[ "mi17" ] = true;
level.helicopter_list[ "mi17_noai" ] = true;
level.helicopter_list[ "cobra" ] = true;
level.helicopter_list[ "cobra_player" ] = true;
level.helicopter_list[ "viper" ] = true;
level.helicopter_list[ "littlebird_player" ] = true;
level.helicopter_list[ "littlebird" ] = true;
level.helicopter_list[ "mi28" ] = true;
level.helicopter_list[ "pavelow" ] = true;
level.helicopter_list[ "pavelow_noai" ] = true;
level.helicopter_list[ "harrier" ] = true;
level.helicopter_list[ "lynx" ] = true;
level.helicopter_list[ "blackhawk_so" ] = true;
level.helicopter_list[ "blackhawk_minigun_so" ] = true;
level.helicopter_list[ "blackhawk_minigun_so_ac130" ] = true;
level.helicopter_list[ "cobra_so" ] = true;
level.helicopter_list[ "mi17_so" ] = true;
level.helicopter_list[ "mi17_so_takes_damage" ] = true;
level.helicopter_list[ "littlebird_so" ] = true;
}
init_airplane_list()
{
level.airplane_list = [];
level.airplane_list[ "mig29" ] = true;
level.airplane_list[ "b2" ] = true;
level.airplane_list[ "a10_warthog" ] = true;
level.airplane_list[ "osprey" ] = true;
}
init_level_has_vehicles()
{
level.levelHasVehicles = false;
vehicles = GetEntArray( "script_vehicle", "code_classname" );
if ( vehicles.size > 0 )
level.levelHasVehicles = true;
}
trigger_getlinkmap( trigger )
{
linkMap = [];
if ( IsDefined( trigger.script_linkTo ) )
{
links = StrTok( trigger.script_linkTo, " " );
foreach ( link in links )
linkMap[ link ] = true;
links = undefined;
}
return linkMap;
}
setup_script_gatetrigger( trigger )
{
gates = [];
if ( IsDefined( trigger.script_gatetrigger ) )
return level.vehicle_gatetrigger[ trigger.script_gatetrigger ];
return gates;
}
setup_script_vehiclespawngroup( trigger, vehicles )
{
script_vehiclespawngroup = false;
if ( IsDefined( trigger.script_VehicleSpawngroup ) )
script_vehiclespawngroup = true;
return script_vehiclespawngroup;
}
setup_vehicle_spawners()
{
spawners = _getvehiclespawnerarray();
foreach ( spawner in spawners )
{
spawner thread vehicle_spawn_think();
}
}
vehicle_spawn_think()
{
if ( IsDefined( self.script_kill_vehicle_spawner ) )
{
group = self.script_kill_vehicle_spawner;
if ( !IsDefined( level.vehicle_killspawn_groups[ group ] ) )
{
level.vehicle_killspawn_groups[ group ] = [];
}
level.vehicle_killspawn_groups[ group ][ level.vehicle_killspawn_groups[ group ].size ] = self;
}
if ( IsDefined( self.script_deathflag ) )
thread maps\_spawner::vehicle_spawner_deathflag();
self thread vehicle_linked_entities_think();
self.count = 1;
self.spawn_functions = [];
for ( ;; )
{
vehicle = undefined;
self waittill( "spawned", vehicle );
self.count--;
if ( !IsDefined( vehicle ) )
{
PrintLn( "Vehicle spawned from spawner at " + self.origin + " but didnt exist!" );
continue;
}
vehicle.spawn_funcs = self.spawn_functions;
vehicle.spawner = self;
vehicle thread maps\_spawner::run_spawn_functions();
}
}
vehicle_linked_entities_think()
{
if ( !IsDefined( self.script_vehiclecargo ) )
return;
if ( !IsDefined( self.script_linkTo ) )
return;
aLinkedEnts = GetEntArray( self.script_linkTo, "script_linkname" );
if ( aLinkedEnts.size == 0 )
return;
targetname = aLinkedEnts[ 0 ].targetname;
aLinkedEnts = GetEntArray( targetname, "targetname" );
eOrg = undefined;
foreach ( ent in aLinkedEnts )
{
if ( ent.classname == "script_origin" )
eOrg = ent;
ent Hide();
}
AssertEx( IsDefined( eOrg ), "Vehicles that have script_linkTo pointing to entities must have one of those entities be a script_origin to be used as a link point of reference" );
foreach ( ent in aLinkedEnts )
{
if ( ent != eOrg )
ent LinkTo( eOrg );
}
self waittill( "spawned", vehicle );
foreach ( ent in aLinkedEnts )
{
ent Show();
if ( ent != eOrg )
ent LinkTo( vehicle );
}
vehicle waittill( "death" );
foreach ( ent in aLinkedEnts )
ent Delete();
}
is_trigger_once()
{
if ( !IsDefined( self.classname ) )
return false;
if ( self.classname == "trigger_multiple" )
return true;
if ( self.classname == "trigger_radius" )
return true;
if ( self.classname == "trigger_lookat" )
return true;
return self.classname == "trigger_disk";
}
trigger_process( trigger, vehicles )
{
bTriggerOnce = trigger is_trigger_once();
trigger.processed_trigger = undefined;
if ( IsDefined( trigger.script_noteworthy ) && trigger.script_noteworthy == "trigger_multiple" )
bTriggeronce = false;
gates = setup_script_gatetrigger( trigger );
script_vehiclespawngroup = IsDefined( trigger.script_VehicleSpawngroup );
script_vehicledetour = IsDefined( trigger.script_vehicledetour ) && ( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );
detoured = IsDefined( trigger.detoured ) && !( is_node_script_origin( trigger ) || is_node_script_struct( trigger ) );
gotrigger = true;
vehicles = undefined;
while ( gotrigger )
{
trigger waittill( "trigger", other );
if ( IsDefined( trigger.script_vehicletriggergroup ) )
{
if ( !IsDefined( other.script_vehicletriggergroup ) )
continue;
if ( other.script_vehicletriggergroup != trigger.script_vehicletriggergroup )
continue;
}
if ( IsDefined( trigger.enabled ) && !trigger.enabled )
trigger waittill( "enable" );
if ( IsDefined( trigger.script_flag_set ) )
{
if ( IsDefined( other.vehicle_flags ) )
other.vehicle_flags[ trigger.script_flag_set ] = true;
other notify( "vehicle_flag_arrived", trigger.script_flag_set );
flag_set( trigger.script_flag_set );
}
if ( IsDefined( trigger.script_flag_clear ) )
{
if ( IsDefined( other.vehicle_flags ) )
other.vehicle_flags[ trigger.script_flag_clear ] = false;
flag_clear( trigger.script_flag_clear );
}
if ( script_vehicledetour )
other thread path_detour_script_origin( trigger );
else if ( detoured && IsDefined( other ) )
other thread path_detour( trigger );
trigger script_delay();
if ( bTriggeronce )
gotrigger = false;
if ( IsDefined( trigger.script_vehicleGroupDelete ) )
{
if ( !IsDefined( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] ) )
{
PrintLn( "failed to find deleteable vehicle with script_vehicleGroupDelete group number: ", trigger.script_vehicleGroupDelete );
level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ] = [];
}
array_levelthread( level.vehicle_DeleteGroup[ trigger.script_vehicleGroupDelete ], ::deleteEnt );
}
if ( script_vehiclespawngroup )
{
scripted_spawn( trigger.script_VehicleSpawngroup );
}
if ( gates.size > 0 && bTriggeronce )
array_levelthread( gates, ::path_gate_open );
if ( IsDefined( trigger.script_VehicleStartMove ) )
{
if ( !IsDefined( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ] ) )
{
PrintLn( "^3Vehicle start trigger is: ", trigger.script_VehicleStartMove );
return;
}
array_levelthread( level.vehicle_StartMoveGroup[ trigger.script_VehicleStartMove ], ::gopath );
}
}
}
path_detour_get_detourpath( detournode )
{
detourpath = undefined;
foreach ( vehicle_detourpath in level.vehicle_detourpaths[ detournode.script_vehicledetour ] )
{
if ( vehicle_detourpath != detournode )
if ( !islastnode( vehicle_detourpath ) )
detourpath = vehicle_detourpath;
}
return detourpath;
}
path_detour_script_origin( detournode )
{
detourpath = path_detour_get_detourpath( detournode );
if ( IsDefined( detourpath ) )
self thread vehicle_paths( detourpath );
}
crash_detour_check( detourpath )
{
Assert( IsDefined( detourpath.script_crashtype ) );
return
(
(
IsDefined( self.deaddriver )
|| ( self.health < self.healthbuffer )
|| detourpath.script_crashtype == "forced"
)
&&
(
!IsDefined( detourpath.derailed )
|| detourpath.script_crashtype == "plane"
)
);
}
crash_derailed_check( detourpath )
{
return IsDefined( detourpath.derailed ) && detourpath.derailed;
}
path_detour( node )
{
detournode = GetVehicleNode( node.target, "targetname" );
detourpath = path_detour_get_detourpath( detournode );
if ( ! IsDefined( detourpath ) )
return;
if ( node.detoured && !IsDefined( detourpath.script_vehicledetourgroup ) )
return;
if ( IsDefined( detourpath.script_crashtype ) )
{
if ( !crash_detour_check( detourpath ) )
return;
self notify( "crashpath", detourpath );
detourpath.derailed = 1;
self notify( "newpath" );
self _SetSwitchNode( node, detourpath );
return;
}
else
{
if ( crash_derailed_check( detourpath ) )
return;
if ( IsDefined( detourpath.script_vehicledetourgroup ) )
{
if ( !IsDefined( self.script_vehicledetourgroup ) )
return;
if ( detourpath.script_vehicledetourgroup != self.script_vehicledetourgroup )
return;
}
self notify( "newpath" );
self _SetSwitchNode( detournode, detourpath );
thread detour_flag( detourpath );
if ( !islastnode( detournode ) && !( IsDefined( node.scriptdetour_persist ) && node.scriptdetour_persist ) )
node.detoured = 1;
self.attachedpath = detourpath;
thread vehicle_paths();
if ( self Vehicle_IsPhysVeh() && IsDefined( detournode.script_transmission ) )
self thread reverse_node( detournode );
return;
}
}
reverse_node( detournode )
{
self endon( "death" );
detournode waittillmatch( "trigger", self );
self.veh_transmission = detournode.script_transmission;
if ( self.veh_transmission == "forward" )
self vehicle_wheels_forward();
else
self vehicle_wheels_backward();
}
_SetSwitchNode( detournode, detourpath )
{
AssertEx( !( detourpath.lookahead == 1 && detourpath.speed == 1 ), "Detourpath has lookahead and speed of 1, this is indicative that neither has been set." );
self SetSwitchNode( detournode, detourpath );
}
detour_flag( detourpath )
{
self endon( "death" );
self.detouringpath = detourpath;
detourpath waittillmatch( "trigger", self );
self.detouringpath = undefined;
}
vehicle_Levelstuff( vehicle, trigger )
{
if ( IsDefined( vehicle.script_linkName ) )
level.vehicle_link = array_2dadd( level.vehicle_link, vehicle.script_linkname, vehicle );
if ( IsDefined( vehicle.script_VehicleStartMove ) )
level.vehicle_StartMoveGroup = array_2dadd( level.vehicle_StartMoveGroup, vehicle.script_VehicleStartMove, vehicle );
if ( IsDefined( vehicle.script_vehicleGroupDelete ) )
level.vehicle_DeleteGroup = array_2dadd( level.vehicle_DeleteGroup, vehicle.script_vehicleGroupDelete, vehicle );
}
spawn_array( spawners )
{
ai = [];
stalinggradspawneverybody = ent_flag_exist( "no_riders_until_unload" );
foreach ( spawner in spawners )
{
spawner.count = 1;
dronespawn = false;
if ( IsDefined( spawner.script_drone ) )
{
dronespawn = true;
spawned = dronespawn_bodyonly( spawner );
spawned maps\_drone::drone_give_soul();
Assert( IsDefined( spawned ) );
}
else
{
dontShareEnemyInfo = ( IsDefined( spawner.script_stealth ) && flag( "_stealth_enabled" ) && !flag( "_stealth_spotted" ) );
if ( IsDefined( spawner.script_forcespawn ) || stalinggradspawneverybody )
spawned = spawner StalingradSpawn( dontShareEnemyInfo );
else
spawned = spawner DoSpawn( dontShareEnemyInfo );
}
if ( !dronespawn && !IsAlive( spawned ) )
continue;
Assert( IsDefined( spawned ) );
ai[ ai.size ] = spawned;
}
ai = remove_non_riders_from_array( ai );
return ai;
}
remove_non_riders_from_array( aiarray )
{
living_ai = [];
foreach ( ai in aiarray )
{
if ( !ai_should_be_added( ai ) )
continue;
living_ai[ living_ai.size ] = ai;
}
return living_ai;
}
ai_should_be_added( ai )
{
if ( IsAlive( ai ) )
return true;
if ( !IsDefined( ai ) )
return false;
if ( !IsDefined( ai.classname ) )
return false;
return ai.classname == "script_model";
}
get_vehicle_ai_spawners()
{
spawners = [];
if ( IsDefined( self.target ) )
{
targets = GetEntArray( self.target, "targetname" );
foreach ( target in targets )
{
if ( !IsSubStr( target.code_classname, "actor" ) )
continue;
if ( !( target.spawnflags & 1 ) )
continue;
if ( IsDefined( target.dont_auto_ride ) )
continue;
spawners[ spawners.size ] = target;
}
}
if ( !IsDefined( self.script_vehicleride ) )
return spawners;
if ( IsDefined( level.vehicle_RideSpawners[ self.script_vehicleride ] ) )
spawners = array_combine( spawners, level.vehicle_RideSpawners[ self.script_vehicleride ] );
return spawners;
}
get_vehicle_ai_riders()
{
if ( !IsDefined( self.script_vehicleride ) )
return [];
if ( !IsDefined( level.vehicle_RideAI[ self.script_vehicleride ] ) )
return [];
return level.vehicle_RideAI[ self.script_vehicleride ];
}
spawn_group()
{
if ( ent_flag_exist( "no_riders_until_unload" ) && !ent_flag( "no_riders_until_unload" ) )
{
return [];
}
spawners = get_vehicle_ai_spawners();
if ( !spawners.size )
return [];
startinvehicles = [];
ai = spawn_array( spawners );
ai = array_combine( ai, get_vehicle_ai_riders() );
ai = sort_by_startingpos( ai );
foreach ( guy in ai )
self thread maps\_vehicle_aianim::guy_enter( guy );
return ai;
}
spawn_unload_group( who )
{
if ( !IsDefined( who ) )
{
return spawn_group();
}
AssertEx( ( ent_flag_exist( "no_riders_until_unload" ) && ent_flag( "no_riders_until_unload" ) ), "spawn_unload_group only used when no_riders_until_unload specified" );
spawners = get_vehicle_ai_spawners();
if ( !spawners.size )
return [];
group_spawners = [];
classname = self.classname;
if( is_iw4_map_sp() )
classname = self.vehicletype;
if ( isdefined( level.vehicle_unloadgroups[ classname ] ) && isdefined( level.vehicle_unloadgroups[ classname ][ who ] ) )
{
group = level.vehicle_unloadgroups[ classname ][ who ];
for ( i = 0; i < group.size; i++ )
{
ride_pos = group[ i ];
group_spawners[ group_spawners.size ] = spawners[ ride_pos ];
}
ai = spawn_array( group_spawners );
for ( i = 0; i < group.size; i++ )
{
ai[ i ].script_startingposition = group[ i ];
}
ai = array_combine( ai, get_vehicle_ai_riders() );
ai = sort_by_startingpos( ai );
foreach ( guy in ai )
self thread maps\_vehicle_aianim::guy_enter( guy );
return ai;
}
else
{
return spawn_group();
}
}
sort_by_startingpos( guysarray )
{
firstarray = [];
secondarray = [];
foreach ( guy in guysarray )
{
if ( IsDefined( guy.script_startingposition ) )
firstarray[ firstarray.size ] = guy;
else
secondarray[ secondarray.size ] = guy;
}
return array_combine( firstarray, secondarray );
}
vehicle_rider_walk_setup( vehicle )
{
if ( !IsDefined( self.script_vehiclewalk ) )
return;
if ( IsDefined( self.script_followmode ) )
self.FollowMode = self.script_followmode;
else
self.FollowMode = "cover nodes";
if ( !IsDefined( self.target ) )
return;
node = GetNode( self.target, "targetname" );
if ( IsDefined( node ) )
self.NodeAftervehicleWalk = node;
}
runtovehicle( guy )
{
guyarray = [];
climbinnode = self.climbnode;
climbinanim = self.climbanim;
closenode = climbinnode[ 0 ];
currentdist = 5000;
thenode = undefined;
for ( i = 0; i < climbinnode.size; i++ )
{
climborg = self GetTagOrigin( climbinnode[ i ] );
climbang = self GetTagAngles( climbinnode[ i ] );
org = GetStartOrigin( climborg, climbang, climbinanim[ i ] );
Distance = Distance( guy.origin, climborg );
if ( Distance < currentdist )
{
currentdist = Distance;
closenode = climbinnode[ i ];
thenode = i;
}
}
climbang = undefined;
climborg = undefined;
thread runtovehicle_setgoal( guy );
while ( !guy.vehicle_goal )
{
climborg = self GetTagOrigin( climbinnode[ thenode ] );
climbang = self GetTagAngles( climbinnode[ thenode ] );
org = GetStartOrigin( climborg, climbang, climbinanim[ thenode ] );
guy set_forcegoal();
guy SetGoalPos( org );
guy.goalradius = 64;
wait 0.25;
}
guy unset_forcegoal();
if ( self Vehicle_GetSpeed() < 1 )
{
guy LinkTo( self );
guy AnimScripted( "hopinend", climborg, climbang, climbinanim[ thenode ] );
guy waittillmatch( "hopinend", "end" );
self guy_enter_vehicle( guy );
}
}
runtovehicle_setgoal( guy )
{
guy.vehicle_goal = false;
self endon( "death" );
guy endon( "death" );
guy waittill( "goal" );
guy.vehicle_goal = true;
}
setup_groundnode_detour( node )
{
realdetournode = GetVehicleNode( node.targetname, "target" );
if ( !IsDefined( realdetournode ) )
return;
realdetournode.detoured = 0;
AssertEx( !IsDefined( realdetournode.script_vehicledetour ), "Detour nodes require one non-detour node before another detournode!" );
add_proccess_trigger( realdetournode );
}
turn_unloading_drones_to_ai()
{
unload_group = self get_unload_group();
foreach ( index, rider in self.riders )
{
if ( !IsAlive( rider ) )
continue;
if ( IsDefined( unload_group[ rider.vehicle_position ] ) )
self.riders[ index ] = self guy_becomes_real_ai( rider, rider.vehicle_position );
}
}
add_proccess_trigger( trigger )
{
if ( IsDefined( trigger.processed_trigger ) )
return;
level.vehicle_processtriggers[ level.vehicle_processtriggers.size ] = trigger;
trigger.processed_trigger = true;
}
islastnode( node )
{
if ( !IsDefined( node.target ) )
return true;
if ( !IsDefined( GetVehicleNode( node.target, "targetname" ) ) && !IsDefined( get_vehiclenode_any_dynamic( node.target ) ) )
return true;
return false;
}
get_path_getfunc( pathpoint )
{
get_func = ::get_from_vehicle_node;
if ( isHelicopter() && IsDefined( pathpoint.target ) )
{
if ( IsDefined( get_from_entity( pathpoint.target ) ) )
get_func = ::get_from_entity;
if ( IsDefined( get_from_spawnstruct( pathpoint.target ) ) )
get_func = ::get_from_spawnstruct;
}
return get_func;
}
path_array_setup( pathpoint )
{
get_func = ::get_from_vehicle_node;
if ( isHelicopter() && IsDefined( pathpoint.target ) )
{
if ( IsDefined( get_from_entity( pathpoint.target ) ) )
get_func = ::get_from_entity;
if ( IsDefined( get_from_spawnstruct( pathpoint.target ) ) )
get_func = ::get_from_spawnstruct;
}
arraycount = 0;
pathpoints = [];
while ( IsDefined( pathpoint ) )
{
pathpoints[ arraycount ] = pathpoint;
arraycount++;
if ( IsDefined( pathpoint.target ) )
pathpoint =[[ get_func ] ] ( pathpoint.target );
else
break;
}
return pathpoints;
}
node_wait( nextpoint, lastpoint )
{
if ( self.attachedpath == nextpoint )
{
waittillframeend;
return;
}
nextpoint waittillmatch( "trigger", self );
}
vehicle_paths( node, bhelicopterwaitforstart )
{
if ( ishelicopter() )
vehicle_paths_helicopter( node, bhelicopterwaitforstart );
else
vehicle_paths_non_heli( node );
}
vehicle_paths_non_heli( node )
{
AssertEx( IsDefined( node ) || IsDefined( self.attachedpath ), "vehicle_path() called without a path" );
self notify( "newpath" );
if ( IsDefined( node ) )
self.attachedpath = node;
pathstart = self.attachedpath;
self.currentNode = self.attachedpath;
if ( !IsDefined( pathstart ) )
return;
self endon( "newpath" );
pathpoint = pathstart;
lastpoint = undefined;
nextpoint = pathstart;
get_func = get_path_getfunc( pathstart );
while ( IsDefined( nextpoint ) )
{
node_wait( nextpoint, lastpoint );
if ( !IsDefined( self ) )
return;
self.currentNode = nextpoint;
if ( IsDefined( nextpoint.gateopen ) && !nextpoint.gateopen )
self thread path_gate_wait_till_open( nextpoint );
if ( IsDefined( nextpoint.script_noteworthy ) )
{
self notify( nextpoint.script_noteworthy );
self notify( "noteworthy", nextpoint.script_noteworthy );
}
waittillframeend;
if ( !IsDefined( self ) )
return;
if ( IsDefined( nextpoint.script_prefab_exploder ) )
{
nextpoint.script_exploder = nextpoint.script_prefab_exploder;
nextpoint.script_prefab_exploder = undefined;
}
if ( IsDefined( nextpoint.script_exploder ) )
{
delay = nextpoint.script_exploder_delay;
if ( IsDefined( delay ) )
{
level delayThread( delay, ::exploder, nextpoint.script_exploder );
}
else
{
level exploder( nextpoint.script_exploder );
}
}
if ( IsDefined( nextpoint.script_flag_set ) )
{
if ( IsDefined( self.vehicle_flags ) )
self.vehicle_flags[ nextpoint.script_flag_set ] = true;
self notify( "vehicle_flag_arrived", nextpoint.script_flag_set );
flag_set( nextpoint.script_flag_set );
}
if ( IsDefined( nextpoint.script_ent_flag_set ) )
{
self ent_flag_set( nextpoint.script_ent_flag_set );
}
if ( IsDefined( nextpoint.script_ent_flag_clear ) )
{
self ent_flag_clear( nextpoint.script_ent_flag_clear );
}
if ( IsDefined( nextpoint.script_flag_clear ) )
{
if ( IsDefined( self.vehicle_flags ) )
self.vehicle_flags[ nextpoint.script_flag_clear ] = false;
flag_clear( nextpoint.script_flag_clear );
}
if ( IsDefined( nextpoint.script_noteworthy ) )
{
if ( nextpoint.script_noteworthy == "kill" )
self force_kill();
if ( nextpoint.script_noteworthy == "godon" )
self godon();
if ( nextpoint.script_noteworthy == "godoff" )
self godoff();
if ( nextpoint.script_noteworthy == "deleteme" )
{
level thread deleteent( self );
return;
}
}
if ( IsDefined( nextpoint.script_crashtypeoverride ) )
self.script_crashtypeoverride = nextpoint.script_crashtypeoverride;
if ( IsDefined( nextpoint.script_badplace ) )
self.script_badplace = nextpoint.script_badplace;
if ( IsDefined( nextpoint.script_turretmg ) )
self.script_turretmg = nextpoint.script_turretmg;
if ( IsDefined( nextpoint.script_team ) )
self.script_team = nextpoint.script_team;
if ( IsDefined( nextpoint.script_turningdir ) )
self notify( "turning", nextpoint.script_turningdir );
if ( IsDefined( nextpoint.script_deathroll ) )
if ( nextpoint.script_deathroll == 0 )
self thread deathrolloff();
else
self thread deathrollon();
if ( IsDefined( nextpoint.script_vehicleaianim ) )
{
if ( IsDefined( nextpoint.script_parameters ) && nextpoint.script_parameters == "queue" )
self.queueanim = true;
}
if ( IsDefined( nextpoint.script_wheeldirection ) )
self wheeldirectionchange( nextpoint.script_wheeldirection );
if ( vehicle_should_unload( ::node_wait, nextpoint ) )
self thread unload_node( nextpoint );
if ( IsDefined( nextpoint.script_transmission ) )
{
self.veh_transmission = nextpoint.script_transmission;
if ( self.veh_transmission == "forward" )
self vehicle_wheels_forward();
else
self vehicle_wheels_backward();
}
if ( IsDefined( nextpoint.script_brake ) )
{
self.veh_brake = nextpoint.script_brake;
}
if ( IsDefined( nextpoint.script_pathtype ) )
self.veh_pathtype = nextpoint.script_pathtype;
if ( IsDefined( nextpoint.script_ent_flag_wait ) )
{
decel = 35;
if ( IsDefined( nextpoint.script_decel ) )
{
decel = nextpoint.script_decel;
}
self Vehicle_SetSpeed( 0, decel );
self ent_flag_wait( nextpoint.script_ent_flag_wait );
if ( !IsDefined( self ) )
return;
accel = 60;
if ( IsDefined( nextpoint.script_accel ) )
{
accel = nextpoint.script_accel;
}
self ResumeSpeed( accel );
}
if ( IsDefined( nextpoint.script_delay ) )
{
decel = 35;
if ( IsDefined( nextpoint.script_decel ) )
decel = nextpoint.script_decel;
self Vehicle_SetSpeed( 0, decel );
if ( IsDefined( nextpoint.target ) )
self thread overshoot_next_node([[ get_func ] ] ( nextpoint.target ) );
nextpoint script_delay();
self notify( "delay_passed" );
accel = 60;
if ( IsDefined( nextpoint.script_accel ) )
{
accel = nextpoint.script_accel;
}
self ResumeSpeed( accel );
}
if ( IsDefined( nextpoint.script_flag_wait ) )
{
if ( !IsDefined( self.vehicle_flags ) )
{
self.vehicle_flags = [];
}
self.vehicle_flags[ nextpoint.script_flag_wait ] = true;
self notify( "vehicle_flag_arrived", nextpoint.script_flag_wait );
was_stopped = false;
if ( !flag( nextpoint.script_flag_wait ) || IsDefined( nextpoint.script_delay_post ) )
{
was_stopped = true;
accel = 5;
decel = 35;
if ( IsDefined( nextpoint.script_accel ) )
accel = nextpoint.script_accel;
if ( IsDefined( nextpoint.script_decel ) )
decel = nextpoint.script_decel;
self vehicle_stop_named( "script_flag_wait_" + nextpoint.script_flag_wait, accel, decel );
self thread overshoot_next_node([[ get_func ] ] ( nextpoint.target ) );
}
flag_wait( nextpoint.script_flag_wait );
if ( !IsDefined( self ) )
{
return;
}
if ( IsDefined( nextpoint.script_delay_post ) )
{
wait nextpoint.script_delay_post;
if ( !IsDefined( self ) )
{
return;
}
}
accel = 10;
if ( IsDefined( nextpoint.script_accel ) )
{
accel = nextpoint.script_accel;
}
if( was_stopped )
{
self vehicle_resume_named( "script_flag_wait_" + nextpoint.script_flag_wait );
}
self notify( "delay_passed" );
}
if ( IsDefined( self.set_lookat_point ) )
{
self.set_lookat_point = undefined;
self ClearLookAtEnt();
}
if ( IsDefined( nextpoint.script_vehicle_lights_off ) )
self thread lights_off( nextpoint.script_vehicle_lights_off );
if ( IsDefined( nextpoint.script_vehicle_lights_on ) )
self thread lights_on( nextpoint.script_vehicle_lights_on );
if ( IsDefined( nextpoint.script_forcecolor ) )
self thread vehicle_script_forcecolor_riders( nextpoint.script_forcecolor );
lastpoint = nextpoint;
if ( !IsDefined( nextpoint.target ) )
break;
nextpoint =[[ get_func ] ] ( nextpoint.target );
if ( !IsDefined( nextpoint ) )
{
nextpoint = lastpoint;
AssertMsg( "can't find nextpoint for node at origin (node targets nothing or different type?): " + lastpoint.origin );
break;
}
}
if ( IsDefined( self.script_turretmg ) )
{
if ( self.script_turretmg == 1 )
{
self mgOn();
}
else
{
self mgOff();
}
}
if ( IsDefined( nextpoint.script_land ) )
self thread vehicle_landvehicle();
self notify( "reached_dynamic_path_end" );
if ( IsDefined( self.script_vehicle_selfremove ) )
{
self notify( "delete" );
self Delete();
}
}
vehicle_paths_helicopter( node, bhelicopterwaitforstart )
{
AssertEx( IsDefined( node ) || IsDefined( self.attachedpath ), "vehicle_path() called without a path" );
self notify( "newpath" );
self endon( "newpath" );
self endon( "death" );
if ( !IsDefined( bhelicopterwaitforstart ) )
bhelicopterwaitforstart = false;
if ( IsDefined( node ) )
self.attachedpath = node;
pathstart = self.attachedpath;
self.currentNode = self.attachedpath;
if ( !IsDefined( pathstart ) )
return;
pathpoint = pathstart;
if ( bhelicopterwaitforstart )
self waittill( "start_dynamicpath" );
lastpoint = undefined;
nextpoint = pathstart;
get_func = get_path_getfunc( pathstart );
while ( IsDefined( nextpoint ) )
{
if ( IsDefined( nextpoint.script_linkTo ) )
set_lookat_from_dest( nextpoint );
heli_wait_node( nextpoint, lastpoint );
if ( !IsDefined( self ) )
return;
self.currentNode = nextpoint;
if ( IsDefined( nextpoint.gateopen ) && !nextpoint.gateopen )
self thread path_gate_wait_till_open( nextpoint );
nextpoint notify( "trigger", self );
if ( IsDefined( nextpoint.script_helimove ) )
{
self SetYawSpeedByName( nextpoint.script_helimove );
if ( nextpoint.script_helimove == "faster" )
self SetMaxPitchRoll( 25, 50 );
}
if ( IsDefined( nextpoint.script_noteworthy ) )
{
self notify( nextpoint.script_noteworthy );
self notify( "noteworthy", nextpoint.script_noteworthy );
}
waittillframeend;
if ( !IsDefined( self ) )
return;
if ( IsDefined( nextpoint.script_prefab_exploder ) )
{
nextpoint.script_exploder = nextpoint.script_prefab_exploder;
nextpoint.script_prefab_exploder = undefined;
}
if ( IsDefined( nextpoint.script_exploder ) )
{
delay = nextpoint.script_exploder_delay;
if ( IsDefined( delay ) )
{
level delayThread( delay, ::exploder, nextpoint.script_exploder );
}
else
{
level exploder( nextpoint.script_exploder );
}
}
if ( IsDefined( nextpoint.script_flag_set ) )
{
if ( IsDefined( self.vehicle_flags ) )
self.vehicle_flags[ nextpoint.script_flag_set ] = true;
self notify( "vehicle_flag_arrived", nextpoint.script_flag_set );
flag_set( nextpoint.script_flag_set );
}
if ( IsDefined( nextpoint.script_ent_flag_set ) )
{
self ent_flag_set( nextpoint.script_ent_flag_set );
}
if ( IsDefined( nextpoint.script_ent_flag_clear ) )
{
self ent_flag_clear( nextpoint.script_ent_flag_clear );
}
if ( IsDefined( nextpoint.script_flag_clear ) )
{
if ( IsDefined( self.vehicle_flags ) )
self.vehicle_flags[ nextpoint.script_flag_clear ] = false;
flag_clear( nextpoint.script_flag_clear );
}
if ( IsDefined( nextpoint.script_noteworthy ) )
{
if ( nextpoint.script_noteworthy == "kill" )
self force_kill();
if ( nextpoint.script_noteworthy == "godon" )
self godon();
if ( nextpoint.script_noteworthy == "godoff" )
self godoff();
if ( nextpoint.script_noteworthy == "deleteme" )
{
level thread deleteent( self );
return;
}
}
if ( IsDefined( nextpoint.script_crashtypeoverride ) )
self.script_crashtypeoverride = nextpoint.script_crashtypeoverride;
if ( IsDefined( nextpoint.script_badplace ) )
self.script_badplace = nextpoint.script_badplace;
if ( IsDefined( nextpoint.script_turretmg ) )
self.script_turretmg = nextpoint.script_turretmg;
if ( IsDefined( nextpoint.script_team ) )
self.script_team = nextpoint.script_team;
if ( IsDefined( nextpoint.script_turningdir ) )
self notify( "turning", nextpoint.script_turningdir );
if ( IsDefined( nextpoint.script_deathroll ) )
if ( nextpoint.script_deathroll == 0 )
self thread deathrolloff();
else
self thread deathrollon();
if ( IsDefined( nextpoint.script_vehicleaianim ) )
{
if ( IsDefined( nextpoint.script_parameters ) && nextpoint.script_parameters == "queue" )
self.queueanim = true;
}
if ( IsDefined( nextpoint.script_wheeldirection ) )
self wheeldirectionchange( nextpoint.script_wheeldirection );
if ( vehicle_should_unload( ::heli_wait_node, nextpoint ) )
self thread unload_node( nextpoint );
if ( self Vehicle_IsPhysVeh() )
{
if ( IsDefined( nextpoint.script_transmission ) )
{
self.veh_transmission = nextpoint.script_transmission;
if ( self.veh_transmission == "forward" )
self vehicle_wheels_forward();
else
self vehicle_wheels_backward();
}
if ( IsDefined( nextpoint.script_pathtype ) )
self.veh_pathtype = nextpoint.script_pathtype;
}
if ( IsDefined( nextpoint.script_flag_wait ) )
{
if ( !IsDefined( self.vehicle_flags ) )
{
self.vehicle_flags = [];
}
self.vehicle_flags[ nextpoint.script_flag_wait ] = true;
self notify( "vehicle_flag_arrived", nextpoint.script_flag_wait );
flag_wait( nextpoint.script_flag_wait );
if ( IsDefined( nextpoint.script_delay_post ) )
wait nextpoint.script_delay_post;
self notify( "delay_passed" );
}
if ( IsDefined( self.set_lookat_point ) )
{
self.set_lookat_point = undefined;
self ClearLookAtEnt();
}
if ( IsDefined( nextpoint.script_vehicle_lights_off ) )
self thread lights_off( nextpoint.script_vehicle_lights_off );
if ( IsDefined( nextpoint.script_vehicle_lights_on ) )
self thread lights_on( nextpoint.script_vehicle_lights_on );
if ( IsDefined( nextpoint.script_forcecolor ) )
self thread vehicle_script_forcecolor_riders( nextpoint.script_forcecolor );
lastpoint = nextpoint;
if ( !IsDefined( nextpoint.target ) )
break;
nextpoint =[[ get_func ] ] ( nextpoint.target );
if ( !IsDefined( nextpoint ) )
{
nextpoint = lastpoint;
AssertMsg( "can't find nextpoint for node at origin (node targets nothing or different type?): " + lastpoint.origin );
break;
}
}
if ( IsDefined( self.script_turretmg ) )
{
if ( self.script_turretmg == 1 )
{
self mgOn();
}
else
{
self mgOff();
}
}
if ( IsDefined( nextpoint.script_land ) )
self thread vehicle_landvehicle();
self notify( "reached_dynamic_path_end" );
if ( IsDefined( self.script_vehicle_selfremove ) )
self Delete();
}
vehicle_should_unload( wait_func, nextpoint )
{
if ( IsDefined( nextpoint.script_unload ) )
return true;
if ( wait_func != ::node_wait )
return false;
if ( !islastnode( nextpoint ) )
return false;
if ( IsDefined( self.dontunloadonend ) )
return false;
if ( self.vehicletype == "empty" )
return false;
return !is_script_vehicle_selfremove();
}
overshoot_next_node( vnode )
{
}
is_script_vehicle_selfremove()
{
if ( !IsDefined( self.script_vehicle_selfremove ) )
return false;
return self.script_vehicle_selfremove;
}
must_stop_at_next_point( nextpoint )
{
if ( IsDefined( nextpoint.script_unload ) )
return true;
if ( IsDefined( nextpoint.script_delay ) )
return true;
return IsDefined( nextpoint.script_flag_wait ) && !flag( nextpoint.script_flag_wait );
}
heli_wait_node( nextpoint, lastpoint )
{
self endon( "newpath" );
if ( IsDefined( nextpoint.script_unload ) && IsDefined( self.fastropeoffset ) )
{
nextpoint.radius = 2;
if ( isdefined( nextpoint.ground_pos ) )
{
nextpoint.origin = nextpoint.ground_pos + ( 0, 0, self.fastropeoffset );
}
else
{
neworg = groundpos( nextpoint.origin ) + ( 0, 0, self.fastropeoffset );
if ( neworg[ 2 ] > nextpoint.origin[ 2 ] - 2000 )
{
nextpoint.origin = groundpos( nextpoint.origin ) + ( 0, 0, self.fastropeoffset );
}
}
self SetHoverParams( 0, 0, 0 );
}
if ( IsDefined( lastpoint ) )
{
airResistance = lastpoint.script_airresistance;
speed = lastpoint.speed;
accel = lastpoint.script_accel;
decel = lastpoint.script_decel;
}
else
{
airResistance = undefined;
speed = undefined;
accel = undefined;
decel = undefined;
}
stopnode = IsDefined( nextpoint.script_stopnode ) && nextpoint.script_stopnode;
unload = IsDefined( nextpoint.script_unload );
flag_wait = ( IsDefined( nextpoint.script_flag_wait ) && !flag( nextpoint.script_flag_wait ) );
endOfPath = !IsDefined( nextpoint.target );
hasDelay = IsDefined( nextpoint.script_delay );
if ( IsDefined( nextpoint.angles ) )
yaw = nextpoint.angles[ 1 ];
else
yaw = 0;
if ( self.health <= 0 )
return;
origin = nextpoint.origin;
if( is_iw4_map_sp() )
if ( IsDefined( self.originheightoffset ) )
origin += ( 0, 0, self.originheightoffset );
if ( IsDefined( self.heliheightoverride ) )
origin = ( origin[0], origin[1], self.heliheightoverride );
self Vehicle_HeliSetAI( origin, speed, accel, decel, nextpoint.script_goalyaw, nextpoint.script_anglevehicle, yaw, airResistance, hasDelay, stopnode, unload, flag_wait, endOfPath );
if ( IsDefined( nextpoint.radius ) )
{
self SetNearGoalNotifyDist( nextpoint.radius );
AssertEx( nextpoint.radius > 0, "radius: " + nextpoint.radius );
self waittill_any( "near_goal", "goal" );
}
else
{
self waittill( "goal" );
}
if ( IsDefined( nextpoint.script_firelink ) )
{
thread heli_firelink( nextpoint );
}
nextpoint script_delay();
if( isdefined( self.path_gobbler ) )
deletestruct_ref( nextpoint );
}
heli_firelink( nextpoint )
{
target = GetEnt( nextpoint.script_linkto, "script_linkname" );
do_struct_spawn_ent = !IsDefined( target );
if ( !IsDefined( target ) )
{
target = getstruct( nextpoint.script_linkto, "script_linkname" );
AssertEx( IsDefined( target ), "No target for script_firelink" );
}
fire_burst = nextpoint.script_fireLink;
if( do_struct_spawn_ent )
target = target spawn_tag_origin();
switch( fire_burst )
{
case "zippy_burst":
wait( 1 );
maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
wait( 0.1 );
maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
wait( 0.2 );
maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
wait( 0.3 );
maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
wait( 0.3 );
maps\_helicopter_globals::fire_missile( "hind_zippy", 1, target );
break;
case "apache_zippy":
waits = [ 0.1, 0.2, 0.3 ];
wait 1;
target.origin += ( 0, 0, -150 );
target MoveTo( target.origin + ( 0, 0, 150 ), 0.6, 0, 0 );
foreach( waittime in waits )
{
if ( !IsDefined( self ) )
continue;
maps\_helicopter_globals::fire_missile( "apache_zippy", 1, target );
wait waittime;
}
break;
case "hind_rpg":
maps\_helicopter_globals::fire_missile( "hind_rpg", 5, target, 0.3 );
break;
default:
if ( ( self.classname == "script_vehicle_littlebird_armed" ) || ( self.classname == "script_vehicle_littlebird_md500" ) || ( self.classname == "script_vehicle_littlebird_md500_streamed" ) )
{
vehicle_scripts\_attack_heli::heli_fire_missiles( target, 2, 0.25 );
}
else
{
maps\_helicopter_globals::fire_missile( "hind_zippy", 5, target, 0.3 );
}
break;
}
if( do_struct_spawn_ent )
target delete();
}
helipath( msg, maxspeed, accel )
{
self SetAirResistance( 30 );
self Vehicle_SetSpeed( maxspeed, accel, level.heli_default_decel );
vehicle_paths( getstruct( msg, "targetname" ) );
}
deathrollon()
{
if ( self.health > 0 )
self.rollingdeath = 1;
}
deathrolloff()
{
self.rollingdeath = undefined;
self notify( "deathrolloff" );
}
getonpath( skip_attach )
{
path_start = undefined;
type = self.vehicletype;
if ( IsDefined( self.vehicle_spawner ) )
{
if ( IsDefined( self.vehicle_spawner.dontgetonpath ) && self.dontgetonpath )
return;
}
if ( IsDefined( self.target ) )
{
path_start = GetVehicleNode( self.target, "targetname" );
if ( !IsDefined( path_start ) )
{
path_start_array = GetEntArray( self.target, "targetname" );
foreach ( path in path_start_array )
{
if ( path.code_classname == "script_origin" )
{
path_start = path;
break;
}
}
}
if ( !IsDefined( path_start ) )
{
path_start = getstruct( self.target, "targetname" );
}
}
if ( !IsDefined( path_start ) )
{
if ( ishelicopter() )
self Vehicle_SetSpeed( 60, 20, level.heli_default_decel );
return;
}
self.attachedpath = path_start;
if ( !isHelicopter() )
{
self.origin = path_start.origin;
if ( !IsDefined( skip_attach ) )
self AttachPath( path_start );
}
else
{
if ( IsDefined( self.speed ) )
{
self Vehicle_SetSpeedImmediate( self.speed, 20 );
}
else
if ( IsDefined( path_start.speed ) )
{
accel = 20;
decel = level.heli_default_decel;
if ( IsDefined( path_start.script_accel ) )
accel = path_start.script_accel;
if ( IsDefined( path_start.script_decel ) )
accel = path_start.script_decel;
self Vehicle_SetSpeedImmediate( path_start.speed, accel, decel );
}
else
{
self Vehicle_SetSpeed( 60, 20, level.heli_default_decel );
}
}
self thread vehicle_paths( undefined, isHelicopter() );
}
create_vehicle_from_spawngroup_and_gopath( spawnGroup )
{
vehicleArray = maps\_vehicle::scripted_spawn( spawnGroup );
foreach ( vehicle in vehicleArray )
level thread maps\_vehicle::gopath( vehicle );
return vehicleArray;
}
gopath( vehicle )
{
if ( !IsDefined( vehicle ) )
{
vehicle = self;
AssertEx( self.code_classname == "script_vehicle", "Tried to do goPath on a non-vehicle" );
}
if ( IsDefined( vehicle.script_VehicleStartMove ) )
level.vehicle_StartMoveGroup[ vehicle.script_VehicleStartMove ] = array_remove( level.vehicle_StartMoveGroup[ vehicle.script_VehicleStartMove ], vehicle );
vehicle endon( "death" );
if ( IsDefined( vehicle.hasstarted ) )
{
PrintLn( "vehicle already moving when triggered with a startmove" );
return;
}
else
vehicle.hasstarted = true;
vehicle script_delay();
vehicle notify( "start_vehiclepath" );
if ( vehicle isHelicopter() )
vehicle notify( "start_dynamicpath" );
else
vehicle StartPath();
}
path_gate_open( node )
{
node.gateopen = true;
node notify( "gate opened" );
}
path_gate_wait_till_open( pathspot )
{
self endon( "death" );
self.waitingforgate = true;
self notify( "wait for gate" );
self vehicle_setspeed_wrapper( 0, 15, "path gate closed" );
pathspot waittill( "gate opened" );
self.waitingforgate = false;
if ( self.health > 0 )
script_resumespeed( "gate opened", level.vehicle_ResumeSpeed );
}
scripted_spawn( group )
{
spawners = _getvehiclespawnerarray_by_spawngroup( group );
vehicles = [];
foreach ( spawner in spawners )
vehicles[ vehicles.size ] = vehicle_spawn( spawner );
return vehicles;
}
vehicle_spawn( vspawner )
{
Assert( IsSpawner( vspawner ) );
AssertEx( !IsDefined( vspawner.vehicle_spawned_thisframe ), "spawning two vehicles on one spawner on the same frame is not allowed" );
vehicle = vspawner Vehicle_DoSpawn();
Assert( IsDefined( vehicle ) );
if ( !IsDefined( vspawner.spawned_count ) )
vspawner.spawned_count = 0;
vspawner.spawned_count ++;
vspawner.vehicle_spawned_thisframe = vehicle;
vspawner.last_spawned_vehicle = vehicle;
vspawner thread remove_vehicle_spawned_thisframe();
vehicle.vehicle_spawner = vspawner;
if( isdefined( vspawner.truckjunk ) )
vehicle.truckjunk = vspawner.truckjunk;
thread vehicle_init( vehicle );
vspawner notify( "spawned", vehicle );
return vehicle;
}
get_vehicle_spawned_from_spawner_with_targetname( targetname )
{
spawner = GetEnt( targetname, "targetname" );
Assert( IsDefined( spawner ) );
if ( IsDefined( spawner.last_spawned_vehicle ) )
return spawner.last_spawned_vehicle;
return undefined;
}
remove_vehicle_spawned_thisframe()
{
wait 0.05;
self.vehicle_spawned_thisframe = undefined;
}
waittill_vehiclespawn( targetname )
{
spawner = GetEnt( targetname, "targetname" );
Assert( IsSpawner( spawner ) );
if ( IsDefined( spawner.vehicle_spawned_thisframe ) )
return spawner.vehicle_spawned_thisframe;
spawner waittill( "spawned", vehicle );
return vehicle;
}
waittill_vehiclespawn_noteworthy( noteworthy )
{
potential_spawners = GetEntArray( noteworthy, "script_noteworthy" );
spawner = undefined;
foreach ( test in potential_spawners )
{
if ( IsSpawner( test ) )
{
spawner = test;
break;
}
}
Assert( IsDefined( spawner ) );
if ( IsDefined( spawner.vehicle_spawned_thisframe ) )
return spawner.vehicle_spawned_thisframe;
spawner = GetEnt( noteworthy, "script_noteworthy" );
spawner waittill( "spawned", vehicle );
return vehicle;
}
waittill_vehiclespawn_noteworthy_array( noteworthy )
{
struct = SpawnStruct();
struct.array_count = 0;
struct.vehicles = [];
array = [];
potentials_array = GetEntArray( noteworthy, "script_noteworthy" );
foreach ( test in potentials_array )
{
if ( IsSpawner( test ) )
array[ array.size ] = test;
}
Assert( array.size );
array_levelthread( array, ::waittill_vehiclespawn_noteworthy_array_countdown, struct );
struct waittill( "all_vehicles_spawned" );
return struct.vehicles;
}
waittill_vehiclespawn_noteworthy_array_countdown( spawner, struct )
{
struct.array_count++;
if ( !IsDefined( spawner.vehicle_spawned_thisframe ) )
spawner waittill( "spawned", vehicle );
else
vehicle = spawner.vehicle_spawned_thisframe;
Assert( IsDefined( vehicle ) );
struct.array_count--;
struct.vehicles[ struct.vehicles.size ] = vehicle;
if ( !struct.array_count )
struct notify( "all_vehicles_spawned" );
}
vehicle_init( vehicle )
{
Assert( vehicle.classname != "script_model" );
classname = vehicle.classname;
if ( IsDefined( level.vehicle_hide_list[ classname ] ) )
{
foreach ( part in level.vehicle_hide_list[ classname ] )
vehicle HidePart( part );
}
if ( vehicle.vehicletype == "empty" )
{
vehicle thread getonpath();
return;
}
if ( vehicle.vehicletype == "bog_mortar" )
return;
if ( ( IsDefined( vehicle.script_noteworthy ) ) && ( vehicle.script_noteworthy == "playervehicle" ) )
return;
vehicle set_ai_number();
vehicle.zerospeed = true;
if ( !IsDefined( vehicle.modeldummyon ) )
vehicle.modeldummyon = false;
type = vehicle.vehicletype;
if ( is_iw4_map_sp() )
classname = vehicle.vehicletype;
vehicle vehicle_life();
vehicle vehicle_setteam();
if ( is_iw4_map_sp() )
{
if ( !IsDefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ) )
{
PrintLn( "vehicle.vehicletype is: " + vehicle.vehicletype );
PrintLn( "vehicle.model is: " + vehicle.model );
}
vehicle thread[[ level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ] ] ();
}
else
{
if ( !IsDefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.classname ] ) )
{
PrintLn( "vehicle.classname is: " + vehicle.classname );
PrintLn( "vehicle.vehicletype is: " + vehicle.vehicletype );
PrintLn( "vehicle.model is: " + vehicle.model );
}
vehicle thread[[ level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.classname ] ] ] ();
}
vehicle thread maingun_FX();
vehicle thread playTankExhaust();
if ( !IsDefined( vehicle.script_avoidplayer ) )
vehicle.script_avoidplayer = false;
if ( IsDefined( level.vehicle_draw_thermal ) )
{
if ( level.vehicle_draw_thermal )
{
vehicle ThermalDrawEnable();
}
}
vehicle ent_flag_init( "unloaded" );
vehicle ent_flag_init( "loaded" );
vehicle.riders = [];
vehicle.unloadque = [];
vehicle.unload_group = "default";
vehicle.fastroperig = [];
if ( IsDefined( level.vehicle_attachedmodels ) && IsDefined( level.vehicle_attachedmodels[ classname ] ) )
{
rigs = level.vehicle_attachedmodels[ classname ];
strings = GetArrayKeys( rigs );
foreach ( string in strings )
{
vehicle.fastroperig[ string ] = undefined;
vehicle.fastroperiganimating[ string ] = false;
}
}
vehicle thread vehicle_badplace();
if ( IsDefined( vehicle.script_vehicle_lights_on ) )
vehicle thread lights_on( vehicle.script_vehicle_lights_on );
if ( IsDefined( vehicle.script_godmode ) )
{
vehicle godon();
}
vehicle.damage_functions = [];
if ( !vehicle isCheap()|| vehicle isCheapShieldEnabled() )
vehicle thread friendlyfire_shield();
vehicle thread maps\_vehicle_aianim::handle_attached_guys();
if ( IsDefined( vehicle.script_friendname ) )
vehicle SetVehicleLookAtText( vehicle.script_friendname, &"" );
if ( !vehicle isCheap() )
vehicle thread vehicle_handleunloadevent();
if ( IsDefined( vehicle.script_dontunloadonend ) )
vehicle.dontunloadonend = true;
if ( !vehicle isCheap() )
vehicle thread vehicle_shoot_shock();
vehicle thread vehicle_rumble();
if ( IsDefined( vehicle.script_physicsjolt ) && vehicle.script_physicsjolt )
vehicle thread physicsjolt_proximity();
vehicle thread vehicle_treads();
vehicle thread idle_animations();
vehicle thread animate_drive_idle();
if ( IsDefined( vehicle.script_deathflag ) )
{
vehicle thread maps\_spawner::vehicle_deathflag();
}
if ( !vehicle isCheap() )
vehicle thread mginit();
if ( IsDefined( level.vehicleSpawnCallbackThread ) )
level thread[[ level.vehicleSpawnCallbackThread ] ] ( vehicle );
vehicle_Levelstuff( vehicle );
if ( IsDefined( vehicle.script_team ) )
vehicle SetVehicleTeam( vehicle.script_team );
if ( !vehicle isCheap() )
vehicle thread disconnect_paths_whenstopped();
vehicle thread getonpath();
if ( vehicle hasHelicopterDustKickup() )
vehicle thread aircraft_dust_kickup();
if ( vehicle Vehicle_IsPhysVeh() )
{
if ( !IsDefined( vehicle.script_pathtype ) )
{
}
else
{
vehicle.veh_pathtype = vehicle.script_pathtype;
}
}
vehicle spawn_group();
vehicle thread vehicle_kill();
vehicle apply_truckjunk();
}
isCheapShieldEnabled()
{
return IsDefined( level.cheap_vehicles_have_shields ) && level.cheap_vehicles_have_shields;
}
kill_damage( classname )
{
if ( !IsDefined( level.vehicle_death_radiusdamage ) || !IsDefined( level.vehicle_death_radiusdamage[ classname ] ) )
return;
if ( IsDefined( self.deathdamage_max ) )
maxdamage = self.deathdamage_max;
else
maxdamage = level.vehicle_death_radiusdamage[ classname ].maxdamage;
if ( IsDefined( self.deathdamage_min ) )
mindamage = self.deathdamage_min;
else
mindamage = level.vehicle_death_radiusdamage[ classname ].mindamage;
if ( IsDefined( level.vehicle_death_radiusdamage[ classname ].delay ) )
wait level.vehicle_death_radiusdamage[ classname ].delay;
if ( !IsDefined( self ) )
return;
if ( level.vehicle_death_radiusdamage[ classname ].bKillplayer )
level.player EnableHealthShield( false );
self RadiusDamage( self.origin + level.vehicle_death_radiusdamage[ classname ].offset, level.vehicle_death_radiusdamage[ classname ].range, maxdamage, mindamage, self );
if ( level.vehicle_death_radiusdamage[ classname ].bKillplayer )
level.player EnableHealthShield( true );
}
vehicle_kill()
{
self endon( "nodeath_thread" );
type = self.vehicletype;
classname = self.classname;
model = self.model;
targetname = self.targetname;
attacker = undefined;
cause = undefined;
weapon = undefined;
registered_kill = false;
while ( 1 )
{
if ( IsDefined( self ) )
self waittill( "death", attacker, cause, weapon );
if ( !registered_kill )
{
registered_kill = true;
if ( IsDefined( attacker ) && IsDefined( cause ) )
{
attacker maps\_player_stats::register_kill( self, cause, weapon );
if ( IsDefined( self.damage_type ) )
{
self.damage_type = undefined;
}
}
if ( is_specialop() && !is_survival() && IsDefined( attacker ) && IsPlayer( attacker ) )
{
if ( attacker.team != self.script_team )
attacker thread giveXp( "kill", 500 );
if ( isdefined( self.riders ) )
{
foreach ( rider in self.riders )
{
if ( isalive( rider ) && isAI( rider ) )
{
attacker thread giveXp( "kill" );
}
}
}
}
self thread helicopter_death_achievement( attacker, cause, weapon );
}
self notify( "clear_c4" );
if ( IsDefined( self.rumbletrigger ) )
self.rumbletrigger Delete();
if ( IsDefined( self.mgturret ) )
{
array_levelthread( self.mgturret, ::turret_deleteme );
self.mgturret = undefined;
}
if ( IsDefined( self.script_team ) )
level.vehicles[ self.script_team ] = array_remove( level.vehicles[ self.script_team ], self );
if ( IsDefined( self.script_linkName ) )
level.vehicle_link[ self.script_linkName ] = array_remove( level.vehicle_link[ self.script_linkName ], self );
if ( IsDefined( self.script_VehicleStartMove ) )
level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ] = array_remove( level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ], self );
if ( IsDefined( self.script_vehicleGroupDelete ) )
level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ] = array_remove( level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ], self );
if ( !IsDefined( self ) || is_corpse() )
{
if ( IsDefined( self.riders ) )
foreach ( rider in self.riders )
if ( IsDefined( rider ) )
rider Delete();
if ( is_corpse() )
{
self.riders = [];
continue;
}
self notify( "delete_destructible" );
return;
}
rumblestruct = undefined;
if ( IsDefined( self.vehicle_rumble_unique ) )
{
rumblestruct = self.vehicle_rumble_unique;
}
else if ( IsDefined( level.vehicle_rumble_override ) && IsDefined( level.vehicle_rumble_override[ classname ] ) )
{
rumblestruct = level.vehicle_rumble_override;
}
else if ( IsDefined( level.vehicle_rumble[ classname ] ) )
{
rumblestruct = level.vehicle_rumble[ classname ];
}
if ( IsDefined( rumblestruct ) )
{
self StopRumble( rumblestruct.rumble );
}
if ( IsDefined( level.vehicle_death_thread[ type ] ) )
thread[[ level.vehicle_death_thread[ type ] ] ] ();
self array_levelthread( self.riders, maps\_vehicle_aianim::guy_vehicle_death, attacker, type );
thread kill_damage( classname );
if( is_iw4_map_sp() )
thread kill_badplace( type );
else
thread kill_badplace( classname );
kill_lights( get_light_model( model, classname ) );
delete_corpses_around_vehicle();
if ( IsDefined( level.vehicle_deathmodel[ classname ] ) )
self thread set_death_model( level.vehicle_deathmodel[ classname ], level.vehicle_deathmodel_delay[ classname ] );
else if ( IsDefined( level.vehicle_deathmodel[ model ] ) )
self thread set_death_model( level.vehicle_deathmodel[ model ], level.vehicle_deathmodel_delay[ model ] );
rocketdeath = vehicle_should_do_rocket_death( model, attacker, cause );
vehOrigin = self.origin;
thread kill_fx( model, rocketdeath );
if ( self.code_classname == "script_vehicle" )
{
if( is_iw4_map_sp() )
self thread kill_jolt( type );
else
self thread kill_jolt( classname );
}
if ( IsDefined( self.delete_on_death ) )
{
wait 0.05;
if ( !IsDefined( self.dontDisconnectPaths ) && !self Vehicle_IsPhysVeh() )
self DisconnectPaths();
self _freevehicle();
wait 0.05;
self vehicle_finish_death( model );
self Delete();
continue;
}
if ( IsDefined( self.free_on_death ) )
{
self notify( "newpath" );
if ( !IsDefined( self.dontDisconnectPaths ) )
self DisconnectPaths();
Vehicle_kill_badplace_forever();
self _freevehicle();
return;
}
vehicle_do_crash( model, attacker, cause );
if ( !IsDefined( self ) )
return;
if ( !rocketdeath )
vehOrigin = self.origin;
if ( IsDefined( level.vehicle_death_earthquake[ classname ] ) )
earthquake
(
level.vehicle_death_earthquake[ classname ].scale,
level.vehicle_death_earthquake[ classname ].duration,
vehOrigin,
level.vehicle_death_earthquake[ classname ].radius
);
wait 0.5;
if ( is_corpse() )
continue;
if ( IsDefined( self ) )
{
while ( IsDefined( self.dontfreeme ) && IsDefined( self ) )
wait 0.05;
if ( !IsDefined( self ) )
continue;
if ( self Vehicle_IsPhysVeh() )
{
while ( isDefined(self) && self.veh_speed != 0 )
wait 1;
if(!isDefined(self))
return;
self DisconnectPaths();
self notify( "kill_badplace_forever" );
self Kill();
self notify( "newpath" );
self Vehicle_TurnEngineOff();
return;
}
else
self _freevehicle();
if ( self.modeldummyon )
self Hide();
}
if ( vehicle_is_crashing() )
{
self Delete();
continue;
}
}
}
helicopter_death_achievement( attacker, cause, weapon )
{
if ( is_survival() && IsDefined( self ) && self isHelicopter() && IsPlayer( attacker ) )
{
if ( !IsDefined( attacker.achieve_birdie ) )
attacker.achieve_birdie = 1;
else
attacker.achieve_birdie++;
if ( attacker.achieve_birdie == 2 )
attacker player_giveachievement_wrapper( "BIRDIE" );
attacker waittill("damage");
attacker.achieve_birdie = undefined;
}
}
_freevehicle()
{
self FreeVehicle();
if ( !IsDefined( level.extra_vehicle_cleanup ) )
return;
delaythread( 0.05, ::extra_vehicle_cleanup );
}
extra_vehicle_cleanup()
{
self notify ( "newpath" );
self.accuracy = undefined;
self.attachedguys = undefined;
self.attackback = undefined;
self.badshot = undefined;
self.badshotcount = undefined;
self.currenthealth = undefined;
self.currentnode = undefined;
self.damage_functions = undefined;
self.delayer = undefined;
self.fastroperig = undefined;
self.getinorgs = undefined;
self.hasstarted = undefined;
self.healthbuffer = undefined;
self.offsetone = undefined;
self.offsetrange = undefined;
self.rocket_destroyed_for_achievement = undefined;
self.rumble_basetime = undefined;
self.rumble_duration = undefined;
self.rumble_radius = undefined;
self.script_attackai = undefined;
self.script_avoidplayer = undefined;
self.script_attackai = undefined;
self.script_avoidplayer = undefined;
self.script_bulletshield = undefined;
self.script_disconnectpaths = undefined;
self.script_linkname = undefined;
self.script_mp_style_helicopter = undefined;
self.script_team = undefined;
self.script_turret = undefined;
self.script_turretmg = undefined;
self.script_vehicleride = undefined;
self.script_vehiclespawngroup = undefined;
self.script_vehiclestartmove = undefined;
self.shotcount = undefined;
self.shotsatzerospeed = undefined;
self.spawn_funcs = undefined;
self.spawn_functions = undefined;
self.tank_queue = undefined;
self.target = undefined;
self.target_min_range = undefined;
self.troop_cache = undefined;
self.troop_cache = undefined;
self.troop_cache_update_next = undefined;
self.turret_damage_max = undefined;
self.turret_damage_min = undefined;
self.turret_damage_range = undefined;
self.badplacemodifier = undefined;
self.attachedpath = undefined;
self.badplacemodifier = undefined;
self.rumble_randomaditionaltime = undefined;
self.rumble_scale = undefined;
self.rumbleon = undefined;
self.rumbletrigger = undefined;
self.runningtovehicle = undefined;
self.script_nomg = undefined;
self.script_startinghealth = undefined;
self.teleported_to_path_section = undefined;
self.turret_damage_range = undefined;
self.turretaccmaxs = undefined;
self.turretaccmins = undefined;
self.turretfiretimer = undefined;
self.turretonvistarg = undefined;
self.turretonvistarg_failed = undefined;
self.unique_id = undefined;
self.unload_group = undefined;
self.unloadque = undefined;
self.usedpositions = undefined;
self.vehicle_spawner = undefined;
self.waitingforgate = undefined;
self.water_splash_function = undefined;
self.water_splash_reset_function = undefined;
self.offsetzero = undefined;
self.script_accuracy = undefined;
self.water_splash_reset_function = undefined;
self.wheeldir = undefined;
self.zerospeed = undefined;
self.dontunloadonend = undefined;
self.dontDisconnectPaths = undefined;
self.script_godmode = undefined;
self.ent_flag = undefined;
self.ent_flag_lock = undefined;
self.export = undefined;
self.godmode = undefined;
self.vehicletype = undefined;
self.vehicle_stop_named = undefined;
self.enable_rocket_death = undefined;
self.touching_trigger_ent = undefined;
self.default_target_vec = undefined;
self.script_badplace = undefined;
self.water_splash_info = undefined;
}
vehicle_finish_death( model )
{
self notify ( "death_finished" );
if ( !IsDefined( self ) )
return;
self UseAnimTree(#animtree );
if ( IsDefined( level.vehicle_DriveIdle[ model ] ) )
self ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
if ( IsDefined( level.vehicle_DriveIdle_r[ model ] ) )
self ClearAnim( level.vehicle_DriveIdle_r[ model ], 0 );
}
vehicle_should_do_rocket_death( model, attacker, cause )
{
if ( IsDefined( self.enableRocketDeath ) && self.enableRocketDeath == false )
return false;
if ( !IsDefined( cause ) )
return false;
if ( !( ( cause == "MOD_PROJECTILE" ) || ( cause == "MOD_PROJECTILE_SPLASH" ) ) )
return false;
return vehicle_has_rocket_death( model );
}
vehicle_has_rocket_death( model )
{
if(is_iw4_map_sp())
return IsDefined( level.vehicle_death_fx[ "rocket_death" + self.vehicletype + model ] ) && IsDefined( self.enableRocketDeath ) && self.enableRocketDeath == true;
else
return IsDefined( level.vehicle_death_fx[ "rocket_death" + self.classname ] ) && IsDefined( self.enableRocketDeath ) && self.enableRocketDeath == true;
}
vehicle_is_crashing()
{
return( IsDefined( self.crashing ) ) && ( self.crashing == true );
}
vehicle_do_crash( model, attacker, cause )
{
crashtype = "tank";
if ( self Vehicle_IsPhysVeh() )
crashtype = "physics";
else
if ( IsDefined( self.script_crashtypeoverride ) )
crashtype = self.script_crashtypeoverride;
else
if ( self isHelicopter() )
crashtype = "helicopter";
else
if ( IsDefined( self.currentnode ) && crash_path_check( self.currentnode ) )
crashtype = "none";
switch( crashtype )
{
case "helicopter":
self thread helicopter_crash( attacker, cause );
break;
case "tank":
if ( !IsDefined( self.rollingdeath ) )
self vehicle_setspeed_wrapper( 0, 25, "Dead" );
else
{
self vehicle_setspeed_wrapper( 8, 25, "Dead rolling out of path intersection" );
self waittill( "deathrolloff" );
self vehicle_setspeed_wrapper( 0, 25, "Dead, finished path intersection" );
}
self notify( "deadstop" );
if ( !IsDefined( self.dontDisconnectPaths ) )
self DisconnectPaths();
if ( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
self waittill( "animsdone" );
break;
case "physics":
self VehPhys_Crash();
self notify( "deadstop" );
if ( !IsDefined( self.dontDisconnectPaths ) )
self DisconnectPaths();
if ( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
self waittill( "animsdone" );
break;
}
if ( IsDefined( level.vehicle_hasMainTurret[ model ] ) && level.vehicle_hasMainTurret[ model ] )
self ClearTurretTarget();
if ( self isHelicopter() )
{
if ( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
self waittill( "crash_done" );
}
else
{
while ( !is_corpse() && IsDefined( self ) && self Vehicle_GetSpeed() > 0 )
wait 0.1;
}
self notify( "stop_looping_death_fx" );
vehicle_finish_death( model );
}
is_corpse()
{
is_corpse = false;
if ( IsDefined( self ) && self.classname == "script_vehicle_corpse" )
is_corpse = true;
return is_corpse;
}
set_death_model( sModel, fDelay )
{
Assert( IsDefined( sModel ) );
if ( IsDefined( fDelay ) && ( fDelay > 0 ) )
wait fDelay;
if ( !IsDefined( self ) )
return;
eModel = get_dummy();
if ( IsDefined( self.clear_anims_on_death ) )
eModel ClearAnim( %root, 0 );
if ( IsDefined( self ) )
eModel SetModel( sModel );
}
helicopter_crash( attacker, cause )
{
if ( IsDefined( attacker ) && IsPlayer( attacker ) )
self.achievement_attacker = attacker;
self.crashing = true;
if ( !IsDefined( self ) )
return;
self thread helicopter_crash_move( attacker, cause );
}
_hasweapon( weapon )
{
weapons = self GetWeaponsListAll();
for ( i = 0; i < weapons.size; i++ )
{
if ( IsSubStr( weapons[ i ], weapon ) )
return true;
}
return false;
}
get_unused_crash_locations()
{
unusedLocations = [];
level.helicopter_crash_locations = array_removeundefined( level.helicopter_crash_locations );
foreach ( location in level.helicopter_crash_locations )
{
if ( IsDefined( location.claimed ) )
continue;
unusedLocations[ unusedLocations.size ] = location;
}
return unusedLocations;
}
detach_getoutrigs()
{
if ( !IsDefined( self.fastroperig ) )
return;
if ( ! self.fastroperig.size )
return;
keys = GetArrayKeys( self.fastroperig );
for ( i = 0; i < keys.size; i++ )
{
self.fastroperig[ keys[ i ] ] Unlink();
}
}
helicopter_crash_move( attacker, cause )
{
self endon("in_air_explosion");
if ( IsDefined( self.perferred_crash_location ) )
crashLoc = self.perferred_crash_location;
else
{
AssertEx( level.helicopter_crash_locations.size > 0, "A helicopter tried to crash but you didn't have any script_origins with targetname helicopter_crash_location in the level" );
unusedLocations = get_unused_crash_locations();
AssertEx( unusedLocations.size > 0, "You dont have enough script_origins with targetname helicopter_crash_location in the level" );
crashLoc = getClosest( self.origin, unusedLocations );
}
Assert( IsDefined( crashLoc ) );
crashLoc.claimed = true;
self detach_getoutrigs();
self notify( "newpath" );
self notify( "deathspin" );
indirect_zoff = 0;
direct = false;
if ( IsDefined( crashLoc.script_parameters ) && crashLoc.script_parameters == "direct" )
direct = true;
if ( IsDefined( self.heli_crash_indirect_zoff ) )
{
direct = false;
indirect_zoff = self.heli_crash_indirect_zoff;
}
if ( direct )
{
Assert( IsDefined( crashLoc.radius ) );
crash_speed = 60;
self Vehicle_SetSpeed( crash_speed, 15, 10 );
self SetNearGoalNotifyDist( crashLoc.radius );
self SetVehGoalPos( crashLoc.origin, 0 );
self thread helicopter_crash_flavor( crashloc.origin, crash_speed );
self waittill_any( "goal", "near_goal" );
}
else
{
indirect_target = ( crashLoc.origin[ 0 ], crashLoc.origin[ 1 ], self.origin[ 2 ] + indirect_zoff );
if ( IsDefined( self.heli_crash_lead ) )
{
indirect_target = self.origin + (self.heli_crash_lead*(self Vehicle_GetVelocity()));
indirect_target = ( indirect_target[0], indirect_target[1], indirect_target[2] + indirect_zoff );
}
self Vehicle_SetSpeed( 40, 10, 10 );
self SetNearGoalNotifyDist( 300 );
self SetVehGoalPos( indirect_target, 1 );
self thread helicopter_crash_flavor( indirect_target, 40 );
msg = "blank";
while ( msg != "death" )
{
msg = self waittill_any( "goal", "near_goal", "death" );
if ( !IsDefined( msg ) && !IsDefined( self ) )
{
crashLoc.claimed = undefined;
self notify( "crash_done" );
return;
}
else
msg = "death";
}
self SetVehGoalPos( crashLoc.origin, 0 );
self waittill( "goal" );
}
crashLoc.claimed = undefined;
self notify( "stop_crash_loop_sound" );
self notify( "crash_done" );
}
helicopter_crash_flavor( target_origin, crash_speed )
{
self endon( "crash_done" );
self ClearLookAtEnt();
style = 0;
if ( IsDefined( self.preferred_crash_style ) )
{
style = self.preferred_crash_style;
if ( self.preferred_crash_style < 0 )
{
style_chance = [1,2,2];
total = 5;
rnd = RandomInt(total);
chance = 0;
foreach (i, val in style_chance)
{
chance += val;
if (rnd < chance)
{
style = i;
break;
}
}
}
}
switch(style)
{
case 1:
self thread helicopter_crash_zigzag();
break;
case 2:
self thread helicopter_crash_directed( target_origin, crash_speed );
break;
case 3:
self thread helicopter_in_air_explosion();
break;
case 0:
default:
self thread helicopter_crash_rotate();
break;
}
}
helicopter_in_air_explosion()
{
self notify( "crash_done" );
self notify("in_air_explosion");
}
helicopter_crash_directed( target_origin, crash_speed )
{
self endon( "crash_done" );
self ClearLookAtEnt();
self SetMaxPitchRoll( RandomIntRange(20, 90), RandomIntRange(5, 90) );
self SetYawSpeed( 400, 100, 100 );
angleoff = 90*RandomIntRange( -2,3);
for ( ;; )
{
totarget = target_origin - self.origin;
yaw = VectorToYaw( totarget );
yaw += angleoff;
self SetTargetYaw( yaw );
wait 0.1;
}
}
helicopter_crash_zigzag()
{
self endon( "crash_done" );
self ClearLookAtEnt();
self SetYawSpeed( 400, 100, 100 );
dir = RandomInt(2);
for ( ;; )
{
if ( !IsDefined( self ) )
return;
iRand = RandomIntRange( 20, 120 );
if (dir)
self SetTargetYaw( self.angles[ 1 ] + iRand );
else
self SetTargetYaw( self.angles[ 1 ] - iRand );
dir = 1 - dir;
rtime = RandomFloatRange( 0.5, 1.0 );
wait rtime;
}
}
helicopter_crash_rotate()
{
self endon( "crash_done" );
self ClearLookAtEnt();
self SetYawSpeed( 400, 100, 100 );
for ( ;; )
{
if ( !IsDefined( self ) )
return;
iRand = RandomIntRange( 90, 120 );
self SetTargetYaw( self.angles[ 1 ] + iRand );
wait 0.5;
}
}
crash_path_check( node )
{
targ = node;
while ( IsDefined( targ ) )
{
if ( ( IsDefined( targ.detoured ) ) && ( targ.detoured == 0 ) )
{
detourpath = path_detour_get_detourpath( GetVehicleNode( targ.target, "targetname" ) );
if ( IsDefined( detourpath ) && IsDefined( detourpath.script_crashtype ) )
return true;
}
if ( IsDefined( targ.target ) )
targ = GetVehicleNode( targ.target, "targetname" );
else
targ = undefined;
}
return false;
}
death_firesound( sound )
{
self thread play_loop_sound_on_tag( sound, undefined, false );
self waittill_any( "fire_extinguish", "stop_crash_loop_sound" );
if ( !IsDefined( self ) )
return;
self notify( "stop sound" + sound );
}
kill_fx( model, rocketdeath )
{
if ( self isDestructible() )
return;
level notify( "vehicle_explosion", self.origin );
self notify( "explode", self.origin );
if ( IsDefined( self.ignore_death_fx ) && self.ignore_death_fx )
return;
type = self.vehicletype;
is_corpse = is_corpse();
Assert( !is_corpse );
classname = self.classname;
if ( is_iw4_map_sp() )
classname = type + model;
if ( rocketdeath )
classname = "rocket_death" + classname;
for ( i = 0; i < level.vehicle_death_fx[ classname ].size; i++ )
{
struct = level.vehicle_death_fx[ classname ][ i ];
thread kill_fx_thread( model, struct, type );
}
}
vehicle_flag_arrived( msg )
{
if ( !IsDefined( self.vehicle_flags ) )
{
self.vehicle_flags = [];
}
while ( !IsDefined( self.vehicle_flags[ msg ] ) )
{
self waittill( "vehicle_flag_arrived", notifymsg );
if ( msg == notifymsg )
return;
}
}
kill_fx_thread( model, struct, type )
{
Assert( IsDefined( struct ) );
if ( IsDefined( struct.waitDelay ) )
{
if ( struct.waitDelay >= 0 )
wait struct.waitDelay;
else
self waittill( "death_finished" );
}
if ( !IsDefined( self ) )
{
return;
}
if ( IsDefined( struct.notifyString ) )
self notify( struct.notifyString );
eModel = get_dummy();
if ( IsDefined( struct.selfDeleteDelay ) )
self delayCall( struct.selfDeleteDelay, ::Delete );
if ( IsDefined( struct.effect ) )
{
if ( ( struct.bEffectLooping ) && ( !IsDefined( self.delete_on_death ) ) )
{
if ( IsDefined( struct.tag ) )
{
if ( ( IsDefined( struct.stayontag ) ) && ( struct.stayontag == true ) )
thread loop_fx_on_vehicle_tag( struct.effect, struct.delay, struct.tag );
else
thread playLoopedFxontag( struct.effect, struct.delay, struct.tag );
}
else
{
forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin;
PlayFX( struct.effect, eModel.origin, forward );
}
}
else if ( IsDefined( struct.tag ) )
{
PlayFXOnTag( struct.effect, deathfx_ent(), struct.tag );
if ( IsDefined( struct.remove_deathfx_entity_delay ) )
deathfx_ent() delayCall( struct.remove_deathfx_entity_delay, ::Delete );
}
else
{
forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin;
PlayFX( struct.effect, eModel.origin, forward );
}
}
if ( ( IsDefined( struct.sound ) ) && ( !IsDefined( self.delete_on_death ) ) )
{
if ( struct.bSoundlooping )
thread death_firesound( struct.sound );
else
self play_sound_in_space( struct.sound );
}
}
loop_fx_on_vehicle_tag( effect, loopTime, tag )
{
Assert( IsDefined( effect ) );
Assert( IsDefined( tag ) );
Assert( IsDefined( loopTime ) );
self endon( "stop_looping_death_fx" );
while ( IsDefined( self ) )
{
PlayFXOnTag( effect, deathfx_ent(), tag );
wait loopTime;
}
}
build_radiusdamage( offset, range, maxdamage, mindamage, bKillplayer, delay )
{
if ( !IsDefined( level.vehicle_death_radiusdamage ) )
level.vehicle_death_radiusdamage = [];
if ( !IsDefined( bKillplayer ) )
bKillplayer = false;
if ( !IsDefined( offset ) )
offset = ( 0, 0, 0 );
struct = SpawnStruct();
struct.offset = offset;
struct.range = range;
struct.maxdamage = maxdamage;
struct.mindamage = mindamage;
struct.bKillplayer = bKillplayer;
struct.delay = delay;
level.vehicle_death_radiusdamage[ level.vtclassname ] = struct;
}
build_rumble( rumble, scale, duration, radius, basetime, randomaditionaltime )
{
if ( !IsDefined( level.vehicle_rumble ) )
level.vehicle_rumble = [];
struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
Assert( IsDefined( rumble ) );
PreCacheRumble( rumble );
struct.rumble = rumble;
level.vehicle_rumble[ level.vtclassname ] = struct;
}
build_rumble_override( class, rumble, scale, duration, radius, basetime, randomaditionaltime )
{
if ( !IsDefined( level.vehicle_rumble_override ) )
level.vehicle_rumble_override = [];
struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
Assert( IsDefined( rumble ) );
PreCacheRumble( rumble );
struct.rumble = rumble;
Assert( !IsDefined( level.vehicle_rumble_override[ class ] ) );
level.vehicle_rumble_override[ class ] = struct;
}
build_rumble_unique( rumble, scale, duration, radius, basetime, randomaditionaltime )
{
struct = build_quake( scale, duration, radius, basetime, randomaditionaltime );
Assert( IsDefined( rumble ) );
struct.rumble = rumble;
assert(isdefined(self.vehicletype));
self.vehicle_rumble_unique = struct;
vehicle_kill_rumble_forever();
thread vehicle_rumble();
}
build_deathquake( scale, duration, radius )
{
classname = level.vtclassname;
if ( is_iw4_map_sp() )
classname = level.vttype;
if ( !IsDefined( level.vehicle_death_earthquake ) )
level.vehicle_death_earthquake = [];
level.vehicle_death_earthquake[ classname ] = build_quake( scale, duration, radius );
}
build_quake( scale, duration, radius, basetime, randomaditionaltime )
{
struct = SpawnStruct();
struct.scale = scale;
struct.duration = duration;
struct.radius = radius;
if ( IsDefined( basetime ) )
struct.basetime = basetime;
if ( IsDefined( randomaditionaltime ) )
struct.randomaditionaltime = randomaditionaltime;
return struct;
}
build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, selfDeleteDelay, remove_deathfx_entity_delay )
{
if ( !IsDefined( bSoundlooping ) )
bSoundlooping = false;
if ( !IsDefined( bEffectLooping ) )
bEffectLooping = false;
if ( !IsDefined( delay ) )
delay = 1;
struct = SpawnStruct();
struct.effect = _loadfx( effect );
struct.tag = tag;
struct.sound = sound;
struct.bSoundlooping = bSoundlooping;
struct.delay = delay;
struct.waitDelay = waitDelay;
struct.stayontag = stayontag;
struct.notifyString = notifyString;
struct.bEffectLooping = bEffectLooping;
struct.selfDeleteDelay = selfDeleteDelay;
struct.remove_deathfx_entity_delay = remove_deathfx_entity_delay;
return struct;
}
build_deathfx_override( classname, type, model, effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay )
{
if ( !IsDefined( level.script ) )
level.script = ToLower( GetDvar( "mapname" ) );
level.vttype = type;
level.vtmodel = model;
level.vtoverride = true;
if ( is_iw4_map_sp() )
classname = type + model;
else
Assert( IsDefined( classname ) );
level.vtclassname = classname;
if ( !IsDefined( level.vehicle_death_fx ) )
level.vehicle_death_fx = [];
if ( ! is_overrode( classname ) )
level.vehicle_death_fx[ classname ] = [];
level.vehicle_death_fx_override[ classname ] = true;
if ( !IsDefined( level.vehicle_death_fx[ classname ] ) )
level.vehicle_death_fx[ classname ] = [];
level.vehicle_death_fx[ classname ][ level.vehicle_death_fx[ classname ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay );
level.vtoverride = undefined;
}
build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay )
{
AssertEx( IsDefined( effect ), "Failed to build death effect because there is no effect specified for the model used for that vehicle." );
classname = level.vtclassname;
if ( is_iw4_map_sp() )
classname = level.vttype + level.vtmodel;
if ( is_overrode ( classname ) )
return;
if ( !IsDefined( level.vehicle_death_fx[ classname ] ) )
level.vehicle_death_fx[ classname ] = [];
level.vehicle_death_fx[ classname ][ level.vehicle_death_fx[ classname ].size ] = build_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay );
}
is_overrode( typemodel )
{
if ( !IsDefined( level.vehicle_death_fx_override ) )
return false;
if ( !IsDefined( level.vehicle_death_fx_override[ typemodel ] ) )
return false;
if ( IsDefined( level.vtoverride ) )
return true;
return level.vehicle_death_fx_override[ typemodel ];
}
build_rocket_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay )
{
if ( is_iw4_map_sp() )
{
vttype = level.vttype;
level.vttype = "rocket_death" + vttype;
build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay );
level.vttype = vttype;
}
else
{
classname = level.vtclassname;
level.vtclassname = "rocket_death" + classname;
build_deathfx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString, delete_vehicle_delay, remove_deathfx_entity_delay );
level.vtclassname = classname;
}
}
precache_scripts()
{
allvehiclesprespawn = [];
vehicles = GetEntArray( "script_vehicle", "code_classname" );
level.needsprecaching = [];
playerdrivablevehicles = [];
allvehiclesprespawn = [];
if ( !IsDefined( level.vehicleInitThread ) )
level.vehicleInitThread = [];
for ( i = 0; i < vehicles.size; i++ )
{
vehicles[ i ].vehicletype = ToLower( vehicles[ i ].vehicletype );
if ( vehicles[ i ].vehicletype == "bog_mortar" || vehicles[ i ].vehicletype == "empty" )
continue;
if ( IsDefined( vehicles[ i ].spawnflags ) && vehicles[ i ].spawnflags & 1 )
playerdrivablevehicles[ playerdrivablevehicles.size ] = vehicles[ i ];
allvehiclesprespawn[ allvehiclesprespawn.size ] = vehicles[ i ];
if ( !IsDefined( level.vehicleInitThread[ vehicles[ i ].vehicletype ] ) )
level.vehicleInitThread[ vehicles[ i ].vehicletype ] = [];
if ( is_iw4_map_sp() )
loadstring = "maps\\\_" + vehicles[ i ].vehicletype + "::main( \"" + vehicles[ i ].model + "\" );";
else
loadstring = "classname: " + vehicles[ i ].classname ;
precachesetup( loadstring, vehicles[ i ] );
}
if ( level.needsprecaching.size > 0 )
{
PrintLn( "----------------------------------------------------------------------------------" );
PrintLn( "---missing vehicle script: run repackage zone and precache scripts from launcher--" );
PrintLn( "----------------------------------------------------------------------------------" );
for ( i = 0; i < level.needsprecaching.size; i++ )
PrintLn( level.needsprecaching[ i ] );
PrintLn( "----------------------------------------------------------------------------------" );
AssertEx( false, "missing vehicle scripts, see above console prints" );
level waittill( "never" );
}
return allvehiclesprespawn;
}
precachesetup( string, vehicle )
{
if( is_iw4_map_sp() )
{
if ( IsDefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.model ] ) )
return;
}
else
{
if ( IsDefined( level.vehicleInitThread[ vehicle.vehicletype ][ vehicle.classname ] ) )
return;
if( vehicle.classname == "script_vehicle" )
return;
}
matched = false;
for ( i = 0; i < level.needsprecaching.size; i++ )
if ( level.needsprecaching[ i ] == string )
matched = true;
if ( !matched )
level.needsprecaching[ level.needsprecaching.size ] = string;
}
vehicle_kill_disconnect_paths_forever()
{
self notify( "kill_disconnect_paths_forever" );
}
disconnect_paths_whenstopped()
{
self endon( "death" );
dont_disconnect_paths = false;
if ( IsDefined( self.script_disconnectpaths ) && !self.script_disconnectpaths )
dont_disconnect_paths = true;
if ( dont_disconnect_paths )
{
self.dontDisconnectPaths = true;
return;
}
wait( RandomFloat( 1 ) );
while ( IsDefined( self ) )
{
if ( self Vehicle_GetSpeed() < 1 )
{
if ( !IsDefined( self.dontDisconnectPaths ) )
self DisconnectPaths();
else
{
AssertEx( self.dontDisconnectPaths == 1, ".dontDisconnectPaths should either be 1 or undefined." );
}
self notify( "speed_zero_path_disconnect" );
while ( self Vehicle_GetSpeed() < 1 )
wait 0.05;
}
self ConnectPaths();
wait 1;
}
}
vehicle_setspeed_wrapper( speed, rate, msg )
{
if ( self Vehicle_GetSpeed() == 0 && speed == 0 )
return;
self Vehicle_SetSpeed( speed, rate );
}
debug_vehiclesetspeed( speed, rate, msg )
{
}
script_resumespeed( msg, rate )
{
self endon( "death" );
fSetspeed = 0;
type = "resumespeed";
if ( !IsDefined( self.resumemsgs ) )
self.resumemsgs = [];
if ( IsDefined( self.waitingforgate ) && self.waitingforgate )
return;
if ( IsDefined( self.attacking ) )
{
if ( self.attacking )
{
fSetspeed = self.attackspeed;
type = "setspeed";
}
}
self.zerospeed = false;
if ( fSetspeed == 0 )
self.zerospeed = true;
if ( type == "resumespeed" )
self ResumeSpeed( rate );
else if ( type == "setspeed" )
self vehicle_setspeed_wrapper( fSetspeed, 15, "resume setspeed from attack" );
self notify( "resuming speed" );
}
print_resumespeed( timer )
{
self notify( "newresumespeedmsag" );
self endon( "newresumespeedmsag" );
self endon( "death" );
while ( GetTime() < timer && IsDefined( self.resumemsgs ) )
{
if ( self.resumemsgs.size > 6 )
start = self.resumemsgs.size - 5;
else
start = 0;
for ( i = start; i < self.resumemsgs.size; i++ )
{
position = i * 32;
Print3d( self.origin + ( 0, 0, position ), "resuming speed: " + self.resumemsgs[ i ], ( 0, 1, 0 ), 1, 3 );
}
wait 0.05;
}
}
force_kill()
{
if ( isDestructible() )
{
self common_scripts\_destructible::force_explosion();
}
else
{
self Kill();
}
}
godon()
{
self.godmode = true;
}
godoff()
{
self.godmode = false;
}
setturretfireondrones( b )
{
if ( IsDefined( self.mgturret ) && self.mgturret.size )
for ( i = 0; i < self.mgturret.size; i++ )
self.mgturret[ i ].script_fireondrones = b;
}
getnormalanimtime( animation )
{
animtime = self GetAnimTime( animation );
animlength = GetAnimLength( animation );
if ( animtime == 0 )
return 0;
return self GetAnimTime( animation ) / GetAnimLength( animation );
}
rotor_anim()
{
Length = GetAnimLength( self getanim( "rotors" ) );
for ( ;; )
{
self SetAnim( self getanim( "rotors" ), 1, 0, 1 );
wait( Length );
}
}
suspend_drive_anims()
{
self notify( "suspend_drive_anims" );
model = self.model;
self ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
self ClearAnim( level.vehicle_DriveIdle_r[ model ], 0 );
}
idle_animations()
{
self UseAnimTree(#animtree );
if ( !IsDefined( level.vehicle_IdleAnim[ self.model ] ) )
return;
foreach ( animation in level.vehicle_IdleAnim[ self.model ] )
self SetAnim( animation );
}
animate_drive_idle()
{
self endon( "suspend_drive_anims" );
if ( !IsDefined( self.wheeldir ) )
self.wheeldir = 1;
model = self.model;
curanimrate = -1;
newanimtime = undefined;
self UseAnimTree(#animtree );
if ( !IsDefined( level.vehicle_DriveIdle[ model ] ) )
return;
if ( !IsDefined( level.vehicle_DriveIdle_r[ model ] ) )
level.vehicle_DriveIdle_r[ model ] = level.vehicle_DriveIdle[ model ];
self endon( "death" );
normalspeed = level.vehicle_DriveIdle_normal_speed[ model ];
animrate = 1.0;
if ( ( IsDefined( level.vehicle_DriveIdle_animrate ) ) && ( IsDefined( level.vehicle_DriveIdle_animrate[ model ] ) ) )
animrate = level.vehicle_DriveIdle_animrate[ model ];
lastdir = self.wheeldir;
animatemodel = self;
animation = level.vehicle_DriveIdle[ model ];
while ( 1 )
{
if ( IsDefined( level.animate_drive_idle_on_dummies ) )
animatemodel = get_dummy();
if ( !normalspeed )
{
if ( IsDefined( self.suspend_driveanims ) )
{
wait 0.05;
continue;
}
animatemodel SetAnim( level.vehicle_DriveIdle[ model ], 1, 0.2, animrate );
return;
}
speed = self Vehicle_GetSpeed();
if( self is_dummy() && isdefined( self.dummyspeed ) )
{
speed = self.dummyspeed;
}
if ( lastdir != self.wheeldir )
{
dif = 0;
if ( self.wheeldir )
{
animation = level.vehicle_DriveIdle[ model ];
dif = 1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle_r[ model ] );
animatemodel ClearAnim( level.vehicle_DriveIdle_r[ model ], 0 );
}
else
{
animation = level.vehicle_DriveIdle_r[ model ];
dif = 1 - animatemodel getnormalanimtime( level.vehicle_DriveIdle[ model ] );
animatemodel ClearAnim( level.vehicle_DriveIdle[ model ], 0 );
}
newanimtime = 0.01;
if ( newanimtime >= 1 || newanimtime == 0 )
newanimtime = 0.01;
lastdir = self.wheeldir;
}
newanimrate = speed / normalspeed;
if( newanimrate != curanimrate )
{
animatemodel SetAnim( animation, 1, 0.05, newanimrate );
curanimrate = newanimrate;
}
if ( IsDefined( newanimtime ) )
{
animatemodel SetAnimTime( animation, newanimtime );
newanimtime = undefined;
}
wait 0.05;
}
}
setup_dynamic_detour( pathnode, get_func )
{
prevnode =[[ get_func ] ] ( pathnode.targetname );
AssertEx( IsDefined( prevnode ), "detour can't be on start node" );
prevnode.detoured = 0;
}
setup_ai()
{
ai = GetAIArray();
for ( i = 0; i < ai.size; i++ )
{
if ( IsDefined( ai[ i ].script_vehicleride ) )
level.vehicle_RideAI = array_2dadd( level.vehicle_RideAI, ai[ i ].script_vehicleride, ai[ i ] );
else
if ( IsDefined( ai[ i ].script_vehiclewalk ) )
level.vehicle_WalkAI = array_2dadd( level.vehicle_WalkAI, ai[ i ].script_vehiclewalk, ai[ i ] );
}
ai = GetSpawnerArray();
for ( i = 0; i < ai.size; i++ )
{
if ( IsDefined( ai[ i ].script_vehicleride ) )
level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, ai[ i ].script_vehicleride, ai[ i ] );
if ( IsDefined( ai[ i ].script_vehiclewalk ) )
level.vehicle_walkspawners = array_2dadd( level.vehicle_walkspawners, ai[ i ].script_vehiclewalk, ai[ i ] );
}
}
array_2dadd( array, firstelem, newelem )
{
if ( !IsDefined( array[ firstelem ] ) )
array[ firstelem ] = [];
array[ firstelem ][ array[ firstelem ].size ] = newelem;
return array;
}
is_node_script_origin( pathnode )
{
return IsDefined( pathnode.classname ) && pathnode.classname == "script_origin";
}
node_trigger_process()
{
processtrigger = false;
if ( IsDefined( self.spawnflags ) && ( self.spawnflags & 1 ) )
{
if ( IsDefined( self.script_crashtype ) )
level.vehicle_crashpaths[ level.vehicle_crashpaths.size ] = self;
level.vehicle_startnodes[ level.vehicle_startnodes.size ] = self;
}
if ( IsDefined( self.script_vehicledetour ) && IsDefined( self.targetname ) )
{
get_func = undefined;
if ( IsDefined( get_from_entity( self.targetname ) ) )
get_func = ::get_from_entity_target;
if ( IsDefined( get_from_spawnstruct( self.targetname ) ) )
get_func = ::get_from_spawnstruct_target;
if ( IsDefined( get_func ) )
{
setup_dynamic_detour( self, get_func );
processtrigger = true;
}
else
{
setup_groundnode_detour( self );
}
level.vehicle_detourpaths = array_2dadd( level.vehicle_detourpaths, self.script_vehicledetour, self );
if ( level.vehicle_detourpaths[ self.script_vehicledetour ].size > 2 )
PrintLn( "more than two script_vehicledetour grouped in group number: ", self.script_vehicledetour );
}
if ( IsDefined( self.script_gatetrigger ) )
{
level.vehicle_gatetrigger = array_2dadd( level.vehicle_gatetrigger, self.script_gatetrigger, self );
self.gateopen = false;
}
if ( IsDefined( self.script_flag_set ) )
{
if ( !IsDefined( level.flag[ self.script_flag_set ] ) )
flag_init( self.script_flag_set );
}
if ( IsDefined( self.script_flag_clear ) )
{
if ( !IsDefined( level.flag[ self.script_flag_clear ] ) )
flag_init( self.script_flag_clear );
}
if ( IsDefined( self.script_flag_wait ) )
{
if ( !IsDefined( level.flag[ self.script_flag_wait ] ) )
flag_init( self.script_flag_wait );
}
if (
IsDefined( self.script_VehicleSpawngroup )
||	IsDefined( self.script_VehicleStartMove )
||	IsDefined( self.script_gatetrigger )
||	IsDefined( self.script_vehicleGroupDelete )
)
processtrigger = true;
if ( processtrigger )
add_proccess_trigger( self );
}
setup_triggers()
{
level.vehicle_processtriggers = [];
triggers = [];
triggers = array_combine( GetAllVehicleNodes(), GetEntArray( "script_origin", "code_classname" ) );
triggers = array_combine( triggers, level.struct );
triggers = array_combine( triggers, GetEntArray( "trigger_radius", "code_classname" ) );
triggers = array_combine( triggers, GetEntArray( "trigger_disk", "code_classname" ) );
triggers = array_combine( triggers, GetEntArray( "trigger_multiple", "code_classname" ) );
triggers = array_combine( triggers, GetEntArray( "trigger_lookat", "code_classname" ) );
array_thread( triggers, ::node_trigger_process );
}
is_node_script_struct( node )
{
if ( ! IsDefined( node.targetname ) )
return false;
return IsDefined( getstruct( node.targetname, "targetname" ) );
}
setup_vehicles( vehicles )
{
nonspawned = [];
level.failed_spawnvehicles = [];
foreach ( vehicle in vehicles )
{
vehicle setup_gags();
if ( vehicle check_spawn_group_isspawner() )
continue;
else
nonspawned[ nonspawned.size ] = vehicle;
}
check_failed_spawn_groups();
foreach ( live_vehicle in nonspawned )
thread vehicle_init( live_vehicle );
}
check_failed_spawn_groups()
{
if ( !level.failed_spawnvehicles.size )
{
level.failed_spawnvehicles = undefined;
return;
}
PrintLn( "Error: FAILED SPAWNGROUPS" );
foreach ( failed_spawner in level.failed_spawnvehicles )
{
PrintLn( "Error: spawner at: " + failed_spawner.origin );
}
AssertMsg( "Spawngrouped vehicle( s ) without spawnflag checked, see console" );
}
check_spawn_group_isspawner()
{
if ( IsDefined( self.script_VehicleSpawngroup ) && !IsSpawner( self ) )
{
level.failed_spawnvehicles[ level.failed_spawnvehicles.size ] = self;
return true;
}
return IsSpawner( self );
}
vehicle_life()
{
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype;
if ( !IsDefined( level.vehicle_life ) || !IsDefined( level.vehicle_life[ classname ] ) )
wait 2;
AssertEx( IsDefined( level.vehicle_life[ classname ] ), "need to specify build_life() in vehicle script for vehicletype: " + classname );
if ( IsDefined( self.script_startinghealth ) )
self.health = self.script_startinghealth;
else
{
if ( level.vehicle_life[ classname ] == -1 )
return;
else if ( IsDefined( level.vehicle_life_range_low[ classname ] ) && IsDefined( level.vehicle_life_range_high[ classname ] ) )
self.health = ( RandomInt( level.vehicle_life_range_high[ classname ] - level.vehicle_life_range_low[ classname ] ) + level.vehicle_life_range_low[ classname ] );
else
self.health = level.vehicle_life[ classname ];
}
if ( IsDefined( level.destructible_model[ self.model ] ) )
{
self.health = 2000;
self.destructible_type = level.destructible_model[ self.model ];
self common_scripts\_destructible::setup_destructibles( true );
}
}
mginit()
{
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype + self.model;
if ( ( ( IsDefined( self.script_nomg ) ) && ( self.script_nomg > 0 ) ) )
return;
if ( !IsDefined( level.vehicle_mgturret[ classname ] ) )
return;
mgangle = 0;
if ( IsDefined( self.script_mg_angle ) )
mgangle = self.script_mg_angle;
turret_templates = level.vehicle_mgturret[ classname ];
if ( !IsDefined( turret_templates ) )
return;
one_turret = IsDefined( self.script_noteworthy ) && self.script_noteworthy == "onemg";
foreach ( index, turret_template in turret_templates )
{
turret = SpawnTurret( "misc_turret", ( 0, 0, 0 ), turret_template.info );
if ( IsDefined( turret_template.offset_tag ) )
turret LinkTo( self, turret_template.tag, turret_template.offset_tag, ( 0, -1 * mgangle, 0 ) );
else
turret LinkTo( self, turret_template.tag, ( 0, 0, 0 ), ( 0, -1 * mgangle, 0 ) );
turret SetModel( turret_template.model );
turret.angles = self.angles;
turret.isvehicleattached = true;
turret.ownerVehicle = self;
Assert( IsDefined( self.script_team ) );
turret.script_team = self.script_team;
turret thread maps\_mgturret::burst_fire_unmanned();
turret MakeUnusable();
set_turret_team( turret );
level thread maps\_mgturret::mg42_setdifficulty( turret, getDifficulty() );
if ( IsDefined( self.script_fireondrones ) )
turret.script_fireondrones = self.script_fireondrones;
if ( IsDefined( turret_template.deletedelay ) )
turret.deletedelay = turret_template.deletedelay;
if ( IsDefined( turret_template.maxrange ) )
turret.maxrange = turret_template.maxrange;
if ( IsDefined( turret_template.defaultdroppitch ) )
turret SetDefaultDropPitch( turret_template.defaultdroppitch );
self.mgturret[ index ] = turret;
if ( one_turret )
break;
}
foreach ( i, turret in self.mgturret )
{
defaultOnMode = level.vehicle_mgturret[ classname ][ i ].defaultONmode;
if ( IsDefined( defaultOnMode ) )
{
turret turret_set_default_on_mode( defaultOnMode );
}
}
if ( !IsDefined( self.script_turretmg ) )
self.script_turretmg = true;;
if ( IsDefined( self.script_turretmg ) && self.script_turretmg == 0 )
self thread mgoff();
else
{
self.script_turretmg = 1;
self thread mgon();
}
self thread mgtoggle();
}
mgtoggle()
{
if( isdefined( level.vehicles_ignore_mg_toggle ) && level.vehicles_ignore_mg_toggle )
return;
self endon( "death" );
if ( self.script_turretmg )
lasttoggle = 1;
else
lasttoggle = 0;
while ( 1 )
{
if ( lasttoggle != self.script_turretmg )
{
lasttoggle = self.script_turretmg;
if ( self.script_turretmg )
self thread mgon();
else
self thread mgoff();
}
wait 0.5;
}
}
mgoff()
{
self.script_turretmg = 0;
if ( ( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
{
self thread chopper_Turret_Off();
return;
}
if ( !IsDefined( self.mgturret ) )
return;
foreach ( i, turret in self.mgturret )
{
if ( IsDefined( turret.script_fireondrones ) )
turret.script_fireondrones = false;
turret SetMode( "manual" );
}
}
mgon()
{
self.script_turretmg = 1;
if ( ( self isHelicopter() ) && ( self hasHelicopterTurret() ) )
{
self thread chopper_Turret_On();
return;
}
if ( !IsDefined( self.mgturret ) )
return;
foreach ( turret in self.mgturret )
{
turret Show();
if ( IsDefined( turret.script_fireondrones ) )
turret.script_fireondrones = true;
if ( IsDefined( turret.defaultONmode ) )
{
if( turret.defaultONmode != "sentry" )
turret SetMode( turret.defaultONmode );
}
else
{
turret SetMode( "auto_nonai" );
}
set_turret_team( turret );
}
}
set_turret_team( turret )
{
switch( self.script_team )
{
case "allies":
case "friendly":
turret SetTurretTeam( "allies" );
break;
case "axis":
case "enemy":
turret SetTurretTeam( "axis" );
break;
case "team3":
turret SetTurretTeam( "team3" );
break;
default:
AssertMsg( "Unknown script_team: " + self.script_team );
break;
}
}
turret_set_default_on_mode( defaultOnMode )
{
self.defaultONmode = defaultOnMode;
}
isHelicopter()
{
return IsDefined( level.helicopter_list[ self.vehicletype ] );
}
isAirplane()
{
return IsDefined( level.airplane_list[ self.vehicletype ] );
}
isCheap()
{
if ( !IsDefined( self.script_cheap ) )
return false;
if ( !self.script_cheap )
return false;
return true;
}
hasHelicopterDustKickup()
{
if ( !isHelicopter() && !isAirplane() )
return false;
if ( isCheap() )
return false;
return true;
}
hasHelicopterTurret()
{
if ( !IsDefined( self.vehicletype ) )
return false;
if ( isCheap() )
return false;
if ( self.vehicletype == "cobra" )
return true;
if ( self.vehicletype == "cobra_player" )
return true;
if ( self.vehicletype == "viper" )
return true;
return false;
}
Chopper_Turret_On()
{
self endon( "death" );
self endon( "mg_off" );
cosine55 = Cos( 55 );
while ( self.health > 0 )
{
eTarget = self maps\_helicopter_globals::getEnemyTarget( 16000, cosine55, true, true );
if ( IsDefined( eTarget ) )
self thread maps\_helicopter_globals::shootEnemyTarget_Bullets( eTarget );
wait 2;
}
}
chopper_Turret_Off()
{
self notify( "mg_off" );
}
playLoopedFxontag( effect, durration, tag )
{
eModel = get_dummy();
effectorigin = Spawn( "script_origin", eModel.origin );
self endon( "fire_extinguish" );
thread playLoopedFxontag_originupdate( tag, effectorigin );
while ( 1 )
{
PlayFX( effect, effectorigin.origin, effectorigin.upvec );
wait durration;
}
}
playLoopedFxontag_originupdate( tag, effectorigin )
{
effectorigin.angles = self GetTagAngles( tag );
effectorigin.origin = self GetTagOrigin( tag );
effectorigin.forwardvec = AnglesToForward( effectorigin.angles );
effectorigin.upvec = AnglesToUp( effectorigin.angles );
while ( IsDefined( self ) && self.code_classname == "script_vehicle" && self Vehicle_GetSpeed() > 0 )
{
eModel = get_dummy();
effectorigin.angles = eModel GetTagAngles( tag );
effectorigin.origin = eModel GetTagOrigin( tag );
effectorigin.forwardvec = AnglesToForward( effectorigin.angles );
effectorigin.upvec = AnglesToUp( effectorigin.angles );
wait 0.05;
}
}
build_turret( info, tag, model, maxrange, defaultONmode, deletedelay, defaultdroppitch, defaultdropyaw, offset_tag )
{
if ( !IsDefined( level.vehicle_mgturret ) )
level.vehicle_mgturret = [];
classname = level.vtclassname;
if ( is_iw4_map_sp() )
classname = level.vttype + level.vtmodel;
if ( !IsDefined( level.vehicle_mgturret[ classname ] ) )
level.vehicle_mgturret[ classname ] = [];
PreCacheModel( model );
PreCacheTurret( info );
struct = SpawnStruct();
struct.info = info;
struct.tag = tag;
struct.model = model;
struct.maxrange = maxrange;
struct.defaultONmode = defaultONmode;
struct.deletedelay = deletedelay;
struct.defaultdroppitch = defaultdroppitch;
struct.defaultdropyaw = defaultdropyaw;
if ( IsDefined( offset_tag ) )
struct.offset_tag = offset_tag;
level.vehicle_mgturret[ classname ][ level.vehicle_mgturret[ classname ].size ] = struct;
}
setup_dvars()
{
}
empty_var( var )
{
}
setup_levelvars()
{
level.vehicle_ResumeSpeed = 5;
level.vehicle_DeleteGroup = [];
level.vehicle_StartMoveGroup = [];
level.vehicle_RideAI = [];
level.vehicle_WalkAI = [];
level.vehicle_DeathSwitch = [];
level.vehicle_RideSpawners = [];
level.vehicle_walkspawners = [];
level.vehicle_gatetrigger = [];
level.vehicle_crashpaths = [];
level.vehicle_link = [];
level.vehicle_detourpaths = [];
level.vehicle_startnodes = [];
level.vehicle_killspawn_groups = [];
if ( !IsDefined( level.drive_spline_path_fun ) )
level.drive_spline_path_fun = ::empty_var;
level.helicopter_crash_locations = GetEntArray( "helicopter_crash_location", "targetname" );
level.helicopter_crash_locations = array_combine( level.helicopter_crash_locations, getstructarray_delete( "helicopter_crash_location", "targetname" ) );
level.playervehicle = Spawn( "script_origin", ( 0, 0, 0 ) );
level.playervehiclenone = level.playervehicle;
level.vehicles = [];
level.vehicles[ "allies" ] = [];
level.vehicles[ "axis" ] = [];
level.vehicles[ "neutral" ] = [];
level.vehicles[ "team3" ] = [];
if ( !IsDefined( level.vehicle_team ) )
level.vehicle_team = [];
if ( !IsDefined( level.vehicle_deathmodel ) )
level.vehicle_deathmodel = [];
if ( !IsDefined( level.vehicle_death_thread ) )
level.vehicle_death_thread = [];
if ( !IsDefined( level.vehicle_DriveIdle ) )
level.vehicle_DriveIdle = [];
if ( !IsDefined( level.vehicle_DriveIdle_r ) )
level.vehicle_DriveIdle_r = [];
if ( !IsDefined( level.attack_origin_condition_threadd ) )
level.attack_origin_condition_threadd = [];
if ( !IsDefined( level.vehiclefireanim ) )
level.vehiclefireanim = [];
if ( !IsDefined( level.vehiclefireanim_settle ) )
level.vehiclefireanim_settle = [];
if ( !IsDefined( level.vehicle_hasname ) )
level.vehicle_hasname = [];
if ( !IsDefined( level.vehicle_turret_requiresrider ) )
level.vehicle_turret_requiresrider = [];
if ( !IsDefined( level.vehicle_rumble ) )
level.vehicle_rumble = [];
if ( !IsDefined( level.vehicle_rumble_override ) )
level.vehicle_rumble_override = [];
if ( !IsDefined( level.vehicle_mgturret ) )
level.vehicle_mgturret = [];
if ( !IsDefined( level.vehicle_isStationary ) )
level.vehicle_isStationary = [];
if ( !IsDefined( level.vehicle_death_earthquake ) )
level.vehicle_death_earthquake = [];
if ( !IsDefined( level.vehicle_treads ) )
level.vehicle_treads = [];
if ( !IsDefined( level.vehicle_unloadgroups ) )
level.vehicle_unloadgroups = [];
if ( !IsDefined( level.vehicle_aianims ) )
level.vehicle_aianims = [];
if ( !IsDefined( level.vehicle_unloadwhenattacked ) )
level.vehicle_unloadwhenattacked = [];
if ( !IsDefined( level.vehicle_exhaust ) )
level.vehicle_exhaust = [];
if ( !IsDefined( level.vehicle_deckdust ) )
level.vehicle_deckdust = [];
if ( !IsDefined( level.vehicle_shoot_shock ) )
level.vehicle_shoot_shock = [];
if ( !IsDefined( level.vehicle_hide_list ) )
level.vehicle_hide_list = [];
if ( !IsDefined( level.vehicle_frontarmor ) )
level.vehicle_frontarmor = [];
if ( !IsDefined( level.destructible_model ) )
level.destructible_model = [];
if ( !IsDefined( level.vehicle_types ) )
level.vehicle_types = [];
if ( !IsDefined( level.vehicle_grenadeshield ) )
level.vehicle_grenadeshield = [];
if ( !IsDefined( level.vehicle_bulletshield ) )
level.vehicle_bulletshield = [];
if ( !IsDefined( level.vehicle_death_jolt ) )
level.vehicle_death_jolt = [];
if ( !IsDefined( level.vehicle_death_badplace ) )
level.vehicle_death_badplace = [];
if ( !IsDefined( level.vehicle_IdleAnim ) )
level.vehicle_IdleAnim = [];
maps\_vehicle_aianim::setup_aianimthreads();
}
attacker_isonmyteam( attacker )
{
if ( ( IsDefined( attacker ) ) && IsDefined( attacker.script_team ) && ( IsDefined( self.script_team ) ) && ( attacker.script_team == self.script_team ) )
return true;
else
return false;
}
is_invulnerable_from_ai( attacker )
{
if ( !IsDefined( self.script_AI_invulnerable ) )
return false;
if ( ( IsDefined( attacker ) ) && ( IsAI( attacker ) ) && ( self.script_AI_invulnerable == 1 ) )
return true;
else
return false;
}
is_godmode()
{
if ( IsDefined( self.godmode ) && self.godmode )
return true;
else
return false;
}
attacker_troop_isonmyteam( attacker )
{
if ( IsDefined( self.script_team ) && self.script_team == "allies" && IsDefined( attacker ) && IsPlayer( attacker ) )
return true;
else if ( IsAI( attacker ) && attacker.team == self.script_team )
return true;
else
return false;
}
has_frontarmor()
{
return( IsDefined( level.vehicle_frontarmor[ self.vehicletype ] ) );
}
grenadeshielded( type )
{
if ( !IsDefined( self.script_grenadeshield ) )
return false;
type = ToLower( type );
if ( ! IsDefined( type ) || ! IsSubStr( type, "grenade" ) )
return false;
if ( self.script_grenadeshield )
return true;
else
return false;
}
bulletshielded( type )
{
if ( !IsDefined( self.script_bulletshield ) )
return false;
type = ToLower( type );
if ( ! IsDefined( type ) || ! IsSubStr( type, "bullet" ) || IsSubStr( type, "explosive" ) )
return false;
if ( self.script_bulletshield )
return true;
else
return false;
}
explosive_bulletshielded( type )
{
if ( !IsDefined( self.script_explosive_bullet_shield ) )
return false;
type = ToLower( type );
if ( ! IsDefined( type ) || !IsSubStr( type, "explosive" ) )
return false;
if ( self.script_explosive_bullet_shield )
return true;
else
return false;
}
vehicle_should_regenerate( attacker, type)
{
return ( ! IsDefined( attacker ) && self.script_team != "neutral" )
||	attacker_isonmyteam( attacker )
||	attacker_troop_isonmyteam( attacker )
||	isDestructible()
||	is_invulnerable_from_ai( attacker )
||	bulletshielded( type )
||	explosive_bulletshielded( type )
|| grenadeshielded( type )
||	type == "MOD_MELEE";
}
friendlyfire_shield()
{
self endon( "death" );
if ( !IsDefined( level.unstoppable_friendly_fire_shield ) )
self endon( "stop_friendlyfire_shield" );
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype;
if ( IsDefined( level.vehicle_bulletshield[ classname ] ) && !IsDefined( self.script_bulletshield ) )
self.script_bulletshield = level.vehicle_bulletshield[ classname ];
if ( IsDefined( level.vehicle_grenadeshield[ classname ] ) && !IsDefined( self.script_grenadeshield ) )
self.script_grenadeshield = level.vehicle_bulletshield[ classname ];
if ( IsDefined( self.script_mp_style_helicopter ) )
{
self.script_mp_style_helicopter = true;
self.bullet_armor = 5000;
self.health = 350;
}
else
self.script_mp_style_helicopter = false;
self.healthbuffer = 20000;
self.health += self.healthbuffer;
self.currenthealth = self.health;
attacker = undefined;
type = undefined;
weaponName = undefined;
while ( self.health > 0 )
{
self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
foreach ( func in self.damage_functions )
{
thread [[ func ]]( amount, attacker, direction_vec, point, type, modelName, tagName );
}
if ( IsDefined( attacker ) )
attacker maps\_player_stats::register_shot_hit();
if ( vehicle_should_regenerate( attacker, type ) ||	is_godmode() )
self.health = self.currenthealth;
else if ( self has_frontarmor() )
{
self regen_front_armor( attacker, amount );
self.currenthealth = self.health;
}
else if ( self hit_bullet_armor( type ) )
{
self.health = self.currenthealth;
self.bullet_armor -= amount;
}
else
self.currenthealth = self.health;
if ( common_scripts\_destructible::getDamageType( type ) == "splash" )
self.rocket_destroyed_for_achievement = true;
else
self.rocket_destroyed_for_achievement = undefined;
if ( self.health < self.healthbuffer && !IsDefined( self.vehicle_stays_alive ) )
break;
amount = undefined;
attacker = undefined;
direction_vec = undefined;
point = undefined;
type = undefined;
modelName = undefined;
tagName = undefined;
partName = undefined;
dFlags = undefined;
weaponName = undefined;
}
self notify( "death", attacker, type, weaponName );
}
hit_bullet_armor( type )
{
if ( ! self.script_mp_style_helicopter )
return false;
if ( self.bullet_armor <= 0 )
return false;
if ( !( IsDefined( type ) ) )
return false;
if ( ! IsSubStr( type, "BULLET" ) )
return false;
else
return true;
}
regen_front_armor( attacker, amount )
{
forwardvec = AnglesToForward( self.angles );
othervec = VectorNormalize( attacker.origin - self.origin );
if ( VectorDot( forwardvec, othervec ) > 0.86 )
self.health += Int( amount * level.vehicle_frontarmor[ self.vehicletype ] );
}
vehicle_kill_rumble_forever()
{
self notify( "kill_rumble_forever" );
}
vehicle_rumble()
{
self endon( "kill_rumble_forever" );
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype;
rumblestruct = undefined;
if ( IsDefined( self.vehicle_rumble_unique ) )
{
rumblestruct = self.vehicle_rumble_unique;
}
else if ( IsDefined( level.vehicle_rumble_override ) && IsDefined( level.vehicle_rumble_override[ classname ] ) )
{
rumblestruct = level.vehicle_rumble_override;
}
else if ( IsDefined( level.vehicle_rumble[ classname ] ) )
{
rumblestruct = level.vehicle_rumble[ classname ];
}
if ( !IsDefined( rumblestruct ) )
{
return;
}
height = rumblestruct.radius * 2;
zoffset = -1 * rumblestruct.radius;
areatrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, zoffset ), 0, rumblestruct.radius, height );
areatrigger EnableLinkTo();
areatrigger LinkTo( self );
self.rumbletrigger = areatrigger;
self endon( "death" );
if ( !IsDefined( self.rumbleon ) )
self.rumbleon = true;
if ( IsDefined( rumblestruct.scale ) )
self.rumble_scale = rumblestruct.scale;
else
self.rumble_scale = 0.15;
if ( IsDefined( rumblestruct.duration ) )
self.rumble_duration = rumblestruct.duration;
else
self.rumble_duration = 4.5;
if ( IsDefined( rumblestruct.radius ) )
{
self.rumble_radius = rumblestruct.radius;
}
else
{
self.rumble_radius = 600;
}
if ( IsDefined( rumblestruct.basetime ) )
{
self.rumble_basetime = rumblestruct.basetime;
}
else
{
self.rumble_basetime = 1;
}
if ( IsDefined( rumblestruct.randomaditionaltime ) )
{
self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
}
else
{
self.rumble_randomaditionaltime = 1;
}
areatrigger.radius = self.rumble_radius;
while ( 1 )
{
areatrigger waittill( "trigger" );
if ( self Vehicle_GetSpeed() == 0 || !self.rumbleon )
{
wait 0.1;
continue;
}
self childthread vehicle_quake_think();
self childthread vehicle_rumble_think( rumblestruct );
while ( level.player IsTouching( areatrigger ) && self.rumbleon && self Vehicle_GetSpeed() > 0 )
{
wait 0.1;
}
self notify( "end_quake_think" );
self notify( "end_rumble_think" );
}
}
vehicle_quake_think( )
{
self endon( "death" );
self endon( "kill_rumble_forever" );
self endon( "end_quake_think" );
while ( 1 )
{
Earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius );
wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
}
}
vehicle_rumble_think( rumblestruct )
{
self endon( "death" );
self endon( "kill_rumble_forever" );
self endon( "end_rumble_think");
if ( IsDefined( rumblestruct.rumble_rate_wii ) )
rumble_rate_wii = rumblestruct.rumble_rate_wii;
else
rumble_rate_wii = 1.0;
while ( 1 )
{
level.player PlayRumbleOnEntity( rumblestruct.rumble );
wait( rumble_rate_wii );
}
}
vehicle_kill_badplace_forever()
{
self notify( "kill_badplace_forever" );
}
vehicle_badplace()
{
if ( !IsDefined( self.script_badplace ) )
return;
self endon( "kill_badplace_forever" );
if ( !self Vehicle_IsPhysVeh() )
self endon( "death" );
self endon( "delete" );
if ( IsDefined( level.custombadplacethread ) )
{
self thread[[ level.custombadplacethread ] ] ();
return;
}
hasturret = IsDefined( level.vehicle_hasMainTurret[ self.model ] ) && level.vehicle_hasMainTurret[ self.model ];
bp_duration = 0.5;
bp_angle_left = 17;
bp_angle_right = 17;
for ( ;; )
{
if ( !IsDefined( self ) )
return;
if ( !IsDefined( self.script_badplace ) || !self.script_badplace )
{
while ( IsDefined( self ) && ( !IsDefined( self.script_badplace ) || !self.script_badplace ) )
wait 0.5;
if ( !IsDefined( self ) )
return;
}
speed = self Vehicle_GetSpeed();
if ( speed <= 0 )
{
wait bp_duration;
continue;
}
if ( speed < 5 )
bp_radius = 200;
else if ( ( speed > 5 ) && ( speed < 8 ) )
bp_radius = 350;
else
bp_radius = 500;
if ( IsDefined( self.BadPlaceModifier ) )
bp_radius = ( bp_radius * self.BadPlaceModifier );
if ( hasturret )
bp_direction = AnglesToForward( self GetTagAngles( "tag_turret" ) );
else
bp_direction = AnglesToForward( self.angles );
BadPlace_Arc( self.unique_id + "arc", bp_duration, self.origin, bp_radius * 1.9, CONST_bp_height, bp_direction, bp_angle_left, bp_angle_right, "axis", "team3", "allies" );
BadPlace_Cylinder( self.unique_id + "cyl", bp_duration, self.origin, 200, CONST_bp_height, "axis", "team3", "allies" );
wait bp_duration + 0.05;
}
}
no_treads()
{
if ( self isHelicopter() )
return true;
if ( self isAirplane() )
return true;
return false;
}
vehicle_treads()
{
tread_class = self.classname;
if( is_iw4_map_sp() )
tread_class = self.vehicletype;
if ( !IsDefined( level.vehicle_treads[ tread_class ] ) )
return;
if ( no_treads() )
return;
if ( IsDefined( level.tread_override_thread ) )
{
self thread[[ level.tread_override_thread ] ] (	"tag_origin", "back_left", ( 160, 0, 0 ) );
return;
}
singleTreadVehicles[ 0 ] = "snowmobile";
singleTreadVehicles[ 1 ] = "snowmobile_friendly";
singleTreadVehicles[ 2 ] = "snowmobile_player";
singleTreadVehicles[ 3 ] = "motorcycle";
if ( is_in_array( singleTreadVehicles, self.vehicletype ) )
self thread do_single_tread();
else
self thread do_multiple_treads();
}
do_single_tread()
{
self endon ( "death" );
self endon( "kill_treads_forever" );
while( true )
{
scale = tread_wait();
if( scale == -1 )
{
wait 0.1;
continue;
}
dummy = self get_dummy();
dummy tread( dummy, scale, "tag_wheel_back_left", "back_left", true, "tag_wheel_back_right" );
}
}
do_multiple_treads()
{
self endon ( "death" );
self endon( "kill_treads_forever" );
while( true )
{
scale = tread_wait();
if( scale == -1 )
{
wait 0.1;
continue;
}
prof_begin( "treads" );
dummy = self get_dummy();
self tread( dummy, scale, "tag_wheel_back_left", "back_left", false );
wait 0.05;
self tread( dummy, scale, "tag_wheel_back_right", "back_right", false );
wait 0.05;
prof_end( "treads" );
}
}
vehicle_kill_treads_forever()
{
self notify( "kill_treads_forever" );
}
tread_wait()
{
speed = self Vehicle_GetSpeed();
if ( ! speed )
{
return -1;
}
speed *= CONST_MPHCONVERSION;
waitTime = ( 1 / speed );
waitTime = clamp( ( waitTime * 35 ), 0.1, 0.3 );
if(isdefined(self.treadfx_freq_scale))
{
waitTime *= self.treadfx_freq_scale;
}
wait waitTime;
return waitTime;
}
tread( dummy, scale, tagname, side, do_second_tag, secondTag )
{
treadfx = treadget( self, side );
if ( treadfx == -1 )
return;
ang = dummy GetTagAngles( tagname );
forwardVec = AnglesToForward( ang );
effectOrigin = self GetTagOrigin( tagname );
if ( do_second_tag )
{
secondTagOrigin = self GetTagOrigin( secondTag );
effectOrigin = ( effectOrigin + secondTagOrigin ) / 2;
}
PlayFX( treadfx, effectOrigin, AnglesToUp( ang ), ( forwardVec * scale ) );
}
treadget( vehicle, side )
{
surface = self GetWheelSurface( side );
if ( !IsDefined( vehicle.vehicletype ) )
{
treadfx = -1;
return treadfx;
}
classname = vehicle.classname;
if( is_iw4_map_sp() )
classname = vehicle.vehicletype;
if ( !IsDefined( level._vehicle_effect[ classname ] ) )
{
PrintLn( "no treads setup for vehicle type: ", classname );
wait 1;
return - 1;
}
treadfx = level._vehicle_effect[ classname ][ surface ];
if ( !IsDefined( treadfx ) )
treadfx = -1;
return treadfx;
}
isStationary()
{
type = self.vehicletype;
if ( IsDefined( level.vehicle_isStationary[ type ] ) && level.vehicle_isStationary[ type ] )
return true;
else
return false;
}
vehicle_shoot_shock()
{
if ( !IsDefined( level.vehicle_shoot_shock[ self.classname] ) )
return;
if ( GetDvar( "disable_tank_shock_minspec" ) == "1" )
return;
self endon( "death" );
if ( !IsDefined( level.vehicle_shoot_shock_overlay ) )
{
level.vehicle_shoot_shock_overlay = NewHudElem();
level.vehicle_shoot_shock_overlay.x = 0;
level.vehicle_shoot_shock_overlay.y = 0;
level.vehicle_shoot_shock_overlay SetShader( "black", 640, 480 );
level.vehicle_shoot_shock_overlay.alignX = "left";
level.vehicle_shoot_shock_overlay.alignY = "top";
level.vehicle_shoot_shock_overlay.horzAlign = "fullscreen";
level.vehicle_shoot_shock_overlay.vertAlign = "fullscreen";
level.vehicle_shoot_shock_overlay.alpha = 0;
}
self endon ( "stop_vehicle_shoot_shock" );
while ( true )
{
self waittill( "weapon_fired" );
if ( IsDefined( self.shock_distance ) )
shock_distance = self.shock_distance;
else
shock_distance = 400;
if ( IsDefined( self.black_distance ) )
black_distance = self.black_distance;
else
black_distance = 800;
player_distance = Distance( self.origin, level.player.origin );
if ( player_distance > black_distance )
continue;
level.vehicle_shoot_shock_overlay.alpha = 0.5;
level.vehicle_shoot_shock_overlay FadeOverTime( 0.2 );
level.vehicle_shoot_shock_overlay.alpha = 0;
if ( player_distance > shock_distance )
continue;
if ( IsDefined( level.player.flashendtime ) && ( ( level.player.flashendtime - GetTime() ) > 200 ) )
continue;
if (IsDefined(self.shellshock_audio_disabled) && self.shellshock_audio_disabled)
continue;
fraction = player_distance / shock_distance;
time = 4 - ( 3 * fraction );
level.player ShellShock( level.vehicle_shoot_shock[ self.classname ], time );
}
}
vehicle_setteam()
{
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype;
if ( !IsDefined( self.script_team ) && IsDefined( level.vehicle_team[ classname ] ) )
self.script_team = level.vehicle_team[ classname ];
level.vehicles[ self.script_team ] = array_add( level.vehicles[ self.script_team ], self );
}
vehicle_handleunloadevent()
{
self endon( "death" );
type = self.vehicletype;
if ( !ent_flag_exist( "unloaded" ) )
{
ent_flag_init( "unloaded" );
}
}
get_vehiclenode_any_dynamic( target )
{
path_start = GetVehicleNode( target, "targetname" );
if ( !IsDefined( path_start ) )
{
path_start = GetEnt( target, "targetname" );
}
else if ( ishelicopter() )
{
PrintLn( "helicopter node targetname: " + path_start.targetname );
PrintLn( "vehicletype: " + self.vehicletype );
AssertMsg( "helicopter on vehicle path( see console for info )" );
}
if ( !IsDefined( path_start ) )
{
path_start = getstruct( target, "targetname" );
}
return path_start;
}
vehicle_resumepathvehicle()
{
if ( !self ishelicopter() )
{
self ResumeSpeed( 35 );
return;
}
node = undefined;
if ( IsDefined( self.currentnode.target ) )
node = get_vehiclenode_any_dynamic( self.currentnode.target );
if ( !IsDefined( node ) )
return;
vehicle_paths( node );
}
setvehgoalpos_wrap( origin, bStop )
{
if ( self.health <= 0 )
return;
if ( IsDefined( self.originheightoffset ) )
origin += ( 0, 0, self.originheightoffset );
self SetVehGoalPos( origin, bStop );
}
vehicle_liftoffvehicle( height )
{
if ( !IsDefined( height ) )
height = 512;
dest = self.origin + ( 0, 0, height );
self SetNearGoalNotifyDist( 10 );
self setvehgoalpos_wrap( dest, 1 );
self waittill( "goal" );
}
waittill_stable()
{
offset = 12;
stabletime = 400;
timer = GetTime() + stabletime;
while ( IsDefined( self ) )
{
if ( abs( self.angles[ 0 ] ) > offset )
timer = GetTime() + stabletime;
if ( abs( self.angles[ 2 ] ) > offset )
timer = GetTime() + stabletime;
if ( GetTime() > timer )
break;
wait 0.05;
}
}
littlebird_landing()
{
self endon ( "death" );
self ent_flag_init( "prep_unload" );
self ent_flag_wait( "prep_unload" );
self turn_unloading_drones_to_ai();
landing_node = self get_landing_node();
landing_node littlebird_lands_and_unloads( self );
self vehicle_paths( landing_node );
}
get_landing_node()
{
node = self.currentnode;
for ( ;; )
{
nextnode = getent_or_struct( node.target, "targetname" );
AssertEx( IsDefined( nextnode ), "Was looking for landing node with script_unload but ran out of nodes to look through." );
if ( IsDefined( nextnode.script_unload ) )
return nextnode;
node = nextnode;
}
}
unload_node( node )
{
self endon ( "death" );
if ( IsDefined( self.ent_flag[ "prep_unload" ] ) && self ent_flag( "prep_unload" ) )
{
return;
}
if ( IsSubStr( self.classname, "snowmobile" ) )
{
while ( self.veh_speed > 15 )
{
wait( 0.05 );
}
}
if ( !IsDefined( node.script_flag_wait ) && !IsDefined( node.script_delay ) )
{
self notify( "newpath" );
}
Assert( IsDefined( self ) );
pathnode = GetNode( node.targetname, "target" );
if ( IsDefined( pathnode ) && self.riders.size )
{
foreach ( rider in self.riders )
{
if ( IsAI( rider ) )
rider thread maps\_spawner::go_to_node( pathnode );
}
}
if ( self ishelicopter() )
{
self SetHoverParams( 0, 0, 0 );
waittill_stable();
}
else
{
self Vehicle_SetSpeed( 0, 35 );
}
if ( IsDefined( node.script_noteworthy ) )
if ( node.script_noteworthy == "wait_for_flag" )
flag_wait( node.script_flag );
self vehicle_unload( node.script_unload );
if ( maps\_vehicle_aianim::riders_unloadable( node.script_unload ) )
self waittill( "unloaded" );
if ( IsDefined( node.script_flag_wait ) || IsDefined( node.script_delay ) )
{
return;
}
if ( IsDefined( self ) )
thread vehicle_resumepathvehicle();
}
move_turrets_here( model )
{
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype + self.model;
if ( !IsDefined( self.mgturret ) )
return;
if ( self.mgturret.size == 0 )
return;
AssertEx( IsDefined( level.vehicle_mgturret[ classname ] ), "no turrets specified for model" );
foreach ( i, turret in self.mgturret )
{
turret Unlink();
turret LinkTo( model, level.vehicle_mgturret[ classname ][ i ].tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
}
}
vehicle_pathdetach()
{
self.attachedpath = undefined;
self notify( "newpath" );
self SetGoalYaw( flat_angle( self.angles )[ 1 ] );
self SetVehGoalPos( self.origin + ( 0, 0, 4 ), 1 );
}
vehicle_to_dummy()
{
AssertEx( !IsDefined( self.modeldummy ), "Vehicle_to_dummy was called on a vehicle that already had a dummy." );
self.modeldummy = Spawn( "script_model", self.origin );
self.modeldummy SetModel( self.model );
self.modeldummy.origin = self.origin;
self.modeldummy.angles = self.angles;
self.modeldummy UseAnimTree(#animtree );
self Hide();
self thread model_dummy_death();
move_riders_here( self.modelDummy );
move_turrets_here( self.modeldummy );
move_truck_junk_here( self.modeldummy );
thread move_lights_here( self.modeldummy );
move_effects_ent_here( self.modeldummy );
copy_destructable_attachments( self.modeldummy );
self.modeldummyon = true;
if ( self hasHelicopterDustKickup() )
{
self notify( "stop_kicking_up_dust" );
self thread aircraft_dust_kickup( self.modeldummy );
}
return self.modeldummy;
}
move_effects_ent_here( model )
{
ent = deathfx_ent();
ent Unlink();
ent LinkTo( model );
}
model_dummy_death()
{
modeldummy = self.modeldummy;
modeldummy endon( "death" );
modeldummy endon( "stop_model_dummy_death" );
while ( IsDefined( self ) )
{
self waittill( "death" );
waittillframeend;
}
modeldummy Delete();
}
move_lights_here( model, classname )
{
model lights_on_internal( "all", self.classname );
wait 0.3;
self thread vehicle_lights_off( "all", self.classname );
}
move_truck_junk_here( model )
{
if ( !IsDefined( self.truckjunk ) )
return;
foreach ( truckjunk in self.truckjunk )
{
if( truckjunk == model )
continue;
truckjunk Unlink();
if( isdefined( truckjunk.script_ghettotag ) )
truckjunk LinkTo( model, truckjunk.script_ghettotag, truckjunk.base_origin, truckjunk.base_angles );
else
truckjunk LinkTo( model );
}
}
dummy_to_vehicle()
{
AssertEx( IsDefined( self.modeldummy ), "Tried to turn a vehicle from a dummy into a vehicle. Can only be called on vehicles that have been turned into dummies with vehicle_to_dummy." );
if ( self isHelicopter() )
self.modeldummy.origin = self GetTagOrigin( "tag_ground" );
else
{
self.modeldummy.origin = self.origin;
self.modeldummy.angles = self.angles;
}
self Show();
move_riders_here( self );
move_turrets_here( self );
thread move_lights_here( self );
move_effects_ent_here( self );
self.modeldummyon = false;
self.modeldummy Delete();
self.modeldummy = undefined;
if ( self hasHelicopterDustKickup() )
{
self notify( "stop_kicking_up_dust" );
self thread aircraft_dust_kickup();
}
return self.modeldummy;
}
move_riders_here( base )
{
if ( !IsDefined( self.riders ) )
return;
riders = self.riders;
foreach ( guy in riders )
{
if ( !IsDefined( guy ) )
continue;
animpos = maps\_vehicle_aianim::anim_pos( self, guy.vehicle_position );
if ( IsDefined( animpos.passenger_2_turret_func ) )
continue;
guy Unlink();
guy LinkTo( base, animpos.sittag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
if ( IsAI( guy ) )
guy ForceTeleport( base GetTagOrigin( animpos.sittag ) );
else
guy.origin = base GetTagOrigin( animpos.sittag );
}
}
spawn_vehicles_from_targetname_newstyle( name )
{
vehicles = [];
test = GetEntArray( name, "targetname" );
test_return = [];
foreach ( v in test )
{
if ( !IsDefined( v.code_classname ) || v.code_classname != "script_vehicle" )
continue;
if ( IsSpawner( v ) )
vehicles[ vehicles.size ] = vehicle_spawn( v );
}
return vehicles;
}
spawn_vehicles_from_targetname( name )
{
vehicles = [];
vehicles = spawn_vehicles_from_targetname_newstyle( name );
AssertEx( vehicles.size, "No vehicle spawners had targetname " + name );
return vehicles;
}
spawn_vehicle_from_targetname( name )
{
vehicleArray = spawn_vehicles_from_targetname( name );
AssertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );
return vehicleArray[ 0 ];
}
spawn_vehicle_from_targetname_and_drive( name )
{
vehicleArray = spawn_vehicles_from_targetname( name );
AssertEx( vehicleArray.size == 1, "Tried to spawn a vehicle from targetname " + name + " but it returned " + vehicleArray.size + " vehicles, instead of 1" );
thread gopath( vehicleArray[ 0 ] );
return vehicleArray[ 0 ];
}
spawn_vehicles_from_targetname_and_drive( name )
{
vehicleArray = spawn_vehicles_from_targetname( name );
foreach ( vehicle in vehicleArray )
thread gopath( vehicle );
return vehicleArray;
}
aircraft_dust_kickup( model )
{
self endon( "death_finished" );
self endon( "stop_kicking_up_dust" );
Assert( IsDefined( self.vehicletype ) );
maxHeight = 1200;
if ( IsDefined( level.treadfx_maxheight ) )
maxHeight = level.treadfx_maxheight;
minHeight = 350;
slowestRepeatWait = 0.15;
fastestRepeatWait = 0.05;
numFramesPerTrace = 3;
doTraceThisFrame = numFramesPerTrace;
defaultRepeatRate = 1.0;
if ( self isAirplane() )
defaultRepeatRate = 0.15;
repeatRate = defaultRepeatRate;
trace = undefined;
d = undefined;
trace_ent = self;
if ( IsDefined( model ) )
trace_ent = model;
if (isdefined(level.treadfx_immediate))
{
repeatrate = 0.1;
doTraceThisFrame = 1;
}
while ( IsDefined( self ) )
{
if ( IsDefined( level.skip_treadfx ) )
return true;
if ( repeatRate <= 0 )
repeatRate = defaultRepeatRate;
wait repeatRate;
if ( !IsDefined( self ) )
return;
doTraceThisFrame--;
if ( doTraceThisFrame <= 0 )
{
doTraceThisFrame = numFramesPerTrace;
trace = BulletTrace( trace_ent.origin, trace_ent.origin - ( 0, 0, 100000 ), false, trace_ent );
d = Distance( trace_ent.origin, trace[ "position" ] );
repeatRate = ( ( d - minHeight ) / ( maxHeight - minHeight ) ) * ( slowestRepeatWait - fastestRepeatWait ) + fastestRepeatWait;
}
if ( !IsDefined( trace ) )
continue;
Assert( IsDefined( d ) );
if ( d > maxHeight )
{
repeatRate = defaultRepeatRate;
continue;
}
if ( IsDefined( trace[ "entity" ] ) )
{
repeatRate = defaultRepeatRate;
continue;
}
if ( !IsDefined( trace[ "position" ] ) )
{
repeatRate = defaultRepeatRate;
continue;
}
if ( !IsDefined( trace[ "surfacetype" ] ) )
trace[ "surfacetype" ] = "dirt";
classname = self.classname;
if( is_iw4_map_sp() )
classname = self.vehicletype;
AssertEx( IsDefined( level._vehicle_effect[ classname ] ), classname + " vehicle script hasn't run _tradfx properly" );
AssertEx( IsDefined( level._vehicle_effect[ classname ][ trace[ "surfacetype" ] ] ), "UNKNOWN SURFACE TYPE: " + trace[ "surfacetype" ] );
if ( level._vehicle_effect[ classname ][ trace[ "surfacetype" ] ] != -1 )
{
PlayFX( level._vehicle_effect[ classname ][ trace[ "surfacetype" ] ], trace[ "position" ] );
}
else
{
}
}
}
tank_crush( crushedVehicle, endNode, tankAnim, truckAnim, animTree, soundAlias, rate )
{
if ( !IsDefined( rate ) )
rate = 1;
Assert( IsDefined( crushedVehicle ) );
Assert( IsDefined( endNode ) );
Assert( IsDefined( tankAnim ) );
Assert( IsDefined( truckAnim ) );
Assert( IsDefined( animTree ) );
animatedTank = vehicle_to_dummy();
self Vehicle_SetSpeed( 7 * rate, 5, 5 );
animLength = GetAnimLength( tankAnim ) / rate;
move_to_time = ( animLength / 3 );
move_from_time = ( animLength / 3 );
node_origin = crushedVehicle.origin;
node_angles = crushedVehicle.angles;
node_forward = AnglesToForward( node_angles );
node_up = AnglesToUp( node_angles );
node_right = AnglesToRight( node_angles );
anim_start_org = GetStartOrigin( node_origin, node_angles, tankAnim );
anim_start_ang = GetStartAngles( node_origin, node_angles, tankAnim );
animStartingVec_Forward = AnglesToForward( anim_start_ang );
animStartingVec_Up = AnglesToUp( anim_start_ang );
animStartingVec_Right = AnglesToRight( anim_start_ang );
tank_Forward = AnglesToForward( animatedTank.angles );
tank_Up = AnglesToUp( animatedTank.angles );
tank_Right = AnglesToRight( animatedTank.angles );
offset_Vec = ( node_origin - anim_start_org );
offset_Forward = VectorDot( offset_Vec, animStartingVec_Forward );
offset_Up = VectorDot( offset_Vec, animStartingVec_Up );
offset_Right = VectorDot( offset_Vec, animStartingVec_Right );
dummy = Spawn( "script_origin", animatedTank.origin );
dummy.origin += ( tank_Forward * offset_Forward );
dummy.origin += ( tank_Up * offset_Up );
dummy.origin += ( tank_Right * offset_Right );
offset_Vec = AnglesToForward( node_angles );
offset_Forward = VectorDot( offset_Vec, animStartingVec_Forward );
offset_Up = VectorDot( offset_Vec, animStartingVec_Up );
offset_Right = VectorDot( offset_Vec, animStartingVec_Right );
dummyVec = ( tank_Forward * offset_Forward );
dummyVec += ( tank_Up * offset_Up );
dummyVec += ( tank_Right * offset_Right );
dummy.angles = VectorToAngles( dummyVec );
if ( IsDefined( soundAlias ) )
level thread play_sound_in_space( soundAlias, node_origin );
animatedTank LinkTo( dummy );
crushedVehicle UseAnimTree( animTree );
animatedTank UseAnimTree( animTree );
Assert( IsDefined( level._vehicle_effect[ "tankcrush" ][ "window_med" ] ) );
Assert( IsDefined( level._vehicle_effect[ "tankcrush" ][ "window_large" ] ) );
crushedVehicle thread tank_crush_fx_on_tag( "tag_window_left_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.2 );
crushedVehicle thread tank_crush_fx_on_tag( "tag_window_right_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_med" ], "veh_glass_break_small", 0.4 );
crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_back_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 0.7 );
crushedVehicle thread tank_crush_fx_on_tag( "tag_windshield_front_glass_fx", level._vehicle_effect[ "tankcrush" ][ "window_large" ], "veh_glass_break_large", 1.5 );
crushedVehicle AnimScripted( "tank_crush_anim", node_origin, node_angles, truckAnim );
animatedTank AnimScripted( "tank_crush_anim", dummy.origin, dummy.angles, tankAnim );
if ( rate != 1 )
{
crushedVehicle SetFlaggedAnim( "tank_crush_anim", truckAnim, 1, 0, rate );
animatedTank SetFlaggedAnim( "tank_crush_anim", tankAnim, 1, 0, rate );
}
dummy MoveTo( node_origin, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
dummy RotateTo( node_angles, move_to_time, ( move_to_time / 2 ), ( move_to_time / 2 ) );
wait move_to_time;
animLength -= move_to_time;
animLength -= move_from_time;
wait animLength;
temp = Spawn( "script_model", ( anim_start_org ) );
temp.angles = anim_start_ang;
anim_end_org = temp LocalToWorldCoords( GetMoveDelta( tankAnim, 0, 1 ) );
anim_end_ang = anim_start_ang + ( 0, GetAngleDelta( tankAnim, 0, 1 ), 0 );
temp Delete();
animEndingVec_Forward = AnglesToForward( anim_end_ang );
animEndingVec_Up = AnglesToUp( anim_end_ang );
animEndingVec_Right = AnglesToRight( anim_end_ang );
attachPos = self GetAttachPos( endNode );
tank_Forward = AnglesToForward( attachPos[ 1 ] );
tank_Up = AnglesToUp( attachPos[ 1 ] );
tank_Right = AnglesToRight( attachPos[ 1 ] );
offset_Vec = ( node_origin - anim_end_org );
offset_Forward = VectorDot( offset_Vec, animEndingVec_Forward );
offset_Up = VectorDot( offset_Vec, animEndingVec_Up );
offset_Right = VectorDot( offset_Vec, animEndingVec_Right );
dummy.final_origin = attachPos[ 0 ];
dummy.final_origin += ( tank_Forward * offset_Forward );
dummy.final_origin += ( tank_Up * offset_Up );
dummy.final_origin += ( tank_Right * offset_Right );
offset_Vec = AnglesToForward( node_angles );
offset_Forward = VectorDot( offset_Vec, animEndingVec_Forward );
offset_Up = VectorDot( offset_Vec, animEndingVec_Up );
offset_Right = VectorDot( offset_Vec, animEndingVec_Right );
dummyVec = ( tank_Forward * offset_Forward );
dummyVec += ( tank_Up * offset_Up );
dummyVec += ( tank_Right * offset_Right );
dummy.final_angles = VectorToAngles( dummyVec );
if ( GetDvar( "debug_tankcrush" ) == "1" )
{
thread draw_line_from_ent_for_time( level.player, self.origin, 1, 0, 0, animLength / 2 );
thread draw_line_from_ent_for_time( level.player, anim_end_org, 0, 1, 0, animLength / 2 );
thread draw_line_from_ent_to_ent_for_time( level.player, dummy, 0, 0, 1, animLength / 2 );
}
dummy MoveTo( dummy.final_origin, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
dummy RotateTo( dummy.final_angles, move_from_time, ( move_from_time / 2 ), ( move_from_time / 2 ) );
wait move_from_time;
self AttachPath( endNode );
waitframe();
dummy_to_vehicle();
}
tank_crush_fx_on_tag( tagName, fxName, soundAlias, startDelay )
{
if ( IsDefined( startDelay ) )
wait startDelay;
PlayFXOnTag( fxName, self, tagName );
if ( IsDefined( soundAlias ) )
self thread play_sound_on_tag( soundAlias, tagName );
}
loadplayer( position, animfudgetime )
{
if ( !IsDefined( animfudgetime ) )
animfudgetime = 0;
Assert( IsDefined( self.riders ) );
Assert( self.riders.size );
guy = undefined;
foreach ( rider in self.riders )
{
if ( rider.vehicle_position == position )
{
guy = rider;
guy.drone_delete_on_unload = true;
guy.playerpiggyback = true;
break;
}
}
AssertEx( !IsAI( guy ), "guy in position of player needs to have script_drone set, use script_startingposition ans script drone in your map" );
Assert( IsDefined( guy ) );
thread show_rigs( position );
animpos = maps\_vehicle_aianim::anim_pos( self, position );
guy notify( "newanim" );
guy DetachAll();
guy SetModel( "fastrope_arms" );
guy UseAnimTree( animpos.player_animtree );
thread maps\_vehicle_aianim::guy_idle( guy, position );
level.player PlayerLinkToDelta( guy, "tag_player", 1.0, 40, 18, 30, 30 );
guy Hide();
animtime = GetAnimLength( animpos.getout );
animtime -= animfudgetime;
self waittill( "unloading" );
level.player DisableWeapons();
guy NotSolid();
wait animtime;
level.player Unlink();
level.player EnableWeapons();
}
show_rigs( position )
{
wait 0.01;
self thread maps\_vehicle_aianim::getout_rigspawn( self, position );
if ( !self.riders.size )
return;
foreach ( rider in self.riders )
self thread maps\_vehicle_aianim::getout_rigspawn( self, rider.vehicle_position );
}
turret_deleteme( turret )
{
if ( IsDefined( self ) )
if ( IsDefined( turret.deletedelay ) )
wait turret.deletedelay;
if ( IsDefined( turret ) )
turret Delete();
}
vehicle_wheels_forward()
{
wheeldirectionchange( 1 );
}
vehicle_wheels_backward()
{
wheeldirectionchange( 0 );
}
wheeldirectionchange( direction )
{
if ( direction <= 0 )
self.wheeldir = 0;
else
self.wheeldir = 1;
}
maingun_FX()
{
if( isdefined( level.maingun_FX_override ) )
{
thread [[ level.maingun_FX_override ]]();
return;
}
model = self.model;
if ( !IsDefined( level.vehicle_deckdust[ model ] ) )
return;
self endon( "death" );
while ( true )
{
self waittill( "weapon_fired" );
PlayFXOnTag( level.vehicle_deckdust[ model ], self, "tag_engine_exhaust" );
barrel_origin = self GetTagOrigin( "tag_flash" );
ground = PhysicsTrace( barrel_origin, barrel_origin + ( 0, 0, -128 ) );
PhysicsExplosionSphere( ground, 192, 100, 1 );
}
}
playTankExhaust()
{
self endon( "death" );
model = self.model;
if ( !IsDefined( level.vehicle_exhaust[ model ] ) )
return;
exhaustDelay = 0.1;
while ( true )
{
if ( !IsDefined( self ) )
return;
if ( !IsAlive( self ) )
return;
PlayFXOnTag( level.vehicle_exhaust[ model ], get_dummy(), "tag_engine_exhaust" );
wait exhaustDelay;
}
}
build_light( model, name, tag, effect, group, delay )
{
if ( !IsDefined( level.vehicle_lights ) )
level.vehicle_lights = [];
if ( !IsDefined( level.vehicle_lights_group_override ) )
level.vehicle_lights_group_override = [];
if ( IsDefined( level.vehicle_lights_group_override[ group ] ) && !level.vtoverride )
return;
struct = SpawnStruct();
struct.name = name;
struct.tag = tag;
struct.delay = delay;
struct.effect = _loadfx( effect );
level.vehicle_lights[ model ][ name ] = struct;
group_light( model, name, "all" );
if ( IsDefined( group ) )
group_light( model, name, group );
}
build_light_override( classname, name, tag, effect, group, delay )
{
if ( !IsDefined( level.script ) )
level.script = ToLower( GetDvar( "mapname" ) );
level.vtclassname = classname;
build_light( classname, name, tag, effect, group, delay );
level.vtoverride = false;
level.vehicle_lights_group_override[ group ] = true;
}
group_light( model, name, group )
{
if ( !IsDefined( level.vehicle_lights_group ) )
level.vehicle_lights_group = [];
if ( !IsDefined( level.vehicle_lights_group[ model ] ) )
level.vehicle_lights_group[ model ] = [];
if ( !IsDefined( level.vehicle_lights_group[ model ][ group ] ) )
level.vehicle_lights_group[ model ][ group ] = [];
foreach ( lightgroup_name in level.vehicle_lights_group[ model ][ group ] )
if ( name == lightgroup_name )
return;
level.vehicle_lights_group[ model ][ group ][ level.vehicle_lights_group[ model ][ group ].size ] = name;
}
lights_on( group, classname )
{
groups = StrTok( group, " " );
array_levelthread( groups, ::lights_on_internal, classname );
}
lights_delayfxforframe()
{
level notify( "new_lights_delayfxforframe" );
level endon( "new_lights_delayfxforframe" );
if ( !IsDefined( level.fxdelay ) )
level.fxdelay = 0;
level.fxdelay += RandomFloatRange( 0.2, 0.4 );
if ( level.fxdelay > 2 )
level.fxdelay = 0;
wait 0.05;
level.fxdelay = undefined;
}
lights_on_internal( group, model )
{
level.lastlighttime = GetTime();
if ( !IsDefined( group ) )
group = "all";
if( ! IsDefined( model ) )
{
model = self.classname;
if( is_iw4_map_sp() && level.script != "contingency" && level.script != "invasion" )
{
model = self.model;
}
}
if( !IsDefined( level.vehicle_lights_group ) )
return;
if ( !IsDefined( level.vehicle_lights_group[ model ] )
|| !IsDefined( level.vehicle_lights_group[ model ][ group ] )
)
return;
thread lights_delayfxforframe();
if ( !IsDefined( self.lights ) )
self.lights = [];
lights = level.vehicle_lights_group[ model ][ group ];
count = 0;
delayoffsetter = [];
for ( i = 0; i < lights.size; i++ )
{
if ( IsDefined( self.lights[ lights[ i ] ] ) )
continue;
template = level.vehicle_lights[ model ][ lights[ i ] ];
if ( IsDefined( template.delay ) )
delay = template.delay;
else
delay = 0;
delay += level.fxdelay;
while ( IsDefined( delayoffsetter[ "" + delay ] ) )
delay += 0.05;
delayoffsetter[ "" + delay ] = true;
self endon( "death" );
childthread noself_delayCall_proc( ::PlayFXOnTag, delay, template.effect, self, template.tag );
self.lights[ lights[ i ] ] = true;
if ( !IsDefined( self ) )
break;
}
level.fxdelay = false;
}
deathfx_ent()
{
if ( !IsDefined( self.deathfx_ent ) )
{
ent = Spawn( "script_model", ( 0, 0, 0 ) );
emodel = get_dummy();
ent SetModel( self.model );
ent.origin = emodel.origin;
ent.angles = emodel.angles;
ent NotSolid();
ent Hide();
ent LinkTo( emodel );
self.deathfx_ent = ent;
}
else
self.deathfx_ent SetModel( self.model );
return self.deathfx_ent;
}
lights_off( group, model, classname )
{
groups = StrTok( group, " ", model );
array_levelthread( groups, ::lights_off_internal, model, classname );
}
lights_off_internal( group, model, classname )
{
if ( IsDefined( classname ) )
model = classname;
else if ( !IsDefined( model ) )
{
if( is_iw4_map_sp() )
model = self.model;
else
model = self.classname;
}
if ( !IsDefined( group ) )
group = "all";
if ( !IsDefined( self.lights ) )
return;
if ( !IsDefined( level.vehicle_lights_group[ model ][ group ] ) )
{
PrintLn( "vehicletype: " + self.vehicletype );
PrintLn( "classname: " + self.classname );
PrintLn( "light group: " + group );
AssertMsg( "lights not defined for this vehicle( see console" );
return;
}
lights = level.vehicle_lights_group[ model ][ group ];
count = 0;
maxlightstopsperframe = 2;
if (isdefined(self.maxlightstopsperframe))
maxlightstopsperframe = self.maxlightstopsperframe;
for ( i = 0;i < lights.size;i++ )
{
template = level.vehicle_lights[ model ][ lights[ i ] ];
StopFXOnTag( template.effect, self, template.tag );
count++;
if ( count >= maxlightstopsperframe )
{
count = 0;
wait 0.05;
}
if ( !IsDefined( self ) )
return;
self.lights[ lights[ i ] ] = undefined;
}
}
build_hideparts( classname, parts_array )
{
Assert( IsDefined( classname ) );
Assert( IsDefined( parts_array ) );
if( !isdefined( level.vehicle_hide_list ) )
level.vehicle_hide_list = [];
level.vehicle_hide_list[classname] = parts_array;
}
build_deathmodel( model, deathmodel, swapDelay, classname )
{
if ( model != level.vtmodel )
return;
if ( !IsDefined( deathmodel ) )
deathmodel = model;
PreCacheModel( model );
PreCacheModel( deathmodel );
if ( !IsDefined( swapDelay ) )
swapDelay = 0;
if ( !IsDefined( classname ) || is_iw4_map_sp() )
{
level.vehicle_deathmodel[ model ] = deathmodel;
level.vehicle_deathmodel_delay[ model ] = swapDelay;
}
else
{
level.vehicle_deathmodel[ classname ] = deathmodel;
level.vehicle_deathmodel_delay[ classname ] = swapDelay;
}
}
build_shoot_shock( shock )
{
PreCacheShader( "black" );
PreCacheShellShock( shock );
level.vehicle_shoot_shock[ level.vtclassname ] = shock;
}
build_idle( animation )
{
if ( !IsDefined( level.vehicle_IdleAnim ) )
level.vehicle_IdleAnim = [];
if ( !IsDefined( level.vehicle_IdleAnim[ level.vtmodel ] ) )
level.vehicle_IdleAnim[ level.vtmodel ] = [];
level.vehicle_IdleAnim[ level.vtmodel ][ level.vehicle_IdleAnim[ level.vtmodel ].size ] = animation;
}
build_drive( forward, reverse, normalspeed, rate )
{
if ( !IsDefined( normalspeed ) )
normalspeed = 10;
level.vehicle_DriveIdle[ level.vtmodel ] = forward;
if ( IsDefined( reverse ) )
level.vehicle_DriveIdle_r[ level.vtmodel ] = reverse;
level.vehicle_DriveIdle_normal_speed[ level.vtmodel ] = normalspeed;
if ( IsDefined( rate ) )
level.vehicle_DriveIdle_animrate[ level.vtmodel ] = rate;
}
build_template( type, model, typeoverride, classname )
{
if ( !IsDefined( level.script ) )
level.script = ToLower( GetDvar( "mapname" ) );
if ( IsDefined( typeoverride ) )
type = typeoverride;
if ( is_iw4_map_sp() )
classname = type + model;
else
AssertEx( IsDefined( classname ), "templated without classname" );
PrecacheVehicle( type );
if ( !IsDefined( level.vehicle_death_fx ) )
level.vehicle_death_fx = [];
if (	!IsDefined( level.vehicle_death_fx[ classname ] ) )
level.vehicle_death_fx[ classname ] = [];
level.vehicle_team[ classname ] = "axis";
level.vehicle_life[ classname ] = 999;
level.vehicle_hasMainTurret[ model ] = false;
level.vehicle_mainTurrets[ model ] = [];
level.vtmodel = model;
level.vttype = type;
level.vtclassname = classname;
}
build_exhaust( effect )
{
level.vehicle_exhaust[ level.vtmodel ] = _loadfx( effect );
}
build_treadfx()
{
classname = level.vtclassname;
if ( is_iw4_map_sp() )
classname = level.vttype;
maps\_treadfx::main( classname );
}
build_team( team )
{
if ( is_iw4_map_sp() )
level.vehicle_team[ level.vttype ] = team;
else
level.vehicle_team[ level.vtclassname ] = team;
}
build_mainturret( tag1, tag2, tag3, tag4 )
{
level.vehicle_hasMainTurret[ level.vtmodel ] = true;
if ( IsDefined( tag1 ) )
level.vehicle_mainTurrets[ level.vtmodel ][ tag1 ] = true;
if ( IsDefined( tag2 ) )
level.vehicle_mainTurrets[ level.vtmodel ][ tag2 ] = true;
if ( IsDefined( tag3 ) )
level.vehicle_mainTurrets[ level.vtmodel ][ tag3 ] = true;
if ( IsDefined( tag4 ) )
level.vehicle_mainTurrets[ level.vtmodel ][ tag4 ] = true;
}
build_bulletshield( bShield )
{
Assert( IsDefined( bShield ) );
if ( is_iw4_map_sp() )
level.vehicle_bulletshield[ level.vttype ] = bShield;
else
level.vehicle_bulletshield[ level.vtclassname ] = bShield;
}
build_grenadeshield( bShield )
{
Assert( IsDefined( bShield ) );
if ( is_iw4_map_sp() )
level.vehicle_grenadeshield[ level.vttype ] = bShield;
else
level.vehicle_grenadeshield[ level.vtclassname ] = bShield;
}
build_aianims( aithread, vehiclethread )
{
classname = level.vtclassname;
if ( is_iw4_map_sp() )
classname = level.vttype;
level.vehicle_aianims[ classname ] =[[ aithread ] ] ();
if ( IsDefined( vehiclethread ) )
level.vehicle_aianims[ classname ] =[[ vehiclethread ] ] ( level.vehicle_aianims[ classname ] );
}
build_frontarmor( armor )
{
if ( is_iw4_map_sp() )
level.vehicle_frontarmor[ level.vttype ] = armor;
else
level.vehicle_frontarmor[ level.vtclassname ] = armor;
}
build_attach_models( modelsthread )
{
if ( is_iw4_map_sp() )
level.vehicle_attachedmodels[ level.vttype ] =[[ modelsthread ] ] ();
else
level.vehicle_attachedmodels[ level.vtclassname ] =[[ modelsthread ] ] ();
}
build_unload_groups( unloadgroupsthread )
{
if ( is_iw4_map_sp() )
level.vehicle_unloadgroups[ level.vttype ] =[[ unloadgroupsthread ] ] ();
else
level.vehicle_unloadgroups[ level.vtclassname ] =[[ unloadgroupsthread ] ] ();
}
build_life( health, minhealth, maxhealth )
{
classname = level.vtclassname;
if ( is_iw4_map_sp() )
classname = level.vttype;
level.vehicle_life[ classname ] = health;
level.vehicle_life_range_low[ classname ] = minhealth;
level.vehicle_life_range_high[ classname ] = maxhealth;
}
build_deckdust( effect )
{
level.vehicle_deckdust[ level.vtmodel ] = _loadfx( effect );
}
build_destructible( model, destructible )
{
if ( IsDefined( level.vehicle_csv_export ) )
return;
Assert( IsDefined( model ) );
Assert( IsDefined( destructible ) );
if ( model != level.vtmodel )
return;
passer = SpawnStruct();
passer.model = model;
passer precache_destructible( destructible );
level.destructible_model[ level.vtmodel ] = destructible;
}
build_localinit( init_thread )
{
if( is_iw4_map_sp() )
level.vehicleInitThread[ level.vttype ][ level.vtmodel ] = init_thread;
else
level.vehicleInitThread[ level.vttype ][ level.vtclassname ] = init_thread;
}
get_from_spawnstruct( target )
{
return getstruct( target, "targetname" );
}
get_from_entity( target )
{
ent = GetEntArray( target, "targetname" );
if ( IsDefined( ent ) && ent.size > 0 )
return ent[ RandomInt( ent.size ) ];
return undefined;
}
get_from_spawnstruct_target( target )
{
return getstruct( target, "target" );
}
get_from_entity_target( target )
{
return GetEnt( target, "target" );
}
get_from_vehicle_node( target )
{
return GetVehicleNode( target, "targetname" );
}
set_lookat_from_dest( dest )
{
viewTarget = GetEnt( dest.script_linkto, "script_linkname" );
if ( !IsDefined( viewTarget ) || level.script == "hunted" )
return;
self SetLookAtEnt( viewTarget );
self.set_lookat_point = true;
}
get_deletegroups( script_vehiclegroupdelete )
{
deletegroups = [];
vehicles = GetEntArray( "script_vehicle", "code_classname" );
foreach ( vehicle in vehicles )
{
if ( !IsDefined( vehicle.script_vehicleGroupDelete )
|| vehicle.script_vehicleGroupDelete != script_vehiclegroupdelete
)
continue;
deletegroups[ deletegroups.size ] = vehicle;
}
return deletegroups;
}
damage_hint_bullet_only()
{
level.armorDamageHints = false;
self.displayingDamageHints = false;
self thread damage_hints_cleanup();
while ( IsDefined( self ) )
{
self waittill( "damage", amount, attacker, direction_vec, point, type );
if ( !IsPlayer( attacker ) )
continue;
if ( IsDefined( self.has_semtex_on_it ) )
continue;
type = ToLower( type );
switch( type )
{
case "mod_pistol_bullet":
case "mod_rifle_bullet":
case "bullet":
if ( !level.armorDamageHints )
{
if ( IsDefined( level.thrown_semtex_grenades ) && level.thrown_semtex_grenades > 0 )
break;
level.armorDamageHints = true;
self.displayingDamageHints = true;
attacker display_hint( "invulerable_bullets" );
wait( 4 );
level.armorDamageHints = false;
if (isdefined(self))
self.displayingDamageHints = false;
break;
}
}
}
}
damage_hints()
{
level.armorDamageHints = false;
self.displayingDamageHints = false;
self thread damage_hints_cleanup();
while ( IsDefined( self ) )
{
self waittill( "damage", amount, attacker, direction_vec, point, type );
if ( !IsPlayer( attacker ) )
continue;
if ( IsDefined( self.has_semtex_on_it ) )
continue;
type = ToLower( type );
switch( type )
{
case "mod_grenade":
case "mod_grenade_splash":
case "mod_pistol_bullet":
case "mod_rifle_bullet":
case "bullet":
if ( !level.armorDamageHints )
{
if ( IsDefined( level.thrown_semtex_grenades ) && level.thrown_semtex_grenades > 0 )
break;
level.armorDamageHints = true;
self.displayingDamageHints = true;
if ( ( type == "mod_grenade" ) || ( type == "mod_grenade_splash" ) )
attacker display_hint( "invulerable_frags" );
else
attacker display_hint( "invulerable_bullets" );
wait( 4 );
level.armorDamageHints = false;
if (isdefined(self))
self.displayingDamageHints = false;
break;
}
}
}
}
damage_hints_cleanup()
{
self waittill( "death" );
if ( self.displayingDamageHints )
level.armorDamageHints = false;
}
copy_destructable_attachments( modeldummy )
{
attachedModelCount = self GetAttachSize();
attachedModels = [];
for ( i = 0; i < attachedModelCount; i++ )
attachedModels[ i ] = ToLower( self GetAttachModelName( i ) );
for ( i = 0; i < attachedModels.size; i++ )
modeldummy Attach( attachedModels[ i ], ToLower( self GetAttachTagName( i ) ) );
}
get_dummy()
{
if ( self.modeldummyon )
eModel = self.modeldummy;
else
eModel = self;
return eModel;
}
is_dummy()
{
return self.modeldummyon;
}
apply_truckjunk()
{
if ( !IsDefined( self.truckjunk ) )
return;
junkarray = self.truckjunk;
self.truckjunk = [];
foreach ( truckjunk in junkarray )
{
if( isdefined( truckjunk.spawner ) )
{
model = spawn_tag_origin();
model.spawner = truckjunk.spawner;
}
else
{
model = Spawn( "script_model", self.origin );
model SetModel( truckjunk.model );
}
tag = "tag_body";
if( isdefined( truckjunk.script_ghettotag ) )
{
model.script_ghettotag = truckjunk.script_ghettotag;
model.base_origin = truckjunk.origin;
model.base_angles = truckjunk.angles;
tag = truckjunk.script_ghettotag;
}
if ( IsDefined( truckjunk.destroyEfx ) )
{
truckjunk thread truckjunk_dyn( model );
}
if( isdefined( truckjunk.script_noteworthy ) )
model.script_noteworthy = truckjunk.script_noteworthy;
if( isdefined( truckjunk.script_parameters ) )
model.script_parameters = truckjunk.script_parameters;
model LinkTo( self, tag, truckjunk.origin, truckjunk.angles );
if( isdefined( truckjunk.destructible_type ) )
{
model.destructible_type = truckjunk.destructible_type;
model common_scripts\_destructible::setup_destructibles( true );
}
self.truckjunk[ self.truckjunk.size ] = model;
}
}
truckjunk_dyn( model )
{
model endon ( "death" );
model SetCanDamage( true );
model.health = 8000;
model waittill ( "damage" );
model hide();
ent = spawn_tag_origin();
ent.origin = model.origin;
ent.angles = model.angles;
ent linkto( model );
PlayFXOnTag( self.destroyEfx, ent, "tag_origin" );
}
truckjunk()
{
Assert( IsDefined( self.target ) );
spawner = GetEnt( self.target, "targetname" );
Assert( IsDefined( spawner ) );
Assert( IsSpawner( spawner ) );
ghettotag = ghetto_tag_create( spawner );
if ( IsSpawner( self ) )
ghettotag.spawner = self;
if ( isdefined( self.targetname ) )
{
targeting_spawner = GetEnt( self.targetname, "target" );
if( IsSpawner( targeting_spawner ) )
ghettotag.spawner = targeting_spawner;
}
if ( IsDefined( self.script_noteworthy ) )
ghettotag.script_noteworthy = self.script_noteworthy;
if ( IsDefined( self.script_parameters ) )
ghettotag.script_parameters = self.script_parameters;
if ( IsDefined( self.script_fxid ) )
ghettotag.destroyEfx = getfx( self.script_fxid );
if ( !IsDefined( spawner.truckjunk ) )
spawner.truckjunk = [];
if ( IsDefined( self.script_startingposition ) )
ghettotag.script_startingposition = self.script_startingposition;
if( isdefined( self.destructible_type ) )
{
precache_destructible( self.destructible_type );
ghettotag.destructible_type = self.destructible_type;
}
spawner.truckjunk[ spawner.truckjunk.size ] = ghettotag;
if ( !IsDefined( self.classname ) )
return;
if ( IsSpawner( self ) )
return;
self Delete();
}
ghetto_tag_create( target )
{
struct = SpawnStruct();
tag = "tag_body";
if( isdefined( self.script_ghettotag ) )
{
tag = self.script_ghettotag;
struct.script_ghettotag = self.script_ghettotag;
}
struct.origin = self.origin - target GetTagOrigin( tag );
if ( !IsDefined( self.angles ) )
angles = ( 0, 0, 0 );
else
angles = self.angles;
struct.angles = angles - target GetTagAngles( tag );
struct.model = self.model;
if( IsDefined( self.script_modelname ) )
{
PreCacheModel( self.script_modelname );
struct.model = self.script_modelname;
}
Assert( isdefined( struct.model ) );
if ( IsDefined( struct.targetname ) )
level.struct_class_names[ "targetname" ][ struct.targetname ] = undefined;
if ( IsDefined( struct.target ) )
level.struct_class_names[ "target" ][ struct.target ] = undefined;
return struct;
}
twobuttonspressed( button1, button2 )
{
return level.player ButtonPressed( button1 ) && level.player ButtonPressed( button2 );
}
vehicle_load_ai( ai, goddriver, group )
{
maps\_vehicle_aianim::load_ai( ai, undefined, group );
}
vehicle_load_ai_single( guy, goddriver, group )
{
ai = [];
ai[ 0 ] = guy;
maps\_vehicle_aianim::load_ai( ai, goddriver, group );
}
kill_badplace( classname )
{
if ( !IsDefined( level.vehicle_death_badplace[ classname ] ) )
return;
struct = level.vehicle_death_badplace[ classname ];
if ( IsDefined( struct.delay ) )
wait struct.delay;
if ( !IsDefined( self ) )
return;
BadPlace_Cylinder( "vehicle_kill_badplace", struct.duration, self.origin, struct.radius, struct.height, struct.team1, struct.team2 );
}
build_death_badplace( delay, duration, height, radius, team1, team2 )
{
if ( !IsDefined( level.vehicle_death_badplace ) )
level.vehicle_death_badplace = [];
struct = SpawnStruct();
struct.delay = delay;
struct.duration = duration;
struct.height = height;
struct.radius = radius;
struct.team1 = team1;
struct.team2 = team2;
if( is_iw4_map_sp() )
level.vehicle_death_badplace[ level.vttype ] = struct;
else
level.vehicle_death_badplace[ level.vtclassname ] = struct;
}
build_death_jolt( delay )
{
if ( !IsDefined( level.vehicle_death_jolt ) )
level.vehicle_death_jolt = [];
struct = SpawnStruct();
struct.delay = delay;
if( is_iw4_map_sp() )
level.vehicle_death_jolt[ level.vttype ] = struct;
else
level.vehicle_death_jolt[ level.vtclassname ] = struct;
}
kill_jolt( classname )
{
if ( IsDefined( level.vehicle_death_jolt[ classname ] ) )
{
self.dontfreeme = true;
wait level.vehicle_death_jolt[ classname ].delay;
}
if ( !IsDefined( self ) )
return;
self JoltBody( ( self.origin + ( 23, 33, 64 ) ), 3 );
wait 2;
if ( !IsDefined( self ) )
return;
self.dontfreeme = undefined;
}
heli_squashes_stuff( ender )
{
self endon( "death" );
level endon( ender );
for ( ;; )
{
self waittill( "trigger", other );
if ( IsAlive( other ) )
{
if ( other.team == "allies" && !IsPlayer( other ) )
continue;
other Kill( ( 0, 0, 0 ) );
}
}
}
_getvehiclespawnerarray_by_spawngroup( spawngroup )
{
spawners = _getvehiclespawnerarray();
array = [];
foreach ( spawner in spawners )
if ( IsDefined( spawner.script_VehicleSpawngroup ) && spawner.script_VehicleSpawngroup == spawngroup )
array[ array.size ] = spawner;
return array;
}
_getvehiclespawnerarray( targetname )
{
vehicles = GetEntArray( "script_vehicle", "code_classname" );
if ( IsDefined( targetname ) )
{
newArray = [];
foreach ( vehicle in vehicles )
{
if ( !IsDefined( vehicle.targetname ) )
continue;
if ( vehicle.targetname == targetname )
newArray = array_add( newArray, vehicle );
}
vehicles = newArray;
}
array = [];
foreach ( vehicle in vehicles )
{
if ( IsSpawner( vehicle ) )
array[ array.size ] = vehicle;
}
return array;
}
setup_gags()
{
if ( !IsDefined( self.script_parameters ) )
return;
if ( self.script_parameters == "gag_ride_in" )
setup_gag_ride();
}
setup_gag_ride()
{
Assert( IsDefined( self.targetname ) );
linked = GetEntArray( self.targetname, "target" );
self.script_vehicleride = auto_assign_ride_group();
foreach ( ent in linked )
{
ent.qSetGoalPos = false;
level.vehicle_RideSpawners = array_2dadd( level.vehicle_RideSpawners, self.script_vehicleride, ent );
}
level.gag_heliride_spawner = self;
}
auto_assign_ride_group()
{
if ( !IsDefined( level.vehicle_group_autoasign ) )
level.vehicle_group_autoasign = 1000;
else
level.vehicle_group_autoasign++;
return level.vehicle_group_autoasign;
}
vehicle_script_forcecolor_riders( script_forcecolor )
{
foreach ( rider in self.riders )
{
if ( IsAI( rider ) )
rider set_force_color( script_forcecolor );
else if ( IsDefined( rider.spawner ) )
rider.spawner.script_forcecolor = script_forcecolor;
else
AssertMsg( "rider who's not an ai without a spawner.." );
}
}
vehicle_spawn_group_limit_riders( group, ridermax )
{
spawners = sort_by_startingpos( level.vehicle_RideSpawners[ group ] );
array = [];
for ( i = 0; i < ridermax; i++ )
array[ array.size ] = spawners[ i ];
level.vehicle_RideSpawners[ group ] = array;
}
update_steering( vehicle )
{
if ( vehicle.update_time != GetTime() )
{
vehicle.update_time = GetTime();
if ( vehicle.steering_enable )
{
steering_goal = clamp( 0 - vehicle.angles[ 2 ], 0 - vehicle.steering_maxroll, vehicle.steering_maxroll ) / vehicle.steering_maxroll;
if ( isDefined( vehicle.leanAsItTurns ) && vehicle.leanAsItTurns )
{
vehicle_steering = vehicle Vehicle_GetSteering();
vehicle_steering = vehicle_steering * -1.0;
steering_goal += vehicle_steering;
if ( steering_goal != 0 )
{
goal_factor = 1.0 / abs( steering_goal );
if ( goal_factor < 1 )
steering_goal *= goal_factor;
}
}
delta = steering_goal - vehicle.steering;
if ( delta != 0 )
{
factor = vehicle.steering_maxdelta / abs( delta );
if ( factor < 1 )
delta *= factor;
vehicle.steering += delta;
}
}
else
{
vehicle.steering = 0;
}
}
return vehicle.steering;
}
mount_snowmobile( vehicle, sit_position )
{
self endon( "death" );
self endon( "long_death" );
if ( doinglongdeath() )
return;
rider_types = [];
rider_types[ 0 ] = "snowmobile_driver";
rider_types[ 1 ] = "snowmobile_passenger";
tags = [];
tags[ "snowmobile_driver" ] = "tag_driver";
tags[ "snowmobile_passenger" ] = "tag_passenger";
rider_type = rider_types[ sit_position ];
AssertEx( IsDefined( rider_type ), "Tried to make a guy mount a snowmobile but it already had 2 riders!" );
tag = tags[ rider_type ];
tag_origin = vehicle GetTagOrigin( tag );
tag_angles = vehicle GetTagAngles( tag );
closest_scene_name = undefined;
closest_org = undefined;
closest_dist = 9999999;
foreach ( scene_name, _ in level.snowmobile_mount_anims[ rider_type ] )
{
animation = getanim_generic( scene_name );
org = GetStartOrigin( tag_origin, tag_angles, animation );
new_dist = Distance( self.origin, org );
if ( new_dist < closest_dist )
{
closest_dist = new_dist;
closest_org = org;
closest_scene_name = scene_name;
}
}
AssertEx( IsDefined( closest_scene_name ), "Somehow an AI could not find an animation to mount a snowmobile" );
closest_org = drop_to_ground( closest_org );
self.goalradius = 8;
self.disablearrivals = true;
self SetGoalPos( closest_org );
self waittill( "goal" );
vehicle anim_generic( self, closest_scene_name, tag );
vehicle thread maps\_vehicle_aianim::guy_enter( self );
self.disablearrivals = false;
}
get_my_spline_node( org )
{
org = ( org[ 0 ], org[ 1 ], 0 );
all_nodes = get_array_of_closest( org, level.snowmobile_path );
close_nodes = [];
for ( i = 0; i < 3; i++ )
{
close_nodes[ i ] = all_nodes[ i ];
}
for ( i = 0; i < level.snowmobile_path.size; i++ )
{
foreach ( node in close_nodes )
{
if ( node == level.snowmobile_path[ i ] )
{
return node;
}
}
}
AssertEx( 0, "Found no node to be on!" );
}
spawn_vehicle_and_attach_to_spline_path( default_speed )
{
if ( level.enemy_snowmobiles.size >= 8 )
return;
vehicle = self spawn_vehicle();
if ( IsDefined( default_speed ) )
vehicle VehPhys_SetSpeed( default_speed );
vehicle thread vehicle_becomes_crashable();
vehicle endon( "death" );
vehicle.dontUnloadOnEnd = true;
vehicle gopath( vehicle );
vehicle leave_path_for_spline_path();
}
leave_path_for_spline_path()
{
self endon( "script_crash_vehicle" );
self waittill_either( "enable_spline_path", "reached_end_node" );
node = self get_my_spline_node( self.origin );
node thread[[ level.drive_spline_path_fun ] ] ( self );
}
kill_vehicle_spawner( trigger )
{
trigger waittill( "trigger" );
foreach ( spawner in level.vehicle_killspawn_groups[ trigger.script_kill_vehicle_spawner ] )
{
spawner Delete();
}
level.vehicle_killspawn_groups[ trigger.script_kill_vehicle_spawner ] = [];
}
spawn_vehicle_and_gopath()
{
vehicle = self spawn_vehicle();
if ( IsDefined( self.script_speed ) )
{
if ( !isHelicopter() )
vehicle VehPhys_SetSpeed( self.script_speed );
}
vehicle thread maps\_vehicle::gopath( vehicle );
return vehicle;
}
attach_vehicle_triggers()
{
triggers = GetEntArray( "vehicle_touch_trigger", "targetname" );
other_triggers = GetEntArray( "vehicle_use_trigger", "targetname" );
triggers = array_combine( triggers, other_triggers );
origin = undefined;
foreach ( trigger in triggers )
{
if ( trigger.script_noteworthy == self.model )
{
origin = trigger.origin;
break;
}
}
vehicle_triggers = [];
foreach ( trigger in triggers )
{
if ( trigger.script_noteworthy != self.model )
continue;
if ( trigger.origin != origin )
continue;
vehicle_triggers[ vehicle_triggers.size ] = trigger;
}
self.vehicle_triggers = [];
foreach ( trigger in vehicle_triggers )
{
trigger.targetname = undefined;
trigger thread manual_tag_linkto( self, "tag_origin" );
if ( !IsDefined( self.vehicle_triggers[ trigger.code_classname ] ) )
self.vehicle_triggers[ trigger.code_classname ] = [];
self.vehicle_triggers[ trigger.code_classname ][ self.vehicle_triggers[ trigger.code_classname ].size ] = trigger;
}
}
humvee_antenna_animates( anims )
{
self UseAnimTree(#animtree );
humvee_antenna_animates_until_death( anims );
if ( !IsDefined( self ) )
return;
self ClearAnim( anims[ "idle" ], 0 );
self ClearAnim( anims[ "rot_l" ], 0 );
self ClearAnim( anims[ "rot_r" ], 0 );
}
humvee_antenna_animates_until_death( anims )
{
self endon( "death" );
for ( ;; )
{
weight = self.veh_speed / 18;
if ( weight <= 0.0001 )
weight = 0.0001;
rate = RandomFloatRange( 0.3, 0.7 );
self SetAnim( anims[ "idle" ], weight, 0, rate );
rate = RandomFloatRange( 0.1, 0.8 );
self SetAnim( anims[ "rot_l" ], 1, 0, rate );
rate = RandomFloatRange( 0.1, 0.8 );
self SetAnim( anims[ "rot_r" ], 1, 0, rate );
wait( 0.5 );
}
}
manual_tag_linkto( entity, tag )
{
for ( ;; )
{
if ( !IsDefined( self ) )
break;
if ( !IsDefined( entity ) )
break;
org = entity GetTagOrigin( tag );
ang = entity GetTagAngles( tag );
self.origin = org;
self.angles = ang;
wait( 0.05 );
}
}
littlebird_lands_and_unloads( vehicle )
{
vehicle SetDeceleration( 6 );
vehicle SetAcceleration( 4 );
AssertEx( IsDefined( self.angles ), "Landing nodes must have angles set." );
vehicle SetTargetYaw( self.angles[ 1 ] );
vehicle Vehicle_SetSpeed( 20, 7, 7 );
while ( Distance( flat_origin( vehicle.origin ), flat_origin( self.origin ) ) > 512 )
wait 0.05;
vehicle endon( "death" );
badplace_name = "landing" + RandomInt( 99999 );
BadPlace_Cylinder( badplace_name, 30, self.origin, 200, CONST_bp_height, "axis", "allies", "neutral", "team3" );
vehicle thread vehicle_land_beneath_node( 424, self );
vehicle waittill( "near_goal" );
BadPlace_Delete( badplace_name );
BadPlace_Cylinder( badplace_name, 30, self.origin, 200, CONST_bp_height, "axis", "allies", "neutral", "team3" );
vehicle notify( "groupedanimevent", "pre_unload" );
vehicle thread vehicle_ai_event( "pre_unload" );
vehicle Vehicle_SetSpeed( 20, 22, 7 );
vehicle notify( "nearing_landing" );
if ( IsDefined( vehicle.custom_landing ) )
{
switch( vehicle.custom_landing )
{
case "hover_then_land":
vehicle Vehicle_SetSpeed( 10, 22, 7 );
vehicle thread vehicle_land_beneath_node( 32, self, 64 );
vehicle waittill( "near_goal" );
vehicle notify( "hovering" );
wait( 1 );
break;
default:
AssertMsg( "Unsupported vehicle.custom_landing" );
break;
}
}
vehicle thread vehicle_land_beneath_node( 16, self );
vehicle waittill( "near_goal" );
BadPlace_Delete( badplace_name );
self script_delay();
vehicle vehicle_unload();
vehicle waittill_stable();
vehicle Vehicle_SetSpeed( 20, 8, 7 );
wait 0.2;
vehicle notify( "stable_for_unlink" );
wait 0.2;
if ( IsDefined( self.script_flag_set ) )
{
flag_set( self.script_flag_set );
}
if ( IsDefined( self.script_flag_wait ) )
{
flag_wait( self.script_flag_wait );
}
vehicle notify( "littlebird_liftoff" );
}
setup_gag_stage_littlebird_unload()
{
Assert( IsDefined( self.targetname ) );
Assert( IsDefined( self.angles ) );
while ( 1 )
{
self waittill( "trigger", vehicle );
littlebird_lands_and_unloads( vehicle );
}
}
setup_gag_stage_littlebird_load()
{
Assert( IsDefined( self.targetname ) );
Assert( IsDefined( self.angles ) );
while ( 1 )
{
self waittill( "trigger", vehicle );
vehicle SetDeceleration( 6 );
vehicle SetAcceleration( 4 );
vehicle SetTargetYaw( self.angles[ 1 ] );
vehicle Vehicle_SetSpeed( 20, 7, 7 );
while ( Distance( flat_origin( vehicle.origin ), flat_origin( self.origin ) ) > 256 )
wait 0.05;
vehicle endon( "death" );
vehicle thread vehicle_land_beneath_node( 220, self );
vehicle waittill( "near_goal" );
vehicle Vehicle_SetSpeed( 20, 22, 7 );
vehicle thread vehicle_land_beneath_node( 16, self );
vehicle waittill( "near_goal" );
vehicle waittill_stable();
vehicle notify( "touch_down", self );
vehicle Vehicle_SetSpeed( 20, 8, 7 );
}
}
vehicle_land_beneath_node( neargoal, node, height )
{
if ( !IsDefined( height ) )
height = 0;
self notify( "newpath" );
if ( ! IsDefined( neargoal ) )
neargoal = 2;
self SetNearGoalNotifyDist( neargoal );
self SetHoverParams( 0, 0, 0 );
self ClearGoalYaw();
self SetTargetYaw( flat_angle( node.angles )[ 1 ] );
self setvehgoalpos_wrap( groundpos( node.origin ) + ( 0, 0, height ), 1 );
self waittill( "goal" );
}
vehicle_landvehicle( neargoal, node )
{
self notify( "newpath" );
if ( ! IsDefined( neargoal ) )
neargoal = 2;
self SetNearGoalNotifyDist( neargoal );
self SetHoverParams( 0, 0, 0 );
self ClearGoalYaw();
self SetTargetYaw( flat_angle( self.angles )[ 1 ] );
self setvehgoalpos_wrap( groundpos( self.origin ), 1 );
self waittill( "goal" );
}
vehicle_get_riders_by_group( groupname )
{
group = [];
Assert( IsDefined( self.vehicletype ) );
classname = self.classname;
if ( is_iw4_map_sp() )
classname = self.vehicletype;
if ( ! IsDefined( level.vehicle_unloadgroups[ classname ] ) )
return group;
vehicles_groups = level.vehicle_unloadgroups[ classname ];
if ( ! IsDefined( groupname ) )
{
return group;
}
foreach ( guy in self.riders )
{
Assert( IsDefined( guy.vehicle_position ) );
foreach ( groupid in	vehicles_groups[ groupname ] )
{
if ( guy.vehicle_position == groupid )
{
group[ group.size ] = guy;
}
}
}
return group;
}
vehicle_ai_event( event )
{
return self maps\_vehicle_aianim::animate_guys( event );
}
vehicle_unload( who )
{
self notify( "unloading" );
ai = [];
if ( ent_flag_exist( "no_riders_until_unload" ) )
{
ent_flag_set( "no_riders_until_unload" );
ai = spawn_unload_group( who );
foreach ( a in ai )
spawn_failed( a );
}
if ( IsDefined( who ) )
self.unload_group = who;
foreach ( guy in self.riders )
{
if ( IsAlive( guy ) )
guy notify( "unload" );
}
ai = self vehicle_ai_event( "unload" );
if( is_iw4_map_sp() )
unloadgroups = level.vehicle_unloadgroups[ self.vehicletype ];
else
unloadgroups = level.vehicle_unloadgroups[ self.classname ];
if ( IsDefined( unloadgroups ) )
{
ai = [];
unload_group = self get_unload_group();
foreach ( index, rider in self.riders )
{
if ( IsDefined( unload_group[ rider.vehicle_position ] ) )
ai[ ai.size ] = rider;
}
}
return ai;
}
get_stage_nodes( pickup_node_before_stage, side )
{
Assert( IsDefined( pickup_node_before_stage.target ) );
targeted_nodes = GetNodeArray( pickup_node_before_stage.target, "targetname" );
stage_side_nodes = [];
foreach ( node in targeted_nodes )
{
Assert( IsDefined( node.script_noteworthy ) );
if ( node.script_noteworthy == "stage_" + side )
stage_side_nodes[ stage_side_nodes.size ] = node;
}
return stage_side_nodes;
}
set_stage( pickup_node_before_stage, guys, side )
{
if ( !ent_flag_exist( "staged_guy_" + side ) )
ent_flag_init( "staged_guy_" + side );
else
ent_flag_clear( "staged_guy_" + side );
if ( !ent_flag_exist( "guy2_in_" + side ) )
ent_flag_init( "guy2_in_" + side );
else
ent_flag_clear( "guy2_in_" + side );
nodes = get_stage_nodes( pickup_node_before_stage, side );
Assert( nodes.size );
heli_node = getstruct( pickup_node_before_stage.target, "targetname" );
stage_heli = Spawn( "script_model", ( 0, 0, 0 ) );
stage_heli SetModel( self.model );
if(isdefined(self.new_stage_heli_spawn))
{
stage_heli.origin = self.origin;
}
else
{
stage_heli.origin = drop_to_ground( heli_node.origin ) + ( 0, 0, self.originheightoffset );
}
stage_heli.angles = heli_node.angles;
stage_heli Hide();
hop_on_guy1 = undefined;
patting_back_second_guy = undefined;
stage_guy = undefined;
foreach ( node in nodes )
{
guy = undefined;
foreach ( rider in guys )
{
if ( ( IsDefined( rider.script_startingposition ) ) && ( rider.script_startingposition == node.script_startingposition ) )
{
guy = rider;
break;
}
}
if ( !IsDefined( guy ) )
{
guy = getClosest( node.origin, guys );
}
Assert( IsDefined( guy ) );
Assert( IsDefined( node.script_startingposition ) );
guy.script_startingposition = node.script_startingposition;
if ( guy.script_startingposition == 2 || guy.script_startingposition == 5 )
{
hop_on_guy1 = guy;
guy maps\_spawner::go_to_node_set_goal_node( node );
}
else if ( guy.script_startingposition == 3 || guy.script_startingposition == 6 )
{
stage_guy = guy;
}
else if ( guy.script_startingposition == 4 || guy.script_startingposition == 7 )
{
patting_back_second_guy = guy;
guy maps\_spawner::go_to_node_set_goal_node( node );
}
guys = array_remove( guys, guy );
}
Assert( IsDefined( hop_on_guy1 ) );
Assert( IsDefined( patting_back_second_guy ) );
Assert( IsDefined( stage_guy ) );
self thread stage_guy( stage_guy, side, patting_back_second_guy, stage_heli );
self thread delete_on_death( stage_heli );
}
load_side( side, riders )
{
hop_on_guy1 = undefined;
patting_back_second_guy = undefined;
stage_guy = undefined;
foreach ( rider in riders )
{
Assert( IsDefined( rider.script_startingposition ) );
if ( rider.script_startingposition == 2 || rider.script_startingposition == 5 )
hop_on_guy1 = rider;
else if ( rider.script_startingposition == 3 || rider.script_startingposition == 6 )
stage_guy = rider;
else if ( rider.script_startingposition == 4 || rider.script_startingposition == 7 )
patting_back_second_guy = rider;
}
Assert( IsDefined( hop_on_guy1 ) );
Assert( IsDefined( patting_back_second_guy ) );
Assert( IsDefined( stage_guy ) );
ent_flag_wait( "staged_guy_" + side );
thread vehicle_load_ai_single( hop_on_guy1, undefined, side );
hop_on_guy1 waittill( "boarding_vehicle" );
thread vehicle_load_ai_single( patting_back_second_guy, undefined, side );
patting_back_second_guy waittill( "boarding_vehicle" );
ent_flag_set( "guy2_in_" + side );
}
stage_guy( guy, side, otherguy, stag_objected )
{
scene = "stage_littlebird_" + side;
array = [];
array[ 0 ] = guy;
stag_objected anim_generic_reach( array[ 0 ], scene, "tag_detach_" + side );
stag_objected anim_generic(	array[ 0 ], scene, "tag_detach_" + side );
ent_flag_set( "staged_guy_" + side );
guy SetGoalPos( drop_to_ground( guy.origin ) );
guy.goalradius = 16;
ent_flag_wait( "guy2_in_" + side );
thread vehicle_load_ai_single( guy, undefined, side );
}
kill_riders( riders )
{
foreach ( rider in riders )
{
if ( !IsAlive( rider ) )
continue;
if ( !IsDefined( rider.ridingvehicle ) && !IsDefined( rider.drivingVehicle ) )
continue;
if ( IsDefined( rider.magic_bullet_shield ) )
rider stop_magic_bullet_shield();
rider Kill();
}
}
vehicle_rider_death_detection( vehicle, riders )
{
if ( level.script == "af_chase" )
if ( IsDefined( self.vehicle_position ) && self.vehicle_position != 0 )
return;
self.health = 1;
vehicle endon( "death" );
self.baseaccuracy = 0.15;
self waittill( "death" );
vehicle notify( "driver_died" );
kill_riders( riders );
}
vehicle_becomes_crashable()
{
self endon( "death" );
self endon( "enable_spline_path" );
waittillframeend;
self.riders = remove_dead_from_array( self.riders );
if ( self.riders.size )
{
array_thread( self.riders, ::vehicle_rider_death_detection, self, self.riders );
self waittill_either( "veh_collision", "driver_died" );
kill_riders( self.riders );
wait( 0.25 );
}
self notify( "script_crash_vehicle" );
self VehPhys_Crash();
}
vehicle_turret_scan_on()
{
self endon( "death" );
self endon( "stop_scanning_turret" );
positive_range = RandomInt( 2 );
while ( IsDefined( self ) )
{
if ( cointoss() )
{
self vehicle_aim_turret_at_angle( 0 );
wait( RandomFloatRange( 2, 10 ) );
}
if ( positive_range == 0 )
{
angle = RandomIntRange( 10, 30 );
positive_range = 1;
}
else
{
angle = RandomIntRange( -30, -10 );
positive_range = 0;
}
self vehicle_aim_turret_at_angle( angle );
wait( RandomFloatRange( 2, 10 ) );
}
}
vehicle_turret_scan_off()
{
self notify( "stop_scanning_turret" );
}
vehicle_aim_turret_at_angle( iAngle )
{
self endon( "death" );
vec = AnglesToForward( self.angles + ( 0, iAngle, 0 ) );
vec *= 10000;
vec = vec + ( 0, 0, 70 );
self SetTurretTargetVec( vec );
}
vehicle_get_path_array()
{
self endon( "death" );
aPathNodes = [];
eStartNode = self.attachedpath;
if ( !IsDefined( self.attachedpath ) )
return aPathNodes;
nextNode = eStartNode;
nextNode.counted = false;
while ( IsDefined( nextNode ) )
{
if ( ( IsDefined( nextNode.counted ) ) && ( nextNode.counted == true ) )
break;
aPathNodes = array_add( aPathNodes, nextNode );
nextNode.counted = true;
if ( !IsDefined( nextNode.target ) )
break;
if ( !isHelicopter() )
nextNode = GetVehicleNode( nextNode.target, "targetname" );
else
nextNode = getent_or_struct( nextNode.target, "targetname" );
}
return aPathNodes;
}
kill_lights( model )
{
lights_off_internal( "all", model );
}
vehicle_lights_on( group, classname )
{
if ( !IsDefined( group ) )
group = "all";
lights_on( group, classname );
}
vehicle_lights_off( group, classname )
{
lights_off( group, classname );
}
set_heli_move( heliMove )
{
if ( !is_iw4_map_sp() )
AssertMsg( "set_heli_move moved to SetYawSpeedByName() " );
self SetYawSpeedByName( heliMove );
if ( heliMove == "faster" )
self SetMaxPitchRoll( 25, 50 );
}
get_light_model( model, classname )
{
if( is_iw4_map_sp() && !isdefined( classname ) )
return model;
return classname;
}
vehicle_switch_paths( next_node, target_node )
{
self SetSwitchNode( next_node, target_node );
self.attachedpath = target_node;
self thread vehicle_paths();
}
vehicle_stop_named( stop_name, acceleration, deceleration )
{
if( !isdefined( self.vehicle_stop_named ) )
self.vehicle_stop_named = [];
AssertEX( !IsDefined( self.vehicle_stop_named[ stop_name ] ), "can't stop twice with same name" );
self Vehicle_SetSpeed( 0, acceleration, deceleration );
self.vehicle_stop_named[ stop_name ] = acceleration;
}
vehicle_resume_named( stop_name )
{
resume_speed = self.vehicle_stop_named[ stop_name ];
self.vehicle_stop_named[ stop_name ] = undefined;
if( self.vehicle_stop_named.size )
return;
self ResumeSpeed( resume_speed );
}
