#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_utility;
main( players, slot_override )
{
if ( !isdefined( players ) )
players = level.players;
thread init_and_run( players, slot_override );
}
init_and_run( players, slot_override )
{
assert( isdefined( players ) );
slot_override = ter_op( IsDefined( slot_override ), slot_override, 1 );
PrecacheNightVisionCodeAssets();
PrecacheShellshock( "nightvision" );
level.nightVision_DLight_Effect = loadfx( "misc/NV_dlight" );
level.nightVision_Reflector_Effect = loadfx( "misc/ir_tapeReflect" );
for ( i = 0; i < players.size; i++ )
{
player = players[ i ];
player ent_flag_init( "nightvision_enabled" );
player ent_flag_init( "nightvision_on" );
player ent_flag_set( "nightvision_enabled" );
player ent_flag_init( "nightvision_dlight_enabled" );
player ent_flag_set( "nightvision_dlight_enabled" );
player ent_flag_clear( "nightvision_dlight_enabled" );
player SetActionSlot( slot_override, "nightvision" );
}
VisionSetNight( "default_night" );
waittillframeend;
wait 0.05;
for ( i = 0; i < players.size; i++ )
{
player = players[ i ];
player thread nightVision_Toggle();
}
}
nightVision_Toggle()
{
assert( isplayer( self ) );
self endon( "death" );
for ( ;; )
{
self waittill( "night_vision_on" );
nightVision_On();
self waittill( "night_vision_off" );
nightVision_Off();
wait 0.05;
}
}
nightVision_check( player )
{
if ( !isdefined( player ) )
player = level.player;
return isdefined( player.nightVision_Enabled );
}
nightVision_On()
{
assert( isplayer( self ) );
self.nightVision_Started = true;
wait( 1.0 );
ent_flag_set( "nightvision_on" );
self.nightVision_Enabled = true;
ai = getaiarray( "allies" );
array_thread( ai, ::enable_ir_beacon );
if ( !exists_global_spawn_function( "allies", ::enable_ir_beacon ) )
add_global_spawn_function( "allies", ::enable_ir_beacon );
}
enable_ir_beacon()
{
if ( !isAI( self ) )
return;
if ( isdefined( self.has_no_ir ) )
{
assertex( self.has_no_ir, ".has_ir must be true or undefined" );
return;
}
animscripts\shared::updateLaserStatus();
thread maps\_nightvision::loopReflectorEffect();
}
loopReflectorEffect()
{
level endon( "night_vision_off" );
self endon( "death" );
for ( ;; )
{
playfxontag( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_le" );
playfxontag( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_ri" );
wait( 0.1 );
}
}
stop_reflector_effect()
{
if ( isdefined( self.has_no_ir ) )
return;
stopfxontag( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_le" );
stopfxontag( level.nightVision_Reflector_Effect, self, "tag_reflector_arm_ri" );
}
nightVision_Off()
{
assert( isplayer( self ) );
self.nightVision_Started = undefined;
wait( 0.4 );
level notify( "night_vision_off" );
if ( isdefined( level.nightVision_DLight ) )
level.nightVision_DLight delete();
self notify( "nightvision_shellshock_off" );
ent_flag_clear( "nightvision_on" );
self.nightVision_Enabled = undefined;
someoneUsingNightvision = false;
for ( i = 0 ; i < level.players.size ; i++ )
{
if ( nightvision_Check( level.players[ i ] ) )
someoneUsingNightvision = true;
}
if ( !someoneUsingNightvision )
remove_global_spawn_function( "allies", ::enable_ir_beacon );
thread nightVision_EffectsOff();
}
nightVision_EffectsOff()
{
friendlies = getAIArray( "allies" );
foreach ( guy in friendlies )
{
guy.usingNVFx = undefined;
guy animscripts\shared::updateLaserStatus();
guy stop_reflector_effect();
}
}
ShouldBreakNVGHintPrint()
{
assert( isplayer( self ) );
return isDefined( self.nightVision_Started );
}
should_break_disable_nvg_print()
{
assert( isplayer( self ) );
return !isDefined( self.nightVision_Started );
}



