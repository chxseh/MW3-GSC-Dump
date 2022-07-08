#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_hud_util;
main()
{
flag_init( "coop_game" );
assertex( is_coop(), "_coop::main() called when not in coop." );
if ( !is_coop() )
return;
flag_set( "coop_game" );
flag_init( "coop_show_constant_icon" );
setDvarIfUninitialized( "coop_show_constant_icon", 1 );
if ( GetDvarInt( "coop_show_constant_icon" ) == 1 )
{
flag_set( "coop_show_constant_icon" );
}
precacheShader( "hint_health" );
precacheShader( "coop_player_location" );
precacheShader( "coop_player_location_fire" );
level.coop_icon_blinktime = 7;
level.coop_icon_blinkcrement = 0.375;
level.coop_revive_nag_hud_refreshtime = 20;
foreach( player in level.players )
{
player.colorBlind = player GetLocalPlayerProfileData( "colorBlind" );
player thread initialize_colors( player.colorBlind );
player thread friendly_hud_init();
}
}
initialize_colors( color_blind_mode )
{
if ( color_blind_mode )
{
cyan	= ( .35, 1, 1 );
orange	= ( 1, .65, 0.2 );
white	= ( 1, 1, 1 );
self.coop_icon_color_normal = cyan;
self.coop_icon_color_downed = orange;
self.coop_icon_color_shoot = cyan;
self.coop_icon_color_damage = white;
self.coop_icon_color_dying = orange;
self.coop_icon_color_blink = white;
}
else
{
green	= ( 0.635, 0.929, 0.604 );
yellow	= ( 1, 1, 0.2 );
orange	= ( 1, .65, 0.2 );
red = ( 1, 0.2, 0.2 );
white	= ( 1, 1, 1 );
self.coop_icon_color_normal = green;
self.coop_icon_color_downed = yellow;
self.coop_icon_color_shoot = green;
self.coop_icon_color_damage = orange;
self.coop_icon_color_dying = red;
self.coop_icon_color_blink = white;
}
}
rebuild_friendly_icon( color, material, rotating )
{
if ( isdefined( self.noFriendlyHudIcon ) )
return;
assertex( isdefined( color ), "rebuild_friendly_icon requires a valid color to be passed in." );
assertex( isdefined( material ), "rebuild_friendly_icon requires a valid material to be passed in.");
if ( !isdefined( self.friendlyIcon ) || ( self.friendlyIcon.material != material ) )
{
self create_fresh_friendly_icon( material );
}
self.friendlyIcon.color = color;
if ( isdefined( rotating ) && rotating )
self.friendlyIcon SetWaypointEdgeStyle_RotatingIcon();
}
create_fresh_friendly_icon( material )
{
if ( isdefined( self.friendlyIcon ) )
self.friendlyIcon Destroy();
self.friendlyIcon = NewClientHudElem( self );
self.friendlyIcon SetShader( material, 1, 1 );
self.friendlyIcon SetWayPoint( true, true, false );
self.friendlyIcon SetWaypointIconOffscreenOnly();
self.friendlyIcon SetTargetEnt( get_other_player( self ) );
self.friendlyIcon.material = material;
self.friendlyIcon.hidewheninmenu = true;
if ( flag( "coop_show_constant_icon" ) )
self.friendlyIcon.alpha = 1.0;
else
self.friendlyIcon.alpha = 0.0;
}
friendly_hud_icon_blink_on_fire()
{
self endon( "death" );
while ( 1 )
{
self waittill( "weapon_fired" );
other_player = get_other_player( self );
other_player thread friendly_hud_icon_flash( other_player.coop_icon_color_shoot, "coop_player_location_fire", true );
}
}
friendly_hud_icon_blink_on_damage()
{
self endon( "death" );
while ( 1 )
{
self waittill( "damage" );
other_player = get_other_player( self );
other_player thread friendly_hud_icon_flash( other_player.coop_icon_color_damage, "coop_player_location", true );
}
}
friendly_hud_icon_flash( color, material, rotate )
{
if ( isdefined( self.noFriendlyHudIcon ) )
return;
self endon( "death" );
self notify( "flash_color_thread" );
self endon( "flash_color_thread" );
other_player = get_other_player( self );
if ( is_player_down( other_player ) )
return;
self rebuild_friendly_icon( color, material, rotate );
wait .5;
material = self FriendlyHudIcon_CurrentMaterial();
rotating = self FriendlyHudIcon_Rotating();
self rebuild_friendly_icon( self.coop_icon_color_normal, material, rotating );
}
friendly_hud_init()
{
level endon( "special_op_terminated" );
assert( isdefined( self ) && isplayer( self ), "Invalid player." );
self FriendlyHudIcon_Normal();
self thread friendly_hud_icon_blink_on_fire();
self thread friendly_hud_icon_blink_on_damage();
self thread monitor_color_blind_toggle();
thread friendly_hud_destroy_on_mission_end();
if ( isdefined( self.noFriendlyHudIcon ) )
return;
self.friendlyIcon.alpha = 0.0;
while ( 1 )
{
flag_wait( "coop_show_constant_icon" );
self.friendlyIcon.alpha = 1.0;
flag_waitopen( "coop_show_constant_icon" );
self.friendlyIcon.alpha = 0.0;
}
}
friendly_hud_destroy_on_mission_end()
{
level waittill( "special_op_terminated" );
foreach ( player in level.players )
{
player player_friendly_hud_destroy();
}
}
player_friendly_hud_destroy()
{
AssertEx( IsDefined( self ) && IsPlayer( self ), "Self not player in destroy friendly hud call." );
if ( IsDefined( self.friendlyIcon ) )
{
self.friendlyIcon Destroy();
}
}
FriendlyHudIcon_HideAll()
{
flag_clear( "coop_show_constant_icon" );
}
FriendlyHudIcon_ShowAll()
{
flag_set( "coop_show_constant_icon" );
}
FriendlyHudIcon_Disable()
{
self.noFriendlyHudIcon = true;
self player_friendly_hud_destroy();
}
FriendlyHudIcon_Enable()
{
self.noFriendlyHudIcon = undefined;
if ( !IsDefined( self.friendlyIcon ) )
{
self FriendlyHudIcon_Normal();
}
}
FriendlyHudIcon_Normal()
{
assertex( flag( "coop_game" ), "Coop HUD not available in non coop." );
if ( !flag( "coop_game" ) )
return;
self.coop_icon_state = "ICON_STATE_NORMAL";
material = self FriendlyHudIcon_CurrentMaterial();
rotating = self FriendlyHudIcon_Rotating();
self rebuild_friendly_icon( self.coop_icon_color_normal, material, rotating );
}
FriendlyHudIcon_Downed()
{
assertex( flag( "coop_game" ), "Coop HUD not available in non coop." );
if ( !flag( "coop_game" ) )
return;
self.coop_icon_state = "ICON_STATE_DOWNED";
material = self FriendlyHudIcon_CurrentMaterial();
rotating = self FriendlyHudIcon_Rotating();
self rebuild_friendly_icon( self.coop_icon_color_downed, material, rotating );
}
FriendlyHudIcon_Update( color )
{
assertex( flag( "coop_game" ), "Coop HUD not available in non coop." );
if ( !flag( "coop_game" ) )
return;
assertex( isdefined( self.coop_icon_state ), "FriendlyHudIcon_Update called before FriendlyHudIcon was initialized." );
material = self FriendlyHudIcon_CurrentMaterial();
rotating = self FriendlyHudIcon_Rotating();
self rebuild_friendly_icon( color, material, rotating );
}
FriendlyHudIcon_CurrentMaterial()
{
assertex( isdefined( self ) && isplayer( self ) && isdefined( self.coop_icon_state ), "coop_icon_state not defined on player." );
material = "coop_player_location";
switch ( self.coop_icon_state )
{
case "ICON_STATE_NORMAL":
material = "coop_player_location";
break;
case "ICON_STATE_DOWNED":
material = "hint_health";
break;
default:
assertmsg( "Invalid coop_icon_state: " + self.coop_icon_state );
break;
}
return material;
}
FriendlyHudIcon_Rotating()
{
assertex( isdefined( self ) && isplayer( self ) && isdefined( self.coop_icon_state ), "coop_icon_state not defined on player." );
result = false;
switch ( self.coop_icon_state )
{
case "ICON_STATE_NORMAL":
result = true;
break;
case "ICON_STATE_DOWNED":
result = false;
break;
default:
assertmsg( "Invalid coop_icon_state: " + self.coop_icon_state );
break;
}
return result;
}
monitor_color_blind_toggle()
{
while ( 1 )
{
if ( self GetLocalPlayerProfileData( "colorBlind" ) != self.colorBlind )
{
self.colorBlind = self GetLocalPlayerProfileData( "colorBlind" );
self initialize_colors( self.colorBlind );
switch ( self.coop_icon_state )
{
case "ICON_STATE_NORMAL":
FriendlyHudIcon_Normal();
break;
case "ICON_STATE_DOWNED":
FriendlyHudIcon_Downed();
break;
}
}
wait 0.05;
}
}