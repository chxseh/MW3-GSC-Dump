#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
init()
{
maps\_hud::init();
precacheString( &"RANK_PLAYER_WAS_PROMOTED_N" );
precacheString( &"RANK_PLAYER_WAS_PROMOTED" );
precacheString( &"RANK_PROMOTED" );
precacheString( &"RANK_ROMANI" );
precacheString( &"RANK_ROMANII" );
precacheString( &"RANK_ROMANIII" );
precachestring( &"SCRIPT_PLUS" );
precacheshader( "line_horizontal" );
precacheshader( "line_vertical" );
precacheshader( "gradient_fadein" );
precacheShader("white");
level.maxRank = int( tableLookup( "sp/rankTable.csv", 0, "maxrank", 1 ) );
level.maxXP = int( tableLookup( "sp/rankTable.csv", 0, level.maxRank, 7 ) );
rId = 0;
for ( rId = 0; rId <= level.maxRank; rId++ )
precacheShader( tableLookup( "sp/rankTable.csv", 0, rId, 6 ) );
rankId = 0;
rankName = tableLookup( "sp/ranktable.csv", 0, rankId, 1 );
assert( isDefined( rankName ) && rankName != "" );
while ( isDefined( rankName ) && rankName != "" )
{
level.rankTable[ rankId ][ 1 ] = tableLookup( "sp/ranktable.csv", 0, rankId, 1 );
level.rankTable[ rankId ][ 2 ] = tableLookup( "sp/ranktable.csv", 0, rankId, 2 );
level.rankTable[ rankId ][ 3 ] = tableLookup( "sp/ranktable.csv", 0, rankId, 3 );
level.rankTable[ rankId ][ 7 ] = tableLookup( "sp/ranktable.csv", 0, rankId, 7 );
precacheString( tableLookupIString( "sp/ranktable.csv", 0, rankId, 10 ) );
rankId++ ;
rankName = tableLookup( "sp/ranktable.csv", 0, rankId, 1 );
}
maps\_missions::buildChallengeInfo();
}
xp_init()
{
xp_setup();
foreach ( player in level.players )
{
player thread xp_player_init();
player thread maps\_missions::updateChallenges();
}
}
xp_player_init()
{
if ( !isDefined( self.summary ) )
{
self.summary[ "rankxp" ] = self getplayerdata( "experience" );
self.summary[ "rank" ] = self getRankForXp( self.summary[ "rankxp" ] );
}
self update_rank_into_profile();
self.rankUpdateTotal = 0;
self.hud_rankscroreupdate = newclientHudElem( self );
self.hud_rankscroreupdate.horzAlign = "center";
self.hud_rankscroreupdate.vertAlign = "middle";
self.hud_rankscroreupdate.alignX = "center";
self.hud_rankscroreupdate.alignY = "middle";
self.hud_rankscroreupdate.x = 0;
self.hud_rankscroreupdate.y = -60;
self.hud_rankscroreupdate.font = "hudbig";
self.hud_rankscroreupdate.fontscale = 0.75;
self.hud_rankscroreupdate.archived = false;
self.hud_rankscroreupdate.color = ( 0.75, 1.0, 0.75 );
self.hud_rankscroreupdate fontPulseInit();
}
update_rank_into_profile()
{
old_percentCompleteSO = self GetLocalPlayerProfileData( "percentCompleteSO" );
old_stars = int( old_percentCompleteSO / 100 );
player_rank = self getRank();
new_percentCompleteSO = player_rank;
self SetLocalPlayerProfileData( "percentCompleteSO", new_percentCompleteSO );
}
xp_bar_client_elem( client )
{
hudelem = newClientHudElem( client );
hudelem.x = ( hud_width_format() / 2 ) * ( -1 );
hudelem.y = 0;
hudelem.sort = 5;
hudelem.horzAlign = "center_adjustable";
hudelem.vertAlign = "bottom_adjustable";
hudelem.alignX = "left";
hudelem.alignY = "bottom";
hudelem setshader( "gradient_fadein", get_xpbarwidth(), 4 );
hudelem.color = ( 1, 0.8, 0.4 );
hudelem.alpha = 0.65;
hudelem.foreground = true;
return hudelem;
}
hud_width_format()
{
if ( isSplitscreen() )
return 726;
else
return 540;
}
xpbar_update()
{
if ( !get_xpbarwidth() )
self.hud_xpbar.alpha = 0;
else
self.hud_xpbar.alpha = 0.65;
self.hud_xpbar setshader( "gradient_fadein", get_xpbarwidth(), 4 );
}
get_xpbarwidth()
{
rank_range = int( tableLookup( "sp/rankTable.csv", 0, self.summary[ "rank" ], 3 ) );
rank_xp = int( self.summary[ "rankxp" ] - int( tableLookup( "sp/rankTable.csv", 0, self.summary[ "rank" ], 2 ) ) );
fullwidth = hud_width_format();
newwidth = int( fullwidth * ( rank_xp / rank_range ) );
return newwidth;
}
xp_setup()
{
if ( !isdefined( level.scoreInfo ) || !isdefined( level.scoreInfo.size ) )
level.scoreInfo = [];
level.xpScale = 1;
if ( level.console )
{
level.xpScale = 1;
}
registerScoreInfo( "kill", 100 );
registerScoreInfo( "headshot", 100 );
registerScoreInfo( "assist", 20 );
registerScoreInfo( "suicide", 0 );
registerScoreInfo( "teamkill", 0 );
registerScoreInfo( "completion_xp", 5000 );
level notify( "rank_score_info_defaults_set" );
}
giveXP_think()
{
self waittill( "death", attacker, type, weapon );
if	(
IsDefined( attacker )
&&	IsDefined( attacker.classname )
&&	attacker.classname == "worldspawn"
&&	IsDefined( self.last_dmg_player )
)
{
attacker = self.last_dmg_player;
}
self giveXP_helper( attacker );
}
giveXP_helper( attacker )
{
if ( !isdefined( attacker ) )
return;
if ( isAI( attacker ) && attacker isBadGuy() )
return;
if ( is_special_targetname_attacker( attacker ) )
{
if ( isdefined( attacker.attacker ) )
{
self thread giveXP_helper( attacker.attacker );
return;
}
if ( isdefined( attacker.damageowner ) )
{
self thread giveXP_helper( attacker.damageowner );
return;
}
}
if ( isPlayer( attacker ) )
{
if ( isdefined( level.giveXp_kill_func ) )
attacker thread [[ level.giveXp_kill_func ]]( self );
else
attacker thread giveXp( "kill" );
}
if ( is_survival() )
{
if	(
isai( attacker )
&&	!attacker isbadguy()
&&	isdefined( attacker.owner )
&&	isPlayer( attacker.owner)
)
{
if ( isdefined( level.giveXp_kill_func ) )
attacker.owner thread [[ level.giveXp_kill_func ]]( self );
else
attacker.owner thread giveXp( "kill" );
}
}
if ( !isPlayer( attacker ) && !isAI( attacker ) )
return;
if ( !attacker isbadguy() && isdefined( self.attacker_list ) && self.attacker_list.size )
{
for ( i = 0; i < self.attacker_list.size; i++ )
{
if ( isPlayer( self.attacker_list[ i ] ) && self.attacker_list[ i ] != attacker )
{
if ( isdefined( self.kill_assist_xp ) )
self.attacker_list[ i ] thread giveXp( "assist", self.kill_assist_xp );
else
self.attacker_list[ i ] thread giveXp( "assist" );
}
}
}
}
is_special_targetname_attacker( attacker )
{
assert( isdefined( attacker ) );
if ( !isdefined( attacker.targetname ) )
return false;
if ( issubstr( attacker.targetname, "destructible" ) )
return true;
if ( string_starts_with( attacker.targetname, "sentry_" ) )
return true;
return false;
}
AI_xp_init()
{
self thread giveXP_think();
self.attacker_list = [];
self.last_attacked = 0;
self add_damage_function( ::xp_took_damage );
}
xp_took_damage( damage, attacker, direction_vec, point, type, modelName, tagName )
{
if ( !isdefined( attacker ) )
return;
if( !IsDefined( self ) )
return;
currentTime = gettime();
timeElapsed = currentTime - self.last_attacked;
if ( timeElapsed <= 10 * 1000 )
{
self.attacker_list = array_remove( self.attacker_list, attacker );
self.attacker_list[ self.attacker_list.size ] = attacker;
self.last_attacked = gettime();
return;
}
self.attacker_list = [];
self.attacker_list[ 0 ] = attacker;
self.last_attacked = gettime();
}
updatePlayerScore( type, value )
{
if ( !isdefined( level.xp_enable ) || !level.xp_enable )
return;
if ( !isDefined( value ) )
{
if ( isDefined( level.scoreInfo[ type ] ) )
value = getScoreInfoValue( type );
else
value = getScoreInfoValue( "kill" );
}
value = int( value * level.xpScale );
if ( type == "assist" )
{
if ( value > getScoreInfoValue( "kill" ) )
value = getScoreInfoValue( "kill" );
}
self thread print_score_increment( value );
self.summary[ "rankxp" ] += value;
if ( self updateRank() )
{
self thread updateRankAnnounceHUD();
self update_rank_into_profile();
}
if ( self.summary[ "rankxp" ] <= level.maxXP )
self setplayerdata( "experience", self.summary[ "rankxp" ] );
if ( self.summary[ "rankxp" ] > level.maxXP )
self setplayerdata( "experience", level.maxXP );
waittillframeend;
self notify( "xp_updated", type );
}
print_score_increment( value )
{
self notify( "update_xp" );
self endon( "update_xp" );
self.rankUpdateTotal += value;
self.hud_rankscroreupdate.label = &"SCRIPT_PLUS";
self.hud_rankscroreupdate setValue( self.rankUpdateTotal );
self.hud_rankscroreupdate.alpha = 0.75;
self.hud_rankscroreupdate thread fontPulse( self );
self.hud_rankscroreupdate.x = 0;
self.hud_rankscroreupdate.y = -60;
wait 1;
self.hud_rankscroreupdate fadeOverTime( 0.2 );
self.hud_rankscroreupdate.alpha = 0;
self.hud_rankscroreupdate moveovertime( 0.2 );
self.hud_rankscroreupdate.x = -240;
self.hud_rankscroreupdate.y = 160;
wait 0.5;
self.hud_rankscroreupdate.x = 0;
self.hud_rankscroreupdate.y = -60;
self.rankUpdateTotal = 0;
}
fontPulseInit()
{
self.baseFontScale = self.fontScale;
self.maxFontScale = self.fontScale * 2;
self.inFrames = 3;
self.outFrames = 5;
}
fontPulse( player )
{
self notify( "fontPulse" );
self endon( "fontPulse" );
scaleRange = self.maxFontScale - self.baseFontScale;
while ( self.fontScale < self.maxFontScale )
{
self.fontScale = min( self.maxFontScale, self.fontScale + ( scaleRange / self.inFrames ) );
wait 0.05;
}
while ( self.fontScale > self.baseFontScale )
{
self.fontScale = max( self.baseFontScale, self.fontScale - ( scaleRange / self.outFrames ) );
wait 0.05;
}
}
updateRank()
{
newRankId = self getRank();
if ( newRankId == self.summary[ "rank" ] )
return false;
oldRank = self.summary[ "rank" ];
rankId = self.summary[ "rank" ];
self.summary[ "rank" ] = newRankId;
while ( rankId <= newRankId )
{
self.setPromotion = true;
rankId++ ;
}
return true;
}
updateRankAnnounceHUD()
{
self endon( "disconnect" );
self notify( "update_rank" );
self endon( "update_rank" );
self notify( "reset_outcome" );
newRankName = self getRankInfoFull( self.summary[ "rank" ] );
notifyData = spawnStruct();
notifyData.titleText = &"RANK_PROMOTED";
notifyData.iconName = self getRankInfoIcon( self.summary[ "rank" ] );
notifyData.sound = "sp_level_up";
notifyData.duration = 4.0;
rank_char = level.rankTable[ self.summary[ "rank" ] ][ 1 ];
subRank = int( rank_char[ rank_char.size - 1 ] );
notifyData.notifyText = newRankName;
if ( flag_exist( "special_op_final_xp_given" ) && flag( "special_op_final_xp_given" ) )
level.eog_summary_delay = int( max( 0, notifyData.duration - 2 ) );
self thread notifyMessage( notifyData );
if ( subRank > 1 )
return;
}
notifyMessage( notifyData )
{
self endon( "death" );
self endon( "disconnect" );
timeout = 4;
while ( self.doingNotify && timeout > 0 )
{
timeout -= 0.5;
wait 0.5;
}
self thread showNotifyMessage( notifyData );
}
stringToFloat( stringVal )
{
floatElements = strtok( stringVal, "." );
floatVal = int( floatElements[0] );
if ( isDefined( floatElements[1] ) )
{
modifier = 1;
for ( i = 0; i < floatElements[1].size; i++ )
modifier *= 0.1;
floatVal += int ( floatElements[1] ) * modifier;
}
return floatVal;
}
actionNotifyMessage( actionData )
{
self endon ( "death" );
self endon ( "disconnect" );
assert( isDefined( actionData.slot ) );
slot = actionData.slot;
assertEx( tableLookup( "sp/splashTable.csv", 0, actionData.name, 0 ) != "", "ERROR: unknown splash - " + actionData.name );
if ( tableLookup( "sp/splashTable.csv", 0, actionData.name, 0 ) != "" )
{
if ( isDefined( actionData.optionalNumber ) )
self ShowHudSplash( actionData.name, actionData.slot, actionData.optionalNumber );
else
self ShowHudSplash( actionData.name, actionData.slot );
self.doingSplash[ slot ] = actionData;
duration = stringToFloat( tableLookup( "sp/splashTable.csv", 0, actionData.name, 4 ) );
if ( isDefined( actionData.sound ) )
self playLocalSound( actionData.sound );
self notify ( "actionNotifyMessage" + slot );
self endon ( "actionNotifyMessage" + slot );
wait ( duration - 0.05 );
self.doingSplash[ slot ] = undefined;
}
if ( self.splashQueue[ slot ].size )
self thread dispatchNotify( slot );
}
removeTypeFromQueue( actionType, slot )
{
newQueue = [];
for ( i = 0; i < self.splashQueue[ slot ].size; i++ )
{
if ( self.splashQueue[ slot ][ i ].type != "killstreak" )
newQueue[ newQueue.size ] = self.splashQueue[ slot ][ i ];
}
self.splashQueue[ slot ] = newQueue;
}
actionNotify( actionData )
{
self endon ( "death" );
self endon ( "disconnect" );
assert( isDefined( actionData.slot ) );
slot = actionData.slot;
if ( !isDefined( actionData.type ) )
actionData.type = "";
if ( !isDefined( self.doingSplash[ slot ] ) )
{
self thread actionNotifyMessage( actionData );
return;
}
else if ( actionData.type == "killstreak" && self.doingSplash[ slot ].type != "challenge" && self.doingSplash[ slot ].type != "rank" )
{
self.notifyText.alpha = 0;
self.notifyText2.alpha = 0;
self.notifyIcon.alpha = 0;
self thread actionNotifyMessage( actionData );
return;
}
else if ( actionData.type == "challenge" && self.doingSplash[ slot ].type != "killstreak" && self.doingSplash[ slot ].type != "challenge" && self.doingSplash[ slot ].type != "rank" )
{
self.notifyText.alpha = 0;
self.notifyText2.alpha = 0;
self.notifyIcon.alpha = 0;
self thread actionNotifyMessage( actionData );
return;
}
if ( actionData.type == "challenge" || actionData.type == "killstreak" )
{
if ( actionData.type == "killstreak" )
self removeTypeFromQueue( "killstreak", slot );
for ( i = self.splashQueue[ slot ].size; i > 0; i-- )
self.splashQueue[ slot ][ i ] = self.splashQueue[ slot ][ i-1 ];
self.splashQueue[ slot ][ 0 ] = actionData;
}
else
{
self.splashQueue[ slot ][ self.splashQueue[ slot ].size ] = actionData;
}
}
showNotifyMessage( notifyData )
{
self endon( "disconnect" );
self.doingNotify = true;
waitRequireVisibility( 0 );
if ( isDefined( notifyData.duration ) )
duration = notifyData.duration;
else
duration = 4.0;
self thread resetOnCancel();
if ( isDefined( notifyData.sound ) )
self playLocalSound( notifyData.sound );
if ( isDefined( notifyData.glowColor ) )
glowColor = notifyData.glowColor;
else
glowColor = ( 0.3, 0.6, 0.3 );
anchorElem = self.notifyTitle;
if ( isDefined( notifyData.titleText ) )
{
if ( isDefined( notifyData.titleLabel ) )
self.notifyTitle.label = notifyData.titleLabel;
else
self.notifyTitle.label = &"";
if ( isDefined( notifyData.titleLabel ) && !isDefined( notifyData.titleIsString ) )
self.notifyTitle setValue( notifyData.titleText );
else
self.notifyTitle setText( notifyData.titleText );
self.notifyTitle setPulseFX( 100, int( duration * 1000 ), 1000 );
self.notifyTitle.glowColor = glowColor;
self.notifyTitle.alpha = 1;
}
if ( isDefined( notifyData.notifyText ) )
{
if ( isDefined( notifyData.textLabel ) )
self.notifyText.label = notifyData.textLabel;
else
self.notifyText.label = &"";
if ( isDefined( notifyData.textLabel ) && !isDefined( notifyData.textIsString ) )
self.notifyText setValue( notifyData.notifyText );
else
self.notifyText setText( notifyData.notifyText );
self.notifyText setPulseFX( 100, int( duration * 1000 ), 1000 );
self.notifyText.glowColor = glowColor;
self.notifyText.alpha = 1;
anchorElem = self.notifyText;
}
if ( isDefined( notifyData.notifyText2 ) )
{
self.notifyText2 setParent( anchorElem );
if ( isDefined( notifyData.text2Label ) )
self.notifyText2.label = notifyData.text2Label;
else
self.notifyText2.label = &"";
self.notifyText2 setText( notifyData.notifyText2 );
self.notifyText2 setPulseFX( 100, int( duration * 1000 ), 1000 );
self.notifyText2.glowColor = glowColor;
self.notifyText2.alpha = 1;
anchorElem = self.notifyText2;
}
if ( isDefined( notifyData.iconName ) )
{
self.notifyIcon setParent( anchorElem );
self.notifyIcon setShader( notifyData.iconName, 60, 60 );
self.notifyIcon.alpha = 0;
self.notifyIcon fadeOverTime( 1.0 );
self.notifyIcon.alpha = 1;
waitRequireVisibility( duration );
self.notifyIcon fadeOverTime( 0.75 );
self.notifyIcon.alpha = 0;
}
else
{
waitRequireVisibility( duration );
}
self notify( "notifyMessageDone" );
self.doingNotify = false;
}
resetOnCancel()
{
self notify( "resetOnCancel" );
self endon( "resetOnCancel" );
self endon( "notifyMessageDone" );
self endon( "disconnect" );
level waittill( "cancel_notify" );
self.notifyTitle.alpha = 0;
self.notifyText.alpha = 0;
self.notifyIcon.alpha = 0;
self.doingNotify = false;
}
waitRequireVisibility( waitTime )
{
interval = .05;
while ( !self canReadText() )
wait interval;
while ( waitTime > 0 )
{
wait interval;
if ( self canReadText() )
waitTime -= interval;
}
}
canReadText()
{
if ( self isFlashbanged() )
return false;
return true;
}
isFlashbanged()
{
return isDefined( self.flashEndTime ) && gettime() < self.flashEndTime;
}
dispatchNotify( slot )
{
nextNotifyData = self.splashQueue[ slot ][ 0 ];
for ( i = 1; i < self.splashQueue[ slot ].size; i++ )
self.splashQueue[ slot ][i-1] = self.splashQueue[ slot ][i];
self.splashQueue[ slot ][i-1] = undefined;
if ( isDefined( nextNotifyData.name ) )
actionNotify( nextNotifyData );
else
showNotifyMessage( nextNotifyData );
}
registerScoreInfo( type, value )
{
level.scoreInfo[ type ][ "value" ] = value;
}
getScoreInfoValue( type )
{
return( level.scoreInfo[ type ][ "value" ] );
}
getRankInfoMinXP( rankId )
{
return int( level.rankTable[ rankId ][ 2 ] );
}
getRankInfoXPAmt( rankId )
{
return int( level.rankTable[ rankId ][ 3 ] );
}
getRankInfoMaxXp( rankId )
{
return int( level.rankTable[ rankId ][ 7 ] );
}
getRankInfoFull( rankId )
{
return tableLookupIString( "sp/ranktable.csv", 0, rankId, 5 );
}
getRankInfoIcon( rankId )
{
return tableLookup( "sp/rankTable.csv", 0, rankId, 6 );
}
getRank()
{
rankXp = self.summary[ "rankxp" ];
rankId = self.summary[ "rank" ];
if ( rankXp < ( getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) ) )
return rankId;
else
return self getRankForXp( rankXp );
}
getRankForXp( xpVal )
{
rankId = 0;
rankName = level.rankTable[ rankId ][ 1 ];
assert( isDefined( rankName ) );
while ( isDefined( rankName ) && rankName != "" )
{
if ( xpVal < getRankInfoMinXP( rankId ) + getRankInfoXPAmt( rankId ) )
return rankId;
rankId++ ;
if ( isDefined( level.rankTable[ rankId ] ) )
rankName = level.rankTable[ rankId ][ 1 ];
else
rankName = undefined;
}
rankId -- ;
return rankId;
}
getRankXP()
{
return self getplayerdata( "experience" );
}
