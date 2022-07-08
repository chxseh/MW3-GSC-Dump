
#include animscripts\traverse\shared;
#using_animtree( "generic_human" );
main()
{
if ( self.type == "dog" )
{
dog_long_jump( "window_40", 20 );
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
jumpAnims = [];
jumpAnims[0] = %jump_across_100_spring;
jumpAnims[1] = %jump_across_100_lunge;
jumpAnims[2] = %jump_across_100_stumble;
jumpanim = jumpAnims[ randomint( jumpAnims.size ) ];
self setFlaggedAnimKnoballRestart( "jumpanim", jumpanim, %body, 1, .1, 1 );
self animscripts\shared::DoNoteTracks( "jumpanim" );
}
