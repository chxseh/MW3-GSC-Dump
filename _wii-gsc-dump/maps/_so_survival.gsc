#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_so_survival_code;
#include maps\_specialops;
#include maps\_so_survival_AI;
#include maps\_so_survival_dialog;
#include maps\_hud_util;
#include maps\_wii_utility;
CONST_DEATH_FAIL_WAVE = 0;
CONST_CONGRAT_MIN_WAVE = 5;
CONST_START_REV_TIMER = 120;
CONST_MIN_REV_TIMER = 30;
CONST_REV_TIMER_DECREASE = 8;
CONST_WAVE_START_TIMEOUT = 5;
CONST_WAVE_DELAY_TOTAL = 35;
CONST_WAVE_DELAY_BEFORE_READY_UP	= 5;
CONST_WAVE_DELAY_COUNTDOWN = 5;
CONST_WAVE_ENDED_TIMER_FADE_DELAY	= 1.75;
CONST_WAVE_AI_LEFT_TILL_NEXT_WAVE	= 0;
CONST_WAVE_AI_LEFT_TILL_AGGRO = 4;
CONST_WAVE_REENFORCEMENT_SQUAD = 1;
CONST_WAVE_REENFORCEMENT_SPECIAL_AI = 2;
CONST_CAMP_RESPONSE_INTERVAL = 8;
CONST_ARMOR_INITIAL_DISPLAY_TIME	= 14;
CONST_ARMOR_DISPLAY_TIME = 6;
CONST_DELAYED_ENEMY_PING = 7;
CONST_EQUIPMENT_C4_MAX = 20;
CONST_EQUIPMENT_CLAYMORE_MAX = 20;
LOADOUT_TABLE = "sp/survival_waves.csv";
TABLE_INDEX = 0;
TABLE_SLOT = 1;
TABLE_REF = 2;
TABLE_AMMO = 3;
CONST_1_STAR_REQ = 5;
CONST_2_STAR_REQ = 10;
CONST_3_STAR_REQ = 20;
get_loadout_item_ref( slot ) { return tablelookup( level.loadout_table, TABLE_SLOT, slot, TABLE_REF ); }
get_loadout_item_ammo( ref ) { return tablelookup( level.loadout_table, TABLE_REF, ref, TABLE_AMMO ); }
survival_preload()
{
maps\so_survival_precache::main();
if ( !isdefined( level.loadout_table ) )
level.loadout_table	= LOADOUT_TABLE;
level.giveXp_kill_func = maps\_so_survival_AI::giveXp_kill;
maps\_so_survival_armory::armory_preload();
maps\_so_survival_AI::AI_preload();
maps\_so_survival_perks::perks_preload();
maps\_so_survival_challenge::Precache_Challenge_Strings();
PrecacheItem( "smoke_grenade_fast" );
precacherumble( "damage_light" );
PrecacheMinimapSentryCodeAssets();
PrecacheString( &"SO_SURVIVAL_SURVIVAL_OBJECTIVE" );
PrecacheString( &"SO_SURVIVAL_WAVE_TITLE" );
PrecacheString( &"SO_SURVIVAL_WAVE_SUCCESS_TITLE" );
PrecacheString( &"SO_SURVIVAL_SURVIVE_TIME" );
PrecacheString( &"SO_SURVIVAL_WAVE_TIME" );
PrecacheString( &"SO_SURVIVAL_PARTNER_READY" );
PrecacheString( &"SO_SURVIVAL_READY_UP_WAIT" );
PrecacheString( &"SO_SURVIVAL_READY_UP" );
PrecacheShader( "gradient_inset_rect" );
PrecacheShader( "teamperk_blast_shield" );
PrecacheShader( "specialty_self_revive" );
Precache_loadout_item( get_loadout_item_ref( "weapon_1" ) );
Precache_loadout_item( get_loadout_item_ref( "weapon_2" ) );
Precache_loadout_item( get_loadout_item_ref( "weapon_3" ) );
maps\_load::set_player_viewhand_model( "viewhands_player_delta" );
thread MP_ents_cleanup();
thread so_start_trigger_delete();
level.cheap_air_strobe_fx = 1;
}
so_start_trigger_delete()
{
triggers = getentarray( "trigger_multiple_flag_set", "classname" );
foreach ( trigger in triggers )
{
if ( IsDefined( trigger.script_flag ) && trigger.script_flag == "start_survival" )
trigger trigger_off();
}
}
hurtPlayersThink( trig )
{
level endon( "special_op_terminated" );
while ( 1 )
{
trig waittill( "trigger", player );
if ( isdefined( player ) && isplayer( player ) && player == self )
break;
}
self kill_wrapper();
}
survival_postload()
{
maps\_so_survival_armory::armory_postload();
maps\_so_survival_loot::loot_postload();
}
survival_init()
{
flag_init( "bosses_spawned" );
flag_init( "aggressive_mode" );
flag_init( "boss_music" );
flag_init( "slamzoom_finished" );
flag_set( "so_player_death_nofail" );
level.custom_eog_no_defaults = true;
level.eog_summary_callback = ::custom_eog_summary;
level.suppress_challenge_success_print = true;
level.congrat_min_wave = CONST_CONGRAT_MIN_WAVE;
level.so_survival_score_func = ::Survival_Leaderboard_Score_Func;
level.so_survival_wave_func = ::survival_leaderboard_wave_func;
level.skip_pilot_kill_count = true;
level.uav_missle_start_forward_distance = 128.0;
level.uav_missle_start_right_distance = 0.0;
setsaveddvar( "ai_foliageSeeThroughDist", 50000 );
SetSavedDvar( "g_friendlyfireDamageScale", 0.5 );
forcesharedammo();
thread enable_challenge_timer( "start_survival", "win_survival", undefined, true );
thread fade_challenge_in( undefined, false );
thread fade_challenge_out( "win_survival" );
level.wave_spawn_locs = maps\_squad_enemies::squad_setup( true );
maps\_drone_ai::init();
maps\_so_survival_armory::armory_init();
maps\_so_survival_loot::loot_init();
maps\_so_survival_AI::AI_init();
maps\_so_survival_perks::perks_init();
maps\_so_survival_challenge::challenge_init();
maps\_so_survival_dialog::survival_dialog_init();
maps\_audio::aud_disable_deathsdoor_audio();
thread setup_players();
thread survival_logic();
}
survival_leaderboard_wave_func()
{
assert( isdefined( level.current_wave ) );
return level.current_wave;
}
survival_leaderboard_score_func()
{
assert( isdefined( level.challenge_start_time ) );
assert( isdefined( level.challenge_end_time ) );
assert( isdefined( level.current_wave ) );
assert( isdefined( level.performance_bonus ) );
foreach ( player in level.players )
assert( isdefined( player.game_performance ) );
session_time = ( level.challenge_end_time - level.challenge_start_time ) / 1000;
session_wave = level.current_wave;
session_credit = 0;
foreach ( player in level.players ){ session_credit += player.game_performance[ "credits" ]; }
session_credits_score = 999 * min( session_credit/( session_wave * 10000 ), 1.0 );
if ( session_wave == 1 )
return int( session_credits_score );
session_wavescore = session_wave * 1000;
session_score	= int( session_wavescore + session_credits_score );
return session_score;
}
other_player_performance( player, ref )
{
if ( is_coop() )
{
return get_other_player( player ).game_performance[ ref ];
}
else
{
return undefined;
}
}
custom_eog_summary()
{
time_survived = int( min( ( level.challenge_end_time - level.challenge_start_time ), 86400000 ) );
ms = int( ( time_survived % 1000 )/100 );
second = int( time_survived / 1000 ) % 60;
minute = int( time_survived / 60000 ) % 60;
hour = int( time_survived / 3600000 );
if ( hour < 10 )
hour = "0" + hour;
if ( minute < 10 )
minute = "0" + minute;
if ( second < 10 )
second = "0" + second;
formated_time = hour + ":" + minute + ":" + second + "." + ms;
player_score	= Survival_Leaderboard_Score_Func();
foreach ( player in level.players )
{
p1_kills = player.game_performance[ "kill" ];
p2_kills = other_player_performance( player, "kill" );
p1_headshot = player.game_performance[ "headshot" ];
p2_headshot = other_player_performance( player, "headshot" );
p1_accuracy = player.game_performance[ "accuracy" ] + "%";
p2_accuracy = other_player_performance( player, "accuracy" );
if ( isdefined( p2_accuracy ) )
p2_accuracy = p2_accuracy + "%";
p1_credits = player.game_performance[ "credits" ];
p2_credits = other_player_performance( player, "credits" );
p1_downed = player.game_performance[ "downed" ];
p2_downed = other_player_performance( player, "downed" );
p1_revives = player.game_performance[ "revives" ];
p2_revives = other_player_performance( player, "revives" );
player set_eog_success_heading( level.current_wave );
if ( is_coop() )
{
setdvar( "ui_hide_hint", 1 );
player add_custom_eog_summary_line( "", "@SPECIAL_OPS_PERFORMANCE_YOU", "@SPECIAL_OPS_PERFORMANCE_PARTNER" );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_KILLS", p1_kills, p2_kills );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_HEADSHOT", p1_headshot, p2_headshot );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_ACCURACY", p1_accuracy, p2_accuracy );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_REVIVES", p1_revives, p2_revives );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_CREDITS_EARNED", p1_credits, p2_credits );
player add_custom_eog_summary_line_blank();
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_TIME", formated_time );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_SCORE", player_score );
}
else
{
setdvar( "ui_hide_hint", 0 );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_KILLS", p1_kills );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_HEADSHOT", p1_headshot );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_ACCURACY", p1_accuracy );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_CREDITS_EARNED",	p1_credits );
player add_custom_eog_summary_line_blank();
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_TIME", formated_time );
player add_custom_eog_summary_line( "@SO_SURVIVAL_PERFORMANCE_SCORE", player_score );
}
}
}
survival_logic()
{
wait( 0.05 );
maps\_so_survival_armory::armory_setup_players();
thread survival_objective();
thread survival_completion();
thread survival_wave();
thread survival_hud();
thread survival_credits();
thread survival_armory_hint();
}
survival_objective()
{
wait 2;
Objective_Add( 1, "active", &"SO_SURVIVAL_SURVIVAL_OBJECTIVE" );
Objective_Current_NoMessage( 1 );
}
survival_completion()
{
level waittill( "so_player_has_died" );
if ( !flag( "start_survival" ) )
flag_wait( "start_survival" );
if ( !flag( "so_player_death_nofail" ) )
return;
flag_set( "win_survival" );
}
survival_success_or_fail()
{
level endon( "special_op_terminated" );
while ( 1 )
{
level waittill( "wave_ended", wave_num );
if ( wave_num >= CONST_DEATH_FAIL_WAVE )
{
flag_set( "so_player_death_nofail" );
return;
}
}
}
waittill_survival_start()
{
flag_wait_or_timeout( "start_survival", CONST_WAVE_START_TIMEOUT );
}
setup_players()
{
if ( level.console )
{
SetSavedDvar( "aim_aimAssistRangeScale", "1" );
if (!using_wii())
SetSavedDvar( "aim_autoAimRangeScale", "0" );
}
hurtTriggers = getentarray( "trigger_hurt", "classname" );
foreach( player in level.players )
{
player thread do_slamzoom();
player thread give_loadout();
foreach ( hurtTrigger in hurtTriggers )
player thread hurtPlayersThink( hurtTrigger );
}
thread player_performance_init();
waittill_survival_start();
level.so_c4_array = [];
level.so_claymore_array = [];
foreach( player in level.players )
{
player thread camping_think();
player thread decrease_rev_time();
player thread weapon_collect_ammo_adjust();
player thread watch_grenade_usage();
}
}
watch_grenade_usage()
{
self endon( "death" );
self endon( "disconnect" );
self thread watch_c4_usage();
self thread watch_claymore_usage();
}
watch_c4_usage()
{
self endon( "death" );
self endon( "disconnect" );
for ( ; ; )
{
self waittill( "grenade_fire", c4, weapname );
if ( IsDefined( c4 ) && IsDefined( weapname ) &&
IsDefined( WeaponInventoryType( weapname ) ) && WeaponInventoryType( weapname ) == "item" &&
IsSubStr( weapname, "c4" ) )
{
if ( level.so_c4_array.size )
{
level.so_c4_array = array_removeundefined( level.so_c4_array );
if ( level.so_c4_array.size >= CONST_EQUIPMENT_C4_MAX )
level.so_c4_array[ 0 ] Detonate();
}
level.so_c4_array[ level.so_c4_array.size ] = c4;
}
}
}
watch_claymore_usage()
{
self endon( "death" );
self endon( "disconnect" );
for ( ; ; )
{
self waittill( "grenade_fire", claymore, weapname );
if ( IsDefined( claymore ) && IsDefined( weapname ) &&
IsDefined( WeaponInventoryType( weapname ) ) && WeaponInventoryType( weapname ) == "item" &&
IsSubStr( weapname, "claymore" ) )
{
if ( level.so_claymore_array.size )
{
level.so_claymore_array = array_removeundefined( level.so_claymore_array );
if ( level.so_claymore_array.size >= CONST_EQUIPMENT_CLAYMORE_MAX )
level.so_claymore_array[ 0 ] Detonate();
}
level.so_claymore_array[ level.so_claymore_array.size ] = claymore;
}
}
}
give_loadout()
{
self endon( "death" );
self takeallweapons();
self give_player_weapon( "weapon_1" );
self give_player_weapon( "weapon_2" );
self give_player_weapon( "weapon_3" );
self give_player_grenade( "grenade_1" );
self give_player_grenade( "grenade_2" );
self give_player_armor( "armor_1" );
wait 0.05;
self give_player_equipment( "equipment_1" );
self give_player_equipment( "equipment_2" );
self give_player_equipment( "equipment_3" );
self give_player_airsupport( "airsupport_1" );
self give_player_airsupport( "airsupport_2" );
self give_player_airsupport( "airsupport_3" );
self give_player_perk( "perk_1" );
self give_player_perk( "perk_2" );
self give_player_perk( "perk_3" );
}
give_player_weapon( slot )
{
weapon = get_loadout_item_ref( slot );
ammo	= get_loadout_item_ammo( weapon );
if ( weapon != "" )
{
self giveweapon( weapon );
weapon_class = weaponclass( weapon );
assert( isdefined( weapon_class ) );
if ( weapon_class == "pistol" )
level.coop_incap_weapon = weapon;
if ( ammo == "max" )
self setweaponammostock( weapon, weaponmaxammo( weapon ) );
else
self setweaponammostock( weapon, int( ammo ) );
if ( slot == "weapon_1" )
self switchToWeapon( weapon );
}
}
give_player_grenade( slot )
{
grenade = get_loadout_item_ref( slot );
ammo	= get_loadout_item_ammo( grenade );
if ( grenade != "" )
{
self giveweapon( grenade );
if ( ammo == "max" )
self setweaponammostock( grenade, weaponmaxammo( grenade ) );
else
self setweaponammostock( grenade, int( ammo ) );
if ( grenade == "flash_grenade" )
self setOffhandSecondaryClass( "flash" );
}
}
give_player_armor( slot )
{
armor_type = get_loadout_item_ref( slot );
armor_points = int( get_loadout_item_ammo( armor_type ) );
if ( armor_type != "" )
{
self maps\_so_survival_armory::give_armor_amount( armor_type, armor_points );
}
}
give_player_equipment( slot )
{
equipment = get_loadout_item_ref( slot );
if ( equipment != "" )
{
give_func = self maps\_so_survival_armory::get_func_give( "equipment", equipment );
self thread [[ give_func ]]( equipment );
}
}
give_player_airsupport( slot )
{
airsupport = get_loadout_item_ref( slot );
if ( airsupport != "" )
{
give_func = self maps\_so_survival_armory::get_func_give( "airsupport", airsupport );
self thread [[ give_func ]]( airsupport );
}
}
give_player_perk( slot )
{
perk_ref = get_loadout_item_ref( slot );
if ( perk_ref != "" )
{
self thread maps\_so_survival_perks::give_perk( perk_ref );
}
}
decrease_rev_time()
{
if ( !is_coop() )
return;
while ( 1 )
{
level waittill( "wave_ended" );
rev_time = CONST_START_REV_TIMER;
rev_time = rev_time - ( level.current_wave * CONST_REV_TIMER_DECREASE );
rev_time = max( rev_time, CONST_MIN_REV_TIMER );
self.laststand_info.bleedout_time_default = rev_time;
}
}
CONST_WEAPON_CHANGE_AMMO_ADJUST_TIME = 10;
weapon_collect_ammo_adjust()
{
Assert( IsDefined( self ) && IsPlayer( self ), "Self not player." );
level endon( "special_op_terminated" );
self endon( "death" );
if ( !IsDefined( self.survival_weapons_swapped ) )
self.survival_weapons_swapped = [];
weap_list_old = self GetWeaponsListPrimaries();
while ( true )
{
self waittill( "weapon_change", weapon );
if ( !weapon_collect_ammo_adjust_valid( weapon ) )
continue;
is_new_weapon = !array_contains( weap_list_old, weapon );
if ( !is_new_weapon )
continue;
if ( !weapon_collect_ammo_adjust_was_recent( weapon ) )
{
if ( self weapon_collect_balance_ammo( weapon ) )
{
self weapon_collect_record_weapon_adjusted( weapon );
}
}
weap_list_curr = self GetWeaponsListPrimaries();
foreach ( weap_old in weap_list_old )
{
if ( !array_contains( weap_list_curr, weap_old ) )
{
if ( !weapon_collect_ammo_adjust_valid( weap_old ) )
continue;
self weapon_collect_record_weapon_adjusted( weap_old );
}
}
weap_list_old = weap_list_curr;
self weapon_collect_clean_recorded_weapons();
}
}
weapon_collect_ammo_adjust_valid( weapon_name )
{
if ( WeaponClass( weapon_name ) == "none" || WeaponClass( weapon_name ) == "rocketlauncher" || WeaponClass( weapon_name ) == "item" )
return false;
if ( WeaponInventoryType( weapon_name ) != "primary" )
return false;
return true;
}
weapon_collect_ammo_adjust_was_recent( weapon_name )
{
Assert( IsDefined( self ) && IsPlayer( self ), "Self not player." );
if ( !IsDefined( self.survival_weapons_swapped ) )
{
return false;
}
if ( !IsDefined( self.survival_weapons_swapped[ weapon_name ] ) )
{
return false;
}
if ( GetTime() - self.survival_weapons_swapped[ weapon_name ] <= CONST_WEAPON_CHANGE_AMMO_ADJUST_TIME * 1000 )
{
return true;
}
return false;
}
weapon_collect_balance_ammo( weapon_name )
{
Assert( IsDefined( self ) && IsPlayer( self ), "Self not player." );
ammo_clip	= self GetWeaponAmmoClip( weapon_name );
ammo_stock	= self GetWeaponAmmoStock( weapon_name );
ammo_clip_max	= WeaponClipSize( weapon_name );
ammo_stock_max	= WeaponMaxAmmo( weapon_name );
if ( ammo_clip == ammo_clip_max )
return false;
if ( ammo_stock <= 0 )
return false;
ammo_clip_free = ammo_clip_max - ammo_clip;
ammo_stock_shift	= 0;
if ( ammo_clip_free > ammo_stock )
{
ammo_stock_shift = ammo_stock;
}
else
{
ammo_stock_shift = ammo_clip_free;
}
self SetWeaponAmmoClip( weapon_name, ammo_clip + ammo_stock_shift );
self SetWeaponAmmoStock( weapon_name, ammo_stock - ammo_stock_shift );
return true;
}
weapon_collect_record_weapon_adjusted( weapon_name )
{
Assert( IsDefined( self ) && IsPlayer( self ), "Self not player." );
if ( !IsDefined( self.survival_weapons_swapped ) )
self.survival_weapons_swapped = [];
self.survival_weapons_swapped[ weapon_name ] = GetTime();
}
weapon_collect_clean_recorded_weapons()
{
Assert( IsDefined( self ) && IsPlayer( self ), "Self not player." );
if ( !IsDefined( self.survival_weapons_swapped ) || !self.survival_weapons_swapped.size )
return;
weapons_valid = [];
foreach ( weapon, time in self.survival_weapons_swapped )
{
if ( self weapon_collect_ammo_adjust_was_recent( weapon ) )
weapons_valid[ weapon ] = self.survival_weapons_swapped[ weapon ];
}
self.survival_weapons_swapped = weapons_valid;
}
do_slamzoom()
{
self DisableWeapons();
self DisableOffhandWeapons();
self FreezeControls( true );
if ( isdefined( self.last_modelfunc ) )
{
self detachall();
self setmodel( "" );
}
self VisionSetNakedForPlayer( "", 1.0 );
self EnableWeapons();
self EnableOffhandWeapons();
self FreezeControls( false );
self PlayerClearStreamOrigin();
self notify( "player_update_model" );
wait 0.5;
flag_set( "slamzoom_finished" );
}
survival_waves_setup()
{
level.pmc_alljuggernauts = false;
level.skip_juggernaut_intro_sound	= true;
level.survival_wave_intermission = false;
if (!using_wii())
level.uav_struct.view_cone = 12;
setsaveddvar( "g_compassShowEnemies", "0" );
if (!using_wii())
{
array_thread( level.players, maps\_remotemissile_utility::setup_remote_missile_target );
add_global_spawn_function( "axis", ::ai_remote_missile_fof_outline );
}
level.current_wave = 1;
level thread update_wave();
}
update_wave()
{
level endon( "special_op_terminated" );
repeat_index = undefined;
repeated_times = 0;
while ( 1 )
{
level waittill( "wave_ended", wave_num );
next_wave_num = wave_num + 1;
if ( !wave_exist( next_wave_num ) )
{
if ( !isdefined( repeat_index ) )
{
repeat_index = 0;
repeated_times = 1;
}
if ( repeat_index == level.survival_repeat_wave.size )
{
repeat_index = 0;
repeated_times++;
}
new_wave = spawnstruct();
new_wave.idx = next_wave_num - 1;
new_wave.num = next_wave_num;
new_wave.squadType = level.survival_repeat_wave[ repeat_index ].squadType;
new_wave.squadArray = level.survival_repeat_wave[ repeat_index ].squadArray;
new_wave.specialAI = level.survival_repeat_wave[ repeat_index ].specialAI;
new_wave.specialAIquantity	= level.survival_repeat_wave[ repeat_index ].specialAIquantity;
new_wave.bossAI = level.survival_repeat_wave[ repeat_index ].bossAI;
new_wave.bossNonAI = level.survival_repeat_wave[ repeat_index ].bossNonAI;
new_wave.bossDelay = level.survival_repeat_wave[ repeat_index ].bossDelay;
new_wave.dogType = level.survival_repeat_wave[ repeat_index ].dogType;
new_wave.dogQuantity = level.survival_repeat_wave[ repeat_index ].dogQuantity;
new_wave.repeating = level.survival_repeat_wave[ repeat_index ].repeating;
previous_wave = level.survival_wave[ wave_num ];
level.survival_wave = [];
level.survival_wave[ wave_num ] = previous_wave;
level.survival_wave[ new_wave.num ]	= new_wave;
repeat_index++;
level.survival_waves_repeated++;
}
}
}
survival_wave()
{
level endon( "special_op_terminated" );
survival_waves_setup();
thread intro_music();
thread maps\_so_survival_AI::survival_wave_stream_start(level.current_wave);
waittill_survival_start();
if ( !flag( "start_survival" ) )
flag_set( "start_survival" );
level notify( "wave_started", level.current_wave );
SetSavedDvar( "bg_viewKickScale", "0.2" );
while( 1 )
{
maps\_so_survival_AI::survival_wave_stream_start(level.current_wave);
if ( isdefined( level.leaders.size ) && level.leaders.size >= 3 )
{
assertex( false, "Too many squads left alive before new wave, AI maxed out!" );
}
squad_array = get_squad_array( level.current_wave );
squads_spawned = 0;
assert( isdefined( squad_array ) && squad_array.size );
foreach ( squad_size in squad_array )
{
if ( squad_size > 0 )
squads_spawned += spawn_wave( 1, squad_size );
wait 0.07;
}
level.special_ai = [];
special_ai_types	= get_special_ai( level.current_wave );
if ( isdefined( special_ai_types ) )
{
foreach( special_type in special_ai_types )
{
if ( issubstr( special_type, "dog" ) )
{
thread spawn_dogs( special_type, get_dog_quantity( level.current_wave ) );
continue;
}
special_ai_num = get_special_ai_type_quantity( level.current_wave, special_type );
assertex( isdefined( special_ai_num ) && special_ai_num > 0, "Special ai of type: " + special_type + " requeste with an undefined or zero count." );
if ( isdefined( special_ai_num ) && special_ai_num > 0 )
{
special_ai_spawned	= spawn_special_ai( special_type, special_ai_num );
}
wait 0.07;
}
}
if ( squad_array[ 0 ] > 0 )
thread reenforcement_squad_spawn( CONST_WAVE_REENFORCEMENT_SQUAD, squad_array[ 0 ] );
if ( wave_has_boss( level.current_wave ) )
thread spawn_boss();
level thread delayed_enemy_ping();
total_enemies = getaiarray( "axis" ).size + dog_get_count();
while ( total_enemies > CONST_WAVE_AI_LEFT_TILL_AGGRO )
{
level waittill_any_timeout( 1.0, "axis_died" );
total_enemies = getaiarray( "axis" ).size + dog_get_count();
}
flag_set( "aggressive_mode" );
maps\_squad_enemies::squad_disband( 0, ::aggressive_squad_leader );
level.squad_leader_behavior_func = maps\_so_survival_AI::aggressive_ai;
level.special_ai_behavior_func = maps\_so_survival_AI::aggressive_ai;
if ( isdefined( level.special_ai ) && level.special_ai.size > 0 )
foreach ( guy in level.special_ai )
guy thread maps\_so_survival_AI::aggressive_ai();
total_enemies = getaiarray( "axis" ).size + dog_get_count();
while ( total_enemies > CONST_WAVE_AI_LEFT_TILL_NEXT_WAVE )
{
level waittill_any_timeout( 1.0, "axis_died" );
total_enemies = getaiarray( "axis" ).size + dog_get_count();
}
level.squad_leader_behavior_func = maps\_so_survival_AI::default_ai;
level.special_ai_behavior_func = maps\_so_survival_AI::default_ai;
if ( wave_has_boss( level.current_wave ) )
{
flag_wait( "bosses_spawned" );
while ( isdefined( level.bosses ) && level.bosses.size )
wait 0.1;
}
flag_clear( "aggressive_mode" );
level notify( "wave_ended", level.current_wave );
setsaveddvar( "g_compassShowEnemies", "0" );
if ( flag( "boss_music" ) )
{
level notify( "end_boss_music" );
flag_clear( "boss_music" );
music_stop( 3 );
}
survival_wave_pickup_downed_players();
if ( wave_exist( level.current_wave+1 ) )
thread maps\_so_survival_AI::survival_wave_stream_start(level.current_wave+1);
survival_wave_intermission();
level.current_wave++;
level notify( "wave_started", level.current_wave );
}
}
delayed_enemy_ping()
{
level endon( "wave_ended" );
wait CONST_DELAYED_ENEMY_PING;
setsaveddvar( "g_compassShowEnemies", "1" );
}
survival_wave_intermission()
{
level endon( "special_op_terminated" );
level.survival_wave_intermission = true;
assertex( CONST_WAVE_DELAY_TOTAL >= CONST_WAVE_DELAY_COUNTDOWN + CONST_WAVE_DELAY_BEFORE_READY_UP, "The total wave delay must be bigger than the big countdown delay." );
duration_before_count	= CONST_WAVE_DELAY_TOTAL - CONST_WAVE_DELAY_COUNTDOWN;
duration_count = CONST_WAVE_DELAY_COUNTDOWN;
if ( duration_before_count > 0 )
{
wait CONST_WAVE_DELAY_BEFORE_READY_UP;
duration_before_count -= CONST_WAVE_DELAY_BEFORE_READY_UP;
assertex( duration_before_count >= 1, "Delay before ready up too long relative to wave delay and countdown delay." );
array_thread( level.players, ::survival_wave_catch_player_ready, "survival_all_ready", duration_before_count + duration_count );
level waittill_any_timeout( duration_before_count, "survival_all_ready" );
level notify( "survival_all_ready" );
}
foreach ( player in level.players )
{
player thread matchStartTimer( duration_count );
}
wait duration_count;
level.survival_wave_intermission = false;
}
survival_wave_catch_player_ready( all_ready_msg, time )
{
self endon( "death" );
level endon( "special_op_terminated" );
level endon( all_ready_msg );
x_offset = maps\_specialops::so_hud_ypos() + 55;
self.elem_ready_up = maps\_specialops::so_create_hud_item( -2, x_offset, &"SO_SURVIVAL_READY_UP", self, true );
self.elem_ready_up elem_ready_up_setup();
self thread survival_wave_catch_player_ready_update( "survival_player_ready", all_ready_msg, self.elem_ready_up, time );
self thread survival_wave_catch_player_ready_clean( all_ready_msg );
if (!using_wii())
self NotifyOnPlayerCommand( "survival_player_ready", "+stance" );
else
{
self wii_NotifyOnCommand( "survival_player_ready", "+melee", "+melee_zoom", "+actionslot_carousel" );
}
self waittill( "survival_player_ready" );
if ( !isdefined( level.survival_players_ready ) )
level.survival_players_ready = 1;
else
level.survival_players_ready++;
self.elem_ready_up maps\_specialops::so_remove_hud_item( true );
if ( level.survival_players_ready == level.players.size )
{
level notify( all_ready_msg );
}
else
{
otherplayer = get_other_player( self );
if ( isdefined( otherplayer ) && isdefined( otherplayer.elem_ready_up ) )
otherplayer.elem_ready_up.label = &"SO_SURVIVAL_PARTNER_READY";
self.elem_ready_up = maps\_specialops::so_create_hud_item( -2, x_offset, &"SO_SURVIVAL_READY_UP_WAIT", self, true );
self.elem_ready_up elem_ready_up_setup();
}
}
elem_ready_up_setup()
{
self.alignX = "right";
self.fontScale = 0.75;
self.alpha = 0.0;
self.horzalign = "right_adjustable";
self.font = "objective";
self.fontscale = 1.5;
if ( issplitscreen() )
{
self.horzAlign = "center";
self.x = 36;
self.y = -22;
}
self thread maps\_hud_util::fade_over_time( 1.0, 0.5 );
}
survival_wave_catch_player_ready_update( player_endon, level_endon, hud_elem, time )
{
level endon( level_endon );
self endon( player_endon );
time = int( time );
while( isdefined( hud_elem ) && time > 0 )
{
hud_elem SetValue( time );
wait 1.0;
time--;
}
}
survival_wave_catch_player_ready_clean( msg )
{
level waittill( msg );
level.survival_players_ready = undefined;
if ( isdefined( self.elem_ready_up ) )
{
self.elem_ready_up maps\_specialops::so_remove_hud_item( true );
}
}
survival_wave_pickup_downed_players()
{
foreach( player in level.players )
{
if ( is_player_down( player ) )
player.laststand_getup_fast = true;
}
}
spawn_wave( spawn_squad_num, squad_size )
{
level endon( "special_op_terminated" );
spawn_squad_num = int( spawn_squad_num );
while( spawn_squad_num )
{
squad = maps\_squad_enemies::spawn_far_squad( level.wave_spawn_locs, get_class( "leader" ), get_class( "follower" ), squad_size - 1 );
foreach( guy in squad )
{
guy	setthreatbiasgroup( "axis" );
guy thread setup_AI_weapon();
wait 0.07;
}
spawn_squad_num--;
wait 0.07;
}
return level.leaders.size;
}
get_class( class )
{
squad_type = get_squad_type( level.current_wave );
classname = get_ai_classname( squad_type );
if ( isdefined( class ) )
{
}
return classname;
}
spawn_special_ai( ai_type, quantity )
{
avoid_locs = [];
avoid_locs[ avoid_locs.size ] = level.player;
if( is_coop() )
avoid_locs[ avoid_locs.size ] = level.players[ 1 ];
classname = get_ai_classname( ai_type );
spawner = get_spawners_by_classname( classname )[ 0 ];
for( i = 0; i < quantity; i++ )
{
wait 0.05;
spawn_loc = get_furthest_from_these( level.wave_spawn_locs, avoid_locs, 4 );
spawner.count = 1;
spawner.origin = spawn_loc.origin;
spawner.angles = spawn_loc.angles;
guy = spawner spawn_ai( true );
guy setthreatbiasgroup( "axis" );
assertex( isdefined( guy ), "Special AI failed to spawn even though it was forced spawned." );
guy.ai_type = get_ai_struct( ai_type );
level.special_ai[ level.special_ai.size ] = guy;
guy thread clear_from_special_ai_array_when_dead();
guy thread setup_AI_weapon();
assertex( isdefined( level.special_ai_behavior_func ), "No special AI behavior func defined!" );
guy thread [[ level.special_ai_behavior_func ]]();
}
return level.special_ai;
}
reenforcement_squad_spawn( quantity, squad_size )
{
level endon( "special_op_terminated" );
level endon( "wave_ended" );
initial_leaders = level.leaders.size;
squad_spawned = 0;
while ( squad_spawned < quantity )
{
if ( level.leaders.size >= initial_leaders )
{
wait 0.05;
continue;
}
total_AI = getaiarray();
if ( total_AI.size >= ( 32 - squad_size ) )
{
wait 0.05;
continue;
}
squad = maps\_squad_enemies::spawn_far_squad( level.wave_spawn_locs, get_class( "leader" ), get_class( "follower" ), squad_size - 1 );
foreach( guy in squad )
{
guy	setthreatbiasgroup( "axis" );
guy thread setup_AI_weapon();
}
squad_spawned++;
}
}
reenforcement_special_ai_spawn( special_ai_type, quantity )
{
level endon( "special_op_terminated" );
level endon( "wave_ended" );
initial_special_ais = level.special_ai.size;
ai_spawned = 0;
while ( ai_spawned < quantity )
{
if ( level.special_ai.size >= initial_special_ais )
{
wait 0.05;
continue;
}
total_AI = getaiarray();
if ( total_AI.size > 31 )
{
wait 0.05;
continue;
}
spawn_special_ai( special_ai_type, 1 );
ai_spawned++;
wait 0.05;
}
}
wave_has_boss( wave_num )
{
AI_bosses = get_bosses_ai( wave_num );
nonAI_bosses = get_bosses_nonai( wave_num );
if ( isdefined( AI_bosses ) || isdefined( nonAI_bosses ) )
return true;
return false;
}
spawn_boss()
{
flag_clear( "bosses_spawned" );
if ( level.survival_wave[ level.current_wave ].bossDelay
&& flag_exist( "aggressive_mode" )
&& !flag( "aggressive_mode" )
)
flag_wait( "aggressive_mode" );
level notify( "boss_spawning", level.current_wave );
level.bosses = [];
AI_bosses = get_bosses_ai( level.current_wave );
nonAI_bosses = get_bosses_nonai( level.current_wave );
if ( isdefined( AI_bosses ) )
{
spawn_boss_AI( AI_bosses, true );
if ( level.bosses.size && isdefined( nonAI_bosses ) )
{
level waittill_any_timeout( 30, "juggernaut_jumpedout" );
wait 6;
}
}
if ( isdefined( nonAI_bosses ) )
thread spawn_boss_nonAI( nonAI_bosses, !isdefined( AI_bosses ) );
flag_set( "bosses_spawned" );
}
spawn_boss_AI( bosses, music_enable )
{
foreach( boss_ref in bosses )
{
if ( boss_ref == "jug_minigun" )
continue;
if ( !issubstr( boss_ref, "jug_" ) )
continue;
path_start = chopper_wait_for_cloest_open_path_start( random_player_origin(), "drop_path_start", "script_unload" );
thread spawn_juggernaut( boss_ref, path_start );
wait 0.5;
}
if ( music_enable )
thread music_boss( "juggernaut" );
}
spawn_boss_nonAI( bosses, music_enable )
{
foreach( boss_ref in bosses )
{
if ( issubstr( boss_ref, "chopper" ) )
{
path_start = chopper_wait_for_cloest_open_path_start( random_player_origin(), "chopper_boss_path_start", "script_stopnode" );
chopper = spawn_chopper_boss( boss_ref, path_start );
}
else
{
}
}
if ( music_enable )
thread music_boss( "chopper" );
}
spawn_allies( target_origin, ally_type, owner )
{
assert( isdefined( owner ), "allies' owner parameter is missing" );
assert( isdefined( target_origin ), "Invalid target origin" );
assert( isdefined( ally_type ), "Invalid ally_type" );
path_start = chopper_wait_for_cloest_open_path_start( target_origin, "drop_path_start", "script_unload" );
level notify( "so_airsupport_incoming", ally_type );
spawn_ally_team( ally_type, 3, path_start, owner );
}
player_performance_init()
{
wait 0.05;
level.performance_bonus[ "accuracy" ] = 3;
level.performance_bonus[ "damagetaken" ] = 2;
level.performance_bonus[ "time" ] = 2;
if ( is_coop() )
{
level.performance_bonus[ "wavebonus" ] = 50;
level.performance_bonus[ "headshot" ] = 50;
level.performance_bonus[ "kill" ] = 50;
}
else
{
level.performance_bonus[ "wavebonus" ] = 25;
level.performance_bonus[ "headshot" ] = 20;
level.performance_bonus[ "kill" ] = 10;
}
foreach( player in level.players )
{
player.game_performance = [];
player.game_performance[ "headshot" ] = 0;
player.game_performance[ "accuracy" ] = 0;
player.game_performance[ "damagetaken" ]	= 0;
player.game_performance[ "kill" ] = 0;
player.game_performance[ "credits" ] = 0;
player.game_performance[ "downed" ] = 0;
player.game_performance[ "revives" ] = 0;
player.performance = [];
player.performance[ "headshot" ] = 0;
player.performance[ "accuracy" ] = 0;
player.performance[ "time" ] = 0;
player.performance[ "damagetaken" ] = 0;
player.performance[ "kill" ] = 0;
player.performance[ "wavebonus" ] = 0;
player player_performance_UI_init();
player thread player_performance_think();
}
add_global_spawn_function( "axis", ::performance_track_headshot );
}
player_performance_reset()
{
self _setplayerdata_single( "surHUD_performance_reward", 0 );
foreach ( index_string, performance_item in self.performance )
{
self.performance[ index_string ] = 0;
self _setplayerdata_array( "surHUD_performance", index_string, 0 );
self _setplayerdata_array( "surHUD_performance_p2", index_string, 0 );
self _setplayerdata_array( "surHUD_performance_credit", index_string, 0 );
}
}
player_performance_think()
{
self endon( "death" );
self thread performance_wave_reset();
self thread performance_track_downed();
self thread performance_track_revives();
self thread performance_track_credits();
self thread performance_track_time();
self thread performance_track_damage();
self thread performance_track_accuracy();
self thread performance_track_kills();
self thread performance_track_waves();
while ( 1 )
{
level waittill( "wave_ended" );
self maps\_player_stats::career_stat_increment( "waves_survived", 1 );
waittillframeend;
reward_array = self reward_calculation();
if ( reward_array[ "total" ] )
self thread giveXP( "personal_wave_reward", reward_array[ "total" ] );
self thread performance_summary( reward_array );
level waittill( "wave_started" );
self.camping_time = 0;
}
}
performance_wave_reset()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
level waittill( "wave_started" );
self player_performance_reset();
self.stats[ "kills" ] = 0;
self.stats[ "shots_fired" ] = 0;
self.stats[ "shots_hit" ] = 0;
}
}
performance_track_revives()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
self waittill( "so_revive_success" );
self.game_performance[ "revives" ]++;
}
}
performance_track_downed()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
self waittill( "player_downed" );
self.game_performance[ "downed" ]++;
}
}
performance_track_credits()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
self waittill( "deposit_credits", delta, donation );
if ( self.survival_credit >= 50000 && !isdefined( self.survival_credit_balance_of_50000 ) )
{
self.survival_credit_balance_of_50000 = true;
self thread so_achievement_update( "GET_RICH_OR_DIE_TRYING" );
}
if ( isdefined( donation ) && donation )
continue;
if ( delta > 0 )
self.game_performance[ "credits" ] += delta;
}
}
performance_track_time()
{
level endon( "special_op_terminated" );
self endon( "death" );
waittill_survival_start();
while ( 1 )
{
last_intermission_start_time = gettime();
level waittill( "wave_ended" );
self.performance[ "time" ] = gettime() - last_intermission_start_time;
level waittill( "wave_started" );
}
}
performance_track_headshot()
{
level endon( "special_op_terminated" );
if ( !IsAI( self ) )
return;
head_shot = false;
self waittill( "death", attacker, cause, weaponName, d, e, f, g );
if(	self was_headshot() && isplayer( attacker ) )
{
msg = "player.performance array is missing headshot setting";
assertex( isdefined( attacker.performance ) && isdefined( attacker.performance[ "headshot" ] ), msg );
attacker.performance[ "headshot" ]++;
attacker.game_performance[ "headshot" ]++;
attacker notify( "sur_ch_headshot" );
}
}
performance_track_damage()
{
level endon( "special_op_terminated" );
self endon( "death" );
assertex( isdefined( self.team ), "Player isn't setup with a .team! for team based damage tracking" );
if ( isdefined( self.armor ) )
self.previous_armor = self.armor[ "points" ];
else
self.previous_armor = 0;
while ( 1 )
{
self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
if ( isdefined( attacker ) && ( attacker != self ) && isdefined( attacker.team ) && attacker.team == self.team )
continue;
self thread performance_damagetaken_update( amount );
}
}
performance_damagetaken_update( amount )
{
max_hp = 100 + self.previous_armor;
damage = int( min( max_hp, amount ) );
self.performance[ "damagetaken" ] += damage;
self.game_performance[ "damagetaken" ] += damage;
waittillframeend;
if ( isdefined( self.armor ) )
self.previous_armor = self.armor[ "points" ];
else
self.previous_armor = 0;
}
performance_track_accuracy()
{
level endon( "special_op_terminated" );
self endon( "death" );
total_shots_fired = 0;
total_shots_hit = 0;
while ( 1 )
{
self waittill( "weapon_fired" );
shots_fired = max( 1, float( self.stats[ "shots_fired" ] ) );
shots_hit = float( self.stats[ "shots_hit" ] );
total_shots_fired += shots_fired;
total_shots_hit += shots_hit;
self.performance[ "accuracy" ] = int_capped( 100 * (shots_hit / shots_fired ), 0, 100 );
self.game_performance[ "accuracy" ] = int_capped( 100 * (total_shots_hit / total_shots_fired ), 0, 100 );
}
}
performance_track_kills()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
level waittill( "specops_player_kill", attacker );
if( isdefined( attacker ) && isplayer( attacker ) && attacker == self )
{
self.performance[ "kill" ]++;
self.game_performance[ "kill" ]++;
}
}
}
performance_track_waves()
{
level endon( "special_op_terminated" );
self endon( "death" );
while ( 1 )
{
level waittill( "wave_ended", current_wave );
self.performance[ "wavebonus" ] = current_wave;
if ( !isdefined( self.survived_a_wave ) )
{
self.survived_a_wave = true;
self thread so_achievement_update( "I_LIVE" );
}
if ( current_wave == 9 )
self thread so_achievement_update( "SURVIVOR" );
if ( current_wave == 14 )
self thread so_achievement_update( "UNSTOPPABLE" );
}
}
reward_calculation()
{
points_headshot = self.performance[ "headshot" ] * level.performance_bonus[ "headshot" ];
points_accuracy = int( max( self.performance[ "accuracy" ] - 25, 0 ) ) * level.performance_bonus[ "accuracy" ];
points_damage = 400;
points_damage -= self.performance[ "damagetaken" ] * level.performance_bonus[ "damagetaken" ];
points_damage = int( max( points_damage, 0 ) );
points_kills	= self.performance[ "kill" ] * level.performance_bonus[ "kill" ];
points_time = 0;
bonus_time = 90;
reward_time = max( bonus_time - int(self.performance[ "time" ]/1000), 0 );
points_time = int( level.performance_bonus[ "time" ] * reward_time );
points_wave = self.performance[ "wavebonus" ] * level.performance_bonus[ "wavebonus" ];
reward_array = [];
reward_array[ "time" ] = points_time;
reward_array[ "headshot" ] = points_headshot;
reward_array[ "accuracy" ] = points_accuracy;
reward_array[ "damagetaken" ] = points_damage;
reward_array[ "kill" ] = points_kills;
reward_array[ "wavebonus" ] = points_wave;
assertex( self.performance.size == reward_array.size, "Reward calculation is missing something!" );
total_points = 0;
foreach ( bonus in reward_array )
total_points += bonus;
reward_array[ "total" ] = get_reward( total_points );
self thread performance_summary_debug( reward_array );
return reward_array;
}
get_reward( points )
{
return int( max( 0, int( points ) ) );
}
camping_think()
{
self endon( "death" );
if ( !isdefined( self.camper_detection ) )
self.camper_detection = false;
self.camping_locs = [];
self.camping_time	= 0;
self thread camp_response();
old_origin = self.origin;
camp_points = 0;
kills = 0;
while ( 1 )
{
self.camping = 0;
self.camping_loc = self.origin;
camp_points = 0;
old_origin = self.origin;
while ( camp_points <= 20 )
{
if ( distance( old_origin, self.origin ) < 220 )
camp_points++;
else
camp_points-=2;
if ( self.health < 40 )
camp_points--;
if ( self.stats[ "kills" ] - kills > 0 )
camp_points += ( self.stats[ "kills" ] - kills );
if (
camp_points <= 0
|| level.survival_wave_intermission
|| ( self ent_flag_exist( "laststand_downed" ) && self ent_flag( "laststand_downed" ) )
)
{
camp_points = 0;
old_origin = self.origin;
}
kills = self.stats[ "kills" ];
wait 1;
}
self.camping = 1;
self.camping_loc = self.origin;
self.camping_locs[ self.camping_locs.size ] = self.camping_loc;
self notify( "camping" );
while ( distance( old_origin, self.origin ) < 260 )
{
self.camping_time++;
wait 1;
}
self notify( "stopped camping" );
}
}
camp_response()
{
self endon( "death" );
level.camp_response_interval = CONST_CAMP_RESPONSE_INTERVAL;
while ( 1 )
{
wait 0.05;
if ( !isdefined( self.camping ) ||
!isdefined( self.camping_loc ) ||
!isdefined( self.camping_time )
)
continue;
if ( self.camping )
{
self thread level_AI_respond( self.camping_loc, self.camping_time );
self thread level_AI_boss_respond( self.camping_loc, self.camping_time );
wait level.camp_response_interval;
}
}
}
level_AI_respond( last_camp_loc, camp_time )
{
all_ai = getaiarray( "axis" );
foreach ( ai in all_ai )
ai thread throw_grenade_at_player( self );
}
level_AI_boss_respond( last_camp_loc, camp_time )
{
if ( isdefined( level.bosses ) && level.bosses.size )
{
responder = level.bosses[ randomint( level.bosses.size ) ];
}
}
survival_credits()
{
level endon( "special_op_terminated" );
foreach ( player in level.players )
player credits_UI_init();
waittill_survival_start();
foreach ( player in level.players )
{
player.survival_credit = 0;
player thread update_from_xp();
player thread update_from_credits();
}
}
update_from_xp()
{
self endon( "death" );
while( 1 )
{
self.old_xp = self.summary[ "rankxp" ];
self.old_credits = self.survival_credit;
self waittill( "xp_updated", xp_type );
if ( !isdefined( xp_type ) )
continue;
increment = self.summary[ "rankxp" ] - self.old_xp;
self.survival_credit += increment;
if ( isdefined( self.rankUpdateTotal ) && self.rankUpdateTotal > increment )
self thread UI_rolling_credits( self.old_credits, self.rankUpdateTotal );
else
self thread UI_rolling_credits( self.old_credits, increment );
self notify( "deposit_credits", increment );
}
}
update_from_credits()
{
self endon( "death" );
while( 1 )
{
self.old_xp = self.summary[ "rankxp" ];
self.old_credits = self.survival_credit;
self waittill( "credit_updated", donation );
increment = self.survival_credit - self.old_credits;
if ( isdefined( self.rankUpdateTotal ) && self.rankUpdateTotal > increment )
self thread UI_rolling_credits( self.old_credits, self.rankUpdateTotal );
else
self thread UI_rolling_credits( self.old_credits, increment );
self notify( "deposit_credits", increment, donation );
}
}
intro_music( type )
{
level endon( "special_op_terminated" );
music_alias = "so_survival_regular_music";
wait 1.5;
MusicPlayWrapper( music_alias );
wait 5;
music_stop( 20 );
}
music_boss( type )
{
level endon( "special_op_terminated" );
level endon( "end_boss_music" );
flag_set( "boss_music" );
music_stop( 3 );
if ( type == "chopper" )
music_alias = "so_survival_boss_music_01";
else if ( type == "juggernaut" )
music_alias = "so_survival_boss_music_02";
else
music_alias = "so_survival_boss_music_01";
music_time = musicLength( music_alias ) + 2;
while ( flag( "boss_music" ) )
{
MusicPlayWrapper( music_alias );
wait( music_time );
}
}
hud_init()
{
level endon( "special_op_terminated" );
}
survival_hud()
{
thread hud_init();
thread wave_splash();
foreach ( player in level.players )
{
player player_reward_splash_init();
player thread wave_HUD();
player thread armor_HUD();
player thread laststand_HUD();
player thread perk_HUD();
player thread enemy_remaining_HUD();
}
}
credits_UI_init()
{
self _setplayerdata_single( "surHUD_credits", 0 );
self _setplayerdata_single( "surHUD_credits_delta", 0 );
self surHUD_enable( "credits" );
}
UI_rolling_credits( old_credits, delta )
{
self notify( "stop_animate_credits" );
self endon( "stop_animate_credits" );
self _setplayerdata_single( "surHUD_credits_delta", 0 );
self surHUD_animate( "credits" );
self _setplayerdata_single( "surHUD_credits", self.survival_credit );
self _setplayerdata_single( "surHUD_credits_delta", delta );
}
wave_timer_player_setup()
{
level endon( "special_op_terminated" );
msg = "Player is either dead or removed while trying to setup its hud.";
assertex( isdefined( self ) && isplayer( self ) && isalive( self ), msg );
clock_icon_size = 28;
xpos = maps\_specialops::so_hud_ypos();
xpos_enemy_left = xpos + 12 + clock_icon_size;
self.hud_so_wave_timer_time = maps\_specialops::so_create_hud_item( -1, xpos, &"SO_SURVIVAL_SURVIVE_TIME", self, true );
self.hud_so_wave_timer_clock = maps\_specialops::so_create_hud_item( -1, xpos-clock_icon_size, undefined, self, true );
self.hud_so_wave_timer_time.alignX = "left";
self.hud_so_wave_timer_clock.alignX = "left";
self.hud_so_wave_timer_clock setShader( "hud_show_timer", clock_icon_size, clock_icon_size );
self.hud_so_wave_timer_clock.alpha = 0;
self.hud_so_wave_timer_time.alpha = 0;
self thread wave_timer_wait_start( self.hud_so_wave_timer_time, self.hud_so_wave_timer_clock );
}
wave_timer_wait_start( hud_time, hud_clock_icon )
{
level endon( "special_op_terminated" );
self endon( "death" );
waittill_survival_start();
while ( 1 )
{
hud_time.label = "";
hud_time settenthstimerup( 0.00 );
start_time = gettime();
hud_time thread maps\_hud_util::fade_over_time( 1.0, 0.5 );
hud_clock_icon thread maps\_hud_util::fade_over_time( 1.0, 0.5 );
level waittill( "wave_ended" );
hud_time.label = "";
pause_time = max( 1, ( gettime() - start_time )/1000 );
hud_time SetTenthsTimerStatic( pause_time );
msg = "";
if ( CONST_WAVE_ENDED_TIMER_FADE_DELAY > 0 )
{
msg = waittill_any_timeout( CONST_WAVE_ENDED_TIMER_FADE_DELAY, "wave_started" );
}
if ( isdefined( msg ) && msg == "wave_started" )
{
hud_time thread maps\_hud_util::fade_over_time( 0.0, 0.0 );
hud_clock_icon thread maps\_hud_util::fade_over_time( 0.0, 0.0 );
}
else
{
hud_time thread maps\_hud_util::fade_over_time( 0.0, 0.5 );
hud_clock_icon thread maps\_hud_util::fade_over_time( 0.0, 0.5 );
level waittill( "wave_started" );
}
}
}
armor_HUD()
{
self endon( "death" );
self.armor_x = 0;
if ( issplitscreen() )
self.armor_y = 112 + ( self == level.player )*27;
else
self.armor_y = 196;
self.armor_shield_size = 28;
self.shield_elem = self special_item_hudelem( self.armor_x, self.armor_y );
self.shield_elem setShader( "teamperk_blast_shield", self.armor_shield_size, self.armor_shield_size );
self.shield_elem.alpha = 0.85;
self.shield_elem_fade	= self special_item_hudelem( self.armor_x, self.armor_y );
self.shield_elem_fade.alpha = 0;
self thread print_armor_hint();
waittillframeend;
while ( 1 )
{
if ( isdefined( self.armor ) && isdefined( self.armor[ "points" ] ) && self.armor[ "points" ] )
{
weaked_armor = 100;
green = float_capped( self.armor["points"] / (weaked_armor/2), 0, 1 );
red = 1 - float_capped( ( self.armor[ "points" ] - weaked_armor/2 ) / (weaked_armor/2), 0, 1 );
self.shield_elem.alpha = 0.85;
self.shield_elem.color = ( 1, float_capped( green, 0, 0.95 ), float_capped( green, 0, 0.7 ) );
self thread armor_jitter();
}
else
{
self.shield_elem.alpha = 0;
}
self waittill_any( "damage", "health_update" );
}
}
armor_jitter()
{
self endon( "death" );
self.shield_elem_fade.alpha = 0.85;
samples = 20;
for( i=0; i<=samples; i++ )
{
jitter_amount = randomint( int( max( 1, 5 - i/(samples/5) ) ) ) - int( 2 - i/(samples/2) );
self.shield_elem.x = self.armor_x + jitter_amount;
self.shield_elem.y = self.armor_y + jitter_amount;
enlarge_amount = int( i*(40/samples) );
self.shield_elem_fade setShader( "teamperk_blast_shield", self.armor_shield_size + enlarge_amount, self.armor_shield_size + enlarge_amount );
self.shield_elem_fade.alpha = max( ( samples*0.85 - i )/samples, 0 );
wait 0.05;
}
self.shield_elem_fade.alpha = 0;
self.shield_elem.x = self.armor_x;
self.shield_elem.y = self.armor_y;
}
print_armor_hint( points )
{
self endon( "death" );
self.armor_label = self special_item_hudelem( self.armor_x, self.armor_y );
self.armor_label.alpha = 0.85;
self.armor_label.elemType = "font";
self.armor_label.label = &"SO_SURVIVAL_ARMOR_POINTS";
self.armor_label.y -= 2;
self.armor_label.x -= 58;
self.armor_label.font = "hudbig";
self.armor_label.fontscale = 0.5;
self.armor_label.width = 0;
self.armor_label.color = ( 1, 0.95, 0.7 );
self.armor_label.alignx = "left";
if ( isdefined( self.armor ) )
self.armor_label setvalue( self.armor[ "points" ] );
else
self.armor_label setvalue( 0 );
initial_display_time = CONST_ARMOR_INITIAL_DISPLAY_TIME;
while ( 1 )
{
if ( !isdefined( self.armor ) || !isdefined( self.armor[ "points" ] ) || !self.armor[ "points" ] )
{
self.armor_label.alpha = 0;
wait 0.05;
continue;
}
self.armor_label.alpha = 0.85;
msg = "";
fade_time = 2;
timer = CONST_ARMOR_DISPLAY_TIME;
while ( timer > 0 || initial_display_time > 0 )
{
msg = self waittill_any_timeout( 0.5, "damage", "health_update" );
self.armor_label setvalue( self.armor[ "points" ] );
timer -= 0.5;
if ( initial_display_time > 0 )
initial_display_time -= 0.5;
if ( self.armor[ "points" ] <= 0 )
{
fade_time = 0.5;
break;
}
}
self.armor_label FadeOverTime( fade_time );
self.armor_label.alpha = 0;
if ( msg != "damage" && msg != "health_update" )
self waittill_any( "damage", "health_update" );
}
}
enemy_remaining_HUD()
{
self endon( "death" );
self surHUD_disable( "enemy" );
self _setplayerdata_single( "surHUD_enemy", 0 );
while ( 1 )
{
level waittill_either( "axis_spawned", "axis_died" );
if ( !flag( "aggressive_mode" ) )
{
self surHUD_disable( "enemy" );
}
else
{
self surHUD_enable( "enemy" );
self _setplayerdata_single( "surHUD_enemy", level.enemy_remaining );
}
}
}
perk_HUD()
{
self endon( "death" );
self.perk_icon_HUD = spawnstruct();
self.perk_icon_HUD.pos_x = -138;
if ( issplitscreen() )
self.perk_icon_HUD.pos_y	= 112 + ( self == level.player )*27;
else
self.perk_icon_HUD.pos_y	= 196;
self.perk_icon_HUD.icon_size	= 28;
self.perk_icon_HUD.icon = self special_item_hudelem( self.perk_icon_HUD.pos_x, self.perk_icon_HUD.pos_y );
self.perk_icon_HUD.icon.color	= ( 1, 1, 1 );
self.perk_icon_HUD.icon.alpha	= 0.0;
while ( 1 )
{
self waittill( "give_perk", ref );
assert( isdefined( level.armory[ "airsupport" ][ ref ] ) );
assert( self hasperk( ref, true ) );
icon = level.armory[ "airsupport" ][ ref ].icon;
self.perk_icon_HUD.icon setShader( icon, self.perk_icon_HUD.icon_size, self.perk_icon_HUD.icon_size );
self.perk_icon_HUD.icon.alpha	= 0.85;
}
}
laststand_HUD()
{
self endon( "death" );
self.laststand_HUD_lives = spawnstruct();
self.laststand_HUD_lives.pos_x = -104;
if ( issplitscreen() )
self.laststand_HUD_lives.pos_y = 112 + ( self == level.player )*27;
else
self.laststand_HUD_lives.pos_y = 196;
self.laststand_HUD_lives.icon_size = 28;
self.laststand_HUD_lives.icon = self special_item_hudelem( self.laststand_HUD_lives.pos_x, self.laststand_HUD_lives.pos_y );
self.laststand_HUD_lives.icon setShader( "specialty_self_revive", self.laststand_HUD_lives.icon_size, self.laststand_HUD_lives.icon_size );
self.laststand_HUD_lives.icon.color	= ( 1, 1, 1 );
self.laststand_HUD_lives.icon.alpha	= 0.0;
while ( 1 )
{
msg = self waittill_any_return( "laststand_lives_updated", "player_downed" );
if ( msg == "player_downed" )
{
self.laststand_HUD_lives.icon.alpha	= 0.0;
}
else if ( self maps\_laststand::get_lives_remaining() > 0 )
{
self.laststand_HUD_lives.icon.alpha	= 1;
}
else
{
self.laststand_HUD_lives.icon.alpha	= 0.0;
}
}
}
special_item_hudelem( pos_x, pos_y )
{
elem = NewClientHudElem( self );
elem.hidden = false;
elem.elemType = "icon";
elem.hideWhenInMenu = true;
elem.archived = false;
elem.x = pos_x;
elem.y = pos_y;
elem.alignx = "center";
elem.aligny = "middle";
elem.horzAlign = "center";
elem.vertAlign = "middle";
return elem;
}
wave_HUD()
{
self endon( "death" );
self surHUD_disable( "wave" );
self _setplayerdata_single( "surHUD_wave", 0 );
while ( 1 )
{
level waittill( "wave_started" );
self surHUD_enable( "wave" );
self _setplayerdata_single( "surHUD_wave", level.current_wave );
}
}
matchStartTimer( duration )
{
matchStartTimer = self creatCountDownHudElem( "hudbig", 1 );
matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
matchStartTimer.sort = 1001;
matchStartTimer.glowColor = ( 0.15, 0.35, 0.85 );
matchStartTimer.color	= ( 0.95, 0.95, 0.95 );
matchStartTimer.foreground = false;
matchStartTimer.hidewheninmenu = true;
matchStartTimer fontPulseInit();
matchStartTimer_Internal( int( duration ), matchStartTimer );
matchStartTimer destroy();
}
fontPulseInit( maxFontScale )
{
self.baseFontScale = self.fontScale;
if ( isDefined( maxFontScale ) )
self.maxFontScale = min( maxFontScale, 6.3 );
else
self.maxFontScale = min( self.fontScale * 2, 6.3 );
self.inFrames = 2;
self.outFrames = 4;
}
creatCountDownHudElem( font, fontScale )
{
fontElem = NewClientHudElem( self );
fontElem.elemType = "font";
fontElem.font = "hudbig";
fontElem.fontscale = fontScale;
fontElem.baseFontScale = fontScale;
fontElem.x = 0;
fontElem.y = 0;
fontElem.width = 0;
fontElem.height = int(level.fontHeight * fontScale);
fontElem.xOffset = 0;
fontElem.yOffset = 0;
fontElem.children = [];
fontElem setParent( level.uiParent );
fontElem.hidden = false;
return fontElem;
}
matchStartTimer_Internal( countTime, matchStartTimer )
{
while ( countTime > 0 )
{
if ( countTime > 99 )
matchStartTimer.alpha = 0;
else
matchStartTimer.alpha = 1;
foreach( player in level.players )
player PlaySound( "so_countdown_beep" );
matchStartTimer thread fontPulse();
wait ( matchStartTimer.inFrames * 0.05 );
matchStartTimer setValue( countTime );
countTime--;
wait ( 1 - (matchStartTimer.inFrames * 0.05) );
}
}
fontPulse()
{
self notify ( "fontPulse" );
self endon ( "fontPulse" );
self endon( "death" );
self ChangeFontScaleOverTime( self.inFrames * 0.05 );
self.fontScale = self.maxFontScale;
wait self.inFrames * 0.05;
self ChangeFontScaleOverTime( self.outFrames * 0.05 );
self.fontScale = self.baseFontScale;
}
player_performance_UI_init()
{
self player_performance_reset();
self surHUD_disable( "performance" );
}
performance_summary( reward_array )
{
self endon( "death" );
assertex( isdefined( self.performance ), "Player performance data is not initialized." );
if ( is_coop() )
waittillframeend;
foreach ( index_string, performance in self.performance )
{
self _setplayerdata_array( "surHUD_performance", index_string, self.performance[ index_string ] );
self _setplayerdata_array( "surHUD_performance_credit", index_string, reward_array[ index_string ] );
if ( is_coop() )
{
player_2 = get_other_player( self );
assertex( isdefined( player_2.performance ), "Other player's performance stats are not setup." );
assertex( isdefined( player_2.performance[ index_string ] ), "Other player's performance["+index_string+"] is not setup." );
self _setplayerdata_array( "surHUD_performance_p2", index_string, player_2.performance[ index_string ] );
}
}
self _setplayerdata_single( "surHUD_performance_reward", reward_array[ "total" ] );
wait 1;
self surHUD_animate( "performance" );
}
performance_summary_debug( reward_array )
{
bar = "---------------------------------------------";
title = "COOP";
if ( !is_coop() )
title = "SOLO";
println( "====================" + title + "=====================" );
println( "WAVE: " + level.current_wave );
println( bar );
foreach ( index_string, reward in reward_array )
{
if( index_string == "total" )
continue;
println( index_string + ": " + self.performance[ index_string ]	+ " = $" + reward );
}
println( bar );
println( "TOTAL CREDITS REWARDED: $" + reward_array[ "total" ] );
}
wave_splash()
{
level endon( "special_op_terminated" );
waittill_survival_start();
while ( 1 )
{
level waittill( "wave_started" );
thread wave_start_splash( "" );
level waittill( "wave_ended", wave_num );
waittill_players_ready_for_splash( 10 );
thread wave_clear_splash( wave_num );
}
}
wave_start_splash( waveDesc )
{
splashData = SpawnStruct();
splashData.title = &"SO_SURVIVAL_WAVE_TITLE";
splashData.duration = 1.5;
splashData.sound = "survival_wave_start_splash";
array_thread( level.players, ::player_wave_splash, splashData );
}
wave_clear_splash( wave_num )
{
splashData = SpawnStruct();
splashData.title = &"SO_SURVIVAL_WAVE_SUCCESS_TITLE";
splashData.title_set_value = wave_num;
splashData.duration = 2.5;
splashData.sound = "survival_wave_end_splash";
array_thread( level.players, ::player_wave_splash, splashData );
}
player_wave_splash( splashData )
{
if( IsDefined( self.doingNotify ) && self.doingNotify )
{
while( self.doingNotify )
wait( 0.05 );
}
if ( !isdefined( splashData.duration ) )
splashData.duration = 1.5;
splashData.title_glowColor = ( 0.15, 0.35, 0.85 );
splashData.title_color = ( 0.95, 0.95, 0.95 );
splashData.type = "wave";
splashData.title_font = "hudbig";
splashData.playSoundLocally = true;
splashData.zoomIn = true;
splashData.zoomOut = true;
splashData.fadeIn = true;
splashData.fadeOut = true;
if( IsSplitscreen() )
{
splashData.title_baseFontScale = 1;
splashData.desc_baseFontScale = 1.2;
}
else
{
splashData.title_baseFontScale = 1.1;
splashData.desc_baseFontScale = 1.2;
}
self splash_notify_message( splashData );
}
survival_armory_hint()
{
level endon( "special_op_terminated" );
foreach( player in level.players )
{
player surHUD_disable( "armory" );
player _setplayerdata_array( "surHUD_unlock_hint_armory", "name", "" );
player _setplayerdata_array( "surHUD_unlock_hint_armory", "icon", "" );
player _setplayerdata_array( "surHUD_unlock_hint_armory", "desc", "" );
}
while( 1 )
{
level waittill( "armory_open", armory_ent );
armory_name = "";
armory_desc = "";
armory_icon = armory_ent.icon;
if ( armory_ent.armory_type == "weapon" )
{
armory_name = "@SO_SURVIVAL_ARMORY_WEAPON_AV";
armory_desc = "@SO_SURVIVAL_ARMORY_WEAPON_DESC";
}
else if ( armory_ent.armory_type == "airsupport" )
{
armory_name = "@SO_SURVIVAL_ARMORY_AIRSUPPORT_AV";
armory_desc = "@SO_SURVIVAL_ARMORY_AIRSUPPORT_DESC";
}
else if ( armory_ent.armory_type == "equipment" )
{
armory_name = "@SO_SURVIVAL_ARMORY_EQUIPMENT_AV";
armory_desc = "@SO_SURVIVAL_ARMORY_EQUIPMENT_DESC";
}
foreach( player in level.players )
{
player _setplayerdata_array( "surHUD_unlock_hint_armory", "name", armory_name );
player _setplayerdata_array( "surHUD_unlock_hint_armory", "icon", armory_icon );
player _setplayerdata_array( "surHUD_unlock_hint_armory", "desc", armory_desc );
player surHUD_animate( "armory" );
}
}
}




