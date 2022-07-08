
#include animscripts\traverse\shared;
#using_animtree( "generic_human" );
main()
{
if ( self.type == "dog" )
{
dog_long_jump( "wallhop", 20 );
return;
}
self.desired_anim_pose = "stand";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self traverseMode( "nogravity" );
self traverseMode( "noclip" );
startnode = self getnegotiationstartnode();
assert( isdefined( startnode ) );
self OrientMode( "face angle", startnode.angles[ 1 ] );
self setFlaggedAnimKnoballRestart( "jumpanim", %jump_across_72, %body, 1, .1, 1 );
self waittillmatch( "jumpanim", "gravity on" );
self traverseMode( "gravity" );
self animscripts\shared::DoNoteTracks( "jumpanim" );
}
