
#include maps\_utility_code;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
createStaticSound( type, unique_name, soundalias, origin, bStartActive )
{
assert( isDefined(type) );
assert( isDefined(unique_name) );
assert( isDefined(soundalias) );
assert( isDefined(origin) );
assertEx( type != "looping" || type != "oneshot", "createStaticSound() type is not looping or oneshot" );
if ( !isDefined( level.static_sounds ) )
level.static_sounds = [];
bActive = true;
if (isDefined(bStartActive))
bActive = bStartActive;
ent = spawnStruct();
level.static_sounds[ level.static_sounds.size ] = ent;
ent.audio_properties = [];
ent.audio_properties[ "type" ] = type;
ent.audio_properties[ "targetname" ] = unique_name;
ent.audio_properties[ "active" ] = bActive;
ent.audio_properties[ "playing" ] = false;
ent.audio_properties[ "soundalias" ] = soundalias;
ent.audio_properties[ "origin" ] = origin;
ent.audio_properties[ "angles" ] = undefined;
ent.audio_properties[ "delay_min" ] = undefined;
ent.audio_properties[ "delay_max" ] = undefined;
ent.drawn = true;
return ent;
}
addStaticSoundLoop( unique_name, soundalias, origin, bStartActive )
{
assert( isDefined(unique_name) );
assert( isDefined(soundalias) );
assert( isDefined(origin) );
ent = createStaticSound( "looping", unique_name, soundalias, origin, bStartActive );
return ent;
}
addStaticSoundOneShot( unique_name, soundalias, origin, delay_min, delay_max, bStartActive )
{
assert( isDefined(unique_name) );
assert( isDefined(soundalias) );
assert( isDefined(origin) );
assert( isDefined(delay_min) );
assert( isDefined(delay_max) );
ent = createStaticSound( "oneshot", unique_name, soundalias, origin, bStartActive );
ent.audio_properties[ "delay_min" ] = delay_min;
ent.audio_properties[ "delay_max" ] = delay_max;
return ent;
}
playStaticSoundLoop()
{
soundalias = self.audio_properties[ "soundalias" ];
origin = self.audio_properties[ "origin" ];
self.audio_properties[ "active" ] = true;
if (self.audio_properties[ "active" ] == true && self.audio_properties[ "playing" ] == false)
{
ent = Spawn( "script_origin", origin );
self.entity = ent;
self.audio_properties[ "playing" ] = true;
self.entity PlayLoopSound( soundalias );
self.entity willNeverChange();
}
}
playStaticSoundOneShot()
{
soundalias = self.audio_properties[ "soundalias" ];
origin = self.audio_properties[ "origin" ];
delay_min = self.audio_properties[ "delay_min" ];
delay_max = self.audio_properties[ "delay_max" ];
self.audio_properties[ "active" ] = true;
while(self.audio_properties[ "active" ])
{
wait( randomFloatRange( delay_min, delay_max ) );
if (self.audio_properties[ "active" ])
{
test_entity = self.entity;
if (!isDefined(test_entity))
{
ent = Spawn( "script_origin", origin );
self.entity = ent;
self.audio_properties[ "playing" ] = true;
self.entity PlaySound( soundalias, "sounddone" );
self.entity waittill( "sounddone" );
self.audio_properties[ "playing" ] = false;
waittillframeend;
self.entity delete();
}
}
}
}
playStaticSound( unique_name, fade_in )
{
fade_time = 0;
if ( isDefined(fade_in) )
{
assert(fade_in >= 0);
fade_time = fade_in;
}
for ( i = 0; i < level.static_sounds.size; i++ )
{
ent = level.static_sounds[ i ];
if (ent.audio_properties[ "targetname" ] == unique_name)
{
continue;
}
else
{
if ( ent.audio_properties[ "type" ] == "looping" )
{
ent thread playStaticSoundLoop();
continue;
}
if ( ent.audio_properties[ "type" ] == "oneshot" )
{
ent thread playStaticSoundOneShot();
continue;
}
if (fade_time > 0)
{
ent.entity ScaleVolume(0.0);
ent.entity ScaleVolume(1.0, fade_time);
wait (fade_time);
waittillframeend;
}
}
}
}
stopStaticSound( unique_name, fade_out )
{
fade_time = 0;
if ( isDefined(fade_out) )
{
assert(fade_out >= 0);
fade_time = fade_out;
}
for ( i = 0; i < level.static_sounds.size; i++ )
{
ent = level.static_sounds[ i ];
if (ent.audio_properties[ "targetname" ] != unique_name)
{
continue;
}
else
{
if (fade_time > 0)
{
ent.entity ScaleVolume(0.0, fade_time);
wait (fade_time);
waittillframeend;
}
ent.audio_properties[ "active" ] = false;
ent.audio_properties[ "playing" ] = false;
if ( ent.audio_properties[ "type" ] == "looping" )
{
ent.entity StopLoopSound();
waittillframeend;
ent.entity Delete();
continue;
}
if ( ent.audio_properties[ "type" ] == "oneshot" )
{
continue;
}
}
}
}
debugDrawStaticSounds()
{
if ( GetDvar( "snd_staticDebug" ) == "" )
SetDevDvar( "snd_staticDebug", "0" );
}
initStaticSounds()
{
if ( !isDefined( level.static_sounds ) )
level.static_sounds = [];
thread debugDrawStaticSounds();
for ( i = 0; i < level.static_sounds.size; i++ )
{
ent = level.static_sounds[ i ];
if ( ent.audio_properties[ "active" ] == true )
{
if ( ent.audio_properties[ "type" ] == "looping" )
ent thread playStaticSoundLoop();
if ( ent.audio_properties[ "type" ] == "oneshot" )
ent thread playStaticSoundOneShot();
}
}
}