#include maps\_shg_common;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\hijack_code;
#include maps\_utility;
handle_crash_fx()
{
level waittill("crash_teleport");
thread handle_sled_fx();
thread handle_wing_fx();
thread handle_engine_fx();
thread handle_tail_fx();
thread handle_tail_impact_fx();
thread handle_volumetric_fx();
level waittill("crash_impact");
thread handle_paper_explosions();
level waittill("crash_throw_player");
}
handle_paper_explosions()
{
sled_drag_ents = GetEntArray("sled_paper_explosion", "script_noteworthy");
foreach(ent in sled_drag_ents)
{
fxID = getfx("hijack_paper_explosion");
PlayFXOnTag(fxID, ent, "tag_origin");
ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
}
level.crash_models[0] waittillmatch( "single anim", "paper_start" );
PlayFXOnTag(getfx("hijack_crash_papers"), level.crash_models[0], "J_Mid_Section");
level.crash_models[0] waittillmatch( "single anim", "paper_stop" );
StopFXOnTag(getfx("hijack_crash_papers"), level.crash_models[0], "J_Mid_Section");
}
handle_volumetric_fx()
{
level waittill("crash_impact");
wait 1;
crash_window_ents = GetEntArray("crash_window_volseq1", "script_noteworthy");
foreach(ent in crash_window_ents)
{
fxID = getfx("hijack_crash_window_volumetric");
PlayFXOnTag(fxID, ent, "tag_origin");
ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
}
wait 0.1;
crash_window_ents = GetEntArray("crash_window_volseq2", "script_noteworthy");
foreach(ent in crash_window_ents)
{
fxID = getfx("hijack_crash_window_volumetric");
PlayFXOnTag(fxID, ent, "tag_origin");
ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
}
wait 0.1;
crash_window_ents = GetEntArray("crash_window_volseq3", "script_noteworthy");
foreach(ent in crash_window_ents)
{
fxID = getfx("hijack_crash_window_volumetric");
PlayFXOnTag(fxID, ent, "tag_origin");
ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
}
wait 0.3;
wait 0.1;
wait 0.1;
crash_window_ents = GetEntArray("crash_window_volseq6", "script_noteworthy");
foreach(ent in crash_window_ents)
{
fxID = getfx("hijack_crash_window_volumetric");
PlayFXOnTag(fxID, ent, "tag_origin");
ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
}
wait 0.1;
crash_window_ents = GetEntArray("crash_window_volseq7", "script_noteworthy");
foreach(ent in crash_window_ents)
{
fxID = getfx("hijack_crash_window_volumetric");
PlayFXOnTag(fxID, ent, "tag_origin");
ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
}
}
handle_sled_fx()
{
level.crash_models[0] waittillmatch( "single anim", "split" );
sled_ent = level.crash_models[0];
break_sparks_fx = getfx("fuselage_break_sparks1");
PlayFXOnTag(break_sparks_fx, sled_ent, "FX_Mid_Break_1");
PlayFXOnTag(break_sparks_fx, sled_ent, "FX_Mid_Break_2");
PlayFXOnTag(break_sparks_fx, sled_ent, "FX_Mid_Break_3");
sled_drag_ents = GetEntArray("sled_drag", "script_noteworthy");
foreach(ent in sled_drag_ents)
{
fxID = getfx("fuselage_scrape");
PlayFXOnTag(fxID, ent, "tag_origin");
ent thread stop_fx_on_notify(fxID, "sled_scrape_stop");
}
}
handle_wing_fx()
{
level waittill("crash_impact");
wait 1;
PlayFXOnTag(getfx("wing_fuel_explosion"), level.crash_models[0], "FX_R_Wing");
level.crash_models[0] thread stop_fx_on_notify(getfx("wing_fuel_explosion"), "sled_scrape_stop");
}
handle_engine_fx()
{
wait 6.733;
PlayFXOnTag(getfx("engine_explosion"), getent("engine_explosion", "script_noteworthy"), "tag_origin");
level.crash_models[0] waittillmatch( "single anim", "engine_fire" );
PlayFXOnTag(getfx("hijack_engine_trail"), level.crash_models[0], "J_rwing_engine");
enginePos = level.crash_models[0] GetTagOrigin("J_rwing_engine");
PlayFX(getfx("hijack_engine_split"), enginePos);
}
handle_tail_fx()
{
tail_debris_fx	= getfx("smoke_geotrail_debris");
explosion_fx	= getfx("reaper_explosion");
trail_fx = getfx("hijack_engine_split");
tail_impact_fx	= getfx("tail_wing_impact");
wait 17.333;
tail_wing_impact = GetEnt("tail_wing_impact1", "script_noteworthy");
PlayFXOnTag(trail_fx, tail_wing_impact, "tag_origin");
PlayFXOnTag(explosion_fx, tail_wing_impact, "tag_origin");
level.player thread play_sound_on_entity( "hijk_explosion_lfe" );
wait 0.7333;
tail_wing_impact = GetEnt("tail_wing_impact2", "script_noteworthy");
PlayFX(tail_impact_fx, tail_wing_impact.origin);
wait 0.2667;
tail_wing_impact = GetEnt("tail_wing_impact3", "script_noteworthy");
explosionPos = level.crash_models[0] gettagorigin("J_RFin_tip2");
PlayFX(explosion_fx, explosionPos);
level.player thread play_sound_on_entity( "hijk_explosion_lfe" );
wait 1.7333;
tail_wing_impact = GetEnt("tail_wing_impact4", "script_noteworthy");
PlayFX(tail_impact_fx, tail_wing_impact.origin);
PlayFXOnTag(trail_fx, tail_wing_impact, "tag_origin");
level.player thread play_sound_on_entity( "hijk_explosion_lfe" );
wait 0.6;
exploder(2000);
aud_send_msg("tower_impact");
level notify("tail_hits_tower");
}
handle_tail_impact_fx()
{
tail_impact = GetEnt("tail_impact1", "script_noteworthy");
wait 18.5;
PlayFX(getfx("hijack_tail_impact"), tail_impact.origin);
PlayFXOnTag(getfx("hijack_tail_trail"), level.crash_models[0], "J_Tail_Sled");
level.crash_models[0] thread stop_fx_on_notify(getfx("hijack_tail_trail"), "sled_scrape_stop");
tail_impact = GetEnt("tail_impact2", "script_noteworthy");
wait 1.3;
PlayFX(getfx("hijack_tail_impact"), tail_impact.origin);
tail_impact = GetEnt("tail_spray", "script_noteworthy");
wait 1;
PlayFX(getfx("hijack_tail_spray"), tail_impact.origin);
}
fluorescentFlicker()
{
level endon("stop_flicker");
for ( ;; )
{
wait( randomfloatrange( .05, .1 ) );
self setLightIntensity( randomfloatrange( .25, 3.0 ) );
}
}
handle_pre_sled_lights()
{
flag_wait( "turn_on_crash_sled_lights" );
thread pre_sled_light();
}
pre_sled_light()
{
sled_fill_lights = getentarray("sled_fill_light", "script_noteworthy");
foreach(ent in sled_fill_lights)
{
id = getfx("hijack_fxlight_default_med_dim");
PlayFXOnTag(id, ent, "tag_origin");
ent thread stop_fx_on_notify(id, "crash_stop_pre_sled_lights");
}
}
handle_crash_lights()
{
sled_light_origins = getentarray("sled_emergency_light_fx", "script_noteworthy");
id = getfx("hijack_fxlight_red_blink_flicker");
foreach(ent in sled_light_origins)
{
PlayFXOnTag(id, ent, "tag_origin");
ent thread stop_fx_on_notify(id, "crash_impact");
}
thread sled_emergency_light_post_impact_flicker();
sled_spotlight_origin = getent("sled_emergency_spotlight_fx", "script_noteworthy");
level waittill("crash_sequence_done");
}
sled_emergency_light_post_impact_flicker()
{
level waittill("crash_impact");
wait 2.0;
sled_light_origins = getentarray("sled_emergency_light_fx", "script_noteworthy");
id = getfx("hijack_fxlight_red_blink_flicker");
foreach(ent in sled_light_origins)
{
PlayFXOnTag(id, ent, "tag_origin");
ent thread stop_fx_on_notify(id, "crash_throw_player");
}
}
stop_fx_on_notify(id,msg)
{
level waittill(msg);
StopFXOnTag(id, self, "tag_origin");
}
custom_fire_fx(guy)
{
guy.a.lastShootTime = gettime();
guy thread play_sound_on_tag( "weap_ak47_fire_npc", "tag_flash" );
PlayFXOnTag( getfx( "ak47_flash_wv_hijack_crash" ), guy, "tag_flash" );
weaporig = guy gettagorigin( "tag_weapon" );
dir = anglestoforward( guy getMuzzleAngle() );
pos = weaporig + ( dir * 1000 );
MagicBullet(guy.weapon, weaporig, pos);
}