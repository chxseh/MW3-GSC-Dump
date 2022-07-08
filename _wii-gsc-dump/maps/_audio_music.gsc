#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#include maps\_audio_stream_manager;
#include maps\_audio_mix_manager;
#include maps\_audio_presets_music;
MUS_init()
{
if (!IsDefined(level._audio))
{
level._audio = SpawnStruct();
}
level._audio.music = SpawnStruct();
level._audio.music.cue_cash = [];
level._audio.music.curr_cue_name = "";
level._audio.music.prev_cue_name = "";
level._audio.music.enable_auto_mix = false;
level._audio.music.env_threat_to_vol	= [
[0.0, 0.5],
[0.9, 1.0],
[1.0, 1.0]
];
thread MUSx_monitor_game_vars();
}
MUS_play(alias, fade_in_time_, cross_fade_out_time_, volume_, forceplay_)
{
stop_adaptive_music_ = undefined;
curr_cue = MUS_get_playing_cue_preset();
new_cue = MUSx_construct_cue(alias);
fade_in_time = new_cue["fade_in_time"];
if (IsDefined(fade_in_time_))
{
fade_in_time = fade_in_time_;
}
cross_fade_out_time = 2.0;
if (IsDefined(curr_cue))
{
if (IsDefined(cross_fade_out_time_))
{
cross_fade_out_time = cross_fade_out_time_;
}
else if (IsDefined(fade_in_time_))
{
cross_fade_out_time = fade_in_time_;
}
else if (IsDefined(curr_cue["fade_out_time"]))
{
cross_fade_out_time = curr_cue["fade_out_time"];
}
}
volume = new_cue["volume"];
if (IsDefined(volume_))
{
volume = volume_;
}
MUSx_start_cue(new_cue["name"], fade_in_time, cross_fade_out_time, volume, forceplay_);
}
MUS_stop(fade_out_time_)
{
fade_out_time = 3.0;
if (MUS_is_playing())
{
cue = MUSx_get_cashed_cue(level._audio.music.curr_cue_name);
fade_out_time = cue["fade_out_time"];
}
if (IsDefined(fade_out_time_))
{
fade_out_time = fade_out_time_;
}
MUSx_stop_all_music(fade_out_time);
}
MUS_is_playing()
{
assert(IsDefined(level._audio) && IsDefined(level._audio.music));
return IsDefined(level._audio.music.curr_cue_name) && level._audio.music.curr_cue_name != "";
}
MUS_get_playing_cue_preset()
{
cue_preset = undefined;
assert(IsDefined(level._audio) && IsDefined(level._audio.music));
if (MUS_is_playing())
{
assert(IsDefined(level._audio.music.curr_cue_name));
cue_preset = MUSx_get_cashed_cue(level._audio.music.curr_cue_name);
}
return cue_preset;
}
MUSx_construct_cue(name)
{
assert(IsDefined(name));
result = MUSx_get_cashed_cue(name);
if (!IsDefined(result))
{
result = [];
result["alias"] = name;
result["volume"] = 1.0;
result["fade_in_time"]	= 1.5;
result["fade_out_time"]	= 1.5;
result["auto_mix"] = false;
result["name"] = name;
MUSx_cash_cue(result);
}
return result;
}
MUSx_start_cue(new_cue_name, fade_in_time, cross_fade_out_time, volume, forceplay_)
{
assert(IsDefined(new_cue_name) && IsString(new_cue_name));
assert(IsDefined(fade_in_time));
assert(IsDefined(cross_fade_out_time));
forceplay = false;
if (IsDefined(forceplay_))
forceplay = forceplay_;
if (new_cue_name == level._audio.music.curr_cue_name && !forceplay)
{
return;
}
else
{
prev_cue_name	= level._audio.music.prev_cue_name;
curr_cue_name	= level._audio.music.curr_cue_name;
level._audio.music.prev_cue_name	= level._audio.music.curr_cue_name;
level._audio.music.curr_cue_name	= new_cue_name;
new_cue = MUSx_get_cashed_cue(level._audio.music.curr_cue_name);
prev_cue = MUSx_get_cashed_cue(level._audio.music.prev_cue_name);
prev_cue_alias = undefined;
if (IsDefined(prev_cue))
{
prev_cue_alias = prev_cue["alias"];
}
SM_start_music(new_cue["alias"], fade_in_time, cross_fade_out_time, volume, prev_cue_alias);
}
}
MUSx_stop_all_music(fade_time)
{
assert(IsDefined(fade_time));
SM_stop_music(fade_time);
}
MUSx_get_auto_mix()
{
return level._audio.music.enable_auto_mix;
}
MUSx_get_cashed_cue(cue_name)
{
return level._audio.music.cue_cash[cue_name];
}
MUSx_cash_cue(cue_preset)
{
level._audio.music.cue_cash[cue_preset["name"]] = cue_preset;
}
MUSx_monitor_game_vars()
{
if (MUSx_get_auto_mix())
{
CONST_updatePeriod = 1.0;
while (1)
{
wait(CONST_updatePeriod);
if (MUSx_get_auto_mix())
{
threat_level = aud_get_threat_level();
mus_scalar = aud_map(threat_level, level._audio.music.env_threat_to_vol);
}
}
}
}





