#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\_helicopter_globals;
#include maps\_hud_util;
#include maps\_shg_common;
#include maps\ny_hind;
#include maps\ny_hind_ai;
#include maps\ny_blackhawk;
#include maps\ss_util;
#include maps\ny_manhattan_code_downtown;
get_vehicle_health()
{
return self.health - self.healthbuffer;
}
set_vehicle_health( health )
{
self.health = self.healthbuffer + health;
self.currenthealth = self.health;
if (self.maxhealth < self.health)
self.maxhealth = self.health;
}
isVehicleAlive(veh)
{
if (!isdefined(veh))
return false;
if (veh get_vehicle_health() <= 0)
return false;
return true;
}
hold_health( health )
{
self.stop_shooting = false;
while (self.stop_shooting == false)
{
self set_vehicle_health(health);
wait 0.05;
}
}
wait_for_player_entering_hind()
{
if( is_split_level_part( "a" ) )
{
return;
}
trigger = getent ( "player_at_hind", "targetname" );
trigger sethintstring ( &"NY_MANHATTAN_HINT_ENTER_HIND" );
trigger_wait_targetname("player_at_hind");
level.player delaycall ( 2.2, ::PlayRumbleOnEntity, "falling_land" );
SetSavedDvar( "compass", 0 );
SetSavedDvar( "ammoCounterHide", 1 );
SetSavedDvar( "hud_showstance", 0 );
SetSavedDvar( "actionSlotsHide", 1 );
level.player freezecontrols ( true );
level.player delaycall ( 2, ::freezecontrols, false );
level.uav hide();
thread battlechatter_off ( "allies" );
flag_set("entering_hind");
aud_send_msg("predator_disabled");
thread start_bh_rooftop();
array_thread ( level.enemy_predator_01, ::fake_death_over_time, "bullet", 2, 4 );
array_thread ( level.enemy_predator_02, ::fake_death_over_time, "bullet", 2, 4 );
level.player takeallweapons();
thread maps\ny_manhattan_code_intro::cleanup_ai ( "rooftop_baddies", "script_noteworthy" );
trigger trigger_off();
wait 1;
radio_dialogue ( "manhattan_hp1_exfilcomplete" );
radio_dialogue ( "manhattan_snd_vertical" );
radio_dialogue ( "manhattan_snd_getonit" );
}
start_squad_member_on_hind( guy )
{
tag = level.scr_tag[guy.animname];
level.player_hind anim_first_frame_solo(guy, "ny_manhattan_blackhawk_idle_nl", tag );
guy linkto( level.player_hind, tag );
if (guy == level.sandman)
level.player_hind thread anim_loop_solo(guy, "blackhawk_land_idle", "end_loop", tag );
else
level.player_hind thread anim_loop_solo(guy, "ny_manhattan_blackhawk_idle", "end_loop", tag );
}
start_squad_on_hind( everyone )
{
if (isdefined(level.squad_on_hind) && level.squad_on_hind)
return;
if (!isdefined(level.squad1))
{
level.squad1 = [];
allies = getentarray( "squad_1", "targetname" );
idx = 0;
foreach( ally in allies )
{
squad_guy = ally spawn_ai( true );
if ( squad_guy.script_noteworthy == "leader" )
{
level.sandman = squad_guy;
level.sandman.animname = "lonestar";
}
else if ( squad_guy.script_noteworthy == "truck" )
{
level.truck = squad_guy;
level.truck.animname = "truck";
}
else
{
level.reno = squad_guy;
level.reno.animname = "reno";
}
squad_guy magic_bullet_shield();
level.squad1[level.squad1.size] = squad_guy;
idx++;
}
}
level.squad_on_hind = true;
foreach (guy in level.squad1)
{
if ((guy != level.sandman) || (!isdefined(everyone) || everyone))
thread start_squad_member_on_hind(guy);
}
}
setup_hind_ride( at_finale )
{
flag_init( "incoming_missiles" );
flag_init( "stop" );
flag_init( "go" );
flag_init( "trigger_little_chase");
flag_init( "start_blown_cover" );
flag_init( "start_hind_dialogue_intro");
flag_init( "end_hind_dialogue_intro");
flag_init( "aud_vo_cover_blown");
flag_init( "aud_vo_hind_start");
flag_init( "cover_blown" );
flag_init( "start_finale" );
flag_init( "aud_vo_chase" );
flag_init( "aud_vo_lost_him" );
level.ny_heli_crash_locations = GetEntArray( "helicopter_crash_location", "targetname");
level.player_hind set_vehicle_health(22135);
level.player_hind.name = "player_hind";
foreach (rider in level.player_hind.riders)
{
rider Delete();
}
level.player_hind.riders = [];
if (!IsGodMode(level.player))
level.player_hind.godmode = false;
level.hind_battle_hind03b = undefined;
level.lookatenemy = false;
level.hind_health = 15000;
level.sight_angle = 90;
level.random_kill_vo_lines = ["reno_line26", "manhattan_rno_goodwork", "manhattan_snd_goodkill"];
level.random_kill_vo_index = 0;
if (!isdefined(at_finale))
{
thread start_hind_and_get_orders();
thread incoming_missile_text();
thread construction_building_battle();
thread blown_cover();
thread player_chase_sequence();
thread setups_shooter_scene();
thread aud_vo_cover_blown();
thread aud_vo_chase();
thread aud_vo_round_the_building();
thread bring_the_pain();
thread enemy_attack_logic();
thread view_logic();
thread player_health_logic();
}
else
{
flag_set( "player_encountered" );
}
thread create_attractor();
thread look_at_enemy();
thread look_at_cleanup();
thread final_chase_sequence();
thread play_finale_manager();
thread kill_player_if_hind_dies();
construction_crash_trigger = getent ( "hind_crash_construction", "targetname" );
construction_crash_trigger thread construction_crash_trigger_monitor();
}
debug_hind()
{
}
debug_temp()
{
wait 2;
while (true)
{
wait 0.05;
health = level.player_hind get_vehicle_health();
println ("health = " + health);
}
}
create_attractor()
{
flag_wait ( "player_encountered" );
thing1 = undefined;
level.player_head_attractor = spawn ( "script_origin", (0,0,0));
head = level.player geteye();
thing1 = Missile_CreateAttractorEnt( level.player, 1500, 99999 );
thing2 = undefined;
level.generic_attractor = spawn ( "script_origin", (0, 0, 0));
thing2 = Missile_CreateAttractorEnt( level.generic_attractor, 10000, 999999 );
level.player_head_attractor moveto ((0,0,0), 0.05, 0, 0);
}
missile_onslaught(delay, override)
{
self endon("death");
level endon ( "finale_playing" );
self.missile_stop = false;
wait (delay);
t = 0.5;
thing1 = Missile_CreateAttractorEnt( level.player, 10000, 999999 );
while (self.missile_stop == false)
{
self thread hind_shoot_missiles(1);
t = t + t;
wait (randomfloatrange (1.0, 3.0));
}
}
hold_attractor(time, thing)
{
t = time / 0.05;
i = 0;
while(t > i)
{
head = level.player geteye();
thing moveto (head, 0.05, 0, 0);
i++;
wait 0.05;
}
}
shoot_scripted(array, cycle)
{
targets = getentarray (array, "targetname");
self.stop_shooting = false;
while (cycle && !self.stop_shooting)
{
foreach (node in targets)
{
if(isVehicleAlive (self))
{
hold = randomfloatrange (0.5, 1.5);
self thread fire_missile( "hind_rpg_cheap", 1, node );
level.generic_attractor moveto (node.origin, 0.05, 0, 0);
wait hold;
}
}
level.generic_attractor moveto ((0, 0, 0), 0.05, 0, 0);
wait (randomfloatrange(1.0, 3.0));
}
if (!cycle)
foreach (node in targets)
{
hold = randomfloatrange (0.5, 1.0);
self thread fire_missile( "hind_rpg_cheap", 1, node );
wait hold;
}
}
force_shoot(flag_id, delay)
{
if (isdefined(flag_id))
flag_wait( flag_id );
if (isdefined(delay))
wait delay;
aud_send_msg("start_blown_cover");
self thread hind_shoot_missiles(3, 1);
}
can_shoot( target, cosEinP, cosTinE )
{
if (!isdefined(cosEinP))
cosEinP = 0.707;
if (!isdefined(cosTinE))
cosTinE = 0.94;
if (!flag ("stop_shooting") && within_fov( level.player GetEye(), level.player GetPlayerAngles(), self.origin, cosEinP ) )
{
if (within_fov( self.origin, self.angles, target.origin, cosTinE ))
{
return true;
}
}
return false;
}
enemy_hind_think(delay, flg, repulse, nomissiles)
{
if (!isdefined(self))
return;
self endon( "death" );
self endon( "stop_ai");
if (isdefined(flg))
flag_wait (flg);
if (isdefined(delay))
wait (delay);
self thread nym_Hind_Turret_AI();
self thread nym_hind_turret_target_around_player();
if (isdefined(nomissiles) && nomissiles)
return;
repulsor = undefined;
attractor = undefined;
while (true)
{
wait 0.1;
if (self can_shoot(level.player_hind))
{
numRockets = 2;
if (randomfloat(100) > 75)
{
numRockets = 3;
if (randomfloat(100) > 75)
{
numRockets = 4;
}
}
if (isdefined (repulse) && repulse == 1)
{
if (isdefined(repulsor))
Missile_DeleteAttractor( repulsor );
range = RandomIntRange( 240, 1200 );
repulsor = Missile_CreateRepulsorEnt( level.player_hind, 10000, range );
}
else if (isdefined (repulse) && repulse == 0)
{
if (isdefined(attractor))
Missile_DeleteAttractor( attractor );
x = RandomFloatRange ( -8, 8 );
y = RandomFloatRange ( 0, 8 );
offset = ( x, y, 0 );
}
self thread hind_shoot_missiles(numRockets);
wait randomfloatrange( 2, 5 );
}
}
}
incoming_missile_text()
{
while (true)
{
wait (0.05);
flag_wait( "incoming_missiles" );
wait (0.05);
flag_clear( "incoming_missiles" );
wait 1;
wait 5;
}
}
shoot_missiles_inacurately()
{
self.stop_shooting = false;
while (true)
{
wait 0.05;
while (IsVehicleAlive (self) && self.stop_shooting == false)
{
num = randomint (2);
delay = randomfloatrange (1,3);
self thread hind_shoot_missiles(num);
wait delay;
}
}
}
hind_shoot_missiles(num, target)
{
level endon ( "finale_playing" );
head = level.player geteye();
level.player_head_attractor.origin = head;
level.generic_attractor.origin = (0, 0, 0);
for (i = 0; i < num; i++)
{
offset_salvo = RandomFloatRange (0.1, 0.25);
self thread fire_missile( "hind_rpg_cheap", 1, level.player );
wait (offset_salvo);
}
}
hind_shoot_missiles_alt(num, target)
{
level endon ( "finale_playing" );
eye = level.player geteye();
head[0] = ( eye[0], eye[1], eye[2] + 200 );
head[1] = ( eye[0] + 300, eye[1], eye[2] - 100 );
head[2] = ( eye[0] - 300, eye[1] + 64, eye[2] - 100 );
head[3] = ( eye[0] - 300, eye[1] + 64, eye[2] + 100 );
head[4] = ( eye[0] + 300, eye[1], eye[2] + 100 );
level.player EnableInvulnerability();
thing = Missile_CreateAttractorOrigin( head[0], 10000, 99999 );
level.generic_attractor.origin = (0, 0, 0);
for (i = 0; i < num; i++)
{
n = randomint(5);
t = RandomFloatRange (0.25, 0.65);
self thread fire_missile( "hind_rpg_cheap", 1, level.player );
Missile_DeleteAttractor(thing);
thing = Missile_CreateAttractorOrigin( head[n], 10000, 99999 );
wait (t);
}
Missile_DeleteAttractor(thing);
wait 1.5;
level.player DisableInvulnerability();
}
look_at_enemy()
{
level.player_hind endon("death");
while (true)
{
wait 0.05;
if (level.lookatenemy == true && isdefined(level.current_enemy) && (level.current_enemy get_vehicle_health() > 0))
{
while (level.lookatenemy == true && isdefined(level.current_enemy) && (level.current_enemy get_vehicle_health() > 0))
{
if ((level.current_enemy get_vehicle_health() > 0) && isVehicleAlive( level.player_hind ))
{
playeryaw = VectorToYaw ( level.current_enemy.origin - level.player_hind.origin );
level.player_hind smooth_vehicle_path_SetTargetYaw ( playeryaw + level.sight_angle );
wait 0.05;
}
}
level.player_hind smooth_vehicle_path_ClearTargetYaw();
}
}
}
look_at_player(time)
{
level.player_hind endon("death");
self endon("death");
i = 0;
time = time * 60;
self.stop_looking = false;
while (isVehicleAlive(self) && ((i < time) || (time < 0)) && self.stop_looking == false )
{
enemyyaw = VectorToYaw ( level.player_hind.origin - self.origin );
self smooth_vehicle_path_SetTargetYaw ( enemyyaw );
if (time >= 0)
i++;
wait 0.05;
}
self smooth_vehicle_path_ClearTargetYaw();
}
look_at_cleanup()
{
while (true)
{
wait (0.05);
if (!isVehicleAlive( level.current_enemy) && level.lookatenemy == true)
level.lookatenemy = false;
}
}
View_Logic()
{
flag_init( "encounter1_center_view" );
flag_init( "encounter2_center_view" );
flag_init( "encounter3_center_view" );
flag_init( "encounter4_favor_back" );
flag_init( "encounter4b_allow_forward" );
flag_init( "encounter5_center_view" );
flag_init( "encounter6_slim_front" );
wait 1;
AdjustHindPlayersViewArcs(65, 75, 25, 45, 1.5);
thread view_logic_spawn_hind02b();
thread view_logic_encounter1();
thread view_logic_encounter2();
thread view_logic_encounter3();
thread view_logic_encounter4();
thread view_logic_encounter5();
thread view_logic_encounter6();
}
view_logic_spawn_hind02b()
{
level endon( "encounter1_center_view" );
flag_wait( "spawn_hind02b" );
AdjustHindPlayersViewArcs(75, 75, 25, 35, 1.5);
}
view_logic_encounter1()
{
level endon( "encounter2_center_view" );
flag_wait( "encounter1_center_view" );
AdjustHindPlayersViewArcs(75, 75, 35, 35, 1);
}
view_logic_encounter2()
{
level endon( "encounter3_center_view" );
flag_wait( "encounter2_center_view" );
wait 1.5;
AdjustHindPlayersViewArcs(15, 15, 15, 15, 1);
wait 2;
AdjustHindPlayersViewArcs(45, 45, 25, 25, 1);
}
view_logic_encounter3()
{
level endon( "encounter4_favor_back" );
flag_wait( "encounter3_center_view" );
AdjustHindPlayersViewArcs(85, 0, 15, 15, 0.1);
wait 2.5;
AdjustHindPlayersViewArcs(85, 55, 15, 35, 1);
}
view_logic_encounter4()
{
level endon( "encounter5_center_view" );
flag_wait( "encounter4_favor_back" );
AdjustHindPlayersViewArcs(85, 75, 40, 35, 0.1);
}
view_logic_encounter5()
{
level endon( "encounter6_slim_front" );
flag_wait( "encounter5_center_view" );
AdjustHindPlayersViewArcs(30, 0, 30, 30, 1.5);
wait 1;
AdjustHindPlayersViewArcs(75, 75, 35, 35, 0.5);
}
view_logic_encounter6()
{
flag_wait( "encounter6_slim_front" );
AdjustHindPlayersViewArcs(75, 75, 35, 35, 0.5);
}
temporary_change_view_arcs(direction, time)
{
if (direction == 0)
AdjustHindPlayersViewArcs(75, 75, 35, 35, time);
if (direction == 1)
AdjustHindPlayersViewArcs(-50, 85, 35, 5, time);
if (direction == 2)
AdjustHindPlayersViewArcs(75, -20, 35, 35, time);
if (direction == 3)
AdjustHindPlayersViewArcs(35, 35, 35, 35, time);
}
player_health_logic()
{
while (!flag("bring_the_pain01"))
{
wait 1;
}
wait 0.5;
}
bring_the_pain()
{
flag_wait("bring_the_pain01");
if (!isdefined(level.isdemo))
{
if (isvehiclealive(level.hind_battle_hind06b))
level.hind_battle_hind06b thread focus_fire(1.5, 4);
if (isvehiclealive(level.hind_battle_hind03b))
level.hind_battle_hind03b thread focus_fire(1.5, 4);
}
else
{
flag_wait( "break_for_it" );
path = getstruct( "chase_helis_fly_off", "targetname" );
level.hind_battle_hind06b thread chase_hind_flyoff( path );
wait 1.75;
level.hind_battle_hind03b thread chase_hind_flyoff( path );
}
}
chase_hind_flyoff( path )
{
self endon( "death" );
if( isDefined( self ) && isAlive( self ) )
{
self smooth_vehicle_path_clear_override_speed();
self.stop_looking = true;
self thread vehicle_paths( path );
}
}
debug_attack_logic()
{
health_pri = level.hind_battle_hind06b get_vehicle_health();
health_sec = level.hind_battle_hind03b get_vehicle_health();
health_inc = health_pri / 3;
while (true)
{
wait 0.05;
nowHealth2 = level.hind_battle_hind06b get_vehicle_health();
println("06b health= " + nowHealth2);
}
}
two_stage_fly_by ()
{
evade_1x = (-1100, -500, 240);
evade_1y = (-500, -1450, 240);
level.hind_battle_hind03b SetYawSpeed(240, 60);
level.hind_battle_hind03b thread smooth_vehicle_path_set_override_speed (100, 160, 100);
level.hind_battle_hind03b adjust_follow_offset_angoff( evade_1x, 0, 1 );
level.hind_battle_hind03b thread set_vehicle_health( 3900 );
wait 1.25;
level.hind_battle_hind03b notify("stop_shooting");
if (isVehicleAlive (level.hind_battle_hind03b))
{
level.hind_battle_hind03b SetMaxPitchRoll( 20, 50 );
}
}
draw_crash_locations()
{
}
monitor_for_safe_crash_location( follow_heli )
{
self endon("death");
while (true)
{
p2e = self.origin - level.player_hind.origin;
playerbelowenemy = (p2e[2] < 0);
p2e = (p2e[0], p2e[1], 0);
closest = undefined;
closestDist = 999999;
best = undefined;
bestDist = closestDist;
foreach (loc in level.ny_heli_crash_locations)
{
e2c = loc.origin - self.origin;
dp = VectorDot(p2e,e2c);
dist = Distance(loc.origin, self.origin);
pointabove = (self.origin[2] < loc.origin[2]);
if (playerbelowenemy && !pointabove)
dist *= 2.0;
if (!playerbelowenemy && pointabove)
dist *= 2.0;
if (dist < closestDist)
{
closestDist = dist;
closest = loc;
}
if ((dp > 0) && (dist < bestDist))
{
bestDist = dist;
best = loc;
}
}
if (isdefined(best))
self.perferred_crash_location = best;
else
self.perferred_crash_location = closest;
if (isdefined(follow_heli))
{
vel = self Vehicle_GetVelocity();
follow_vel = follow_heli Vehicle_GetVelocity();
follow2self = self.origin - follow_heli.origin;
if (VectorDot(vel, follow2self) > 0)
{
if (follow2self[2] < 0)
self.heli_crash_indirect_zoff = 600;
else
self.heli_crash_indirect_zoff = 600;
self.heli_crash_lead = 1;
}
else
{
self.heli_crash_indirect_zoff = undefined;
self.heli_crash_lead = undefined;
}
}
wait 0.05;
}
}
enemy_attack_logic()
{
flag_wait( "spawn_hind06b" );
wait 1;
flag_wait ("hind06b_to_follow");
wait 1;
hind01 = level.hind_battle_hind06b;
hind02 = level.hind_battle_hind03b;
if (isVehicleAlive(hind01))
{
hind01.stop_shooting = true;
hind01 thread set_vehicle_health( level.hind_health );
}
if (isVehicleAlive(hind02))
{
hind02.stop_shooting = true;
hind02 thread set_vehicle_health( level.hind_health );
}
level.sec_offset = (-2100, -120, 100);
level.pri_offset = (-1100, -420, 240);
level.pri_offset2 = (-1100, -420, 740);
evade_1 = (-1500, -720, 1000);
evade_1b = (-1500, -1010, 700);
evade_1x = (1500, 100, 400);
evade_2 = (-900, 720, 1000);
isEvade_1 = 0;
isEvade_2 = 0;
health_pri = level.hind_health;
health_inc = health_pri / 3;
level.switch_pos = false;
level.primaryHind = hind01;
level.secondaryHind = hind02;
thread enemy_dodge_bullets(0);
if (isVehicleAlive(level.secondaryHind))
level.secondaryHind thread shoot_missiles_inacurately();
raceahead1 = 0;
while (raceahead1 == 0 &&	(isVehicleAlive (hind01) || isVehicleAlive (hind02)))
{
while (isVehicleAlive (hind01) )
{
wait 0.05;
}
if (isVehicleAlive(hind02))
{
wait 3;
if (isEvade_1 == 0)
{
isEvade_1 = 1;
level.primaryHind = hind02;
while (isVehicleAlive(hind02) && !isdefined(hind02.follow_offset))
wait 0.05;
if (isVehicleAlive(hind02))
{
hind02 adjust_follow_offset_angoff( level.pri_offset, 0, 2 );
health_pri = hind02 get_vehicle_health();
}
}
if (isVehicleAlive(hind02) && (hind02 get_vehicle_health() <= (8000)))
hind02 thread set_vehicle_health( 8000 );
}
while (isVehicleAlive (hind02) && hind02 get_vehicle_health() > (8000))
{
wait 0.05;
}
if (isVehicleAlive(hind02))
{
raceahead1 = 1;
wait 0.05;
}
}
}
enemy_dodge_bullets(angle)
{
level.primaryHind endon("death");
health1 = level.primaryHind get_vehicle_health();
tolerance = health1 / 10;
x = level.pri_offset[ 0 ];
y = level.pri_offset[ 1 ];
z = level.pri_offset[ 2 ];
while (isVehicleAlive (level.primaryHind))
{
wait 0.05;
while (level.switch_pos == true)
wait 0.05;
if	(isVehicleAlive (level.primaryHind))
{
health2 = level.primaryHind get_vehicle_health();
if (health2 < (health1 - tolerance))
{
health1 = level.primaryHind get_vehicle_health();
change = 100 + randomint(300);
dir = randomint(3);
if (dir == 1)
level.primaryHind thread adjust_follow_offset_angoff( (x, (y + change), z), angle, 0.75 );
if (dir == 2)
level.primaryHind thread adjust_follow_offset_angoff( (x, y, (z + change)), angle, 0.75 );
if (dir == 3)
level.primaryHind thread adjust_follow_offset_angoff( ((x - change), y, z), angle, 0.75 );
wait 1.25;
level.primaryHind thread adjust_follow_offset_angoff( (x, y, z), angle, 1 );
}
}
}
}
spawn_enemy_hind( targetname, drive, health, no_vo)
{
if (drive)
{
enemy_hind = spawn_vehicle_from_targetname_and_drive ( targetname );
enemy_hind.curpathtype = "normal";
enemy_hind.curpathstart = targetname;
}
else
enemy_hind = spawn_vehicle_from_targetname ( targetname );
enemy_hind.name = targetname;
enemy_hind set_vehicle_health(health);
enemy_hind EnableAimAssist();
enemy_hind build_rumble_unique("mig_rumble", 0.1, 0.2, 900, 0.05, 0.05);
enemy_hind thread enemy_hind_cool_damage_effects();
enemy_hind thread maps\ny_manhattan_fx::enemy_hind_spotlight();
enemy_hind thread maps\ny_manhattan_code_intro::setup_remote_missile_target_guy();
enemy_hind thread enemy_hind_monitor_death();
if (!isdefined(no_vo))
enemy_hind thread random_kill_vo();
return enemy_hind;
}
enemy_hind_monitor_death()
{
self endon ( "crash_done" );
level endon ( "surprise_follower" );
self waittill ( "deathspin" );
self.is_crashing = true;
}
construction_crash_trigger_monitor()
{
level endon ( "surprise_follower" );
while ( true )
{
self waittill ( "trigger", triggerer );
if ( isdefined ( triggerer ) && isdefined ( triggerer.is_crashing ) && ( triggerer.is_crashing ) )
triggerer notify ( "goal" );
}
}
generic_one_liner(guy, vo, radio)
{
if (!isdefined(radio))
guy dialogue_queue ( vo );
if (isdefined(radio))
radio_dialogue( vo );
}
aud_vo_hind_start()
{
flag_wait( "aud_vo_hind_start");
flag_set("start_hind_dialogue_intro");
wait 2;
flag_set("end_hind_dialogue_intro");
aud_send_msg("begin_hind_conversation");
radio_dialogue( "manhattan_hqr_newdirective" );
radio_dialogue( "manhattan_snd_rpgrpg" );
radio_dialogue( "manhattan_hqr_assaultvessel" );
radio_dialogue( "manhattan_snd_rogerlast" );
flag_set ("end_new_orders_dialogue");
axis = GetAIArray( "axis" );
if( IsDefined( axis ) && axis.size > 0 )
foreach( baddie in axis )
baddie Delete();
radio_dialogue( "manhattan_hqr_enemybirds" );
aud_send_msg("end_hind_conversation");
}
aud_vo_cover_blown()
{
flag_wait( "player_encountered");
aud_send_msg("begin_hind_conversation");
if (!flag( "stop_sneaky_dialog" ))
radio_dialogue( "manhattan_trk_enemybird" );
if (!flag( "stop_sneaky_dialog" ))
flag_set( "encounter1_center_view" );
wait 1;
flag_set("cover_blown");
wait 1.5;
aud_send_msg("end_hind_conversation");
flag_wait ( "stop_sneaky_dialog" );
wait(1);
aud_send_msg("begin_hind_conversation");
radio_dialogue( "manhattan_trk_stayonhim" );
radio_dialogue( "manhattan_snd_russianbird" );
aud_send_msg("end_hind_conversation");
}
aud_vo_chase()
{
flag_wait( "aud_vo_chase" );
wait 2;
radio_dialogue( "manhattan_trk_hindsinbound" );
flag_wait ("hind06b_to_follow");
aud_send_msg("begin_hind_conversation");
radio_dialogue( "manhattan_trk_takingheavyfire" );
radio_dialogue( "manhattan_hp1_evasiveaction" );
flag_wait ( "spawn_next_hind" );
thread radio_dialogue( "manhattan_snd_scansectors" );
aud_send_msg("end_hind_conversation");
}
aud_vo_round_the_building()
{
flag_wait ( "pre_surprise_follower" );
wait 0.5;
aud_send_msg("begin_hind_conversation");
println ("center view");
flag_set( "encounter5_center_view" );
radio_dialogue( "manhattan_rno_lostem" );
wait 0.75;
radio_dialogue( "manhattan_snd_hindhindhind" );
flag_set( "encounter6_slim_front" );
level.sight_angle = 25;
radio_dialogue ( "manhattan_hp1_holdon" );
wait 1.5;
radio_dialogue( "manhattan_rno_behindbuilding" );
radio_dialogue( "manhattan_snd_beadonhim" );
radio_dialogue( "manhattan_snd_firefirefire" );
aud_send_msg("end_hind_conversation");
}
aud_vo_finale ()
{
addnotetrack_flag ( "enemyhind", "trk_lookout", "trk_lookout", "ny_manhattan_hind_finale" );
addnotetrack_flag ( "hind", "snd_werehit", "snd_werehit", "ny_manhattan_hind_finale2" );
addnotetrack_flag ( "hind", "rno_hangon", "rno_hangon", "ny_manhattan_hind_finale2" );
addnotetrack_flag ( "hind", "trk_goingdown", "trk_goingdown", "ny_manhattan_hind_finale2" );
addnotetrack_flag ( "hind", "snd_perssureinpedals", "snd_perssureinpedals", "ny_manhattan_hind_finale2" );
addnotetrack_flag ( "hind", "rno_holdon", "rno_holdon", "ny_manhattan_hind_finale2" );
addnotetrack_flag ( "hind", "snd_enroute", "snd_enroute", "ny_manhattan_hind_finale2" );
flag_wait ( "trk_lookout" );
thread radio_dialogue ( "manhattan_trk_lookout" );
flag_wait ( "snd_werehit" );
thread radio_dialogue ( "manhattan_snd_werehit" );
flag_wait ( "rno_hangon" );
thread radio_dialogue ( "manhattan_rno_hangon" );
flag_wait ( "trk_goingdown" );
radio_dialogue ( "manhattan_trk_goingdown" );
flag_wait ( "snd_perssureinpedals" );
radio_dialogue ( "manhattan_hp1_pressure" );
thread radio_dialogue ( "manhattan_hp1_comeon" );
flag_wait ( "rno_holdon" );
thread radio_dialogue ( "manhattan_rno_holdon" );
flag_wait ( "snd_enroute" );
radio_dialogue ( "manhattan_hp1_fuel70percent" );
aud_send_msg( "mus_vo_sandman_enroute" );
radio_dialogue ( "manhattan_snd_enroute" );
radio_dialogue ( "manhattan_hqr_skiesclear" );
}
random_kill_vo()
{
assert(IsDefined(level.random_kill_vo_lines));
assert(IsDefined(level.random_kill_vo_index));
assert(level.random_kill_vo_lines.size > 0);
assert(level.random_kill_vo_index >= 0 && level.random_kill_vo_index < level.random_kill_vo_lines.size);
while (IsVehicleAlive(self))
{
wait 0.05;
}
assert(level.random_kill_vo_index >= 0 && level.random_kill_vo_index < level.random_kill_vo_lines.size);
line = level.random_kill_vo_lines[level.random_kill_vo_index];
level.random_kill_vo_index = (level.random_kill_vo_index + 1) % level.random_kill_vo_lines.size;
if (line == "reno_line26")
{
level.reno dialogue_queue("reno_line26");
}
else
{
radio_dialogue(line);
}
wait 5;
self notify ( "near_goal" );
}
start_hind_and_get_orders()
{
wait 1;
thread aud_vo_hind_start();
flag_set( "aud_vo_hind_start");
wait 2;
level.player_hind.godmode = false;
level.playerpath = getstruct ( "blackhawk_startpath", "targetname" );
level.player_hind thread vehicle_paths ( level.playerpath );
level.player_hind vehicle_setspeed ( 15, 5, 5 );
level.player_hind Vehicle_SetSpeed (40, 10, 5);
}
start_bh_rooftop()
{
flag_init ("end_new_orders_dialogue");
level.player_hind.godmode = true;
bh_roof_01 = getentarray ( "bh_roof_01", "targetname" );
foreach ( spawner in bh_roof_01 )
{
guy = spawner spawn_ai ( true );
guy.goalradius = 512;
}
flag_wait ( "end_new_orders_dialogue" );
level.player_hind.godmode = false;
}
setups_shooter_scene()
{
flag_init( "stop_sneaky_dialog" );
flag_wait( "spawn_hind02" );
level.hind_battle_hind02b = spawn_enemy_hind ( "hind_battle_hind02b", true, level.hind_health, 1 );
level.hind_battle_hind02b.godmode = true;
aud_send_msg("spawn_hind02b", level.hind_battle_hind02b);
wait 4;
level.hind_battle_hind02 = spawn_enemy_hind ( "hind_battle_hind02", true, 15000, 1 );
level.hind_battle_hind02 SetMaxPitchRoll( 20, 60 );
aud_send_msg("spawn_hind02", level.hind_battle_hind02);
wait 0.5;
health1 = level.hind_battle_hind02b get_vehicle_health();
health_at_start = health1;
thread stealthy_kill_logic();
flag_wait( "player_encountered" );
level.current_enemy = level.hind_battle_hind02b;
level.hind_battle_hind02b thread look_at_player(-1);
flag_wait_or_timeout( "enemy_shooter01", 2.5 );
level.lookatenemy = true;
new_path1 = getstruct ("hover_and_fire", "targetname");
level.hind_battle_hind02b thread ny_start_heli_path( new_path1, 2, 240);
level.hind_battle_hind02b smooth_vehicle_path_set_override_speed (5, 20, 20);
level.player_hind smooth_vehicle_path_set_override_speed (10, 20, 20);
flag_set( "aud_vo_cover_blown");
thread wait_for_cover_blown_to_attack();
flag_set ( "cover_blown" );
flag_set( "stop_sneaky_dialog" );
wait 0.05;
level.hind_battle_hind02b SetYawSpeed(240, 60);
new_path = getstruct ("hind_02b_outi", "targetname");
level.hind_battle_hind02b thread vehicle_paths(new_path);
level.hind_battle_hind02b smooth_vehicle_path_set_override_speed (60, 100, 90);
level.hind_battle_hind02b SetMaxPitchRoll( 30, 60 );
level.hind_battle_hind02b notify("stop_shooting");
flag_set ("trigger_little_chase");
level.hind_battle_hind02b.stop_shooting = true;
level.hind_battle_hind02b.stop_looking = true;
}
wait_for_cover_blown_to_attack()
{
if (isdefined(level.hind_battle_hind02b) )
{
aud_send_msg("cover_blown");
level.hind_battle_hind02b thread enemy_hind_think( undefined, undefined, undefined, true );
level.hind_battle_hind02b thread focus_fire(4, 100);
level.hind_battle_hind02b thread hind_shoot_missiles_alt(5);
wait 1;
level.hind_battle_hind02b notify ( "stop_ai" );
}
}
stealthy_kill_logic()
{
flag_wait ("hind_stealthy_kill");
new_path = getstruct ("stealthy_kill_path", "targetname");
level.player_hind thread ny_start_heli_path( new_path, 4, 240);
flag_wait ("trigger_little_chase");
wait 1;
maps\_autosave::_autosave_game_now_nochecks();
new_path = getstruct ("little_chase", "targetname");
level.player_hind thread ny_start_heli_path( new_path, 0.5, 240);
level.player_hind smooth_vehicle_path_set_override_speed (60, 60, 60);
wait 3;
flag_set( "spawn_hind03b" );
}
focus_fire( time, minradius )
{
self endon("death");
self endon("stop_shooting");
while (!isdefined(self.main_turret) || !isdefined(self.main_turret["around_radius"]))
wait 0.05;
self.main_turret["sweepspeed"] = 10;
self.main_turret["sweepcount"] = 0;
self.main_turret["delay"] = 0.0;
self.main_turret["delayrange"] = 0.1;
self.main_turret["mintimebtnfires"] = 0.05;
self.main_turret["maxtimebtnfires"] = 0.3;
if (!isdefined(minradius))
minradius = 10;
radius = self.main_turret["around_radius"];
if (time > 0)
{
dradius = radius - minradius;
dradius = 0.05 * dradius/time;
while (time > 0)
{
radius -= dradius;
if (radius <= minradius)
radius = minradius;
self.main_turret["around_radius"] = radius;
time -= 0.05;
wait 0.05;
}
}
else
{
self.main_turret["around_radius"] = minradius;
}
}
wait_to_focus_fire_after_flag( flg, time )
{
flag_wait( flg );
self focus_fire( time );
}
blown_cover()
{
flag_wait( "spawn_hind03b" );
level.player EnableInvulnerability();
flag_set( "start_blown_cover" );
level.hind_battle_hind03b = spawn_enemy_hind ( "hind_battle_hind03b", true, 3*level.hind_health );
aud_send_msg("spawn_hind03b", level.hind_battle_hind03b);
level.hind_battle_hind03b thread enemy_hind_think( 0.05, "enemy_fire_01", 0 );
level.hind_battle_hind03b thread monitor_for_safe_crash_location();
level.hind_battle_hind03b SetMaxPitchRoll( 10, 60 );
flag_set( "encounter2_center_view" );
flag_wait( "fire_point_01" );
level.player_hind smooth_vehicle_path_set_override_speed (0, 20, 20);
flag_wait( "start_blown_cover" );
level.player_hind SetMaxPitchRoll( 10, 5 );
level.hind_battle_hind03b	thread force_shoot("enemy_fire_01");
flag_wait( "enemy_fire_01" );
wait (2.28);
level.player_hind smooth_vehicle_path_set_override_speed ( 60, 90, 5 );
level.current_enemy = level.hind_battle_hind03b;
level.lookatenemy = true;
level.player_hind SetMaxPitchRoll( 50, 30 );
level.sight_angle = 145;
flag_set( "encounter3_center_view" );
flag_wait ("hind03b_follow_player");
level.player disableInvulnerability();
offset2 = (-2100, -900, 240);
wait 2;
level.hind_battle_hind03b thread follow_enemy_vehicle( level.player_hind, offset2, 0, 2 );
flag_wait ( "reset_yaw" );
level.player_hind SetMaxPitchRoll( 10, 5 );
level.lookatenemy = false;
level.player_hind smooth_vehicle_path_clear_override_speed ( );
while ( isVehicleAlive( level.hind_battle_hind03b ) )
{
wait 0.05;
if ( !isVehicleAlive(level.hind_battle_hind06b))
{
cos45 = 0.707;
if (flag ("spawn_next_hind") || (!within_fov( level.player GetEye(), level.player GetPlayerAngles(), level.hind_battle_hind03b.origin, cos45 )) )
{
if (isVehicleAlive(level.hind_battle_hind03b))
flag_set( "aud_vo_lost_him" );
}
}
}
}
player_chase_sequence()
{
flag_wait( "spawn_hind06b" );
flag_set( "aud_vo_chase" );
wait 0.45;
level.hind_battle_hind06b = spawn_enemy_hind ( "hind_battle_hind06b", true, (3*level.hind_health) );
aud_send_msg("spawn_hind06b", level.hind_battle_hind06b);
level.hind_battle_hind06b thread enemy_hind_think();
level.hind_battle_hind06b thread monitor_for_safe_crash_location(level.hind_battle_hind03b);
level.hind_battle_hind06b SetMaxPitchRoll( 20, 90 );
aud_send_msg("begin_hind_conversation");
radio_dialogue ( "manhattan_hp1_rightsidehigh" );
aud_send_msg("end_hind_conversation");
flag_wait ("hind06b_to_follow");
wait 1;
level.hind_battle_hind06b SetMaxPitchRoll( 10, 40 );
level.hind_battle_hind06b thread look_at_player(-1);
offset = (-1100, -520, 200);
level.hind_battle_hind06b thread follow_enemy_vehicle( level.player_hind, offset, 0, 2 );
flag_set( "encounter4_favor_back" );
}
spawn_decoy()
{
flag_wait( "spawn_next_hind" );
wait 2;
level.hind_decoy = spawn_enemy_hind ( "hind_battle_hind05x", true, level.hind_health );
level.hind_decoy SetMaxPitchRoll( 15, 90 );
level.hind_decoy shoot_scripted("missile_target_02", 1);
}
final_chase_sequence()
{
flag_wait ("surprise_follower");
aud_send_msg("surprise_follower");
level.hind_battle_hind03c = spawn_enemy_hind ( "hind_battle_hind03c", true, 38000, 1 );
level.hind_battle_hind03c smooth_vehicle_path_set_override_speed ( 40, 90, 90 );
level.hind_battle_hind03c thread enemy_hind_think();
level.hind_battle_hind03c.godmode = true;
level.current_enemy = level.hind_battle_hind03c;
level.lookatenemy = true;
level.hind_battle_hind03c thread look_at_player(-1);
}
construction_building_battle()
{
flag_wait( "surprise_follower" );
level.player_hind thread construction_building_player_setup();
flag_wait ("enemy_pause_01");
level.player_hind thread construction_building_player_phase_1();
level.hind_battle_hind03c thread construction_building_enemy_phase_1();
flag_wait ("const_enemy_pursue");
wait 3;
if ( isVehicleAlive(level.hind_battle_hind03c) )
{
level.player EnableInvulnerability();
level.player_hind thread construction_building_player_phase_2();
level.hind_battle_hind03c thread construction_building_enemy_phase_2();
}
flag_wait("player_arrived");
flag_wait("enemy_arrived");
flag_set("start_finale");
}
construction_building_player_setup()
{
self smooth_vehicle_path_set_override_speed ( 30, 60, 30 );
self set_vehicle_health(7000);
}
construction_building_player_phase_1()
{
path = getstruct("const_bottom_loop_node", "targetname");
self SetMaxPitchRoll( 60, 30 );
self smooth_vehicle_path_set_override_speed ( 30, 60, 60 );
self thread vehicle_paths( path );
flag_wait ("const_enemy_pursue");
self SetMaxPitchRoll( 10, 5 );
}
construction_building_enemy_phase_1()
{
path = getstruct("const_bottom_loop_node_enemy", "targetname");
self endon( "death" );
wait 3.25;
self.stop_looking = true;
self thread vehicle_paths( path );
}
construction_building_player_phase_2()
{
self.godmode = true;
last_path_player = getstruct ("player_return", "targetname");
wait 0.65;
self smooth_vehicle_path_set_override_speed ( 45, 90, 90 );
self thread smooth_vehicle_switch_path( last_path_player, 2, 24, undefined, true);
}
construction_building_enemy_phase_2()
{
self thread focus_fire(12);
self thread missile_onslaught(12);
self.missile_stop = true;
self.godmode = true;
}
pause_helicopter(speed, flag_id)
{
flag_wait (flag_id);
self smooth_vehicle_path_set_override_speed ( speed, 20, 5 );
}
pause_helicopter_until(speed, flag_id)
{
while (!flag(flag_id))
{
wait 0.05;
self smooth_vehicle_path_set_override_speed ( speed, 20, 5 );
}
}
timer(time)
{
wait (time);
return true;
}
player_enter_hind( start_on_hind, finale )
{
flag_wait("entering_hind");
addforcestreamxmodel( "weapon_blackhawk_minigun_viewmodel" );
if (!isdefined(start_on_hind))
start_on_hind = false;
if (!start_on_hind)
{
playertag = "tag_player1";
level.player allowprone( false );
level.player allowcrouch( false );
level.player_hind anim_first_frame_solo( level.player_arms, "ny_harbor_hind_entry", playertag );
level.player_hind anim_first_frame_solo( level.player_legs, "ny_harbor_hind_entry", playertag );
level.player_hind.turret_model.animname = "turret";
level.player_hind.turret_model SetAnimTree();
level.player_hind.turret_model unlink();
level.player_hind thread anim_first_frame_solo( level.player_hind.turret_model, "ny_harbor_hind_entry", playertag );
level.player_hind.turret_model linkto( level.player_hind, playertag );
level.player_arms linkto( level.player_hind, playertag );
level.player_legs linkto( level.player_hind, playertag );
level.player PlayerLinkToBlend( level.player_arms, "tag_player", 0.2 );
wait 0.2;
thread vision_set_fog_changes("ny_manhattan_hind", 5);
thread wait_for_turret_swap();
level.player_arms show();
thread lerp_fov_overtime(2, 55);
level.player_hind thread anim_single_solo( level.player_legs, "ny_harbor_hind_entry", playertag );
level.player_hind thread anim_single_solo( level.player_hind.turret_model, "ny_harbor_hind_entry", playertag );
level.player_hind anim_single_solo( level.player_arms, "ny_harbor_hind_entry", playertag );
level.player_legs Hide();
level.player_hind.turret_model linkto( level.player_hind, "tag_turret_npc" );
level.player_arms unlink();
level.player_legs unlink();
}
else
{
thread vision_set_fog_changes("ny_manhattan_hind", 5);
level.starting_on_hind = true;
}
flag_set( "obj_capturehind_complete" );
player_lerped_onto_hind_sideturret(false);
level.player setup_no_dirt_from_explosions();
level.player_arms hide();
start_squad_on_hind( start_on_hind );
if (!flag ( "hind_start_point" ) )
{
wait 0.1;
}
else
wait 0.1;
self notify("player_entered_hind");
thread setup_hind_ride( finale );
}
rooftop_guys_timer()
{
wait 18;
flag_set ( "rooftop_guys_dead" );
}
wait_to_reach_goal_for_finale( tgt )
{
self waittill( "goal" );
while (true)
{
dang = abs(tgt.angles[1] - self.angles[1]);
if (dang < 5)
break;
wait 0.05;
}
level.wait_for_finale += 1;
}
show_pos(pos, colr)
{
}
show_axis(pos, angles)
{
}
show_ent_pos(ent, colr)
{
ent endon("death");
}
show_ent_axis(ent)
{
if (!isdefined(level.debug_txt_y))
level.debug_txt_y = 30;
name = ent getentitynumber() + "";
CreateDebugTextHud( name, 20, level.debug_txt_y, (1,1,1), "" );
level.debug_txt_y += 18;
ent endon("death");
}
wait_for_finale_timeout( timeout )
{
level endon("finale_playing");
level.hind_battle_hind03c thread focus_fire ( timeout );
level.hind_battle_hind03c.missile_stop = true;
wait timeout;
if (!IsGodMode(level.player))
level.player_hind.godmode = false;
level.player DisableInvulnerability();
level.hind_battle_hind03c thread missile_onslaught(0.05, 1);
level.player_hind set_vehicle_health(1100);
wait 1;
}
wait_to_be_hit()
{
self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
}
MoveToEntity( ent, time, lock_after_time)
{
ent endon("death");
self endon("death");
self endon("stop_move");
while (time > 0)
{
wait 0.05;
time -= 0.05;
if (time > 0)
{
self moveto(ent.origin,time,0,0);
self rotateto(ent.angles,time,0,0);
}
}
if (lock_after_time)
{
while (true)
{
self.origin = ent.origin;
self.angles = ent.angles;
wait 0.05;
}
}
else
{
self.origin = ent.origin;
self.angles = ent.angles;
}
}
Blur_from_collision()
{
wait 0.5;
wait 1.6;
}
HideEnemyHindAfterCrash(enemy_hind_model, enemy_hind)
{
enemy_hind_model waittillmatch("single anim","vfx_enemy_building_hit");
wait 0.5;
enemy_hind Delete();
enemy_hind_model Hide();
}
play_finale_manager()
{
level.player_hind endon("death");
flag_wait( "start_finale" );
scripted_node = getent( "hind_finale_scripted_node", "targetname" );
player_hind_start = getent( "hind_finale_player_hind_start", "targetname" );
enemy_hind_start = getent( "hind_finale_enemy_hind_start", "targetname" );
player_hind = level.player_hind;
enemy_hind = level.hind_battle_hind03c;
level.lookatenemy = true;
level.sight_angle = 90;
level.current_enemy = enemy_hind;
enemy_hind thread look_at_player(-1);
wait 0.05;
final_player_path= getstruct ("get_to_player_anim_pos", "targetname");
final_enemy_path = getstruct ("get_to_enemy_anim_pos", "targetname");
if (!isdefined(level.just_finale))
enemy_hind thread hind_shoot_missiles(3);
wait 1.2;
player_hind smooth_vehicle_path_set_override_speed ( 30, 60, 60 );
player_hind thread smooth_vehicle_switch_path( final_player_path, 2, 24, undefined, true);
player_hind SetMaxPitchRoll( 0, 0);
wait 1;
enemy_hind smooth_vehicle_path_set_override_speed ( 30, 60, 60 );
enemy_hind thread smooth_vehicle_switch_path( final_enemy_path, 2, 24, undefined, true);
flag_wait("player_arrived02");
flag_wait("enemy_arrived02");
hoverpath = getstruct ("player_hind_during_finale_start", "targetname");
player_hind thread ny_start_heli_path( hoverpath, 2, 240);
level thread wait_for_finale_timeout(5.0);
enemy_hind wait_to_be_hit();
wait 0.05;
enemy_hind notify("newpath");
level notify("finale_playing");
enemy_hind_model = spawn("script_model", enemy_hind.origin);
aud_send_msg("finale_playing", enemy_hind_model);
enemy_hind_model SetModel( "vehicle_mi24p_hind_manhattan" );
enemy_hind_model.angles = enemy_hind.angles;
enemy_hind switch_cool_damage(enemy_hind_model);
enemy_hind Hide();
enemy_hind vehicle_lights_off("all");
enemy_hind nym_disallow_shooting();
enemy_hind notify("stop_ai");
enemy_hind_model.animname = "enemyhind";
enemy_hind_model setAnimTree();
playfxontag(getfx("ny_hind_lastHit"),enemy_hind_model,"tag_origin");
aud_send_msg("ny_hind_lastHit", enemy_hind);
enemy_hind_model thread maps\ny_manhattan_fx::enemy_hind_spot_finale();
player_hind anim_first_frame_solo(enemy_hind_model, "ny_manhattan_hind_finale");
result = TransformMove(enemy_hind.origin, enemy_hind.angles, enemy_hind_model.origin, enemy_hind_model.angles, player_hind.origin, player_hind.angles);
ref_position = spawn_tag_origin();
ref_position.origin = result["origin"];
ref_position.angles = result["angles"];
ref_position anim_first_frame_solo(enemy_hind_model, "ny_manhattan_hind_finale");
enemy_hind_model linkto(ref_position);
player_ambient_path = getstruct ("player_hind_during_finale_start", "targetname");
player_hind thread ny_start_heli_path( player_ambient_path, 2, 24);
ref_position thread MoveToEntity(player_hind, 1, true);
thread aud_vo_finale ();
ref_position anim_single_solo(enemy_hind_model, "ny_manhattan_hind_finale");
player_hind_model = spawn("script_model", player_hind.origin);
player_hind_model setmodel("vehicle_ny_blackhawk");
player_hind_model.angles = player_hind.angles;
player_hind Hide();
player_hind vehicle_lights_off("all");
player_hind_model.animname = "hind";
player_hind_model setAnimTree();
player_hind_model HidePart( "wheel_root_r", "vehicle_ny_blackhawk" );
player_hind_model HidePart( "wheel_front_r_base_jnt", "vehicle_ny_blackhawk" );
player_hind_model HidePart( "wheel_front_r_jnt", "vehicle_ny_blackhawk" );
player_hind_model HidePart( "wheel_root_l", "vehicle_ny_blackhawk" );
player_hind_model HidePart( "wheel_front_l_base_jnt", "vehicle_ny_blackhawk" );
player_hind_model HidePart( "wheel_front_l_jnt", "vehicle_ny_blackhawk" );
player_hind_model thread finale_animated_rotors();
enemy_hind_model unlink();
thread HideEnemyHindAfterCrash(enemy_hind_model, enemy_hind);
helis[0] = player_hind_model;
helis[1] = enemy_hind_model;
scripted_node anim_first_frame(helis, "ny_manhattan_hind_finale2");
player_hind_model dontinterpolate();
enemy_hind_model dontinterpolate();
wait 0.05;
turret_model = spawn("script_model", player_hind_model gettagorigin("tag_turret_npc"));
turret_model setmodel("weapon_blackhawk_minigun");
turret_model.animname = "hindturret";
turret_model SetAnimTree();
turret_model.angles = player_hind_model gettagangles("tag_turret_npc");
turret_model.origin = player_hind_model gettagorigin("tag_turret_npc");
player_hind_model anim_first_frame_solo(turret_model, "ny_manhattan_hind_finale2", "tag_turret_npc");
turret_model LinkTo( player_hind_model, "tag_turret_npc" );
turret_model dontinterpolate();
idx=1;
guys = [];
player_hind notify("end_loop");
foreach (guy in level.squad1)
{
guy unlink();
player_hind_model anim_first_frame_solo(guy, "ny_manhattan_hind_finale2", "tag_player1");
guy dontinterpolate();
guy linkto( player_hind_model, "tag_player1" );
guy.name = undefined;
guys[idx] = guy;
idx = idx + 1;
if (idx > 3)
break;
}
guys[idx] = level.player_arms;
level.player_arms unlink();
player_hind_model anim_first_frame_solo( level.player_arms, "ny_manhattan_hind_finale2", "tag_player1" );
level.player_arms dontinterpolate();
level.player_arms linkto( player_hind_model, "tag_player1" );
level.player_arms show();
if (isdefined(level.use_hind_mg))
{
level.hind_tvm.player EnableTurretDismount();
level.player unlink();
level.hind_tvm.turret Delete();
}
else
{
level.player unlink();
}
level.player allowprone( false );
level.player allowcrouch( false );
level.player disableWeapons();
level.player PlayerLinkToBlend( level.player_arms, "tag_player", 0 );
level.truck gun_remove();
thread hind_finale_give_cam_control();
thread Blur_from_collision();
thread start_building_chunk_anim( level.player_arms, scripted_node );
flag_set ( "hind_finale_start" );
thread ending_fadeout_nextmission(level.player_arms);
player_hind_model thread maps\ny_manhattan_fx::hind_finale_rotor_hit();
player_hind_model thread anim_single(guys, "ny_manhattan_hind_finale2", "tag_player1");
player_hind_model thread anim_single_solo(turret_model, "ny_manhattan_hind_finale2", "tag_turret_npc");
thread finale_rumble();
scripted_node anim_single(helis, "ny_manhattan_hind_finale2");
level notify("hind_finale_finished");
}
finale_rumble()
{
level.rumble thread rumble_ramp_to ( 1, 0.1 );
wait 1;
level.rumble thread rumble_ramp_to( 0, 1 );
wait 5;
level.rumble thread rumble_ramp_to( 0.6, 0.1 );
wait 0.5;
level.rumble thread rumble_ramp_to( 0, 1 );
wait 3;
level.rumble thread rumble_ramp_to( 0.2, 1 );
wait 4;
level.rumble thread rumble_ramp_to( 0, 1 );
wait 6;
level.rumble thread rumble_ramp_to( 0.2, 1 );
wait 6.5;
level.rumble thread rumble_ramp_to( 1, 0.1 );
wait 0.5;
level.rumble thread rumble_ramp_to( 0, 0.5 );
}
hind_finale_give_cam_control()
{
wait 27;
level.player playerlinktodelta ( level.player_arms, "tag_player", 1, 0, 0, 0, 0, true );
wait 0.05;
level.player LerpViewAngleClamp ( 2, 1, 0.25, 20, 15, 20, 10 );
}
finale_animated_rotors()
{
self endon( "death" );
xanim = level.scr_anim[ "ny_harbor_hind"]["rotors"];
length = getanimlength( xanim );
while ( true )
{
if ( !isdefined( self ) )
break;
self setanim( xanim );
wait length;
}
}
do_movie_fadein( black_overlay )
{
wait 0.1;
black_overlay FadeOverTime( 1.0 );
black_overlay.alpha = 0;
}
start_building_chunk_anim( notetrack_obj, scripted_node )
{
notetrack_obj waittillmatch("single anim", "trigger exploding chunks" );
chunks = spawn("script_model", (0,0,0));
chunks.animname = "chunks";
chunks assign_model();
chunks SetAnimTree();
scripted_node anim_single_solo( chunks, "ny_manhattan_hind_finale3" );
}
ending_fadeout_nextmission( notetrack_obj )
{
video_fade_time = 5.0;
audio_delay_time	= 4.0;
audio_fade_time = video_fade_time;
level_fade_time = audio_delay_time + audio_fade_time;
notetrack_obj waittillmatch("single anim", "fade_out" );
black_overlay = create_client_overlay( "black", 0, level.player );
black_overlay FadeOverTime(video_fade_time);
black_overlay.alpha = 1;
aud_send_msg("ny_manhattan_fade_to_black", [audio_delay_time, audio_fade_time]);
wait(level_fade_time);
nextmission();
}
attach_fx_on_target( fxSet,tagSet, point, direction_vec)
{
self endon( "stop_looping_death_fx" );
tagNum = find_closest_tag(point,tagSet);
if (tagNum == -1)
return;
tag = tagSet[tagNum];
fx = fxSet[tagNum];
loopTime = 0.05;
tag_origin = spawn_tag_origin();
tag_origin.origin = self GetTagOrigin(tag);
tag_origin.angles = self GetTagAngles(tag);
tag_origin linkto( self, tag );
self.cool_damage_info[tag]["origin"] = tag_origin;
self.cool_damage_info[tag]["fx"] = fx;
PlayFXOnTag( fx, tag_origin, "tag_origin" );
}
switch_cool_damage( target )
{
if (isdefined(self.cool_damage_info))
{
foreach (tag, rec in self.cool_damage_info)
{
rec["origin"] linkto( target, tag);
}
target.cool_damage_info = self.cool_damage_info;
self.cool_damage_info = undefined;
}
}
find_closest_tag(point,tags)
{
mindist = 1000000;
mintag = -1;
j = 0;
returnIndx = -1;
foreach (tag in tags)
{
if (isdefined(self.cool_damage_info) && isdefined(self.cool_damage_info[tag]))
continue;
tag_pos = self GetTagOrigin( tag );
dist = Distance( tag_pos, point );
if (dist < mindist)
{
mindist = dist;
mintag = tag;
returnIndx = j;
}
j++;
}
return returnIndx;
}
kill_enemy_hind_cool_damage_effects()
{
self waittill("death");
cool_damage_info = self.cool_damage_info;
while (isdefined(self))
wait 0.1;
if (isdefined(cool_damage_info))
{
foreach (tag, rec in cool_damage_info)
{
StopFxOnTag(rec["fx"], rec["origin"], "tag_origin");
rec["origin"] Delete();
}
}
}
enemy_hind_cool_damage_effects()
{
self endon("death");
fxs = [ "smoke/smoke_trail_black_heli_emitter","fire/heli_engine_fire" , "smoke/smoke_trail_black_heli_emitter", "fire/heli_engine_fire", "fire/heli_engine_fire", "smoke/smoke_trail_black_heli_emitter", "smoke/smoke_trail_black_heli_emitter", "fire/heli_engine_fire", "fire/heli_engine_fire", "smoke/smoke_trail_black_heli_emitter", "smoke/smoke_trail_black_heli_emitter" ];
tags = [ "tag_origin" , "main_rotor_jnt" , "tag_deathfx" , "tag_engine_left" , "tag_engine_right"	, "tag_light_belly" , "tag_light_cockpit01", "tag_light_L_wing" , "tag_light_R_wing" , "tag_light_tail" , "tag_turret" ];
smokefx = [];
for(i=0;i<fxs.size;i++)
{
smokefx[(smokefx.size)]=loadfx(fxs[i]);
}
damagetillnextfx = 5000;
numFXplaying = 0;
curdamagetillnextfx = damagetillnextfx;
self thread kill_enemy_hind_cool_damage_effects();
while (true)
{
self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
curdamagetillnextfx -= amount;
if (curdamagetillnextfx <= 0 && numFXplaying < 4)
{
if(numFXplaying>2)
{
fxs[1]="fire/fire_smoke_trail_l_emitter";
fxs[3]="fire/fire_smoke_trail_l_emitter";
fxs[7]="fire/fire_smoke_trail_l_emitter";
fxs[8]="fire/fire_smoke_trail_l_emitter";
fxs[9]="fire/fire_smoke_trail_l_emitter";
}
self thread attach_fx_on_target( smokefx,tags, point, direction_vec);
curdamagetillnextfx = damagetillnextfx;
numFXplaying ++;
}
}
}
keep_dead_player_attached()
{
level.player waittill("death");
level.player PlayerLinkToBlend( level.player_hind, "tag_player", 0.05);
}
kill_player_if_hind_dies()
{
thread keep_dead_player_attached();
level.player_hind waittill("death");
if ( isalive ( level.player ) )
{
SetDvar( "ui_deadquote", &"NY_MANHATTAN_BLACKHAWK_KILLED" );
maps\_utility::missionFailedWrapper();
}
}
flash_black_blur()
{
black_overlay = get_black_overlay();
thread blur_overlay(8.0,0.2);
black_overlay delayThread( 0.2, ::exp_fade_overlay, 1, .2 );
black_overlay delayThread( 0.7, ::exp_fade_overlay, 0, 1 );
delayThread( 0.7, ::blur_overlay, 0, 1 );
}
exp_fade_overlay( target_alpha, fade_time )
{
self notify( "exp_fade_overlay" );
self endon( "exp_fade_overlay" );
fade_steps = 4;
step_angle = 90 / fade_steps;
current_angle = 0;
step_time = fade_time / fade_steps;
current_alpha = self.alpha;
alpha_dif = current_alpha - target_alpha;
for ( i = 0; i < fade_steps; i++ )
{
current_angle += step_angle;
self FadeOverTime( step_time );
if ( target_alpha > current_alpha )
{
fraction = 1 - Cos( current_angle );
self.alpha = current_alpha - alpha_dif * fraction;
}
else
{
fraction = Sin( current_angle );
self.alpha = current_alpha - alpha_dif * fraction;
}
wait step_time;
}
}
get_black_overlay()
{
if ( !isdefined( level.black_overlay ) )
level.black_overlay = create_client_overlay( "black", 0, level.player );
level.black_overlay.sort = -1;
level.black_overlay.foreground = false;
return level.black_overlay;
}
blur_overlay( target, time )
{
SetBlur( target, time );
}
nodirt_on_screen_from_position( position )
{
PlayRumbleOnPosition( "grenade_rumble", position );
Earthquake( 0.3, 0.5, position, 400 );
wii_play_grenade_rumble( position );
}
setup_no_dirt_from_explosions()
{
func = ::nodirt_on_screen_from_position;
level.player.mods_override = [];
level.player.mods_override[ "MOD_GRENADE" ] = func;
level.player.mods_override[ "MOD_GRENADE_SPLASH" ] = func;
level.player.mods_override[ "MOD_PROJECTILE" ] = func;
level.player.mods_override[ "MOD_PROJECTILE_SPLASH" ] = func;
level.player.mods_override[ "MOD_EXPLOSIVE" ] = func;
}
restore_dirt_from_explosions()
{
level.player.mods_override = undefined;
}



