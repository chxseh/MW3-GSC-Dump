
#include common_scripts\utility;
#include maps\_utility;
#include animscripts\utility;
#include animscripts\battlechatter_ai;
init_battleChatter()
{
if ( IsDefined( anim.chatInitialized ) && anim.chatInitialized )
return;
SetDvarIfUninitialized( "bcs_enable", "on" );
if ( GetDvar( "bcs_enable", "on" ) == "off" )
{
anim.chatInitialized = false;
anim.player.chatInitialized = false;
return;
}
anim.chatInitialized = true;
anim.player.chatInitialized = false;
SetDvarIfUninitialized( "bcs_filterThreat", "off" );
SetDvarIfUninitialized( "bcs_filterInform", "off" );
SetDvarIfUninitialized( "bcs_filterOrder", "off" );
SetDvarIfUninitialized( "bcs_filterReaction", "off" );
SetDvarIfUninitialized( "bcs_filterResponse", "off" );
SetDvarIfUninitialized( "bcs_forceEnglish", "0" );
SetDvarIfUninitialized( "bcs_allowsamevoiceresponse", "off" );
SetDvarIfUninitialized( "debug_bcprint", "off" );
SetDvarIfUninitialized( "debug_bcprintdump", "off" );
SetDvarIfUninitialized( "debug_bcprintdumptype", "csv" );
SetDvarIfUninitialized( "debug_bcshowqueue", "off" );
anim.bcPrintFailPrefix = "^3***** BCS FAILURE: ";
anim.bcPrintWarnPrefix = "^3***** BCS WARNING: ";
bcs_setup_teams_array();
bcs_setup_countryIDs();
anim.playerNameIDs[ "american" ] = "1";
anim.playerNameIDs[ "seal" ] = "1";
anim.playerNameIDs[ "taskforce" ] = "1";
anim.playerNameIDs[ "secretservice" ] = "1";
anim.playerNameIDs[ "delta" ] = "1";
thread setPlayerBcNameID();
anim.usedIDs = [];
anim.usedIDs[ "russian" ] = [];
anim.usedIDs[ "russian" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "russian" ][ 0 ].count = 0;
anim.usedIDs[ "russian" ][ 0 ].npcID = "0";
anim.usedIDs[ "russian" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "russian" ][ 1 ].count = 0;
anim.usedIDs[ "russian" ][ 1 ].npcID = "1";
anim.usedIDs[ "russian" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "russian" ][ 2 ].count = 0;
anim.usedIDs[ "russian" ][ 2 ].npcID = "2";
anim.usedIDs[ "russian" ][ 3 ] = SpawnStruct();
anim.usedIDs[ "russian" ][ 3 ].count = 0;
anim.usedIDs[ "russian" ][ 3 ].npcID = "3";
anim.usedIDs[ "russian" ][ 4 ] = SpawnStruct();
anim.usedIDs[ "russian" ][ 4 ].count = 0;
anim.usedIDs[ "russian" ][ 4 ].npcID = "4";
anim.usedIDs[ "portuguese" ] = [];
anim.usedIDs[ "portuguese" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "portuguese" ][ 0 ].count = 0;
anim.usedIDs[ "portuguese" ][ 0 ].npcID = "0";
anim.usedIDs[ "portuguese" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "portuguese" ][ 1 ].count = 0;
anim.usedIDs[ "portuguese" ][ 1 ].npcID = "1";
anim.usedIDs[ "portuguese" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "portuguese" ][ 2 ].count = 0;
anim.usedIDs[ "portuguese" ][ 2 ].npcID = "2";
anim.usedIDs[ "shadowcompany" ] = [];
anim.usedIDs[ "shadowcompany" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "shadowcompany" ][ 0 ].count = 0;
anim.usedIDs[ "shadowcompany" ][ 0 ].npcID = "0";
anim.usedIDs[ "shadowcompany" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "shadowcompany" ][ 1 ].count = 0;
anim.usedIDs[ "shadowcompany" ][ 1 ].npcID = "1";
anim.usedIDs[ "shadowcompany" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "shadowcompany" ][ 2 ].count = 0;
anim.usedIDs[ "shadowcompany" ][ 2 ].npcID = "2";
anim.usedIDs[ "shadowcompany" ][ 3 ] = SpawnStruct();
anim.usedIDs[ "shadowcompany" ][ 3 ].count = 0;
anim.usedIDs[ "shadowcompany" ][ 3 ].npcID = "3";
anim.usedIDs[ "british" ] = [];
anim.usedIDs[ "british" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "british" ][ 0 ].count = 0;
anim.usedIDs[ "british" ][ 0 ].npcID = "0";
anim.usedIDs[ "british" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "british" ][ 1 ].count = 0;
anim.usedIDs[ "british" ][ 1 ].npcID = "1";
anim.usedIDs[ "american" ] = [];
anim.usedIDs[ "american" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "american" ][ 0 ].count = 0;
anim.usedIDs[ "american" ][ 0 ].npcID = "0";
anim.usedIDs[ "american" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "american" ][ 1 ].count = 0;
anim.usedIDs[ "american" ][ 1 ].npcID = "1";
anim.usedIDs[ "american" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "american" ][ 2 ].count = 0;
anim.usedIDs[ "american" ][ 2 ].npcID = "2";
anim.usedIDs[ "seal" ] = [];
anim.usedIDs[ "seal" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "seal" ][ 0 ].count = 0;
anim.usedIDs[ "seal" ][ 0 ].npcID = "0";
anim.usedIDs[ "seal" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "seal" ][ 1 ].count = 0;
anim.usedIDs[ "seal" ][ 1 ].npcID = "1";
anim.usedIDs[ "seal" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "seal" ][ 2 ].count = 0;
anim.usedIDs[ "seal" ][ 2 ].npcID = "2";
anim.usedIDs[ "seal" ][ 3 ] = SpawnStruct();
anim.usedIDs[ "seal" ][ 3 ].count = 0;
anim.usedIDs[ "seal" ][ 3 ].npcID = "3";
anim.usedIDs[ "taskforce" ] = [];
anim.usedIDs[ "taskforce" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "taskforce" ][ 0 ].count = 0;
anim.usedIDs[ "taskforce" ][ 0 ].npcID = "0";
anim.usedIDs[ "secretservice" ] = [];
anim.usedIDs[ "secretservice" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "secretservice" ][ 0 ].count = 0;
anim.usedIDs[ "secretservice" ][ 0 ].npcID = "0";
anim.usedIDs[ "secretservice" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "secretservice" ][ 1 ].count = 0;
anim.usedIDs[ "secretservice" ][ 1 ].npcID = "1";
anim.usedIDs[ "secretservice" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "secretservice" ][ 2 ].count = 0;
anim.usedIDs[ "secretservice" ][ 2 ].npcID = "2";
anim.usedIDs[ "secretservice" ][ 3 ] = SpawnStruct();
anim.usedIDs[ "secretservice" ][ 3 ].count = 0;
anim.usedIDs[ "secretservice" ][ 3 ].npcID = "3";
anim.usedIDs[ "arab" ] = [];
anim.usedIDs[ "arab" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "arab" ][ 0 ].count = 0;
anim.usedIDs[ "arab" ][ 0 ].npcID = "0";
anim.usedIDs[ "arab" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "arab" ][ 1 ].count = 0;
anim.usedIDs[ "arab" ][ 1 ].npcID = "1";
anim.usedIDs[ "arab" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "arab" ][ 2 ].count = 0;
anim.usedIDs[ "arab" ][ 2 ].npcID = "2";
anim.usedIDs[ "delta" ] = [];
anim.usedIDs[ "delta" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "delta" ][ 0 ].count = 0;
anim.usedIDs[ "delta" ][ 0 ].npcID = "0";
anim.usedIDs[ "delta" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "delta" ][ 1 ].count = 0;
anim.usedIDs[ "delta" ][ 1 ].npcID = "1";
anim.usedIDs[ "delta" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "delta" ][ 2 ].count = 0;
anim.usedIDs[ "delta" ][ 2 ].npcID = "2";
anim.usedIDs[ "french" ] = [];
anim.usedIDs[ "french" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "french" ][ 0 ].count = 0;
anim.usedIDs[ "french" ][ 0 ].npcID = "0";
anim.usedIDs[ "african" ] = [];
anim.usedIDs[ "african" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "african" ][ 0 ].count = 0;
anim.usedIDs[ "african" ][ 0 ].npcID = "0";
anim.usedIDs[ "african" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "african" ][ 1 ].count = 0;
anim.usedIDs[ "african" ][ 1 ].npcID = "1";
anim.usedIDs[ "african" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "african" ][ 2 ].count = 0;
anim.usedIDs[ "african" ][ 2 ].npcID = "2";
anim.usedIDs[ "czech" ] = [];
anim.usedIDs[ "czech" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "czech" ][ 0 ].count = 0;
anim.usedIDs[ "czech" ][ 0 ].npcID = "0";
anim.usedIDs[ "czech" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "czech" ][ 1 ].count = 0;
anim.usedIDs[ "czech" ][ 1 ].npcID = "1";
anim.usedIDs[ "czech" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "czech" ][ 2 ].count = 0;
anim.usedIDs[ "czech" ][ 2 ].npcID = "2";
anim.usedIDs[ "pmc" ] = [];
anim.usedIDs[ "pmc" ][ 0 ] = SpawnStruct();
anim.usedIDs[ "pmc" ][ 0 ].count = 0;
anim.usedIDs[ "pmc" ][ 0 ].npcID = "0";
anim.usedIDs[ "pmc" ][ 1 ] = SpawnStruct();
anim.usedIDs[ "pmc" ][ 1 ].count = 0;
anim.usedIDs[ "pmc" ][ 1 ].npcID = "1";
anim.usedIDs[ "pmc" ][ 2 ] = SpawnStruct();
anim.usedIDs[ "pmc" ][ 2 ].count = 0;
anim.usedIDs[ "pmc" ][ 2 ].npcID = "2";
init_flavorbursts();
if ( !IsDefined( level.friendlyfire_warnings ) )
{
level.friendlyfire_warnings = false;
}
anim.eventTypeMinWait = [];
anim.eventTypeMinWait[ "threat" ] = [];
anim.eventTypeMinWait[ "response" ] = [];
anim.eventTypeMinWait[ "reaction" ] = [];
anim.eventTypeMinWait[ "order" ] = [];
anim.eventTypeMinWait[ "inform" ] = [];
anim.eventTypeMinWait[ "custom" ] = [];
anim.eventTypeMinWait[ "direction" ] = [];
if ( IsDefined( level._stealth ) )
{
anim.eventActionMinWait[ "threat" ][ "self" ] = 20000;
anim.eventActionMinWait[ "threat" ][ "squad" ] = 30000;
}
else
{
anim.eventActionMinWait[ "threat" ][ "self" ] = 12500;
anim.eventActionMinWait[ "threat" ][ "squad" ] = 7500;
}
anim.eventActionMinWait[ "threat" ][ "location_repeat" ] = 5000;
anim.eventActionMinWait[ "response" ][ "self" ] = 1000;
anim.eventActionMinWait[ "response" ][ "squad" ] = 1000;
anim.eventActionMinWait[ "reaction" ][ "self" ] = 1000;
anim.eventActionMinWait[ "reaction" ][ "squad" ] = 1000;
anim.eventActionMinWait[ "order" ][ "self" ] = 8000;
anim.eventActionMinWait[ "order" ][ "squad" ] = 10000;
anim.eventActionMinWait[ "inform" ][ "self" ] = 6000;
anim.eventActionMinWait[ "inform" ][ "squad" ] = 8000;
anim.eventActionMinWait[ "custom" ][ "self" ] = 0;
anim.eventActionMinWait[ "custom" ][ "squad" ] = 0;
anim.eventTypeMinWait[ "playername" ] = 50000;
anim.eventTypeMinWait[ "reaction" ][ "casualty" ] = 14000;
anim.eventTypeMinWait[ "reaction" ][ "friendlyfire" ] = 5000;
anim.eventTypeMinWait[ "reaction" ][ "taunt" ] = 30000;
anim.eventTypeMinWait[ "inform" ][ "reloading" ] = 20000;
anim.eventTypeMinWait[ "inform" ][ "killfirm" ] = 15000;
anim.eventPriority[ "threat" ][ "infantry" ] = 0.5;
anim.eventPriority[ "threat" ][ "vehicle" ] = 0.7;
anim.eventPriority[ "response" ][ "ack" ] = 0.9;
anim.eventPriority[ "response" ][ "exposed" ] = 0.8;
anim.eventPriority[ "response" ][ "callout" ] = 0.9;
anim.eventPriority[ "response" ][ "echo" ] = 0.9;
anim.eventPriority[ "reaction" ][ "casualty" ] = 0.5;
anim.eventPriority[ "reaction" ][ "friendlyfire" ] = 1.0;
anim.eventPriority[ "reaction" ][ "taunt" ] = 0.9;
anim.eventPriority[ "order" ][ "action" ] = 0.3;
anim.eventPriority[ "order" ][ "move" ] = 0.3;
anim.eventPriority[ "order" ][ "displace" ] = 0.5;
anim.eventPriority[ "inform" ][ "attack" ] = 0.9;
anim.eventPriority[ "inform" ][ "incoming" ] = 0.9;
anim.eventPriority[ "inform" ][ "reloading" ] = 0.2;
anim.eventPriority[ "inform" ][ "suppressed" ] = 0.2;
anim.eventPriority[ "inform" ][ "killfirm" ] = 0.7;
anim.eventPriority[ "custom" ][ "generic" ] = 1.0;
anim.eventDuration[ "threat" ][ "infantry" ] = 1000;
anim.eventDuration[ "threat" ][ "vehicle" ] = 1000;
anim.eventDuration[ "response" ][ "exposed" ] = 2000;
anim.eventDuration[ "response" ][ "callout" ] = 2000;
anim.eventDuration[ "response" ][ "echo" ] = 2000;
anim.eventDuration[ "response" ][ "ack" ] = 1750;
anim.eventDuration[ "reaction" ][ "casualty" ] = 2000;
anim.eventDuration[ "reaction" ][ "friendlyfire" ] = 1000;
anim.eventDuration[ "reaction" ][ "taunt" ] = 2000;
anim.eventDuration[ "order" ][ "action" ] = 3000;
anim.eventDuration[ "order" ][ "move" ] = 3000;
anim.eventDuration[ "order" ][ "displace" ] = 3000;
anim.eventDuration[ "inform" ][ "attack" ] = 1000;
anim.eventDuration[ "inform" ][ "incoming" ] = 1500;
anim.eventDuration[ "inform" ][ "reloading" ] = 1000;
anim.eventDuration[ "inform" ][ "suppressed" ] = 2000;
anim.eventDuration[ "inform" ][ "killfirm" ] = 2000;
anim.eventDuration[ "custom" ][ "generic" ] = 1000;
anim.eventChance[ "response" ][ "exposed" ] = 75;
anim.eventChance[ "response" ][ "reload" ] = 65;
anim.eventChance[ "response" ][ "callout" ] = 75;
anim.eventChance[ "response" ][ "callout_negative" ] = 20;
anim.eventChance[ "response" ][ "order" ] = 40;
anim.eventChance[ "moveEvent" ][ "coverme" ] = 70;
anim.eventChance[ "moveEvent" ][ "ordertoplayer" ] = 10;
anim.fbt_desiredDistMax = 620;
anim.fbt_waitMin = 12;
anim.fbt_waitMax = 24;
anim.fbt_lineBreakMin = 2;
anim.fbt_lineBreakMax = 5;
anim.moveOrigin = Spawn( "script_origin", ( 0, 0, 0 ) );
if ( !IsDefined( level.bcs_maxTalkingDistFromPlayer ) )
{
level.bcs_maxTalkingDistFromPlayer = 1500;
}
if ( !IsDefined( level.bcs_maxThreatDistFromPlayer ) )
{
level.bcs_maxThreatDistFromPlayer = 2500;
}
level.heightForHighCallout = 96.0;
level.minDistanceCallout = 8.0;
level.maxDistanceCallout = 45.0;
maps\_bcs_location_trigs::bcs_location_trigs_init();
Assert( IsDefined( anim.bcs_locations ) );
anim.locationLastCalloutTimes = [];
anim.scriptedDialogueBufferTime = 4000;
anim.bcs_threatResetTime = 3000;
anim.squadCreateFuncs[ anim.squadCreateFuncs.size ] = ::init_squadBattleChatter;
anim.squadCreateStrings[ anim.squadCreateStrings.size ] = "::init_squadBattleChatter";
foreach ( team in anim.teams )
{
anim.isTeamSpeaking[ team ] = false;
anim.isTeamSaying[ team ][ "threat" ] = false;
anim.isTeamSaying[ team ][ "order" ] = false;
anim.isTeamSaying[ team ][ "reaction" ] = false;
anim.isTeamSaying[ team ][ "response" ] = false;
anim.isTeamSaying[ team ][ "inform" ] = false;
anim.isTeamSaying[ team ][ "custom" ] = false;
}
bcs_setup_chatter_toggle_array();
if ( !IsDefined( anim.flavorburstVoices ) )
{
anim.flavorburstVoices = [];
anim.flavorburstVoices[ "american" ] = true;
anim.flavorburstVoices[ "delta" ] = false;
anim.flavorburstVoices[ "french" ] = false;
anim.flavorburstVoices[ "czech" ] = false;
anim.flavorburstVoices[ "pmc" ] = false;
anim.flavorburstVoices[ "african" ] = false;
anim.flavorburstVoices[ "shadowcompany" ] = true;
anim.flavorburstVoices[ "seal" ] = false;
anim.flavorburstVoices[ "taskforce" ] = false;
anim.flavorburstVoices[ "secretservice" ] = false;
anim.flavorburstVoices[ "british" ] = false;
}
bcs_setup_flavorburst_toggle_array();
anim.lastTeamSpeakTime = [];
anim.lastNameSaid = [];
anim.lastNameSaidTime = [];
foreach ( team in anim.teams )
{
anim.lastTeamSpeakTime[ team ] = -50000;
anim.lastNameSaid[ team ] = "none";
anim.lastNameSaidTime[ team ] = -100000;
}
anim.lastNameSaidTimeout = 120000;
for ( index = 0; index < anim.squadIndex.size; index++ )
{
if ( IsDefined( anim.squadIndex[ index ].chatInitialized ) && anim.squadIndex[ index ].chatInitialized )
continue;
anim.squadIndex[ index ] init_squadBattleChatter();
}
anim.threatCallouts = [];
anim.threatCallouts[ "rpg" ] = 100;
anim.threatCallouts[ "exposed" ] = 25;
anim.threatCallouts[ "player_distance" ] = 25;
anim.threatCallouts[ "player_obvious" ] = 25;
anim.threatCallouts[ "player_contact_clock" ] = 25;
anim.threatCallouts[ "player_target_clock" ] = 25;
anim.threatCallouts[ "player_target_clock_high" ] = 25;
anim.threatCallouts[ "player_cardinal" ] = 20;
anim.threatCallouts[ "ai_distance" ] = 25;
anim.threatCallouts[ "ai_obvious" ] = 25;
anim.threatCallouts[ "ai_contact_clock" ] = 20;
anim.threatCallouts[ "ai_target_clock" ] = 20;
anim.threatCallouts[ "ai_target_clock_high" ] = 75;
anim.threatCallouts[ "ai_cardinal" ] = 10;
anim.threatCallouts[ "player_location" ] = 95;
anim.threatCallouts[ "ai_location" ] = 100;
anim.threatCallouts[ "generic_location" ] = 90;
anim.lastTeamThreatCallout = [];
anim.lastTeamThreatCalloutTime = [];
foreach ( team in anim.teams )
{
anim.lastTeamThreatCallout[ team ] = undefined;
anim.lastTeamThreatCalloutTime[ team ] = undefined;
}
anim.teamThreatCalloutLimitTimeout = 120000;
level notify( "battlechatter initialized" );
anim notify( "battlechatter initialized" );
}
bcs_setup_teams_array()
{
if ( !IsDefined( anim.teams ) )
{
anim.teams = [];
anim.teams[ anim.teams.size ] = "axis";
anim.teams[ anim.teams.size ] = "allies";
anim.teams[ anim.teams.size ] = "team3";
anim.teams[ anim.teams.size ] = "neutral";
}
}
bcs_setup_countryIDs()
{
if ( !IsDefined( anim.countryIDs ) )
{
anim.countryIDs[ "british" ] = "UK";
anim.countryIDs[ "american" ] = "US";
anim.countryIDs[ "seal" ] = "NS";
anim.countryIDs[ "taskforce" ] = "TF";
anim.countryIDs[ "secretservice" ] = "SS";
anim.countryIDs[ "russian" ] = "RU";
anim.countryIDs[ "arab" ] = "AB";
anim.countryIDs[ "portuguese" ] = "PG";
anim.countryIDs[ "shadowcompany" ] = "SC";
anim.countryIDs[ "delta" ] = "DF";
anim.countryIDs[ "french" ] = "FR";
anim.countryIDs[ "african" ] = "AF";
anim.countryIDs[ "czech" ] = "CZ";
anim.countryIDs[ "pmc" ] = "PC";
}
}
bcs_setup_chatter_toggle_array()
{
bcs_setup_teams_array();
if ( !IsDefined( level.battlechatter ) )
{
level.battlechatter = [];
foreach ( team in anim.teams )
{
set_battlechatter_variable( team, true );
}
}
}
bcs_setup_flavorburst_toggle_array()
{
bcs_setup_teams_array();
if ( !IsDefined( level.flavorbursts ) )
{
level.flavorbursts = [];
foreach ( team in anim.teams )
{
level.flavorbursts[ team ] = true;
}
}
}
init_flavorbursts()
{
anim.flavorbursts[ "american" ] = [];
numBursts = 41;
us = [];
if ( level.script == "roadkill" || level.script == "trainer" )
{
us[ us.size ] = 13;
us[ us.size ] = 15;
us[ us.size ] = 16;
us[ us.size ] = 19;
us[ us.size ] = 20;
us[ us.size ] = 30;
us[ us.size ] = 31;
us[ us.size ] = 33;
us[ us.size ] = 38;
}
for ( i = 0; i < numBursts; i++ )
{
if ( us.size )
{
foundOne = false;
foreach ( sequenceNum in us )
{
if ( sequenceNum == i )
{
foundOne = true;
break;
}
}
if ( foundOne )
{
continue;
}
}
anim.flavorbursts[ "american" ][ i ] = string( i + 1 );
}
anim.flavorbursts[ "shadowcompany" ] = [];
numBursts = 9;
for ( i = 1; i <= numBursts; i++ )
{
anim.flavorbursts[ "shadowcompany" ][ i ] = string( i + 1 );
}
anim.flavorburstsUsed = [];
}
shutdown_battleChatter()
{
anim.countryIDs = undefined;
anim.eventTypeMinWait = undefined;
anim.eventActionMinWait = undefined;
anim.eventTypeMinWait = undefined;
anim.eventPriority = undefined;
anim.eventDuration = undefined;
anim.moveOrigin = undefined;
anim.scriptedDialogueBufferTime = undefined;
anim.bcs_threatResetTime = undefined;
anim.locationLastCalloutTimes = undefined;
anim.usedIDs = undefined;
anim.flavorburstsUsed = undefined;
anim.lastTeamThreatCallout = undefined;
anim.lastTeamThreatCalloutTime = undefined;
anim.lastNameSaidTimeout = undefined;
anim.lastNameSaid = undefined;
anim.lastNameSaidTime = undefined;
anim.chatInitialized = false;
anim.player.chatInitialized = false;
level.battlechatter = undefined;
for ( i = 0; i < anim.squadCreateFuncs.size; i++ )
{
if ( anim.squadCreateStrings[ i ] != "::init_squadBattleChatter" )
continue;
if ( i != ( anim.squadCreateFuncs.size - 1 ) )
{
anim.squadCreateFuncs[ i ] = anim.squadCreateFuncs[ anim.squadCreateFuncs.size - 1 ];
anim.squadCreateStrings[ i ] = anim.squadCreateStrings[ anim.squadCreateStrings.size - 1 ];
}
anim.squadCreateFuncs[ anim.squadCreateFuncs.size - 1 ] = undefined;
anim.squadCreateStrings[ anim.squadCreateStrings.size - 1 ] = undefined;
}
level notify( "battlechatter disabled" );
anim notify( "battlechatter disabled" );
}
init_squadBattleChatter()
{
squad = self;
squad.numSpeakers = 0;
squad.maxSpeakers = 1;
squad.nextSayTime = GetTime() + 50;
squad.nextSayTimes[ "threat" ] = GetTime() + 50;
squad.nextSayTimes[ "order" ] = GetTime() + 50;
squad.nextSayTimes[ "reaction" ] = GetTime() + 50;
squad.nextSayTimes[ "response" ] = GetTime() + 50;
squad.nextSayTimes[ "inform" ] = GetTime() + 50;
squad.nextSayTimes[ "custom" ] = GetTime() + 50;
squad.nextTypeSayTimes[ "threat" ] = [];
squad.nextTypeSayTimes[ "order" ] = [];
squad.nextTypeSayTimes[ "reaction" ] = [];
squad.nextTypeSayTimes[ "response" ] = [];
squad.nextTypeSayTimes[ "inform" ] = [];
squad.nextTypeSayTimes[ "custom" ] = [];
squad.isMemberSaying[ "threat" ] = false;
squad.isMemberSaying[ "order" ] = false;
squad.isMemberSaying[ "reaction" ] = false;
squad.isMemberSaying[ "response" ] = false;
squad.isMemberSaying[ "inform" ] = false;
squad.isMemberSaying[ "custom" ] = false;
squad.lastDirection = "";
squad.memberAddFuncs[ squad.memberAddFuncs.size ] = ::addToSystem;
squad.memberAddStrings[ squad.memberAddStrings.size ] = "::addToSystem";
squad.memberRemoveFuncs[ squad.memberRemoveFuncs.size ] = ::removeFromSystem;
squad.memberRemoveStrings[ squad.memberRemoveStrings.size ] = "::removeFromSystem";
squad.squadUpdateFuncs[ squad.squadUpdateFuncs.size ] = ::initContact;
squad.squadUpdateStrings[ squad.squadUpdateStrings.size ] = "::initContact";
squad.fbt_firstBurst = true;
squad.fbt_lastBursterID = undefined;
for ( i = 0; i < anim.squadIndex.size; i++ )
squad thread initContact( anim.squadIndex[ i ].squadName );
squad thread squadThreatWaiter();
squad thread squadOfficerWaiter();
squad thread squadFlavorBurstTransmissions();
squad.chatInitialized = true;
squad notify( "squad chat initialized" );
}
shutdown_squadBattleChatter()
{
squad = self;
squad.numSpeakers = undefined;
squad.maxSpeakers = undefined;
squad.nextSayTime = undefined;
squad.nextSayTimes = undefined;
squad.nextTypeSayTimes = undefined;
squad.isMemberSaying = undefined;
squad.fbt_firstBurst = undefined;
squad.fbt_lastBursterID = undefined;
for ( i = 0; i < squad.memberAddFuncs.size; i++ )
{
if ( squad.memberAddStrings[ i ] != "::addToSystem" )
continue;
if ( i != ( squad.memberAddFuncs.size - 1 ) )
{
squad.memberAddFuncs[ i ] = squad.memberAddFuncs[ squad.memberAddFuncs.size - 1 ];
squad.memberAddStrings[ i ] = squad.memberAddStrings[ squad.memberAddStrings.size - 1 ];
}
squad.memberAddFuncs[ squad.memberAddFuncs.size - 1 ] = undefined;
squad.memberAddStrings[ squad.memberAddStrings.size - 1 ] = undefined;
}
for ( i = 0; i < squad.memberRemoveFuncs.size; i++ )
{
if ( squad.memberRemoveStrings[ i ] != "::removeFromSystem" )
continue;
if ( i != ( squad.memberRemoveFuncs.size - 1 ) )
{
squad.memberRemoveFuncs[ i ] = squad.memberRemoveFuncs[ squad.memberRemoveFuncs.size - 1 ];
squad.memberRemoveStrings[ i ] = squad.memberRemoveStrings[ squad.memberRemoveStrings.size - 1 ];
}
squad.memberRemoveFuncs[ squad.memberRemoveFuncs.size - 1 ] = undefined;
squad.memberRemoveStrings[ squad.memberRemoveStrings.size - 1 ] = undefined;
}
for ( i = 0; i < squad.squadUpdateFuncs.size; i++ )
{
if ( squad.squadUpdateStrings[ i ] != "::initContact" )
continue;
if ( i != ( squad.squadUpdateFuncs.size - 1 ) )
{
squad.squadUpdateFuncs[ i ] = squad.squadUpdateFuncs[ squad.squadUpdateFuncs.size - 1 ];
squad.squadUpdateStrings[ i ] = squad.squadUpdateStrings[ squad.squadUpdateStrings.size - 1 ];
}
squad.squadUpdateFuncs[ squad.squadUpdateFuncs.size - 1 ] = undefined;
squad.squadUpdateStrings[ squad.squadUpdateStrings.size - 1 ] = undefined;
}
for ( i = 0; i < anim.squadIndex.size; i++ )
squad shutdownContact( anim.squadIndex[ i ].squadName );
squad.chatInitialized = false;
}
bcsEnabled()
{
return anim.chatInitialized;
}
bcsDebugWaiter()
{
lastState = GetDvar( "bcs_enable", "on" );
while ( 1 )
{
state = GetDvar( "bcs_enable", "on" );
if ( state != lastState )
{
switch( state )
{
case "on":
if ( !anim.chatInitialized )
enableBattleChatter();
break;
case "off":
if ( anim.chatInitialized )
disableBattleChatter();
break;
}
lastState = state;
}
wait( 1.0 );
}
}
enableBattleChatter()
{
init_battleChatter();
anim.player thread animscripts\battleChatter_ai::addToSystem();
ai = GetAIArray();
for ( i = 0; i < ai.size; i++ )
{
ai[ i ] addToSystem();
}
}
disableBattleChatter()
{
shutdown_battleChatter();
ai = GetAIArray();
for ( i = 0; i < ai.size; i++ )
{
if ( IsDefined( ai[ i ].squad ) && ai[ i ].squad.chatInitialized )
ai[ i ].squad shutdown_squadBattleChatter();
ai[ i ] removeFromSystem();
}
}
setPlayerBcNameID( overrideNameID, overrideCountryID )
{
if ( IsDefined( overrideNameID ) && IsDefined( overrideCountryID ) )
{
level.player.bcNameID = overrideNameID;
level.player.bcCountryID = overrideCountryID;
return;
}
while ( !IsDefined( level.campaign ) )
{
wait( 0.1 );
}
nationality = level.campaign;
nameID = anim.playerNameIDs[ nationality ];
countryID = anim.countryIDs[ nationality ];
if ( IsDefined( nameID ) )
{
level.player.bcNameID = nameID;
}
if ( IsDefined( countryID ) )
{
level.player.bcCountryID = countryID;
}
}
playBattleChatter()
{
if ( !IsAlive( self ) )
{
return;
}
if ( !bcsEnabled() )
{
return;
}
if ( self._animActive > 0 )
{
return;
}
if ( IsDefined( self.isSpeaking ) && self.isSpeaking )
{
return;
}
if ( self.team == "allies" && IsDefined( anim.scriptedDialogueStartTime ) )
{
if ( ( anim.scriptedDialogueStartTime + anim.scriptedDialogueBufferTime ) > GetTime() )
{
return;
}
}
if ( self friendlyfire_warning() )
{
return;
}
if ( !IsDefined( self.battleChatter ) || !self.battleChatter )
{
return;
}
if ( self.team == "allies" && GetDvarInt( "bcs_forceEnglish", 0 ) )
{
return;
}
if ( anim.isTeamSpeaking[ self.team ] )
{
return;
}
self endon( "death" );
event = self getHighestPriorityEvent();
if ( !IsDefined( event ) )
{
return;
}
switch( event )
{
case "custom":
self thread playCustomEvent();
break;
case "response":
self thread playResponseEvent();
break;
case "order":
self thread playOrderEvent();
break;
case "threat":
self thread playThreatEvent();
break;
case "reaction":
self thread playReactionEvent();
break;
case "inform":
self thread playInformEvent();
break;
}
}
playThreatEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
self endon( "cancel speaking" );
self.curEvent = self.chatQueue[ "threat" ];
threat = self.chatQueue[ "threat" ].threat;
if ( !IsAlive( threat ) )
{
return;
}
if ( threatWasAlreadyCalledOut( threat ) && !IsPlayer( threat ) )
{
return;
}
anim thread lockAction( self, "threat" );
success = false;
switch( self.chatQueue[ "threat" ].eventType )
{
case "infantry":
if ( IsPlayer( threat ) || !IsDefined( threat GetTurret() ) )
{
success = self threatInfantry( threat );
}
else
{
}
break;
case "dog":
success = self threatDog( threat );
break;
case "vehicle":
break;
}
self notify( "done speaking" );
if ( !success )
{
return;
}
if ( !IsAlive( threat ) )
{
return;
}
threat.calledOut[ self.squad.squadName ] = SpawnStruct();
threat.calledOut[ self.squad.squadName ].spotter = self;
threat.calledOut[ self.squad.squadName ].threatType = self.chatQueue[ "threat" ].eventType;
threat.calledOut[ self.squad.squadName ].expireTime = GetTime() + anim.bcs_threatResetTime;
if ( IsDefined( threat.squad ) )
{
self.squad.squadList[ threat.squad.squadName ].calledOut = true;
}
}
threatWasAlreadyCalledOut( threat )
{
if ( IsDefined( threat.calledOut ) && IsDefined( threat.calledOut[ self.squad.squadName ] ) )
{
if ( threat.calledOut[ self.squad.squadName ].expireTime < GetTime() )
{
return true;
}
}
return false;
}
threatInfantry( threat, forceDetail )
{
self endon( "cancel speaking" );
chatPhrase = self createChatPhrase();
chatPhrase.master = true;
chatPhrase.threatEnt = threat;
callout = self getThreatInfantryCalloutType( threat );
if ( !IsDefined( callout ) || ( IsDefined( callout ) && !IsDefined( callout.type ) ) )
{
return false;
}
switch( callout.type )
{
case "rpg":
chatPhrase threatInfantryRPG( threat );
break;
case "exposed":
doResponse = self doExposedCalloutResponse( callout.responder );
if ( doResponse && self canSayName( callout.responder ) )
{
chatPhrase addNameAlias( callout.responder.bcName );
chatPhrase.lookTarget = callout.responder;
}
chatPhrase threatInfantryExposed( threat );
if ( doResponse )
{
if ( RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout_negative" ] )
{
callout.responder addResponseEvent( "callout", "neg", self, 0.9 );
}
else
{
callout.responder addResponseEvent( "exposed", "acquired", self, 0.9 );
}
}
break;
case "player_obvious":
chatPhrase addPlayerNameAlias();
chatPhrase addThreatObviousAlias();
break;
case "player_distance":
distance = getDistanceYardsNormalized( level.player.origin, threat.origin );
chatPhrase addPlayerNameAlias();
chatPhrase addThreatDistanceAlias( distance );
break;
case "player_contact_clock":
chatPhrase addPlayerNameAlias();
chatPhrase addThreatCalloutAlias( "contactclock", callout.playerClockDirection );
break;
case "player_target_clock":
chatPhrase addPlayerNameAlias();
chatPhrase addThreatCalloutAlias( "targetclock", callout.playerClockDirection );
break;
case "player_target_clock_high":
chatPhrase addPlayerNameAlias();
degreesElevation = getDegreesElevation( level.player.origin, threat.origin );
if ( degreesElevation >= 20 && degreesElevation <= 50 )
{
chatPhrase addThreatCalloutAlias( "targetclock", callout.playerClockDirection );
chatPhrase addThreatElevationAlias( degreesElevation );
}
else
chatPhrase addThreatCalloutAlias( "targetclock", callout.playerClockDirection + "_high" );
break;
case "player_cardinal":
chatPhrase addPlayerNameAlias();
cardinalDirection = getDirectionCompass( level.player.origin, threat.origin );
normalizedDirection = normalizeCompassDirection( cardinalDirection );
if ( normalizedDirection == "impossible" )
{
return false;
}
chatPhrase addThreatCalloutAlias( "cardinal", normalizedDirection );
break;
case "ai_obvious":
if ( IsDefined( callout.responder ) && self canSayName( callout.responder ) )
{
chatPhrase addNameAlias( callout.responder.bcName );
chatPhrase.lookTarget = callout.responder;
}
chatPhrase addThreatObviousAlias();
chatPhrase addCalloutResponseEvent( self, callout, threat );
break;
case "ai_distance":
relativeGuy = self;
if ( self.team == "allies" )
{
relativeGuy = level.player;
}
else if ( IsDefined( callout.responder )
&& RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout" ] )
{
relativeGuy = callout.responder;
}
distance = getDistanceYardsNormalized( relativeGuy.origin, threat.origin );
chatPhrase addThreatDistanceAlias( distance );
chatPhrase addCalloutResponseEvent( self, callout, threat );
break;
case "ai_contact_clock":
relativeGuy = self;
if ( self.team == "allies" )
{
relativeGuy = level.player;
}
else if ( IsDefined( callout.responder )
&& RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout" ] )
{
relativeGuy = callout.responder;
}
angles = getRelativeAngles( relativeGuy );
clockDirection = getDirectionFacingClock( angles, relativeGuy.origin, threat.origin );
chatPhrase addThreatCalloutAlias( "contactclock", clockDirection );
chatPhrase addCalloutResponseEvent( self, callout, threat );
break;
case "ai_target_clock":
relativeGuy = self;
if ( self.team == "allies" )
{
relativeGuy = level.player;
}
else if ( IsDefined( callout.responder )
&& RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout" ] )
{
relativeGuy = callout.responder;
}
angles = getRelativeAngles( relativeGuy );
clockDirection = getDirectionFacingClock( angles, relativeGuy.origin, threat.origin );
chatPhrase addThreatCalloutAlias( "targetclock", clockDirection );
chatPhrase addCalloutResponseEvent( self, callout, threat );
break;
case "ai_target_clock_high":
relativeGuy = self;
if ( self.team == "allies" )
{
relativeGuy = level.player;
}
else if ( IsDefined( callout.responder )
&& RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout" ] )
{
relativeGuy = callout.responder;
}
angles = getRelativeAngles( relativeGuy );
clockDirection = getDirectionFacingClock( angles, relativeGuy.origin, threat.origin );
degreesElevation = getDegreesElevation( relativeGuy.origin, threat.origin );
if ( degreesElevation >= 20 && degreesElevation <= 50 )
{
chatPhrase addThreatCalloutAlias( "targetclock", clockDirection );
chatPhrase addThreatElevationAlias( degreesElevation );
}
else
chatPhrase addThreatCalloutAlias( "targetclock", clockDirection + "_high" );
chatPhrase addCalloutResponseEvent( self, callout, threat );
break;
case "ai_cardinal":
relativeGuy = self;
if ( self.team == "allies" )
{
relativeGuy = level.player;
}
cardinalDirection = getDirectionCompass( relativeGuy.origin, threat.origin );
normalizedDirection = normalizeCompassDirection( cardinalDirection );
if ( normalizedDirection == "impossible" )
{
return false;
}
chatPhrase addThreatCalloutAlias( "cardinal", normalizedDirection );
break;
case "generic_location":
Assert( IsDefined( callout.location ) );
success = chatPhrase threatInfantry_doCalloutLocation( callout );
if ( !success )
{
return false;
}
break;
case "player_location":
Assert( IsDefined( callout.location ) );
chatPhrase addPlayerNameAlias();
success = chatPhrase threatInfantry_doCalloutLocation( callout );
if ( !success )
{
return false;
}
break;
case "ai_location":
Assert( IsDefined( callout.location ) );
AssertEx( IsDefined( callout.responder ), "we should have found a valid responder in order to do an ai_location callout!" );
if ( self canSayName( callout.responder ) )
{
chatPhrase addNameAlias( callout.responder.bcName );
chatPhrase.lookTarget = callout.responder;
}
success = chatPhrase threatInfantry_doCalloutLocation( callout );
if ( !success )
{
return false;
}
index = chatPhrase.soundaliases.size - 1;
alias = chatPhrase.soundaliases[ index ];
if ( IsCalloutTypeReport( alias ) )
{
callout.responder addResponseEvent( "callout", "echo", self, 0.9, alias );
}
else if ( IsCalloutTypeQA( alias, self ) )
{
callout.responder addResponseEvent( "callout", "QA", self, 0.9, alias, callout.location );
}
else
{
if ( RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout_negative" ] )
{
callout.responder addResponseEvent( "callout", "neg", self, 0.9 );
}
else
{
callout.responder addResponseEvent( "exposed", "acquired", self, 0.9 );
}
}
break;
}
setLastCalloutType( callout.type );
self playPhrase( chatPhrase );
return true;
}
doExposedCalloutResponse( responder )
{
if ( !IsDefined( responder ) )
{
return false;
}
if ( responder.countryID != "US" && responder.countryID != "NS" && responder.countryID != "TF" )
{
return false;
}
if ( RandomInt( 100 ) > anim.eventChance[ "response" ][ "exposed" ] )
{
return false;
}
return true;
}
threatInfantry_doCalloutLocation( callout )
{
success = self addThreatCalloutLocationAlias( callout.location );
return success;
}
addCalloutResponseEvent( respondTo, callout, threat )
{
if ( !IsDefined( callout.responder ) )
{
return;
}
if ( RandomInt( 100 ) > anim.eventChance[ "response" ][ "callout" ] )
{
return;
}
modifier = "affirm";
if ( !callout.responder CanSee( threat ) && RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout_negative" ] )
{
modifier = "neg";
}
callout.responder addResponseEvent( "callout", modifier, respondTo, 0.9 );
}
getThreatInfantryCalloutType( threat )
{
location = threat GetLocation();
selfClockDirection = getDirectionFacingClock( self.angles, self.origin, threat.origin );
responder = self getResponder( 64, 1024, "response" );
responderClockDirection = undefined;
if ( IsDefined( responder ) )
{
responderClockDirection = getDirectionFacingClock( responder.angles, responder.origin, threat.origin );
}
playerClockDirection = getDirectionFacingClock( level.player.angles, level.player.origin, threat.origin );
if ( self.team == "allies" )
{
clockDirectionToUse = playerClockDirection;
relativeGuy = level.player;
}
else if ( IsDefined( responder ) )
{
clockDirectionToUse = responderClockDirection;
relativeGuy = responder;
}
else
{
clockDirectionToUse = selfClockDirection;
relativeGuy = self;
}
distanceYards = getDistanceYards( relativeGuy.origin, threat.origin );
self.possibleThreatCallouts = [];
if ( !IsPlayer( threat ) && threat usingRocketLauncher() )
{
self addPossibleThreatCallout( "rpg" );
}
if ( threat IsExposed() )
{
self addPossibleThreatCallout( "exposed" );
}
if ( self.team == "allies" )
{
calloutHigh = false;
if ( threat.origin[2] - relativeGuy.origin[2] >= level.heightForHighCallout )
{
if ( addPossibleThreatCallout( "player_target_clock_high" ) )
calloutHigh = true;
}
if ( !calloutHigh )
{
if ( clockDirectionToUse == "12" )
{
self addPossibleThreatCallout( "player_obvious" );
if ( distanceYards > level.minDistanceCallout && distanceYards < level.maxDistanceCallout )
self addPossibleThreatCallout( "player_distance" );
}
if ( self canSayPlayerName() && clockDirectionToUse != "12" )
{
self addPossibleThreatCallout( "player_contact_clock" );
self addPossibleThreatCallout( "player_target_clock" );
self addPossibleThreatCallout( "player_cardinal" );
}
}
}
calloutHigh = false;
if ( threat.origin[2] - relativeGuy.origin[2] >= level.heightForHighCallout )
{
if ( addPossibleThreatCallout( "ai_target_clock_high" ) )
calloutHigh = true;
}
if ( !calloutHigh )
{
if ( clockDirectionToUse == "12" )
{
self addPossibleThreatCallout( "ai_distance" );
if ( distanceYards > level.minDistanceCallout && distanceYards < level.maxDistanceCallout )
self addPossibleThreatCallout( "ai_obvious" );
}
self addPossibleThreatCallout( "ai_contact_clock" );
self addPossibleThreatCallout( "ai_target_clock" );
self addPossibleThreatCallout( "ai_cardinal" );
}
if ( IsDefined( location ) )
{
cannedResponse = location GetCannedResponse( self );
if ( IsDefined( cannedResponse ) )
{
if ( IsDefined( responder ) )
{
self addPossibleThreatCallout( "ai_location" );
}
else
{
if ( self canSayPlayerName() )
{
self addPossibleThreatCallout( "player_location" );
}
self addPossibleThreatCallout( "generic_location" );
}
}
else
{
if ( IsDefined( responder ) )
{
self addPossibleThreatCallout( "ai_location" );
}
if ( self canSayPlayerName() )
{
self addPossibleThreatCallout( "player_location" );
}
self addPossibleThreatCallout( "generic_location" );
}
}
if ( !self.possibleThreatCallouts.size )
{
return undefined;
}
best = getWeightedChanceRoll( self.possibleThreatCallouts, anim.threatCallouts );
callout = SpawnStruct();
callout.type = best;
callout.responder = responder;
callout.responderClockDirection = responderClockDirection;
callout.playerClockDirection = playerClockDirection;
if ( IsDefined( location ) )
{
callout.location = location;
}
return callout;
}
GetCannedResponse( speaker )
{
cannedResponseAlias = undefined;
aliases = self.locationAliases;
foreach ( alias in aliases )
{
if ( IsCalloutTypeQA( alias, speaker ) && !IsDefined( self.qaFinished ) )
{
cannedResponseAlias = alias;
break;
}
if ( IsCalloutTypeReport( alias ) )
{
cannedResponseAlias = alias;
}
}
return cannedResponseAlias;
}
IsCalloutTypeReport( alias )
{
return IsSubStr( alias, "_report" );
}
IsCalloutTypeQA( alias, speaker )
{
if ( IsSubStr( alias, "_qa" ) && SoundExists( alias ) )
{
return true;
}
tryQA = speaker GetQACalloutAlias( alias, 0 );
if ( SoundExists( tryQA ) )
{
return true;
}
return false;
}
GetQACalloutAlias( basealias, lineIndex )
{
alias = self.countryID + "_" + self.npcID + "_co_";
alias += basealias;
alias += "_qa" + lineIndex;
return alias;
}
addAllowedThreatCallout( threatType )
{
self.allowedCallouts[ self.allowedCallouts.size ] = threatType;
}
addPossibleThreatCallout( threatType )
{
allowed = false;
foreach ( calloutType in self.allowedCallouts )
{
if ( calloutType == threatType )
{
if ( !self calloutTypeWillRepeat( threatType ) )
{
allowed = true;
}
break;
}
}
if ( !allowed )
{
return allowed;
}
self.possibleThreatCallouts[ self.possibleThreatCallouts.size ] = threatType;
return allowed;
}
calloutTypeWillRepeat( threatType )
{
if ( !IsDefined( anim.lastTeamThreatCallout[ self.team ] ) )
{
return false;
}
if ( !IsDefined( anim.lastTeamThreatCalloutTime[ self.team ] ) )
{
return false;
}
lastThreat = anim.lastTeamThreatCallout[ self.team ];
lastCalloutTime = anim.lastTeamThreatCalloutTime[ self.team ];
timeout = anim.teamThreatCalloutLimitTimeout;
if ( ( threatType == lastThreat ) && ( GetTime() - lastCalloutTime < timeout ) )
{
return true;
}
return false;
}
setLastCalloutType( type )
{
anim.lastTeamThreatCallout[ self.team ] = type;
anim.lastTeamThreatCalloutTime[ self.team ] = GetTime();
}
getWeightedChanceRoll( possibleValues, chancesForValues )
{
best = undefined;
bestRoll = -1;
foreach ( value in possibleValues )
{
if ( chancesForValues[ value ] <= 0 )
{
continue;
}
thisRoll = RandomInt( chancesForValues[ value ] );
if ( IsDefined( best ) && ( chancesForValues[ best ] >= 100 ) )
{
if ( chancesForValues[ value ] < 100 )
{
continue;
}
}
else if ( ( chancesForValues[ value ] >= 100 ) )
{
best = value;
bestRoll = thisRoll;
}
else if ( thisRoll > bestRoll )
{
best = value;
bestRoll = thisRoll;
}
}
return best;
}
threatDog( threat, forceDetail )
{
self endon( "cancel speaking" );
chatPhrase = self createChatPhrase();
chatPhrase.master = true;
chatPhrase.threatEnt = threat;
chatPhrase addThreatAlias( "dog", "generic" );
self playPhrase( chatPhrase );
return true;
}
threatInfantryExposed( threat )
{
exposedVariants = [];
exposedVariants = array_add( exposedVariants, "open" );
exposedVariants = array_add( exposedVariants, "breaking" );
if ( self.owner.team == "allies" && self.owner.countryID != "RU" )
{
exposedVariants = array_add( exposedVariants, "movement" );
}
exposedVariant = exposedVariants[ RandomInt( exposedVariants.size ) ];
self addThreatExposedAlias( exposedVariant );
}
threatInfantryRPG( threat )
{
self addThreatAlias( "rpg" );
}
playReactionEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
self.curEvent = self.chatQueue[ "reaction" ];
reactTo = self.chatQueue[ "reaction" ].reactTo;
modifier = self.chatQueue[ "reaction" ].modifier;
anim thread lockAction( self, "reaction" );
switch( self.chatQueue[ "reaction" ].eventType )
{
case "casualty":
self reactionCasualty( reactTo, modifier );
break;
case "taunt":
self reactionTaunt( reactTo, modifier );
break;
case "friendlyfire":
self reactionFriendlyFire( reactTo, modifier );
break;
}
self notify( "done speaking" );
}
reactionCasualty( reactTo, modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
chatPhrase addReactionAlias( "casualty", "generic" );
self playPhrase( chatPhrase );
}
reactionTaunt( reactTo, modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
if ( IsDefined( modifier ) && modifier == "hostileburst" )
{
chatPhrase addHostileBurstAlias();
}
else
{
chatPhrase addTauntAlias( "taunt", "generic" );
}
self playPhrase( chatPhrase );
}
reactionFriendlyFire( reactTo, modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
chatPhrase addCheckFireAlias();
self playPhrase( chatPhrase );
}
playResponseEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
self.curEvent = self.chatQueue[ "response" ];
modifier = self.chatQueue[ "response" ].modifier;
respondTo = self.chatQueue[ "response" ].respondTo;
if ( !IsAlive( respondTo ) )
{
return;
}
if ( self.chatQueue[ "response" ].modifier == "follow" && self.a.state != "move" )
{
return;
}
anim thread lockAction( self, "response" );
switch( self.chatQueue[ "response" ].eventType )
{
case "exposed":
self responseThreatExposed( respondTo, modifier );
break;
case "callout":
self responseThreatCallout( respondTo, modifier );
break;
case "ack":
self responseGeneric( respondTo, modifier );
break;
}
self notify( "done speaking" );
}
responseThreatExposed( respondTo, modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !IsAlive( respondTo ) )
{
return;
}
chatPhrase = self createChatPhrase();
chatPhrase addThreatExposedAlias( modifier );
chatPhrase.lookTarget = respondTo;
chatPhrase.master = true;
self playPhrase( chatPhrase );
}
responseThreatCallout( respondTo, modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !IsAlive( respondTo ) )
{
return;
}
chatPhrase = self createChatPhrase();
success = false;
if ( modifier == "echo" )
{
success = chatPhrase addThreatCalloutEcho( self.curEvent.reportAlias, respondTo );
}
else if ( modifier == "QA" )
{
success = chatPhrase addThreatCalloutQA_NextLine( respondTo, self.curEvent.reportAlias, self.curEvent.location );
}
else
{
success = chatPhrase addThreatCalloutResponseAlias( modifier );
}
if ( !success )
{
return;
}
chatPhrase.lookTarget = respondTo;
chatPhrase.master = true;
self playPhrase( chatPhrase );
}
responseGeneric( respondTo, modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( !IsAlive( respondTo ) )
{
return;
}
type = self.chatQueue[ "response" ].eventType;
chatPhrase = self createChatPhrase();
chatPhrase addResponseAlias( type, modifier );
chatPhrase.lookTarget = respondTo;
chatPhrase.master = true;
self playPhrase( chatPhrase );
}
playOrderEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
self.curEvent = self.chatQueue[ "order" ];
modifier = self.chatQueue[ "order" ].modifier;
orderTo = self.chatQueue[ "order" ].orderTo;
anim thread lockAction( self, "order" );
switch( self.chatQueue[ "order" ].eventType )
{
case "action":
self orderAction( modifier, orderTo );
break;
case "move":
self orderMove( modifier, orderTo );
break;
case "displace":
self orderDisplace( modifier );
break;
}
self notify( "done speaking" );
}
orderAction( modifier, orderTo )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
self tryOrderTo( chatPhrase, orderTo );
chatPhrase addOrderAlias( "action", modifier );
self playPhrase( chatPhrase );
}
orderMove( modifier, orderTo )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
self tryOrderTo( chatPhrase, orderTo );
chatPhrase addOrderAlias( "move", modifier );
self playPhrase( chatPhrase );
}
orderDisplace( modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
chatPhrase addOrderAlias( "displace", modifier );
self playPhrase( chatPhrase, true );
}
tryOrderTo( chatPhrase, orderTo )
{
if ( RandomInt( 100 ) > anim.eventChance[ "response" ][ "order" ] )
{
if ( !IsDefined( orderTo ) || ( IsDefined( orderTo ) && !IsPlayer( orderTo ) ) )
{
return;
}
}
if ( IsDefined( orderTo ) && IsPlayer( orderTo ) && IsDefined( level.player.bcNameID ) )
{
chatPhrase addPlayerNameAlias();
chatPhrase.lookTarget = level.player;
}
else if ( IsDefined( orderTo ) && self canSayName( orderTo ) )
{
chatPhrase addNameAlias( orderTo.bcName );
chatPhrase.lookTarget = orderTo;
orderTo addResponseEvent( "ack", "yes", self, 0.9 );
}
else
{
level notify( "follow order", self );
}
}
playInformEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
self.curEvent = self.chatQueue[ "inform" ];
modifier = self.chatQueue[ "inform" ].modifier;
anim thread lockAction( self, "inform" );
switch( self.chatQueue[ "inform" ].eventType )
{
case "incoming":
self informIncoming( modifier );
break;
case "attack":
self informAttacking( modifier );
break;
case "reloading":
self informReloading( modifier );
break;
case "suppressed":
self informSuppressed( modifier );
break;
case "killfirm":
self informKillfirm( modifier );
break;
}
self notify( "done speaking" );
}
informReloading( modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
chatPhrase addInformAlias( "reloading", modifier );
self playPhrase( chatPhrase );
}
informSuppressed( modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
chatPhrase addInformAlias( "suppressed", modifier );
self playPhrase( chatPhrase );
}
informIncoming( modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
if ( modifier == "grenade" )
chatPhrase.master = true;
chatPhrase addInformAlias( "incoming", modifier );
self playPhrase( chatPhrase );
}
informAttacking( modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
chatPhrase addInformAlias( "attack", modifier );
self playPhrase( chatPhrase );
}
informKillfirm( modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
chatPhrase = self createChatPhrase();
chatPhrase addInformAlias( "killfirm", modifier );
self playPhrase( chatPhrase );
}
playCustomEvent()
{
self endon( "death" );
self endon( "removed from battleChatter" );
self.curEvent = self.chatQueue[ "custom" ];
anim thread lockAction( self, self.curEvent.type, true );
self playPhrase( self.customChatPhrase );
self notify( "done speaking" );
self.customChatEvent = undefined;
self.customChatPhrase = undefined;
}
playPhrase( chatPhrase, noSound )
{
anim endon( "battlechatter disabled" );
self endon( "death" );
if ( IsDefined( noSound ) )
{
return;
}
if ( self battleChatter_canPrint() || self battleChatter_canPrintDump() )
{
bcAliases = [];
foreach ( alias in chatPhrase.soundAliases )
{
bcAliases[ bcAliases.size ] = alias;
}
if ( self battleChatter_canPrint() )
{
self battleChatter_print( bcAliases );
}
if ( self battleChatter_canPrintDump() )
{
bcDescriptor = self.curEvent.eventAction + "_" + self.curEvent.eventType;
if ( IsDefined( self.curEvent.modifier ) )
{
bcDescriptor += ( "_" + self.curEvent.modifier );
}
self thread battleChatter_printDump( bcAliases, bcDescriptor );
}
}
for ( i = 0; i < chatPhrase.soundAliases.size; i++ )
{
if ( !self.battleChatter )
{
if ( !is_friendlyfire_event( self.curEvent ) )
{
continue;
}
else if ( !self can_say_friendlyfire( false ) )
{
continue;
}
}
if ( self._animActive > 0 )
{
continue;
}
if ( isFiltered( self.curEvent.eventAction ) )
{
wait( 0.85 );
continue;
}
if ( !SoundExists( chatPhrase.soundAliases[ i ] ) )
{
continue;
}
startTime = GetTime();
soundOrg = Spawn( "script_origin", self GetTagOrigin( "j_head" ) );
soundOrg LinkTo( self );
if ( chatPhrase.master && self.team == "allies" )
{
self thread maps\_anim::anim_facialFiller( chatPhrase.soundAliases[ i ], chatPhrase.lookTarget );
soundOrg PlaySoundAsMaster( chatPhrase.soundAliases[ i ], chatPhrase.soundAliases[ i ], true );
soundOrg waittill( chatPhrase.soundAliases[ i ] );
self notify( chatPhrase.soundAliases[ i ] );
}
else
{
self thread maps\_anim::anim_facialFiller( chatPhrase.soundAliases[ i ], chatPhrase.lookTarget );
if ( GetDvarInt( "bcs_forceEnglish", 0 ) )
{
soundOrg PlaySoundAsMaster( chatPhrase.soundAliases[ i ], chatPhrase.soundAliases[ i ], true );
}
else
{
soundOrg PlaySound( chatPhrase.soundAliases[ i ], chatPhrase.soundAliases[ i ], true );
}
soundOrg waittill( chatPhrase.soundAliases[ i ] );
self notify( chatPhrase.soundAliases[ i ] );
}
soundOrg Delete();
if ( GetTime() < startTime + 250 )
{
}
}
self notify( "playPhrase_done" );
self doTypeLimit( self.curEvent.eventAction, self.curEvent.eventType );
}
is_friendlyfire_event( curEvent )
{
if ( !IsDefined( curEvent.eventAction ) || !IsDefined( curEvent.eventType ) )
{
return false;
}
if ( curEvent.eventAction == "reaction" && curEvent.eventType == "friendlyfire" )
{
return true;
}
return false;
}
isSpeakingFailSafe( eventAction )
{
self endon( "death" );
wait( 25 );
self clearIsSpeaking( eventAction );
}
clearIsSpeaking( eventAction )
{
self.isSpeaking = false;
self.chatQueue[ eventAction ].expireTime = 0;
self.chatQueue[ eventAction ].priority = 0.0;
self.nextSayTimes[ eventAction ] = GetTime() + anim.eventActionMinWait[ eventAction ][ "self" ];
}
lockAction( speaker, eventAction, customEvent )
{
anim endon( "battlechatter disabled" );
Assert( !speaker.isSpeaking );
squad = speaker.squad;
team = speaker.team;
speaker.isSpeaking = true;
speaker thread isSpeakingFailSafe( eventAction );
squad.isMemberSaying[ eventAction ] = true;
squad.numSpeakers++;
anim.isTeamSpeaking[ team ] = true;
anim.isTeamSaying[ team ][ eventAction ] = true;
message = speaker waittill_any_return( "death", "done speaking", "cancel speaking" );
squad.isMemberSaying[ eventAction ] = false;
squad.numSpeakers--;
anim.isTeamSpeaking[ team ] = false;
anim.isTeamSaying[ team ][ eventAction ] = false;
if ( message == "cancel speaking" )
{
return;
}
anim.lastTeamSpeakTime[ team ] = GetTime();
if ( IsAlive( speaker ) )
{
speaker clearIsSpeaking( eventAction );
}
squad.nextSayTimes[ eventAction ] = GetTime() + anim.eventActionMinWait[ eventAction ][ "squad" ];
}
updateContact( squadName, member )
{
if ( GetTime() - self.squadList[ squadName ].lastContact > 10000 )
{
isInContact = false;
for ( i = 0; i < self.members.size; i++ )
{
if ( self.members[ i ] != member && IsAlive( self.members[ i ].enemy ) && IsDefined( self.members[ i ].enemy.squad ) && self.members[ i ].enemy.squad.squadName == squadName )
isInContact = true;
}
if ( !isInContact )
{
self.squadList[ squadName ].firstContact = GetTime();
self.squadList[ squadName ].calledOut = false;
}
}
self.squadList[ squadName ].lastContact = GetTime();
}
canSay( eventAction, eventType, priority, modifier )
{
self endon( "death" );
self endon( "removed from battleChatter" );
if ( IsPlayer( self ) )
{
return false;
}
if ( Distance( level.player.origin, self.origin ) > level.bcs_maxTalkingDistFromPlayer )
{
return false;
}
if ( !IsDefined( self.battlechatter ) || !self.battlechatter )
return( false );
if ( IsDefined( priority ) && priority >= 1 )
return( true );
if ( ( GetTime() + anim.eventActionMinWait[ eventAction ][ "self" ] ) < self.nextSayTimes[ eventAction ] )
return( false );
if ( ( GetTime() + anim.eventActionMinWait[ eventAction ][ "squad" ] ) < self.squad.nextSayTimes[ eventAction ] )
return( false );
if ( IsDefined( eventType ) && typeLimited( eventAction, eventType ) )
return( false );
if ( IsDefined( eventType ) && anim.eventPriority[ eventAction ][ eventType ] < self.bcs_minPriority )
return( false );
return( true );
}
getHighestPriorityEvent()
{
prof_begin("getHighestPriorityEvent");
best = undefined;
bestpriority = -999999999;
foreach( type, chatQueueEntry in self.chatQueue )
{
if ( self isValidEvent( type ) )
{
if ( chatQueueEntry.priority > bestpriority )
{
best = type;
bestpriority = chatQueueEntry.priority;
}
}
}
prof_end("getHighestPriorityEvent");
return best;
}
getTargettingAI( threat )
{
squad = self.squad;
targettingAI = [];
for ( index = 0; index < squad.members.size; index++ )
{
if ( IsDefined( squad.members[ index ].enemy ) && squad.members[ index ].enemy == threat )
targettingAI[ targettingAI.size ] = squad.members[ index ];
}
if ( !IsDefined( targettingAI[ 0 ] ) )
return( undefined );
targettingSpeaker = undefined;
for ( index = 0; index < targettingAI.size; index++ )
{
if ( targettingAI[ index ] canSay( "response" ) )
return( targettingSpeaker );
}
return( getClosest( self.origin, targettingAI ) );
}
getQueueEvents()
{
prof_begin("getQueueEvents");
queueEvents = [];
queueEventStates = [];
queueEvents[ 0 ] = "custom";
queueEvents[ 1 ] = "response";
queueEvents[ 2 ] = "order";
queueEvents[ 3 ] = "threat";
queueEvents[ 4 ] = "inform";
for ( i = queueEvents.size - 1; i >= 0; i-- )
{
for ( j = 1; j <= i; j++ )
{
if ( self.chatQueue[ queueEvents[ j - 1 ] ].priority < self.chatQueue[ queueEvents[ j ] ].priority )
{
strTemp = queueEvents[ j - 1 ];
queueEvents[ j - 1 ] = queueEvents[ j ];
queueEvents[ j ] = strTemp;
}
}
}
validEventFound = false;
for ( i = 0; i < queueEvents.size; i++ )
{
eventState = self getEventState( queueEvents[ i ] );
if ( eventState == " valid" && !validEventFound )
{
validEventFound = true;
queueEventStates[ i ] = "g " + queueEvents[ i ] + eventState + " " + self.chatQueue[ queueEvents[ i ] ].priority;
}
else if ( eventState == " valid" )
{
queueEventStates[ i ] = "y " + queueEvents[ i ] + eventState + " " + self.chatQueue[ queueEvents[ i ] ].priority;
}
else
{
if ( self.chatQueue[ queueEvents[ i ] ].expireTime == 0 )
queueEventStates[ i ] = "b " + queueEvents[ i ] + eventState + " " + self.chatQueue[ queueEvents[ i ] ].priority;
else
queueEventStates[ i ] = "r " + queueEvents[ i ] + eventState + " " + self.chatQueue[ queueEvents[ i ] ].priority;
}
}
prof_end("getQueueEvents");
return queueEventStates;
}
getEventState( strAction )
{
strState = "";
if ( self.squad.isMemberSaying[ strAction ] )
strState += " playing";
if ( GetTime() > self.chatQueue[ strAction ].expireTime )
strState += " expired";
if ( GetTime() < self.squad.nextSayTimes[ strAction ] )
strState += " cantspeak";
if ( strState == "" )
strState = " valid";
return( strState );
}
isFiltered( strAction )
{
if ( GetDvar( "bcs_filter" + strAction, "off" ) == "on" || GetDvar( "bcs_filter" + strAction, "off" ) == "1" )
return( true );
return( false );
}
isValidEvent( strAction )
{
time = gettime();
if ( !self.squad.isMemberSaying[ strAction ] &&
!anim.isTeamSaying[ self.team ][ strAction ] &&
time < self.chatQueue[ strAction ].expireTime &&
time > self.squad.nextSayTimes[ strAction ] )
{
if ( !typeLimited( strAction, self.chatQueue[ strAction ].eventType ) )
return( true );
}
return( false );
}
typeLimited( strAction, strType )
{
if ( !IsDefined( anim.eventTypeMinWait[ strAction ][ strType ] ) )
return( false );
if ( !IsDefined( self.squad.nextTypeSayTimes[ strAction ][ strType ] ) )
return( false );
if ( GetTime() > self.squad.nextTypeSayTimes[ strAction ][ strType ] )
return( false );
return( true );
}
doTypeLimit( strAction, strType )
{
if ( !IsDefined( anim.eventTypeMinWait[ strAction ][ strType ] ) )
return;
self.squad.nextTypeSayTimes[ strAction ][ strType ] = GetTime() + anim.eventTypeMinWait[ strAction ][ strType ];
}
bcIsSniper()
{
if ( IsPlayer( self ) )
return false;
if ( self isExposed() )
return false;
return IsSniperRifle( self.weapon );
}
isExposed()
{
if ( Distance( self.origin, level.player.origin ) > 1500 )
{
return false;
}
if ( IsDefined( self GetLocation() ) )
{
return false;
}
node = self bcGetClaimedNode();
if ( !IsDefined( node ) )
{
return true;
}
if ( !self isNodeCoverOrConceal() )
{
return false;
}
return true;
}
isNodeCoverOrConceal()
{
node = self.node;
if ( !IsDefined( node ) )
{
return false;
}
if ( IsSubStr( node.type, "Cover" ) || IsSubStr( node.type, "Conceal" ) )
{
return true;
}
return false;
}
squadHasOfficer( squad )
{
if ( squad.officerCount > 0 )
{
return true;
}
else
{
return false;
}
}
isOfficer()
{
fullRank = self getRank();
if ( !IsDefined( fullRank ) )
return false;
if ( fullRank == "sergeant"
|| fullRank == "lieutenant"
|| fullRank == "captain"
|| fullRank == "sergeant" )
{
return true;
}
return false;
}
bcGetClaimedNode()
{
if ( IsPlayer( self ) )
return self.node;
else
return self GetClaimedNode();
}
enemy_team_name()
{
if ( self IsBadGuy() )
return true;
else
return false;
}
getName()
{
if ( enemy_team_name() )
{
name = self.ainame;
}
else if ( self.team == "allies" )
{
name = self.name;
}
else
{
name = undefined;
}
if ( !IsDefined( name ) )
{
return( undefined );
}
tokens = StrTok( name, " " );
if ( tokens.size < 2 )
{
return( name );
}
Assert( tokens.size > 1 );
return( tokens[ 1 ] );
}
getRank()
{
return self.airank;
}
getClosestFriendlySpeaker( strAction )
{
speakers = self getSpeakers( strAction, self.team );
speaker = getClosest( self.origin, speakers );
return( speaker );
}
getSpeakers( strAction, team )
{
speakers = [];
soldiers = GetAIArray( team );
for ( i = 0; i < soldiers.size; i++ )
{
if ( soldiers[ i ] == self )
{
continue;
}
if ( !soldiers[ i ] canSay( strAction ) )
{
continue;
}
speakers[ speakers.size ] = soldiers[ i ];
}
return( speakers );
}
getResponder( distMin, distMax, eventType )
{
responder = undefined;
if ( !IsDefined( eventType ) )
{
eventType = "response";
}
soldiers = array_randomize( self.squad.members );
distMin *= distMin;
distMax *= distMax;
for ( i = 0; i < soldiers.size; i++ )
{
if ( soldiers[ i ] == self )
{
continue;
}
if ( !IsAlive( soldiers[ i ] ) )
{
continue;
}
dist_sqrd = DistanceSquared( self.origin, soldiers[ i ].origin );
if ( dist_sqrd < distMin )
{
continue;
}
if ( dist_sqrd > distMax )
{
continue;
}
if ( self isUsingSameVoice( soldiers[ i ] ) )
{
continue;
}
if ( !soldiers[ i ] canSay( eventType ) )
{
continue;
}
responder = soldiers[ i ];
if ( self canSayName( responder ) )
{
break;
}
}
return responder;
}
getLocation()
{
myLocations = self get_all_my_locations();
myLocations = array_randomize( myLocations );
if ( myLocations.size )
{
foreach ( location in myLocations )
{
if ( !location_called_out_ever( location ) )
{
return location;
}
}
foreach ( location in myLocations )
{
if ( !location_called_out_recently( location ) )
{
return location;
}
}
}
return undefined;
}
get_all_my_locations()
{
allLocations = anim.bcs_locations;
myLocations = [];
foreach ( location in allLocations )
{
if ( self IsTouching( location ) && IsDefined( location.locationAliases ) )
{
myLocations[ myLocations.size ] = location;
}
}
return myLocations;
}
update_bcs_locations()
{
if ( IsDefined( anim.bcs_locations ) )
{
anim.bcs_locations = array_removeUndefined( anim.bcs_locations );
}
}
is_in_callable_location()
{
myLocations = self get_all_my_locations();
foreach ( location in myLocations )
{
if ( !location_called_out_recently( location ) )
{
return true;
}
}
return false;
}
location_called_out_ever( location )
{
lastCalloutTime = location_get_last_callout_time( location );
if ( !IsDefined( lastCalloutTime ) )
{
return false;
}
return true;
}
location_called_out_recently( location )
{
lastCalloutTime = location_get_last_callout_time( location );
if ( !IsDefined( lastCalloutTime ) )
{
return false;
}
nextCalloutTime = lastCalloutTime + anim.eventActionMinWait[ "threat" ][ "location_repeat" ];
if ( GetTime() < nextCalloutTime )
{
return true;
}
return false;
}
location_add_last_callout_time( location )
{
anim.locationLastCalloutTimes[ location.classname ] = GetTime();
}
location_get_last_callout_time( location )
{
if ( IsDefined( anim.locationLastCalloutTimes[ location.classname ] ) )
{
return anim.locationLastCalloutTimes[ location.classname ];
}
return undefined;
}
getRelativeAngles( ent )
{
Assert( IsDefined( ent ) );
angles = ent.angles;
if ( !IsPlayer( ent ) )
{
node = ent bcGetClaimedNode();
if ( IsDefined( node ) )
{
angles = node.angles;
}
}
return angles;
}
sideIsLeftRight( side )
{
if ( side == "left" || side == "right" )
{
return true;
}
return false;
}
getDirectionFacingFlank( vOrigin, vPoint, vFacing )
{
anglesToFacing = VectorToAngles( vFacing );
anglesToPoint = VectorToAngles( vPoint - vOrigin );
angle = anglesToFacing[ 1 ] - anglesToPoint[ 1 ];
angle += 360;
angle = Int( angle ) % 360;
if ( angle > 315 || angle < 45 )
direction = "front";
else if ( angle < 135 )
direction = "right";
else if ( angle < 225 )
direction = "rear";
else
direction = "left";
return( direction );
}
normalizeCompassDirection( direction )
{
Assert( IsDefined( direction ) );
new = undefined;
switch( direction )
{
case "north":
new = "n";
break;
case "northwest":
new = "nw";
break;
case "west":
new = "w";
break;
case "southwest":
new = "sw";
break;
case "south":
new = "s";
break;
case "southeast":
new = "se";
break;
case "east":
new = "e";
break;
case "northeast":
new = "ne";
break;
case "impossible":
new = "impossible";
break;
default:
AssertMsg( "Can't normalize compass direction " + direction );
return;
}
Assert( IsDefined( new ) );
return new;
}
getDirectionCompass( vOrigin, vPoint )
{
angles = VectorToAngles( vPoint - vOrigin );
angle = angles[ 1 ];
northYaw = GetNorthYaw();
angle -= northYaw;
if ( angle < 0 )
angle += 360;
else if ( angle > 360 )
angle -= 360;
if ( angle < 22.5 || angle > 337.5 )
direction = "north";
else if ( angle < 67.5 )
direction = "northwest";
else if ( angle < 112.5 )
direction = "west";
else if ( angle < 157.5 )
direction = "southwest";
else if ( angle < 202.5 )
direction = "south";
else if ( angle < 247.5 )
direction = "southeast";
else if ( angle < 292.5 )
direction = "east";
else if ( angle < 337.5 )
direction = "northeast";
else
direction = "impossible";
return( direction );
}
getDistanceYards( source, target )
{
distanceInches = Distance2D( source, target );
distanceYards = 0.0254 * distanceInches;
return distanceYards;
}
getDistanceYardsNormalized( source, target )
{
distanceYards = getDistanceYards( source, target );
if ( distanceYards < 15.0 )
return "10";
else if ( distanceYards < 25.0 )
return "20";
else if ( distanceYards < 35.0 )
return "30";
else
return "40";
}
getFrontArcClockDirection( direction )
{
AssertEx( IsDefined( direction ) );
faDirection = "undefined";
if ( direction == "10" || direction == "11" )
{
faDirection = "10";
}
else if ( direction == "12" )
{
faDirection = direction;
}
else if ( direction == "1" || direction == "2" )
{
faDirection = "2";
}
return faDirection;
}
getDirectionFacingClock( viewerAngles, viewerOrigin, targetOrigin )
{
forward = AnglesToForward( viewerAngles );
vFacing = VectorNormalize( forward );
anglesToFacing = VectorToAngles( vFacing );
anglesToPoint = VectorToAngles( targetOrigin - viewerOrigin );
angle = anglesToFacing[ 1 ] - anglesToPoint[ 1 ];
angle += 360;
angle = Int( angle ) % 360;
if ( angle > 345 || angle < 15 )
{
direction = "12";
}
else if ( angle < 45 )
{
direction = "1";
}
else if ( angle < 75 )
{
direction = "2";
}
else if ( angle < 105 )
{
direction = "3";
}
else if ( angle < 135 )
{
direction = "4";
}
else if ( angle < 165 )
{
direction = "5";
}
else if ( angle < 195 )
{
direction = "6";
}
else if ( angle < 225 )
{
direction = "7";
}
else if ( angle < 255 )
{
direction = "8";
}
else if ( angle < 285 )
{
direction = "9";
}
else if ( angle < 315 )
{
direction = "10";
}
else
{
direction = "11";
}
return( direction );
}
getDegreesElevation( viewerOrigin, targetOrigin )
{
ht = targetOrigin[2] - viewerOrigin[2];
dist = Distance2D( viewerOrigin, targetOrigin );
angle = ATan( ht/dist );
if ( angle < 15 || angle > 55 )
return angle;
else if ( angle < 25 )
return 20;
else if ( angle < 35 )
return 30;
else if ( angle < 45 )
return 40;
else if ( angle < 55 )
return 50;
}
getVectorRightAngle( vDir )
{
return( vDir[ 1 ], 0 - vDir[ 0 ], vDir[ 2 ] );
}
getVectorArrayAverage( avAngles )
{
vDominantDir = ( 0, 0, 0 );
for ( i = 0; i < avAngles.size; i++ )
vDominantDir += avAngles[ i ];
return( vDominantDir[ 0 ] / avAngles.size, vDominantDir[ 1 ] / avAngles.size, vDominantDir[ 2 ] / avAngles.size );
}
addNameAlias( name )
{
self.soundAliases[ self.soundAliases.size ] =
self.owner.countryID + "_" + self.owner.npcID + "_name_" + name;
anim.lastNameSaid[ self.owner.team ] = name;
anim.lastNameSaidTime[ self.owner.team ] = GetTime();
}
addPlayerNameAlias()
{
if ( !self.owner canSayPlayerName() )
{
return;
}
anim.lastPlayerNameCallTime = GetTime();
nameAlias = self.owner.countryID + "_" + self.owner.npcID + "_name_player_" + level.player.bcCountryID + "_" + level.player.bcNameID;
self.soundAliases[ self.soundAliases.size ] = nameAlias;
self.lookTarget = level.player;
}
addRankAlias( name )
{
self.soundAliases[ self.soundAliases.size ] = self.owner.countryID + "_" + self.owner.npcID + "_rank_" + name;
}
canSayName( ai )
{
if ( enemy_team_name() )
{
return false;
}
if ( !IsDefined( ai.bcName ) )
{
return false;
}
if ( ai.battlechatter == false )
{
return false;
}
if ( !IsDefined( ai.countryID ) )
{
return false;
}
if ( self.countryID != ai.countryID )
{
return false;
}
if ( self nameSaidRecently( ai ) )
{
return false;
}
nameAlias = self.countryID + "_" + self.npcID + "_name_" + ai.bcName;
if ( SoundExists( nameAlias ) )
{
return true;
}
return false;
}
nameSaidRecently( ai )
{
if ( ( anim.lastNameSaid[ self.team ] == ai.bcName ) || ( ( GetTime() - anim.lastNameSaidTime[ self.team ] ) < anim.lastNameSaidTimeout ) )
{
return true;
}
return false;
}
canSayPlayerName()
{
if ( enemy_team_name() )
{
return false;
}
if ( !IsDefined( level.player.bcNameID ) || !IsDefined( level.player.bcCountryID ) )
{
return false;
}
if ( player_name_called_recently() )
{
return false;
}
nameAlias = self.countryID + "_" + self.npcID + "_name_player_" + level.player.bcCountryID + "_" + level.player.bcNameID;
if ( SoundExists( nameAlias ) )
{
return true;
}
return false;
}
player_name_called_recently()
{
if ( !IsDefined( anim.lastPlayerNameCallTime ) )
{
return false;
}
if ( GetTime() - anim.lastPlayerNameCallTime >= anim.eventTypeMinWait[ "playername" ] )
{
return false;
}
return true;
}
isUsingSameVoice( otherguy )
{
if ( ( IsString( self.npcID ) && IsString( otherguy.npcID ) ) && ( self.npcID == otherguy.npcID ) )
{
return true;
}
else if ( ( !isString( self.npcID ) && !isString( otherguy.npcID ) ) && ( self.npcID == otherguy.npcID ) )
{
return true;
}
else
{
return false;
}
}
addThreatAlias( type, modifier )
{
Assert( IsDefined( type ) );
threat = self.owner.countryID + "_" + self.owner.npcID + "_threat_" + type;
if ( IsDefined( modifier ) )
{
threat += ( "_" + modifier );
}
self.soundAliases = array_add( self.soundAliases, threat );
return true;
}
addThreatExposedAlias( type )
{
Assert( IsDefined( type ) );
alias = self.owner.countryID + "_" + self.owner.npcID + "_exposed_" + type;
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatObviousAlias()
{
alias = self.owner.countryID + "_" + self.owner.npcID + "_order_action_suppress";
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatDistanceAlias( distance )
{
alias = self.owner.countryID + "_" + self.owner.npcID + "_co_dist_" + distance;
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatElevationAlias( angle )
{
alias = self.owner.countryID + "_" + self.owner.npcID + "_co_elev_" + angle;
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatCalloutEcho( reportAlias, respondTo )
{
Assert( IsDefined( reportAlias ) );
alias = self createEchoAlias( reportAlias, respondTo );
if ( !SoundExists( alias ) )
{
return false;
}
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatCalloutResponseAlias( modifier )
{
Assert( IsDefined( modifier ) );
alias = self.owner.countryID + "_" + self.owner.npcID + "_resp_ack_co_gnrc_" + modifier;
if ( !SoundExists( alias ) )
{
return false;
}
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatCalloutQA_NextLine( respondTo, prevLine, location )
{
Assert( IsDefined( respondTo ) && IsDefined( prevLine ) );
partialAlias = undefined;
foreach ( str in location.locationAliases )
{
if ( IsSubStr( prevLine, str ) )
{
partialAlias = str;
break;
}
}
Assert( IsDefined( partialAlias ) );
prefix = self.owner.countryID + "_" + self.owner.npcID + "_co_";
lastChar = GetSubStr( prevLine, prevLine.size - 1, prevLine.size );
Assert( string_is_single_digit_integer( lastChar ) );
nextIndex = Int( lastChar ) + 1;
qaAlias = prefix + partialAlias + "_qa" + nextIndex;
if ( !SoundExists( qaAlias ) )
{
if ( RandomInt( 100 ) < anim.eventChance[ "response" ][ "callout_negative" ] )
{
respondTo addResponseEvent( "callout", "neg", self.owner, 0.9 );
}
else
{
respondTo addResponseEvent( "exposed", "acquired", self.owner, 0.9 );
}
location.qaFinished = true;
return false;
}
respondTo addResponseEvent( "callout", "QA", self.owner, 0.9, qaAlias, location );
self.soundAliases[ self.soundAliases.size ] = qaAlias;
return true;
}
createEchoAlias( reportAlias, respondTo )
{
reportSuffix = "_report";
echoSuffix = "_echo";
echoPrefix = self.owner.countryID + "_" + self.owner.npcID + "_";
AssertEx( IsSubStr( reportAlias, reportSuffix ), "reportAlias doesn't have substring '" + reportSuffix + "', so it doesn't look like an eligible report alias." );
reportSuffixStartIndex = reportAlias.size - reportSuffix.size;
oldPrefix = self.owner.countryID + "_" + respondTo.npcID + "_";
oldPrefixLength = oldPrefix.size;
baseAlias = GetSubStr( reportAlias, oldPrefixLength, reportSuffixStartIndex );
echoAlias = echoPrefix + baseAlias + echoSuffix;
return echoAlias;
}
addThreatCalloutAlias( type, modifier )
{
Assert( IsDefined( type ) && IsDefined( modifier ) );
alias = self.owner.countryID + "_" + self.owner.npcID + "_callout_" + type + "_" + modifier;
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatCalloutLandmarkAlias( landmark, frontArcDirection, isRelative )
{
Assert( IsDefined( landmark ) && IsDefined( frontArcDirection ) );
landmarkStr = landmark.script_landmark;
if ( !IsDefined( isRelative ) )
{
isRelative = false;
}
alias = self.owner.countryID + "_" + self.owner.npcID + "_callout_obj_" + landmarkStr;
if ( isRelative )
{
alias += "_y";
}
alias += "_" + frontArcDirection;
if ( !SoundExists( alias ) )
{
return false;
}
self.soundAliases[ self.soundAliases.size ] = alias;
return true;
}
addThreatCalloutLocationAlias( location )
{
Assert( IsDefined( location ) && IsDefined( location.locationAliases ) );
finalAlias = undefined;
locationAliases = location.locationAliases;
Assert( locationAliases.size );
locAlias = locationAliases[ 0 ];
if ( locationAliases.size > 1 )
{
responseAlias = undefined;
responseAlias = location GetCannedResponse( self.owner );
if ( IsDefined( responseAlias ) )
{
locAlias = responseAlias;
}
else
{
locAlias = random( locationAliases );
}
}
alias = undefined;
if ( !IsDefined( location.qaFinished ) && IsCalloutTypeQA( locAlias, self.owner ) )
{
alias = self.owner GetQACalloutAlias( locAlias, 0 );
}
else
{
prefix = self.owner.countryID + "_" + self.owner.npcID + "_";
if ( !IsSubStr( locAlias, "callout" ) )
{
prefix += "co_";
}
alias = prefix + locAlias;
}
if ( SoundExists( alias ) )
{
finalAlias = alias;
}
if ( !IsDefined( finalAlias ) )
{
return false;
}
location_add_last_callout_time( location );
self.soundAliases[ self.soundAliases.size ] = finalAlias;
return true;
}
addInformAlias( type, modifier )
{
Assert( IsDefined( type ) && IsDefined( modifier ) );
alias = self.owner.countryID + "_" + self.owner.npcID + "_inform_" + type + "_" + modifier;
self.soundAliases[ self.soundAliases.size ] = alias;
}
addResponseAlias( type, modifier )
{
Assert( IsDefined( type ) && IsDefined( modifier ) );
alias = self.owner.countryID + "_" + self.owner.npcID + "_response_" + type + "_" + modifier;
self.soundAliases[ self.soundAliases.size ] = alias;
return( true );
}
addReactionAlias( type, modifier )
{
Assert( IsDefined( type ) && IsDefined( modifier ) );
reaction = self.owner.countryID + "_" + self.owner.npcID + "_reaction_" + type + "_" + modifier;
self.soundAliases[ self.soundAliases.size ] = reaction;
return( true );
}
addCheckFireAlias()
{
reaction = self.owner.countryID + "_" + self.owner.npcID + "_check_fire";
self.soundAliases[ self.soundAliases.size ] = reaction;
return true;
}
addTauntAlias( type, modifier )
{
Assert( IsDefined( type ) && IsDefined( modifier ) );
reaction = self.owner.countryID + "_" + self.owner.npcID + "_taunt";
self.soundAliases[ self.soundAliases.size ] = reaction;
return( true );
}
addHostileBurstAlias()
{
burst = self.owner.countryID + "_" + self.owner.npcID + "_hostile_burst";
self.soundAliases[ self.soundAliases.size ] = burst;
return true;
}
addOrderAlias( type, modifier )
{
Assert( IsDefined( type ) && IsDefined( modifier ) );
order = self.owner.countryID + "_" + self.owner.npcID + "_order_" + type + "_" + modifier;
self.soundAliases[ self.soundAliases.size ] = order;
return true;
}
initContact( squadName )
{
if ( !IsDefined( self.squadList[ squadName ].calledOut ) )
self.squadList[ squadName ].calledOut = false;
if ( !IsDefined( self.squadList[ squadName ].firstContact ) )
self.squadList[ squadName ].firstContact = 2000000000;
if ( !IsDefined( self.squadList[ squadName ].lastContact ) )
self.squadList[ squadName ].lastContact = 0;
}
shutdownContact( squadName )
{
self.squadList[ squadName ].calledOut = undefined;
self.squadList[ squadName ].firstContact = undefined;
self.squadList[ squadName ].lastContact = undefined;
}
createChatEvent( eventAction, eventType, priority )
{
chatEvent = SpawnStruct();
chatEvent.owner = self;
chatEvent.eventType = eventType;
chatEvent.eventAction = eventAction;
if ( IsDefined( priority ) )
chatEvent.priority = priority;
else
chatEvent.priority = anim.eventPriority[ eventAction ][ eventType ];
chatEvent.expireTime = GetTime() + anim.eventDuration[ eventAction ][ eventType ];
return chatEvent;
}
createChatPhrase()
{
chatPhrase = SpawnStruct();
chatPhrase.owner = self;
chatPhrase.soundAliases = [];
chatPhrase.master = false;
return chatPhrase;
}
pointInFov( origin )
{
return within_fov( self.origin, self.angles, origin, 0.766 );
}
entInFrontArc( ent )
{
return within_fov( self.origin, self.angles, ent.origin, 0 );
}
squadFlavorBurstTransmissions()
{
anim endon( "battlechatter disabled" );
self endon( "squad_deleting" );
if ( self.team != "allies" )
{
if ( level.script != "af_caves" )
{
return;
}
}
while ( self.memberCount <= 0 )
{
wait( 0.5 );
}
burstingWasPaused = false;
while ( IsDefined( self ) )
{
if ( !squadCanBurst( self ) )
{
burstingWasPaused = true;
wait( 1 );
continue;
}
else if ( self.fbt_firstBurst )
{
if ( !burstingWasPaused )
{
wait( RandomFloat( anim.fbt_waitMin ) );
}
if ( burstingWasPaused )
{
burstingWasPaused = false;
}
self.fbt_firstBurst = false;
}
else
{
if ( !burstingWasPaused )
{
wait( RandomFloatRange( anim.fbt_waitMin, anim.fbt_waitMax ) );
}
if ( burstingWasPaused )
{
burstingWasPaused = false;
}
}
burster = getBurster( self );
if ( !IsDefined( burster ) )
{
continue;
}
nationality = burster.voice;
burstID = getFlavorBurstID( self, nationality );
aliases = getFlavorBurstAliases( nationality, burstID );
foreach ( i, alias in aliases )
{
if ( !burster canDoFlavorBurst() || Distance( level.player.origin, burster.origin ) > anim.fbt_desiredDistMax )
{
for ( j = 0; j < self.members.size; j++ )
{
burster = getBurster( self );
if ( !IsDefined( burster ) )
{
continue;
}
if ( burster.voice == nationality )
{
break;
}
}
if ( !IsDefined( burster ) || burster.voice != nationality )
{
break;
}
}
self thread playFlavorBurstLine( burster, alias );
self waittill( "burst_line_done" );
if ( i != ( aliases.size - 1 ) )
{
wait( RandomFloatRange( anim.fbt_lineBreakMin, anim.fbt_lineBreakMax ) );
}
}
}
}
squadCanBurst( squad )
{
foundOne = false;
foreach ( member in squad.members )
{
if ( member canDoFlavorBurst() )
{
foundOne = true;
break;
}
}
return foundOne;
}
canDoFlavorBurst()
{
canDo = false;
if ( !IsPlayer( self )
&& IsAlive( self )
&& self.classname != "actor_enemy_dog"
&& level.flavorbursts[ self.team ]
&& self voiceCanBurst()
&& self.flavorbursts )
{
canDo = true;
}
return canDo;
}
voiceCanBurst()
{
if ( IsDefined( anim.flavorburstVoices[ self.voice ] ) && anim.flavorburstVoices[ self.voice ] )
{
return true;
}
return false;
}
getBurster( squad )
{
burster = undefined;
squadMembers = get_array_of_farthest( level.player.origin, squad.members );
foreach ( guy in squadMembers )
{
if ( guy canDoFlavorBurst() )
{
burster = guy;
if ( !IsDefined( squad.fbt_lastBursterID ) )
{
break;
}
if ( IsDefined( squad.fbt_lastBursterID ) && squad.fbt_lastBursterID == burster.unique_id )
{
continue;
}
}
}
if ( IsDefined( burster ) )
{
squad.fbt_lastBursterID = burster.unique_id;
}
return burster;
}
getFlavorBurstID( squad, nationality )
{
bursts = array_randomize( anim.flavorbursts[ nationality ] );
if ( anim.flavorburstsUsed.size >= bursts.size )
{
anim.flavorburstsUsed = [];
}
burstID = undefined;
foreach ( burst in bursts )
{
burstID = burst;
if ( !flavorBurstWouldRepeat( burstID ) )
{
break;
}
}
anim.flavorburstsUsed[ anim.flavorburstsUsed.size ] = burstID;
return burstID;
}
flavorBurstWouldRepeat( burstID )
{
if ( !anim.flavorburstsUsed.size )
{
return false;
}
foundIt = false;
foreach ( usedBurst in anim.flavorburstsUsed )
{
if ( usedBurst == burstID )
{
foundIt = true;
break;
}
}
return foundIt;
}
getFlavorBurstAliases( nationality, burstID, startingLine )
{
if ( !IsDefined( startingLine ) )
{
startingLine = 1;
}
burstLine = startingLine;
aliases = [];
while ( 1 )
{
alias = "FB_" + anim.countryIDs[ nationality ] + "_" + burstID + "_" + burstLine;
burstLine++;
if ( SoundExists( alias ) )
{
aliases[ aliases.size ] = alias;
}
else
{
break;
}
}
return aliases;
}
playFlavorBurstLine( burster, alias )
{
anim endon( "battlechatter disabled" );
soundOrg = Spawn( "script_origin", burster GetTagOrigin( "j_head" ) );
soundOrg LinkTo( burster );
soundOrg PlaySound( alias, alias, true );
soundOrg waittill( alias );
soundOrg Delete();
if ( IsDefined( self ) )
self notify( "burst_line_done" );
}
flavorBurstLineDebug( burster, alias )
{
self endon( "burst_line_done" );
while ( 1 )
{
Print3d( burster GetTagOrigin( "j_spinelower" ), alias, ( 1, 1, 1 ), 1, 0.5 );
wait( 0.05 );
}
}
battleChatter_canPrint()
{
return( false );
}
battleChatter_canPrintDump()
{
return false;
}
battleChatter_print( aliases )
{
if ( aliases.size <= 0 )
{
AssertMsg( "battleChatter_print(): the aliases array is empty." );
return;
}
if ( !self battleChatter_canPrint() )
{
return;
}
colorPrefix = "^5 ";
if ( enemy_team_name() )
{
colorPrefix = "^6 ";
}
Print( colorPrefix );
foreach ( alias in aliases )
{
Print( alias );
}
PrintLn( "" );
}
battleChatter_printDump( aliases, descriptor )
{
}
getAliasTypeFromSoundalias( alias )
{
prefix = self.countryID + "_" + self.npcID + "_";
AssertEx( IsSubStr( alias, prefix ), "didn't find expected prefix info in alias '" + alias + "' with substr test of '" + prefix + "'." );
aliasType = GetSubStr( alias, prefix.size, alias.size );
return aliasType;
}
battleChatter_printDumpLine( file, str, controlFlag )
{
if ( flag( controlFlag ) )
{
flag_wait( controlFlag );
}
flag_set( controlFlag );
FPrintLn( file, str );
flag_clear( controlFlag );
}
bcDrawObjects()
{
for ( i = 0; i < anim.bcs_locations.size; i++ )
{
locationAliases = anim.bcs_locations[ i ].locationAliases;
if ( !IsDefined( locationAliases ) )
{
continue;
}
locationStr = "";
foreach ( alias in locationAliases )
{
locationStr += alias;
}
thread drawBCObject( "Location: " + locationStr, anim.bcs_locations[ i ] GetOrigin(), ( 0, 0, 8 ), ( 1, 1, 1 ) );
}
}
drawBCObject( string, origin, offset, color )
{
while ( true )
{
if ( Distance( level.player.origin, origin ) > 2048 )
{
wait( 0.1 );
continue;
}
Print3d( origin + offset, string, color, 1, 0.75 );
wait 0.05;
}
}
drawBCDirections( landmark, offset, color )
{
landmarkOrigin = landmark GetOrigin();
while ( true )
{
if ( Distance( level.player.origin, landmarkOrigin ) > 2048 )
{
wait( 0.1 );
continue;
}
compass = getDirectionCompass( level.player.origin, landmarkOrigin );
compass = normalizeCompassDirection( compass );
clock = getDirectionFacingClock( level.player.angles, level.player.origin, landmarkOrigin );
string = compass + ", " + clock + ":00";
Print3d( landmarkOrigin + offset, string, color, 1, 0.75 );
wait 0.05;
}
}
resetNextSayTimes( team, action )
{
soldiers = GetAIArray( team );
for ( index = 0; index < soldiers.size; index++ )
{
soldier = soldiers[ index ];
if ( !isAlive( soldier ) )
continue;
if ( !IsDefined( soldier.battlechatter ) )
continue;
soldier.nextSayTimes[ action ] = GetTime() + 350;
soldier.squad.nextSayTimes[ action ] = GetTime() + 350;
}
}
voice_is_british_based()
{
self endon( "death" );
if ( self.voice == "british" )
return true;
else
return false;
}
friendlyfire_warning()
{
if ( !self can_say_friendlyfire() )
{
return false;
}
self doTypeLimit( "reaction", "friendlyfire" );
self thread playReactionEvent();
return true;
}
can_say_friendlyfire( checkTypeLimit )
{
if ( IsDefined( self.friendlyfire_warnings_disable ) )
{
return false;
}
if ( !IsDefined( self.chatQueue ) )
{
return false;
}
if ( !IsDefined( self.chatQueue[ "reaction" ] ) || !IsDefined( self.chatQueue[ "reaction" ].eventType ) )
{
return false;
}
if ( self.chatQueue[ "reaction" ].eventType != "friendlyfire" )
{
return false;
}
if ( GetTime() > self.chatQueue[ "reaction" ].expireTime )
{
return false;
}
if ( !IsDefined( checkTypeLimit ) )
{
checkTypeLimit = true;
}
if ( checkTypeLimit )
{
if ( IsDefined( self.squad.nextTypeSayTimes[ "reaction" ][ "friendlyfire" ] ) )
{
if ( GetTime() < self.squad.nextTypeSayTimes[ "reaction" ][ "friendlyfire" ] )
{
return false;
}
}
}
return true;
}
