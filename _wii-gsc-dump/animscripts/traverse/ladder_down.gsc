
#using_animtree( "generic_human" );
main()
{
self.desired_anim_pose = "crouch";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self traverseMode( "nogravity" );
self traverseMode( "noclip" );
endnode = self getnegotiationendnode();
assert( isdefined( endnode ) );
endPos = endnode.origin;
startnode = self getnegotiationstartnode();
assert( isdefined( startnode ) );
self OrientMode( "face angle", startnode.angles[ 1 ] );
rate = 1;
if ( IsDefined ( self.moveplaybackrate ) )
rate = self.moveplaybackrate;
self setFlaggedAnimKnoballRestart( "climbanim", %ladder_climbon, %body, 1, .1, rate );
self animscripts\shared::DoNoteTracks( "climbanim" );
climbAnim = %ladder_climbdown;
self setFlaggedAnimKnoballRestart( "climbanim", climbAnim, %body, 1, .1, rate );
cycleDelta = GetMoveDelta( climbAnim, 0, 1 );
climbRate = cycleDelta[ 2 ] * rate / getanimlength( climbAnim );
climbingTime = ( endPos[ 2 ] - self.origin[ 2 ] ) / climbRate;
self animscripts\notetracks::DoNoteTracksForTime( climbingTime, "climbanim" );
self traverseMode( "gravity" );
self.a.movement = "stop";
self.a.pose = "stand";
}
