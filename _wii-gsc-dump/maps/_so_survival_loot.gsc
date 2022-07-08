#include common_scripts\utility;
#include maps\_so_survival_code;
LOOT_TABLE = "sp/survival_loot.csv";
TABLE_INDEX = 0;
TABLE_REF = 1;
TABLE_TYPE = 2;
TABLE_NAME = 3;
TABLE_DESC = 4;
TABLE_CHANCE = 5;
TABLE_WAVE_UNLOCK = 6;
TABLE_WAVE_LOCK = 7;
TABLE_RANK = 8;
TABLE_VAR1 = 9;
LOOT_INDEX_START = 0;
LOOT_INDEX_END = 20;
LOOT_VERSION_INDEX_START = 100;
LOOT_VERSION_INDEX_END = 199;
CONST_WEAPON_DROP_AMMO_CLIP = 0.4;
CONST_WEAPON_DROP_AMMO_STOCK = 0.5;
CONST_WEAPON_DROP_ALT_AMMO_CLIP = 0.5;
CONST_WEAPON_DROP_ALT_AMMO_STOCK = 0.5;
CONST_LOOT_DROP_MIN_WAVES_LAST_DROP = 2;
CONST_LOOT_LAST_WAVE_DROP_DEFAULT = -999;
loot_preload()
{
for ( i = LOOT_INDEX_START; i <= LOOT_INDEX_END; i++ )
{
loot_ref = get_loot_ref_by_index( i );
if( isdefined( loot_ref ) && get_loot_type( loot_ref ) == "weapon" )
precache_loadout_item( loot_ref );
}
for ( i = LOOT_VERSION_INDEX_START; i <= LOOT_VERSION_INDEX_END; i++ )
{
loot_version = get_loot_version_by_index( i );
if( isdefined( loot_version ) )
precache_loadout_item( loot_version );
}
}
loot_postload()
{
}
loot_init()
{
loot_populate( LOOT_INDEX_START, LOOT_INDEX_END, LOOT_VERSION_INDEX_START, LOOT_VERSION_INDEX_END );
}
loot_populate( loot_start_idx, loot_end_idx, version_start_idx, version_end_idx )
{
level.loot_version_array = [];
for ( i = version_start_idx; i <= version_end_idx; i++ )
{
version = get_loot_version_by_index( i );
if ( isdefined( version ) && version != "" )
{
level.loot_version_array[ level.loot_version_array.size ] = version;
}
}
level.loot_info_array = [];
for ( i = loot_start_idx; i <= loot_end_idx; i++ )
{
loot_ref = get_loot_ref_by_index( i );
if( !isdefined( loot_ref ) || loot_ref == "" )
continue;
loot_type = get_loot_type( loot_ref );
if ( !isdefined( level.loot_info_array[ loot_type ] ) )
level.loot_info_array[ loot_type ] = [];
item = spawnstruct();
item.index = i;
item.ref = loot_ref;
item.type = loot_type;
item.name = get_loot_name( loot_ref );
item.desc = get_loot_desc( loot_ref );
item.chance = get_loot_chance( loot_ref );
item.wave_unlock	= get_loot_wave_unlock( loot_ref );
item.wave_lock = get_loot_wave_lock( loot_ref );
item.wave_dropped	= CONST_LOOT_LAST_WAVE_DROP_DEFAULT;
item.rank = get_loot_rank( loot_ref );
item.versions = get_loot_versions( loot_ref );
level.loot_info_array[ loot_type ][ loot_ref ] = item;
}
}
loot_roll( chance_override )
{
if ( !isdefined( level.loot_info_array ) || !isdefined( level.loot_info_array[ "weapon" ] ) )
return false;
loot_item_array = [];
foreach( loot in level.loot_info_array[ "weapon" ] )
{
if	(
level.current_wave >= loot.wave_unlock
&&	level.current_wave < loot.wave_lock
&&	level.current_wave - loot.wave_dropped >= CONST_LOOT_DROP_MIN_WAVES_LAST_DROP
&&	highest_player_rank() >= loot.rank
)
{
loot_item_array[ loot_item_array.size ] = loot;
}
}
if ( !loot_item_array.size )
return false;
loot_item_array = maps\_utility_joec::exchange_sort_by_handler( loot_item_array, ::loot_roll_compare_type_wave_dropped );
loot_version = undefined;
foreach( loot in loot_item_array )
{
chance = ter_op( isdefined( chance_override ), chance_override, loot.chance );
if ( chance > randomfloatrange( 0.0, 1.0 ) )
{
loot_version = loot.versions[ randomint( loot.versions.size ) ];
loot.wave_dropped = level.current_wave;
break;
}
}
if ( isdefined( loot_version ) )
{
weapon_name = loot_version;
weapon_model = getweaponmodel( weapon_name );
self.dropweapon	= false;
self thread loot_drop_on_death( "weapon_" + weapon_name, weapon_name, "weapon", weapon_model, "tag_stowed_back" );
return true;
}
return false;
}
loot_roll_compare_type_wave_dropped()
{
assertex( isdefined( self ) && isdefined( self.wave_dropped ), "self.wave_dropped not defined." );
last_drop_wave = ter_op( isdefined( self ) && isdefined( self.wave_dropped ), self.wave_dropped, CONST_LOOT_LAST_WAVE_DROP_DEFAULT );
return last_drop_wave;
}
loot_drop_on_death( loot_class, loot_name, loot_type, model_name, tag )
{
level endon( "special_op_terminated" );
loot_model = spawn( "script_model", self gettagorigin( tag ) );
loot_model setmodel( model_name );
loot_model linkto( self, tag, (0, 0, 0), (0, 0, 0) );
self waittill_any( "death", "long_death" );
if ( !isdefined( self ) )
return;
loot_item = spawn( loot_class, self gettagorigin( tag ) );
if ( isdefined( loot_type ) && loot_type == "weapon" )
{
ammo_in_clip = int( max( 1, CONST_WEAPON_DROP_AMMO_CLIP * weaponclipsize( loot_name ) ) );
ammo_in_stock = int( max( 1, CONST_WEAPON_DROP_AMMO_STOCK * weaponmaxammo( loot_name ) ) );
loot_item itemweaponsetammo( ammo_in_clip, ammo_in_stock );
alt_weapon = weaponaltweaponname( loot_name );
if ( alt_weapon != "none" )
{
ammo_alt_clip	= int( max( 1, CONST_WEAPON_DROP_ALT_AMMO_CLIP * weaponclipsize( alt_weapon ) ) );
ammo_alt_stock	= int( max( 1, CONST_WEAPON_DROP_ALT_AMMO_STOCK * weaponmaxammo( alt_weapon ) ) );
loot_item itemweaponsetammo( ammo_alt_clip, ammo_alt_stock, ammo_alt_clip, 1 );
}
}
print3d( loot_item.origin, "loot!", (1 ,1, 0), 0.5, 1, 200 );
loot_model unlink();
wait 0.05;
loot_model delete();
}
loot_item_exist( ref )
{
return isdefined( level.loot_info_array ) && isdefined( level.loot_info_array[ ref ] );
}
get_loot_ref_by_index( idx )
{
assertex( idx >= LOOT_INDEX_START && idx <= LOOT_INDEX_END, "Tried to get loot outside of the bounds of the loot indexes." );
return get_ref_by_index( idx );
}
get_ref_by_index( idx )
{
return tablelookup( LOOT_TABLE, TABLE_INDEX, idx, TABLE_REF );
}
get_loot_type( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].type;
return tablelookup( LOOT_TABLE, TABLE_REF, ref, TABLE_TYPE );
}
get_loot_name( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].name;
return tablelookup( LOOT_TABLE, TABLE_REF, ref, TABLE_NAME );
}
get_loot_desc( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].desc;
return tablelookup( LOOT_TABLE, TABLE_REF, ref, TABLE_DESC );
}
get_loot_chance( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].chance;
return float( tablelookup( LOOT_TABLE, TABLE_REF, ref, TABLE_CHANCE ) );
}
get_loot_wave_unlock( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].wave_unlock;
return int( tablelookup( LOOT_TABLE, TABLE_REF, ref, TABLE_WAVE_UNLOCK ) );
}
get_loot_wave_lock( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].wave_lock;
return int( tablelookup( LOOT_TABLE, TABLE_REF, ref, TABLE_WAVE_LOCK ) );
}
get_loot_rank( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].rank;
return int( tablelookup( LOOT_TABLE, TABLE_REF, ref, TABLE_RANK ) );
}
get_loot_version_by_index( idx )
{
assertex( idx >= LOOT_VERSION_INDEX_START && idx <= LOOT_VERSION_INDEX_END, "Tried to get loot version outside of the bounds of the loot indexes." );
return get_ref_by_index( idx );
}
get_loot_versions( ref )
{
if ( loot_item_exist( ref ) )
return level.loot_info_array[ ref ].versions;
assertex( isdefined( level.loot_version_array ), "The loot version array has not been populated." );
name = "joe";
versions = [];
base_ref = ref;
if ( get_loot_type( ref ) == "weapon" )
base_ref = getsubstr( ref, 0, ref.size - 3 );
foreach( v in level.loot_version_array )
{
if ( issubstr( v, base_ref ) )
{
versions[ versions.size ] = v;
}
}
if ( !versions.size )
versions[ versions.size ] = ref;
return versions;
}