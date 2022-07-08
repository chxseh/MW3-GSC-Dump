
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
self clearanim( %stand_and_crouch, 0.1 );
self setFlaggedAnimKnoballRestart( "diveanim", %jump_over_high_wall, %body, 1, .1, 1 );
self playsound( "dive_wall" );
self waittillmatch( "diveanim", "gravity on" );
self traverseMode( "nogravity" );
self waittillmatch( "diveanim", "noclip" );
self traverseMode( "noclip" );
self waittillmatch( "diveanim", "gravity on" );
self traverseMode( "gravity" );
self animscripts\shared::DoNoteTracks( "diveanim" );
}

