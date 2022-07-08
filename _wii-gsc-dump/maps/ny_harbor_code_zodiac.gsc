#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\ny_harbor_code_sdv;
#include maps\ny_harbor_code_sub;
#include maps\ny_harbor_code_vo;
#include maps\ny_hind;
#include maps\ny_hind_ai;
#include maps\_gameevents;
#include maps\_helicopter_globals;
#include maps\_audio_music;
#include maps\_shg_common;
#include maps\_hud_util;
CONST_MPHTOIPS = 17.6;
CONST_ZODIAC_WHEEL_OFF = -6.0;
dump_entities()
{
entities = getentarray();
foreach (ent in entities)
{
id = ent GetEntityNumber();
classname = "";
if (isdefined(ent.classname))
classname = ent.classname;
origin = ent.origin;
model = "";
if (isdefined(ent.model))
model = ent.model;
targetname = "";
if (isdefined(ent.targetname))
targetname = ent.targetname;
println(id + " : " + classname + ", " + model + ", " + targetname + ", (" + origin[0] + "," + origin[1] + ", " + origin[2] + ")" );
}
}
displace_zodiac_collision( positions, angles )
{
extra_displacement = 0;
if (isdefined(self.displacement))
extra_displacement = self.displacement;
displacement_scale = 1.0;
if (isdefined(self.displacement_scale))
displacement_scale = self.displacement_scale;
for (i=0; i<4; i++)
{
position = positions[i];
displacement = 0;
if (displacement_scale > 0)
{
current_patch = self.current_patch;
if (!isdefined(current_patch))
current_patch = level.escape_zodiac.current_patch;
if (isdefined(current_patch))
displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures[current_patch], position );
displacement *= displacement_scale;
}
displacement += extra_displacement + self.zodiac_zoff;
z = level.water_z + displacement;
if (isdefined(self.zodiac_wheel_blend))
{
wheel_z = position[2];
if (isdefined(self.zodiac_wheel_offset))
{
wheel_z += self.zodiac_wheel_offset;
}
blend = self.zodiac_wheel_blend;
z = z*(1-blend) + wheel_z*blend;
}
origin = (position[0], position[1], z);
self.zodiac_coll[i].origin = origin;
self.zodiac_coll[i].angles = (0,angles[1]+60,0);
}
}
displace_zodiac()
{
CONST_WHEEL_TAGS = [ "tag_wheel_front_left", "tag_wheel_front_right", "tag_wheel_back_left", "tag_wheel_back_right" ];
self endon("death");
for (i=0; i<4; i++)
{
self.zodiac_coll[i] Hide();
if (isdefined(level.zodiac_colls))
level.zodiac_colls[level.zodiac_colls.size] = self.zodiac_coll[i];
else
level.zodiac_colls[0] = self.zodiac_coll[i];
}
while (true)
{
if (!isdefined(self.manual_displace))
{
angles = self.angles;
vel = 0.0 * (self Vehicle_GetVelocity());
positions = [];
for (i=0; i<4; i++)
{
positions[i] = (self GetTagOrigin( CONST_WHEEL_TAGS[i] )) + vel;
}
self displace_zodiac_collision( positions, angles );
}
wait 0.05;
}
}
displace_zodiac_collision_at_position( position )
{
CONST_WHEEL_TAGS = [ "tag_wheel_front_left", "tag_wheel_front_right", "tag_wheel_back_left", "tag_wheel_back_right" ];
delta = position - self.origin;
positions = [];
angles = self.angles;
for (i=0; i<4; i++)
{
positions[i] = delta + self GetTagOrigin( CONST_WHEEL_TAGS[i] );
}
self displace_zodiac_collision( positions, angles );
}
track_water_patch( targetnames, zoff )
{
self endon("death");
patches = [];
foreach (targetname in targetnames)
{
patches[targetname] = getent( targetname, "targetname" );
patches[targetname] Hide();
}
if (!isdefined(self.current_patch))
self.current_patch = targetnames[0];
}
test_water_patch_switch()
{
level.player endon("death");
patchnames = [ "water_patch", "water_patch_med", "water_patch_calm" ];
patchidx = 0;
while (true)
{
while (!level.player usebuttonpressed())
wait 0.05;
while (level.player usebuttonpressed())
wait 0.05;
patchidx++;
if (patchidx >= patchnames.size)
patchidx = 0;
self.current_patch = patchnames[patchidx];
level.player SetWaterSheeting( 1, 0.5 );
}
}
zodiac_setup( zoff, colltgt )
{
self.zodiac_coll[0] = getent( colltgt+"a", "targetname");
self.zodiac_coll[1] = getent( colltgt+"b", "targetname");
self.zodiac_coll[2] = getent( colltgt+"c", "targetname");
self.zodiac_coll[3] = getent( colltgt+"d", "targetname");
self.zodiac_zoff = zoff;
self vehphys_clearautodisable();
self thread zodiac_treadfx();
self thread zodiac_physics();
self thread vehicle_scripts\_zodiac_drive::drive_vehicle( true, true );
self thread displace_zodiac( );
wait 0.05;
self Vehicle_teleport((self.origin[0], self.origin[1], self.zodiac_coll[0].origin[2] + 24), self.angles );
}
hold_zodiac_in_place()
{
start_origin = self.origin;
start_yaw = self.angles[1];
while (!flag( "get_on_zodiac" ))
{
origin = (start_origin[0], start_origin[1], self.origin[2]);
angles = (self.angles[0], start_yaw, self.angles[2]);
self Vehicle_Teleport( origin, angles );
wait 0.05;
}
}
wait_to_get_on_zodiac()
{
wait 0.5;
thread vo_zodiac_ride();
thread sky_battle();
thread setup_boat_destruction();
thread sub_deck_fail();
zoff = -36;
set_water_sheating_time( "bump_small_start", "bump_big_start" );
patchnames = [ "water_patch", "water_patch_med", "water_patch_calm" ];
level.escape_zodiac thread zodiac_setup( zoff, "zodiac_collision_");
level.ally_zodiac thread zodiac_setup( -60, "zodiac2_collision_" );
level.ally_zodiac.displacement = 10;
level.escape_zodiac.current_patch = "water_patch_med";
setup_ally_zodiac();
flag_wait("start_zodiac");
lines = [];
lines[lines.size] = "nyharbor_lns_gogo";
maps\ny_harbor::SetAbovewaterCharLighting();
thread put_sandman_on_zodiac_waving();
level.escape_zodiac thread hold_zodiac_in_place();
flag_wait( "get_on_zodiac" );
aud_send_msg("aud_zodiac_slide_se");
thread keep_dying_player_on_zodiac();
level.zodiac_rumble = get_rumble_ent( "steady_rumble" );
level.zodiac_rumble.intensity = 0;
level.player delaycall ( 1.85, ::PlayRumbleOnEntity, "falling_land" );
level.sandman notify("stop_waving");
delaythread ( 1.0, ::sub_fire_missiles );
level.sdv_player_legs hide();
play_exit_to_zodiac();
level.escape_zodiac thread track_water_patch( patchnames, zoff );
flag_set( "obj_escape_given" );
thread zodiac_slow_mo_setup();
thread zodiac_gameplay();
thread handle_rescue_seaknight();
thread handle_allies_zodiac();
level.escape_zodiac.current_patch = "water_patch_med";
while (level.escape_zodiac.veh_speed <= 0)
wait 0.05;
aud_send_msg("begin_zodiac_ride");
level.sandman.use_auto_pose = true;
}
setup_ally_zodiac()
{
level.truck = maps\ny_harbor::create_ally("squad_reno", "truck", "Truck", "r");
level.grinch = maps\ny_harbor::create_ally("squad_truck", "grinch", "Grinch", "r");
thread load_ally_zodiac();
level.ally_zodiac thread hold_zodiac_in_place();
}
sub_fire_missiles()
{
flag_set ( "start_opening_missile_doors" );
wait 4;
}
put_sandman_on_zodiac_waving()
{
actor = level.sandman;
actor endon("stop_waving");
boat = level.escape_zodiac;
boat Show();
boat Vehicle_teleport ( level.escape_zodiac_start.origin, level.escape_zodiac.angles );
boat anim_first_frame_solo( actor, "wave_from_zodiac", "tag_guy2" );
actor linkto( boat, "tag_guy2" );
while (true)
boat anim_single_solo( actor, "wave_from_zodiac", "tag_guy2" );
}
keep_dying_player_on_zodiac()
{
level.player waittill("death");
if (isdefined(level.player.driving) && level.player.driving)
{
while (true)
{
level.player PlayerLinkToDelta ( level.escape_zodiac, "tag_player", 0, 60, 90, 45, 45 );
wait 0.05;
}
}
}
catch_notetrack_switch_zodiac( boat1, boat2 )
{
self waittillmatch( "single anim", "swap_zodiac" );
boat1 SetModel("vehicle_zodiac_viewmodel_harbor");
boat2 SetModel("vehicle_zodiac_viewmodel_harbor");
boat1 DontCastShadows();
boat2 DontCastShadows();
level.ally_zodiac.displacement = 0;
}
move_node_to_tgt_then_to_veh_tgt( snode, vnode )
{
TIME_TO_S = 0.5;
TIME_TO_V = 0.5;
level.escape_zodiac.displacement_scale = 0.0;
self unlink();
self moveto( snode.origin, TIME_TO_S, 0, 0 );
self rotateto( snode.angles, TIME_TO_S, 0, 0 );
wait TIME_TO_S;
self.origin = snode.origin;
self.angles = snode.angles;
snode linkto( self );
self moveto( vnode.origin, TIME_TO_V, 0, 0 );
self rotateto( vnode.angles, TIME_TO_V, 0, 0 );
wait TIME_TO_V;
self moveto( vnode.origin, 0.05, 0, 0 );
self rotateto( vnode.angles, 0.05, 0, 0 );
wait 0.05;
self.origin = vnode.origin;
self.angles = vnode.angles;
self linkto( vnode );
}
ramp_displacement( target, time )
{
while (time > 0)
{
self.displacement += (target - self.displacement)*0.05/time;
time -= 0.05;
wait 0.05;
}
if (target == 0)
self.displacement = undefined;
else
self.displacement = target;
}
ramp_displacement_scale( target, time )
{
while (time > 0)
{
self.displacement_scale += (target - self.displacement_scale)*0.05/time;
time -= 0.05;
wait 0.05;
}
if (target == 1)
self.displacement_scale = undefined;
else
self.displacement_scale = target;
}
ramp_boatrocking_scale( target, time )
{
while (time > 0)
{
current = getdvarfloat( "vehBoatRockingScale" );
current += (target - current)*0.05/time;
setsaveddvar( "vehBoatRockingScale", ""+current );
time -= 0.05;
wait 0.05;
}
setsaveddvar( "vehBoatRockingScale", ""+target );
}
clear_start_from_cinematic( actor )
{
actor.start_from_cinematic = undefined;
}
draw_tag_axis( tag )
{
}
play_exit_to_zodiac()
{
level.player disableWeapons();
level.player FreezeControls( true );
if ( level.player getstance() == "crouch" || level.player getstance() == "prone" )
{
if ( level.player getstance() == "prone" )
waittime = 0.5;
else
waittime = 0.2;
level.player setstance ( "stand" );
wait waittime;
}
thread ramp_boatrocking_scale( 0.0, 0.5 );
actor = level.sandman;
boat = level.escape_zodiac;
boat makeUnusable();
scriptednode = getent("sub_board_anim_node","targetname");
offset = (0,0,18);
snode = spawn_tag_origin();
snode.origin = scriptednode.origin + offset;
snode.angles = scriptednode.angles;
znode = spawn_tag_origin();
znode.origin = scriptednode.origin + offset;
znode.angles = scriptednode.angles;
vnode = spawn_tag_origin();
vnode.origin = scriptednode.origin + offset;
vnode.angles = scriptednode.angles;
boat_model = spawn( "script_model", boat.origin );
boat_model.animname = "zodiac";
boat_model SetModel("vehicle_zodiac_boat");
boat_model SetAnimTree();
boat_model.targetname = "boat_model";
boat_model Hide();
tgt_boat_model = spawn( "script_model", boat.origin );
tgt_boat_model.animname = "zodiac";
tgt_boat_model SetModel("vehicle_zodiac_boat");
tgt_boat_model SetAnimTree();
tgt_boat_model.targetname = "tgt_boat_model";
tgt_boat_model Hide();
veh_boat_model = spawn( "script_model", boat.origin );
veh_boat_model.animname = "zodiac";
veh_boat_model SetModel("vehicle_zodiac_boat");
veh_boat_model SetAnimTree();
veh_boat_model.targetname = "veh_boat_model";
veh_boat_model Hide();
snode anim_first_frame_solo( tgt_boat_model, "exit_to_zodiac" );
vnode anim_first_frame_solo( veh_boat_model, "exit_to_zodiac" );
vnode linkto( veh_boat_model );
tgt_boat_model linkto( snode );
veh_boat_model match_origin_to_tag( boat, "tag_body", true );
guys[0] = level.sdv_player_arms;
guys[1] = level.sdv_player_legs;
snode anim_first_frame( guys, "exit_to_zodiac" );
guys[0] linkto( snode );
guys[1] linkto( snode );
level.sdv_player_arms hide();
level.player playerlinktoblend ( level.sdv_player_arms, "tag_player", 0.2 );
level.sdv_player_legs delaycall ( 0.2, ::show );
wait 0.05;
znode.origin = vnode.origin;
znode.angles = vnode.angles;
znode linkto( boat, "tag_body" );
znode anim_first_frame_solo( boat_model, "exit_to_zodiac" );
boat_model linkto( znode );
wait 0.05;
boat Hide();
boat_model Show();
actor linkto( boat_model, "tag_guy2" );
wait 0.1;
znode thread move_node_to_tgt_then_to_veh_tgt( snode, vnode );
znode thread anim_single_solo( boat_model, "exit_to_zodiac" );
boat_model thread anim_single_solo( actor, "exit_to_zodiac", "tag_guy2" );
level.sdv_player_arms delaycall ( 0.1, ::show );
level.sdv_player_arms thread catch_notetrack_switch_zodiac( boat_model, boat );
snode anim_single( guys, "exit_to_zodiac" );
level.sdv_player_legs unlink();
level.sdv_player_arms linkto( boat_model, "tag_player" );
foreach( guy in guys )
{
guy hide();
}
boat_model unlink();
actor unlink();
actor.a.boat_pose = "left";
actor.start_from_cinematic = true;
delaythread( 2, ::clear_start_from_cinematic, actor );
actor thread get_guy_on_zodiac( boat );
level.zodiac_playerZodiacModel = "vehicle_zodiac_viewmodel_harbor";
array_call ( guys, ::unlink );
array_call ( guys, ::linkto, boat, "tag_player" );
boat Show();
level.player FreezeControls( false );
SetSavedDvar( "vehCam_pitchClamp", "0.1" );
SetSavedDvar( "vehCam_yawClamp", "0.1" );
boat makeUsable();
boat useby(level.player);
level.player.driving = true;
boat makeUnusable();
flag_clear ( "player_off_path" );
flag_set("player_on_boat");
autosave_by_name ( "on_zodiac" );
thread zodiac_fail( true );
delaythread ( 5, ::zodiac_fail_monitor_speed );
delaythread ( 5, ::zodiac_fail_progress_gates );
level.zodiac_fail_speed = 30;
boat thread ramp_displacement_scale( 1.0, 2.0 );
thread ramp_boatrocking_scale( 1.0, 2.0 );
level.sandman disable_pain();
thread display_hint_timeout ( "hint_zodiac", 10 );
thread autosave_pre_carrier();
boat_model Delete();
tgt_boat_model Delete();
veh_boat_model Delete();
snode Delete();
znode Delete();
vnode Delete();
}
autosave_pre_carrier()
{
flag_wait ( "autosave_pre_carrier" );
maps\_autosave::_autosave_game_now_notrestart();
}
show_carrier()
{
carrier = getent( "carrier_model", "targetname" );
carrier show();
}
zodiac_gameplay()
{
level.zodiac_cg = false;
ship = getent ("sinking_ship", "targetname");
ship delete();
thread make_swimmers();
thread ship_squeeze_event();
thread destroyer_missile_fx();
thread destroyer_zubr_driveby();
thread make_zubrs();
thread show_hidden_ships();
thread zodiac_slow_mo_event();
thread exit_path();
thread missile_timing();
thread start_boat_player_crash();
thread zodiac_set_calm_waters();
thread zodiac_smoke_field();
thread hide_sub_missile_tubes();
thread zodiac_fail_flip_player();
}
start_boat_player_crash()
{
flag_wait("start_boat_crash");
}
zodiac_fail( skipSpeedCheck )
{
flag_wait ( "player_on_boat" );
if( !IsDefined( skipSpeedCheck ) )
thread zodiac_fail_monitor_speed();
level endon ( "chinook_success" );
level endon ( "pause_zodiac_fail" );
if( using_wii() && GetDvarInt( "free_roam" ) == 1 )
{
return;
}
while ( true )
{
flag_wait_any ( "player_too_slow", "player_off_path", "chinook_clean_entry" );
if ( !flag ( "switch_chinook" ) )
SetDvar( "ui_deadquote", "@NY_HARBOR_ZODIAC_FAIL_QUOTE" );
else
SetDvar( "ui_deadquote", "@NY_HARBOR_ZODIAC_FAIL_QUOTE_CHINOOK" );
if ( flag ( "chinook_clean_entry" ) )
SetDvar( "ui_deadquote", "@NY_HARBOR_ZODIAC_FAIL_QUOTE_CHINOOK_ENTRY" );
missionFailedWrapper();
break;
}
}
zodiac_fail_monitor_speed()
{
level endon ( "start_exit_path_align" );
level endon ( "pause_zodiac_fail" );
while ( true )
{
if ( flag ( "destroy_ally_zodiac" ) )
level.zodiac_fail_speed = 50;
if ( level.escape_zodiac vehicle_getspeed() <= level.zodiac_fail_speed )
{
flag_set ( "player_going_too_slow" );
thread zodiac_fail_monitor_speed_clear();
flag_wait_or_timeout ( "player_going_fast_enough", 5 );
wait 0.1;
if ( !flag ( "player_going_fast_enough" ) )
{
flag_set ( "player_too_slow" );
}
else
{
flag_clear ( "player_going_too_slow" );
flag_clear ( "player_going_fast_enough" );
}
}
wait 0.1;
}
}
zodiac_fail_monitor_speed_clear()
{
level endon ( "stop_monitor_speed_clear" );
level endon ( "pause_zodiac_fail" );
level endon ( "start_exit_path_align" );
while ( true )
{
if ( level.escape_zodiac vehicle_getspeed() >= level.zodiac_fail_speed )
{
flag_set ( "player_going_fast_enough" );
level notify ( "stop_monitor_speed_clear" );
}
wait 0.1;
}
}
zodiac_fail_flip_player()
{
level waittill ( "flip" );
level.sdv_player_arms hide();
level.sdv_player_legs hide();
if (isdefined(level.escape_zodiac.firstPerson))
level.escape_zodiac Detach( level.zodiac_playerHandModel, "tag_player" );
level.player dismountvehicle();
if ( isdefined ( level.player ) )
level.player kill();
linkobj = Spawn( "script_model", level.player.origin );
linkobj.angles = level.player.angles;
linkobj Hide();
linkobj SetModel( "zodiac_head_roller" );
linkobj LinkTo( level.escape_zodiac, "tag_player", ( 0, 0, 60 ), ( 0, 0, 0 ) );
offset_obj = Spawn( "script_model", level.player.origin );
offset_obj SetModel( "zodiac_head_roller" );
offset_obj LinkTo( linkobj, "tag_player", ( 0, 0, -60 ), ( 0, 0, 0 ) );
offset_obj.angles = level.player.angles;
offset_obj Hide();
blend_time = 1;
base_origin = level.escape_zodiac.origin;
coll = getent( "diver_death_collision", "targetname");
coll Hide();
coll.origin = base_origin;
coll linkto( level.escape_zodiac, "tag_body");
wait .1;
level.player PlayerLinkToDelta( offset_obj, "tag_player", 1.0, 0, 0, 0, 0 );
level.player PlayerSetGroundReferenceEnt( offset_obj );
boatvelocity = level.escape_zodiac Vehicle_GetVelocity();
forward = AnglesToForward( level.escape_zodiac.angles );
right = AnglesToRight( level.escape_zodiac.angles );
sandman_hold = 0.15;
offset = boatvelocity*0.15 - 12*forward + 48*right;
if (VectorDot(forward,boatvelocity) < 0)
{
sandman_hold = 0.25;
}
exp_origin = level.player.origin + offset;
physicsexplosionsphere ( exp_origin, 125, 120, 0.1 );
wait sandman_hold;
wait 0.1;
boatvelocity = level.escape_zodiac Vehicle_GetVelocity();
exp_origin = level.sandman.origin + boatvelocity*0.10 + (0,0,24);
physicsexplosionsphere ( exp_origin, 250, 200, 1.0 );
}
zodiac_death_call_flip()
{
level.player waittill ( "death" );
level notify ( "flip" );
}
chinook_extraction_fail()
{
level endon ( "chinook_success" );
flag_wait ( "start_exit_path_align" );
wait 5;
if ( !flag ( "chinook_success" ) )
flag_set ( "player_off_path" );
}
zodiac_fail_progress_gates()
{
num_gates = 7;
level endon ( "flip" );
level endon ( "chinook_success" );
for ( i = 0; i <= num_gates; i++ )
{
flag_wait_or_timeout ( "zodiac_gate" + i, 8 );
if ( i == 7 )
wait 3;
if ( !flag ( "zodiac_gate" + i ) )
{
if ( !flag ( "start_boat_crash" ) )
flag_set ( "player_off_path" );
}
else
level notify ( "gate_passed" );
}
flag_wait ( "carrier_done" );
num_gates = 14;
for ( i = 8; i <= num_gates; i++ )
{
flag_wait_or_timeout ( "zodiac_gate" + i, 8 );
if ( !flag ( "zodiac_gate" + i ) )
flag_set ( "player_off_path" );
else
level notify ( "gate_passed" );
}
flag_wait_or_timeout ( "chinook_success", 10 );
if ( !flag ( "start_exit_path" ) )
flag_set ( "player_off_path" );
}
sub_deck_fail()
{
wait 15;
count = 0;
if( !flag( "get_on_zodiac" ) )
{
SetDvar( "ui_deadquote", "@NY_HARBOR_FAIL_SUB_DECK_ZODIAC" );
missionFailedWrapper();
}
}
missile_timing()
{
flag_wait ("spawn_torpedo_1");
ssn_12_0 = launch_s300( "big_missile0", "big_missile0_landed" );
thread wait_for_missile_hit( "big_missile0_landed", ssn_12_0 );
aud_send_msg("big_missile_launch_1", ssn_12_0);
delaythread ( 4, ::zodiac_water_impacts, "spawn_missile_1", 0, 1 );
thread kill_boat ( "big_missile0_landed", "ship2_squeeze", "ship2_squeeze_roll", "ship2_squeeze_roll_2" );
flag_wait ("spawn_missile_1");
wait 0.5;
ssn_12_1 = launch_ssn12( "enemy_missile2", "enemy_missile2_landed" );
thread wait_for_missile_hit( "enemy_missile2_landed", ssn_12_1 );
aud_send_msg("big_missile_launch_2", ssn_12_1);
s300_1 = launch_s300( "big_missile1", "big_missile1_landed" );
thread wait_for_missile_hit( "big_missile1_landed", s300_1 );
thread kill_boat_anim ( "big_missile1_landed", "ship_splode_1", "burya", "front" );
thread maps\ny_harbor_fx::disable_ambient_fx();
aud_send_msg("incoming_missile_to_boat", s300_1);
wait 0.6;
s300_2 = launch_s300( "big_missile3", "big_missile3_landed" );
thread wait_for_missile_hit( "big_missile3_landed", s300_2 );
thread kill_boat_anim ( "big_missile3_landed", "ship_splode_3", "burya", "front" );
aud_send_msg("incoming_missile_to_boat", s300_2);
flag_wait ("spawn_missile_2");
wait 1;
s300_3 = launch_s300( "big_missile2", "big_missile2_landed" );
thread wait_for_missile_hit( "big_missile2_landed", s300_3 );
thread kill_boat_anim ( "big_missile2_landed", "ship_splode_2", "burya", "mid" );
aud_send_msg("incoming_missile_to_boat", s300_3);
flag_wait ("spawn_second_missiles");
wait 0.5;
s300_4 = launch_s300( "big_missile5", "big_missile5_landed" );
thread wait_for_missile_hit( "big_missile5_landed", s300_4 );
thread kill_boat_anim ( "big_missile5_landed", "ship_splode_5", "burya", "mid" );
aud_send_msg("incoming_missile_to_boat", s300_4);
wait 0.5;
s300_5 = launch_s300( "big_missile4", "big_missile4_landed" );
thread wait_for_missile_hit( "big_missile4_landed", s300_5 );
thread kill_boat_anim ( "big_missile4_landed", "ship_splode_4", "burya", "rear" );
aud_send_msg("incoming_missile_to_boat", s300_5);
wait 5.4;
s300_6 = launch_s300( "big_missile6", "big_missile6_landed" );
thread wait_for_missile_hit( "big_missile6_landed", s300_6 );
thread kill_boat_anim ( "big_missile6_landed", "ship_splode_6", "burya", "front" );
aud_send_msg("incoming_missile_to_boat", s300_6);
flag_wait("exit_missile_trigger");
wait 5;
ssn_12_exit = launch_ssn12( "exit_missile_1", "big_missileE1_landed" );
thread wait_for_missile_hit( "big_missileE1_landed", ssn_12_exit );
}
missile_timing2()
{
wait 0.5;
ssn_12_exit = launch_ssn12( "exit_missile_1", "big_missileE1_landed" );
thread wait_for_missile_hit( "big_missileE1_landed", ssn_12_exit );
}
jet_timings1()
{
flag_wait("view_8");
aud_send_msg("spawn_f15_fighters_finale");
wait 2.5;
jet3 = spawn_vehicles_from_targetname_and_drive( "f15_03");
jet4 = spawn_vehicles_from_targetname_and_drive( "f15_04");
jet5 = spawn_vehicles_from_targetname_and_drive( "f15_05");
}
kill_boat(flg, boat, pos1, pos2)
{
loc1 = getent(pos1, "targetname");
loc2 = getent(pos2, "targetname");
ship = getent(boat, "targetname");
ship no_bobbing();
flag_wait (flg);
ship moveto(loc1.origin, 2.2, 0.2, 2);
ship rotateto(loc1.angles, 2.2, 0.2, 2);
wait 0.2;
flag_set("flag_destroyer_fx");
wait 0.3;
wait 1.0;
ship moveto(loc2.origin, 3, 1.7, 0.3);
ship rotateto(loc2.angles, 3, 1.7, 0.3);
}
kill_boat_anim ( wait_flag, boatname, animname, hit_loc )
{
boat = getent ( boatname, "targetname" );
boat_anim = getent ( boat.target, "targetname" );
boat_anim.animname = animname;
boat_anim setanimtree();
org = spawn ( "script_origin", boat.origin );
org.angles = boat.angles;
org linkto ( boat );
boat_anim linkto ( org );
flag_wait ( wait_flag );
boat no_bobbing();
org anim_first_frame_solo ( boat_anim, "destruct_" + hit_loc );
boat hide();
boat_anim show();
hit_locs = [];
hit_locs[0] = "front";
hit_locs[1] = "mid";
hit_locs[2] = "rear";
hit_locs = array_remove( hit_locs, hit_loc );
foreach( other_loc in hit_locs )
{
playfxontag(getfx("corvette_explosion_other"), boat_anim, "tag_deathfx_" + other_loc );
}
playfxontag(getfx("corvette_explosion_front"), boat_anim, "tag_deathfx_" + hit_loc );
explosionLoc = boat_anim getTagOrigin("tag_deathfx_" + hit_loc);
maps\ny_harbor_fx::update_fire_reflections_manager("corvette_explosion_front", (explosionLoc[0], explosionLoc[1], -225) );
flagname = "flag_" + boatname + "_fx";
flag_set(flagname);
org anim_single_solo ( boat_anim, "destruct_" + hit_loc );
}
setup_boat_destruction()
{
boats = [];
for ( i = 1; i < 7; i++ )
{
boat = getent ( "ship_splode_" + i, "targetname" );
boat_destruct = getent ( boat.target, "targetname" );
boat_destruct linkto ( boat );
boat_destruct hide();
}
}
launch_s300( name, flg )
{
s300 = spawn_vehicles_from_targetname_and_drive( name );
assert( s300.size > 0 );
s300[0].animname = "ss_n_12_missile";
s300[0] Vehicle_SetSpeed( 500, 100, 50 );
s300[0] thread play_s300fx( name );
aud_send_msg("missile_launch", s300[0] );
return s300[0];
}
launch_ssn12( name, flg )
{
ssn_12 = spawn_vehicles_from_targetname_and_drive( name );
assert( ssn_12.size > 0 );
ssn_12[0].animname = "ss_n_12_missile";
ssn_12[0] setanim( level.scr_anim["ss_n_12_missile"]["close_idle"], 1, 0 );
ssn_12[0] thread open_ssn12_wings();
ssn_12[0] Vehicle_SetSpeed( 500, 100, 50 );
ssn_12[0] thread play_ssn12fx_alt( name );
aud_send_msg("missile_launch", ssn_12[0] );
return ssn_12[0];
}
wait_for_missile_hit( name, missile )
{
missile endon("missile_hit");
flag_wait( name );
node = getvehiclenode( name, "targetname" );
if (isdefined(node))
missile thread missile_hit( node.origin, node.angles );
else
missile thread missile_hit( missile.origin, missile.angles );
if ( isdefined( missile ) )
{
missile thread missile_cleanup();
}
missile notify("missile_hit");
}
missile_hit( pos, angles )
{
dummy = spawn_tag_origin();
dummy.origin = pos;
dummy.angles = angles;
aud_send_msg( "little_ship_missile_hit", dummy.origin);
thread maps\ny_harbor_fx::play_missile_hit_screenfx(pos);
if( isDefined( self ) )
{
self delete();
}
wait 2;
dummy delete();
}
destroyer_missile_fx()
{
flag_wait( "big_missile0_landed" );
org = getstruct( "org_destroyer_fx", "targetname" );
aud_send_msg("big_ship_missile_hit", org.origin);
dummy = spawn_tag_origin();
dummy.origin = org.origin;
dummy.angles = org.angles;
PlayFxOnTag( getfx( "destroyer_missile_impact" ), dummy, "tag_origin" );
wait( 2 );
StopFxOnTag( getfx( "destroyer_missile_impact" ), dummy, "tag_origin" );
dummy delete();
}
destroyer_zubr_driveby()
{
flag_wait( "zubrs_destroyers" );
zubr = spawn_vehicle_from_targetname_and_drive( "destroyer_zubr" );
zubr thread maps\ny_harbor_fx::surface_zbur_treadfx();
flag_wait ( "start_boat_crash" );
zubr delete();
}
play_s300fx( name )
{
self endon("death");
if(name=="ssn12_1_r_i") exploder(690);
else exploder(691);
wait(.5);
if(name=="ssn12_1_r_i") exploder(692);
else exploder(693);
wait(.5);
wait(.5);
}
play_ssn12fx_alt( name )
{
self endon("death");
if(name=="ssn12_1_r_i") exploder(690);
else exploder(691);
wait(.5);
if(name=="ssn12_1_r_i") exploder(692);
else exploder(693);
wait(.5);
PlayFXOnTag( getfx( "ssn12_launch_smoke" ), self, "tag_tail" );
wait(.5);
}
open_ssn12_wings()
{
self endon("death");
wait 0.5;
self setanim( level.scr_anim["ss_n_12_missile"]["open"], 1, 0 );
}
missile_cleanup()
{
if ( ent_flag_exist( "engineeffects" ) )
ent_flag_clear( "engineeffects" );
if ( ent_flag_exist( "afterburners" ) )
ent_flag_clear( "afterburners" );
if ( ent_flag_exist( "contrails" ) )
ent_flag_clear( "contrails" );
wait 0.05;
self delete();
}
zodiac_set_calm_waters()
{
trigger_wait_targetname( "calm_waters" );
level.escape_zodiac.current_patch = "water_patch_calm";
}
hide_sub_missile_tubes()
{
flag_wait( "spawn_missile_1" );
thread maps\ny_harbor_code_sub::sub_missile_tubes_hide();
}
zodiac_smoke_field()
{
flag_wait( "start_smoke_field" );
orgs = getstructarray( "org_smoke", "targetname" );
foreach( org in orgs )
{
dummy = spawn_tag_origin();
dummy.origin = org.origin;
dummy.angles = org.angles;
}
}
smoke_fx()
{
PlayFXOnTag( getfx( "thin_black_smoke_L" ), self, "tag_origin" );
level waittill( "kill_smoke_field" );
StopFXOnTag( getfx( "thin_black_smoke_L" ), self, "tag_origin" );
}
determine_velocity_at_start( model, anm )
{
self anim_first_frame_solo( model, anm );
self thread anim_single_solo( model, anm );
wait 0.05;
start = model.origin;
wait 0.05;
end = model.origin;
model StopAnimScripted();
level.anim_start_vel[anm] = (end-start)*20;
}
zodiac_slow_mo_setup()
{
org = getstruct( "org_carrier_crash", "targetname" );
level.z_rail_1 = getent("carrier_slide_zodiac", "targetname");
level.z_rail_1.animname = "zodiac";
level.z_rail_1 SetAnimTree();
level.z_rail_1 hide();
level.z_rail_1 thread determine_velocity_at_start( level.z_rail_1, "carrier_start" );
wait 0.5;
level.z_rail_1.animname = "zodiac_player";
level.z_rail_1 thread determine_velocity_at_start( level.z_rail_1, "finale_escape" );
wait 0.5;
level.z_rail_1.animname = "zodiac";
}
move_close_in_time( target, curvel, tgtvel, time2converge )
{
threshdist = 0.5 * length(curvel) * 0.05;
prv_tgt_origin = target.origin;
prv_origin = self.origin;
firstframe = true;
time = 0;
rottime = time2converge;
if (time2converge > 0.20)
rottime = time2converge - 0.10;
delta_angles = ShortestDeltaAngle(self.angles,target.angles, (360,360,360));
self rotateto( self.angles + delta_angles, rottime, 0, 0 );
while (time < time2converge)
{
if (!firstframe)
{
curvel = 20 * (self.origin - prv_origin);
tgtvel = 20 * (target.origin - prv_tgt_origin);
}
prv_tgt_origin = target.origin;
prv_origin = self.origin;
firstframe = false;
ratio = time / time2converge;
omratio = 1 - ratio;
desired_vel = (omratio * curvel) + (ratio * tgtvel);
desired_pos = (omratio * self.origin) + (ratio * target.origin);
t = 1.0;
pred_position = desired_pos + t*desired_vel;
self moveto( pred_position, t, 0, 0 );
time += 0.05;
wait 0.05;
}
self.origin = target.origin;
self.angles = target.angles;
}
match_fov( vehicle, transtime )
{
level endon("stop_match_fov");
vehdef = spawnstruct();
vehcam_offset = (0,0,0);
vehdef.vehcam_offset = vehcam_offset;
vehdef.fovSpeed = CONST_MPHTOIPS*65.0;
vehdef.fovIncrease = 20.0;
vehdef.fovOffset = 0.0;
vehdef.rollInfluence = 0.6;
base_fov = GetDvarFloat("cg_fov");
time = 0;
prv_speed = 0.0;
dSpeed = 2*CONST_MPHTOIPS;
while (true)
{
speed = 0.0;
if (isdefined(vehicle.matching))
{
if (isdefined(vehicle.cur_speed))
speed = CONST_MPHTOIPS*vehicle.cur_speed;
else
speed = Length(vehicle.vel);
}
else
{
speed = CONST_MPHTOIPS* (vehicle Vehicle_GetSpeed());
}
diff = speed - prv_speed;
if (diff < -1*dSpeed)
diff = -1*dSpeed;
if (diff > dSpeed)
diff = dSpeed;
speed = prv_speed + diff;
prv_speed = speed;
eyevalues = calc_vehicle_fov( vehicle, vehdef, speed );
fovadd = eyevalues["fov"] - base_fov;
if (time < transtime)
{
fovadd *= time/transtime;
time += 0.05;
}
SetSavedDvar("cg_fovNonVehAdd", fovadd);
wait 0.05;
}
}
track_vel( ent )
{
ent endon("stop_tracking_vel");
prev_origin = ent.origin;
while (true)
{
if (isdefined(ent.self_move))
{
prev_origin = ent.origin;
if (ent.self_move > 0)
{
ent.vel = (ent.self_move/ent.base_self_move)*ent.base_vel;
self.cur_speed = Length(ent.vel)/CONST_MPHTOIPS;
ent.origin = ent.origin + 0.05*ent.vel;
}
else
{
ent.vel = (0,0,0);
}
}
else
{
ent.vel = (ent.origin - prev_origin)*20;
prev_origin = ent.origin;
}
self.vel = ent.vel;
if (isdefined(self.matching))
{
self zodiac_match( ent, ent.vel );
}
wait 0.05;
}
}
zodiac_teleport( origin, angles, vel )
{
maxdspeed = 0.5;
self displace_zodiac_collision_at_position( origin+0.0*(vel[0],vel[1],0) );
self vehicle_teleport( origin, angles );
speed = Length(vel)/CONST_MPHTOIPS;
if (isdefined(self.cur_speed))
{
dSpeed = speed - self.cur_speed;
if (abs(dSpeed) > maxdspeed)
{
if (dSpeed < 0)
dSpeed = -1*maxdspeed;
else
dSpeed = maxdspeed;
}
speed = self.cur_speed + dSpeed;
self.cur_speed = speed;
}
else
{
self.cur_speed = speed;
}
if (speed > 0)
level.escape_zodiac Vehicle_SetSpeedImmediate(speed,speed, speed);
}
zodiac_match( target, vel )
{
offset = self.origin - self GetTagOrigin("tag_body");
body_origin = target GetTagOrigin("tag_body");
origin = body_origin + offset + 0.10*(vel[0],vel[1],0);
angles = target GetTagAngles("tag_body");
if (self.matching_teleport > 0)
{
zodiac_teleport( origin, (0,angles[1],0), vel);
self.matching_teleport--;
}
else
{
maxdspeed = 0.5;
forward = AnglesToForward(angles);
forward = VectorNormalize((forward[0],forward[1],0));
speed = Length(vel)/CONST_MPHTOIPS;
if (isdefined(self.cur_speed))
{
dSpeed = speed - self.cur_speed;
if (abs(dSpeed) > maxdspeed)
{
if (dSpeed < 0)
dSpeed = -1*maxdspeed;
else
dSpeed = maxdspeed;
}
speed = self.cur_speed + dSpeed;
self.cur_speed = speed;
}
else
{
self.cur_speed = speed;
}
if ((speed > 0) && !level.player.driving)
{
level.escape_zodiac Vehicle_SetSpeedImmediate(speed,speed, speed);
level.escape_zodiac VehicleDriveTo( self.origin + 2400*forward, speed );
}
}
}
wait_to_start_matching()
{
wait 1.5;
level.escape_zodiac.matching = true;
level.escape_zodiac.matching_teleport = 55;
thread match_fov( level.escape_zodiac, 2.0 );
}
prep_escape_zodiac_for_slide_end()
{
level.escape_zodiac hide();
origin = level.ally_zodiac.origin - ( 120, 0, 0);
angles = level.escape_zodiac.angles;
vel = level.ally_zodiac Vehicle_GetVelocity();
level.escape_zodiac zodiac_teleport( origin, (0,angles[1],0), vel);
}
zodiac_slow_mo_event()
{
level.player endon("death");
flag_wait ( "spawn_dvora" );
org = getstruct( "org_carrier_crash", "targetname" );
org.origin = org.origin + (0,0,12);
level.dvora = spawn_vehicle_from_targetname( "dvora_crasher" );
level.dvora.animname = "dvora";
level.dvora godon();
level.dvora thread setup_dvora(org);
dmg_triggers = getentarray ( "dvora_mine_trigger", "targetname" );
array_thread ( dmg_triggers, ::dvora_mine_trigger_monitor );
foreach ( trigger in dmg_triggers )
{
trigger EnableLinkTo();
trigger linkto ( level.dvora );
}
level.dvora thread maps\ny_harbor_fx::surface_dvora_carrier_fx();
flag_wait ("start_boat_crash");
level.zodiac_rumble delaythread ( 0, ::rumble_ramp_to, 0.4, 0.4 );
level.zodiac_rumble delaythread ( 1, ::rumble_ramp_to, 0, 1 );
level.player enableinvulnerability();
level.player SetWaterSheeting( 0 );
zodiac_ref_tgt = spawn("script_model", level.z_rail_1.origin);
zodiac_ref_tgt SetModel("vehicle_zodiac_viewmodel_harbor");
zodiac_ref_tgt.animname = "zodiac";
zodiac_ref_tgt SetAnimTree();
zodiac_ref_tgt hide();
org anim_first_frame_solo( zodiac_ref_tgt, "carrier_start" );
zodiac_ref_start = zodiac_ref_tgt.origin;
patch = getent( level.escape_zodiac.current_patch, "targetname" );
patch hide();
level.player thread player_reload_silently();
aud_send_msg("pre_slo_mo_splash");
level.escape_zodiac thread maps\ny_harbor_fx::surface_escape_zodiac_bumbfx();
wait 0.25;
thread vehicle_scripts\_zodiac_drive::stop_1st_person( level.escape_zodiac );
level.escape_zodiac useby(level.player);
level.player.driving = false;
level.sandman.forceidle = true;
level.player unlink();
zodiac_model = spawn("script_model", level.escape_zodiac.origin);
level.escape_zodiac_fx = zodiac_model;
zodiac_model.angles = level.escape_zodiac.angles;
zodiac_model SetModel("vehicle_zodiac_viewmodel_harbor");
zodiac_model.animname = "zodiac";
zodiac_model SetAnimTree();
level.player PlayerLinkToDelta(zodiac_model, "tag_player", 0, 0, 0, 0, 0, false );
level.player allowmelee ( false );
level.sandman thread get_guy_on_zodiac( zodiac_model, true );
thread prep_escape_zodiac_for_slide_end();
level.zodiac_cg = true;
level.ally_zodiac vehicle_setspeed( 45, 12, 5 );
vel = level.escape_zodiac Vehicle_GetVelocity();
tgtvel = level.anim_start_vel[ "carrier_start" ];
distance = Distance(zodiac_model.origin, zodiac_ref_tgt.origin);
speed = 0.75*Length(vel) + 0.25*Length(tgtvel);
time2converge = distance/speed;
anim_start_origin = zodiac_ref_tgt.origin;
zodiac_ref_tgt.origin = anim_start_origin - time2converge*tgtvel;
zodiac_ref_tgt moveto( anim_start_origin, 0.25, 0, 0 );
zodiac_model move_close_in_time( zodiac_ref_tgt, vel, tgtvel, 0.25 );
level.z_rail_1 = zodiac_model;
level.escape_zodiac thread track_vel( zodiac_model );
boats = [];
boats[ 0 ] = level.z_rail_1;
level.dvora show();
level notify( "kill_smoke_field" );
level.dvora animscripted( "dvora_carrier_anim_started", org.origin, org.angles, level.scr_anim[ "dvora" ][ "carrier_start" ] );
level notify("msg_fx_playSecondSplash");
dvora_3 = spawn_vehicle_from_targetname_and_drive ( "dvora_3" );
aud_send_msg("slow_mo_dvora", dvora_3);
level notify ( "pause_zodiac_fail" );
flag_clear ( "player_off_path" );
org anim_single( boats, "carrier_start" );
thread carrier_slowmo_enable_player_weapon();
thread zodiac_slomo_open_view();
thread carrier_slow_mo_on();
level.dvora animscripted( "dvora_carrier_anim_started", org.origin, org.angles, level.scr_anim[ "dvora" ][ "carrier_breach" ] );
org anim_single( boats, "carrier_breach" );
level.player DisableWeapons();
level.player playerlinktoblend ( level.z_rail_1, "tag_player", .05, 0, 0 );
if( !flag( "dvora_destroyed" ) )
{
}
level.escape_zodiac.displacement = -12;
level.escape_zodiac.displacement_scale = 0.0;
thread wait_to_start_matching();
level.player disableinvulnerability();
thread dvora_kill_player();
level notify("msg_fx_play_lastsplash");
aud_send_msg("boat_slowmo_outro");
org anim_single( boats, "carrier_end" );
zodiac_model notify("stop_tracking_vel");
level.escape_zodiac.matching = undefined;
level.player SetWaterSheeting( 1, 5.0 );
level.escape_zodiac useby(level.player);
level.escape_zodiac makeUnusable();
zodiac_model LinkToBlendToTag( level.escape_zodiac, "tag_origin", false );
level.sandman thread get_guy_on_zodiac( level.escape_zodiac, true );
zodiac_model Hide();
level.escape_zodiac Show();
wait 0.05;
thread autosave_by_name ( "carrier_slide_done" );
thread zodiac_fail();
thread chinook_extraction_fail();
time2stop = 1.0;
zodiac_model.self_move = time2stop;
zodiac_model.base_self_move = time2stop;
zodiac_model.base_vel = (zodiac_model.vel[0], zodiac_model.vel[1], 0);
while ( time2stop > 0 )
{
if (level.player ThrottleButtonPressed())
break;
time2stop -= 0.05;
zodiac_model.self_move = time2stop;
wait 0.05;
}
level.escape_zodiac.matching = undefined;
level.player FreezeControls( false );
level.escape_zodiac ReturnPlayerControl();
level.player.driving = true;
level.escape_zodiac.veh_topspeed = 55;
flag_set( "carrier_done" );
level.escape_zodiac.current_patch = "water_patch_med";
level.zodiac_cg = false;
level.ally_zodiac thread keep_zodiac_ahead( level.escape_zodiac );
wait 0.1;
zodiac_model notify("stop_tracking_vel");
dDispl = -0.25;
if (level.escape_zodiac.displacement < 0)
dDispl = 0.25;
while ((level.escape_zodiac.displacement != 0) ||
(level.escape_zodiac.displacement_scale<1.0) ||
(isdefined(level.escape_zodiac.zodiac_wheel_blend) && (level.escape_zodiac.zodiac_wheel_blend > 0.0)) )
{
if (level.escape_zodiac.displacement != 0)
level.escape_zodiac.displacement += dDispl;
else
level.escape_zodiac.displacement = 0;
if (level.escape_zodiac.displacement_scale<1.0)
level.escape_zodiac.displacement_scale += 0.01;
else
level.escape_zodiac.displacement_scale = 1.0;
if (isdefined(level.escape_zodiac.zodiac_wheel_blend))
{
if (level.escape_zodiac.zodiac_wheel_blend > 0.0)
level.escape_zodiac.zodiac_wheel_blend -= 0.01;
else
level.escape_zodiac.zodiac_wheel_blend = 0.0;
}
wait 0.05;
}
level notify("stop_match_fov");
level.escape_zodiac.zodiac_wheel_blend = undefined;
wait 2.0;
level.sandman.forceidle = undefined;
zodiac_model Delete();
}
hide_player_vm_at_death()
{
level endon( "dvora_destroyed" );
level.player waittill("death");
level.sdv_player_arms Hide();
thread vehicle_scripts\_zodiac_drive::stop_1st_person( level.escape_zodiac );
level.player FreezeControls(true);
}
dvora_kill_player()
{
shots = 0;
if ( !flag ( "dvora_destroyed" ) )
{
thread hide_player_vm_at_death();
while ( !flag ( "dvora_destroyed" ) )
{
foreach ( mg in level.dvora.mgturret )
{
mg shootturret();
level.player dodamage ( 10, level.player.origin );
shots++;
}
wait 0.1;
if ( shots >= 30 )
{
SetDvar( "ui_deadquote", "@NY_HARBOR_CARRIER_FAIL" );
thread missionFailedWrapper();
while (true)
{
level.player PlayerLinkToDelta ( level.z_rail_1, "tag_player", 0, 60, 90, 45, 45 );
wait 0.05;
}
}
}
}
}
carrier_slowmo_enable_player_weapon()
{
wait 0.2;
level.player EnableWeapons();
level.player lerpviewangleclamp ( 0.25, 0.1, 0, 60, 60, 45, 45 );
}
zodiac_slomo_open_view()
{
flag_wait ( "dvora_guy3_dead" );
if ( !flag ( "carrier_done" ) )
level.player PlayerLinkToDelta ( level.z_rail_1, "tag_player", 0, 60, 90, 45, 45 );
}
carrier_slow_mo_on()
{
wait( 0.3 );
setSlowMotion( 1.0, .3, .1 );
aud_send_msg("start_carrier_slowmotion");
level.player enableslowaim();
wait 0.4;
setslowmotion ( 0.3, 1.0, 0.2 );
wait 0.2;
level.player disableslowaim();
}
dvora_rider_death( vehicle, explosion_offset, force, delay )
{
self.ragdoll_immediate = true;
self waittill("death");
forward = VectorNormalize(level.player.origin - self.origin);
up = (0,0,1);
right = vectorcross(forward,up);
if (false && isdefined(vehicle))
{
scl = 0.2;
vel_offset = 0.05*vehicle.vel;
origin = self.origin + scl*((explosion_offset[0]*forward) + (explosion_offset[1]*right) + (0,0,explosion_offset[2]));
origin = origin - vel_offset;
radius = Distance(origin,self.origin);
force *= 1.5;
}
else
{
radius = Length(explosion_offset);
origin = self.origin + (explosion_offset[0]*forward) + (explosion_offset[1]*right) + (0,0,explosion_offset[2]);
}
if (delay>0)
wait delay;
if (isdefined(self))
{
radius = Length(explosion_offset);
origin = self.origin + (explosion_offset[0]*forward) + (explosion_offset[1]*right) + (0,0,explosion_offset[2]);
}
PhysicsExplosionSphere( origin, 1.5*radius, radius, force );
}
track_velocity()
{
self endon("death");
self.vel = (0,0,0);
prv_origin = self.origin;
while (true)
{
self.vel = 20*(self.origin - prv_origin);
prv_origin = self.origin;
foreach (rider in self.riders)
{
if ( isdefined ( rider ) && isalive ( rider ) )
rider.ragdoll_start_vel = self.vel;
}
wait 0.05;
}
}
setup_dvora(org)
{
self thread track_velocity();
foreach( turret in self.mgturret )
{
turret setTurretCanAiDetach( false );
turret setconvergencetime ( 0, "yaw" );
}
level.dvora.mgturret [ 0 ] settargetentity ( level.ally_zodiac, (0, 0, 0) );
level.dvora.mgturret [ 1 ] settargetentity ( level.escape_zodiac, (0, 0, 0) );
ragdoll_exp_offsets = [ (100,0,0), (100,0,0), (-100,0,0), (-100,0,0) ];
ragdoll_exp_force = [ 1000, 1000, 1000, 1000 ];
ragdoll_exp_delay = [ 0.05, 0.05, 0.05, 0.05 ];
foreach( i,rider in self.riders )
{
rider.ignoreme = true;
rider.accuracy = 0.06;
if ( rider.vehicle_position == 0 )
{
rider.ignoreall = true;
rider thread dvora_setdeathanim ( "ny_harbor_davora_front_turret_death", "tag_guy" );
rider kill();
}
else if ( rider.vehicle_position == 2 )
{
rider thread shoot_blanks();
rider thread dvora_setdeathanim ( "ny_harbor_davora_side_fall_death", "tag_guy3" );
}
else if ( rider.vehicle_position == 3 )
{
rider thread shoot_blanks();
rider thread dvora_setdeathanim ( "stand_death_shoulderback", "tag_guy4" );
}
}
self thread maps\ny_harbor_fx::surface_dvora_destroy_fx(org);
self maps\ny_harbor_fx::surface_dvora_npc_hit_thread();
self Hide();
foreach( rider in self.riders )
{
rider Hide();
}
wait 0.10;
self Show();
foreach( rider in self.riders )
{
rider Show();
}
self.riders[ 2 ] waittill( "death" );
level.zodiac_rumble delaythread ( 0, ::rumble_ramp_to, 0.7, 0.1 );
level.zodiac_rumble delaythread ( 0.75, ::rumble_ramp_to, 0, 0.5 );
flag_set( "dvora_hit" );
riders = [];
riders [ riders.size ] = self.riders [ 0 ];
riders [ riders.size ] = self.riders [ 1 ];
riders [ riders.size ] = self.riders [ 2 ];
riders [ riders.size ] = self.riders [ 3 ];
foreach ( mg in self.mgturret )
{
mg delaycall ( 0.25, ::hide );
}
array_thread ( riders, ::dvora_delete_riders );
corpses = getcorpsearray();
foreach( corpse in corpses )
corpse delete();
level.dvora setanim( level.scr_anim[ "dvora" ][ "destorychunk" ] );
self notify( "dvora_destroyed" );
wait( 0.2 );
aud_send_msg("stop_carrier_slowmotion");
flag_set( "dvora_destroyed" );
}
dvora_mine_trigger_monitor()
{
level endon ( "dvora_destroyed" );
while ( true )
{
self waittill ( "trigger", player );
if ( player == level.player )
if (isdefined ( level.dvora.riders[2] ) && isalive ( level.dvora.riders[2] ) )
level.dvora.riders[2] kill();
wait 0.05;
}
}
shoot_blanks()
{
self endon ( "death" );
for ( i = 0; i < 10; i++ )
{
self ShootBlank();
wait randomfloatrange ( 0.1, 0.4 );
}
}
dvora_delete_riders()
{
wait 0.25;
if ( isdefined ( self ) )
self delete();
}
dvora_setdeathanim( deathanim, guy_tag )
{
self endon("death");
wait 0.5;
self.noragdoll = true;
if ( self.vehicle_position == 0 )
{
if ( isdefined ( deathanim ) )
self.deathanim = GetGenericAnim( deathanim );
}
else
{
self.health = 9999;
self.animname = "generic";
self waittill ( "damage" );
if ( self.vehicle_position == 3 )
flag_set ( "dvora_guy3_dead" );
level.dvora anim_single_solo ( self, deathanim, guy_tag );
if ( isdefined ( self ) )
{
if ( self.vehicle_position == 3 )
level.dvora anim_loop_solo ( self, "ny_harbor_stand_death_shoulderback_pose", "stop_loop", guy_tag );
}
if ( isdefined ( self ) )
self delete();
}
}
move_dvora()
{
self endon( "dvora_destroyed" );
println ("go dvora 1");
wait 1;
self thread move_boat("dvora_crash_event1", 2.2);
wait 2.2;
self thread move_boat("dvora_crash_event2", 2.5);
wait 2.5;
self thread move_boat("dvora_crash_event3", 2);
wait 2;
println ("go dvora 4");
self thread move_boat("dvora_crash_event4", 2);
println ("done dvora 4");
wait 1.5;
}
monitor_dvora_count_shots()
{
level endon ( "dvora_destroyed" );
level.player endon ( "death" );
while ( true )
{
level.player waittill( "weapon_fired" );
level.player.dvora_shots++;
}
}
zubr_crash()
{
level.zubr thread move_boat("zubr_slow_mo3", 2);
wait 2;
level.zubr thread move_boat("zubr_slow_mo4", 1);
wait 1;
level.zubr thread move_boat("zubr_slow_mo5", 1);
wait 1;
level.zubr thread move_boat("zubr_slow_mo6", 1);
}
move_boat(pos, time)
{
loc = getent(pos, "targetname");
self moveto(loc.origin, time);
self rotateto(loc.angles, time);
}
ch46e_animated_rotors()
{
self endon( "death" );
xanim = self getanim( "rotors" );
length = getanimlength( xanim );
while ( true )
{
if ( !isdefined( self ) )
break;
self setanim( xanim );
wait length;
}
}
wait_to_start_exit_quake()
{
flag_wait ( "start_exit_path_earthquake" );
earthquake ( 0.2, 2, level.player.origin, 1024 );
}
zodiac_driveto( ref, speed, tgt_speed, threshdist, offset, time )
{
target = ref.origin + (offset* AnglesToForward(ref.angles));
self vehicledriveto(target, speed );
while (true)
{
newtarget = ref.origin + (offset* AnglesToForward(ref.angles));
if (distance(newtarget,target) > 12 )
{
target = newtarget;
self vehicledriveto(target, speed );
}
z2t = target - self.origin;
dist = Length(z2t);
if (dist < threshdist)
break;
forward = AnglesToForward(self.angles);
distfwd = VectorDot(forward, z2t);
if (distfwd < 0)
break;
if (time > 0)
{
offset *= 1 - (0.05/time);
speed += (tgt_speed - speed)*(0.05/time);
time -= 0.05;
}
else
{
offset = 0;
speed = tgt_speed;
}
wait 0.05;
}
}
move_displace_to_target( time, target )
{
self endon("death");
if (!isdefined(self.displacement))
return;
delta = (target - self.displacement) * 0.05/time;
while (time > 0)
{
self.displacement += delta;
time -= 0.05;
wait 0.05;
}
self.displacement = target;
}
switch_to_flyout_water()
{
wait 2;
ShowWater( 3 );
}
adjust_fov_to_default( fov)
{
blendTime = 1.0;
blendCount = blendTime/0.05;
blendFrac = 0.05/blendTime;
base_fov = GetDvarFloat("cg_fov");
fovadd = fov - base_fov;
dFov = blendFrac*fovadd;
blend = 0;
while (blendCount > 0)
{
wait 0.05;
fovadd = fovadd - dFov;
SetSavedDvar("cg_fovNonVehAdd",fovadd);
blend += blendFrac;
blendCount -= 1;
}
SetSavedDvar("cg_fovNonVehAdd",0);
}
exit_path()
{
level endon ( "player_off_path" );
finale_collision = getent("zodiac_finale_collision","targetname");
finale_collision.origin = finale_collision.origin + (0,0,12);
vehdef = spawnstruct();
vehcam_offset = (0,0,0);
vehdef.vehcam_offset = vehcam_offset;
vehdef.fovSpeed = CONST_MPHTOIPS*65.0;
vehdef.fovIncrease = 20.0;
vehdef.fovOffset = 0.0;
vehdef.rollInfluence = 0.6;
level.exit_chinook = spawn_vehicle_from_targetname ( "exit_vehicle" );
level.exit_chinook.animname = "ch46e";
level.exit_chinook SetAnimTree();
level.exit_chinook thread ch46e_animated_rotors();
level.chinook_model = getent( "chinook_model", "targetname" );
level.chinook_model.animname = "ch46e";
level.chinook_model SetAnimTree();
level.chinook_model hide();
level.exit_chinook hide();
thread wait_to_start_exit_quake();
zodiac_ref_tgt = spawn ( "script_model", ( 0, 0, 0 ) );
zodiac_ref_tgt setmodel ( "vehicle_zodiac_viewmodel_harbor" );
zodiac_ref_tgt.animname = "zodiac_player";
zodiac_ref_tgt setanimtree();
zodiac_ref_tgt Hide();
zodiac_tmp = spawn ( "script_model", ( 0, 0, 0 ) );
zodiac_tmp setmodel ( "vehicle_zodiac_viewmodel_harbor" );
zodiac_tmp.animname = "zodiac_player";
zodiac_tmp setanimtree();
zodiac_tmp Hide();
level.exit_chinook anim_first_frame_solo( zodiac_tmp, "finale_escape", "tag_guy9" );
zodiac_tmp linkto( level.exit_chinook, "tag_guy9" );
wait 0.05;
zodiac_ref_tgt match_origin_to_tag( zodiac_tmp, "tag_body", true );
forward = AnglesToForward( zodiac_ref_tgt.angles );
if (!isdefined(level.debug_exit_flight))
{
while (true)
{
flag_wait("start_exit_path_align");
zodiac_forward = AnglesToForward( level.escape_zodiac.angles );
dp = VectorDot( forward, zodiac_forward);
delta = zodiac_ref_tgt.origin - level.escape_zodiac.origin;
delta = VectorNormalize( delta );
dpo = VectorDot( forward, delta );
if ((dp > 0.8) && (dpo > 0.8))
break;
flag_clear("start_exit_path_align");
wait 0.05;
}
}
else
flag_wait("start_exit_path_align");
flag_set ( "chinook_success" );
level.exit_chinook notify ( "stop_loop" );
level.player allowcrouch ( false );
level.player allowprone ( false );
aud_send_msg("start_zodiac_into_chinook");
level.zodiac_cg = true;
level.escape_zodiac.displacement_scale = 0;
level.escape_zodiac thread move_displace_to_target( 0.8, -36 );
SetSavedDvar( "compass", 0 );
SetSavedDvar( "ammoCounterHide", 1 );
SetSavedDvar( "hud_showstance", 0 );
SetSavedDvar( "actionSlotsHide", 1 );
zodiac_model = spawn ( "script_model", level.escape_zodiac.origin );
zodiac_model setmodel ( "vehicle_zodiac_viewmodel_harbor" );
zodiac_model.animname = "zodiac_player";
zodiac_model setanimtree();
zodiac_model match_origin_to_tag( level.escape_zodiac, "tag_body", true );
level.escape_zodiac Hide();
level.sdv_player_arms unlink();
level.sdv_player_arms.origin = zodiac_model GetTagOrigin("tag_player");
level.sdv_player_arms.angles = zodiac_model GetTagAngles("tag_player");
level.sdv_player_arms dontinterpolate();
level.sdv_player_arms linkto( zodiac_model, "tag_player");
level.sandman dontinterpolate();
level.sandman linkto( zodiac_model, "tag_guy2");
fov = GetDvarFloat("cg_fov");
if (!isdefined(level.debug_exit_flight))
{
eyevalues = calc_vehicle_fov( level.escape_zodiac, vehdef );
fovadd = eyevalues["fov"] - fov;
fov = eyevalues["fov"];
if (isdefined(level.player.driving) && level.player.driving)
{
SetSavedDvar("cg_fovNonVehAdd",fovadd);
level.escape_zodiac useby( level.player );
level.escape_zodiac.veh_brake = 0;
level.player.driving = false;
}
level.player playerlinktoBlend( level.sdv_player_arms, "tag_player", 0, 0, 0 );
vel = level.escape_zodiac Vehicle_GetVelocity();
zspeed = level.escape_zodiac Vehicle_GetSpeed();
tgtvel = level.anim_start_vel[ "finale_escape" ];
speed = Length(tgtvel)/CONST_MPHTOIPS;
level.escape_zodiac zodiac_driveto( zodiac_ref_tgt, zspeed, speed, 120, -240, 1.0 );
}
delaythread ( 9, ::flag_set, "send_off_second_chinook" );
flag_set( "no_more_physics_effects" );
org = getstruct( "org_finale_escape", "targetname" );
zodiac_model unlink();
thread adjust_fov_to_default( fov);
zodiac_velocity = level.escape_zodiac Vehicle_GetVelocity();
zodiac_speed = max( Length( zodiac_velocity ), 0.01 );
distance_to_go = Length( zodiac_ref_tgt.origin - zodiac_model.origin );
time_to_go = distance_to_go / zodiac_speed;
server_steps = int ( time_to_go / 0.05 ) - 1;
interp_start = zodiac_model.origin;
interp_end = zodiac_ref_tgt.origin;
zodiac_model rotateto(zodiac_ref_tgt.angles, ( server_steps + 1 ) * 0.05, 0.0, 0.0);
for ( step = 0; step < server_steps; step++ )
{
interp = ( step + 1.0 ) / ( server_steps + 2 );
interp_pos = interp_start * ( 1.0 - interp ) + interp_end * interp;
zodiac_model.origin = interp_pos;
wait 0.05;
}
if (!isdefined(level.debug_exit_flight))
{
level.sdv_player_arms unlink();
}
guys = [];
guys[ 0 ] = zodiac_model;
guys[ 1 ] = level.sdv_player_arms;
guys[ 2 ] = level.ch_guy1;
guys[ 3 ] = level.ch_guy2;
guys[ 4 ] = level.sandman;
zodiac_model Show();
level.ch_guy1 Show();
level.ch_guy2 Show();
level.sandman Show();
if (isdefined(level.debug_exit_flight))
{
level.exit_chinook anim_first_frame( guys, "finale_escape", "tag_guy9" );
}
level.sdv_player_arms linkto ( level.exit_chinook, "tag_guy9" );
level.sandman linkto ( level.exit_chinook, "tag_guy9" );
thread vehicle_scripts\_zodiac_drive::stop_1st_person( level.escape_zodiac );
thread ally_zodiac_hide();
level.sdv_player_arms delayCall( 0.2, ::Show );
thread switch_to_flyout_water();
level.ch_guy1 delaycall ( 4, ::delete );
level.escape_zodiac delaycall( 2, ::Delete );
level.zodiac_rumble delaythread ( 0.25, ::rumble_ramp_to, 0.3, 0.1 );
level.zodiac_rumble delaythread ( 0.65, ::rumble_ramp_to, 0, 0.5 );
aud_send_msg( "mus_finale" );
aud_send_msg( "chinook_finale_escape" );
org thread anim_single_solo ( level.exit_chinook, "finale_escape" );
level.exit_chinook anim_single( guys, "finale_escape", "tag_guy9" );
chinook_exit_node = getstruct ( "chinook_exit", "targetname" );
wait 0.05;
level.exit_chinook thread maps\_vehicle::vehicle_paths_helicopter ( chinook_exit_node );
level.exit_chinook setmaxpitchroll ( 10, 80 );
level.player PlayerLinkToDelta ( level.sdv_player_arms, "tag_player", 1, 10, 10, 20, 5, true );
thread escape_flight();
flag_wait ( "exit_chinook_reduce_roll" );
level.exit_chinook setmaxpitchroll ( 10, 30 );
}
ally_zodiac_hide()
{
wait 5;
level.ally_zodiac hide();
if (isdefined(level.grinch))
level.grinch hide();
if (isdefined(level.truck))
level.truck hide();
}
escape_flight( )
{
dvora = spawn_vehicle_from_targetname_and_drive( "last_dvora" );
wait 0.05;
flag_set("exit_missile_trigger");
thread missile_timing2();
thread jet_timings1();
flag_set( "obj_escape_complete" );
delaythread( 7, ::ending_fadeout_nextmission );
if (isdefined(level.rescue_seaknight2))
level.rescue_seaknight2 Hide();
if (isdefined(level.chinook_model))
level.chinook_model hide();
flag_set( "finale_dialogue" );
flag_wait("view_8");
wait 6;
}
ending_fadeout_nextmission( )
{
video_fade_time = 2.0;
audio_delay_time	= 2.0;
audio_fade_time = 6.0;
level_fade_time = audio_delay_time + audio_delay_time;
black_overlay = create_client_overlay("black", 0, level.player);
black_overlay FadeOverTime(video_fade_time);
black_overlay.alpha = 1;
aud_send_msg("level_fade_to_black", [audio_delay_time, audio_fade_time]);
wait(level_fade_time + 3);
nextmission();
}
spawn_enemies()
{
spawner = getent( "zodiac_enemy", "targetname" );
level.zodiac_enemy = spawner spawn_ai(true);
}
show_hidden_ships()
{
ship1 = getent("ship_to_hide1", "targetname");
ship1 show();
}
ship_squeeze_event()
{
flag_wait("spawn_hind01");
heli = spawn_vehicle_from_targetname_and_drive("hind_squeeze");
aud_send_msg("spawn_ship_squeeze_hind", heli);
targets = ["hind_targets1", "hind_targets2", "hind_targets3", "hind_targets4", "hind_targets5", "hind_targets6", "hind_targets7", "hind_targets8", "hind_targets9", "hind_targets10", "hind_targets11"];
flag_wait ( "destroy_squeeze_heli" );
wait 2;
forward = AnglesToForward ( heli.angles );
org = spawn ( "script_origin", ( 0, 0, 0 ) );
org.origin = heli.origin - forward * 3000;
missile = magicbullet ( "tomahawk_missile", org.origin, heli.origin );
aud_send_msg("tomahawk_the_hind", missile);
attractor = missile_createattractorent ( heli, 999999, 999999 );
}
create_attractor()
{
thing2 = undefined;
level.generic_attractor = spawn ( "script_origin", (0, 0, 0));
thing2 = Missile_CreateAttractorEnt( level.generic_attractor, 10000, 999999 );
level.player_head_attractor moveto ((0,0,0), 0.05, 0, 0);
}
fire_missiles(targets)
{
thing = undefined;
level.generic_attractor = spawn ( "script_origin", (0, 0, 0));
thing = Missile_CreateAttractorEnt( level.generic_attractor, 10000, 999999 );
foreach (t in targets)
{
target = getent(t, "targetname");
if (isdefined(target))
{
level.generic_attractor moveto(target.origin, 1);
self thread fire_missile( "hind_rpg", 1, target );
}
wait .25;
}
}
make_falling_debris()
{
flag_wait("debris1");
thread falling_debris("f15_01", "f15_01_pos1", "f15_01_pos2", 5, 1.5 );
}
falling_debris(item, org1, org2, time1, time2)
{
thing = getent (item, "targetname");
pos1 = getent(org1, "targetname");
pos2 = getent(org2, "targetname");
thing moveto(pos1.origin, time1, time1/2);
thing rotateto (pos1.angles, time1, time1/2);
wait time1;
thing moveto(pos2.origin, time2, time2/4);
thing rotateto (pos2.angles, time2, time2/4);
wait time2;
thing delete();
}
make_zubrs()
{
flag_wait( "zubrs" );
dvora_1 = spawn_vehicle_from_targetname_and_drive( "dvora_1" );
aud_send_msg("dvora_1", dvora_1);
dvora_1 thread maps\ny_harbor_fx::surface_dvora_treadfx();
dvora_2 = spawn_vehicle_from_targetname_and_drive( "dvora_2" );
aud_send_msg("dvora_2", dvora_2);
dvora_2 thread maps\ny_harbor_fx::surface_dvora_treadfx();
flag_wait ( "start_boat_crash" );
dvora_1 delete();
dvora_2 delete();
}
make_swimmers()
{
flag_wait ("swimmers2");
}
make_fallers()
{
flag_wait ("fallers");
loc = getent("faller1_dest", "targetname");
fall_orgs = getentarray ("fallers", "targetname");
spawner = getent ("bodies_for_falling", "targetname");
water_level = loc getorigin();
while (!flag("swimmers2"))
{
foreach (guy in fall_orgs)
{
thread setup_fallers(guy, loc, spawner);
wait 1;
}
}
}
make_fallers2()
{
flag_wait ("fallers2");
loc = getent("fallers2_water", "targetname");
fall_orgs = getentarray ("fallers2", "targetname");
spawner = getent ("bodies_for_falling2", "targetname");
water_level = loc getorigin();
while (!flag("fallers2_end"))
{
foreach (guy in fall_orgs)
{
thread setup_fallers(guy, loc, spawner);
wait 1;
}
}
}
setup_fallers(org, dest, spawner)
{
guy = spawner spawn_ai(true);
guy gun_remove();
anime = org.animation;
guy forceTeleport( org.origin, org.angles );
dummy = maps\_vehicle_aianim::convert_guy_to_drone( guy );
tagO = spawn_tag_origin();
tagO.origin = org.origin;
dummy thread anim_generic_loop (dummy, anime, "stop_loop");
dummy LinkTo(tagO);
vect = dest getorigin();
loc = org getorigin();
falling = true;
time = 0;
tagO moveto ((loc[0], loc[1], vect[2]) , 2, 1);
wait 2;
dummy delete();
tagO delete();
}
setup_swimmers(guys, raft)
{
swimmers = getentarray(guys, "script_noteworthy");
boat = getent (raft, "targetname");
foreach (swimmer in swimmers)
{
org = swimmer getorigin ();
dest = boat getorigin ();
dist = distance(swimmer.origin, boat.origin);
time = dist/52;
swimmer MoveTo (dest, time);
wait 0.05;
}
}
move_the_swimmer(forward)
{
println(forward);
dest = self.origin + (forward * 1000);
time = randomfloatrange(10.0, 15.0);
self MoveTo (dest, time);
}
setup_floating_bodies()
{
spawners = getentarray ("bodies_for_harbor", "targetname");
origns = getentarray ("harbor_surface_floater", "targetname");
n = 0;
foreach (org in origns)
{
guy = spawners[n] spawn_ai(true);
guy gun_remove();
anime = org.animation;
guy forceTeleport( org.origin, org.angles );
dummy = maps\_vehicle_aianim::convert_guy_to_drone( guy );
org thread anim_generic_loop (dummy, anime, "stop_loop");
if (n < (spawners.size - 1))
n++;
else
n = 0;
wait 0.1;
}
}
open_seaknight_doors( flg )
{
flag_wait( flg );
self.animname = "ch46e";
self anim_single_solo( self, "open_rear" );
self anim_loop_solo( self, "open_rear_loop" );
}
start_extraction()
{
flag_wait( "switch_chinook" );
chinooks = [];
chinooks [ 1 ] = level.exit_chinook;
level.exit_chinook show();
level.rescue_seaknight2 delete();
aud_send_msg("show_exit_chinook", level.exit_chinook);
org = getstruct( "org_finale_escape", "targetname" );
level.ch_guy1 = getent ( "ch_guy1", "targetname" );
level.ch_guy1.animname = "ch_guy1";
level.ch_guy1 assign_animtree();
level.ch_guy1 attach ( "head_tank_a_pilot", "" );
level.ch_guy2 = getent ( "ch_guy2", "targetname" );
level.ch_guy2.animname = "ch_guy2";
level.ch_guy2 assign_animtree();
level.ch_guy2 attach ( "head_tank_b_pilot", "" );
level.ch_guy1 linktoblendtotag (level.exit_chinook, "tag_guy9" );
level.ch_guy2 linktoblendtotag (level.exit_chinook, "tag_guy9" );
level.exit_chinook thread anim_loop_solo ( level.ch_guy2, "chinook_idle", "stop_loop", "tag_guy9" );
level.exit_chinook thread anim_loop_solo ( level.ch_guy1, "chinook_idle", "stop_loop", "tag_guy9" );
org anim_single( chinooks, "chinook_landing" );
wait 0.05;
org thread anim_loop( chinooks, "chinook_idle" );
}
handle_rescue_seaknight()
{
println("---------------------------------start helicopter");
flag_wait( "get_on_zodiac" );
flag_wait ("spawn_chinook");
thread zodiac_water_impacts( "zodiac_stop_mortar2", 0, 1 );
println("---------------------------------spawn helicopter");
level.treadfx_immediate = true;
level.rescue_seaknight = spawn_vehicle_from_targetname_and_drive( "rescue_seaknight" );
level.treadfx_immediate = undefined;
level.rescue_seaknight.animname = "ch46e2";
level.rescue_seaknight setanimtree();
level.rescue_seaknight thread ch46e_animated_rotors();
level.rescue_seaknight2 = spawn_vehicle_from_targetname_and_drive( "rescue_seaknight2" );
level.rescue_seaknight2.animname = "ch46e2";
level.rescue_seaknight2 setanimtree();
level.rescue_seaknight2 thread ch46e_animated_rotors();
aud_send_msg("spawn_flyby_chinook_left", level.rescue_seaknight2);
aud_send_msg("spawn_flyby_chinook_right", level.rescue_seaknight);
flag_wait ("spawn_last_zubr");
thread start_extraction();
aud_send_msg( "mus_theres_our_bird" );
level.sandman.use_auto_pose = undefined;
level.sandman.scripted_boat_pose = "left";
}
ally_zodiac_wake_control()
{
flag_wait("ally_zodiac_jumping");
self ent_flag_clear("tread_active");
self notify("zodiac_treadfx_stop");
flag_wait("ally_zodiac_landing");
self ent_flag_set("tread_active");
self notify("zodiac_treadfx_go");
}
keep_zodiac_ahead( chaser )
{
self endon("death");
chaser endon("death");
while (level.zodiac_cg == false)
{
dist = Distance( self.origin, chaser.origin );
speed = chaser.veh_speed;
accel = 10;
if (flag("ally_zodiac_point_of_no_return") && !flag("ally_zodiac_landing"))
{
speed = 40;
accel = 30;
}
else if (dist < 1080)
{
speed = chaser.veh_speed + 5;
accel = 30;
}
else if (dist > 1560)
{
speed = chaser.veh_speed - 5;
if (speed < 0)
speed = 0;
accel = 20;
}
else
{
if (speed < 10)
speed = 10;
}
self vehicle_setspeed( speed, accel, accel );
wait 0.05;
}
}
handle_allies_zodiac()
{
flag_wait( "get_on_zodiac" );
wait 2.0;
thread gopath( level.ally_zodiac );
level.ally_zodiac thread keep_zodiac_ahead( level.escape_zodiac );
level.ally_zodiac thread ally_zodiac_wake_control();
}
ZODIAC_TREADFX_MOVETIME = .2;
ZODIAC_TREADFX_MOVETIMEFRACTION = 1 / ( ZODIAC_TREADFX_MOVETIME + .05 );
ZODIAC_TREADFX_HEIGHTOFFSET = ( 0, 0, 16 );
zodiac_treadfx_chaser( chaseobj )
{
PlayFXOnTag( getfx( "zodiac_wake_geotrail" ), self, "tag_origin" );
self NotSolid();
self Hide();
self endon( "death" );
chaseobj endon( "death" );
thread zodiac_treadfx_chaser_death( chaseobj );
chaseobj ent_flag_init( "in_air" );
chaseobj ent_flag_init( "tread_active" );
chaseobj ent_flag_set( "tread_active" );
childthread zodiac_treadfx_stop_notify( chaseobj );
childthread zodiac_treadfx_toggle( chaseobj );
while ( IsAlive( chaseobj ) )
{
self MoveTo( chaseobj GetTagOrigin( "tag_origin" ) + ZODIAC_TREADFX_HEIGHTOFFSET + ( chaseobj Vehicle_GetVelocity() / ZODIAC_TREADFX_MOVETIMEFRACTION ), ZODIAC_TREADFX_MOVETIME );
self RotateTo( ( 0, chaseobj.angles[ 1 ], 0 ), ZODIAC_TREADFX_MOVETIME ) ;
wait ZODIAC_TREADFX_MOVETIME + .05;
waittillframeend;
}
self Delete();
}
zodiac_treadfx_toggle( chaseobj )
{
chaseobj endon("death");
active = true;
prv_active = true;
prv_in_air = chaseobj ent_flag( "in_air" );
while ( 1 )
{
msg = chaseobj waittill_any_return( "zodiac_treadfx_stop", "zodiac_treadfx_go", "veh_leftground", "veh_landed" );
if ( msg == "veh_leftground" )
chaseobj ent_flag_set( "in_air" );
if ( msg == "veh_landed" )
chaseobj ent_flag_clear( "in_air" );
if ( msg == "zodiac_treadfx_go" )
active = true;
if ( msg == "zodiac_treadfx_stop" )
active = false;
in_air = chaseobj ent_flag( "in_air" );
if ((prv_active && !prv_in_air) &&
(!active || in_air) )
StopFXOnTag( getfx( "zodiac_wake_geotrail" ), self, "tag_origin" );
else if ((!prv_active || prv_in_air) &&
(active && !in_air))
PlayFXOnTag( getfx( "zodiac_wake_geotrail" ), self, "tag_origin" );
prv_active = active;
prv_in_air = in_air;
}
}
zodiac_treadfx_stop_notify( chaseobj )
{
chaseobj endon("death");
while ( 1 )
{
vel = chaseobj Vehicle_GetVelocity();
forward = AnglesToForward( chaseobj.angles );
dp = VectorDot( vel, forward );
if ( dp < -10 )
{
if (chaseobj ent_flag( "tread_active" ))
chaseobj notify( "zodiac_treadfx_stop" );
}
else if ( chaseobj Vehicle_GetSpeed() < 4 )
{
if (chaseobj ent_flag( "tread_active" ))
chaseobj notify( "zodiac_treadfx_stop" );
}
else if ( ! chaseobj ent_flag( "in_air" ) )
{
if (chaseobj ent_flag( "tread_active" ))
chaseobj notify( "zodiac_treadfx_go" );
}
wait .1;
}
}
zodiac_treadfx_chaser_death( chaseobj )
{
chaseobj waittill_any( "stop_bike", "death", "kill_treadfx" );
self Delete();
}
zodiac_treadfx()
{
chaser = Spawn( "script_model", self.origin );
chaser SetModel( self.model );
chaser.angles = ( 0, self.angles[ 1 ], 0 );
chaser thread zodiac_treadfx_chaser( self );
}
enemy_chase_boat_breadcrumb()
{
struct = SpawnStruct();
struct.origin = self.origin;
struct.angles = flat_angle( self.angles );
struct.spawn_time = GetTime();
level.breadcrumb[ level.breadcrumb.size ] = struct;
}
vehicle_dump()
{
predumpvehicles = GetEntArray( "script_vehicle", "code_classname" );
vehicles = [];
foreach ( vehicle in predumpvehicles )
{
if ( IsSpawner( vehicle ) )
continue;
struct = SpawnStruct();
struct.classname = vehicle.classname;
struct.origin = vehicle.origin;
struct.angles = vehicle.angles;
struct.speedbeforepause = vehicle Vehicle_GetSpeed();
struct.script_VehicleSpawngroup = vehicle.script_vehiclespawngroup;
struct.script_VehicleStartMove = vehicle.script_vehiclestartmove;
struct.model = vehicle.model;
struct.angles = vehicle.angles;
if ( IsDefined( level.playersride ) && vehicle == level.playersride )
struct.playersride = true;
vehicles[ vehicles.size ] = struct;
}
fileprint_launcher_start_file();
fileprint_map_start();
foreach ( i, vehicle in vehicles )
{
origin = fileprint_radiant_vec( vehicle.origin );
angles = fileprint_radiant_vec( vehicle.angles );
fileprint_map_entity_start();
fileprint_map_keypairprint( "classname", "script_struct" );
fileprint_map_keypairprint( "model", vehicle.model );
fileprint_map_keypairprint( "origin", origin );
fileprint_map_keypairprint( "angles", angles );
if ( IsDefined( vehicle.speedbeforepause ) )
fileprint_map_keypairprint( "current_speed", vehicle.speedbeforepause );
if ( IsDefined( vehicle.script_VehicleSpawngroup ) )
fileprint_map_keypairprint( "script_vehiclespawngroup", vehicle.script_VehicleSpawngroup );
if ( IsDefined( vehicle.script_VehicleStartMove ) )
fileprint_map_keypairprint( "script_vehiclestartmove", vehicle.script_VehicleStartMove );
fileprint_map_entity_end();
}
map_name = level.script + "_veh_ref.map";
fileprint_launcher_end_file( "/map_source/" + map_name );
launcher_write_clipboard( map_name );
}
draw_crumb( crumb, lastcrumb, fraction )
{
if ( !flag( "debug_crumbs" ) )
return;
left_spot = crumb.origin + AnglesToRight( crumb.angles ) * -1000 ;
right_spot = crumb.origin + AnglesToRight( crumb.angles ) * 1000 ;
color = ( fraction, 1 - fraction, 0 );
Line( left_spot, right_spot, color );
if ( !isdefined( lastcrumb ) )
return;
left_spot_last = lastcrumb.origin + AnglesToRight( lastcrumb.angles ) * -1000 ;
right_spot_last = lastcrumb.origin + AnglesToRight( lastcrumb.angles ) * 1000 ;
Line( left_spot, left_spot_last, color );
Line( right_spot, right_spot_last, color );
}
zodiac_physics()
{
self.bigjump_timedelta = 500;
self.jump_timedelta = 250;
self.event_time = -1;
self.event = [];
self.event[ "jump" ] = [];
self.event[ "jump" ][ "driver" ] = false;
self.event[ "jump" ][ "passenger" ] = false;
self.event[ "bump" ] = [];
self.event[ "bump" ][ "driver" ] = false;
self.event[ "bump" ][ "passenger" ] = false;
self.event[ "bump_big" ] = [];
self.event[ "bump_big" ][ "driver" ] = false;
self.event[ "bump_big" ][ "passenger" ] = false;
self.event[ "sway_left" ] = [];
self.event[ "sway_left" ][ "driver" ] = false;
self.event[ "sway_left" ][ "passenger" ] = false;
self.event[ "sway_right" ] = [];
self.event[ "sway_right" ][ "driver" ] = false;
self.event[ "sway_right" ][ "passenger" ] = false;
self childthread watchVelocity();
self childthread listen_leftground();
self childthread listen_landed();
self childthread listen_jolt();
self childthread listen_bounce();
self childthread listen_turn_spray();
}
zodiac_fx( fxName )
{
tag = "tag_origin";
if ( IsDefined( level._effect_tag[ fxName ] ) )
tag = level._effect_tag[ fxName ];
if ( IsDefined( level._effect[ fxName ] ) )
PlayFXOnTag( level._effect[ fxName ], self, tag );
}
listen_leftground()
{
nofx = true;
self endon( "death" );
flag_wait( "player_on_boat" );
for ( ;; )
{
self waittill( "veh_leftground" );
self.event_time = GetTime();
self.event[ "jump" ][ "driver" ] = true;
self.event[ "jump" ][ "passenger" ] = true;
if (!nofx)
zodiac_fx( "zodiac_leftground" );
}
}
listen_landed()
{
self endon( "death" );
wait 2;
flag_wait( "player_on_boat" );
for ( ;; )
{
self waittill( "veh_landed" );
self.event[ "jump" ][ "driver" ] = false;
self.event[ "jump" ][ "passenger" ] = false;
if ( self.event_time + self.bigjump_timedelta < GetTime() )
{
self.event[ "bump_big" ][ "driver" ] = true;
self.event[ "bump_big" ][ "passenger" ] = true;
if ( ! flag( "player_in_sight_of_boarding" ) )
thread water_bump( "bump_big" );
if ( self == level.players_boat )
{
zodiac_fx( "player_zodiac_bumpbig" );
aud_send_msg("zodiac_landed_big");
}
else
zodiac_fx( "zodiac_bumpbig" );
}
else if ( self.event_time + self.jump_timedelta < GetTime() )
{
self.event[ "bump" ][ "driver" ] = true;
self.event[ "bump" ][ "passenger" ] = true;
if ( ! flag( "player_in_sight_of_boarding" ) )
thread water_bump( "bump" );
if ( self == level.players_boat )
{
zodiac_fx( "player_zodiac_bump" );
aud_send_msg("zodiac_landed");
}
else
zodiac_fx( "zodiac_bump" );
}
}
}
trigger_set_water_sheating_time( bump_small, bump_big )
{
self waittill( "trigger" );
set_water_sheating_time( bump_small, bump_big );
}
set_water_sheating_time( bump_small, bump_big )
{
level.water_sheating_time[ "bump" ] = level.water_sheating_time[ bump_small ];
level.water_sheating_time[ "bump_big" ] = level.water_sheating_time[ bump_big ];
}
water_bump( bumptype )
{
if ( !isdefined( level.players_boat ) || self != level.players_boat )
return;
level endon( "missionfailed" );
if ( flag( "missionfailed" ) )
return;
if ( bumptype == "bump_big" )
level.player PlayRumbleOnEntity( "damage_heavy" );
else
level.player PlayRumbleOnEntity( "damage_light" );
if ( !flag( "no_more_physics_effects" ) )
level.player SetWaterSheeting( 1, level.water_sheating_time[ bumptype ] );
}
listen_jolt()
{
self endon( "death" );
flag_wait( "player_on_boat" );
for ( ;; )
{
self waittill( "veh_jolt", jolt );
if ( jolt[ 1 ] >= 0 )
{
self.event[ "sway_left" ][ "driver" ] = true;
self.event[ "sway_left" ][ "passenger" ] = true;
zodiac_fx( "zodiac_sway_left" );
}
else
{
self.event[ "sway_right" ][ "driver" ] = true;
self.event[ "sway_right" ][ "passenger" ] = true;
zodiac_fx( "zodiac_sway_right" );
}
}
}
listen_bounce()
{
nofx = true;
self endon( "death" );
flag_wait( "player_on_boat" );
for ( ;; )
{
self waittill( "veh_boatbounce", force );
if ( force < 75.0 )
{
}
else if ( force < 100.0 )
{
zodiac_fx( "zodiac_bounce_small_left" );
zodiac_fx( "zodiac_bounce_small_right" );
}
else
{
zodiac_fx( "zodiac_bounce_large_left" );
zodiac_fx( "zodiac_bounce_large_right" );
}
}
}
listen_turn_spray()
{
self endon( "death" );
while ( 1 )
{
velocity = self Vehicle_GetBodyVelocity();
if ( self Vehicle_GetSpeed() > 40 )
{
if ( velocity[ 1 ] < -150.0 )
{
zodiac_fx( "zodiac_sway_right" );
aud_send_msg("zodiac_sway_right");
}
else if ( velocity[ 1 ] > 150.0 )
{
zodiac_fx( "zodiac_sway_left" );
aud_send_msg("zodiac_sway_left");
}
}
else if ( self Vehicle_GetSpeed() > 10 )
{
if ( velocity[ 1 ] < -30.0 )
{
zodiac_fx( "zodiac_sway_right_light" );
aud_send_msg("zodiac_sway_right_light");
}
else if ( velocity[ 1 ] > 30.0 )
{
zodiac_fx( "zodiac_sway_left_light" );
aud_send_msg("zodiac_sway_left_light");
}
}
wait .05;
}
}
listen_collision()
{
self endon( "death" );
for ( ;; )
{
self waittill( "veh_collision", collision, start_vel );
foreach ( rider in self.riders )
{
if ( IsAlive( rider ) && !isdefined( rider.magic_bullet_shield ) )
{
rider Kill();
}
}
zodiac_fx( "zodiac_collision" );
}
}
watchVelocity()
{
self endon( "death" );
vel = self Vehicle_GetVelocity();
for ( ;; )
{
self.prevFrameVelocity = vel;
vel = self Vehicle_GetVelocity();
wait .05;
}
}
rumble_with_throttle()
{
rumble_ent = get_rumble_ent();
throttle_leveling_time = 3.4;
level_throttle = .01;
full_throttled_time = 0;
rumble_fraction = .13;
while ( 1 )
{
throttle = self Vehicle_GetThrottle();
full_throttled_time += .05;
if ( throttle < .5 )
{
full_throttled_time = 0;
throttle_level_fraction = 1;
}
else
{
throttle_level_fraction = 1 - ( full_throttled_time / throttle_leveling_time );
}
rumble_ent.intensity = ( throttle * rumble_fraction * throttle_level_fraction );
if ( full_throttled_time > throttle_leveling_time || self Vehicle_GetSpeed() > 43 )
{
full_throttled_time = throttle_leveling_time;
rumble_ent.intensity = 0;
}
wait .05;
if ( flag( "player_in_sight_of_boarding" ) )
break;
}
rumble_ent Delete();
}
boatrider_link( vehicle, noblend )
{
if (isdefined(noblend) && noblend)
{
self dontinterpolate();
self LinkTo( vehicle, "tag_guy2" );
}
else
self LinkToBlendToTag( vehicle, "tag_guy2", false );
}
boatrider_think( vehicle )
{
boatrider_link( vehicle );
self AllowedStances( "crouch" );
self.ignoreAll = false;
self.vehicle = vehicle;
self.force_canAttackEnemyNode = true;
self.fullAutoRangeSq = 2000 * 2000;
self.highlyAwareRadius = 2048;
self AnimCustom( maps\_zodiac_harbor_ai::think );
}
get_guy_on_zodiac( vehicle, bAlreadyOnBoat, noblend )
{
tag = "tag_guy2";
self teleport( vehicle getTagOrigin( tag ), vehicle getTagAngles( tag ) );
if (isdefined(bAlreadyOnBoat) && bAlreadyOnBoat)
{
self thread boatrider_link( vehicle, noblend );
self.vehicle = vehicle;
}
else
self thread boatrider_think(vehicle);
}
get_truck_on_zodiac()
{
level.truck.forced_startingposition = 0;
level.truck gun_remove();
level.ally_zodiac maps\_vehicle_aianim::guy_enter( level.truck );
level.ally_zodiac thread anim_generic_loop( level.truck, "zodiac_driver_idle", undefined, "tag_driver");
}
load_ally_zodiac()
{
level.grinch thread get_guy_on_zodiac( level.ally_zodiac );
get_truck_on_zodiac();
}
get_guys_on_zodiacs()
{
level.sandman thread get_guy_on_zodiac( level.escape_zodiac );
load_ally_zodiac();
}
player_reload_silently()
{
Assert(IsPlayer(self));
weapon = self GetCurrentWeapon();
if(IsDefined(weapon) && ( weapon != "none" ) )
{
class = WeaponClass(weapon);
if(class != "rocketlauncher" && class != "grenade")
{
current = self GetWeaponAmmoClip(weapon);
clip = WeaponClipSize(weapon);
if ( level.player GetWeaponAmmoStock ( weapon ) <= clip * 2 )
level.player SetWeaponAmmoStock ( weapon, clip * 2 );
needed = clip - current;
stock = self GetWeaponAmmoStock(weapon);
given = Int(min(needed, stock));
self SetWeaponAmmoClip(weapon, current + given);
self SetWeaponAmmoStock(weapon, stock - given);
}
}
}
zodiac_water_impacts( while_flag, barrage, physics )
{
org = spawn ( "script_origin", ( 0, 0, 0 ) );
if ( barrage )
{
thread zodiac_water_impacts_lateral( "right", while_flag );
thread zodiac_water_impacts_lateral( "left", while_flag );
}
while ( !flag ( while_flag ) )
{
wait randomintrange ( 3, 6 );
if ( !flag ( while_flag ) )
{
incoming_dur = randomfloatrange( 1.0, 1.5 );
aud_send_msg("waterbarrage_inc_normal", incoming_dur);
wait( incoming_dur );
forward = AnglesToForward( level.player.angles );
right = anglestoright ( level.player.angles );
x = randomfloatrange ( 0, 1 );
org.origin = level.player.origin + forward * 600 + right * x;
org.angles = level.player.angles;
playfx ( level._effect[ "mortarExp_water" ], org.origin );
thread maps\ny_harbor_fx::surface_waterexp_res(org.origin);
aud_send_msg("zodiac_water_impacts", org.origin);
wait 0.90;
if ( physics )
physicsexplosionsphere ( org.origin + ( 0, 0, -42 ), 50, 45, 1.00 );
}
}
org delete();
}
zodiac_water_impacts_lateral( side, while_flag )
{
org = spawn ( "script_origin", ( 0, 0, 0 ) );
while ( !flag ( while_flag ) )
{
wait randomfloatrange ( 3, 6 );
if ( !flag ( while_flag ) )
{
incoming_dur = randomfloatrange( 1.0, 1.5 );
aud_send_msg("waterbarrage_inc_lateral", incoming_dur);
wait( incoming_dur );
forward = AnglesToForward( level.player.angles );
right = anglestoright ( level.player.angles );
if ( side == "left" )
x = randomfloatrange ( -500, -300 );
else
x = randomfloatrange ( 300, 500 );
forward_range = randomfloatrange ( 800, 1500 );
org.origin = level.player.origin + forward * forward_range + right * x;
org.angles = level.player.angles;
playfx ( level._effect[ "mortarExp_water" ], org.origin );
thread maps\ny_harbor_fx::surface_waterexp_res(org.origin);
aud_send_msg("zodiac_water_impacts_lateral", org.origin);
}
}
org delete();
}
dvora_delete()
{
self waittill ( "reached_end_node" );
self notify ( "stop_fx" );
wait 0.05;
self delete();
}
change_debug_wp_color( name, orgcolor, newcolor, t )
{
ChangeDebugTextHudColor( name, newcolor );
while (t > 0)
{
dc = orgcolor - newcolor;
newcolor = newcolor + (0.05/t)*dc;
ChangeDebugTextHudColor( name, newcolor );
t -= 0.05;
wait 0.05;
}
ChangeDebugTextHudColor( name, orgcolor );
}
debug_water_patches()
{
huds = [];
x = 20;
y = 20;
foreach (patch in level.water_patches)
{
if (!isdefined(patch.hidden))
patch.hidden = 0;
patch.prv_hidden = patch.hidden;
entnum = patch GetEntityNumber();
name = "patch"+entnum;
CreateDebugTextHud(name,x,y);
y += 18;
}
volumes = getentarray( "bobbing_volume", "script_noteworthy");
foreach (volume in volumes)
{
if (!isdefined(volume.hidden))
volume.hidden = 0;
volume.prv_hidden = volume.hidden;
}
while (true)
{
foreach (patch in level.water_patches)
{
patch_shown = "+";
if (isdefined(patch.hidden) && patch.hidden)
patch_shown = "-";
entnum = patch GetEntityNumber();
name = "patch"+entnum;
text = patch_shown;
if (isdefined(patch.script_noteworthy))
text = text + patch.script_noteworthy;
if (isdefined(patch.targetname))
text = text + ":" + patch.targetname;
if (isdefined(patch.target))
{
sibling = getent(patch.target, "targetname");
if (isdefined(sibling))
{
sibling_shown = "+";
if (isdefined(sibling.hidden) && sibling.hidden)
sibling_shown = "-";
text = text + " " + sibling_shown;
if (isdefined(sibling.script_noteworthy))
text = text + sibling.script_noteworthy;
if (isdefined(sibling.targetname))
text = text + ":" + sibling.targetname;
}
}
PrintDebugTextStringHud(name,text);
if ( patch.prv_hidden != patch.hidden )
thread change_debug_wp_color( name, (1,1,1), (1,0,0), 2.0 );
patch.prv_hidden = patch.hidden;
}
wait 0.05;
}
}
setup_wp_trigger()
{
if (!isdefined(self.patches_show))
self.patches_show = [];
if (!isdefined(self.patches_hide))
self.patches_hide = [];
}
setup_water_patch_triggers()
{
InitBobbingVolumes();
active_triggers = [];
level.water_patches = [];
triggers = getentarray("water_patch_trigger", "script_noteworthy");
if (isdefined(triggers))
active_triggers = triggers;
foreach (trigger in triggers)
{
trigger setup_wp_trigger();
}
foreach (trigger in triggers)
{
if (isdefined(trigger.target))
{
targets = getentarray( trigger.target, "targetname" );
assertex(isdefined(targets), "trigger target " + trigger.target + " not referencing anything");
trigger.patches_show = array_combine_unique( trigger.patches_show, targets );
level.water_patches = array_combine_unique( level.water_patches, targets );
foreach (target in targets)
{
if (isdefined(target.target))
{
if (target.classname != "info_volume")
{
targets2 = getentarray( target.target, "targetname" );
assertex(isdefined(targets2), "dyn_patch target " + target.target + " not referencing anything");
trigger.patches_hide = array_combine_unique( trigger.patches_hide, targets2 );
foreach (target2 in targets2)
{
if (!isdefined(target2.parent_targets))
target2.parent_targets = [];
target2.parent_targets[target2.parent_targets.size] = target;
if (isdefined(target2.target))
{
triggers2 = getentarray( target2.target, "targetname");
assertex(isdefined(triggers2), "dyn_patch target " + target2.target + " not referencing anything");
foreach (trigger2 in triggers2)
{
trigger2 setup_wp_trigger();
trigger2.patches_show = array_combine_unique( trigger2.patches_show, [ target2 ] );
trigger2.patches_hide = array_combine_unique( trigger2.patches_hide, [ target ] );
active_triggers = array_combine_unique( active_triggers, [trigger2] );
}
}
}
}
else
{
{
triggers2 = getentarray( target.target, "targetname");
assertex(isdefined(triggers2), "dyn_patch target " + target.target + " not referencing anything");
foreach (trigger2 in triggers2)
{
trigger2 setup_wp_trigger();
trigger2.patches_hide = array_combine_unique( trigger2.patches_hide, [ target ] );
active_triggers = array_combine_unique( active_triggers, [trigger2] );
}
}
}
}
}
}
}
volumes = getentarray("bobbing_volume", "script_noteworthy");
foreach (volume in volumes)
{
if (isdefined(volume.target) && !isdefined(volume.targetname))
{
triggers2 = getentarray( volume.target, "targetname");
assertex(isdefined(triggers2), "dyn_patch target " + volume.target + " not referencing anything");
foreach (trigger2 in triggers2)
{
trigger2 setup_wp_trigger();
trigger2.patches_hide = array_combine_unique( trigger2.patches_hide, [ volume ] );
active_triggers = array_combine_unique( active_triggers, [trigger2] );
}
}
}
array_thread( active_triggers, ::water_patch_trigger_thread );
}
water_patch_trigger_thread()
{
last_trigger = 0;
trigger_off_time = 100;
while (true)
{
self waittill("trigger");
if (last_trigger < gettime())
{
foreach (ent in self.patches_show)
{
if (ent.classname != "info_volume")
{
ent Show();
}
else
{
ent thread ActivateBobbingObjects();
}
ent.hidden = false;
}
foreach (ent in self.patches_hide)
{
if (ent.classname != "info_volume")
{
ent Hide();
}
else
{
ent thread DeactivateBobbingObjects();
}
ent.hidden = true;
}
}
last_trigger = gettime() + trigger_off_time;
wait 0.05;
}
}
sky_battle()
{
flag_wait ("sub_exit_player_going_out_hatch");
addforcestreamxmodel( "vehicle_zodiac_boat" );
addforcestreamxmodel( "vehicle_zodiac_viewmodel_harbor" );
level thread do_forcestreamerdefrag(2);
wait 0.1;
f15_cb07 = spawn_vehicle_from_targetname_and_drive ("f15_cb07");
f15_cb07 thread craig_delete_jet();
aud_send_msg("spawn_f15_fighters_7_8", f15_cb07);
wait 0.2;
f15_cb08 = spawn_vehicle_from_targetname_and_drive ("f15_cb08");
f15_cb08 thread craig_delete_jet();
flag_wait ("fallers");
wait 0.4;
f15_cb01 = spawn_vehicle_from_targetname_and_drive ("f15_cb01");
f15_cb01 thread craig_delete_jet();
aud_send_msg("spawn_f15_fighters_1_2", f15_cb01);
wait 0.6;
f15_cb02 = spawn_vehicle_from_targetname_and_drive ("f15_cb02");
f15_cb02 thread craig_delete_jet();
wait 0.0;
f15_cb03 = spawn_vehicle_from_targetname_and_drive ("f15_cb03");
f15_cb03 thread craig_delete_jet();
wait 0.0;
f15_cb04 = spawn_vehicle_from_targetname_and_drive ("f15_cb04");
f15_cb04 thread craig_delete_jet();
aud_send_msg("spawn_f15_fighters_3_4", f15_cb04);
flag_wait ("spawn_hind01");
wait 2.5;
f15_cb05 = spawn_vehicle_from_targetname_and_drive ("f15_cb05");
f15_cb05 thread craig_delete_jet();
aud_send_msg("spawn_f15_fighter_5", f15_cb05);
wait 2.5;
f15_cb06 = spawn_vehicle_from_targetname_and_drive ("f15_cb06");
f15_cb06 thread craig_delete_jet();
aud_send_msg("spawn_f15_fighter_6", f15_cb06);
flag_wait ("fallers");
wait 0.1;
rescue_seaknight2_cb01 = spawn_vehicle_from_targetname_and_drive ("rescue_seaknight2_cb01");
rescue_seaknight2_cb01 thread craig_delete_helo();
wait 0.1;
rescue_seaknight2_cb02 = spawn_vehicle_from_targetname_and_drive ("rescue_seaknight2_cb02");
rescue_seaknight2_cb02 thread craig_delete_helo();
wait 0.1;
rescue_seaknight2_cb03 = spawn_vehicle_from_targetname_and_drive ("rescue_seaknight2_cb03");
rescue_seaknight2_cb03 thread craig_delete_helo();
wait 0.1;
rescue_seaknight2_cb04 = spawn_vehicle_from_targetname_and_drive ("rescue_seaknight2_cb04");
rescue_seaknight2_cb04 thread craig_delete_helo();
flag_wait ("start_boat_crash");
wait 0.5;
hind_mi24_cb01 = spawn_vehicle_from_targetname_and_drive ("hind_mi24_cb01");
hind_mi24_cb01 thread craig_delete_helo();
hind_mi24_cb01 setmaxpitchroll(30,60);
wait 2.6;
hind_mi24_cb02 = spawn_vehicle_from_targetname_and_drive ("hind_mi24_cb02");
hind_mi24_cb02 thread craig_delete_helo();
hind_mi24_cb02 setmaxpitchroll(30,60);
wait 3.7;
hind_mi24_cb03 = spawn_vehicle_from_targetname_and_drive ("hind_mi24_cb03");
hind_mi24_cb03 thread craig_delete_helo();
wait 0.2;
hind_mi24_cb04 = spawn_vehicle_from_targetname_and_drive ("hind_mi24_cb04");
hind_mi24_cb04 thread craig_delete_helo();
wait 0.5;
hind_mi24_cb05 = spawn_vehicle_from_targetname_and_drive ("hind_mi24_cb05");
hind_mi24_cb05 thread craig_delete_helo();
hind_mi24_cb05 setmaxpitchroll(30,80);
aud_send_msg("spawn_hind_flyby_5", hind_mi24_cb05);
wait 0.7;
hind_mi24_cb06 = spawn_vehicle_from_targetname_and_drive ("hind_mi24_cb06");
hind_mi24_cb06 thread craig_delete_helo();
hind_mi24_cb06 setmaxpitchroll(30,80);
aud_send_msg("spawn_hind_flyby_6", hind_mi24_cb06);
}
craig_delete_helo()
{
self waittill ( "reached_dynamic_path_end" );
self delete();
}
craig_delete_jet()
{
self waittill ( "reached_end_node" );
self delete();
}
rotating_radar()
{
speed = 0;
time = 20000;
speed_multiplier = 1.0;
if( isdefined( self.speed ) )
{
speed_multiplier = self.speed;
}
speed = randomfloatrange( 1*speed_multiplier, 2*speed_multiplier );
if( isdefined( self.script_noteworthy ) && (self.script_noteworthy=="lockedspeed") )
wait 0;
else
wait randomfloatrange( 0, 1 );
while ( true )
{
self rotatevelocity( ( 0, speed, 0 ), time );
wait time;
}
}

