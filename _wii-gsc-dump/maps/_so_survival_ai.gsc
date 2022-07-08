#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_so_survival_code;
WAVE_TABLE = "sp/survival_waves.csv";
TABLE_INDEX = 0;
TABLE_BOSS_DELAY = 1;
TABLE_WAVE = 2;
TABLE_SQUAD_TYPE = 3;
TABLE_SQUAD_SIZE = 4;
TABLE_SPECIAL = 5;
TABLE_SPECIAL_NUM = 6;
TABLE_BOSS_AI = 7;
TABLE_BOSS_NONAI = 8;
TABLE_REPEAT = 9;
TABLE_ARMORY_UNLOCK = 10;
TABLE_AI_REF = 1;
TABLE_AI_NAME = 2;
TABLE_AI_DESC = 3;
TABLE_AI_CLASSNAME = 4;
TABLE_AI_WEAPON = 5;
TABLE_AI_ALT_WEAPON = 6;
TABLE_AI_HEALTH = 7;
TABLE_AI_SPEED = 8;
TABLE_AI_XP = 9;
TABLE_AI_BOSS = 10;
TABLE_AI_ACCURACY = 11;
TABLE_WAVE_DEF_INDEX_START = 0;
TABLE_WAVE_DEF_INDEX_END = 40;
TABLE_AI_TYPE_INDEX_START = 100;
TABLE_AI_TYPE_INDEX_END = 120;
CONST_WEAPON_DROP_RATE = 1;
CONST_AI_UPDATE_DELAY = 4.0;
CONST_AI_SEARCH_PLAYER_TIME = 6.0;
CONST_LONG_DEATH_REMOVE_DIST_MIN = 540;
CONST_AI_REPEAT_BOOST_HEALTH = 0.10;
CONST_AI_REPEAT_BOOST_SPEED = 0.05;
CONST_AI_SPEED_MAX = 1.5;
CONST_AI_REPEAT_BOOST_ACCURACY = 0.2;
CONST_NODE_CLOSEST_RADIUS_MIN = 1;
CONST_NODE_CLOSEST_RADIUS_MAX = 128;
CONST_NODE_CLOSEST_RADIUS_INCREASE = 64;
CONST_NODE_CLOSEST_RADIUS_INVALID = 2048;
CONST_NODE_CLOSEST_HEIGHT = 512;
CONST_NODE_CLOSEST_HEIGHT_INCREASE = 128;
CONST_REGULAR_GOAL_RADIUS_DEFAULT = 900;
CONST_REGULAR_GOAL_RADIUS_AGGRESSIVE	= 384;
CONST_MARTYRDOM_GOAL_RADIUS_DEFAULT = 900;
CONST_MARTYRDOM_GOAL_RADIUS_AGGRESSIVE	= 384;
CONST_CLAYMORE_GOAL_RADIUS_DEFAULT = 900;
CONST_CLAYMORE_GOAL_RADIUS_AGGRESSIVE	= 384;
CONST_CHEMICAL_GOAL_RADIUS_DEFAULT = 512;
CONST_CHEMICAL_GOAL_RADIUS_AGGRESSIVE	= 384;
CONST_ALLY_GOAL_RADIUS = 512;
CONST_ALLY_GOAL_RADIUS_RIOTSHIELD = 448;
CONST_GENERIC_AI_ENGAGE_MIN = 88;
CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF	= 64;
CONST_MARTYRDOM_C4_SOUND_TELL_LENGTH	= 1.5;
CONST_MARTYRDOM_C4_TIMER = 3;
CONST_MARTYRDOM_C4_TIMER_SUBSEQUENT = 0.4;
CONST_MARTYRDOM_C4_PHYS_RADIUS = 256;
CONST_MARTYRDOM_C4_PHYS_FORCE = 2;
CONST_MARTYRDOM_C4_QUAKE_SCALE = 0.4;
CONST_MARTYRDOM_C4_QUAKE_TIME = 0.8;
CONST_MARTYRDOM_C4_QUAKE_RADIUS = 600;
CONST_MARTYRDOM_C4_DMG_RADIUS = 192;
CONST_MARTYRDOM_C4_DMG_MAX = 100;
CONST_MARTYRDOM_C4_DMG_MIN = 50;
CONST_MARTYRDOM_C4_DANGER_RANGE = CONST_MARTYRDOM_C4_DMG_RADIUS - 48;
CONST_CLAYMORE_PLACED_MAX = 6;
CONST_MINE_LOC_UPDATE_DELAY = 0.5;
CONST_MINE_LOC_WEIGHT_MAX = 20;
CONST_MINE_LOC_WEIGHT_INC = 0.5;
CONST_MINE_LOC_WEIGHT_DECAY = 0.025;
CONST_MINE_LOC_RANGE_PLAYER
= 512;
CONST_MINE_PLANT_CHECK_DELAY = 2.0;
CONST_MINE_PLANT_TIME_BETWEEN = 8.0;
CONST_MINE_PLANT_DIST_PLAYER_MIN = 384;
CONST_MINE_PLANT_DIST_AI_MAX = 768;
CONST_MINE_PLANT_HEIGHT_AI_MAX = 240;
CONST_MINE_PLANT_WEIGHT_MIN = 2.0;
CONST_CLAYMORE_ENT_TIMER = 0.75;
CONST_CLAYMORE_ENT_TRIG_ANGLE = 70;
CONST_CLAYMORE_ENT_TRIG_DIST_MIN = 20;
CONST_CLAYMORE_ENT_PHYS_RADIUS = 256;
CONST_CLAYMORE_ENT_PHYS_FORCE = 2;
CONST_CLAYMORE_ENT_QUAKE_SCALE = 0.4;
CONST_CLAYMORE_ENT_QUAKE_TIME = 0.8;
CONST_CLAYMORE_ENT_QUAKE_RADIUS = 600;
CONST_CLAYMORE_ENT_TRIG_RADIUS = 192;
CONST_CLAYMORE_ENT_DMG_RADIUS = 192;
CONST_CLAYMORE_ENT_DMG_MAX = 100;
CONST_CLAYMORE_ENT_DMG_MIN = 50;
CONST_CHEMBOMB_ENT_TIMER = 0.5;
CONST_CHEMBOMB_ENT_TRIG_RADIUS = 96;
CONST_CHEMBOMB_CLOUD_LIFE_TIME = 6.0;
CONST_CHEMBOMB_CLOUD_BADPLACE_LIFE_TIME	= 1.0;
CONST_CHEMICAL_TANK_PHYS_RADIUS = 256;
CONST_CHEMICAL_TANK_PHYS_FORCE = 0.5;
CONST_CHEMICAL_TANK_QUAKE_SCALE = 0.2;
CONST_CHEMICAL_TANK_QUAKE_TIME = 0.4;
CONST_CHEMICAL_TANK_QUAKE_RADIUS = 600;
CONST_CHEMICAL_TANK_DMG_RADIUS = 192;
CONST_CHEMICAL_TANK_DMG_MAX = 20;
CONST_CHEMICAL_TANK_DMG_MIN = 10;
CONST_CHEMICAL_CLOUD_TRIG_RADIUS = 96;
CONST_CHEMICAL_CLOUD_LIFE_TIME = 6.0;
CONST_CHEMICAL_CLOUD_BADPLACE_LIFE_TIME	= 2.0;
CONST_CHEMICAL_CLOUD_SHOCK_TIME = 1.5;
CONST_CHEMICAL_CLOUD_SHOCK_DELAY = 1.0;
CONST_JUG_POP_HELMET_HEALTH_PERCENT = 0.33;
CONST_JUG_DROP_SHIELD_HEALTH_PERCENT	= 0.50;
CONST_JUG_WEAKENED = 250;
CONST_JUG_MIN_DAMAGE_PAIN = 350;
CONST_JUG_MIN_DAMAGE_PAIN_WEAK = 250;
CONST_JUG_RUN_DIST = 1000;
CONST_JUG_WEAKENED_RUN_DIST = 500;
CONST_JUG_RIOTSHIELD_BULLET_BLOCK = 1;
CONST_JUG_HIGH_SHIELD = 0.25;
CONST_JUG_MED_SHIELD = 0.33;
CONST_JUG_LOW_SHIELD = 0.75;
CONST_JUG_NO_SHIELD = 1.0;
CONST_JUG_KILL_ON_PAIN = 9999;
CONST_CHOPPER_SPEED = 60;
CONST_CHOPPER_ACCEL = 20;
CONST_ALLY_BULLET_SHIELD_TIME = 20;
CONST_DOG_SPAWN_OVER_TIME = 50;
CONST_DOGSPLODE_C4_TIMER_NECK_SNAP = 5;
CONST_DOG_TIME_STATIC_TO_DETONATE = 2000;
CONST_DOG_DIST_TO_SENTRY_DETONATE = 40;
CONST_DOG_SAME_LOC_THRESHOLD = 10;
AI_preload()
{
AI_preload_weapons();
PrecacheHeadIcon( "headicon_delta_so" );
PrecacheHeadIcon( "headicon_gign_so" );
precacheModel( "weapon_c4" );
level._effect[ "martyrdom_c4_explosion" ] = loadfx( "explosions/grenadeExp_metal" );
level._effect[ "martyrdom_dlight_red" ] = loadfx( "misc/dlight_red" );
level._effect[ "martyrdom_red_blink" ] = loadfx( "misc/power_tower_light_red_blink" );
PrecacheModel( "weapon_claymore" );
level._effect[ "claymore_laser" ] = loadfx( "misc/claymore_laser" );
level._effect[ "claymore_explosion" ] = loadfx( "explosions/grenadeExp_metal" );
level._effect[ "claymore_disabled" ] = loadfx( "explosions/sentry_gun_explosion" );
precachemodel( "gas_canisters_backpack" );
precachemodel( "ims_scorpion_explosive1" );
precacheShellShock( "radiation_low" );
precacheShellShock( "radiation_med" );
precacheShellShock( "radiation_high" );
level._effect[ "chemical_tank_explosion" ] = loadfx( "smoke/so_chemical_explode_smoke" );
level._effect[ "chemical_tank_smoke" ] = loadfx( "smoke/so_chemical_stream_smoke" );
level._effect[ "chemical_mine_spew" ] = loadfx( "smoke/so_chemical_mine_spew" );
level._effect[ "money" ] = loadfx ("props/cash_player_drop");
maps\_chopperboss::chopper_boss_load_fx();
animscripts\dog\dog_init::initDogAnimations();
}
AI_preload_weapons()
{
index_start = TABLE_AI_TYPE_INDEX_START;
index_end = TABLE_AI_TYPE_INDEX_END;
for( i = index_start; i <= index_end; i++ )
{
ai_weapons = get_ai_weapons( get_ai_ref_by_index( i ) );
foreach( w in ai_weapons )
precacheitem( w );
}
}
AI_init()
{
SetSavedDvar( "ai_dropAkimboChance", 0 );
if ( !isdefined( level.wave_table ) )
level.wave_table = WAVE_TABLE;
level.survival_ai = [];
level.survival_boss = [];
level.survival_ai = ai_type_populate();
level.survival_repeat_wave = [];
level.survival_waves_repeated = 0;
level.survival_wave = [];
level.survival_wave = wave_populate();
createthreatbiasgroup( "sentry" );
createthreatbiasgroup( "allies" );
createthreatbiasgroup( "axis" );
createthreatbiasgroup( "boss" );
createthreatbiasgroup( "dogs" );
setignoremegroup( "sentry", "dogs" );
setthreatbias( "sentry", "boss", 50 );
setthreatbias( "sentry", "axis", 50 );
setthreatbias( "boss", "allies", 2000 );
setthreatbias( "dogs", "allies", 1000 );
setthreatbias( "axis", "allies", 0 );
foreach ( player in level.players )
{
player.onlyGoodNearestNodes = true;
player thread update_player_closest_node_think();
}
level.attributes_func = ::setup_attributes;
level.squad_leader_behavior_func = ::default_ai;
level.special_ai_behavior_func = ::default_ai;
level.squad_drop_weapon_rate = CONST_WEAPON_DROP_RATE;
add_global_spawn_function( "axis", ::no_grenade_bag_drop );
add_global_spawn_function( "axis", ::weapon_drop_ammo_adjustment );
add_global_spawn_function( "axis", ::update_enemy_remaining );
add_global_spawn_function( "axis", ::ai_on_long_death );
register_xp();
thread survival_AI_regular();
thread survival_AI_martyrdom();
thread survival_AI_claymore_and_chemical();
thread survival_boss_juggernaut();
thread survival_drop_chopper_init();
thread survival_boss_chopper();
thread dog_relocate_init();
battlechatter_on( "allies" );
battlechatter_on( "axis" );
}
wave_populate()
{
index_start = TABLE_WAVE_DEF_INDEX_START;
index_end = TABLE_WAVE_DEF_INDEX_END;
waves = [];
for ( i = index_start; i <= index_end; i++ )
{
wave_num = get_wave_number_by_index( i );
if ( !isdefined( wave_num ) || wave_num == 0 )
continue;
wave = spawnstruct();
wave.idx = i;
wave.num = wave_num;
wave.squadType = get_squad_type( wave_num );
wave.squadArray = get_squad_array( wave_num );
wave.specialAI = get_special_ai( wave_num );
wave.specialAIquantity	= get_special_ai_quantity( wave_num );
wave.bossDelay = get_wave_boss_delay( wave_num );
wave.bossAI = get_bosses_ai( wave_num );
wave.bossNonAI = get_bosses_nonai( wave_num );
wave.dogType = get_dog_type( wave_num );
wave.dogQuantity = get_dog_quantity( wave_num );
wave.repeating = is_repeating( wave_num );
unlock_armory_array = get_armory_unlocked( wave_num );
if ( isdefined( unlock_armory_array ) && unlock_armory_array.size )
{
if ( !isdefined( level.armory_unlock ) )
level.armory_unlock = [];
foreach ( unlock_armory in unlock_armory_array )
level.armory_unlock[ unlock_armory ] = wave_num;
}
waves[ wave_num ] = wave;
if ( wave.repeating )
level.survival_repeat_wave[ level.survival_repeat_wave.size ] = wave;
}
assertex( isdefined( level.survival_repeat_wave ) && level.survival_repeat_wave.size, "At least one wave must be set to repeating." );
thread wait_calculate_max_wave_stream_size();
return waves;
}
ai_type_add_override_class( ai_type, class_new )
{
AssertEx( IsDefined( ai_type ) && IsString( ai_type ), "The AI type should be a string." );
AssertEx( IsDefined( class_new ) && IsString( class_new ), "The new AI class should be a string." );
if ( !IsDefined( level.survival_ai_class_overrides ) )
{
level.survival_ai_class_overrides = [];
}
level.survival_ai_class_overrides[ ai_type ] = class_new;
}
ai_type_add_override_weapons( ai_type, weapons_new )
{
AssertEx( IsDefined( ai_type ) && IsString( ai_type ), "The AI type should be a string." );
AssertEx( IsDefined( weapons_new ) && IsArray( weapons_new ) && weapons_new.size, "The new AI weapons parm should be a filled array." );
if ( !IsDefined( level.survival_ai_weapon_overrides ) )
{
level.survival_ai_weapon_overrides = [];
}
foreach ( weapon in weapons_new )
{
PreCacheItem( weapon );
}
level.survival_ai_weapon_overrides[ ai_type ] = weapons_new;
}
ai_type_populate()
{
index_start = TABLE_AI_TYPE_INDEX_START;
index_end = TABLE_AI_TYPE_INDEX_END;
ai_types	= [];
for ( i = index_start; i <= index_end; i++ )
{
ref = get_ai_ref_by_index( i );
if ( !isdefined( ref ) || ref == "" )
continue;
ai = spawnstruct();
ai.idx = i;
ai.ref = ref;
ai.name = get_ai_name( ref );
ai.desc = get_ai_desc( ref );
ai.classname	= get_ai_classname( ref );
ai.weapon = get_ai_weapons( ref );
ai.altweapon	= get_ai_alt_weapons( ref );
ai.health = get_ai_health( ref );
ai.speed = get_ai_speed( ref );
ai.accuracy = get_ai_accuracy( ref );
ai.XP = get_ai_xp( ref );
if ( is_ai_boss( ref ) )
level.survival_boss[ ref ] = ai;
ai_types[ ref ] = ai;
}
return ai_types;
}
giveXp_kill( victim, XP_mod )
{
assertex( isPlayer( self ), "Trying to give XP to non Player" );
assertex( isdefined( victim ), "Trying to give XP reward on something that is not defined" );
XP_type = "kill";
if ( isdefined( victim.ai_type ) )
XP_type = "survival_ai_" + victim.ai_type.ref;
value = undefined;
if ( isdefined( XP_mod ) )
{
reward = maps\_rank::getScoreInfoValue( XP_type );
if ( isdefined( reward ) )
value = reward * XP_mod;
}
self givexp( XP_type, value );
}
register_xp()
{
foreach ( ai in level.survival_ai )
maps\_rank::registerScoreInfo( "survival_ai_" + ai.ref, get_ai_xp( ai.ref ) );
}
update_player_closest_node_think()
{
AssertEx( IsPlayer( self ), "Self should be a player in update_player_closest_node_think()" );
self endon( "death" );
level endon( "special_op_terminated" );
max_radius = CONST_NODE_CLOSEST_RADIUS_MAX;
min_radius = CONST_NODE_CLOSEST_RADIUS_MIN;
max_height = CONST_NODE_CLOSEST_HEIGHT;
while ( 1 )
{
closestNode = GetClosestNodeInSight( self.origin );
if ( IsDefined( closestNode ) )
{
if ( closestNode.type != "Begin" && closestNode.type != "End" && closestNode.type != "Turret" )
self.node_closest = closestNode;
}
wait 0.25;
}
}
update_enemy_remaining()
{
level endon( "special_op_terminated" );
waittillframeend;
level.enemy_remaining = get_survival_enemies_living().size;
level notify( "axis_spawned" );
self waittill( "death" );
waittillframeend;
enemies_alive = get_survival_enemies_living();
level.enemy_remaining = enemies_alive.size;
level notify( "axis_died" );
if	(
flag( "aggressive_mode" )
&&	enemies_alive.size == 1
&&	isai( enemies_alive[ 0 ] )
&&	enemies_alive[ 0 ].type != "dog"
)
{
enemies_alive[ 0 ] thread prevent_long_death();
}
}
get_survival_enemies_living()
{
enemy_array = getaiarray( "axis" );
if ( IsDefined( level.bosses ) && level.bosses.size )
enemy_array = array_merge( enemy_array, level.bosses );
enemy_array = array_merge( enemy_array, dog_get_living() );
return enemy_array;
}
prevent_long_death()
{
level endon( "special_op_terminated" );
self endon( "death" );
if ( !isdefined( self.a.doingLongDeath ) )
{
self disable_long_death();
return;
}
while ( 1 )
{
safe_to_kill = true;
foreach ( player in level.players )
{
player_too_close = Distance2D( player.origin, self.origin ) < CONST_LONG_DEATH_REMOVE_DIST_MIN;
if ( player_too_close )
{
safe_to_kill = false;
break;
}
if ( self CanSee( player ) )
{
safe_to_kill = false;
break;
}
wait 0.05;
}
if ( safe_to_kill )
{
attacker = self get_last_attacker();
if ( isdefined( attacker ) )
self Kill( self.origin, attacker );
else
self Kill( self.origin );
return;
}
wait 0.1;
}
}
get_last_attacker()
{
assertex( isdefined( self ), "Self must be defined to check for last attacker." );
attacker = undefined;
if ( isdefined( self.attacker_list ) && self.attacker_list.size )
attacker = self.attacker_list[ self.attacker_list.size - 1 ];
return attacker;
}
weapon_drop_ammo_adjustment()
{
if ( !isai( self ) || isdefined( self.type ) && self.type == "dog" )
return;
if ( !isdefined( level.armory ) || !isdefined( level.armory[ "weapon" ] ) )
return;
level endon( "special_op_terminated" );
self waittill( "weapon_dropped", weapon );
if ( !isdefined( weapon ) )
return;
weapon_name = GetSubStr( weapon.classname, 7 );
wait ( 0.05 );
weapon_struct = level.armory[ "weapon" ][ weapon_name ];
if ( !isdefined( weapon ) || !isdefined( weapon_struct ) )
return;
assert( isdefined( weapon_struct.dropclip ) && isdefined( weapon_struct.dropstock ) );
ammo_in_clip = weapon_struct.dropclip;
ammo_stock = weapon_struct.dropstock;
weapon ItemWeaponSetAmmo( ammo_in_clip, ammo_stock );
alt_weapon = WeaponAltWeaponName( weapon_name );
if( alt_weapon != "none" )
{
alt_clip = int( max( 1, WeaponClipSize( alt_weapon ) ) );
alt_stock = int( max( 1, WeaponMaxAmmo( alt_weapon ) ) );
weapon ItemWeaponSetAmmo( alt_clip, alt_stock, alt_clip, 1 );
}
}
no_grenade_bag_drop()
{
level.nextGrenadeDrop	= 100000;
}
money_fx_on_death()
{
level endon( "special_op_terminated" );
self waittill( "death" );
if ( !isdefined( self ) )
return;
playFx( level._effect[ "money" ], self.origin + ( 0, 0, 32 ) );
}
ai_on_long_death()
{
if ( !isai( self ) || isdefined( self.type ) && self.type == "dog" )
return;
self endon( "death" );
level endon( "special_op_terminated" );
self waittill( "long_death" );
self waittill( "flashbang", flash_origin, flash_dist, flash_angle, attacker );
if ( isdefined( attacker ) && isdefined( attacker.team ) && attacker.team == "allies" )
self kill( self.origin, attacker );
}
get_ai_type_ref()
{
assertex( isdefined( self ) && isalive( self ), "Trying to AI type when AI is undefined or dead." );
if ( isdefined( self.ai_type ) )
return self.ai_type.ref;
if ( isdefined( level.leaders ) )
{
foreach( leader in level.leaders )
{
if ( leader == self )
return get_squad_type( level.current_wave );
}
}
if ( isdefined( self.leader ) && isAI( self.leader ) )
return get_squad_type( level.current_wave );
assertex( false, "Failed to assign AI_type_ref for AI: " + self.unique_id );
return undefined;
}
get_special_ai_array( ref )
{
assert( isdefined( ref ) );
arr_ai_type = [];
if ( isdefined( level.special_ai ) && level.special_ai.size )
{
foreach( ai in level.special_ai )
if ( isalive( ai ) && isdefined( ai.ai_type ) && ai.ai_type.ref == ref )
arr_ai_type[ arr_ai_type.size ] = ai;
}
return arr_ai_type;
}
default_ai()
{
assertex( isdefined( self ) && isalive( self ) && isAI( self ), "Default AI behavior func was called on nonAI or is removed/dead." );
self notify( "ai_behavior_change" );
self.aggressivemode = true;
self.aggressing = undefined;
ai_ref = self [[ level.attributes_func ]]();
if ( ai_ref == "martyrdom" )
{
self thread behavior_special_ai_martyrdom();
return;
}
if ( ai_ref == "claymore" )
{
self thread behavior_special_ai_claymore();
return;
}
if ( ai_ref == "chemical" )
{
self thread behavior_special_ai_chemical();
return;
}
if ( ai_ref == "easy" || ai_ref == "regular" || ai_ref == "hardened" || ai_ref == "veteran" || ai_ref == "elite" )
self thread default_squad_leader();
}
aggressive_ai()
{
assertex( isdefined( self ) && isalive( self ) && isAI( self ), "Default AI behavior func was called on nonAI or is removed/dead." );
self notify( "ai_behavior_change" );
self.aggressivemode = true;
self.aggressing = true;
ai_ref = self [[ level.attributes_func ]]();
if ( ai_ref == "martyrdom" )
{
self thread behavior_special_ai_martyrdom();
return;
}
if ( ai_ref == "claymore" )
{
self thread behavior_special_ai_claymore();
return;
}
if ( ai_ref == "chemical" )
{
self thread behavior_special_ai_chemical();
return;
}
if ( ai_ref == "easy" || ai_ref == "regular" || ai_ref == "hardened" || ai_ref == "veteran" || ai_ref == "elite" )
self thread aggressive_squad_leader();
}
setup_attributes()
{
if ( isdefined( self.attributes_set ) && isdefined( self.ai_type ) )
return self.ai_type.ref;
ai_ref = self get_ai_type_ref();
if ( !isdefined( self.ai_type ) )
{
ai_type_struct = get_ai_struct( ai_ref );
assertex( isdefined( ai_type_struct ), "Failed to find struct for AI type: " + ai_ref );
self.ai_type = ai_type_struct;
}
is_vehicle = ( isdefined( self.code_classname ) && self.code_classname == "script_vehicle" );
set_health = get_ai_health( ai_ref );
if ( isdefined( set_health ) && !is_vehicle )
self.health = set_health;
speed_scale = get_ai_speed( ai_ref );
if ( isdefined( speed_scale ) )
{
if ( is_vehicle )
self Vehicle_SetSpeed( CONST_CHOPPER_SPEED * speed_scale, CONST_CHOPPER_ACCEL * speed_scale );
else
self.moveplaybackrate = speed_scale;
}
set_accuracy = get_ai_accuracy( ai_ref );
if ( isdefined( set_accuracy ) )
self set_baseaccuracy( set_accuracy );
alt_weapons	= get_ai_alt_weapons( ai_ref );
foreach ( alt_weapon in alt_weapons )
{
if ( alt_weapon == "fraggrenade" )
{
self.grenadeammo = 2;
self.grenadeweapon = "fraggrenade";
}
if ( alt_weapon == "flash_grenade" )
{
self.grenadeammo = 2;
self.grenadeweapon = "flash_grenade";
}
}
if( isdefined( self.dropweapon ) && self.dropweapon && isdefined( level.squad_drop_weapon_rate ) )
{
drop_chance = randomfloat( 1 );
if( drop_chance > level.squad_drop_weapon_rate )
self.dropweapon = false;
}
self.advance_regardless_of_numbers = true;
self.reacquire_without_facing = true;
self.minExposedGrenadeDist = 256;
self.attributes_set = true;
return ai_ref;
}
survival_boss_behavior()
{
self endon( "death" );
msg = "Boss does not have AI_Type struct, should have been passed when spawning by AI_Type.";
assertex( isdefined( self.ai_type ), msg );
boss_ref = self [[ level.attributes_func ]]();
if ( !isdefined( boss_ref ) )
return;
if ( boss_ref == "jug_regular" )
{
self global_jug_behavior();
self thread boss_jug_regular();
return;
}
if ( boss_ref == "jug_headshot" )
{
self global_jug_behavior();
self thread boss_jug_headshot();
return;
}
if ( boss_ref == "jug_explosive" )
{
self global_jug_behavior();
self thread boss_jug_explosive();
return;
}
if ( boss_ref == "jug_riotshield" )
{
self global_jug_behavior();
self thread boss_jug_riotshield();
return;
}
}
survival_AI_regular()
{
}
default_squad_leader()
{
self.goalradius = CONST_REGULAR_GOAL_RADIUS_DEFAULT;
self.aggressing = undefined;
self setengagementmindist( 300, 200 );
self setengagementmaxdist( 512, 768 );
self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change demotion" );
}
aggressive_squad_leader()
{
self.goalradius = CONST_REGULAR_GOAL_RADIUS_AGGRESSIVE;
self.aggressing = true;
self enable_heat_behavior( true );
self disable_surprise();
self setengagementmindist( CONST_GENERIC_AI_ENGAGE_MIN, CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF );
self setengagementmaxdist( 512, 768 );
self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change demotion" );
}
behavior_special_ai_martyrdom()
{
self endon( "death" );
self endon( "ai_behavior_change" );
if ( !isdefined( self.special_ability ) )
self thread martyrdom_ability();
engage_min_dist = 0;
engage_min_dist_fall_off	= 0;
if ( isdefined( self.aggressing ) && self.aggressing )
{
engage_min_dist = CONST_GENERIC_AI_ENGAGE_MIN;
engage_min_dist_fall_off	= CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF;
self.goalradius = CONST_MARTYRDOM_GOAL_RADIUS_AGGRESSIVE;
self enable_heat_behavior( true );
self disable_surprise();
}
else
{
engage_min_dist = 200;
engage_min_dist_fall_off	= 100;
self.goalradius = CONST_MARTYRDOM_GOAL_RADIUS_DEFAULT;
}
self setengagementmindist( engage_min_dist, engage_min_dist_fall_off );
self setengagementmaxdist( 512, 768 );
self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change" );
}
survival_AI_martyrdom()
{
}
martyrdom_ability()
{
self.special_ability = true;
self.forceLongDeath = true;
self thread attach_c4( "j_spine4", (0,6,0), (0,0,-90) );
self thread attach_c4( "tag_stowed_back", (0,1,5), (80,90,0) );
self thread detonate_c4_when_dead( CONST_MARTYRDOM_C4_TIMER, CONST_MARTYRDOM_C4_TIMER_SUBSEQUENT );
}
attach_c4( tag, origin_offset, angles_offset )
{
assertex( isdefined( tag ), "attach_c4() passed undfined tag." );
if ( !isdefined( origin_offset ) )
origin_offset = ( 0, 0, 0 );
if ( !isdefined( angles_offset ) )
angles_offset = ( 0, 0, 0 );
c4_model = spawn( "script_model", self gettagorigin( tag ) + origin_offset );
c4_model setmodel( "weapon_c4" );
c4_model linkto( self, tag, origin_offset, angles_offset );
if ( !isdefined( self.c4_attachments ) )
self.c4_attachments = [];
self.c4_attachments[ self.c4_attachments.size ] = c4_model;
}
detonate_c4_when_dead( timer, subsequent_timer )
{
self waittill_any( "long_death", "death", "force_c4_detonate" );
self notify( "c4_detonated" );
if ( !isdefined( self ) || !isdefined( self.c4_attachments ) || self.c4_attachments.size == 0 )
return;
attacker = self get_last_attacker();
if ( isdefined( self.dog_neck_snapped ) )
{
timer = CONST_DOGSPLODE_C4_TIMER_NECK_SNAP;
}
for ( i = 0; i < self.c4_attachments.size; i++ )
{
playfxontag( getfx( "martyrdom_dlight_red" ), self.c4_attachments[ i ], "tag_fx" );
playfxontag( getfx( "martyrdom_red_blink" ), self.c4_attachments[ i ], "tag_fx" );
}
c4_array = self.c4_attachments;
self.c4_attachments = undefined;
BadPlace_Cylinder( "", timer, c4_array[ 0 ].origin, CONST_MARTYRDOM_C4_DANGER_RANGE, CONST_MARTYRDOM_C4_DANGER_RANGE, "axis", "allies" );
time_before_sound = max( timer - CONST_MARTYRDOM_C4_SOUND_TELL_LENGTH, 0 );
if ( time_before_sound > 0 )
{
timer -= time_before_sound;
wait time_before_sound;
}
c4_array[ 0 ] playsound( "semtex_warning" );
time_left = false;
if ( timer > 0.25 )
{
timer -= 0.25;
time_left = true;
}
wait timer;
for ( i = 0; i < c4_array.size; i++ )
{
if ( !isdefined( c4_array[ i ] ) )
continue;
stopfxontag( getfx( "martyrdom_red_blink" ), c4_array[ i ], "tag_fx" );
}
if ( time_left )
wait 0.25;
c4_array = sortbydistance( c4_array, c4_array[0].origin + (0,0,-120) );
for ( i = 0; i < c4_array.size; i++ )
{
if ( !isdefined( c4_array[ i ] ) )
continue;
playfx( level._effect[ "martyrdom_c4_explosion" ], c4_array[ i ].origin );
c4_array[ i ] playsound( "detpack_explo_main", "sound_done" );
PhysicsExplosionCylinder( c4_array[ i ].origin, CONST_MARTYRDOM_C4_PHYS_RADIUS, 1, CONST_MARTYRDOM_C4_PHYS_FORCE );
earthquake( CONST_MARTYRDOM_C4_QUAKE_SCALE, CONST_MARTYRDOM_C4_QUAKE_TIME, c4_array[ i ].origin, CONST_MARTYRDOM_C4_QUAKE_RADIUS );
stopfxontag( getfx( "martyrdom_dlight_red" ), c4_array[ i ], "tag_fx" );
if ( !isdefined( attacker ) )
attacker = undefined;
c4_array[ i ] radiusdamage( c4_array[ i ].origin, CONST_MARTYRDOM_C4_DMG_RADIUS, CONST_MARTYRDOM_C4_DMG_MAX, CONST_MARTYRDOM_C4_DMG_MIN, attacker, "MOD_EXPLOSIVE" );
c4_array[ i ] thread ent_linked_delete();
wait subsequent_timer;
}
}
behavior_special_ai_claymore()
{
if ( isdefined( self.planting ) )
return;
self endon( "death" );
self endon( "ai_behavior_change" );
engage_min_dist = 0;
engage_min_dist_fall_off	= 0;
if ( isdefined( self.aggressing ) && self.aggressing )
{
engage_min_dist = CONST_GENERIC_AI_ENGAGE_MIN;
engage_min_dist_fall_off	= CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF;
self.goalradius = CONST_CLAYMORE_GOAL_RADIUS_AGGRESSIVE;
self enable_heat_behavior( true );
self disable_surprise();
}
else
{
engage_min_dist = 300;
engage_min_dist_fall_off	= 200;
self.goalradius = CONST_CLAYMORE_GOAL_RADIUS_DEFAULT;
}
self setengagementmindist( engage_min_dist, engage_min_dist_fall_off );
self setengagementmaxdist( 512, 768 );
self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change" );
}
survival_AI_claymore_and_chemical()
{
mine_locs_populate();
thread mine_locs_manage_weights();
mine_ai_types = [ "claymore", "chemical" ];
thread mine_locs_manage_planting( mine_ai_types );
}
mine_locs_populate()
{
level.so_mine_locs = [];
level.so_mine_locs = get_all_mine_locs();
assertex( level.so_mine_locs.size, "Map has no mine location structs placed." );
foreach( mine_loc in level.so_mine_locs )
{
mine_loc.weight = 0.0;
}
}
mine_locs_attempt_plant( array_ai_types )
{
if ( isdefined( level.so_mines ) && level.so_mines.size >= CONST_CLAYMORE_PLACED_MAX )
return false;
ai_mine = [];
foreach ( ai_type in array_ai_types )
{
ai_mine = array_combine( ai_mine, get_special_ai_array( ai_type ) );
}
ai_mine = mine_ai_remove_busy( ai_mine );
if ( !ai_mine.size )
return false;
valid_locs = mine_locs_get_valid( CONST_MINE_PLANT_DIST_PLAYER_MIN, CONST_MINE_PLANT_WEIGHT_MIN );
valid_locs = mine_locs_sorted_by_weight( valid_locs );
foreach( loc in valid_locs )
{
foreach( ai in ai_mine )
{
ai_mine_dist = distance2d( loc.origin, ai.origin );
if	(
ai_mine_dist > CONST_MINE_PLANT_DIST_AI_MAX ||
loc.origin[2] < ai.origin[2] - CONST_MINE_PLANT_HEIGHT_AI_MAX * 0.5 ||
loc.origin[2] > ai.origin[2] + CONST_MINE_PLANT_HEIGHT_AI_MAX * 0.5
)
continue;
player_closest = getclosest( loc.origin, level.players );
player_mine_dist = distance2d( loc.origin, player_closest.origin );
if ( ai_mine_dist < player_mine_dist )
{
ai thread behavior_special_ai_mine_place( loc );
return true;
}
}
}
return false;
}
mine_ai_remove_busy( array_ai )
{
ai_not_planting = [];
foreach( ai in array_ai )
{
if ( !isdefined( ai.planting ) )
ai_not_planting[ ai_not_planting.size ] = ai;
}
return ai_not_planting;
}
mine_locs_sorted_by_weight( locs )
{
for( i = 0; i < locs.size - 1; i++ )
{
index_small = 0;
for ( j = i + 1; j < locs.size; j++ )
{
if ( locs[ j ].weight < locs[ i ].weight )
{
loc_ref = locs[ j ];
locs[ j ] = locs[ i ];
locs[ i ] = loc_ref;
}
}
}
return locs;
}
mine_locs_get_valid( dist_min, weight_min )
{
assertex( isdefined( level.so_mine_locs ) && level.so_mine_locs.size, "Level not prepped with claymore plant locations." );
locs_valid = [];
foreach( loc in level.so_mine_locs )
if ( loc mine_loc_valid_plant( dist_min, weight_min ) )
locs_valid[ locs_valid.size ] = loc;
return locs_valid;
}
mine_loc_valid_plant( dist_min, weight_min )
{
assert( isdefined( self.weight ) );
assert( isdefined( dist_min ) && dist_min >= 0 );
assert( isdefined( weight_min ) );
if ( isdefined( self.occupied ) || self.weight < weight_min )
return false;
foreach( player in level.players )
if ( distance2d( self.origin, player.origin ) < dist_min )
return false;
return true;
}
mine_locs_manage_weights()
{
level endon( "special_op_terminated" );
while ( 1 )
{
foreach( loc in level.so_mine_locs )
{
increased = false;
foreach( player in level.players )
{
if ( distance2d( loc.origin, player.origin ) <= CONST_MINE_LOC_RANGE_PLAYER )
{
loc mine_loc_adjust_weight( true );
increased = true;
}
}
if ( !increased )
loc mine_loc_adjust_weight( false );
}
wait CONST_MINE_LOC_UPDATE_DELAY;
}
}
mine_loc_adjust_weight( increment )
{
if ( increment )
self.weight = min( CONST_MINE_LOC_WEIGHT_MAX, self.weight + CONST_MINE_LOC_WEIGHT_INC );
else
self.weight = max( 0, self.weight - CONST_MINE_LOC_WEIGHT_DECAY );
}
mine_locs_manage_planting( array_ai_types )
{
level endon( "special_op_terminated" );
while ( 1 )
{
if ( mine_locs_attempt_plant( array_ai_types ) )
wait CONST_MINE_PLANT_TIME_BETWEEN;
else
wait CONST_MINE_PLANT_CHECK_DELAY;
}
}
behavior_special_ai_mine_place( loc_struct )
{
assertex( !isdefined( loc_struct.occupied ), "Claymore placed on already occupied location." );
self endon( "death" );
self.planting = true;
self notify( "ai_behavior_change" );
loc_struct.occupied = true;
self thread mine_ai_planting_death( loc_struct );
goal_radius = self.goalradius;
self.goalradius = 48;
self.ignoreall = true;
self.ignoreme = true;
self setgoalpos( loc_struct.origin );
msg = self waittill_any_timeout( 13, "goal", "bad_path" );
if ( msg != "goal" )
{
loc_struct.occupied = undefined;
if ( msg == "bad_path" )
{
level.so_mine_locs = array_remove_nokeys( level.so_mine_locs, loc_struct );
}
}
else
{
self allowedstances( "crouch" );
wait 1.0;
mine = undefined;
ai_ref = self get_ai_type_ref();
if ( ai_ref == "claymore" )
{
mine = self claymore_create( loc_struct.origin, loc_struct.angles );
mine playsound( "so_claymore_plant" );
mine thread claymore_on_trigger();
mine thread claymore_on_damage();
mine thread claymore_on_emp();
level notify( "ai_claymore_planted" );
}
else if ( ai_ref == "chemical" )
{
mine = self chembomb_create( loc_struct.origin, loc_struct.angles );
mine playsound( "so_claymore_plant" );
mine thread chembomb_on_trigger();
mine thread chembomb_on_damage();
level notify( "ai_chembomb_planted" );
}
else
{
AssertMsg( "Invalid AI type told to plant mine: " + ai_ref );
}
AssertEx( IsDefined( mine ), "Failed to create mine using AI Type: " + ai_ref );
if ( IsDefined( mine ) )
{
if ( !isdefined( level.so_mines ) )
level.so_mines = [];
level.so_mines[ level.so_mines.size ] = mine;
mine thread mine_on_death( loc_struct );
wait 0.25;
loc_struct.weight *= 0.5;
}
}
self allowedstances( "prone", "crouch", "stand" );
self.goalradius = goal_radius;
self.ignoreall = false;
self.ignoreme = false;
self.planting = undefined;
self notify( "planting_done" );
ai_ref = self get_ai_type_ref();
if ( ai_ref == "claymore" )
{
self thread behavior_special_ai_claymore();
}
else if ( ai_ref == "chemical" )
{
self thread behavior_special_ai_chemical();
}
}
mine_ai_planting_death( loc_struct )
{
self endon( "planting_done" );
level endon( "special_op_terminated" );
self waittill( "death" );
loc_struct.occupied = undefined;
}
claymore_create( origin, angles, drop )
{
assert( isdefined( origin ) );
assert( isdefined( angles ) );
claymore = spawn( "script_model", origin );
claymore setmodel( "weapon_claymore" );
if ( !isdefined( drop ) || drop )
claymore.origin = drop_to_ground( origin, 12, -120 );
claymore.angles = (0, angles[ 1 ], 0);
playfxontag( getfx( "claymore_laser" ), claymore, "tag_fx" );
if ( isdefined( self ) && isalive( self ) )
claymore.owner = self;
return claymore;
}
claymore_on_trigger()
{
self endon( "death" );
level endon( "special_op_terminated" );
trig_spawn_flags = 6;
trig_claymore = spawn( "trigger_radius", self.origin + ( 0, 0, 0 - CONST_CLAYMORE_ENT_TRIG_RADIUS ), trig_spawn_flags, CONST_CLAYMORE_ENT_TRIG_RADIUS, CONST_CLAYMORE_ENT_TRIG_RADIUS * 2 );
self thread mine_delete_on_death( trig_claymore );
while ( 1 )
{
trig_claymore waittill( "trigger", activator );
if ( isdefined( self.owner ) && activator == self.owner )
continue;
if ( isdefined( self.disabled ) )
{
self waittill( "enabled" );
continue;
}
if ( activator claymore_on_trigger_laser_check( self ) )
{
self notify( "triggered" );
self claymore_detonate( CONST_CLAYMORE_ENT_TIMER );
return;
}
}
}
claymore_on_trigger_laser_check( claymore )
{
if ( isDefined( claymore.disabled ) )
return false;
pos = self.origin + ( 0, 0, 32 );
dirToPos = pos - claymore.origin;
claymoreForward = anglesToForward( claymore.angles );
dist = vectorDot( dirToPos, claymoreForward );
if ( dist < CONST_CLAYMORE_ENT_TRIG_DIST_MIN )
return false;
dirToPos = vectornormalize( dirToPos );
dot = vectorDot( dirToPos, claymoreForward );
if ( !isdefined( level.so_claymore_trig_dot ) )
level.so_claymore_trig_dot = cos( CONST_CLAYMORE_ENT_TRIG_ANGLE );
return( dot > level.so_claymore_trig_dot );
}
claymore_detonate( timer )
{
assert( isdefined( self ) );
if ( isdefined( self.so_claymore_activated ) )
return;
self.so_claymore_activated = true;
level endon( "special_op_terminated" );
self playsound( "claymore_activated_SP" );
if ( isdefined( timer ) && timer > 0 )
wait timer;
assert( isdefined( self ) );
self playsound( "detpack_explo_main", "sound_done" );
playfx( level._effect[ "claymore_explosion" ], self.origin );
physicsexplosioncylinder( self.origin, CONST_CLAYMORE_ENT_PHYS_RADIUS, 1, CONST_CLAYMORE_ENT_PHYS_FORCE );
earthquake( CONST_CLAYMORE_ENT_QUAKE_SCALE, CONST_CLAYMORE_ENT_QUAKE_TIME, self.origin, CONST_CLAYMORE_ENT_QUAKE_RADIUS );
stopfxontag( getfx( "claymore_laser" ), self, "tag_fx" );
radiusdamage( self.origin, CONST_CLAYMORE_ENT_DMG_RADIUS, CONST_CLAYMORE_ENT_DMG_MAX, CONST_CLAYMORE_ENT_DMG_MIN, undefined, "MOD_EXPLOSIVE" );
level.so_mine_last_detonate_time = gettime();
if ( isdefined( self ) )
self delete();
}
mine_delete_on_death( trig )
{
level endon( "special_op_terminated" );
self waittill( "death" );
level.so_mines = array_remove_nokeys( level.so_mines, self );
wait 0.05;
if ( isdefined( trig ) )
trig delete();
}
claymore_on_damage()
{
self endon( "death" );
self endon( "triggered" );
level endon( "special_op_terminated" );
self.health = 100;
self setcandamage( true );
self.maxhealth = 100000;
self.health = self.maxhealth;
self waittill( "damage", amount, attacker );
timer = 0.05;
if ( mine_so_detonated_recently() )
timer = 0.1 + randomfloat( 0.4 );
self claymore_detonate( timer );
}
mine_so_detonated_recently()
{
return IsDefined( level.so_mine_last_detonate_time ) && gettime() - level.so_mine_last_detonate_time < 400;
}
claymore_on_emp()
{
self endon( "death" );
self endon( "triggered" );
level endon( "special_op_terminated" );
while( 1 )
{
self waittill( "emp_damage", attacker, duration );
plaYfxOnTag( getfx( "claymore_disabled" ), self, "tag_origin" );
self.disabled = true;
self notify( "disabled" );
wait( duration );
self.disabled = undefined;
self notify( "enabled" );
}
}
mine_on_death( struct_loc )
{
assertex( isdefined( struct_loc ) && isdefined( struct_loc.occupied ), "Mine on death called on undefined entity or mine that was not occupied." );
level endon( "special_op_terminated" );
self waittill( "death" );
struct_loc.occupied = undefined;
}
behavior_special_ai_chemical()
{
if ( isdefined( self.planting ) )
return;
self endon( "death" );
self endon( "ai_behavior_change" );
if ( !isdefined( self.special_ability ) )
self thread chemical_ability();
engage_min_dist = 0;
engage_min_dist_fall_off	= 0;
if ( isdefined( self.aggressing ) && self.aggressing )
{
engage_min_dist = CONST_GENERIC_AI_ENGAGE_MIN;
engage_min_dist_fall_off	= CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF;
self.goalradius = CONST_CHEMICAL_GOAL_RADIUS_AGGRESSIVE;
self enable_heat_behavior( true );
self disable_surprise();
}
else
{
engage_min_dist = 120;
engage_min_dist_fall_off	= 60;
self.goalradius = CONST_CHEMICAL_GOAL_RADIUS_DEFAULT;
}
self setengagementmindist( engage_min_dist, engage_min_dist_fall_off );
self setengagementmaxdist( 512, 768 );
self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change" );
}
chemical_ability()
{
self.special_ability = true;
self.ignoresuppression = true;
self.no_pistol_switch = true;
self.noRunNGun = true;
self.disableExits = true;
self.disableArrivals = true;
self.disableBulletWhizbyReaction = true;
self.combatMode = "no_cover";
self.neverSprintForVariation = true;
self disable_long_death();
self disable_surprise();
tank = self chemical_ability_attach_tank( "tag_shield_back", (0,0,0), (0,90,0) );
self thread chemical_ability_tank_spew( tank );
self thread chemical_ability_on_tank_damage( tank );
self thread chemical_ability_on_death( tank );
}
chemical_ability_attach_tank( tag, origin_offset, angle_offset )
{
tank = spawn( "script_model", self gettagorigin( tag ) + origin_offset );
tank setmodel( "gas_canisters_backpack" );
tank.health = 99999;
tank setcandamage( true );
tank linkto( self, tag, origin_offset, angle_offset );
return tank;
}
chemical_ability_tank_spew( tank )
{
self endon( "death" );
tank endon( "death" );
while( 1 )
{
playfxontag( getfx( "chemical_tank_smoke" ), self, "tag_shield_back" );
wait 0.05;
}
}
chemical_ability_on_tank_damage( tank )
{
self endon( "death" );
self endon( "tank_detonated" );
level endon( "special_op_terminated" );
while( 1 )
{
tank waittill( "damage", damage, attacker, dir, point, dmg_type, model, tag, part, dFlags, weapon );
if	(
isPlayer( attacker )
||	dmg_type == "MOD_EXPLOSIVE"
||	dmg_type == "MOD_GRENADE"
||	dmg_type == "MOD_GRENADE_SPLASH"
)
{
self thread so_survival_kill_ai( attacker, dmg_type, weapon );
return;
}
}
}
chemical_ability_on_death( tank )
{
self endon( "tank_detonated" );
level endon( "special_op_terminated" );
self waittill( "death", attacker );
if ( !isdefined( self ) )
{
if ( isdefined( tank ) )
{
wait 0.05;
tank delete();
}
return;
}
self thread chemical_ability_detonate( tank, attacker );
}
chemical_ability_detonate( tank, attacker )
{
if ( !isdefined( tank ) || isdefined( tank.detonated ) )
return;
tank.detonated = true;
if ( !isdefined( self ) )
return;
self notify( "tank_detonated" );
explode_origin = self.origin;
tank playsound( "detpack_explo_main", "sound_done" );
PhysicsExplosionCylinder( explode_origin, CONST_CHEMICAL_TANK_PHYS_RADIUS, 1, CONST_CHEMICAL_TANK_PHYS_FORCE );
earthquake( CONST_CHEMICAL_TANK_QUAKE_SCALE, CONST_CHEMICAL_TANK_QUAKE_TIME, explode_origin, CONST_CHEMICAL_TANK_QUAKE_RADIUS );
attacker = ter_op( isdefined( attacker ), attacker, undefined );
playfx( getfx( "chemical_tank_explosion" ), explode_origin );
thread chemical_ability_gas_cloud( explode_origin, CONST_CHEMICAL_CLOUD_LIFE_TIME, CONST_CHEMICAL_CLOUD_BADPLACE_LIFE_TIME );
tank unlink();
wait 0.05;
tank delete();
}
chemical_ability_gas_cloud( cloud_origin, cloud_time, bad_place_time )
{
level endon( "special_op_terminated" );
trig_spawn_flags = 7;
trig_smoke = spawn( "trigger_radius", cloud_origin + ( 0, 0, 0 - CONST_CHEMICAL_CLOUD_TRIG_RADIUS ), trig_spawn_flags, CONST_CHEMICAL_CLOUD_TRIG_RADIUS, CONST_CHEMICAL_CLOUD_TRIG_RADIUS * 2 );
BadPlace_Cylinder( "", bad_place_time, cloud_origin, CONST_CHEMICAL_CLOUD_TRIG_RADIUS, CONST_CHEMICAL_CLOUD_TRIG_RADIUS, "axis", "allies" );
trig_smoke endon( "smoke_done" );
trig_smoke thread do_in_order( ::_wait, cloud_time, ::send_notify, "smoke_done" );
while ( 1 )
{
trig_smoke waittill( "trigger", activator );
if ( !isdefined( activator ) || !isalive( activator ) )
continue;
if ( isplayer( activator ) )
{
if ( is_player_down( activator ) || is_player_down_and_out( activator ) )
continue;
if ( isdefined( activator.gassed ) )
continue;
shock_type = "";
current_time = gettime();
if	(
!isdefined( activator.gassed_before )
||	( isdefined( activator.gas_time ) && current_time - activator.gas_time > CONST_CHEMICAL_CLOUD_SHOCK_TIME * 1000 )
)
{
shock_type = "radiation_low";
}
else
{
if ( activator.gas_shock == "radiation_low" )
shock_type = "radiation_med";
else
shock_type = "radiation_high";
}
activator.gassed_before = true;
activator.gas_shock = shock_type;
activator.gas_time = current_time;
activator shellshock( shock_type, CONST_CHEMICAL_CLOUD_SHOCK_TIME );
activator.gassed = true;
activator thread chemical_ability_remove_gas_flag( CONST_CHEMICAL_CLOUD_SHOCK_DELAY );
}
if ( isAI( activator ) )
{
}
}
}
chemical_ability_remove_gas_flag( delay )
{
assertex( isdefined( self ) && isdefined( self.gassed ), "Invalid self or missing gas flag to remove" );
self endon( "death" );
wait delay;
self.gassed = undefined;
}
chembomb_create( origin, angles, drop )
{
assert( isdefined( origin ) );
assert( isdefined( angles ) );
chembomb = spawn( "script_model", origin );
chembomb setmodel( "ims_scorpion_explosive1" );
if ( !isdefined( drop ) || drop )
{
chembomb.origin = drop_to_ground( origin, 12, -120 ) + ( 0, 0, 5 );
}
chembomb.angles = (0, angles[ 1 ], 0);
chembomb.tag_origin = chembomb spawn_tag_origin();
chembomb.tag_origin LinkTo( chembomb, "tag_explosive1", (0,0,6), (-90, 0, 0) );
PlayFXOnTag( getfx( "chemical_mine_spew" ), chembomb.tag_origin, "tag_origin" );
if ( isdefined( self ) && isalive( self ) )
chembomb.owner = self;
return chembomb;
}
chembomb_on_trigger()
{
self endon( "death" );
level endon( "special_op_terminated" );
trig_spawn_flags = 6;
trig_mine = spawn( "trigger_radius", self.origin + ( 0, 0, 0 - CONST_CHEMBOMB_ENT_TRIG_RADIUS ), trig_spawn_flags, CONST_CHEMBOMB_ENT_TRIG_RADIUS, CONST_CHEMBOMB_ENT_TRIG_RADIUS * 2 );
self thread mine_delete_on_death( trig_mine );
while ( 1 )
{
trig_mine waittill( "trigger", activator );
if ( isdefined( self.owner ) && activator == self.owner )
continue;
if ( isdefined( self.disabled ) )
{
self waittill( "enabled" );
continue;
}
self notify( "triggered" );
self chembomb_detonate( CONST_CHEMBOMB_ENT_TIMER );
return;
}
}
chembomb_on_damage()
{
self endon( "death" );
self endon( "triggered" );
level endon( "special_op_terminated" );
self.health = 100;
self setcandamage( true );
self.maxhealth = 100000;
self.health = self.maxhealth;
self waittill( "damage", amount, attacker );
timer = 0.05;
if ( mine_so_detonated_recently() )
timer = 0.1 + randomfloat( 0.4 );
self chembomb_detonate( timer );
}
chembomb_detonate( timer )
{
Assert( IsDefined( self ) );
if ( IsDefined( self.chembomb_activated ) )
return;
self.chembomb_activated = true;
level endon( "special_op_terminated" );
self PlaySound( "claymore_activated_SP" );
if ( IsDefined( timer ) && timer > 0 )
wait timer;
Assert( IsDefined( self ) );
level.so_mine_last_detonate_time = GetTime();
self PlaySound( "detpack_explo_main", "sound_done" );
PhysicsExplosionCylinder( self.origin, CONST_CHEMICAL_TANK_PHYS_RADIUS, 1, CONST_CHEMICAL_TANK_PHYS_FORCE );
Earthquake( CONST_CHEMICAL_TANK_QUAKE_SCALE, CONST_CHEMICAL_TANK_QUAKE_TIME, self.origin, CONST_CHEMICAL_TANK_QUAKE_RADIUS );
PlayFX( getfx( "chemical_tank_explosion" ), self.origin );
StopFXOnTag( getfx( "chemical_mine_spew" ), self.tag_origin, "tag_origin" );
thread chemical_ability_gas_cloud( self.origin, CONST_CHEMBOMB_CLOUD_LIFE_TIME, CONST_CHEMBOMB_CLOUD_BADPLACE_LIFE_TIME );
self.tag_origin Delete();
wait 0.05;
if ( IsDefined( self ) )
self Delete();
}
dog_relocate_init()
{
level.dog_reloc_trig_array = getentarray( "dog_relocate", "targetname" );
if ( !isdefined( level.dog_reloc_trig_array ) || level.dog_reloc_trig_array.size == 0 )
return;
foreach ( loc_trig in level.dog_reloc_trig_array )
{
assert( isdefined( loc_trig.target ) );
reloc_struct = getstruct( loc_trig.target, "targetname" );
loc_trig.reloc_origin = reloc_struct.origin;
loc_trig thread dog_reloc_monitor();
}
}
dog_reloc_monitor()
{
level endon( "special_op_terminated" );
while ( 1 )
{
self waittill( "trigger", player );
while ( player istouching( self ) )
{
player.dog_reloc = self.reloc_origin;
wait 0.05;
}
player.dog_reloc = undefined;
}
}
spawn_dogs( dog_type, quantity )
{
level endon( "special_op_terminated" );
level endon( "wave_ended" );
if ( !isdefined( dog_type ) || dog_type == "" || !isdefined( quantity ) || !quantity )
return;
level.dogs = [];
avoid_locs = [];
foreach ( player in level.players )
avoid_locs[ avoid_locs.size ] = player;
dog_spawner = getentarray( "dog_spawner", "targetname" )[ 0 ];
assertex( isdefined( dog_spawner ), "No dog spawner while trying to spawn dog; targetname = dog_spawner" );
level.dogs_attach_c4 = isdefined( dog_type ) && dog_type == "dog_splode";
dog_spawner add_spawn_function( ::dog_setup );
dog_spawner add_spawn_function( ::dog_seek_player );
dog_spawner add_spawn_function( ::dog_register_death );
for ( i = 0; i < quantity; i ++ )
{
spawn_loc = get_furthest_from_these( level.wave_spawn_locs, avoid_locs, 4 );
dog_spawner.count = 1;
dog_spawner.origin = spawn_loc.origin;
dog_spawner.angles = spawn_loc.angles;
wait_between_spawn = int ( ( (CONST_DOG_SPAWN_OVER_TIME-10) + randomint(10) )/quantity );
level.survival_dog_spawning = true;
doggy = dog_spawner spawn_ai( true );
doggy.ai_type = get_ai_struct( dog_type );
doggy setthreatbiasgroup( "dogs" );
doggy [[ level.attributes_func ]]();
doggy.canclimbladders = false;
level.dogs[ level.dogs.size ] = doggy;
level.survival_dog_spawning = undefined;
if ( !flag( "aggressive_mode" ) )
waittill_any_timeout( wait_between_spawn, "aggressive_mode" );
wait 0.05;
}
}
dog_setup()
{
self.badplaceawareness = 0;
self.grenadeawareness = 0;
if ( isdefined( level.dogs_attach_c4 ) && level.dogs_attach_c4 )
{
self thread attach_c4( "j_hip_base_ri", (6,6,-3), (0,0,0) );
self thread attach_c4( "j_hip_base_le", (-6,-6,3), (0,0,0) );
self thread detonate_c4_when_dead( CONST_MARTYRDOM_C4_TIMER, CONST_MARTYRDOM_C4_TIMER_SUBSEQUENT );
self thread dog_detonate_c4_near_sentry();
}
}
dog_detonate_c4_near_sentry()
{
level endon( "special_op_terminated" );
self endon( "death" );
self endon( "c4_detonated" );
pos_saved = self.origin;
pos_curr = self.origin;
loc_new_time	= GetTime();
while ( 1 )
{
wait 0.2;
pos_curr	= self.origin;
time_curr	= GetTime();
if ( DistanceSquared( pos_curr, pos_saved ) > squared( CONST_DOG_SAME_LOC_THRESHOLD ) || self animscripts\dog\dog_combat::inSyncMeleeWithTarget() )
{
pos_saved = pos_curr;
loc_new_time	= time_curr;
}
if ( !IsDefined( level.placed_sentry ) || !level.placed_sentry.size )
continue;
if ( time_curr - loc_new_time < CONST_DOG_TIME_STATIC_TO_DETONATE )
continue;
close_to_sentry = false;
foreach ( sentry in level.placed_sentry )
{
if ( IsDefined( sentry.carrier ) )
continue;
if ( DistanceSquared( pos_curr, sentry.origin ) < squared( CONST_DOG_DIST_TO_SENTRY_DETONATE ) )
{
close_to_sentry = true;
break;
}
}
if ( close_to_sentry )
{
break;
}
else
{
pos_saved = pos_curr;
loc_new_time = time_curr;
}
}
self notify( "stop_dog_seek_player" );
self.ignoreall = true;
self SetGoalPos( self.origin );
self notify( "force_c4_detonate" );
}
dog_register_death()
{
self waittill( "death" );
level.dogs = dog_get_living();
}
dog_seek_player()
{
level endon( "special_op_terminated" );
level endon( "wave_ended" );
self endon( "death" );
self endon( "stop_dog_seek_player" );
self.moveplaybackrate	= 0.75;
self.goalheight = 80;
self.goalradius = 300;
update_delay = 1.0;
while ( 1 )
{
closest_player = get_closest_player_healthy( self.origin );
if ( !IsDefined( closest_player ) )
{
closest_player = get_closest_player( self.origin );
}
if ( IsDefined( closest_player ) )
{
bCanSee = self canSee( closest_player );
meToPlayerSq = DistanceSquared( self.origin, closest_player.origin );
if ( IsDefined( closest_player.dog_reloc ) )
{
self SetGoalPos( closest_player.dog_reloc );
}
else if ( (!bCanSee || meToPlayerSq > 1024*1024) && IsDefined( closest_player.node_closest ) )
{
self SetGoalPos( closest_player.node_closest.origin );
self.goalradius = 24;
}
else
{
self SetGoalPos( closest_player.origin );
self.goalradius = 384;
}
}
wait update_delay;
}
}
dog_get_count()
{
dog_count = dog_get_living().size;
if ( isdefined( level.survival_dog_spawning ) )
dog_count++;
return dog_count;
}
dog_get_living()
{
if ( !isdefined( level.dogs ) )
{
level.dogs = [];
return level.dogs;
}
dog_array = [];
foreach( dog in level.dogs )
{
if ( isdefined( dog ) && isalive( dog ) )
dog_array[ dog_array.size ] = dog;
}
return dog_array;
}
survival_boss_juggernaut()
{
}
is_juggernaut_used( AI_bosses )
{
foreach( boss_ref in AI_bosses )
if ( issubstr( boss_ref, "jug_" ) )
return true;
return false;
}
spawn_juggernaut( boss_ref, path_start )
{
level endon( "special_op_terminated" );
boss = drop_jug_by_chopper( boss_ref, path_start );
if ( !isdefined( boss ) )
return;
boss.ai_type = get_ai_struct( boss_ref );
boss.kill_assist_xp = int( get_ai_xp( boss_ref ) * 0.2 );
boss maps\_so_survival_loot::loot_roll( 0.0 );
level.bosses[ level.bosses.size ] = boss;
boss waittill( "jumpedout" );
level notify( "juggernaut_jumpedout" );
boss thread survival_boss_behavior();
boss thread clear_from_boss_array_when_dead();
}
drop_jug_by_chopper( spawner_type, chopper_path )
{
spawner = get_spawners_by_targetname( spawner_type )[ 0 ];
assertex( isdefined( spawner ), "Type: " + spawner_type + " does not have a spawner present in level." );
spawner add_spawn_function( ::money_fx_on_death );
chopper = chopper_spawn_from_targetname_and_drive( "jug_drop_chopper", chopper_path.origin, chopper_path );
chopper thread maps\_chopperboss::chopper_path_release( "reached_dynamic_path_end death deathspin" );
chopper godon();
chopper.script_vehicle_selfremove = true;
chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );
chopper thread chopper_drop_smoke_at_unloading();
chopper chopper_spawn_pilot_from_targetname( "jug_drop_chopper_pilot" );
boss = chopper chopper_spawn_passenger( spawner );
boss deletable_magic_bullet_shield();
boss thread do_in_order( ::waittill_any, "jumpedout", ::stop_magic_bullet_shield );
boss setthreatbiasgroup( "boss" );
return boss;
}
progressive_damaged()
{
self endon( "death" );
self endon( "new_jug_behavior" );
while ( 1 )
{
if ( self.health <= CONST_JUG_WEAKENED )
{
self.walkDist = CONST_JUG_WEAKENED_RUN_DIST;
self.walkDistFacingMotion = CONST_JUG_WEAKENED_RUN_DIST;
}
else
{
self.walkDist = CONST_JUG_RUN_DIST;
self.walkDistFacingMotion = CONST_JUG_RUN_DIST;
}
wait 0.05;
}
}
damage_factor()
{
self endon( "death" );
self endon( "new_jug_behavior" );
self.bullet_resistance = 0;
while ( 1 )
{
self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
if ( isdefined( self.magic_bullet_shield ) )
continue;
damage_heal = 0;
headshot = false;
if ( IsDefined( attacker ) && IsAI( attacker ) && self.team != attacker.team )
{
damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "ai_damage" ] );
}
else if( type == "MOD_MELEE" )
{
if ( isdefined( attacker ) && isplayer( attacker ) && isdefined( weapon ) && IsSubStr( weapon, "riotshield_so" ) )
damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "melee_riotshield" ] );
else
damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "melee" ] );
}
else if	(
type == "MOD_EXPLOSIVE"
|| type == "MOD_GRENADE"
|| type == "MOD_GRENADE_SPLASH"
|| type == "MOD_PROJECTILE"
|| type == "MOD_PROJECTILE_SPLASH"
)
{
damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "explosive" ] );
}
else
{
if(	self was_headshot() )
{
damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "headshot" ] );
headshot = true;
}
else
damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "bodyshot" ] );
}
damage_heal = int( damage_heal );
if ( damage_heal < 0 && abs( damage_heal ) >= self.health )
{
if ( headshot )
self.died_of_headshot = true;
self thread so_survival_kill_ai( attacker, type, weapon );
}
else
{
self.health += damage_heal;
}
self notify( "dmg_factored" );
}
}
dmg_factor_calc( amount, dmg_factor )
{
damage_heal = 0;
if ( isdefined( dmg_factor ) && dmg_factor )
damage_heal = int( amount * ( 1 - dmg_factor ) );
return damage_heal;
}
global_jug_behavior()
{
self.dmg_factor[ "headshot" ] = 1;
self.dmg_factor[ "bodyshot" ] = 1;
self.dmg_factor[ "melee" ] = 1;
self.dmg_factor[ "melee_riotshield" ] = 1;
self.dmg_factor[ "explosive" ] = 1;
self.dmg_factor[ "ai_damage" ] = 1;
self.dropweapon = false;
self.minPainDamage = CONST_JUG_MIN_DAMAGE_PAIN;
self set_battlechatter( false );
self.aggressing = true;
self.dontMelee = undefined;
self.meleeAlwaysWin	= true;
self thread damage_factor();
self thread progressive_damaged();
}
boss_jug_helmet_pop( health_percent, arr_dmg_factor )
{
assertex( isdefined( self.dmg_factor ) && self.dmg_factor.size, "Juggernaut passed without dmg_factor array filled." );
self endon( "death" );
health_original = self.health;
if ( isdefined( self.ai_type ) )
health_original = self get_ai_health( self.ai_type.ref );
while ( 1 )
{
if ( self.health / health_original <= health_percent )
{
self animscripts\death::helmetpop();
dmg_factor_size = self.dmg_factor.size;
self.dmg_factor = array_combine_keys( self.dmg_factor, arr_dmg_factor );
assertex( self.dmg_factor.size == dmg_factor_size, "Damage factor array size changed, passed factor array had invalid keys." );
return;
}
self waittill( "dmg_factored" );
}
}
boss_jug_regular()
{
self.dmg_factor[ "headshot" ] = CONST_JUG_LOW_SHIELD;
self.dmg_factor[ "bodyshot" ] = CONST_JUG_MED_SHIELD;
self.dmg_factor[ "melee" ] = CONST_JUG_HIGH_SHIELD;
self.dmg_factor[ "melee_riotshield" ] = CONST_JUG_HIGH_SHIELD;
self.dmg_factor[ "explosive" ] = CONST_JUG_MED_SHIELD;
self.dmg_factor[ "ai_damage" ] = CONST_JUG_MED_SHIELD;
self setengagementmindist( 100, 60 );
self setengagementmaxdist( 512, 768 );
self.goalradius = 128;
self.goalheight = 81;
self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
}
boss_jug_headshot()
{
self.dmg_factor[ "headshot" ] = CONST_JUG_NO_SHIELD;
self.dmg_factor[ "bodyshot" ] = CONST_JUG_MED_SHIELD;
self.dmg_factor[ "melee" ] = CONST_JUG_HIGH_SHIELD;
self.dmg_factor[ "melee_riotshield" ] = CONST_JUG_HIGH_SHIELD;
self.dmg_factor[ "explosive" ] = CONST_JUG_NO_SHIELD;
self.dmg_factor[ "ai_damage" ] = CONST_JUG_HIGH_SHIELD;
self setengagementmindist( 100, 60 );
self setengagementmaxdist( 512, 768 );
self.goalradius = 128;
self.goalheight = 81;
self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
}
boss_jug_explosive()
{
self.dmg_factor[ "headshot" ] = CONST_JUG_MED_SHIELD;
self.dmg_factor[ "bodyshot" ] = CONST_JUG_HIGH_SHIELD;
self.dmg_factor[ "melee" ] = CONST_JUG_HIGH_SHIELD;
self.dmg_factor[ "melee_riotshield" ] = CONST_JUG_HIGH_SHIELD;
self.dmg_factor[ "explosive" ] = CONST_JUG_MED_SHIELD;
self.dmg_factor[ "ai_damage" ] = CONST_JUG_HIGH_SHIELD;
self setengagementmindist( 100, 60 );
self setengagementmaxdist( 512, 768 );
self.goalradius = 128;
self.goalheight = 81;
self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
}
boss_jug_riotshield()
{
self endon( "death" );
self endon( "riotshield_damaged" );
self.dmg_factor[ "headshot" ] = CONST_JUG_LOW_SHIELD;
self.dmg_factor[ "bodyshot" ] = CONST_JUG_LOW_SHIELD;
self.dmg_factor[ "melee" ] = CONST_JUG_MED_SHIELD;
self.dmg_factor[ "melee_riotshield" ] = CONST_JUG_MED_SHIELD;
self.dmg_factor[ "explosive" ] = CONST_JUG_NO_SHIELD;
self.dmg_factor[ "ai_damage" ] = CONST_JUG_HIGH_SHIELD;
self.dropRiotshield = true;
self subclass_juggernaut_riotshield();
self thread juggernaut_abandon_shield();
if ( CONST_JUG_RIOTSHIELD_BULLET_BLOCK )
self.shieldBulletBlockLimit = 9999;
self setengagementmindist( 100, 60 );
self setengagementmaxdist( 512, 768 );
self.goalradius = 128;
self.goalheight = 81;
self.usechokepoints = false;
self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
thread juggernaut_manage_min_pain_damage();
}
juggernaut_manage_min_pain_damage()
{
self endon( "death" );
while ( 1 )
{
if ( self.health <= CONST_JUG_WEAKENED )
self.minPainDamage = CONST_JUG_MIN_DAMAGE_PAIN_WEAK;
else
self.minPainDamage = CONST_JUG_MIN_DAMAGE_PAIN;
wait 0.05;
}
}
subclass_juggernaut_riotshield()
{
self.juggernaut = true;
self.doorFlashChance = .05;
self.aggressivemode = true;
self.ignoresuppression = true;
self.no_pistol_switch = true;
self.noRunNGun = true;
self.disableArrivals = true;
self.disableBulletWhizbyReaction = true;
self.combatMode = "no_cover";
self.neverSprintForVariation = true;
self.a.disableLongDeath = true;
self.pathEnemyFightDist = 128;
self.pathenemylookahead = 128;
self disable_turnAnims();
self disable_surprise();
self.meleeAlwaysWin = true;
if( !self isBadGuy() )
return;
level notify( "juggernaut_spawned" );
self thread subclass_juggernaut_death();
}
juggernaut_abandon_shield()
{
self endon( "death" );
self thread juggernaut_abandon_shield_low_health( CONST_JUG_DROP_SHIELD_HEALTH_PERCENT );
self waittill( "riotshield_damaged" );
wait 0.05;
self AI_drop_riotshield();
if ( !isAlive( self ) )
return;
self animscripts\riotshield\riotshield::riotshield_turn_into_regular_ai();
self thread maps\_juggernaut::subclass_juggernaut();
self notify( "new_jug_behavior" );
self global_jug_behavior();
self thread boss_jug_regular();
}
juggernaut_abandon_shield_low_health( health_percent )
{
self endon( "death" );
self endon( "riotshield_damaged" );
health_original = self.health;
if ( isdefined( self.ai_type ) )
{
health_original = self get_ai_health( self.ai_type.ref );
}
while ( 1 )
{
self waittill( "damage" );
if ( self.health / health_original <= health_percent )
{
self notify( "riotshield_damaged" );
return;
}
}
}
subclass_juggernaut_death()
{
self endon( "new_jug_behavior" );
self waittill( "death", attacker );
self AI_drop_riotshield();
level notify( "juggernaut_died" );
if ( ! isdefined( self ) )
return;
if ( ! isdefined( attacker ) )
return;
if ( ! isplayer( attacker ) )
return;
}
survival_boss_chopper()
{
level.chopper_boss_min_dist2D = 128;
maps\_chopperboss::chopper_boss_locs_populate( "script_noteworthy", "so_chopper_boss_path_struct" );
}
survival_drop_chopper_init()
{
start_array = getstructarray( "drop_path_start", "targetname" );
foreach ( start_node in start_array )
{
cur_node = start_node;
while( isdefined( cur_node ) )
{
if ( isdefined( cur_node.script_unload ) )
{
cur_node.ground_pos = groundpos( cur_node.origin );
break;
}
if ( isdefined( cur_node.target ) )
{
cur_node = getstruct( cur_node.target, "targetname" );
}
else
{
assertmsg( "Drop chopper path is missing .script_unload on an unload struct." );
break;
}
}
}
}
spawn_chopper_boss( boss_ref, path_start )
{
level endon( "special_op_terminated" );
chopper_boss = chopper_spawn_from_targetname( boss_ref, path_start.origin );
chopper_boss chopper_spawn_pilot_from_targetname( "jug_drop_chopper_pilot" );
if (!using_wii())
chopper_boss thread maps\_remotemissile_utility::setup_remote_missile_target();
chopper_boss.ai_type = get_ai_struct( boss_ref );
chopper_boss [[ level.attributes_func ]]();
if ( isdefined( level.xp_enable ) && level.xp_enable )
chopper_boss thread maps\_rank::AI_xp_init();
chopper_boss.kill_assist_xp = int( get_ai_xp( boss_ref ) * 0.2 );
level.bosses[ level.bosses.size ] = chopper_boss;
chopper_boss thread maps\_chopperboss::chopper_boss_behavior_little_bird( path_start );
chopper_boss thread maps\_chopperboss::chopper_path_release( "death deathspin" );
chopper_boss thread clear_from_boss_array_when_dead();
chopper_boss setthreatbiasgroup( "boss" );
setthreatbias( "sentry", "boss", 1500 );
foreach ( turret in chopper_boss.mgturret )
{
turret setbottomarc( 90 );
}
return chopper_boss;
}
spawn_ally_team( ally_ref, count, path_start, owner )
{
ally_team = [];
ally_spawner = get_spawners_by_targetname( ally_ref )[ 0 ];
assertex( isdefined( ally_spawner ), "No ally spawner with targetname: " + ally_ref );
if ( !isdefined( ally_spawner ) )
return ally_team;
chopper = chopper_spawn_from_targetname_and_drive( "ally_drop_chopper", path_start.origin, path_start );
chopper thread maps\_chopperboss::chopper_path_release( "reached_dynamic_path_end death deathspin" );
chopper godon();
chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );
chopper.script_vehicle_selfremove = true;
chopper endon( "death" );
chopper chopper_spawn_pilot_from_targetname( "friendly_support_delta" );
for ( i = 0; i < count; i++ )
{
ally = chopper chopper_spawn_passenger( ally_spawner, i + 2 );
ally set_battlechatter( false );
ally deletable_magic_bullet_shield();
ally thread ally_remove_bullet_shield( CONST_ALLY_BULLET_SHIELD_TIME, "jumpedout" );
ally setthreatbiasgroup( "allies" );
ally.ignoreme = true;
ally.ally_ref = ally_ref;
ally.ai_type = get_ai_struct( ally_ref );
ally [[ level.attributes_func ]]();
ally thread setup_AI_weapon();
ally.owner = owner;
ally_team[ ally_team.size ] = ally;
ally.headiconteam = "allies";
if ( ally_ref == "friendly_support_delta" )
{
ally.headicon = "headicon_delta_so";
}
if ( ally_ref == "friendly_support_riotshield" )
{
ally.headicon = "headicon_gign_so";
}
ally.drawoncompass = false;
wait 0.05;
}
chopper thread ally_team_setup( ally_team );
level.spawning_friendlies=0;
return ally_team;
}
_GetEye()
{
if ( isdefined( self ) && isalive( self ) )
return self geteye();
return undefined;
}
ally_team_setup( allies )
{
assertex( isdefined( self ), "Chopper not passed as self so unloaded cannot be waited for." );
assertex( isdefined( allies ) && allies.size, "Invalid or empty ally array." );
self endon( "death" );
self waittill( "unloaded" );
array_thread( allies, ::ally_setup );
}
ally_setup()
{
if ( !isdefined( self ) || !isalive( self ) )
return;
self setengagementmindist( 300, 200 );
self setengagementmaxdist( 512, 768 );
self.goalradius = CONST_ALLY_GOAL_RADIUS;
if ( isdefined( self.ai_type ) && IsSubStr( self.ai_type.ref, "riotshield" ) )
{
self.goalradius = CONST_ALLY_GOAL_RADIUS_RIOTSHIELD;
self setengagementmindist( 200, 100 );
self setengagementmaxdist( 512, 768 );
self thread drop_riotshield_think();
self thread ally_manage_min_pain_damage( 300 );
}
else
{
self thread ally_manage_min_pain_damage( 150 );
}
self.ignoreme = false;
self.fixednode = false;
self.dropweapon = false;
self.dropRiotshield = true;
self.drawoncompass = true;
self set_battlechatter( true );
self PushPlayer( false );
self.bullet_resistance = 30;
self thread ally_on_death();
self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius );
}
ally_manage_min_pain_damage( minPainDamage )
{
self endon( "death" );
while ( 1 )
{
self.minPainDamage = minPainDamage;
wait 0.05;
}
}
drop_riotshield_think()
{
self endon( "death" );
self waittill_any_return( "riotshield_damaged", "dog_attacks_ai" );
wait 0.05;
self AI_drop_riotshield();
if ( !isAlive( self ) )
return;
self animscripts\riotshield\riotshield::riotshield_turn_into_regular_ai();
}
ally_remove_bullet_shield( timer, wait_before_timer )
{
assertex( isdefined( timer ), "Timer undefined." );
self endon( "death" );
if ( isdefined( wait_before_timer )	)
self waittill( wait_before_timer );
wait timer;
self stop_magic_bullet_shield();
}
ally_on_death()
{
self waittill( "death" );
if( isdefined( self.owner ) && isalive( self.owner ) )
self.owner notify( "ally_died" );
self AI_drop_riotshield();
}
setup_AI_weapon()
{
waittillframeend;
assertex( isdefined( self.ai_type ), "AI attributes aren't set correctly, or function call too early" );
if ( isdefined( self.team ) && self.team == "axis" )
{
self maps\_so_survival_loot::loot_roll();
}
assertex( isdefined( level.coop_incap_weapon ), "Default secondary weapon should be defined." );
if ( isdefined( level.coop_incap_weapon ) )
{
self.sidearm = level.coop_incap_weapon;
place_weapon_on( self.sidearm, "none" );
}
forced_weapon = get_ai_weapons( self.ai_type.ref )[ 0 ];
assertex( isdefined( forced_weapon ), "Regular or Special AI did not return a weapon which could cause them to use their SP weapon." );
if ( !isdefined( forced_weapon ) || forced_weapon == self.weapon )
return;
self forceUseWeapon( forced_weapon, "primary" );
assertex( self.weapon == forced_weapon, "Force weapon failed to set " + forced_weapon + "as the primary weapon." );
assertex( self.primaryweapon == forced_weapon, "Force weapon failed to set " + forced_weapon + "as the primary weapon." );
}
get_all_mine_locs()
{
claymore_locs = getstructarray( "so_claymore_loc", "targetname" );
return claymore_locs;
}
AI_drop_riotshield()
{
if ( !isdefined( self ) )
return;
if ( isdefined( self.weaponInfo[ "iw5_riotshield_so" ] ) )
{
position = self.weaponInfo[ "iw5_riotshield_so" ].position;
if ( isdefined( self.dropriotshield ) && self.dropriotshield && position != "none" )
self thread animscripts\shared::DropWeaponWrapper( "iw5_riotshield_so", position );
self animscripts\shared::detachWeapon( "iw5_riotshield_so" );
self.weaponInfo[ "iw5_riotshield_so" ].position = "none";
self.a.weaponPos[ position ] = "none";
}
}
manage_ai_relative_to_player( update_delay, goal_radius, endons, notifies )
{
assert( isdefined( update_delay ) );
level endon( "special_op_terminated" );
self endon( "death" );
self.goalradius = ter_op( isdefined( goal_radius ), goal_radius, self.goalradius );
self.goalheight = 80;
if ( isdefined( endons ) )
{
arr_endons = strtok( endons, " " );
foreach ( e in arr_endons )
self endon( e );
}
if ( isdefined( notifies ) )
{
arr_notifies = strtok( notifies, " " );
foreach ( n in arr_notifies )
self notify( n );
}
self survival_disable_sprint();
first_update = true;
last_target = undefined;
while ( 1 )
{
close_player = get_closest_player_healthy( self.origin );
if ( !IsDefined( close_player ) )
{
close_player = get_closest_player( self.origin );
}
if ( !isdefined( close_player ) )
{
wait update_delay;
continue;
}
if ( self.team == "allies" )
{
if ( distancesquared( self.origin, close_player.origin ) > self.goalradius * self.goalradius )
{
self setgoalentity( close_player );
wait 2;
continue;
}
}
else
{
if ( distancesquared( self.origin, close_player.origin ) < self.goalradius * self.goalradius )
self GetEnemyInfo( close_player );
}
if ( !isdefined(last_target) || last_target != close_player )
{
last_target = close_player;
self SetGoalEntity( close_player );
self notify( "target_reset" );
self thread bad_path_listener( close_player );
}
if ( first_update )
{
first_update = false;
if ( self.team == "axis" )
{
self GetEnemyInfo( close_player );
}
}
self survival_disable_sprint();
if ( self.team == "allies" )
{
self SetGoalPos( self.origin );
if ( IsDefined( self.subclass )	&& self.subclass == "riotshield" )
{
wait( RandomFloatRange( 0.2, 2.0 ) );
curr_radius = self.goalradius;
self.goalradius = 1.0;
wait 0.1;
self.goalradius = curr_radius;
}
}
wait update_delay;
}
}
bad_path_listener( target )
{
self endon( "target_reset" );
self endon( "death" );
assert( isdefined( target ) );
while ( true )
{
self waittill( "bad_path" );
if ( isdefined( target.node_closest ) )
{
self SetGoalPos( target.node_closest.origin );
last_player_pos = target.origin;
while ( distanceSquared( last_player_pos, target.origin ) < 144 )
wait( 0.5 );
self SetGoalEntity( target );
}
}
}
manage_ai_poll_player_state( close_player )
{
self endon( "death" );
self endon( "manage_ai_stop_polling_player_state" );
while ( 1 )
{
wait 0.1;
if	(
!isdefined( close_player )
||	!isalive( close_player )
||	is_player_down( close_player )
)
{
self notify( "manage_ai_player_invalid" );
return;
}
else if ( distancesquared( self.origin, close_player.origin ) <= self.goalradius * self.goalradius )
{
self notify( "manage_ai_player_found" );
return;
}
}
}
manage_ai_go_to_player_node( player )
{
AssertEx( IsDefined( player.node_closest ), "Player did not have closest_node defined, this should always be defined." );
if ( IsDefined( player.node_closest ) )
{
self SetGoalPos( player.node_closest.origin );
}
}
survival_enable_sprint()
{
if ( isdefined( self.subclass ) && self.subclass == "riotshield" )
{
if ( isdefined( self.juggernaut ) )
{
self maps\_riotshield::riotshield_fastwalk_on();
}
else
{
self maps\_riotshield::riotshield_sprint_on();
}
}
else
{
if ( isdefined( self.juggernaut ) )
self enable_sprint();
else
self.combatMode = "no_cover";
}
}
survival_disable_sprint()
{
if ( isdefined( self.subclass ) && self.subclass == "riotshield" )
{
if ( isdefined( self.juggernaut ) )
{
self maps\_riotshield::riotshield_fastwalk_off();
}
else
{
self maps\_riotshield::riotshield_sprint_off();
}
}
else
{
if ( isdefined( self.juggernaut ) )
self disable_sprint();
else
self.combatMode = "cover";
}
}
ai_exist( ref )
{
return isdefined( level.survival_ai ) && isdefined( level.survival_ai[ ref ] );
}
get_ai_index( ref )
{
if ( ai_exist( ref ) )
return level.survival_ai[ ref ].idx;
return int( tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_INDEX ) );
}
get_ai_ref_by_index( idx )
{
return tablelookup( WAVE_TABLE, TABLE_INDEX, idx, TABLE_AI_REF );
}
get_ai_struct( ref )
{
msg = "Trying to get survival AI_type struct before stringtable is ready, or type doesnt exist.";
assertex( ai_exist( ref ), msg );
return level.survival_ai[ ref ];
}
get_ai_classname( ref )
{
if ( IsDefined( level.survival_ai_class_overrides ) && IsDefined( level.survival_ai_class_overrides[ ref ] ) )
return level.survival_ai_class_overrides[ ref ];
if ( ai_exist( ref ) )
return level.survival_ai[ ref ].classname;
return tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_CLASSNAME );
}
get_ai_weapons( ref )
{
if ( IsDefined( level.survival_ai_weapon_overrides ) && IsDefined( level.survival_ai_weapon_overrides[ ref ] ) )
return level.survival_ai_weapon_overrides[ ref ];
if ( ai_exist( ref ) )
return level.survival_ai[ ref ].weapon;
weapons = tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_WEAPON );
return strtok( weapons, " " );
}
get_ai_alt_weapons( ref )
{
if ( ai_exist( ref ) )
return level.survival_ai[ ref ].altweapon;
weapons = tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_ALT_WEAPON );
return strtok( weapons, " " );
}
get_ai_name( ref )
{
if ( ai_exist( ref ) )
return level.survival_ai[ ref ].name;
return tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_NAME );
}
get_ai_desc( ref )
{
if ( ai_exist( ref ) )
return level.survival_ai[ ref ].desc;
return tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_DESC );
}
get_ai_health( ref )
{
if ( isdefined( level.survival_waves_repeated ) )
repeat_scale_health = 1.0 + level.survival_waves_repeated * CONST_AI_REPEAT_BOOST_HEALTH;
else
repeat_scale_health = 1.0;
if ( ai_exist( ref ) )
return int( level.survival_ai[ ref ].health * repeat_scale_health );
health = tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_HEALTH );
if ( health == "" )
return undefined;
return int ( int( health ) * repeat_scale_health );
}
get_ai_speed( ref )
{
if ( isdefined( level.survival_waves_repeated ) )
repeat_scale_speed = 1.0 + level.survival_waves_repeated * CONST_AI_REPEAT_BOOST_SPEED;
else
repeat_scale_speed = 1.0;
if ( ai_exist( ref ) )
return Min( level.survival_ai[ ref ].speed * repeat_scale_speed, CONST_AI_SPEED_MAX );
speed = tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_SPEED );
if ( speed == "" )
return undefined;
return Min( float( speed ) * repeat_scale_speed, CONST_AI_SPEED_MAX );
}
get_ai_accuracy( ref )
{
if ( isdefined( level.survival_waves_repeated ) )
repeat_scale_accuracy = 1.0 + level.survival_waves_repeated * CONST_AI_REPEAT_BOOST_ACCURACY;
else
repeat_scale_accuracy = 1.0;
if ( ai_exist( ref ) )
{
if ( isdefined( level.survival_ai[ ref ].accuracy ) )
return level.survival_ai[ ref ].accuracy * repeat_scale_accuracy;
else
return level.survival_ai[ ref ].accuracy;
}
accuracy = tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_ACCURACY );
if ( accuracy == "" )
return undefined;
return float( accuracy ) * repeat_scale_accuracy;
}
get_ai_xp( ref )
{
if ( ai_exist( ref ) )
return level.survival_ai[ ref ].xp;
XP_reward = tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_XP );
if ( XP_reward == "" )
return undefined;
return int( XP_reward );
}
is_ai_boss( ref )
{
if ( ai_exist( ref ) && isdefined( level.survival_boss ) )
return isdefined( level.survival_boss[ ref ] );
Var1 = tablelookup( WAVE_TABLE, TABLE_AI_REF, ref, TABLE_AI_BOSS );
if ( !isdefined( Var1 ) || Var1 == "" )
return false;
return true;
}
wave_exist( wave_num )
{
return isdefined( level.survival_wave ) && isdefined( level.survival_wave[ wave_num ] );
}
get_wave_boss_delay( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].bossDelay;
return int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_BOSS_DELAY ) );
}
get_wave_index( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].idx;
return int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_INDEX ) );
}
get_wave_number_by_index( index )
{
return int( tablelookup( level.wave_table, TABLE_INDEX, index, TABLE_WAVE ) );
}
get_squad_type( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].squadType;
return tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SQUAD_TYPE );
}
get_squad_array( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].squadArray;
squad_array = [];
ai_count = int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SQUAD_SIZE ) );
if ( ai_count <= 3 )
{
squad_array[ 0 ] = ai_count;
}
else
{
remainder = ai_count % 3;
squad_count = int( ai_count / 3 );
for ( i=0; i<squad_count; i++ )
squad_array[ i ] = 3;
if ( remainder == 1 )
{
if ( level.merge_squad_member_max == 4 )
{
squad_array[ squad_array.size - 1 ] += remainder;
}
else
{
exchange = 1;
squad_array[ squad_array.size - 1 ] -= ( exchange );
squad_array[ squad_array.size ] = remainder + ( exchange );
}
}
else if ( remainder == 2 )
{
squad_array[ squad_array.size ] = remainder;
}
}
return squad_array;
}
get_special_ai( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].specialAI;
specials = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SPECIAL );
if ( isdefined( specials ) && specials != "" )
return strtok( specials, " " );
return undefined;
}
get_special_ai_quantity( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].specialAIquantity;
special_nums = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SPECIAL_NUM );
special_num_array = [];
if ( isdefined( special_nums ) && special_nums != "" )
{
special_nums = strtok( special_nums, " " );
for( i=0; i<special_nums.size; i++ )
special_num_array[ i ] = int( special_nums[ i ] );
return special_num_array;
}
return undefined;
}
get_special_ai_type_quantity( wave_num, ai_type )
{
assertex( isdefined( ai_type ), "ai_type is not defined while trying to get quantity for type." );
special_ai_array = get_special_ai( wave_num );
special_ai_quantity_array = get_special_ai_quantity( wave_num );
if ( isdefined( special_ai_array )
&& isdefined( special_ai_quantity_array )
&& special_ai_array.size
&& special_ai_quantity_array.size
)
{
foreach( index, special in special_ai_array )
{
if ( ai_type == special )
return special_ai_quantity_array[ index ];
}
}
return 0;
}
get_bosses_ai( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].bossAI;
bosses = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_BOSS_AI );
if ( isdefined( bosses ) && bosses != "" )
return strtok( bosses, " " );
return undefined;
}
get_bosses_nonai( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].bossNonAI;
bosses = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_BOSS_NONAI );
if ( isdefined( bosses ) && bosses != "" )
return strtok( bosses, " " );
return undefined;
}
is_repeating( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].repeating;
return int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_REPEAT ) );
}
get_armory_unlocked( wave_num )
{
armory_unlock_array = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_ARMORY_UNLOCK );
armory_unlock_array = strtok( armory_unlock_array, " " );
return armory_unlock_array;
}
get_dog_type( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].dogType;
special_array = get_special_ai( wave_num );
if ( !isdefined( special_array ) || !special_array.size )
return "";
foreach ( special in special_array )
{
if ( issubstr( special, "dog" ) )
return special;
}
return "";
}
get_dog_quantity( wave_num )
{
if ( wave_exist( wave_num ) )
return level.survival_wave[ wave_num ].dogQuantity;
dog_type = get_dog_type( wave_num );
if ( !isdefined( dog_type ) )
return 0;
return get_special_ai_type_quantity( wave_num, dog_type );
}
start_streaming(classname)
{
addforcestreamaitype( classname, 0 );
}
stop_streaming(classname)
{
removeforcestreamaitype( classname, 0 );
}
list_contains( list, item )
{
foreach( entry in list )
if ( entry == item )
return true;
return false;
}
list_subtract( list1, list2 )
{
result = [];
foreach( entry in list1 )
if ( !list_contains(list2,entry) )
result[result.size]=entry;
return result;
}
add_wave_class( ai_type, result )
{
if (IsDefined(ai_type) && ai_type.size )
{
if ( issubstr( ai_type, "dog" ) )
classname = "enemy_dog";
else
classname =get_ai_classname( ai_type );
if (!list_contains(result,classname))
result[result.size]=classname;
}
return result;
}
get_wave_classes(wave_num)
{
result = [];
result = add_wave_class( get_squad_type( wave_num ), result );
specials = get_special_ai( wave_num );
if (IsDefined(specials))
foreach ( special_type in specials )
{
result = add_wave_class(special_type, result);
}
bosses = get_bosses_ai( wave_num );
if (IsDefined(bosses))
foreach ( boss_type in bosses )
{
result = add_wave_class(boss_type, result);
}
return result;
}
survival_wave_stream_start(wave_num)
{
if (!IsDefined(level.current_wave_streamed) || level.current_wave_streamed!=wave_num)
{
level.current_wave_streamed=wave_num;
add = [];
del = [];
new_classes = get_wave_classes(wave_num);
if ( IsDefined( level.streamed_models ) )
{
add = list_subtract( new_classes, level.streamed_models );
del = list_subtract( level.streamed_models, new_classes );
}
else
{
add = new_classes;
del = [];
}
foreach ( d in del )
stop_streaming(d);
foreach ( a in add )
start_streaming(a);
level.streamed_models = new_classes;
}
}
ally_stream_start( ally_type )
{
aitype = undefined;
if ( ally_type == "friendly_support_delta" )
aitype = "actor_ally_so_delta";
else if ( ally_type == "friendly_support_riotshield" )
aitype = "actor_ally_so_riotshield";
if ( isDefined(level.current_ally_streamed) )
{
if (isdefined(aitype) && aitype == level.current_ally_streamed)
return;
stop_streaming(level.current_ally_streamed);
level.current_ally_streamed = undefined;
}
if (isdefined(aitype))
{
level.current_ally_streamed = aitype;
start_streaming(level.current_ally_streamed);
}
}
wave_compute_stream_size( wave_num )
{
total = 0;
if (!IsDefined(level.current_wave_streamed) || level.current_wave_streamed!=wave_num)
{
wave_classes = get_wave_classes(wave_num+1);
foreach ( c in wave_classes )
total += computestreamsizeforaitype(c);
}
return total;
}
compute_max_ally_size()
{
ally1 = computestreamsizeforaitype("actor_ally_so_delta");
ally2 = computestreamsizeforaitype("actor_ally_so_riotshield");
if (ally1 > ally2)
return ally1;
return ally2;
}
wait_calculate_max_wave_stream_size()
{
wait 0.07;
max_size = 0;
for ( i = 0; i< level.survival_wave.size; i++ )
{
wsize = wave_compute_stream_size(i);
if (wsize > max_size)
max_size=wsize;
}
max_size += compute_max_ally_size();
SetMaxEnemyStreamSize( max_size );
}	
	

