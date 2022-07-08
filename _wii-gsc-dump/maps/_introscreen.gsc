#include common_scripts\utility;
#include maps\_utility;
main()
{
flag_init( "pullup_weapon" );
flag_init( "introscreen_complete" );
flag_init( "safe_for_objectives" );
flag_init( "introscreen_complete" );
delayThread( 10, ::flag_set, "safe_for_objectives" );
level.linefeed_delay = 16;
PreCacheShader( "black" );
PreCacheShader( "white" );
if ( GetDvar( "introscreen" ) == "" )
SetDvar( "introscreen", "1" );
if ( IsDefined( level.credits_active ) )
return;
main_old_maps();
switch ( get_introscreen_levelname() )
{
case "london":
PreCacheString( &"LONDON_INTROSCREEN_LINE_1" );
PreCacheString( &"LONDON_INTROSCREEN_LINE_2" );
PreCacheString( &"LONDON_INTROSCREEN_LINE_3" );
PreCacheString( &"LONDON_INTROSCREEN_LINE_4" );
PreCacheString( &"LONDON_INTROSCREEN_LINE_5" );
introscreen_delay();
break;
case "castle":
PreCacheString( &"CASTLE_INTROSCREEN_LINE_1" );
PreCacheString( &"CASTLE_INTROSCREEN_LINE_2" );
PreCacheString( &"CASTLE_INTROSCREEN_LINE_3" );
PreCacheString( &"CASTLE_INTROSCREEN_LINE_4" );
PreCacheString( &"CASTLE_INTROSCREEN_LINE_5" );
introscreen_delay();
break;
case "prague":
PreCacheString( &"PRAGUE_INTROSCREEN_LINE_1" );
PreCacheString( &"PRAGUE_INTROSCREEN_LINE_2" );
PreCacheString( &"PRAGUE_INTROSCREEN_LINE_3" );
PreCacheString( &"PRAGUE_INTROSCREEN_LINE_4" );
PreCacheString( &"PRAGUE_INTROSCREEN_LINE_5" );
introscreen_delay();
break;
case "prague_escape":
PreCacheString( &"PRAGUE_ESCAPE_INTROSCREEN_LINE_1" );
PreCacheString( &"PRAGUE_ESCAPE_INTROSCREEN_LINE_2" );
PreCacheString( &"PRAGUE_ESCAPE_INTROSCREEN_LINE_3" );
PreCacheString( &"PRAGUE_ESCAPE_INTROSCREEN_LINE_4" );
PreCacheString( &"PRAGUE_ESCAPE_INTROSCREEN_LINE_5" );
introscreen_delay();
break;
case "payback_a":
PreCacheString( &"PAYBACK_INTROSCREEN_LINE_1" );
PreCacheString( &"PAYBACK_INTROSCREEN_LINE_2" );
PreCacheString( &"PAYBACK_INTROSCREEN_LINE_3" );
PreCacheString( &"PAYBACK_INTROSCREEN_LINE_4" );
PreCacheString( &"PAYBACK_INTROSCREEN_LINE_5" );
introscreen_delay();
break;
case "example":
break;
case "hamburg_a":
PreCacheString( &"TANKCOMMANDER_INTROSCREEN_LINE_1" );
PreCacheString( &"TANKCOMMANDER_INTROSCREEN_LINE_2" );
PreCacheString( &"TANKCOMMANDER_INTROSCREEN_LINE_3" );
PreCacheString( &"TANKCOMMANDER_INTROSCREEN_LINE_4" );
introscreen_delay();
break;
case "rescue_2":
PreCacheString( &"RESCUE_2_INTROSCREEN_LINE_1" );
PreCacheString( &"RESCUE_2_INTROSCREEN_LINE_2" );
PreCacheString( &"RESCUE_2_INTROSCREEN_LINE_3" );
PreCacheString( &"RESCUE_2_INTROSCREEN_LINE_4" );
introscreen_delay();
break;
default:
wait 0.05;
level notify( "finished final intro screen fadein" );
wait 0.05;
level notify( "starting final intro screen fadeout" );
wait 0.05;
level notify( "controls_active" );
wait 0.05;
flag_set( "introscreen_complete" );
break;
}
}
introscreen_feed_lines( lines )
{
keys = GetArrayKeys( lines );
for ( i = 0; i < keys.size; i++ )
{
key = keys[ i ];
interval = 1;
time = ( i * interval ) + 1;
delayThread( time, ::introscreen_corner_line, lines[ key ], ( lines.size - i - 1 ), interval, key );
}
}
introscreen_generic_black_fade_in( time, fade_time, fade_in_time )
{
introscreen_generic_fade_in( "black", time, fade_time, fade_in_time );
}
introscreen_generic_white_fade_in( time, fade_time, fade_in_time )
{
introscreen_generic_fade_in( "white", time, fade_time, fade_in_time );
}
introscreen_generic_fade_in( shader, pause_time, fade_out_time, fade_in_time )
{
if ( !isdefined( fade_out_time ) )
fade_out_time = 1.5;
introblack = NewHudElem();
introblack.x = 0;
introblack.y = 0;
introblack.horzAlign = "fullscreen";
introblack.vertAlign = "fullscreen";
introblack.foreground = true;
introblack SetShader( shader, 640, 480 );
if ( IsDefined( fade_in_time ) && fade_in_time > 0 )
{
introblack.alpha = 0;
introblack FadeOverTime( fade_in_time );
introblack.alpha = 1;
wait( fade_in_time );
}
wait pause_time;
if ( fade_out_time > 0 )
introblack FadeOverTime( fade_out_time );
introblack.alpha = 0;
wait fade_out_time;
SetSavedDvar( "com_cinematicEndInWhite", 0 );
}
introscreen_create_line( string )
{
index = level.introstring.size;
yPos = ( index * 30 );
if ( level.console )
yPos -= 60;
level.introstring[ index ] = NewHudElem();
level.introstring[ index ].x = 0;
level.introstring[ index ].y = yPos;
level.introstring[ index ].alignX = "center";
level.introstring[ index ].alignY = "middle";
level.introstring[ index ].horzAlign = "center";
level.introstring[ index ].vertAlign = "middle";
level.introstring[ index ].sort = 1;
level.introstring[ index ].foreground = true;
level.introstring[ index ].fontScale = 1.75;
level.introstring[ index ] SetText( string );
level.introstring[ index ].alpha = 0;
level.introstring[ index ] FadeOverTime( 1.2 );
level.introstring[ index ].alpha = 1;
}
introscreen_fadeOutText()
{
for ( i = 0; i < level.introstring.size; i++ )
{
level.introstring[ i ] FadeOverTime( 1.5 );
level.introstring[ i ].alpha = 0;
}
wait 1.5;
for ( i = 0; i < level.introstring.size; i++ )
level.introstring[ i ] Destroy();
}
introscreen_delay( string1, string2, string3, string4, pausetime1, pausetime2, timebeforefade )
{
waittillframeend;
waittillframeend;
if ( slamzoom_intro() )
{
return;
}
if ( introscreen_old_maps() )
{
return;
}
switch ( get_introscreen_levelname() )
{
case "london":
london_intro();
return;
case "castle":
castle_intro();
return;
case "prague":
prague_intro();
return;
case "prague_escape":
prague_escape_intro();
return;
case "payback_a":
payback_intro();
return;
case "rescue_2":
rescue_2_intro();
return;
case "hamburg_a":
hamburg_intro();
return;
}
level.introblack = NewHudElem();
level.introblack.x = 0;
level.introblack.y = 0;
level.introblack.horzAlign = "fullscreen";
level.introblack.vertAlign = "fullscreen";
level.introblack.foreground = true;
level.introblack SetShader( "black", 640, 480 );
level.player FreezeControls( true );
wait .05;
level.introstring = [];
if ( IsDefined( string1 ) )
introscreen_create_line( string1 );
if ( IsDefined( pausetime1 ) )
{
wait pausetime1;
}
else
{
wait 2;
}
if ( IsDefined( string2 ) )
introscreen_create_line( string2 );
if ( IsDefined( string3 ) )
introscreen_create_line( string3 );
if ( IsDefined( string4 ) )
{
if ( IsDefined( pausetime2 ) )
{
wait pausetime2;
}
else
{
wait 2;
}
}
if ( IsDefined( string4 ) )
introscreen_create_line( string4 );
level notify( "finished final intro screen fadein" );
if ( IsDefined( timebeforefade ) )
{
wait timebeforefade;
}
else
{
wait 3;
}
level.introblack FadeOverTime( 1.5 );
level.introblack.alpha = 0;
level notify( "starting final intro screen fadeout" );
level.player FreezeControls( false );
level notify( "controls_active" );
introscreen_fadeOutText();
flag_set( "introscreen_complete" );
}
_CornerLineThread( string, size, interval, index_key )
{
level notify( "new_introscreen_element" );
if ( !isdefined( level.intro_offset ) )
level.intro_offset = 0;
else
level.intro_offset++;
y = _CornerLineThread_height();
hudelem = NewHudElem();
hudelem.x = 20;
hudelem.y = y;
hudelem.alignX = "left";
hudelem.alignY = "bottom";
hudelem.horzAlign = "left";
hudelem.vertAlign = "bottom";
hudelem.sort = 1;
hudelem.foreground = true;
hudelem SetText( string );
hudelem.alpha = 0;
hudelem FadeOverTime( 0.2 );
hudelem.alpha = 1;
hudelem.hidewheninmenu = true;
hudelem.fontScale = 2.0;
hudelem.color = ( 0.8, 1.0, 0.8 );
hudelem.font = "objective";
hudelem.glowColor = ( 0.3, 0.6, 0.3 );
hudelem.glowAlpha = 1;
duration = Int( ( size * interval * 1000 ) + 4000 );
hudelem SetPulseFX( 30, duration, 700 );
thread hudelem_destroy( hudelem );
if ( !isdefined( index_key ) )
return;
if ( !isstring( index_key ) )
return;
if ( index_key != "date" )
return;
}
_CornerLineThread_height()
{
return( ( ( level.intro_offset ) * 20 ) - 82 );
}
introscreen_corner_line( string, size, interval, index_key )
{
thread _CornerLineThread( string, size, interval, index_key );
}
hudelem_destroy( hudelem )
{
wait( level.linefeed_delay );
hudelem notify( "destroying" );
level.intro_offset = undefined;
time = .5;
hudelem FadeOverTime( time );
hudelem.alpha = 0;
wait time;
hudelem notify( "destroy" );
hudelem Destroy();
}
castle_intro()
{
level.player FreezeControls( true );
SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
thread introscreen_generic_black_fade_in( 6.0 );
lines = [];
lines[ lines.size ] = &"CASTLE_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"CASTLE_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"CASTLE_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"CASTLE_INTROSCREEN_LINE_4";
lines[ lines.size ] = &"CASTLE_INTROSCREEN_LINE_5";
introscreen_feed_lines( lines );
wait( 6.0 );
flag_set( "introscreen_complete" );
level.player FreezeControls( false );
}
london_intro()
{
level.player FreezeControls( true );
SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
thread introscreen_generic_black_fade_in( 5.0 );
lines = [];
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_4";
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_5";
introscreen_feed_lines( lines );
wait( 5.0 );
flag_set( "introscreen_complete" );
level.player FreezeControls( false );
}
hamburg_intro()
{
SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
thread introscreen_generic_black_fade_in( 3.5 );
lines = [];
lines[ lines.size ] = &"TANKCOMMANDER_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"TANKCOMMANDER_INTROSCREEN_LINE_15";
lines[ lines.size ] = &"TANKCOMMANDER_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"TANKCOMMANDER_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"TANKCOMMANDER_INTROSCREEN_LINE_4";
introscreen_feed_lines( lines );
wait( 3.0 );
flag_set( "introscreen_complete" );
}
prague_intro()
{
level.player FreezeControls( true );
flag_wait( "fade_up" );
thread introscreen_generic_black_fade_in( 4, 5 );
lines = [];
lines[ lines.size ] = &"PRAGUE_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"PRAGUE_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"PRAGUE_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"PRAGUE_INTROSCREEN_LINE_4";
lines[ lines.size ] = &"PRAGUE_INTROSCREEN_LINE_5";
level.player delayCall( 4.0, ::FreezeControls, false );
flag_wait( "city_reveal" );
delayThread( 9.25 , ::introscreen_feed_lines, lines );
}
prague_escape_intro()
{
level.player FreezeControls( true );
thread introscreen_generic_black_fade_in( 8.0, .5 );
lines = [];
lines[ lines.size ] = &"PRAGUE_ESCAPE_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"PRAGUE_ESCAPE_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"PRAGUE_ESCAPE_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"PRAGUE_ESCAPE_INTROSCREEN_LINE_4";
lines[ lines.size ] = &"PRAGUE_ESCAPE_INTROSCREEN_LINE_5";
introscreen_feed_lines( lines );
wait( 8 );
flag_set( "introscreen_complete" );
level.player FreezeControls( false );
}
payback_intro()
{
level.player FreezeControls( true );
SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
level notify("introscreen_prime_audio");
level notify("introscreen_fade_start");
wait( 2.0 );
level.player FreezeControls( false );
hours = 9;
minutes = 30;
seconds = 10;
level.HudTimeStamp = ( hours * 60 * 60 ) + ( minutes * 60 ) + seconds;
level.HudTimeStampStartTime = GetTime();
lines = [];
lines[ lines.size ] = &"PAYBACK_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"PAYBACK_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"PAYBACK_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"PAYBACK_INTROSCREEN_LINE_4";
lines[ lines.size ] = &"PAYBACK_INTROSCREEN_LINE_5";
introscreen_feed_lines( lines );
wait( 2.0 );
}
feedline_delay()
{
wait( 2 );
}
slamzoom_intro()
{
flying_levels = [];
flying_levels[ "killhouse" ] = true;
flying_levels[ "cliffhanger" ] = true;
flying_levels[ "estate" ] = true;
flying_levels[ "boneyard" ] = true;
if ( !getdvarint( "newintro" ) )
flying_levels[ "roadkill" ] = true;
override_angles = IsDefined( level.customIntroAngles );
if ( !isdefined( flying_levels[ get_introscreen_levelname() ] ) )
return false;
if ( !isdefined( level.dontReviveHud ) )
thread revive_ammo_counter();
thread hide_hud();
thread weapon_pullout();
level.player FreezeControls( true );
feedline_delay_func = ::feedline_delay;
zoomHeight = 16000;
slamzoom = true;
extra_delay = 0;
special_save = false;
if ( slamzoom )
{
lines = [];
switch( get_introscreen_levelname() )
{
case "london":
CinematicInGameSync( "estate_fade" );
lines = [];
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"LONDON_INTROSCREEN_LINE_4";
zoomHeight = 4000;
SetSavedDvar( "sm_sunSampleSizeNear", 0.6 );
delayThread( 0.5, ::ramp_out_sunsample_over_time, 0.9 );
break;
}
add_func( feedline_delay_func );
add_func( ::introscreen_feed_lines, lines );
thread do_funcs();
}
origin = level.player.origin;
level.player PlayerSetStreamOrigin( origin );
level.player.origin = origin + ( 0, 0, zoomHeight );
ent = Spawn( "script_model", ( 69, 69, 69 ) );
ent.origin = level.player.origin;
ent SetModel( "tag_origin" );
if ( override_angles )
{
ent.angles = ( 0, level.customIntroAngles[ 1 ], 0 );
}
else
{
ent.angles = level.player.angles;
}
level.player PlayerLinkTo( ent, undefined, 1, 0, 0, 0, 0 );
ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 );
wait( extra_delay );
ent MoveTo( origin + ( 0, 0, 0 ), 2, 0, 2 );
wait( 1.00 );
wait( 0.5 );
if ( override_angles )
{
ent RotateTo( level.customIntroAngles, 0.5, 0.3, 0.2 );
}
else
{
ent RotateTo( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), 0.5, 0.3, 0.2 );
}
if ( !special_save )
SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
wait( 0.5 );
flag_set( "pullup_weapon" );
wait( 0.2 );
level.player Unlink();
level.player FreezeControls( false );
level.player PlayerClearStreamOrigin();
thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
wait( 0.2 );
thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );
wait( 0.2 );
flag_set( "introscreen_complete" );
wait( 2 );
ent Delete();
return true;
}
hide_hud()
{
wait( 0.05 );
SetSavedDvar( "compass", 0 );
SetSavedDvar( "ammoCounterHide", "1" );
SetSavedDvar( "hud_showstance", "0" );
SetSavedDvar( "actionSlotsHide", "1" );
}
weapon_pullout()
{
weap = level.player GetWeaponsListAll()[ 0 ];
level.player DisableWeapons();
flag_wait( "pullup_weapon" );
level.player EnableWeapons();
}
revive_ammo_counter()
{
flag_wait( "safe_for_objectives" );
if ( !isdefined( level.nocompass ) )
SetSavedDvar( "compass", 1 );
SetSavedDvar( "ammoCounterHide", "0" );
SetSavedDvar( "actionSlotsHide", "0" );
SetSavedDvar( "hud_showstance", "1" );
}
ramp_out_sunsample_over_time( time, base_sample_size )
{
sample_size = GetDvarFloat( "sm_sunSampleSizeNear" );
if ( !isdefined( base_sample_size ) )
base_sample_size = 0.25;
range = sample_size - base_sample_size;
frames = time * 20;
for ( i = 0; i <= frames; i++ )
{
dif = i / frames;
dif = 1 - dif;
current_range = dif * range;
current_sample_size = base_sample_size + current_range;
SetSavedDvar( "sm_sunSampleSizeNear", current_sample_size );
wait( 0.05 );
}
}
get_introscreen_levelname()
{
if ( IsDefined( level.introscreen_levelname ) )
{
return level.introscreen_levelname;
}
return level.script;
}
main_old_maps()
{
switch( get_introscreen_levelname() )
{
case "dcburning":
PreCacheString( &"DCBURNING_INTROSCREEN_1" );
PreCacheString( &"DCBURNING_INTROSCREEN_2" );
PreCacheString( &"DCBURNING_INTROSCREEN_3" );
PreCacheString( &"DCBURNING_INTROSCREEN_4" );
PreCacheString( &"DCBURNING_INTROSCREEN_5" );
introscreen_delay();
break;
}
}
cliffhanger_intro_text()
{
wait 17;
lines = [];
lines[ lines.size ] = &"CLIFFHANGER_LINE1";
lines[ "date" ] = &"CLIFFHANGER_LINE2";
lines[ lines.size ] = &"CLIFFHANGER_LINE3";
lines[ lines.size ] = &"CLIFFHANGER_LINE4";
lines[ lines.size ] = &"CLIFFHANGER_LINE5";
maps\_introscreen::introscreen_feed_lines( lines );
}
dcburning_intro()
{
level.player DisableWeapons();
thread dcburningIntroDvars();
level.mortar_min_dist = 1;
level.player FreezeControls( true );
introblack = NewHudElem();
introblack.x = 0;
introblack.y = 0;
introblack.horzAlign = "fullscreen";
introblack.vertAlign = "fullscreen";
introblack.foreground = true;
introblack SetShader( "black", 640, 480 );
wait 4.25;
wait 3;
level notify( "black_fading" );
level.mortar_min_dist = undefined;
introblack FadeOverTime( 1.5 );
introblack.alpha = 0;
wait( 1.5 );
flag_set( "introscreen_complete" );
level notify( "introscreen_complete" );
level.player FreezeControls( false );
level.player EnableWeapons();
wait( .5 );
SetSavedDvar( "compass", 1 );
SetSavedDvar( "ammoCounterHide", "0" );
SetSavedDvar( "hud_showStance", 1 );
flag_wait( "player_exiting_start_trench" );
lines = [];
lines[ lines.size ] = &"DCBURNING_INTROSCREEN_1";
lines[ lines.size ] = &"DCBURNING_INTROSCREEN_2";
lines[ lines.size ] = &"DCBURNING_INTROSCREEN_3";
lines[ lines.size ] = &"DCBURNING_INTROSCREEN_4";
lines[ lines.size ] = &"DCBURNING_INTROSCREEN_5";
introscreen_feed_lines( lines );
}
dcburningIntroDvars()
{
wait( 0.05 );
SetSavedDvar( "compass", 0 );
SetSavedDvar( "ammoCounterHide", "1" );
SetSavedDvar( "hud_showStance", 0 );
}
rescue_2_intro()
{
lines = [];
thread introscreen_generic_black_fade_in( 5.4, 8 );
lines[ lines.size ] = &"RESCUE_2_INTROSCREEN_LINE_1";
lines[ lines.size ] = &"RESCUE_2_INTROSCREEN_LINE_2";
lines[ lines.size ] = &"RESCUE_2_INTROSCREEN_LINE_3";
lines[ lines.size ] = &"RESCUE_2_INTROSCREEN_LINE_4";
lines[ lines.size ] = &"RESCUE_2_INTROSCREEN_LINE_5";
introscreen_feed_lines( lines );
}
introscreen_old_maps()
{
switch ( get_introscreen_levelname() )
{
case "dcburning":
dcburning_intro();
return true;
}
return false;
}
