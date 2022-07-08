#include maps\_utility_code;
#include maps\_utility;
#include maps\_audio_stream_manager;
#include maps\_audio_dynamic_ambi;
#include maps\_audio_zone_manager;
#include common_scripts\utility;
#include maps\_audio_music;
#include maps\_audio_mix_manager;
#include maps\_audio_whizby;
#include maps\_audio_vehicles;
#include maps\_shg_common;
aud_init()
{
if (!IsDefined(level.aud))
{
if ( !isdefined( level.script ) )
level.script = ToLower( GetDvar( "mapname" ) );
level.aud = SpawnStruct();
if (!IsDefined(level._audio))
{
level._audio = SpawnStruct();
}
level._audio.using_string_tables = false;
level._audio.stringtables = [];
index = spawnstruct();
level._audio.index = spawnstruct();
level._audio.index.local = get_index_struct();
level._audio.index.common = get_index_struct();
index_common_presets();
level._audio.message_handlers = [];
level._audio.progress_trigger_callbacks = [];
level._audio.progress_maps = [];
level._audio.filter_disabled = false;
level._audio.current_filter = "";
level._audio.current_filter_indices = ["", ""];
level._audio.zone_occlusion_and_filtering_disabled = false;
level._audio.vo_duck_active = false;
level._audio.sticky_threat = undefined;
level._audio.player_state = SpawnStruct();
level._audio.player_state.locamote = "idle";
level._audio.player_state.locamote_prev = "idle";
level.ambient_reverb = [];
level.ambient_track = [];
level.fxfireloopmod = 1;
level.reverb_track = "";
level.eq_main_track = 0;
level.eq_mix_track = 1;
level.eq_track[ level.eq_main_track ] = "";
level.eq_track[ level.eq_mix_track ] = "";
SM_init();
DAMB_init();
AZM_init();
thread MM_init();
MUS_init();
WHIZ_init();
VM_init();
thread aud_level_fadein();
thread aud_wait_for_mission_fail_music();
aud_register_msg_handler(::_audio_msg_handler);
}
}
AUDIO_PRESETS_DYNAMIC_AMBIENCE(name, p)
{
aud_print_error("CALLING DYNAMIC_AMBIENCE PRESET USING OLD METHOD!");
}
AUDIO_PRESETS_DYNAMIC_AMBIENCE_COMPONENTS(name, p)
{
aud_print_error("CALLING DYNAMIC_AMBIENCE_COMPONENTS PRESET USING OLD METHOD!");
}
AUDIO_PRESETS_DYNAMIC_AMBIENCE_LOOP_DEFINITIONS(name, p)
{
aud_print_error("CALLING DYNAMIC_AMBIENCE_LOOP_DEFINITIONS PRESET USING OLD METHOD!");
}
AUDIO_PRESETS_MIX(name, p)
{
aud_print_error("CALLING MIX PRESET USING OLD METHOD!");
}
AUDIO_PRESETS_OCCLUSION(name, eq)
{
aud_print_error("CALLING OCCLUSION PRESET USING OLD METHOD!");
}
AUDIO_PRESETS_REVERB(name, p)
{
aud_print_error("CALLING REVERB PRESET USING OLD METHOD!");
}
AUDIO_PRESETS_WHIZBY(name, p)
{
aud_print_error("CALLING WHIZBY PRESET USING OLD METHOD!");
}
AUDIO_PRESETS_ZONES(name, p)
{
aud_print_error("CALLING ZONE PRESET USING OLD METHOD!");
}
aud_prime_stream(alias, update_, updaterate_)
{
update = false;
if (IsDefined(update_))
update = update_;
assert(IsString(alias));
self endon("release" + alias);
while(true)
{
self PrefetchSound(alias, "primed" + alias);
self waittill("primed" + alias);
if (!IsDefined(self.primed_streams))
self.primed_streams = [];
self.primed_streams[alias] = true;
if (!update)
{
return;
}
else
{
if (IsDefined(updaterate_))
wait updaterate_;
}
}
}
aud_is_stream_primed(alias)
{
if (!isaudiodisabled())
{
if (IsDefined(self.primed_streams) && IsDefined(self.primed_streams[alias]) && self.primed_streams[alias] )
return true;
else
return false;
}
else
{
return true;
}
}
aud_error_if_not_primed(alias)
{
}
aud_release_stream(alias, callstopsound_)
{
callstopsound = false;
if (IsDefined(callstopsound_))
callstopsound = callstopsound_;
self notify("release" + alias);
if (callstopsound && IsDefined(self))
self stopsounds();
}
aud_wait_till_primed(alias)
{
if (IsDefined(self.primed_streams) && IsDefined(self.primed_streams[alias]) && self.primed_streams[alias])
return;
self waittill("primed" + alias);
self notify("release" + alias);
}
aud_prime_and_play_on_plr(alias, wait_time, use_slowmo_)
{
origin = level.player.origin;
dummy = spawn("script_origin", origin);
dummy thread aud_prime_stream(alias);
if (wait_time > 0)
{
if (IsDefined(use_slowmo_) && use_slowmo_)
{
aud_slomo_wait(wait_time);
}
else
{
wait(wait_time);
}
}
dummy aud_wait_till_primed(alias);
self playsound(alias);
dummy delete();
}
aud_prime_and_play_internal(alias, wait_time, use_slowmo_)
{
self aud_prime_stream(alias);
if (IsDefined(use_slowmo_) && use_slowmo_)
{
aud_slomo_wait(wait_time);
}
else
{
wait(wait_time);
}
assert(self aud_is_stream_primed(alias));
self playsound(alias, "sounddone");
self waittill("sounddone");
wait(0.05);
self delete();
}
aud_prime_and_play(alias, wait_time, origin_, use_slowmo_)
{
assert(IsDefined(alias));
assert(IsDefined(wait_time));
origin = level.player.origin;
if (IsDefined(origin_))
{
origin = origin_;
}
ent = spawn("script_origin", origin);
assert(IsDefined(ent));
ent thread aud_prime_and_play_internal(alias, wait_time, use_slowmo_);
return ent;
}
aud_add_progress_map(name, map_array)
{
assert(IsDefined(level._audio.progress_maps));
level._audio.progress_maps[name] = map_array;
}
aud_get_progress_map(name)
{
assert(IsDefined(name));
assert(IsDefined(level._audio.progress_maps));
if (IsDefined(level._audio.progress_maps[name]))
return level._audio.progress_maps[name];
}
is_deathsdoor_audio_enabled()
{
if (!IsDefined(level._audio.deathsdoor_enabled))
{
return true;
}
else
{
return level._audio.deathsdoor_enabled;
}
}
aud_enable_deathsdoor_audio()
{
level.player.disable_breathing_sound = false;
level._audio.deathsdoor_enabled = true;
}
aud_disable_deathsdoor_audio()
{
level.player.disable_breathing_sound = true;
level._audio.deathsdoor_enabled = false;
}
restore_after_deathsdoor()
{
if (is_deathsdoor_audio_enabled() || isdefined(level._audio.in_deathsdoor))
{
level._audio.in_deathsdoor = undefined;
assert(IsDefined(level._audio.deathsdoor));
thread aud_set_occlusion(level._audio.deathsdoor.occlusion);
thread aud_set_filter(level._audio.deathsdoor.filter);
}
}
set_deathsdoor()
{
level._audio.in_deathsdoor = true;
if (!IsDefined(level._audio.deathsdoor))
{
level._audio.deathsdoor = spawnstruct();
}
level._audio.deathsdoor.filter = undefined;
level._audio.deathsdoor.occlusion = undefined;
level._audio.deathsdoor.reverb = undefined;
level._audio.deathsdoor.filter = level._audio.current_filter;
level._audio.deathsdoor.occlusion = level._audio.current_occlusion;
level._audio.deathsdoor.reverb = level._audio.current_reverb;
if (is_deathsdoor_audio_enabled())
{
thread aud_set_filter("deathsdoor");
}
}
aud_set_mission_failed_music(alias)
{
level._audio.failed_music_alias = alias;
}
aud_wait_for_mission_fail_music()
{
wait(0.05);
assert(isDefined(level.flag));
while (!flag_exist("missionfailed"))
{
wait(0.05);
}
music_alias = "shg_mission_failed_stinger";
flag_wait("missionfailed");
if (IsDefined(level._audio.failed_music_alias))
{
music_alias = level._audio.failed_music_alias;
}
if (SoundExists(music_alias))
{
MUS_play(music_alias, 2, 4);
}
}
aud_clear_filter(index_)
{
index = 0;
if (IsDefined(index_))
{
assert(index_ == 0 || index_ == 1);
index = index_;
}
level._audio.current_filter_indices[index] = "";
aud_set_filter(undefined, index);
}
aud_disable_zone_filter()
{
level._audio.filter_zone_disabled = true;
}
aud_enable_zone_filter()
{
level._audio.filter_zone_disabled = undefined;
}
aud_is_zone_filter_enabled()
{
return !IsDefined(level._audio.filter_zone_disabled);
}
aud_set_filter(presetname, index_, max_server_calls_per_frame_, set_hud_)
{
}
aud_disable_filter_setting(channel_)
{
level._audio.filter_disabled = true;
}
aud_enable_filter_setting(channel_)
{
level._audio.filter_disabled = false;
}
aud_set_timescale_internal(presetname)
{
assert(IsString(presetname));
assert(IsDefined(level._audio.timescale_presets[presetname]));
stringtable = "soundtables/common_timescale.csv";
numparams = 2;
row_value = "";
row_count = 0;
preset = [];
param_names = [];
found_preset = false;
empty_rows = 0;
index = get_indexed_preset("timescale", presetname, true);
if (index != -1)
{
row_count = index;
}
else if (aud_is_common_indexed())
{
return false;
}
while(row_value != "EOF" && empty_rows < 10)
{
row_value = tablelookupbyrow(stringtable, row_count, 0);
if (row_value != "")
empty_rows = 0;
while(row_value == presetname)
{
found_preset = true;
preset = undefined;
for (col = 1; col < numparams + 1; col++)
{
if (!IsDefined(param_names[col]))
param_names[col] = tablelookupbyrow(stringtable, 0, col);
paramname = param_names[col];
paramvalue = tablelookupbyrow(stringtable, row_count, col);
if (paramvalue != "")
{
switch(paramname)
{
case "channel_name":
preset = spawnstruct();
preset.channel = paramvalue;
break;
case "scalefactor":
preset.scalefactor = float(paramvalue);
break;
default:
aud_print_error("In timescale preset table, common_timescale.csv, there is an improperly labeled parameter column, \"" + paramname + "\".");
break;
}
}
}
if (IsDefined(preset))
{
assert(IsDefined(preset.channel));
level._audio.timescale_presets[presetname][level._audio.timescale_presets[presetname].size] = preset;
}
row_count++;
row_value = tablelookupbyrow(stringtable, row_count, 0);
}
empty_rows++;
if (found_preset)
return true;
row_count++;
}
return false;
}
aud_set_timescale_threaded(presetname_, max_server_calls_per_frame_)
{
presetname = "default";
if (IsDefined(presetname_))
{
assert(IsString(presetname_));
presetname = presetname_;
}
if (!IsDefined(level._audio.timescale_presets))
level._audio.timescale_presets = [];
success = true;
if (!IsDefined(level._audio.timescale_presets[presetname]))
{
level._audio.timescale_presets[presetname] = [];
success = aud_set_timescale_internal(presetname);
}
if (!success)
{
return;
}
max_server_calls_per_frame = 10;
if (IsDefined(max_server_calls_per_frame_))
max_server_calls_per_frame = max_server_calls_per_frame_;
count = 0;
foreach(preset in level._audio.timescale_presets[presetname])
{
assert(IsDefined(preset.channel));
assert(IsDefined(preset.scalefactor));
SoundSetTimeScaleFactor(preset.channel, preset.scalefactor);
if (count < max_server_calls_per_frame)
count++;
else
{
count = 0;
wait(0.05);
}
}
}
aud_set_timescale(presetname_, max_server_calls_per_frame_)
{
thread aud_set_timescale_threaded(presetname_, max_server_calls_per_frame_);
}
aud_set_occlusion_internal(presetname)
{
assert(IsDefined(level._audio.occlusion_presets[presetname]));
if (!IsDefined(presetname))
return;
stringtable = "soundtables/common_occlusion.csv";
numparams = 5;
row_value = "";
row_count = 0;
preset = [];
param_names = [];
found_preset = false;
empty_rows = 0;
index = get_indexed_preset("occlusion", presetname, true);
if (index != -1)
{
row_count = index;
}
else if (aud_is_common_indexed())
{
return false;
}
while(row_value != "EOF" && empty_rows < 10 )
{
row_value = tablelookupbyrow(stringtable, row_count, 0);
if (row_value != "")
empty_rows = 0;
while(row_value == presetname)
{
found_preset = true;
preset = undefined;
for (col = 1; col < numparams + 1; col++)
{
if (!IsDefined(param_names[col]))
param_names[col] = tablelookupbyrow(stringtable, 0, col);
paramname = param_names[col];
paramvalue = tablelookupbyrow(stringtable, row_count, col);
if (paramvalue != "")
{
switch(paramname)
{
case "channel_name":
preset = spawnstruct();
preset.channel = paramvalue;
break;
case "frequency":
preset.freq = float(paramvalue);
break;
case "type":
preset.type = paramvalue;
break;
case "gain":
preset.gain = float(paramvalue);
break;
case "q":
preset.q = float(paramvalue);
break;
default:
aud_print_error("In occlusion preset table, common_occlusion.csv, there is an improperly labeled parameter column, \"" + paramname + "\".");
break;
}
}
}
assert(IsDefined(preset));
assert(IsDefined(preset.channel));
if (!IsDefined(preset.freq))
preset.freq = 600;
if (!IsDefined(preset.type))
preset.type = "highshelf";
if (!IsDefined(preset.gain))
preset.gain = -12;
if (!IsDefined(preset.q))
preset.q = 1;
level._audio.occlusion_presets[presetname][level._audio.occlusion_presets[presetname].size] = preset;
row_count++;
row_value = tablelookupbyrow(stringtable, row_count, 0);
}
empty_rows++;
if (found_preset)
return true;
row_count++;
}
return false;
}
aud_set_occlusion_threaded(presetname_, max_server_calls_per_frame_)
{
presetname = "default";
if (IsDefined(presetname_))
{
assert(IsString(presetname_));
presetname = presetname_;
}
if (!IsDefined(level._audio.occlusion_presets))
level._audio.occlusion_presets = [];
success = true;
if (!IsDefined(level._audio.occlusion_presets[presetname]))
{
level._audio.occlusion_presets[presetname] = [];
success = aud_set_occlusion_internal(presetname);
}
if (!success)
{
return;
}
level._audio.current_occlusion = presetname;
if (!(IsDefined(level._audio.zone_occlusion_and_filtering_disabled) && level._audio.zone_occlusion_and_filtering_disabled))
{
max_server_calls_per_frame = 10;
if (IsDefined(max_server_calls_per_frame_))
max_server_calls_per_frame = max_server_calls_per_frame;
count = 0;
foreach(preset in level._audio.occlusion_presets[presetname])
{
assert(IsDefined(preset.channel));
assert(IsDefined(preset.freq));
assert(IsDefined(preset.type));
assert(isDefined(preset.gain));
assert(isDefined(preset.q));
level.player SetOcclusion(preset.channel, preset.freq, preset.type, preset.gain, preset.q);
if (count < max_server_calls_per_frame)
count++;
else
{
count = 0;
wait(0.05);
}
}
}
}
aud_set_occlusion(presetname_, max_server_calls_per_frame_)
{
if ( IsDefined(level.player.ent_flag) && IsDefined( level.player.ent_flag[ "player_has_red_flashing_overlay" ] ) && level.player maps\_utility::ent_flag( "player_has_red_flashing_overlay" ) )
return;
if (!IsDefined(presetname_))
{
level._audio.current_filter = undefined;
return;
}
thread aud_set_occlusion_threaded(presetname_, max_server_calls_per_frame_);
}
aud_deactivate_occlusion(max_server_calls_per_frame_)
{
max_server_calls_per_frame = 10;
if (IsDefined(max_server_calls_per_frame_))
max_server_calls_per_frame = max_server_calls_per_frame;
count = 0;
foreach(channel_name, val in level._audio.mix.channel_names)
{
level.player DeactivateOcclusion(channel_name);
if (count < max_server_calls_per_frame)
count++;
else
{
count = 0;
wait(0.05);
}
}
}
aud_disable_zone_occlusion_and_filtering(max_server_calls_per_frame_)
{
max_server_calls_per_frame = 10;
if (IsDefined(max_server_calls_per_frame_))
max_server_calls_per_frame = max_server_calls_per_frame;
aud_set_filter(undefined, 0, max_server_calls_per_frame);
aud_set_filter(undefined, 1, max_server_calls_per_frame);
aud_deactivate_occlusion(max_server_calls_per_frame);
level._audio.zone_occlusion_and_filtering_disabled = true;
}
aud_enable_zone_occlusion_and_filtering(max_server_calls_per_frame_)
{
filter_presetname = undefined;
occlusion_presetname = "default";
max_server_calls_per_frame = 10;
if (IsDefined(max_server_calls_per_frame_))
max_server_calls_per_frame = max_server_calls_per_frame;
if ( IsDefined(level._audio.zone_mgr.current_zone) && IsDefined(level._audio.zone_mgr.zones[level._audio.zone_mgr.current_zone]) )
{
current_zone = AZM_get_current_zone();
zone = level._audio.zone_mgr.zones[current_zone];
if (IsDefined(zone["occlusion"]) && zone["occlusion"] != "none")
occlusion_presetname = zone["occlusion"];
if (IsDefined(zone["filter"]) && zone["filter"] != "none")
filter_presetname = zone["filter"];
}
if (level._audio.current_occlusion != occlusion_presetname) occlusion_presetname = level._audio.current_occlusion;
level._audio.zone_occlusion_and_filtering_disabled = false;
aud_set_filter(filter_presetname, 0, max_server_calls_per_frame);
aud_set_filter(undefined, 1, max_server_calls_per_frame);
aud_set_occlusion(occlusion_presetname, max_server_calls_per_frame);
}
aud_use_level_zones(level_audio_zones_function)
{
assert(IsDefined(level._audio));
level._audio.level_audio_zones_function = level_audio_zones_function;
}
aud_use_level_reverb(level_audio_reverb_function)
{
assert(IsDefined(level._audio));
level._audio.level_audio_reverb_function = level_audio_reverb_function;
}
aud_use_level_filters(level_audio_filter_function)
{
assert(IsDefined(level._audio));
level._audio.level_audio_filter_function = level_audio_filter_function;
}
aud_use_string_tables(do_index_)
{
do_index = true;
if (IsDefined(do_index_))
{
do_index = do_index_;
}
level._audio.using_string_tables = true;
AZM_use_string_table();
DAMB_use_string_table();
MM_use_string_table();
WHIZ_use_string_table();
if (do_index)
{
aud_index_presets();
}
WHIZ_set_preset("default");
}
set_stringtable_mapname(name)
{
aud_use_string_tables(false);
level._audio.stringtables["map"] = name;
aud_index_presets();
}
get_stringtable_mapname()
{
if (IsDefined(level._audio.stringtables["map"]))
return level._audio.stringtables["map"];
else
{
if( is_split_level() && !IsDefined( level.template_script ) )
{
return get_split_level_original_name();
}
return get_template_level();
}
}
set_mix_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["mix"] = name;
}
get_mix_stringtable()
{
if (!IsDefined(level._audio.stringtables["mix"]))
return "soundtables/" + get_stringtable_mapname() + "_mix.csv";
else
return "soundtables/" + level._audio.stringtables["mix"];
}
set_damb_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["damb"] = name;
}
get_damb_stringtable()
{
if (!IsDefined(level._audio.stringtables["damb"]))
return "soundtables/" + get_stringtable_mapname() + "_damb.csv";
else
return "soundtables/" + level._audio.stringtables["damb"];
}
set_damb_component_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["damb_comp"] = name;
}
get_damb_component_stringtable(name)
{
if (!IsDefined(level._audio.stringtables["damb_comp"]))
return "soundtables/" + get_stringtable_mapname() + "_damb_components.csv";
else
return "soundtables/" + level._audio.stringtables["damb_comp"];
}
set_damb_loops_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["damb_loops"] = name;
}
get_damb_loops_stringtable(name)
{
if (!IsDefined(level._audio.stringtables["damb_loops"]))
return "soundtables/" + get_stringtable_mapname() + "_damb_loops.csv";
else
return "soundtables/" + level._audio.stringtables["damb_loops"];
}
set_reverb_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["reverb"] = name;
}
get_reverb_stringtable()
{
if (!IsDefined(level._audio.stringtables["reverb"]))
return "soundtables/" + get_stringtable_mapname() + "_reverb.csv";
else
return "soundtables/" + level._audio.stringtables["reverb"];
}
set_filter_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["filter"] = name;
}
get_filter_stringtable()
{
if (!IsDefined(level._audio.stringtables["filter"]))
return "soundtables/" + get_stringtable_mapname() + "_filter.csv";
else
return "soundtables/" + level._audio.stringtables["filter"];
}
set_zone_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["zone"] = name;
}
get_zone_stringtable()
{
if (!IsDefined(level._audio.stringtables["zone"]))
return "soundtables/" + get_stringtable_mapname() + "_zone.csv";
else
return "soundtables/" + level._audio.stringtables["zone"];
}
set_occlusion_stringtable(name)
{
assert(IsString(name));
level._audio.stringtables["occlusion"] = name;
}
get_occlusion_stringtable()
{
if (!IsDefined(level._audio.stringtables["occlusion"]))
return "soundtables/" + get_stringtable_mapname() + "_occlusion.csv";
else
return "soundtables/" + level._audio.stringtables["occlusion"];
}
aud_register_msg_handler(msg_handler)
{
level._audio.message_handlers[level._audio.message_handlers.size] = msg_handler;
}
aud_send_msg(msg, args, notificaion_string)
{
thread aud_dispatch_msg(msg, args, notificaion_string);
}
aud_dispatch_msg(msg, args, notificaion_string)
{
assert(IsString(msg));
msg_was_handled = false;
result = false;
foreach (msg_handler in level._audio.message_handlers)
{
result = self [[msg_handler]](msg, args);
if (!msg_was_handled && IsDefined(result) && result == true)
{
msg_was_handled = result;
}
else if (!msg_was_handled && !IsDefined(result))
{
msg_was_handled = true;
}
}
if (IsDefined(notificaion_string))
{
self notify(notificaion_string);
}
assert(IsDefined(msg_was_handled));
if (!msg_was_handled)
{
aud_print_warning("\tAUDIO MESSAGE NOT HANDLED: " + msg);
}
}
aud_get_player_locamote_state()
{
assert(IsDefined(level._audio));
assert(IsDefined(level._audio.player_state));
assert(IsDefined(level._audio.player_state.locamote));
return level._audio.player_state.locamote;
}
aud_get_threat_level(alert_level_, min_yards_, max_yards_)
{
threat_level = 0;
sticky_threat = aud_get_sticky_threat();
if (IsDefined(sticky_threat))
{
threat_level = sticky_threat;
}
else
{
alert_level	= 3;
min_yards = 10;
max_yards = 100;
if (IsDefined(alert_level_))
{
alert_level = alert_level_;
}
if (IsDefined(max_yards_))
{
max_yards = max_yards_;
}
if (IsDefined(max_yards_))
{
min_yards = min_yards_;
}
max_dist	= 36 * max_yards;
min_dist	= 36 * min_yards;
enemies = GetAiArray( "bad_guys" );
num_aware_and_close_dudes	= 0;
weight_total = 0;
foreach(dude in enemies)
{
if(IsDefined(dude.alertlevelint) && dude.alertlevelint >= alert_level)
{
dist = Distance(level.player.origin, dude.origin);
if (dist < max_dist)
{
num_aware_and_close_dudes++;
if (dist < min_dist)
{
weight_dude = 1.0;
}
else
{
weight_dude = 1.0 - (dist - min_dist)/(max_dist - min_dist);
}
weight_total += weight_dude;
}
}
}
if (num_aware_and_close_dudes > 0)
{
threat_level = weight_total/num_aware_and_close_dudes;
}
else
{
threat_level = 0;
}
}
return threat_level;
}
aud_get_sticky_threat()
{
return level._audio.sticky_threat;
}
aud_set_sticky_threat(threat_level)
{
level._audio.sticky_threat = threat_level;
}
aud_clear_sticky_threat()
{
level._audio.sticky_threat = undefined;
}
aud_num_alive_enemies(max_yards_)
{
result	= 0;
radius	= 36 * 100;
if (IsDefined(max_yards_))
{
radius = 36 * max_yards_;
}
enemies = GetAiArray( "bad_guys" );
foreach(dude in enemies)
{
if(IsAlive(dude))
{
dist = Distance(level.player.origin, dude.origin);
if (dist < radius)
{
result++;
}
}
}
return result;
}
_audio_msg_handler(msg, args)
{
msg_handled = true;
switch(msg)
{
case "level_fade_to_black":
{
assert(IsArray(args) && IsDefined(args[0]) && IsDefined(args[1]));
delay_time	= args[0];
fade_time = args[1];
wait(delay_time);
MM_start_preset("mute_all", fade_time);
}
break;
case "generic_building_bomb_shake":
{
level.player playsound("sewer_bombs");
}
break;
case "start_player_slide_trigger":
{
}
break;
case "end_player_slide_trigger":
{
}
break;
case "missile_fired":
break;
case "msg_audio_fx_ambientExp":
break;
case "aud_play_sound_at":
{
assert(IsDefined(args.alias));
assert(IsDefined(args.pos));
aud_play_sound_at(args.alias, args.pos);
}
break;
case "aud_play_dynamic_explosion":
{
assert(IsDefined(args.explosion_pos));
assert(IsDefined(args.left_alias));
assert(IsDefined(args.right_alias));
if (IsDefined(args.spread_width))
spread_width = args.spread_width;
else
spread_width = undefined;
if (IsDefined(args.rear_dist))
rear_dist = args.rear_dist;
else
rear_dist = undefined;
if (IsDefined(args.velocity))
velocity = args.velocity;
else
velocity = undefined;
aud_play_dynamic_explosion(args.explosion_pos, args.left_alias, args.right_alias, spread_width, rear_dist, velocity);
}
break;
case "aud_play_conversation":
{
aud_play_conversation(msg, args);
}
break;
case "xm25_contact_explode":
{
if (soundexists("xm25_proj_explo"))
{
impact_point = args;
thread play_sound_in_space("xm25_proj_explo", impact_point);
}
}
break;
case "light_flicker_on":
{
light_model = args;
aud_handle_flickering_light(light_model);
}
break;
default:
{
msg_handled = false;
}
}
return msg_handled;
}
aud_handle_flickering_light(light_model)
{
specific_light_played = false;
switch(light_model.model)
{
case "furniture_lamp_floor1_off":
case "com_cafe_light_part1_off":
case "furniture_lamp_table1":
{
specific_light_played = true;
if (SoundExists("paris_lamplight_flicker"))
{
thread play_sound_in_space("paris_lamplight_flicker", light_model.origin);
}
}
break;
default:
{
specific_light_played = false;
}
}
return specific_light_played;
}
aud_play_conversation(msg, args)
{
assert(IsDefined(args));
lines = args;
chatter_states = [];
for (i = 0; i < lines.size; i++)
{
chatter_states[i] = lines[i].ent.battlechatter;
lines[i].ent.battlechatter = 0;
}
foreach (line in lines)
{
assert(IsDefined(line.ent));
assert(IsDefined(line.sound));
if (IsDefined(line.delay))
{
wait(line.delay);
}
ent = Spawn( "script_origin", ( 0, 0, 0 ) );
ent LinkTo( line.ent, "", ( 0, 0, 0 ), ( 0, 0, 0 ) );
ent PlaySound(line.sound, "sounddone");
ent waittill("sounddone");
wait(0.05);
ent delete();
}
for (i = 0; i < lines.size; i++)
{
lines[i].ent.battlechatter = chatter_states[i];
}
}
trigger_multiple_audio_register_callback(callbacks)
{
assert(IsDefined(callbacks));
if (!IsDefined(level._audio.trigger_functions))
{
level._audio.trigger_functions = [];
}
for (i = 0; i < callbacks.size; i++)
{
callback_array = callbacks[i];
assert(callback_array.size == 2);
callback_key = callback_array[0];
assert(IsString(callback_key));
callback_function = callback_array[1];
level._audio.trigger_functions[callback_key] = callback_function;
}
if (IsDefined(level._audio.trigger_function_keys))
{
foreach ( callback_key in level._audio.trigger_function_keys)
{
assertEx(IsDefined(level._audio.trigger_functions[callback_key]), "trigger_multiple_audio_callback: " + callback_key + " not registered with a function pointer.");
}
level._audio.trigger_function_keys = undefined;
}
}
get_target_ent_target()
{
target_ent = get_target_ent();
return target_ent.target;
}
get_target_ent_origin()
{
target_ent = get_target_ent();
return target_ent.origin;
}
get_target_ent_target_ent()
{
target_ent = get_target_ent();
return target_ent get_target_ent();
}
get_target_ent_target_ent_origin()
{
target_ent_target_ent = get_target_ent_target_ent();
return target_ent_target_ent.origin;
}
get_zone_from(tokens, is_backwards)
{
if (!IsDefined(tokens) || !IsDefined(is_backwards))
{
return undefined;
}
assert(IsDefined(tokens[0]) && IsDefined(tokens[1]));
if (is_backwards)
{
return tokens[1];
}
else
{
return tokens[0];
}
}
get_zone_to(tokens, is_backwards)
{
assert(IsDefined(is_backwards));
if (!IsDefined(tokens) || !IsDefined(is_backwards))
{
return undefined;
}
assert(IsDefined(tokens[0]) && IsDefined(tokens[1]));
if (is_backwards)
{
return tokens[0];
}
else
{
return tokens[1];
}
}
trigger_multiple_audio_trigger(use_old_key_compatibility)
{
if (!IsDefined(level._audio))
level._audio = spawnstruct();
if (!IsDefined(level._audio.trigger_functions))
level._audio.trigger_functions = [];
tokens = undefined;
if (IsDefined(use_old_key_compatibility) && use_old_key_compatibility)
{
if (IsDefined(self.ambient))
{
tokens = strtok(self.ambient, " ");
}
}
else
{
if (IsDefined(self.script_audio_zones))
{
tokens = strtok(self.script_audio_zones, " ");
}
else if (Isdefined(self.audio_zones))
{
tokens = strtok( self.audio_zones, " " );
}
}
if (IsDefined(tokens) && tokens.size == 2)
{
assertEx(IsDefined(self.target), "Trigger Multiple Audio Trigger: audio zones given without setting up target entities (script_origins).");
}
else if (IsDefined(tokens) && tokens.size == 1)
{
for ( ; ; )
{
self waittill( "trigger", other );
assertEx( isplayer( other ), "Non - player entity touched an ambient trigger." );
AZM_start_zone( tokens[0], self.script_duration );
}
}
if (IsDefined(self.script_audio_progress_map))
{
assert(IsDefined(level._audio.progress_maps));
if (!IsDefined(level._audio.progress_maps[self.script_audio_progress_map]))
{
aud_print_error("Trying to set a progress_map_function without defining the envelope in the level.aud.envs array.");
self.script_audio_progress_map = undefined;
}
}
if(!IsDefined(level._audio.trigger_function_keys))
{
level._audio.trigger_function_keys = [];
}
if (IsDefined(self.script_audio_enter_func))
{
level._audio.trigger_function_keys[level._audio.trigger_function_keys.size] = self.script_audio_enter_func;
}
if (IsDefined(self.script_audio_exit_func))
{
level._audio.trigger_function_keys[level._audio.trigger_function_keys.size] = self.script_audio_exit_func;
}
if (IsDefined(self.script_audio_progress_func))
{
level._audio.trigger_function_keys[level._audio.trigger_function_keys.size] = self.script_audio_progress_func;
}
if (IsDefined(self.script_audio_point_func))
{
level._audio.trigger_function_keys[level._audio.trigger_function_keys.size] = self.script_audio_point_func;
}
if (!IsDefined(self.script_audio_blend_mode))
{
self.script_audio_blend_mode = "blend";
}
point_a = undefined;
point_b = undefined;
dist = undefined;
if (IsDefined(self.target))
{
if (!IsDefined(get_target_ent()))
{
aud_print_error("Audo Zone Trigger at " + self.origin + " has defined a target, " + self.target + ", but that target doesn't exist.");
return;
}
if (IsDefined(get_target_ent_target()))
{
point_a = get_target_ent_origin();
if (!IsDefined(get_target_ent_target_ent()))
{
aud_print_error("Audo Zone Trigger at " + self.origin + " has defined a target, " + get_target_ent_target() + ", but that target doesn't exist.");
return;
}
point_b = get_target_ent_target_ent_origin();
}
else
{
assert(IsDefined(self.target));
target_ent = get_target_ent();
diff = 2*(self.origin - target_ent.origin);
angles = VectorToAngles(diff);
point_a = get_target_ent_origin();
point_b = point_a + diff;
if (AngleClamp180(angles[0]) < 45)
{
point_a = (point_a[0], point_a[1], 0);
point_b = (point_b[0], point_b[1], 0);
}
}
dist = distance(point_a, point_b);
}
is_backward = false;
while (1)
{
self waittill("trigger", other);
assertEx( IsPlayer(other), "Non - player entity touched an ambient trigger." );
if (aud_is_specops() && other != level.player)
{
continue;
}
if (IsDefined(point_a) && IsDefined(point_b))
{
progress = trigger_multiple_audio_progress(point_a, point_b, dist, other.origin);
if (progress < 0.5)
{
is_backward = false;
if (IsDefined(self.script_audio_enter_msg))
{
if (IsDefined(tokens) && IsDefined(tokens[0]))
{
aud_send_msg(self.script_audio_enter_msg, tokens[0]);
}
else
{
aud_send_msg(self.script_audio_enter_msg, "front");
}
}
if (IsDefined(self.script_audio_enter_func))
{
if (IsDefined(tokens) && IsDefined(tokens[0]))
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_enter_func]))
{
[[ level._audio.trigger_functions[self.script_audio_enter_func] ]](tokens[0]);
}
}
else
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_enter_func]))
{
[[ level._audio.trigger_functions[self.script_audio_enter_func] ]]("front");
}
}
}
}
else
{
is_backward = true;
if (IsDefined(self.script_audio_enter_msg))
{
if (IsDefined(tokens) && IsDefined(tokens[1]))
{
aud_send_msg(self.script_audio_enter_msg, tokens[1]);
}
else
{
aud_send_msg(self.script_audio_enter_msg, "back");
}
}
if (IsDefined(self.script_audio_enter_func))
{
if (IsDefined(tokens) && IsDefined(tokens[1]))
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_enter_func]))
{
[[ level._audio.trigger_functions[self.script_audio_enter_func] ]](tokens[1]);
}
}
else
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_enter_func]))
{
[[ level._audio.trigger_functions[self.script_audio_enter_func] ]]("back");
}
}
}
}
}
else
{
if (IsDefined(self.script_audio_enter_msg))
{
aud_send_msg(self.script_audio_enter_msg);
}
if (IsDefined(self.script_audio_enter_func))
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_enter_func]))
{
[[ level._audio.trigger_functions[self.script_audio_enter_func] ]]();
}
}
}
blend_args = undefined;
if (Isdefined(get_zone_from(tokens, is_backward)) && IsDefined(get_zone_to(tokens, is_backward)))
{
blend_args = AZMx_get_blend_args(get_zone_from(tokens, is_backward), get_zone_to(tokens, is_backward));
if (!IsDefined(blend_args))
{
return;
}
assert(IsDefined(self.script_audio_blend_mode));
blend_args.mode = self.script_audio_blend_mode;
}
if (IsDefined(blend_args) && aud_is_zone_filter_enabled())
{
if (IsDefined(blend_args.filter1) || IsDefined(blend_args.filter2))
{
level.player deactivateeq(1);
}
}
last_progress = -1;
progress = -1;
while ( other istouching( self ) )
{
if (IsDefined(self.script_audio_point_func))
{
progress_point = trigger_multiple_audio_progress_point(point_a, point_b, other.origin);
if (IsDefined(level._audio.trigger_functions[self.script_audio_point_func]))
{
[[ level._audio.trigger_functions[self.script_audio_point_func] ]](progress_point);
}
}
if (IsDefined(point_a) && IsDefined(point_b))
{
progress = trigger_multiple_audio_progress(point_a, point_b, dist, other.origin);
if (IsDefined(self.script_audio_progress_map))
{
assert(IsDefined(level._audio.progress_maps[self.script_audio_progress_map]));
progress = aud_map(progress, level._audio.progress_maps[self.script_audio_progress_map]);
}
if (progress != last_progress)
{
if (IsDefined(get_zone_from(tokens, is_backward)) && IsDefined(get_zone_to(tokens, is_backward)))
AZM_print_enter_blend(get_zone_from(tokens, is_backward), get_zone_to(tokens, is_backward), progress);
if (IsDefined(self.script_audio_progress_msg))
{
aud_send_msg(self.script_audio_progress_msg, progress);
}
if (IsDefined(self.script_audio_progress_func))
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_progress_func]))
{
[[ level._audio.trigger_functions[self.script_audio_progress_func] ]](progress);
}
}
if (IsDefined(blend_args))
{
trigger_multiple_audio_blend(progress, blend_args, is_backward);
}
last_progress = progress;
AZM_print_progress(progress);
}
}
if (IsDefined(self.script_audio_update_rate))
{
wait(self.script_audio_update_rate);
}
else
{
wait(0.1);
}
}
if (IsDefined(point_a) && IsDefined(point_b))
{
assert(IsDefined(progress));
if (progress > 0.5)
{
if (IsDefined(tokens) && IsDefined(tokens[1]))
{
AZM_set_current_zone(tokens[1]);
}
if (IsDefined(self.script_audio_exit_msg))
{
if (IsDefined(tokens) && IsDefined(tokens[1]))
{
aud_send_msg(self.script_audio_exit_msg, tokens[1]);
}
else
{
aud_send_msg(self.script_audio_exit_msg, "back");
}
}
if (IsDefined(self.script_audio_exit_func))
{
if (IsDefined(tokens) && IsDefined( tokens[1] ))
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_exit_func]))
{
[[ level._audio.trigger_functions[self.script_audio_exit_func] ]](tokens[1]);
}
}
else
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_exit_func]))
{
[[ level._audio.trigger_functions[self.script_audio_exit_func] ]]("back");
}
}
}
progress = 1;
}
else
{
if (IsDefined(tokens) && IsDefined(tokens[0]))
{
AZM_set_current_zone(tokens[0]);
}
if (IsDefined(self.script_audio_exit_msg))
{
if (IsDefined(tokens) && IsDefined(tokens[0]))
{
aud_send_msg(self.script_audio_exit_msg, tokens[0]);
}
else
{
aud_send_msg(self.script_audio_exit_msg, "front");
}
}
if (IsDefined(self.script_audio_exit_func))
{
if (IsDefined(tokens) && IsDefined(tokens[0]))
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_exit_func]))
{
[[ level._audio.trigger_functions[self.script_audio_exit_func] ]](tokens[0]);
}
}
else
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_exit_func]))
{
[[ level._audio.trigger_functions[self.script_audio_exit_func] ]]("front");
}
}
}
progress = 0;
}
if (IsDefined(blend_args))
{
trigger_multiple_audio_blend(progress, blend_args, is_backward);
}
}
else
{
if (IsDefined(self.script_audio_exit_msg))
{
aud_send_msg(self.script_audio_exit_msg);
}
if (IsDefined(self.script_audio_exit_func))
{
if (IsDefined(level._audio.trigger_functions[self.script_audio_exit_func]))
{
[[ level._audio.trigger_functions[self.script_audio_exit_func] ]]();
}
}
}
}
}
trigger_multiple_audio_progress( start, end, dist, org )
{
normal = vectorNormalize( end - start );
vec = org - start;
progress = vectorDot( vec, normal );
progress = progress / dist;
return clamp(progress, 0, 1.0);
}
trigger_multiple_audio_progress_point( start, end, org )
{
normal = vectorNormalize( end - start );
vec = org - start;
progress_length = vectorDot( vec, normal );
return normal * progress_length + start;
}
trigger_multiple_audio_blend(progress, blend_args, is_backward)
{
assert(IsDefined(progress));
assert(IsDefined(blend_args));
progress = clamp(progress, 0, 1.0);
if (is_backward)
{
progress = 1.0 - progress;
}
assert(IsDefined(blend_args.mode));
mode = blend_args.mode;
assert(mode == "blend" || mode == "trigger");
if (mode == "blend")
{
level_a = 1.0 - progress;
level_b = progress;
AZMx_blend_zones(level_a, level_b, blend_args);
}
else
{
if (progress < 0.33)
{
AZM_start_zone(blend_args.zone_from_name);
}
else if (progress > 0.66)
{
AZM_start_zone(blend_args.zone_to_name);
}
}
}
aud_play_dynamic_explosion(explo_pos, left_alias, right_alias, spread_width, rear_dist, velocity)
{
assert(IsDefined(explo_pos));
assert(IsDefined(left_alias));
assert(IsDefined(right_alias));
player_ent = Spawn( "script_origin", level.player.origin );
explo_ent = Spawn( "script_origin", explo_pos );
if (!IsDefined(spread_width))
{
spread_width = Distance(explo_ent.origin, player_ent.origin);
}
if (!IsDefined(rear_dist))
{
yards = 30;
rear_dist = 12 * 3 * yards;
}
final_explo_positions = aud_do_dynamic_explosion_math(explo_ent.origin, player_ent.origin, spread_width, rear_dist);
assert(IsDefined(final_explo_positions));
assert(final_explo_positions.size == 2);
final_explo_positions[0] = (final_explo_positions[0][0], final_explo_positions[0][1], player_ent.origin[2]);
final_explo_positions[1] = (final_explo_positions[1][0], final_explo_positions[1][1], player_ent.origin[2]);
distance_traveled = Distance( explo_ent.origin, final_explo_positions[0] );
if (!IsDefined(velocity))
{
velocity = 12 * 3 * 50;
}
move_time = distance_traveled/velocity;
if (IsDefined(final_explo_positions) && final_explo_positions.size == 2)
{
left_ent = Spawn( "script_origin", explo_ent.origin );
right_ent = Spawn( "script_origin", explo_ent.origin );
left_ent PlaySound(left_alias);
right_ent PlaySound(right_alias);
left_ent moveTo( final_explo_positions[0], move_time, 0, 0);
right_ent moveTo( final_explo_positions[1], move_time, 0, 0);
}
}
aud_do_dynamic_explosion_math(explosion_vector, player_vector, spread_width, rear_dist)
{
centerVector = player_vector - explosion_vector;
leftVector = aud_copy_vector(centerVector);
rightVector = aud_copy_vector(centerVector);
leftRightVectorMag = aud_vector_magnitude_2d(leftVector);
leftRightVectorMultiplier = 0.5 * spread_width / leftRightVectorMag;
leftVector = aud_scale_vector_2d(leftVector, leftRightVectorMultiplier);
rightVector = aud_scale_vector_2d(rightVector, leftRightVectorMultiplier);
leftVector = aud_rotate_vector_yaw(leftVector, 90);
rightVector = aud_rotate_vector_yaw(rightVector, -90);
centerVectorMag = aud_vector_magnitude_2d(centerVector);
centerVectorMultiplier = rear_dist / centerVectorMag;
scaledCenterVector = aud_scale_vector_2d(centerVector, centerVectorMultiplier);
scaledCenterVector = scaledCenterVector + centerVector;
scaledCenterVector = scaledCenterVector + centerVector;
leftVector = leftVector + scaledCenterVector;
rightVector = rightVector + scaledCenterVector;
result = [];
result[0] = leftVector;
result[1] = rightVector;
return result;
}
aud_get_optional_param(optional_parameter_, default_value)
{
assert(IsDefined(default_value));
result = default_value;
if (IsDefined(optional_parameter_))
{
result = optional_parameter_;
}
return result;
}
aud_scale_vector_2d(vec, scalar)
{
return(vec[0] * scalar, vec[1] * scalar, vec[2]);
}
aud_scale_vector(vec, scalar)
{
return(vec[0] * scalar, vec[1] * scalar, vec[2] * scalar );
}
aud_rotate_vector_yaw(vec, angle)
{
vecX = vec[0] * cos(angle) - vec[1] * sin(angle);
vecY = vec[0] * sin(angle) + vec[1] * cos(angle);
return (vecX, vecY, vec[2]);
}
aud_copy_vector(input_vector)
{
new_vector = (0,0,0);
new_vector = new_vector + input_vector;
return new_vector;
}
aud_vector_magnitude_2d(input_vector)
{
return sqrt(input_vector[0] * input_vector[0] + input_vector[1] * input_vector[1]);
}
aud_print_synch(msg)
{
aud_print(msg, "synch_frame");
}
aud_print(msg, msg_type_)
{
}
aud_print_warning(msg)
{
aud_print(msg, "warning");
}
aud_print_error(msg)
{
aud_print(msg, "error");
}
aud_print_debug(msg)
{
aud_print(msg);
}
aud_print_zone(msg)
{
aud_print(msg, "zone");
}
aud_print_zone_small(msg)
{
aud_print(msg, "zone_small");
}
equal_strings(str1, str2)
{
if (isdefined(str1) && isdefined(str2))
{
return str1 == str2;
}
else
{
return !isdefined(str1) && !isdefined(str2);
}
}
IsUndefined(x)
{
return !IsDefined(x);
}
delete_on_sounddone(ent)
{
ent waittill("sounddone");
ent delete_sound_entity();
}
delete_sound_entity()
{
self delaycall(0.05, ::delete);
}
aud_fade_out_and_delete(sndEntity, fade)
{
sndEntity ScaleVolume(0.0, fade);
sndEntity delaycall(fade + 0.05, ::stopsounds);
sndEntity delaycall(fade + 0.1, ::delete);
}
aud_fade_loop_out_and_delete(sndEntity, fade)
{
sndEntity ScaleVolume(0.0, fade);
wait(fade + 0.05);
sndEntity StopLoopSound();
wait(0.05);
sndEntity delete();
}
aud_min(val1, val2)
{
if (val1 <= val2)
{
return val1;
}
else
{
return val2;
}
}
aud_max(val1, val2)
{
if (val1 >= val2)
{
return val1;
}
else
{
return val2;
}
}
aud_clamp(input, min, max)
{
if (input < min)
{
input = min;
}
else if (input > max)
{
input = max;
}
return input;
}
aud_fade_sound_in(ent, alias_name, vol, fade_in_time, is_loop_)
{
assert(IsDefined(ent));
assert(IsString(alias_name));
assert(IsDefined(vol));
assert(IsDefined(fade_in_time));
vol = aud_clamp(vol, 0.0, 1.0);
fade_in_time = aud_max(0.05, fade_in_time);
is_loop = false;
if (IsDefined(is_loop_))
{
is_loop = is_loop_;
}
if (is_loop)
{
ent playloopsound(alias_name);
}
else
{
ent PlaySound(alias_name);
}
ent ScaleVolume(0.0);
ent delaycall(0.05, ::ScaleVolume, vol, fade_in_time);
}
aud_map2(input_x, env_points)
{
assert(IsDefined(env_points));
assert(env_points.size >= 2);
min_x = env_points[0][0];
max_x = env_points[env_points.size - 1][0];
min_y = env_points[0][1];
max_y = env_points[env_points.size - 1][1];
output = undefined;
if (input_x <= min_x)
{
output = min_y;
}
else if (input_x >= max_x)
{
output = max_y;
}
else
{
curr_x = undefined;
prev_x = min_x;
prev_y = min_y;
for (i = 0; i < env_points.size; i++)
{
curr_x = env_points[i][0];
curr_y = env_points[i][1];
if (input_x >= prev_x && input_x < curr_x)
{
fraction = (input_x - prev_x) / (curr_x - prev_x);
output = prev_y + fraction * (curr_y - prev_y);
break;
}
prev_x = curr_x;
prev_y = curr_y;
}
}
assert(IsDefined(output));
return output;
}
aud_map(input, env_points)
{
assert(IsDefined(input));
assert(input >= 0.0 && input <= 1.0);
assert(IsDefined(env_points));
output = 0.0;
num_points = env_points.size;
prev_point = env_points[0];
for (i = 1; i < env_points.size; i++)
{
next_point = env_points[i];
if (input >= prev_point[0] && input <= next_point[0])
{
prev_x = prev_point[0];
next_x = next_point[0];
prev_y = prev_point[1];
next_y = next_point[1];
x_fract = (input - prev_x) / (next_x - prev_x);
output = prev_y + x_fract * (next_y - prev_y);
break;
}
else
{
prev_point = next_point;
}
}
assert(output >= 0.0 && output <= 1.0);
return output;
}
aud_map_range(input, range_min, range_max, env_points)
{
assert(IsDefined(input));
assert(IsDefined(env_points));
assert(range_max != range_min);
val = (input - range_min) / ( range_max - range_min);
val = clamp(val, 0.0, 1.0);
return aud_map(val, env_points);
}
aud_smooth(prev, curr, smooth)
{
assert(IsDefined(prev));
assert(IsDefined(curr));
assert(IsDefined(smooth) && smooth > 0.0 && smooth <= 1.0);
return prev + smooth * (curr - prev);
}
aud_is_even(number)
{
assert(IsDefined(number));
return (number == Int(number / 2) * 2);
}
all_mix_channels_except(exception_array)
{
assert(IsDefined(exception_array));
all_mix_channels = MM_get_channel_names();
assert(IsDefined(all_mix_channels));
result = [];
foreach( channel in exception_array)
{
assert(IsString(channel));
all_mix_channels[channel] = undefined;
}
foreach (channel, _ in all_mix_channels)
{
assert(IsString(channel));
result[result.size] = channel;
}
return result;
}
all_mix_channels()
{
all_mix_channels = MM_get_channel_names();
result = [];
assert(IsDefined(all_mix_channels));
foreach(channel, _ in all_mix_channels)
{
assert(IsString(channel));
result[result.size] = channel;
}
return result;
}
aud_SetAllTimeScaleFactors(value)
{
assert(IsDefined(value) && !IsString(value));
value = clamp(value, 0, 1.0);
chans = all_mix_channels();
aud_SetTimeScaleFactors(chans, value);
}
aud_SetTimeScaleFactors(chans, value)
{
thread audx_SetTimeScaleFactors(chans, value);
}
audx_SetTimeScaleFactors(chans, value)
{
assert(IsDefined(chans) && IsDefined(value));
burstMax = 8;
burst = 0;
i = 0;
next = 0;
while (i < chans.size)
{
next = i;
for (burst = 0; burst < burstMax && next < chans.size; burst++)
{
SoundSetTimeScaleFactor(chans[next], value);
next++;
}
wait(0.05);
i += burstMax;
}
}
aud_set_breach_time_scale_factors()
{
chans = all_mix_channels();
aud_SetTimeScaleFactors(chans, 1.0);
wait(0.5);
SoundSetTimeScaleFactor( "Music", 0 );
SoundSetTimeScaleFactor( "Menu", 0 );
SoundSetTimeScaleFactor( "local3", 0.0 );
SoundSetTimeScaleFactor( "Mission", 0.0 );
SoundSetTimeScaleFactor( "Announcer", 0.0 );
SoundSetTimeScaleFactor( "Bulletimpact", .60 );
SoundSetTimeScaleFactor( "Voice", 0.40 );
SoundSetTimeScaleFactor( "effects1", 0.20 );
SoundSetTimeScaleFactor( "effects2", 0.20 );
SoundSetTimeScaleFactor( "local", 0.20 );
SoundSetTimeScaleFactor( "local2", 0.20 );
SoundSetTimeScaleFactor( "physics", 0.20 );
SoundSetTimeScaleFactor( "ambient", 0.50 );
SoundSetTimeScaleFactor( "auto", 0.50 );
}
play_2d_sound_internal(aliasname)
{
self playsound(aliasname, "sounddone");
self waittill("sounddone");
wait(0.05);
self delete();
}
aud_delay_play_2d_sound_internal(aliasname, delay, use_slowmo_)
{
if (IsDefined(use_slowmo_) && use_slowmo_)
{
aud_slomo_wait(delay);
}
else
{
wait(delay);
}
ent = spawn("script_origin", level.player.origin);
ent thread play_2d_sound_internal(aliasname);
return ent;
}
aud_play_2d_sound(aliasname)
{
ent = spawn("script_origin", level.player.origin);
ent thread play_2d_sound_internal(aliasname);
return ent;
}
aud_delay_play_2d_sound(aliasname, delay, use_slowmo_)
{
ent = thread aud_delay_play_2d_sound_internal(aliasname, delay, use_slowmo_);
return ent;
}
audx_play_linked_sound_internal(type, aliasname, loop_stop_notify_)
{
if (type == "loop")
{
assert(IsDefined(loop_stop_notify_));
level endon(loop_stop_notify_ + "internal");
self playloopsound(aliasname);
level waittill(loop_stop_notify_);
if (IsDefined(self))
{
self stoploopsound(aliasname);
wait(0.05);
self delete();
}
}
else if (type == "oneshot")
{
self playsound(aliasname, "sounddone");
self waittill("sounddone");
if (IsDefined(self))
{
self delete();
}
}
}
audx_monitor_linked_entity_health(ent, loop_stop_notify)
{
assert(IsDefined(ent));
assert(IsDefined(loop_stop_notify));
level endon(loop_stop_notify);
while(IsDefined(self))
{
wait(0.1);
}
level notify(loop_stop_notify + "internal");
if (IsDefined(ent))
{
ent stoploopsound();
wait(0.05);
ent delete();
}
}
aud_play_linked_sound(aliasname, ent_to_linkto, type_, loop_stop_notify_, offset_)
{
assert(IsDefined(ent_to_linkto));
assert(IsDefined(aliasname));
type = "oneshot";
if (IsDefined(type_))
{
assert(type_ == "loop" || type_ == "oneshot");
type = type_;
}
ent = spawn("script_origin", ent_to_linkto.origin);
if (IsDefined(offset_))
{
ent linkto(ent_to_linkto, "tag_origin", offset_, (0, 0, 0));
}
else
{
ent linkto(ent_to_linkto);
}
if (type == "loop")
{
assertEx(IsDefined(loop_stop_notify_), "aud_play_linked_sound: need to supply a loop_stop_notify arg if using a loop.");
ent_to_linkto thread audx_monitor_linked_entity_health(ent, loop_stop_notify_);
}
ent thread audx_play_linked_sound_internal(type, aliasname, loop_stop_notify_);
return ent;
}
aud_playsound_attach(alias, linktothis, soundtype_)
{
ent = Spawn( "script_origin", linktothis.origin );
ent LinkTo(linktothis);
soundtype = "oneshot";
if (IsDefined(soundtype_))
{
soundtype = soundtype_;
}
if (soundtype == "loop")
{
ent playloopsound(alias);
}
else
{
ent playsound(alias);
}
return ent;
}
aud_play_sound_at_internal(alias, pos, duration_)
{
self PlaySound( alias, "sounddone" );
if (IsDefined(duration_))
{
wait(duration_);
self StopSounds();
}
else
{
self waittill( "sounddone" );
}
wait( 0.05 );
self delete();
}
aud_play_sound_at(alias, pos, duration_)
{
assert( IsDefined( alias ) );
assert( IsDefined( pos ) );
ent = Spawn( "script_origin", pos );
ent thread aud_play_sound_at_internal(alias, pos, duration_);
return ent;
}
aud_prime_point_source_loop(alias, position)
{
assert(IsString(alias));
assert(IsDefined(position));
loop_entity = Spawn("script_origin", position);
assert(IsDefined(loop_entity));
loop_entity thread aud_prime_stream(alias, true, 0.1);
return loop_entity;
}
aud_play_primed_point_source_loop(alias, start_vol_, fade_time_)
{
assert(IsString(alias));
assert(IsDefined(self));
assert(self aud_is_stream_primed(alias));
start_vol = aud_get_optional_param(start_vol_, 1.0);
fade_time = aud_get_optional_param(fade_time_, 1.0);
aud_fade_sound_in(self, alias, start_vol, fade_time, true);
aud_release_stream(alias);
}
aud_play_point_source_loop(alias, position, start_vol_, fade_time_)
{
assert(IsString(alias));
assert(IsDefined(position));
start_vol = aud_get_optional_param(start_vol_, 1.0);
fade_time = aud_get_optional_param(fade_time_, 1.0);
loop_entity = Spawn("script_origin", position);
assert(IsDefined(loop_entity));
aud_fade_sound_in(loop_entity, alias, start_vol, fade_time, true);
return loop_entity;
}
aud_stop_point_source_loop(loop_entity, fade_time_)
{
assert(IsDefined(loop_entity));
fade_time = aud_get_optional_param(fade_time_, 1.0);
aud_fade_out_and_delete(loop_entity, fade_time);
}
aud_set_point_source_loop_volume(loop_entity, vol, fade_time_)
{
assert(IsDefined(loop_entity));
assert(IsDefined(vol));
vol = clamp(vol, 0, 1.0);
fade_time = aud_get_optional_param(fade_time_, 1.0);
loop_entity ScaleVolume(vol, fade_time);
}
aud_play_loops_on_destructables_array(destructable_name, loop_alias, end_alias_, update_rate_)
{
assert(IsString(destructable_name));
assert(IsString(loop_alias));
update_rate = 0.1;
if (IsDefined(update_rate_))
{
update_rate = update_rate_;
}
destruct_entities = getentarray(destructable_name, "script_noteworthy");
num_destructables = destruct_entities.size;
foreach(destruct_ent in destruct_entities)
{
destruct_ent playloopsound(loop_alias);
destruct_ent.loop_sound_stopped = false;
}
while(num_destructables > 0)
{
wait(update_rate);
foreach(destruct_ent in destruct_entities)
{
if (destruct_ent.health < 0 && !destruct_ent.loop_sound_stopped)
{
num_destructables--;
destruct_ent stoploopsound();
destruct_ent.loop_sound_stopped = true;
if (IsDefined(end_alias_))
{
play_sound_in_space(end_alias_, destruct_ent.origin);
}
}
}
}
}
aud_set_music_submix(volume, fade_time_)
{
assert(IsDefined(volume));
submix_name = "music_submix";
if (!MM_does_volmod_submix_exist(submix_name))
{
MM_add_dynamic_volmod_submix(submix_name, ["music", 1.0], fade_time_);
MM_make_submix_sticky(submix_name);
}
MM_scale_submix(submix_name, volume, fade_time_);
}
aud_set_ambi_submix(volume, fade_time_)
{
assert(IsDefined(volume));
submix_name = "ambi_submix";
if (!MM_does_volmod_submix_exist(submix_name))
{
MM_add_dynamic_volmod_submix(submix_name, ["ambience", 1.0], fade_time_);
MM_make_submix_sticky(submix_name);
}
MM_scale_submix(submix_name, volume, fade_time_);
}
aud_fade_in_music(fade_time_)
{
fade_time = 10.0;
if (IsDefined(fade_time_))
{
fade_time = fade_time_;
}
MM_add_submix("mute_music", 0.1);
wait(0.05);
MM_clear_submix("mute_music", fade_time);
}
aud_check_sound_done()
{
self endon("cleanup");
if (!IsDefined(self.sounddone))
self.sounddone = false;
self waittill("sounddone");
if (IsDefined(self))
{
self.sounddone = true;
self notify("cleanup");
}
}
aud_in_zone(zone_name)
{
assert(IsString(zone_name));
return equal_strings(AZM_get_current_zone(), zone_name);
}
aud_find_exploder( num )
{
if (isdefined(level.createFXexploders))
{
exploders = level.createFXexploders[""+num];
if (isdefined(exploders))
return exploders[0];
}
else
{
for ( j = 0;j < level.createFXent.size;j++ )
{
fx_ent = level.createFXent[ j ];
if ( !isdefined( fx_ent ) )
continue;
if ( fx_ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( fx_ent.v[ "exploder" ] ) )
continue;
if ( int(fx_ent.v[ "exploder" ]) != num )
continue;
return fx_ent;
}
}
return undefined;
}
aud_duck(submix, duck_time, fade_in_, fade_out_)
{
thread audx_duck(submix, duck_time, fade_in_, fade_out_);
}
audx_duck(submix, duck_time, fade_in_, fade_out_)
{
assert(IsString(submix));
assert(IsDefined(duck_time));
duck_time = clamp(duck_time, 0, 10);
fade_in = 1.0;
if (IsDefined(fade_in_))
{
fade_in = fade_in_;
}
fade_out = fade_in;
if (IsDefined(fade_out_))
{
fade_out = fade_out_;
}
MM_add_submix(submix, fade_in);
wait(duck_time);
MM_clear_submix(submix, fade_out);
}
get_index_struct()
{
index = spawnstruct();
index.filter = [];
index.mix = [];
index.occlusion = [];
index.timescale = [];
index.indexed = false;
return index;
}
aud_index_presets()
{
assert(IsDefined(level._audio.index.local));
level._audio.index.local.mix = index_stringtable_internal(get_mix_stringtable());
level._audio.index.local.filter = index_stringtable_internal(get_filter_stringtable());
level._audio.index.local.indexed = true;
}
aud_is_local_indexed()
{
return level._audio.index.local.indexed;
}
index_common_presets()
{
assert(IsDefined(level._audio.index.common));
level._audio.index.common.mix = index_stringtable_internal("soundtables/common_mix.csv");
level._audio.index.common.occlusion	= index_stringtable_internal("soundtables/common_occlusion.csv");
level._audio.index.common.timescale	= index_stringtable_internal("soundtables/common_timescale.csv");
level._audio.index.common.indexed = true;
}
aud_is_common_indexed()
{
return level._audio.index.common.indexed;
}
get_indexed_preset(type, preset_name, is_common_)
{
assert(IsString(type));
assert(IsString(preset_name));
is_common = true;
if (IsDefined(is_common_))
{
is_common = is_common_;
}
index_struct = undefined;
if (is_common)
index_struct = level._audio.index.common;
else
index_struct = level._audio.index.local;
assert(IsDefined(index_struct));
index = undefined;
switch(type)
{
case "mix":
index = index_struct.mix[preset_name];
break;
case "filter":
index = index_struct.filter[preset_name];
break;
case "occlusion":
index = level._audio.index.common.occlusion[preset_name];
break;
case "timescale":
index = level._audio.index.common.timescale[preset_name];
break;
default:
break;
}
if (!IsDefined(index))
index = -1;
return index;
}
get_mix_index(preset_name, is_common)
{
assert(IsString(preset_name));
assert(IsDefined(is_common));
if (is_common)
{
return level._audio.index.common.mix[preset_name];
}
else
return level._audio.index.local.mix[preset_name];
}
index_stringtable_internal(preset_file)
{
assert(IsString(preset_file));
curr_preset_name = "";
blank_count = 0;
row_count = 1;
result = [];
preset_name = "";
while(blank_count < 10 && preset_name != "EOF")
{
preset_name = tablelookupbyrow(preset_file, row_count, 0);
if (IsDefined(preset_name) && preset_name != curr_preset_name && preset_name != "" && preset_name != "EOF")
{
blank_count = 0;
curr_preset_name = preset_name;
result[curr_preset_name] = row_count;
}
else if (preset_name == "")
{
blank_count++;
}
row_count++;
}
return result;
}
aud_percent_chance(percent)
{
assert(IsDefined(percent)&& percent >= 0 && percent <= 100);
return RandomIntRange(1, 100) <= percent;
}
aud_start_slow_mo_gunshot_callback(gunshot_function_callback, impact_function_callback)
{
assert(IsDefined(gunshot_function_callback));
assert(IsDefined(impact_function_callback));
level endon("aud_stop_slow_mo_gunshot");
bad_guys = GetAiArray("axis");
foreach(bad_guy in bad_guys)
{
bad_guy thread aud_impact_monitor(impact_function_callback);
}
button_triggered = false;
weapon_type = level.player GetCurrentWeapon();
while(true)
{
if (level.player AttackButtonPressed())
{
if (!button_triggered)
{
button_triggered = true;
[[ gunshot_function_callback ]](weapon_type);
}
}
else
{
button_triggered = false;
}
wait(0.05);
}
}
aud_impact_monitor(impact_function_callback)
{
level endon("aud_stop_slow_mo_gunshot");
assert(IsDefined(impact_function_callback));
weapon_type = level.player GetCurrentWeapon();
while(true)
{
self waittill("damage", damage, attacker, direction_vec, point, type);
if (IsDefined(point))
{
[[impact_function_callback]](weapon_type, damage, attacker, point, type);
}
}
}
aud_stop_slow_mo_gunshot_callback()
{
level notify("aud_stop_slow_mo_gunshot");
}
aud_play_distributed_sound(alias_name, points, edge_spread, min_dist_, max_dist_, update_rate_, vol_scale_)
{
assert(IsDefined(self));
self.IsDistributedSound = true;
self.alias = alias_name;
self.points = points;
self.edge_spread = edge_spread;
self.update_rate = update_rate_;
self.min_dist = min_dist_;
self.max_dist = max_dist_;
self.vol_scale = vol_scale_;
self PlayLoopSound(alias_name);
wait(0.1);
self thread audx_distributed_sound_update_loop(points, edge_spread, update_rate_, min_dist_, max_dist_, vol_scale_ );
}
aud_stop_distributed_sound()
{
self notify("stop");
}
aud_start_distributed_sound()
{
if (IsDefined(self.IsDistributedSound))
{
assert(IsDefined(self.alias));
self PlayLoopSound(self.alias);
wait(0.1);
self thread audx_distributed_sound_update_loop(self.points, self.edge_spread, self.update_rate, self.min_dist, self.max_dist, self.vol_scale);
}
}
audx_distributed_sound_update_loop(points, edge_spread, update_rate_, min_dist_, max_dist_, vol_scale_)
{
self endon("stop");
update_rate = 0.1;
if (IsDefined(update_rate_))
{
update_rate = update_rate_;
}
vol_scale = 1.0;
if (IsDefined(vol_scale_))
{
vol_scale = vol_scale_;
}
if (IsDefined(min_dist_))
{
if (!IsDefined(max_dist_))
return;
while(IsDefined(self))
{
wait(update_rate);
}
}
else
{
while(IsDefined(self))
{
wait(update_rate);
}
}
}
aud_slomo_wait(waittime)
{
waitent = spawn("script_origin", (0,0,0));
waitent thread aud_slomo_wait_internal(waittime);
waitent waittill("slo_mo_wait_done");
waitent delete();
}
aud_slomo_wait_internal(waittime)
{
total_wait = 0;
while(total_wait < waittime)
{
timescale_val = GetDvarFloat("com_timescale");
total_wait += 0.0666666 / timescale_val;
wait(0.0666666);
}
self notify("slo_mo_wait_done");
}
aud_set_level_fade_time(fadetime)
{
if (!IsDefined(level._audio))
{
level._audio = spawnstruct();
}
level._audio.level_fade_time = fadetime;
}
aud_level_fadein()
{
if (!IsDefined(level._audio.level_fade_time))
{
level._audio.level_fade_time = 1.0;
}
wait(0.05);
levelsoundfade(1, level._audio.level_fade_time);
}
aud_is_specops()
{
return IsDefined(level._audio.specops);
}
audx_set_spec_ops_internal()
{
if (!IsDefined(level._audio))
{
level._audio = spawnstruct();
}
level._audio.specops = true;
}
aud_set_spec_ops()
{
thread audx_set_spec_ops_internal();
}
audx_play_line_emitter_internal()
{
assert(IsString(self.label));
assert(IsString(self.alias));
assert(self.is_playing == false);
assert(IsDefined(self.point1));
assert(IsDefined(self.point2));
assert(IsDefined(self.fade_in));
level endon(self.label + "_line_emitter_stop");
start_to_end = self.point2 - self.point1;
start_to_end_norm = VectorNormalize(start_to_end);
start_to_end_mag = Distance(self.point1, self.point2);
update_rate = 0.1;
while(true)
{
start_to_player = level.player.origin - self.point1;
player_proj = VectorDot(start_to_player, start_to_end_norm);
player_proj = clamp(player_proj, 0, start_to_end_mag);
sound_origin = self.point1 + start_to_end_norm*player_proj;
if (!self.is_playing)
{
self.origin = sound_origin;
self playloopsound(self.alias);
self scalevolume(0);
wait(0.05);
self scalevolume(1.0, self.fade_in);
self.is_playing = true;
}
else
{
self moveto(sound_origin, update_rate);
}
wait(update_rate);
}
}
aud_stop_line_emitter(label)
{
level notify(label + "_line_emitter_stop");
}
aud_play_line_emitter(label, alias, point1, point2, fade_, fade_out_)
{
assert(IsString(label));
assert(IsString(alias));
assert(IsDefined(point1));
assert(IsDefined(point2));
fade_in = 0.1;
fade_out = 0.1;
if (IsDefined(fade_))
{
fade_in = max(fade_, 0);
fade_out = max(fade_, 0);
}
if (IsDefined(fade_out_))
{
fade_out = max(fade_out_, 0);
}
ent = spawn("script_origin", (0,0,0));
ent.alias = alias;
ent.is_playing = false;
ent.point1 = point1;
ent.point2 = point2;
ent.fade_in = fade_in;
ent.label = label;
ent thread audx_play_line_emitter_internal();
level waittill(label + "_line_emitter_stop");
ent scalevolume(0, fade_out);
wait(fade_out);
ent stoploopsound();
wait(0.05);
ent delete();
}
aud_print_3d_on_ent(msg, _size, _text_color)
{
if(IsDefined(self))
{
white = (1, 1, 1);
red = (1, 0, 0);
green = (0, 1, 0);
blue = (0, 1, 1);
size = 5;
text_color = white;
if(IsDefined(_size))
{
size = _size;
}
if(IsDefined( _text_color))
{
text_color = _text_color;
switch( text_color )
{
case "red":
{
text_color = red;
}
break;
case "white":
{
text_color = white;
}
break;
case "blue":
{
text_color = blue;
}
break;
case "green":
{
text_color = green;
}
break;
default:
{
text_color = white;
}
}
}
self endon("death");
while(IsDefined(self))
{
Print3d( self.origin, msg, text_color, 1, size, 1 );
wait(0.05);
}
}
}



