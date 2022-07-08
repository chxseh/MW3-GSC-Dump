#include maps\_utility;
main()
{
}
add_context_sensative_dialog( name1, name2, group, soundAlias )
{
assert( isdefined( name1 ) );
assert( isdefined( name2 ) );
assert( isdefined( group ) );
assert( isdefined( soundAlias ) );
assert( soundexists( soundAlias ) == true );
if ( ( !isdefined( level.scr_sound[ name1 ] ) ) || ( !isdefined( level.scr_sound[ name1 ][ name2 ] ) ) || ( !isdefined( level.scr_sound[ name1 ][ name2 ][ group ] ) ) )
{
level.scr_sound[ name1 ][ name2 ][ group ] = spawnStruct();
level.scr_sound[ name1 ][ name2 ][ group ].played = false;
level.scr_sound[ name1 ][ name2 ][ group ].sounds = [];
}
index = level.scr_sound[ name1 ][ name2 ][ group ].sounds.size;
level.scr_sound[ name1 ][ name2 ][ group ].sounds[ index ] = soundAlias;
}
add_context_sensative_timeout( name1, name2, groupNum, timeoutDuration )
{
if ( !isdefined( level.context_sensative_dialog_timeouts ) )
level.context_sensative_dialog_timeouts = [];
createStruct = false;
if ( !isdefined( level.context_sensative_dialog_timeouts[ name1 ] ) )
createStruct = true;
else if ( !isdefined( level.context_sensative_dialog_timeouts[ name1 ][ name2 ] ) )
createStruct = true;
if ( createStruct )
level.context_sensative_dialog_timeouts[ name1 ][ name2 ] = spawnStruct();
if ( isdefined( groupNum ) )
{
level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups = [];
level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ] = spawnStruct();
level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "timeoutDuration" ] = timeoutDuration * 1000;
level.context_sensative_dialog_timeouts[ name1 ][ name2 ].groups[ string( groupNum ) ].v[ "lastPlayed" ] = ( timeoutDuration * - 1000 );
}
else
{
level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v[ "timeoutDuration" ] = timeoutDuration * 1000;
level.context_sensative_dialog_timeouts[ name1 ][ name2 ].v[ "lastPlayed" ] = ( timeoutDuration * - 1000 );
}
}