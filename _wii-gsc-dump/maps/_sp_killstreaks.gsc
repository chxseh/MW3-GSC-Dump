#include maps\_utility;
#include common_scripts\utility;
#include maps\_sp_airdrop;
#include maps\_remotemissile_utility;
sp_killstreaks_global_preload()
{
PrecacheString( &"SP_KILLSTREAKS_CAPTURING_CRATE" );
PrecacheShader( "progress_bar_fill" );
PrecacheShader( "progress_bar_bg" );
PrecacheShader( "dpad_killstreak_carepackage" );
PrecacheShader( "specialty_carepackage" );
PrecacheString( &"SP_KILLSTREAKS_SHAREPACKAGE_TITLE" );
PrecacheString( &"SP_KILLSTREAKS_SHAREPACKAGE_DESC" );
PrecacheString( &"SP_KILLSTREAKS_CRATE_HIJACK_TITLE" );
PrecacheString( &"SP_KILLSTREAKS_CRATE_HIJACK_DESC" );
PrecacheString( &"SP_KILLSTREAKS_EARNED_AIRDROP" );
PrecacheString( &"SP_KILLSTREAKS_NAME_AIRDROP" );
PrecacheItem( "killstreak_sentry_sp" );
PrecacheShader( "specialty_sentry_gun_crate" );
PrecacheShader( "specialty_airdrop_sentry_minigun" );
PrecacheString( &"SP_KILLSTREAKS_EARNED_AIRDROP_SENTRY" );
PrecacheString( &"SP_KILLSTREAKS_SENTRY_PICKUP" );
PrecacheString( &"SP_KILLSTREAKS_REWARDNAME_AIRDROP_SENTRY" );
PrecacheString( &"SP_KILLSTREAKS_REWARDNAME_SENTRY" );
PrecacheShader( "specialty_stalker" );
PrecacheShader( "specialty_longersprint" );
PrecacheShader( "specialty_fastreload" );
PrecacheShader( "specialty_quickdraw" );
PrecacheShader( "specialty_steadyaim" );
PrecacheString( &"SP_KILLSTREAKS_SPECIALTY_LONGERSPRINT_PICKUP" );
PrecacheString( &"SP_KILLSTREAKS_SPECIALTY_FASTRELOAD_PICKUP" );
PrecacheString( &"SP_KILLSTREAKS_SPECIALTY_QUICKDRAW_PICKUP" );
PrecacheString( &"SP_KILLSTREAKS_SPECIALTY_BULLETACCURACY_PICKUP" );
PrecacheString( &"SP_KILLSTREAKS_SPECIALTY_STALKER_PICKUP" );
PrecacheItem( "c4" );
PrecacheShader( "hud_icon_c4" );
PrecacheString( &"SP_KILLSTREAKS_EARNED_AIRDROP_C4" );
PrecacheString( &"SP_KILLSTREAKS_C4_PICKUP" );
PrecacheString( &"SP_KILLSTREAKS_REWARDNAME_AIRDROP_C4" );
PrecacheShader( "waypoint_ammo_friendly" );
PrecacheString( &"PLATFORM_RESUPPLY" );
PrecacheString( &"SP_KILLSTREAKS_REWARDNAME_AIRDROP_AMMO" );
PrecacheItem( "remote_missile_detonator" );
PrecacheItem( "remote_missile" );
PrecacheShader( "dpad_killstreak_hellfire_missile" );
PrecacheShader( "specialty_predator_missile" );
PrecacheString( &"SP_KILLSTREAKS_EARNED_PREDATOR_MISSILE" );
PrecacheString( &"SP_KILLSTREAKS_REMOTEMISSILE_PICKUP" );
PrecacheString( &"SP_KILLSTREAKS_REWARDNAME_AIRDROP_REMOTEMISSILE" );
PrecacheString( &"SP_KILLSTREAKS_REWARDNAME_REMOTEMISSILE" );
PrecacheShader( "specialty_nuke" );
}
sp_killstreaks_init()
{
ASSERT( !sp_killstreaks_init_done() );
ASSERT( !IsDefined( level.ks ) );
level.ks = SpawnStruct();
level.ks.killstreakTypes = [];
mapCenterStruct = GetStruct( "map_center", "targetname" );
ASSERT( IsDefined( mapCenterStruct ), "Couldn't find struct with targetname map_center." );
level.mapCenter = mapCenterStruct.origin;
array_thread( level.players, ::sp_killstreaks_player_init );
if( !sp_airdrop_init_done() )
{
sp_airdrop_init();
}
sp_killstreaks_hud_init();
level.ks.globalInitDone = true;
}
sp_killstreaks_hud_init()
{
level.uiParent = spawnstruct();
level.uiParent.horzAlign = "left";
level.uiParent.vertAlign = "top";
level.uiParent.alignX = "left";
level.uiParent.alignY = "top";
level.uiParent.x = 0;
level.uiParent.y = 0;
level.uiParent.width = 0;
level.uiParent.height = 0;
level.uiParent.children = [];
level.fontHeight = 12;
level.hud["allies"] = spawnstruct();
level.hud["axis"] = spawnstruct();
level.primaryProgressBarY = -61;
level.primaryProgressBarX = 0;
level.primaryProgressBarHeight = 9;
level.primaryProgressBarWidth = 120;
level.primaryProgressBarTextY = -75;
level.primaryProgressBarTextX = 0;
level.primaryProgressBarFontSize = .6;
level.teamProgressBarY = 32;
level.teamProgressBarHeight = 14;
level.teamProgressBarWidth = 192;
level.teamProgressBarTextY = 8;
level.teamProgressBarFontSize = 1.65;
if ( IsSplitscreen() )
{
level.lowerTextYAlign = "BOTTOM";
level.lowerTextY = -76;
level.lowerTextFontSize = 1.14;
}
else
{
level.lowerTextYAlign = "CENTER";
level.lowerTextY = 70;
level.lowerTextFontSize = 1.6;
}
}
sp_killstreaks_init_done()
{
return( IsDefined( level.ks ) && IsDefined( level.ks.globalInitDone ) );
}
sp_killstreaks_player_init()
{
self.ks = SpawnStruct();
self.ks.killstreaks = [];
self thread sp_killstreak_use_waiter();
if (!using_wii())
{
if( !IsDefined( self.remotemissile_actionslot ) )
{
self.remotemissile_actionslot = 4;
}
self thread remotemissile_no_autoreload();
}
}
add_sp_killstreak( streakType )
{
ASSERT( sp_killstreaks_init_done() );
ASSERTEX( !sp_killstreak_exists( streakType ), "Couldn't add killstreak info for type '" + streakType + "' because info with that type name has already been added." );
weaponName	= undefined;
streakFunc	= undefined;
achieveVO	= undefined;
useVO = undefined;
splashIcon	= undefined;
splashHint	= undefined;
crateIcon	= undefined;
crateHint	= undefined;
crateOpenFunc = undefined;
if ( issubstr( streakType, "specialty_" ) )
{
weaponName	= "airdrop_marker_mp";
streakFunc	= ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_AIRDROP";
achieveVO	= "UK_1mc_achieve_carepackage";
useVO = "UK_1mc_use_carepackage";
splashIcon	= "specialty_carepackage";
splashHint	= &"SP_KILLSTREAKS_EARNED_AIRDROP";
crateOpenFunc = ::sp_killstreak_perk_crateopen;
switch( streakType )
{
case "specialty_longersprint":
crateIcon	= "specialty_longersprint";
crateHint	= &"SP_KILLSTREAKS_SPECIALTY_LONGERSPRINT_PICKUP";
break;
case "specialty_fastreload":
crateIcon	= "specialty_fastreload";
crateHint	= &"SP_KILLSTREAKS_SPECIALTY_FASTRELOAD_PICKUP";
break;
case "specialty_quickdraw":
crateIcon	= "specialty_quickdraw";
crateHint	= &"SP_KILLSTREAKS_SPECIALTY_QUICKDRAW_PICKUP";
break;
case "specialty_detectexplosive":
crateIcon	= "specialty_bombsquad";
crateHint	= &"SP_KILLSTREAKS_SPECIALTY_DETECTEXPLOSIVE_PICKUP";
break;
case "specialty_bulletaccuracy":
crateIcon	= "specialty_steadyaim";
crateHint	= &"SP_KILLSTREAKS_SPECIALTY_BULLETACCURACY_PICKUP";
break;
case "specialty_stalker":
crateIcon	= "specialty_stalker";
crateHint	= &"SP_KILLSTREAKS_SPECIALTY_STALKER_PICKUP";
break;
default:
ASSERTMSG( "Couldn't identify sp killstreak to add, of type '" + streakType + "'." );
return;
}
}
else
{
switch( streakType )
{
case "carepackage":
weaponName	= "airdrop_marker_mp";
streakFunc	= ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_AIRDROP";
achieveVO	= "UK_1mc_achieve_carepackage";
useVO = "UK_1mc_use_carepackage";
splashIcon	= "specialty_carepackage";
splashHint	= &"SP_KILLSTREAKS_EARNED_AIRDROP";
crateIcon	= "dpad_killstreak_carepackage";
crateHint	= &"SP_KILLSTREAKS_NAME_AIRDROP";
crateOpenFunc = undefined;
break;
case "carepackage_sentry":
weaponName	= "airdrop_marker_mp";
streakFunc = ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_AIRDROP_SENTRY";
achieveVO	= "UK_1mc_deploy_sentry";
useVO = undefined;
splashIcon	= "specialty_airdrop_sentry_minigun";
splashHint	= &"SP_KILLSTREAKS_EARNED_AIRDROP_SENTRY";
crateIcon	= "specialty_sentry_gun_crate";
crateHint	= &"SP_KILLSTREAKS_SENTRY_PICKUP";
crateOpenFunc = undefined;
break;
case "sentry":
weaponName	= "killstreak_sentry_sp";
streakFunc = ::sp_killstreak_autosentry_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_SENTRY";
achieveVO	= "UK_1mc_deploy_sentry";
useVO = undefined;
splashIcon	= "specialty_airdrop_sentry_minigun";
splashHint	= &"SP_KILLSTREAKS_EARNED_AIRDROP_SENTRY";
crateIcon	= "specialty_sentry_gun_crate";
crateHint	= &"SP_KILLSTREAKS_SENTRY_PICKUP";
crateOpenFunc = undefined;
break;
case "sentry_gl":
weaponName	= "killstreak_sentry_sp";
streakFunc = ::sp_killstreak_autosentry_gl_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_SENTRY";
achieveVO	= "UK_1mc_deploy_sentry";
useVO = undefined;
splashIcon	= "specialty_airdrop_sentry_minigun";
splashHint	= &"SP_KILLSTREAKS_EARNED_AIRDROP_SENTRY";
crateIcon	= "specialty_sentry_gun_crate";
crateHint	= &"SP_KILLSTREAKS_SENTRY_PICKUP";
crateOpenFunc = undefined;
break;
case "carepackage_remote_missile":
weaponName	= "airdrop_marker_mp";
streakFunc	= ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_AIRDROP_REMOTEMISSILE";
achieveVO	= "UK_1mc_achieve_carepackage";
useVO = "UK_1mc_use_carepackage";
splashIcon	= "specialty_predator_missile";
splashHint	= &"SP_KILLSTREAKS_";
crateIcon	= "dpad_killstreak_carepackage";
crateHint	= &"SP_KILLSTREAKS_NAME_AIRDROP";
crateOpenFunc = undefined;
break;
case "remote_missile":
weaponName	= "remote_missile_detonator";
streakFunc = ::sp_killstreak_remotemissile_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_REMOTEMISSILE";
achieveVO	= "UK_1mc_achieve_hellfire";
useVO = "UK_1mc_use_hellfire";
splashIcon	= "specialty_predator_missile";
splashHint	= &"SP_KILLSTREAKS_EARNED_PREDATOR_MISSILE";
crateIcon	= "dpad_killstreak_hellfire_missile";
crateHint	= &"SP_KILLSTREAKS_REMOTEMISSILE_PICKUP";
crateOpenFunc = undefined;
break;
case "carepackage_c4":
weaponName	= "airdrop_marker_mp";
streakFunc	= ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_AIRDROP_C4";
achieveVO	= "UK_1mc_achieve_carepackage";
useVO = "UK_1mc_use_carepackage";
splashIcon	= "hud_icon_c4";
splashHint	= &"SP_KILLSTREAKS_EARNED_AIRDROP_C4";
crateIcon	= "hud_icon_c4";
crateHint	= &"SP_KILLSTREAKS_C4_PICKUP";
crateOpenFunc = ::sp_killstreak_c4_crateopen;
break;
case "carepackage_ammo":
weaponName	= "airdrop_marker_mp";
streakFunc	= ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_AIRDROP_AMMO";
achieveVO	= "UK_1mc_achieve_carepackage";
useVO = "UK_1mc_use_carepackage";
splashIcon	= "specialty_carepackage";
splashHint	= &"SP_KILLSTREAKS_EARNED_AIRDROP";
crateIcon	= "waypoint_ammo_friendly";
crateHint	= &"PLATFORM_RESUPPLY";
crateOpenFunc = ::sp_killstreak_ammo_crateopen;
break;
case "carepackage_precision_airstrike":
weaponName	= "airdrop_marker_mp";
streakFunc = ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_PRECISION_AIRSTRIKE";
achieveVO	= "UK_1mc_achieve_carepackage";
useVO = "UK_1mc_use_carepackage";
splashIcon	= "specialty_precision_airstrike";
splashHint	= &"SP_KILLSTREAKS_EARNED_PRECISION_AIRSTRIKE";
crateIcon	= "dpad_killstreak_carepackage";
crateHint	= &"SP_KILLSTREAKS_PRECISION_AIRSTRIKE_PICKUP";
crateOpenFunc = undefined;
break;
case "precision_airstrike":
weaponName	= "killstreak_precision_airstrike_sp";
streakFunc = ::sp_killstreak_airstrike_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_PRECISION_AIRSTRIKE";
achieveVO	= "UK_1mc_achieve_airstrike";
useVO = "UK_1mc_use_airstrike";
splashIcon	= "specialty_precision_airstrike";
splashHint	= &"SP_KILLSTREAKS_EARNED_PRECISION_AIRSTRIKE";
crateIcon	= "dpad_killstreak_precision_airstrike";
crateHint	= &"SP_KILLSTREAKS_PRECISION_AIRSTRIKE_PICKUP";
crateOpenFunc = undefined;
break;
case "carepackage_stealth_airstrike":
weaponName	= "airdrop_marker_mp";
streakFunc = ::sp_killstreak_carepackage_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_STEALTH_AIRSTRIKE";
achieveVO	= "UK_1mc_achieve_carepackage";
useVO = "UK_1mc_use_carepackage";
splashIcon	= "specialty_stealth_bomber";
splashHint	= &"SP_KILLSTREAKS_EARNED_STEALTH_AIRSTRIKE";
crateIcon	= "dpad_killstreak_carepackage";
crateHint	= &"SP_KILLSTREAKS_STEALTH_AIRSTRIKE_PICKUP";
crateOpenFunc = undefined;
break;
case "stealth_airstrike":
weaponName	= "killstreak_stealth_airstrike_sp";
streakFunc = ::sp_killstreak_airstrike_main;
menuRewardDesc	= "SP_KILLSTREAKS_REWARDNAME_STEALTH_AIRSTRIKE";
achieveVO	= "UK_1mc_achieve_airstrike";
useVO = "UK_1mc_use_airstrike";
splashIcon	= "specialty_stealth_bomber";
splashHint	= &"SP_KILLSTREAKS_EARNED_STEALTH_AIRSTRIKE";
crateIcon	= "dpad_killstreak_stealth_bomber";
crateHint	= &"SP_KILLSTREAKS_STEALTH_AIRSTRIKE_PICKUP";
crateOpenFunc = undefined;
break;
default:
ASSERTMSG( "Couldn't identify sp killstreak to add, of type '" + streakType + "'." );
return;
}
}
info = SpawnStruct();
info.streakType = streakType;
info.weaponName = weaponName;
info.streakFunc = streakFunc;
info.menuRewardDesc = menuRewardDesc;
info.achieveVO = achieveVO;
info.useVO = useVO;
info.splashIcon	= splashIcon;
info.splashHint	= splashHint;
info.crateIcon = crateIcon;
info.crateHint = crateHint;
info.crateOpenFunc = crateOpenFunc;
level.ks.killstreakTypes[ streakType ] = info;
add_killstreak_radio_dialogue( achieveVO, useVO );
}
add_killstreak_radio_dialogue( sound1, sound2 )
{
if( !IsDefined( level.scr_radio ) )
{
level.scr_radio = [];
}
sounds[ 0 ] = sound1;
sounds[ 1 ] = sound2;
foreach( sound in sounds )
{
if( !array_contains( level.scr_radio, sound ) && IsDefined( sound ) )
{
level.scr_radio[ sound ] = sound;
}
}
}
sp_killstreak_exists( streakType )
{
foreach( index, info in level.ks.killstreakTypes )
{
if( index == streakType )
{
return true;
}
}
return false;
}
get_sp_killstreak_info( streakType )
{
ASSERT( sp_killstreaks_init_done() );
info = level.ks.killstreakTypes[ streakType ];
ASSERTEX( IsDefined( info ), "Couldn't find sp killstreak info for type '" + streakType + "'." );
return info;
}
give_sp_killstreak( streakType, regive )
{
ASSERT( IsDefined( streakType ) );
if( !IsDefined( self.ks.killstreaks[ 0 ] ) )
{
self.ks.killstreaks[ 0 ] = streakType;
}
else
{
newarr = [];
newarr[ 0 ] = streakType;
foreach( existingType in self.ks.killstreaks )
{
newarr[ newarr.size ] = existingType;
}
self.ks.killstreaks = newarr;
}
self activate_current_sp_killstreak( regive );
}
activate_current_sp_killstreak( regive )
{
streakType = self.ks.killstreaks[ 0 ];
ASSERT( IsDefined( streakType ) );
println( "KILLSTREAK GET" );
killstreakInfo = get_sp_killstreak_info( streakType );
self GiveWeapon( killstreakInfo.weaponName );
self SetActionSlot( 4, "weapon", killstreakInfo.weaponName );
if( streakType == "remote_missile" )
{
maps\_remotemissile::enable_uav( true, killstreakInfo.weaponName );
}
if ( !isdefined( regive ) || !regive )
self thread radio_dialogue( killstreakInfo.achieveVO );
}
take_sp_killstreak( streakType )
{
ASSERT( IsDefined( self.ks ) && IsDefined( self.ks.killstreaks ) );
ASSERT( self.ks.killstreaks.size );
taken = false;
foreach( index, existingType in self.ks.killstreaks )
{
if( existingType == streakType )
{
self.ks.killstreaks = array_remove( self.ks.killstreaks, streakType );
if( index == 0 )
{
killstreakInfo = get_sp_killstreak_info( streakType );
self TakeWeapon( killstreakInfo.weaponName );
}
taken = true;
break;
}
}
ASSERT( taken, "Couldn't take sp killstreak of type '" + streakType + "' because the player didn't actually have it in his queue." );
if( self has_any_killstreak() )
{
self activate_current_sp_killstreak();
}
}
has_any_killstreak()
{
return( self.ks.killstreaks.size );
}
has_killstreak( type )
{
if( self has_any_killstreak() )
{
foreach( streakType in self.ks.killstreaks )
{
if( type == streakType )
{
return true;
}
}
}
return false;
}
sp_killstreak_use_waiter()
{
self endon( "death" );
for ( ;; )
{
self.ks.lastWeaponUsed = self GetCurrentWeapon();
self waittill ( "weapon_change", newWeapon );
if ( !IsAlive( self ) )
{
continue;
}
killstreakType = self.ks.killstreaks[ 0 ];
if ( !IsDefined( killstreakType ) )
{
continue;
}
killstreakInfo = get_sp_killstreak_info( killstreakType );
if( IsDefined( killstreakInfo.weaponName ) )
{
if ( newWeapon != killstreakInfo.weaponName )
{
continue;
}
}
waittillframeend;
success = self sp_killstreak_use_pressed( killstreakInfo );
if( success )
{
self used_sp_killstreak( killstreakInfo );
self take_sp_killstreak( killstreakType );
}
else
{
if ( !isdefined( self.carrying_pickedup_sentry ) || !self.carrying_pickedup_sentry )
self post_killstreak_weapon_switchback();
}
if( is_survival() )
{
wait 0.05;
if ( isdefined( self.sentry_placement_failed ) && self.sentry_placement_failed )
{
self give_sp_killstreak( killstreakType, true );
}
}
if ( self GetCurrentWeapon() == "none" )
{
while ( self GetCurrentWeapon() == "none" )
{
wait ( 0.05 );
}
waittillframeend;
}
}
}
sp_killstreak_use_pressed( killstreakInfo )
{
streakType = killstreakInfo.streakType;
ASSERT( IsDefined( streakType ) );
ASSERT( IsDefined( killstreakInfo.streakFunc ) );
if ( !self isOnGround() && isCarryKillstreak( streakType ) )
{
return ( false );
}
if ( self isUsingRemote() )
{
return ( false );
}
if ( isDefined( self.selectingLocation ) )
{
return ( false );
}
if ( self IsUsingTurret() && ( isRideKillstreak( streakType ) || isCarryKillstreak( streakType ) ) )
{
iprintlnbold( &"MP_UNAVAILABLE_USING_TURRET" );
return ( false );
}
if ( ( self ent_flag_exist( "laststand_downed" ) && self ent_flag( "laststand_downed" ) ) && isRideKillstreak( streakType ) )
{
iprintlnbold( &"MP_UNAVILABLE_IN_LASTSTAND" );
return ( false );
}
if ( !self isWeaponEnabled() )
{
return ( false );
}
if ( !self [[ killstreakInfo.streakFunc ]]( killstreakInfo ) )
{
return ( false );
}
return ( true );
}
used_sp_killstreak( info )
{
self PlayLocalSound( "weap_c4detpack_trigger_plr" );
if( IsDefined( info.useVO ) && info.streakType != "remote_missile" )
{
thread radio_dialogue( info.useVO );
}
}
post_killstreak_weapon_switchback()
{
if ( is_player_down( self ) )
{
return;
}
if( IsDefined( self.ks.lastWeaponUsed ) && self.ks.lastWeaponUsed != "none" )
{
self SwitchToWeapon( self.ks.lastWeaponUsed );
}
}
sp_killstreak_remotemissile_main( killstreakInfo )
{
weaponName = killstreakInfo.weaponName;
self.remotemissileFired = false;
self thread sp_killstreak_remotemissile_waitForFire( killstreakInfo.useVO );
while( self.using_uav )
{
wait( 0.05 );
}
self notify( "stopped_using_uav" );
return self.remoteMissileFired;
}
sp_killstreak_remotemissile_waitForFire( useVO )
{
self endon( "stopped_using_uav" );
self waittill( "player_fired_remote_missile" );
self.remoteMissileFired = true;
self thread radio_dialogue( useVO );
}
sp_killstreak_carepackage_main( killstreakInfo )
{
crateType = sp_carepackage_select_reward( killstreakInfo );
airdropSuccess = sp_try_use_airdrop( crateType );
if( !airdropSuccess )
{
return false;
}
return true;
}
sp_carepackage_select_reward( killstreakInfo )
{
if( issubstr( killstreakInfo.streakType, "specialty_" ) )
{
return killstreakInfo.streakType;
}
if( killstreakInfo.streakType == "carepackage_c4" )
{
return "carepackage_c4";
}
else if( killstreakInfo.streakType == "carepackage_remote_missile" )
{
return "remote_missile";
}
else if( killstreakInfo.streakType == "carepackage_sentry" )
{
return "sentry";
}
else if( killstreakInfo.streakType == "carepackage_ammo" )
{
return "carepackage_ammo";
}
else if( killstreakInfo.streakType == "carepackage_precision_airstrike" )
{
return "precision_airstrike";
}
else if( killstreakInfo.streakType == "carepackage_stealth_airstrike" )
{
return "stealth_airstrike";
}
types = [];
weights = [];
types[ types.size ] = "sentry";
weights[ "sentry" ] = 5;
types[ types.size ] = "remote_missile";
weights[ "remote_missile" ] = 15;
types[ types.size ] = "precision_airstrike";
weights[ "precision_airstrike" ] = 10;
types[ types.size ] = "stealth_airstrike";
weights[ "stealth_airstrike" ] = 10;
types[ types.size ] = "carepackage_c4";
weights[ "carepackage_c4" ] = 5;
types[ types.size ] = "carepackage_ammo";
weights[ "carepackage_ammo" ] = 5;
return getWeightedChanceRoll( types, weights );
}
sp_killstreak_ammo_crateopen()
{
self PlayLocalSound( "ammo_crate_use" );
self refillAmmo();
}
refillAmmo()
{
weaponList = self GetWeaponsListAll();
foreach ( weaponName in weaponList )
{
if ( isSubStr( weaponName, "grenade" ) )
{
if ( self getAmmoCount( weaponName ) >= 1 )
{
continue;
}
}
self GiveMaxAmmo( weaponName );
}
}
sp_killstreak_perk_crateopen( ref )
{
self thread maps\_so_survival_perks::give_perk( ref );
}
sp_killstreak_c4_crateopen()
{
if( !self HasWeapon( "c4" ) )
{
self GiveWeapon( "c4" );
self SetActionSlot( 2, "weapon", "c4" );
}
else
{
if( self GetFractionMaxAmmo( "c4" ) == 1 )
{
return;
}
curr = self GetWeaponAmmoStock( "c4" );
self SetWeaponAmmoStock( "c4", curr + 4 );
}
}
sp_killstreak_autosentry_main( killstreakInfo )
{
self common_scripts\_sentry::giveSentry( "sentry_minigun" );
self thread sentry_cancel_notify();
self NotifyOnPlayerCommand( "controller_sentry_cancel", "+actionslot 4" );
self NotifyOnPlayerCommand( "controller_sentry_cancel", "weapnext" );
self waittill_any( "sentry_placement_finished", "sentry_placement_canceled" );
self post_killstreak_weapon_switchback();
return true;
}
sp_killstreak_autosentry_gl_main( killstreakInfo )
{
self common_scripts\_sentry::giveSentry( "sentry_gun" );
self thread sentry_cancel_notify();
self NotifyOnPlayerCommand( "controller_sentry_cancel", "+actionslot 4" );
self NotifyOnPlayerCommand( "controller_sentry_cancel", "weapnext" );
self waittill_any( "sentry_placement_finished", "sentry_placement_canceled" );
self post_killstreak_weapon_switchback();
return true;
}
sentry_cancel_notify()
{
self endon( "sentry_placement_canceled" );
self endon( "sentry_placement_finished" );
self waittill( "controller_sentry_cancel" );
if ( !isdefined( self.carrying_pickedup_sentry ) || !self.carrying_pickedup_sentry )
self notify( "sentry_placement_canceled" );
}
sp_killstreak_airstrike_main( killstreakInfo )
{
streakType = killstreakInfo.streakType;
airstrikeType = "default";
if( streakType == "precision_airstrike" )
{
airstrikeType = "precision";
}
else if( streakType == "stealth_airstrike" )
{
airstrikeType = "stealth";
}
result = maps\_sp_airstrike::try_use_airstrike( airstrikeType );
self post_killstreak_weapon_switchback();
return result;
}
isUsingRemote()
{
return( isDefined( self.usingRemote ) );
}
isRideKillstreak( streakType )
{
switch( streakType )
{
case "helicopter_minigun":
case "helicopter_mk19":
case "ac130":
case "predator_missile":
return true;
default:
return false;
}
}
isCarryKillstreak( streakType )
{
switch( streakType )
{
case "sentry":
case "sentry_gl":
return true;
default:
return false;
}
}
deadlyKillstreak( streakType )
{
switch ( streakType )
{
case "predator_missile":
case "precision_airstrike":
case "harrier_airstrike":
case "stealth_airstrike":
case "ac130":
return true;
}
return false;
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
