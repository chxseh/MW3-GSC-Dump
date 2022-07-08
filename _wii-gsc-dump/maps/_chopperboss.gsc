#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
CONST_CHOPPER_BOSS_SHOT_COUNT = 20;
CONST_CHOPPER_BOSS_SHOT_COUNT_LONG = 60;
CONST_CHOPPER_BOSS_WIND_UP_TIME = 2.0;
CONST_CHOPPER_BOSS_MIN_TARGET_DIST_2D	= 384;
CONST_CHOPPER_BOSS_MAX_TARGET_DIST_2D	= 3072;
chopper_boss_load_fx()
{
level._effect[ "chopper_boss_light_smoke" ] = loadfx( "smoke/smoke_trail_white_heli" );
level._effect[ "chopper_boss_heavy_smoke" ] = loadfx( "smoke/smoke_trail_black_heli" );
}
chopper_boss_locs_populate( key, val )
{
level.chopper_boss_locs = getstructarray( val, key );
assertex( level.chopper_boss_locs.size, "Level does not contain any chopper boss structs with targetname so_chopper_boss_loc" );
foreach( loc in level.chopper_boss_locs )
{
loc.neighbors = loc get_linked_structs();
foreach( other_loc in level.chopper_boss_locs )
{
if ( loc == other_loc )
continue;
if ( !array_contains( loc.neighbors, other_loc ) && array_contains( other_loc get_linked_structs(), loc ) )
loc.neighbors[ loc.neighbors.size ] = other_loc;
}
}
}
chopper_path_release( waittills, endons )
{
assertex( isdefined( self ), "Chopper not defined." );
assertex( isdefined( self.loc_current ), "Chopper ref to current location not defined." );
assertex( isdefined( self.loc_current.in_use ), "Current location not marked as in_use." );
if ( isdefined( endons ) )
{
endon_array = strtok( endons, " " );
foreach( end in endon_array )
self endon( end );
}
assertex( isdefined( waittills ) && waittills.size, "Waittills not defined or array of size zero." );
waittills_array = strtok( waittills, " " );
switch ( waittills_array.size )
{
case 1:
self waittill( waittills_array[ 0 ] );
break;
case 2:
self waittill_either( waittills_array[ 0 ], waittills_array[ 1 ] );
break;
case 3:
self waittill_any( waittills_array[ 0 ], waittills_array[ 1 ], waittills_array[ 2 ] );
break;
case 4:
self waittill_any( waittills_array[ 0 ], waittills_array[ 1 ], waittills_array[ 2 ], waittills_array[ 3 ] );
break;
default:
assertmsg( "Called with too many waittills: " + waittills_array.size + ". Add more if needed." );
break;
}
self.loc_current.in_use = undefined;
}
chopper_boss_behavior_little_bird( path_start )
{
assertex( isdefined( path_start ), "Chopper boss behavior called with invalid path_start" );
assertex( !isdefined( path_start.in_use ), "Chopper boss behavior given start path struct that is in use." );
self endon( "death" );
self endon( "deathspin" );
level endon( "special_op_terminated" );
self.loc_current = path_start;
self.loc_current.in_use = true;
self chopper_boss_setup();
self thread chopper_boss_damage_states();
self thread chopper_event_on_death();
fired_weapons = false;
while ( 1 )
{
self.heli_target = undefined;
ignore_current_loc = isdefined( self.request_move ) && self.request_move || fired_weapons;
while ( IsDefined( level.chopper_boss_finding_target ) && level.chopper_boss_finding_target == true )
{
wait 0.05;
}
best_loc = self chopper_boss_get_best_location_and_target( ignore_current_loc );
if ( isdefined( best_loc ) && self.loc_current != best_loc )
{
if ( isdefined( self.heli_target ) )
{
self setlookatent( self.heli_target );
}
else
{
closest_player = getclosest( self.origin, level.players );
if ( isdefined( closest_player ) )
self setlookatent( closest_player );
}
self.request_move = undefined;
self thread chopper_boss_move( best_loc );
self waittill( "reached_dynamic_path_end" );
}
if ( isdefined( self.heli_target ) )
{
fired_weapons = self chopper_boss_attempt_firing( self.heli_target );
}
wait 0.1;
}
}
chopper_boss_setup()
{
self mgoff();
self chopper_boss_sentient();
self add_damagefeedback();
self.mgturret[ 1 ] unlink();
self.mgturret[ 1 ] delete();
turret = self.mgturret[ 0 ];
turret unlink();
turret linkto( self, "tag_turret", ( 0, 0, 0 ), ( 0, 0, 0 ) );
turret setleftarc( 45 );
turret setrightarc( 45 );
turret settoparc( 45 );
turret setbottomarc( 55 );
turret setdefaultdroppitch( -10 );
self.mgturret = [];
self.mgturret[ self.mgturret.size ] = turret;
}
chopper_event_on_death()
{
self waittill( "death", attacker );
if ( !isdefined( self ) )
return;
if( is_survival() )
{
playFx( level._effect[ "money" ], self.origin + ( 0, 0, -32 ) );
}
}
chopper_boss_damage_states()
{
self endon( "death" );
self endon( "deathspin" );
health_original = self.health - self.healthbuffer;
state = 0;
while ( 1 )
{
health = self.health - self.healthbuffer;
if ( health <= health_original * 0.5 )
{
if ( state == 1 )
{
state = 2;
self.request_move = true;
}
playfxontag( getfx( "chopper_boss_heavy_smoke" ), self, "tag_engine" );
}
else if ( health <= health_original * 0.75 )
{
if ( state == 0 )
{
state = 1;
self.request_move = true;
}
playfxontag( getfx( "chopper_boss_light_smoke" ), self, "tag_engine" );
}
wait 0.05;
}
}
chopper_boss_can_hit_from( chopper_origin_test, target_origin )
{
assertex( isdefined( chopper_origin_test ), "Shot origin not specified." );
assertex( isdefined( target_origin ), "Target origin not specified." );
offset_turret_z = self.mgturret[ 0 ].origin[ 2 ] - self.origin[ 2 ];
return BulletTracePassed( chopper_origin_test + (0, 0, offset_turret_z), target_origin, false, self );
}
chopper_boss_in_range( target_origin )
{
assertex( isdefined( self ), "Chopper not specified." );
assertex( isdefined( target_origin ), "Target origin not specified." );
target_dist = distance2d( self.origin, target_origin );
min_dist2D = CONST_CHOPPER_BOSS_MIN_TARGET_DIST_2D;
if ( IsDefined( level.chopper_boss_min_dist2D ) )
{
min_dist2D = level.chopper_boss_min_dist2D;
}
return	target_dist >= min_dist2D && target_dist <= CONST_CHOPPER_BOSS_MAX_TARGET_DIST_2D;
}
chopper_boss_set_target( target )
{
if ( isdefined( target ) )
{
self.heli_target = target;
}
}
chopper_boss_attempt_firing( target )
{
assertex( isdefined( self ), "Chopper not defined." );
assertex( isdefined( target ), "Target not defined." );
self endon( "deathspin" );
self endon( "death" );
shot_target = false;
if ( isdefined( target ) && !IsDefined( target.heli_shooting ) && self chopper_boss_in_range( target.origin ) )
{
self thread chopper_boss_manage_shooting_flag( self.heli_target );
self setlookatent( target );
is_facing = self chopper_boss_wait_face_target( target, 5.0 );
if ( isdefined( target ) )
{
if ( isdefined( is_facing ) && is_facing )
{
self chopper_boss_fire_turrets( target );
shot_target = true;
}
}
self notify( "chopper_done_shooting" );
}
return shot_target;
}
chopper_boss_manage_shooting_flag( target )
{
assert( isdefined( self ) );
assert( isdefined( target ) );
assertex( !isdefined( target.heli_shooting ), "Target already had helicopter shooting flag." );
target.heli_shooting = true;
self waittill_any( "death", "deathspin", "chopper_done_shooting" );
if ( isdefined( target ) )
{
assertex( isdefined( target.heli_shooting ), "Something else cleared the target helicopter shooting flag." );
target.heli_shooting = undefined;
}
}
chopper_boss_wait_face_target( target, timeout )
{
assertex( isdefined( target ), "Invalid target" );
self endon( "death" );
self endon( "deathspin" );
target endon( "death" );
end_time = undefined;
if ( isdefined( timeout ) )
end_time = gettime() + timeout * 1000;
while( isdefined( target ) )
{
if ( within_fov_2d( self.origin, self.angles, target.origin, 0.0 ) )
return true;
if ( isdefined( end_time ) && gettime() >= end_time )
return false;
wait 0.25;
}
}
chopper_boss_fire_turrets( target )
{
assertex( isdefined( target ), "Helicopter told to shoot at invalid target" );
self endon( "deathspin" );
self endon( "death" );
target endon( "death" );
shot_count = CONST_CHOPPER_BOSS_SHOT_COUNT;
foreach( turret in self.mgturret )
{
if ( isAI( target ) )
{
turret settargetentity( target, target geteye() - target.origin );
}
else if ( isplayer( target ) )
{
if ( is_player_down( target ) )
{
shot_count = CONST_CHOPPER_BOSS_SHOT_COUNT_LONG;
turret settargetentity( target );
}
else
{
turret settargetentity( target, target geteye() - target.origin );
}
}
else
{
turret settargetentity( target, ( 0, 0, 32 ) );
}
turret startbarrelspin();
}
wait CONST_CHOPPER_BOSS_WIND_UP_TIME;
fire_time = weaponfiretime( "minigun_littlebird_spinnup" );
assertex( isdefined( fire_time ) && fire_time > 0, "Fire time not valid." );
turret_index = 0;
for ( i = 0; i < shot_count; i++ )
{
self.mgturret[ turret_index ] shootturret();
turret_index++;
if ( turret_index >= self.mgturret.size )
turret_index = 0;
wait fire_time + 0.05;
}
wait 1.0;
foreach( turret in self.mgturret )
{
turret stopbarrelspin();
}
}
chopper_boss_manage_targeting_flag()
{
AssertEx( !IsDefined( level.chopper_boss_finding_target ) || level.chopper_boss_finding_target == false, "Chopper currently targeting flag was already set to true." );
level.chopper_boss_finding_target = true;
self waittill_any( "death", "deathspin", "chopper_done_targeting" );
level.chopper_boss_finding_target = undefined;
}
chopper_boss_get_best_location_and_target( ignore_current_loc )
{
assertex( isdefined( self ) && isdefined( self.loc_current ), "Chopper undefined or has no current loc reference." );
assertex( isdefined( self.loc_current.neighbors ) && self.loc_current.neighbors.size, "Chopper current location has no neighbors." );
self endon( "death" );
optional_locs = self.loc_current.neighbors;
if ( !isdefined( ignore_current_loc ) || ignore_current_loc == false )
optional_locs[ optional_locs.size ] = self.loc_current;
self thread chopper_boss_manage_targeting_flag();
targets = [];
foreach( player in level.players )
{
if (
!is_player_down( player )
&&	( !IsDefined( player.ignoreme ) || player.ignoreme == false )
)
{
targets[ targets.size ] = player;
}
}
allies = getaiarray( "allies" );
foreach ( ally in allies )
{
if ( !IsDefined( ally.ignoreme ) || ally.ignoreme == false )
{
targets[ targets.size ] = ally;
}
}
if ( isdefined( level.placed_sentry ) )
{
foreach( sentry in level.placed_sentry )
{
if ( !IsDefined( sentry.ignoreme ) || sentry.ignoreme == false )
{
targets[ targets.size ] = sentry;
}
}
}
if ( !targets.size )
{
foreach( player in level.players )
{
if	(
!is_player_down_and_out( player )
&&	( !IsDefined( player.ignoreme ) || player.ignoreme == false )
)
{
targets[ targets.size ] = player;
}
}
}
valid_locs = [];
traces = 0;
foreach( loc in optional_locs )
{
if ( loc != self.loc_current && isdefined( loc.in_use ) )
continue;
loc.heli_target = undefined;
loc.dist2D = undefined;
dist_target = undefined;
foreach( target in targets )
{
if ( !IsDefined( target ) )
continue;
if ( loc chopper_boss_in_range( target.origin ) == false )
continue;
trace_loc = target.origin + ( 0, 0, 64 );
if ( isAI( target ) || isPlayer( target ) )
trace_loc = target geteye();
if ( self chopper_boss_can_hit_from( loc.origin, trace_loc ) )
{
if ( !isdefined( loc.heli_target ) )
{
valid_locs[ valid_locs.size ] = loc;
loc.heli_target = target;
dist_target = distance2d( loc.origin, target.origin );
}
else
{
dist_test = distance2d( loc.origin, target.origin );
if ( dist_test < dist_target )
{
loc.heli_target = target;
dist_target = dist_test;
}
}
}
traces++;
if ( traces >= 4 )
{
wait 0.05;
traces = 0;
}
}
}
if ( valid_locs.size )
{
valid_locs_cleaned = [];
foreach ( loc in valid_locs )
{
if ( IsDefined( loc.heli_target ) )
valid_locs_cleaned[ valid_locs_cleaned.size ] = loc;
}
valid_locs = valid_locs_cleaned;
}
if ( !valid_locs.size )
{
foreach( loc in optional_locs )
{
if ( loc != self.loc_current && isdefined( loc.in_use ) )
continue;
closest_target = undefined;
foreach( target in targets )
{
if ( !IsDefined( target ) )
continue;
if ( !isdefined( closest_target ) )
{
closest_target = target;
loc.dist2D = distance2d( loc.origin, target.origin );
}
else
{
dist = distance2d( loc.origin, target.origin );
if ( dist < loc.dist2D )
{
closest_target = target;
loc.dist2D = dist;
}
}
}
if ( isdefined( loc.dist2D ) )
valid_locs[ valid_locs.size ] = loc;
}
}
else
{
foreach( loc in valid_locs )
loc.dist2D = distance2d( loc.heli_target.origin, loc.origin );
}
sorted_locs = maps\_utility_joec::exchange_sort_by_handler( valid_locs, ::chopper_boss_loc_compare );
next_loc = undefined;
next_loc_outside_min = false;
foreach( loc in sorted_locs )
{
min_dist2D = CONST_CHOPPER_BOSS_MIN_TARGET_DIST_2D;
if ( IsDefined( level.chopper_boss_min_dist2D ) )
{
min_dist2D = level.chopper_boss_min_dist2D;
}
if ( loc.dist2D >= min_dist2D && loc.dist2D <= CONST_CHOPPER_BOSS_MAX_TARGET_DIST_2D )
{
next_loc = loc;
next_loc_outside_min = true;
break;
}
}
if ( !isdefined( next_loc ) && sorted_locs.size )
{
next_loc = sorted_locs[ 0 ];
}
if ( isdefined( next_loc ) && isdefined( next_loc.heli_target ) )
self chopper_boss_set_target( next_loc.heli_target );
self notify( "chopper_done_targeting" );
if ( isdefined( next_loc ) && next_loc != self.loc_current )
return next_loc;
else
return undefined;
}
chopper_boss_loc_compare()
{
assert( isdefined( self ) && isdefined( self.dist2D ), "Need dist2D property defined." );
return self.dist2D;
}
chopper_boss_move( target_struct )
{
assertex( !isdefined( target_struct.in_use ), "helicopter told to use path that is in use." );
self.loc_current.in_use = undefined;
self.loc_current = target_struct;
self.loc_current.in_use = true;
self thread maps\_vehicle::vehicle_paths( target_struct );
}
chopper_boss_sentient()
{
self makeentitysentient( "axis", true );
self.attackeraccuracy = 6;
self.maxvisibledist = 3072;
self.threatbias = 10000;
}