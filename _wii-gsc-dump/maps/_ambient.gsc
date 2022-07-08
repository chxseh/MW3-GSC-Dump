#include maps\_audio;
setup_new_eq_settings( track, eqIndex )
{
if ( !isdefined( track ) || !isdefined( level.ambient_eq[ track ] ) )
{
deactivate_index( eqIndex );
return false;
}
if ( level.eq_track[ eqIndex ] == track )
{
return false;
}
level.eq_track[ eqIndex ] = track;
use_eq_settings( track, eqIndex );
return true;
}
use_eq_settings( presetname, eqIndex )
{
assertEx(IsString(presetname), "use_eq_settings: requires a presetname.");
assertEx(IsDefined(eqIndex), "use_eq_settings: requires an eqIndex parameter.");
if ( level.player maps\_utility::ent_flag( "player_has_red_flashing_overlay" ) )
return;
aud_set_filter(presetname, eqIndex);
}
deactivate_index( eqIndex )
{
assert(IsDefined(eqIndex));
level.eq_track[ eqIndex ] = "";
level.player deactivateeq( eqIndex );
}
blend_to_eq_track( eqIndex, time_ )
{
assertEx(IsDefined(eqIndex), "blend_to_eq_track requires an eqIndex.");
time = 1.0;
if (IsDefined(time_))
time = time_;
interval = .05;
count = time / interval;
fraction = 1 / count;
for ( i = 0; i <= 1; i += fraction )
{
level.player SetEqLerp( i, eqIndex );
wait( interval );
}
level.player SetEqLerp( 1, eqIndex );
}
use_reverb_settings( reverb_preset )
{
assert(IsString(reverb_preset));
if ( level.player maps\_utility::ent_flag( "player_has_red_flashing_overlay" ) )
return;
}
deactivate_reverb()
{
}
ambientDelay( foo, bar, baz)
{
aud_print_warning("ambientDelay called, this is deprecated! Use new preset string tables.");
}
ambientEvent( track, name, weight, min_dist, max_dist, start_angle, end_angle )
{
aud_print_warning("ambientEvent called, this is deprecated! Use new preset string tables.");
}
ambientEventStart( track )
{
aud_print_warning("ambientEventStart called, this is deprecated! Use maps\_utility::set_ambient( track, fade_ ).");
maps\_utility::set_ambient(track);
}
start_ambient_event( track )
{
aud_print_warning("start_ambient_event called, this is deprecated! Use maps\_utility::set_ambient( track, fade_ ).");
maps\_utility::set_ambient(track);
}
get_progess(start, end, dist, org)
{
maps\_utility::get_progress( start, end, org, dist );
}