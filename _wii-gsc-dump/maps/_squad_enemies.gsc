#include common_scripts\utility;
#include maps\_utility;
CONST_MIN_SQUAD_SPAWNERS = 4;
CONST_MAINTAIN_SQUAD_NUM = 4;
CONST_SQUAD_FILL_DELAY = 0.15;
CONST_MAX_FOLLOW_DIST = 800;
CONST_FOLLOW_DIST = 600;
CONST_MERGE_SQUAD_MEMBER_MAX = 3;
CONST_RIOTSHIELD_FOLLOW_DIST = 45;
CONST_RIOTSHIELD_FOLLOW_ANGLE	= 145;
CONST_RIOTSHIELD_FOLLOW_RADIUS	= 8;
CONST_SQUAD_LEADER_GOALRADIUS	= 2048;
squad_setup( struct_spawner )
{
if ( !flag_exist( "squad_spawning" ) )
flag_init( "squad_spawning" );
level.new_squad_logic = true;
level.merge_squad_member_max = CONST_MERGE_SQUAD_MEMBER_MAX;
level.leaders = [];
if ( isdefined( struct_spawner ) && struct_spawner )
all_spawn_locs = getstructarray( "leader", "script_noteworthy" );
else
all_spawn_locs = getentarray( "leader", "script_noteworthy" );
foreach ( spawner in all_spawn_locs )
{
if ( isdefined( spawner.targetname ) && isSubStr( spawner.targetname, "protector" ) )
all_spawn_locs = array_remove( all_spawn_locs, spawner );
}
level.squad_follower_func = ::setup_follower_advanced;
thread merge_squad();
thread squad_spread();
thread drawLeader();
return all_spawn_locs;
}
squad_disband( delay, behavior_func, param1 )
{
if ( isdefined( delay ) && delay > 0 )
wait delay;
if ( flag_exist( "squad_spawning" ) )
flag_waitopen( "squad_spawning" );
level notify( "squad_disband" );
level.leaders = [];
if ( isdefined( behavior_func ) )
{
bad_guys = getaiarray( "axis" );
foreach ( guy in bad_guys )
{
guy notify( "ai_behavior_change" );
guy.leader = undefined;
guy.squadmembers = undefined;
if ( isdefined( guy.is_squad_enemy ) && guy.is_squad_enemy )
{
if ( isdefined( param1 ) )
guy thread [[ behavior_func ]]( param1 );
else
guy thread [[ behavior_func ]]();
}
guy.is_squad_enemy = false;
}
}
}
setup_zones( trig, spawn_num )
{
level endon( "challenge_success" );
level endon( "special_op_terminated" );
if ( !flag_exist( "squad_spawning" ) )
flag_init( "squad_spawning" );
zone_spawn_names = trig get_links();
zone_spawners = [];
foreach ( spawn_name in zone_spawn_names )
zone_spawners[ zone_spawners.size ] = getent( spawn_name, "script_linkname" );
trig thread one_direction_trigger();
trig waittill( "trigger" );
if ( getAiarray( "axis" ).size > 1 )
{
level.cleaning_up = true;
squad_clean_up();
wait 2.02;
}
else
{
level.cleaning_up = false;
}
if ( ( level.leaders.size + spawn_num ) > level.desired_squads )
spawn_num = level.desired_squads - level.leaders.size;
for ( i=0; i<spawn_num; i++ )
spawn_far_squad( zone_spawners, undefined, undefined, undefined );
wait ( 1 );
level.cleaning_up = false;
level notify( "clean_up_done" );
level notify( "zone_spawn_complete" );
}
spawn_enemy_squads( follower_size )
{
level endon( "challenge_success" );
level endon( "special_op_terminated" );
all_spawn_locs = squad_setup();
if( !isdefined( level.desired_squads ) )
level.desired_squads = CONST_MAINTAIN_SQUAD_NUM;
else
{
msg = "Must have at least " + CONST_MIN_SQUAD_SPAWNERS + " squad leader spawners in level";
assertex( level.desired_squads >= CONST_MIN_SQUAD_SPAWNERS, msg );
}
if ( isdefined( level.squad_zoning ) && level.squad_zoning )
{
zone_trigs = getentarray( "zone_trig", "targetname" );
foreach ( trig in zone_trigs )
thread setup_zones( trig, int( trig.script_noteworthy ) );
level waittill( "zone_spawn_complete" );
}
while( 1 )
{
wait CONST_SQUAD_FILL_DELAY;
if ( isdefined( level.cleaning_up ) && level.cleaning_up )
level waittill( "clean_up_done" );
if ( level.leaders.size < level.desired_squads )
spawn_far_squad( all_spawn_locs, undefined, undefined, follower_size );
}
}
spawn_far_squad( all_spawn_locs, leader_class, follower_class, follower_size )
{
avoid_locs = [];
avoid_locs[ avoid_locs.size ] = level.player;
if( is_coop() )
{
avoid_locs[ avoid_locs.size ] = level.players[ 1 ];
}
foreach ( leader in level.leaders )
{
avoid_locs[ avoid_locs.size ] = leader;
}
spawn_loc = undefined;
while( all_spawn_locs.size > ( 1 ) )
{
foreach ( avoid_loc in avoid_locs )
{
spawn_loc = getclosest( avoid_loc.origin, all_spawn_locs );
all_spawn_locs = array_remove( all_spawn_locs, spawn_loc );
if ( all_spawn_locs.size == 1 )
break;
}
}
spawn_loc = all_spawn_locs[ 0 ];
thread draw_debug_marker( spawn_loc.origin, ( 1, 1, 1 ) );
assert( isdefined( spawn_loc ) );
if ( isspawner( all_spawn_locs[ 0 ] ) )
spawners = getentarray( spawn_loc.target, "targetname" );
else
spawners = getstructarray( spawn_loc.target, "targetname" );
spawners[ spawners.size ] = spawn_loc;
foreach ( spawner in spawners )
{
if ( !isdefined( spawner.script_noteworthy ) )
spawner.script_noteworthy = "follower";
}
flag_set( "squad_spawning" );
group = [];
group = spawn_enemy_group( spawners, leader_class, follower_class, follower_size );
flag_clear( "squad_spawning" );
wait 0.05;
return group;
}
squad_clean_up()
{
ai_array = getaiarray( "axis" );
foreach ( spawner in ai_array )
{
if ( isdefined( spawner.protector_obj_group ) )
ai_array = array_remove( ai_array, spawner );
}
thread AI_delete_when_out_of_sight( ai_array, 1300 );
}
squad_spread()
{
level endon( "challenge_success" );
level endon( "special_op_terminated" );
while ( 1 )
{
wait 1;
if ( !isdefined( level.leaders ) )
continue;
if ( level.leaders.size < 2 )
continue;
foreach ( leader in level.leaders )
{
if( !isdefined( leader.squadmembers ) || leader.squadmembers.size < 2 )
continue;
foreach ( other_leader in level.leaders )
{
if ( other_leader == leader )
continue;
if( !isdefined( other_leader.squadmembers ) || other_leader.squadmembers.size < 2 )
continue;
if( distance( leader.origin, other_leader.origin ) < CONST_FOLLOW_DIST )
{
foreach( follower in other_leader.squadmembers )
{
if ( isdefined( follower.saw_player ) && follower.saw_player )
follower.goalradius = CONST_MAX_FOLLOW_DIST;
}
}
else
{
foreach( follower in other_leader.squadmembers )
{
if ( isdefined( follower.saw_player ) && follower.saw_player )
follower.goalradius = CONST_FOLLOW_DIST;
}
}
}
}
}
}
merge_squad()
{
level endon( "challenge_success" );
level endon( "special_op_terminated" );
while ( 1 )
{
wait 2;
if ( !isdefined( level.leaders ) )
continue;
if ( level.leaders.size < 2 )
continue;
smallest_leader = level.leaders[ 0 ];
foreach ( leader in level.leaders )
{
if ( smallest_leader.squadmembers.size > leader.squadmembers.size )
smallest_leader = leader;
}
remaining = array_remove( level.leaders, smallest_leader );
second_smallest_leader = remaining[ 0 ];
foreach ( leader in remaining )
{
if ( second_smallest_leader.squadmembers.size > leader.squadmembers.size )
second_smallest_leader = leader;
}
merge_size = smallest_leader.squadmembers.size + second_smallest_leader.squadmembers.size + 2;
if ( merge_size <= CONST_MERGE_SQUAD_MEMBER_MAX )
{
level.leaders = array_remove( level.leaders, smallest_leader );
smallest_leader notify( "demotion" );
group = array_combine( smallest_leader.squadmembers, second_smallest_leader.squadmembers );
group[ group.size ] = smallest_leader;
group[ group.size ] = second_smallest_leader;
second_smallest_leader thread setup_leader( group );
followers = array_remove( group, second_smallest_leader );
foreach ( guy in followers )
{
if ( isalive( guy ) )
guy thread setup_follower( second_smallest_leader );
}
}
}
}
spawn_enemy_group( spawners, leader_class, follower_class, follower_size )
{
level endon( "challenge_success" );
level endon( "special_op_terminated" );
assertex( isdefined( leader_class ) == isdefined( follower_class ), "Squad leader and follower class overrides must be either both or none" );
custom_spawner = false;
if ( isdefined( leader_class ) )
custom_spawner = true;
if( !isdefined( level.leaders ) )
level.leaders = [];
AssertEx( ( spawners.size > 0 ), "The array passed to array_spawn function is empty" );
if ( !isdefined( follower_size ) )
follower_size = spawners.size - 1;
else
follower_size = int( min( spawners.size - 1, follower_size ) );
msg = "Trying to spawn "+follower_size+" followers but only "+ (spawners.size-1) + " spawners are available!";
AssertEx( follower_size < spawners.size, msg );
if ( custom_spawner || !isspawner( spawners[ 0 ] ) )
{
leader_spawner = undefined;
follower_spawner = undefined;
all_spawners = getspawnerarray();
foreach( ai_spawner in all_spawners )
{
if ( ai_spawner.classname == leader_class )
leader_spawner = ai_spawner;
if ( ai_spawner.classname == follower_class )
follower_spawner = ai_spawner;
}
assertex( isdefined( leader_spawner ), "Trying to spawn: [" + leader_class + "] without spawner present in level" );
assertex( isdefined( follower_spawner ), "Trying to spawn: [" + follower_class + "] without spawner present in level" );
follower_count = 0;
group = [];
foreach( spawner in spawners )
{
wait 0.05;
if( spawner.script_noteworthy == "leader" )
{
leader_spawner.script_noteworthy = "leader";
leader_spawner.count = 1;
leader_spawner.origin = spawner.origin;
leader_spawner.angles = spawner.angles;
guy = leader_spawner spawn_ai( true );
group[ group.size ] = guy;
}
if( spawner.script_noteworthy == "follower" )
{
if ( follower_count >= follower_size )
continue;
follower_count++;
follower_spawner.script_noteworthy = "follower";
follower_spawner.count = 1;
follower_spawner.origin = spawner.origin;
follower_spawner.angles = spawner.angles;
guy = follower_spawner spawn_ai( true );
group[ group.size ] = guy;
}
}
}
else
{
assertex( isspawner( spawners[ 0 ] ), "The spawners passed in for spawn arent spawner entities, is this custom spawning?" );
follower_count = 0;
group = [];
foreach ( spawner in spawners )
{
if ( spawner.script_noteworthy == "follower" )
follower_count++;
if ( follower_count >= follower_size )
continue;
spawner.count = 1;
guy = spawner spawn_ai( true );
group[ group.size ] = guy;
}
}
if ( !group.size )
return undefined;
alive_group = [];
foreach( guy in group )
{
guy.is_squad_enemy = true;
if ( isalive( guy ) )
alive_group[ alive_group.size ] = guy;
}
group = alive_group;
leader = undefined;
foreach( guy in group )
{
if( guy.script_noteworthy == "leader" )
{
leader = guy;
leader.back_occupied[ "left" ] = 0;
leader.back_occupied[ "right" ] = 0;
leader thread setup_leader( group );
}
}
if ( group.size < spawners.size && !isdefined( leader ) )
{
leader = group[ randomint( group.size ) ];
leader.script_noteworthy = "leader";
leader thread setup_leader( group );
}
assert( isdefined( leader ) );
foreach( guy in group )
{
if( isdefined( level.squad_drop_weapon_rate ) )
{
drop_chance = randomfloat( 1 );
if( drop_chance > level.squad_drop_weapon_rate )
guy.DropWeapon = false;
}
if( guy.script_noteworthy == "follower" )
guy thread setup_follower( leader );
}
return group;
}
setup_leader( group )
{
level endon( "squad_disband" );
self notify( "new_leader" );
self endon( "new_leader" );
self endon( "demotion" );
self.squadmembers = [];
self.leader = undefined;
foreach( guy in group )
if( !isalive( guy ) )
group array_remove( group, guy );
if ( !isdefined( level.new_squad_logic ) || level.new_squad_logic == false )
{
if( group.size == 1 && level.leaders.size > 0 )
{
leader = level.leaders[0];
if( level.leaders.size > 1 )
leader = get_closest_living( self.origin, level.leaders );
self setup_follower( leader );
return;
}
}
if ( !is_in_array( level.leaders, self ) )
level.leaders[level.leaders.size] = self;
if ( isdefined( level.squad_leader_behavior_func ) )
{
self thread [[ level.squad_leader_behavior_func ]]();
}
else
{
self.goalradius = CONST_SQUAD_LEADER_GOALRADIUS;
player = getclosest( self.origin, level.players );
self.favoriteenemy = player;
self setgoalentity( player );
self setengagementmindist( 300, 200 );
self setengagementmaxdist( 512, 720 );
}
self thread wait_for_followers();
self thread enlarge_follower_goalradius_upon_seeing_player();
if ( !isdefined( level.new_squad_logic ) || level.new_squad_logic == false )
{
self thread handle_all_followers_dying( group );
}
self waittill( "death" );
new_leaders = [];
foreach( leader in level.leaders )
{
if ( isdefined( leader ) && isalive( leader ) )
new_leaders[ new_leaders.size ] = leader;
}
level.leaders = new_leaders;
leader = undefined;
foreach( guy in group )
{
if( isalive( guy ) )
{
if( !isdefined( leader ) )
{
leader = guy;
guy notify( "promotion" );
guy thread setup_leader( group );
}
else
{
guy thread setup_follower( leader );
}
}
}
}
enlarge_follower_goalradius_upon_seeing_player()
{
level endon( "squad_disband" );
self endon( "new_leader" );
self endon( "demotion" );
self endon( "death" );
self waittill( "enemy_visible" );
if ( isdefined( self.squadmembers ) && self.squadmembers.size )
{
foreach( follower in self.squadmembers )
follower notify( "leader_saw_player" );
}
}
wait_for_followers()
{
level endon( "squad_disband" );
self endon( "new_leader" );
self endon( "demotion" );
self endon( "death" );
old_rate = self.moveplaybackrate;
while ( 1 )
{
wait 2;
assertex( isdefined( self ), "Function called on dead or removed AI." );
if ( isdefined( self.squadmembers ) && self.squadmembers.size )
{
guy = get_closest_living( self.origin, self.squadmembers );
if ( isdefined( guy ) && distance( guy.origin, self.origin ) > 256 )
{
self.moveplaybackrate = 0.85 * old_rate;
}
else
{
self.moveplaybackrate = old_rate;
}
}
}
}
setup_follower( leader )
{
level endon( "squad_disband" );
self notify( "assigned_new_leader" );
self endon( "assigned_new_leader" );
self endon( "death" );
self endon( "promotion" );
self.squadmembers = undefined;
self.leader = leader;
self thread leader_follower_count( leader );
assertex( isdefined( leader ), "setup follower to an undefined leader" );
assertex( isalive( leader ), "setup follower to a dead leader" );
if ( isdefined( level.attributes_func ) )
self [[ level.attributes_func ]]();
if ( isdefined( level.squad_follower_func ) )
self [[level.squad_follower_func]]( leader );
else
self thread follow_leader_regular( leader );
}
leader_follower_count( leader )
{
level endon( "squad_disband" );
self endon( "assigned_new_leader" );
leader endon( "death" );
leader.squadmembers[ leader.squadmembers.size ] = self;
self waittill( "death" );
if ( !isdefined( self.leader ) )
return;
if( isalive( self.leader ) && isdefined( self.leader.squadmembers ) && self.leader.squadmembers.size > 0 )
{
new_squadmembers = [];
foreach( guy in leader.squadmembers )
{
if( isalive( guy ) )
new_squadmembers[ new_squadmembers.size ] = guy;
}
leader.squadmembers = new_squadmembers;
}
}
setup_follower_advanced( leader )
{
if ( is_riotshield( leader ) )
{
leader.goalradius = 1300;
position = undefined;
if ( !leader.back_occupied[ "right" ] && !leader.back_occupied[ "left" ] )
{
if ( cointoss() )
self follow_leader_riotshield( "left" );
else
self follow_leader_riotshield( "right" );
return;
}
if ( leader.back_occupied[ "right" ] && leader.back_occupied[ "left" ] )
{
self follow_leader_regular();
return;
}
if ( !leader.back_occupied[ "right" ] && leader.back_occupied[ "left" ] )
{
self follow_leader_riotshield( "right" );
return;
}
if ( leader.back_occupied[ "right" ] && !leader.back_occupied[ "left" ] )
{
self follow_leader_riotshield( "left" );
return;
}
}
else
{
self follow_leader_regular();
}
}
follow_leader_riotshield( position )
{
level endon( "squad_disband" );
self endon( "death" );
self endon( "promotion" );
self.goalradius = 128;
self.pathenemyfightdist = 192;
self.pathenemylookahead = 192;
self.favoriteenemy = undefined;
self setengagementmindist( 300, 200 );
self setengagementmaxdist( 512, 720 );
self.leader.back_occupied[ position ] = 1;
self.is_occupying = position;
self thread setup_follower_goalradius_riotshield();
while( 1 )
{
follower_goal_pos = self.leader get_riotshield_back_pos( position, false );
if ( !isdefined( follower_goal_pos ) )
{
self follow_leader_regular();
return;
}
old_org = self.leader.origin;
wait 0.2;
while ( isdefined( self.leader ) && isalive( self.leader ) && ( distance( self.leader.origin, old_org ) < 2 ) )
{
old_org = self.leader.origin;
wait 0.2;
}
if( !isalive( self.leader ) || !isdefined( follower_goal_pos ) )
self setgoalpos( self.origin );
else
self setgoalpos( follower_goal_pos );
}
}
follow_leader_regular()
{
level endon( "squad_disband" );
self endon( "death" );
self endon( "promotion" );
self.goalradius = 128;
self.pathenemyfightdist = 192;
self.pathenemylookahead = 192;
self.favoriteenemy = undefined;
self setengagementmindist( 300, 200 );
self setengagementmaxdist( 512, 720 );
self thread setup_follower_goalradius();
while( 1 )
{
wait .2;
if( !isalive( self.leader ) )
self setgoalpos( self.origin );
else
self setgoalpos( self.leader.origin );
}
}
protector_leader_logic( protector_obj_group, obj_trig )
{
level endon( "squad_disband" );
self endon( "death" );
self.back_occupied[ "left" ] = 0;
self.back_occupied[ "right" ] = 0;
self.protecting_obj = true;
self.protector_obj_group = protector_obj_group;
goal_struct = getstruct( self.target, "targetname" );
self bind_in_place( obj_trig, goal_struct.origin );
obj_trig waittill( "trigger" );
wait 5;
self.protecting_obj = false;
self.goalradius = 512;
player = getclosest( self.origin, level.players );
self.favoriteenemy = player;
self setgoalentity( player );
}
setup_follower_goalradius()
{
self waittill_either( "enemy_visible", "leader_saw_player" );
self.goalradius = CONST_FOLLOW_DIST;
self.saw_player = true;
}
setup_follower_goalradius_riotshield()
{
level endon( "squad_disband" );
self endon( "death" );
self endon( "promotion" );
self.goalradius = CONST_RIOTSHIELD_FOLLOW_RADIUS;
self waittill( "goal" );
trial_delay = 10;
tries = 5;
follow_duration = 120;
while ( 1 )
{
cqb_walk( "on" );
if ( isdefined( self.protecting_obj ) && self.protecting_obj )
{
wait 1;
continue;
}
wait 30;
self.goalradius = CONST_FOLLOW_DIST;
cqb_walk( "off" );
wait 20;
self.goalradius = CONST_RIOTSHIELD_FOLLOW_RADIUS;
}
self.goalradius = CONST_FOLLOW_DIST;
self.leader.back_occupied[ self.is_occupying ] = 0;
}
get_riotshield_back_pos( direction, facing_player )
{
if ( !isdefined( direction ) )
return undefined;
front_angle = undefined;
if ( isdefined( facing_player ) && facing_player )
{
if ( isdefined( self.enemy ) && isplayer( self.enemy ) )
front_angle = vectortoangles( self.enemy - self.origin );
else
return undefined;
}
else
{
front_angle = self.angles;
}
if ( direction == "left" )
back_angle = ( front_angle[0], front_angle[1]-CONST_RIOTSHIELD_FOLLOW_ANGLE, front_angle[2] );
else
back_angle = ( front_angle[0], front_angle[1]+CONST_RIOTSHIELD_FOLLOW_ANGLE, front_angle[2] );
pos_vector = ( VectorNormalize( AnglesToForward( back_angle ) ) * CONST_RIOTSHIELD_FOLLOW_DIST );
return self.origin + pos_vector;
}
bind_in_place( obj_trig, org )
{
level endon( "squad_disband" );
obj_trig endon( "trigger" );
self endon( "death" );
while ( 1 )
{
self.goalradius = 8;
self setgoalpos( org );
wait 0.05;
}
}
one_direction_trigger()
{
self endon ( "trigger" );
disable_trigger = getent( self.target, "targetname" );
disable_trigger waittill( "trigger" );
self trigger_off();
}
is_leader_riotshield( follower )
{
return ( isdefined( follower.leader ) && follower.leader.classname == "actor_enemy_afghan_riotshield" );
}
is_riotshield( leader )
{
if ( leader.classname == "actor_enemy_afghan_riotshield" )
return true;
return false;
}
handle_all_followers_dying( group )
{
level endon( "squad_disband" );
self endon( "death" );
while( 1 )
{
wait 1;
survivors = 0;
foreach( guy in group )
if( isalive( guy ) )
survivors++;
if( ( survivors == 1 ) && ( level.leaders.size > 1 ) )
{
level.leaders = array_remove( level.leaders, self );
leader = level.leaders[0];
if( level.leaders.size > 1 )
leader = get_closest_living( self.origin, level.leaders );
self thread setup_follower( leader );
self notify( "demotion" );
return;
}
}
}
drawLeader()
{
if( getdvar( "squad_debug" ) == "" || getdvar( "squad_debug" ) == "0" )
return;
color = ( 1, 1, 1 );
while ( 1 )
{
foreach( leader in level.leaders )
{
if( isalive( leader ) && isdefined( leader.squadmembers ) )
{
Print3d( leader.origin + (0,0,70), "leader["+(leader.squadmembers.size+1)+"]", color, 1, 2 );
foreach( guy in leader.squadmembers )
{
if ( isdefined( guy ) && isalive( guy ) )
line( leader.origin, guy.origin, ( 0.5, 0.5, 1 ), 1 );
}
}
}
wait( 0.05 );
}
}
draw_debug_marker( loc, color )
{
if( getdvar( "squad_debug" ) == "" || getdvar( "squad_debug" ) == "0" )
return;
counter = 0;
while ( counter < 40 )
{
Print3d( loc + (0,0,70), "X", color, 1, 8 );
wait ( 0.05 );
counter++;
}
}
drawFollowers()
{
if( getdvar( "squad_debug" ) == "" || getdvar( "squad_debug" ) == "0" )
return;
while( 1 )
{
all_ai = getaiarray();
foreach ( guy in all_ai )
{
if( isdefined( guy.leader ) )
thread draw_line_for_time( guy.origin, guy.leader.origin, 0.5, 0.5, 1, 0.1 );
}
wait 0.1;
}
}
