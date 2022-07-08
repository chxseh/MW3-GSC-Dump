#include animscripts\utility;
#include animscripts\combat_utility;
#include animscripts\notetracks;
#include animscripts\shared;
#include common_scripts\utility;
#using_animtree( "generic_human" );
MoveCQB()
{
animscripts\run::changeWeaponStandRun();
if ( self.a.pose != "stand" )
{
self clearAnim( %root, 0.2 );
if ( self.a.pose == "prone" )
self ExitProneWrapper( 1 );
self.a.pose = "stand";
}
self.a.movement = self.moveMode;
self thread CQBTracking();
cqbWalkAnim = DetermineCQBAnim();
rate = self.moveplaybackrate;
if ( self.moveMode == "walk" )
rate *= 0.6;
if ( self.stairsState == "none" )
transTime = 0.3;
else
transTime = 0.1;
self setFlaggedAnimKnobAll( "runanim", cqbWalkAnim, %walk_and_run_loops, 1, transTime, rate, true );
self animscripts\run::SetMoveNonForwardAnims( %walk_backward, %walk_left, %walk_right );
self thread animscripts\run::SetCombatStandMoveAnimWeights( "cqb" );
DoNoteTracksForTime( 0.2, "runanim" );
self thread animscripts\run::stopShootWhileMovingThreads();
}
DetermineCQBAnim()
{
if ( isdefined( self.customMoveAnimSet ) && isdefined( self.customMoveAnimSet[ "cqb" ] ) )
return animscripts\run::GetRunAnim();
if ( self.stairsState == "up" )
return %traverse_stair_run;
if ( self.stairsState == "down" )
return %traverse_stair_run_down_01;
if ( self.movemode == "walk" )
return %walk_CQB_F;
variation = getRandomIntFromSeed( self.a.runLoopCount, 2 );
if ( variation == 0 )
return %run_CQB_F_search_v1;
return %run_CQB_F_search_v2;
}
CQBTracking()
{
assert( isdefined( self.aim_while_moving_thread ) == isdefined( self.trackLoopThread ) );
assertex( !isdefined( self.trackLoopThread ) || (self.trackLoopThreadType == "faceEnemyAimTracking"), self.trackLoopThreadType );
if ( animscripts\move::MayShootWhileMoving() )
animscripts\run::runShootWhileMovingThreads();
animscripts\run::faceEnemyAimTracking();
}
setupCQBPointsOfInterest()
{
level.cqbPointsOfInterest = [];
pointents = getEntArray( "cqb_point_of_interest", "targetname" );
for ( i = 0; i < pointents.size; i++ )
{
level.cqbPointsOfInterest[ i ] = pointents[ i ].origin;
pointents[ i ] delete();
}
}
findCQBPointsOfInterest()
{
if ( isdefined( anim.findingCQBPointsOfInterest ) )
return;
anim.findingCQBPointsOfInterest = true;
if ( !level.cqbPointsOfInterest.size )
return;
while ( 1 )
{
ai = getaiarray();
waited = false;
foreach( guy in ai )
{
if ( isAlive( guy ) && guy isCQBWalking() && !IsDefined( guy.disable_cqb_points_of_interest ) )
{
moving = ( guy.a.movement != "stop" );
shootAtPos = (guy.origin[0], guy.origin[1], guy getShootAtPos()[2]);
lookAheadPoint = shootAtPos;
forward = anglesToForward( guy.angles );
if ( moving )
{
trace = bulletTrace( lookAheadPoint, lookAheadPoint + forward * 128, false, undefined );
lookAheadPoint = trace[ "position" ];
}
best = -1;
bestdist = 1024 * 1024;
for ( j = 0; j < level.cqbPointsOfInterest.size; j++ )
{
point = level.cqbPointsOfInterest[ j ];
dist = distanceSquared( point, lookAheadPoint );
if ( dist < bestdist )
{
if ( moving )
{
if ( distanceSquared( point, shootAtPos ) < 64 * 64 )
continue;
dot = vectorDot( vectorNormalize( point - shootAtPos ), forward );
if ( dot < 0.643 || dot > 0.966 )
continue;
}
else
{
if ( dist < 50 * 50 )
continue;
}
if ( !sightTracePassed( lookAheadPoint, point, false, undefined ) )
continue;
bestdist = dist;
best = j;
}
}
if ( best < 0 )
guy.cqb_point_of_interest = undefined;
else
guy.cqb_point_of_interest = level.cqbPointsOfInterest[ best ];
wait .05;
waited = true;
}
}
if ( !waited )
wait .25;
}
}

 

