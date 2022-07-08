#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_survival_code;
#include maps\_specialops;
CONST_CHALLENGE_SET_NUM = 2;
CH_TABLE = "sp/survival_challenge.csv";
CH_INDEX = 0;
CH_REF = 1;
CH_NAME = 2;
CH_DESC = 3;
CH_SPLASH = 4;
CH_ICON = 5;
CH_REQ = 6;
CH_XP = 7;
CH_REPEAT = 8;
CH_CARRY = 9;
CH_WAVE_ACTIVE = 10;
CH_WAVE_INACTIVE = 11;
CONST_STAGGER_DECAY = 1;
CONST_STAGGER_KILLPOINTS = 6;
CONST_PROG_BAR_WIDTH = 104;
CONST_PROG_BAR_HEIGHT = 10;
Precache_Challenge_Strings()
{
PrecacheString( &"SO_SURVIVAL_SUR_CH_HEADSHOT" );
PrecacheString( &"SO_SURVIVAL_SUR_CH_STREAK" );
PrecacheString( &"SO_SURVIVAL_SUR_CH_STAGGER" );
PrecacheString( &"SO_SURVIVAL_SUR_CH_QUADKILL" );
PrecacheString( &"SO_SURVIVAL_SUR_CH_FLASH" );
PrecacheString( &"SO_SURVIVAL_SUR_CH_KNIFE" );
}
ch_populate()
{
index_start = 0;
index_end = 20;
ch_array	= [];
for( i = index_start; i <= index_end; i++ )
{
ref = ch_get_ref_by_index( i );
if ( !isdefined( ref ) || ref == "" )
break;
sur_ch = spawnstruct();
sur_ch.idx = i;
sur_ch.ref = ref;
sur_ch.name = ch_get_name( ref );
sur_ch.desc = ch_get_desc( ref );
sur_ch.splash = ch_get_splash( ref );
sur_ch.icon = ch_get_icon( ref );
sur_ch.requirement	= ch_get_requirement( ref );
sur_ch.XP = ch_get_xp( ref );
sur_ch.repeatable	= ch_get_repeatable( ref );
sur_ch.carry = ch_get_carry( ref );
sur_ch.wave_active	= ch_get_wave_active( ref );
sur_ch.wave_inactive= ch_get_wave_inactive( ref );
sur_ch.func = challenge_func_director( ref );
ch_array[ ref ] = sur_ch;
}
return ch_array;
}
challenge_init()
{
level.sur_ch = ch_populate();
flag_init( "challenge_monitor_busy" );
add_global_spawn_function( "axis", ::track_melee_streak );
add_global_spawn_function( "axis", ::track_flash_kill );
foreach( player in level.players )
player thread sur_challenge_think();
}
sur_challenge_think()
{
wait 0.05;
for( i=0;i<5;i++ )
{
self surHUD_challenge_label( i, "" );
self surHUD_challenge_progress( i, 0 );
self surHUD_challenge_reward( i, 0 );
}
self surHUD_disable( "challenge" );
flag_wait( "start_survival" );
while ( 1 )
{
ch_array = [];
foreach ( ch in level.sur_ch )
{
if ( ch.wave_active == 0 )
continue;
if ( ch.wave_inactive == 0 )
{
if ( level.current_wave >= ch.wave_active )
ch_array[ ch_array.size ] = ch;
}
else
{
if ( level.current_wave >= ch.wave_active && level.current_wave <= ch.wave_inactive )
ch_array[ ch_array.size ] = ch;
}
}
assertex( ch_array.size >= CONST_CHALLENGE_SET_NUM, "Not enough active challenges for this wave" );
count = 0;
ch_array = array_randomize( ch_array );
self.selected_ch_array = [];
self.completed_ch = [];
foreach( challenge in ch_array )
{
if ( count == CONST_CHALLENGE_SET_NUM )
break;
self.selected_ch_array[ challenge.ref ] = spawnstruct();
self.selected_ch_array[ challenge.ref ].index = count;
self.selected_ch_array[ challenge.ref ].struct = challenge;
self.completed_ch[ challenge.ref ] = 0;
assertex( isdefined( challenge.func ), "No function pointer for challenge: " + challenge.ref );
self thread [[ challenge.func ]] ( challenge.ref );
count++;
}
self surHUD_animate( "challenge" );
level waittill( "wave_ended" );
level waittill( "wave_started" );
self notify( "challenge_reset" );
}
}
challenge_func_director( sur_ch_ref )
{
switch( sur_ch_ref )
{
case "sur_ch_headshot":
return ::sur_ch_headshot;
case "sur_ch_streak":
return ::sur_ch_streak;
case "sur_ch_stagger":
return ::sur_ch_stagger;
case "sur_ch_quadkill":
return ::sur_ch_quadkill;
case "sur_ch_knife":
return ::sur_ch_knife;
case "sur_ch_flash":
return ::sur_ch_flash;
}
return undefined;
}
sur_ch_generic( sur_ch_ref )
{
self endon( "death" );
self endon( "challenge_reset" );
index = self.selected_ch_array[ sur_ch_ref ].index;
assert( isdefined( index ) );
requirement = ch_get_requirement( sur_ch_ref );
xp_reward = ch_get_xp( sur_ch_ref );
carry = ch_get_carry( sur_ch_ref );
repeatable = ch_get_repeatable( sur_ch_ref );
assert( isdefined( self.selected_ch_array ) );
assert( isdefined( self.selected_ch_array[ sur_ch_ref ] ) );
self.selected_ch_array[ sur_ch_ref ].completed = 0;
self.selected_ch_array[ sur_ch_ref ].progress = 0;
self thread setup_ch_progress_bar( index, sur_ch_ref );
victim = undefined;
while ( 1 )
{
while ( self.selected_ch_array[ sur_ch_ref ].progress < requirement )
{
self waittill( sur_ch_ref, increment, victim );
if ( !isdefined( increment ) )
increment = 1;
if ( increment < 0 )
self.selected_ch_array[ sur_ch_ref ].progress = 0;
else
self.selected_ch_array[ sur_ch_ref ].progress += increment;
self thread ch_progress_bar_update( sur_ch_ref );
}
if ( isdefined( victim ) && isAI( victim ) )
playFx( level._effect[ "money" ], victim.origin + (0,0,32) );
self.selected_ch_array[ sur_ch_ref ].progress = 0;
self.selected_ch_array[ sur_ch_ref ].completed++;
reward = self.selected_ch_array[ sur_ch_ref ].completed * ch_get_xp( sur_ch_ref );
givexp( sur_ch_ref, reward );
self thread indicate_completion( sur_ch_ref, reward );
while ( flag( "challenge_monitor_busy" ) )
wait 0.05;
self notify( "challenge_complete", sur_ch_ref );
self delayThread( 0.05, ::ch_progress_bar_update, sur_ch_ref );
if ( !repeatable )
return;
}
}
generic_kill_monitor( sur_ch_ref, progress_increment )
{
self endon( "death" );
self endon( "challenge_reset" );
while( 1 )
{
old_kills = self.stats[ "kills" ];
level waittill( "specops_player_kill", attacker, victim, weaponName, killtype );
if ( !isalive( attacker )|| attacker != self )
{
continue;
}
waittillframeend;
if ( old_kills < self.stats[ "kills" ] )
{
kills_delta = self.stats[ "kills" ] - old_kills;
for ( i=0; i< kills_delta; i++ )
{
self notify( sur_ch_ref, progress_increment, victim );
waittillframeend;
}
}
}
}
sur_ch_flash( sur_ch_ref )
{
self thread sur_ch_generic( sur_ch_ref );
}
track_flash_kill()
{
level endon( "special_op_terminated" );
if ( !IsAI( self ) )
return;
while ( 1 )
{
self waittill( "death", attacker, type, weapon );
if ( !isdefined( attacker ) || !isplayer( attacker ) )
continue;
if ( self isFlashed() && ( !isdefined( self.flash_killed ) || !self.flash_killed ) )
{
self.flash_killed = true;
attacker notify( "sur_ch_flash", 1 );
}
}
}
sur_ch_knife( sur_ch_ref )
{
self thread sur_ch_generic( sur_ch_ref );
}
track_melee_streak()
{
level endon( "special_op_terminated" );
if ( !IsAI( self ) )
return;
while ( 1 )
{
self waittill( "death", attacker, type, weapon );
if ( !isdefined( attacker ) || !isplayer( attacker ) )
continue;
if ( isdefined( weapon ) && weapontype( weapon ) == "riotshield" )
continue;
if ( isdefined( type ) && type == "MOD_MELEE" )
attacker notify( "sur_ch_knife", 1 );
else
attacker notify( "sur_ch_knife", -1 );
}
}
sur_ch_quadkill( sur_ch_ref )
{
self thread sur_ch_generic( sur_ch_ref );
}
sur_ch_headshot( sur_ch_ref )
{
self thread sur_ch_generic( sur_ch_ref );
}
sur_ch_streak( sur_ch_ref )
{
self endon( "death" );
self endon( "challenge_reset" );
self thread sur_ch_generic( sur_ch_ref );
waittillframeend;
self thread generic_kill_monitor( sur_ch_ref, 1 );
self thread streak_reset( sur_ch_ref );
}
streak_reset( sur_ch_ref )
{
self endon( "death" );
self endon( "challenge_reset" );
while ( 1 )
{
self waittill( "damage", amount, attacker );
if ( isdefined( attacker ) && isAI( attacker ) )
self notify( sur_ch_ref, -1 );
}
}
sur_ch_stagger( sur_ch_ref )
{
self endon( "death" );
self endon( "challenge_reset" );
self thread sur_ch_generic( sur_ch_ref );
waittillframeend;
self thread generic_kill_monitor( sur_ch_ref, CONST_STAGGER_KILLPOINTS );
self thread stagger_decay( sur_ch_ref );
}
stagger_decay( sur_ch_ref )
{
self endon( "death" );
self endon( "challenge_reset" );
sample_frequency = 5;
sample_frequency = min( 20, sample_frequency );
decay_point_per_sample = CONST_STAGGER_DECAY/sample_frequency;
while ( 1 )
{
grace_time = 2;
while ( self.selected_ch_array[ sur_ch_ref ].progress == 0 )
self waittill_any_timeout( grace_time, sur_ch_ref );
if( level.survival_wave_intermission )
{
level waittill( "wave_started" );
wait grace_time;
}
for( i=0; i<sample_frequency; i++ )
{
wait 1/sample_frequency;
old_progress = self.selected_ch_array[ sur_ch_ref ].progress;
self.selected_ch_array[ sur_ch_ref ].progress = max( 0, old_progress - decay_point_per_sample );
self thread ch_progress_bar_update( sur_ch_ref );
}
}
}
CONST_Y_OFFSET = -152;
CONST_X_OFFSET = 0;
setup_ch_progress_bar( index, sur_ch_ref )
{
self surHUD_challenge_label( index, ch_get_name( sur_ch_ref ) );
self thread ch_progress_bar_update( sur_ch_ref );
}
ch_progress_bar_update( sur_ch_ref )
{
index = self.selected_ch_array[ sur_ch_ref ].index;
progress = self.selected_ch_array[ sur_ch_ref ].progress;
reward_x	= self.selected_ch_array[ sur_ch_ref ].completed + 1;
requirement = ch_get_requirement( sur_ch_ref );
self surHUD_challenge_reward( index, ch_get_xp( sur_ch_ref ) * reward_x );
self surHUD_challenge_progress( index, int( ( progress / requirement ) * 100 )/100 );
}
indicate_completion( sur_ch_ref, reward )
{
if( IsDefined( self.doingNotify ) && self.doingNotify )
{
while( self.doingNotify )
wait( 0.05 );
}
splashData = SpawnStruct();
splashData.duration = 2.5;
splashData.sound = "survival_bonus_splash";
splashData.type = "wave";
splashData.title_font = "hudbig";
splashData.playSoundLocally = true;
splashData.zoomIn = true;
splashData.zoomOut = true;
splashData.fadeIn = true;
splashData.fadeOut = true;
splashData.title_glowColor = ( 0.85, 0.35, 0.15 );
splashData.title_color = ( 0.95, 0.95, 0.9 );
splashData.title = ch_get_splash( sur_ch_ref );
splashData.title_set_value = reward;
if( IsSplitscreen() )
splashData.title_baseFontScale = 1;
else
splashData.title_baseFontScale = 1.1;
self splash_notify_message( splashData );
}
ch_exist( ref )
{
return isdefined( level.sur_ch ) && isdefined( level.sur_ch[ ref ] );
}
ch_get_index_by_ref( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].idx;
return tablelookup( CH_TABLE, CH_REF, ref, CH_INDEX );
}
ch_get_ref_by_index( index )
{
return tablelookup( CH_TABLE, CH_INDEX, index, CH_REF );
}
ch_get_name( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].name;
return tablelookup( CH_TABLE, CH_REF, ref, CH_NAME );
}
ch_get_desc( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].desc;
return tablelookup( CH_TABLE, CH_REF, ref, CH_DESC );
}
ch_get_splash( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].splash;
return tablelookupistring( CH_TABLE, CH_REF, ref, CH_SPLASH );
}
ch_get_icon( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].icon;
return tablelookup( CH_TABLE, CH_REF, ref, CH_ICON );
}
ch_get_requirement( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].requirement;
return int( tablelookup( CH_TABLE, CH_REF, ref, CH_REQ ) );
}
ch_get_XP( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].XP;
return int( tablelookup( CH_TABLE, CH_REF, ref, CH_XP ) );
}
ch_get_repeatable( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].repeatable;
return int( tablelookup( CH_TABLE, CH_REF, ref, CH_REPEAT ) );
}
ch_get_carry( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].carry;
return int( tablelookup( CH_TABLE, CH_REF, ref, CH_CARRY ) );
}
ch_get_wave_active( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].wave_active;
return int( tablelookup( CH_TABLE, CH_REF, ref, CH_WAVE_ACTIVE ) );
}
ch_get_wave_inactive( ref )
{
if ( ch_exist( ref ) )
return level.sur_ch[ ref ].wave_inactive;
return int( tablelookup( CH_TABLE, CH_REF, ref, CH_WAVE_INACTIVE ) );
}