#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_sp_killstreaks;
#include maps\_sp_airdrop;
#include maps\_specialops;
#include maps\_so_survival_code;
ARMORY_TABLE = "sp/survival_armories.csv";
TABLE_INDEX = 0;
TABLE_REF = 1;
TABLE_TYPE = 2;
TABLE_SLOT = 2;
TABLE_COST = 3;
TABLE_NAME = 4;
TABLE_DESC = 5;
TABLE_ICON = 6;
TABLE_UNLOCK = 7;
TABLE_STOCK = 8;
TABLE_WEAPONUPGRADE = 8;
TABLE_WEAPONDROPAMMO = 9;
TABLE_EXCLUDE = 9;
TABLE_STOCK_MAX_IN_PLAY = 10;
TABLE_SUBTYPE = 11;
ARMORY_WEAPON_INDEX_START = 0;
ARMORY_WEAPON_INDEX_END = 64;
ARMORY_WEAPONUPGRADE_INDEX_START= 100;
ARMORY_WEAPONUPGRADE_INDEX_END	= 120;
ARMORY_EQUIPMENT_INDEX_START	= 1000;
ARMORY_EQUIPMENT_INDEX_END = 1020;
ARMORY_AIRSUPPORT_INDEX_START	= 10000;
ARMORY_AIRSUPPORT_INDEX_END
= 10020;
ARMORY_UNLOCK_WEAPON = 0;
ARMORY_UNLOCK_EQUIPMENT = 3;
ARMORY_UNLOCK_AIRSUPPORT = 4;
ARMORY_RELOCATE = 0;
ARMORY_ICON_WEAPON = "so_survival_icon_armory_weapon";
ARMORY_ICON_EQUIPMENT = "so_survival_icon_armory_equipment";
ARMORY_ICON_AIRSUPPORT = "so_survival_icon_armory_airsupport";
ARMORY_MENU_WEAPON = "so_survival_menu_weapon";
ARMORY_MENU_EQUIPMENT = "so_survival_menu_equipment";
ARMORY_MENU_AIRSUPPORT = "so_survival_menu_airsupport";
CREDIT_SHARE_INCREMENT = 500;
CREDIT_SHARE_BONUS = 0.1;
HINT_DISPLAY_ENABLE = 1;
HINT_DISPLAY_TIME = 5;
HINT_DISPLAY_FADE_TIME = 1;
CONST_AMMO_ARMOR_START = 250;
CONST_AMMO_ARMOR_JUG_START = 500;
armory_preload()
{
sp_airdrop_preload();
sp_killstreaks_global_preload();
common_scripts\_sentry::main();
level.remotemissile_usethermal	= true;
level.visionThermalDefault = "thermal_mp";
level.VISION_UAV = "thermal_mp";
delete_on_load();
if (!using_wii())
remotemissile_infantry_kills_dialogue_setup();
PrecacheString( &"SO_SURVIVAL_ARMORY_USE_WEAPON" );
PrecacheString( &"SO_SURVIVAL_ARMORY_USE_EQUIPMENT" );
PrecacheString( &"SO_SURVIVAL_ARMORY_USE_AIRSUPPORT" );
PrecacheShader( "specops_ui_equipmentstore" );
PrecacheShader( "specops_ui_weaponstore" );
PrecacheShader( "specops_ui_airsupport" );
PrecacheShader( "specops_ui_deltasupport" );
PrecacheShader( "specops_ui_riotshieldsupport" );
precachemenu( "survival_armory_equipment" );
precachemenu( "survival_armory_airsupport" );
precachemenu( "survival_armory_weapon" );
precachemenu( "survival_armory_replacement_warning" );
add_hint_string( "dpad_right_slot_full", &"SO_SURVIVAL_DPAD_RIGHT_SLOT_FULL" );
for ( i=ARMORY_WEAPON_INDEX_START; i<=ARMORY_WEAPON_INDEX_END; i++ )
{
weapon_string = get_ref_by_index( i );
if( isdefined( weapon_string ) && weapon_string != "" && weapon_string != "ammo" && get_type( weapon_string ) == "weapon" )
Precache_loadout_item( weapon_string );
}
PrecacheItem( "claymore" );
PrecacheItem( "rpg_survival" );
PrecacheItem( "iw5_riotshield_so" );
precacheItem( "air_support_strobe" );
level.air_support_sticky_marker_fx = LoadFx( "smoke/signal_smoke_air_support_pulse" );
precacheModel( "vehicle_ac130_coop_wii" );
precacheModel( "c130_zoomrig" );
level.armory = [];
level.armory_all_items = [];
armory_populate( ARMORY_WEAPONUPGRADE_INDEX_START, ARMORY_WEAPONUPGRADE_INDEX_END, "weaponupgrade" );
armory_populate( ARMORY_WEAPON_INDEX_START, ARMORY_WEAPON_INDEX_END, "weapon" );
armory_populate( ARMORY_EQUIPMENT_INDEX_START, ARMORY_EQUIPMENT_INDEX_END, "equipment" );
armory_populate( ARMORY_AIRSUPPORT_INDEX_START, ARMORY_AIRSUPPORT_INDEX_END,	"airsupport" );
}
armory_postload()
{
sp_killstreaks_init();
level.airdropCrateUseTime = 0;
level.airdropCrateTimeout = 60;
level.airdropCrateUnstuck = true;
add_sp_killstreak( "carepackage" );
add_sp_killstreak( "remote_missile" );
add_sp_killstreak( "sentry" );
add_sp_killstreak( "sentry_gl" );
add_sp_killstreak( "specialty_longersprint" );
add_sp_killstreak( "specialty_fastreload" );
add_sp_killstreak( "specialty_quickdraw" );
add_sp_killstreak( "specialty_detectexplosive" );
add_sp_killstreak( "specialty_bulletaccuracy" );
add_sp_killstreak( "specialty_stalker" );
if ( !using_wii() )
{
maps\_remotemissile::init();
level thread remotemissile_uav();
level thread remotemissile_infantry_kills_dialogue();
}
level.claymoreSentientFunc = ::claymoreSentientFunc;
maps\_air_support_strobe::main();
ac130_traverse();
}
ac130_traverse()
{
level.ac130_Speed[ "move" ] = 250;
level.ac130_Speed[ "rotate" ] = 70;
level.strobe_no_vis_check = true;
level.strobe_no_badplace = true;
minimapOrigins = getEntArray( "minimap_corner", "targetname" );
ac130Origin = (0,0,0);
if ( miniMapOrigins.size )
ac130Origin = findBoxCenter( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
level.ac130 = spawn( "script_model", ac130Origin );
level.ac130 setModel( "c130_zoomrig" );
level.ac130.angles = ( 0, 115, 0 );
level.ac130 hide();
level thread rotatePlane();
level thread ac130_spawn();
}
findBoxCenter( mins, maxs )
{
center = ( 0, 0, 0 );
center = maxs - mins;
center = ( center[0]/2, center[1]/2, center[2]/2 ) + mins;
return center;
}
rotatePlane()
{
level notify("stop_rotatePlane_thread");
level endon("stop_rotatePlane_thread");
rampupDegrees = 10;
rotateTime = ( level.ac130_Speed[ "rotate" ] / 360 ) * rampupDegrees;
level.ac130 rotateyaw( level.ac130.angles[ 2 ] + rampupDegrees, rotateTime, rotateTime, 0 );
for (;;)
{
level.ac130 rotateyaw( 360, level.ac130_Speed[ "rotate" ] );
wait level.ac130_Speed[ "rotate" ];
}
}
CONST_ORBIT_RADIUS = 3000;
CONST_ORBIT_HEIGHT = 4500;
ac130_spawn()
{
wait 0.07;
ac130model = spawn( "script_model", level.ac130 getTagOrigin( "tag_origin" ) + ( 0, CONST_ORBIT_RADIUS, CONST_ORBIT_HEIGHT ) );
ac130model setModel( "vehicle_ac130_coop_wii" );
ac130model setCanDamage( false );
ac130model.health = 1000;
ac130model linkTo( level.ac130, "tag_origin", ( 0, CONST_ORBIT_RADIUS, CONST_ORBIT_HEIGHT ), ( 0, 180, -20 ) );
level.ac130.planeModel = ac130model;
level.ac130.planeModel hide();
wait 0.07;
level.ac130.planeModel show();
maps\_air_support_strobe::set_aircraft( level.ac130.planeModel );
}
armory_init()
{
armory_weapon = armory_setup( "weapon", "specops_ui_weaponstore", &"SO_SURVIVAL_ARMORY_USE_WEAPON" );
armory_equipment = armory_setup( "equipment", "specops_ui_equipmentstore",&"SO_SURVIVAL_ARMORY_USE_EQUIPMENT" );
armory_airsupport = armory_setup( "airsupport", "specops_ui_airsupport", &"SO_SURVIVAL_ARMORY_USE_AIRSUPPORT" );
level thread armory_usage_think( armory_weapon );
level thread armory_usage_think( armory_equipment );
level thread armory_usage_think( armory_airsupport );
foreach ( player in level.players )
{
player thread track_ownership();
player thread sentry_setup();
}
}
armory_populate( index_start, index_end, armory_type )
{
for ( i = index_start; i <= index_end; i++ )
{
ref = get_ref_by_index( i );
if ( !isdefined( ref ) || ref == "" )
continue;
item = spawnstruct();
item.idx = i;
item.ref = ref;
item.type = armory_type;
item.sub_type = get_sub_type( ref );
item.name = get_name( ref );
item.desc = get_desc( ref );
item.cost = get_cost( ref );
item.icon = get_icon( ref );
item.unlockrank = get_unlock_rank( ref );
item.func_can_give	= get_func_can_give( armory_type, ref );
item.func_give = get_func_give( armory_type, ref );
if ( armory_type == "weaponupgrade" )
item.slot = get_slot( ref );
if ( armory_type == "weapon" && ref != "ammo" )
{
item.maxstock = 1;
item.upgrades = get_upgrades_possible( ref );
item.dropclip = get_item_drop_clip( ref );
item.dropstock = get_item_drop_stock( ref );
}
else
{
item.enabled	= is_item_enabled( ref );
item.maxstock = get_maxstock( ref );
}
level.armory[ armory_type ][ ref ] = item;
level.armory_all_items[ ref ] = item;
}
}
armory_setup( armory_type, icon, useHint, menu )
{
armory = getent( "armory_" + armory_type, "targetname" );
if ( !isdefined( armory ) )
return;
armory.armory_type	= armory_type;
armory.icon = icon;
armory.useHint = useHint;
armory.menu = "survival_armory_" + armory_type;
assertex( isdefined( armory ), "ent with targetname: armory_"+armory_type+" does not exist in level." );
armory.laptop_locked= getent( armory.target, "targetname" );
armory.laptop = getent( armory.laptop_locked.target, "targetname" );
armory.laptop hide();
armory thread armory_use_monitor();
return armory;
}
armory_setup_players()
{
foreach ( armory in level.armory )
{
foreach ( item in armory )
{
foreach ( player in level.players )
{
item_type = item.type;
item_ref = item.ref;
ownership	= player get_ownership_val( item.ref );
player set_ownership( item_type, item_ref, ownership );
}
}
}
}
get_ownership_val( ref )
{
assertex( isdefined( self ) && isplayer( self ), "get_ownership_val() requires self be player." );
assertex( isdefined( level.armory_all_items ) && isdefined( level.armory_all_items[ ref ] ), "Ref: " + ref + " does not exist in master armory list." );
val = self armory_can_give( ref );
if ( val == 0 )
return 1;
else if ( val == 2 )
return 2;
else
return 0;
}
armory_use_monitor()
{
level endon( "special_op_terminated" );
self waittill_armory_unlocked();
self.laptop show();
self.laptop_locked hide();
worldIcon = NewHudElem();
worldIcon.archived = true;
worldIcon.x = self.origin[0];
worldIcon.y = self.origin[1];
worldIcon.z = self.origin[2];
worldIcon.alpha = 0.75;
worldIcon SetShader( self.icon, 12, 12 );
worldIcon SetWaypoint( true, true, false );
self.crateWorldIcon = worldIcon;
self setHintString( self.useHint );
self makeUsable();
level notify( "armory_open", self );
while ( 1 )
{
self waittill( "trigger", player );
if ( !isplayer( player ) )
continue;
wait 0.1;
if ( !player UseButtonPressed() )
continue;
self notify( "armory_use", player );
}
}
waittill_armory_unlocked()
{
level endon( "special_op_terminated" );
while ( 1 )
{
level waittill( "wave_ended", wave_num );
assertex( isdefined( level.armory_unlock ),"level.armory_unlock is not yet built or failed to build correctly");
assertex( isdefined( level.armory_unlock[ self.armory_type ] ),"Armory: " + self.armory_type + " failed to build into level.armory array");
if ( level.armory_unlock[ self.armory_type ] == wave_num )
return;
}
}
waittill_armory_warning_respond( warning_menu )
{
level endon( "special_op_terminated" );
self endon( "armory_closed" );
self endon( "armory_interrupted" );
self endon( "dog_attacks_player" );
while ( 1 )
{
self waittill( "menuresponse", menu, response );
if ( menu != warning_menu )
continue;
else
break;
}
return response;
}
waittill_armory_respond()
{
level endon( "special_op_terminated" );
self endon( "armory_closed" );
self endon( "armory_interrupted" );
self endon( "dog_attacks_player" );
self waittill( "menuresponse", menu, response );
return response;
}
armory_downed_interrupt()
{
level endon( "special_op_terminated" );
self endon( "armory_closed" );
self endon( "dog_attacks_player" );
while ( 1 )
{
self waittill( "player_downed" );
self notify( "armory_interrupted" );
}
}
armory_usage_think( armory )
{
level endon( "special_op_terminated" );
if ( !isdefined( armory ) )
return;
foreach( player in level.players )
player.using_armory = false;
while ( 1 )
{
armory waittill( "armory_use", user );
if ( !user.using_armory )
user thread armory_user_thread( armory );
}
}
armory_user_thread( armory )
{
level endon( "special_op_terminated" );
self endon( "death" );
self thread armory_downed_interrupt();
if ( !isdefined( self ) || !isplayer( self ) || !isalive( self ) )
return;
if ( armory.armory_type == "airsupport" && !self has_open_slot_right() )
{
self display_hint( "dpad_right_slot_full" );
return;
}
self notify( "armory_opened", armory );
self.using_armory = true;
armory_menu = armory.menu;
self openpopupmenu( armory.menu );
self freezecontrols( true );
while ( 1 )
{
response = self waittill_armory_respond();
if ( !isdefined( response ) )
{
self close_armory_interface();
break;
}
assertex( response != "bad", "A bad response from menu: " + armory.menu );
if ( response == "quit" )
{
self.selected_weapon = undefined;
self close_armory_interface();
break;
}
if ( response == "share" )
{
if ( self.survival_credit == 0 )
continue;
increment = CREDIT_SHARE_INCREMENT;
if ( self.survival_credit < CREDIT_SHARE_INCREMENT )
increment = self.survival_credit;
foreach( player in level.players )
{
if ( player == self )
player.survival_credit -= increment;
if ( player != self )
player.survival_credit += increment;
donation = true;
player notify( "credit_updated", donation );
}
}
if ( issubstr( response, "weaponswitch" ) )
{
weapon_index = strtok( response, "_" )[1];
weapon_chosen	= get_ref_by_index( weapon_index );
if ( !isdefined( weapon_chosen ) || weapon_chosen == "" )
{
assertmsg( "Menu gave invalid weaponswitch index:" + weapon_index );
continue;
}
weapons_player	= self GetWeaponsListPrimaries();
foreach( weapon in weapons_player )
{
if ( weaponclass( weapon ) == "rocketlauncher"
|| weaponclass( weapon ) == "item"
|| weaponclass( weapon ) == "none"
)
{
continue;
}
if ( get_weapon_base_name( weapon ) == weapon_chosen )
{
self.selected_weapon = weapon;
self notify( "new_weapon_selected" );
break;
}
}
}
if ( issubstr( response, "purchase" ) )
{
item_index = strtok( response, "_" )[1];
item_ref = get_ref_by_index( item_index );
assertex( isdefined( item_ref ) && item_ref != "", "Item reference not found!");
item_cost = get_cost( item_ref );
reopen_menu = false;
if ( ( item_ref == "rpg_survival" || item_ref == "iw5_riotshield_so" )
&& !self hasweapon( item_ref )
&& isdefined( self get_replaceable_weapon() )
)
{
self openpopupmenu( "survival_armory_replacement_warning" );
response = self waittill_armory_warning_respond( "survival_armory_replacement_warning" );
if ( !isdefined( response ) || response != "continue" )
{
self close_armory_interface();
self thread armory_user_thread( armory );
return;
}
else
{
reopen_menu = true;
}
}
if ( self.survival_credit >= item_cost )
{
if ( self armory_can_give( item_ref ) )
{
self notify( "armory_opened", armory );
self armory_give( item_ref );
if ( get_sub_type( item_ref ) == "sniper" )
{
self.selected_weapon = item_ref;
self give_weapon_upgrade( strtok( item_ref, "_" )[1] +"scope" );
}
self.survival_credit -= item_cost;
self notify( "credit_updated" );
purchase_item_type = get_type( item_ref);
assertex( isdefined( purchase_item_type ), "Item type is invalid." );
if ( purchase_item_type == "weapon" ||	purchase_item_type == "weaponupgrade" )
{
self so_achievement_update( "ARMS_DEALER", item_ref );
}
if ( get_sub_type( item_ref ) == "sniper" )
{
self so_achievement_update( "ARMS_DEALER", strtok( item_ref, "_" )[1] +"scope" );
}
if ( purchase_item_type == "airsupport" )
{
self so_achievement_update( "DANGER_ZONE", item_ref );
}
if ( purchase_item_type == "equipment" )
{
self so_achievement_update( "DEFENSE_SPENDING", item_ref );
}
}
}
if ( reopen_menu )
{
self close_armory_interface();
self thread armory_user_thread( armory );
return;
}
if ( armory.armory_type == "airsupport"	)
{
self close_armory_interface();
break;
}
}
}
}
close_armory_interface()
{
self closepopupmenu();
self freezecontrols( false );
self notify( "armory_closed" );
self.using_armory = false;
}
create_player_pip()
{
if ( !isdefined( self.pip ) )
self.pip = self newpip();
self.pip.entity = spawn ( "script_model", self.origin );
self.pip.entity setmodel ( "tag_origin" );
wait 0.05;
self.pip.tag = "tag_origin";
self.pip.fov = 65;
self.pip.freeCamera = true;
self.pip.enableshadows = false;
self.pip.x = -40;
self.pip.y = 310;
self.pip.width = 240;
self.pip.height = 135;
self.pip.enable = false;
}
sentry_setup()
{
level endon( "special_op_terminated" );
self	endon( "death" );
while ( 1 )
{
self waittill( "new_sentry", sentry_turret );
sentry_turret setthreatbiasgroup( "sentry" );
if ( WeaponType( sentry_turret.weaponName ) == "projectile" )
sentry_turret setConvergenceHeightPercent( 0 );
else
sentry_turret setConvergenceHeightPercent( 0.7 );
}
}
sentry_pip_cam( sentry )
{
self endon( "death" );
sentry endon( "death" );
self thread death_pip_disable( sentry );
while ( 1 )
{
self link_pip_cam_to( sentry );
self setup_pip_name( sentry );
if ( !self.pip.enable )
self.pip.enable = true;
sentry waittill( "sentry_move_started" );
self.pip.entity unlink();
if ( self.pip.enable )
self.pip.enable = false;
if ( isdefined( self.pip_display_name ) )
self.pip_display_name destroy();
sentry waittill( "sentry_move_finished" );
}
}
cycle_sentry_pip()
{
self endon( "death" );
self NotifyOnPlayerCommand( "pip_cycle", "+actionslot 2" );
if ( !isdefined( self.pip_sentry_id ) )
self.pip_sentry_id = 0;
while( 1 )
{
self waittill( "pip_cycle" );
if ( isdefined( level.placed_sentry ) && level.placed_sentry.size )
{
assertex( isdefined( self.pip ), "Player's PIP is not initialized before cycling PIP" );
if ( self.pip_sentry_id > level.placed_sentry.size - 1 )
self.pip_sentry_id = 0;
self pip_patch_into( self.pip_sentry_id );
self.pip_sentry_id++;
}
}
}
death_pip_disable( sentry )
{
self endon( "death" );
sentry waittill( "death" );
if ( self.pip.enable )
self.pip.enable = false;
self.pip_display_name destroy();
}
pip_patch_into( id )
{
sentry = level.placed_sentry[ id ];
if ( !isdefined( sentry ) )
return;
if ( self.pip.enable )
self.pip.enable = false;
self link_pip_cam_to( sentry );
self setup_pip_name( self );
if ( !self.pip.enable )
self.pip.enable = true;
self.pip.display_id = id;
}
setup_pip_name( sentry )
{
if ( isdefined( self.pip_display_name ) )
self.pip_display_name destroy();
self.pip_display_name = NewHudElem();
self.pip_display_name.alpha = 1;
self.pip_display_name.x = self.pip.x;
self.pip_display_name.y = self.pip.y - 20;
self.pip_display_name.hidewheninmenu = false;
self.pip_display_name.hidewhendead = true;
self.pip_display_name.fontscale = 1.25;
if ( !isdefined( self.pip.display_id ) )
self.pip.display_id = 0;
self.pip_display_name.label = "Sentry #" + self.pip.display_id + " [Dpad down to cycle]";
}
link_pip_cam_to( sentry )
{
translate = ( -12 * vectornormalize( anglestoforward( sentry.angles ) ) );
attach_loc = sentry GetTagOrigin( "mg01" ) + ( 0, 0, 12 ) + translate;
self.pip.entity unlink();
self.pip.entity.origin = attach_loc;
self.pip.entity.angles = sentry.angles;
self.pip.entity linkto( sentry, "mg01" );
}
get_total_sentries()
{
total_sentries = 0;
if ( isdefined( level.placed_sentry ) && level.placed_sentry.size )
{
total_sentries += level.placed_sentry.size;
}
foreach( player in level.players )
{
if ( player maps\_sp_killstreaks::has_killstreak( "sentry" ) )
total_sentries++;
if ( player maps\_sp_killstreaks::has_killstreak( "sentry_gl" ) )
total_sentries++;
}
return total_sentries;
}
has_sentry()
{
if ( self maps\_sp_killstreaks::has_killstreak( "sentry" ) )
return true;
if ( self maps\_sp_killstreaks::has_killstreak( "sentry_gl" ) )
return true;
foreach( sentry in level.placed_sentry )
{
if ( isdefined( sentry )
&& isdefined( sentry.attacker )
&& isplayer( sentry.attacker )
&& sentry.attacker == self
)
{
return true;
}
}
return false;
}
track_ownership()
{
self endon( "death" );
wait 0.05;
while( 1 )
{
self waittill( "armory_opened", armory );
while ( 1 )
{
foreach ( item in level.armory[ armory.armory_type ] )
{
ownership = self get_ownership_val( item.ref );
self set_ownership( item.type, item.ref, ownership );
}
if ( armory.armory_type == "weapon" )
{
foreach ( item in level.armory[ "weaponupgrade" ] )
{
ownership = self get_ownership_val( item.ref );
self set_ownership( item.type, item.ref, ownership );
}
}
msg = self waittill_any_timeout( 0.05, "armory_closed", "new_weapon_selected" );
if ( msg == "armory_closed" )
break;
}
}
}
set_ownership( item_type, item_ref, ownership )
{
self _setplayerdata_array( "armory" + item_type, item_ref, ownership );
}
claymoreSentientFunc( team )
{
self MakeEntitySentient( team, true );
self.attackerAccuracy = 2;
self.maxVisibleDist = 356;
self.threatBias = -1000;
self.detonateRadius = 96;
}
has_open_slot_right()
{
override = self GetWeaponHudIconOverride( "actionslot4" );
if ( isdefined( override ) && override != "none" )
return false;
if ( self hasweapon( "air_support_strobe" ) )
return false;
return !self maps\_sp_killstreaks::has_any_killstreak();
}
hint_bubble()
{
}
item_exist( ref )
{
return isdefined( level.armory_all_items ) && isdefined( level.armory_all_items[ ref ] );
}
get_index( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].idx;
return int( tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_INDEX ) );
}
get_ref_by_index( idx )
{
return tablelookup( ARMORY_TABLE, TABLE_INDEX, idx, TABLE_REF );
}
get_icon( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].icon;
return tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_ICON );
}
get_slot( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].slot;
return tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_TYPE );
}
get_type( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].type;
return tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_TYPE );
}
get_sub_type( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].sub_type;
return tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_SUBTYPE );
}
get_maxstock( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].maxstock;
return int( tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_STOCK_MAX_IN_PLAY ) );
}
get_upgrades_possible( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].upgrades;
upgrade_array = tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_WEAPONUPGRADE );
upgrade_array = strtok( upgrade_array, " " );
return upgrade_array;
}
get_name( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].name;
return tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_NAME );
}
get_desc( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].desc;
return tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_DESC );
}
get_cost( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].cost;
return int( tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_COST ) );
}
get_unlock_rank( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].unlockrank;
return int( tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_UNLOCK ) );
}
is_item_enabled( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].enabled;
excluded = tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_EXCLUDE );
if ( !isdefined( excluded ) || excluded == "" )
return true;
if ( !issubstr( excluded, level.script ) )
return true;
return false;
}
get_item_drop_stock( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].dropstock;
return int( strtok( tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_WEAPONDROPAMMO ), " " )[ 1 ] );
}
get_item_drop_clip( ref )
{
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].dropclip;
return int( strtok( tablelookup( ARMORY_TABLE, TABLE_REF, ref, TABLE_WEAPONDROPAMMO ), " " )[ 0 ] );
}
armory_can_give( ref )
{
assert( isdefined( self ) && isplayer( self ), "Armory can give check needs player as self" );
assert( isdefined( level.armory_all_items ) && level.armory_all_items.size, "Armory can give check called with master armory items array undefined." );
armory_item = level.armory_all_items[ ref ];
if ( !isdefined( armory_item ) )
return false;
return self [[ armory_item.func_can_give ]]( ref );
}
armory_give( ref )
{
assert( isdefined( self ) && isplayer( self ), "Armory give call needs player as self" );
assert( isdefined( level.armory_all_items ) && level.armory_all_items.size, "Armory give call used with master armory items array undefined." );
armory_item = level.armory_all_items[ ref ];
self [[ armory_item.func_give ]]( ref );
}
get_func_can_give( armory_type, ref )
{
AssertEx( IsDefined( armory_type ), "The armory type must be defined." );
AssertEx( IsDefined( ref ), "The item ref name must be defined." );
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].func_can_give;
func_can_give = ::can_give_default;
if ( armory_type == "weapon" )
{
if ( ref == "ammo" )
{
func_can_give = ::can_give_ammo;
}
else
{
func_can_give = ::can_give_weapon;
}
}
else if ( armory_type == "weaponupgrade" )
{
func_can_give = ::can_give_weapon_upgrade;
}
else if ( armory_type == "equipment" )
{
switch ( ref )
{
case "fraggrenade":
case "flash_grenade":
func_can_give = ::can_give_grenade;
break;
case "c4":
case "claymore":
func_can_give = ::can_give_slotted_explosive;
break;
case "rpg_survival":
func_can_give = ::can_give_launcher;
break;
case "iw5_riotshield_so":
case "iw5_riotshield_so_upgrade":
func_can_give = ::can_give_riotshield_so;
break;
case "sentry":
case "sentry_gl":
func_can_give = ::can_give_sentry;
break;
case "armor":
case "juggernaut_suit":
func_can_give = ::can_give_armor;
break;
case "laststand":
func_can_give = ::can_give_laststand;
break;
default:
AssertMsg( "Unhandled Equipment Item Ref Name: " + ref + " passed with armory type: " + armory_type );
break;
}
}
else if ( armory_type == "airsupport" )
{
switch ( ref )
{
case "remote_missile":
func_can_give = ::can_give_remote_missile;
break;
case "friendly_support_delta":
case "friendly_support_riotshield":
func_can_give = ::can_give_friendlies;
break;
case "precision_airstrike":
func_can_give = ::can_give_airstrike;
break;
case "assault_chopper":
case "manned_chopper":
func_can_give = ::can_give_chopper;
break;
case "specialty_longersprint":
case "specialty_fastreload":
case "specialty_quickdraw":
case "specialty_detectexplosive":
case "specialty_bulletaccuracy":
case "specialty_stalker":
func_can_give = ::can_give_perk_care_package;
break;
default:
AssertMsg( "Unhandled Air Support Item Ref Name: " + ref + " passed with armory type: " + armory_type );
break;
}
}
else
{
AssertMsg( "Invalid armory type of: " + armory_type );
}
AssertEx( func_can_give != ::can_give_default, "Armory: " + armory_type + " Item: " + ref + " failed to get a propper can_give() function." );
return func_can_give;
}
get_func_give( armory_type, ref )
{
AssertEx( IsDefined( armory_type ), "The armory type must be defined." );
AssertEx( IsDefined( ref ), "The item ref name must be defined." );
if ( item_exist( ref ) )
return level.armory_all_items[ ref ].func_give;
func_give = ::give_default;
if ( armory_type == "weapon" )
{
if ( ref == "ammo" )
{
func_give = ::give_ammo;
}
else
{
func_give = ::give_weapon;
}
}
else if ( armory_type == "weaponupgrade" )
{
func_give = ::give_weapon_upgrade;
}
else if ( armory_type == "equipment" )
{
switch ( ref )
{
case "fraggrenade":
case "flash_grenade":
func_give = ::give_grenade;
break;
case "c4":
case "claymore":
func_give = ::give_slotted_explosive;
break;
case "rpg_survival":
func_give = ::give_launcher;
break;
case "iw5_riotshield_so":
case "iw5_riotshield_so_upgrade":
func_give = ::give_riotshield_so;
break;
case "sentry":
case "sentry_gl":
func_give = ::give_sentry;
break;
case "armor":
case "juggernaut_suit":
func_give = ::give_armor;
break;
case "laststand":
func_give = ::give_laststand;
break;
default:
AssertMsg( "Unhandled Equipment Item Ref Name: " + ref + " passed with armory type: " + armory_type );
break;
}
}
else if ( armory_type == "airsupport" )
{
switch ( ref )
{
case "remote_missile":
func_give = ::give_remote_missile;
break;
case "friendly_support_delta":
case "friendly_support_riotshield":
func_give = ::give_friendlies;
break;
case "precision_airstrike":
func_give = ::give_airstrike;
break;
case "assault_chopper":
case "manned_chopper":
func_give = ::give_chopper;
break;
case "specialty_longersprint":
case "specialty_fastreload":
case "specialty_quickdraw":
case "specialty_detectexplosive":
case "specialty_bulletaccuracy":
case "specialty_stalker":
func_give = ::give_perk_care_package;
break;
default:
AssertMsg( "Unhandled Air Support Item Ref Name: " + ref + " passed with armory type: " + armory_type );
break;
}
}
else
{
AssertMsg( "Invalid armory type of: " + armory_type );
}
AssertEx( func_give != ::give_default, "Armory: " + armory_type + " Item: " + ref + " failed to get a propper give() function." );
return func_give;
}
can_give_default( ref )
{
return false;
}
give_default( ref )
{
return;
}
can_give_ammo( ref )
{
primary_weapons = self GetWeaponsListPrimaries();
foreach ( weapon in primary_weapons )
{
if ( weaponclass( weapon ) == "rocketlauncher"
|| weaponclass( weapon ) == "item"
|| weaponclass( weapon ) == "none"
)
{
continue;
}
if	(
self GetWeaponAmmoClip( weapon ) < WeaponClipSize( weapon )
||	self GetWeaponAmmoStock( weapon ) < WeaponMaxAmmo( weapon )
)
{
return true;
}
alt_weapon = WeaponAltWeaponName( weapon );
if	(
alt_weapon != "none"
&&	self GetWeaponAmmoClip( alt_weapon ) < WeaponClipSize( alt_weapon )
||	self GetWeaponAmmoStock( alt_weapon ) < WeaponMaxAmmo( alt_weapon )
)
{
return true;
}
}
return false;
}
give_ammo( ref )
{
primary_weapons = self GetWeaponsListPrimaries();
foreach ( weapon in primary_weapons )
{
if ( weapon == "rpg_survival" )
continue;
self give_ammo_max( weapon );
}
}
give_ammo_max( weapon )
{
if ( WeaponInventoryType( weapon ) == "altmode" )
{
weapon = get_weapon_name_from_alt( weapon );
}
self SetWeaponAmmoClip( weapon, WeaponClipSize( weapon ) );
self SetWeaponAmmoStock( weapon, WeaponMaxAmmo( weapon ) );
alt_weapon = WeaponAltWeaponName( weapon );
if ( alt_weapon != "none" )
{
self SetWeaponAmmoClip( alt_weapon, WeaponClipSize( alt_weapon ) );
self SetWeaponAmmoStock( alt_weapon, WeaponMaxAmmo( alt_weapon ) );
}
}
can_give_weapon( ref )
{
ref_class = WeaponClass( ref );
has_ref_class = false;
primary_weapons = self GetWeaponsListPrimaries();
foreach ( weapon in primary_weapons )
{
if ( WeaponClass( weapon ) == ref_class )
{
has_ref_class = true;
break;
}
}
if ( has_ref_class == false )
{
return true;
}
ref_base_name = get_weapon_base_name( ref );
foreach ( weapon in primary_weapons )
{
if ( weaponclass( weapon ) == "rocketlauncher"
|| weaponclass( weapon ) == "item"
|| weaponclass( weapon ) == "none"
)
continue;
weapon_base_name = get_weapon_base_name( weapon );
if ( weapon_base_name == ref_base_name )
{
return false;
}
}
return true;
}
give_weapon( ref, default_ammo )
{
replaceable_weapon = self get_replaceable_weapon();
if ( isdefined( replaceable_weapon ) )
self takeweapon( replaceable_weapon );
self GiveWeapon( ref );
if ( !isdefined( default_ammo ) )
self give_ammo_max( ref );
self SwitchToWeapon( ref );
}
get_replaceable_weapon()
{
primary_weapons = self GetWeaponsListPrimaries();
if ( primary_weapons.size > 1 )
{
current_weapon = self GetCurrentWeapon();
if ( WeaponInventoryType( current_weapon ) == "altmode" )
{
current_weapon = get_weapon_name_from_alt( current_weapon );
}
if ( IsDefined( current_weapon ) && WeaponInventoryType( current_weapon ) == "primary" )
{
return current_weapon;
}
else
{
weapon_list = self GetWeaponsList( "primary" );
foreach ( weapon in weapon_list )
{
if ( WeaponClass( weapon ) != "item" )
return weapon;
}
}
}
return undefined;
}
can_give_weapon_upgrade( ref )
{
weapon = undefined;
if ( isdefined( self.selected_weapon ) )
weapon = self.selected_weapon;
else
weapon = self GetCurrentWeapon();
if ( WeaponInventoryType( weapon ) == "altmode" )
{
weapon = get_weapon_name_from_alt( weapon );
}
if ( !IsDefined( weapon )
|| weapon == "none"
|| WeaponInventoryType( weapon ) != "primary"
|| weaponclass( weapon ) == "item"
|| weaponclass( weapon ) == "rocketlauncher"
|| weaponclass( weapon ) == "none"
)
{
return 0;
}
weapon_base_name	= get_weapon_base_name( weapon );
valid_upgrades = get_upgrades_possible( weapon_base_name );
if ( !IsDefined(valid_upgrades) || !valid_upgrades.size )
return 0;
valid = false;
foreach ( upgrade in valid_upgrades )
{
if ( ref == upgrade )
{
valid = true;
break;
}
}
if ( !valid )
return 0;
current_upgrades = get_upgrades_on_weapon( weapon );
foreach ( upgrade in current_upgrades )
{
if ( ref == upgrade )
{
return 2;
}
}
return 1;
}
give_weapon_upgrade( ref )
{
weapon = self GetCurrentWeapon();
if ( isdefined( self.selected_weapon ) )
weapon = self.selected_weapon;
if ( WeaponInventoryType( weapon ) == "altmode" )
{
weapon = get_weapon_name_from_alt( weapon );
}
if ( !IsDefined( weapon ) || WeaponInventoryType( weapon ) != "primary" )
{
return;
}
current_upgrades = get_upgrades_on_weapon( weapon );
upgrade_to_replace	= undefined;
new_upgrade_slot = get_slot( ref );
if ( current_upgrades.size )
{
foreach ( upgrade in current_upgrades )
{
if ( new_upgrade_slot == get_slot( upgrade ) )
{
upgrade_to_replace = upgrade;
break;
}
}
}
if ( isdefined( upgrade_to_replace ) )
{
foreach ( idx, upgrade in current_upgrades )
{
if ( upgrade == upgrade_to_replace )
{
current_upgrades[ idx ] = ref;
break;
}
}
}
else
{
current_upgrades[ current_upgrades.size ] = ref;
}
weapon_base = get_weapon_base_name( weapon );
weapon_new	= weapon_base;
while( current_upgrades.size > 0 )
{
upgrade_next = current_upgrades[ 0 ];
for ( i = 1; i < current_upgrades.size; i++ )
{
if ( is_later_in_alphabet( upgrade_next, current_upgrades[ i ] ) )
upgrade_next = current_upgrades[ i ];
}
weapon_new += "_" + get_attachment_fullname( upgrade_next, weapon_base );
current_upgrades = array_remove( current_upgrades, upgrade_next );
}
main_ammo_clip	= self GetWeaponAmmoClip( weapon );
main_ammo_stock	= self GetWeaponAmmoStock( weapon );
alt_ammo_clip	= undefined;
alt_ammo_stock	= undefined;
weapon_alt = WeaponAltWeaponName( weapon );
if ( weapon_alt != "none" )
{
alt_ammo_clip	= self GetWeaponAmmoClip( weapon_alt );
alt_ammo_stock	= self GetWeaponAmmoStock( weapon_alt );
}
self TakeWeapon( weapon );
self GiveWeapon( weapon_new );
self SetWeaponAmmoClip( weapon_new, main_ammo_clip );
self SetWeaponAmmoStock( weapon_new, main_ammo_stock );
weapon_new_alt = WeaponAltWeaponName( weapon_new );
if ( weapon_new_alt != "none" )
{
if ( new_upgrade_slot != "main" )
{
self SetWeaponAmmoClip( weapon_new_alt, alt_ammo_clip );
self SetWeaponAmmoStock( weapon_new_alt, alt_ammo_stock );
}
else
{
self SetWeaponAmmoClip( weapon_new_alt, WeaponClipSize( weapon_new_alt ) );
self SetWeaponAmmoStock( weapon_new_alt, WeaponMaxAmmo( weapon_new_alt ) );
}
}
maps\_so_survival::weapon_collect_record_weapon_adjusted( weapon_new );
self SwitchToWeapon( weapon_new );
}
get_attachment_fullname( attachmentName, weaponName )
{
weapon_sub_type = get_sub_type( weaponName );
switch( weapon_sub_type )
{
case "smg":
if ( attachmentName == "reflex" )
return "reflexsmg";
else if ( attachmentName == "eotech" )
return "eotechsmg";
else if ( attachmentName == "acog" )
return "acogsmg";
else if ( attachmentName == "thermal" )
return "thermalsmg";
case "lmg":
if ( attachmentName == "reflex" )
return "reflexlmg";
else if ( attachmentName == "eotech" )
return "eotechlmg";
case "machinepistol":
if ( attachmentName == "reflex" )
return "reflexsmg";
else if ( attachmentName == "eotech" )
return "eotechsmg";
default:
return attachmentName;
}
}
get_attachment_basename( attachmentName )
{
if ( issubstr( attachmentName, "reflex" ) )
return "reflex";
if ( issubstr( attachmentName, "eotech" ) )
return "eotech";
if ( issubstr( attachmentName, "acog" ) )
return "acog";
if ( issubstr( attachmentName, "reflex" ) )
return "reflex";
return attachmentName;
}
get_weapon_base_name( weapon )
{
if (weapon=="rpg_survival")
return weapon;
base_name = undefined;
name_start_index = 0;
name_end_index = undefined;
if ( WeaponInventoryType( weapon ) == "altmode" )
{
name_start_index = 4;
}
for( i = name_start_index + 4; i < weapon.size; i++ )
{
if ( weapon[ i ] == "_" )
{
name_end_index = i + 3;
break;
}
}
Assert( IsDefined( name_end_index ) && name_end_index <= weapon.size, "Name end index undefined or out of bounds." );
base_name = GetSubStr( weapon, name_start_index, name_end_index );
AssertEx( WeaponClass( base_name ) != "none", "Invalid base weapon name created: " + base_name );
return base_name;
}
get_upgrades_on_weapon( weapon )
{
current_upgrades = [];
weapon_base_name = get_weapon_base_name( weapon );
if ( weapon_base_name == weapon )
{
return current_upgrades;
}
upgrade_string = GetSubStr( weapon, weapon_base_name.size );
upgrade_array = StrTok( upgrade_string, "_" );
for( i = 0; i < upgrade_array.size; i ++ )
{
upgrade_array[ i ] = get_attachment_basename( upgrade_array[ i ] );
}
return upgrade_array;
}
get_weapon_name_from_alt( weapon )
{
if ( WeaponInventoryType( weapon ) != "altmode" )
{
assertmsg( "Get weapon name from alt called on non alt weapon." );
return weapon;
}
return GetSubStr( weapon, 4 );
}
can_give_grenade( ref )
{
max_carry = get_maxstock( ref );
return self GetWeaponAmmoStock( ref ) < max_carry;
}
give_grenade( ref )
{
if ( !self hasweapon( ref ) )
self giveweapon( ref );
if ( issubstr( ref, "flash" ) && self GetOffhandPrimaryClass() != "flash" )
{
self setOffhandSecondaryClass( "flash" );
}
max_carry = get_maxstock( ref );
self setweaponammostock( ref, max_carry );
}
can_give_launcher( ref )
{
if ( self HasWeapon( ref ) )
{
if ( ref == "rpg_survival" )
{
total = self getweaponammoclip( "rpg_survival" ) + self getweaponammostock( "rpg_survival" );
return ( get_maxstock( "rpg_survival" ) > total );
}
}
return true;
}
can_give_slotted_explosive( ref )
{
if ( self HasWeapon( ref ) )
{
if ( ref == "claymore" )
{
total = self getweaponammoclip( ref ) + self getweaponammostock( ref );
return ( get_maxstock( ref ) != total );
}
if ( ref == "c4" )
{
total = self getweaponammostock( ref );
return ( get_maxstock( ref ) != total );
}
}
return true;
}
give_launcher( ref )
{
if ( !self HasWeapon( ref ) )
{
if ( ref == "rpg_survival" )
{
self give_weapon( "rpg_survival", true );
self SetWeaponAmmoclip( "rpg_survival", 1 );
self SetWeaponAmmoStock( "rpg_survival", 1 );
}
}
else
{
if ( ref == "rpg_survival" )
{
total = self getweaponammoclip( ref ) + self getweaponammostock( ref );
clip = 1;
stock = int ( min( 1 + total, get_maxstock( ref ) - 1 ) );
self SetWeaponAmmoclip( "rpg_survival", clip );
self SetWeaponAmmoStock( "rpg_survival", stock );
self SwitchToWeapon( "rpg_survival" );
}
}
}
give_slotted_explosive( ref )
{
ammo_added = 5;
ammo_curr = 0;
extra_clip = 0;
slot = 1;
if( !self HasWeapon( ref ) )
{
if ( ref == "claymore" )
{
slot = 1;
extra_clip = 1;
}
else if ( ref == "c4" )
{
slot = 2;
}
self SetPreloadWeapon( ref, 0 );
self GiveWeapon( ref );
self SetActionSlot( slot, "weapon", ref );
}
else
{
ammo_curr = self GetWeaponAmmoStock( ref );
}
if ( ref == "claymore" && self getweaponammoclip( ref ) == 0 )
{
self SetWeaponAmmoclip( ref, 1 );
ammo_added--;
}
self SetWeaponAmmoStock( ref, ammo_curr + ammo_added - extra_clip );
}
can_give_riotshield_so( ref )
{
primary_weapons = self GetWeaponsListPrimaries();
foreach ( weapon in primary_weapons )
{
if ( IsSubStr( weapon, "riotshield" ) )
{
return false;
}
}
return true;
}
give_riotshield_so( ref )
{
self give_weapon( ref, true );
}
can_give_sentry( ref )
{
if ( !self has_open_slot_right() )
{
return false;
}
if ( is_coop() )
return !( self has_sentry() ) && ( get_total_sentries() < 2 );
else
return get_total_sentries() < 2;
}
give_sentry( ref )
{
self thread give_sp_killstreak( ref );
}
can_give_armor( ref )
{
if ( !isdefined( self.armor ) )
return true;
armor_points = 0;
if ( ref == "armor" )
{
armor_points = CONST_AMMO_ARMOR_START;
}
else if ( ref == "juggernaut_suit" )
{
armor_points = CONST_AMMO_ARMOR_JUG_START;
}
if ( self.armor[ "points" ] < armor_points )
{
return true;
}
return false;
}
give_armor( ref )
{
give_armor_amount( ref );
}
armor_init()
{
assertex( isdefined( self ) && isplayer( self ), "Armor init not called on player." );
self.max_armor_points = 0;
self.armor = [];
self.armor[ "type" ] = "";
self.armor[ "points" ]	= 0;
self thread player_armor_shield();
}
give_armor_amount( type, points )
{
AssertEx( isdefined( type ) && ( type == "armor" || type == "juggernaut_suit" ), "Invalid armor type: " + type );
if ( !isdefined( points ) )
{
if ( type == "armor" )
{
points = CONST_AMMO_ARMOR_START;
}
else if ( type == "juggernaut_suit" )
{
points = CONST_AMMO_ARMOR_JUG_START;
}
else
{
return;
}
}
if ( !IsDefined( self.armor ) )
{
self armor_init();
}
self.dogs_dont_instant_kill = true;
self.armor[ "type" ]	= type;
self.armor[ "points" ]	= points;
self.max_armor_points	= points;
self notify( "health_update" );
}
player_armor_shield()
{
self endon( "death" );
assertex( !isdefined( self.armor_shield_on ), "Armor shield turned on more than once." );
if ( isdefined( self.armor_shield_on ) )
{
return;
}
self.armor_shield_on = true;
while ( 1 )
{
self waittill( "damage", damage, attacker, direction, point, type, modelName, tagName, partName, dflags, weaponName );
self.previous_health = int( min( 100, self.health + damage ) );
self.saved_by_armor = false;
if ( self.armor[ "points" ] > 0 )
{
self.saved_by_armor = true;
remaining_armor_points = self.armor[ "points" ] - damage;
damage_penetration = int( max( 0, 0 - remaining_armor_points ) );
if ( !damage_penetration )
{
self.armor[ "points" ] -= damage;
self SetNormalHealth( 1 );
}
else
{
set_health_frac = int_capped( self.previous_health - damage_penetration, 1, 100 ) / 100;
self SetNormalHealth( set_health_frac );
if ( self.armor[ "points" ] + self.previous_health <= damage )
{
self.saved_by_armor = false;
}
self.armor[ "points" ] = 0;
}
if ( self.armor[ "points" ] <= 0 )
{
self.dogs_dont_instant_kill = undefined;
}
self notify( "health_update" );
}
}
}
can_give_laststand( ref )
{
return maps\_laststand::get_lives_remaining() == 0;
}
give_laststand( ref )
{
maps\_laststand::update_lives_remaining( true );
}
can_give_remote_missile( ref )
{
return has_open_slot_right();
}
give_remote_missile( ref )
{
self thread give_sp_killstreak( ref );
}
can_give_friendlies( ref )
{
if ( !self has_open_slot_right() )
{
return false;
}
friendlies = GetAIArray( "allies" );
foreach ( ally in friendlies )
{
if ( IsAlive( ally ) && IsDefined( ally.owner ) && ally.owner == self )
{
return false;
}
}
return true;
}
can_use_friendlies( ref )
{
if (isdefined(level.spawning_friendlies) && level.spawning_friendlies != 0)
return false;
friendlies = GetAIArray( "allies" );
foreach ( ally in friendlies )
{
if ( IsAlive( ally ) )
{
return false;
}
}
return true;
}
give_friendlies( ref )
{
self thread give_friendlies_monitor_use( ref );
}
give_friendlies_monitor_use( ally_type )
{
self endon( "death" );
dpad_icon = "specops_ui_deltasupport";
if ( ally_type == "friendly_support_delta" )
dpad_icon = "specops_ui_deltasupport";
if ( ally_type == "friendly_support_riotshield" )
dpad_icon = "specops_ui_riotshieldsupport";
self SetWeaponHudIconOverride( "actionslot4", dpad_icon );
NotifyOnCommand( "friendly_support_called", "+actionslot 4" );
while (1)
{
self waittill( "friendly_support_called" );
if (self can_use_friendlies(ally_type))
{
level.spawning_friendlies=1;
maps\_so_survival_AI::ally_stream_start( ally_type );
maps\_so_survival::spawn_allies( self.origin, ally_type, self );
self SetWeaponHudIconOverride( "actionslot4", "none" );
return;
}
else
{
self show_ally_warning(5);
}
}
}
show_ally_warning( seconds )
{
level.ally_warning_time = seconds;
if (!isDefined(level.ally_warning))
{
xpos = maps\_specialops::so_hud_ypos();
self.ally_warning = maps\_specialops::so_create_hud_item( -1, xpos, &"SO_SURVIVAL_ALLY_UNAVAILABLE", self, true );
while (level.ally_warning_time > 0)
{
level.ally_warning_time -= 0.666;
wait 0.666;
}
self.ally_warning so_remove_hud_item();
wait 0.666;
self.ally_warning = undefined;
}
}
can_give_airstrike( ref )
{
return !( self hasweapon( "air_support_strobe" ) );
}
give_airstrike( ref )
{
self thread maps\_air_support_strobe::enable_strobes_for_player();
self thread sticky_strobe();
self thread disable_strobe_for_player();
}
sticky_strobe()
{
level endon( "special_op_terminated" );
self endon( "death" );
self endon( "strobe_timeout" );
while ( 1 )
{
self waittill( "grenade_fire", strobe, weaponName );
strobe.sticky = false;
if ( weaponName != "air_support_strobe" )
continue;
enemies = GetAISpeciesArray( "axis", "all" );
foreach( dude in enemies )
{
if ( isAI( dude ) && isalive( dude ) )
dude thread watch_for_strobe_hit();
}
if ( isdefined( level.bosses ) && level.bosses.size )
{
foreach( boss in level.bosses )
{
if ( isdefined( boss.vehicletype ) )
boss thread watch_for_strobe_hit();
}
}
self thread strobe_timeout();
self waittill( "strobe_stuck_on_ai", hit_ent );
strobe.sticky	= true;
if ( isdefined( hit_ent ) )
{
if ( isAI( hit_ent ) )
{
strobe.origin = hit_ent gettagorigin( "j_mainroot" );
strobe linkto( hit_ent, "j_mainroot" );
}
else
{
strobe.origin = hit_ent.origin;
strobe linkto( hit_ent );
}
while ( 1 )
{
hit_ent waittill( "death" );
if ( isdefined( strobe ) )
strobe unlink();
return;
}
}
}
}
strobe_timeout()
{
self endon( "strobe_stuck_on_ai" );
wait 5;
self notify( "strobe_timeout" );
}
watch_for_strobe_hit()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
self waittill("damage", amount, attacker, direction_vec, point, type, modelname, tagName, partName, dflags, weapon);
if ( !isdefined( weapon ) || !isdefined( attacker ) || !isplayer( attacker ) )
continue;
if ( weapon == "air_support_strobe" )
{
attacker notify( "strobe_stuck_on_ai", self );
return;
}
}
}
disable_strobe_for_player()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
level waittill( "air_suport_strobe_fired_upon", strobe );
if ( strobe.owner == self && !( self hasweapon( "air_support_strobe" ) ) )
{
self thread maps\_air_support_strobe::disable_strobes_for_player();
return;
}
}
}
can_give_chopper( ref )
{
return false;
}
give_chopper( ref )
{
return;
}
can_give_perk_care_package( ref )
{
if ( self hasperk( ref, true ) )
return false;
return has_open_slot_right();
}
give_perk_care_package( ref )
{
self thread give_sp_killstreak( ref );
}
get_item_ent( ref, type )
{
msg = "called get_item_ent() before armory tables are built!";
assertex( isdefined( level.armory ) && isdefined( level.armory_all_items ), msg );
if ( isdefined( type ) )
return level.armory[ type ][ ref ];
return level.armory_all_items[ ref ];
}
is_item_locked( ent )
{
assert( isdefined( self.summary ) && isdefined( self.summary[ "rank" ] ) );
unlock_rank = ent.unlockrank;
player_rank = self maps\_rank::getRank();
assert( isdefined( unlock_rank ) && isdefined( player_rank ) );
return player_rank >= unlock_rank;
}
can_afford( ent )
{
return self.survival_credit >= ent.cost;
}
