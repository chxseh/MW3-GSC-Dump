
#using_animtree( "generic_human" );
main()
{
self.desired_anim_pose = "crouch";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self traverseMode( "nogravity" );
self traverseMode( "noclip" );
startnode = self getnegotiationstartnode();
assert( isdefined( startnode ) );
self OrientMode( "face angle", startnode.angles[ 1 ] );
self setFlaggedAnimKnoballRestart( "diveanim", %fenceclimb, %body, 1, .1, 1 );
self animscripts\shared::DoNoteTracks( "diveanim" );
self traverseMode( "gravity" );
}
