#include common_scripts\utility;
#include maps\_utility;
is_light_entity( ent )
{
return ent.classname == "light_spot" || ent.classname == "light_omni" || ent.classname == "light";
}
flickerLight( color0, color1, minDelay, maxDelay )
{
self endon("kill_flicker");
toColor = color0;
delay = 0.0;
self ent_flag_init("stop_flicker");
for ( ;; )
{
if (self ent_flag("stop_flicker"))
{
wait 0.05;
}
else
{
fromColor = toColor;
toColor = color0 + ( color1 - color0 ) * randomfloat( 1.0 );
if ( minDelay != maxDelay )
delay += randomfloatrange( minDelay, maxDelay );
else
delay += minDelay;
if(delay==0) delay+=.0000001;
colorDeltaPerTime = ( fromColor - toColor ) * ( 1 / delay );
while ( ( delay > 0 ) && ( !( self ent_flag("stop_flicker") ) ) )
{
self setLightColor( toColor + colorDeltaPerTime * delay );
wait 0.05;
delay -= 0.05;
}
}
}
}
kill_flicker_when_damaged( noteworthy )
{
ents = getentarray( noteworthy, "script_noteworthy");
closest = undefined;
closest_distance = 99999999.0;
foreach (ent in ents)
{
dist = Distance(self.origin, ent.origin);
if (dist < closest_distance)
{
closest = ent;
closest_distance = dist;
}
}
if (isdefined(closest))
{
closest waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
self notify("kill_flicker");
wait 0.05;
self setLightColor( (0,0,0) );
}
}
generic_pulsing()
{
if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
{
self setLightIntensity( 0 );
return;
}
on = self getLightIntensity();
off = .05;
curr = on;
transition_on = .3;
transition_off = .6;
increment_on = ( on - off ) / ( transition_on / .05 );
increment_off = ( on - off ) / ( transition_off / .05 );
for ( ;; )
{
time = 0;
while ( ( time < transition_off ) )
{
curr -= increment_off;
curr = clamp( curr, 0, 100 );
self setLightIntensity( curr );
time += .05;
wait( .05 );
}
wait( 1 );
time = 0;
while ( time < transition_on )
{
curr += increment_on;
curr = clamp( curr, 0, 100 );
self setLightIntensity( curr );
time += .05;
wait( .05 );
}
wait( .5 );
}
}
generic_double_strobe()
{
if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
{
self setLightIntensity( 0 );
return;
}
on = self getLightIntensity();
off = .05;
linked_models = false;
lit_model = undefined;
unlit_model = undefined;
linked_lights = false;
linked_light_ents = [];
if ( isdefined( self.script_noteworthy ) )
{
linked_things = getentarray( self.script_noteworthy, "targetname" );
for ( i = 0; i < linked_things.size; i++ )
{
if ( is_light_entity( linked_things[ i ] ) )
{
linked_lights = true;
linked_light_ents[ linked_light_ents.size ] = linked_things[ i ];
}
if ( linked_things[ i ].classname == "script_model" )
{
lit_model = linked_things[ i ];
unlit_model = getent( lit_model.target, "targetname" );
linked_models = true;
}
}
}
for ( ;; )
{
self setLightIntensity( off );
if ( linked_models )
{
lit_model hide();
unlit_model show();
}
wait( .8 );
self setLightIntensity( on );
if ( linked_models )
{
lit_model show();
unlit_model hide();
}
wait( .1 );
self setLightIntensity( off );
if ( linked_models )
{
lit_model hide();
unlit_model show();
}
wait( .12 );
self setLightIntensity( on );
if ( linked_models )
{
lit_model show();
unlit_model hide();
}
wait( .1 );
}
}
getclosests_flickering_model( origin )
{
array = getentarray( "light_flicker_model", "targetname" );
return_array = [];
model = getclosest( origin, array );
if ( isdefined( model ) )
return_array[ 0 ] = model;
return return_array;
}
generic_flickering()
{
if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
{
self setLightIntensity( 0 );
return;
}
self endon( "stop_dynamic_light_behavior" );
self endon( "death" );
self.linked_models = false;
self.lit_models = undefined;
self.unlit_models = undefined;
self.linked_lights = false;
self.linked_light_ents = [];
self.linked_prefab_ents = undefined;
self.linked_things = [];
if ( isdefined( self.script_LinkTo ) )
{
self.linked_prefab_ents = self get_linked_ents();
assertex( self.linked_prefab_ents.size == 2, "Dynamic light at " + self.origin + " needs to script_LinkTo a prefab that contains both on and off light models" );
foreach( ent in self.linked_prefab_ents )
{
if ( ( isdefined( ent.script_noteworthy ) ) && ( ent.script_noteworthy == "on" ) )
{
if (!isdefined(self.lit_models))
self.lit_models[0] = ent;
else
self.lit_models[self.lit_models.size] = ent;
continue;
}
if ( ( isdefined( ent.script_noteworthy ) ) && ( ent.script_noteworthy == "off" ) )
{
if (!isdefined(self.unlit_models))
self.unlit_models[0] = ent;
else
self.unlit_models[self.unlit_models.size] = ent;
self.unlit_model = ent;
continue;
}
if ( is_light_entity( ent ) )
{
self.linked_lights = true;
self.linked_light_ents[ self.linked_light_ents.size ] = ent;
}
}
assertex( isdefined( self.lit_models ), "Dynamic light at " + self.origin + " needs to script_LinkTo a prefab contains a script_model light with script_noteworthy of 'on' " );
assertex( isdefined( self.unlit_models ), "Dynamic light at " + self.origin + " needs to script_LinkTo a prefab contains a script_model light with script_noteworthy of 'on' " );
self.linked_models = true;
}
if ( isdefined( self.script_noteworthy ) )
self.linked_things = getentarray( self.script_noteworthy, "targetname" );
if ( ( ! self.linked_things.size ) && ( !isdefined( self.linked_prefab_ents ) ) )
self.linked_things = getclosests_flickering_model( self.origin );
for ( i = 0; i < self.linked_things.size; i++ )
{
if ( is_light_entity( self.linked_things[ i ] ) )
{
self.linked_lights = true;
self.linked_light_ents[ self.linked_light_ents.size ] = self.linked_things[ i ];
}
if ( self.linked_things[ i ].classname == "script_model" )
{
lit_model = self.linked_things[ i ];
if (!isdefined(self.lit_models))
self.lit_models[0] = lit_model;
else
self.lit_models[self.lit_models.size] = lit_model;
if (!isdefined(self.unlit_models))
self.unlit_models[0] = getent( lit_model.target, "targetname" );
else
self.unlit_models[self.unlit_models.size] = getent( lit_model.target, "targetname" );
self.linked_models = true;
}
}
if (isdefined(self.lit_models))
{
foreach (lit_model in self.lit_models)
{
if (isdefined(lit_model) && isdefined(lit_model.script_fxid))
{
lit_model.effect = createOneshotEffect(lit_model.script_fxid);
offset = ( 0, 0, 0);
angles = ( 0, 0, 0);
if (isdefined(lit_model.script_parameters))
{
tokens = strtok(lit_model.script_parameters, ", ");
if (tokens.size < 3)
{
assertmsg( "lit_model script_parameters are expected to have three numbers for the offset");
}
else if (tokens.size == 6)
{
x = Float(tokens[0]);
y = Float(tokens[1]);
z = Float(tokens[2]);
offset = ( x, y, z );
x = Float(tokens[3]);
y = Float(tokens[4]);
z = Float(tokens[5]);
angles = ( x, y, z );
}
else
{
x = Float(tokens[0]);
y = Float(tokens[1]);
z = Float(tokens[2]);
offset = ( x, y, z );
}
}
lit_model.effect.v[ "origin" ] = ( lit_model.origin + offset );
lit_model.effect.v[ "angles" ] = ( lit_model.angles + angles );
}
}
}
self thread generic_flicker_msg_watcher();
self thread generic_flicker();
}
generic_flicker_msg_watcher()
{
self ent_flag_init("flicker_on");
if(isdefined(self.script_light_startnotify) && self.script_light_startnotify != "nil")
{
for(;;)
{
level waittill(self.script_light_startnotify);
self ent_flag_set("flicker_on");
if(isdefined(self.script_light_stopnotify) && self.script_light_stopnotify != "nil")
{
level waittill(self.script_light_stopnotify);
self ent_flag_clear("flicker_on");
}
}
}
else self ent_flag_set("flicker_on");
}
generic_flicker_pause()
{
f_on = self getLightIntensity();
if(! self ent_flag("flicker_on"))
{
if ( self.linked_models )
{
if (isdefined(self.lit_models))
{
foreach (lit_model in self.lit_models)
{
lit_model hide();
if (isdefined(lit_model.effect))
{
lit_model.effect pauseEffect();
}
}
}
if (isdefined(self.unlit_models))
{
foreach (unlit_model in self.unlit_models)
unlit_model show();
}
}
self setLightIntensity( 0 );
if ( self.linked_lights )
{
for ( i = 0; i < self.linked_light_ents.size; i++ )
self.linked_light_ents[ i ] setLightIntensity( 0 );
}
self ent_flag_wait("flicker_on");
self setLightIntensity( f_on );
if ( self.linked_lights )
{
for ( i = 0; i < self.linked_light_ents.size; i++ )
self.linked_light_ents[ i ] setLightIntensity( f_on );
}
if ( self.linked_models )
{
if (isdefined(self.lit_models))
{
foreach (lit_model in self.lit_models)
{
lit_model show();
if (isdefined(lit_model.effect))
{
lit_model.effect restartEffect();
}
}
}
if (isdefined(self.unlit_models))
{
foreach (unlit_model in self.unlit_models)
unlit_model hide();
}
}
}
}
generic_flicker()
{
self endon( "stop_dynamic_light_behavior" );
self endon( "death" );
min_flickerless_time = .2;
max_flickerless_time = 1.5;
on = self getLightIntensity();
off = 0;
curr = on;
num = 0;
while( isdefined( self ) )
{
self generic_flicker_pause();
num = randomintrange( 1, 10 );
while ( num )
{
self generic_flicker_pause();
wait( randomfloatrange( .05, .1 ) );
if ( curr > .2 )
{
curr = randomfloatrange( 0, .3 );
if ( self.linked_models && isDefined(self.lit_models) )
{
foreach (lit_model in self.lit_models)
{
lit_model hide();
if (isdefined(lit_model.effect))
{
lit_model.effect pauseEffect();
}
}
}
if (isdefined(self.unlit_models))
{
foreach (unlit_model in self.unlit_models)
unlit_model show();
}
}
else
{
curr = on;
if ( self.linked_models )
{
if (isdefined(self.lit_models))
{
foreach (lit_model in self.lit_models)
{
lit_model show();
if (isdefined(lit_model.effect))
{
lit_model.effect restartEffect();
}
}
}
if(isdefined(self.unlit_models))
{
foreach (unlit_model in self.unlit_models)
{
unlit_model hide();
maps\_audio::aud_send_msg("light_flicker_on", unlit_model);
}
}
}
}
self setLightIntensity( curr );
if ( self.linked_lights )
{
for ( i = 0; i < self.linked_light_ents.size; i++ )
self.linked_light_ents[ i ] setLightIntensity( curr );
}
num -- ;
}
self generic_flicker_pause();
self setLightIntensity( on );
if ( self.linked_lights )
{
for ( i = 0; i < self.linked_light_ents.size; i++ )
self.linked_light_ents[ i ] setLightIntensity( on );
}
if ( self.linked_models )
{
if (isdefined(self.lit_models))
{
foreach (lit_model in self.lit_models)
{
lit_model show();
if (isdefined(lit_model.effect))
{
lit_model.effect restartEffect();
}
}
}
if (isdefined(self.unlit_models))
{
foreach (unlit_model in self.unlit_models)
unlit_model hide();
}
}
wait( randomfloatrange( min_flickerless_time, max_flickerless_time ) );
}
}
generic_spot()
{
for(;;)
{
level waitframe();
}
}
flickerLightIntensity( minDelay, maxDelay )
{
on = self getLightIntensity();
off = 0;
curr = on;
num = 0;
for ( ;; )
{
num = randomintrange( 1, 10 );
while ( num )
{
wait( randomfloatrange( .05, .1 ) );
if ( curr > .2 )
curr = randomfloatrange( 0, .3 );
else
curr = on;
self setLightIntensity( curr );
num -- ;
}
self setLightIntensity( on );
wait( randomfloatrange( minDelay, maxDelay ) );
}
}
burning_trash_fire()
{
full = self getLightIntensity();
old_intensity = full;
for ( ;; )
{
intensity = randomfloatrange( full * 0.7, full * 1.2 );
timer = randomfloatrange( 0.3, 0.6 );
timer *= 20;
for ( i = 0; i < timer; i++ )
{
new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
self setLightIntensity( new_intensity );
wait( 0.05 );
}
old_intensity = intensity;
}
}
strobeLight( intensity0, intensity1, period, kill_flag )
{
frequency = 360 / period;
time = 0;
while ( 1 )
{
interpolation = sin( time * frequency ) * 0.5 + 0.5;
self setLightIntensity( intensity0 + ( intensity1 - intensity0 ) * interpolation );
wait 0.05;
time += 0.05;
if ( time > period )
time -= period;
if( isdefined( kill_flag ) )
{
if( flag( kill_flag ) )
return;
}
}
}
changeLightColorTo( targetColor, totalTime, accelTime, decelTime )
{
if ( !isdefined( accelTime ) )
accelTime = 0;
if ( !isdefined( decelTime ) )
decelTime = 0;
self thread changeLightColorToWorkerThread( targetColor, totalTime, accelTime, decelTime );
}
changeLightColorToWorkerThread( targetColor, totalTime, accelTime, decelTime )
{
startColor = self getLightColor();
timeFactor = 1 / ( totalTime * 2 - ( accelTime + decelTime ) );
time = 0;
if ( time < accelTime )
{
halfRate = timeFactor / accelTime;
while ( time < accelTime )
{
fraction = halfRate * time * time;
self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
wait 0.05;
time += 0.05;
}
}
while ( time < totalTime - decelTime )
{
fraction = timeFactor * ( 2 * time - accelTime );
self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
wait 0.05;
time += 0.05;
}
time = totalTime - time;
if ( time > 0 )
{
halfRate = timeFactor / decelTime;
while ( time > 0 )
{
fraction = 1 - halfRate * time * time;
self setLightColor( vectorlerp( startColor, targetColor, fraction ) );
wait 0.05;
time -= 0.05;
}
}
self setLightColor( targetColor );
}
television()
{
thread tv_changes_intensity();
thread tv_changes_color();
}
tv_changes_intensity()
{
self endon( "light_off" );
full = self getLightIntensity();
old_intensity = full;
for ( ;; )
{
intensity = randomfloatrange( full * 0.7, full * 1.2 );
timer = randomfloatrange( 0.3, 1.2 );
timer *= 20;
for ( i = 0; i < timer; i++ )
{
new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
self setLightIntensity( new_intensity );
wait( 0.05 );
}
old_intensity = intensity;
}
}
tv_changes_color()
{
self endon( "light_off" );
range = 0.5;
base = 0.5;
rgb = [];
old_rgb = [];
for ( i = 0; i < 3; i++ )
{
rgb[ i ] = 0;
old_rgb[ i ] = 0;
}
for ( ;; )
{
for ( i = 0; i < rgb.size; i++ )
{
old_rgb[ i ] = rgb[ i ];
rgb[ i ] = randomfloat( range ) + base;
}
timer = randomfloatrange( 0.3, 1.2 );
timer *= 20;
for ( i = 0; i < timer; i++ )
{
new_rgb = [];
for ( p = 0; p < rgb.size; p++ )
{
new_rgb[ p ] = rgb[ p ] * ( i / timer ) + old_rgb[ p ] * ( ( timer - i ) / timer );
}
self setLightColor( ( new_rgb[ 0 ], new_rgb[ 1 ], new_rgb[ 2 ] ) );
wait( 0.05 );
}
}
}
sun_shadow_trigger( trigger )
{
duration = 1;
if ( IsDefined( trigger.script_duration ) )
duration = trigger.script_duration;
while ( true )
{
trigger waittill( "trigger", other );
trigger set_sun_shadow_params( duration );
}
}
set_sun_shadow_params( duration )
{
}
lerp_sunsamplesizenear_overtime( value, time )
{
level notify( "changing_sunsamplesizenear" );
level endon( "changing_sunsamplesizenear" );
old_value = GetDvarFloat( "sm_sunSampleSizeNear", .25 );
if ( value == old_value )
return;
diff = value - old_value;
times = time/0.05;
if ( times > 0 )
{
d = diff / times;
v = old_value;
for ( i=0; i<times; i++ )
{
v = v + d;
SetSavedDvar( "sm_sunSampleSizeNear", v );
wait( 0.05 );
}
}
SetSavedDvar( "sm_sunSampleSizeNear", value );
}
