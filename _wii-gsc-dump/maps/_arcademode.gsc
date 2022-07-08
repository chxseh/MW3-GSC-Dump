#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
main()
{
precachestring( &"SCRIPT_COLON" );
precachestring( &"SCRIPT_TIME_REMAINING" );
precachestring( &"SCRIPT_TOTAL_SCORE" );
precachestring( &"SCRIPT_EXTRA_LIFE" );
precachestring( &"SCRIPT_CHECKPOINT" );
precachestring( &"SCRIPT_MISSION_SCORE" );
precachestring( &"SCRIPT_ZERO_DEATHS" );
precachestring( &"SCRIPT_PLUS" );
precachestring( &"SCRIPT_TIME_UP" );
precachestring( &"SCRIPT_1UP" );
precachestring( &"SCRIPT_GAME_OVER" );
precachestring( &"SCRIPT_DIFFICULTY_BONUS_ONEANDAHALF" );
precachestring( &"SCRIPT_DIFFICULTY_BONUS_THREE" );
precachestring( &"SCRIPT_DIFFICULTY_BONUS_FOUR" );
precachestring( &"SCRIPT_MISSION_COMPLETE" );
precachestring( &"SCRIPT_NEW_HIGH_SCORE" );
precachestring( &"SCRIPT_STREAK_BONUS_LOST" );
precachestring( &"SCRIPT_STREAK_COMPLETE" );
precachestring( &"SCRIPT_X" );
precacheShader( "arcademode_life" );
level.color_cool_green = ( 0.8, 2.0, 0.8 );
level.color_cool_green_glow = ( 0.3, 0.6, 0.3 );
arcadeMode_init_kill_streak_colors();
level.arcadeMode_checkpoint_dvars = [];
level.arcadeMode_checkpoint_max = 10;
level.arcadeMode_kills_hud = [];
level.arcademode_kill_streak_ends = 0;
level.arcadeMode_last_streak_time = 0;
level.arcadeMode_ramping_score = 0;
level.arcadeMode_new_kill_streak_allowed = true;
flag_init( "arcadeMode_multiplier_maxed" );
setdvar( "arcademode_lives_changed", 0 );
level.arcadeMode_kill_streak_current_multiplier = 1;
level.arcadeMode_kill_streak_multiplier_count = 3;
arcadeMode_reset_kill_streak();
for ( i = 0; i < level.arcadeMode_checkpoint_max; i++ )
{
setdvar( "arcademode_checkpoint_" + i, "" );
}
level.arcadeMode_last_multi_kill_sound = 0;
level.arcadeMode_success = false;
arcadeMode_define_damage_multipliers();
flag_init( "arcademode_complete" );
flag_init( "arcademode_ending_complete" );
waittillframeend;
level.global_kill_func = ::player_kill;
level.global_damage_func_ads = ::player_damage_ads;
level.global_damage_func = ::player_damage;
level.arcadeMode_hud_sort = 50;
level.arcadeMode_maxlives = 10;
level.arcademode_rewarded_lives = 0;
if ( getdvar( "arcademode_lives" ) == "" || getdvar( "arcademode_full" ) != "1" || level.script == "cargoship" )
{
setdvar( "arcademode_lives", 2 );
level.arcademode_rewarded_lives = 2;
}
if ( getdvar( "arcademode_full" ) == "1" && level.script == "cargoship" )
{
setdvar( "arcademode_lives", 5 );
level.arcademode_rewarded_lives = 5;
}
lives = getdvarint( "arcadeMode_lives" );
setdvar( "arcademode_earned_lives", lives );
level.arcademode_playthrough = getdvarint( "arcademode_playthrough_count" );
level.arcademode_playthrough++ ;
setdvar( "arcademode_playthrough_count", level.arcademode_playthrough );
setdvar( "arcademode_died", 0 );
setdvar( "arcademode_score", 0 );
if ( getdvar( "arcademode_combined_score" ) == "" || ( getdvar( "arcademode_full" ) == "1" && level.script == "cargoship" ) )
{
setdvar( "arcademode_combined_score", 0 );
}
timer = arcademode_get_level_time();
timer *= 60;
level.arcdeMode_startTime = gettime();
level.arcadeMode_time = timer;
level.arcadeMode_killBase = 50;
level.arcadeMode_damageBase = 5;
level.arcadeMode_multiKills = [];
mods = getarraykeys( level.arcadeMode_weaponMultiplier );
for ( i = 0; i < mods.size; i++ )
{
level.arcadeMode_multiKills[ mods[ i ] ] = [];
}
blank_array = level.arcadeMode_multiKills;
thread arcademode_update_lives();
thread arcademode_update_score();
thread arcademode_update_timer();
thread arcadeMode_death_detection();
arcademode_redraw_lives( lives );
for ( ;; )
{
wait( 0.05 );
waittillframeend;
waittillframeend;
mods = getarraykeys( level.arcadeMode_multiKills );
array_levelthread( mods, ::arcadeMode_add_points_for_mod );
level.arcadeMode_multiKills = blank_array;
}
}
arcademode_complete()
{
if ( getdvar( "arcademode" ) != "1" )
return false;
return flag( "arcademode_complete" );
}
arcademode_get_level_time()
{
time_remaining = 20;
timer = [];
difficultyTimerScale = 1;
if ( isdefined( timer[ level.script ] ) )
time_remaining = timer[ level.script ];
level.arcademode_difficultyTimerScale = difficultyTimerScale;
return time_remaining;
}
arcadeMode_death_detection()
{
level endon( "arcademode_complete" );
level add_wait( ::flag_wait, "missionfailed" );
level.player add_wait( ::waittill_msg, "death" );
do_wait_any();
setdvar( "arcademode_died", 1 );
lives = getdvarint( "arcademode_lives" );
earned_lives = getdvarint( "arcademode_earned_lives" );
if ( lives > earned_lives )
lives = earned_lives;
lives -= 1;
setdvar( "arcademode_lives", lives );
setdvar( "arcademode_lives_changed", -1 );
arcademode_redraw_lives( lives + 1 );
level.arcadeMode_redraw_score = true;
UpdateScoreElemsOnce();
if ( lives < 0 )
{
wait 1.5;
level.arcadeMode_failureString = &"SCRIPT_GAME_OVER";
thread arcademode_ends();
return;
}
if ( isalive( level.player ) )
{
missionfailed();
}
}
arcademode_update_timer()
{
level.player endon( "death" );
hud_time = newHudElem();
hud_time.foreground = true;
hud_time.alignX = "right";
hud_time.alignY = "top";
hud_time.horzAlign = "right";
hud_time.vertAlign = "top";
hud_time.x = 0;
hud_time.y = 60;
hud_time.sort = level.arcadeMode_hud_sort;
hud_time.fontScale = 3;
hud_time.color = ( 0.8, 1.0, 0.8 );
hud_time.font = "objective";
hud_time.glowColor = ( 0.3, 0.6, 0.3 );
hud_time.glowAlpha = 1;
hud_time.hidewheninmenu = true;
level.arcadeMode_hud_timer = hud_time;
level endon( "arcadeMode_remove_timer" );
timer = level.arcadeMode_time;
hud_time settimer( timer - .1 );
wait( timer );
level.arcadeMode_failureString = &"SCRIPT_TIME_UP";
thread arcadeMode_ends();
}
arcademode_update_lives()
{
level.player endon( "death" );
level endon( "missionfailed" );
level.arcadeMode_lives_hud = [];
for ( i = 0; i < level.arcadeMode_maxlives; i++ )
{
arcademode_add_life( i, 16, 78, - 18, 64, level.arcadeMode_hud_sort );
}
for ( ;; )
{
change = getdvarint( "arcademode_lives_changed" );
if ( change != 0 )
{
lives = getdvarint( "arcademode_lives" );
if ( lives < 0 )
{
level.arcadeMode_failureString = &"SCRIPT_GAME_OVER";
thread arcadeMode_ends();
return;
}
if ( change == -1 )
{
level notify( "lost_streak" );
level.arcademode_kill_streak_ends = gettime();
thread arcademode_add_kill_streak_time( 0 );
level.arcadeMode_new_kill_streak_allowed = false;
earned_lives = getdvarint( "arcademode_earned_lives" );
earned_lives -- ;
lives = earned_lives;
setdvar( "arcademode_earned_lives", earned_lives );
setdvar( "arcademode_lives", earned_lives );
}
arcademode_redraw_lives( lives );
level.arcadeMode_redraw_score = true;
setdvar( "arcademode_lives_changed", 0 );
}
wait( 0.05 );
}
}
arcademode_convert_extra_lives()
{
arcadeMode_lives = getdvarint( "arcademode_lives" );
earned = getdvarint( "arcademode_earned_lives" );
if ( arcadeMode_lives > earned )
thread extra_lives_display( arcadeMode_lives - earned );
setdvar( "arcademode_earned_lives", arcadeMode_lives );
thread maps\_arcademode::arcademode_redraw_lives( arcadeMode_lives );
return arcadeMode_lives > earned;
}
arcademode_checkpoint_print()
{
if ( !arcadeMode() )
return;
arcademode_convert_extra_lives();
start_offset = 800;
movetime = 0.8;
level.player thread play_sound_in_space( "arcademode_checkpoint", level.player geteye() );
thread maps\_arcademode::draw_checkpoint( start_offset, movetime, 1 );
thread maps\_arcademode::draw_checkpoint( start_offset, movetime, -1 );
}
arcadeMode_redraw_life( index, earned_lives )
{
if ( index >= earned_lives )
self setshader( "arcademode_life", 64, 64 );
else
self setshader( "stance_stand", 64, 64 );
self fadeovertime( 1 );
self.alpha = 1;
self.glowAlpha = 1;
self.color = level.color_cool_green;
}
arcadeMode_remove_life( index )
{
if ( self.alpha <= 0 )
return;
self fadeovertime( 1 );
self.alpha = 0;
self.color = ( 1, 0, 0 );
self.glowAlpha = 0;
}
arcademode_redraw_lives( lives )
{
if ( lives > 10 )
lives = 10;
earned_lives = getdvarint( "arcademode_earned_lives" );
for ( i = 0; i < lives; i++ )
{
level.arcadeMode_lives_hud[ i ] arcadeMode_redraw_life( i, earned_lives );
}
for ( i = lives; i < level.arcadeMode_maxlives; i++ )
{
if ( i < 0 )
continue;
if ( i >= 10 )
continue;
level.arcadeMode_lives_hud[ i ] arcadeMode_remove_life( i );
}
}
arcademode_update_streak_progress()
{
for ( ;; )
{
level waittill_either( "arcademode_decrement_kill_streak", "arcademode_new_kill" );
waittillframeend;
arcademode_redraw_streak_progress();
}
}
arcademode_redraw_streak_progress()
{
for ( i = 0; i < level.arcadeMode_kill_streak_current_count; i++ )
{
if ( i >= level.arcadeMode_kills_hud.size )
return;
level.arcadeMode_kills_hud[ i ].color = level.arcadeMode_streak_color[ level.arcadeMode_kill_streak_current_multiplier - 1 ];
level.arcadeMode_kills_hud[ i ].glowColor = level.arcadeMode_streak_glow[ level.arcadeMode_kill_streak_current_multiplier - 1 ];
}
count = 0;
for ( ;; )
{
color = level.arcadeMode_kill_streak_current_multiplier + count;
if ( color >= level.arcadeMode_streak_color.size )
{
color = level.arcadeMode_streak_color.size - 1;
}
for ( i = level.arcadeMode_kill_streak_current_count + count * level.arcadeMode_kill_streak_multiplier_count; i < level.arcadeMode_kill_streak_current_count + ( count + 1 ) * level.arcadeMode_kill_streak_multiplier_count; i++ )
{
if ( i >= level.arcadeMode_kills_hud.size )
return;
level.arcadeMode_kills_hud[ i ].color = level.arcadeMode_streak_color[ color ];
level.arcadeMode_kills_hud[ i ].glowColor = level.arcadeMode_streak_glow[ color ];
}
count++ ;
}
}
arcademode_add_kill( num, x, y, offset, scale, sort )
{
level endon( "arcademode_stop_kill_streak_art" );
hud_kill = newHudElem();
hud_kill.foreground = true;
hud_kill.x = x + num * offset;
if ( level.arcadeMode_kills_hud.size == 0 )
{
level.arcademode_kill_zero_x_location = hud_kill.x;
}
hud_kill.y = y;
hud_kill setshader( "arcademode_kill", scale, scale );
hud_kill.alignX = "right";
hud_kill.alignY = "top";
hud_kill.horzAlign = "right";
hud_kill.vertAlign = "top";
hud_kill.sort = sort;
hud_kill.color = level.color_cool_green;
hud_kill.glowColor = level.color_cool_green_glow;
hud_kill.glowAlpha = 1;
hud_kill.hidewheninmenu = true;
leftermost = false;
level.arcadeMode_kills_hud[ level.arcadeMode_kills_hud.size ] = hud_kill;
if ( level.arcadeMode_kills_hud.size == 10 )
{
leftermost = true;
hud_kill.alpha = 0;
}
else
{
hud_kill.alpha = 1;
}
for ( ;; )
{
if ( hud_kill.x == level.arcademode_kill_zero_x_location )
{
decay_time = 4;
if ( level.arcadeMode_kills_hud.size == 1 )
{
wait( 3 );
}
hud_kill fadeovertime( decay_time );
hud_kill.color = ( 1, 0, 0 );
hud_kill.alpha = 0;
wait( decay_time );
level notify( "arcademode_decrement_kill_streak" );
hud_kill destroy();
for ( i = 0; i < level.arcadeMode_kills_hud.size - 1; i++ )
{
level.arcadeMode_kills_hud[ i ] = level.arcadeMode_kills_hud[ i + 1 ];
}
level.arcadeMode_kills_hud[ level.arcadeMode_kills_hud.size - 1 ] = undefined;
if ( !level.arcadeMode_kills_hud.size )
thread arcadeMode_reset_kill_streak();
return;
}
level waittill( "arcademode_decrement_kill_streak" );
wait( 0.05 );
hud_kill moveovertime( 0.5 );
hud_kill.x -= offset;
if ( leftermost )
{
hud_kill fadeovertime( 0.5 );
hud_kill.alpha = 1;
leftermost = false;
}
}
}
get_streak_hud( x, y, width, height )
{
streak_hud = newhudelem();
streak_hud.foreground = true;
streak_hud.x = x + -4;
streak_hud.y = y + 14;
streak_hud.alignX = "right";
streak_hud.alignY = "top";
streak_hud.horzAlign = "right";
streak_hud.vertAlign = "top";
streak_hud.color = level.color_cool_green;
streak_hud.sort = level.arcadeMode_hud_sort - 1;
streak_hud.alpha = 0;
streak_hud.glowColor = level.color_cool_green_glow;
streak_hud.glowAlpha = 0;
streak_hud.hidewheninmenu = true;
streak_hud setShader( "white", width, height );
return streak_hud;
}
arcademode_add_kill_streak_time( timer )
{
if ( !level.arcadeMode_new_kill_streak_allowed )
return;
level notify( "arcademode_new_kill_streak_time" );
level endon( "arcademode_new_kill_streak_time" );
if ( level.arcademode_kill_streak_ends < gettime() )
{
level.arcademode_kill_streak_ends = gettime() + timer * 1000;
}
else
{
level.arcademode_kill_streak_ends += timer * 1000;
}
waittillframeend;
if ( isdefined( level.arcademode_hud_streak ) )
{
level.arcademode_hud_streak fadeovertime( 0.05 );
level.arcademode_hud_streak.alpha = 1;
}
height = 26;
width_mult = 12;
max_timer = 90;
streak_hud = level.arcadeMode_streak_hud;
streak_hud_shadow = level.arcadeMode_streak_hud_shadow;
width = level.arcademode_kill_streak_ends - gettime();
width *= 0.001;
if ( width > max_timer )
width = max_timer;
width *= width_mult;
width = int( width );
if ( width > 980 )
width = 980;
if ( !isdefined( streak_hud ) )
{
streak_hud = get_streak_hud( 0, 0, width, height );
streak_hud_shadow = get_streak_hud( 3, 3, width, height );
streak_hud_shadow.sort = streak_hud_shadow.sort - 1;
streak_hud_shadow.alpha = 0.0;
streak_hud_shadow.color = ( 0, 0, 0 );
}
else
{
streak_hud ScaleOverTime( 1, width, height );
streak_hud_shadow ScaleOverTime( 1, width, height );
wait( 1 );
}
level.arcadeMode_streak_hud = streak_hud;
level.arcadeMode_streak_hud_shadow = streak_hud_shadow;
streak_hud endon( "death" );
timer = level.arcademode_kill_streak_ends - gettime();
timer *= 0.001;
drawTimer = int( timer );
if ( drawTimer > max_timer )
{
drawTimer = max_timer;
wait( timer - drawTimer );
}
for ( ;; )
{
width = level.arcademode_kill_streak_ends - gettime();
width *= 0.001;
time_remaining = width;
if ( isdefined( level.arcademode_hud_streak ) )
{
level.arcademode_hud_streak fadeovertime( 1 );
level.arcademode_hud_streak.alpha = ( time_remaining - 1 ) / 5;
}
width *= width_mult;
width = int( width );
if ( width <= 0 )
width = 1;
if ( width > 980 )
width = 980;
streak_hud ScaleOverTime( 1, width, height );
streak_hud_shadow ScaleOverTime( 1, width, height );
wait( 1 );
if ( width == 1 )
break;
}
thread arcadeMode_reset_kill_streak();
}
arcademode_add_kill_streak()
{
if ( flag( "arcadeMode_multiplier_maxed" ) )
return;
level endon( "arcadeMode_multiplier_maxed" );
level endon( "arcademode_stop_kill_streak" );
level.arcadeMode_kill_streak_current_count -- ;
streak_time = gettime();
if ( level.arcadeMode_kill_streak_current_count <= 0 && streak_time > level.arcadeMode_last_streak_time )
{
level.arcadeMode_last_streak_time = streak_time;
old_mult = level.arcadeMode_kill_streak_current_multiplier;
level.arcadeMode_kill_streak_current_multiplier++ ;
if ( level.arcadeMode_kill_streak_current_multiplier >= level.arcadeMode_streak_color.size )
{
level.arcadeMode_kill_streak_current_multiplier = level.arcadeMode_streak_color.size;
thread arcadeMode_multiplier_maxed();
}
if ( old_mult != level.arcadeMode_kill_streak_current_multiplier )
{
level notify( "arcademode_new_kill_streak" );
level.player playsound( "arcademode_" + level.arcadeMode_kill_streak_current_multiplier + "x" );
thread arcademode_draw_multiplier();
}
level.arcadeMode_kill_streak_current_count = level.arcadeMode_kill_streak_multiplier_count;
}
level notify( "arcademode_new_kill" );
for ( ;; )
{
if ( level.arcadeMode_kills_hud.size < 10 )
{
arcademode_add_kill_streak_time( 5 );
return;
}
level waittill( "arcademode_decrement_kill_streak" );
}
}
streak_timer_color_pulse()
{
waittillframeend;
waittillframeend;
level.arcadeMode_streak_hud endon( "death" );
for ( ;; )
{
timer = randomfloatrange( 0.1, 1.0 );
level.arcadeMode_streak_hud fadeovertime( timer );
level.arcadeMode_streak_hud.color = ( randomfloat( 1 ), randomfloat( 1 ), randomfloat( 1 ) );
wait( timer );
}
}
arcadeMode_multiplier_maxed()
{
waittillframeend;
if ( flag( "arcadeMode_multiplier_maxed" ) )
return;
flag_set( "arcadeMode_multiplier_maxed" );
streak_time = 20;
level.arcademode_kill_streak_ends = gettime() + streak_time * 1000;
thread arcademode_add_kill_streak_time( 0 );
thread streak_timer_color_pulse();
MusicStop();
wait( 0.05 );
MusicPlay( "airplane_alt_maximum_music" );
add_wait( ::_wait, streak_time + 1 );
level add_wait( ::waittill_msg, "lost_streak" );
do_wait_any();
thread arcadeMode_reset_kill_streak();
MusicStop();
if ( isdefined( level.last_song ) )
{
wait( 0.05 );
MusicPlay( level.last_song );
}
}
get_hud_score()
{
hud_score = newHudElem();
hud_score.foreground = true;
hud_score.x = 0;
hud_score.y = 10;
hud_score.alignX = "right";
hud_score.alignY = "top";
hud_score.horzAlign = "right";
hud_score.vertAlign = "top";
hud_score.score = 0;
hud_score.font = "objective";
hud_score.fontScale = 5;
hud_score.sort = level.arcadeMode_hud_sort;
hud_score.glowColor = level.color_cool_green_glow;
hud_score.glowAlpha = 1;
hud_score.hidewheninmenu = true;
return hud_score;
}
arcademode_update_score()
{
level.player endon( "death" );
level.arcademode_hud_digits = 10;
level.arcademode_hud_scores = [];
for ( i = 0; i < level.arcademode_hud_digits; i++ )
{
level.arcademode_hud_scores[ level.arcademode_hud_scores.size ] = get_hud_score();
level.arcademode_hud_scores[ level.arcademode_hud_scores.size - 1 ].x = i * - 30;
}
if ( getdvarint( "arcademode_full" ) )
score = getdvarint( "arcademode_combined_score" );
else
score = getdvarint( "arcademode_score" );
hud_draw_score( score );
level.arcadeMode_redraw_score = false;
for ( ;; )
{
wait( 0.05 );
UpdateScoreElemsOnce();
if ( level.arcadeMode_redraw_score )
{
level.arcadeMode_redraw_score = false;
}
}
}
UpdateScoreElemsOnce()
{
if ( getdvarint( "arcademode_full" ) )
hud_update_score( "arcadeMode_combined_score" );
else
hud_update_score( "arcademode_score" );
}
hud_update_score( score_dvar )
{
score = getdvarint( score_dvar );
if ( level.arcadeMode_redraw_score )
{
level.arcadeMode_ramping_score = score;
hud_draw_score( score );
return;
}
if ( level.arcadeMode_ramping_score >= score )
return;
difference = score - level.arcadeMode_ramping_score;
boost = difference * 0.2 + 1;
if ( difference <= 15 )
boost = 1;
level.arcadeMode_ramping_score += boost;
if ( level.arcadeMode_ramping_score > score )
level.arcadeMode_ramping_score = score;
hud_draw_score( int( level.arcadeMode_ramping_score ) );
}
get_digits_from_score( score )
{
digits = [];
score = int( score );
for ( ;; )
{
digits[ digits.size ] = score % 10;
score = int( score * 0.1 );
if ( score <= 0 )
break;
}
return digits;
}
hud_draw_score( score )
{
hud_draw_score_for_elements( score, level.arcademode_hud_scores );
}
hud_draw_score_for_elements( score, elements )
{
digits = get_digits_from_score( score );
for ( i = 0; i < digits.size; i++ )
{
if ( i >= elements.size - 1 )
break;
elements[ i ] setvalue( digits[ i ] );
elements[ i ].alpha = 1;
}
for ( i = digits.size; i < elements.size ; i++ )
{
elements[ i ].alpha = 0;
}
if ( score == 0 )
{
elements[ 0 ].alpha = 1;
elements[ 0 ] setvalue( 0 );
}
}
arcademode_add_life( num, x, y, offset, scale, sort )
{
hud_score = newHudElem();
hud_score.foreground = true;
hud_score.x = x + num * offset;
hud_score.y = y;
hud_score setshader( "stance_stand", scale, scale );
hud_score.alignX = "right";
hud_score.alignY = "top";
hud_score.horzAlign = "right";
hud_score.vertAlign = "top";
hud_score.sort = sort;
hud_score.color = level.color_cool_green;
hud_score.glowColor = level.color_cool_green_glow;
hud_score.glowAlpha = 0;
hud_score.alpha = 0;
hud_score.hidewheninmenu = true;
level.arcadeMode_lives_hud[ level.arcadeMode_lives_hud.size ] = hud_score;
}
arcadeMode_define_damage_multipliers()
{
extra_lives_range[ 0 ] = 40;
extra_lives_range[ 1 ] = 30;
extra_lives_range[ 2 ] = 25;
extra_lives_range[ 3 ] = 20;
level.arcademode_kills_until_next_extra_life = 10;
level.arcadeMode_extra_lives_range = extra_lives_range;
extra_lives_base = [];
for ( i = 0; i < 4; i++ )
extra_lives_base[ i ] = extra_lives_range[ i ] * 0.15;
level.arcadeMode_extra_lives_base = extra_lives_base;
}
set_next_extra_life( extra_lives )
{
}
new_ending_hud( align, fade_in_time, x_off, y_off )
{
hud_score = newHudElem();
hud_score.foreground = true;
hud_score.x = x_off;
hud_score.y = y_off;
hud_score.alignX = align;
hud_score.alignY = "middle";
hud_score.horzAlign = align;
hud_score.vertAlign = "middle";
hud_score.fontScale = 3;
if ( getdvar( "widescreen" ) == "1" )
{
hud_score.fontScale = 5;
}
hud_score.color = ( 0.8, 1.0, 0.8 );
hud_score.font = "objective";
hud_score.glowColor = ( 0.3, 0.6, 0.3 );
hud_score.glowAlpha = 1;
hud_score.alpha = 0;
hud_score fadeovertime( fade_in_time );
hud_score.alpha = 1;
hud_score.hidewheninmenu = true;
hud_score.sort = level.arcadeMode_hud_sort + 10;
return hud_score;
}
extra_lives_display( num )
{
for ( i = 0; i < 5; i++ )
{
thread extra_lives_sizzle();
}
extra_lives = new_ending_hud( "center", 0.2, 0, -100 );
extra_lives.label = ( &"SCRIPT_EXTRA_LIFE" );
extra_lives setvalue( num );
extra_lives SetPulseFX( 5, 3000, 1000 );
wait( 5 );
extra_lives destroy();
}
fade_out( timer )
{
self fadeovertime( timer );
self.alpha = 0;
wait( timer );
self destroy();
}
extra_lives_sizzle()
{
extra_lives = new_ending_hud( "center", 0.2, 0, -100 );
extra_lives.alpha = randomfloatrange( 0.1, 0.45 );
extra_lives.sort -= 1;
extra_lives settext( &"SCRIPT_EXTRA_LIFE" );
extra_lives delaythread( 3, ::fade_out, 1 );
extra_lives endon( "death" );
x = extra_lives.x;
y = extra_lives.y;
range = 20;
for ( ;; )
{
timer = randomfloatrange( 0.1, 0.2 );
extra_lives moveovertime( timer );
extra_lives.x = x + randomfloatrange( range * - 1, range );
extra_lives.y = y + randomfloatrange( range * - 1, range );
wait( timer );
}
}
round_up_to_five( score )
{
new_score = score - score % 5;
if ( new_score < score )
new_score += 5;
return new_score;
}
arcadeMode_add_points( origin, kill, type, value )
{
if ( value <= 0 )
return;
if ( isdefined( level.arcadeMode_deathtypes[ type ] ) )
type = level.arcadeMode_deathtypes[ type ];
value = int( value );
value = round_up_to_five( value );
value *= level.arcadeMode_kill_streak_current_multiplier;
score = getdvarint( "arcademode_score" );
score += value;
combined_score = getdvarint( "arcademode_combined_score" );
combined_score += value;
setdvar( "arcademode_combined_score", combined_score );
setdvar( "arcademode_score", score );
timer = 3 * 20;
alpha = 1.5;
scale = 0.9 + ( value - 10 ) * 0.01;
if ( scale > 1.4 )
scale = 1.4;
color = ( 0.75, 0, 0 );
if ( kill )
{
thread arcademode_add_kill_streak();
thread arcademode_add_point_towards_extra_life();
color = level.arcadeMode_killColors[ type ];
}
level.player pointPulse( value );
}
arcademode_add_point_towards_extra_life()
{
level.arcademode_kills_until_next_extra_life -= 1;
if ( level.arcademode_kills_until_next_extra_life > 0 )
return;
level.arcademode_rewarded_lives++ ;
lives = getdvarint( "arcademode_lives" );
lives++ ;
if ( lives >= level.arcadeMode_maxlives )
{
lives = level.arcadeMode_maxlives;
}
else
{
setdvar( "arcademode_lives", lives );
setdvar( "arcademode_lives_changed", 1 );
}
level.arcademode_kills_until_next_extra_life = level.arcadeMode_extra_lives_range[ level.gameskill ];
}
arcademode_set_origin_in_radius()
{
r = 60;
theta = 90;
if ( level.player.pointPulseIndex > 0 )
{
if ( level.player.pointPulseIndex == 1 )
{
side = randomint( 1 );
level.player.thirdPointPulseSide = 1 - side;
if ( side )
theta = 45;
else
theta = 135;
}
else if ( level.player.pointPulseIndex == 2 )
{
side = level.player.thirdPointPulseSide;
if ( side )
theta = 45;
else
theta = 135;
}
else if ( level.player.pointPulseIndex <= 4 )
{
theta = randomfloatrange( 0, 180 );
r = randomfloatrange( 60, 120 );
}
else if ( level.player.pointPulseIndex <= 8 )
{
theta = randomfloatrange( 0, 180 );
r = randomfloatrange( 60, 160 );
}
else
{
theta = randomfloatrange( -30, 180 + 30 );
r = randomfloatrange( 60, 200 );
}
}
self.x = r * cos( theta );
self.y = 0 - r * sin( theta );
}
pointPulse( amount )
{
if ( amount == 0 )
return;
if ( !isdefined( level.player.pointPulseCount ) )
{
level.player.pointPulseCount = 0;
level.player.pointPulseIndex = 0;
}
hud_pointpulse = newHudElem();
hud_pointpulse.horzAlign = "center";
hud_pointpulse.vertAlign = "middle";
hud_pointpulse.alignX = "center";
hud_pointpulse.alignY = "middle";
hud_pointpulse arcademode_set_origin_in_radius();
hud_pointpulse.font = "objective";
hud_pointpulse.fontscale = 2.5;
hud_pointpulse.archived = false;
hud_pointpulse.color = ( 0.5, 0.5, 0.5 );
hud_pointpulse.sort = 4;
arcadeMode_kill_streak_current_multiplier = level.arcadeMode_kill_streak_current_multiplier;
level.player.pointPulseCount++ ;
level.player.pointPulseIndex++ ;
wait( 0.05 );
if ( amount <= 0 )
{
hud_pointpulse.label = &"";
hud_pointpulse.color = ( 1, 0, 0 );
hud_pointpulse.glowColor = ( 0, 0, 0 );
hud_pointpulse.glowAlpha = 0;
}
else
{
hud_pointpulse.label = &"SCRIPT_PLUS";
hud_pointpulse.color = ( 1, 1, 1 );
hud_pointpulse.glowColor = level.color_cool_green_glow;
hud_pointpulse.glowAlpha = 1;
}
hud_pointpulse setvalue( amount );
hud_pointpulse.alpha = 1;
hud_pointpulse ChangeFontScaleOverTime( 0.15 );
hud_pointpulse.fontScale = 3.5;
wait .15;
hud_pointpulse moveOverTime( .25 + .5 + 1.0 );
hud_pointpulse.y -= 40;
hud_pointpulse ChangeFontScaleOverTime( 0.25 );
hud_pointpulse.fontScale = 2.5;
wait .25;
wait .5;
hud_pointpulse fadeOverTime( 1.0 );
hud_pointpulse.alpha = 0;
wait .5;
level.player.pointPulseCount -- ;
if ( level.player.pointPulseCount == 0 )
level.player.pointPulseIndex = 0;
hud_pointpulse destroy();
}
set_circular_origin()
{
base = 50;
for ( ;; )
{
x = randomint( base );
y = randomint( base );
if ( distance( ( 0, 0, 0 ), ( x, y, 0 ) ) < base )
break;
}
if ( cointoss() )
x *= -1;
if ( cointoss() )
y *= -1;
self.x = x;
self.y = y;
}
arcadeMode_add_points_for_mod( mod )
{
for ( i = 0; i < level.arcadeMode_multiKills[ mod ].size; i++ )
{
arcadeMode_add_points_for_individual_kill( level.arcadeMode_multiKills[ mod ][ i ], mod, level.arcadeMode_multiKills[ mod ].size );
}
}
arcadeMode_add_points_for_individual_kill( mod_array, mod, kills )
{
if ( mod_array[ "type" ] != "melee" )
base_points = level.arcadeMode_killBase + level.arcadeMode_locationKillBonus[ mod_array[ "damage_location" ] ] + level.arcadeMode_weaponBonus[ mod_array[ "type" ] ];
else
base_points = level.arcadeMode_killBase + level.arcadeMode_weaponBonus[ mod_array[ "type" ] ];
thread arcadeMode_add_points( mod_array[ "origin" ], true, mod, base_points );
}
player_kill( type, location, point )
{
if ( !isdefined( location ) )
location = "none";
death_type = level.arcadeMode_deathtypes[ type ];
if ( !isdefined( death_type ) )
{
base_points = level.arcadeMode_killBase;
thread arcadeMode_add_points( point, true, "melee", base_points );
return;
}
array[ "damage_location" ] = location;
array[ "type" ] = death_type;
array[ "origin" ] = point;
if ( death_type == "explosive" )
array[ "origin" ] = self.origin;
level.arcadeMode_multiKills[ death_type ][ level.arcadeMode_multiKills[ death_type ].size ] = array;
}
player_damage( type, location, point )
{
thread arcadeMode_add_points( point, false, type, level.arcadeMode_damageBase );
}
player_damage_ads( type, location, point )
{
thread arcadeMode_add_points( point, false, type, level.arcadeMode_damageBase * 1.25 );
}
end_mission()
{
setsaveddvar( "ui_nextMission", "0" );
for ( i = 0; i < level.players.size; i++ )
{
player = level.players[ i ];
player.maxhealth = 0;
player.health = 1;
}
missionsuccess( "killhouse" );
}
create_total_score_hud( offset, totalScoreYpos )
{
level.arcademode_hud_total_scores = [];
for ( i = 0; i < level.arcademode_hud_digits; i++ )
{
hud_score = get_hud_score();
level.arcademode_hud_total_scores[ level.arcademode_hud_total_scores.size ] = hud_score;
hud_score.x = i * - 30 + -150 + offset;
hud_score.y = totalScoreYpos;
hud_score.alignX = "right";
hud_score.alignY = "middle";
hud_score.horzAlign = "right";
hud_score.vertAlign = "middle";
hud_score.alpha = 0;
hud_score.sort = level.arcadeMode_hud_sort + 10;
}
}
set_total_score_hud( score )
{
hud_draw_score_for_elements( score, level.arcademode_hud_total_scores );
}
arcadeMode_ends()
{
if ( flag( "arcademode_complete" ) )
return;
flag_set( "arcademode_complete" );
slowmo_setlerptime_out( .05 );
slowmo_lerp_out();
slowmo_end();
if ( level.arcadeMode_success )
{
if ( arcademode_convert_extra_lives() )
wait( 2 );
}
stop_time = 0;
if ( isdefined( level.arcademode_stoptime ) )
{
stop_time = gettime() - level.arcademode_stoptime;
stop_time *= 0.001;
}
time_elapsed = gettime() - level.arcdeMode_startTime;
time_elapsed *= 0.001;
time_elapsed -= stop_time;
timer = level.arcademode_time - time_elapsed;
timer = int( timer );
if ( timer == 0 )
timer++ ;
assertex( timer >= 0, "Finished a level in arcademode with no time remaining" );
fade_time = 0.5;
level.mission_failed_disabled = true;
thread player_invul_forever();
thread black_background( fade_time );
wait( fade_time + 0.25 );
level.player freezeControls( true );
fade_in_time = 1;
endReasonYpos = -140;
totalScoreYpos = -80;
missionScoreYpos = -20;
timerYpos = 40;
scoreBoostYpos = 100;
livesYpos = 300;
hud_end_reason = new_ending_hud( "center", fade_in_time, 0, endReasonYpos );
if ( level.arcadeMode_success )
{
hud_end_reason.color = ( 1.0, 1.0, 1.0 );
hud_end_reason settext( &"SCRIPT_MISSION_COMPLETE" );
}
else
{
hud_end_reason.color = ( 1.0, 0.4, 0.2 );
hud_end_reason.glowColor = ( 0.75, 0.3, 0.3 );
hud_end_reason settext( level.arcadeMode_failureString );
}
wait 1.0;
for ( i = 0; i < level.arcadeMode_maxlives; i++ )
{
level.arcadeMode_lives_hud[ i ] destroy();
}
offset = 130;
level.arcadeMode_lives_hud = [];
for ( i = 0; i < level.arcadeMode_maxlives; i++ )
{
arcademode_add_life( i, -135 + offset, livesYpos, -30, 96, level.arcadeMode_hud_sort + 10 );
}
lives = getdvarint( "arcademode_lives" );
rewarded_lives = level.arcademode_rewarded_lives;
if ( lives > rewarded_lives )
lives = rewarded_lives;
arcademode_redraw_lives( lives );
combined_score = 0;
hud_total_score = undefined;
if ( getdvar( "arcademode_full" ) == "1" )
{
hud_total_score = new_ending_hud( "left", fade_in_time, 20, totalScoreYpos );
hud_total_score settext( &"SCRIPT_TOTAL_SCORE" );
create_total_score_hud( offset, totalScoreYpos );
combined_score = getdvarint( "arcademode_combined_score" );
set_total_score_hud( combined_score );
}
hud_mission_score = new_ending_hud( "left", fade_in_time, 20, missionScoreYpos );
hud_mission_score settext( &"SCRIPT_MISSION_SCORE" );
for ( i = 0; i < level.arcademode_hud_digits; i++ )
{
hud_score = level.arcademode_hud_scores[ i ];
hud_score.x = i * - 30 + -150 + offset;
hud_score.y = missionScoreYpos;
hud_score.sort = level.arcadeMode_hud_sort + 10;
hud_score.alignX = "right";
hud_score.alignY = "middle";
hud_score.horzAlign = "right";
hud_score.vertAlign = "middle";
}
hud_draw_score( 0 );
minutes = 0;
seconds = 0;
while ( timer >= 60 )
{
minutes++ ;
timer -= 60;
}
seconds = timer;
hud_time_remaining = new_ending_hud( "left", fade_in_time, 20, timerYpos );
hud_time_remaining settext( &"SCRIPT_TIME_REMAINING" );
level.arcademode_hud_timer_minutes_tens = new_ending_hud( "right", fade_in_time, -265 + offset, timerYpos );
level.arcademode_hud_timer_minutes_ones = new_ending_hud( "right", fade_in_time, -235 + offset, timerYpos );
hud_timer_colon = new_ending_hud( "right", fade_in_time, -215 + offset, timerYpos - 5 );
hud_timer_colon settext( &"SCRIPT_COLON" );
level.arcademode_hud_timer_seconds_tens = new_ending_hud( "right", fade_in_time, -180 + offset, timerYpos );
level.arcademode_hud_timer_seconds_ones = new_ending_hud( "right", fade_in_time, -150 + offset, timerYpos );
ending_set_time( minutes, seconds );
wait( fade_in_time );
wait( 1 );
final_score = getdvarint( "arcadeMode_score" );
score = 0;
base_score = combined_score;
soundCount = 0;
for ( ;; )
{
difference = final_score - score;
boost = difference * 0.2 + 1;
if ( difference <= 15 )
boost = 1;
boost = int( boost );
score += boost;
if ( score > final_score )
score = final_score;
hud_draw_score( score );
if ( score == final_score )
break;
soundCount -- ;
if ( soundCount <= 0 )
{
level.player thread play_sound_in_space( "bullet_ap_dirt", level.player geteye() );
soundCount = 3;
}
wait( 0.05 );
}
wait( 1 );
break_timer = false;
hud_zero_deaths = undefined;
if ( level.arcadeMode_success )
{
points_per_second = 5;
total_seconds = minutes * 60 + seconds;
time_bonus_iterations = ceil( total_seconds / 15 );
base_time_bonus = ceil( total_seconds * points_per_second );
final_time_bonus = ceil( base_time_bonus / level.arcademode_difficultyTimerScale );
start_score = score;
finish_score = score + final_time_bonus;
start_combined_score = combined_score;
finish_combined_score = combined_score + final_time_bonus;
for ( i = 1; i <= time_bonus_iterations; i++ )
{
bonus_fraction = ( i * 1.0 / time_bonus_iterations );
if ( i == time_bonus_iterations )
bonus_fraction = 1;
score = int( start_score * ( 1 - bonus_fraction ) + finish_score * bonus_fraction );
if ( getdvar( "arcademode_full" ) == "1" )
{
combined_score = int( start_combined_score * ( 1 - bonus_fraction ) + finish_combined_score * bonus_fraction );
set_total_score_hud( combined_score );
}
hud_draw_score( score );
remaining_seconds = int( total_seconds * ( 1 - bonus_fraction ) );
ending_set_time( floor( remaining_seconds / 60 ), remaining_seconds % 60 );
soundCount -- ;
if ( soundCount <= 0 )
{
level.player thread play_sound_in_space( "bullet_ap_metal", level.player geteye() );
soundCount = 3;
}
wait( 0.05 );
}
ending_set_time( 0, 0 );
wait( 1 );
for ( ;; )
{
mult = 1;
if ( lives > 10 )
{
remainder = lives % 10;
if ( lives - remainder >= 10 )
{
mult = 10;
}
else
{
mult = remainder;
}
if ( lives < 20 )
mult = remainder;
}
lives -= mult;
if ( lives < 0 )
break;
life_bonus = 1000;
life_bonus *= mult;
boost = int( life_bonus );
if ( getdvar( "arcademode_full" ) == "1" )
{
combined_score += boost;
set_total_score_hud( combined_score );
}
score += boost;
level.player thread play_sound_in_space( "mortar_explosion", level.player geteye() );
hud_draw_score( int( score ) );
arcademode_redraw_lives( lives );
wait( 0.6 );
}
wait( 1 );
if ( getdvarint( "arcademode_died" ) != 1 && level.gameskill >= 2 )
{
boost = int( score );
arcademode_end_boost( score, combined_score, boost, &"SCRIPT_ZERO_DEATHS", "bullet_ap_bark", scoreBoostYpos, fade_in_time );
score += boost;
combined_score += boost;
}
}
else
{
level.arcademode_hud_timer_seconds_ones SetPulseFX( 0, 0, 1000 );
level.arcademode_hud_timer_seconds_tens SetPulseFX( 0, 0, 1000 );
level.arcademode_hud_timer_minutes_ones SetPulseFX( 0, 0, 1000 );
level.arcademode_hud_timer_minutes_tens SetPulseFX( 0, 0, 1000 );
hud_timer_colon SetPulseFX( 0, 0, 1000 );
hud_time_remaining SetPulseFX( 0, 0, 1000 );
arcademode_redraw_lives( 0 );
wait( 2 );
}
skillmult = level.arcadeMode_skillMultiplier[ level.gameskill ];
if ( skillmult > 1 )
{
if ( skillmult == 1.5 )
{
string = &"SCRIPT_DIFFICULTY_BONUS_ONEANDAHALF";
}
else if ( skillmult == 3 )
{
string = &"SCRIPT_DIFFICULTY_BONUS_THREE";
}
else
{
assert( skillmult == 4 );
string = &"SCRIPT_DIFFICULTY_BONUS_FOUR";
}
boost = int( ceil( score * skillmult ) - score );
arcademode_end_boost( score, combined_score, boost, string, "bullet_ap_glass", scoreBoostYpos, fade_in_time );
score += boost;
combined_score += boost;
}
gotNewHighScore = false;
if ( getdvar( "arcademode_full" ) == "1" )
{
dvar = "s18";
oldVal = getdvarint( dvar );
if ( combined_score > oldVal )
{
digits = get_digits_from_score( combined_score );
score_string = get_score_string_from_digits( digits );
setdvar( dvar, score_string );
finished = false;
if ( !level.arcadeMode_success )
finished = true;
if ( level.script == "airplane" )
finished = true;
if ( finished )
gotNewHighScore = true;
}
level.player UploadScore( "LB_FULL", getdvarint( dvar ) );
}
else
{
levelScoreIndices = [];
}
if ( gotNewHighScore )
{
if ( !level.arcadeMode_success )
UpdateGamerProfile();
wait( 1 );
hud_newhighscore = new_ending_hud( "center", fade_in_time, 0, scoreBoostYPos );
hud_newhighscore settext( &"SCRIPT_NEW_HIGH_SCORE" );
hud_newhighscore.alpha = 1;
hud_newhighscore fadeovertime( 0.05 );
hud_newhighscore SetPulseFX( 30, 3000, 1000 );
wait( 3.5 );
}
wait( 2 );
hud_end_reason SetPulseFX( 0, 0, 1000 );
wait( 0.5 );
hud_mission_score SetPulseFX( 0, 0, 1000 );
for ( i = 0; i < level.arcademode_hud_digits; i++ )
{
hud_score = level.arcademode_hud_scores[ i ];
hud_score SetPulseFX( 0, 0, 1000 );
}
if ( getdvar( "arcademode_full" ) == "1" )
{
hud_total_score SetPulseFX( 0, 0, 1000 );
for ( i = 0; i < level.arcademode_hud_digits; i++ )
{
hud_score = level.arcademode_hud_total_scores[ i ];
hud_score SetPulseFX( 0, 0, 1000 );
}
}
if ( level.arcadeMode_success )
{
wait( 0.5 );
level.arcademode_hud_timer_seconds_ones SetPulseFX( 0, 0, 1000 );
level.arcademode_hud_timer_seconds_tens SetPulseFX( 0, 0, 1000 );
level.arcademode_hud_timer_minutes_ones SetPulseFX( 0, 0, 1000 );
level.arcademode_hud_timer_minutes_tens SetPulseFX( 0, 0, 1000 );
hud_timer_colon SetPulseFX( 0, 0, 1000 );
hud_time_remaining SetPulseFX( 0, 0, 1000 );
}
wait( 1 );
if ( getdvar( "arcademode_full" ) == "1" )
{
logString( "ArcadeMode Score: " + score + ", mission: " + level.script + ", gameskill: " + level.gameskill + ", total: " + combined_score );
}
else
{
logString( "ArcadeMode Score: " + score + ", mission: " + level.script + ", gameskill: " + level.gameskill );
}
setdvar( "arcademode_combined_score", combined_score );
if ( !level.arcadeMode_success )
{
setdvar( "ui_arcade_lost", 1 );
end_mission();
}
else
setdvar( "ui_arcade_lost", 0 );
flag_set( "arcademode_ending_complete" );
}
arcademode_end_boost( score, combined_score, boost, string, sound, ypos, fade_in_time )
{
hud_boost = new_ending_hud( "center", fade_in_time, 0, ypos );
hud_boost settext( string );
hud_boost.alpha = 1;
hud_boost fadeovertime( 0.05 );
wait( 0.05 );
wait 1.0;
soundCount = 0;
final_score = score + boost;
final_combined_score = combined_score + boost;
for ( ;; )
{
difference = final_score - score;
boost = difference * 0.2 + 1;
if ( difference <= 15 )
boost = 1;
boost = int( boost );
score += boost;
if ( score > final_score )
score = final_score;
hud_draw_score( score );
if ( getdvar( "arcademode_full" ) == "1" )
{
combined_score += boost;
if ( combined_score > final_combined_score )
combined_score = final_combined_score;
set_total_score_hud( combined_score );
}
if ( score == final_score )
break;
soundCount -- ;
if ( soundCount <= 0 )
{
level.player thread play_sound_in_space( sound, level.player geteye() );
soundCount = 3;
}
wait( 0.05 );
}
wait 0.5;
hud_boost SetPulseFX( 0, 0, 1000 );
wait 1.0;
}
black_background( fade_time )
{
overlay = newHudElem();
overlay.foreground = true;
overlay.x = 0;
overlay.y = 0;
overlay setshader( "black", 640, 480 );
overlay.alignX = "left";
overlay.alignY = "top";
overlay.horzAlign = "fullscreen";
overlay.vertAlign = "fullscreen";
overlay.sort = level.arcadeMode_hud_sort + 5;
overlay.alpha = 0;
if ( fade_time > 0 )
overlay fadeovertime( fade_time );
overlay.alpha = 1;
}
player_invul_forever()
{
for ( ;; )
{
level.player EnableInvulnerability();
level.player.deathInvulnerableTime = 70000;
level.player.ignoreme = true;
ai = getaispeciesarray( "all", "all" );
array_thread( ai, ::set_ignoreme, true );
wait( 0.05 );
}
}
ending_set_time( minutes, seconds )
{
minutes_tens = 0;
seconds_tens = 0;
while ( minutes >= 10 )
{
minutes_tens++ ;
minutes -= 10;
}
while ( seconds >= 10 )
{
seconds_tens++ ;
seconds -= 10;
}
level.arcademode_hud_timer_seconds_ones setvalue( seconds );
level.arcademode_hud_timer_seconds_tens setvalue( seconds_tens );
level.arcademode_hud_timer_minutes_ones setvalue( minutes );
level.arcademode_hud_timer_minutes_tens setvalue( minutes_tens );
}
draw_checkpoint( start_offset, movetime, mult )
{
start_offset *= mult;
checkpoint = new_ending_hud( "center", 0.1, start_offset, 90 );
checkpoint settext( &"SCRIPT_CHECKPOINT" );
checkpoint MoveOverTime( movetime );
checkpoint.x = 0;
wait( movetime );
wait( 0.5 );
checkpoint MoveOverTime( movetime );
checkpoint.x = start_offset * - 1;
wait( movetime );
checkpoint destroy();
}
arcademode_checkpoint_getid( unique_id )
{
for ( i = 0; i < level.arcadeMode_checkpoint_dvars.size; i++ )
{
if ( level.arcadeMode_checkpoint_dvars[ i ] == unique_id )
return i;
}
return undefined;
}
arcadeMode_init_kill_streak_colors()
{
level.arcadeMode_streak_color = [];
level.arcadeMode_streak_glow = [];
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = level.color_cool_green;
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = ( 0.8, 0.8, 2.0 );
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = ( 2.0, 0.8, 0.0 );
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = ( 0.5, 2.0, 2.0 );
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = ( 2.0, 0.5, 2.0 );
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = ( 0.3, 0.3, 2.0 );
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = ( 2.0, 2.0, 0.5 );
level.arcadeMode_streak_color[ level.arcadeMode_streak_color.size ] = ( 2.0, 2.0, 2.0 );
for ( i = 0; i < level.arcadeMode_streak_color.size; i++ )
{
level.arcadeMode_streak_glow[ i ] = ( level.arcadeMode_streak_color[ i ][ 0 ] * 0.35, level.arcadeMode_streak_color[ i ][ 1 ] * 0.35, level.arcadeMode_streak_color[ i ][ 2 ] * 0.35 );
}
level.arcadeMode_streak_color[ 0 ] = level.color_cool_green_glow;
}
arcadeMode_killstreak_complete_display()
{
if ( level.arcadeMode_kill_streak_current_multiplier == 1 )
return;
if ( flag( "arcademode_complete" ) )
return;
kill_streak = new_ending_hud( "right", 0.2, - 10, -57 );
kill_streak SetPulseFX( 5, 3000, 1000 );
kill_streak.fontScale = 2;
if ( level.arcadeMode_kill_streak_current_multiplier >= 8 )
{
level.player thread play_sound_in_space( "arcademode_kill_streak_won", level.player geteye() );
kill_streak settext( &"SCRIPT_STREAK_COMPLETE" );
}
else
{
level.player thread play_sound_in_space( "arcademode_kill_streak_lost", level.player geteye() );
kill_streak settext( &"SCRIPT_STREAK_BONUS_LOST" );
}
wait( 5 );
kill_streak destroy();
}
arcadeMode_reset_kill_streak_art()
{
if ( isdefined( level.arcadeMode_streak_hud ) )
{
level.arcadeMode_streak_hud destroy();
level.arcadeMode_streak_hud = undefined;
level.arcadeMode_streak_hud_shadow destroy();
}
level notify( "arcademode_stop_kill_streak_art" );
for ( i = 0; i < level.arcadeMode_kills_hud.size; i++ )
{
level.arcadeMode_kills_hud[ i ] destroy();
}
level.arcadeMode_kills_hud = [];
}
arcadeMode_reset_kill_streak()
{
level.arcadeMode_new_kill_streak_allowed = true;
thread arcadeMode_killstreak_complete_display();
level notify( "arcademode_stop_kill_streak" );
arcadeMode_reset_kill_streak_art();
flag_clear( "arcadeMode_multiplier_maxed" );
level.arcadeMode_kill_streak_current_count = level.arcadeMode_kill_streak_multiplier_count;
level.arcadeMode_kill_streak_current_multiplier = 1;
}
get_hud_multi()
{
hud_mult = newHudElem();
hud_mult.alignX = "right";
hud_mult.alignY = "top";
hud_mult.horzAlign = "right";
hud_mult.vertAlign = "top";
hud_mult thread arcademode_draw_multiplier_kill();
hud_mult.x = 0;
hud_mult.y = 126;
hud_mult.font = "objective";
hud_mult.fontscale = 0.1;
hud_mult.archived = false;
hud_mult.foreground = true;
hud_mult.color = level.arcadeMode_streak_color[ level.arcadeMode_kill_streak_current_multiplier - 1 ];
hud_mult.glowColor = level.arcadeMode_streak_glow[ level.arcadeMode_kill_streak_current_multiplier - 1 ];
hud_mult.sort = level.arcadeMode_hud_sort;
hud_mult.label = &"SCRIPT_X";
hud_mult setvalue( level.arcadeMode_kill_streak_current_multiplier );
hud_mult changeFontScaleOverTime( 0.5 );
hud_mult.fontscale = 3;
hud_mult.alpha = 0;
hud_mult fadeovertime( 0.5 );
hud_mult.alpha = 1.0;
return hud_mult;
}
arcademode_draw_multiplier()
{
for ( i = 0; i < 40; i++ )
{
hud_sizzle = get_hud_multi();
hud_sizzle thread arcademode_draw_mult_sizzle();
}
level endon( "arcademode_new_kill_streak" );
hud_mult = get_hud_multi();
level.arcademode_hud_streak = hud_mult;
level waittill( "arcademode_stop_kill_streak" );
hud_mult SetPulseFX( 0, 0, 1000 );
wait( 1 );
hud_mult destroy();
level.arcademode_hud_streak = undefined;
}
arcademode_draw_mult_sizzle()
{
level endon( "arcademode_new_kill_streak" );
wait( 0.05 );
range = 500;
self moveovertime( 2 );
self.x += randomintrange( range * - 1, range );
self.y += randomintrange( range * - 1, range );
wait( 0.5 );
self fadeovertime( 1 );
self.alpha = 0;
wait( 1 );
self destroy();
}
arcademode_draw_multiplier_kill()
{
self endon( "death" );
level waittill( "arcademode_new_kill_streak" );
self destroy();
}
get_score_string_from_digits( digits )
{
msg = "";
for ( i = 0; i < digits.size; i++ )
{
msg = digits[ i ] + msg;
}
return msg;
}