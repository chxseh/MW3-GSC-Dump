#include common_scripts\utility;
#using_animtree( "animated_props" );
main()
{
if( !isdefined ( level.anim_prop_models ) )
level.anim_prop_models = [];
mapname = tolower( getdvar( "mapname" ) );
SP = true;
if ( string_starts_with( mapname, "mp_" ) )
SP = false;
model = "fence_tarp_132x82";
if ( SP )
{
level.anim_prop_models[ model ][ "wind" ] = %fence_tarp_132x82_med_01;
}
else
level.anim_prop_models[ model ][ "wind" ] = "fence_tarp_132x82_med_01";
}
    