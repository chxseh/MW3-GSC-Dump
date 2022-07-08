#include maps\_utility_code;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
SM_init()
{
assert(IsDefined(level._audio));
level._audio.stream = spawnstruct();
level._audio.stream.music = spawnstruct();
level._audio.stream.music.curr = SMx_create_struct();
level._audio.stream.music.prev = SMx_create_struct();
level._audio.stream.ambience = spawnstruct();
level._audio.stream.ambience.curr = SMx_create_struct();
level._audio.stream.ambience.prev = SMx_create_struct();
}
SM_start_preset(alias, fade_, priority_, interrupt_fade_, volscale_)
{
assert(IsDefined(alias));
fadetime = 1.0;
if (IsDefined(fade_))
{
fadetime = max(fade_, 0);
}
volscale = 1.0;
if (IsDefined(volscale_))
{
volscale = max(volscale_, 0);
}
SMx_set_values_for_struct(level._audio.stream.ambience.prev, level._audio.stream.ambience.curr.name, level._audio.stream.ambience.curr.vol, level._audio.stream.ambience.curr.fade);
SMx_set_values_for_struct(level._audio.stream.ambience.curr, alias, volscale, fadetime);
ambientplay(alias, fadetime, volscale);
}
SM_start_music(alias, fade_in_time_, cross_fade_out_time_, volscale_, prev_alias)
{
assert(IsDefined(alias));
fadetime = 1.0;
if (IsDefined(fade_in_time_))
{
fadetime = max(fade_in_time_, 0);
}
fadeouttime = 1.0;
if (IsDefined(cross_fade_out_time_))
{
fadeouttime = cross_fade_out_time_;
}
volscale = 1.0;
if (IsDefined(volscale_))
{
volscale = max(volscale_, 0);
}
SMx_set_values_for_struct(level._audio.stream.music.prev, level._audio.stream.music.curr.name, level._audio.stream.music.curr.vol, level._audio.stream.music.curr.fade);
SMx_set_values_for_struct(level._audio.stream.music.curr, alias, volscale, fadetime);
if (IsDefined(prev_alias))
{
musicstop(fadeouttime, prev_alias);
musicplay(alias, fadetime, volscale, false);
}
else
{
musicplay(alias, fadetime, volscale);
}
}
SM_stop_ambient_alias(alias, fade_)
{
assert(IsDefined(alias));
if (alias != "none")
{
fade = 1.0;
if (IsDefined(fade_))
{
fade = max(fade_, 0);
}
if (level._audio.stream.ambience.curr.name == alias)
{
level._audio.stream.ambience.curr = level._audio.stream.ambience.prev;
SMx_clear_struct(level._audio.stream.ambience.prev);
}
else if (level._audio.stream.ambience.prev.name == alias)
{
SMx_clear_struct(level._audio.stream.ambience.prev);
}
ambientstop(fade, alias);
}
}
SM_stop_music_alias(alias, fade_)
{
assert(IsDefined(alias));
fade = 1.0;
if (IsDefined(fade_))
{
fade = max(fade_, 0);
}
if (level._audio.stream.music.curr.name == alias)
{
level._audio.stream.music.curr = level._audio.stream.music.prev;
SMx_clear_struct(level._audio.stream.music.prev);
}
else if (level._audio.stream.ambience.prev.name == alias)
{
SMx_clear_struct(level._audio.stream.music.prev);
}
musicstop(fade, alias);
}
SM_stop_ambience(fade_)
{
fade = 1.0;
if (IsDefined(fade_))
fade = fade_;
ambientstop(fade);
}
SM_stop_music(fade_)
{
fade = 1.0;
if (IsDefined(fade_))
fade = fade_;
SMx_clear_struct(level._audio.stream.music.curr);
SMx_clear_struct(level._audio.stream.music.prev);
musicstop(fade);
}
SM_mix_ambience(info_array)
{
assert(IsArray(info_array));
assert(info_array.size <= 2 && info_array.size > 0);
threshold = 0.009;
if (info_array.size == 1)
{
SMx_set_values_for_struct(level._audio.stream.ambience.curr, info_array[0].alias, info_array[0].vol, info_array[0].fade);
}
else if (info_array.size == 2)
{
SMx_set_values_for_struct(level._audio.stream.ambience.prev, info_array[0].alias, info_array[0].vol, info_array[0].fade);
SMx_set_values_for_struct(level._audio.stream.ambience.curr, info_array[1].alias, info_array[1].vol, info_array[1].fade);
}
for (i = 0; i < info_array.size; i++)
{
assert(IsDefined(info_array[i].alias));
assert(IsDefined(info_array[i].vol));
assert(IsDefined(info_array[i].fade));
alias = info_array[i].alias;
vol = max(info_array[i].vol, 0);
fade = clamp(info_array[i].fade, 0, 1);
if (alias != "none")
{
if (vol < threshold)
ambientstop(fade, alias);
else
ambientplay(alias, fade, vol, false);
}
}
}
SM_get_current_ambience_name()
{
return level._audio.stream.ambience.curr.name;
}
SM_get_current_music_name()
{
return level._audio.stream.music.curr.name;
}
SMx_set_values_for_struct(struct, name, vol, fade)
{
struct.name = name;
struct.vol = vol;
struct.fade = fade;
}
SMx_create_struct()
{
struct = spawnstruct();
struct.name = "";
struct.vol = 0.0;
struct.fade = 0.0;
return struct;
}
SMx_clear_struct(input_struct)
{
input_struct.name = "";
input_struct.vol = 0.0;
input_struct.fade = 0.0;
}


