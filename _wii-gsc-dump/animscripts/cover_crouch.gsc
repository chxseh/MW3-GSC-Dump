#include animscripts\Combat_utility;
#include animscripts\Utility;
#include common_scripts\Utility;
#using_animtree( "generic_human" );
main()
{
self endon( "killanimscript" );
animscripts\utility::initialize( "cover_crouch" );
self animscripts\cover_wall::cover_wall_think( "crouch" );
}
end_script()
{
self.coverCrouchLean_aimmode = undefined;
animscripts\cover_behavior::end_script( "crouch" );
}
