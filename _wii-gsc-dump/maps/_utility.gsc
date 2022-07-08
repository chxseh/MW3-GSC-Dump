#include common_scripts\utility;
#include animscripts\utility;
#include maps\_utility_code;
is_coop()
{
if ( IsSplitScreen() || ( GetDvar( "coop" ) == "1" ) )
{
AssertEx( IsDefined( level.player2 ), "In co-op mode but level.player2 is undefined. IsSplitScreen=" + IsSplitScreen() + " coop dvar=" + GetDvar( "coop" ) );
return true;
}
return false;
}
is_coop_online()
{
if ( issplitscreen() )
return false;
if ( !is_coop() )
return false;
return true;
}
is_player_down( player )
{
AssertEx( IsDefined( player ) && IsPlayer( player ), "is_player_down() requires a valid player to test." );
if ( player ent_flag_exist( "laststand_downed" ) )
return player ent_flag( "laststand_downed" );
if ( IsDefined( player.laststand ) )
return player.laststand;
return !IsAlive( player );
}
is_player_down_and_out( player )
{
assertex( isdefined( player ) && isplayer( player ), "is_player_down_and_out() requires a valid player to test." );
if ( !isdefined( player.down_part2_proc_ran ) )
return false;
return player.down_part2_proc_ran;
}
killing_will_down( player )
{
AssertEx( IsDefined( player ) && IsPlayer( player ), "Invalid player." );
if ( laststand_enabled() )
{
assertex( isdefined( level.laststand_initialized ), "Laststand not initialized yet." );
return player maps\_laststand::laststand_downing_will_fail() == false;
}
return false;
}
clear_custom_eog_summary()
{
for( p = 1; p <= 2; p++ )
{
for ( j = 1; j <= 4; j++ )
{
for ( i = 1; i <= 9; i++ )
{
SetDvar( "ui_eog_r" + i + "c"+ j + "_player" + p, "" );
SetDvar( "ui_eog_r" + i + "c"+ j + "_player" + p, "" );
}
}
SetDvar( "ui_eog_success_heading_player" + p, "" );
}
}
set_custom_eog_summary( row, col, data )
{
AssertEx( IsDefined( self ) && IsPlayer( self ), "set_custom_eog_summary() Must be called on a Player entity!" );
r = Int( row );
c = Int( col );
AssertEx( r >= 1 && r <= 9, "Row: " + r + " is out of bound, row = 1->9." );
AssertEx( c >= 1 && c <= 4, "Column: " + c + " is out of bound, column = 1->4." );
eog_dvar = "";
if ( level.players.size > 1 )
{
if ( self == level.player )
eog_dvar = "ui_eog_r" + r + "c" + c + "_player1";
else if ( self == level.player2 )
eog_dvar = "ui_eog_r" + r + "c" + c + "_player2";
else
AssertEx( true, "set_custom_eog_summary() Must be called on a Player entity!" );
}
else
{
eog_dvar = "ui_eog_r" + r + "c" + c + "_player1";
}
SetDvar( eog_dvar, data );
}
add_custom_eog_summary_line( eog_title, eog_value1, eog_value2, eog_value3, eog_line_override )
{
assertex( isdefined( eog_title ), "so_add_eog_summary_line() requires a valid eog_title." );
assertex( isdefined( self ) && isplayer( self ), "so_add_eog_summary_line() must be called on a player." );
if ( !isdefined( self.eog_line ) )
self.eog_line = 0;
eog_line = undefined;
if ( isdefined( eog_line_override ) )
{
eog_line = eog_line_override;
if ( eog_line_override > self.eog_line )
self.eog_line = eog_line_override;
}
else
{
self.eog_line++;
eog_line = self.eog_line;
}
self set_custom_eog_summary( eog_line, 1, eog_title );
value_array = [];
if ( isdefined( eog_value3 ) )
value_array[ value_array.size ] = eog_value3;
if ( isdefined( eog_value2 ) )
value_array[ value_array.size ] = eog_value2;
if ( isdefined( eog_value1 ) )
value_array[ value_array.size ] = eog_value1;
for ( i = 0; i < value_array.size; i ++ )
self set_custom_eog_summary( eog_line, 4 - i, value_array[ i ] );
}
add_custom_eog_summary_line_blank()
{
if ( !isdefined( self.eog_line ) )
self.eog_line = 0;
self.eog_line++;
}
set_eog_success_heading( title )
{
AssertEx( IsDefined( self ) && IsPlayer( self ), "set_custom_eog_summary() Must be called on a Player entity!" );
eog_dvar = "";
if ( level.players.size > 1 )
{
if ( self == level.player )
eog_dvar = "ui_eog_success_heading_player1";
else if ( self == level.player2 )
eog_dvar = "ui_eog_success_heading_player2";
else
AssertEx( true, "set_eog_success_heading() Must be called on a Player entity!" );
}
else
{
eog_dvar = "ui_eog_success_heading_player1";
}
SetDvar( eog_dvar, title );
}
is_survival()
{
return ( is_specialop() && ( GetDvarInt( "so_survival" ) > 0 ) );
}
laststand_enabled()
{
return IsDefined( level.laststand_type ) && level.laststand_type > 0;
}
is_specialop()
{
return GetDvarInt( "specialops" ) >= 1;
}
convert_to_time_string( timer, show_tenths )
{
string = "";
if ( timer < 0 )
string += "-";
timer = round_float( timer, 1, false );
timer_clipped = timer * 100;
timer_clipped = int( timer_clipped );
timer_clipped = abs( timer_clipped );
minutes = timer_clipped / 6000;
minutes = int( minutes );
string += minutes;
seconds = timer_clipped / 100;
seconds = int( seconds );
seconds -= minutes * 60;
if ( seconds < 10 )
string += ":0" + seconds;
else
string += ":" + seconds;
if ( IsDefined( show_tenths ) && show_tenths )
{
tenths = timer_clipped;
tenths -= minutes * 6000;
tenths -= seconds * 100;
tenths = int( tenths/10 );
string += "." + tenths;
}
return string;
}
round_float( value, precision, down )
{
AssertEx( IsDefined( value ), "value must be defined." );
AssertEx( IsDefined( precision ), "precision must be defined." );
AssertEx( precision == int( precision ), "precision must be an integer." );
precision = int( precision );
if ( precision < 0 || precision > 4 )
{
AssertMsg( "Precision value must be an integer that is >= 0 and <= 4. This was passed in: " + precision );
return value;
}
decimal_offset = 1;
for ( i = 1; i <= precision; i++ )
{
decimal_offset *= 10;
}
value_clipped = value * decimal_offset;
if ( !IsDefined( down ) || down )
{
value_clipped = floor( value_clipped );
}
else
{
value_clipped = ceil( value_clipped );
}
value = value_clipped / decimal_offset;
return value;
}
round_millisec_on_sec( value, precision, down )
{
value_seconds = value / 1000;
value_seconds = round_float( value_seconds, precision, down );
value = value_seconds * 1000;
return int( value );
}
isdefined_test( value, test_value, test_style )
{
if ( !isdefined( value ) )
return false;
if ( !isdefined( test_value ) )
return true;
if ( !isdefined( test_style ) )
test_style = "==";
switch ( test_style )
{
case "==":	return ( value == test_value );
case "<":	return ( value < test_value );
case ">":	return ( value > test_value );
case "<=":	return ( value <= test_value );
case ">=":	return ( value >= test_value );
}
return true;
}
set_vision_set( visionset, transition_time )
{
if ( init_vision_set( visionset ) )
return;
if ( !isdefined( transition_time ) )
transition_time = 1;
VisionSetNaked( visionset, transition_time );
SetDvar( "vision_set_current", visionset );
}
set_vision_set_player( visionset, transition_time )
{
if ( init_vision_set( visionset ) )
return;
Assert( IsDefined( self ) );
Assert( level != self );
if ( !isdefined( transition_time ) )
transition_time = 1;
self VisionSetNakedForPlayer( visionset, transition_time );
}
set_nvg_vision( visionset, transition_time )
{
if ( !isdefined( transition_time ) )
transition_time = 1;
VisionSetNight( visionset, transition_time );
}
sun_light_fade( startSunColor, endSunColor, fTime )
{
fTime = Int( fTime * 20 );
increment = [];
for ( i = 0; i < 3; i++ )
increment[ i ] = ( startSunColor[ i ] - endSunColor[ i ] ) / fTime;
newSunColor = [];
for ( i = 0; i < fTime; i++ )
{
wait( 0.05 );
for ( j = 0; j < 3; j++ )
newSunColor[ j ] = startSunColor[ j ] - ( increment[ j ] * i );
SetSunLight( newSunColor[ 0 ], newSunColor[ 1 ], newSunColor[ 2 ] );
}
SetSunLight( endSunColor[ 0 ], endSunColor[ 1 ], endSunColor[ 2 ] );
}
ent_flag_wait( msg )
{
AssertEx( ( !IsSentient( self ) && IsDefined( self ) ) || IsAlive( self ), "Attempt to check a flag on entity that is not alive or removed" );
while ( IsDefined( self ) && !self.ent_flag[ msg ] )
self waittill( msg );
}
ent_flag_wait_vehicle_node( msg )
{
AssertEx( IsDefined( self ) , "Attempt to check a flag on node that is is not defined" );
while ( IsDefined( self ) && !self.ent_flag[ msg ] )
self waittill( msg );
}
ent_flag_wait_either( flag1, flag2 )
{
AssertEx( ( !IsSentient( self ) && IsDefined( self ) ) || IsAlive( self ), "Attempt to check a flag on entity that is not alive or removed" );
while ( IsDefined( self ) )
{
if ( ent_flag( flag1 ) )
return;
if ( ent_flag( flag2 ) )
return;
self waittill_either( flag1, flag2 );
}
}
ent_flag_wait_or_timeout( flagname, timer )
{
AssertEx( ( !IsSentient( self ) && IsDefined( self ) ) || IsAlive( self ), "Attempt to check a flag on entity that is not alive or removed" );
start_time = GetTime();
while ( IsDefined( self ) )
{
if ( self.ent_flag[ flagname ] )
break;
if ( GetTime() >= start_time + timer * 1000 )
break;
self ent_wait_for_flag_or_time_elapses( flagname, timer );
}
}
ent_flag_waitopen( msg )
{
AssertEx( ( !IsSentient( self ) && IsDefined( self ) ) || IsAlive( self ), "Attempt to check a flag on entity that is not alive or removed" );
while ( IsDefined( self ) && self.ent_flag[ msg ] )
self waittill( msg );
}
ent_flag_assert( msg )
{
AssertEx( !self ent_flag( msg ), "Flag " + msg + " set too soon on entity" );
}
ent_flag_waitopen_either( flag1, flag2 )
{
AssertEx( ( !IsSentient( self ) && IsDefined( self ) ) || IsAlive( self ), "Attempt to check a flag on entity that is not alive or removed" );
while ( IsDefined( self ) )
{
if ( !ent_flag( flag1 ) )
return;
if ( !ent_flag( flag2 ) )
return;
self waittill_either( flag1, flag2 );
}
}
ent_flag_init( message )
{
if ( !isDefined( self.ent_flag ) )
{
self.ent_flag = [];
self.ent_flags_lock = [];
}
self.ent_flag[ message ] = false;
}
ent_flag_exist( message )
{
if ( IsDefined( self.ent_flag ) && IsDefined( self.ent_flag[ message ] ) )
return true;
return false;
}
ent_flag_set_delayed( message, delay )
{
self endon( "death" );
wait( delay );
self ent_flag_set( message );
}
ent_flag_set( message )
{
self.ent_flag[ message ] = true;
self notify( message );
}
ent_flag_clear( message )
{
if ( self.ent_flag[ message ] )
{
self.ent_flag[ message ] = false;
self notify( message );
}
}
ent_flag_clear_delayed( message, delay )
{
wait( delay );
self ent_flag_clear( message );
}
ent_flag( message )
{
AssertEx( IsDefined( message ), "Tried to check flag but the flag was not defined." );
AssertEx( IsDefined( self.ent_flag[ message ] ), "Tried to check flag " + message + " but the flag was not initialized." );
return self.ent_flag[ message ];
}
get_closest_to_player_view( array, player, use_eye, min_dot )
{
if ( !array.size )
return;
if ( !isdefined( player ) )
player = level.player;
if ( !isdefined( min_dot ) )
min_dot = -1;
player_origin = player.origin;
if ( IsDefined( use_eye ) && use_eye )
player_origin = player GetEye();
ent = undefined;
player_angles = player GetPlayerAngles();
player_forward = AnglesToForward( player_angles );
dot = -1;
foreach ( array_item in array )
{
angles = VectorToAngles( array_item.origin - player_origin );
forward = AnglesToForward( angles );
newdot = VectorDot( player_forward, forward );
if ( newdot < dot )
continue;
if ( newdot < min_dot )
continue;
dot = newdot;
ent = array_item;
}
return ent;
}
get_closest_index_to_player_view( array, player, use_eye )
{
if ( !array.size )
return;
if ( !isdefined( player ) )
player = level.player;
player_origin = player.origin;
if ( IsDefined( use_eye ) && use_eye )
player_origin = player GetEye();
index = undefined;
player_angles = player GetPlayerAngles();
player_forward = AnglesToForward( player_angles );
dot = -1;
for ( i = 0; i < array.size; i++ )
{
angles = VectorToAngles( array[ i ].origin - player_origin );
forward = AnglesToForward( angles );
newdot = VectorDot( player_forward, forward );
if ( newdot < dot )
continue;
dot = newdot;
index = i;
}
return index;
}
flag_trigger_init( message, trigger, continuous )
{
flag_init( message );
if ( !isDefined( continuous ) )
continuous = false;
Assert( IsSubStr( trigger.classname, "trigger" ) );
trigger thread _flag_wait_trigger( message, continuous );
return trigger;
}
flag_triggers_init( message, triggers, all )
{
flag_init( message );
if ( !isDefined( all ) )
all = false;
for ( index = 0; index < triggers.size; index++ )
{
Assert( IsSubStr( triggers[ index ].classname, "trigger" ) );
triggers[ index ] thread _flag_wait_trigger( message, false );
}
return triggers;
}
flag_set_delayed( message, delay )
{
wait( delay );
flag_set( message );
}
flag_clear_delayed( message, delay )
{
wait( delay );
flag_clear( message );
}
_flag_wait_trigger( message, continuous )
{
self endon( "death" );
for ( ;; )
{
self waittill( "trigger", other );
flag_set( message );
if ( !continuous )
return;
while ( other IsTouching( self ) )
wait( 0.05 );
flag_clear( message );
}
}
level_end_save()
{
if ( arcadeMode() )
return;
if ( level.MissionFailed )
return;
if ( flag( "game_saving" ) )
return;
for ( i = 0; i < level.players.size; i++ )
{
player = level.players[ i ];
if ( !isAlive( player ) )
return;
}
flag_set( "game_saving" );
imagename = "levelshots / autosave / autosave_" + level.script + "end";
SaveGame( "levelend", &"AUTOSAVE_AUTOSAVE", imagename, true );
flag_clear( "game_saving" );
}
add_extra_autosave_check( name, func, msg )
{
level._extra_autosave_checks[ name ] = [];
level._extra_autosave_checks[ name ][ "func" ] = func;
level._extra_autosave_checks[ name ][ "msg" ] = msg;
}
remove_extra_autosave_check( name )
{
level._extra_autosave_checks[ name ] = undefined;
}
autosave_stealth()
{
thread autosave_by_name_thread( "autosave_stealth", 8, true );
}
autosave_tactical()
{
autosave_tactical_setup();
thread autosave_tactical_proc();
}
autosave_by_name( name )
{
thread autosave_by_name_thread( name );
}
autosave_by_name_silent( name )
{
thread autosave_by_name_thread( name, undefined, undefined, true );
}
autosave_by_name_thread( name, timeout, doStealthChecks, suppress_hint )
{
if ( !isDefined( level.curAutoSave ) )
level.curAutoSave = 1;
imageName = "levelshots/autosave/autosave_" + level.script + level.curAutoSave;
result = level maps\_autosave::tryAutoSave( level.curAutoSave, "autosave", imagename, timeout, doStealthChecks, suppress_hint );
if ( IsDefined( result ) && result )
level.curAutoSave++;
}
autosave_or_timeout( name, timeout )
{
thread autosave_by_name_thread( name, timeout );
}
debug_message( message, origin, duration, entity )
{
if ( !isDefined( duration ) )
duration = 5;
if ( IsDefined( entity ) )
{
entity endon( "death" );
origin = entity.origin;
}
for ( time = 0; time < ( duration * 20 ); time++ )
{
if ( !isdefined( entity ) )
Print3d( ( origin + ( 0, 0, 45 ) ), message, ( 0.48, 9.4, 0.76 ), 0.85 );
else
Print3d( entity.origin, message, ( 0.48, 9.4, 0.76 ), 0.85 );
wait 0.05;
}
}
debug_message_ai( message, duration )
{
self notify( "debug_message_ai" );
self endon( "debug_message_ai" );
self endon( "death" );
if ( !isDefined( duration ) )
duration = 5;
for ( time = 0; time < ( duration * 20 ); time++ )
{
Print3d( ( self.origin + ( 0, 0, 45 ) ), message, ( 0.48, 9.4, 0.76 ), 0.85 );
wait 0.05;
}
}
debug_message_clear( message, origin, duration, extraEndon )
{
if ( IsDefined( extraEndon ) )
{
level notify( message + extraEndon );
level endon( message + extraEndon );
}
else
{
level notify( message );
level endon( message );
}
if ( !isDefined( duration ) )
duration = 5;
for ( time = 0; time < ( duration * 20 ); time++ )
{
Print3d( ( origin + ( 0, 0, 45 ) ), message, ( 0.48, 9.4, 0.76 ), 0.85 );
wait 0.05;
}
}
chain_off( chain )
{
trigs = GetEntArray( "trigger_friendlychain", "classname" );
for ( i = 0; i < trigs.size; i++ )
if ( ( IsDefined( trigs[ i ].script_chain ) ) && ( trigs[ i ].script_chain == chain ) )
{
if ( IsDefined( trigs[ i ].oldorigin ) )
trigs[ i ].origin = trigs[ i ].oldorigin;
else
trigs[ i ].oldorigin = trigs[ i ].origin;
trigs[ i ].origin = trigs[ i ].origin + ( 0, 0, -5000 );
}
}
chain_on( chain )
{
trigs = GetEntArray( "trigger_friendlychain", "classname" );
for ( i = 0; i < trigs.size; i++ )
if ( ( IsDefined( trigs[ i ].script_chain ) ) && ( trigs[ i ].script_chain == chain ) )
{
if ( IsDefined( trigs[ i ].oldorigin ) )
trigs[ i ].origin = trigs[ i ].oldorigin;
}
}
precache( model )
{
ent = Spawn( "script_model", ( 0, 0, 0 ) );
ent.origin = level.player GetOrigin();
ent SetModel( model );
ent Delete();
}
closerFunc( dist1, dist2 )
{
return dist1 >= dist2;
}
fartherFunc( dist1, dist2 )
{
return dist1 <= dist2;
}
getClosest( org, array, maxdist )
{
if ( !IsDefined( maxdist ) )
maxdist = 500000;
ent = undefined;
foreach ( item in array )
{
newdist = Distance( item.origin, org );
if ( newdist >= maxdist )
continue;
maxdist = newdist;
ent = item;
}
return ent;
}
getFarthest( org, array, maxdist )
{
if ( !IsDefined( maxdist ) )
maxdist = 500000;
dist = 0;
ent = undefined;
foreach ( item in array )
{
newdist = Distance( item.origin, org );
if ( newdist <= dist || newdist >= maxdist )
continue;
dist = newdist;
ent = item;
}
return ent;
}
getClosestFx( org, fxarray, dist )
{
return compareSizesFx( org, fxarray, dist, ::closerFunc );
}
get_closest_point( origin, points, maxDist )
{
Assert( points.size );
closestPoint = points[ 0 ];
dist = Distance( origin, closestPoint );
for ( index = 0; index < points.size; index++ )
{
testDist = Distance( origin, points[ index ] );
if ( testDist >= dist )
continue;
dist = testDist;
closestPoint = points[ index ];
}
if ( !isDefined( maxDist ) || dist <= maxDist )
return closestPoint;
return undefined;
}
get_farthest_ent( org, array )
{
if ( array.size < 1 )
return;
dist = Distance( array[ 0 ] GetOrigin(), org );
ent = array[ 0 ];
for ( i = 0; i < array.size; i++ )
{
newdist = Distance( array[ i ] GetOrigin(), org );
if ( newdist < dist )
continue;
dist = newdist;
ent = array[ i ];
}
return ent;
}
get_within_range( org, array, dist )
{
guys = [];
for ( i = 0; i < array.size; i++ )
{
if ( Distance( array[ i ].origin, org ) <= dist )
guys[ guys.size ] = array[ i ];
}
return guys;
}
get_outside_range( org, array, dist )
{
guys = [];
for ( i = 0; i < array.size; i++ )
{
if ( Distance( array[ i ].origin, org ) > dist )
guys[ guys.size ] = array[ i ];
}
return guys;
}
get_closest_living( org, array, dist )
{
if ( !isdefined( dist ) )
dist = 9999999;
if ( array.size < 1 )
return;
ent = undefined;
for ( i = 0; i < array.size; i++ )
{
if ( !isalive( array[ i ] ) )
continue;
newdist = Distance( array[ i ].origin, org );
if ( newdist >= dist )
continue;
dist = newdist;
ent = array[ i ];
}
return ent;
}
get_highest_dot( start, end, array )
{
if ( !array.size )
return;
ent = undefined;
angles = VectorToAngles( end - start );
dotforward = AnglesToForward( angles );
dot = -1;
foreach ( member in array )
{
angles = VectorToAngles( member.origin - start );
forward = AnglesToForward( angles );
newdot = VectorDot( dotforward, forward );
if ( newdot < dot )
continue;
dot = newdot;
ent = member;
}
return ent;
}
get_closest_index( org, array, dist )
{
if ( !isdefined( dist ) )
dist = 9999999;
if ( array.size < 1 )
return;
index = undefined;
foreach ( i, ent in array )
{
newdist = Distance( ent.origin, org );
if ( newdist >= dist )
continue;
dist = newdist;
index = i;
}
return index;
}
get_closest_exclude( org, ents, excluders )
{
if ( !isdefined( ents ) )
return undefined;
range = 0;
if ( IsDefined( excluders ) && excluders.size )
{
exclude = [];
for ( i = 0; i < ents.size; i++ )
exclude[ i ] = false;
for ( i = 0; i < ents.size; i++ )
for ( p = 0; p < excluders.size; p++ )
if ( ents[ i ] == excluders[ p ] )
exclude[ i ] = true;
found_unexcluded = false;
for ( i = 0; i < ents.size; i++ )
if ( ( !exclude[ i ] ) && ( IsDefined( ents[ i ] ) ) )
{
found_unexcluded = true;
range = Distance( org, ents[ i ].origin );
ent = i;
i = ents.size + 1;
}
if ( !found_unexcluded )
return( undefined );
}
else
{
for ( i = 0; i < ents.size; i++ )
if ( IsDefined( ents[ i ] ) )
{
range = Distance( org, ents[ 0 ].origin );
ent = i;
i = ents.size + 1;
}
}
ent = undefined;
for ( i = 0; i < ents.size; i++ )
if ( IsDefined( ents[ i ] ) )
{
exclude = false;
if ( IsDefined( excluders ) )
{
for ( p = 0; p < excluders.size; p++ )
if ( ents[ i ] == excluders[ p ] )
exclude = true;
}
if ( !exclude )
{
newrange = Distance( org, ents[ i ].origin );
if ( newrange <= range )
{
range = newrange;
ent = i;
}
}
}
if ( IsDefined( ent ) )
return ents[ ent ];
else
return undefined;
}
get_closest_player( org )
{
if ( level.players.size == 1 )
return level.player;
player = getClosest( org, level.players );
return player;
}
get_closest_player_healthy( org )
{
if ( level.players.size == 1 )
return level.player;
healthyPlayers = get_players_healthy();
player = getClosest( org, healthyPlayers );
return player;
}
get_players_healthy()
{
healthy_players = [];
foreach ( player in level.players )
{
if ( is_player_down( player ) )
continue;
healthy_players[ healthy_players.size ] = player;
}
return healthy_players;
}
get_closest_ai( org, team, excluders )
{
if ( IsDefined( team ) )
ents = GetAIArray( team );
else
ents = GetAIArray();
if ( ents.size == 0 )
return undefined;
if ( IsDefined( excluders ) )
{
Assert( excluders.size > 0 );
ents = array_remove_array( ents, excluders );
}
return getClosest( org, ents );
}
get_array_of_farthest( org, array, excluders, max, maxdist, mindist )
{
aArray = get_array_of_closest( org, array, excluders, max, maxdist, mindist );
aArray = array_reverse( aArray );
return aArray;
}
get_array_of_closest( org, array, excluders, max, maxdist, mindist )
{
if ( !isdefined( max ) )
max = array.size;
if ( !isdefined( excluders ) )
excluders = [];
maxdist2rd = undefined;
if ( IsDefined( maxdist ) )
maxdist2rd = maxdist * maxdist;
mindist2rd = 0;
if ( IsDefined( mindist ) )
mindist2rd = mindist * mindist;
if ( excluders.size == 0 && max >= array.size && mindist2rd == 0 && !isdefined( maxdist2rd ) )
return SortByDistance( array, org );
newArray = [];
foreach ( ent in array )
{
excluded = false;
foreach ( excluder in excluders )
{
if ( ent == excluder )
{
excluded = true;
break;
}
}
if ( excluded )
continue;
dist2rd = DistanceSquared( org, ent.origin );
if ( IsDefined( maxdist2rd ) && dist2rd > maxdist2rd )
continue;
if ( dist2rd < mindist2rd )
continue;
newArray[ newArray.size ] = ent;
}
newArray = SortByDistance( newArray, org );
if ( max >= newArray.size )
return newArray;
finalArray = [];
for ( i = 0; i < max; i++ )
finalArray[ i ] = newArray[ i ];
return finalArray;
}
get_closest_ai_exclude( org, team, excluders )
{
if ( IsDefined( team ) )
ents = GetAIArray( team );
else
ents = GetAIArray();
if ( ents.size == 0 )
return undefined;
return get_closest_exclude( org, ents, excluders );
}
get_progress( start, end, org, dist_)
{
assert(IsDefined(start));
assert(IsDefined(end));
assert(Isdefined(org));
dist = dist_;
if (!IsDefined(dist))
dist = Distance( start, end );
dist = max(0.01, dist);
normal = vectorNormalize( end - start );
vec = org - start;
progress = vectorDot( vec, normal );
progress = progress / dist;
progress = clamp(progress, 0, 1);
return progress;
}
can_see_origin( origin, test_characters )
{
AssertEx( IsDefined( origin ), "can_see_origin() requires a valid origin to be passed in." );
AssertEx( IsPlayer( self ) || IsAI( self ), "can_see_origin() can only be called on a player or AI." );
if ( !isdefined( test_characters ) )
test_characters = true;
if ( !self point_in_fov( origin ) )
{
return false;
}
if ( !SightTracePassed( self GetEye(), origin, test_characters, self ) )
{
return false;
}
return true;
}
point_in_fov( origin )
{
forward = AnglesToForward( self.angles );
normalVec = VectorNormalize( origin - self.origin );
dot = VectorDot( forward, normalVec );
return dot > 0.766;
}
stop_magic_bullet_shield()
{
self notify( "stop_magic_bullet_shield" );
AssertEx( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield, "Tried to stop magic bullet shield on a guy without magic bulletshield" );
if ( IsAI( self ) )
self.attackeraccuracy = 1;
self.magic_bullet_shield = undefined;
self.damageShield = false;
self notify( "internal_stop_magic_bullet_shield" );
}
magic_bullet_death_detection()
{
}
magic_bullet_shield( no_death_detection )
{
if ( IsAI( self ) )
{
AssertEx( IsAlive( self ), "Tried to do magic_bullet_shield on a dead or undefined guy." );
AssertEx( !self.delayedDeath, "Tried to do magic_bullet_shield on a guy about to die." );
AssertEx( !isDefined( self.Melee ), "Trying to turn on magic_bullet_shield while melee in progress (might be about to die)." );
}
else
{
self.health = 100000;
}
self endon( "internal_stop_magic_bullet_shield" );
AssertEx( !isdefined( self.magic_bullet_shield ), "Can't call magic bullet shield on a character twice. Use make_hero and remove_heroes_from_array so that you don't end up with shielded guys in your logic." );
if ( IsAI( self ) )
self.attackeraccuracy = 0.1;
self.magic_bullet_shield = true;
self.damageShield = true;
}
disable_long_death()
{
AssertEx( IsAlive( self ), "Tried to disable long death on a non living thing" );
self.a.disableLongDeath = true;
}
enable_long_death()
{
AssertEx( IsAlive( self ), "Tried to enable long death on a non living thing" );
self.a.disableLongDeath = false;
}
enable_blood_pool()
{
self.skipBloodPool = undefined;
}
disable_blood_pool()
{
self.skipBloodPool = true;
}
deletable_magic_bullet_shield()
{
magic_bullet_shield( true );
}
get_ignoreme()
{
return self.ignoreme;
}
set_ignoreme( val )
{
AssertEx( IsSentient( self ), "Non ai tried to set ignoreme" );
self.ignoreme = val;
}
set_ignoreall( val )
{
AssertEx( IsSentient( self ), "Non ai tried to set ignoraell" );
self.ignoreall = val;
}
set_favoriteenemy( enemy )
{
self.favoriteenemy = enemy;
}
get_pacifist()
{
return self.pacifist;
}
set_pacifist( val )
{
AssertEx( IsSentient( self ), "Non ai tried to set pacifist" );
self.pacifist = val;
}
ignore_me_timer( time )
{
self notify( "new_ignore_me_timer" );
self endon( "new_ignore_me_timer" );
self endon( "death" );
if ( !isdefined( self.ignore_me_timer_prev_value ) )
self.ignore_me_timer_prev_value = self.ignoreme;
ai = GetAIArray( "bad_guys" );
foreach ( guy in ai )
{
if ( !isalive( guy.enemy ) )
continue;
if ( guy.enemy != self )
continue;
guy ClearEnemy();
}
self.ignoreme = true;
wait( time );
self.ignoreme = self.ignore_me_timer_prev_value;
self.ignore_me_timer_prev_value = undefined;
}
array_randomize( array )
{
for ( i = 0; i < array.size; i++ )
{
j = RandomInt( array.size );
temp = array[ i ];
array[ i ] = array[ j ];
array[ j ] = temp;
}
return array;
}
array_reverse( array )
{
array2 = [];
for ( i = array.size - 1; i >= 0; i-- )
array2[ array2.size ] = array[ i ];
return array2;
}
delete_exploder( num )
{
num += "";
if (isdefined(level.createFXexploders))
{
exploders = level.createFXexploders[num];
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if ( IsDefined( ent.model ) )
ent.model Delete();
}
}
}
else
{
for ( i = 0; i < level.createFXent.size; i++ )
{
ent = level.createFXent[ i ];
if ( !isdefined( ent ) )
continue;
if ( ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( ent.v[ "exploder" ] ) )
continue;
if ( ent.v[ "exploder" ] + "" != num )
continue;
if ( IsDefined( ent.model ) )
ent.model Delete();
}
}
level notify( "killexplodertridgers" + num );
}
hide_exploder_models( num )
{
num += "";
if (isdefined(level.createFXexploders))
{
exploders = level.createFXexploders[num];
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if ( IsDefined( ent.model ) )
ent.model Hide();
}
}
}
else
{
for ( i = 0; i < level.createFXent.size; i++ )
{
ent = level.createFXent[ i ];
if ( !isdefined( ent ) )
continue;
if ( ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( ent.v[ "exploder" ] ) )
continue;
if ( ent.v[ "exploder" ] + "" != num )
continue;
if ( IsDefined( ent.model ) )
ent.model Hide();
}
}
}
show_exploder_models( num )
{
num += "";
if (isdefined(level.createFXexploders))
{
exploders = level.createFXexploders[num];
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if ( ! exploder_model_starts_hidden( ent.model ) && ! exploder_model_is_damaged_model( ent.model ) && !exploder_model_is_chunk( ent.model ) )
{
ent.model Show();
}
if ( IsDefined( ent.brush_shown ) )
ent.model Show();
}
}
}
else
{
for ( i = 0; i < level.createFXent.size; i++ )
{
ent = level.createFXent[ i ];
if ( !isdefined( ent ) )
continue;
if ( ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( ent.v[ "exploder" ] ) )
continue;
if ( ent.v[ "exploder" ] + "" != num )
continue;
if ( IsDefined( ent.model ) )
{
if ( ! exploder_model_starts_hidden( ent.model ) && ! exploder_model_is_damaged_model( ent.model ) && !exploder_model_is_chunk( ent.model ) )
{
ent.model Show();
}
if ( IsDefined( ent.brush_shown ) )
ent.model Show();
}
}
}
}
exploder_model_is_damaged_model( ent )
{
return( IsDefined( ent.targetname ) ) && ( ent.targetname == "exploder" );
}
exploder_model_starts_hidden( ent )
{
return( ent.model == "fx" ) && ( ( !isdefined( ent.targetname ) ) || ( ent.targetname != "exploderchunk" ) );
}
exploder_model_is_chunk( ent )
{
return( IsDefined( ent.targetname ) ) && ( ent.targetname == "exploderchunk" );
}
get_exploder_array( msg )
{
msg += "";
array = [];
if (isdefined(level.createFXexploders))
{
exploders = level.createFXexploders[msg];
if (isdefined(exploders))
{
array = exploders;
}
}
else
{
foreach ( ent in level.createFXent )
{
if ( ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( ent.v[ "exploder" ] ) )
continue;
if ( ent.v[ "exploder" ] + "" != msg )
continue;
array[ array.size ] = ent;
}
}
return array;
}
flood_spawn( spawners )
{
maps\_spawner::flood_spawner_scripted( spawners );
}
set_ambient( track, fade_ )
{
maps\_audio_zone_manager::AZM_start_zone(track, fade_);
}
force_crawling_death( angle, num_crawls, array, nofallanim )
{
if ( !isdefined( num_crawls ) )
num_crawls = 4;
self thread force_crawling_death_proc( angle, num_crawls, array, nofallanim );
}
#using_animtree( "generic_human" );
override_crawl_death_anims()
{
if ( IsDefined( self.a.custom_crawling_death_array ) )
{
self.a.array[ "crawl" ] = self.a.custom_crawling_death_array[ "crawl" ];
self.a.array[ "death" ] = self.a.custom_crawling_death_array[ "death" ];
self.a.crawl_fx_rate = self.a.custom_crawling_death_array[ "blood_fx_rate" ];
if( isdefined( self.a.custom_crawling_death_array[ "blood_fx" ] ) )
self.a.crawl_fx = self.a.custom_crawling_death_array[ "blood_fx" ];
}
self.a.array[ "stand_2_crawl" ] = [];
self.a.array[ "stand_2_crawl" ][ 0 ] = %dying_stand_2_crawl_v3;
if ( IsDefined( self.nofallanim ) )
self.a.pose = "prone";
self OrientMode( "face angle", self.a.force_crawl_angle );
self.a.force_crawl_angle = undefined;
}
force_crawling_death_proc( angle, num_crawls, array, nofallanim )
{
self.forceLongDeath = true;
self.a.force_num_crawls = num_crawls;
self.noragdoll = true;
self.nofallanim = nofallanim;
self.a.custom_crawling_death_array = array;
self.crawlingPainAnimOverrideFunc = ::override_crawl_death_anims;
self.maxhealth = 100000;
self.health = 100000;
self enable_long_death();
if ( !isdefined( nofallanim ) || nofallanim == false )
self.a.force_crawl_angle = angle + 181.02;
else
{
self.a.force_crawl_angle = angle;
self thread animscripts\notetracks::noteTrackPoseCrawl();
}
}
get_friendly_chain_node( chainstring )
{
chain = undefined;
trigger = GetEntArray( "trigger_friendlychain", "classname" );
for ( i = 0; i < trigger.size; i++ )
{
if ( ( IsDefined( trigger[ i ].script_chain ) ) && ( trigger[ i ].script_chain == chainstring ) )
{
chain = trigger[ i ];
break;
}
}
if ( !isdefined( chain ) )
{
return undefined;
}
node = GetNode( chain.target, "targetname" );
return node;
}
shock_ondeath()
{
Assert( IsPlayer( self ) );
PreCacheShellShock( "default" );
self waittill( "death" );
if ( IsDefined( self.specialDeath ) )
return;
if ( GetDvar( "r_texturebits" ) == "16" )
return;
self ShellShock( "default", 3 );
}
delete_on_death_wait_sound( ent, sounddone )
{
ent endon( "death" );
self waittill( "death" );
if ( IsDefined( ent ) )
{
if ( ent IsWaitingOnSound() )
ent waittill( sounddone );
ent Delete();
}
}
is_dead_sentient()
{
return IsSentient( self ) && !isalive( self );
}
play_sound_on_tag( alias, tag, ends_on_death, op_notify_string, radio_dialog )
{
if ( is_dead_sentient() )
return;
org = Spawn( "script_origin", ( 0, 0, 0 ) );
org endon( "death" );
thread delete_on_death_wait_sound( org, "sounddone" );
if ( IsDefined( tag ) )
org LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
else
{
org.origin = self.origin;
org.angles = self.angles;
org LinkTo( self );
}
org PlaySound( alias, "sounddone" );
if ( IsDefined( ends_on_death ) )
{
AssertEx( ends_on_death, "ends_on_death must be true or undefined" );
if ( !isdefined( wait_for_sounddone_or_death( org ) ) )
org StopSounds();
wait( 0.05 );
}
else
{
if (isaudiodisabled())
{
org ent_wait_for_flag_or_time_elapses("sounddone", 2.0);
}
else
{
org waittill( "sounddone" );
}
}
if ( IsDefined( op_notify_string ) )
self notify( op_notify_string );
org Delete();
}
play_sound_on_tag_endon_death( alias, tag )
{
play_sound_on_tag( alias, tag, true );
}
play_sound_on_entity( alias, op_notify_string )
{
AssertEx( !isSpawner( self ), "Spawner tried to play a sound" );
play_sound_on_tag( alias, undefined, undefined, op_notify_string );
}
play_loop_sound_on_tag( alias, tag, bStopSoundOnDeath )
{
org = Spawn( "script_origin", ( 0, 0, 0 ) );
org endon( "death" );
if ( !isdefined( bStopSoundOnDeath ) )
bStopSoundOnDeath = true;
if ( bStopSoundOnDeath )
thread delete_on_death( org );
if ( IsDefined( tag ) )
org LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
else
{
org.origin = self.origin;
org.angles = self.angles;
org LinkTo( self );
}
org PlayLoopSound( alias );
self waittill( "stop sound" + alias );
org StopLoopSound( alias );
org Delete();
}
save_friendlies()
{
ai = GetAIArray( "allies" );
game_characters = 0;
for ( i = 0; i < ai.size; i++ )
{
if ( IsDefined( ai[ i ].script_friendname ) )
continue;
game[ "character" + game_characters ] = ai[ i ] codescripts\character::save();
game_characters++;
}
game[ "total characters" ] = game_characters;
}
spawn_failed( spawn )
{
if ( !isalive( spawn ) )
return true;
if ( !isdefined( spawn.finished_spawning ) )
spawn waittill_either( "finished spawning", "death" );
if ( IsAlive( spawn ) )
return false;
return true;
}
spawn_setcharacter( data )
{
codescripts\character::precache( data );
self waittill( "spawned", spawn );
if ( maps\_utility::spawn_failed( spawn ) )
return;
PrintLn( "Size is ", data[ "attach" ].size );
spawn codescripts\character::new();
spawn codescripts\character::load( data );
}
key_hint_print( message, binding )
{
IPrintLnBold( message, binding[ "key1" ] );
}
view_tag( tag )
{
self endon( "death" );
for ( ;; )
{
maps\_debug::drawTag( tag );
wait( 0.05 );
}
}
assign_animtree( animname )
{
if ( IsDefined( animname ) )
self.animname = animname;
AssertEx( IsDefined( level.scr_animtree[ self.animname ] ), "There is no level.scr_animtree for animname " + self.animname );
self UseAnimTree( level.scr_animtree[ self.animname ] );
}
assign_model()
{
AssertEx( IsDefined( level.scr_model[ self.animname ] ), "There is no level.scr_model for animname " + self.animname );
if ( IsArray( level.scr_model[ self.animname ] ) )
{
randIndex = RandomInt( level.scr_model[ self.animname ].size );
self SetModel( level.scr_model[ self.animname ][ randIndex ] );
}
else
self SetModel( level.scr_model[ self.animname ] );
}
spawn_anim_model( animname, origin )
{
if ( !isdefined( origin ) )
origin = ( 0, 0, 0 );
model = Spawn( "script_model", origin );
model.animname = animname;
model assign_animtree();
model assign_model();
return model;
}
trigger_wait( strName, strKey )
{
eTrigger = GetEnt( strName, strKey );
if ( !isdefined( eTrigger ) )
{
AssertMsg( "trigger not found: " + strName + " key: " + strKey );
return;
}
eTrigger waittill( "trigger", eOther );
level notify( strName, eOther );
return eOther;
}
trigger_wait_targetname( strName )
{
eTrigger = GetEnt( strName, "targetname" );
if ( !isdefined( eTrigger ) )
{
AssertMsg( "trigger not found: " + strName + " targetname " );
return;
}
eTrigger waittill( "trigger", eOther );
level notify( strName, eOther );
return eOther;
}
set_flag_on_dead( spawners, strFlag )
{
thread set_flag_on_func_wait_proc( spawners, strFlag, ::waittill_dead, "set_flag_on_dead" );
}
set_flag_on_dead_or_dying( spawners, strFlag )
{
thread set_flag_on_func_wait_proc( spawners, strFlag, ::waittill_dead_or_dying, "set_flag_on_dead_or_dying" );
}
set_flag_on_spawned( spawners, strFlag )
{
thread set_flag_on_func_wait_proc( spawners, strFlag, ::empty_func, "set_flag_on_spawned" );
}
empty_func( var )
{
return;
}
set_flag_on_spawned_ai_proc( system, internal_flag )
{
self waittill( "spawned", guy );
if ( maps\_utility::spawn_failed( guy ) )
return;
system.ai[ system.ai.size ] = guy;
self ent_flag_set( internal_flag );
}
set_flag_on_func_wait_proc( spawners, strFlag, waitfunc, internal_flag )
{
system = SpawnStruct();
system.ai = [];
AssertEx( spawners.size, "spawners is empty" );
foreach ( key, spawn in spawners )
spawn ent_flag_init( internal_flag );
array_thread( spawners, ::set_flag_on_spawned_ai_proc, system, internal_flag );
foreach ( key, spawn in spawners )
spawn ent_flag_wait( internal_flag );
[[ waitfunc ]]( system.ai );
flag_set( strFlag );
}
set_flag_on_trigger( eTrigger, strFlag )
{
if ( !flag( strFlag ) )
{
eTrigger waittill( "trigger", eOther );
flag_set( strFlag );
return eOther;
}
}
set_flag_on_targetname_trigger( msg )
{
Assert( IsDefined( level.flag[ msg ] ) );
if ( flag( msg ) )
return;
trigger = GetEnt( msg, "targetname" );
trigger waittill( "trigger" );
flag_set( msg );
}
is_in_array( aeCollection, eFindee )
{
for ( i = 0; i < aeCollection.size; i++ )
{
if ( aeCollection[ i ] == eFindee )
return( true );
}
return( false );
}
waittill_dead( guys, num, timeoutLength )
{
ent = SpawnStruct();
if ( IsDefined( timeoutLength ) )
{
ent endon( "thread_timed_out" );
ent thread waittill_dead_timeout( timeoutLength );
}
ent.count = guys.size;
if ( IsDefined( num ) && num < ent.count )
ent.count = num;
array_thread( guys, ::waittill_dead_thread, ent );
while ( ent.count > 0 )
ent waittill( "waittill_dead guy died" );
}
waittill_dead_or_dying( guys, num, timeoutLength )
{
newArray = [];
foreach ( member in guys )
{
if ( IsAlive( member ) && !member.ignoreForFixedNodeSafeCheck )
newArray[ newArray.size ] = member;
}
guys = newArray;
ent = SpawnStruct();
if ( IsDefined( timeoutLength ) )
{
ent endon( "thread_timed_out" );
ent thread waittill_dead_timeout( timeoutLength );
}
ent.count = guys.size;
if ( IsDefined( num ) && num < ent.count )
ent.count = num;
array_thread( guys, ::waittill_dead_or_dying_thread, ent );
while ( ent.count > 0 )
ent waittill( "waittill_dead_guy_dead_or_dying" );
}
waittill_dead_thread( ent )
{
self waittill( "death" );
ent.count--;
ent notify( "waittill_dead guy died" );
}
waittill_dead_or_dying_thread( ent )
{
self waittill_either( "death", "pain_death" );
ent.count--;
ent notify( "waittill_dead_guy_dead_or_dying" );
}
waittill_dead_timeout( timeoutLength )
{
wait( timeoutLength );
self notify( "thread_timed_out" );
}
waittill_aigroupcleared( aigroup )
{
while ( level._ai_group[ aigroup ].spawnercount || level._ai_group[ aigroup ].aicount )
wait( 0.25 );
}
waittill_aigroupcount( aigroup, count )
{
while ( level._ai_group[ aigroup ].spawnercount + level._ai_group[ aigroup ].aicount > count )
wait( 0.25 );
}
get_ai_group_count( aigroup )
{
return( level._ai_group[ aigroup ].spawnercount + level._ai_group[ aigroup ].aicount );
}
get_ai_group_sentient_count( aigroup )
{
return( level._ai_group[ aigroup ].aicount );
}
get_ai_group_ai( aigroup )
{
aiSet = [];
for ( index = 0; index < level._ai_group[ aigroup ].ai.size; index++ )
{
if ( !isAlive( level._ai_group[ aigroup ].ai[ index ] ) )
continue;
aiSet[ aiSet.size ] = level._ai_group[ aigroup ].ai[ index ];
}
return( aiSet );
}
waittill_notetrack_or_damage( notetrack )
{
self endon( "damage" );
self endon( "death" );
self waittillmatch( "single anim", notetrack );
}
get_living_ai( name, type )
{
array = get_living_ai_array( name, type );
if ( array.size > 1 )
{
AssertMsg( "get_living_ai used for more than one living ai of type " + type + " called " + name + "." );
return undefined;
}
return array[ 0 ];
}
get_living_ai_array( name, type )
{
ai = GetAISpeciesArray( "all", "all" );
array = [];
foreach ( actor in ai )
{
if ( !isalive( actor ) )
continue;
switch( type )
{
case "targetname":{
if ( IsDefined( actor.targetname ) && actor.targetname == name )
array[ array.size ] = actor;
}break;
case "script_noteworthy":{
if ( IsDefined( actor.script_noteworthy ) && actor.script_noteworthy == name )
array[ array.size ] = actor;
}break;
}
}
return array;
}
get_vehicle( name, type )
{
Assert( IsDefined( name ) );
Assert( IsDefined( type ) );
array = get_vehicle_array( name, type );
if ( !array.size )
return undefined;
AssertEx( array.size == 1, "tried to get_vehicle() on vehicles with key-pair: " + name + "," + type );
return array[ 0 ];
}
get_vehicle_array( name, type )
{
array = GetEntArray( name, type );
vehicle = [];
merge_array = [];
foreach ( object in array )
{
if ( object.code_classname != "script_vehicle" )
continue;
merge_array[ 0 ] = object;
if ( IsSpawner( object ) )
{
if ( IsDefined( object.last_spawned_vehicle ) )
{
merge_array[ 0 ] = object.last_spawned_vehicle;
vehicle = array_merge( vehicle, merge_array );
}
continue;
}
vehicle = array_merge( vehicle, merge_array );
}
return vehicle;
}
get_living_aispecies( name, type, breed )
{
array = get_living_ai_array( name, type, breed );
if ( array.size > 1 )
{
AssertMsg( "get_living_aispecies used for more than one living ai of type " + type + " called " + name + "." );
return undefined;
}
return array[ 0 ];
}
get_living_aispecies_array( name, type, breed )
{
if ( !isdefined( breed ) )
breed = "all";
ai = GetAISpeciesArray( "allies", breed );
ai = array_combine( ai, GetAISpeciesArray( "axis", breed ) );
array = [];
for ( i = 0; i < ai.size; i++ )
{
switch( type )
{
case "targetname":{
if ( IsDefined( ai[ i ].targetname ) && ai[ i ].targetname == name )
array[ array.size ] = ai[ i ];
}break;
case "script_noteworthy":{
if ( IsDefined( ai[ i ].script_noteworthy ) && ai[ i ].script_noteworthy == name )
array[ array.size ] = ai[ i ];
}break;
}
}
return array;
}
gather_delay_proc( msg, delay )
{
if ( IsDefined( level.gather_delay[ msg ] ) )
{
if ( level.gather_delay[ msg ] )
{
wait( 0.05 );
if ( IsAlive( self ) )
self notify( "gather_delay_finished" + msg + delay );
return;
}
level waittill( msg );
if ( IsAlive( self ) )
self notify( "gather_delay_finished" + msg + delay );
return;
}
level.gather_delay[ msg ] = false;
wait( delay );
level.gather_delay[ msg ] = true;
level notify( msg );
if ( IsAlive( self ) )
self notify( "gather_delay_finished" + msg + delay );
}
gather_delay( msg, delay )
{
thread gather_delay_proc( msg, delay );
self waittill( "gather_delay_finished" + msg + delay );
}
set_environment( env )
{
animscripts\utility::setEnv( env );
}
death_waiter( notifyString )
{
self waittill( "death" );
level notify( notifyString );
}
getchar( num )
{
if ( num == 0 )
return "0";
if ( num == 1 )
return "1";
if ( num == 2 )
return "2";
if ( num == 3 )
return "3";
if ( num == 4 )
return "4";
if ( num == 5 )
return "5";
if ( num == 6 )
return "6";
if ( num == 7 )
return "7";
if ( num == 8 )
return "8";
if ( num == 9 )
return "9";
}
getlinks_array( array, linkMap )
{
ents = [];
for ( j = 0; j < array.size; j++ )
{
node = array[ j ];
script_linkname = node.script_linkname;
if ( !isdefined( script_linkname ) )
continue;
if ( !isdefined( linkMap[ script_linkname ] ) )
continue;
ents[ ents.size ] = node;
}
return ents;
}
array_merge_links( array1, array2 )
{
if ( !array1.size )
return array2;
if ( !array2.size )
return array1;
linkMap = [];
for ( i = 0; i < array1.size; i++ )
{
node = array1[ i ];
linkMap[ node.script_linkName ] = true;
}
for ( i = 0; i < array2.size; i++ )
{
node = array2[ i ];
if ( IsDefined( linkMap[ node.script_linkName ] ) )
continue;
linkMap[ node.script_linkName ] = true;
array1[ array1.size ] = node;
}
return array1;
}
array_merge( array1, array2 )
{
if ( array1.size == 0 )
return array2;
if ( array2.size == 0 )
return array1;
newarray = array1;
foreach ( array2_ent in array2 )
{
foundmatch = false;
foreach ( array1_ent in array1 )
{
if ( array1_ent == array2_ent )
{
foundmatch = true;
break;
}
}
if ( foundmatch )
continue;
else
newarray[ newarray.size ] = array2_ent;
}
return newarray;
}
array_exclude( array, arrayExclude )
{
newarray = array;
for ( i = 0; i < arrayExclude.size; i++ )
{
if ( is_in_array( array, arrayExclude[ i ] ) )
newarray = array_remove( newarray, arrayExclude[ i ] );
}
return newarray;
}
array_compare( array1, array2 )
{
if ( array1.size != array2.size )
return false;
foreach ( key, member in array1 )
{
if ( !isdefined( array2[ key ] ) )
return false;
member2 = array2[ key ];
if ( member2 != member )
return false;
}
return true;
}
array_contains( array, compare )
{
if ( array.size <= 0 )
return false;
foreach ( member in array )
{
if ( member == compare )
return true;
}
return false;
}
getLinkedVehicleNodes()
{
array = [];
if ( IsDefined( self.script_linkTo ) )
{
linknames = get_links();
foreach ( name in linknames )
{
entities = GetVehicleNodeArray( name, "script_linkname" );
array = array_combine( array, entities );
}
}
return array;
}
draw_line( org1, org2, r, g, b )
{
while ( 1 )
{
Line( org1, org2, ( r, g, b ), 1 );
wait .05;
}
}
draw_line_to_ent_for_time( org1, ent, r, g, b, timer )
{
timer = GetTime() + ( timer * 1000 );
while ( GetTime() < timer )
{
Line( org1, ent.origin, ( r, g, b ), 1 );
wait .05;
if ( !isdefined( ent ) || !isdefined( ent.origin ) )
return;
}
}
draw_line_from_ent_for_time( ent, org, r, g, b, timer )
{
draw_line_to_ent_for_time( org, ent, r, g, b, timer );
}
draw_line_from_ent_to_ent_for_time( ent1, ent2, r, g, b, timer )
{
ent1 endon( "death" );
ent2 endon( "death" );
timer = GetTime() + ( timer * 1000 );
while ( GetTime() < timer )
{
Line( ent1.origin, ent2.origin, ( r, g, b ), 1 );
wait .05;
}
}
draw_line_from_ent_to_ent_until_notify( ent1, ent2, r, g, b, notifyEnt, notifyString )
{
Assert( IsDefined( notifyEnt ) );
Assert( IsDefined( notifyString ) );
ent1 endon( "death" );
ent2 endon( "death" );
notifyEnt endon( notifyString );
while ( 1 )
{
Line( ent1.origin, ent2.origin, ( r, g, b ), 0.05 );
wait .05;
}
}
draw_line_until_notify( org1, org2, r, g, b, notifyEnt, notifyString )
{
Assert( IsDefined( notifyEnt ) );
Assert( IsDefined( notifyString ) );
notifyEnt endon( notifyString );
while ( 1 )
{
draw_line_for_time( org1, org2, r, g, b, 0.05 );
}
}
draw_line_from_ent_to_vec_for_time( ent, vec, length, r, g, b, timer )
{
timer = GetTime() + ( timer * 1000 );
vec *= length;
while ( GetTime() < timer )
{
Line( ent.origin, ent.origin + vec, ( r, g, b ), 1 );
wait .05;
if ( !isdefined( ent ) || !isdefined( ent.origin ) )
return;
}
}
draw_circle_until_notify( center, radius, r, g, b, notifyEnt, notifyString )
{
circle_sides = 16;
angleFrac = 360 / circle_sides;
circlepoints = [];
for ( i = 0; i < circle_sides; i++ )
{
angle = ( angleFrac * i );
xAdd = Cos( angle ) * radius;
yAdd = Sin( angle ) * radius;
x = center[ 0 ] + xAdd;
y = center[ 1 ] + yAdd;
z = center[ 2 ];
circlepoints[ circlepoints.size ] = ( x, y, z );
}
thread draw_circle_lines_until_notify( circlepoints, r, g, b, notifyEnt, notifyString );
}
draw_circle_lines_until_notify( circlepoints, r, g, b, notifyEnt, notifyString )
{
for ( i = 0; i < circlepoints.size; i++ )
{
start = circlepoints[ i ];
if ( i + 1 >= circlepoints.size )
end = circlepoints[ 0 ];
else
end = circlepoints[ i + 1 ];
thread draw_line_until_notify( start, end, r, g, b, notifyEnt, notifyString );
}
}
clear_enemy_passthrough()
{
self notify( "enemy" );
self ClearEnemy();
}
battlechatter_off( team )
{
level notify( "battlechatter_off_thread" );
animscripts\battlechatter::bcs_setup_chatter_toggle_array();
if ( IsDefined( team ) )
{
set_battlechatter_variable( team, false );
soldiers = GetAIArray( team );
}
else
{
foreach ( team in anim.teams )
{
set_battlechatter_variable( team, false );
}
soldiers = GetAIArray();
}
if ( !isDefined( anim.chatInitialized ) || !anim.chatInitialized )
return;
for ( index = 0; index < soldiers.size; index++ )
soldiers[ index ].battlechatter = false;
for ( index = 0; index < soldiers.size; index++ )
{
soldier = soldiers[ index ];
if ( !isalive( soldier ) )
continue;
if ( !soldier.chatInitialized )
continue;
if ( !soldier.isSpeaking )
continue;
soldier wait_until_done_speaking();
}
speakDiff = GetTime() - anim.lastTeamSpeakTime[ "allies" ];
if ( speakDiff < 1500 )
wait( speakDiff / 1000 );
if ( IsDefined( team ) )
level notify( team + " done speaking" );
else
level notify( "done speaking" );
}
battlechatter_on( team )
{
thread battlechatter_on_thread( team );
}
battlechatter_on_thread( team )
{
level endon( "battlechatter_off_thread" );
animscripts\battlechatter::bcs_setup_chatter_toggle_array();
while ( !IsDefined( anim.chatInitialized ) )
{
wait( 0.05 );
}
flag_set( "battlechatter_on_thread_waiting" );
wait( 1.5 );
flag_clear( "battlechatter_on_thread_waiting" );
if ( IsDefined( team ) )
{
set_battlechatter_variable( team, true );
soldiers = GetAIArray( team );
}
else
{
foreach ( team in anim.teams )
{
set_battlechatter_variable( team, true );
}
soldiers = GetAIArray();
}
for ( index = 0; index < soldiers.size; index++ )
soldiers[ index ] set_battlechatter( true );
}
set_battlechatter( state )
{
if ( !anim.chatInitialized )
return;
if ( self.type == "dog" )
return;
if ( state )
{
if ( IsDefined( self.script_bcdialog ) && !self.script_bcdialog )
self.battlechatter = false;
else
self.battlechatter = true;
}
else
{
self.battlechatter = false;
if ( IsDefined( self.isSpeaking ) && self.isSpeaking )
self waittill( "done speaking" );
}
}
set_team_bcvoice( team, newvoice )
{
if ( !anim.chatInitialized )
return;
supported_voicetypes = GetArrayKeys( anim.countryIDs );
in_supported_voicetypes = array_contains( supported_voicetypes, newvoice );
assertEx( in_supported_voicetypes, "Tried to change ai's voice to " + newvoice + " but that voicetype is not supported!" );
if ( !in_supported_voicetypes )
return;
allies = GetAIArray( team );
foreach( ai in allies )
ai set_ai_bcvoice( newvoice );
}
set_ai_bcvoice( newvoice )
{
if ( !anim.chatInitialized )
return;
supported_voicetypes = GetArrayKeys( anim.countryIDs );
in_supported_voicetypes = array_contains( supported_voicetypes, newvoice );
assertEx( in_supported_voicetypes, "Tried to change ai's voice to " + newvoice + " but that voicetype is not supported!" );
if ( !in_supported_voicetypes )
return;
if ( self.type == "dog" )
return;
if ( IsDefined( self.isSpeaking ) && self.isSpeaking )
{
self waittill( "done speaking" );
wait( 0.1 );
}
self animscripts\battlechatter_ai::removeFromSystem();
wait( 0.1 );
self.voice = newvoice;
self animscripts\battlechatter_ai::addToSystem();
}
flavorbursts_on( team )
{
thread set_flavorbursts_team_state( true, team );
}
flavorbursts_off( team )
{
thread set_flavorbursts_team_state( false, team );
}
set_flavorbursts_team_state( state, team )
{
if ( !IsDefined( team ) )
{
team = "allies";
}
if ( !anim.chatInitialized )
{
return;
}
wait( 1.5 );
level.flavorbursts[ team ] = state;
guys = [];
guys = GetAIArray( team );
array_thread( guys, ::set_flavorbursts, state );
}
set_flavorbursts( state )
{
self.flavorbursts = state;
}
friendlyfire_warnings_off()
{
ais = GetAiArray( "allies" );
foreach( guy in ais )
{
if( IsAlive( guy ) )
{
guy set_friendlyfire_warnings( false );
}
}
level.friendlyfire_warnings = false;
}
friendlyfire_warnings_on()
{
ais = GetAiArray( "allies" );
foreach( guy in ais )
{
if( IsAlive( guy ) )
{
guy set_friendlyfire_warnings( true );
}
}
level.friendlyfire_warnings = true;
}
set_friendlyfire_warnings( state )
{
if( state )
{
self.friendlyfire_warnings_disable = undefined;
}
else
{
self.friendlyfire_warnings_disable = true;
}
}
set_friendly_chain_wrapper( node )
{
level.player SetFriendlyChain( node );
level notify( "newFriendlyChain", node.script_noteworthy );
}
get_obj_origin( msg )
{
objOrigins = GetEntArray( "objective", "targetname" );
for ( i = 0; i < objOrigins.size; i++ )
{
if ( objOrigins[ i ].script_noteworthy == msg )
return objOrigins[ i ].origin;
}
}
get_obj_event( msg )
{
objEvents = GetEntArray( "objective_event", "targetname" );
for ( i = 0; i < objEvents.size; i++ )
{
if ( objEvents[ i ].script_noteworthy == msg )
return objEvents[ i ];
}
}
waittill_objective_event()
{
waittill_objective_event_proc( true );
}
waittill_objective_event_notrigger()
{
waittill_objective_event_proc( false );
}
obj_set_chain_and_enemies()
{
objChain = GetNode( self.target, "targetname" );
objEnemies = GetEntArray( self.target, "targetname" );
flood_and_secure_scripted( objEnemies );
level notify( "new_friendly_trigger" );
level.player set_friendly_chain_wrapper( objChain );
}
flood_begin()
{
self notify( "flood_begin" );
}
flood_and_secure_scripted( spawners, instantRespawn )
{
if ( !isdefined( instantRespawn ) )
instantRespawn = false;
if ( !isdefined( level.spawnerWave ) )
level.spawnerWave = [];
array_thread( spawners, maps\_spawner::flood_and_secure_spawner, instantRespawn );
for ( i = 0; i < spawners.size; i++ )
{
spawners[ i ].playerTriggered = true;
spawners[ i ] notify( "flood_begin" );
}
}
debugorigin()
{
self notify( "Debug origin" );
self endon( "Debug origin" );
self endon( "death" );
for ( ;; )
{
forward = AnglesToForward( self.angles );
forwardFar = ( forward * 30 );
forwardClose = ( forward * 20 );
right = AnglesToRight( self.angles );
left = ( right * -10 );
right = ( right * 10 );
Line( self.origin, self.origin + forwardFar, ( 0.9, 0.7, 0.6 ), 0.9 );
Line( self.origin + forwardFar, self.origin + forwardClose + right, ( 0.9, 0.7, 0.6 ), 0.9 );
Line( self.origin + forwardFar, self.origin + forwardClose + left, ( 0.9, 0.7, 0.6 ), 0.9 );
wait( 0.05 );
}
}
get_linked_structs()
{
array = [];
if ( IsDefined( self.script_linkTo ) )
{
linknames = get_links();
for ( i = 0; i < linknames.size; i++ )
{
ent = getstruct( linknames[ i ], "script_linkname" );
if ( IsDefined( ent ) )
{
array[ array.size ] = ent;
}
}
}
return array;
}
get_last_ent_in_chain( sEntityType )
{
ePathpoint = self;
while ( IsDefined( ePathpoint.target ) )
{
wait( 0.05 );
if ( IsDefined( ePathpoint.target ) )
{
switch( sEntityType )
{
case "vehiclenode":
ePathpoint = GetVehicleNode( ePathpoint.target, "targetname" );
break;
case "pathnode":
ePathpoint = GetNode( ePathpoint.target, "targetname" );
break;
case "ent":
ePathpoint = GetEnt( ePathpoint.target, "targetname" );
break;
case "struct":
ePathpoint = getstruct( ePathpoint.target, "targetname" );
break;
default:
AssertMsg( "sEntityType needs to be 'vehiclenode', 'pathnode', 'ent' or 'struct'" );
}
}
else
break;
}
ePathend = ePathpoint;
return ePathend;
}
player_seek( timeout )
{
goalent = Spawn( "script_origin", level.player.origin );
goalent LinkTo( level.player );
if ( IsDefined( timeout ) )
self thread timeout( timeout );
self SetGoalEntity( goalent );
if ( !isdefined( self.oldgoalradius ) )
self.oldgoalradius = self.goalradius;
self.goalradius = 300;
self waittill_any( "goal", "timeout" );
if ( IsDefined( self.oldgoalradius ) )
{
self.goalradius = self.oldgoalradius;
self.oldgoalradius = undefined;
}
goalent Delete();
}
timeout( timeout )
{
self endon( "death" );
wait( timeout );
self notify( "timeout" );
}
set_forcegoal()
{
if ( IsDefined( self.set_forcedgoal ) )
return;
self.oldfightdist = self.pathenemyfightdist;
self.oldmaxdist = self.pathenemylookahead;
self.oldmaxsight = self.maxsightdistsqrd;
self.pathenemyfightdist = 8;
self.pathenemylookahead = 8;
self.maxsightdistsqrd = 1;
self.set_forcedgoal = true;
}
unset_forcegoal()
{
if ( !isdefined( self.set_forcedgoal ) )
return;
self.pathenemyfightdist = self.oldfightdist;
self.pathenemylookahead = self.oldmaxdist;
self.maxsightdistsqrd = self.oldmaxsight;
self.set_forcedgoal = undefined;
}
array_add( array, ent )
{
array[ array.size ] = ent;
return array;
}
array_removeDead_keepkeys( array )
{
newArray = [];
keys = GetArrayKeys( array );
for ( i = 0; i < keys.size; i++ )
{
key = keys[ i ];
if ( !isalive( array[ key ] ) )
continue;
newArray[ key ] = array[ key ];
}
return newArray;
}
array_removeDead( array )
{
newArray = [];
foreach ( member in array )
{
if ( !isalive( member ) )
continue;
newArray[ newArray.size ] = member;
}
return newArray;
}
array_removeDead_or_dying( array )
{
newArray = [];
foreach ( member in array )
{
if ( !isalive( member ) )
continue;
if ( member doingLongDeath() )
continue;
newArray[ newArray.size ] = member;
}
return newArray;
}
array_insert( array, object, index )
{
if ( index == array.size )
{
temp = array;
temp[ temp.size ] = object;
return temp;
}
temp = [];
offset = 0;
for ( i = 0; i < array.size; i++ )
{
if ( i == index )
{
temp[ i ] = object;
offset = 1;
}
temp[ i + offset ] = array[ i ];
}
return temp;
}
array_remove_nokeys( ents, remover )
{
newents = [];
for ( i = 0; i < ents.size; i++ )
if ( ents[ i ] != remover )
newents[ newents.size ] = ents[ i ];
return newents;
}
array_remove_index( array, index )
{
for ( i = 0; i < array.size - 1; i++ )
{
if ( i == index )
{
array[ i ] = array[ i + 1 ];
index++;
}
}
array[ array.size - 1 ] = undefined;
return array;
}
array_notify( ents, notifier, match )
{
foreach ( key, value in ents )
value notify( notifier, match );
}
struct_arrayspawn()
{
struct = SpawnStruct();
struct.array = [];
struct.lastindex = 0;
return struct;
}
structarray_add( struct, object )
{
Assert( !isdefined( object.struct_array_index ) );
struct.array[ struct.lastindex ] = object;
object.struct_array_index = struct.lastindex;
struct.lastindex++;
}
structarray_remove( struct, object )
{
structarray_swaptolast( struct, object );
struct.array[ struct.lastindex - 1 ] = undefined;
struct.lastindex--;
}
structarray_remove_index( struct, index )
{
if ( IsDefined( struct.array[ struct.lastindex - 1 ] ) )
{
struct.array[ index ] = struct.array[ struct.lastindex - 1 ];
struct.array[ index ].struct_array_index = index;
struct.array[ struct.lastindex - 1 ] = undefined;
struct.lastindex = struct.array.size;
}
else
{
struct.array[ index ] = undefined;
structarray_remove_undefined( struct );
}
}
structarray_remove_undefined( struct )
{
newArray = [];
foreach( object in struct.array )
{
if ( !isdefined( object ) )
continue;
newArray[ newArray.size ] = object;
}
struct.array = newArray;
foreach( i, object in struct.array )
{
object.struct_array_index = i;
}
struct.lastindex = struct.array.size;
}
structarray_swaptolast( struct, object )
{
struct structarray_swap( struct.array[ struct.lastindex - 1 ], object );
}
structarray_shuffle( struct, shuffle )
{
for ( i = 0; i < shuffle; i++ )
struct structarray_swap( struct.array[ i ], struct.array[ RandomInt( struct.lastindex ) ] );
}
set_ambient_alias( ambient, alias )
{
zone = ambient;
maps\_audio_zone_manager::AZM_set_zone_streamed_ambience(zone, alias);
}
get_use_key()
{
if ( level.console )
return " + usereload";
else
return " + activate";
}
doom()
{
self Teleport( ( 0, 0, -15000 ) );
self Kill( ( 0, 0, 0 ) );
}
custom_battlechatter( phrase )
{
return self animscripts\battlechatter_ai::custom_battlechatter_internal( phrase );
}
get_stop_watch( time, othertime )
{
watch = NewHudElem();
if ( level.console )
{
watch.x = 68;
watch.y = 35;
}
else
{
watch.x = 58;
watch.y = 95;
}
watch.alignx = "center";
watch.aligny = "middle";
watch.horzAlign = "left";
watch.vertAlign = "middle";
if ( IsDefined( othertime ) )
timer = othertime;
else
timer = level.explosiveplanttime;
watch SetClock( timer, time, "hudStopwatch", 64, 64 );
return watch;
}
objective_is_active( msg )
{
active = false;
for ( i = 0; i < level.active_objective.size; i++ )
{
if ( level.active_objective[ i ] != msg )
continue;
active = true;
break;
}
return( active );
}
objective_is_inactive( msg )
{
inactive = false;
for ( i = 0; i < level.inactive_objective.size; i++ )
{
if ( level.inactive_objective[ i ] != msg )
continue;
inactive = true;
break;
}
return( inactive );
}
set_objective_inactive( msg )
{
array = [];
for ( i = 0; i < level.active_objective.size; i++ )
{
if ( level.active_objective[ i ] == msg )
continue;
array[ array.size ] = level.active_objective[ i ];
}
level.active_objective = array;
exists = false;
for ( i = 0; i < level.inactive_objective.size; i++ )
{
if ( level.inactive_objective[ i ] != msg )
continue;
exists = true;
}
if ( !exists )
level.inactive_objective[ level.inactive_objective.size ] = msg;
}
set_objective_active( msg )
{
array = [];
for ( i = 0; i < level.inactive_objective.size; i++ )
{
if ( level.inactive_objective[ i ] == msg )
continue;
array[ array.size ] = level.inactive_objective[ i ];
}
level.inactive_objective = array;
exists = false;
for ( i = 0; i < level.active_objective.size; i++ )
{
if ( level.active_objective[ i ] != msg )
continue;
exists = true;
}
if ( !exists )
level.active_objective[ level.active_objective.size ] = msg;
}
detect_friendly_fire()
{
level thread maps\_friendlyfire::detectFriendlyFireOnEntity( self );
}
missionFailedWrapper()
{
if ( level.MissionFailed )
return;
if ( IsDefined( level.nextmission ) )
return;
level.MissionFailed = true;
flag_set( "missionfailed" );
if ( arcadeMode() )
return;
if ( GetDvar( "failure_disabled" ) == "1" )
return;
if ( is_specialop() )
{
level.challenge_end_time = gettime();
thread maps\_specialops_code::failure_summary_display();
return;
}
mission_recon( false );
MissionFailed();
}
script_delay()
{
if ( IsDefined( self.script_delay ) )
{
wait( self.script_delay );
return true;
}
else
if ( IsDefined( self.script_delay_min ) && IsDefined( self.script_delay_max ) )
{
wait( RandomFloatRange( self.script_delay_min, self.script_delay_max ) );
return true;
}
return false;
}
script_wait()
{
startTime = GetTime();
if ( IsDefined( self.script_wait ) )
{
wait( self.script_wait );
if ( IsDefined( self.script_wait_add ) )
self.script_wait += self.script_wait_add;
}
else if ( IsDefined( self.script_wait_min ) && IsDefined( self.script_wait_max ) )
{
wait( RandomFloatRange( self.script_wait_min, self.script_wait_max ) );
if ( IsDefined( self.script_wait_add ) )
{
self.script_wait_min += self.script_wait_add;
self.script_wait_max += self.script_wait_add;
}
}
return( GetTime() - startTime );
}
guy_enter_vehicle( guy )
{
self maps\_vehicle_aianim::guy_enter( guy );
}
guy_runtovehicle_load( guy, vehicle )
{
maps\_vehicle_aianim::guy_runtovehicle( guy, vehicle );
}
get_force_color_guys( team, color )
{
ai = GetAIArray( team );
guys = [];
for ( i = 0; i < ai.size; i++ )
{
guy = ai[ i ];
if ( !isdefined( guy.script_forcecolor ) )
continue;
if ( guy.script_forcecolor != color )
continue;
guys[ guys.size ] = guy;
}
return guys;
}
get_all_force_color_friendlies()
{
ai = GetAIArray( "allies" );
guys = [];
for ( i = 0; i < ai.size; i++ )
{
guy = ai[ i ];
if ( !isdefined( guy.script_forcecolor ) )
continue;
guys[ guys.size ] = guy;
}
return guys;
}
get_all_target_ents( target )
{
if ( !isdefined( target ) )
target = self.target;
AssertEx( IsDefined( target ), "Self had no target!" );
array = [];
ents = GetEntArray( target, "targetname" );
array = array_combine( array, ents );
ents = GetNodeArray( target, "targetname" );
array = array_combine( array, ents );
ents = getstructarray( target, "targetname" );
array = array_combine( array, ents );
ents = GetVehicleNodeArray( target, "targetname" );
array = array_combine( array, ents );
return array;
}
enable_ai_color()
{
if ( IsDefined( self.script_forcecolor ) )
return;
if ( !isdefined( self.old_forceColor ) )
return;
set_force_color( self.old_forcecolor );
self.old_forceColor = undefined;
}
enable_ai_color_dontmove()
{
self.dontColorMove = true;
self enable_ai_color();
}
disable_ai_color()
{
if ( IsDefined( self.new_force_color_being_set ) )
{
self endon( "death" );
self waittill( "done_setting_new_color" );
}
self ClearFixedNodeSafeVolume();
if ( !isdefined( self.script_forcecolor ) )
{
return;
}
AssertEx( !isdefined( self.old_forcecolor ), "Tried to disable forcecolor on a guy that somehow had a old_forcecolor already. Investigate!!!" );
self.old_forceColor = self.script_forceColor;
level.arrays_of_colorForced_ai[ self maps\_colors::get_team() ][ self.script_forcecolor ] = array_remove( level.arrays_of_colorForced_ai[ self maps\_colors::get_team() ][ self.script_forcecolor ], self );
maps\_colors::left_color_node();
self.script_forcecolor = undefined;
self.currentColorCode = undefined;
}
clear_force_color()
{
disable_ai_color();
}
check_force_color( _color )
{
color = level.colorCheckList[ ToLower( _color ) ];
if ( IsDefined( self.script_forcecolor ) && color == self.script_forcecolor )
return true;
else
return false;
}
get_force_color()
{
color = self.script_forceColor;
return color;
}
shortenColor( color )
{
AssertEx( IsDefined( level.colorCheckList[ ToLower( color ) ] ), "Tried to set force color on an undefined color: " + color );
return level.colorCheckList[ ToLower( color ) ];
}
set_force_color( _color )
{
color = shortenColor( _color );
AssertEx( maps\_colors::colorIsLegit( color ), "Tried to set force color on an undefined color: " + color );
if ( !isAI( self ) )
{
set_force_color_spawner( color );
return;
}
AssertEx( IsAlive( self ), "Tried to set force color on a dead / undefined entity." );
if ( self.team == "allies" )
{
self.fixednode = true;
self.fixednodesaferadius = 64;
self.pathenemyfightdist = 0;
self.pathenemylookahead = 0;
}
self.script_color_axis = undefined;
self.script_color_allies = undefined;
self.old_forcecolor = undefined;
team = maps\_colors::get_team();
if ( IsDefined( self.script_forcecolor ) )
{
level.arrays_of_colorForced_ai[ team ][ self.script_forcecolor ] = array_remove( level.arrays_of_colorForced_ai[ team ][ self.script_forcecolor ], self );
}
self.script_forcecolor = color;
level.arrays_of_colorForced_ai[ team ][ color ] = array_removeDead( level.arrays_of_colorForced_ai[ team ][ color ] );
level.arrays_of_colorForced_ai[ team ][ self.script_forcecolor ] = array_add( level.arrays_of_colorForced_ai[ team ][ self.script_forcecolor ], self );
thread new_color_being_set( color );
}
set_force_color_spawner( color )
{
self.script_forcecolor = color;
self.old_forceColor = undefined;
}
issue_color_orders( color_team, team )
{
colorCodes = StrTok( color_team, " " );
colors = [];
colorCodesByColorIndex = [];
for ( i = 0; i < colorCodes.size; i++ )
{
color = undefined;
if ( IsSubStr( colorCodes[ i ], "r" ) )
color = "r";
else
if ( IsSubStr( colorCodes[ i ], "b" ) )
color = "b";
else
if ( IsSubStr( colorCodes[ i ], "y" ) )
color = "y";
else
if ( IsSubStr( colorCodes[ i ], "c" ) )
color = "c";
else
if ( IsSubStr( colorCodes[ i ], "g" ) )
color = "g";
else
if ( IsSubStr( colorCodes[ i ], "p" ) )
color = "p";
else
if ( IsSubStr( colorCodes[ i ], "o" ) )
color = "o";
else
AssertEx( 0, "Trigger at origin " + self GetOrigin() + " had strange color index " + colorCodes[ i ] );
colorCodesByColorIndex[ color ] = colorCodes[ i ];
colors[ colors.size ] = color;
}
Assert( colors.size == colorCodes.size );
for ( i = 0; i < colorCodes.size; i++ )
{
level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] = array_removeUndefined( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] );
AssertEx( IsDefined( level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ] ), "Trigger refer to a color# that does not exist in any node for this team." );
for ( p = 0; p < level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ].size; p++ )
level.arrays_of_colorCoded_spawners[ team ][ colorCodes[ i ] ][ p ].currentColorCode = colorCodes[ i ];
}
for ( i = 0; i < colors.size; i++ )
{
level.arrays_of_colorForced_ai[ team ][ colors[ i ] ] = array_removeDead( level.arrays_of_colorForced_ai[ team ][ colors[ i ] ] );
level.currentColorForced[ team ][ colors[ i ] ] = colorCodesByColorIndex[ colors[ i ] ];
}
for ( i = 0; i < colorCodes.size; i++ )
self thread maps\_colors::issue_color_order_to_ai( colorCodes[ i ], colors[ i ], team );
}
flashRumbleLoop( duration )
{
Assert( IsPlayer( self ) );
goalTime = GetTime() + duration * 1000;
while ( GetTime() < goalTime )
{
self PlayRumbleOnEntity( "damage_heavy" );
wait( 0.05 );
}
}
flashMonitorEnableHealthShield( time )
{
self endon( "death" );
self endon( "flashed" );
wait 0.2;
self EnableHealthShield( false );
wait time + 2;
self EnableHealthShield( true );
}
nineBangHandler( origin, percent_distance, percent_angle, attacker, team )
{
waits = [ 0.8, 0.7, 0.7, 0.6 ];
banglens = [ 1.0, 0.8, 0.6, 0.6 ];
foreach( i, banglen in banglens)
{
frac = ( percent_distance - 0.85 ) / ( 1 - 0.85 );
if ( frac > percent_angle )
percent_angle = frac;
if ( percent_angle < 0.25 )
percent_angle = 0.25;
minamountdist = 0.3;
if ( percent_distance > 1 - minamountdist )
percent_distance = 1.0;
else
percent_distance = percent_distance / ( 1 - minamountdist );
if ( team != self.team )
seconds = percent_distance * percent_angle * 6.0;
else
seconds = percent_distance * percent_angle * 3.0;
if ( seconds < 0.25 )
continue;
seconds = banglen * seconds;
if ( IsDefined( self.maxflashedseconds ) && seconds > self.maxflashedseconds )
seconds = self.maxflashedseconds;
self.flashingTeam = team;
self notify( "flashed" );
self.flashendtime = GetTime() + seconds * 1000;
self ShellShock( "flashbang", seconds );
flag_set( "player_flashed" );
if ( percent_distance * percent_angle > 0.5 )
self thread flashMonitorEnableHealthShield( seconds );
wait waits[i];
}
thread unflash_flag( 0.05 );
}
flashMonitor()
{
Assert( IsPlayer( self ) );
self endon( "death" );
for ( ;; )
{
self waittill( "flashbang", origin, percent_distance, percent_angle, attacker, team );
if ( "1" == GetDvar( "noflash" ) )
continue;
if ( is_player_down( self ) )
continue;
if (isdefined(self.threw_ninebang))
{
player_range_percent = 1000/1250;
om_player_range_percent = 1.0 - player_range_percent;
self.threw_ninebang = undefined;
if (percent_distance < om_player_range_percent)
continue;
percent_distance = (percent_distance-om_player_range_percent) / player_range_percent;
}
frac = ( percent_distance - 0.85 ) / ( 1 - 0.85 );
if ( frac > percent_angle )
percent_angle = frac;
if ( percent_angle < 0.25 )
percent_angle = 0.25;
minamountdist = 0.3;
if ( percent_distance > 1 - minamountdist )
percent_distance = 1.0;
else
percent_distance = percent_distance / ( 1 - minamountdist );
if ( team != self.team )
seconds = percent_distance * percent_angle * 6.0;
else
seconds = percent_distance * percent_angle * 3.0;
if ( seconds < 0.25 )
continue;
if ( IsDefined( self.maxflashedseconds ) && seconds > self.maxflashedseconds )
seconds = self.maxflashedseconds;
self.flashingTeam = team;
self notify( "flashed" );
self.flashendtime = GetTime() + seconds * 1000;
self ShellShock( "flashbang", seconds );
flag_set( "player_flashed" );
thread unflash_flag( seconds );
if ( percent_distance * percent_angle > 0.5 )
self thread flashMonitorEnableHealthShield( seconds );
if ( seconds > 2 )
thread flashRumbleLoop( 0.75 );
else
thread flashRumbleLoop( 0.25 );
if ( team != "allies" )
self thread flashNearbyAllies( seconds, team );
}
}
flashNearbyAllies( baseDuration, team )
{
Assert( IsPlayer( self ) );
wait .05;
allies = GetAIArray( "allies" );
for ( i = 0; i < allies.size; i++ )
{
if ( DistanceSquared( allies[ i ].origin, self.origin ) < 350 * 350 )
{
duration = baseDuration + RandomFloatRange( -1000, 1500 );
if ( duration > 4.5 )
duration = 4.5;
else if ( duration < 0.25 )
continue;
newendtime = GetTime() + duration * 1000;
if ( !isdefined( allies[ i ].flashendtime ) || allies[ i ].flashendtime < newendtime )
{
allies[ i ].flashingTeam = team;
allies[ i ] flashBangStart( duration );
}
}
}
}
restartEffect()
{
self common_scripts\_createfx::restart_fx_looper();
}
pauseExploder( num )
{
num += "";
if (isdefined(level.createFXexploders))
{
exploders = level.createFXexploders[num];
if (isdefined(exploders))
{
foreach (ent in exploders)
{
ent pauseEffect();
}
}
}
else
{
foreach ( fx in level.createFXent )
{
if ( !isdefined( fx.v[ "exploder" ] ) )
continue;
if ( fx.v[ "exploder" ] != num )
continue;
fx pauseEffect();
}
}
}
restartExploder( num )
{
num += "";
if (isdefined(level.createFXexploders))
{
exploders = level.createFXexploders[num];
if (isdefined(exploders))
{
foreach (ent in exploders)
{
ent restartEffect();
}
}
}
else
{
foreach ( fx in level.createFXent )
{
if ( !isdefined( fx.v[ "exploder" ] ) )
continue;
if ( fx.v[ "exploder" ] != num )
continue;
fx restartEffect();
}
}
}
getfxarraybyID( fxid )
{
array = [];
if (isdefined(level.createFXbyFXID))
{
fxids = level.createFXbyFXID[fxid];
if (isdefined(fxids))
array = fxids;
}
else
{
for ( i = 0; i < level.createFXent.size; i++ )
{
if ( level.createFXent[ i ].v[ "fxid" ] == fxid )
array[ array.size ] = level.createFXent[ i ];
}
}
return array;
}
ignoreAllEnemies( qTrue )
{
self notify( "ignoreAllEnemies_threaded" );
self endon( "ignoreAllEnemies_threaded" );
if ( qTrue )
{
self.old_threat_bias_group = self GetThreatBiasGroup();
num = undefined;
CreateThreatBiasGroup( "ignore_everybody" );
self SetThreatBiasGroup( "ignore_everybody" );
teams = [];
teams[ "axis" ] = "allies";
teams[ "allies" ] = "axis";
AssertEx( self.team != "neutral", "Why are you making a guy have team neutral? And also, why is he doing anim_reach?" );
ai = GetAIArray( teams[ self.team ] );
groups = [];
for ( i = 0; i < ai.size; i++ )
groups[ ai[ i ] GetThreatBiasGroup() ] = true;
keys = GetArrayKeys( groups );
for ( i = 0; i < keys.size; i++ )
{
SetThreatBias( keys[ i ], "ignore_everybody", 0 );
}
}
else
{
num = undefined;
AssertEx( IsDefined( self.old_threat_bias_group ), "You can't use ignoreAllEnemies( false ) on an AI that has never ran ignoreAllEnemies( true )" );
if ( self.old_threat_bias_group != "" )
{
self SetThreatBiasGroup( self.old_threat_bias_group );
}
self.old_threat_bias_group = undefined;
}
}
vehicle_detachfrompath()
{
maps\_vehicle::vehicle_pathdetach();
}
vehicle_resumepath()
{
thread maps\_vehicle::vehicle_resumepathvehicle();
}
vehicle_land( neargoaldist )
{
maps\_vehicle::vehicle_landvehicle( neargoaldist );
}
vehicle_liftoff( height )
{
maps\_vehicle::vehicle_liftoffvehicle( height );
}
vehicle_dynamicpath( node, bwaitforstart )
{
maps\_vehicle::vehicle_paths( node, bwaitforstart );
}
groundpos( origin )
{
return BulletTrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
}
change_player_health_packets( num )
{
Assert( IsPlayer( self ) );
self.player_health_packets += num;
self notify( "update_health_packets" );
if ( self.player_health_packets >= 3 )
self.player_health_packets = 3;
}
getvehiclespawner( targetname )
{
spawners = getvehiclespawnerarray( targetname );
Assert( spawners.size == 1 );
return spawners[ 0 ];
}
getvehiclespawnerarray( targetname )
{
return maps\_vehicle::_getvehiclespawnerarray( targetname );
}
describe_start( msg, func, loc_string, optional_func )
{
add_start_assert();
if( !IsDefined( level.start_description ) )
level.start_description = [];
AssertEx( !isdefined( level.start_description[ msg ] ), "You are describing this start point more than once" );
level.start_description[ msg ] = add_start_construct( msg, func, loc_string, optional_func );
}
add_start( msg, func, loc_string, optional_func )
{
add_start_assert();
msg = ToLower( msg );
if ( IsDefined( level.start_description ) && IsDefined( level.start_description[ msg ] ) )
{
array = level.start_description[ msg ];
}
else
array = add_start_construct( msg, func, loc_string, optional_func );
if( !IsDefined( func ) )
{
if ( !IsDefined( level.start_description ) )
AssertEx( IsDefined( func ), "add_start() called with no descriptions set and no func parameter.." );
else if( !IsSubStr( msg, "no_game" ) )
{
if ( !IsDefined( level.start_description[ msg ] ) )
return;
}
}
level.start_functions[ level.start_functions.size ] = array;
level.start_arrays[ msg ] = array;
}
is_no_game_start()
{
return IsSubStr( level.start_point, "no_game" );
}
add_start_construct( msg, func, loc_string, optional_func )
{
array = [];
array[ "name" ] = msg;
array[ "start_func" ] = func;
array[ "start_loc_string" ] = loc_string;
array[ "logic_func" ] = optional_func;
return array;
}
add_start_assert()
{
AssertEx( !isdefined( level._loadStarted ), "Can't create starts after _load" );
if ( !isdefined( level.start_functions ) )
level.start_functions = [];
}
level_has_start_points()
{
return level.start_functions.size > 1;
}
set_default_start( start )
{
level.default_start_override = start;
}
default_start( func )
{
level.default_start = func;
}
linetime( start, end, color, timer )
{
thread linetime_proc( start, end, color, timer );
}
within_fov( start_origin, start_angles, end_origin, fov )
{
normal = VectorNormalize( end_origin - start_origin );
forward = AnglesToForward( start_angles );
dot = VectorDot( forward, normal );
return dot >= fov;
}
within_fov_2d( start_origin, start_angles, end_origin, fov )
{
start_origin = set_z( start_origin, 0 );
end_origin = set_z( end_origin, 0 );
start_angles = ( 0, start_angles[ 1 ], 0 );
normal = VectorNormalize( end_origin - start_origin );
forward = AnglesToForward( start_angles );
dot = VectorDot( forward, normal );
return dot >= fov;
}
get_dot( start_origin, start_angles, end_origin )
{
normal = VectorNormalize( end_origin - start_origin );
forward = AnglesToForward( start_angles );
dot = VectorDot( forward, normal );
return dot;
}
within_fov_of_players( end_origin, fov )
{
bDestInFOV = undefined;
for ( i = 0; i < level.players.size; i++ )
{
playerEye = level.players[ i ] GetEye();
bDestInFOV = within_fov( playerEye, level.players[ i ] GetPlayerAngles(), end_origin, fov );
if ( !bDestInFOV )
return false;
}
return true;
}
waitSpread( start, end )
{
if ( !isdefined( end ) )
{
end = start;
start = 0;
}
AssertEx( IsDefined( start ) && IsDefined( end ), "Waitspread was called without defining amount of time" );
wait( RandomFloatRange( start, end ) );
if ( 1 )
return;
personal_wait_index = undefined;
if ( !isdefined( level.active_wait_spread ) )
{
level.active_wait_spread = true;
level.wait_spreaders = 0;
personal_wait_index = level.wait_spreaders;
level.wait_spreaders++;
thread waitSpread_code( start, end );
}
else
{
personal_wait_index = level.wait_spreaders;
level.wait_spreaders++;
waittillframeend;
}
waittillframeend;
wait( level.wait_spreader_allotment[ personal_wait_index ] );
}
wait_for_buffer_time_to_pass( last_queue_time, buffer_time )
{
timer = buffer_time * 1000 - ( GetTime() - last_queue_time );
timer *= 0.001;
if ( timer > 0 )
{
wait( timer );
}
}
bcs_scripted_dialogue_start()
{
anim.scriptedDialogueStartTime = GetTime();
}
dialogue_queue( msg )
{
bcs_scripted_dialogue_start();
if (!isaudiodisabled())
{
self maps\_anim::anim_single_queue( self, msg );
}
}
generic_dialogue_queue( msg, timeout )
{
bcs_scripted_dialogue_start();
if (!isaudiodisabled())
{
self maps\_anim::anim_generic_queue( self, msg, undefined, undefined, timeout );
}
}
radio_dialogue( msg, timeout )
{
AssertEx( IsDefined( level.scr_radio[ msg ] ), "Tried to play radio dialogue " + msg + " that did not exist! Add it to level.scr_radio" );
if ( !isdefined( level.player_radio_emitter ) )
{
ent = Spawn( "script_origin", ( 0, 0, 0 ) );
ent LinkTo( level.player, "", ( 0, 0, 0 ), ( 0, 0, 0 ) );
level.player_radio_emitter = ent;
}
bcs_scripted_dialogue_start();
success = false;
if ( !IsDefined( timeout ) )
{
success = level.player_radio_emitter function_stack( ::play_sound_on_tag, level.scr_radio[ msg ], undefined, true );
}
else
{
success = level.player_radio_emitter function_stack_timeout( timeout, ::play_sound_on_tag, level.scr_radio[ msg ], undefined, true );
}
return success;
}
radio_dialogue_overlap( msg )
{
AssertEx( IsDefined( level.scr_radio[ msg ] ), "Tried to play radio dialogue " + msg + " that did not exist! Add it to level.scr_radio" );
AssertEx( IsDefined( level.player_radio_emitter ), "Tried to overlap dialogue but no radio dialogue was playing, use radio_dialogue." );
level.player_radio_emitter play_sound_on_tag( level.scr_radio[ msg ], undefined, true );
}
radio_dialogue_stop()
{
if ( !isdefined( level.player_radio_emitter ) )
return;
level.player_radio_emitter Delete();
}
radio_dialogue_clear_stack()
{
if ( !isdefined( level.player_radio_emitter ) )
return;
level.player_radio_emitter function_stack_clear();
}
radio_dialogue_interupt( msg )
{
AssertEx( IsDefined( level.scr_radio[ msg ] ), "Tried to play radio dialogue " + msg + " that did not exist! Add it to level.scr_radio" );
if ( !isdefined( level.player_radio_emitter ) )
{
ent = Spawn( "script_origin", ( 0, 0, 0 ) );
ent LinkTo( level.player, "", ( 0, 0, 0 ), ( 0, 0, 0 ) );
level.player_radio_emitter = ent;
}
level.player_radio_emitter play_sound_on_tag( level.scr_radio[ msg ], undefined, true );
}
radio_dialogue_safe( msg )
{
return radio_dialogue( msg, .05 );
}
radio_dialogue_queue( msg )
{
radio_dialogue( msg );
}
hint_create( text, background, backgroundAlpha )
{
struct = SpawnStruct();
if ( IsDefined( background ) && background == true )
struct.bg = NewHudElem();
struct.elm = NewHudElem();
struct hint_position_internal( backgroundAlpha );
struct.elm SetText( text );
return struct;
}
hint_delete()
{
self notify( "death" );
if ( IsDefined( self.elm ) )
self.elm Destroy();
if ( IsDefined( self.bg ) )
self.bg Destroy();
}
hint_position_internal( bgAlpha )
{
if ( level.console )
self.elm.fontScale = 2;
else
self.elm.fontScale = 1.6;
self.elm.x = 0;
self.elm.y = -40;
self.elm.alignX = "center";
self.elm.alignY = "bottom";
self.elm.horzAlign = "center";
self.elm.vertAlign = "middle";
self.elm.sort = 1;
self.elm.alpha = 0.8;
if ( !isdefined( self.bg ) )
return;
self.bg.x = 0;
self.bg.y = -40;
self.bg.alignX = "center";
self.bg.alignY = "middle";
self.bg.horzAlign = "center";
self.bg.vertAlign = "middle";
self.bg.sort = -1;
if ( level.console )
self.bg SetShader( "popmenu_bg", 650, 52 );
else
self.bg SetShader( "popmenu_bg", 650, 42 );
if ( !isdefined( bgAlpha ) )
bgAlpha = 0.5;
self.bg.alpha = bgAlpha;
}
string( num )
{
return( "" + num );
}
ignoreEachOther( group1, group2 )
{
AssertEx( ThreatBiasGroupExists( group1 ), "Tried to make threatbias group " + group1 + " ignore " + group2 + " but " + group1 + " does not exist!" );
AssertEx( ThreatBiasGroupExists( group2 ), "Tried to make threatbias group " + group2 + " ignore " + group1 + " but " + group2 + " does not exist!" );
SetIgnoreMeGroup( group1, group2 );
SetIgnoreMeGroup( group2, group1 );
}
add_global_spawn_function( team, function, param1, param2, param3 )
{
AssertEx( IsDefined( level.spawn_funcs ), "Tried to add_global_spawn_function before calling _load" );
func = [];
func[ "function" ] = function;
func[ "param1" ] = param1;
func[ "param2" ] = param2;
func[ "param3" ] = param3;
level.spawn_funcs[ team ][ level.spawn_funcs[ team ].size ] = func;
}
remove_global_spawn_function( team, function )
{
AssertEx( IsDefined( level.spawn_funcs ), "Tried to remove_global_spawn_function before calling _load" );
array = [];
for ( i = 0; i < level.spawn_funcs[ team ].size; i++ )
{
if ( level.spawn_funcs[ team ][ i ][ "function" ] != function )
{
array[ array.size ] = level.spawn_funcs[ team ][ i ];
}
}
level.spawn_funcs[ team ] = array;
}
exists_global_spawn_function( team, function )
{
if ( !isdefined( level.spawn_funcs ) )
return false;
for ( i = 0; i < level.spawn_funcs[ team ].size; i++ )
{
if ( level.spawn_funcs[ team ][ i ][ "function" ] == function )
return true;
}
return false;
}
remove_spawn_function( function )
{
AssertEx( !isalive( self ), "Tried to remove_spawn_function to a living guy." );
AssertEx( IsSpawner( self ), "Tried to remove_spawn_function to something that isn't a spawner." );
AssertEx( IsDefined( self.spawn_functions ), "Tried to remove_spawn_function before calling _load" );
new_spawn_functions = [];
foreach ( func_array in self.spawn_functions )
{
if ( func_array[ "function" ] == function )
continue;
new_spawn_functions[ new_spawn_functions.size ] = func_array;
}
self.spawn_functions = new_spawn_functions;
}
add_spawn_function( function, param1, param2, param3, param4, param5 )
{
AssertEx( !isalive( self ), "Tried to add_spawn_function to a living guy." );
AssertEx( IsSpawner( self ), "Tried to add_spawn_function to something that isn't a spawner." );
AssertEx( IsDefined( self.spawn_functions ), "Tried to add_spawn_function before calling _load" );
foreach ( func_array in self.spawn_functions )
{
if ( func_array[ "function" ] == function )
return;
}
func = [];
func[ "function" ] = function;
func[ "param1" ] = param1;
func[ "param2" ] = param2;
func[ "param3" ] = param3;
func[ "param4" ] = param4;
func[ "param5" ] = param5;
self.spawn_functions[ self.spawn_functions.size ] = func;
}
array_delete( array )
{
for ( i = 0; i < array.size; i++ )
{
array[ i ] Delete();
}
}
array_kill( array )
{
for ( i = 0; i < array.size; i++ )
{
array[ i ] kill();
}
}
ignore_triggers( timer )
{
self endon( "death" );
self.ignoreTriggers = true;
if ( IsDefined( timer ) )
{
wait( timer );
}
else
{
wait( 0.5 );
}
self.ignoreTriggers = false;
}
activate_trigger_with_targetname( msg )
{
trigger = GetEnt( msg, "targetname" );
trigger activate_trigger();
}
activate_trigger_with_noteworthy( msg )
{
trigger = GetEnt( msg, "script_noteworthy" );
trigger activate_trigger();
}
disable_trigger_with_targetname( msg )
{
trigger = GetEnt( msg, "targetname" );
trigger trigger_off();
}
disable_trigger_with_noteworthy( msg )
{
trigger = GetEnt( msg, "script_noteworthy" );
trigger trigger_off();
}
enable_trigger_with_targetname( msg )
{
trigger = GetEnt( msg, "targetname" );
trigger trigger_on();
}
enable_trigger_with_noteworthy( msg )
{
trigger = GetEnt( msg, "script_noteworthy" );
trigger trigger_on();
}
is_hero()
{
return IsDefined( level.hero_list[ get_ai_number() ] );
}
get_ai_number()
{
if ( !isdefined( self.unique_id ) )
{
set_ai_number();
}
return self.unique_id;
}
set_ai_number()
{
self.unique_id = "ai" + level.ai_number;
level.ai_number++;
}
make_hero()
{
level.hero_list[ self.unique_id ] = true;
}
unmake_hero()
{
level.hero_list[ self.unique_id ] = undefined;
}
get_heroes()
{
array = [];
ai = GetAIArray( "allies" );
for ( i = 0; i < ai.size; i++ )
{
if ( ai[ i ] is_hero() )
array[ array.size ] = ai[ i ];
}
return array;
}
set_team_pacifist( team, val )
{
ai = GetAIArray( team );
for ( i = 0; i < ai.size; i++ )
{
ai[ i ].pacifist = val;
}
}
replace_on_death()
{
maps\_colors::colorNode_replace_on_death();
}
spawn_reinforcement( classname, color )
{
maps\_colors::colorNode_spawn_reinforcement( classname, color );
}
clear_promotion_order()
{
level.current_color_order = [];
}
set_promotion_order( deadguy, replacer )
{
if ( !isdefined( level.current_color_order ) )
{
level.current_color_order = [];
}
deadguy = shortenColor( deadguy );
replacer = shortenColor( replacer );
level.current_color_order[ deadguy ] = replacer;
if ( !isdefined( level.current_color_order[ replacer ] ) )
set_empty_promotion_order( replacer );
}
set_empty_promotion_order( deadguy )
{
if ( !isdefined( level.current_color_order ) )
{
level.current_color_order = [];
}
level.current_color_order[ deadguy ] = "none";
}
remove_dead_from_array( array )
{
newarray = [];
foreach ( item in array )
{
if ( !isalive( item ) )
continue;
newarray[ newarray.size ] = item;
}
return newarray;
}
remove_heroes_from_array( array )
{
newarray = [];
for ( i = 0; i < array.size; i++ )
{
if ( array[ i ] is_hero() )
continue;
newarray[ newarray.size ] = array[ i ];
}
return newarray;
}
remove_all_animnamed_guys_from_array( array )
{
newarray = [];
for ( i = 0; i < array.size; i++ )
{
if ( IsDefined( array[ i ].animname ) )
continue;
newarray[ newarray.size ] = array[ i ];
}
return newarray;
}
remove_color_from_array( array, color )
{
newarray = [];
for ( i = 0; i < array.size; i++ )
{
guy = array[ i ];
if ( !isdefined( guy.script_forcecolor ) )
continue;
if ( guy.script_forcecolor == color )
continue;
newarray[ newarray.size ] = guy;
}
return newarray;
}
remove_noteworthy_from_array( array, noteworthy )
{
newarray = [];
for ( i = 0; i < array.size; i++ )
{
guy = array[ i ];
if ( !isdefined( guy.script_noteworthy ) )
continue;
if ( guy.script_noteworthy == noteworthy )
continue;
newarray[ newarray.size ] = guy;
}
return newarray;
}
get_closest_colored_friendly( color, origin )
{
allies = get_force_color_guys( "allies", color );
allies = remove_heroes_from_array( allies );
if ( !isdefined( origin ) )
friendly_origin = level.player.origin;
else
friendly_origin = origin;
return getClosest( friendly_origin, allies );
}
remove_without_classname( array, classname )
{
newarray = [];
for ( i = 0; i < array.size; i++ )
{
if ( !issubstr( array[ i ].classname, classname ) )
continue;
newarray[ newarray.size ] = array[ i ];
}
return newarray;
}
remove_without_model( array, model )
{
newarray = [];
for ( i = 0; i < array.size; i++ )
{
if ( !issubstr( array[ i ].model, model ) )
continue;
newarray[ newarray.size ] = array[ i ];
}
return newarray;
}
get_closest_colored_friendly_with_classname( color, classname, origin )
{
allies = get_force_color_guys( "allies", color );
allies = remove_heroes_from_array( allies );
if ( !isdefined( origin ) )
friendly_origin = level.player.origin;
else
friendly_origin = origin;
allies = remove_without_classname( allies, classname );
return getClosest( friendly_origin, allies );
}
promote_nearest_friendly( colorFrom, colorTo )
{
for ( ;; )
{
friendly = get_closest_colored_friendly( colorFrom );
if ( !isalive( friendly ) )
{
wait( 1 );
continue;
}
friendly set_force_color( colorTo );
return;
}
}
instantly_promote_nearest_friendly( colorFrom, colorTo )
{
for ( ;; )
{
friendly = get_closest_colored_friendly( colorFrom );
if ( !isalive( friendly ) )
{
AssertEx( 0, "Instant promotion from " + colorFrom + " to " + colorTo + " failed!" );
return;
}
friendly set_force_color( colorTo );
return;
}
}
instantly_promote_nearest_friendly_with_classname( colorFrom, colorTo, classname )
{
for ( ;; )
{
friendly = get_closest_colored_friendly_with_classname( colorFrom, classname );
if ( !isalive( friendly ) )
{
AssertEx( 0, "Instant promotion from " + colorFrom + " to " + colorTo + " failed!" );
return;
}
friendly set_force_color( colorTo );
return;
}
}
promote_nearest_friendly_with_classname( colorFrom, colorTo, classname )
{
for ( ;; )
{
friendly = get_closest_colored_friendly_with_classname( colorFrom, classname );
if ( !isalive( friendly ) )
{
wait( 1 );
continue;
}
friendly set_force_color( colorTo );
return;
}
}
riotshield_lock_orientation( yaw_angle )
{
self OrientMode( "face angle", yaw_angle );
self.lockOrientation = true;
}
riotshield_unlock_orientation()
{
self.lockOrientation = false;
}
instantly_set_color_from_array_with_classname( array, color, classname )
{
foundGuy = false;
newArray = [];
for ( i = 0; i < array.size; i++ )
{
guy = array[ i ];
if ( foundGuy || !isSubstr( guy.classname, classname ) )
{
newArray[ newArray.size ] = guy;
continue;
}
foundGuy = true;
guy set_force_color( color );
}
return newArray;
}
instantly_set_color_from_array( array, color )
{
foundGuy = false;
newArray = [];
for ( i = 0; i < array.size; i++ )
{
guy = array[ i ];
if ( foundGuy )
{
newArray[ newArray.size ] = guy;
continue;
}
foundGuy = true;
guy set_force_color( color );
}
return newArray;
}
wait_for_script_noteworthy_trigger( msg )
{
wait_for_trigger( msg, "script_noteworthy" );
}
wait_for_targetname_trigger( msg )
{
wait_for_trigger( msg, "targetname" );
}
wait_for_flag_or_timeout( msg, timer )
{
if ( flag( msg ) )
return;
ent = SpawnStruct();
ent thread ent_waits_for_level_notify( msg );
ent thread ent_times_out( timer );
ent waittill( "done" );
}
wait_for_notify_or_timeout( msg, timer )
{
ent = SpawnStruct();
ent thread ent_waits_for_notify( self, msg );
ent thread ent_times_out( timer );
ent waittill( "done" );
}
wait_for_trigger_or_timeout( timer )
{
ent = SpawnStruct();
ent thread ent_waits_for_trigger( self );
ent thread ent_times_out( timer );
ent waittill( "done" );
}
wait_for_either_trigger( msg1, msg2 )
{
ent = SpawnStruct();
array = [];
array = array_combine( array, GetEntArray( msg1, "targetname" ) );
array = array_combine( array, GetEntArray( msg2, "targetname" ) );
for ( i = 0; i < array.size; i++ )
{
ent thread ent_waits_for_trigger( array[ i ] );
}
ent waittill( "done" );
}
dronespawn_bodyonly( spawner )
{
drone = maps\_spawner::spawner_dronespawn( spawner );
Assert( IsDefined( drone ) );
return drone;
}
dronespawn( spawner )
{
if ( !isdefined( spawner ) )
spawner = self;
drone = maps\_spawner::spawner_dronespawn( spawner );
Assert( IsDefined( drone ) );
AssertEx( IsDefined( level.drone_spawn_func ), "You need to put maps\_drone_civilian::init(); OR maps\_drone_ai::init(); in your level script! Use the civilian version if your drone is a civilian and the _ai version if it's a friendly or enemy." );
drone [[ level.drone_spawn_func ]]();
drone.spawn_funcs = spawner.spawn_functions;
drone thread maps\_spawner::run_spawn_functions();
return drone;
}
makerealai( drone )
{
return maps\_spawner::spawner_makerealai( drone );
}
get_trigger_flag()
{
if ( IsDefined( self.script_flag ) )
{
return self.script_flag;
}
if ( IsDefined( self.script_noteworthy ) )
{
return self.script_noteworthy;
}
AssertEx( 0, "Flag trigger at " + self.origin + " has no script_flag set." );
}
set_default_pathenemy_settings()
{
self.pathenemylookahead = 192;
self.pathenemyfightdist = 192;
}
cqb_walk( on_or_off )
{
if ( on_or_off == "on" )
{
self enable_cqbwalk();
}
else
{
Assert( on_or_off == "off" );
self disable_cqbwalk();
}
}
enable_cqbwalk( autoEnabled )
{
if ( !isdefined( autoEnabled ) )
self.cqbEnabled = true;
self.cqbwalking = true;
self.turnRate = 0.2;
level thread animscripts\cqb::findCQBPointsOfInterest();
}
disable_cqbwalk()
{
self.cqbwalking = undefined;
self.cqbEnabled = undefined;
self.turnRate = 0.3;
self.cqb_point_of_interest = undefined;
}
enable_readystand()
{
self.bUseReadyIdle = true;
}
disable_readystand()
{
self.bUseReadyIdle = undefined;
}
cqb_aim( the_target )
{
if ( !isdefined( the_target ) )
{
self.cqb_target = undefined;
}
else
{
self.cqb_target = the_target;
if ( !isdefined( the_target.origin ) )
AssertMsg( "target passed into cqb_aim does not have an origin!" );
}
}
set_force_cover( val )
{
AssertEx( !isdefined( val ) || val == false || val == true, "invalid force cover set on guy" );
AssertEx( IsAlive( self ), "Tried to set force cover on a dead guy" );
if ( IsDefined( val ) && val )
self.forceSuppression = true;
else
self.forceSuppression = undefined;
}
do_in_order( func1, param1, func2, param2 )
{
if ( IsDefined( param1 ) )
[[ func1 ]]( param1 );
else
[[ func1 ]]();
if ( IsDefined( param2 ) )
[[ func2 ]]( param2 );
else
[[ func2 ]]();
}
scrub()
{
self maps\_spawner::scrub_guy();
}
send_notify( msg, optional_param )
{
if ( IsDefined( optional_param ) )
self notify( msg, optional_param );
else
self notify( msg );
}
waittill_match_or_timeout( msg, match, timer )
{
ent = SpawnStruct();
ent endon( "complete" );
ent delayThread( timer, ::send_notify, "complete" );
self waittillmatch( msg, match );
}
deleteEnt( ent )
{
ent notify( "deleted" );
ent Delete();
}
first_touch( ent )
{
if ( !isdefined( self.touched ) )
self.touched = [];
AssertEx( IsDefined( ent ), "Ent is not defined!" );
AssertEx( IsDefined( ent.unique_id ), "Ent has no unique_id" );
if ( IsDefined( self.touched[ ent.unique_id ] ) )
return false;
self.touched[ ent.unique_id ] = true;
return true;
}
getanim( anime )
{
AssertEx( IsDefined( self.animname ), "Called getanim on a guy with no animname" );
AssertEx( IsDefined( level.scr_anim[ self.animname ][ anime ] ), "Called getanim on an inexistent anim" );
return level.scr_anim[ self.animname ][ anime ];
}
hasanim( anime )
{
AssertEx( IsDefined( self.animname ), "Called getanim on a guy with no animname" );
return IsDefined( level.scr_anim[ self.animname ][ anime ] );
}
getanim_from_animname( anime, animname )
{
AssertEx( IsDefined( animname ), "Must supply an animname" );
AssertEx( IsDefined( level.scr_anim[ animname ][ anime ] ), "Called getanim on an inexistent anim" );
return level.scr_anim[ animname ][ anime ];
}
getanim_generic( anime )
{
AssertEx( IsDefined( level.scr_anim[ "generic" ][ anime ] ), "Called getanim_generic on an inexistent anim" );
return level.scr_anim[ "generic" ][ anime ];
}
add_hint_string( name, string, optionalFunc )
{
if ( !isdefined( level.trigger_hint_string ) )
{
level.trigger_hint_string = [];
level.trigger_hint_func = [];
}
AssertEx( IsDefined( name ), "Set a name for the hint string. This should be the same as the script_hint on the trigger_hint." );
AssertEx( IsDefined( string ), "Set a string for the hint string. This is the string you want to appear when the trigger is hit." );
AssertEx( !isdefined( level.trigger_hint_string[ name ] ), "Tried to redefine hint " + name );
level.trigger_hint_string[ name ] = string;
PreCacheString( string );
if ( IsDefined( optionalFunc ) )
{
level.trigger_hint_func[ name ] = optionalFunc;
}
}
show_hint( struct )
{
AssertEx( IsDefined( struct.string ), "Need a localized string associated with the hint" );
thread ShowHintPrint_struct( struct );
}
hide_hint( struct )
{
struct.timeout = true;
}
fire_radius( origin, radius )
{
trigger = Spawn( "trigger_radius", origin, 0, radius, 48 );
for ( ;; )
{
trigger waittill( "trigger", other );
AssertEx( IsPlayer( other ), "Tried to burn a non player in a fire" );
level.player DoDamage( 5, origin );
}
}
clearThreatBias( group1, group2 )
{
SetThreatBias( group1, group2, 0 );
SetThreatBias( group2, group1, 0 );
}
scr_println( msg )
{
PrintLn( msg );
}
ThrowGrenadeAtPlayerASAP()
{
animscripts\combat_utility::ThrowGrenadeAtPlayerASAP_combat_utility();
}
array_combine_keys( array1, array2 )
{
if ( !array1.size )
return array2;
keys = GetArrayKeys( array2 );
for ( i = 0; i < keys.size; i++ )
array1[ keys[ i ] ] = array2[ keys[ i ] ];
return array1;
}
set_ignoreSuppression( val )
{
self.ignoreSuppression = val;
}
set_goalradius( radius )
{
self.goalradius = radius;
}
try_forever_spawn()
{
export = self.export;
for ( ;; )
{
AssertEx( IsDefined( self ), "Spawner with export " + export + " was deleted." );
guy = self DoSpawn();
if ( spawn_failed( guy ) )
{
wait( 1 );
continue;
}
return guy;
}
}
set_allowdeath( val )
{
self.allowdeath = val;
}
set_run_anim( anime, alwaysRunForward )
{
AssertEx( IsDefined( anime ), "Tried to set run anim but didn't specify which animation to ues" );
AssertEx( IsDefined( self.animname ), "Tried to set run anim on a guy that had no anim name" );
AssertEx( IsDefined( level.scr_anim[ self.animname ][ anime ] ), "Tried to set run anim but the anim was not defined in the maps _anim file" );
if ( IsDefined( alwaysRunForward ) )
self.alwaysRunForward = alwaysRunForward;
else
self.alwaysRunForward = true;
self disable_turnAnims();
self.run_overrideanim = level.scr_anim[ self.animname ][ anime ];
self.walk_overrideanim = self.run_overrideanim;
}
set_dog_walk_anim()
{
AssertEx( self.type == "dog" );
self.a.movement = "walk";
self.disablearrivals = true;
self.disableexits = true;
self.script_nobark = 1;
}
set_combat_stand_animset( fire_anim, aim_straight, idle_anim, reload_anim )
{
self animscripts\animset::init_animset_custom_stand( fire_anim, aim_straight, idle_anim, reload_anim );
}
set_move_animset( move_mode, move_anim, sprint_anim )
{
AssertEx( IsDefined( anim.animsets.move[ move_mode ] ), "Default anim set is not defined" );
animset = anim.animsets.move[ move_mode ];
if ( IsArray( move_anim ) )
{
Assert( move_anim.size == 4 );
animset[ "straight" ] = move_anim[ 0 ];
animset[ "move_f" ] = move_anim[ 0 ];
animset[ "move_l" ] = move_anim[ 1 ];
animset[ "move_r" ] = move_anim[ 2 ];
animset[ "move_b" ] = move_anim[ 3 ];
}
else
{
animset[ "straight" ] = move_anim;
animset[ "move_f" ] = move_anim;
}
if ( IsDefined( sprint_anim ) )
animset[ "sprint" ] = sprint_anim;
self.customMoveAnimSet[ move_mode ] = animset;
}
set_generic_idle_anim( anime )
{
AssertEx( IsDefined( anime ), "Tried to set generic idle but didn't specify which animation to ues" );
AssertEx( IsDefined( level.scr_anim[ "generic" ][ anime ] ), "Tried to set generic run anim but the anim was not defined in the maps _anim file" );
idleAnim = level.scr_anim[ "generic" ][ anime ];
if ( IsArray( idleAnim ) )
self.specialIdleAnim = idleAnim;
else
self.specialIdleAnim[ 0 ] = idleAnim;
}
set_idle_anim( anime )
{
AssertEx( IsDefined( self.animname ), "No animname!" );
AssertEx( IsDefined( anime ), "Tried to set idle anim but didn't specify which animation to ues" );
AssertEx( IsDefined( level.scr_anim[ self.animname ][ anime ] ), "Tried to set generic run anim but the anim was not defined in the maps _anim file" );
idleAnim = level.scr_anim[ self.animname ][ anime ];
if ( IsArray( idleAnim ) )
self.specialIdleAnim = idleAnim;
else
self.specialIdleAnim[ 0 ] = idleAnim;
}
clear_generic_idle_anim()
{
self.specialIdleAnim = undefined;
self notify( "stop_specialidle" );
}
set_generic_run_anim( anime, alwaysRunForward )
{
set_generic_run_anim_array( anime, undefined, alwaysRunForward );
}
clear_generic_run_anim()
{
self notify( "movemode" );
self enable_turnAnims();
self.run_overrideanim = undefined;
self.walk_overrideanim = undefined;
}
set_generic_run_anim_array( anime, weights, alwaysRunForward )
{
AssertEx( IsDefined( anime ), "Tried to set generic run anim but didn't specify which animation to ues" );
AssertEx( IsDefined( level.scr_anim[ "generic" ][ anime ] ), "Tried to set generic run anim but the anim was not defined in the maps _anim file" );
AssertEx( !isdefined(weights) || isdefined(level.scr_anim[ "generic" ][weights]), "weights needs to be a valid entry in level.scr_anim" );
AssertEx( !isdefined(weights) || isarray(level.scr_anim[ "generic" ][weights]), "weights needs to be an array of animation weights (ascending order)" );
AssertEx( isarray(level.scr_anim[ "generic" ][anime])
|| !isdefined(weights), "its not valid to pass in a weights param and not an array of anims to run" );
AssertEx( !isdefined(weights) || (level.scr_anim[ "generic" ][weights].size == level.scr_anim[ "generic" ][anime].size), "the weights array must equal the size of the anims array" );
self notify( "movemode" );
if ( !isdefined( alwaysRunForward ) || alwaysRunForward )
self.alwaysRunForward = true;
else
self.alwaysRunForward = undefined;
self disable_turnAnims();
self.run_overrideanim = level.scr_anim[ "generic" ][ anime ];
self.walk_overrideanim = self.run_overrideanim;
if ( IsDefined( weights ) )
{
self.run_override_weights = level.scr_anim[ "generic" ][ weights ];
self.walk_override_weights = self.run_override_weights;
}
else
{
self.run_override_weights = undefined;
self.walk_override_weights = undefined;
}
}
set_run_anim_array( anime, weights, alwaysRunForward )
{
AssertEx( IsDefined( anime ), "Tried to set generic run anim but didn't specify which animation to ues" );
AssertEx( IsDefined( self.animname ), "Tried to set run anim on a guy that had no anim name" );
AssertEx( IsDefined( level.scr_anim[ self.animname ][ anime ] ), "Tried to set run anim but the anim was not defined in the maps _anim file" );
self notify( "movemode" );
if ( !isdefined( alwaysRunForward ) || alwaysRunForward )
self.alwaysRunForward = true;
else
self.alwaysRunForward = undefined;
self disable_turnAnims();
self.run_overrideanim = level.scr_anim[ self.animname ][ anime ];
self.walk_overrideanim = self.run_overrideanim;
if ( IsDefined( weights ) )
{
self.run_override_weights = level.scr_anim[ self.animname ][ weights ];
self.walk_override_weights = self.run_override_weights;
}
else
{
self.run_override_weights = undefined;
self.walk_override_weights = undefined;
}
}
clear_run_anim()
{
self notify( "clear_run_anim" );
self notify( "movemode" );
if ( self.type == "dog" )
{
self.a.movement = "run";
self.disablearrivals = false;
self.disableexits = false;
self.script_nobark = undefined;
return;
}
if ( !isdefined( self.casual_killer ) )
self enable_turnAnims();
self.alwaysRunForward = undefined;
self.run_overrideanim = undefined;
self.walk_overrideanim = undefined;
self.run_override_weights = undefined;
self.walk_override_weights = undefined;
}
debugvar( msg, timer )
{
SetDvarIfUninitialized( msg, timer );
return GetDvarFloat( msg );
}
physicsjolt_proximity( outer_radius, inner_radius, force )
{
self endon( "death" );
self endon( "stop_physicsjolt" );
if ( !isdefined( outer_radius ) || !isdefined( inner_radius ) || !isdefined( force ) )
{
outer_radius = 400;
inner_radius = 256;
force = ( 0, 0, 0.075 );
}
fade_distance = outer_radius * outer_radius;
fade_speed = 3;
base_force = force;
while ( true )
{
wait 0.1;
force = base_force;
if ( self.code_classname == "script_vehicle" )
{
speed = self Vehicle_GetSpeed();
if ( speed < fade_speed )
{
scale = speed / fade_speed;
force = ( base_force* scale );
}
}
dist = DistanceSquared( self.origin, level.player.origin );
scale = fade_distance / dist;
if ( scale > 1 )
scale = 1;
force = ( force* scale );
total_force = force[ 0 ] + force[ 1 ] + force[ 2 ];
if ( total_force > 0.025 )
PhysicsJitter( self.origin, outer_radius, inner_radius, force[ 2 ], force[ 2 ] * 2.0 );
}
}
set_goal_entity( ent )
{
self SetGoalEntity( ent );
}
activate_trigger( name, type, triggeringEnt )
{
if ( !isdefined( name ) )
self activate_trigger_process( triggeringEnt );
else
array_thread( GetEntArray( name, type ), ::activate_trigger_process, triggeringEnt );
}
activate_trigger_process( triggeringEnt )
{
AssertEx( !isdefined( self.trigger_off ), "Tried to activate trigger that is OFF( either from trigger_off or from flags set on it through shift - G menu" );
if ( IsDefined( self.script_color_allies ) )
{
self.activated_color_trigger = true;
maps\_colors::activate_color_trigger( "allies" );
}
if ( IsDefined( self.script_color_axis ) )
{
self.activated_color_trigger = true;
maps\_colors::activate_color_trigger( "axis" );
}
self notify( "trigger", triggeringEnt );
}
self_delete()
{
self Delete();
}
remove_noColor_from_array( ai )
{
newarray = [];
for ( i = 0; i < ai.size; i++ )
{
guy = ai[ i ];
if ( guy has_color() )
newarray[ newarray.size ] = guy;
}
return newarray;
}
has_color()
{
if ( self maps\_colors::get_team() == "axis" )
{
return IsDefined( self.script_color_axis ) || IsDefined( self.script_forcecolor );
}
return IsDefined( self.script_color_allies ) || IsDefined( self.script_forcecolor );
}
clear_colors()
{
clear_team_colors( "axis" );
clear_team_colors( "allies" );
}
clear_team_colors( team )
{
level.currentColorForced[ team ][ "r" ] = undefined;
level.currentColorForced[ team ][ "b" ] = undefined;
level.currentColorForced[ team ][ "c" ] = undefined;
level.currentColorForced[ team ][ "y" ] = undefined;
level.currentColorForced[ team ][ "p" ] = undefined;
level.currentColorForced[ team ][ "o" ] = undefined;
level.currentColorForced[ team ][ "g" ] = undefined;
}
get_script_palette()
{
rgb = [];
rgb[ "r" ] = ( 1, 0, 0 );
rgb[ "o" ] = ( 1, 0.5, 0 );
rgb[ "y" ] = ( 1, 1, 0 );
rgb[ "g" ] = ( 0, 1, 0 );
rgb[ "c" ] = ( 0, 1, 1 );
rgb[ "b" ] = ( 0, 0, 1 );
rgb[ "p" ] = ( 1, 0, 1 );
return rgb;
}
notify_delay( sNotifyString, fDelay )
{
Assert( IsDefined( self ) );
Assert( IsDefined( sNotifyString ) );
Assert( IsDefined( fDelay ) );
self endon( "death" );
if ( fDelay > 0 )
wait fDelay;
if ( !isdefined( self ) )
return;
self notify( sNotifyString );
}
gun_remove()
{
if ( IsAI( self ) )
self animscripts\shared::placeWeaponOn( self.weapon, "none" );
else
self Detach( GetWeaponModel( self.weapon ), "tag_weapon_right" );
}
gun_recall()
{
if ( IsAI( self ) )
self animscripts\shared::placeWeaponOn( self.weapon, "right" );
else
self Attach( GetWeaponModel( self.weapon ), "tag_weapon_right" );
}
place_weapon_on( weapon, location )
{
Assert( IsAI( self ) );
if ( !AIHasWeapon( weapon ) )
animscripts\init::initWeapon( weapon );
animscripts\shared::placeWeaponOn( weapon, location );
}
forceUseWeapon( newWeapon, targetSlot )
{
Assert( IsDefined( newWeapon ) );
Assert( newWeapon != "none" );
Assert( IsDefined( targetSlot ) );
AssertEx( ( targetSlot == "primary" ) || ( targetSlot == "secondary" ) || ( targetSlot == "sidearm" ), "Target slot is either primary, secondary or sidearm." );
if ( !animscripts\init::isWeaponInitialized( newWeapon ) )
animscripts\init::initWeapon( newWeapon );
hasWeapon = ( self.weapon != "none" );
isCurrentSideArm = usingSidearm();
isNewSideArm = ( targetSlot == "sidearm" );
isNewSecondary = ( targetSlot == "secondary" );
if ( hasWeapon && ( isCurrentSideArm != isNewSideArm ) )
{
Assert( self.weapon != newWeapon );
if ( isCurrentSideArm )
holsterTarget = "none";
else if ( isNewSecondary )
holsterTarget = "back";
else
holsterTarget = "chest";
animscripts\shared::placeWeaponOn( self.weapon, holsterTarget );
self.lastWeapon = self.weapon;
}
else
{
self.lastWeapon = newWeapon;
}
animscripts\shared::placeWeaponOn( newWeapon, "right" );
if ( isNewSideArm )
self.sideArm = newWeapon;
else if ( isNewSecondary )
self.secondaryweapon = newWeapon;
else
self.primaryweapon = newWeapon;
self.weapon = newWeapon;
self.bulletsinclip = WeaponClipSize( self.weapon );
self notify( "weapon_switch_done" );
}
lerp_player_view_to_tag( player, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
lerp_player_view_to_tag_internal( player, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, false );
}
lerp_player_view_to_tag_and_hit_geo( player, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
lerp_player_view_to_tag_internal( player, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, true );
}
lerp_player_view_to_position( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo, player )
{
player = get_player_from_self();
linker = Spawn( "script_origin", ( 0, 0, 0 ) );
linker.origin = player.origin;
linker.angles = player GetPlayerAngles();
if ( IsDefined( hit_geo ) && hit_geo )
{
player PlayerLinkTo( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo );
}
else
if ( IsDefined( right_arc ) )
{
player PlayerLinkTo( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc );
}
else
if ( IsDefined( fraction ) )
{
player PlayerLinkTo( linker, "", fraction );
}
else
{
player PlayerLinkTo( linker );
}
linker MoveTo( origin, lerptime, lerptime * 0.25 );
linker RotateTo( angles, lerptime, lerptime * 0.25 );
wait( lerptime );
linker Delete();
}
lerp_player_view_to_tag_oldstyle( player, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
lerp_player_view_to_tag_oldstyle_internal( player, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, false );
}
lerp_player_view_to_position_oldstyle( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo )
{
player = get_player_from_self();
linker = Spawn( "script_origin", ( 0, 0, 0 ) );
linker.origin = player get_player_feet_from_view();
linker.angles = player GetPlayerAngles();
if ( IsDefined( hit_geo ) )
{
player PlayerLinkToDelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo );
}
else
if ( IsDefined( right_arc ) )
{
player PlayerLinkToDelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc );
}
else
if ( IsDefined( fraction ) )
{
player PlayerLinkToDelta( linker, "", fraction );
}
else
{
player PlayerLinkToDelta( linker );
}
linker MoveTo( origin, lerptime, lerptime * 0.25 );
linker RotateTo( angles, lerptime, lerptime * 0.25 );
wait( lerptime );
linker Delete();
}
player_moves( dist )
{
org = level.player.origin;
for ( ;; )
{
if ( Distance( org, level.player.origin ) > dist )
break;
wait( 0.05 );
}
}
waittill_either_function( func1, parm1, func2, parm2 )
{
ent = SpawnStruct();
thread waittill_either_function_internal( ent, func1, parm1 );
thread waittill_either_function_internal( ent, func2, parm2 );
ent waittill( "done" );
}
waittill_msg( msg )
{
self waittill( msg );
}
display_hint( hint, parm1, parm2, parm3 )
{
player = get_player_from_self();
if ( IsDefined( level.trigger_hint_func[ hint ] ) )
{
if ( player [[ level.trigger_hint_func[ hint ] ]]() )
return;
player thread HintPrint( level.trigger_hint_string[ hint ], level.trigger_hint_func[ hint ], parm1, parm2, parm3, 30 );
}
else
{
player thread HintPrint( level.trigger_hint_string[ hint ], undefined, undefined, undefined, undefined, 30 );
}
}
display_hint_timeout( hint, timeout, parm1, parm2, parm3 )
{
player = get_player_from_self();
AssertEx( IsDefined( level.trigger_hint_func[ hint ] ), "Can't have a hint with a timeout if is has no break function, because hints without break functions display for a set period of time." );
if ( player [[ level.trigger_hint_func[ hint ] ]]() )
return;
player thread HintPrint( level.trigger_hint_string[ hint ], level.trigger_hint_func[ hint ], parm1, parm2, parm3, timeout );
}
getGenericAnim( anime )
{
AssertEx( IsDefined( level.scr_anim[ "generic" ][ anime ] ), "Generic anim " + anime + " was not defined in your _anim file." );
return level.scr_anim[ "generic" ][ anime ];
}
enable_careful()
{
AssertEx( IsAI( self ), "Tried to make an ai careful but it wasn't called on an AI" );
self.script_careful = true;
}
disable_careful()
{
AssertEx( IsAI( self ), "Tried to unmake an ai careful but it wasn't called on an AI" );
self.script_careful = false;
self notify( "stop_being_careful" );
}
enable_sprint()
{
AssertEx( IsAI( self ), "Tried to make an ai sprint but it wasn't called on an AI" );
self.sprint = true;
}
disable_sprint()
{
AssertEx( IsAI( self ), "Tried to unmake an ai sprint but it wasn't called on an AI" );
self.sprint = undefined;
}
disable_bulletwhizbyreaction()
{
self.disableBulletWhizbyReaction = true;
}
enable_bulletwhizbyreaction()
{
self.disableBulletWhizbyReaction = undefined;
}
clear_dvar( msg )
{
SetDvar( msg, "" );
}
mission( name )
{
return level.script == name;
}
set_fixednode_true()
{
self.fixednode = true;
}
set_fixednode_false()
{
self.fixednode = false;
}
spawn_ai( bForceSpawn, bMagicBulletShield )
{
if ( IsDefined( self.script_delay_spawn ) )
{
self endon( "death" );
wait( self.script_delay_spawn );
}
spawnedGuy = undefined;
dontShareEnemyInfo = ( IsDefined( self.script_stealth ) && flag( "_stealth_enabled" ) && !flag( "_stealth_spotted" ) );
if ( ( IsDefined( self.script_forcespawn ) ) || ( IsDefined( bForceSpawn ) ) )
{
if ( !isdefined( self.script_drone ) )
spawnedGuy = self StalingradSpawn( dontShareEnemyInfo );
else
spawnedGuy = dronespawn( self );
}
else
{
if ( !isdefined( self.script_drone ) )
spawnedGuy = self DoSpawn( dontShareEnemyInfo );
else
spawnedGuy = dronespawn( self );
}
if ( isdefined(bMagicBulletShield) && bMagicBulletShield && IsAlive( spawnedGuy ) )
spawnedGuy magic_bullet_shield();
if ( !isdefined( self.script_drone ) )
spawn_failed( spawnedGuy );
if( IsDefined( self.script_spawn_once ) )
self Delete();
return spawnedGuy;
}
function_stack( func, param1, param2, param3, param4, param5 )
{
localentity = SpawnStruct();
localentity thread function_stack_proc( self, func, param1, param2, param3, param4, param5 );
return self function_stack_wait_finish( localentity );
}
function_stack_timeout( timeout, func, param1, param2, param3, param4, param5 )
{
localentity = SpawnStruct();
localentity thread function_stack_proc( self, func, param1, param2, param3, param4, param5 );
if ( IsDefined( localentity.function_stack_func_begun ) || ( localentity waittill_any_timeout( timeout, "function_stack_func_begun" ) != "timeout" ) )
{
return self function_stack_wait_finish( localentity );
}
else
{
localentity notify( "death" );
return false;
}
}
function_stack_clear()
{
newstack = [];
if ( IsDefined( self.function_stack[ 0 ] ) && IsDefined( self.function_stack[ 0 ].function_stack_func_begun ) )
newstack[ 0 ] = self.function_stack[ 0 ];
self.function_stack = undefined;
self notify( "clear_function_stack" );
waittillframeend;
if ( !newstack.size )
return;
if ( !newstack[ 0 ].function_stack_func_begun )
return;
self.function_stack = newstack;
}
geo_off()
{
if ( IsDefined( self.geo_off ) )
return;
self.realorigin = self GetOrigin();
self MoveTo( self.realorigin + ( 0, 0, -10000 ), .2 );
self.geo_off = true;
}
geo_on()
{
if ( !isDefined( self.geo_off ) )
return;
self MoveTo( self.realorigin, .2 );
self waittill( "movedone" );
self.geo_off = undefined;
}
disable_exits()
{
self.disableexits = true;
}
enable_exits()
{
self.disableexits = undefined;
}
disable_turnAnims()
{
self.noTurnAnims = true;
}
enable_turnAnims()
{
self.noTurnAnims = undefined;
}
disable_arrivals()
{
self.disablearrivals = true;
}
enable_arrivals()
{
self endon( "death" );
waittillframeend;
self.disablearrivals = undefined;
}
set_blur( magnitude, time )
{
SetBlur( magnitude, time );
}
set_goal_radius( radius )
{
self.goalradius = radius;
}
set_goal_node( node )
{
self.last_set_goalnode = node;
self.last_set_goalpos = undefined;
self.last_set_goalent = undefined;
self SetGoalNode( node );
}
set_goal_node_targetname( targetname )
{
Assert( IsDefined( targetname ) );
node = GetNode( targetname, "targetname" );
Assert( IsDefined( node ) );
self set_goal_node( node );
}
set_goal_pos( origin )
{
self.last_set_goalnode = undefined;
self.last_set_goalpos = origin;
self.last_set_goalent = undefined;
self SetGoalPos( origin );
}
set_goal_ent( target )
{
set_goal_pos( target.origin );
self.last_set_goalent = target;
}
objective_complete( obj )
{
objective_recon( obj );
Objective_State( obj, "done" );
level notify( "objective_complete" + obj );
}
handsignal( xanim, waitAnimDone, ender, waiter )
{
returnImmediate = true;
if ( IsDefined( waitAnimDone ) )
returnImmediate = !waitAnimDone;
if ( IsDefined( ender ) )
level endon( ender );
if ( IsDefined( waiter ) )
level waittill( waiter );
animName = "signal_" + xanim;
if ( self.a.pose == "crouch" )
animName = animName + "_crouch";
else if ( self.script == "cover_right" )
animName = animName + "_coverR";
else if ( self isCQBWalking() )
animName = animName + "_cqb";
if ( returnImmediate )
self SetAnimRestart( getGenericAnim( animName ), 1, 0, 1.1 );
else
self maps\_anim::anim_generic( self, animName );
}
get_guy_with_script_noteworthy_from_spawner( script_noteworthy )
{
spawner = GetEntArray( script_noteworthy, "script_noteworthy" );
AssertEx( spawner.size == 1, "Tried to get guy from spawner but there were zero or multiple spawners" );
guys = array_spawn( spawner );
return guys[ 0 ];
}
get_guy_with_targetname_from_spawner( targetname )
{
spawner = GetEntArray( targetname, "targetname" );
AssertEx( spawner.size == 1, "Tried to get guy from spawner but there were zero or multiple spawners" );
guys = array_spawn( spawner );
return guys[ 0 ];
}
get_guys_with_targetname_from_spawner( targetname )
{
spawners = GetEntArray( targetname, "targetname" );
AssertEx( spawners.size > 0, "Tried to get guy from spawner but there were zero spawners" );
return array_spawn( spawners );
}
array_spawn( spawners, bForceSpawn, skipIncorrectNumberAssert )
{
if ( !isdefined( skipIncorrectNumberAssert ) )
skipIncorrectNumberAssert = 0;
guys = [];
foreach ( spawner in spawners )
{
spawner.count = 1;
if ( GetSubStr( spawner.classname, 7, 10 ) == "veh" )
{
guy = spawner spawn_vehicle();
if ( IsDefined( guy.target ) && !IsDefined( guy.script_moveoverride ) )
guy thread maps\_vehicle::gopath();
guys[ guys.size ] = guy;
}
else
{
guy = spawner spawn_ai( bForceSpawn );
if ( !skipIncorrectNumberAssert )
AssertEx( IsAlive( guy ), "Guy with export " + spawner.export + " failed to spawn." );
guys[ guys.size ] = guy;
}
}
if ( !skipIncorrectNumberAssert )
AssertEx( guys.size == spawners.size, "Didnt spawn correct number of guys" );
return guys;
}
array_spawn_targetname( targetname, forcespawn, skipIncorrectNumberAssert, deleteDronePool )
{
spawners = GetEntArray( targetname, "targetname" );
if ( IsDefined( level.spawn_pool_enabled ) )
{
struct_spawners = getstructarray( targetname, "targetname" );
if ( IsDefined( deleteDronePool ) && deleteDronePool )
deletestructarray_ref( struct_spawners );
pool_spawners = maps\_spawner::get_pool_spawners_from_structarray( struct_spawners );
spawners = array_combine( spawners, pool_spawners );
}
AssertEx( spawners.size, "Tried to spawn spawners with targetname " + targetname + " but there are no spawners" );
return array_spawn( spawners, forcespawn, skipIncorrectNumberAssert );
}
array_spawn_noteworthy( noteworthy, forcespawn, skipIncorrectNumberAssert, deleteDronePool )
{
spawners = GetEntArray( noteworthy, "script_noteworthy" );
if ( IsDefined( level.spawn_pool_enabled ) )
{
struct_spawners = getstructarray( noteworthy, "script_noteworthy" );
if ( IsDefined( deleteDronePool ) && deleteDronePool )
deletestructarray_ref( struct_spawners );
pool_spawners = maps\_spawner::get_pool_spawners_from_structarray( struct_spawners );
spawners = array_combine( spawners, pool_spawners );
}
AssertEx( spawners.size, "Tried to spawn spawners with targetname " + noteworthy + " but there are no spawners" );
return array_spawn( spawners, forcespawn, skipIncorrectNumberAssert );
}
spawn_script_noteworthy( script_noteworthy, bForceSpawn )
{
spawner = GetEnt( script_noteworthy, "script_noteworthy" );
AssertEx( IsDefined( spawner ), "Spawner with script_noteworthy " + script_noteworthy + " does not exist." );
guy = spawner spawn_ai( bForceSpawn );
return guy;
}
spawn_targetname( targetname, bForceSpawn )
{
spawner = GetEnt( targetname, "targetname" );
AssertEx( IsDefined( spawner ), "Spawner with targetname " + targetname + " does not exist." );
guy = spawner spawn_ai( bForceSpawn );
return guy;
}
add_dialogue_line( name, msg, name_color )
{
if ( GetDvarInt( "loc_warnings", 0 ) )
return;
if ( !isdefined( level.dialogue_huds ) )
{
level.dialogue_huds = [];
}
for ( index = 0; ; index++ )
{
if ( !isdefined( level.dialogue_huds[ index ] ) )
break;
}
color = "^3";
if ( IsDefined( name_color ) )
{
switch( name_color )
{
case "r":
case "red":
color = "^1";
break;
case "g":
case "green":
color = "^2";
break;
case "y":
case "yellow":
color = "^3";
break;
case "b":
case "blue":
color = "^4";
break;
case "c":
case "cyan":
color = "^5";
break;
case "p":
case "purple":
color = "^6";
break;
case "w":
case "white":
color = "^7";
break;
case "bl":
case "black":
color = "^8";
break;
}
}
level.dialogue_huds[ index ] = true;
hudelem = maps\_hud_util::createFontString( "default", 1.5 );
hudelem.location = 0;
hudelem.alignX = "left";
hudelem.alignY = "top";
hudelem.foreground = 1;
hudelem.sort = 20;
hudelem.alpha = 0;
hudelem FadeOverTime( 0.5 );
hudelem.alpha = 1;
hudelem.x = 40;
hudelem.y = 260 + index * 18;
hudelem.label = " " + color + "< " + name + " > ^7" + msg;
hudelem.color = ( 1, 1, 1 );
wait( 2 );
timer = 2 * 20;
hudelem FadeOverTime( 6 );
hudelem.alpha = 0;
for ( i = 0; i < timer; i++ )
{
hudelem.color = ( 1, 1, 0 / ( timer - i ) );
wait( 0.05 );
}
wait( 4 );
hudelem Destroy();
level.dialogue_huds[ index ] = undefined;
}
destructible_disable_explosion()
{
self common_scripts\_destructible::disable_explosion();
}
destructible_force_explosion()
{
self common_scripts\_destructible::force_explosion();
}
set_grenadeammo( count )
{
self.grenadeammo = count;
}
get_player_feet_from_view()
{
Assert( IsPlayer( self ) );
tagorigin = self.origin;
upvec = AnglesToUp( self GetPlayerAngles() );
height = self GetPlayerViewHeight();
player_eye = tagorigin + ( 0, 0, height );
player_eye_fake = tagorigin + ( upvec*height );
diff_vec = player_eye - player_eye_fake;
fake_origin = tagorigin + diff_vec;
return fake_origin;
}
set_baseaccuracy( val )
{
self.baseaccuracy = val;
}
set_console_status()
{
if ( !isdefined( level.Console ) )
level.Console = GetDvar( "consoleGame" ) == "true";
else
AssertEx( level.Console == ( GetDvar( "consoleGame" ) == "true" ), "Level.console got set incorrectly." );
if ( !isdefined( level.xenon ) )
level.xenon = GetDvar( "xenonGame" ) == "true";
else
AssertEx( level.xenon == ( GetDvar( "xenonGame" ) == "true" ), "Level.xenon got set incorrectly." );
if ( !isdefined( level.ps3 ) )
level.ps3 = GetDvar( "ps3Game" ) == "true";
else
AssertEx( level.ps3 == ( GetDvar( "ps3Game" ) == "true" ), "Level.ps3 got set incorrectly." );
}
autosave_now( suppress_print )
{
return maps\_autosave::_autosave_game_now( suppress_print );
}
autosave_now_silent()
{
return maps\_autosave::_autosave_game_now( true );
}
set_generic_deathanim( deathanim )
{
self.deathanim = getGenericAnim( deathanim );
}
set_deathanim( deathanim )
{
self.deathanim = getanim( deathanim );
}
clear_deathanim()
{
self.deathanim = undefined;
}
hunted_style_door_open( soundalias )
{
wait( 1.75 );
if ( IsDefined( soundalias ) )
self PlaySound( soundalias );
else
self PlaySound( "door_wood_slow_open" );
self RotateTo( self.angles + ( 0, 70, 0 ), 2, .5, 0 );
self ConnectPaths();
self waittill( "rotatedone" );
self RotateTo( self.angles + ( 0, 40, 0 ), 2, 0, 2 );
}
palm_style_door_open( soundalias )
{
wait( 1.35 );
if ( IsDefined( soundalias ) )
self PlaySound( soundalias );
else
self PlaySound( "door_wood_slow_open" );
self RotateTo( self.angles + ( 0, 70, 0 ), 2, .5, 0 );
self ConnectPaths();
self waittill( "rotatedone" );
self RotateTo( self.angles + ( 0, 40, 0 ), 2, 0, 2 );
}
lerp_fov_overtime( time, destfov )
{
foreach( player in level.players )
player LerpFOV( destfov, time );
wait time;
}
lerp_fovscale_overtime( time, destfovscale )
{
basefov = GetDvarFloat( "cg_fovscale" );
incs = Int( time / .05 );
incfov = ( destfovscale - basefov ) / incs ;
currentfov = basefov;
for ( i = 0; i < incs; i++ )
{
currentfov += incfov;
SetSavedDvar( "cg_fovscale", currentfov );
wait .05;
}
SetSavedDvar( "cg_fovscale", destfovscale );
}
putGunAway()
{
animscripts\shared::placeWeaponOn( self.weapon, "none" );
self.weapon = "none";
}
apply_fog()
{
maps\_load::set_fog_progress( 0 );
}
apply_end_fog()
{
maps\_load::set_fog_progress( 1 );
}
anim_stopanimscripted()
{
self StopAnimScripted();
self notify( "stop_loop" );
self notify( "single anim", "end" );
self notify( "looping anim", "end" );
}
disable_pain()
{
AssertEx( IsAI( self ), "Tried to disable pain on a non ai" );
self.a.disablePain = true;
self.allowPain = false;
}
enable_pain()
{
AssertEx( IsAI( self ), "Tried to enable pain on a non ai" );
self.a.disablePain = false;
self.allowPain = true;
}
_delete()
{
self Delete();
}
_kill()
{
self Kill();
}
kill_wrapper()
{
if ( isplayer( self ) )
{
if ( flag_exist( "special_op_terminated" ) && flag( "special_op_terminated" ) )
{
return false;
}
if ( is_player_down( self ) )
{
self disableinvulnerability();
}
}
self EnableDeathShield( false );
self kill();
return true;
}
_setentitytarget( target )
{
self SetEntityTarget( target );
}
_ClearEntityTarget()
{
self ClearEntityTarget();
}
_unlink()
{
self Unlink();
}
disable_oneshotfx_with_noteworthy( noteworthy )
{
AssertEx( IsDefined( level._global_fx_ents[ noteworthy ] ), "No _global_fx ents have noteworthy " + noteworthy );
keys = GetArrayKeys( level._global_fx_ents[ noteworthy ] );
for ( i = 0; i < keys.size; i++ )
{
level._global_fx_ents[ noteworthy ][ keys[ i ] ].looper Delete();
level._global_fx_ents[ noteworthy ][ keys[ i ] ] = undefined;
}
}
_setLightIntensity( val )
{
self SetLightIntensity( val );
}
_linkto( targ, tag, org, angles )
{
if ( IsDefined( angles ) )
{
self LinkTo( targ, tag, org, angles );
return;
}
if ( IsDefined( org ) )
{
self LinkTo( targ, tag, org );
return;
}
if ( IsDefined( tag ) )
{
self LinkTo( targ, tag );
return;
}
self LinkTo( targ );
}
array_wait( array, msg, timeout )
{
keys = GetArrayKeys( array );
structs = [];
for ( i = 0; i < keys.size; i++ )
{
key = keys[ i ];
}
for ( i = 0; i < keys.size; i++ )
{
key = keys[ i ];
structs[ key ] = SpawnStruct();
structs[ key ]._array_wait = true;
structs[ key ] thread array_waitlogic1( array[ key ], msg, timeout );
}
for ( i = 0; i < keys.size; i++ )
{
key = keys[ i ];
if ( IsDefined( array[ key ] ) && structs[ key ]._array_wait )
structs[ key ] waittill( "_array_wait" );
}
}
die()
{
self Kill( ( 0, 0, 0 ) );
}
getmodel( str )
{
AssertEx( IsDefined( level.scr_model[ str ] ), "Tried to getmodel on model " + str + " but level.scr_model[ " + str + " was not defined." );
return level.scr_model[ str ];
}
isADS()
{
Assert( IsPlayer( self ) );
return( self PlayerAds() > 0.5 );
}
enable_auto_adjust_threatbias()
{
level.auto_adjust_threatbias = true;
if ( level.gameskill >= 2 )
{
level.player.threatbias = Int( maps\_gameskill::get_locked_difficulty_val_player( "threatbias", 1 ) );
return;
}
level.auto_adjust_difficulty_frac = GetDvarInt( "autodifficulty_frac" );
current_frac = level.auto_adjust_difficulty_frac * 0.01;
level.player.threatbias = Int( maps\_gameskill::get_blended_difficulty( "threatbias", current_frac ) );
}
disable_auto_adjust_threatbias()
{
level.auto_adjust_threatbias = false;
}
disable_replace_on_death()
{
self.replace_on_death = undefined;
self notify( "_disable_reinforcement" );
}
waittill_player_lookat( dot, timer, dot_only, timeout, ignore_ent, player )
{
if ( !isdefined( player ) )
player = level.player;
timeoutEnt = SpawnStruct();
if ( IsDefined( timeout ) )
timeoutEnt thread notify_delay( "timeout", timeout );
timeoutEnt endon( "timeout" );
if ( !isdefined( dot ) )
dot = 0.92;
if ( !isdefined( timer ) )
timer = 0;
base_time = Int( timer * 20 );
count = base_time;
self endon( "death" );
ai_guy = IsAI( self );
org = undefined;
for ( ;; )
{
if ( ai_guy )
org = self GetEye();
else
org = self.origin;
if ( player player_looking_at( org, dot, dot_only, ignore_ent ) )
{
count--;
if ( count <= 0 )
return true;
}
else
{
count = base_time;
}
wait( 0.05 );
}
}
waittill_player_lookat_for_time( timer, dot, dot_only, ignore_ent )
{
AssertEx( IsDefined( timer ), "Tried to do waittill_player_lookat_for_time with no time parm." );
waittill_player_lookat( dot, timer, dot_only, undefined, ignore_ent );
}
player_looking_at( start, dot, dot_only, ignore_ent )
{
if ( !isdefined( dot ) )
dot = 0.8;
player = get_player_from_self();
end = player GetEye();
angles = VectorToAngles( start - end );
forward = AnglesToForward( angles );
player_angles = player GetPlayerAngles();
player_forward = AnglesToForward( player_angles );
new_dot = VectorDot( forward, player_forward );
if ( new_dot < dot )
{
return false;
}
if ( IsDefined( dot_only ) )
{
AssertEx( dot_only, "dot_only must be true or undefined" );
return true;
}
trace = BulletTrace( start, end, false, ignore_ent );
return trace[ "fraction" ] == 1;
}
players_looking_at( org, dot, dot_only, ignore_ent )
{
for ( i = 0; i < level.players.size; i++ )
{
if ( !level.players[ i ] player_looking_at( org, dot, dot_only, ignore_ent ) )
return false;
}
return true;
}
either_player_looking_at( org, dot, dot_only, ignore_ent )
{
for ( i = 0; i < level.players.size; i++ )
{
if ( level.players[ i ] player_looking_at( org, dot, dot_only, ignore_ent ) )
return true;
}
return false;
}
player_can_see_ai( ai, latency )
{
currentTime = getTime();
if ( !isdefined( latency ) )
latency = 0;
if ( isdefined( ai.playerSeesMeTime ) && ai.playerSeesMeTime + latency >= currentTime )
{
assert( isdefined( ai.playerSeesMe ) );
return ai.playerSeesMe;
}
ai.playerSeesMeTime = currentTime;
if ( !within_fov( level.player.origin, level.player.angles, ai.origin, 0.766 ) )
{
ai.playerSeesMe = false;
return false;
}
playerEye = level.player GetEye();
feetOrigin = ai.origin;
if ( SightTracePassed( playerEye, feetOrigin, true, level.player, ai ) )
{
ai.playerSeesMe = true;
return true;
}
eyeOrigin = ai GetEye();
if ( SightTracePassed( playerEye, eyeOrigin, true, level.player, ai ) )
{
ai.playerSeesMe = true;
return true;
}
midOrigin = ( eyeOrigin + feetOrigin ) * 0.5;
if ( SightTracePassed( playerEye, midOrigin, true, level.player, ai ) )
{
ai.playerSeesMe = true;
return true;
}
ai.playerSeesMe = false;
return false;
}
players_within_distance( fDist, org )
{
fDistSquared = fDist * fDist;
for ( i = 0; i < level.players.size; i++ )
{
if ( DistanceSquared( org, level.players[ i ].origin ) < fDistSquared )
return true;
}
return false;
}
AI_delete_when_out_of_sight( aAI_to_delete, fDist )
{
if ( !isdefined( aAI_to_delete ) )
return;
off_screen_dot = 0.75;
if ( IsSplitScreen() )
{
off_screen_dot = 0.65;
}
while ( aAI_to_delete.size > 0 )
{
wait( 1 );
for ( i = 0; i < aAI_to_delete.size; i++ )
{
if ( ( !isdefined( aAI_to_delete[ i ] ) ) || ( !isalive( aAI_to_delete[ i ] ) ) )
{
aAI_to_delete = array_remove( aAI_to_delete, aAI_to_delete[ i ] );
continue;
}
if ( players_within_distance( fDist, aAI_to_delete[ i ].origin ) )
continue;
if ( either_player_looking_at( aAI_to_delete[ i ].origin + ( 0, 0, 48 ), off_screen_dot, true ) )
continue;
if ( IsDefined( aAI_to_delete[ i ].magic_bullet_shield ) )
aAI_to_delete[ i ] stop_magic_bullet_shield();
aAI_to_delete[ i ] Delete();
aAI_to_delete = array_remove( aAI_to_delete, aAI_to_delete[ i ] );
}
}
}
add_wait( func, parm1, parm2, parm3 )
{
ent = SpawnStruct();
ent.caller = self;
ent.func = func;
ent.parms = [];
if ( IsDefined( parm1 ) )
{
ent.parms[ ent.parms.size ] = parm1;
}
if ( IsDefined( parm2 ) )
{
ent.parms[ ent.parms.size ] = parm2;
}
if ( IsDefined( parm3 ) )
{
ent.parms[ ent.parms.size ] = parm3;
}
level.wait_any_func_array[ level.wait_any_func_array.size ] = ent;
}
add_abort( func, parm1, parm2, parm3 )
{
ent = SpawnStruct();
ent.caller = self;
ent.func = func;
ent.parms = [];
if ( IsDefined( parm1 ) )
{
ent.parms[ ent.parms.size ] = parm1;
}
if ( IsDefined( parm2 ) )
{
ent.parms[ ent.parms.size ] = parm2;
}
if ( IsDefined( parm3 ) )
{
ent.parms[ ent.parms.size ] = parm3;
}
level.abort_wait_any_func_array[ level.abort_wait_any_func_array.size ] = ent;
}
add_func( func, parm1, parm2, parm3, parm4, parm5 )
{
ent = SpawnStruct();
ent.caller = self;
ent.func = func;
ent.parms = [];
if ( IsDefined( parm1 ) )
{
ent.parms[ ent.parms.size ] = parm1;
}
if ( IsDefined( parm2 ) )
{
ent.parms[ ent.parms.size ] = parm2;
}
if ( IsDefined( parm3 ) )
{
ent.parms[ ent.parms.size ] = parm3;
}
if ( IsDefined( parm4 ) )
{
ent.parms[ ent.parms.size ] = parm4;
}
if ( IsDefined( parm5 ) )
{
ent.parms[ ent.parms.size ] = parm5;
}
level.run_func_after_wait_array[ level.run_func_after_wait_array.size ] = ent;
}
add_call( func, parm1, parm2, parm3, parm4, parm5 )
{
ent = SpawnStruct();
ent.caller = self;
ent.func = func;
ent.parms = [];
if ( IsDefined( parm1 ) )
{
ent.parms[ ent.parms.size ] = parm1;
}
if ( IsDefined( parm2 ) )
{
ent.parms[ ent.parms.size ] = parm2;
}
if ( IsDefined( parm3 ) )
{
ent.parms[ ent.parms.size ] = parm3;
}
if ( IsDefined( parm4 ) )
{
ent.parms[ ent.parms.size ] = parm4;
}
if ( IsDefined( parm5 ) )
{
ent.parms[ ent.parms.size ] = parm5;
}
level.run_call_after_wait_array[ level.run_call_after_wait_array.size ] = ent;
}
add_noself_call( func, parm1, parm2, parm3, parm4, parm5 )
{
ent = SpawnStruct();
ent.func = func;
ent.parms = [];
if ( IsDefined( parm1 ) )
{
ent.parms[ ent.parms.size ] = parm1;
}
if ( IsDefined( parm2 ) )
{
ent.parms[ ent.parms.size ] = parm2;
}
if ( IsDefined( parm3 ) )
{
ent.parms[ ent.parms.size ] = parm3;
}
if ( IsDefined( parm4 ) )
{
ent.parms[ ent.parms.size ] = parm4;
}
if ( IsDefined( parm5 ) )
{
ent.parms[ ent.parms.size ] = parm5;
}
level.run_noself_call_after_wait_array[ level.run_noself_call_after_wait_array.size ] = ent;
}
add_endon( name )
{
ent = SpawnStruct();
ent.caller = self;
ent.ender = name;
level.do_wait_endons_array[ level.do_wait_endons_array.size ] = ent;
}
do_wait_any()
{
AssertEx( IsDefined( level.wait_any_func_array ), "Tried to do a do_wait without addings funcs first" );
AssertEx( level.wait_any_func_array.size > 0, "Tried to do a do_wait without addings funcs first" );
do_wait( level.wait_any_func_array.size - 1 );
}
do_wait( count_to_reach )
{
if ( !isdefined( count_to_reach ) )
count_to_reach = 0;
AssertEx( IsDefined( level.wait_any_func_array ), "Tried to do a do_wait without addings funcs first" );
ent = SpawnStruct();
array = level.wait_any_func_array;
endons = level.do_wait_endons_array;
after_array = level.run_func_after_wait_array;
call_array = level.run_call_after_wait_array;
nscall_array = level.run_noself_call_after_wait_array;
abort_array = level.abort_wait_any_func_array;
level.wait_any_func_array = [];
level.run_func_after_wait_array = [];
level.do_wait_endons_array = [];
level.abort_wait_any_func_array = [];
level.run_call_after_wait_array = [];
level.run_noself_call_after_wait_array = [];
ent.count = array.size;
ent array_levelthread( array, ::waittill_func_ends, endons );
ent thread do_abort( abort_array );
ent endon( "any_funcs_aborted" );
for ( ;; )
{
if ( ent.count <= count_to_reach )
break;
ent waittill( "func_ended" );
}
ent notify( "all_funcs_ended" );
array_levelthread( after_array, ::exec_func, [] );
array_levelthread( call_array, ::exec_call );
array_levelthread( nscall_array, ::exec_call_noself );
}
do_funcs()
{
AssertEx( IsDefined( level.wait_any_func_array ), "Tried to do a do_wait without addings funcs first" );
ent = SpawnStruct();
AssertEx( !level.wait_any_func_array.size, "Don't use add_wait and do_funcs together." );
AssertEx( !level.do_wait_endons_array.size, "Don't use add_endon and do_funcs together." );
AssertEx( !level.run_call_after_wait_array.size, "Don't use add_call and do_funcs together." );
AssertEx( !level.run_noself_call_after_wait_array.size, "Don't use add_call and do_funcs together." );
AssertEx( !level.abort_wait_any_func_array.size, "Do_funcs doesn't support add_abort." );
after_array = level.run_func_after_wait_array;
level.run_func_after_wait_array = [];
foreach ( func_struct in after_array )
{
level exec_func( func_struct, [] );
}
ent notify( "all_funcs_ended" );
}
is_default_start()
{
if( isdefined( level.forced_start_catchup ) && level.forced_start_catchup == true )
return false;
if ( IsDefined( level.default_start_override ) && level.default_start_override == level.start_point )
return true;
if ( IsDefined( level.default_start ) )
return level.start_point == "default";
if ( level_has_start_points() )
return level.start_point == level.start_functions[ 0 ][ "name" ];
return level.start_point == "default";
}
force_start_catchup()
{
level.forced_start_catchup = true;
}
is_first_start()
{
if ( !level_has_start_points() )
return true;
return level.start_point == level.start_functions[ 0 ][ "name" ];
}
is_after_start( name )
{
hit_current_start = false;
if( level.start_point == name )
return false;
for ( i = 0; i < level.start_functions.size; i++ )
{
if ( level.start_functions[ i ][ "name" ] == name )
{
hit_current_start = true;
continue;
}
if( level.start_functions[ i ][ "name" ] == level.start_point )
return hit_current_start;
}
}
_Earthquake( scale, duration, source, radius )
{
Earthquake( scale, duration, source, radius );
}
waterfx( endflag, soundalias )
{
self endon( "death" );
play_sound = false;
if ( IsDefined( soundalias ) )
play_sound = true;
if ( IsDefined( endflag ) )
{
flag_assert( endflag );
level endon( endflag );
}
for ( ;; )
{
wait( RandomFloatRange( 0.15, 0.3 ) );
start = self.origin + ( 0, 0, 150 );
end = self.origin - ( 0, 0, 150 );
trace = BulletTrace( start, end, false, undefined );
if ( trace[ "surfacetype" ] != "water" )
continue;
fx = "water_movement";
if ( IsPlayer( self ) )
{
if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) < 5 )
{
fx = "water_stop";
}
}
else if ( IsDefined( level._effect[ "water_" + self.a.movement ] ) )
{
fx = "water_" + self.a.movement;
}
water_fx = getfx( fx );
start = trace[ "position" ];
angles = (0,self.angles[1],0);
forward = anglestoforward( angles );
up = anglestoup( angles );
PlayFX( water_fx, start, up, forward );
if ( fx != "water_stop" && play_sound )
thread play_sound_in_space( soundalias, start );
}
}
playerSnowFootsteps( endflag )
{
if ( IsDefined( endflag ) )
{
flag_assert( endflag );
level endon( endflag );
}
for ( ;; )
{
wait( RandomFloatRange( 0.25, .5 ) );
start = self.origin + ( 0, 0, 0 );
end = self.origin - ( 0, 0, 5 );
trace = BulletTrace( start, end, false, undefined );
forward = AnglesToForward( self.angles );
mydistance = Distance( self GetVelocity(), ( 0, 0, 0 ) );
if ( IsDefined( self.vehicle ) )
continue;
if ( trace[ "surfacetype" ] != "snow" )
continue;
if ( mydistance <= 10 )
continue;
fx = "snow_movement";
if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) <= 154 )
{
PlayFX( getfx( "footstep_snow_small" ), trace[ "position" ], trace[ "normal" ], forward );
}
if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) > 154 )
{
PlayFX( getfx( "footstep_snow" ), trace[ "position" ], trace[ "normal" ], forward );
}
}
}
mix_up( sound )
{
timer = 3 * 20;
for ( i = 0; i < timer; i++ )
{
self SetSoundBlend( sound, sound + "_off", ( timer - i ) / timer );
wait( 0.05 );
}
}
mix_down( sound )
{
timer = 3 * 20;
for ( i = 0; i < timer; i++ )
{
self SetSoundBlend( sound, sound + "_off", i / timer );
wait( 0.05 );
}
}
manual_linkto( entity, offset )
{
entity endon( "death" );
self endon( "death" );
if ( !isdefined( offset ) )
{
offset = ( 0, 0, 0 );
}
for ( ;; )
{
self.origin = entity.origin + offset;
self.angles = entity.angles;
wait( 0.05 );
}
}
nextmission()
{
mission_recon();
maps\_endmission::_nextmission();
}
make_array( index1, index2, index3, index4, index5 )
{
AssertEx( IsDefined( index1 ), "Need to define index 1 at least" );
array = [];
array[ array.size ] = index1;
if ( IsDefined( index2 ) )
{
array[ array.size ] = index2;
}
if ( IsDefined( index3 ) )
{
array[ array.size ] = index3;
}
if ( IsDefined( index4 ) )
{
array[ array.size ] = index4;
}
if ( IsDefined( index5 ) )
{
array[ array.size ] = index5;
}
return array;
}
fail_on_friendly_fire()
{
level.failOnFriendlyFire = true;
}
normal_friendly_fire_penalty()
{
level.failOnFriendlyFire = false;
}
getPlayerClaymores()
{
Assert( IsPlayer( self ) );
heldweapons = self GetWeaponsListAll();
stored_ammo = [];
for ( i = 0; i < heldweapons.size; i++ )
{
weapon = heldweapons[ i ];
stored_ammo[ weapon ] = self GetWeaponAmmoClip( weapon );
}
claymoreCount = 0;
if ( IsDefined( stored_ammo[ "claymore" ] ) && stored_ammo[ "claymore" ] > 0 )
{
claymoreCount = stored_ammo[ "claymore" ];
}
return claymoreCount;
}
getPlayerC4()
{
Assert( IsPlayer( self ) );
heldweapons = self GetWeaponsListAll();
stored_ammo = [];
for ( i = 0; i < heldweapons.size; i++ )
{
weapon = heldweapons[ i ];
stored_ammo[ weapon ] = self GetWeaponAmmoClip( weapon );
}
c4Count = 0;
if ( IsDefined( stored_ammo[ "c4" ] ) && stored_ammo[ "c4" ] > 0 )
{
c4Count = stored_ammo[ "c4" ];
}
return c4Count;
}
_wait( timer )
{
wait( timer );
}
_waittillmatch( msg, match )
{
self waittillmatch( msg, match );
}
_setsaveddvar( var, val )
{
SetSavedDvar( var, val );
}
lerp_savedDvar( name, value, time )
{
curr = GetDvarFloat( name );
range = value - curr;
interval = .05;
count = Int( time / interval );
delta = range / count;
while ( count )
{
curr += delta;
SetSavedDvar( name, curr );
wait interval;
count--;
}
SetSavedDvar( name, value );
}
giveachievement_wrapper( achievement )
{
if ( is_demo() )
{
return;
}
if( level.script == "ending" && isdefined( level.level_mode ) && level.level_mode == "free" )
return;
foreach ( player in level.players )
{
player GiveAchievement( achievement );
}
}
player_giveachievement_wrapper( achievement )
{
if ( is_demo() )
{
return;
}
if( level.script == "ending" && isdefined( level.level_mode ) && level.level_mode == "free" )
return;
self GiveAchievement( achievement );
}
add_jav_glow( optional_glow_delete_flag )
{
jav_glow = Spawn( "script_model", ( 0, 0, 0 ) );
jav_glow SetContents( 0 );
jav_glow SetModel( "weapon_javelin_obj" );
jav_glow.origin = self.origin;
jav_glow.angles = self.angles;
self add_wait( ::delete_on_not_defined );
if ( IsDefined( optional_glow_delete_flag ) )
{
flag_assert( optional_glow_delete_flag );
add_wait( ::flag_wait, optional_glow_delete_flag );
}
do_wait_any();
jav_glow Delete();
}
add_c4_glow( optional_glow_delete_flag )
{
c4_glow = Spawn( "script_model", ( 0, 0, 0 ) );
c4_glow SetContents( 0 );
c4_glow SetModel( "weapon_c4_obj" );
c4_glow.origin = self.origin;
c4_glow.angles = self.angles;
self add_wait( ::delete_on_not_defined );
if ( IsDefined( optional_glow_delete_flag ) )
{
flag_assert( optional_glow_delete_flag );
add_wait( ::flag_wait, optional_glow_delete_flag );
}
do_wait_any();
c4_glow Delete();
}
delete_on_not_defined()
{
for ( ;; )
{
if ( !isdefined( self ) )
return;
wait( 0.05 );
}
}
slowmo_start()
{
}
slowmo_end()
{
}
slowmo_setspeed_slow( speed )
{
level.slowmo.speed_slow = speed;
}
slowmo_setspeed_norm( speed )
{
level.slowmo.speed_norm = speed;
}
slowmo_setlerptime_in( time )
{
level.slowmo.lerp_time_in = time;
}
slowmo_setlerptime_out( time )
{
level.slowmo.lerp_time_out = time;
}
slowmo_lerp_in()
{
if(IsDefined(level.no_slowmo) && level.no_slowmo)
return;
SetSlowMotion( level.slowmo.speed_norm, level.slowmo.speed_slow, level.slowmo.lerp_time_in );
}
slowmo_lerp_out()
{
if(IsDefined(level.no_slowmo) && level.no_slowmo)
return;
setslowmotion( level.slowmo.speed_slow, level.slowmo.speed_norm, level.slowmo.lerp_time_out );
}
add_earthquake( name, mag, duration, radius )
{
level.earthquake[ name ][ "magnitude" ] = mag;
level.earthquake[ name ][ "duration" ] = duration;
level.earthquake[ name ][ "radius" ] = radius;
}
arcadeMode_kill( origin, damage_type, amount )
{
if ( GetDvar( "arcademode" ) != "1" )
return;
thread maps\_arcademode::arcadeMode_add_points( origin, true, damage_type, amount );
}
arcadeMode_damage( origin, damage_type, amount )
{
if ( GetDvar( "arcademode" ) != "1" )
return;
thread maps\_arcademode::arcadeMode_add_points( origin, false, damage_type, amount );
}
arcademode_checkpoint( time_remaining, unique_id )
{
if ( 1 )
return;
if ( GetDvar( "arcademode" ) != "1" )
return;
id = maps\_arcadeMode::arcademode_checkpoint_getid( unique_id );
if ( !isdefined( id ) )
{
id = level.arcadeMode_checkpoint_dvars.size;
level.arcadeMode_checkpoint_dvars[ level.arcadeMode_checkpoint_dvars.size ] = unique_id;
AssertEx( level.arcadeMode_checkpoint_dvars.size <= level.arcadeMode_checkpoint_max, "Exceeded max number of arcademode checkpoints." );
}
if ( GetDvar( "arcademode_checkpoint_" + id ) == "1" )
return;
SetDvar( "arcademode_checkpoint_" + id, "1" );
if ( GetDvar( "arcademode_full" ) == "1" )
{
if ( level.gameskill == 2 )
time_remaining *= 2.0;
if ( level.gameskill == 3 )
time_remaining *= 2.5;
}
remaining_time = GetDvarInt( "arcademode_time" );
stored_time = GetDvarInt( "arcademode_stored_time" );
stored_time += remaining_time;
SetDvar( "arcademode_stored_time", stored_time );
SetDvar( "arcademode_time", time_remaining * 60 );
start_offset = 800;
movetime = 0.8;
level.player thread play_sound_in_space( "arcademode_checkpoint", level.player GetEye() );
thread maps\_arcademode::draw_checkpoint( start_offset, movetime, 1 );
thread maps\_arcademode::draw_checkpoint( start_offset, movetime, -1 );
}
arcadeMode()
{
return GetDvar( "arcademode" ) == "1";
}
arcadeMode_stop_timer()
{
if ( !isdefined( level.arcadeMode_hud_timer ) )
return;
level notify( "arcadeMode_remove_timer" );
level.arcademode_stoptime = GetTime();
level.arcadeMode_hud_timer Destroy();
level.arcadeMode_hud_timer = undefined;
}
MusicPlayWrapper( song, timescale, overrideCheat )
{
level.last_song = song;
if ( !arcadeMode() || !flag( "arcadeMode_multiplier_maxed" ) )
{
if ( !isdefined( timescale ) )
timescale = true;
if ( !isdefined( overrideCheat ) )
overrideCheat = false;
MusicStop( 0 );
MusicPlay( song, 0, 1.0, true, overrideCheat );
}
}
music_loop( name, time, fade_time, timescale, overrideCheat )
{
thread music_loop_internal( name, time, fade_time, timescale, overrideCheat );
}
music_loop_stealth( name, length, fade_time, timescale, overrideCheat )
{
thread music_loop_internal( name, length, fade_time, timescale, overrideCheat, true );
}
music_play( name, fade_time, timescale, overrideCheat )
{
if ( IsDefined( fade_time ) && fade_time > 0 )
{
thread music_play_internal_stop_with_fade_then_call( name, fade_time, timescale, overrideCheat );
return;
}
music_stop();
MusicPlayWrapper( name, timescale, overrideCheat );
}
music_stop( fade_time )
{
if ( !isdefined( fade_time ) || fade_time <= 0 )
MusicStop();
else
MusicStop( fade_time );
level notify( "stop_music" );
}
player_is_near_live_grenade()
{
grenades = GetEntArray( "grenade", "classname" );
for ( i = 0; i < grenades.size; i++ )
{
grenade = grenades[ i ];
if ( grenade.model == "weapon_claymore" )
continue;
for ( playerIndex = 0; playerIndex < level.players.size; playerIndex++ )
{
player = level.players[ playerIndex ];
if ( DistanceSquared( grenade.origin, player.origin ) < ( 275 * 275 ) )
{
return true;
}
}
}
return false;
}
player_died_recently()
{
return GetDvarInt( "player_died_recently", "0" ) > 0;
}
all_players_istouching( eVolume )
{
AssertEx( IsDefined( eVolume ), "eVolume parameter not defined" );
foreach ( player in level.players )
{
if ( !player IsTouching( eVolume ) )
return false;
}
return true;
}
any_players_istouching( eVolume )
{
AssertEx( IsDefined( eVolume ), "eVolume parameter not defined" );
foreach ( player in level.players )
{
if ( player IsTouching( eVolume ) )
return true;
}
return false;
}
get_ent_closest_to_flag_trig( sFlagName, aEnts )
{
AssertEx( IsDefined( sFlagName ), "You need to specify the name of the script_flag key for this function" );
AssertEx( IsDefined( aEnts ), "You need to specify the array of entities you want to check" );
AssertEx( aEnts.size > 0, "The array passed is empty" );
if ( aEnts.size == 1 )
return aEnts[ 0 ];
flag_trig = undefined;
eEnt = undefined;
trigs = GetEntArray( "trigger_multiple", "classname" );
for ( i = 0; i < trigs.size; i++ )
{
if ( ( IsDefined( trigs[ i ].script_flag ) ) && ( trigs[ i ].script_flag == sFlagName ) )
{
flag_trig = trigs[ i ];
break;
}
}
AssertEx( IsDefined( flag_trig ), "Cannot find a flag trigger with the script_flag name of :" + sFlagName );
eEnt = getClosest( flag_trig.origin, aEnts );
AssertEx( IsDefined( eEnt ), "Could not determine which entity was closest to flag trigger " + sFlagName );
return eEnt;
}
getDifficulty()
{
Assert( IsDefined( level.gameskill ) );
if ( level.gameskill < 1 )
return "easy";
if ( level.gameskill < 2 )
return "medium";
if ( level.gameskill < 3 )
return "hard";
return "fu";
}
hide_players( qBool )
{
for ( i = 0; i < level.players.size; i++ )
{
if ( qBool == true )
level.players[ i ] Hide();
else
level.players[ i ] Show();
}
}
SetModelFunc( modelFunc, starts_off )
{
if ( !isdefined( starts_off ) )
starts_off = false;
thread maps\_loadout::UpdateModel( modelFunc );
}
getAveragePlayerOrigin()
{
averageOrigin_x = 0;
averageOrigin_y = 0;
averageOrigin_z = 0;
foreach ( player in level.players )
{
averageOrigin_x += player.origin[ 0 ];
averageOrigin_y += player.origin[ 1 ];
averageOrigin_z += player.origin[ 2 ];
}
averageOrigin_x = averageOrigin_x / level.players.size;
averageOrigin_y = averageOrigin_y / level.players.size;
averageOrigin_z = averageOrigin_z / level.players.size;
return( averageOrigin_x, averageOrigin_y, averageOrigin_z );
}
get_average_origin( array )
{
origin = ( 0, 0, 0 );
foreach ( member in array )
origin += member.origin;
return origin * ( 1.0 / array.size ) ;
}
generic_damage_think()
{
self.damage_functions = [];
for ( ;; )
{
self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
foreach ( func in self.damage_functions )
{
thread [[ func ]]( damage, attacker, direction_vec, point, type, modelName, tagName );
}
}
}
add_damage_function( func )
{
self.damage_functions[ self.damage_functions.size ] = func;
}
remove_damage_function( damage_func )
{
new_array = [];
foreach ( func in self.damage_functions )
{
if ( func == damage_func )
continue;
new_array[ new_array.size ] = func;
}
self.damage_functions = new_array;
}
giveXp( type, value )
{
self maps\_rank::updatePlayerScore( type, value );
}
playLocalSoundWrapper( alias )
{
Assert( IsDefined( alias ) );
self PlayLocalSound( alias );
}
enablePlayerWeapons( bool )
{
AssertEx( IsDefined( bool ), "Need to pass either 'true' or 'false' to enable/disable weapons" );
if ( level.players.size < 1 )
return;
foreach ( player in level.players )
{
if ( bool == true )
player EnableWeapons();
else
player DisableWeapons();
}
}
teleport_players( aNodes )
{
player1node = undefined;
player2node = undefined;
eNode = undefined;
foreach ( node in aNodes )
{
if ( ( IsDefined( node.script_noteworthy ) ) && ( node.script_noteworthy == "player1" ) )
player1node = node;
else if ( ( IsDefined( node.script_noteworthy ) ) && ( node.script_noteworthy == "player2" ) )
player2node = node;
else
{
if ( !isdefined( player1node ) )
player1node = node;
if ( !isdefined( player2node ) )
player2node = node;
}
}
foreach ( player in level.players )
{
if ( player == level.player )
eNode = player1node;
else if ( player == level.player2 )
eNode = player2node;
player SetOrigin( eNode.origin );
player SetPlayerAngles( eNode.angles );
}
}
teleport_player( object )
{
level.player SetOrigin( object.origin );
if ( IsDefined( object.angles ) )
level.player SetPlayerAngles( object.angles );
}
hide_player_model()
{
if ( !is_coop() )
return;
self.is_hidden = true;
AssertEx( IsDefined( self.last_modelfunc ), "can't Hide player model on a player that hasn't been through maps\_loadout::UpdateModel()" );
thread maps\_loadout::UpdateModel( undefined );
}
show_player_model()
{
if ( !is_coop() )
return;
self.is_hidden = false;
AssertEx( IsDefined( self.last_modelfunc ), "can't Show player model on a player that hasn't been through maps\_loadout::UpdateModel()" );
thread maps\_loadout::UpdateModel( self.last_modelfunc );
}
translate_local()
{
entities = [];
if ( IsDefined( self.entities ) )
entities = self.entities;
if ( IsDefined( self.entity ) )
entities[ entities.size ] = self.entity;
AssertEx( entities.size > 0, "Tried to do translate_local without any entities" );
array_levelthread( entities, ::translate_local_on_ent );
}
open_up_fov( time, player_rig, tag, arcRight, arcLeft, arcTop, arcBottom )
{
level.player endon( "stop_opening_fov" );
wait( time );
level.player PlayerLinkToDelta( player_rig, tag, 1, arcRight, arcLeft, arcTop, arcBottom, true );
}
get_ai_touching_volume( sTeam, species, bGetDrones )
{
if ( !isdefined( sTeam ) )
sTeam = "all";
if ( !isdefined( species ) )
species = "all";
aTeam = GetAISpeciesArray( sTeam, species );
aGuysTouchingVolume = [];
foreach ( guy in aTeam )
{
AssertEx( IsAlive( guy ), "Got ai array yet got a dead guy!" );
if ( guy IsTouching( self ) )
aGuysTouchingVolume[ aGuysTouchingVolume.size ] = guy;
}
return aGuysTouchingVolume;
}
get_drones_touching_volume( sTeam )
{
if ( !isdefined( sTeam ) )
sTeam = "all";
aDrones = [];
if ( sTeam == "all" )
{
aDrones = array_merge( level.drones[ "allies" ].array, level.drones[ "axis" ].array );
aDrones = array_merge( aDrones, level.drones[ "neutral" ].array );
}
else
aDrones = level.drones[ sTeam ].array;
aDronesToReturn = [];
foreach ( drone in aDrones )
{
if ( !isdefined( drone ) )
continue;
if ( drone IsTouching( self ) )
aDronesToReturn[ aDronesToReturn.size ] = drone;
}
return aDronesToReturn;
}
get_drones_with_targetname( sTargetname )
{
aDrones = array_merge( level.drones[ "allies" ].array, level.drones[ "axis" ].array );
aDrones = array_merge( aDrones, level.drones[ "neutral" ].array );
aDronesToReturn = [];
foreach ( drone in aDrones )
{
if ( !isdefined( drone ) )
continue;
if ( ( IsDefined( drone.targetname ) ) && ( drone.targetname == sTargetname ) )
aDronesToReturn[ aDronesToReturn.size ] = drone;
}
return aDronesToReturn;
}
get_other_player( player )
{
Assert( is_coop() );
Assert( isdefined( player ) && isplayer( player ) );
foreach ( other_player in level.players )
{
if ( player == other_player )
continue;
return other_player;
}
AssertMsg( "get_other_player() tried to get other player but there is no other player." );
}
is_other_player_downed( player )
{
Assert( is_coop() );
Assert( isdefined( player ) && isplayer( player ) );
other_player = get_other_player( player );
Assert( IsDefined( other_player ) );
return is_player_down( other_player );
}
set_count( count )
{
self.count = count;
}
follow_path( node, require_player_dist, arrived_at_node_func )
{
self notify( "_utility::follow_path" );
self endon( "_utility::follow_path" );
self endon( "death" );
goal_type = undefined;
if ( !isdefined( node.classname ) )
{
if ( !isdefined( node.type ) )
goal_type = "struct";
else
goal_type = "node";
}
else
goal_type = "entity";
if ( !isdefined( require_player_dist ) )
require_player_dist = 300;
oldforcegoal = self.script_forcegoal;
self.script_forcegoal = 1;
self maps\_spawner::go_to_node( node, goal_type, arrived_at_node_func, require_player_dist );
self.script_forcegoal = oldforcegoal;
}
enable_dynamic_run_speed( pushdist, sprintdist, stopdist, jogdist, group, dontChangeMovePlaybackRate )
{
AssertEx( IsDefined( level.scr_anim[ "generic" ][ "DRS_sprint" ] ), " - -- -- -- -- -- -- add this line: 'maps\_dynamic_run_speed::main();' AFTER maps\\\_load::main(); -- -- -- -- -- -- - " );
if ( !isdefined( pushdist ) )
pushdist = 250;
if ( !isdefined( sprintdist ) )
sprintdist = 100;
if ( !isdefined( stopdist ) )
stopdist = pushdist * 2;
if ( !isdefined( jogdist ) )
jogdist = pushdist * 1.25;
if ( !isdefined( dontChangeMovePlaybackRate ) )
dontChangeMovePlaybackRate = false;
self.dontChangeMovePlaybackRate = dontChangeMovePlaybackRate;
self thread dynamic_run_speed_proc( pushdist, sprintdist, stopdist, jogdist, group );
}
disable_dynamic_run_speed()
{
self notify( "stop_dynamic_run_speed" );
}
player_seek_enable()
{
self endon( "death" );
self endon( "stop_player_seek" );
g_radius = 1200;
if ( self has_shotgun() )
g_radius = 250;
newGoalRadius = Distance( self.origin, level.player.origin );
for ( ;; )
{
wait 2;
self.goalradius = newGoalRadius;
player = get_closest_player( self.origin );
self SetGoalEntity( player );
newGoalRadius -= 175;
if ( newGoalRadius < g_radius )
{
newGoalRadius = g_radius;
return;
}
}
}
player_seek_disable()
{
self notify( "stop_player_seek" );
}
waittill_entity_in_range_or_timeout( entity, range, timeout )
{
self endon( "death" );
entity endon( "death" );
if ( !isdefined( timeout ) )
timeout = 5;
timeout_time = GetTime() + ( timeout * 1000 );
while ( IsDefined( entity ) )
{
if ( Distance( entity.origin, self.origin ) <= range )
break;
if ( GetTime() > timeout_time )
break;
wait .1;
}
}
waittill_entity_in_range( entity, range )
{
self endon( "death" );
entity endon( "death" );
while ( IsDefined( entity ) )
{
if ( Distance( entity.origin, self.origin ) <= range )
break;
wait .1;
}
}
waittill_entity_out_of_range( entity, range )
{
self endon( "death" );
entity endon( "death" );
while ( IsDefined( entity ) )
{
if ( Distance( entity.origin, self.origin ) > range )
break;
wait .1;
}
}
has_shotgun()
{
self endon( "death" );
if ( !isdefined( self.weapon ) )
return false;
if ( self.weapon == "winchester1200" || self.weapon == "m1014" || self.weapon == "striker" || self.weapon == "ranger" || self.weapon == "aa12" )
return true;
else
return false;
}
isPrimaryWeapon( weapName )
{
if ( weapName == "none" )
return false;
if ( weaponInventoryType( weapName ) != "primary" )
return false;
switch ( weaponClass( weapName ) )
{
case "rifle":
case "smg":
case "mg":
case "spread":
case "pistol":
case "rocketlauncher":
case "sniper":
return true;
default:
return false;
}
}
player_has_thermal()
{
weapons = self GetWeaponsListAll();
if ( !isdefined( weapons ) )
return false;
foreach ( weapon in weapons )
{
if ( IsSubStr( weapon, "thermal" ) )
return true;
}
return false;
}
waittill_true_goal( origin, radius )
{
self endon( "death" );
if ( !isdefined( radius ) )
radius = self.goalradius;
while ( 1 )
{
self waittill( "goal" );
if ( Distance( self.origin, origin ) < radius + 10 )
break;
}
}
player_speed_percent( percent, time )
{
currspeed = Int( GetDvar( "g_speed" ) );
if ( !isdefined( level.player.g_speed ) )
level.player.g_speed = currspeed;
goalspeed = Int( level.player.g_speed * percent * .01 );
level.player player_speed_set( goalspeed, time );
}
blend_movespeedscale_percent( percent, time )
{
player = self;
if ( !isplayer( player ) )
player = level.player;
if ( !isdefined( player.movespeedscale ) )
player.movespeedscale = 1.0;
goalscale = percent * .01;
player blend_movespeedscale( goalscale, time );
}
player_speed_set( speed, time )
{
currspeed = Int( GetDvar( "g_speed" ) );
if ( !isdefined( level.player.g_speed ) )
level.player.g_speed = currspeed;
get_func = ::g_speed_get_func;
set_func = ::g_speed_set_func;
level.player thread player_speed_proc( speed, time, get_func, set_func, "player_speed_set" );
}
blend_movespeedscale( scale, time )
{
player = self;
if ( !isplayer( player ) )
player = level.player;
if ( !isdefined( player.movespeedscale ) )
player.movespeedscale = 1.0;
get_func = ::movespeed_get_func;
set_func = ::movespeed_set_func;
player thread player_speed_proc( scale, time, get_func, set_func, "blend_movespeedscale" );
}
player_speed_proc( speed, time, get_func, set_func, ender )
{
self notify( ender );
self endon( ender );
currspeed = [[ get_func ]]();
goalspeed = speed;
if ( IsDefined( time ) )
{
range = goalspeed - currspeed;
interval = .05;
numcycles = time / interval;
fraction = range / numcycles;
while ( abs( goalspeed - currspeed ) > abs( fraction * 1.1 ) )
{
currspeed += fraction;
[[ set_func ]]( currspeed );
wait interval;
}
}
[[ set_func ]]( goalspeed );
}
player_speed_default( time )
{
if ( !isdefined( level.player.g_speed ) )
return;
level.player player_speed_set( level.player.g_speed, time );
waittillframeend;
level.player.g_speed = undefined;
}
blend_movespeedscale_default( time )
{
player = self;
if ( !isplayer( player ) )
player = level.player;
if ( !isdefined( player.movespeedscale ) )
return;
player blend_movespeedscale( 1.0, time );
waittillframeend;
player.movespeedscale = undefined;
}
drop_to_ground( pos, updist, downdist )
{
if ( !isdefined( updist ) )
updist = 1500;
if ( !isdefined( downdist ) )
downdist = -12000;
return PhysicsTrace( pos + ( 0, 0, updist ), pos + ( 0, 0, downdist ) );
}
teleport_ent( ent )
{
if ( IsPlayer( self ) )
{
self SetOrigin( ent.origin );
self SetPlayerAngles( ent.angles );
}
else
{
self ForceTeleport( ent.origin, ent.angles );
}
}
teleport_to_ent_tag( ent, tag )
{
position = ent GetTagOrigin( tag );
angles = ent GetTagAngles( tag );
self DontInterpolate();
if ( IsPlayer( self ) )
{
self SetOrigin( position );
self SetPlayerAngles( angles );
}
else if( IsAI( self ) )
{
self ForceTeleport( position, angles );
}
else
{
self.origin = position;
self.angles = angles;
}
}
teleport_ai( eNode )
{
AssertEx( IsAI( self ), "Function teleport_ai can only be called on an AI entity" );
AssertEx( IsDefined( eNode ), "Need to pass a node entity to function teleport_ai" );
self ForceTeleport( eNode.origin, eNode.angles );
self SetGoalPos( self.origin );
self SetGoalNode( eNode );
}
move_all_fx( vec )
{
foreach ( fx in level.createFXent )
{
fx.v[ "origin" ] += vec;
}
}
IsSliding()
{
return IsDefined( self.slideModel );
}
BeginSliding( velocity, allowedAcceleration, dampening )
{
Assert( IsPlayer( self ) );
player = self;
player thread play_sound_on_entity( "foot_slide_plr_start" );
player thread play_loop_sound_on_tag( "foot_slide_plr_loop" );
override_link_method = IsDefined( level.custom_linkto_slide );
if ( !isDefined( velocity ) )
velocity = player GetVelocity() + ( 0, 0, -10 );
if ( !isDefined( allowedAcceleration ) )
allowedAcceleration = 10;
if ( !isDefined( dampening ) )
dampening = .035;
Assert( !isDefined( player.slideModel ) );
slideModel = Spawn( "script_origin", player.origin );
slideModel.angles = player.angles;
player.slideModel = slideModel;
slideModel MoveSlide( ( 0, 0, 15 ), 15, velocity );
if ( override_link_method )
{
player PlayerLinkToBlend( slideModel, undefined, 1 );
}
else
{
player PlayerLinkTo( slideModel );
}
player DisableWeapons();
player AllowProne( false );
player AllowCrouch( true );
player AllowStand( false );
player thread DoSlide( slideModel, allowedAcceleration, dampening );
}
EndSliding()
{
Assert( IsPlayer( self ) );
player = self;
Assert( IsDefined( player.slideModel ) );
player notify( "stop sound" + "foot_slide_plr_loop" );
player thread play_sound_on_entity( "foot_slide_plr_end" );
player Unlink();
player SetVelocity( player.slidemodel.slideVelocity );
player.slideModel Delete();
player EnableWeapons();
player AllowProne( true );
player AllowCrouch( true );
player AllowStand( true );
player notify( "stop_sliding" );
}
spawn_vehicle()
{
return maps\_vehicle::vehicle_spawn( self );
}
getEntWithFlag( flag )
{
trigger_classes = maps\_load::get_load_trigger_classes();
triggers = [];
foreach ( class, _ in trigger_classes )
{
if ( !IsSubStr( class, "flag" ) )
continue;
other_triggers = GetEntArray( class, "classname" );
triggers = array_combine( triggers, other_triggers );
}
trigger_funcs = maps\_load::get_load_trigger_funcs();
foreach ( func, _ in trigger_funcs )
{
if ( !IsSubStr( func, "flag" ) )
continue;
other_triggers = GetEntArray( func, "targetname" );
triggers = array_combine( triggers, other_triggers );
}
found_trigger = undefined;
foreach ( trigger in triggers )
{
if ( trigger.script_flag == flag )
{
return trigger;
}
}
}
getEntArrayWithFlag( flag )
{
trigger_classes = maps\_load::get_load_trigger_classes();
triggers = [];
foreach ( class, _ in trigger_classes )
{
if ( !IsSubStr( class, "flag" ) )
continue;
other_triggers = GetEntArray( class, "classname" );
triggers = array_combine( triggers, other_triggers );
}
trigger_funcs = maps\_load::get_load_trigger_funcs();
foreach ( func, _ in trigger_funcs )
{
if ( !IsSubStr( func, "flag" ) )
continue;
other_triggers = GetEntArray( func, "targetname" );
triggers = array_combine( triggers, other_triggers );
}
found_triggers = [];
foreach ( trigger in triggers )
{
if ( trigger.script_flag == flag )
{
found_triggers[ found_triggers.size ] = trigger;
}
}
return found_triggers;
}
set_z( vec, z )
{
return( vec[ 0 ], vec[ 1 ], z );
}
set_y( vec, y )
{
return( vec[ 0 ], y, vec[ 2 ] );
}
set_x( vec, x )
{
return( x, vec[ 1 ], vec[ 2 ] );
}
player_using_missile()
{
weapon = self GetCurrentWeapon();
if ( !isdefined( weapon ) )
return false;
if ( IsSubStr( ToLower( weapon ), "rpg" ) )
return true;
if ( IsSubStr( ToLower( weapon ), "stinger" ) )
return true;
if ( IsSubStr( ToLower( weapon ), "at4" ) )
return true;
if ( IsSubStr( ToLower( weapon ), "javelin" ) )
return true;
return false;
}
doingLongDeath()
{
Assert( IsAI( self ) );
return IsDefined( self.a.doingLongDeath );
}
get_rumble_ent( rumble )
{
if ( is_coop() )
PrintLn( "^3Warning! Using get_rumble_ent will cause the same rumbles to apply to all of the coop players!" );
player = get_player_from_self();
if ( !IsDefined( rumble ) )
rumble = "steady_rumble";
ent = Spawn( "script_origin", player GetEye() );
ent.intensity = 1;
ent thread update_rumble_intensity( player, rumble );
return ent;
}
set_rumble_intensity( intensity )
{
AssertEx( intensity >= 0 && intensity <= 1, "Intensity must be between 0 and 1" );
self.intensity = intensity;
}
rumble_ramp_on( time )
{
thread rumble_ramp_to( 1, time );
}
rumble_ramp_off( time )
{
thread rumble_ramp_to( 0, time );
}
rumble_ramp_to( dest, time )
{
self notify( "new_ramp" );
self endon( "new_ramp" );
self endon( "death" );
frames = time * 20;
dif = dest - self.intensity;
slice = dif / frames;
for ( i = 0; i < frames; i++ )
{
self.intensity += slice;
wait( 0.05 );
}
self.intensity = dest;
}
get_player_from_self()
{
if ( IsDefined( self ) )
{
if ( !is_in_array( level.players, self ) )
return level.player;
else
return self;
}
else
return level.player;
}
get_player_gameskill()
{
AssertEx( IsPlayer( self ), "get_player_gameskill() can only be called on a player." );
return Int( self GetPlayerSetting( "gameskill" ) );
}
glow( model )
{
if ( IsDefined( self.non_glow_model ) )
return;
self.non_glow_model = self.model;
if ( !isdefined( model ) )
model = self.model + "_obj";
self SetModel( model );
}
stopGlow( model )
{
if ( !isdefined( self.non_glow_model ) )
return;
self SetModel( self.non_glow_model );
self.non_glow_model = undefined;
}
array_delete_evenly( array, delete_size, set_size )
{
AssertEx( delete_size > 0, "Save size must be at least 1" );
AssertEx( set_size > 0, "Removal size must be at least 1" );
AssertEx( delete_size < set_size, "Save size must be less than removal size" );
removal = [];
delete_size = set_size - delete_size;
foreach ( entry in array )
{
removal[ removal.size ] = entry;
if ( removal.size == set_size )
{
removal = array_randomize( removal );
for ( i = delete_size; i < removal.size; i++ )
{
removal[ i ] Delete();
}
removal = [];
}
}
new_array = [];
foreach ( entry in array )
{
if ( !isdefined( entry ) )
continue;
new_array[ new_array.size ] = entry;
}
return new_array;
}
waittill_in_range( origin, range, resolution )
{
if( !isdefined( resolution ) )
resolution = 0.5;
self endon( "death" );
while ( IsDefined( self ) )
{
if ( Distance( origin, self.origin ) <= range )
break;
wait resolution;
}
}
add_trace_fx( name )
{
ent = SpawnStruct();
ent thread add_trace_fx_proc( name );
return ent;
}
traceFX_on_tag( fx_name, tag, trace_depth )
{
origin = self GetTagOrigin( tag );
angles = self GetTagAngles( tag );
traceFx( fx_name, origin, angles, trace_depth );
}
traceFx( fx_name, origin, angles, trace_depth )
{
AssertEx( IsDefined( level.trace_fx[ fx_name ] ), "No level.trace_fx with name " + fx_name );
AssertEx( IsDefined( level.trace_fx[ fx_name ][ "default" ] ), "No default fx defined for " + fx_name );
forward = AnglesToForward( angles );
trace = BulletTrace( origin, origin + forward * trace_depth, false, undefined );
if ( trace[ "fraction" ] >= 1 )
{
return;
}
surface = trace[ "surfacetype" ];
if ( !isdefined( level.trace_fx[ fx_name ][ surface ] ) )
surface = "default";
fx_info = level.trace_fx[ fx_name ][ surface ];
if ( IsDefined( fx_info[ "fx" ] ) )
{
PlayFX( fx_info[ "fx" ], trace[ "position" ], trace[ "normal" ] );
}
if ( IsDefined( fx_info[ "fx_array" ] ) )
{
foreach ( fx in fx_info[ "fx_array" ] )
{
PlayFX( fx, trace[ "position" ], trace[ "normal" ] );
}
}
if ( IsDefined( fx_info[ "sound" ] ) )
{
level thread play_sound_in_space( fx_info[ "sound" ], trace[ "position" ] );
}
if ( IsDefined( fx_info[ "rumble" ] ) )
{
player = get_player_from_self();
player PlayRumbleOnEntity( fx_info[ "rumble" ] );
}
}
disable_surprise()
{
self.newEnemyReactionDistSq = 0;
}
enable_surprise()
{
self.newEnemyReactionDistSq = squared( 512 );
}
enable_heat_behavior( shoot_while_moving )
{
self.heat = true;
self.no_pistol_switch = true;
self.useCombatScriptAtCover = true;
if ( !isdefined( shoot_while_moving ) || !shoot_while_moving )
{
self.dontshootwhilemoving = true;
self.maxfaceenemydist = 64;
self.pathenemylookahead = 2048;
self disable_surprise();
}
self.specialReloadAnimFunc = animscripts\animset::heat_reload_anim;
self.customMoveAnimSet[ "run" ] = anim.animsets.move[ "heat_run" ];
}
disable_heat_behavior()
{
self.heat = undefined;
self.no_pistol_switch = undefined;
self.dontshootwhilemoving = undefined;
self.useCombatScriptAtCover = false;
self.maxfaceenemydist = 512;
self.specialReloadAnimFunc = undefined;
self.customMoveAnimSet = undefined;
}
getVehicleArray()
{
return Vehicle_GetArray();
}
hint( string, timeOut, zoffset )
{
if ( !isdefined( zoffset ) )
zoffset = 0;
hintfade = 0.5;
level endon( "clearing_hints" );
if ( IsDefined( level.hintElement ) )
level.hintElement maps\_hud_util::destroyElem();
level.hintElement = maps\_hud_util::createFontString( "default", 1.5 );
level.hintElement maps\_hud_util::setPoint( "MIDDLE", undefined, 0, 30 + zoffset );
level.hintElement.color = ( 1, 1, 1 );
level.hintElement SetText( string );
level.hintElement.alpha = 0;
level.hintElement FadeOverTime( 0.5 );
level.hintElement.alpha = 1;
wait( 0.5 );
level.hintElement endon( "death" );
if ( IsDefined( timeOut ) )
wait( timeOut );
else
return;
level.hintElement FadeOverTime( hintfade );
level.hintElement.alpha = 0;
wait( hintfade );
level.hintElement maps\_hud_util::destroyElem();
}
hint_fade()
{
hintfade = 1;
if ( IsDefined( level.hintElement ) )
{
level notify( "clearing_hints" );
level.hintElement FadeOverTime( hintfade );
level.hintElement.alpha = 0;
wait( hintfade );
}
}
kill_deathflag( theFlag, time )
{
if ( !isdefined( level.flag[ theFlag ] ) )
return;
if ( !isdefined( time ) )
time = 0;
foreach ( deathTypes in level.deathFlags[ theFlag ] )
{
foreach ( element in deathTypes )
{
if ( IsAlive( element ) )
{
element thread kill_deathflag_proc( time );
}
else
{
element Delete();
}
}
}
}
get_player_view_controller( model, tag, originoffset, turret )
{
if ( !IsDefined( turret ) )
{
turret = "player_view_controller";
}
if ( !isdefined( originoffset ) )
originoffset = ( 0, 0, 0 );
origin = model GetTagOrigin( tag );
player_view_controller = SpawnTurret( "misc_turret", origin, turret );
player_view_controller.angles = model GetTagAngles( tag );
player_view_controller SetModel( "tag_turret" );
player_view_controller LinkTo( model, tag, originoffset, ( 0, 0, 0 ) );
player_view_controller MakeUnusable();
player_view_controller Hide();
player_view_controller SetMode( "manual" );
return player_view_controller;
}
blend_dof( start, end, time )
{
blend = level create_blend( ::blend_default_dof, start, end );
blend.time = time;
}
create_blend( func, var1, var2, var3 )
{
ent = SpawnStruct();
ent childthread process_blend( func, self, var1, var2, var3 );
return ent;
}
store_players_weapons( scene )
{
if ( !isdefined( self.stored_weapons ) )
{
self.stored_weapons = [];
}
array = [];
weapons = self GetWeaponsListAll();
foreach ( weapon in weapons )
{
array[ weapon ] = [];
array[ weapon ][ "clip_left" ] = self GetWeaponAmmoClip( weapon, "left" );
array[ weapon ][ "clip_right" ] = self GetWeaponAmmoClip( weapon, "right" );
array[ weapon ][ "stock" ] = self GetWeaponAmmoStock( weapon );
}
if ( !isdefined( scene ) )
scene = "default";
self.stored_weapons[ scene ] = [];
self.stored_weapons[ scene ][ "current_weapon" ] = self GetCurrentWeapon();
self.stored_weapons[ scene ][ "inventory" ] = array;
}
restore_players_weapons( scene )
{
if ( !isdefined( scene ) )
scene = "default";
if ( !isdefined( self.stored_weapons ) || !isdefined( self.stored_weapons[ scene ] ) )
{
PrintLn( "^3Warning! Tried to restore weapons for scene " + scene + " but they weren't stored" );
return;
}
self TakeAllWeapons();
foreach ( weapon, array in self.stored_weapons[ scene ][ "inventory" ] )
{
if ( WeaponInventoryType( weapon ) != "altmode" )
{
self GiveWeapon( weapon );
}
self SetWeaponAmmoClip( weapon, array[ "clip_left" ], "left" );
self SetWeaponAmmoClip( weapon, array[ "clip_right" ], "right" );
self SetWeaponAmmoStock( weapon, array[ "stock" ] );
}
current_weapon = self.stored_weapons[ scene ][ "current_weapon" ];
if ( current_weapon != "none" )
self SwitchToWeapon( current_weapon );
}
hide_entity()
{
switch( self.code_classname )
{
case "light_spot":
case "script_vehicle":
case "script_model":
self Hide();
break;
case "script_brushmodel":
self Hide();
self NotSolid();
if ( self.spawnflags & 1 )
self ConnectPaths();
break;
case "trigger_radius":
case "trigger_multiple":
case "trigger_use":
case "trigger_use_touch":
case "trigger_multiple_flag_set":
case "trigger_multiple_breachIcon":
case "trigger_multiple_flag_lookat":
case "trigger_multiple_flag_looking":
self trigger_off();
break;
default:
AssertMsg( "Unable to hide entity at " + self.origin + ". Need to define a method for handling entities of classname " + self.code_classname );
}
}
show_entity()
{
switch( self.code_classname )
{
case "light_spot":
case"script_vehicle":
case"script_model":
self Show();
break;
case "script_brushmodel":
self Show();
self Solid();
if ( self.spawnflags & 1 )
self DisconnectPaths();
break;
case "trigger_radius":
case "trigger_multiple":
case "trigger_use":
case "trigger_use_touch":
case "trigger_multiple_flag_set":
case "trigger_multiple_breachIcon":
case "trigger_multiple_flag_lookat":
case "trigger_multiple_flag_looking":
self trigger_on();
break;
default:
AssertMsg( "Unable to show entity at " + self.origin + ". Need to define a method for handling entities of classname " + self.code_classname );
}
}
_rotateyaw( yaw_angle, time, acc_time, dec_time )
{
if ( IsDefined( dec_time ) )
self RotateYaw( yaw_angle, time, acc_time, dec_time );
else
if ( IsDefined( acc_time ) )
self RotateYaw( yaw_angle, time, acc_time );
else
self RotateYaw( yaw_angle, time );
}
set_moveplaybackrate( rate, time )
{
self notify( "set_moveplaybackrate" );
self endon( "set_moveplaybackrate" );
if ( IsDefined( time ) )
{
range = rate - self.moveplaybackrate;
interval = .05;
numcycles = time / interval;
fraction = range / numcycles;
while ( abs( rate - self.moveplaybackrate ) > abs( fraction * 1.1 ) )
{
self.moveplaybackrate += fraction;
wait interval;
}
}
self.moveplaybackrate = rate;
}
array_spawn_function( array, func, param1, param2, param3, param4 )
{
AssertEx( IsDefined( array ), "That isn't an array!" );
AssertEx( IsArray( array ), "That isn't an array!" );
AssertEx( array.size, "That array is empty!" );
foreach ( spawner in array )
{
AssertEx( IsSpawner( spawner ), "This isn't a spawner!" );
spawner thread add_spawn_function( func, param1, param2, param3, param4 );
}
}
array_spawn_function_targetname( key, func, param1, param2, param3, param4 )
{
array = GetEntArray( key, "targetname" );
array_spawn_function( array, func, param1, param2, param3, param4 );
}
array_spawn_function_noteworthy( key, func, param1, param2, param3, param4 )
{
array = GetEntArray( key, "script_noteworthy" );
array_spawn_function( array, func, param1, param2, param3, param4 );
}
enable_dontevershoot()
{
self.dontEverShoot = true;
}
disable_dontevershoot()
{
self.dontEverShoot = undefined;
}
create_vision_set_fog( fogset )
{
if ( !isdefined( level.vision_set_fog ) )
level.vision_set_fog = [];
ent = SpawnStruct();
ent.name = fogset;
level.vision_set_fog[ fogset ] = ent;
return ent;
}
get_vision_set_fog( fogset )
{
if ( !isdefined( level.vision_set_fog ) )
level.vision_set_fog = [];
ent = level.vision_set_fog[ fogset ];
return ent;
}
create_fog( fogset )
{
if ( !isdefined( level.fog_set ) )
level.fog_set = [];
ent = SpawnStruct();
ent.name = fogset;
level.fog_set[ fogset ] = ent;
return ent;
}
get_fog( fogset )
{
if ( !isdefined( level.fog_set ) )
level.fog_set = [];
ent = level.fog_set[ fogset ];
return ent;
}
init_self_fog_transition()
{
if ( !IsDefined( self.fog_transition_ent ) )
{
self.fog_transition_ent = SpawnStruct();
self.fog_transition_ent.fogset = "";
self.fog_transition_ent.time = 0;
}
}
fog_set_changes( fog_set, transition_time )
{
if ( !isPlayer( self ) )
maps\_art::init_fog_transition();
else
init_self_fog_transition();
if ( !isdefined( level.fog_set ) )
level.fog_set = [];
ent = level.fog_set[ fog_set ];
if ( !isdefined( ent ) )
{
AssertEx( IsDefined( level.vision_set_fog ), "Fog set:" + fog_set + " does not exist, use create_fog( " + fog_set + " ) or create_vision_set_fog( " + fog_set + " ); in your /createart/level_fog.gsc" );
ent = level.vision_set_fog[ fog_set ];
}
AssertEx( IsDefined( ent ), "Fog set:" + fog_set + " does not exist, use create_fog( " + fog_set + " ) or create_vision_set_fog( " + fog_set + " ); in your /createart/level_fog.gsc" );
if ( !isdefined( transition_time ) )
transition_time = ent.transitiontime;
AssertEx( IsDefined( transition_time ), "Fog set: " + fog_set + " does not have a transition_time defined and a time was not specified in the function call." );
if( GetDvarInt( "scr_art_tweak") != 0 )
{
translateEntTosliders(ent );
transition_time = 0;
}
if ( !isPlayer( self ) )
{
if ( level.fog_transition_ent.fogset == fog_set && level.fog_transition_ent.time == transition_time )
return;
set_fog_to_ent_values( ent, transition_time );
level.fog_transition_ent.fogset = fog_set;
level.fog_transition_ent.time = transition_time;
}
else
{
if ( self.fog_transition_ent.fogset == fog_set && self.fog_transition_ent.time == transition_time )
return;
self set_fog_to_ent_values( ent, transition_time );
self.fog_transition_ent.fogset = fog_set;
self.fog_transition_ent.time = transition_time;
}
}
translateEntTosliders(ent)
{
}
set_fog_to_ent_values( ent, transition_time )
{
if ( IsDefined( ent.sunFogEnabled) && ent.sunFogEnabled)
{
if ( !isPlayer( self ) )
{
SetExpFog(
ent.startDist,
ent.halfwayDist,
ent.red,
ent.green,
ent.blue,
ent.maxOpacity,
transition_time,
ent.sunRed,
ent.sunGreen,
ent.sunBlue,
ent.sunDir,
ent.sunBeginFadeAngle,
ent.sunEndFadeAngle,
ent.normalFogScale );
}
else
{
self PlayerSetExpFog(
ent.startDist,
ent.halfwayDist,
ent.red,
ent.green,
ent.blue,
ent.maxOpacity,
transition_time,
ent.sunRed,
ent.sunGreen,
ent.sunBlue,
ent.sunDir,
ent.sunBeginFadeAngle,
ent.sunEndFadeAngle,
ent.normalFogScale );
}
}
else
{
if ( !isPlayer( self ) )
{
SetExpFog(
ent.startDist,
ent.halfwayDist,
ent.red,
ent.green,
ent.blue,
ent.maxOpacity,
transition_time );
}
else
{
self PlayerSetExpFog(
ent.startDist,
ent.halfwayDist,
ent.red,
ent.green,
ent.blue,
ent.maxOpacity,
transition_time );
}
}
}
vision_set_fog_changes( vision_set, transition_time )
{
do_fog = vision_set_changes( vision_set, transition_time );
if ( do_fog && IsDefined( get_vision_set_fog( vision_set ) ) )
{
fog_set_changes( vision_set, transition_time );
}
}
init_self_visionset()
{
if ( !IsDefined( self.vision_set_transition_ent ) )
{
self.vision_set_transition_ent = SpawnStruct();
self.vision_set_transition_ent.vision_set = "";
self.vision_set_transition_ent.time = 0;
}
}
vision_set_changes( vision_set, transition_time )
{
if ( !IsPlayer( self ) )
{
vision_set_initd = true;
if ( !isdefined( level.vision_set_transition_ent ) )
{
level.vision_set_transition_ent = SpawnStruct();
level.vision_set_transition_ent.vision_set = "";
level.vision_set_transition_ent.time = 0;
vision_set_initd = false;
}
if ( level.vision_set_transition_ent.vision_set == vision_set && level.vision_set_transition_ent.time == transition_time )
{
return false;
}
level.vision_set_transition_ent.vision_set = vision_set;
level.vision_set_transition_ent.time = transition_time;
if( vision_set_initd && ( GetDvarInt( "scr_art_tweak") != 0 ) )
{
}
else
{
VisionSetNaked( vision_set, transition_time );
}
level.lvl_visionset = vision_set;
SetDvar( "vision_set_current", vision_set );
}
else
{
self init_self_visionset();
if ( self.vision_set_transition_ent.vision_set == vision_set && self.vision_set_transition_ent.time == transition_time )
return false;
self.vision_set_transition_ent.vision_set = vision_set;
self.vision_set_transition_ent.time = transition_time;
self VisionSetNakedForPlayer( vision_set, transition_time );
}
return true;
}
set_art_tweaked_vision_set()
{
}
enable_teamflashbangImmunity()
{
self thread enable_teamflashbangImmunity_proc();
}
enable_teamflashbangImmunity_proc()
{
self endon( "death" );
while ( 1 )
{
self.teamFlashbangImmunity = true;
wait .05;
}
}
disable_teamflashbangImmunity()
{
self.teamFlashbangImmunity = undefined;
}
_radiusdamage( origin, range, maxdamage, mindamage, attacker )
{
if ( !isdefined( attacker ) )
RadiusDamage( origin, range, maxdamage, mindamage );
else
RadiusDamage( origin, range, maxdamage, mindamage, attacker );
}
mask_interactives_in_volumes( volumes )
{
tvs = GetEntArray( "interactive_tv", "targetname" );
foreach ( volume in volumes )
{
volume.interactives = [];
}
foreach ( tv in tvs )
{
foreach ( volume in volumes )
{
if ( !volume IsTouching( tv ) )
continue;
volume put_interactive_in_volume( tv );
break;
}
}
}
activate_interactives_in_volume()
{
if ( !isdefined( self.interactives ) )
return;
foreach ( ent in self.interactives )
{
toy = Spawn( "script_model", ( 0, 0, 0 ) );
toy SetModel( ent.toy_model );
toy.origin = ent.origin;
toy.angles = ent.angles;
toy.script_noteworthy = ent.script_noteworthy;
toy.target = ent.target;
toy.targetname = ent.targetname;
toy thread maps\_interactive_objects::tv_logic();
}
self.interactives = [];
}
mask_destructibles_in_volumes( volumes )
{
destructible_toy = GetEntArray( "destructible_toy", "targetname" );
destructible_vehicles = GetEntArray( "destructible_vehicle", "targetname" );
combined_destructibles = array_combine( destructible_toy, destructible_vehicles );
foreach ( volume in volumes )
{
volume.destructibles = [];
}
foreach ( toy in combined_destructibles )
{
foreach ( volume in volumes )
{
if ( !volume IsTouching( toy ) )
continue;
volume put_toy_in_volume( toy );
break;
}
}
}
mask_exploders_in_volume( volumes )
{
if( GetDvar( "createfx" ) != "" )
return;
ents = GetEntArray( "script_brushmodel", "classname" );
smodels = GetEntArray( "script_model", "classname" );
for ( i = 0; i < smodels.size; i++ )
ents[ ents.size ] = smodels[ i ];
foreach( volume in volumes )
foreach ( ent in ents )
{
if ( IsDefined( ent.script_prefab_exploder ) )
ent.script_exploder = ent.script_prefab_exploder;
if ( !IsDefined( ent.script_exploder ) )
continue;
if ( !IsDefined( ent.model ) )
continue;
if ( ent.code_classname != "script_model" )
continue;
if ( !ent IsTouching( volume ) )
continue;
ent.masked_exploder = true;
}
}
activate_exploders_in_volume()
{
test_org = Spawn( "script_origin", ( 0, 0, 0 ) );
foreach ( EntFx in level.createfxent )
{
if ( !IsDefined( EntFx.v[ "masked_exploder" ] ) )
continue;
test_org.origin = EntFx.v[ "origin" ];
test_org.angles = EntFx.v[ "angles" ];
if( !test_org IsTouching( self ) )
continue;
model_name = EntFx.v[ "masked_exploder" ];
spawnflags = EntFx.v[ "masked_exploder_spawnflags" ];
disconnect_paths = EntFX.v[ "masked_exploder_script_disconnectpaths" ];
new_ent = Spawn( "script_model", ( 0, 0, 0 ), spawnflags );
new_ent SetModel( model_name );
new_ent.origin = EntFx.v[ "origin" ];
new_ent.angles = EntFx.v[ "angles" ];
Entfx.v[ "masked_exploder" ] = undefined;
Entfx.v[ "masked_exploder_spawnflags" ] = undefined;
Entfx.v[ "masked_exploder_script_disconnectpaths" ] = undefined;
new_ent.disconnect_paths = disconnect_paths;
new_ent.script_exploder = EntFx.v[ "exploder" ];
maps\_load::setup_individual_exploder( new_ent );
EntFX.model = new_ent;
}
test_org delete();
}
precache_destructible( destructible_type )
{
infoIndex = common_scripts\_destructible_types::getInfoIndex( destructible_type );
if ( infoIndex != -1 )
return;
struct = SpawnStruct();
struct.destructibleInfo= self common_scripts\_destructible_types::makeType( destructible_type );
struct thread common_scripts\_destructible::precache_destructibles();
struct thread common_scripts\_destructible::add_destructible_fx();
}
delete_destructibles_in_volumes( volumes, dodelayed )
{
foreach ( volume in volumes )
volume.destructibles = [];
names = [ "destructible_toy", "destructible_vehicle" ];
incs = 0;
if ( !IsDefined( dodelayed ) )
dodelayed = false;
foreach( name in names )
{
destructible_toy = GetEntArray( name, "targetname" );
foreach ( toy in destructible_toy )
{
foreach ( volume in volumes )
{
if( dodelayed )
{
incs++;
incs %= 5;
if( incs == 1 )
wait 0.05;
}
if ( !volume IsTouching( toy ) )
continue;
toy delete();
break;
}
}
}
}
delete_interactives_in_volumes( volumes, dodelayed )
{
tvs = GetEntArray( "interactive_tv", "targetname" );
foreach ( volume in volumes )
{
volume.interactives = [];
}
incs = 0;
if ( !IsDefined( dodelayed ) )
dodelayed = false;
foreach ( tv in tvs )
{
foreach ( volume in volumes )
{
if ( dodelayed )
{
incs++;
incs %= 5;
if ( incs == 1 )
wait 0.05;
}
if ( !volume IsTouching( tv ) )
continue;
tv Delete();
break;
}
}
}
delete_exploders_in_volumes( volumes, dodelayed )
{
ents = GetEntArray( "script_brushmodel", "classname" );
smodels = GetEntArray( "script_model", "classname" );
for ( i = 0; i < smodels.size; i++ )
ents[ ents.size ] = smodels[ i ];
delete_ents = [];
test_org = Spawn( "script_origin", ( 0, 0, 0 ) );
incs = 0;
if ( !IsDefined( dodelayed ) )
dodelayed = false;
foreach( volume in volumes )
foreach ( ent in ents )
{
if ( !IsDefined( ent.script_exploder ) )
continue;
test_org.origin = ent GetOrigin();
if( !volume IsTouching( test_org ) )
continue;
delete_ents[ delete_ents.size ] = ent;
}
array_delete( delete_ents );
test_org Delete();
}
activate_destructibles_in_volume()
{
if ( !isdefined( self.destructibles ) )
return;
foreach ( ent in self.destructibles )
{
toy = Spawn( "script_model", ( 0, 0, 0 ) );
toy SetModel( ent.toy_model );
toy.origin = ent.origin;
toy.angles = ent.angles;
toy.script_noteworthy = ent.script_noteworthy;
toy.targetname = ent.targetname;
toy.target = ent.target;
toy.script_linkto = ent.script_linkto;
toy.destructible_type = ent.destructible_type;
toy.script_noflip = ent.script_noflip;
toy common_scripts\_destructible::setup_destructibles( true );
}
self.destructibles = [];
}
setFlashbangImmunity( immune )
{
self.flashBangImmunity = immune;
}
flashBangGetTimeLeftSec()
{
Assert( IsDefined( self ) );
Assert( IsDefined( self.flashEndTime ) );
durationMs = self.flashEndTime - GetTime();
if ( durationMs < 0 )
return 0;
return( durationMs * 0.001 );
}
flashBangIsActive()
{
return( flashBangGetTimeLeftSec() > 0 );
}
flashBangStart( duration )
{
Assert( IsDefined( self ) );
Assert( IsDefined( duration ) );
if ( IsDefined( self.flashBangImmunity ) && self.flashbangImmunity )
return;
newFlashEndTime = GetTime() + ( duration * 1000.0 );
if ( IsDefined( self.flashendtime ) )
self.flashEndTime = max( self.flashendtime, newFlashEndTime );
else
self.flashendtime = newFlashEndTime;
self notify( "flashed" );
self SetFlashBanged( true );
}
waittill_volume_dead()
{
for ( ;; )
{
ai = GetAISpeciesArray( "axis", "all" );
found_guy = false;
foreach ( guy in ai )
{
if ( !isalive( guy ) )
continue;
if ( guy IsTouching( self ) )
{
found_guy = true;
break;
}
wait( 0.0125 );
}
if ( !found_guy )
{
aHostiles = self get_ai_touching_volume( "axis" );
if ( !aHostiles.size )
break;
}
wait( 0.05 );
}
}
waittill_volume_dead_or_dying()
{
ever_found_guy = false;
for ( ;; )
{
ai = GetAISpeciesArray( "axis", "all" );
found_guy = false;
foreach ( guy in ai )
{
if ( !isalive( guy ) )
continue;
if ( guy IsTouching( self ) )
{
if ( guy doingLongDeath() )
continue;
found_guy = true;
ever_found_guy = true;
break;
}
wait( 0.0125 );
}
if ( !found_guy )
{
aHostiles = self get_ai_touching_volume( "axis" );
if ( !aHostiles.size )
{
break;
}
else
{
ever_found_guy = true;
}
}
wait( 0.05 );
}
return ever_found_guy;
}
waittill_volume_dead_then_set_flag( sFlag )
{
self waittill_volume_dead();
flag_set( sFlag );
}
waittill_targetname_volume_dead_then_set_flag( targetname, msg )
{
volume = GetEnt( targetname, "targetname" );
AssertEx( IsDefined( volume ), "No volume for targetname " + targetname );
volume waittill_volume_dead_then_set_flag( msg );
}
player_can_be_shot()
{
level.player ent_flag_clear( "player_zero_attacker_accuracy" );
level.player.IgnoreRandomBulletDamage = false;
level.player maps\_gameskill::update_player_attacker_accuracy();
}
player_cant_be_shot()
{
level.player ent_flag_set( "player_zero_attacker_accuracy" );
level.player.attackeraccuracy = 0;
level.player.IgnoreRandomBulletDamage = true;
}
set_player_attacker_accuracy( val )
{
player = get_player_from_self();
player.gs.player_attacker_accuracy = val;
player maps\_gameskill::update_player_attacker_accuracy();
}
array_index_by_parameters( old_array )
{
array = [];
foreach ( item in old_array )
{
array[ item.script_parameters ] = item;
}
return array;
}
array_index_by_classname( old_array )
{
array = [];
foreach ( item in old_array )
{
array[ item.classname ] = item;
}
return array;
}
array_index_by_script_index( array )
{
newarray = [];
foreach ( ent in array )
{
index = ent.script_index;
if ( IsDefined( index ) )
{
AssertEx( !isdefined( newarray[ index ] ), "Multiple ents had the same script_index of " + index );
newarray[ index ] = ent;
}
}
return newarray;
}
add_target_pivot( ent )
{
if ( IsDefined( ent ) )
{
self.pivot = ent;
}
else
{
AssertEx( IsDefined( self.target ), "Tried to add pivot to an entity but it has no target." );
self.pivot = GetEnt( self.target, "targetname" );
AssertEx( IsDefined( self.pivot ), "Tried to add pivot but there was no pivot entity. Must be a script mover, like a script_origin not script_struct." );
}
self LinkTo( self.pivot );
}
get_color_volume_from_trigger()
{
info = self get_color_info_from_trigger();
team = info[ "team" ];
foreach ( code in info[ "codes" ] )
{
volume = level.arrays_of_colorCoded_volumes[ team ][ code ];
if ( IsDefined( volume ) )
return volume;
}
return undefined;
}
get_color_nodes_from_trigger()
{
info = self get_color_info_from_trigger();
team = info[ "team" ];
foreach ( code in info[ "codes" ] )
{
nodes = level.arrays_of_colorCoded_nodes[ team ][ code ];
if ( IsDefined( nodes ) )
return nodes;
}
return undefined;
}
flashBangStop()
{
self.flashendtime = undefined;
self SetFlashBanged( false );
}
getent_or_struct( param1, param2 )
{
ent = GetEnt( param1, param2 );
if ( IsDefined( ent ) )
return ent;
return getstruct( param1, param2 );
}
grenade_earthQuake()
{
self thread endOnDeath();
self endon( "end_explode" );
self waittill( "explode", position );
dirt_on_screen_from_position( position );
}
endOnDeath()
{
self waittill( "death" );
waittillframeend;
self notify( "end_explode" );
}
dirt_on_screen_from_position( position )
{
PlayRumbleOnPosition( "grenade_rumble", position );
Earthquake( 0.3, 0.5, position, 400 );
wii_play_grenade_rumble( position );
foreach ( player in level.players )
{
if ( Distance( position, player.origin ) > 600 )
continue;
if ( player DamageConeTrace( position ) )
player thread dirtEffect( position );
}
}
player_rides_shotgun_in_humvee( right, left, up, down )
{
return self player_rides_in_humvee( "shotgun", level.player, right, left, up, down );
}
player_rides_in_humvee( seat, rider, right, left, up, down )
{
if ( !isdefined( rider ) )
rider = level.player;
assert( isplayer( rider ) );
rider AllowCrouch( false );
rider AllowProne( false );
rider DisableWeapons();
org = spawn_tag_origin();
org LinkTo( self, "tag_passenger", player_rides_in_humvee_offset( seat ), ( 0, 0, 0 ) );
org.player_dismount = spawn_tag_origin();
org.player_dismount LinkTo( self, "tag_body", player_rides_humvee_offset_dismount( seat ), ( 0, 0, 0 ) );
if ( !isdefined( right ) )
right = 90;
if ( !isdefined( left ) )
left = 90;
if ( !isdefined( up ) )
up = 40;
if ( !isdefined( down ) )
down = 40;
rider DisableWeapons();
rider PlayerLinkTo( org, "tag_origin", 0.8, right, left, up, down );
rider.humvee_org = org;
return org;
}
player_rides_in_humvee_offset( seat )
{
switch( seat )
{
case "shotgun" :	return ( -5, 10, -34 );
case "backleft" :	return ( -45, 45, -34 );
case "backright" :	return ( -45, 5, -34 );
}
assertmsg( "No offset for " + seat + " was available in player_rides_in_humvee_offset()" );
}
player_rides_humvee_offset_dismount( seat )
{
switch( seat )
{
case "shotgun" :	return ( -8, -90, -12.6 );
case "backleft" :	return ( -58, 85, -12.6 );
case "backright" :	return ( -58, -95, -12.6 );
}
assertmsg( "No offset for " + seat + " was available in player_rides_humvee_offset_dismount()" );
}
player_leaves_humvee( skip_offset )
{
if ( !isdefined( skip_offset ) )
skip_offset = false;
org = self;
rider = level.player;
if ( isplayer( self ) )
{
rider = self;
org = rider.humvee_org;
}
org Unlink();
if ( !skip_offset )
{
move_time = 0.6;
org MoveTo( org.player_dismount.origin, move_time, move_time * 0.5, move_time * 0.5 );
wait( move_time );
}
rider Unlink();
rider EnableWeapons();
rider AllowCrouch( true );
rider AllowProne( true );
rider.humvee_org = undefined;
org.player_dismount Delete();
org Delete();
}
dirtEffect( position, attacker )
{
sides = screen_effect_sides( position );
foreach ( type, _ in sides )
{
self thread maps\_gameskill::grenade_dirt_on_screen( type );
}
}
bloodsplateffect( position )
{
if ( !IsDefined( self.damageAttacker ) )
{
return;
}
sides = screen_effect_sides( self.damageAttacker.origin );
foreach ( type, _ in sides )
{
self thread maps\_gameskill::blood_splat_on_screen( type );
}
}
screen_effect_sides( position )
{
forwardVec = VectorNormalize( AnglesToForward( self.angles ) );
rightVec = VectorNormalize( AnglesToRight( self.angles ) );
entVec = VectorNormalize( position - self.origin );
fDot = VectorDot( entVec, forwardVec );
rDot = VectorDot( entVec, rightVec );
sides = [];
curWeapon = self GetCurrentWeapon();
if ( fDot > 0 && fDot > 0.5 && WeaponType( curWeapon ) != "riotshield" )
{
sides[ "bottom" ] = true;
}
if ( abs( fDot ) < 0.866 )
{
if ( rDot > 0 )
{
sides[ "right" ] = true;
}
else
{
sides[ "left" ] = true;
}
}
return sides;
}
pathrandompercent_set( value )
{
if ( !isdefined( self.old_pathrandompercent ) )
self.old_pathrandompercent = self.pathrandompercent;
self.pathrandompercent = value;
}
pathrandompercent_zero()
{
if ( IsDefined( self.old_pathrandompercent ) )
return;
self.old_pathrandompercent = self.pathrandompercent;
self.pathrandompercent = 0;
}
pathrandompercent_reset()
{
Assert( IsDefined( self.old_pathrandompercent ) );
self.pathrandompercent = self.old_pathrandompercent;
self.old_pathrandompercent = undefined;
}
walkdist_zero()
{
if ( IsDefined( self.old_walkDistFacingMotion ) )
return;
self.old_walkDist = self.walkDist;
self.old_walkDistFacingMotion = self.walkDistFacingMotion;
self.walkdist = 0;
self.walkDistFacingMotion = 0;
}
walkdist_reset()
{
Assert( IsDefined( self.old_walkDist ) );
Assert( IsDefined( self.old_walkDistFacingMotion ) );
self.walkdist = self.old_walkDist;
self.walkDistFacingMotion = self.old_walkDistFacingMotion;
self.old_walkDist = undefined;
self.old_walkDistFacingMotion = undefined;
}
enable_ignorerandombulletdamage_drone()
{
self thread ignorerandombulletdamage_drone_proc();
}
ignorerandombulletdamage_drone_proc()
{
AssertEx( !IsSentient( self ), "AI tried to run enable_ignorerandombulletdamage_drone" );
self endon( "disable_ignorerandombulletdamage_drone" );
self endon( "death" );
self.IgnoreRandomBulletDamage = true;
self.fakehealth = self.health;
self.health = 1000000;
while ( 1 )
{
self waittill( "damage", damage, attacker );
if ( !isplayer( attacker ) && IsSentient( attacker ) )
{
if ( IsDefined( attacker.enemy ) && attacker.enemy != self )
continue;
}
self.fakehealth -= damage;
if ( self.fakehealth <= 0 )
break;
}
self Kill();
}
hide_notsolid()
{
if ( !isdefined( self.oldContents ) )
{
self.oldContents = self SetContents( 0 );
}
self Hide();
}
show_solid()
{
if ( !isai( self ) )
self Solid();
if ( IsDefined( self.oldContents ) )
{
self SetContents( self.oldContents );
}
self Show();
}
set_brakes( num )
{
self.veh_brake = num;
}
disable_ignorerandombulletdamage_drone()
{
if ( !isalive( self ) )
return;
if ( !isdefined( self.IgnoreRandomBulletDamage ) )
return;
self notify( "disable_ignorerandombulletdamage_drone" );
self.IgnoreRandomBulletDamage = undefined;
self.health = self.fakehealth;
}
timeOutEnt( timeOut )
{
ent = SpawnStruct();
ent delayThread( timeOut, ::send_notify, "timeout" );
return ent;
}
delayThread( timer, func, param1, param2, param3, param4, param5, param6 )
{
thread delayThread_proc( func, timer, param1, param2, param3, param4, param5, param6 );
}
enable_danger_react( duration )
{
duration *= 1000;
Assert( IsAI( self ) );
self.doDangerReact = true;
self.dangerReactDuration = duration;
self.neverSprintForVariation = undefined;
}
disable_danger_react()
{
Assert( IsAI( self ) );
self.doDangerReact = false;
self.neverSprintForVariation = true;
}
set_group_advance_to_enemy_parameters( interval, group_size )
{
level.advanceToEnemyInterval = interval;
level.advanceToEnemyGroupMax = group_size;
}
reset_group_advance_to_enemy_timer( team )
{
Assert( IsDefined( level.lastAdvanceToEnemyTime[ team ] ) );
level.lastAdvanceToEnemyTime[ team ] = GetTime();
}
set_custom_gameskill_func( func )
{
Assert( IsDefined( func ) );
level.custom_gameskill_func = func;
thread maps\_gameskill::resetSkill();
}
clear_custom_gameskill_func()
{
level.custom_gameskill_func = undefined;
thread maps\_gameskill::resetSkill();
}
set_wind( weight, rate, variance )
{
Assert( IsDefined( weight ) );
Assert( IsDefined( rate ) );
maps\_animatedmodels::init_wind_if_uninitialized();
if ( IsDefined( variance ) )
level.wind.variance = variance;
level.wind.rate = rate;
level.wind.weight = weight;
level notify( "windchange", "strong" );
}
string_is_single_digit_integer( str )
{
if ( str.size > 1 )
{
return false;
}
arr = [];
arr[ "0" ] = true;
arr[ "1" ] = true;
arr[ "2" ] = true;
arr[ "3" ] = true;
arr[ "4" ] = true;
arr[ "5" ] = true;
arr[ "6" ] = true;
arr[ "7" ] = true;
arr[ "8" ] = true;
arr[ "9" ] = true;
if ( IsDefined( arr[ str ] ) )
{
return true;
}
return false;
}
set_battlechatter_variable( team, val )
{
level.battlechatter[ team ] = val;
update_battlechatter_hud();
}
objective_clearAdditionalPositions( objective_number )
{
for ( i = 0; i < 8; i++ )
{
objective_additionalposition( objective_number, i, (0,0,0) );
}
}
get_minutes_and_seconds( milliseconds )
{
time = [];
time[ "minutes" ] = 0;
time[ "seconds" ] = Int( milliseconds / 1000 );
while ( time[ "seconds" ] >= 60 )
{
time[ "minutes" ]++;
time[ "seconds" ] -= 60;
}
if ( time[ "seconds" ] < 10 )
time[ "seconds" ] = "0" + time[ "seconds" ];
return time;
}
player_has_weapon( weap )
{
weaponList = level.player GetWeaponsListPrimaries();
foreach ( weapon in weaponList )
{
if ( weapon == weap )
return true;
}
return false;
}
obj( msg )
{
if ( !isdefined( level.obj_array ) )
{
level.obj_array = [];
}
if ( !isdefined( level.obj_array[ msg ] ) )
{
level.obj_array[ msg ] = level.obj_array.size + 1;
}
return level.obj_array[ msg ];
}
MusicLoop( alias, delay_between_tracks )
{
if ( !isdefined( delay_between_tracks ) )
delay_between_tracks = 0;
time = musicLength( alias );
assertex( time + delay_between_tracks > 0, "No time for delay" );
level notify( "stop_music" );
level endon( "stop_music" );
for ( ;; )
{
MusicPlayWrapper( alias );
wait time;
wait delay_between_tracks;
}
}
player_mount_vehicle( vehicle )
{
assert( isplayer( self ) );
self MountVehicle( vehicle );
self.drivingVehicle = vehicle;
}
player_dismount_vehicle()
{
assert( isplayer( self ) );
self DismountVehicle();
self.drivingVehicle = undefined;
}
graph_position( v, min_x, min_y, max_x, max_y )
{
rise = max_y - min_y;
run = max_x - min_x;
assertex( run != 0, "max and min x must be different, or you havent defined any graph space." );
slope = rise / run;
v -= max_x;
v = slope * v;
v += max_y;
return v;
}
enable_achievement_harder_they_fall()
{
self.rappeller = true;
}
disable_achievement_harder_they_fall()
{
self.rappeller = undefined;
}
enable_achievement_harder_they_fall_guy( guy )
{
guy enable_achievement_harder_they_fall();
}
disable_achievement_harder_they_fall_guy( guy )
{
guy disable_achievement_harder_they_fall();
}
musicLength( alias )
{
time = TableLookup( "soundtables/soundlength.csv", 0, alias, 1 );
if ( !isdefined( time ) || ( time == "" ) )
{
assertmsg( "No time stored in soundtables/soundlength.csv for " + alias + "." );
return -1;
}
time = int( time );
assertex( time > 0, "Music alias " + alias + " had zero time." );
time *= 0.001;
return time;
}
is_command_bound( cmd )
{
binding = GetKeyBinding( cmd );
return binding[ "count" ];
}
linear_interpolate( percentage, min_value, max_value )
{
assert( isdefined( percentage ) );
assert( isdefined( min_value ) );
assert( isdefined( max_value ) );
max_adjustment = max_value - min_value;
real_adjustment = percentage * max_adjustment;
final_value = min_value + real_adjustment;
return final_value;
}
is_iw4_map_sp()
{
switch( level.script )
{
case "oilrig":
case "boneyard":
case "cliffhanger":
case "dcburning":
case "estate":
case "airport":
case "favela":
case "gulag":
case "trainer":
case "favela_escape":
case "af_chase":
case "ending":
case "roadkill":
case "arcadia":
case "af_caves":
case "dcemp":
case "dc_whitehouse":
case "iw4_credits":
case "so_escape_airport":
case "so_download_arcadia":
case "so_intel_boneyard":
case "so_bridge":
case "so_crossing_so_bridge":
case "so_demo_so_bridge":
case "so_sabotage_cliffhanger":
case "so_snowrace1_cliffhanger":
case "so_snowrace2_cliffhanger":
case "so_rooftop_contingency":
case "so_forest_contingency":
case "so_defuse_favela_escape":
case "so_takeover_estate":
case "so_juggernauts_favela":
case "so_killspree_favela":
case "so_ghillies":
case "so_hidden_so_ghillies":
case "so_showers_gulag":
case "co_hunted":
case "so_ac130_co_hunted":
case "so_chopper_invasion":
case "so_killspree_invasion":
case "so_defense_invasion":
case "so_assault_oilrig":
case "so_takeover_oilrig":
case "so_killspree_trainer":
case "so_civilrescue":
case "contingency":
case "invasion":
case "bog_b":
return true;
default:
return false;
}
}
define_loadout( levelname )
{
level.loadout = levelname;
}
template_level( levelname )
{
define_loadout( levelname );
define_introscreen( levelname );
level.template_script = levelname;
}
template_so_level( levelname )
{
level.audio_stringtable_mapname = levelname;
}
define_introscreen( levelname )
{
level.introscreen_levelname = levelname;
}
fx_volume_pause_noteworthy( noteworthy, dodelayed )
{
thread fx_volume_pause_noteworthy_thread( noteworthy, dodelayed );
}
fx_volume_pause_noteworthy_thread( noteworthy, dodelayed )
{
volume = GetEnt( noteworthy, "script_noteworthy" );
volume notify ( "new_volume_command" );
volume endon ( "new_volume_command" );
wait 0.05;
fx_volume_pause( volume, dodelayed );
}
fx_volume_pause( volume, dodelayed )
{
Assert( IsDefined( volume ) );
volume.fx_paused = true;
if ( !IsDefined( dodelayed ) )
dodelayed = false;
if( dodelayed )
array_thread_mod_delayed( volume.fx, ::pauseeffect );
else
array_thread( volume.fx, ::pauseeffect );
}
array_thread_mod_delayed( array, threadname, mod )
{
inc = 0;
if ( !IsDefined( mod ) )
mod = 5;
send_array = [];
foreach( object in array )
{
send_array[ send_array.size ] = object;
inc ++;
inc %= mod;
if( mod == 0 )
{
array_thread( send_array, threadname );
wait 0.05;
send_array = [];
}
}
}
fx_volume_restart_noteworthy( noteworthy )
{
thread fx_volume_restart_noteworthy_thread( noteworthy );
}
fx_volume_restart_noteworthy_thread( noteworthy )
{
volume = GetEnt( noteworthy, "script_noteworthy" );
volume notify ( "new_volume_command" );
volume endon ( "new_volume_command" );
wait 0.05;
if( ! IsDefined( volume.fx_paused ) )
return;
volume.fx_paused = undefined;
fx_volume_restart( volume );
}
fx_volume_restart( volume )
{
Assert( IsDefined( volume ) );
array_thread( volume.fx, ::restartEffect );
}
flag_count_increment( msg )
{
AssertEx( flag_exist( msg ), "Attempt to increment flag before calling flag_init: " + msg );
if ( !IsDefined( level.flag_count ) )
level.flag_count = [];
if ( ! IsDefined( level.flag_count[ msg ] ) )
level.flag_count[ msg ] = 1;
else
level.flag_count[ msg ]++;
}
flag_count_decrement( msg )
{
AssertEx( flag_exist( msg ) , "Attempt to decrement flag before calling flag_init: " + msg );
AssertEx( IsDefined( level.flag_count ) && IsDefined( level.flag_count[ msg ] ), "Can't decrement a flag that's never been set/incremented." );
level.flag_count[ msg ]--;
level.flag_count[ msg ] = int( max( 0, level.flag_count[ msg ] ) );
if ( level.flag_count[ msg ] )
return;
flag_set( msg );
}
flag_count_set( msg, count )
{
AssertEx( count, "don't support setting to Zero" );
AssertEx( flag_exist( msg ) , "Attempt to set flag count before calling flag_init: " + msg );
level.flag_count[ msg ] = count;
}
add_cleanup_ent( ent, groupname )
{
Assert( IsDefined( ent ) );
Assert( IsDefined( groupname ) );
if ( !IsDefined( level.cleanup_ents ) )
level.cleanup_ents = [];
if ( !IsDefined( level.cleanup_ents[ groupname ] ) )
level.cleanup_ents[ groupname ] = [];
level.cleanup_ents[ groupname ][ level.cleanup_ents[ groupname ].size ] = ent;
}
cleanup_ents( groupname )
{
Assert( IsDefined( level.cleanup_ents ) );
Assert( IsDefined( level.cleanup_ents[ groupname ] ) );
array = level.cleanup_ents[ groupname ];
array = array_removeUndefined( array );
array_delete( array );
level.cleanup_ents[ groupname ] = undefined;
}
cleanup_ents_removing_bullet_shield( groupname )
{
if( ! IsDefined( level.cleanup_ents ) )
return;
if( ! IsDefined( level.cleanup_ents[ groupname ] ) )
return;
array = level.cleanup_ents[ groupname ];
array = array_removeUndefined( array );
foreach( obj in array )
{
if ( ! IsAI( obj ) )
continue;
if ( !IsAlive( obj ) )
continue;
if ( ! IsDefined( obj.magic_bullet_shield ) )
continue;
if( !obj.magic_bullet_shield )
continue;
obj stop_magic_bullet_shield();
}
array_delete( array );
level.cleanup_ents[ groupname ] = undefined;
}
add_trigger_function( function )
{
if( !isdefined( self.trigger_functions ) )
self thread add_trigger_func_thread();
self.trigger_functions[ self.trigger_functions.size ] = function;
}
getallweapons()
{
array = [];
entities = GetEntArray();
foreach( ent in entities )
{
if ( !IsDefined( ent.classname ) )
continue;
if ( IsSubStr( ent.classname, "weapon_" ) )
array[array.size] = ent;
}
return array;
}
radio_add( dialog )
{
level.scr_radio[dialog ] = dialog;
}
move_with_rate( origin, angles, moverate )
{
Assert( IsDefined( origin ) );
Assert( IsDefined( angles ) );
Assert( IsDefined( moverate ) );
self notify( "newmove" );
self endon( "newmove" );
if ( !isdefined( moverate ) )
moverate = 200;
dist = Distance( self.origin, origin );
movetime = dist / moverate;
movevec = VectorNormalize( origin - self.origin );
self MoveTo( origin, movetime, 0, 0 );
self RotateTo( angles, movetime, 0, 0 );
wait movetime;
if ( !isdefined( self ) )
return;
self.velocity = movevec * ( dist / movetime );
}
flag_on_death( msg )
{
level endon( msg );
self waittill( "death" );
flag_set( msg );
}
geoMode()
{
return GetDvar( "geomode" ) == "1";
}
enable_damagefeedback()
{
level.damagefeedback = true;
}
disable_damagefeedback()
{
level.damagefeedback = false;
}
is_damagefeedback_enabled()
{
return ( isdefined( level.damagefeedback ) && level.damagefeedback );
}
add_damagefeedback()
{
assert( isdefined( self ) );
self maps\_damagefeedback::monitorDamage();
}
remove_damagefeedback()
{
assert( isdefined( self ) );
self maps\_damagefeedback::stopMonitorDamage();
}
is_demo()
{
if ( GetDvar( "e3demo" ) == "1" )
{
return true;
}
return false;
}
deletestructarray( value, key, delay )
{
structs = getstructarray( value, key );
deletestructarray_ref( structs, delay );
}
deletestruct_ref( struct )
{
if ( !IsDefined( struct ) )
return;
value = struct.script_linkname;
if ( IsDefined( value ) &&
IsDefined( level.struct_class_names[ "script_linkname" ] ) &&
IsDefined( level.struct_class_names[ "script_linkname" ][ value ] ) )
{
foreach( i, _struct in level.struct_class_names[ "script_linkname" ][ value ] )
if ( IsDefined( _struct ) && struct == _struct )
level.struct_class_names[ "script_linkname" ][ value ][ i ] = undefined;
if ( level.struct_class_names[ "script_linkname" ][ value ].size == 0 )
level.struct_class_names[ "script_linkname" ][ value ] = undefined;
}
value = struct.script_noteworthy;
if ( IsDefined( value ) &&
IsDefined( level.struct_class_names[ "script_noteworthy" ] ) &&
IsDefined( level.struct_class_names[ "script_noteworthy" ][ value ] ) )
{
foreach( i, _struct in level.struct_class_names[ "script_noteworthy" ][ value ] )
if ( IsDefined( _struct ) && struct == _struct )
level.struct_class_names[ "script_noteworthy" ][ value ][ i ] = undefined;
if ( level.struct_class_names[ "script_noteworthy" ][ value ].size == 0 )
level.struct_class_names[ "script_noteworthy" ][ value ] = undefined;
}
value = struct.target;
if ( IsDefined( value ) &&
IsDefined( level.struct_class_names[ "target" ] ) &&
IsDefined( level.struct_class_names[ "target" ][ value ] ) )
{
foreach( i, _struct in level.struct_class_names[ "target" ][ value ] )
if ( IsDefined( _struct ) && struct == _struct )
level.struct_class_names[ "target" ][ value ][ i ] = undefined;
if ( level.struct_class_names[ "target" ][ value ].size == 0 )
level.struct_class_names[ "target" ][ value ] = undefined;
}
value = struct.targetname;
if ( IsDefined( value ) &&
IsDefined( level.struct_class_names[ "targetname" ] ) &&
IsDefined( level.struct_class_names[ "targetname" ][ value ] ) )
{
foreach( i, _struct in level.struct_class_names[ "targetname" ][ value ] )
if ( IsDefined( _struct ) && struct == _struct )
level.struct_class_names[ "targetname" ][ value ][ i ] = undefined;
if ( level.struct_class_names[ "targetname" ][ value ].size == 0 )
level.struct_class_names[ "targetname" ][ value ] = undefined;
}
if ( IsDefined( level.struct ) )
foreach ( i, _struct in level.struct )
if ( struct == _struct )
level.struct[ i ] = undefined;
}
deletestructarray_ref( structs, delay )
{
if ( !IsDefined( structs ) || !IsArray( structs ) || structs.size == 0 )
return;
delay = ter_op( IsDefined( delay ), delay, 0 );
delay = ter_op( delay > 0, delay, 0 );
if ( delay > 0 )
{
foreach ( struct in structs )
{
deletestruct_ref( struct );
wait delay;
}
}
else
foreach ( struct in structs )
deletestruct_ref( struct );
}
getstruct_delete( value, key )
{
struct = getstruct( value, key );
deletestruct_ref( struct );
return struct;
}
getstructarray_delete( value, key, delay )
{
structs = getstructarray( value, key );
deletestructarray_ref( structs, delay );
return structs;
}
getent_or_struct_or_node( value, key )
{
Assert( IsDefined( value ) );
Assert( IsDefined( key ) );
ent = getent_or_struct( value, key );
if ( !IsDefined( ent ) )
ent = GetNode( value, key );
if ( !IsDefined( ent ) )
ent = GetVehicleNode( value, key );
return ent;
}
setEntityHeadIcon( icon_shader, icon_width, icon_height, offset, reference_point_func )
{
assertex( isdefined( icon_shader ), "setEntityHeadIcon() requires icon shader passed in." );
if ( isDefined( offset ) )
self.entityHeadIconOffset = offset;
else
self.entityHeadIconOffset = (0,0,0);
if( isDefined( reference_point_func ) )
self.entityHeadIconReferenceFunc = reference_point_func;
self notify( "new_head_icon" );
headIcon = newhudelem();
headIcon.archived = true;
headIcon.alpha = .8;
headIcon setShader( icon_shader, icon_width, icon_height );
headIcon setWaypoint( false, false, false, true );
self.entityHeadIcon = headIcon;
self updateEntityHeadIconOrigin();
self thread updateEntityHeadIcon();
self thread destroyEntityHeadIconOnDeath();
}
removeEntityHeadIcon()
{
if ( !isdefined( self.entityHeadIcon ) )
return;
self.entityHeadIcon destroy();
}
updateEntityHeadIcon()
{
self endon( "new_head_icon" );
self endon( "death" );
pos = self.origin;
while(1)
{
if ( pos != self.origin )
{
self updateEntityHeadIconOrigin();
pos = self.origin;
}
wait .05;
}
}
updateEntityHeadIconOrigin()
{
if( isDefined( self.entityHeadIconReferenceFunc ) )
{
entityHeadIconReference = self [[ self.entityHeadIconReferenceFunc ]]();
if( isdefined( entityHeadIconReference ) )
{
self.entityHeadIcon.x = self.entityHeadIconOffset[0] + entityHeadIconReference[0];
self.entityHeadIcon.y = self.entityHeadIconOffset[1] + entityHeadIconReference[1];
self.entityHeadIcon.z = self.entityHeadIconOffset[2] + entityHeadIconReference[2];
return;
}
}
self.entityHeadIcon.x = self.origin[0] + self.entityHeadIconOffset[0];
self.entityHeadIcon.y = self.origin[1] + self.entityHeadIconOffset[1];
self.entityHeadIcon.z = self.origin[2] + self.entityHeadIconOffset[2];
}
destroyEntityHeadIconOnDeath()
{
self endon( "new_head_icon" );
self waittill( "death" );
if( !isDefined(self.entityHeadIcon) )
return;
self.entityHeadIcon destroy();
}
is_split_level()
{
if( !IsDefined( level.script ) )
{
level.script = ToLower( GetDvar( "mapname" ) );
}
if( IsSubStr( level.script, "_" ) )
{
tokens = StrTok( level.script, "_" );
foreach( token in tokens )
{
if( token == "a" || token == "b" || token == "c" || token == "d" || token == "a2" )
{
return true;
}
}
}
return false;
}
is_split_level_part( strPart )
{
Assert( IsDefined( strPart ) );
if( !IsDefined( level.script ) )
{
level.script = ToLower( GetDvar( "mapname" ) );
}
if( IsSubStr( level.script, "_" ) )
{
tokens = StrTok( level.script, "_" );
foreach( token in tokens )
{
if( token == strPart )
{
return true;
}
}
}
return false;
}
is_split_level_part_or_original( strPart )
{
Assert( IsDefined( strPart ) );
if( !IsDefined( level.script ) )
{
level.script = ToLower( GetDvar( "mapname" ) );
}
if( !is_split_level() )
{
return true;
}
if( IsSubStr( level.script, "_" ) )
{
tokens = StrTok( level.script, "_" );
foreach( token in tokens )
{
if( token == strPart )
{
return true;
}
}
}
return false;
}
get_split_level_original_name()
{
if( !IsDefined( level.script ) )
{
level.script = ToLower( GetDvar( "mapname" ) );
}
if( IsSubStr( level.script, "_" ) )
{
if( !IsDefined( level.script_original ) )
{
originalName = "";
tokens = StrTok( level.script, "_" );
foreach(index,token in tokens)
{
if( token == "a" || token == "b" || token == "c" || token == "d" || token == "a2" )
{
continue;
}
originalName += token;
if( index < ( tokens.size - 2 ) )
{
originalName += "_";
}
}
level.script_original = originalName;
}
return level.script_original;
}
return level.script;
}
set_allowBlackScreenSoundFade_wait(value, waitTime)
{
wait(waitTime);
setDvar("cg_allowBlackScreenSoundFade", value);
}
do_wiigeomstreamnotify( suppressText, suppressBlackScreen, waitForTextureStream, isInvulnerable, dontFadeSound )
{
if( !IsDefined( suppressText ) )
{
suppressText = 1;
}
if( !IsDefined( suppressBlackScreen ) )
{
suppressBlackScreen = 1;
}
if( !IsDefined( waitForTextureStream ) )
{
waitForTextureStream = 0;
}
if( !IsDefined( isInvulnerable ) )
{
isInvulnerable = false;
}
oldSoundFade = getDvar("cg_allowBlackScreenSoundFade", 0);
if( IsDefined( dontFadeSound ) && dontFadeSound )
{
setDvar("cg_allowBlackScreenSoundFade", 0);
}
wiigeomstreamnotify( suppressText, suppressBlackScreen, waitForTextureStream );
if( isInvulnerable )
{
level.player EnableInvulnerability();
}
level waittill( "geom_stream_done" );
if( IsDefined( dontFadeSound ) && dontFadeSound )
{
self thread set_allowBlackScreenSoundFade_wait(oldSoundFade, 2.0);
}
if( isInvulnerable )
{
level.player DisableInvulnerability();
}
}
do_forcestreamerdefrag( delay )
{
if( IsDefined( delay ) )
{
wait( delay );
}
level.player forcestreamerdefrag();
}