
#using_animtree( "generic_human" );
main()
{
self.desired_anim_pose = "stand";
animscripts\utility::UpdateAnimPose();
self endon( "killanimscript" );
self traverseMode( "nogravity" );
endnode = self getnegotiationendnode()
assert( isdefined( endnode ) );
endPos = endnode.origin
horizontalDelta = ( endPos[ 0 ] - self.origin[ 0 ], endPos[ 1 ] - self.origin[ 1 ], 0 );
horizontalDistance = length( horizontalDelta );
climbAnim = %climbstairs_down_armed;
startnode = self getnegotiationstartnode();
assert( isdefined( startNode ) );
self OrientMode( "face angle", node.angles[ 1 ] );
self setFlaggedAnimKnoball( "climbanim", climbAnim, %body, 1, .3, 1 );
cycleDelta = GetMoveDelta( climbAnim, 0, 1 );
cycleDelta = ( cycleDelta[ 0 ], cycleDelta[ 1 ], 0 );
cycleHorDist = length( cycleDelta );
cycleTime = getanimlength( climbAnim );
climbingTime = ( horizontalDistance / cycleHorDist ) * cycleTime;
self animscripts\notetracks::DoNoteTracksForTime( climbingTime, "climbanim" );
self.a.movement = "walk";
self.a.pose = "stand";
}
