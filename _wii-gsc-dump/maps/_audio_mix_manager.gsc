#include maps\_audio;
MM_init()
{
if (!IsDefined(level._audio))
{
level._audio = SpawnStruct();
}
if (!IsDefined(level._audio.mix))
{
level._audio.mix = SpawnStruct();
}
MMx_init_volmods();
level._audio.mix.use_string_table_presets = false;
level._audio.mix.use_iw_presets = false;
level._audio.mix.blending = false;
level._audio.mix.debug_mix_mode = false;
max_messages = 10;
thread MMx_mix_server_throttler(max_messages);
thread MMx_volmod_server_throttler(max_messages);
level._audio.mix.curr_preset = "";
level._audio.mix.prev_preset = "";
level._audio.mix.sticky_submixes = [];
if (!IsDefined(level._audio.volmod_submixes))
level._audio.volmod_submixes = [];
level._audio.mix.volmod_submixblends = [];
level._audio.mix.preset_cache = [];
level._audio.mix.changed_presets = [];
level._audio.mix.headroom = 0.85;
level._audio.mix.blend_value = 0;
level._audio.mix.blend_name = "";
thread MMx_update_mix_thread();
waittillframeend;
thread MMx_apply_initial_mix();
}
MM_precache_preset(preset_name)
{
MMx_get_mix_preset(preset_name);
}
MM_set_headroom_mix(preset_name, headroom_value, fade_time_)
{
assert(IsDefined(preset_name));
assert(IsDefined(headroom_value));
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode)
{
fade_time = 1.0;
if (IsDefined(fade_time_))
fade_time = fade_time_;
level._audio.mix.headroom = headroom_value;
preset = MMx_get_mix_preset(preset_name);
if (IsDefined(preset))
{
level._audio.mix.headroom_preset = preset;
MMx_update_mix(fade_time, preset_name);
}
}
}
MM_enabled_debug_mode()
{
level._audio.mix.debug_mix_mode = true;
}
MM_disable_debug_mode()
{
level._audio.mix.debug_mix_mode = false;
}
MM_use_string_table()
{
level._audio.mix.use_string_table_presets = true;
level._audio.mix.use_iw_presets = false;
}
MM_start_preset(preset_name, fade_time_)
{
assert(IsString(preset_name) && preset_name != "");
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode && !level._audio.mix.blending)
{
assert(IsString(preset_name));
assert(IsDefined(level._audio.mix.curr_preset));
if (preset_name != level._audio.mix.curr_preset)
{
MMx_clear_submixes(false);
MMx_set_mix(preset_name, fade_time_);
}
}
}
MM_start_zone_preset(preset_name)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode && !level._audio.mix.blending)
{
assert(IsString(preset_name));
preset = MMx_get_mix_preset(preset_name);
if (!IsDefined(preset))
{
return;
}
if (IsDefined(level._audio.mix.volmod_submixes["zone_mix"]))
{
foreach(channel_name, value in level._audio.mix.volmod_submixes["zone_mix"])
{
if (channel_name != "fade_time" && channel_name != "preset_name")
{
level._audio.mix.volmod_submixes["zone_mix"][channel_name].current_volume = 1.0;
}
}
}
else
{
level._audio.mix.volmod_submixes["zone_mix"] = [];
}
level._audio.mix.volmod_submixes["zone_mix"]["preset_name"] = preset_name;
foreach(channel_name, value in preset)
{
if (channel_name != "fade_time" && channel_name != "name")
{
level._audio.mix.volmod_submixes["zone_mix"][channel_name] = SpawnStruct();
level._audio.mix.volmod_submixes["zone_mix"][channel_name].current_volume = value;
level._audio.mix.volmod_submixes["zone_mix"][channel_name].original_volume = value;
}
}
fade = 1.0;
if (IsDefined(preset["fade_time"]))
{
fade = preset["fade_time"];
}
MMx_update_mix(fade, "zone_mix");
}
}
MM_clear_zone_mix(fade_)
{
fade = 1.0;
if (IsDefined(fade_))
{
fade = fade_;
}
if (IsDefined(level._audio.mix.volmod_submixes["zone_mix"]))
{
level._audio.mix.volmod_submixes["zone_mix"]["CLEAR"] = true;
MMx_update_mix(fade, "zone_mix");
}
}
MM_clear_submixes(fade_time_)
{
MMx_clear_submixes(true, fade_time_);
}
MM_make_submix_sticky(preset_name)
{
level._audio.mix.sticky_submixes[preset_name] = true;
}
MM_make_submix_unsticky(preset_name)
{
level._audio.mix.sticky_submixes[preset_name] = undefined;
}
MM_add_submix(preset_name, fade_time_, initial_volume_scale_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode && !level._audio.mix.blending)
{
assert(IsString(preset_name));
MMx_set_mix(preset_name, fade_time_, initial_volume_scale_);
}
}
MM_add_submix_blend_to(preset_name, label, blendvalue_, fadetime_)
{
assert(IsString(preset_name));
assert(IsString(label));
if (!IsDefined(level._audio.mix.volmod_submixblends[label]))
{
submixblend = MMx_create_submix_blend(undefined, preset_name, blendvalue_);
if (!IsDefined(submixblend))
{
return;
}
level._audio.mix.volmod_submixblends[label] = submixblend;
MMx_update_mix(fadetime_, preset_name);
}
}
MM_add_submix_blend(preset_name_A, preset_name_B, label, blendvalue_, fadetime_)
{
assert(IsString(preset_name_A));
assert(IsString(preset_name_B));
assert(IsString(label));
if (!IsDefined(level._audio.mix.volmod_submixblends[label]))
{
submixblend = MMx_create_submix_blend(preset_name_A, preset_name_B, blendvalue_);
if (!IsDefined(submixblend))
{
return;
}
level._audio.mix.volmod_submixblends[label] = submixblend;
MMx_update_mix(fadetime_, label);
}
}
MM_set_submix_blend_value(label, blendvalue, fadetime_)
{
assert(IsString(label));
assert(IsDefined(blendvalue));
if (IsDefined(level._audio.mix.volmod_submixblends[label]))
{
assert(IsDefined(level._audio.mix.volmod_submixblends[label].blendvalue));
level._audio.mix.volmod_submixblends[label].blendvalue = clamp(blendvalue, 0, 1);
MMx_update_mix(fadetime_, label);
}
}
MM_clear_submix_blend(label, fadetime_)
{
assert(IsString(label));
if (IsDefined(level._audio.mix.volmod_submixblends[label]))
{
level._audio.mix.volmod_submixblends[label].clear = true;
MMx_update_mix(fadetime_, label);
}
}
MM_scale_submix(preset_name, volume_scale, fade_time_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode && !level._audio.mix.blending)
{
assert(IsString(preset_name));
assert(IsDefined(volume_scale));
assert(IsDefined(level._audio.mix.volmod_submixes));
if (IsDefined(level._audio.mix.volmod_submixes[preset_name]))
{
MMx_scale_submix(preset_name, volume_scale);
}
else
{
MMx_make_new_submix(preset_name, volume_scale);
}
MMx_update_mix(fade_time_, preset_name);
}
}
MM_restore_submix(preset_name, fade_time_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode && !level._audio.mix.blending)
{
assert(IsString(preset_name));
assert(IsDefined(level._audio.mix.volmod_submixes));
if (IsDefined(level._audio.mix.volmod_submixes[preset_name]))
{
level._audio.mix.volmod_submixes[preset_name].current_volume = level._audio.mix.volmod_submixes[preset_name].original_volume;
MMx_update_mix(fade_time_, preset_name);
}
}
}
MM_clear_submix(preset_name, fade_time_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode && !level._audio.mix.blending)
{
assert(IsString(preset_name));
if(preset_name == "default")
return;
assert(IsDefined(level._audio.mix.volmod_submixes));
if (!IsDefined(level._audio.mix.sticky_submixes[preset_name]) && IsDefined(level._audio.mix.volmod_submixes[preset_name]))
{
level._audio.mix.volmod_submixes[preset_name]["CLEAR"] = true;
MMx_update_mix(fade_time_, preset_name);
}
}
}
MM_get_applied_preset_name()
{
return level._audio.mix.curr_preset;
}
MM_add_dynamic_volmod_submix(submixname, channels, fade_time_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode)
{
assertEx(IsString(submixname), "MM_add_dynamic_submix: must give a submixname.");
assertEx(IsArray(channels), "MM_add_dynamic_submix: must give an array of channelnames-volume pairs.");
assertEx(aud_is_even(channels.size), "MM_add_dynamic_submix: must give array of channelnames-volume pairs.");
if (IsDefined(level._audio.mix.volmod_submixes[submixname]))
{
return;
}
assert(!IsDefined(level._audio.mix.volmod_submixes[submixname]));
level._audio.mix.volmod_submixes[submixname] = [];
count = 0;
channel_name = undefined;
foreach(value in channels)
{
if (aud_is_even(count))
{
assert(!IsDefined(channel_name));
assertEx(IsString(value), "MM_add_dynamic_submix: must give array of channelnames-volume pairs. " + value + " is an invalid channel name.");
channel_name = value;
}
else
{
assert(IsDefined(channel_name));
if (!MMx_is_volmod_channel(channel_name))
{
level._audio.mix.volmod_submixes[submixname] = undefined;
return;
}
level._audio.mix.volmod_submixes[submixname][channel_name] = spawnstruct();
level._audio.mix.volmod_submixes[submixname][channel_name].current_volume = value;
level._audio.mix.volmod_submixes[submixname][channel_name].original_volume = value;
channel_name = undefined;
}
count++;
}
MMx_update_mix(fade_time_, submixname);
}
}
MM_add_dynamic_submix(submixname, volmods, fade_time_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode)
{
assertEx(IsString(submixname), "MM_add_dynamic_submix: must give a submixname.");
assertEx(IsArray(volmods), "MM_add_dynamic_submix: must give an array of volmodname-volume pairs.");
assertEx(aud_is_even(volmods.size), "MM_add_dynamic_submix: must give array of volmodname-volume pairs.");
assert(!IsDefined(level._audio.mix.volmod_submixes[submixname]));
level._audio.mix.volmod_submixes[submixname] = [];
count = 0;
channel_name = undefined;
foreach(volmod in volmods)
{
if (aud_is_even(count))
{
assert(!IsDefined(channel_name));
assertEx(IsString(volmod), "MM_add_dynamic_submix: must give array of volmod-volume pairs. " + volmod + " is an invalid volmod name.");
channel_name = volmod;
}
else
{
assert(IsDefined(channel_name));
level._audio.mix.volmod_submixes[submixname][channel_name] = spawnstruct();
level._audio.mix.volmod_submixes[submixname][channel_name].current_volume = volmod;
level._audio.mix.volmod_submixes[submixname][channel_name].original_volume = volmod;
channel_name = undefined;
}
count++;
}
MMx_update_mix(fade_time_, submixname);
}
}
MM_does_volmod_submix_exist(submixname)
{
return IsDefined(level._audio.mix.volmod_submixes[submixname]);
}
MM_mute_volmods(channels, fade_time_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode)
{
level._audio.mix.volmod_submixes["mm_mute"] = [];
if (IsString(channels))
{
if (!IsDefined(level._audio.mix.volmod_submixes["mm_mute"][channels]))
{
level._audio.mix.volmod_submixes["mm_mute"][channels] = spawnstruct();
}
level._audio.mix.volmod_submixes["mm_mute"][channels].current_volume = 0.0;
level._audio.mix.volmod_submixes["mm_mute"][channels].original_volume = 1.0;
}
else
{
assert(IsArray(channels));
foreach(channel in channels)
{
if (!IsDefined(level._audio.mix.volmod_submixes["mm_mute"][channel]))
{
level._audio.mix.volmod_submixes["mm_mute"][channel] = spawnstruct();
}
level._audio.mix.volmod_submixes["mm_mute"][channel].current_volume = 0.0;
level._audio.mix.volmod_submixes["mm_mute"][channel].original_volume = 1.0;
}
}
MMx_update_mix(fade_time_, "mm_mute");
}
}
MM_clear_volmod_mute_mix(fade_time_)
{
if (IsDefined(level._audio.volmod_submixes["mm_mute"]))
{
level._audio.volmod_submixes["mm_mute"] = undefined;
MMx_update_mix(fade_time_, "mm_mute");
}
}
MM_solo_volmods(channels, fade_time_)
{
assert(IsDefined(level._audio.mix.debug_mix_mode));
if (!level._audio.mix.debug_mix_mode)
{
level._audio.mix.volmod_submixes["mm_solo"] = [];
foreach(channel_name, _ in level._audio.mix.volmod_vals)
{
level._audio.mix.volmod_submixes["mm_solo"][channel_name] = spawnstruct();
level._audio.mix.volmod_submixes["mm_solo"][channel_name].current_volume = 0.0;
level._audio.mix.volmod_submixes["mm_solo"][channel_name].original_volume = 1.0;
}
if (IsString(channels))
{
level._audio.mix.volmod_submixes["mm_solo"][channels].current_volume = 1.0;
}
else
{
assert(IsArray(channels));
foreach(channel in channels)
{
level._audio.mix.volmod_submixes["mm_solo"][channel].current_volume = 1.0;
}
}
MMx_update_mix(fade_time_, "mm_solo");
}
}
MM_clear_solo_volmods(fade_time_)
{
if (IsDefined(level._audio.mix.volmod_submixes["mm_solo"]))
{
level._audio.mix.volmod_submixes["mm_solo"] = undefined;
MMx_update_mix(fade_time_, "mm_solo");
}
}
MM_get_channel_names()
{
assert(IsDefined(level._audio) && IsDefined(level._audio.mix));
return level._audio.mix.channel_names;
}
MM_get_num_volmod_submixes()
{
return level._audio.mix.volmod_submixes.size;
}
MM_get_num_submixes()
{
return 0;
}
MM_get_volmod_submix_name_by_index(index)
{
assert(IsDefined(index) && index >= 0);
result = undefined;
if (IsDefined(level._audio.mix.volmod_submixes) && index < level._audio.mix.volmod_submixes.size)
{
count = 0;
foreach( volmod_submix_name, volmod_submix in level._audio.mix.volmod_submixes)
{
if (volmod_submix.size > 0)
{
if (count == index)
{
if (volmod_submix_name == "zone_mix")
{
assert(IsDefined(level._audio.mix.volmod_submixes["zone_mix"]));
real_name = level._audio.mix.volmod_submixes["zone_mix"]["preset_name"];
volmod_submix_name = "zone_mix : " + real_name;
}
result = volmod_submix_name;
break;
}
count++;
}
}
}
return result;
}
MM_get_volmod_submix_by_name(name)
{
assert(IsString(name));
result = undefined;
if (GetSubStr(name, 0, 8) == "zone_mix")
name = "zone_mix";
if (IsDefined(level._audio.mix.volmod_submixes) && IsDefined(level._audio.mix.volmod_submixes[name]))
{
if (level._audio.mix.volmod_submixes[name].size > 0)
result = level._audio.mix.volmod_submixes[name];
}
return result;
}
MM_set_default_volmod(volmod_name, val, fade_time_)
{
assert(IsString(volmod_name));
assert(IsDefined(val));
assert(IsDefined(level._audio.mix.volmod_submixes));
val = clamp(val, 0, 1);
if (IsDefined(level._audio.mix.volmod_submixes["default"]))
{
if (IsDefined(level._audio.mix.volmod_submixes["default"][volmod_name]))
{
level._audio.mix.volmod_submixes["default"][volmod_name].current_volume = val;
MMx_update_mix(fade_time_, "default");
}
else
{
aud_print_error("Trying to set a volmod value on the default submix but the volmod doesn't exist: " + volmod_name);
}
}
else
{
aud_print_error("Trying to set a volmod value on the default submix but \"default\" doesn't exist.");
}
}
MM_get_original_default_volmod(volmod_name)
{
result = undefined;
assert(IsString(volmod_name));
assert(IsDefined(level._audio.mix.volmod_submixes));
if (IsDefined(level._audio.mix.volmod_submixes["default"]))
{
if (IsDefined(level._audio.mix.volmod_submixes["default"][volmod_name]))
{
result = level._audio.mix.volmod_submixes["default"][volmod_name].original_volume;
}
else
{
aud_print_error("Trying to set a volmod value on the default submix but the volmod doesn't exist: " + volmod_name);
}
}
else
{
aud_print_error("Trying to set a volmod value on the default submix but \"default\" doesn't exist.");
}
return result;
}
MM_restore_original_default_volmod(volmod_name, fade_time_)
{
original_value = MM_get_original_default_volmod(volmod_name);
if (IsDefined(original_value))
{
MM_set_default_volmod(volmod_name, original_value, fade_time_);
}
}
MMx_set_mix(preset_name, fade_time_, initial_volume_scale_)
{
MMx_make_new_submix(preset_name, initial_volume_scale_);
level._audio.mix.prev_preset = level._audio.mix.curr_preset;
level._audio.mix.curr_preset = preset_name;
MMx_update_mix(fade_time_, preset_name);
}
MMx_scale_submix(preset_name, volume_scale)
{
assert(IsString(preset_name));
assert(IsDefined(volume_scale));
if (IsDefined(level._audio.mix.volmod_submixes[preset_name]))
{
foreach(channel_name, channel_info in level._audio.mix.volmod_submixes[preset_name])
{
level._audio.mix.volmod_submixes[preset_name][channel_name].current_volume = channel_info.original_volume * volume_scale;
}
}
}
MMx_make_new_submix(preset_name, volume_scale_)
{
assert(IsString(preset_name));
if (preset_name == "default")
{
return;
}
if (!IsDefined(level._audio.mix.volmod_submixes[preset_name]))
{
preset = MMx_get_mix_preset(preset_name);
if (!IsDefined(preset))
return;
volume_scale = 1.0;
if (IsDefined(volume_scale_))
{
volume_scale = volume_scale_;
volume_scale = max(volume_scale, 0.0);
}
level._audio.mix.volmod_submixes[preset_name] = [];
foreach(channel_name, value in preset)
{
if (channel_name != "name" && channel_name != "fade_time")
{
level._audio.mix.volmod_submixes[preset_name][channel_name] = spawnstruct();
level._audio.mix.volmod_submixes[preset_name][channel_name].current_volume = value * volume_scale;
level._audio.mix.volmod_submixes[preset_name][channel_name].original_volume = value;
}
}
}
}
MMx_create_submix_blend(preset_name_A, preset_name_B, blendvalue_)
{
assert(IsString(preset_name_B));
blendvalue = 0;
if (IsDefined(blendvalue_))
blendvalue = clamp(blendvalue_, 0, 1);
submixblend = spawnstruct();
presetB = MMx_get_mix_preset(preset_name_B);
if (!IsDefined(presetB))
{
return;
}
submixblend.presetB = presetB;
submixblend.presetB["fade_time"] = undefined;
submixblend.presetB["name"] = undefined;
if (IsDefined(preset_name_A))
{
presetA = MMx_get_mix_preset(preset_name_A);
if (!IsDefined(presetA))
return;
submixblend.presetA = presetA;
assert(IsDefined(submixblend.presetA));
submixblend.presetA["fade_time"] = undefined;
submixblend.presetA["name"] = undefined;
}
else
{
submixblend.presetA = [];
foreach( channel_name, value in submixblend.presetB)
submixblend.presetA[channel_name] = 1.0;
}
submixblend.blendvalue = blendvalue;
return submixblend;
}
MMx_clear_submixes(update_, fade_time_)
{
update = true;
if (IsDefined(update_))
{
update = update_;
}
foreach(submix_name, submix in level._audio.mix.volmod_submixes)
{
if (submix_name != "default"
&& submix_name != "zone_mix"
&& !IsDefined(level._audio.mix.sticky_submixes[submix_name])
&& submix_name != "mm_solo"
&& submix_name != "mm_mute" )
{
level._audio.mix.volmod_submixes[submix_name]["CLEAR"] = true;
level._audio.mix.changed_presets[submix_name] = true;
}
}
if (update)
{
MMx_update_mix(fade_time_, undefined);
}
}
MMx_update_mix(fade_time_, preset_name)
{
level._audio.mix.last_fade_time = fade_time_;
if (IsDefined(preset_name))
{
level._audio.mix.changed_presets[preset_name] = true;
}
level notify("mix_update");
}
MMx_update_mix_thread()
{
level waittill("mix_update");
while(true)
{
waittillframeend;
fade_time = 0;
if (IsDefined(level._audio.mix.last_fade_time))
{
fade_time = level._audio.mix.last_fade_time;
}
MMx_update_volmod_groups(fade_time);
assert(level._audio.mix.changed_presets.size == 0);
level waittill("mix_update");
}
}
MMx_mix_in_non_changed_submixes()
{
assert(IsDefined(level._audio.mix.volume_products));
assert(IsDefined(level._audio.mix.volmod_submixes));
not_changed_submixes = [];
foreach(submix_name, submix in level._audio.mix.volmod_submixes)
{
if (!IsDefined(level._audio.mix.changed_presets[submix_name]))
{
not_changed_submixes[submix_name] = true;
}
}
foreach(volmod_name, v1 in level._audio.mix.volume_products)
{
foreach(submix_name, v2 in not_changed_submixes)
{
if (IsDefined(level._audio.mix.volmod_submixes[submix_name][volmod_name]))
{
level._audio.mix.volume_products[volmod_name] *= level._audio.mix.volmod_submixes[submix_name][volmod_name].current_volume;
}
}
}
}
MMx_update_volmod_groups(fade_time_)
{
assert(IsDefined(level._audio.mix));
assert(IsArray(level._audio.mix.volmod_submixes));
assert(IsDefined(level._audio.mix.headroom));
fade_time = 1.0;
if (IsDefined(fade_time_))
{
fade_time = fade_time_;
fade_time = max(fade_time, 0.0);
}
level._audio.mix.volume_products = undefined;
MMx_set_volume_products_volmods(false);
assert(IsDefined(level._audio.mix.volume_products));
MMx_mix_in_non_changed_submixes();
has_changed = false;
foreach(volmod, volume in level._audio.mix.volume_products)
{
if (volmod != "voiceover_critical" && volmod != "fullvolume")
{
volume *= level._audio.mix.headroom;
}
if (volume != level._audio.mix.volmod_vals[volmod].volume)
{
has_changed = true;
level._audio.mix.volmod_vals[volmod].volume = volume;
level._audio.mix.volmod_vals[volmod].fade_time = fade_time;
MMx_volmod_setting_enqueue(volmod, volume, fade_time);
}
}
level._audio.mix.changed_presets = [];
if (has_changed)
{
level notify("aud_new_volmod_set");
}
}
MMx_set_volume_products_volmods(except_default)
{
assert(IsDefined(except_default));
assert(!IsDefined(level._audio.mix.volume_products));
assert(IsDefined(level._audio.mix.changed_presets));
level._audio.mix.volume_products = [];
submixblendproducts = [];
foreach(submix_name, _ in level._audio.mix.changed_presets)
{
if (IsDefined(level._audio.mix.volmod_submixes[submix_name]))
{
submix = level._audio.mix.volmod_submixes[submix_name];
submix["name"] = undefined;
submix["fade_time"] = undefined;
submix["preset_name"] = undefined;
is_cleared = false;
if (IsDefined(submix["CLEAR"]))
is_cleared = true;
submix["CLEAR"] = undefined;
foreach(channel_name, channel_info in submix)
{
if (IsDefined(level._audio.mix.volume_products[channel_name]) && !is_cleared)
{
level._audio.mix.volume_products[channel_name] *= channel_info.current_volume;
}
else if (is_cleared && !IsDefined(level._audio.mix.volume_products[channel_name]))
{
level._audio.mix.volume_products[channel_name] = 1.0;
}
else if (!is_cleared)
{
level._audio.mix.volume_products[channel_name] = channel_info.current_volume;
}
}
if (is_cleared)
level._audio.mix.volmod_submixes[submix_name] = undefined;
}
else if (IsDefined(level._audio.mix.volmod_submixblends[submix_name]))
{
submixblend = level._audio.mix.volmod_submixblends[submix_name];
is_cleared = false;
if (IsDefined(submixblend.clear))
{
is_cleared = true;
}
foreach( channel_name, value in submixblend.presetA )
{
if (!IsDefined(submixblendproducts[channel_name]))
{
submixblendproducts[channel_name] = 1.0;
}
assert(IsDefined(submixblend.presetB[channel_name]));
if (!is_cleared)
{
valB = submixblend.presetB[channel_name];
valA = submixblend.presetA[channel_name];
blend = submixblend.blendvalue;
assert(valA >= 0.0);
assert(valB >= 0.0);
assert(blend >= 0.0 && blend <= 1.0);
blendresult = blend * ( valB - valA ) + valA;
assert(blendresult >= 0.0);
submixblendproducts[channel_name] *= blendresult;
}
}
if (is_cleared)
level._audio.mix.volmod_submixblends[submix_name] = undefined;
}
}
foreach( channel, value in submixblendproducts)
{
if (IsDefined(level._audio.mix.volume_products[channel]))
{
level._audio.mix.volume_products[channel] *= value;
}
else
level._audio.mix.volume_products[channel] = value;
}
}
MMx_apply_initial_mix()
{
debug_mix = undefined;
debug_submix = undefined;
}
MMx_apply_debug_mix(debug_mix)
{
if (level._audio.mix.debug_mix_mode)
{
while (!IsDefined(level.player))
{
wait(0.05);
}
assert(IsString(debug_mix));
MMx_set_mix(debug_mix);
}
}
MMx_volmod_setting_enqueue(volmod_name, volume, fade_time)
{
assert(IsDefined(volmod_name));
assert(IsDefined(volume));
assert(IsDefined(fade_time));
if (!IsDefined(level._audio.mix.volmod_queue))
{
level._audio.mix.volmod_queue = [];
level._audio.mix.volmod_index = 0;
}
already_queued = false;
foreach(key, value in level._audio.mix.volmod_queue)
{
if (value["volmod"] == volmod_name)
{
already_queued = true;
level._audio.mix.volmod_queue[key]["volume"] = volume;
level._audio.mix.volmod_queue[key]["fade_time"] = fade_time;
break;
}
}
if (!already_queued)
{
new_mix_queue = [];
new_mix_queue["volmod"] = volmod_name;
new_mix_queue["volume"] = volume;
new_mix_queue["fade_time"] = fade_time;
level._audio.mix.volmod_queue[level._audio.mix.volmod_index] = new_mix_queue;
level._audio.mix.volmod_index++;
}
}
MMx_mix_setting_enqueue(channel, volume, fade_time)
{
assert(IsDefined(channel));
assert(IsDefined(volume));
assert(IsDefined(fade_time));
if (!IsDefined(level._audio.mix.queue))
{
level._audio.mix.queue = [];
level._audio.mix.index = 0;
}
channel_already_queued = false;
foreach(key, value in level._audio.mix.queue)
{
if (value["channel"] == channel)
{
channel_already_queued = true;
level._audio.mix.queue[key]["volume"] = volume;
level._audio.mix.queue[key]["fade_time"] = fade_time;
break;
}
}
if (!channel_already_queued)
{
new_mix_queue = [];
new_mix_queue["channel"] = channel;
new_mix_queue["volume"] = volume;
new_mix_queue["fade_time"] = fade_time;
level._audio.mix.queue[level._audio.mix.index] = new_mix_queue;
level._audio.mix.index++;
}
}
MMx_volmod_server_throttler(max_count_)
{
if (!IsDefined(level._audio.mix.volmod_queue))
{
level._audio.mix.volmod_queue = [];
level._audio.mix.volmod_index = 0;
}
max_count = 5;
if (IsDefined(max_count_))
{
max_count = max_count_;
max_count = max(max_count, 1);
}
while(true)
{
level waittill("aud_new_volmod_set");
assert(IsDefined(level._audio.mix.volmod_queue));
while(level._audio.mix.volmod_queue.size > 0)
{
mix_message_count = 0;
keys_used = [];
foreach( key_index, mix in level._audio.mix.volmod_queue)
{
if (mix_message_count < max_count)
{
mix_message_count++;
keys_used[keys_used.size] = key_index;
mix_setting = level._audio.mix.volmod_queue[key_index];
assert(IsDefined(mix_setting));
assert(IsDefined(mix_setting["volmod"]));
assert(IsDefined(mix_setting["volume"]));
assert(IsDefined(mix_setting["fade_time"]));
channel = mix_setting["volmod"];
volume = mix_setting["volume"];
fade_time = mix_setting["fade_time"];
volume = clamp(volume, 0.0, 1.0);
assert(MMx_is_volmod_channel(channel));
level.player SetVolMod(channel, volume, fade_time);
}
else
{
break;
}
}
for (i = 0; i < keys_used.size; i++)
{
key = keys_used[i];
level._audio.mix.volmod_queue[key] = undefined;
}
wait(0.05);
}
}
}
MMx_mix_server_throttler(max_count_)
{
if (!IsDefined(level._audio.mix.queue))
{
level._audio.mix.queue = [];
level._audio.mix.index = 0;
}
max_count = 5;
if (IsDefined(max_count_))
{
max_count = max_count_;
max_count = max(max_count, 1);
}
while(true)
{
level waittill("aud_new_mix_set");
assert(IsDefined(level._audio.mix.queue));
while(level._audio.mix.queue.size > 0)
{
mix_message_count = 0;
keys_used = [];
foreach( key_index, mix in level._audio.mix.queue)
{
if (mix_message_count < max_count)
{
mix_message_count++;
keys_used[keys_used.size] = key_index;
mix_setting = level._audio.mix.queue[key_index];
assert(IsDefined(mix_setting));
assert(IsDefined(mix_setting["channel"]));
assert(IsDefined(mix_setting["volume"]));
assert(IsDefined(mix_setting["fade_time"]));
channel = mix_setting["channel"];
volume = mix_setting["volume"];
fade_time = mix_setting["fade_time"];
volume = clamp(volume, 0.0, 1.0);
level.player SetChannelVolume(channel, volume, fade_time);
}
else
{
break;
}
}
for (i = 0; i < keys_used.size; i++)
{
key = keys_used[i];
level._audio.mix.queue[key] = undefined;
}
wait(0.05);
}
}
}
MMx_get_preset_from_string_table(presetname, checklevel)
{
assert(IsString(presetname));
preset = [];
level_stringtable = maps\_audio::get_mix_stringtable();
common_stringtable = "soundtables/common_mix.csv";
if (!IsDefined(level._audio.mix.preset_cache))
level._audio.mix.preset_cache = [];
if (IsDefined(level._audio.mix.preset_cache[presetname]))
{
preset = level._audio.mix.preset_cache[presetname];
}
else
{
if (checklevel)
preset = MMx_get_mix_preset_from_stringtable_internal(level_stringtable, presetname, false);
if (!IsDefined(preset) || preset.size == 0)
preset = MMx_get_mix_preset_from_stringtable_internal(common_stringtable, presetname, true);
if (!IsDefined(preset) || preset.size == 0)
return;
level._audio.mix.preset_cache[presetname] = preset;
}
return preset;
}
MMx_get_mix_preset_from_stringtable_internal(stringtable, presetname, is_common)
{
assert(IsString(stringtable));
assert(IsString(presetname));
assert(IsDefined(is_common));
numparams = 4;
row_value = "";
row_count = 0;
found_preset = false;
empty_rows = 0;
fade_time = undefined;
preset = [];
if (!IsDefined(level._audio.mix.param_names))
{
level._audio.mix.param_names = [];
}
if (!IsDefined(level._audio.mix.param_names[stringtable]))
{
level._audio.mix.param_names[stringtable] = [];
for (col = 1; col < numparams; col++)
{
paramname = tablelookupbyrow(stringtable, 0, col);
level._audio.mix.param_names[stringtable][paramname] = col;
}
}
index = get_indexed_preset("mix", presetname, is_common);
if (index != -1)
{
row_count = index;
}
else if ((is_common && aud_is_common_indexed()) || (!is_common && aud_is_local_indexed()))
{
return preset;
}
entry_count = 0;
while(row_value != "EOF" && empty_rows < 10 )
{
row_value = tablelookupbyrow(stringtable, row_count, 0);
if (row_value != "")
empty_rows = 0;
while(row_value == presetname)
{
found_preset = true;
if (!IsDefined(fade_time))
{
fade_time_col = level._audio.mix.param_names[stringtable]["fade_time"];
fade_time = tablelookupbyrow(stringtable, row_count, fade_time_col);
if (!IsDefined(fade_time) || (IsDefined(fade_time) && fade_time == ""))
{
fade_time = 1.0;
}
}
channel_name_col = level._audio.mix.param_names[stringtable]["channels"];
channel_val_col = level._audio.mix.param_names[stringtable]["value"];
channel_name = tablelookupbyrow(stringtable, row_count, channel_name_col);
channel_val = tablelookupbyrow(stringtable, row_count, channel_val_col);
assertEx(IsDefined(channel_name) && channel_name != "", "In soundtable " + stringtable + " there is a format problem in preset " + presetname);
assertEx(IsDefined(channel_val) && channel_name != "", "In soundtable " + stringtable + " there is a format problem in preset " + presetname);
if ((channel_name == "set_all" || channel_name == "setall"))
{
assertEx(entry_count == 0, "In soundtable " + stringtable + " the \"set_all\" keyword needs to be the first entry in the preset " + presetname);
if (float(channel_val) < 1)
preset = volmod_mix_with_all_channels_at(float(channel_val));
}
else
{
assert(IsDefined(level._audio.mix.volmodfile));
if (!IsDefined(level._audio.mix.volmodfile[channel_name]))
{
aud_print_error("In soundtable " + stringtable + ", " + presetname + " uses a volmod group name that doesn't exist in the volmodgroups.csv file.");
return;
}
preset[channel_name] = float(channel_val);
}
row_count++;
row_value = tablelookupbyrow(stringtable, row_count, 0);
entry_count++;
}
empty_rows++;
if (found_preset)
break;
row_count++;
}
if (found_preset && IsDefined(fade_time))
{
preset["fade_time"] = float(fade_time);
}
return preset;
}
MMx_get_mix_preset(preset_name)
{
assert(IsString(preset_name));
assert(IsDefined(level._audio.mix.preset_cache));
if (!IsDefined(level._audio.mix.preset_cache))
level._audio.mix.preset_cache = [];
preset = [];
if (IsDefined(level._audio.mix.preset_cache[preset_name]))
{
preset = level._audio.mix.preset_cache[preset_name];
}
else
{
preset = undefined;
if (level._audio.mix.use_string_table_presets)
{
preset = MMx_get_preset_from_string_table(preset_name, true);
}
else
{
preset = MMx_get_preset_from_string_table(preset_name, false);
if (!IsDefined(preset) || preset.size == 0)
{
preset = AUDIO_PRESETS_MIX(preset_name, preset);
}
}
if(!IsDefined(preset) || preset.size == 0)
{
return;
}
preset["name"] = preset_name;
if (!IsDefined(preset["fade_time"]))
{
preset["fade_time"] = 1.0;
}
level._audio.mix.preset_cache[preset_name] = preset;
}
return preset;
}
MMx_init_volmods()
{
assert(IsDefined(level._audio.mix));
if (!IsDefined(level._audio.mix.volmodfile))
{
MMx_parse_volumemodgroups_csv();
}
level._audio.mix.volmod_vals = [];
assert(IsDefined(level._audio.mix.volmodfile));
foreach(chan_name, value in level._audio.mix.volmodfile)
{
level._audio.mix.volmod_vals[chan_name] = SpawnStruct();
level._audio.mix.volmod_vals[chan_name].volume = value;
level._audio.mix.volmod_vals[chan_name].fade_time = 0.0;
}
MMx_init_channel_names();
}
MMx_init_channel_names()
{
assert(IsDefined(level._audio) && IsDefined(level._audio.mix));
if (!IsDefined(level._audio.mix.channel_names))
{
chans = [];
chans["physics"] = true;
chans["ambdist1"] = true;
chans["ambdist2"] = true;
chans["auto"] = true;
chans["auto2"] = true;
chans["auto2d"] = true;
chans["autodog"] = true;
chans["explosiondist1"] = true;
chans["explosiondist2"] = true;
chans["explosiveimpact"] = true;
chans["element"] = true;
chans["element_int"] = true;
chans["element_ext"] = true;
chans["bulletimpact"] = true;
chans["bulletflesh1"] = true;
chans["bulletflesh2"] = true;
chans["bulletwhizby"] = true;
chans["vehicle"] = true;
chans["vehiclelimited"] = true;
chans["menu"] = true;
chans["body"] = true;
chans["body2d"] = true;
chans["reload"] = true;
chans["reload2d"] = true;
chans["item"] = true;
chans["explosion1"] = true;
chans["explosion2"] = true;
chans["explosion3"] = true;
chans["explosion4"] = true;
chans["explosion5"] = true;
chans["effects1"] = true;
chans["effects2"] = true;
chans["effects3"] = true;
chans["effects2d1"] = true;
chans["effects2d2"] = true;
chans["vehicle2d"] = true;
chans["weapon_dist"] = true;
chans["weapon_mid"] = true;
chans["weapon"] = true;
chans["weapon2d"] = true;
chans["nonshock"] = true;
chans["nonshock2"] = true;
chans["voice"] = true;
chans["local"] = true;
chans["local2"] = true;
chans["local3"] = true;
chans["ambient"] = true;
chans["hurt"] = true;
chans["player1"] = true;
chans["player2"] = true;
chans["music"] = true;
chans["musicnopause"] = true;
chans["grondo3d"] = true;
chans["grondo2d"] = true;
chans["mission"] = true;
chans["critical"] = true;
chans["announcer"] = true;
chans["shellshock"] = true;
level._audio.mix.channel_names = chans;
}
assert(level._audio.mix.channel_names.size == 58);
}
MMx_get_channel_volumes()
{
assert(IsDefined(level._audio) && IsDefined(level._audio.mix));
return level._audio.mix.channel_volumes;
}
volmod_mix_with_all_channels_at(vol)
{
assert(IsDefined(level._audio.mix.volmodfile));
preset = [];
foreach(channel, value in level._audio.mix.volmodfile)
{
if (channel != "hud" && channel != "interface" && channel != "interface_music")
{
preset[channel] = vol;
}
}
return preset;
}
MMx_parse_volumemodgroups_csv()
{
stringtable = "soundaliases/volumemodgroups.svmod";
level._audio.mix.volmodfile = [];
maxblankcount = 10;
currblankcount = 0;
row = 0;
while(currblankcount < maxblankcount)
{
volmodname = tablelookupbyrow(stringtable, row, 0);
if (volmodname == "")
{
currblankcount++;
continue;
}
first_char = GetSubStr(volmodname, 0, 0);
if (first_char == "#")
continue;
volmodvalue = tablelookupbyrow(stringtable, row, 1);
level._audio.mix.volmodfile[volmodname] = float(volmodvalue);
row++;
}
if (!IsDefined(level._audio.volmod_submixes))
level._audio.volmod_submixes = [];
level._audio.mix.volmod_submixes["default"] = [];
foreach(volmodname, value in level._audio.mix.volmodfile)
{
level._audio.mix.volmod_submixes["default"][volmodname] = spawnstruct();
level._audio.mix.volmod_submixes["default"][volmodname].current_volume = value;
level._audio.mix.volmod_submixes["default"][volmodname].original_volume = value;
}
}
MMx_is_mix_channel(value)
{
assert(IsDefined(level._audio.mix.channel_names));
return IsDefined(level._audio.mix.channel_names[value]);
}
MMx_is_volmod_channel(value)
{
assert(IsDefined(level._audio.mix.volmodfile));
return IsDefined(level._audio.mix.volmodfile[value]);
}
