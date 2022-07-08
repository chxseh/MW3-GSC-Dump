#include maps\_utility;
#include common_scripts\utility;
blizzard_main()
{
level.sandstormSpawnrate = 0.1;
blizzard_flags();
fx_init();
blizzard_level_set( "none" );
thread blizzard_start();
level.global_ambience_blend_func = ::blizzard_ice_overlay_blend;
}
blizzard_flags()
{
flag_init( "pause_blizzard_ground_fx" );
}
blizzard_start()
{
if ( !isdefined( level.players ) )
level waittill( "level.players initialized" );
array_thread( level.players, ::blizzard_start_proc );
thread pause_blizzard_ground_fx();
}
blizzard_start_screen_proc()
{
screen_tag = self spawn_tag_origin();
screenEffect = false;
while(1)
{
if (!is_coop() && level.snowLevel == 6)
{
if (!screenEffect )
{
screenEffect = true;
PlayFXOnTag(level._effect["particle_fog2"],screen_tag,"tag_origin");
}
playerAngles = self GetPlayerAngles();
screen_tag.origin = self.origin;
screen_tag.angles = playerAngles;
}
else
{
if (screenEffect )
{
StopFXOnTag(level._effect["particle_fog2"],screen_tag,"tag_origin");
screenEffect = false;
}
}
wait(.05);
}
}
blizzard_start_proc()
{
while ( 1 )
{
if ( is_coop() )
PlayFXOnTagForClients( level._effect[ "blizzard_main" ], self, "tag_origin", self );
else
playfx( level._effect[ "blizzard_main" ], (self groundpos(self.origin)+(0,0,86)) );
wait(level.sandstormSpawnrate);
}
}
set_sandstorm_spawnrate(rate)
{
if (!IsDefined(rate))
{
switch(level.snowLevel)
{
case 0:
level.sandstormSpawnrate = .3;
break;
case 1:
level.sandstormSpawnrate = .08;
break;
case 2:
level.sandstormSpawnrate = .17;
break;
case 3:
level.sandstormSpawnrate = .3;
break;
case 4:
level.sandstormSpawnrate = .24;
break;
case 5:
level.sandstormSpawnrate = .14;
break;
case 6:
level.sandstormSpawnrate = .07;
break;
}
}
else
{
level.sandstormSpawnrate = rate;
}
}
lerp_sandstorm_spawnrate(rate,transitionSpeed)
{
if (!IsDefined(transitionSpeed))
{
transitionSpeed = .05;
}
if (rate > level.sandstormSpawnrate)
{
while(rate > level.sandstormSpawnrate)
{
wait(level.sandstormSpawnrate);
newRate = level.sandstormSpawnrate+transitionSpeed;
level.sandstormSpawnrate = min(newRate,rate);
}
}
else
{
while(rate < level.sandstormSpawnrate)
{
wait(level.sandstormSpawnrate);
newRate = level.sandstormSpawnrate-transitionSpeed;
level.sandstormSpawnrate = max(newRate,rate);
}
}
}
fx_init()
{
setsaveddvar( "r_outdoorfeather", "32" );
level._effect[ "blizzard_level_0" ] = loadfx( "misc/blank" );
level._effect[ "blizzard_level_1" ] = loadfx( "sand/sand_light" );
level._effect[ "blizzard_level_2" ] = loadfx( "sand/sand_medium_2" );
level._effect[ "blizzard_level_3" ] = loadfx( "sand/sand_medium_2" );
level._effect[ "blizzard_level_4" ] = loadfx( "sand/sand_medium_2" );
level._effect[ "blizzard_level_5" ] = loadfx( "sand/sand_extreme" );
level._effect[ "blizzard_level_6" ] = loadfx( "sand/sand_extreme" );
level._effect[ "blizzard_level_7" ] = loadfx( "sand/sand_aftermath" );
sun_array = GetMapSunLight();
level.default_sun = ( sun_array[0], sun_array[1], sun_array[2] );
level.sun_intensity = 1.0;
level.blizzard_overlay_alpha = 0;
}
blizzard_level_set( type )
{
level.snowLevel = blizzard_level_get_count( type );
blizzard_set_fx();
}
blizzard_level_transition_none( time )
{
blizzard_set();
thread blizzard_level_transition( "none", time );
maps\_utility::vision_set_fog_changes( "payback", time );
thread blizzard_set_culldist( 0, 0 );
thread blizzard_set_shadowquality( 0, 1.0 );
SetHalfResParticles( false );
flag_set( "pause_blizzard_ground_fx" );
blizzard_overlay_alpha( time, 0 );
resetsunlight();
}
blizzard_no_fog( time )
{
blizzard_set();
thread blizzard_level_transition( "none", time );
maps\_utility::vision_set_fog_changes( "payback", time );
thread blizzard_set_culldist( 0, 0 );
thread blizzard_set_shadowquality( 0, 1.0 );
SetHalfResParticles( false );
flag_set( "pause_blizzard_ground_fx" );
blizzard_overlay_alpha( time, 0.25 );
resetsunlight();
}
blizzard_level_transition_light( time )
{
blizzard_set();
thread blizzard_level_transition( "light", time );
maps\_utility::vision_set_fog_changes( "payback", time );
thread blizzard_set_culldist( 0, 0 );
thread blizzard_set_shadowquality( 0, 1.0 );
SetHalfResParticles( false );
flag_set( "pause_blizzard_ground_fx" );
blizzard_overlay_alpha( time, 0.45 );
thread blizzard_set_sunlight( 1.0, time );
}
blizzard_level_transition_med( time )
{
blizzard_set();
thread blizzard_level_transition( "med", time );
maps\_utility::vision_set_fog_changes( "payback_medium", time );
thread blizzard_set_culldist( time, 4500 );
thread blizzard_set_shadowquality( time, 0.5 );
SetHalfResParticles( false );
flag_set( "pause_blizzard_ground_fx" );
blizzard_overlay_alpha( time, 0.5 );
}
blizzard_level_transition_hard( time )
{
blizzard_set();
thread blizzard_level_transition( "hard", time );
maps\_utility::vision_set_fog_changes( "payback_heavy", time );
intensity = 1;
thread blizzard_set_sunlight( intensity, time );
thread blizzard_set_culldist( time, 0 );
thread blizzard_set_shadowquality( time, 0 );
SetHalfResParticles( false );
blizzard_overlay_alpha( time, 0.7 );
}
blizzard_level_transition_extreme( time,disable_fog )
{
blizzard_set();
thread blizzard_level_transition( "extreme", time );
intensity = 1;
thread blizzard_set_sunlight( intensity, time );
thread blizzard_set_culldist( time, 0 );
thread blizzard_set_shadowquality( time, 0 );
SetHalfResParticles( false );
blizzard_overlay_alpha( time, 0.7 );
if (!IsDefined(disable_fog))
{
thread blizzard_level_transition_extreme_fog(time,0.05);
}
}
blizzard_level_transition_extreme_fog_novision(time,delay)
{
wait(delay);
maps\_utility::vision_set_fog_changes( "payback_heavy_fogonly", time);
}
blizzard_level_transition_extreme_fog(time,delay)
{
if (IsDefined(delay))
{
wait(delay);
}
wait(delay);
maps\_utility::vision_set_fog_changes( "payback_heavy", time);
}
blizzard_level_transition_extreme_sat(time,delay)
{
if (IsDefined(delay))
{
wait(delay);
}
maps\_utility::vision_set_fog_changes( "payback_heavy_sat", time);
}
blizzard_level_transition_extreme2(time,delay)
{
if (IsDefined(delay))
{
wait(delay);
}
vision_set_changes("payback_heavy_75",time);
}
blizzard_level_transition_blackout( time )
{
blizzard_set();
thread blizzard_level_transition( "extreme", time );
maps\_utility::vision_set_fog_changes( "payback_blackout", time );
intensity = 1;
thread blizzard_set_sunlight( intensity, time );
thread blizzard_set_culldist( time, 0 );
thread blizzard_set_shadowquality( time, 0 );
SetHalfResParticles( false );
blizzard_overlay_alpha( time, 0.7 );
}
blizzard_level_transition_aftermath( time )
{
blizzard_set();
thread blizzard_level_transition( "aftermath", time );
maps\_utility::vision_set_fog_changes( "payback_heavy", time );
intensity = 1;
thread blizzard_set_sunlight( intensity, time );
thread blizzard_set_culldist( time, 0 );
thread blizzard_set_shadowquality( time, 0.5 );
SetHalfResParticles( false );
blizzard_overlay_alpha( time, 0.7 );
}
blizzard_set_culldist( time, to )
{
level notify( "blizzard_set_culldist" );
level endon( "blizzard_set_culldist" );
max_cull = 10000;
from = level.blizzard_culldist;
if ( !IsDefined( from ) || from == 0 )
{
from = max_cull;
}
if ( to == 0 )
{
to = max_cull;
}
trans_time = 0;
startTime = (time * 0.5);
while ( trans_time <= time )
{
if ( time > 0 )
{
if ( trans_time >= startTime )
{
coef = (trans_time - startTime) / (time - startTime);
level.blizzard_culldist = from + ((to - from) * coef);
}
else
{
level.blizzard_culldist = from;
}
}
else
{
level.blizzard_culldist = to;
}
trans_time += blizzard_set_culldist_checked( level.blizzard_culldist );
}
if ( to >= max_cull || to == 0 )
{
level.blizzard_culldist = 0;
blizzard_set_culldist_checked( 0 );
}
else
{
for(;;)
{
level.blizzard_culldist = to;
blizzard_set_culldist_checked( to );
}
}
}
blizzard_set_culldist_checked( cull_dist )
{
level notify( "blizzard_set_culldist_checked" );
level endon( "blizzard_set_culldist" );
level endon( "blizzard_set_culldist_checked" );
cull_allowed = false;
time_waited = 0;
if ( !IsDefined( level.trig_enable_sandstorm_cull ) )
{
level.trig_enable_sandstorm_cull = GetEntArray("trig_enable_sandstorm_cull", "targetname");
}
while ( !cull_allowed )
{
if ( cull_dist == 0 )
{
cull_allowed = true;
}
else
{
if ( IsDefined( level.player.trig_enable_sandstorm_cull ) && level.player IsTouching( level.player.trig_enable_sandstorm_cull ) )
{
cull_allowed = blizzard_culldist_check_trigger( level.player.trig_enable_sandstorm_cull );
}
else
{
foreach ( trig in level.trig_enable_sandstorm_cull )
{
if ( (!IsDefined( level.player.trig_enable_sandstorm_cull ) || trig != level.player.trig_enable_sandstorm_cull)
&& level.player IsTouching( trig ) )
{
cull_allowed = blizzard_culldist_check_trigger( trig );
level.player.trig_enable_sandstorm_cull = trig;
break;
}
}
}
if ( !cull_allowed )
{
SetCullDist( 0 );
}
}
time_waited += 0.05;
wait 0.05;
}
SetCullDist( cull_dist );
return time_waited;
}
blizzard_culldist_check_trigger( trig )
{
cull_allowed = false;
if ( IsDefined( trig.target ) )
{
avoid_look_at = getstruct(trig.target, "targetname");
if ( IsDefined( avoid_look_at ) )
{
lookingDir = AnglesToForward( level.player GetPlayerAngles() );
avoidDir = VectorNormalize( avoid_look_at.origin - level.player.origin );
if ( VectorDot( lookingDir, avoidDir ) < 0.6 )
{
cull_allowed = true;
}
}
}
else
{
cull_allowed = true;
}
return cull_allowed;
}
blizzard_set_shadowquality( time, to )
{
self notify( "blizzard_set_shadowquality" );
self endon( "blizzard_set_shadowquality" );
from = level.blizzard_shadowquality;
if ( !IsDefined( from ) )
{
from = 1.0;
}
shadow_scale = 1;
shadow_size_near = 0.25;
trans_time = 0;
while ( trans_time <= time )
{
if ( time > 0 )
{
coef = trans_time / time;
level.blizzard_shadowquality = from + ((to - from) * coef);
}
else
{
level.blizzard_shadowquality = to;
}
shadow_scale = 0.25 + (level.blizzard_shadowquality * 0.75);
shadow_size_near = 0.1 + (level.blizzard_shadowquality * 0.15);
wait 0.05;
if ( int( trans_time ) != int( trans_time + 0.05 ) )
{
SetSavedDvar( "sm_sunShadowScale", shadow_scale );
SetSavedDvar( "sm_sunSampleSizeNear", shadow_size_near );
}
trans_time += 0.05;
}
SetSavedDvar( "sm_sunShadowScale", shadow_scale );
SetSavedDvar( "sm_sunSampleSizeNear", shadow_size_near );
}
blizzard_set_sunlight( intensity, time )
{
level notify( "blizzard_set_sunlight" );
level endon( "blizzard_set_sunlight" );
interval = int( time * 20 );
diff = intensity - level.sun_intensity;
fraction = diff / interval;
while( interval )
{
level.sun_intensity += fraction;
new_sun = ( level.default_sun * level.sun_intensity );
setsunlight( new_sun[ 0 ], new_sun[ 1 ], new_sun[ 2 ] );
interval--;
wait .05;
}
level.sun_intensity = intensity;
new_sun = ( level.default_sun * level.sun_intensity );
setsunlight( new_sun[ 0 ], new_sun[ 1 ], new_sun[ 2 ] );
}
blizzard_level_transition( type, time )
{
level notify( "blizzard_level_change" );
level endon( "blizzard_level_change" );
newlevel = blizzard_level_get_count( type );
if ( level.snowLevel > newlevel )
{
interval = level.snowLevel - newlevel;
time /= interval;
for ( i = 0; i < interval; i++ )
{
wait( time );
level.snowLevel -- ;
blizzard_set_fx();
}
assert( level.snowLevel == newlevel );
}
if ( level.snowLevel < newlevel )
{
interval = newlevel - level.snowLevel;
time /= interval;
for ( i = 0; i < interval; i++ )
{
wait( time );
level.snowLevel++ ;
blizzard_set_fx();
}
assert( level.snowLevel == newlevel );
}
}
blizzard_set_fx()
{
level._effect[ "blizzard_main" ] = level._effect[ "blizzard_level_" + level.snowLevel ];
thread set_sandstorm_spawnrate();
}
blizzard_level_get_count( type )
{
switch( type )
{
case "none":
return 0;
case "light":
return 1;
case "med":
return 3;
case "hard":
return 5;
case "extreme":
return 6;
case "aftermath":
return 7;
}
}
blizzard_overlay_alpha( time, alpha, skipCap )
{
player = self;
if ( !isplayer( player ) )
player = level.player;
if( !isdefined( alpha ) )
alpha = 1;
if ( !isdefined( skipCap ) )
level.blizzard_overlay_alpha_cap = alpha;
if ( alpha > 0 )
{
}
else
{
}
overlay = get_frozen_overlay( player );
overlay.x = 0;
overlay.y = 0;
overlay setshader( "overlay_sandstorm", 640, 480 );
overlay.sort = 50;
overlay.lowresbackground = true;
overlay.alignX = "left";
overlay.alignY = "top";
overlay.horzAlign = "fullscreen";
overlay.vertAlign = "fullscreen";
overlay.alpha = level.blizzard_overlay_alpha;
overlay fadeovertime( time );
overlay.alpha = alpha;
level.blizzard_overlay_alpha = alpha;
}
blizzard_overlay_clear( timer )
{
if ( !isdefined( timer ) || !timer )
{
player = self;
if ( !isplayer( player ) )
player = level.player;
overlay = get_frozen_overlay( player );
overlay destroy();
return;
}
blizzard_overlay_alpha( timer, 0 );
}
get_frozen_overlay( player )
{
if ( !isdefined( player.overlay_frozen ) )
player.overlay_frozen = newClientHudElem( player );
return player.overlay_frozen;
}
pause_blizzard_ground_fx()
{
fx = [];
wait( 0.1 );
for ( ;; )
{
flag_wait( "pause_blizzard_ground_fx" );
foreach ( oneshot in fx )
oneshot pauseEffect();
flag_waitopen( "pause_blizzard_ground_fx" );
foreach ( oneshot in fx )
oneshot restartEffect();
}
}
blizzard_set()
{
level notify( "blizzard_changed" );
level notify( "blizzard_set_sunlight" );
}
blizzard_ice_overlay_blend( progress, inner, outer )
{
cap = level.blizzard_overlay_alpha_cap;
if ( !isdefined( cap ) )
cap = 1;
if ( issubstr( inner, "exterior" ) )
{
blizzard_overlay_alpha( 1, ( 1 - progress ) * cap, true );
return;
}
if ( issubstr( outer, "exterior" ) )
{
blizzard_overlay_alpha( 1, progress * cap, true );
}
}
