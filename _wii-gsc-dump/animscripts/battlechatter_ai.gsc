
#include common_scripts\utility;
#include maps\_utility;
#include animscripts\utility;
#include animscripts\battlechatter;
addToSystem( squadName )
{
self endon( "death" );
if ( !bcsEnabled() )
return;
if ( self.chatInitialized )
return;
assert( isdefined( self.squad ) );
if ( !isdefined( self.squad.chatInitialized ) || !self.squad.chatInitialized )
self.squad init_squadBattleChatter();
self.enemyClass = "infantry";
self.calledOut = [];
if ( isPlayer( self ) )
{
self.battleChatter = false;
self.flavorbursts = false;
self.type = "human";
return;
}
if ( self.type == "dog" )
{
self.enemyClass = undefined;
self.battlechatter = false;
self.flavorbursts = false;
return;
}
if ( self.team == "neutral" )
{
self.enemyClass = undefined;
self.battlechatter = false;
self.flavorbursts = false;
return;
}
if ( forceEnglish() )
{
if ( self.team == "allies" )
self.script_battlechatter = false;
else
self.voice = "american";
}
self.countryID = anim.countryIDs[ self.voice ];
if ( isdefined( self.script_friendname ) )
{
friendname = ToLower( self.script_friendname );
if ( IsSubStr( friendname, "price" ) )
{
self.npcID = "pri";
}
else if ( IsSubStr( friendname, "mactavish" ) || IsSubStr( friendname, "soap" ) )
{
self.npcID = "mct";
}
else if ( IsSubStr( friendname, "wallcroft" ) )
{
self.npcID = "wcf";
}
else if ( IsSubStr( friendname, "griffin" ) )
{
self.npcID = "grf";
}
else if ( IsSubStr( friendname, "grinch" ) )
{
self.npcID = "grn";
}
else if ( IsSubStr( friendname, "truck" ) )
{
self.npcID = "trk";
}
else if ( IsSubStr( friendname, "sandman" ) )
{
self.npcID = "snd";
}
else if ( IsSubStr( friendname, "yuri" ) )
{
self.npcID = "yri";
}
else
{
self setNPCID();
}
}
else
{
self setNPCID();
}
self thread aiNameAndRankWaiter();
self init_aiBattleChatter();
self thread aiThreadThreader();
}
forceEnglish()
{
if ( !getDvarInt( "bcs_forceEnglish", 0 ) )
return false;
switch( level.script )
{
case "pmc_strike":
return true;
}
return false;
}
aiThreadThreader()
{
self endon( "death" );
self endon( "removed from battleChatter" );
waitTime = 0.5;
wait( waitTime );
self thread aiGrenadeDangerWaiter();
self thread aiFollowOrderWaiter();
if ( self.team == "allies" )
{
wait( waitTime );
self thread aiDisplaceWaiter();
if ( self.countryID == "CZ" )
self thread aiHostileBurstLoop();
}
else if( ( self.team == "axis" || self.team == "team3" ) && !isAlliedCountryID( self.countryID ) )
{
self thread aiHostileBurstLoop();
}
if( self.team == level.player.team )
{
self thread player_friendlyfire_waiter();
}
wait( waitTime );
self thread aiBattleChatterLoop();
}
isAlliedCountryID( id )
{
if( id == "UK" || id == "US" || id == "NS" || id == "TF" || id == "SS" )
{
return true;
}
return false;
}
setNPCID()
{
assert( !isDefined( self.npcID ) );
usedIDs = anim.usedIDs[ self.voice ];
numIDs = usedIDs.size;
startIndex = randomIntRange( 0, numIDs );
lowestID = startIndex;
for ( index = 0; index <= numIDs; index++ )
{
if ( usedIDs[ ( startIndex + index )%numIDs ].count < usedIDs[ lowestID ].count )
lowestID = ( startIndex + index ) % numIDs;
}
self thread npcIDTracker( lowestID );
self.npcID = usedIDs[ lowestID ].npcID;
}
npcIDTracker( lowestID )
{
anim.usedIDs[ self.voice ][ lowestID ].count++ ;
self waittill_either( "death", "removed from battleChatter" );
if ( !bcsEnabled() )
return;
anim.usedIDs[ self.voice ][ lowestID ].count-- ;
}
aiHostileBurstLoop()
{
self endon( "death" );
self endon( "removed from battleChatter" );
while( 1 )
{
if( Distance( self.origin, level.player.origin ) < 1024 )
{
if( IsDefined( self.squad.memberCount ) && self.squad.memberCount > 1 )
{
self addReactionEvent( "taunt", "hostileburst" );
}
}
wait( RandomFloatRange( 2, 5 ) );
}
}
aiBattleChatterLoop()
{
self endon( "death" );
self endon( "removed from battleChatter" );
while ( true )
{
prof_begin( "aiBattleChatterLoop" );
self playBattleChatter();
prof_end( "aiBattleChatterLoop" );
wait( 0.3 + randomfloat( 0.2 ) );
}
}
aiNameAndRankWaiter()
{
self endon( "death" );
self endon( "removed from battleChatter" );
while ( 1 )
{
self.bcName = self animscripts\battlechatter::getName();
self.bcRank = self animscripts\battlechatter::getRank();
self waittill( "set name and rank" );
}
}
removeFromSystem( squadName )
{
if ( !IsAlive( self ) && bcsEnabled() )
{
self aiDeathFriendly();
self aiDeathEnemy();
}
if ( IsDefined( self ) )
{
self.battleChatter = false;
self.chatInitialized = false;
}
self notify( "removed from battleChatter" );
if ( IsDefined( self ) )
{
self.chatQueue = undefined;
self.nextSayTime = undefined;
self.nextSayTimes = undefined;
self.isSpeaking = undefined;
self.enemyClass = undefined;
self.calledOut = undefined;
self.countryID = undefined;
self.npcID = undefined;
}
}
init_aiBattleChatter()
{
prof_begin("init_aiBattleChatter");
self.chatQueue = [];
self.chatQueue[ "threat" ] = spawnstruct();
self.chatQueue[ "threat" ].expireTime = 0;
self.chatQueue[ "threat" ].priority = 0.0;
self.chatQueue[ "response" ] = spawnstruct();
self.chatQueue[ "response" ].expireTime = 0;
self.chatQueue[ "response" ].priority = 0.0;
self.chatQueue[ "reaction" ] = spawnstruct();
self.chatQueue[ "reaction" ].expireTime = 0;
self.chatQueue[ "reaction" ].priority = 0.0;
self.chatQueue[ "inform" ] = spawnstruct();
self.chatQueue[ "inform" ].expireTime = 0;
self.chatQueue[ "inform" ].priority = 0.0;
self.chatQueue[ "order" ] = spawnstruct();
self.chatQueue[ "order" ].expireTime = 0;
self.chatQueue[ "order" ].priority = 0.0;
self.chatQueue[ "custom" ] = spawnstruct();
self.chatQueue[ "custom" ].expireTime = 0;
self.chatQueue[ "custom" ].priority = 0.0;
self.nextSayTime = getTime() + 50;
self.nextSayTimes[ "threat" ] = 0;
self.nextSayTimes[ "reaction" ] = 0;
self.nextSayTimes[ "response" ] = 0;
self.nextSayTimes[ "inform" ] = 0;
self.nextSayTimes[ "order" ] = 0;
self.nextSayTimes[ "custom" ] = 0;
self.isSpeaking = false;
self.bcs_minPriority = 0.0;
self.allowedCallouts = [];
self addAllowedThreatCallout( "rpg" );
self addAllowedThreatCallout( "exposed" );
if( self.voice != "shadowcompany" )
{
if ( self.voice != "british" && self.voice != "pmc" )
self addAllowedThreatCallout( "ai_obvious" );
self addAllowedThreatCallout( "ai_contact_clock" );
self addAllowedThreatCallout( "ai_target_clock" );
self addAllowedThreatCallout( "ai_cardinal" );
}
if( self.voice == "delta" )
{
self addAllowedThreatCallout( "player_distance" );
self addAllowedThreatCallout( "player_target_clock_high" );
self addAllowedThreatCallout( "ai_distance" );
self addAllowedThreatCallout( "ai_target_clock_high" );
}
if( self.team == "allies" )
{
if ( array_contains( anim.playerNameIDs, self.voice ) )
{
self addAllowedThreatCallout( "player_contact_clock" );
self addAllowedThreatCallout( "player_target_clock" );
self addAllowedThreatCallout( "player_cardinal" );
if ( self.voice != "british" && self.voice != "pmc" )
self addAllowedThreatCallout( "player_obvious" );
self addAllowedThreatCallout( "player_object_clock" );
if ( self.voice != "french" )
self addAllowedThreatCallout( "player_location" );
}
if ( self.voice != "french" )
{
self addAllowedThreatCallout( "ai_location" );
self addAllowedThreatCallout( "generic_location" );
}
}
if ( IsDefined( self.script_battlechatter ) && !self.script_battlechatter )
{
self.battleChatter = false;
}
else
{
self.battleChatter = level.battlechatter[ self.team ];
}
if( self voiceCanBurst() )
{
self.flavorbursts = true;
}
else
{
self.flavorbursts = false;
}
if( level.friendlyfire_warnings )
{
self set_friendlyfire_warnings( true );
}
else
{
self set_friendlyfire_warnings( false );
}
self.chatInitialized = true;
prof_end("init_aiBattleChatter");
}
addThreatEvent( eventType, threat, priority )
{
self endon( "death" );
self endon( "removed from battleChatter" );
prof_begin( "addThreatEvent" );
ASSERTEX( IsDefined( eventType ), "addThreatEvent called with undefined eventType" );
if ( !self canSay( "threat", eventType, priority ) )
{
prof_end( "addThreatEvent" );
return;
}
if( threatWasAlreadyCalledOut( threat ) && !IsPlayer( threat ) )
{
prof_end( "addThreatEvent" );
return;
}
chatEvent = self createChatEvent( "threat", eventType, priority );
switch( eventType )
{
case "infantry":
chatEvent.threat = threat;
break;
}
if( IsDefined( threat.squad ) )
{
self.squad updateContact( threat.squad.squadName, self );
}
self.chatQueue[ "threat" ] = undefined;
self.chatQueue[ "threat" ] = chatEvent;
prof_end( "addThreatEvent" );
}
addResponseEvent( eventType, modifier, respondTo, priority, reportAlias, location )
{
self thread addResponseEvent_internal( eventType, modifier, respondTo, priority, reportAlias, location );
}
addResponseEvent_internal( eventType, modifier, respondTo, priority, reportAlias, location )
{
self endon( "death" );
self endon( "removed from battleChatter" );
self endon( "responseEvent_failsafe" );
self thread responseEvent_failSafe( respondTo );
message = respondTo waittill_any_return( "death", "done speaking", "cancel speaking" );
if ( message == "cancel speaking" )
{
return;
}
if ( !IsAlive( respondTo ) )
{
return;
}
if ( !self canSay( "response", eventType, priority, modifier ) )
{
return;
}
if ( !IsPlayer( respondTo ) )
{
if( self isUsingSameVoice( respondTo ) )
{
return;
}
}
chatEvent = self createChatEvent( "response", eventType, priority );
if( IsDefined( reportAlias ) )
{
chatEvent.reportAlias = reportAlias;
}
if( IsDefined( location ) )
{
chatEvent.location = location;
}
chatEvent.respondTo = respondTo;
chatEvent.modifier = modifier;
self.chatQueue[ "response" ] = undefined;
self.chatQueue[ "response" ] = chatEvent;
}
responseEvent_failSafe( respondTo )
{
self endon( "death" );
self endon( "removed from battleChatter" );
respondTo endon( "death" );
respondTo endon( "done speaking" );
respondTo endon( "cancel speaking" );
wait( 25 );
self notify( "responseEvent_failsafe" );
}
addInformEvent( eventType, modifier, informTo, priority )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !self canSay( "inform", eventType, priority, modifier ) )
{
return;
}
chatEvent = self createChatEvent( "inform", eventType, priority );
switch( eventType )
{
case "reloading":
chatEvent.modifier = modifier;
chatEvent.informTo = informTo;
break;
default:
chatEvent.modifier = modifier;
}
self.chatQueue[ "inform" ] = undefined;
self.chatQueue[ "inform" ] = chatEvent;
}
addReactionEvent( eventType, modifier, reactTo, priority )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !isdefined( self.chatQueue ) )
{
return;
}
chatEvent = self createChatEvent( "reaction", eventType, priority );
chatEvent.reactTo = reactTo;
chatEvent.modifier = modifier;
self.chatQueue[ "reaction" ] = undefined;
self.chatQueue[ "reaction" ] = chatEvent;
}
addOrderEvent( eventType, modifier, orderTo, priority )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !self canSay( "order", eventType, priority, modifier ) )
{
return;
}
if ( IsDefined( orderTo ) && orderTo.type == "dog" )
{
return;
}
chatEvent = self createChatEvent( "order", eventType, priority );
chatEvent.modifier = modifier;
chatEvent.orderTo = orderTo;
self.chatQueue[ "order" ] = undefined;
self.chatQueue[ "order" ] = chatEvent;
}
squadOfficerWaiter()
{
anim endon( "battlechatter disabled" );
anim endon( "squad deleted " + self.squadName );
while ( 1 )
{
officer = undefined;
if ( self.officers.size )
members = self.officers;
else
members = self.members;
officers = [];
for ( index = 0; index < members.size; index++ )
{
if ( isalive( members[ index ] ) )
officers[ officers.size ] = members[ index ];
}
if ( officers.size )
{
officer = getClosest( level.player.origin, officers );
officer aiOfficerOrders();
officer waittill( "death" );
}
wait( 3.0 );
}
}
getThreats( potentialThreats )
{
prof_begin("getThreats");
threats = [];
for ( i = 0; i < potentialThreats.size; i++ )
{
if ( !IsDefined( potentialThreats[ i ].enemyClass ) )
{
continue;
}
if( !threatIsViable( potentialThreats[i] ) )
{
continue;
}
potentialThreats[ i ].threatID = threats.size;
threats[ threats.size ] = potentialThreats[ i ];
}
threats = get_array_of_closest( level.player.origin, threats );
haveLocs = [];
noLocs = [];
foreach( threat in threats )
{
location = threat GetLocation();
if( IsDefined( location ) && !location_called_out_recently( location ) )
{
haveLocs[ haveLocs.size ] = threat;
}
else
{
noLocs[ noLocs.size ] = threat;
}
}
threats = array_combine( haveLocs, noLocs );
prof_end("getThreats");
return( threats );
}
threatIsViable( threat )
{
maxDistSqd = level.bcs_maxThreatDistFromPlayer * level.bcs_maxThreatDistFromPlayer;
if( DistanceSquared( level.player.origin, threat.origin ) > maxDistSqd )
{
return false;
}
if( !level.player entInFrontArc( threat ) )
{
return false;
}
return true;
}
squadThreatWaiter()
{
anim endon( "battlechatter disabled" );
anim endon( "squad deleted " + self.squadName );
while ( 1 )
{
wait( RandomFloatRange( 0.25, 0.75 ) );
prof_begin("squadThreatWaiter");
if ( self.team == "allies" )
{
validEnemies = getThreats( GetAIArray( "axis", "team3" ) );
}
else if ( self.team == "team3" )
{
validEnemies = getThreats( GetAIArray( "allies", "axis" ) );
}
else
{
validEnemies = GetAIArray( "allies", "team3" );
validEnemies[ validEnemies.size ] = level.player;
}
if ( !validEnemies.size )
{
prof_end("squadThreatWaiter");
continue;
}
addedEnemies = [];
foreach( i, member in self.members )
{
if ( !IsAlive( member ) )
{
continue;
}
if ( !validEnemies.size )
{
validEnemies = addedEnemies;
addedEnemies = [];
}
foreach( j, enemy in validEnemies )
{
if ( !IsDefined( enemy ) )
{
if ( j == 0 )
{
validEnemies = [];
}
continue;
}
if ( !IsAlive( enemy ) )
{
continue;
}
if ( !IsDefined( enemy.enemyClass) )
{
continue;
}
if( !member CanSee( enemy ) )
{
if( IsPlayer( enemy ) )
{
continue;
}
if( enemy.team == level.player.team )
{
continue;
}
if( !player_can_see_ai( enemy, 250 ) )
{
continue;
}
}
member addThreatEvent( enemy.enemyClass, enemy );
addedEnemies[ addedEnemies.size ] = enemy;
validEnemies = array_remove( validEnemies, enemy );
break;
}
prof_end("squadThreatWaiter");
wait( 0.05 );
prof_begin("squadThreatWaiter");
}
prof_end("squadThreatWaiter");
}
}
aiDeathFriendly()
{
attacker = self.attacker;
array_thread( self.squad.members, ::aiDeathEventThread );
if ( IsAlive( attacker ) && IsSentient( attacker ) && IsDefined( attacker.squad ) && attacker.battleChatter )
{
if ( IsDefined( attacker.calledOut[ attacker.squad.squadName ] ) )
{
attacker.calledOut[ attacker.squad.squadName ] = undefined;
}
if ( !IsDefined( attacker.enemyClass ) )
{
return;
}
if ( !attacker is_in_callable_location() )
{
return;
}
foreach( member in self.squad.members )
{
if ( GetTime() > ( member.lastEnemySightTime + 2000 ) )
{
continue;
}
member addThreatEvent( attacker.enemyClass, attacker );
}
}
}
aiDeathEventThread()
{
if( !IsAlive( self ) )
{
return;
}
self endon( "death" );
self endon( "removed from battleChatter" );
self notify ( "aiDeathEventThread" );
self endon ( "aiDeathEventThread" );
wait( 1.5 );
self addReactionEvent( "casualty", "generic", self, 0.9 );
}
aiDeathEnemy()
{
attacker = self.attacker;
if ( !IsAlive( attacker ) || !IsSentient( attacker ) || !IsDefined( attacker.squad ) )
{
return;
}
if( !IsDefined( attacker.countryID ) || attacker.countryID != "NS" )
{
return;
}
if ( !IsPlayer( attacker ) )
{
attacker thread aiKillEventThread();
}
}
aiKillEventThread()
{
self endon( "death" );
self endon( "removed from battleChatter" );
wait( 1.5 );
self addInformEvent( "killfirm", "generic" );
}
aiOfficerOrders()
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !isdefined( self.squad.chatInitialized ) )
self.squad waittill( "squad chat initialized" );
while ( 1 )
{
if ( getdvar( "bcs_enable", "on" ) == "off" )
{
wait( 1.0 );
continue;
}
self addSituationalOrder();
wait( RandomFloatRange( 3.0, 6.0 ) );
}
}
aiGrenadeDangerWaiter()
{
self endon( "death" );
self endon( "removed from battleChatter" );
while ( 1 )
{
self waittill( "grenade danger", grenade );
if ( getdvar( "bcs_enable", "on" ) == "off" )
continue;
if ( !isdefined( grenade ) || grenade.model != "projectile_m67fraggrenade" )
continue;
if ( distance( grenade.origin, level.player.origin ) < 512 )
self addInformEvent( "incoming", "grenade" );
}
}
aiDisplaceWaiter()
{
self endon( "death" );
self endon( "removed from battleChatter" );
while( true )
{
self waittill( "trigger" );
if ( getdvar( "bcs_enable", "on" ) == "off" )
continue;
if ( GetTime() < self.a.painTime + 4000 )
{
continue;
}
self addResponseEvent( "ack", "yes", level.player, 1.0 );
}
}
evaluateMoveEvent( wasInCover )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !bcsEnabled() )
{
return;
}
if ( !IsDefined( self.node ) )
{
return;
}
dist = Distance( self.origin, self.node.origin );
if ( dist < 512 )
{
return;
}
if ( !self isNodeCoverOrConceal() )
{
return;
}
if( !self nationalityOkForMoveOrder() )
{
return;
}
responder = self getResponder( 24, 1024, "response" );
if( self.team != "axis" && self.team != "team3" )
{
if( !IsDefined( responder ) )
{
responder = level.player;
}
else
{
if( RandomInt( 100 ) < anim.eventChance[ "moveEvent" ][ "ordertoplayer" ] )
{
responder = level.player;
}
}
}
if( self.combatTime > 0.0 )
{
if( RandomInt( 100 ) < anim.eventChance[ "moveEvent" ][ "coverme" ] )
{
self addOrderEvent( "action", "coverme", responder );
}
else
{
self addOrderEvent( "move", "combat", responder );
}
}
else
{
if( self nationalityOkForMoveOrderNoncombat() )
{
self addOrderEvent( "move", "noncombat", responder );
}
}
}
nationalityOkForMoveOrder()
{
if( self.countryID == "SS" )
{
return false;
}
return true;
}
nationalityOkForMoveOrderNoncombat()
{
if( self.countryID == "US" )
{
return true;
}
return false;
}
aiFollowOrderWaiter()
{
self endon( "death" );
self endon( "removed from battleChatter" );
while ( true )
{
level waittill( "follow order", speaker );
if ( !bcsEnabled() )
return;
if ( speaker.team != self.team )
continue;
if ( distance( self.origin, speaker.origin ) < 600 )
{
self addResponseEvent( "ack", "yes", speaker, 0.9 );
}
}
}
player_friendlyfire_waiter()
{
self endon( "death" );
self endon( "removed from battleChatter" );
self thread player_friendlyfire_waiter_damage();
while( 1 )
{
self waittill( "bulletwhizby", shooter, whizByDist );
if( !bcsEnabled() )
{
continue;
}
if( !IsPlayer( shooter ) )
{
continue;
}
if( self friendlyfire_whizby_distances_valid( shooter, whizbyDist ) )
{
self player_friendlyfire_addReactionEvent();
wait( 3 );
}
}
}
player_friendlyfire_addReactionEvent()
{
self addReactionEvent( "friendlyfire", undefined, level.player, 1.0 );
}
player_friendlyfire_waiter_damage()
{
self endon( "death" );
self endon( "removed from battleChatter" );
while( 1 )
{
self waittill( "damage", amount, attacker, direction_vec, point, type );
if( IsDefined( attacker ) && IsPlayer( attacker ) )
{
if( damage_is_valid_for_friendlyfire_warning( type ) )
{
self player_friendlyfire_addReactionEvent();
}
}
}
}
damage_is_valid_for_friendlyfire_warning( type )
{
if( !IsDefined( type ) )
{
return false;
}
switch( type )
{
case "MOD_MELEE":
case "MOD_GRENADE":
case "MOD_GRENADE_SPLASH":
case "MOD_CRUSH":
case "MOD_IMPACT":
return false;
}
return true;
}
friendlyfire_whizby_distances_valid( shooter, whizbyDist )
{
minDistFromAI = 256 * 256;
maxWhizbyDist = 42;
if( DistanceSquared( shooter.origin, self.origin ) < minDistFromAI )
{
return false;
}
if( whizbyDist > maxWhizbyDist )
{
return false;
}
return true;
}
evaluateReloadEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !bcsEnabled() )
{
return;
}
self addInformEvent( "reloading", "generic" );
}
evaluateMeleeEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !bcsEnabled() )
return( false );
if ( !isdefined( self.enemy ) )
return( false );
return( false );
}
evaluateFiringEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !bcsEnabled() )
return;
if ( !isdefined( self.enemy ) )
return;
}
evaluateSuppressionEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !bcsEnabled() )
return;
if ( !self.suppressed )
return;
self addInformEvent( "suppressed", "generic" );
}
evaluateAttackEvent( type )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !bcsEnabled() )
{
return;
}
ASSERTEX( IsDefined( type ), "Grenade type [self.grenadeWeapon] thrown is undefined!" );
self addInformEvent( "attack", "grenade" );
}
addSituationalOrder()
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( self.squad.squadStates[ "combat" ].isActive )
{
self addSituationalCombatOrder();
}
}
addSituationalCombatOrder()
{
self endon( "death" );
self endon( "removed from battleChatter" );
prof_begin("addSituationalCombatOrder");
squad = self.squad;
squad animscripts\squadmanager::updateStates();
if ( squad.squadStates[ "suppressed" ].isActive )
{
if ( squad.squadStates[ "cover" ].isActive )
{
responder = self getResponder( 96, 512, "response" );
self addOrderEvent( "action", "grenade", responder );
}
else
{
self addOrderEvent( "displace", "generic" );
}
}
else if ( squad.squadStates[ "combat" ].isActive )
{
if( self.countryID != "SS" )
{
responder = self getResponder( 24, 1024, "response" );
self addOrderEvent( "action", "suppress", responder );
}
}
prof_end( "addSituationalCombatOrder" );
}
custom_battlechatter_init_valid_phrases()
{
phrases = [];
phrases[ phrases.size ] = "order_move_combat";
phrases[ phrases.size ] = "order_move_noncombat";
phrases[ phrases.size ] = "order_action_coverme";
phrases[ phrases.size ] = "inform_reloading";
level.customBCS_validPhrases = phrases;
}
custom_battlechatter_validate_phrase( string )
{
foundIt = false;
foreach( phrase in level.customBCS_validPhrases )
{
if( phrase == string )
{
foundIt = true;
break;
}
}
return foundIt;
}
custom_battlechatter_internal( string )
{
if ( !IsDefined( level.customBcs_validPhrases ) )
{
custom_battlechatter_init_valid_phrases();
}
string = tolower( string );
phraseInvalidStr = anim.bcPrintFailPrefix + "custom battlechatter phrase '" + string + "' isn't valid.  look at _utility::custom_battlechatter_init_valid_phrases(), or the util script documentation for custom_battlechatter(), for a list of valid phrases.";
badCountryIdStr = anim.bcPrintFailPrefix + "AI at origin " + self.origin + "wasn't able to play custom battlechatter because his nationality is '" + self.countryID + "'.";
if( !custom_battlechatter_validate_phrase( string ) )
{
ASSERTMSG( phraseInvalidStr );
return false;
}
responder = self getResponder( 24, 512, "response" );
self beginCustomEvent();
switch( string )
{
case "order_move_combat":
if( !self nationalityOkForMoveOrder() )
{
return false;
}
self tryOrderTo( self.customChatPhrase, responder );
self addMoveCombatAliasEx();
break;
case "order_move_noncombat":
if( !self nationalityOkForMoveOrderNoncombat() )
{
return false;
}
self addMoveNoncombatAliasEx();
break;
case "order_action_coverme":
self tryOrderTo( self.customChatPhrase, responder );
self addActionCovermeAliasEx();
break;
case "inform_reloading":
self addInformReloadingAliasEx();
break;
default:
ASSERTMSG( phraseInvalidStr );
return false;
}
self endCustomEvent( 2000 );
return true;
}
beginCustomEvent()
{
if ( !bcsEnabled() )
return;
self.customChatPhrase = createChatPhrase();
}
addActionCovermeAliasEx()
{
self.customChatPhrase addOrderAlias( "action", "coverme" );
}
addMoveCombatAliasEx()
{
self.customChatPhrase addOrderAlias( "move", "combat" );
}
addMoveNoncombatAliasEx()
{
self.customChatPhrase addOrderAlias( "move", "noncombat" );
}
addInformReloadingAliasEx()
{
self.customChatPhrase addInformAlias( "reloading", "generic" );
}
addNameAliasEx( name )
{
if ( !bcsEnabled() )
return;
self.customChatPhrase addNameAlias( name );
}
endCustomEvent( eventDuration, typeOverride )
{
if ( !bcsEnabled() )
return;
chatEvent = self createChatEvent( "custom", "generic", 1.0 );
if ( isdefined( eventDuration ) )
chatEvent.expireTime = gettime() + eventDuration;
if ( isDefined( typeOverride ) )
chatEvent.type = typeOverride;
else
chatEvent.type = "custom";
self.chatQueue[ "custom" ] = undefined;
self.chatQueue[ "custom" ] = chatEvent;
}
