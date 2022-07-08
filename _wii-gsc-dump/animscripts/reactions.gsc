#include animscripts\SetPoseMovement;
#include animscripts\notetracks;
#include animscripts\Utility;
#include common_scripts\Utility;
#using_animtree( "generic_human" );
main()
{
self endon( "killanimscript" );
animscripts\utility::initialize( "reactions" );
self newEnemySurprisedReaction();
}
initReactionAnims()
{
anim.runningReactToBullets = [];
anim.runningReactToBullets[ anim.runningReactToBullets.size ] = %run_react_duck;
anim.runningReactToBullets[ anim.runningReactToBullets.size ] = %run_react_flinch;
anim.runningReactToBullets[ anim.runningReactToBullets.size ] = %run_react_stumble;
anim.lastRunningReactAnim = 0;
anim.coverReactions = [];
anim.coverReactions[ "cover_stand" ]	= array( %stand_cover_reaction_A, %stand_cover_reaction_B );
anim.coverReactions[ "cover_crouch" ]	= array( %crouch_cover_reaction_A, %crouch_cover_reaction_B );
anim.coverReactions[ "cover_left" ] = array( %CornerStndL_react_A );
anim.coverReactions[ "cover_right" ]	= array( %CornerStndR_react_A );
}
reactionsCheckLoop()
{
self thread bulletWhizbyCheckLoop();
}
canReactAgain()
{
return ( !isdefined( self.lastReactTime ) || gettime() - self.lastReactTime > 2000 );
}
bulletWhizbyReaction()
{
self endon( "killanimscript" );
self.lastReactTime = gettime();
self.a.movement = "stop";
enemyNear = ( isDefined( self.whizbyEnemy ) && distanceSquared( self.origin, self.whizbyEnemy.origin ) < 400 * 400 );
self animmode( "gravity" );
self orientmode( "face current" );
if ( enemyNear || cointoss() )
{
self clearanim( %root, 0.1 );
reactAnim = [];
reactAnim[ 0 ] = %exposed_idle_reactA;
reactAnim[ 1 ] = %exposed_idle_reactB;
reactAnim[ 2 ] = %exposed_idle_twitch;
reactAnim[ 3 ] = %exposed_idle_twitch_v4;
reaction = reactAnim[ randomint( reactAnim.size ) ];
if ( enemyNear )
waitTime = 1 + randomfloat( 0.5 );
else
waitTime = 0.2 + randomfloat( 0.5 );
self setFlaggedAnimKnobRestart( "reactanim", reaction, 1, 0.1, 1 );
self DoNoteTracksForTime( waitTime, "reactanim" );
self clearanim( %root, 0.1 );
if ( !enemyNear && self.stairsState == "none" && !IsDefined( self.disable_dive_whizby_react ) )
{
rate = 1 + randomfloat( 0.2 );
diveAnim = randomAnimOfTwo( %exposed_dive_grenade_B, %exposed_dive_grenade_F );
self setFlaggedAnimKnobRestart( "dive", diveAnim, 1, 0.1, rate );
self animscripts\shared::DoNoteTracks( "dive" );
}
}
else
{
wait randomfloat( 0.2 );
rate = 1.2 + randomfloat( 0.3 );
if ( self.a.pose == "stand" )
{
self clearanim( %root, 0.1 );
self setFlaggedAnimKnobRestart( "crouch", %exposed_stand_2_crouch, 1, 0.1, rate );
self animscripts\shared::DoNoteTracks( "crouch" );
}
forward = anglesToForward( self.angles );
if ( isDefined( self.whizbyEnemy ) )
dirToEnemy = vectorNormalize( self.whizbyEnemy.origin - self.origin );
else
dirToEnemy = forward;
if ( vectordot( dirToEnemy, forward ) > 0 )
{
twitchAnim = randomAnimOfTwo( %exposed_crouch_idle_twitch_v2, %exposed_crouch_idle_twitch_v3 );
self clearanim( %root, 0.1 );
self setFlaggedAnimKnobRestart( "twitch", twitchAnim, 1, 0.1, 1 );
self animscripts\shared::DoNoteTracks( "twitch" );
}
else
{
turnAnim = randomAnimOfTwo( %exposed_crouch_turn_180_left, %exposed_crouch_turn_180_right );
self clearanim( %root, 0.1 );
self setFlaggedAnimKnobRestart( "turn", turnAnim, 1, 0.1, 1 );
self animscripts\shared::DoNoteTracks( "turn" );
}
}
self clearanim( %root, 0.1 );
self.whizbyEnemy = undefined;
self animmode( "normal" );
self orientmode( "face default" );
}
bulletWhizbyCheckLoop()
{
self endon( "killanimscript" );
if ( isdefined( self.disableBulletWhizbyReaction ) )
return;
while ( 1 )
{
self waittill( "bulletwhizby", shooter );
if ( !isdefined( shooter.team ) || self.team == shooter.team )
continue;
if ( isdefined( self.coverNode ) || isdefined( self.ambushNode ) )
continue;
if ( self.a.pose != "stand" )
continue;
if ( !canReactAgain() )
continue;
self.whizbyEnemy = shooter;
self animcustom( ::bulletWhizbyReaction );
}
}
clearLookAtThread()
{
self endon( "killanimscript" );
wait 0.3;
self setLookAtEntity();
}
getNewEnemyReactionAnim()
{
reactAnim = undefined;
if ( self nearClaimNodeAndAngle() && isdefined( anim.coverReactions[ self.prevScript ] ) )
{
nodeForward = anglesToForward( self.node.angles );
dirToReactionTarget = vectorNormalize( self.reactionTargetPos - self.origin );
if ( vectorDot( nodeForward, dirToReactionTarget ) < -0.5 )
{
self orientmode( "face current" );
index = randomint( anim.coverReactions[ self.prevScript ].size );
reactAnim = anim.coverReactions[ self.prevScript ][ index ];
}
}
if ( !isdefined( reactAnim ) )
{
reactAnimArray = [];
reactAnimArray[ 0 ] = %exposed_backpedal;
reactAnimArray[ 1 ] = %exposed_idle_reactB;
if ( isdefined( self.enemy ) && distanceSquared( self.enemy.origin, self.reactionTargetPos ) < 256 * 256 )
self orientmode( "face enemy" );
else
self orientmode( "face point", self.reactionTargetPos );
if ( self.a.pose == "crouch" )
{
dirToReactionTarget = vectorNormalize( self.reactionTargetPos - self.origin );
forward = anglesToForward( self.angles );
if ( vectorDot( forward, dirToReactionTarget ) < -0.5 )
{
self orientmode( "face current" );
reactAnimArray[ 0 ] = %crouch_cover_reaction_A;
reactAnimArray[ 1 ] = %crouch_cover_reaction_B;
}
}
reactAnim = reactAnimArray[ randomint( reactAnimArray.size ) ];
}
return reactAnim;
}
stealthNewEnemyReactAnim()
{
self clearanim( %root, 0.2 );
if ( randomint( 4 ) < 3 )
{
self orientmode( "face enemy" );
self setFlaggedAnimKnobRestart( "reactanim", %exposed_idle_reactB, 1, 0.2, 1 );
time = getAnimLength( %exposed_idle_reactB );
self DoNoteTracksForTime( time * 0.8, "reactanim" );
self orientmode( "face current" );
}
else
{
self orientmode( "face enemy" );
self setFlaggedAnimKnobRestart( "reactanim", %exposed_backpedal, 1, 0.2, 1 );
time = getAnimLength( %exposed_backpedal );
self DoNoteTracksForTime( time * 0.8, "reactanim" );
self orientmode( "face current" );
self clearanim( %root, 0.2 );
self setFlaggedAnimKnobRestart( "reactanim", %exposed_backpedal_v2, 1, 0.2, 1 );
self animscripts\shared::DoNoteTracks( "reactanim" );
}
}
newEnemyReactionAnim()
{
self endon( "death" );
self endon( "endNewEnemyReactionAnim" );
self.lastReactTime = gettime();
self.a.movement = "stop";
if ( isdefined( self._stealth ) && self.alertLevel != "combat" )
{
stealthNewEnemyReactAnim();
}
else
{
reactAnim = self getNewEnemyReactionAnim();
self clearanim( %root, 0.2 );
self setFlaggedAnimKnobRestart( "reactanim", reactAnim, 1, 0.2, 1 );
self animscripts\shared::DoNoteTracks( "reactanim" );
}
self notify( "newEnemyReactionDone" );
}
newEnemySurprisedReaction()
{
self endon( "death" );
if ( isdefined( self.disableReactionAnims ) )
return;
if ( !canReactAgain() )
return;
if ( self.a.pose == "prone" || isdefined( self.a.onback ) )
return;
self animmode( "gravity" );
if ( isdefined( self.enemy ) )
newEnemyReactionAnim();
}
