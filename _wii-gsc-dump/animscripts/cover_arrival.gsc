#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include animscripts\animset;
#include common_scripts\utility;
#include maps\_utility;
#using_animtree( "generic_human" );
maxSpeed = 250;
allowedError = 8;
main()
{
self endon( "killanimscript" );
self endon( "abort_approach" );
approachnumber = self.approachNumber;
assert( isdefined( self.approachtype ) );
arrivalAnim = anim.coverTrans[ self.approachtype ][ approachnumber ];
assert( isdefined( arrivalAnim ) );
if ( !isdefined( self.heat ) )
self thread abortApproachIfThreatened();
self clearanim( %body, 0.2 );
self setFlaggedAnimRestart( "coverArrival", arrivalAnim, 1, 0.2, self.moveTransitionRate );
self animscripts\shared::DoNoteTracks( "coverArrival", ::handleStartAim );
newstance = anim.arrivalEndStance[ self.approachType ];
assertex( isdefined( newstance ), "bad node approach type: " + self.approachtype );
if ( isdefined( newstance ) )
self.a.pose = newstance;
self.a.movement = "stop";
self.a.arrivalType = self.approachType;
self clearanim( %root, .3 );
self.lastApproachAbortTime = undefined;
}
handleStartAim( note )
{
if ( note == "start_aim" )
{
if ( self.a.pose == "stand" )
{
self set_animarray_standing();
}
else if ( self.a.pose == "crouch" )
{
self set_animarray_crouching();
}
else
{
assertMsg( "Unsupported self.a.pose: " + self.a.pose );
}
self animscripts\combat::set_aim_and_turn_limits();
self.previousPitchDelta = 0.0;
setupAim( 0 );
self thread animscripts\track::trackShootEntOrPos();
}
}
isThreatenedByEnemy()
{
if ( !isdefined( self.node ) )
return false;
if ( isdefined( self.enemy ) && self seeRecently( self.enemy, 1.5 ) && distanceSquared( self.origin, self.enemy.origin ) < 250000 )
return !( self isCoverValidAgainstEnemy() );
return false;
}
abortApproachIfThreatened()
{
self endon( "killanimscript" );
while ( 1 )
{
if ( !isdefined( self.node ) )
return;
if ( isThreatenedByEnemy() )
{
self clearanim( %root, .3 );
self notify( "abort_approach" );
self.lastApproachAbortTime = getTime();
return;
}
wait 0.1;
}
}
getNodeStanceYawOffset( approachtype )
{
if ( isdefined( self.heat ) )
return 0;
if ( approachtype == "left" || approachtype == "left_crouch" )
return 90.0;
else if ( approachtype == "right" || approachtype == "right_crouch" )
return - 90.0;
return 0;
}
canUseSawApproach( node )
{
if ( !usingMG() )
return false;
if ( !isDefined( node.turretInfo ) )
return false;
if ( node.type != "Cover Stand" && node.type != "Cover Prone" && node.type!= "Cover Crouch" )
return false;
if ( isDefined( self.enemy ) && distanceSquared( self.enemy.origin, node.origin ) < 256 * 256 )
return false;
if ( GetNodeYawToEnemy() > 40 || GetNodeYawToEnemy() < - 40 )
return false;
return true;
}
determineNodeApproachType( node )
{
if ( canUseSawApproach( node ) )
{
if ( node.type == "Cover Stand" )
return "stand_saw";
if ( node.type == "Cover Crouch" )
return "crouch_saw";
else if ( node.type == "Cover Prone" )
return "prone_saw";
}
if ( !isdefined( anim.approach_types[ node.type ] ) )
return;
if ( isdefined( node.arrivalStance ) )
stance = node.arrivalStance;
else
stance = node getHighestNodeStance();
if ( stance == "prone" )
stance = "crouch";
type = anim.approach_types[ node.type ][ stance ];
if ( self use_readystand() && type == "exposed" )
{
type = "exposed_ready";
}
if ( self shouldCQB() )
{
cqbType = type + "_cqb";
if ( isdefined( anim.coverTrans[ cqbType ] ) )
type = cqbType;
}
return type;
}
determineNodeExitType( node )
{
if ( canUseSawApproach( node ) )
{
if ( node.type == "Cover Stand" )
return "stand_saw";
if ( node.type == "Cover Crouch" )
return "crouch_saw";
else if ( node.type == "Cover Prone" )
return "prone_saw";
}
if ( !isdefined( anim.approach_types[ node.type ] ) )
return;
if ( isdefined( anim.requiredExitStance[ node.type ] ) && anim.requiredExitStance[ node.type ] != self.a.pose )
return;
stance = self.a.pose;
if ( stance == "prone" )
stance = "crouch";
type = anim.approach_types[ node.type ][ stance ];
if ( self use_readystand() && type == "exposed" )
{
type = "exposed_ready";
}
if ( self shouldCQB() )
{
cqbType = type + "_cqb";
if ( isdefined( anim.coverExit[ cqbType ] ) )
type = cqbType;
}
return type;
}
determineExposedApproachType( node )
{
if ( isdefined( self.heat ) )
{
return "heat";
}
if ( isdefined( node.arrivalStance ) )
stance = node.arrivalStance;
else
stance = node getHighestNodeStance();
if ( stance == "prone" )
stance = "crouch";
if ( stance == "crouch" )
type = "exposed_crouch";
else
type = "exposed";
if ( type == "exposed" && self use_readystand() )
type = type + "_ready";
if ( self shouldCQB() )
return type + "_cqb";
return type;
}
getMaxDirectionsAndExcludeDirFromApproachType( node )
{
returnobj = spawnstruct();
if ( isdefined( node ) && isdefined( anim.maxDirections[ node.type ] ) )
{
returnobj.maxDirections = anim.maxDirections[ node.type ];
returnobj.excludeDir = anim.excludeDir[ node.type ];
}
else
{
returnobj.maxDirections = 9;
returnobj.excludeDir = -1;
}
return returnobj;
}
shouldApproachToExposed( approachType )
{
if ( !isdefined( self.enemy ) )
return false;
if ( self NeedToReload( 0.5 ) )
return false;
if ( self isSuppressedWrapper() )
return false;
if ( isdefined( anim.exposedTransition[ approachtype ] ) )
return false;
if ( approachtype == "left_crouch" || approachtype == "right_crouch" )
return false;
return canSeePointFromExposedAtNode( self.enemy getShootAtPos(), self.node );
}
calculateNodeOffsetFromAnimationDelta( nodeAngles, delta )
{
right = anglestoright( nodeAngles );
forward = anglestoforward( nodeAngles );
return ( forward* delta[ 0 ] ) + ( right *( 0 - delta[ 1 ] ) );
}
getApproachEnt()
{
if ( isdefined( self.scriptedArrivalEnt ) )
return self.scriptedArrivalEnt;
if ( isdefined( self.node ) )
return self.node;
return undefined;
}
getApproachPoint( node, approachtype )
{
if ( approachType == "stand_saw" )
{
approachPoint = ( node.turretInfo.origin[ 0 ], node.turretInfo.origin[ 1 ], node.origin[ 2 ] );
forward = anglesToForward( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
right = anglesToRight( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
approachPoint = approachPoint + ( forward * -32.545 ) - ( right * 6.899 );
}
else if ( approachType == "crouch_saw" )
{
approachPoint = ( node.turretInfo.origin[ 0 ], node.turretInfo.origin[ 1 ], node.origin[ 2 ] );
forward = anglesToForward( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
right = anglesToRight( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
approachPoint = approachPoint + ( forward * -32.545 ) - ( right * 6.899 );
}
else if ( approachType == "prone_saw" )
{
approachPoint = ( node.turretInfo.origin[ 0 ], node.turretInfo.origin[ 1 ], node.origin[ 2 ] );
forward = anglesToForward( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
right = anglesToRight( ( 0, node.turretInfo.angles[ 1 ], 0 ) );
approachPoint = approachPoint + ( forward * -37.36 ) - ( right * 13.279 );
}
else if ( isdefined( self.scriptedArrivalEnt ) )
{
approachPoint = self.goalpos;
}
else
{
approachPoint = node.origin;
}
return approachPoint;
}
checkApproachPreConditions()
{
if ( isdefined( self getnegotiationstartnode() ) )
{
return false;
}
if ( isdefined( self.disableArrivals ) && self.disableArrivals )
{
return false;
}
return true;
}
checkApproachConditions( approachType, approach_dir, node )
{
if ( isdefined( anim.exposedTransition[ approachtype ] ) )
return false;
if ( approachType == "stand" || approachType == "crouch" )
{
assert( isdefined( node ) );
if ( AbsAngleClamp180( vectorToYaw( approach_dir ) - node.angles[ 1 ] + 180 ) < 60 )
{
return false;
}
}
if ( self isThreatenedByEnemy() || ( isdefined( self.lastApproachAbortTime ) && self.lastApproachAbortTime + 500 > getTime() ) )
{
return false;
}
return true;
}
setupApproachNode( firstTime )
{
self endon( "killanimscript" );
if ( isdefined( self.heat ) )
{
self thread doLastMinuteExposedApproachWrapper();
return;
}
if ( firstTime )
self.requestArrivalNotify = true;
self.a.arrivalType = undefined;
self thread doLastMinuteExposedApproachWrapper();
self waittill( "cover_approach", approach_dir );
if ( !self checkApproachPreConditions() )
return;
self thread setupApproachNode( false );
approachType = "exposed";
approachPoint = self.pathGoalPos;
approachNodeYaw = vectorToYaw( approach_dir );
approachFinalYaw = approachNodeYaw;
node = getApproachEnt();
if ( isdefined( node ) )
{
approachType = determineNodeApproachType( node );
if ( isdefined( approachtype ) && approachtype != "exposed" )
{
approachPoint = getApproachPoint( node, approachtype );
approachNodeYaw = node.angles[ 1 ];
approachFinalYaw = getNodeForwardYaw( node );
}
}
else if ( self use_readystand() )
{
if ( self shouldCQB() )
approachType = "exposed_ready_cqb";
else
approachType = "exposed_ready";
}
if ( !checkApproachConditions( approachType, approach_dir, node ) )
return;
startCoverApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir );
}
coverApproachLastMinuteCheck( approachPoint, approachFinalYaw, approachType, approachNumber, requiredYaw )
{
if ( isdefined( self.disableArrivals ) && self.disableArrivals )
{
return false;
}
if ( abs( self getMotionAngle() ) > 45 && isdefined( self.enemy ) && vectorDot( anglesToForward( self.angles ), vectorNormalize( self.enemy.origin - self.origin ) ) > .8 )
{
return false;
}
if ( self.a.pose != "stand" || ( self.a.movement != "run" && !( self isCQBWalkingOrFacingEnemy() ) ) )
{
return false;
}
if ( AbsAngleClamp180( requiredYaw - self.angles[ 1 ] ) > 30 )
{
if ( isdefined( self.enemy ) && self canSee( self.enemy ) && distanceSquared( self.origin, self.enemy.origin ) < 256 * 256 )
{
if ( vectorDot( anglesToForward( self.angles ), self.enemy.origin - self.origin ) > 0 )
{
return false;
}
}
}
if ( !checkCoverEnterPos( approachPoint, approachFinalYaw, approachType, approachNumber, false ) )
{
return false;
}
return true;
}
approachWaitTillClose( node, checkDist )
{
if ( !isdefined( node ) )
return;
while ( 1 )
{
if ( !isdefined( self.pathGoalPos ) )
self waitForPathGoalPos();
dist = distance( self.origin, self.pathGoalPos );
if ( dist <= checkDist + allowedError )
break;
waittime = ( dist - checkDist ) / maxSpeed - .1;
if ( waittime < .05 )
waittime = .05;
wait waittime;
}
}
startCoverApproach( approachType, approachPoint, approachNodeYaw, approachFinalYaw, approach_dir )
{
self endon( "killanimscript" );
self endon( "cover_approach" );
assert( isdefined( approachType ) );
assert( approachType != "exposed" );
node = getApproachEnt();
result = getMaxDirectionsAndExcludeDirFromApproachType( node );
maxDirections = result.maxDirections;
excludeDir = result.excludeDir;
arrivalFromFront = vectorDot( approach_dir, anglestoforward( node.angles ) ) >= 0;
result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, approach_dir, maxDirections, excludeDir, arrivalFromFront );
if ( result.approachNumber < 0 )
{
return;
}
approachNumber = result.approachNumber;
if ( level.newArrivals && approachNumber <= 6 && arrivalFromFront )
{
self endon( "goal_changed" );
self.arrivalStartDist = anim.coverTransLongestDist[ approachtype ];
approachWaitTillClose( node, self.arrivalStartDist );
dirToNode = vectorNormalize( approachPoint - self.origin );
result = self CheckArrivalEnterPositions( approachPoint, approachFinalYaw, approachType, dirToNode, maxDirections, excludeDir, arrivalFromFront );
self.arrivalStartDist = length( anim.coverTransDist[ approachtype ][ approachNumber ] );
approachWaitTillClose( node, self.arrivalStartDist );
if ( !( self maymovetopoint( approachPoint ) ) )
{
self.arrivalStartDist = undefined;
return;
}
if ( result.approachNumber < 0 )
{
self.arrivalStartDist = undefined;
return;
}
approachNumber = result.approachNumber;
requiredYaw = approachFinalYaw - anim.coverTransAngles[ approachType ][ approachNumber ];
}
else
{
self setRunToPos( self.coverEnterPos );
self waittill( "runto_arrived" );
requiredYaw = approachFinalYaw - anim.coverTransAngles[ approachType ][ approachNumber ];
if ( !self coverApproachLastMinuteCheck( approachPoint, approachFinalYaw, approachType, approachNumber, requiredYaw ) )
return;
}
self.approachNumber = approachNumber;
self.approachType = approachType;
self.arrivalStartDist = undefined;
self startcoverarrival( self.coverEnterPos, requiredYaw );
}
CheckArrivalEnterPositions( approachpoint, approachYaw, approachtype, approach_dir, maxDirections, excludeDir, arrivalFromFront )
{
assert( approachtype != "exposed" );
angleDataObj = spawnstruct();
calculateNodeTransitionAngles( angleDataObj, approachtype, true, approachYaw, approach_dir, maxDirections, excludeDir );
sortNodeTransitionAngles( angleDataObj, maxDirections );
resultobj = spawnstruct();
arrivalPos = ( 0, 0, 0 );
resultobj.approachNumber = -1;
numAttempts = 2;
for ( i = 1; i <= numAttempts; i++ )
{
assert( angleDataObj.transIndex[ i ] != excludeDir );
resultobj.approachNumber = angleDataObj.transIndex[ i ];
if ( !self checkCoverEnterPos( approachpoint, approachYaw, approachtype, resultobj.approachNumber, arrivalFromFront ) )
{
continue;
}
break;
}
if ( i > numAttempts )
{
resultobj.approachNumber = -1;
return resultobj;
}
distToApproachPoint = distanceSquared( approachpoint, self.origin );
distToAnimStart = distanceSquared( approachpoint, self.coverEnterPos );
if ( distToApproachPoint < distToAnimStart * 2 * 2 )
{
if ( distToApproachPoint < distToAnimStart )
{
resultobj.approachNumber = -1;
return resultobj;
}
if ( !level.newArrivals || !arrivalFromFront )
{
selfToAnimStart = vectorNormalize( self.coverEnterPos - self.origin );
requiredYaw = approachYaw - anim.coverTransAngles[ approachType ][ resultobj.approachNumber ];
AnimStartToNode = anglesToForward( ( 0, requiredYaw, 0 ) );
cosAngle = vectorDot( selfToAnimStart, AnimStartToNode );
if ( cosAngle < 0.707 )
{
resultobj.approachNumber = -1;
return resultobj;
}
}
}
return resultobj;
}
doLastMinuteExposedApproachWrapper()
{
self endon( "killanimscript" );
self endon( "move_interrupt" );
self notify( "doing_last_minute_exposed_approach" );
self endon( "doing_last_minute_exposed_approach" );
self thread watchGoalChanged();
while ( 1 )
{
doLastMinuteExposedApproach();
while ( 1 )
{
self waittill_any( "goal_changed", "goal_changed_previous_frame" );
if ( isdefined( self.coverEnterPos ) && isdefined( self.pathGoalPos ) && distance2D( self.coverEnterPos, self.pathGoalPos ) < 1 )
continue;
break;
}
}
}
watchGoalChanged()
{
self endon( "killanimscript" );
self endon( "doing_last_minute_exposed_approach" );
while ( 1 )
{
self waittill( "goal_changed" );
wait .05;
self notify( "goal_changed_previous_frame" );
}
}
exposedApproachConditionCheck( node, goalMatchesNode )
{
if ( !isdefined( self.pathGoalPos ) )
{
return false;
}
if ( isdefined( self.disableArrivals ) && self.disableArrivals )
{
return false;
}
if ( isdefined( self.approachConditionCheckFunc ) )
{
if ( !self [[self.approachConditionCheckFunc]]( node ) )
return false;
}
else
{
if ( !self.faceMotion && ( !isdefined( node ) || node.type == "Path" ) )
{
return false;
}
if ( self.a.pose != "stand" )
{
return false;
}
}
if ( self isThreatenedByEnemy() || ( isdefined( self.lastApproachAbortTime ) && self.lastApproachAbortTime + 500 > getTime() ) )
{
return false;
}
if ( !self maymovetopoint( self.pathGoalPos ) )
{
return false;
}
return true;
}
exposedApproachWaitTillClose()
{
while ( 1 )
{
if ( !isdefined( self.pathGoalPos ) )
self waitForPathGoalPos();
node = getApproachEnt();
if ( isdefined( node ) && !isdefined( self.heat ) )
arrivalPos = node.origin;
else
arrivalPos = self.pathGoalPos;
dist = distance( self.origin, arrivalPos );
checkDist = anim.longestExposedApproachDist;
if ( dist <= checkDist + allowedError )
break;
waittime = ( dist - anim.longestExposedApproachDist ) / maxSpeed - .1;
if ( waittime < 0 )
break;
if ( waittime < .05 )
waittime = .05;
wait waittime;
}
}
faceEnemyAtEndOfApproach( node )
{
if ( !isdefined( self.enemy ) )
return false;
if ( isdefined( self.heat ) && isdefined( node ) )
return false;
if ( self.combatmode == "cover" && isSentient( self.enemy ) && gettime() - self lastKnownTime( self.enemy ) > 15000 )
return false;
return sightTracePassed( self.enemy getShootAtPos(), self.pathGoalPos + ( 0, 0, 60 ), false, undefined );
}
doLastMinuteExposedApproach()
{
self endon( "goal_changed" );
self endon( "move_interrupt" );
if ( isdefined( self getnegotiationstartnode() ) )
return;
self exposedApproachWaitTillClose();
if ( isdefined( self.grenade ) && isdefined( self.grenade.activator ) && self.grenade.activator == self )
return;
approachType = "exposed";
maxDistToNodeSq = 1;
if ( isdefined( self.approachTypeFunc ) )
{
approachtype = self [[ self.approachTypeFunc ]]();
}
else if ( self use_readystand() )
{
if ( self shouldCQB() )
approachtype = "exposed_ready_cqb";
else
approachtype = "exposed_ready";
}
else if ( self shouldCQB() )
{
approachtype = "exposed_cqb";
}
else if ( isdefined( self.heat ) )
{
approachtype = "heat";
maxDistToNodeSq = 64 * 64;
}
node = getApproachEnt();
if ( isdefined( node ) && isdefined( self.pathGoalPos ) && !isdefined( self.disableCoverArrivalsOnly ) )
goalMatchesNode = distanceSquared( self.pathGoalPos, node.origin ) < maxDistToNodeSq;
else
goalMatchesNode = false;
if ( goalMatchesNode )
approachtype = determineExposedApproachType( node );
approachDir = VectorNormalize( self.pathGoalPos - self.origin );
desiredFacingYaw = vectorToYaw( approachDir );
if ( isdefined( self.faceEnemyArrival ) )
{
desiredFacingYaw = self.angles[1];
}
else if ( faceEnemyAtEndOfApproach( node ) )
{
desiredFacingYaw = vectorToYaw( self.enemy.origin - self.pathGoalPos );
}
else
{
faceNodeAngle = isdefined( node ) && goalMatchesNode;
faceNodeAngle = faceNodeAngle && ( node.type != "Path" ) && ( node.type != "Ambush" || !recentlySawEnemy() );
if ( faceNodeAngle )
{
desiredFacingYaw = getNodeForwardYaw( node );
}
else
{
likelyEnemyDir = self getAnglesToLikelyEnemyPath();
if ( isdefined( likelyEnemyDir ) )
desiredFacingYaw = likelyEnemyDir[ 1 ];
}
}
angleDataObj = spawnstruct();
calculateNodeTransitionAngles( angleDataObj, approachType, true, desiredFacingYaw, approachDir, 9, -1 );
best = 1;
for ( i = 2; i <= 9; i++ )
{
if ( angleDataObj.transitions[ i ] > angleDataObj.transitions[ best ] )
best = i;
}
self.approachNumber = angleDataObj.transIndex[ best ];
self.approachType = approachType;
approachAnim = anim.coverTrans[ approachType ][ self.approachNumber ];
animDist = length( anim.coverTransDist[ approachType ][ self.approachNumber ] );
requiredDistSq = animDist + allowedError;
requiredDistSq = requiredDistSq * requiredDistSq;
while ( isdefined( self.pathGoalPos ) && distanceSquared( self.origin, self.pathGoalPos ) > requiredDistSq )
wait .05;
if ( isdefined( self.arrivalStartDist ) && self.arrivalStartDist < animDist + allowedError )
{
return;
}
if ( !self exposedApproachConditionCheck( node, goalMatchesNode ) )
return;
dist = distance( self.origin, self.pathGoalPos );
if ( abs( dist - animDist ) > allowedError )
{
return;
}
facingYaw = vectorToYaw( self.pathGoalPos - self.origin );
if ( isdefined( self.heat ) && goalMatchesNode )
{
requiredYaw = desiredFacingYaw - anim.coverTransAngles[ approachType ][ self.approachNumber ];
idealStartPos = getArrivalStartPos( self.pathGoalPos, desiredFacingYaw, approachtype, self.approachNumber );
}
else if ( animDist > 0 )
{
delta = anim.coverTransDist[ approachType ][ self.approachNumber ];
assert( delta[ 0 ] != 0 );
yawToMakeDeltaMatchUp = atan( delta[ 1 ] / delta[ 0 ] );
if ( !isdefined( self.faceEnemyArrival ) || self.faceMotion )
{
requiredYaw = facingYaw - yawToMakeDeltaMatchUp;
if ( AbsAngleClamp180( requiredYaw - self.angles[ 1 ] ) > 30 )
{
return;
}
}
else
{
requiredYaw = self.angles[1];
}
closerDist = dist - animDist;
idealStartPos = self.origin + ( VectorNormalize( self.pathGoalPos - self.origin ) * closerDist );
}
else
{
requiredYaw = self.angles[1];
idealStartPos = self.origin;
}
self startcoverarrival( idealStartPos, requiredYaw );
}
waitForPathGoalPos()
{
while ( 1 )
{
if ( isdefined( self.pathgoalpos ) )
return;
wait 0.1;
}
}
startMoveTransitionPreConditions()
{
if ( !isdefined( self.pathGoalPos ) )
{
return false;
}
if ( !self shouldFaceMotion() )
{
return false;
}
if ( self.a.pose == "prone" )
{
return false;
}
if ( isdefined( self.disableExits ) && self.disableExits )
{
return false;
}
if ( self.stairsState != "none" )
{
return false;
}
if ( !self isStanceAllowed( "stand" ) && !isdefined( self.heat ) )
{
return false;
}
if ( distanceSquared( self.origin, self.pathGoalPos ) < 10000 )
{
return false;
}
return true;
}
startMoveTransitionConditions( exittype, exitNode )
{
if ( !isdefined( exittype ) )
{
return false;
}
if ( exittype == "exposed" || isdefined( self.heat ) )
{
if ( self.a.pose != "stand" && self.a.pose != "crouch" )
{
return false;
}
if ( self.a.movement != "stop" )
{
return false;
}
}
if ( !isdefined( self.heat ) && isdefined( self.enemy ) && vectorDot( self.lookaheaddir, self.enemy.origin - self.origin ) < 0 )
{
if ( self canSeeEnemyFromExposed() && distanceSquared( self.origin, self.enemy.origin ) < 300 * 300 )
{
return false;
}
}
return true;
}
getExitNode()
{
exitNode = undefined;
if ( !isdefined( self.heat ) )
limit = 400;
else
limit = 4096;
if ( isdefined( self.node ) && ( distanceSquared( self.origin, self.node.origin ) < limit ) )
exitNode = self.node;
else if ( isdefined( self.prevNode ) && ( distanceSquared( self.origin, self.prevNode.origin ) < limit ) )
exitNode = self.prevNode;
if ( isdefined( exitNode ) && isdefined( self.heat ) && AbsAngleClamp180( self.angles[1] - exitNode.angles[1] ) > 30 )
return undefined;
return exitNode;
}
customMoveTransitionFunc()
{
if ( !isdefined( self.startMoveTransitionAnim ) )
return;
self animmode( "zonly_physics", false );
self orientmode( "face current" );
self SetFlaggedAnimKnobAllRestart( "move", self.startMoveTransitionAnim, %root, 1 );
if ( animHasNotetrack( self.startMoveTransitionAnim, "code_move" ) )
{
self animscripts\shared::DoNoteTracks( "move" );
self OrientMode( "face motion" );
self animmode( "none", false );
}
self animscripts\shared::DoNoteTracks( "move" );
}
determineNonNodeExitType( exittype )
{
if ( self.a.pose == "stand" )
exittype = "exposed";
else
exittype = "exposed_crouch";
if ( self use_readystand() )
exittype = "exposed_ready";
if ( shouldCQB() )
exittype = exittype + "_cqb";
else if ( isdefined( self.heat ) )
exittype = "heat";
return exittype;
}
determineHeatCoverExitType( exitNode, exittype )
{
if ( exitNode.type == "Cover Right" )
exittype = "heat_right";
else if ( exitNode.type == "Cover Left" )
exittype = "heat_left";
return exittype;
}
startMoveTransition()
{
if ( isdefined( self.customMoveTransition ) )
{
customTransition = self.customMoveTransition;
if ( !isdefined( self.permanentCustomMoveTransition ) )
self.customMoveTransition = undefined;
[[ customTransition ]]();
if ( !isdefined( self.permanentCustomMoveTransition ) )
self.startMoveTransitionAnim = undefined;
self clearanim( %root, 0.2 );
self orientmode( "face default" );
self animmode( "none", false );
return;
}
self endon( "killanimscript" );
if ( !self startMoveTransitionPreConditions() )
return;
exitpos = self.origin;
exityaw = self.angles[ 1 ];
exittype = "exposed";
exitTypeFromNode = false;
exitNode = getExitNode();
if ( isdefined( exitNode ) )
{
nodeExitType = determineNodeExitType( exitNode );
if ( isdefined( nodeExitType ) )
{
exitType = nodeExitType;
exitTypeFromNode = true;
if ( isdefined( self.heat ) )
exitType = determineHeatCoverExitType( exitNode, exittype );
if ( !isdefined( anim.exposedTransition[ exitType ] ) && exittype != "stand_saw" && exittype != "crouch_saw" )
{
anglediff = AbsAngleClamp180( self.angles[ 1 ] - GetNodeForwardYaw( exitNode ) );
if ( anglediff < 5 )
{
if ( !isdefined( self.heat ) )
exitpos = exitNode.origin;
exityaw = GetNodeForwardYaw( exitNode );
}
}
}
}
if ( !self startMoveTransitionConditions( exittype, exitNode ) )
return;
isExposedExit = isdefined( anim.exposedTransition[ exittype ] );
if ( !exitTypeFromNode )
exittype = determineNonNodeExitType();
leaveDir = ( -1 * self.lookaheaddir[ 0 ], -1 * self.lookaheaddir[ 1 ], 0 );
result = getMaxDirectionsAndExcludeDirFromApproachType( exitNode );
maxDirections = result.maxDirections;
excludeDir = result.excludeDir;
angleDataObj = spawnstruct();
calculateNodeTransitionAngles( angleDataObj, exittype, false, exityaw, leaveDir, maxDirections, excludeDir );
sortNodeTransitionAngles( angleDataObj, maxDirections );
approachnumber = -1;
numAttempts = 3;
if ( isExposedExit )
numAttempts = 1;
for ( i = 1; i <= numAttempts; i++ )
{
assert( angleDataObj.transIndex[ i ] != excludeDir );
approachNumber = angleDataObj.transIndex[ i ];
if ( self checkCoverExitPos( exitpos, exityaw, exittype, isExposedExit, approachNumber ) )
break;
}
if ( i > numAttempts )
{
return;
}
allowedDistSq = distanceSquared( self.origin, self.coverExitPos ) * 1.25 * 1.25;
if ( distanceSquared( self.origin, self.pathgoalpos ) < allowedDistSq )
{
return;
}
self doCoverExitAnimation( exittype, approachNumber );
}
str( val )
{
if ( !isdefined( val ) )
return "{undefined}";
return val;
}
doCoverExitAnimation( exittype, approachNumber )
{
assert( isdefined( approachNumber ) );
assert( approachnumber > 0 );
assert( isdefined( exittype ) );
leaveAnim = anim.coverExit[ exittype ][ approachnumber ];
assert( isdefined( leaveAnim ) );
lookaheadAngles = vectortoangles( self.lookaheaddir );
if ( self.a.pose == "prone" )
return;
transTime = 0.2;
self animMode( "zonly_physics", false );
self OrientMode( "face angle", self.angles[ 1 ] );
self setFlaggedAnimKnobAllRestart( "coverexit", leaveAnim, %body, 1, transTime, self.moveTransitionRate );
assert( animHasNotetrack( leaveAnim, "code_move" ) );
self animscripts\shared::DoNoteTracks( "coverexit" );
self.a.pose = "stand";
self.a.movement = "run";
self.ignorePathChange = undefined;
self OrientMode( "face motion" );
self animmode( "none", false );
self finishCoverExitNotetracks( "coverexit" );
self clearanim( %root, 0.2 );
self OrientMode( "face default" );
self animMode( "normal", false );
}
finishCoverExitNotetracks( flagname )
{
self endon( "move_loop_restart" );
self animscripts\shared::DoNoteTracks( flagname );
}
drawVec( start, end, duration, color )
{
for ( i = 0; i < duration * 100; i++ )
{
line( start + ( 0, 0, 30 ), end + ( 0, 0, 30 ), color );
wait 0.05;
}
}
drawApproachVec( approach_dir )
{
self endon( "killanimscript" );
for ( ;; )
{
if ( !isdefined( self.node ) )
break;
Line( self.node.origin + ( 0, 0, 20 ), ( self.node.origin - ( approach_dir * 64 ) ) + ( 0, 0, 20 ) );
wait( 0.05 );
}
}
calculateNodeTransitionAngles( angleDataObj, approachtype, isarrival, arrivalYaw, approach_dir, maxDirections, excludeDir )
{
angleDataObj.transitions = [];
angleDataObj.transIndex = [];
anglearray = undefined;
sign = 1;
offset = 0;
if ( isarrival )
{
anglearray = anim.coverTransAngles[ approachtype ];
sign = -1;
offset = 0;
}
else
{
anglearray = anim.coverExitAngles[ approachtype ];
sign = 1;
offset = 180;
}
for ( i = 1; i <= maxDirections; i++ )
{
angleDataObj.transIndex[ i ] = i;
if ( i == 5 || i == excludeDir || !isdefined( anglearray[ i ] ) )
{
angleDataObj.transitions[ i ] = -1.0003;
continue;
}
angles = ( 0, arrivalYaw + sign * anglearray[ i ] + offset, 0 );
dir = vectornormalize( anglestoforward( angles ) );
angleDataObj.transitions[ i ] = vectordot( approach_dir, dir );
}
}
sortNodeTransitionAngles( angleDataObj, maxDirections )
{
for ( i = 2; i <= maxDirections; i++ )
{
currentValue = angleDataObj.transitions[ angleDataObj.transIndex[ i ] ];
currentIndex = angleDataObj.transIndex[ i ];
for ( j = i - 1; j >= 1; j -- )
{
if ( currentValue < angleDataObj.transitions[ angleDataObj.transIndex[ j ] ] )
break;
angleDataObj.transIndex[ j + 1 ] = angleDataObj.transIndex[ j ];
}
angleDataObj.transIndex[ j + 1 ] = currentIndex;
}
}
checkCoverExitPos( exitpoint, exityaw, exittype, isExposedExit, approachNumber )
{
angle = ( 0, exityaw, 0 );
forwardDir = anglestoforward( angle );
rightDir = anglestoright( angle );
forward = ( forwardDir * anim.coverExitDist[ exittype ][ approachNumber ][ 0 ] );
right = ( rightDir * anim.coverExitDist[ exittype ][ approachNumber ][ 1 ] );
exitPos = exitpoint + forward - right;
self.coverExitPos = exitPos;
if ( !isExposedExit && !( self checkCoverExitPosWithPath( exitPos ) ) )
{
return false;
}
if ( !( self maymovefrompointtopoint( self.origin, exitPos ) ) )
return false;
if ( approachNumber <= 6 || isExposedExit )
return true;
forward = ( forwardDir * anim.coverExitPostDist[ exittype ][ approachNumber ][ 0 ] );
right = ( rightDir * anim.coverExitPostDist[ exittype ][ approachNumber ][ 1 ] );
finalExitPos = exitPos + forward - right;
self.coverExitPos = finalExitPos;
return( self maymovefrompointtopoint( exitPos, finalExitPos ) );
}
getArrivalStartPos( arrivalPoint, arrivalYaw, approachType, approachNumber )
{
angle = ( 0, arrivalYaw - anim.coverTransAngles[ approachtype ][ approachNumber ], 0 );
forwardDir = anglestoforward( angle );
rightDir = anglestoright( angle );
forward = ( forwardDir * anim.coverTransDist[ approachtype ][ approachNumber ][ 0 ] );
right = ( rightDir * anim.coverTransDist[ approachtype ][ approachNumber ][ 1 ] );
return arrivalpoint - forward + right;
}
getArrivalPreStartPos( arrivalPoint, arrivalYaw, approachType, approachNumber )
{
angle = ( 0, arrivalYaw - anim.coverTransAngles[ approachtype ][ approachNumber ], 0 );
forwardDir = anglestoforward( angle );
rightDir = anglestoright( angle );
forward = ( forwardDir * anim.coverTransPreDist[ approachtype ][ approachNumber ][ 0 ] );
right = ( rightDir * anim.coverTransPreDist[ approachtype ][ approachNumber ][ 1 ] );
return arrivalpoint - forward + right;
}
checkCoverEnterPos( arrivalpoint, arrivalYaw, approachtype, approachNumber, arrivalFromFront )
{
enterPos = getArrivalStartPos( arrivalPoint, arrivalYaw, approachType, approachNumber );
self.coverEnterPos = enterPos;
if ( level.newArrivals && approachNumber <= 6 && arrivalFromFront )
return true;
if ( !( self maymovefrompointtopoint( enterPos, arrivalpoint ) ) )
return false;
if ( approachNumber <= 6 || isdefined( anim.exposedTransition[ approachtype ] ) )
return true;
originalEnterPos = getArrivalPreStartPos( enterPos, arrivalYaw, approachType, approachNumber );
self.coverEnterPos = originalEnterPos;
return( self maymovefrompointtopoint( originalEnterPos, enterPos ) );
}
use_readystand()
{
if ( !isdefined( anim.readystand_anims_inited ) )
{
return false;
}
if ( !anim.readystand_anims_inited )
{
return false;
}
if ( !IsDefined( self.bUseReadyIdle ) )
{
return false;
}
if ( !self.bUseReadyIdle )
{
return false;
}
return true;
}
debug_arrivals_on_actor()
{
return false;
}
debug_arrival( msg )
{
if ( !debug_arrivals_on_actor() )
return;
println( msg );
}