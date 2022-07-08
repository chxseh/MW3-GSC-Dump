#include maps\_utility;
#include maps\_shg_common;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\hijack_code;
start_crash()
{
level.player GiveWeapon( "fnfiveseven" );
level.player SwitchToWeapon( "fnfiveseven" );
maps\_compass::setupMiniMap("compass_map_dcemp_static", "crash_minimap_corner");
setsaveddvar( "compassmaxrange", 50000 );
flag_set("show_crash_model");
level.door3 = getent( "intro_door3" , "targetname");
level.door3 MoveY( 50, .1);
level.commander = spawn_ally("commander");
level.president = spawn_ally("president");
level.hero_agent_01 = spawn_ally("hero_agent_01" );
level.advisor = spawn_ally("advisor", "end_scene_advisor");
level.daughter = spawn_targetname( "find_daughter_pre_crash" );
level.hero_agent_01 disable_ai_color();
level.commander set_force_color("c");
level.commander enable_ai_color();
level.daughter_struct = GetStruct("cargo_room_anim_struct","targetname");
pres_and_daughter = [];
pres_and_daughter[0] = level.president;
pres_and_daughter[1] = level.daughter;
level.daughter_struct thread anim_loop(pres_and_daughter,"post_find_loop");
flag_set("find_daughter_moment_finished");
aud_send_msg("cargo_room_zone_off");
level.daughter_struct thread anim_loop_solo(level.commander,"find_daughter_commander_loop" );
player_start_struct = GetStruct( "player_start_crash", "targetname" );
level.player setOrigin( player_start_struct.origin );
level.player setPlayerAngles( player_start_struct.angles );
level.player GiveWeapon( "fnfiveseven" );
level.player SwitchToWeapon( "fnfiveseven" );
hero_agent_node = GetNode("hero_agent_crash_node","targetname");
level.hero_agent_01 teleport_ai(hero_agent_node);
level.hero_agent_01 SetGoalNode(hero_agent_node);
thread setup_jump_to_rollers();
thread maps\hijack_crash_fx::handle_crash_lights();
thread maps\hijack_crash_fx::pre_sled_light();
thread open_cargo_door();
thread pre_plane_crash();
thread maps\hijack::setup_cloud_tunnel();
thread crash_objectives();
main();
level waittill("crash_teleport");
level.daughter_struct notify("stop_loop");
}
crash_init_flags()
{
flag_init("stop_managing_crash_player");
flag_init("crash_throw_player");
flag_init("hero_agent_ready_for_crash");
flag_init("commander_finished_wake_up_anim");
flag_init("stop_sun_crash_lerp");
flag_init("tower_is_down");
flag_init("crash_wait_timer_finished");
}
crash_objectives()
{
objective_add( obj("escape_pod"), "current", &"HIJACK_OBJ_ESCAPE_HATCH", level.hero_agent_01.origin );
Objective_OnEntity( obj("escape_pod"), level.hero_agent_01, (0, 0, 70));
level waittill("crash_teleport");
objective_state( obj("escape_pod"), "failed" );
}
#using_animtree( "animated_props" );
pre_plane_crash()
{
aud_send_msg("approaching_ground");
thread autosave_by_name( "pre_crash" );
thread plane_rumbling();
thread maps\hijack_airplane::stop_combat();
flag_wait("player_is_in_crash_room");
thread enemy_pre_crash_chatter();
flag_wait( "player_is_in_end_room" );
}
commander_pre_crash_door_anim()
{
level.commander endon("start_crash_anim");
level.daughter_struct notify( "stop_loop" );
level.commander StopAnimScripted();
anim_struct = GetStruct("cargo_room_anim_struct","targetname");
anim_struct anim_reach_solo(level.commander, "door1");
anim_struct anim_single_solo(level.commander,"door1");
level.commander thread anim_loop_solo(level.commander, "corner_standL_alert_twitch04", "stop_door_loop");
}
crash_room_door_blocker()
{
crash_door_blocker2 = getent("crash_door_blocker_2", "targetname");
crash_door_blocker2 NotSolid();
flag_wait_any("start_plane_crash_aisle_1", "start_plane_crash_aisle_2");
crash_door_blocker2 Solid();
}
#using_animtree( "animated_props" );
open_cargo_door()
{
foreach(model in level.crash_models)
{
model.animname = "generic";
model UseAnimTree(#animtree);
}
props = getent("hijack_crash_model_props", "script_noteworthy");
props thread anim_loop_solo(props, "hijack_pre_plane_crash_compartments", "stop loop");
doorprop = getent("hijack_crash_model_front_interior", "script_noteworthy");
aud_send_msg("pre_crash_door");
doorprop anim_single_solo(doorprop, "hijack_pre_plane_crash_door");
crash_door_blocker = getent("crash_door_blocker", "targetname");
crash_door_blocker NotSolid();
thread crash_room_door_blocker();
flag_wait("player_is_in_crash_room");
crash_door_blocker solid();
doorprop anim_single_solo(doorprop, "hijack_pre_plane_crash_door_close");
}
start_plane_crash()
{
thread main();
}
setup_jump_to_rollers()
{
level.org_view_roll = getent("org_view_roll", "targetname");
assert(isdefined(level.org_view_roll));
level.player playerSetGroundReferenceEnt(level.org_view_roll);
level.aRollers = [];
level.aRollers = array_add(level.aRollers, level.org_view_roll);
thread plane_rumbling();
array_thread(level.aRollers, ::rotate_rollers_roll, -10, 1, 0, 0);
wait(1);
array_thread(level.aRollers, ::rotate_rollers_roll, 20, 1.5, 0, 0);
wait(1.5);
array_thread(level.aRollers, ::rotate_rollers_roll, -10, 1, 0, 0);
level waittill("planecrash_approaching");
}
#using_animtree( "animated_props" );
main()
{
thread handle_crash_enemies();
thread maps\hijack_crash_fx::handle_crash_fx();
level.hero_agent_01 hero_agent_prepare_for_crash(level.crash_models[0]);
flag_wait_any("start_plane_crash_aisle_1", "start_plane_crash_aisle_2");
thread maps\hijack_airplane::airplane_cleanup();
level.using_aisle_1 = false;
attach_tag = "tag_player1_rotate";
reference_struct_front = GetStruct("struct_aisle2_front", "targetname");
reference_struct_back = GetStruct("struct_aisle2_back", "targetname");
reference_struct_left = GetStruct("struct_aisle2_left", "targetname");
reference_struct_right = GetStruct("struct_aisle2_right", "targetname");
if (flag("start_plane_crash_aisle_1"))
{
level.using_aisle_1 = true;
}
delayThread(0.75, ::quickfade, 0.05);
old_plane_models = level.crash_models;
i=0;
foreach(model in old_plane_models)
{
level.crash_models[i] = spawn("script_model",(0,0,0));
level.crash_models[i] SetModel(old_plane_models[i].model);
level.crash_models[i].animname = "generic";
level.crash_models[i] UseAnimTree(#animtree);
if(isdefined(model.script_noteworthy))
{
level.crash_models[i].script_noteworthy = model.script_noteworthy + "_new";
}
i++;
}
old_plane_models[0] UseAnimTree(#animtree);
old_plane_models[0].animname = "generic";
plane_crash_anim_firstframe(level.crash_models);
tag_origin_player_link = spawn_tag_origin();
attach_tag = "tag_player1_rotate";
if(!level.using_aisle_1)
{
}
calculate_plane_movement_limits(old_plane_models[0], attach_tag);
tag_origin_player_link LinkTo(level.crash_models[0], attach_tag, (0, 0, 0), (0, 0, 0));
level.groundent = tag_origin_player_link;
level.player PlayerSetGroundReferenceEnt(tag_origin_player_link);
level.attach_tag = attach_tag;
level notify("planecrash_approaching");
level notify("crash_lights_out");
wait_for_agents_to_align_for_crash();
level.hero_agent_01.ignoreall = true;
thread handle_crash_sunlight();
Earthquake( 0.3, 1.2, level.player.origin, 200000 );
thread quickfade(0.05);
flag_clear( "in_flight" );
wait .05;
fwd_percent = (reference_struct_front.origin[0] - level.player.origin[0]) /
(reference_struct_front.origin[0] - reference_struct_back.origin[0]);
fwd_percent = clamp(fwd_percent, 0.0, 1.0);
right_percent = (reference_struct_left.origin[1] - level.player.origin[1]) /
(reference_struct_left.origin[1] - reference_struct_right.origin[1]);
right_percent = clamp(right_percent, 0.0, 1.0);
teleport_crash_ents(old_plane_models[1], level.crash_models[1]);
maps\_compass::setupMiniMap("compass_map_dcemp_static", "crash_minimap_corner");
setsaveddvar( "compassmaxrange", 50000 );
SetSkyboxIndex(1);
level.player thread maps\_wii_utility::wii_play_rumble_loop_on_entity( "wii_hijack_plane_medium" );
level.hero_agent_01 thread handle_hero_agent_crash();
level.commander thread handle_commander_crash();
level notify("crash_teleport");
thread plane_crash_anim(level.crash_models);
thread crash_manage_player_position_new(level.crash_models[0], fwd_percent, right_percent, level.using_aisle_1);
thread crash_hit_throw_player(level.crash_models[0]);
flag_wait("stop_managing_crash_player");
transition_to_tarmac();
}
calculate_plane_movement_limits(model, attach_tag)
{
fwd_anim= %hijack_plane_crash_player_move_forward;
right_anim= %hijack_plane_crash_player_move_right;
tag_origin = spawn_tag_origin();
tag_origin LinkTo(model, attach_tag, (0,0,0), (0,0,0));
model SetAnim(fwd_anim, 1, 0, 0 );
model SetAnim(right_anim, 1, 0, 0 );
waittillframeend;
model SetAnimTime(fwd_anim, 1.0);
waittillframeend;
level.fwd_point = model GetTagOrigin(attach_tag);
model SetAnimTime(fwd_anim, 0.0);
waittillframeend;
level.back_point = model GetTagOrigin(attach_tag);
model SetAnimTime(right_anim, 1.0);
waittillframeend;
level.right_point = model GetTagOrigin(attach_tag);
model SetAnimTime(right_anim, 0.0);
waittillframeend;
level.left_point = model GetTagOrigin(attach_tag);
}
hero_agent_prepare_for_crash(planemodel)
{
level.hero_agent_01.animname = "generic";
level.hero_agent_01.disablearrivals = true;
level.hero_agent_01.disableexits = true;
planemodel anim_reach_solo( level.hero_agent_01, "planecrash_agent1", "tag_agent" );
flag_set("hero_agent_ready_for_crash");
}
wait_for_agents_to_align_for_crash()
{
}
pre_crash_radio_vo(model)
{
model waittillmatch("single anim", "vo_line");
radio_dialogue("hijack_plt_brace");
}
quickfade(outTime)
{
fade_out(outTime);
fade_in(0.05);
}
thread_spin()
{
while(true)
{
x = 0;
wait 0.05;
}
}
plane_crash_anim_firstframe(models)
{
struct_align_crash = GetStruct("hijack_crash_align", "targetname");
foreach(model in models)
{
model.animname = "generic";
}
struct_align_crash anim_first_frame(models, "hijack_plane_crash_anim");
}
plane_crash_anim(models)
{
aud_send_msg ("crash_sequence");
level notify("crash_anim_start");
struct_align_crash = GetStruct("hijack_crash_align", "targetname");
level thread notify_delay("luggage_falls_out", 15.5);
struct_align_crash thread plane_crash_trees();
thread pre_crash_radio_vo(models[0]);
thread crash_hit_ground_thread(models[0]);
aud_send_msg("suitcase_prop_sound_impact", models[0]);
tower = spawn_anim_model("crash_tower", (0,0,0));
towerlights = spawn_anim_model("crash_tower_lights", (0,0,0));
towerpieces[0] = tower;
towerpieces[1] = towerlights;
struct_align_crash thread anim_single(towerpieces, "hijack_plane_crash_anim");
towerlights thread tower_light_flicker();
thread plane_crash_audio_messages(models[0]);
engine = spawn_anim_model("crash_engine_1",(0,0,0));
models = array_add(models, engine);
thread handle_engine_swap(engine);
struct_align_crash anim_single(models, "hijack_plane_crash_anim");
level notify("crash_done");
flag_set("stop_managing_crash_player");
waittillframeend;
array_delete(level.crash_models);
}
tower_light_flicker()
{
level waittill("tail_hits_tower");
wait 0.3;
thread flag_set_delayed("tower_is_down", 2.0);
self hide();
wait 0.15;
self show();
scalar = 1.0;
while(!flag("tower_is_down"))
{
self hide();
wait_time = RandomFloatRange(0.1*scalar, 0.2*scalar);
wait(wait_time);
self show();
wait_time = RandomFloatRange(0.1*scalar, 0.5*scalar);
wait(wait_time);
scalar *= 0.80;
}
self Delete();
}
plane_crash_audio_messages(model)
{
level.crash_explosion_origin = spawn_tag_origin();
level.crash_explosion_origin LinkTo(model, "FX_R_Wing",(0,0,0),(0,0,0));
level.crash_breakaway_chunk = spawn_tag_origin();
level.crash_breakaway_chunk LinkTo(model, "J_Break_Chunk",(0,0,0),(0,0,0));
level waittill("crash_impact");
wait 0.5;
aud_send_msg("crash_chunk_breaks_away");
wait 1.0;
aud_send_msg("crash_explosion");
flag_wait("crash_throw_player");
level.crash_explosion_origin delete();
level.crash_breakaway_chunk delete();
}
handle_engine_swap(engineEnt)
{
engineEnt waittillmatch("single anim", "engine_fire");
engineEnt SetModel(level.scr_model["crash_engine_2"]);
}
plane_crash_trees()
{
tree1 = spawn_anim_model("pine_tree_lg");
tree2 = spawn_anim_model("pine_tree_lg");
tree3 = spawn_anim_model("pine_tree_sm");
tree4 = spawn_anim_model("pine_tree_sm");
tree5 = spawn_anim_model("pine_tree_lg");
tree6 = spawn_anim_model("pine_tree_sm");
self thread anim_single_solo(tree1, "crash_tree_1");
self thread anim_single_solo(tree2, "crash_tree_2");
self thread anim_single_solo(tree3, "crash_tree_3");
self thread anim_single_solo(tree4, "crash_tree_4");
self thread anim_single_solo(tree5, "crash_tree_5");
self thread anim_single_solo(tree6, "crash_tree_6");
flag_wait("crash_throw_player");
}
transition_to_tarmac()
{
level notify( "stop_rumbling" );
level.commander notify("stop_loop");
level.commander stopanimscripted();
thread maps\hijack_tarmac::tarmac_carnage();
level.player setweaponammostock ( "fnfiveseven", 60 );
maps\hijack_tarmac::main_script_thread();
}
CMPP_FORWARD_SCALE = 0.5;
CMPP_SIDE_SCALE = 0.5;
crash_manage_player_position_new(player_spot, fwd_percent, right_pct, is_using_aisle_1)
{
thread manage_player_movement_limits();
attach_tag = "tag_player1_rotate";
CMPP_FWD_ANIM = %hijack_plane_crash_player_move_forward;
CMPP_BACK_ANIM = %hijack_plane_crash_player_move_back;
CMPP_LEFT_ANIM = %hijack_plane_crash_player_move_left;
CMPP_RIGHT_ANIM = %hijack_plane_crash_player_move_right;
level.fwd_aisle_ranges = [];
level.fwd_aisle_ranges[0]["left"] = 0.30;
level.fwd_aisle_ranges[0]["right"] = 0.40;
level.fwd_aisle_ranges[0]["front"] = 1.0;
level.fwd_aisle_ranges[0]["back"] = 0.45;
level.fwd_aisle_ranges[1]["left"] = 0.70;
level.fwd_aisle_ranges[1]["right"] = 0.79;
level.fwd_aisle_ranges[1]["front"] = 1.0;
level.fwd_aisle_ranges[1]["back"] = 0.3;
level.side_aisle_ranges = [];
level.side_aisle_ranges[0]["back"] = 0.84;
level.side_aisle_ranges[0]["front"] = 0.9;
level.side_aisle_ranges[0]["left"] = 0.15;
level.side_aisle_ranges[0]["right"] = 1.0;
level.side_aisle_ranges[1]["back"] = 0.55;
level.side_aisle_ranges[1]["front"] = 0.6;
level.side_aisle_ranges[1]["left"] = 0.1;
level.side_aisle_ranges[1]["right"] = 1.0;
find_player_aisles(fwd_percent, right_pct);
cur_fwd_anim = CMPP_FWD_ANIM;
dest_fwd_anim = CMPP_FWD_ANIM;
player_spot SetAnim(cur_fwd_anim, 1, 0, 0);
player_spot SetAnimTime(cur_fwd_anim, fwd_percent);
cur_right_anim = CMPP_RIGHT_ANIM;
dest_right_anim = CMPP_RIGHT_ANIM;
player_spot SetAnim(cur_right_anim, 1, 0, 0);
player_spot SetAnimTime(cur_right_anim, right_pct);
level.player PlayerLinkToDelta(level.groundent, "tag_origin", 0.0, 180, 180, 70, 70, true);
fwd_movement_updated = false;
right_movement_updated = false;
playerThrown = false;
move_speed_scale = 1;
level.pushing_at_edge_time = 0;
level.pushing_at_edge_measure_time = GetTime();;
while(!flag("stop_managing_crash_player"))
{
if(!flag("crash_throw_player"))
{
if (!IsAlive(level.player))
{
normalized_movement = (0, 0, 0);
}
else
{
normalized_movement = level.player GetNormalizedMovement();
}
movement_strength = Distance((0, 0, 0), normalized_movement);
normalized_movement = (normalized_movement[0], normalized_movement[1] * -1, 0);
normalized_movement_angles = VectorToAngles(normalized_movement);
player_angles = level.player GetPlayerAngles();
if (IsDefined(level.groundent))
{
player_angles = CombineAngles(level.groundent.angles, player_angles);
}
fwd_movement_angle = CombineAngles(player_angles, normalized_movement_angles);
movement_vector = VectorNormalize(AnglesToForward(fwd_movement_angle));
spot_angles = player_spot GetTagAngles(attach_tag);
fwd_base = VectorNormalize(AnglesToForward(spot_angles));
right_base = VectorNormalize(AnglesToRight(spot_angles));
fwd_movement_vector_dot = VectorDot(movement_vector, fwd_base);
fwd_movement_strength = movement_strength * fwd_movement_vector_dot;
right_movement_vector_dot = VectorDot(movement_vector, right_base);
right_movement_strength = movement_strength * right_movement_vector_dot;
fwd_animtime = player_spot GetAnimTime(cur_fwd_anim);
fwd_animlength = GetAnimLength(cur_fwd_anim);
fwd_anim_fraction = fwd_animtime / fwd_animlength;
right_animtime = player_spot GetAnimTime(cur_right_anim);
right_animlength = GetAnimLength(cur_right_anim);
right_anim_fraction = right_animtime / right_animlength;
if (movement_strength == 0 || fwd_movement_strength == 0)
{
if (fwd_movement_updated)
{
player_spot SetAnim(cur_fwd_anim, 1, 0, 0);
}
if (right_movement_updated)
{
player_spot SetAnim(cur_right_anim, 1, 0, 0);
}
fwd_movement_updated = false;
right_movement_updated = false;
wait(0.05);
continue;
}
override_fwd_scale = 1.0;
override_right_scale = 1.0;
move_fraction_max = 1.0;
move_fraction_min = 0.0;
if (fwd_movement_strength <= 0)
{
dest_fwd_anim = CMPP_BACK_ANIM;
}
else
{
dest_fwd_anim = CMPP_FWD_ANIM;
}
back_move_limit = 1.0;
fwd_move_limit = 1.0;
left_move_limit=1.0;
right_move_limit=1.0;
if(level.current_fwd_aisle != -1)
{
back_move_limit = 1.0 - level.fwd_aisle_ranges[level.current_fwd_aisle]["back"];
fwd_move_limit = level.fwd_aisle_ranges[level.current_fwd_aisle]["front"];
}
else
{
Assert(level.current_side_aisle != -1);
back_move_limit = 1.0 - level.side_aisle_ranges[level.current_side_aisle]["back"];
fwd_move_limit = level.side_aisle_ranges[level.current_side_aisle]["front"];
}
if(level.current_side_aisle != -1)
{
left_move_limit = 1.0 - level.side_aisle_ranges[level.current_side_aisle]["left"];
right_move_limit = level.side_aisle_ranges[level.current_side_aisle]["right"];
}
else
{
Assert(level.current_fwd_aisle != -1);
right_move_limit = level.fwd_aisle_ranges[level.current_fwd_aisle]["right"];
left_move_limit = 1.0 - level.fwd_aisle_ranges[level.current_fwd_aisle]["left"];
}
if(dest_fwd_anim == CMPP_BACK_ANIM)
{
projected_fwd_pct = fwd_animtime + 0.05*(abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale);
if(projected_fwd_pct > back_move_limit)
{
override_fwd_scale = 0.0;
fwd_animtime = back_move_limit;
player_spot SetAnimTime(CMPP_BACK_ANIM, back_move_limit);
}
}
if(dest_fwd_anim == CMPP_FWD_ANIM)
{
projected_fwd_pct = fwd_animtime + 0.05*(abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale);
if(projected_fwd_pct > fwd_move_limit)
{
override_fwd_scale = 0.0;
fwd_animtime = fwd_move_limit;
player_spot SetAnimTime(CMPP_BACK_ANIM, fwd_move_limit);
}
}
if(dest_right_anim == CMPP_LEFT_ANIM)
{
projected_left_pct = right_animtime + 0.05*(abs(right_movement_strength) * override_right_scale * CMPP_SIDE_SCALE * move_speed_scale);
if(projected_left_pct > left_move_limit)
{
override_right_scale = 0.0;
right_animtime = left_move_limit;
player_spot SetAnimTime(CMPP_LEFT_ANIM, left_move_limit);
}
}
if(dest_right_anim == CMPP_RIGHT_ANIM)
{
projected_right_pct = right_animtime + 0.05*(abs(right_movement_strength) * override_right_scale * CMPP_SIDE_SCALE * move_speed_scale);
if(projected_right_pct > right_move_limit)
{
override_right_scale = 0.0;
right_animtime = right_move_limit;
player_spot SetAnimTime(CMPP_RIGHT_ANIM, right_move_limit);
}
}
if (cur_fwd_anim != dest_fwd_anim)
{
player_spot ClearAnim(cur_fwd_anim, 0);
fwd_anim_fraction = 1 - fwd_anim_fraction;
fwd_anim_fraction = clamp(fwd_anim_fraction, move_fraction_min, move_fraction_max);
player_spot SetAnim(dest_fwd_anim, 1, 0, abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale);
player_spot SetAnimTime(dest_fwd_anim, fwd_anim_fraction);
cur_fwd_anim = dest_fwd_anim;
}
else
{
player_spot SetAnim(cur_fwd_anim, 1, 0, abs(fwd_movement_strength) * override_fwd_scale * CMPP_FORWARD_SCALE * move_speed_scale );
}
if (right_movement_strength < 0)
{
dest_right_anim = CMPP_LEFT_ANIM;
}
else
{
dest_right_anim = CMPP_RIGHT_ANIM;
}
if (cur_right_anim != dest_right_anim)
{
player_spot ClearAnim(cur_right_anim, 0);
right_anim_fraction = 1 - right_anim_fraction;
right_anim_fraction = clamp(right_anim_fraction, 0.0, 1.0);
player_spot SetAnim(dest_right_anim, 1, 0, abs(right_movement_strength) * override_right_scale* CMPP_SIDE_SCALE * move_speed_scale);
player_spot SetAnimTime(dest_right_anim, right_anim_fraction);
cur_right_anim = dest_right_anim;
}
else
{
player_spot SetAnim(cur_right_anim, 1, 0, abs(right_movement_strength) * CMPP_SIDE_SCALE * move_speed_scale);
}
fwd_movement_updated = true;
right_movement_updated = true;
if(fwd_movement_strength < 0 && cur_fwd_anim == CMPP_BACK_ANIM && (player_spot GetAnimTime(cur_fwd_anim)) > 0.99)
{
level.pushing_at_edge_time += (GetTime() - level.pushing_at_edge_measure_time) ;
if(level.pushing_at_edge_time > 1000)
{
thread player_falls_out();
return;
}
}
else
{
levelpushing_at_edge_time = 0;
}
level.pushing_at_edge_measure_time = GetTime();
wait(0.05);
fwd = player_spot GetAnimTime(cur_fwd_anim);
if(cur_fwd_anim == CMPP_BACK_ANIM)
{
fwd = 1.0 - fwd;
}
right = player_spot GetAnimTime(cur_right_anim);
if(cur_right_anim == CMPP_LEFT_ANIM)
{
right = 1.0 - right;
}
find_player_aisles( fwd, right );
}
else
{
if(!playerThrown)
{
playerThrown = true;
level.player FreezeControls(true);
player_spot SetAnim(CMPP_FWD_ANIM,1.0,0,3.0);
player_spot SetAnim(CMPP_BACK_ANIM,0.0,0);
rightTime = player_spot GetAnimTime(cur_right_anim);
if(rightTime > 0.80)
{
player_spot SetAnimTime(cur_right_anim, 0.80);
}
else if (rightTime < 0.35)
{
player_spot SetAnimTime(cur_right_anim, 0.35);
}
player_spot SetAnim(cur_right_anim,1.0,0.0,0.0);
wait 0.85;
level.player FreezeControls(false);
move_speed_scale = 0.6;
flag_clear("crash_throw_player");
dest_fwd_anim = CMPP_FWD_ANIM;
cur_fwd_anim = CMPP_FWD_ANIM;
fwd_anim_fraction = 1.0;
}
wait 0.05;
}
}
}
find_player_aisles(fwd_anim_pct, right_anim_pct)
{
level.current_fwd_aisle = -1;
best_fwd_aisle_index = -1;
best_fwd_aisle_dist = 1.0;
for(i=0; i<level.fwd_aisle_ranges.size; i++)
{
distFromAisleCenter = abs(right_anim_pct - 0.5 * (level.fwd_aisle_ranges[i]["left"] + level.fwd_aisle_ranges[i]["right"]));
if(right_anim_pct >= level.fwd_aisle_ranges[i]["left"] && right_anim_pct <= level.fwd_aisle_ranges[i]["right"])
{
level.current_fwd_aisle = i;
break;
}
if(distFromAisleCenter < best_fwd_aisle_dist)
{
best_fwd_aisle_dist = distFromAisleCenter;
best_fwd_aisle_index = i;
}
}
level.current_side_aisle = -1;
best_side_aisle_index = -1;
best_side_aisle_dist = 1.0;
for(i=0; i<level.side_aisle_ranges.size; i++)
{
distFromAisleCenter = abs(fwd_anim_pct - 0.5 * (level.side_aisle_ranges[i]["back"] + level.side_aisle_ranges[i]["front"]));
if(fwd_anim_pct >= level.side_aisle_ranges[i]["back"] && fwd_anim_pct <= level.side_aisle_ranges[i]["front"])
{
level.current_side_aisle = i;
break;
}
if(distFromAisleCenter < best_side_aisle_dist)
{
best_side_aisle_dist = distFromAisleCenter;
best_side_aisle_index = i;
}
}
if(level.current_fwd_aisle == -1 && level.current_side_aisle == -1)
{
if(best_side_aisle_dist < best_fwd_aisle_dist)
{
level.current_side_aisle = best_side_aisle_index;
}
else
{
level.current_fwd_aisle = best_fwd_aisle_index;
}
}
}
manage_player_movement_limits()
{
thread handle_left_aisle_limit();
thread handle_right_aisle_limit();
}
handle_left_aisle_limit()
{
level waittill("luggage_falls_out");
level.fwd_aisle_ranges[1]["back"] = 0.0;
}
handle_right_aisle_limit()
{
level waittill("agent_falls_out");
level.fwd_aisle_ranges[0]["back"] = 0.0;
}
teleport_to_crashmodel( oldModel, newModel)
{
if(!isdefined(level.helper))
{
level.helper = spawn_tag_origin();
}
level.helper.origin = oldmodel GetTagOrigin("J_Mid_Section");
localOffset = level.helper WorldToLocalCoords(self.origin);
level.helper.origin = newModel GetTagOrigin("J_Mid_Section");
newWorldLoc = level.helper LocalToWorldCoords(localOffset);
if(IsAI(self))
{
self ForceTeleport(newWorldLoc, self.angles);
}
else if(IsPlayer(self))
{
level.helper.origin = newWorldLoc;
level.helper.angles = self GetPlayerAngles();
self teleport_player(level.helper);
}
else
{
self.origin = newWorldLoc;
}
}
teleport_crash_ents(oldModel, newModel)
{
level.player teleport_to_crashmodel(oldModel, newModel);
level.hero_agent_01 teleport_to_crashmodel(oldModel, newModel);
level.hero_agent_01 LinkTo(newModel,"tag_agent",(0,0,0), (0,0,0));
level.commander teleport_to_crashmodel(oldModel, newModel);
level.commander LinkTo(newModel,"J_Mid_Section");
sled_ents = getentarray("sled_attach_ents", "targetname");
foreach(ent in sled_ents)
{
ent teleport_to_crashmodel(oldmodel, newModel);
ent setmodel("tag_origin");
ent Linkto(newModel, "J_Mid_Section" );
}
tail_ents = GetEntArray("tail_attach_ents","targetname");
foreach(ent in tail_ents)
{
ent teleport_to_crashmodel(oldModel, newModel);
ent setmodel("tag_origin");
ent Linkto(newModel, "J_Tail_Sled" );
}
}
handle_hero_agent_crash()
{
self.ignoreall = true;
self.animname = "generic";
aud_send_msg("agent_scream", level.hero_agent_01);
level thread notify_delay("agent_falls_out", 19.5);
level.crash_models[0] anim_single_solo(self,"planecrash_agent1", "tag_agent");
if( IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
self stop_magic_bullet_shield();
self.deathfunction = undefined;
waittillframeend;
self kill();
}
handle_commander_crash()
{
level.commander notify( "stop_door_loop" );
}
handle_crash_enemies()
{
level waittill("crash_teleport");
thread tail_enemy_spawn(GetEnt("planecrash_enemy1", "targetname"), "planecrash_enemy1");
thread tail_enemy_spawn(GetEnt("planecrash_enemy2", "targetname"), "planecrash_enemy2");
thread tail_enemy_spawn(GetEnt("planecrash_enemy3", "targetname"), "planecrash_enemy3");
thread tail_enemy_spawn(GetEnt("planecrash_enemy4", "targetname"), "planecrash_enemy4");
thread tail_enemy_spawn(GetEnt("planecrash_enemy5", "targetname"), "planecrash_enemy5");
thread tail_enemy_spawn(GetEnt("planecrash_enemy6", "targetname"), "planecrash_enemy6");
}
tail_enemy_spawn(spawner, anim_name)
{
ai = spawner spawn_ai();
ai.ignoreall = true;
ai LinkTo(level.crash_models[0], "tag_enemy", (0,0,0), (0,0,0));
ai.dontShootStraight = true;
level.crash_models[0] thread anim_generic(ai, anim_name, "tag_enemy");
ai.allowdeath = true;
ai.noragdoll = true;
level waittill("crash_done");
if(isdefined(ai))
{
ai delete();
}
}
shell_shock(name, duration)
{
self ShellShock( name, duration );
}
player_falls_out()
{
player_rig = spawn_anim_model( "player_rig", level.player.origin );
player_rig.angles = level.player.angles;
player_rig SetAnimTree();
level.player DisableWeapons();
level.player SetStance("stand");
level.player AllowCrouch(false);
level.player delayThread(0.75, ::shell_shock, "hijack_airplane", 3.0 );
aud_send_msg("crash_death");
player_rig LinkTo(level.crash_models[0], level.attach_tag, (0,0,0),(0,180,0));
level.player PlayerLinkToAbsolute( player_rig, "tag_player");
level.player PlayerSetGroundReferenceEnt(undefined);
animlen = GetAnimLength(player_rig getanim("crash_fall_out"));
level.crash_models[0] thread anim_single_solo( player_rig, "crash_fall_out", level.attach_tag);
wait animlen - .5;
setDvar( "ui_deadquote", &"HIJACK_FELL_OUT_OF_PLANE" );
level notify( "mission failed" );
missionFailedWrapper();
}
handle_crash_sunlight()
{
SetSunLight(0,0,0);
level waittill("crash_impact");
setsaveddvar( "sm_sunSampleSizeNear", 2.5 );
enableforcedsunshadows();
ResetSunLight();
thread sunlight_flicker();
thread sunlight_direction_lerp();
flag_wait("crash_throw_player");
DisableForcedSunShadows();
setsaveddvar( "sm_sunSampleSizeNear", 0.25 );
}
sunlight_flicker()
{
wait 0.5;
current_val = (0,0,0);
thread sunlight_flicker_lifetime_values();
while(!flag("stop_sun_crash_lerp"))
{
scale = RandomFloatRange(level.crash_light_scale_min, level.crash_light_scale_max);
wait(RandomFloatRange(0.1, 0.3));
current_val = level.crash_light_val_base * scale;
SetSunLight(current_val[0], current_val[1], current_val[2]);
}
end_value = (0.878431, 0.443137, 0.121569);
sun_lerp_value(current_val, end_value, 0.5);
}
sunlight_flicker_lifetime_values()
{
crash_light_val_base_start = (0.878431, 0.443137, 0.121569);
crash_light_val_base_end = (0.965, 0.847, 0.584);
crash_light_scale_min_start = 1.2;
crash_light_scale_max_start = 3.0;
crash_light_scale_min_end = 0.9;
crash_light_scale_max_end = 0.98;
level.crash_light_val_base = crash_light_val_base_start;
level.crash_light_scale_min = crash_light_scale_min_start;
level.crash_light_scale_max = crash_light_scale_max_start;
total_time = 13;
life =total_time ;
while(life > 0)
{
pct = (total_time - life)/total_time;
pct = pct*pct;
level.crash_light_val_base = VectorLerp(crash_light_val_base_start, crash_light_val_base_end, pct);
level.crash_light_scale_min = linear_interpolate(pct, crash_light_scale_min_start, crash_light_scale_min_end);
level.crash_light_scale_max = linear_interpolate(pct, crash_light_scale_max_start, crash_light_scale_max_end);
life -= 0.1;
wait 0.1;
}
flag_set("stop_sun_crash_lerp");
}
sun_lerp_value(start, end, time)
{
timeLeft = time;
pct = 0;
while(timeLeft > 0)
{
timeLeft -= 0.05;
pct = (time - timeLeft) / time;
val = start + (end - start) * pct;
SetSunLight(val[0], val[1], val[2]);
}
}
sunlight_direction_lerp()
{
start_sun_dir = (-5, -90, 0);
defaultYaw = -5;
start_yaw = -120;
end_yaw = -70;
angles_start = (-5, -130, 0);
angles_end = (-5, -80, 0);
start_light = (0.878431, 0.443137, 0.121569);
LerpSunAngles(start_sun_dir, angles_start, 0.05);
while(!flag("stop_sun_crash_lerp"))
{
LerpSunAngles(angles_end, angles_start , RandomFloatRange(0.5, 1.1) );
wait (RandomFloatRange(0.6, 0.9));
LerpSunAngles(angles_start, angles_end, 0.05);
wait 0.05;
}
}
crash_hit_ground_thread(planeModel)
{
planeModel waittillmatch("single anim", "hit_ground");
level notify("crash_impact");
level notify("crash_stop_pre_sled_lights");
thread handle_runner_lights();
maps\_wii_utility::wii_stop_all_rumbles();
Earthquake( 0.7, 1.2, level.player.origin, 200000 );
level.player DisableWeapons();
wait .5;
level.player thread maps\_wii_utility::wii_play_rumble_loop_on_entity("wii_hijack_plane_large");
thread plane_rumbling();
wait 1.5;
level.player EnableWeapons();
}
crash_hit_throw_player(planeModel)
{
planeModel waittillmatch("single anim", "hit_stop");
flag_set("crash_throw_player");
level notify("crash_stop_flashing_lights");
level notify("sled_scrape_stop");
maps\_wii_utility::wii_stop_all_rumbles();
level notify("stop_rumbling");
lookatEnt = getstruct("player_crash_end_lookat", "targetname");
player_dest = getent("crash_player_dest_2", "script_noteworthy");
if(	level.using_aisle_1)
{
player_dest = getent("crash_player_dest_1", "script_noteworthy");
}
newPlayerAngles = VectorToAngles(lookatEnt.origin - player_dest.origin);
newPlayerAngles = (0,newPlayerAngles[1],0);
remove_all_weapons_post_crash();
newPlayerLinkTo = spawn_tag_origin();
newPlayerLinkTo.origin = planeModel GetTagOrigin(level.attach_tag);
newPlayerLinkTo.angles = planeModel GetTagAngles(level.attach_tag) + (10,180, 0);
newPlayerLinkTo linkto(level.groundent);
level.player PlayerLinkToBlend(newPlayerLinkTo, "tag_origin", .1, 0,0);
wait 0.1;
if(isdefined(level.commander))
{
level.commander stop_magic_bullet_shield();
level.commander delete();
level.commander = spawn_ally( "commander_tarmac", "tarmac_commander_tarmac" );
exitGoal = GetNode("commander_pre_ramp_node", "targetname");
level.commander teleport_ai(exitGoal);
level.commander Hide();
}
level.player ShellShock( "hijack_airplane", 2.5 );
level.player PlayRumbleOnEntity( "wii_damage_heavy" );
wait .3;
planeModel waittillmatch("single anim", "hit_end");
flag_set("stop_managing_crash_player");
level.player PlayRumbleOnEntity( "wii_damage_heavy" );
thread maps\hijack_code::fade_out(.05);
wait .2;
scene_origin = getstruct("agent_helps_player_origin", "targetname");
player_rig = spawn_anim_model( "player_rig", level.player.origin );
level.player PlayerLinkToDelta(player_rig,"tag_player", 1.0, 10,10,10,10,true);
scene_origin anim_first_frame_solo(player_rig,"help_player_up");
level notify("crash_sequence_done");
SetSavedDvar( "compass", 0 );
SetSavedDvar( "hud_showStance", 0 );
SetSavedDvar( "ammoCounterHide", 1 );
SetSavedDvar( "actionSlotsHide", 1 );
level.player EnableSlowAim(0,0);
thread crash_wait_fade_timer();
WiiGeomStreamNotify(true);
level waittill( "geom_stream_done" );
flag_wait( "crash_wait_timer_finished" );
SetSavedDvar( "compass", 1 );
SetSavedDvar( "hud_showStance", 1 );
SetSavedDvar( "ammoCounterHide", 0 );
SetSavedDvar( "actionSlotsHide", 0 );
level.player DisableSlowAim();
level.commander show();
level.player AllowCrouch(false);
maps\_compass::setupMiniMap("compass_map_hijack_tarmac", "tarmac_minimap_corner");
setsaveddvar( "compassmaxrange", 3500 );
thread maps\hijack_code::fade_in(3.0);
thread post_crash_background_chatter();
thread player_wake_up(scene_origin, player_rig);
thread commander_wake_up(scene_origin);
thread animated_telephone();
}
crash_wait_fade_timer()
{
wait(10.0);
flag_set("crash_wait_timer_finished");
}
remove_all_weapons_post_crash()
{
level.player disableweapons();
}
animated_telephone()
{
scene_origin = getstruct("agent_helps_player_origin", "targetname");
telephone = GetEnt("post_crash_phone","targetname");
telephone.animname = "post_crash_telephone";
telephone SetAnimTree();
scene_origin thread anim_single_solo(telephone,"telephone_swing");
}
player_wake_up(scene_origin, player_rig)
{
thread player_blur();
level.player EnableSlowAim();
ForceYellowDot(true);
scene_origin anim_single_solo(player_rig,"help_player_up");
level.player Unlink();
player_rig Delete();
thread slowly_restore_aim_speed();
flag_set("player_on_feet_post_crash");
}
commander_wake_up(scene_origin)
{
level notify("start_commander_wake_up_anim");
scene_origin anim_single_solo(level.commander,"help_player_up");
flag_set("commander_finished_wake_up_anim");
}
slowly_restore_aim_speed()
{
wait_time = 0.4;
level.player EnableSlowAim(0.2,0.2);
wait(wait_time);
level.player EnableSlowAim(0.3,0.3);
wait(wait_time);
level.player EnableSlowAim(0.4,0.4);
wait(wait_time);
level.player EnableSlowAim(0.5,0.5);
wait(wait_time);
level.player EnableSlowAim(0.6,0.6);
wait(wait_time);
level.player EnableSlowAim(0.7,0.7);
wait(wait_time);
level.player EnableSlowAim(0.8,0.8);
wait(wait_time);
level.player EnableSlowAim(0.9,0.9);
wait(wait_time);
level.player DisableSlowAim();
}
player_blur()
{
setblur( 9, 1 );
wait(1);
setblur(0,1);
wait(2);
setblur(4,0.5);
wait(0.5);
setblur(0,0.5);
wait(2.5);
setblur( 5, 3);
wait(2.5);
setblur( 0, 1.5 );
wait(0.5);
start = level.dofDefault;
dof_injured = [];
dof_injured[ "nearStart" ] = .1;
dof_injured[ "nearEnd" ] = .2;
dof_injured[ "nearBlur" ] = 6.0;
dof_injured[ "farStart" ] = 50;
dof_injured[ "farEnd" ] = 100;
dof_injured[ "farBlur" ] = 5;
blend_dof( start, dof_injured, 2.5 );
flag_wait("player_on_feet_post_crash");
blend_dof( dof_injured, start, 5 );
}
post_crash_background_chatter()
{
level endon( "player_exit_plane_3" );
level.tarmac_radio_org = spawn( "script_origin", level.player.origin );
level.tarmac_radio_org linkto( level.player );
level.tarmac_radio_org.linked = true;
min_time = 1.75;
max_time = 3.0;
background_chatter( "hijack_rt1_stillinarea", level.tarmac_radio_org );
wait(RandomFloatRange( min_time, max_time ));
background_chatter( "hijack_rt2_command", level.tarmac_radio_org );
wait(RandomFloatRange( min_time, max_time ));
background_chatter( "hijack_rt3_scrambling", level.tarmac_radio_org );
wait(RandomFloatRange( min_time, max_time ));
background_chatter( "hijack_rt1_clearing", level.tarmac_radio_org );
wait(RandomFloatRange( min_time, max_time ));
background_chatter( "hijack_rt2_neutralized", level.tarmac_radio_org );
wait(RandomFloatRange( min_time-1, max_time-1 ));
background_chatter( "hijack_rt3_wounded", level.tarmac_radio_org );
wait(RandomFloatRange( min_time-1, max_time-1 ));
background_chatter( "hijack_rt1_verifylocation", level.tarmac_radio_org );
wait(RandomFloatRange( min_time-1, max_time-1 ));
background_chatter( "hijack_rt2_hamburg", level.tarmac_radio_org );
wait(RandomFloatRange( min_time-1, max_time-1 ));
background_chatter( "hijack_fso1_flightpath", level.tarmac_radio_org );
}
handle_runner_lights()
{
front_ent = getent("hijack_crash_model_front_interior_new", "script_noteworthy");
rear_ent = getent("hijack_crash_model_rear_interior_new", "script_noteworthy");
runner_lights_seton(false, front_ent,"plane_crash_lights_on_front", "plane_crash_lights_off_front");
runner_lights_seton(false, rear_ent,"plane_crash_lights_on_rear", "plane_crash_lights_off_rear");
wait 2.0;
thread flicker_model(front_ent,"stop_front_flicker", "plane_crash_lights_on_front", "plane_crash_lights_off_front");
wait 3.0;
runner_lights_seton(false, rear_ent,"plane_crash_lights_on_rear", "plane_crash_lights_off_rear");
flag_wait("crash_throw_player");
level notify("stop_front_flicker");
runner_lights_seton(false, front_ent,"plane_crash_lights_on_front", "plane_crash_lights_off_front");
runner_lights_seton(false, rear_ent,"plane_crash_lights_on_rear", "plane_crash_lights_off_rear");
}
enemy_pre_crash_chatter()
{
level endon("crash_teleport");
soundOrg = getent("crash_battlechatter_origin", "script_noteworthy");
while(true)
{
soundOrg play_sound_on_entity("RU_1_order_move_combat");
soundOrg play_sound_on_entity("RU_1_hostile_burst");
}
}
flicker_model(model, ender, onModelAlias, offModelAlias)
{
level endon(ender);
while(true)
{
runner_lights_seton(true, model, onModelAlias, offModelAlias);	;
wait(RandomFloatRange(0.05, 0.5));
runner_lights_seton(false, model, onModelAlias, offModelAlias);	;
wait(RandomFloatRange(0.05, 0.2));
}
}
runner_lights_seton(on, ent, onModelAlias, offModelAlias)
{
if(on)
{
ent SetModel(level.scr_model[onModelAlias]);
}
else
{
ent SetModel(level.scr_model[offModelAlias]);
}
}
