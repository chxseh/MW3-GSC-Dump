#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_sandstorm;
#include maps\_audio;
#include maps\payback_util;
debug_no_heroes()
{
if ( !IsDefined( level.debug_no_heroes ))
{
level.debug_no_heroes = false;
}
return level.debug_no_heroes;
}
sandstorm_skybox_hide()
{
}
sandstorm_skybox_show()
{
}
set_sandstorm_level( stormlevel, transition_time, disable_fog )
{
if ( IsDefined( level.debug_no_sandstorm ) && level.debug_no_sandstorm )
{
return;
}
if ( !IsDefined( transition_time ))
{
transition_time = 10;
}
aud_send_msg( "sandstorm_" + stormlevel );
switch( stormlevel )
{
case "light":
blizzard_level_transition_light( transition_time );
break;
case "medium":
blizzard_level_transition_med( transition_time );
wait(5);
sandstorm_fx(3);
break;
case "hard":
blizzard_level_transition_hard( transition_time );
break;
case "blackout":
blizzard_level_transition_blackout( transition_time);
break;
case "extreme":
if ( IsDefined( disable_fog ))
{
blizzard_level_transition_extreme( transition_time,disable_fog );
}
else{
blizzard_level_transition_extreme( transition_time);
}
sandstorm_fx(0);
break;
case "aftermath":
blizzard_level_transition_aftermath( transition_time );
break;
case "none":
blizzard_level_transition_none( transition_time );
break;
}
}
handle_vehicle_lights()
{
self endon( "sandstorm_vehicle_delete" );
self vehicle_lights_on();
self waittill( "death" );
self vehicle_lights_off( "all" );
}
attachFlashlight( notify_name )
{
attach_tag = "TAG_INHAND";
self.flashlight = Spawn( "script_model", self.origin );
flashlight = self.flashlight;
flashlight.owner = self;
flashlight.origin = self GetTagOrigin( attach_tag );
flashlight.angles = self GetTagAngles( attach_tag );
flashlight SetModel( "com_flashlight_on" );
flashlight LinkTo( self, attach_tag );
flashlight_tag = "tag_light";
flashlight_effect = level._effect[ "lights_flashlight_sandstorm" ];
PlayFXOnTag(flashlight_effect, flashlight, flashlight_tag);
self thread remove_flashlight_on_alert(notify_name, flashlight_effect, flashlight, flashlight_tag);
self waittill_any( "death", "remove_flashlight");
wait(0.1);
flashlight Delete();
}
remove_flashlight_on_alert(notify_name, flashlight_effect, flashlight, flashlight_tag)
{
self endon( "death" );
self endon( "remove_flashlight" );
while ( 1 )
{
level waittill(notify_name);
self notify( "remove_flashlight" );
flashlight SetModel( "com_flashlight_off" );
StopFXOnTag( flashlight_effect, flashlight, flashlight_tag );
wait(0.1);
}
}
flashlight_on_guy()
{
if ( IsDefined(self) )
{
self.flashlight_tag = "tag_weapon_right";
self.flashlight_effect = level._effect[ "lights_flashlight_sandstorm_offset" ];
PlayFXOnTag(self.flashlight_effect, self, self.flashlight_tag);
self thread flashlight_off_on_death();
}
}
flashlight_off_guy()
{
if ( IsDefined(self) && IsDefined(self.flashlight_tag) && IsDefined(self.flashlight_effect) )
{
StopFXOnTag(self.flashlight_effect, self, self.flashlight_tag);
self.flashlight_effect = undefined;
self.flashlight_tag = undefined;
}
}
flashlight_off_on_death()
{
self notify("flashlight_off_on_death");
self endon("flashlight_off_on_death");
self waittill_any("death", "flashlight_off_delayed");
if ( IsDefined(self.flashlight_off_delay) )
{
wait self.flashlight_off_delay;
}
else
{
wait 0.75;
}
self flashlight_off_guy();
}

