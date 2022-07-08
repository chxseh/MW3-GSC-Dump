#include maps\_utility_code;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#include maps\_audio_dynamic_ambi;
#include maps\_audio_stream_manager;
#include maps\_audio_mix_manager;
AZM_init()
{
if (!IsDefined(level._audio.zone_mgr))
{
level._audio.zone_mgr = SpawnStruct();
level._audio.zone_mgr.current_zone = "";
level._audio.zone_mgr.zones = [];
level._audio.zone_mgr.overrides = spawnstruct();
level._audio.zone_mgr.overrides.samb = [];
level._audio.zone_mgr.overrides.damb = [];
level._audio.zone_mgr.overrides.mix = [];
level._audio.zone_mgr.overrides.rev = [];
level._audio.zone_mgr.overrides.occ = [];
level._audio.zone_mgr.use_string_table_presets = false;
level._audio.zone_mgr.use_iw_presets = false;
}
if (!IsDefined(level._audio.use_level_audio_zones))
{
level._audio.level_audio_zones_function = undefined;
}
}
AZM_use_string_table()
{
level._audio.zone_mgr.use_string_table_presets = true;
level._audio.zone_mgr.use_iw_presets = false;
}
AZM_use_iw_presets()
{
level._audio.zone_mgr.use_iw_presets = true;
level._audio.zone_mgr.use_string_table_presets = false;
}
AZM_start_zone(name, fade_, specops_player_)
{
assertEx(IsString(name), "AZM_start_zone: name must be a string.");
if (level._audio.zone_mgr.current_zone == name)
{
return;
}
else if (level._audio.zone_mgr.current_zone != "")
{
AZM_stop_zone(level._audio.zone_mgr.current_zone, fade_);
}
level._audio.zone_mgr.current_zone = name;
assert(IsDefined(level._audio.zone_mgr.zones));
if (IsDefined(level._audio.zone_mgr.zones[name]) && IsDefined(level._audio.zone_mgr.zones[name]["state"]) && level._audio.zone_mgr.zones[name]["state"] != "stopping")
{
aud_print_warning("ZONEM_start_zone(\"" + name + "\") being called even though audio zone, \"" + name + "\", is already started.");
return;
}
fade = 2.0;
if (IsDefined(fade_))
{
assertEx(fade_ >= 0.0, "ZONEM_start_zone: fade_ must be greater than zero.");
fade = fade_;
}
if (!IsDefined(level._audio.zone_mgr.zones[name]))
{
zone = AZMx_load_zone(name);
if (!IsDefined(zone))
return;
level._audio.zone_mgr.zones[name] = zone;
}
zone = level._audio.zone_mgr.zones[name];
aud_print_zone("ZONE START: " + name);
level._audio.zone_mgr.zones[name]["state"] = "playing";
priority = zone["priority"];
interrupt_fade = zone["interrupt_fade"];
if (IsDefined(zone["streamed_ambience"]))
{
if (zone["streamed_ambience"] != "none")
{
SM_start_preset(zone["streamed_ambience"], fade, priority, interrupt_fade);
}
else
{
SM_stop_ambience(fade);
}
}
if (IsDefined(zone["mix"]))
{
if (zone["mix"] != "none")
{
MM_start_zone_preset(zone["mix"]);
}
else
{
MM_clear_zone_mix(1.0);
}
}
}
AZM_set_zone_streamed_ambience(zone_name, streamed_ambience, fade_)
{
success = AZMx_set_param_internal(zone_name, "streamed_ambience", streamed_ambience, ::AZMx_restart_stream, fade_);
if (!success)
{
if (!IsDefined(streamed_ambience))
streamed_ambience = "none";
level._audio.zone_mgr.overrides.samb[zone_name] = streamed_ambience;
}
}
AZM_set_zone_dynamic_ambience(zone_name, dynamic_ambience, fade_)
{
if (!IsDefined(dynamic_ambience))
dynamic_ambience = "none";
AZMx_set_param_internal(zone_name, "dynamic_ambience", dynamic_ambience, ::AZMx_restart_damb, fade_);
level._audio.zone_mgr.overrides.damb[zone_name] = dynamic_ambience;
}
AZM_set_zone_reverb(zone_name, reverb_name, fade_)
{
if (!IsDefined(reverb_name))
reverb_name = "none";
AZMx_set_param_internal(zone_name, "reverb", reverb_name, ::AZMx_restart_reverb, fade_);
level._audio.zone_mgr.overrides.rev[zone_name] = reverb_name;
}
AZM_set_zone_occlusion(zone_name, occlusion_name, fade_)
{
if (!IsDefined(occlusion_name))
occlusion_name = "none";
AZMx_set_param_internal(zone_name, "occlusion", occlusion_name, ::AZMx_restart_occlusion, fade_);
level._audio.zone_mgr.overrides.mix[occlusion_name] = occlusion_name;
}
AZM_set_zone_mix(zone_name, mix_name, fade_)
{
if (!IsDefined(mix_name))
mix_name = "none";
AZMx_set_param_internal(zone_name, "mix", mix_name, ::AZMx_restart_mix, fade_);
level._audio.zone_mgr.overrides.mix[mix_name] = mix_name;
}
AZM_stop_zones(fade_)
{
fade = 1.0;
if (IsDefined(fade_))
{
assertEx(fade_ >= 0.0, "ZONEM_stop_zone: fade_ must be greater or equal to zero.");
fade = fade_;
}
aud_print_zone("ZONE STOP ALL");
foreach (zone in level._audio.zone_mgr.zones)
{
assert(IsDefined(zone["name"]));
AZM_stop_zone(zone["name"], fade, false);
}
}
AZM_stop_zone(name, fade_, print_)
{
assertEx(IsString(name), "ZONEM_stop_zone: name must be a string.");
if (IsDefined(level._audio.zone_mgr.zones[name]) && IsDefined(level._audio.zone_mgr.zones[name]["state"]) && level._audio.zone_mgr.zones[name]["state"] != "stopping")
{
fade = 1.0;
if (IsDefined(fade_))
{
assertEx(fade_ >= 0.0, "ZONEM_stop_zone: fade_ must be greater or equal to zero.");
fade = fade_;
}
zone = level._audio.zone_mgr.zones[name];
do_print = false;
if (IsDefined(print_))
{
do_print = print_;
}
if (do_print)
{
aud_print_zone("ZONE STOP ZONE: " + name);
}
if (IsDefined(zone["streamed_ambience"]))
{
SM_stop_ambient_alias(zone["streamed_ambience"], fade);
}
if (IsDefined(zone["dynamic_ambience"]))
{
DAMB_zone_stop_preset(zone["dynamic_ambience"], fade);
}
level._audio.zone_mgr.zones[name]["state"] = "stopping";
thread AZMx_wait_till_fade_done_and_remove_zone(name, fade);
}
}
AZM_get_current_zone()
{
return level._audio.zone_mgr.current_zone;
}
AZM_set_current_zone(zone)
{
assert(IsString(zone));
level._audio.zone_mgr.current_zone = zone;
}
AZM_print_enter_blend(zone_from, zone_to, progress_)
{
}
AZM_print_exit_blend(zone_to)
{
}
AZM_print_progress(progress)
{
}
AZMx_load_zone(name)
{
assert(IsDefined(name));
if (IsDefined(level._audio.zone_mgr.zones[name]))
{
return;
}
if (!IsDefined(level._audio.zone_mgr.preset_cache))
level._audio.zone_mgr.preset_cache = [];
zone = [];
if (IsDefined(level._audio.zone_mgr.preset_cache[name]))
{
zone = level._audio.zone_mgr.preset_cache[name];
}
else
{
zone = AZMx_get_preset_from_string_table(name, true);
}
if (!IsDefined(zone) || zone.size == 0)
{
return;
}
level._audio.zone_mgr.preset_cache[name] = zone;
assert(IsDefined(zone));
recache = false;
if (IsDefined(level._audio.zone_mgr.overrides.samb[name]))
{
if (level._audio.zone_mgr.overrides.samb[name] == "none")
zone["streamed_ambience"] = undefined;
else
zone["streamed_ambience"] = level._audio.zone_mgr.overrides.samb[name];
recache = true;
level._audio.zone_mgr.overrides.samb[name] = undefined;
}
if (IsDefined(level._audio.zone_mgr.overrides.damb[name]))
{
if (level._audio.zone_mgr.overrides.damb[name] == "none")
zone["dynamic_ambience"] = undefined;
else
zone["dynamic_ambience"] = level._audio.zone_mgr.overrides.damb[name];
recache = true;
level._audio.zone_mgr.overrides.damb[name] = undefined;
}
if (IsDefined(level._audio.zone_mgr.overrides.rev[name]))
{
if (level._audio.zone_mgr.overrides.rev[name] == "none")
zone["reverb"] = undefined;
else
zone["reverb"] = level._audio.zone_mgr.overrides.rev[name];
recache = true;
level._audio.zone_mgr.overrides.rev[name] = undefined;
}
if (IsDefined(level._audio.zone_mgr.overrides.occ[name]))
{
if (level._audio.zone_mgr.overrides.occ[name] == "none")
zone["occlusion"] = undefined;
else
zone["occlusion"] = level._audio.zone_mgr.overrides.occ[name];
recache = true;
level._audio.zone_mgr.overrides.occ[name] = undefined;
}
if (IsDefined(level._audio.zone_mgr.overrides.mix[name]))
{
if (level._audio.zone_mgr.overrides.mix[name] == "none")
zone["mix"] = undefined;
else
zone["mix"] = level._audio.zone_mgr.overrides.mix[name];
recache = true;
level._audio.zone_mgr.overrides.mix[name] = undefined;
}
if (recache)
{
level._audio.zone_mgr.preset_cache[name] = zone;
}
zone["name"] = name;
if (!IsDefined(zone["priority"]))
{
zone["priority"] = 1;
}
if (!IsDefined(zone["interrupt_fade"]))
{
zone["interrupt_fade"] = 0.1;
}
return zone;
}
AZMx_get_preset_from_string_table(presetname, checklevel)
{
assert(IsString(presetname));
assert(IsDefined(checklevel));
common_stringtable = "soundtables/common_zone.csv";
level_stringtable = maps\_audio::get_zone_stringtable();
preset = [];
if (checklevel)
preset = AZMx_get_zone_preset_from_stringtable_internal(level_stringtable, presetname);
if (!IsDefined(preset) || preset.size == 0)
preset = AZMx_get_zone_preset_from_stringtable_internal(common_stringtable, presetname);
if (!IsDefined(preset) || preset.size == 0)
{
return;
}
return preset;
}
AZMx_get_zone_preset_from_stringtable_internal(stringtable, presetname)
{
assert(IsString(stringtable));
assert(IsString(presetname));
preset = [];
paramname = "";
value = "";
numparams = 8;
for( i = 1; i < numparams; i++)
{
if (paramname != "comments" && value != "")
preset[paramname] = value;
paramname = tablelookup(stringtable, 0, "zone_names", i);
value = tablelookup(stringtable, 0, presetname, i);
if (paramname != "comment" && paramname != "comments" && value != "")
{
switch(paramname)
{
case "streamed_ambience":
preset["streamed_ambience"] = value;
break;
case "dynamic_ambience":
preset["dynamic_ambience"] = value;
break;
case "mix":
preset["mix"] = value;
break;
case "reverb":
preset["reverb"] = value;
break;
case "filter":
preset["filter"] = value;
break;
case "occlusion":
preset["occlusion"] = value;
break;
default:
assertEx(false, "For audio zone preset stringtable, param name, \"" + paramname + "\", is unknown.");
break;
}
}
}
return preset;
}
AZMx_restart_stream(zone_name, fade_)
{
assert(IsDefined(zone_name));
streamed_ambience = level._audio.zone_mgr.zones[zone_name]["streamed_ambience"];
if (IsDefined(streamed_ambience))
SM_start_preset(streamed_ambience, fade_);
else
SM_stop_ambience(fade_);
}
AZMx_restart_damb(zone_name, fade_)
{
assert(IsDefined(zone_name));
fade = 1.0;
if (IsDefined(fade_))
fade = fade_;
dynamic_ambience = level._audio.zone_mgr.zones[zone_name]["dynamic_ambience"];
if (IsDefined(dynamic_ambience))
{
DAMB_zone_start_preset(dynamic_ambience, fade);
}
else
{
DAMB_zone_stop_preset(undefined, fade);
}
}
AZMx_restart_reverb(zone_name, fade_)
{
}
AZMx_restart_occlusion(zone_name, fade_)
{
assert(IsDefined(zone_name));
occlusion = level._audio.zone_mgr.zones[zone_name]["occlusion"];
if (IsDefined(occlusion))
aud_set_occlusion(occlusion);
}
AZMx_restart_mix(zone_name, fade_)
{
assert(IsDefined(zone_name));
mix = level._audio.zone_mgr.zones[zone_name]["mix"];
if (IsDefined(mix))
MM_start_preset(mix);
}
AZMx_set_param_internal(zone_name, param_name, param, function_pointer, fade_)
{
assert(IsString(zone_name));
assert(IsString(param_name));
assert(IsString(param_name));
assert(IsDefined(function_pointer));
if (IsDefined(level._audio.zone_mgr.zones[zone_name]))
{
if ((IsDefined(level._audio.zone_mgr.zones[zone_name][param_name]) && level._audio.zone_mgr.zones[zone_name][param_name] != param)
|| (!IsDefined(level._audio.zone_mgr.zones[zone_name][param_name]) && param != "none"))
{
if (param == "none")
level._audio.zone_mgr.zones[zone_name][param_name] = undefined;
else
level._audio.zone_mgr.zones[zone_name][param_name] = param;
if (zone_name == AZM_get_current_zone())
{
[[ function_pointer ]](zone_name, fade_);
}
}
return true;
}
else
{
return false;
}
}
AZMx_wait_till_fade_done_and_remove_zone(name, fade)
{
assert(IsDefined(name));
assert(IsDefined(fade));
wait(fade);
wait(0.05);
assert(IsDefined(level._audio.zone_mgr.zones[name]));
if (level._audio.zone_mgr.zones[name]["state"] == "stopping")
{
}
}
AZMx_get_blend_args(zone_from_name, zone_to_name)
{
args = SpawnStruct();
args.zone_from_name	= zone_from_name;
args.zone_to_name = zone_to_name;
args.samb1_name = undefined;
args.samb2_name = undefined;
args.damb1_name = undefined;
args.damb2_name = undefined;
args.occlusion1 = undefined;
args.occlusion2 = undefined;
args.filter1 = undefined;
args.filter2 = undefined;
args.reverb1 = undefined;
args.reverb2 = undefined;
args.mix1_name = undefined;
args.mix2_name = undefined;
if (!IsDefined(level._audio.zone_mgr.zones[zone_from_name]))
{
zone = AZMx_load_zone(zone_from_name);
if (!IsDefined(zone))
{
aud_print_warning("Couldn't find zone: " + zone_from_name );
return;
}
level._audio.zone_mgr.zones[zone_from_name] = zone;
}
current_zone = level._audio.zone_mgr.zones[zone_from_name];
if (!IsDefined(level._audio.zone_mgr.zones[zone_to_name]))
{
zone = AZMx_load_zone(zone_to_name);
if (!IsDefined(zone))
{
aud_print_warning("Couldn't find zone: " + zone_to_name );
return;
}
level._audio.zone_mgr.zones[zone_to_name] = zone;
}
destination_zone = level._audio.zone_mgr.zones[zone_to_name];
args.occlusion1 = current_zone["occlusion"];
args.occlusion2 = destination_zone["occlusion"];
args.filter1 = current_zone["filter"];
args.filter2 = destination_zone["filter"];
args.reverb1 = current_zone["reverb"];
args.reverb2 = destination_zone["reverb"];
args.mix1 = current_zone["mix"];
args.mix2 = destination_zone["mix"];
args.samb1_name = current_zone["streamed_ambience"];
args.samb2_name = destination_zone["streamed_ambience"];
return args;
}
AZMx_is_valid_damb_blend_request(amb1_name, amb2_name)
{
result = false;
if (IsDefined(amb1_name) && IsDefined(amb2_name) && amb1_name != amb2_name)
{
result = true;
}
else if ((IsDefined(amb2_name) && !IsDefined(amb1_name)))
{
result = true;
}
else if ((IsDefined(amb1_name) && !IsDefined(amb2_name)))
{
result = true;
}
return result;
}
AZMx_is_valid_samb_blend_request(amb1_name, amb2_name)
{
result = false;
if (IsDefined(amb1_name) && IsDefined(amb2_name) && amb1_name != amb2_name)
{
result = true;
}
else if ((IsDefined(amb2_name) && !IsDefined(amb1_name)))
{
result = true;
}
return result;
}
AZMx_blend_zones(level_1, level_2, args)
{
assert(IsDefined(level_1));
assert(IsDefined(level_2));
assert(IsDefined(args));
if	(AZMx_is_valid_samb_blend_request(args.samb1_name, args.samb2_name))
{
aliasInfo = [];
index = 0;
if (IsDefined(args.samb1_name) && args.samb1_name != "")
{
zone1 = level._audio.zone_mgr.zones[args.zone_from_name];
assert(IsDefined(zone1));
aliasInfo[index] = SpawnStruct();
aliasInfo[index].alias = args.samb1_name;
aliasInfo[index].vol = level_1;
aliasInfo[index].fade = zone1["interrupt_fade"];
aliasInfo[index].priority = zone1["priority"];
index++;
}
if (isdefined(args.samb2_name) && args.samb2_name != "")
{
zone2 = level._audio.zone_mgr.zones[args.zone_to_name];
assert(IsDefined(zone2));
aliasInfo[index] = SpawnStruct();
aliasInfo[index].alias = args.samb2_name;
aliasInfo[index].vol = level_2;
aliasInfo[index].fade = zone2["interrupt_fade"];
aliasInfo[index].priority = zone2["priority"];
}
if (aliasInfo.size > 0)
{
SM_mix_ambience(aliasInfo);
}
}
if ( AZMx_is_valid_damb_blend_request(args.damb1_name, args.damb2_name) )
{
DAMB_prob_mix_damb_presets(args.damb1_name, level_1, args.damb2_name, level_2);
}
has_filter = false;
if (aud_is_zone_filter_enabled())
{
if (Isdefined(args.filter1))
{
has_filter = true;
aud_set_filter(args.filter1, 0, false);
}
else
{
aud_set_filter(undefined, 0, false);
}
if (IsDefined(args.filter2))
{
has_filter = true;
aud_set_filter(args.filter2, 1, false);
}
else
{
aud_set_filter(undefined, 1, false);
}
if (!(IsDefined(level._audio.zone_occlusion_and_filtering_disabled) && level._audio.zone_occlusion_and_filtering_disabled))
{
if (IsDefined(args.filter1) || IsDefined(args.filter2))
{
level.player SetEqLerp(level_1, 0);
}
}
}
if (level_1 >= 0.75)
{
if (IsDefined(args.mix1))
{
}
if (aud_is_zone_filter_enabled())
{
if (IsDefined(args.occlusion1))
{
if (args.occlusion1 == "none")
aud_deactivate_occlusion();
else
aud_set_occlusion(args.occlusion1);
}
}
}
else if (level_2 >= 0.75)
{
if(IsDefined(args.reverb2))
{
if (IsDefined(args.mix2))
{
if (args.mix2 == "none")
MM_clear_zone_mix(2.0);
else
MM_start_zone_preset(args.mix2);
}
if (IsDefined(args.occlusion2))
{
if (args.occlusion2 == "none")
aud_deactivate_occlusion();
else
aud_set_occlusion(args.occlusion2);
}
}
}
}




