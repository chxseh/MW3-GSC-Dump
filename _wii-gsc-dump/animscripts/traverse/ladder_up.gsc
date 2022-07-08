
#using_animtree( "generic_human" );
main()
{
if ( isdefined( self.type ) && self.type == "dog" )
return;
self.desired_anim_pose = "crouch";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self traverseMode( "noclip" );
climbAnim = %ladder_climbup;
endAnim = %ladder_climboff;
startnode = self getnegotiationstartnode();
assert( isdefined( startnode ) );
self OrientMode( "face angle", startnode.angles[ 1 ] );
rate = 1;
if ( IsDefined ( self.moveplaybackrate ) )
rate = self.moveplaybackrate;
self setFlaggedAnimKnoballRestart( "climbanim", climbAnim, %body, 1, .1, rate );
endAnimDelta = GetMoveDelta( endAnim, 0, 1 );
endNode = self getnegotiationendnode();
assert( isdefined( endnode ) );
endPos = endnode.origin - endAnimDelta + ( 0, 0, 1 );
cycleDelta = GetMoveDelta( climbAnim, 0, 1 );
climbRate = cycleDelta[ 2 ] * rate / getanimlength( climbAnim );
climbingTime = ( endPos[ 2 ] - self.origin[ 2 ] ) / climbRate;
if ( climbingTime > 0 )
{
self.allowpain = true;
self animscripts\notetracks::DoNoteTracksForTime( climbingTime, "climbanim" );
self setFlaggedAnimKnoballRestart( "climbanim", endAnim, %body, 1, .1, rate );
self animscripts\shared::DoNoteTracks( "climbanim" );
}
self traverseMode( "gravity" );
self.a.movement = "run";
self.a.pose = "crouch";
}

