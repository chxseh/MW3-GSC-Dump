
#include maps\_utility;
main()
{
level.friendlyfire[ "min_participation" ] = -200;
level.friendlyfire[ "max_participation" ] = 1000;
level.friendlyfire[ "enemy_kill_points" ] = 250;
level.friendlyfire[ "friend_kill_points" ] = -650;
level.friendlyfire[ "point_loss_interval" ] = 1.25;
level.player.participation = 0;
level.friendlyFireDisabled = 0;
level.friendlyFireDisabledForDestructible = 0;
SetDvarIfUninitialized( "friendlyfire_dev_disabled", "0" );
common_scripts\utility::flag_init( "friendly_fire_warning" );
thread debug_friendlyfire();
thread participation_point_flattenOverTime();
}
debug_friendlyfire()
{
}
friendly_fire_think( entity )
{
if ( !isdefined( entity ) )
return;
if ( !isdefined( entity.team ) )
entity.team = "allies";
if ( IsDefined( level.no_friendly_fire_penalty ) )
return;
level endon( "mission failed" );
level thread notifyDamage( entity );
level thread notifyDamageNotDone( entity );
level thread notifyDeath( entity );
for ( ;; )
{
if ( !isdefined( entity ) )
return;
if ( entity.health <= 0 )
return;
damage = undefined;
attacker = undefined;
direction = undefined;
point = undefined;
method = undefined;
weaponName = undefined;
player_killed_destructible = undefined;
entity waittill( "friendlyfire_notify", damage, attacker, direction, point, method, weaponName );
if ( !isdefined( entity ) )
return;
if ( !isdefined( attacker ) )
continue;
bPlayersDamage = false;
if ( !isdefined( weaponName ) )
weaponName = entity.damageweapon;
if ( IsDefined( level.friendlyfire_destructible_attacker ) )
{
if ( IsDefined( attacker.damageowner ) )
{
player_killed_destructible = true;
attacker = attacker.damageowner;
}
}
if ( IsPlayer( attacker ) )
{
bPlayersDamage = true;
if ( isdefined( weaponName ) && ( weaponName == "none" ) )
{
bPlayersDamage = false;
}
if ( attacker isUsingTurret() )
{
bPlayersDamage = true;
}
if ( IsDefined( player_killed_destructible ) )
{
bPlayersDamage = true;
}
}
else if ( ( IsDefined( attacker.code_classname ) ) && ( attacker.code_classname == "script_vehicle" ) )
{
owner = attacker GetVehicleOwner();
if ( ( IsDefined( owner ) ) && ( IsPlayer( owner ) ) )
{
bPlayersDamage = true;
}
}
if ( !bPlayersDamage )
continue;
if ( !isdefined( entity.team ) )
continue;
same_team = entity.team == level.player.team;
civilianKilled = undefined;
if( level.script == "airport" )
civilianKilled = false;
else
{
if( isdefined( entity.type ) && entity.type == "civilian" )
civilianKilled = true;
else
civilianKilled = IsSubStr( entity.classname, "civilian" );
}
killed = damage == -1;
if ( !same_team && !civilianKilled )
{
if ( killed )
{
level.player.participation += level.friendlyfire[ "enemy_kill_points" ];
participation_point_cap();
return;
}
continue;
}
if ( IsDefined( entity.no_friendly_fire_penalty ) )
continue;
if ( ( method == "MOD_PROJECTILE_SPLASH" ) && ( IsDefined( level.no_friendly_fire_splash_damage ) ) )
continue;
if ( IsDefined( weaponName ) && ( weaponName == "claymore" ) )
continue;
if ( killed )
{
if ( IsDefined( entity.friend_kill_points ) )
{
level.player.participation += entity.friend_kill_points;
}
else
{
level.player.participation += level.friendlyfire[ "friend_kill_points" ];
}
}
else
{
level.player.participation -= damage;
}
participation_point_cap();
if ( check_grenade( entity, method ) && savecommit_afterGrenade() )
{
if ( killed )
return;
else
continue;
}
if ( IsDefined( level.friendly_fire_fail_check ) )
{
[[ level.friendly_fire_fail_check ]]( entity, damage, attacker, direction, point, method, weaponName );
}
else
{
friendly_fire_checkPoints( civilianKilled );
}
}
}
friendly_fire_checkPoints( civilianKilled )
{
if ( ( IsDefined( level.failOnFriendlyFire ) ) && ( level.failOnFriendlyFire ) )
{
level thread missionfail( civilianKilled );
return;
}
friendlyfire_disable_destructible = level.friendlyFireDisabledForDestructible;
if ( IsDefined( level.friendlyfire_destructible_attacker ) && civilianKilled )
{
friendlyfire_disable_destructible = false;
}
if ( friendlyfire_disable_destructible )
{
return;
}
if ( level.friendlyFireDisabled == 1 )
return;
if ( level.player.participation <= ( level.friendlyfire[ "min_participation" ] ) )
level thread missionfail( civilianKilled );
}
check_grenade( entity, method )
{
if ( !isdefined( entity ) )
return false;
wasGrenade = false;
if ( ( IsDefined( entity.damageweapon ) ) && ( entity.damageweapon == "none" ) )
wasGrenade = true;
if ( ( IsDefined( method ) ) && ( method == "MOD_GRENADE_SPLASH" ) )
wasGrenade = true;
return wasGrenade;
}
savecommit_afterGrenade()
{
currentTime = GetTime();
if ( currentTime < 4500 )
{
PrintLn( "^3aborting friendly fire because the level just loaded and saved and could cause a autosave grenade loop" );
return true;
}
else
if ( ( currentTime - level.lastAutoSaveTime ) < 4500 )
{
PrintLn( "^3aborting friendly fire because it could be caused by an autosave grenade loop" );
return true;
}
return false;
}
participation_point_cap()
{
if ( level.player.participation > level.friendlyfire[ "max_participation" ] )
level.player.participation = level.friendlyfire[ "max_participation" ];
if ( level.player.participation < level.friendlyfire[ "min_participation" ] )
level.player.participation = level.friendlyfire[ "min_participation" ];
}
participation_point_flattenOverTime()
{
level endon( "mission failed" );
for ( ;; )
{
if ( level.player.participation > 0 )
{
level.player.participation--;
}
else if ( level.player.participation < 0 )
{
level.player.participation++;
}
wait level.friendlyfire[ "point_loss_interval" ];
}
}
TurnBackOn()
{
level.friendlyFireDisabled = 0;
}
TurnOff()
{
level.friendlyFireDisabled = 1;
}
missionfail( civilianKilled )
{
if ( !isdefined( civilianKilled ) )
civilianKilled = false;
if ( level.script == "airport" )
{
if ( civilianKilled )
return;
common_scripts\utility::flag_set( "friendly_fire_warning" );
return;
}
if ( GetDvar( "friendlyfire_dev_disabled" ) == "1" )
return;
level.player endon( "death" );
if( !isAlive( level.player ) )
return;
level endon( "mine death" );
level notify( "mission failed" );
level notify( "friendlyfire_mission_fail" );
waittillframeend;
SetSavedDvar( "hud_missionFailed", 1 );
if ( IsDefined( level.player.failingMission ) )
return;
if ( civilianKilled )
SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_CIVILIAN_KILLED" );
else if ( IsDefined( level.custom_friendly_fire_message ) )
SetDvar( "ui_deadquote", level.custom_friendly_fire_message );
else if ( level.campaign == "british" )
SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH" );
else if ( level.campaign == "russian" )
SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN" );
else
SetDvar( "ui_deadquote", &"SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN" );
if ( IsDefined( level.custom_friendly_fire_shader ) )
thread maps\_load::special_death_indicator_hudelement( level.custom_friendly_fire_shader, 64, 64, 0 );
ReconSpatialEvent( level.player.origin, "script_friendlyfire: civilian %d", civilianKilled );
maps\_utility::missionFailedWrapper();
}
notifyDamage( entity )
{
level endon( "mission failed" );
entity endon( "death" );
for ( ;; )
{
damage = undefined;
attacker = undefined;
direction = undefined;
point = undefined;
method = undefined;
modelName = undefined;
tagName = undefined;
partName = undefined;
dFlags = undefined;
weaponName = undefined;
entity waittill( "damage", damage, attacker, direction, point, method, modelName, tagName, partName, dFlags, weaponName );
entity notify( "friendlyfire_notify", damage, attacker, direction, point, method, weaponName );
}
}
notifyDamageNotDone( entity )
{
level endon( "mission failed" );
entity waittill( "damage_notdone", damage, attacker, direction, point, method );
entity notify( "friendlyfire_notify", -1, attacker, undefined, undefined, method );
}
notifyDeath( entity )
{
level endon( "mission failed" );
entity waittill( "death", attacker, method, weaponName );
entity notify( "friendlyfire_notify", -1, attacker, undefined, undefined, method, weaponName );
}
detectFriendlyFireOnEntity( entity )
{
}
