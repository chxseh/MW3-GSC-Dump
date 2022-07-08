#include animscripts\traverse\shared;
#using_animtree( "generic_human" );
main()
{
if ( self.type == "dog" )
dog_jump_up( 40, 3 );
else
step_up_human();
}
step_up_human()
{
self.desired_anim_pose = "crouch";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self.a.movement = "walk";
self traverseMode( "nogravity" );
startnode = self getnegotiationstartnode();
assert( isdefined( startnode ) );
self OrientMode( "face angle", startnode.angles[ 1 ] );
self setFlaggedAnimKnoballRestart( "stepanim", %step_up_low_wall, %body, 1, .1, 1 );
self waittillmatch( "stepanim", "gravity on" );
self traverseMode( "gravity" );
self animscripts\shared::DoNoteTracks( "stepanim" );
self setAnimKnobAllRestart( animscripts\run::GetCrouchRunAnim(), %body, 1, 0.1, 1 );
}

