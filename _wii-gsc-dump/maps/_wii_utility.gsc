#include common_scripts\utility;
#include animscripts\utility;
#include maps\_utility_code;
button_monitor( signal, bind, intermediate, checkfunc )
{
NotifyOnCommand( intermediate, bind );
for(;;)
{
self waittill( intermediate );
if ( self [[ checkfunc ]]() )
{
self notify( signal );
}
wait 0.07;
}
}
checkfunc_wii()
{
return (!self using_classic_controller() && !self using_wii_zapper());
}
checkfunc_ccp()
{
return (self using_classic_controller());
}
checkfunc_zap()
{
return (self using_wii_zapper());
}
wii_NotifyOnCommand( signal, ccp_bind, wii_bind, zap_bind )
{
intermediate_w=signal + "_w";
intermediate_c=signal + "_c";
intermediate_z=signal + "_z";
self childthread button_monitor(signal, wii_bind, intermediate_w, ::checkfunc_wii );
self childthread button_monitor(signal, ccp_bind, intermediate_c, ::checkfunc_ccp );
self childthread button_monitor(signal, zap_bind, intermediate_z, ::checkfunc_zap );
}
wii_button_monitor( signal, ccp_bind, wii_bind, zap_bind )
{
intermediate_w=signal + "_w";
intermediate_c=signal + "_c";
intermediate_z=signal + "_z";
self thread button_monitor(signal, wii_bind, intermediate_w, ::checkfunc_wii );
self thread button_monitor(signal, ccp_bind, intermediate_c, ::checkfunc_ccp );
self thread button_monitor(signal, zap_bind, intermediate_z, ::checkfunc_zap );
}
monitor_dpad_up( signal )
{
self wii_button_monitor( signal, "+actionslot 1", "+gostand", "+actionslot 1" );
}
monitor_dpad_down( signal )
{
self wii_button_monitor( signal, "+actionslot 2", "+melee_zoom", "+actionslot 2" );
}
monitor_dpad_left( signal )
{
self wii_button_monitor( signal, "+actionslot 3", "+actionslot_carousel", "+actionslot 3" );
}
monitor_dpad_right( signal )
{
self wii_button_monitor( signal, "+actionslot 4", "weapnext", "+actionslot 4" );
}
wii_play_rumble_with_wait( rumble_type , wait_time )
{
self endon("death");
if ( IsDefined(wait_time) )
{
level.loop_rumble = false;
wait(wait_time);
}
self PlayRumbleOnEntity(rumble_type);
}
wii_play_rumble_loop_on_entity( rumble_type , rate )
{
self endon("death");
if ( !IsDefined(rate) )
{
rate = 1;
}
level.loop_rumble = true;
while(level.loop_rumble)
{
println("ccsdebug: PlayRumbleOnEntity: " + rumble_type);
PlayRumbleOnPosition(rumble_type, self.origin);
wait(rate);
}
}
wii_stop_all_rumbles()
{
level.loop_rumble = false;
StopAllRumbles();
}
wii_play_rumble_loop_in_area( rumble_type, rate, radius )
{
self endon("death");
height = radius * 2;
zoffset = -1 * radius;
areatrigger = Spawn( "trigger_radius", self.origin + (0, 0, zoffset), 0, radius, height );
areatrigger EnableLinkTo();
areatrigger LinkTo( self );
self.arearumbletrigger = areatrigger;
thread wii_cleanup_rumble_loop_in_area();
while(1)
{
self.arearumbletrigger waittill( "trigger" );
while( IsDefined( self.arearumbletrigger ) && ( level.player IsTouching( self.arearumbletrigger ) ) )
{
PlayRumbleOnPosition( rumble_type, self.origin );
wait( rate );
}
}
}
wii_stop_rumble_loop_in_area()
{
if ( IsDefined( self.arearumbletrigger ) )
self.arearumbletrigger Delete();
}
wii_cleanup_rumble_loop_in_area()
{
self waittill("death");
if ( IsDefined( self.arearumbletrigger ) )
self.arearumbletrigger Delete();
}
wii_play_random_rumble(playtime, rumbles, minInterval, maxInterval, delay)
{
level.player endon("death");
if(IsDefined(delay))
{
wait(delay);
}
timer = playtime;
while(timer > 0.0)
{
interval = RandomFloatRange(minInterval, maxInterval);
rumble = random(rumbles);
timer -= interval;
level.player PlayRumbleOnEntity(rumble);
wait(interval);
}
}
wii_precache_random_heavy_rumbles()
{
PreCacheRumble("wii_rumble_0");
PreCacheRumble("wii_rumble_1");
PreCacheRumble("wii_rumble_2");
PreCacheRumble("wii_rumble_3");
PreCacheRumble("wii_rumble_4");
PreCacheRumble("wii_rumble_5");
PreCacheRumble("wii_rumble_6");
PreCacheRumble("wii_rumble_7");
PreCacheRumble("wii_rumble_8");
}
wii_play_random_heavy_rumble(playtime, delay)
{
rumbles = [];
rumbles[rumbles.size] = "wii_rumble_0";
rumbles[rumbles.size] = "wii_rumble_1";
rumbles[rumbles.size] = "wii_rumble_2";
rumbles[rumbles.size] = "wii_rumble_3";
rumbles[rumbles.size] = "wii_rumble_4";
rumbles[rumbles.size] = "wii_rumble_5";
rumbles[rumbles.size] = "wii_rumble_6";
rumbles[rumbles.size] = "wii_rumble_7";
rumbles[rumbles.size] = "wii_rumble_8";
thread wii_play_random_rumble(playtime, rumbles, 0.05, 0.25, delay);
}