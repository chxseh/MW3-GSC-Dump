
#using_animtree( "generic_human" );
main()
{
self.desired_anim_pose = "crouch";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self.a.movement = "walk";
self traverseMode( "nogravity" );
startnode = self getnegotiationstartnode();
assert( isdefined( startnode ) );
self OrientMode( "face angle", startnode.angles[ 1 ] );
self setFlaggedAnimKnoballRestart( "stepanim", %jump_across_72, %body, 1, .1, 1 );
wait .15;
self traverseMode( "gravity" );
self animscripts\shared::DoNoteTracks( "stepanim" );
}