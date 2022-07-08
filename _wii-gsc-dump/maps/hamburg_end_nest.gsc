#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_end;
#include animscripts\hummer_turret\common;
#include maps\hamburg_tank_ai;
#include maps\_audio;
#include maps\_hud_util;
ALLYIN2AXIS_IN_PLAYER_OUT = 5000;
ALLYOUT2AXIS_IN_PLAYER_OUT = -5000;
ALLYIN2AXIS_OUT_PLAYER_OUT = 2500;
ALLYOUT2AXIS_OUT_PLAYER_OUT = 5000;
ALLYIN2AXIS_IN_PLAYER_IN = 2500;
ALLYOUT2AXIS_IN_PLAYER_IN = 200;
ALLYIN2AXIS_OUT_PLAYER_IN = -5000;
ALLYOUT2AXIS_OUT_PLAYER_IN = 5000;
begin_ambush()
{
}
setup_ambush()
{
maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
startstruct = getstruct( "start_ambush", "targetname" );
if(isdefined(startstruct))
{
level.player SetOrigin( startstruct.origin );
level.player SetPlayerAngles( startstruct.angles );
}
spawn_allies(1);
battlechatter_on( "allies" );
battlechatter_on( "axis" );
setup_suv_scene_bodies();
thread setup_hvt_vehicles();
thread squad_goto_hvt_vehicles();
thread setup_flickering_lights();
thread handle_null_breach();
thread squad_goto_hvt_vehicles_failsafe();
set_no_explode_vehicles();
wait 1;
flag_set("flag_goto_hvt_vehicles");
}
setup_nest()
{
maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
startstruct = getstruct( "start_crows_nest", "targetname" );
if(isdefined(startstruct))
{
level.player SetOrigin( startstruct.origin );
level.player SetPlayerAngles( startstruct.angles );
}
spawn_allies(1);
thread maps\hamburg_end_streets::f15_bomber();
flag_set("rooftop_javs_dead");
wait 1;
battlechatter_on( "allies" );
battlechatter_on( "axis" );
set_no_explode_vehicles();
thread maps\hamburg_code::cleanup_bridge_and_before_garage_area();
wait 2;
thread maps\hamburg_code::garage_cleanup_beach_area();
thread axisdebug();
}
axisdebug()
{
level.db_axis = 0;
while(1)
{
axis = GetAIArray( "axis" );
if( axis.size != level.db_axis )
{
level.db_axis = axis.size ;
IPrintLn("T:"+axis.size );
}
wait 0.1;
}
}
setup_end()
{
maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
startstruct = getstruct( "start_end", "targetname" );
if(isdefined(startstruct))
{
level.player SetOrigin( startstruct.origin );
level.player SetPlayerAngles( startstruct.angles );
}
spawn_allies(1);
battlechatter_off( "allies" );
battlechatter_on( "axis" );
thread setup_flickering_lights();
thread handle_null_breach();
setup_suv_scene_bodies();
thread setup_hvt_vehicles();
set_no_explode_vehicles();
}
nest_pre_load()
{
thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance0_outside_battle2");
thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance2_outside_battle2");
thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance1_outside_battle2");
thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance3_outside_battle2");
thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance4_outside_battle2");
flag_init( "nest_go_wave1a" );
flag_init( "approaching_null_breach" );
flag_init( "finish_mission" );
flag_init( "start_outside_battle2" );
flag_init( "advance0_outside_battle2" );
flag_init( "flag_nest_apache_killspot" );
flag_init( "advance1_outside_battle2" );
flag_init( "advance2_outside_battle2" );
flag_init( "advance3_outside_battle2" );
flag_init( "advance4_outside_battle2" );
flag_init( "advance5_outside_battle2" );
flag_init( "nest_advance_inside1" );
flag_init( "follow_sandman_nest" );
flag_init( "rooftop_javs_dead" );
flag_init( "endstreet_helis");
flag_init("go_rooftop_heli");
flag_init("player_approaching_breach");
flag_init( "flag_goto_hvt_vehicles" );
flag_init( "allies_follow_sandman_to_breach" );
flag_init( "squad_at_hvts" );
flag_init( "flag_streets_apache_killspot" );
flag_init("retreat_balconyguys");
flag_init("stop_breach_chatter");
flag_init("goalpost_dead");
flag_init("close_breach_door");
flag_init("sandman_at_breach");
flag_init("flag_search_scene_failsafe");
flag_init("search_scene_finished");
}
begin_nest()
{
level.destructible_protection_func = undefined;
thread go_rooftop_heli();
flag_wait( "nestfoot_finished" );
}
breachroom_close_the_door()
{
icon_trigger = GetEnt( "trigger_breach_icon", "targetname" );
icon_trigger trigger_off();
usetrigger = getent("hamburg_trigger_use_breach","targetname");
usetrigger disable_trigger_with_targetname("hamburg_trigger_use_breach");
wait( 1 );
breach_door = level.breach_doors[ 2 ];
breach_door Hide();
breach_path_clip = GetEnt( "breach_solid", "targetname" );
breach_path_clip NotSolid();
breach_path_clip ConnectPaths();
old_door = GetEnt( "blast_door_slam", "targetname" );
old_door.origin = breach_door.origin;
startAngles = old_door.angles;
old_door.angles += ( 0, -74, 0 );
flag_wait( "close_breach_door" );
thread nest_enemy_battlechatter();
old_door RotateYaw( 74, .25 );
old_door thread play_sound_in_space( "breach_door_slam", old_door.origin );
breach_path_clip Solid();
breach_path_clip DisconnectPaths();
wait( .66 );
old_door thread play_sound_in_space( "breach_headshot", old_door.origin );
old_door Hide();
old_door NotSolid();
breach_door Show();
wait 0.4;
old_door thread play_sound_in_space( "breach_headshot", old_door.origin );
wait .15;
old_door thread play_sound_in_space( "breach_headshot", old_door.origin );
wait 0.5;
old_door thread play_sound_in_space( "breach_bodyfall", old_door.origin );
flag_wait("sandman_at_breach");
icon_trigger trigger_on();
usetrigger enable_trigger_with_targetname("hamburg_trigger_use_breach");
level waittill( "breaching" );
icon_trigger trigger_off();
}
setup_battle2_to_hvts()
{
thread setup_hvt_vehicles();
thread objective_follow_sandman();
thread nest_javelin_apache();
thread setup_end_street_combat();
thread maps\hamburg_end::allied_jets_ambient();
}
begin_end()
{
level.destructible_protection_func = undefined;
thread autosave_by_name( "begin_end" );
thread objective_follow_sandman();
flag_wait( "nestfoot_finished" );
}
ai_array_killcount_flag_set( enemies , killcount , flag , timeout )
{
waittill_dead_or_dying( enemies , killcount , timeout );
flag_set( flag );
}
check_trigger_flagset(targetname)
{
trigger = getent(targetname,"targetname");
trigger waittill( "trigger" );
if ( IsDefined( trigger.script_flag_set ) )
{
flag_set( trigger.script_flag_set );
}
}
setup_end_street_combat()
{
flag_wait("rooftop_javs_dead");
thread autosave_by_name( "rooftop_javs_dead" );
thread spawn_end_street_wave2();
thread squad_goto_hvt_vehicles();
if(IsDefined(level.green1) && isalive(level.green1))
{
level.green1.fixednodesaferadius = 100;
}
if(IsDefined(level.green2) && isalive(level.green2))
{
level.green2.fixednodesaferadius = 100;
}
guys = array_spawn_targetname_allow_fail("end_streets_wave1");
music_play( "ham_end_see_ambush" );
level.sandman dialogue_queue( "hamburg_snd_rooftopsclear" );
level.sandman thread dialogue_queue( "hamburg_snd_convoyatend" );
wait 1;
endstreets_apache();
thread ai_array_killcount_flag_set(guys, (guys.size - 2), "advance1_outside_battle2");
}
spawn_end_street_wave2()
{
flag_wait("advance1_outside_battle2");
thread autosave_by_name( "advance1_outside_battle2" );
thread spawn_end_street_wave3();
thread retreat_from_vol_to_vol("goal_Lstreets_wave0","goal_Lstreets_wave1", .5, 1);
SafeActivateTrigger("trig_advance1_outside_battle2");
guys = array_spawn_targetname_allow_fail("end_streets_wave2");
thread ai_array_killcount_flag_set(guys, (guys.size - 2), "advance2_outside_battle2");
}
spawn_end_street_wave3()
{
flag_wait("advance2_outside_battle2");
thread autosave_by_name( "advance2_outside_battle2" );
thread spawn_end_street_wave4();
thread retreat_from_vol_to_vol("goal_Lstreets_wave1","goal_Lstreets_wave3", 1, 2);
thread retreat_from_vol_to_vol("goal_Rstreets_wave1","goal_Rstreets_wave3", 2, 5);
SafeActivateTrigger("trig_advance2_outside_battle2");
guys = array_spawn_targetname_allow_fail("end_streets_wave3");
thread ai_array_killcount_flag_set(guys, (guys.size - 2), "advance3_outside_battle2");
thread endstreethelis();
}
spawn_end_street_wave4()
{
flag_wait("advance3_outside_battle2");
thread autosave_by_name( "advance3_outside_battle2" );
thread spawn_end_street_wave5();
wave4helis = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 800 );
setup_suv_scene_bodies();
SafeActivateTrigger("trig_advance3_outside_battle2");
level.endstreetguys1 = array_spawn_targetname_allow_fail("end_streets_wave4");
array_spawn_function_targetname("end_streets_nest", maps\hamburg_end::spawn_func_delete_at_path_end);
end_street_nest = array_spawn_targetname_allow_fail("end_streets_nest");
thread ai_array_killcount_flag_set(level.endstreetguys1, (level.endstreetguys1.size - 2), "advance4_outside_battle2");
}
spawn_end_street_wave5()
{
flag_wait("advance4_outside_battle2");
thread setup_flickering_lights();
thread handle_null_breach();
thread squad_goto_hvt_vehicles_failsafe();
thread autosave_by_name( "advance4_outside_battle2" );
thread retreat_from_vol_to_vol("goal_Lstreets_wave3","goal_streets_wave4", 2, 3);
thread retreat_from_vol_to_vol("goal_Rstreets_wave3","goal_streets_wave4", 2, 5);
SafeActivateTrigger("trig_advance4_outside_battle2");
level.endstreetguys2 = array_spawn_targetname_allow_fail("end_streets_wave5");
wait 0.05;
radio_dialogue( "tank_hqr_reached" );
level.sandman dialogue_queue("hamburg_snd_affirmitive");
level.sandman thread dialogue_queue("hamburg_snd_watchleft");
combarr = [];
combarr = array_combine(level.endstreetguys1, level.endstreetguys2);
thread ai_array_killcount_flag_set(combarr, combarr.size, "flag_goto_hvt_vehicles");
thread ai_array_killcount_flag_set(combarr, int(combarr.size * 0.5), "advance5_outside_battle2");
flag_wait("advance5_outside_battle2");
SafeActivateTrigger("trig_advance5_outside_battle2");
}
go_rooftop_heli()
{
flag_wait("go_rooftop_heli");
rooftopheli = spawn_vehicle_from_targetname_and_drive("endstreets_heli_rooftop");
endstreets_apache();
}
endstreethelis()
{
flag_wait("endstreet_helis");
heliflyby = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 400 );
}
squad_goto_hvt_vehicles()
{
level endon("flag_search_scene_failsafe");
aud_send_msg("play_car_horn");
flag_wait("flag_goto_hvt_vehicles");
flag_set("retreat_balconyguys");
heliflyby = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 400 );
thread setup_hvt_vehicles();
thread handle_suv_search_anim_veh( level.red1, "sandman","suv1", "suv1b" , "hvt_search_scene_sand", level.suv1, level.suv1_bullets , level.suvbody1 );
thread green1_handle_suv_search_anim_veh( level.green1, "rogers", "suv2","suv2b" , "hvt_search_scene_rogers", level.suv2, level.suv2_bullets , level.suvbody2 );
thread blue2_handle_search_anim( level.blue2, "leftside", "hvt_search_scene_left" );
thread blue1_handle_search_anim( level.blue1, "rightside", "hvt_search_scene_right" );
SafeActivateTrigger("trig_post_convoy_colors");
thread handle_convoy_vo();
}
green1_dialogue_queue( spawned_message, animname, vo_to_play )
{
if( !IsDefined( level.green1) || !IsAlive( level.green1 ) )
{
level waittill( spawned_message );
level.green1.animname = animname;
}
level.green1 dialogue_queue( vo_to_play );
}
handle_convoy_vo()
{
level endon("flag_search_scene_failsafe");
green1_dialogue_queue("greenend1_spawned", "rogers", "hamburg_rhg_wereclear" );
level.sandman dialogue_queue( "hamburg_snd_checkvehicles" );
flag_wait("squad_at_hvts");
wait 2;
music_stop( 20 );
level.green1 dialogue_queue( "hamburg_rhg_nothinhere" );
wait 1;
level.sandman dialogue_queue( "hamburg_snd_nothere" );
level.sandman dialogue_queue( "hamburg_snd_negativecargo" );
level.player radio_dialogue( "tank_hqr_anysign" );
level.sandman dialogue_queue( "hamburg_snd_copyyourlast" );
green1_dialogue_queue("greenend1_spawned", "rogers", "hamburg_rhg_lotofblood" );
green1_dialogue_queue("greenend1_spawned", "rogers", "hamburg_rhg_goinup" );
level.sandman thread dialogue_queue( "hamburg_snd_easy" );
flag_set("search_scene_finished");
SafeActivateTrigger("trig_squad_follow_sandman");
level.red1 enable_cqbwalk();
level.blue1 enable_cqbwalk();
level.blue2 enable_cqbwalk();
level.green1 enable_cqbwalk();
level.green2 enable_cqbwalk();
flag_set("allies_follow_sandman_to_breach");
flag_wait("approaching_null_breach");
level.red1 disable_cqbwalk();
level.blue1 disable_cqbwalk();
level.blue2 disable_cqbwalk();
level.green1 disable_cqbwalk();
level.green2 disable_cqbwalk();
delayThread( 0.5, ::music_play, "ham_end_gobreach");
level.green1 dialogue_queue("hamburg_rhg_contact");
level.sandman dialogue_queue("hamburg_snd_movenow");
flag_wait("sandman_at_breach");
level.sandman thread breach_door_nag();
}
breach_door_nag()
{
level endon("breaching");
while(1)
{
self dialogue_queue("hamburg_snd_getacharge");
wait 3;
self dialogue_queue("hamburg_snd_breachandclear");
wait 3;
self dialogue_queue("hamburg_snd_damndoor");
wait 3;
}
}
squad_goto_hvt_vehicles_failsafe()
{
level endon("search_scene_finished");
thread check_trigger_flagset("trig_search_scene_failsafe");
flag_wait("flag_search_scene_failsafe");
if(IsDefined(level.green1) && IsAlive(level.green1))
{
level.green1 anim_stopanimscripted();
}
if(IsDefined(level.green2) && IsAlive(level.green2))
{
level.green2 anim_stopanimscripted();
}
if(IsDefined(level.blue1) && IsAlive(level.blue1))
{
level.blue1 anim_stopanimscripted();
}
level.red1 anim_stopanimscripted();
level.red1 enable_sprint();
level.red1.movePlaybackRate = 1.2;
if(IsDefined(level.green1) && IsAlive(level.green1))
{
level.green1 enable_sprint();
level.green1.movePlaybackRate = 1.2;
}
if(IsDefined(level.green2) && IsAlive(level.green2))
{
level.green2 enable_sprint();
level.green2.movePlaybackRate = 1.2;
}
if(IsDefined(level.blue1) && IsAlive(level.blue1))
{
level.blue1 enable_sprint();
level.blue1.movePlaybackRate = 1.2;
}
if(IsDefined(level.blue2) && IsAlive(level.blue2))
{
level.blue2 enable_sprint();
level.blue2.movePlaybackRate = 1.2;
}
music_play( "ham_end_gobreach");
SafeActivateTrigger("trig_squad_follow_sandman");
flag_set("allies_follow_sandman_to_breach");
}
setup_hvt_vehicles()
{
level.suv1 = GetEnt("endsuv1","targetname");
level.suv2 = GetEnt("endsuv2","targetname");
level.suv1_bullets = GetEnt("endsuv1_bullets","targetname");
level.suv2_bullets = GetEnt("endsuv2_bullets","targetname");
level.gaz1 = GetEnt("gaz1","targetname");
level.gaz2 = GetEnt("gaz2","targetname");
level.gaz3 = GetEnt("gaz3","targetname");
level.suv1.animname = "suv1";
level.suv2.animname = "suv2";
level.suv1_bullets.animname = "suv1b";
level.suv2_bullets.animname = "suv2b";
level.gaz1.animname = "gaz1";
level.gaz2.animname = "gaz2";
level.gaz3.animname = "gaz3";
level.suv1 SetAnimTree();
level.suv2 SetAnimTree();
level.suv1_bullets SetAnimTree();
level.suv2_bullets SetAnimTree();
level.gaz1 SetAnimTree();
level.gaz2 SetAnimTree();
level.gaz3 SetAnimTree();
level.suv1 hidePart( "TAG_GLASS_LEFT_BACK" );
level.suv1 hidePart( "TAG_GLASS_LEFT_BACK_D" );
level.suv1 hidePart( "TAG_GLASS_LEFT_BACK_FX" );
level.suv2 hidePart( "TAG_GLASS_LEFT_FRONT" );
level.suv2 hidePart( "TAG_GLASS_LEFT_FRONT_D" );
level.suv2 hidePart( "TAG_GLASS_LEFT_FRONT_FX" );
thread hvt_vehicles_firstframe(level.suv1, level.suv2, level.gaz1, level.gaz2, level.gaz3, level.suv1_bullets, level.suv2_bullets, level.suv3_bullets );
}
hvt_vehicles_firstframe(suv1, suv2, gaz1, gaz2, gaz3, suv1b, suv2b, suv3b)
{
vehs = [];
vehs[0] = suv1;
vehs[1] = suv2;
vehs[3] = gaz1;
vehs[4] = gaz2;
vehs[5] = gaz3;
vehs[6] = suv1b;
vehs[7] = suv2b;
vehs[8] = suv3b;
scene = getstruct("node_hvt_search_sandman","targetname");
scene anim_first_frame_solo(vehs[0], "hvt_search_scene_sand" );
scene anim_first_frame_solo(vehs[1], "hvt_search_scene_rogers" );
scene anim_first_frame_solo(vehs[3], "hvt_search_scene_gaz" );
scene anim_first_frame_solo(vehs[4], "hvt_search_scene_gaz" );
scene anim_first_frame_solo(vehs[5], "hvt_search_scene_gaz" );
scene anim_first_frame_solo(vehs[6], "hvt_search_scene_sand" );
scene anim_first_frame_solo(vehs[7], "hvt_search_scene_rogers" );
scene anim_first_frame_solo(vehs[8], "hvt_search_scene_right" );
}
rogers_door_open_hvt()
{
rogers = self;
rogers PushPlayer( true );
rogers.animname = "generic" ;
goalnode = GetNode( "hvt_door_kick_start" , "targetname" );
goalstruct = getstruct( "struct_hvt_door_kick_start" , "targetname" );
goalnode anim_reach_and_approach_node_solo( rogers, "doorkick_2_stand");
thread rogers_open_door();
goalstruct anim_single_solo_run( rogers, "doorkick_2_stand" );
rogers PushPlayer( false );
}
rogers_open_door()
{
wait 0.4;
doorr = GetEnt( "hvt_door_kick_door", "targetname" );
doorr ConnectPaths();
doorr RotateYaw( -120, 0.15 );
doorr thread play_sound_in_space( "wood_door_kick", doorr.origin );
flag_clear( "streets_kicked_door" );
}
setup_suv_scene_bodies()
{
level.hvt_search_sceneorg = getstruct("node_hvt_search_sandman","targetname");
suv = GetEnt("end_suburban_destroyed","targetname");
joint = spawn_anim_model("suv_spin_wheel_joint", suv.origin);
joint linkto( suv, "tag_origin");
wheel = spawn_anim_model( "suv_spin_wheel", suv.origin );
wheel linkto( joint , "J_prop_1" );
suv thread anim_loop_solo( joint, "hamburg_suburban_wheel", "stop_loop");
suvbody1spawner = GetEnt("suvbody1","targetname");
suvbody2spawner = GetEnt("suvbody2","targetname");
suvbody3spawner = GetEnt("suvbody3","targetname");
suvbody3bspawner = GetEnt("suvbody3b","targetname");
suvbody4spawner = GetEnt("suvbody4","targetname");
suvbody5spawner = GetEnt("suvbody5","targetname");
suvbody6spawner = GetEnt("suvbody6","targetname");
suvbody7spawner = GetEnt("suvbody7","targetname");
suvbody1spawner.script_looping = 0;
suvbody2spawner.script_looping = 0;
suvbody3spawner.script_looping = 0;
suvbody3bspawner.script_looping = 0;
suvbody4spawner.script_looping = 0;
suvbody5spawner.script_looping = 0;
suvbody6spawner.script_looping = 0;
suvbody7spawner.script_looping = 0;
level.suvbody1 = suvbody1spawner dronespawn();
level.suvbody2 = suvbody2spawner dronespawn();
level.suvbody3 = suvbody3spawner dronespawn();
level.suvbody3b = suvbody3spawner dronespawn();
level.suvbody4 = suvbody4spawner dronespawn();
level.suvbody5 = suvbody5spawner dronespawn();
level.suvbody6 = suvbody6spawner dronespawn();
level.suvbody7 = suvbody7spawner dronespawn();
bodies = [];
bodies[0] = level.suvbody1;
bodies[1] = level.suvbody2;
bodies[2] = level.suvbody3;
bodies[3] = level.suvbody3b;
bodies[4] = level.suvbody4;
bodies[5] = level.suvbody5;
bodies[6] = level.suvbody6;
bodies[7] = level.suvbody7;
bodies[0].animname = "body1";
bodies[1].animname = "body2";
bodies[2].animname = "body3";
bodies[3].animname = "generic";
bodies[4].animname = "generic";
bodies[5].animname = "generic";
bodies[6].animname = "generic";
bodies[7].animname = "generic";
bodies[0] prep_bodies();
bodies[1] prep_bodies();
bodies[2] prep_bodies();
bodies[3] prep_bodies();
bodies[4] prep_bodies();
bodies[5] prep_bodies();
bodies[6] prep_bodies();
bodies[7] prep_bodies();
waitframe();
briefcase = GetEnt("hamburg_briefcase","targetname");
briefcase.animname = "hamburg_briefcase";
briefcase SetAnimTree();
level.hvt_search_sceneorg anim_first_frame_solo( briefcase, "scn_hamburg_briefcase" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[0], "hvt_search_scene_sand" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[1], "hvt_search_scene_rogers" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[2], "hvt_search_scene_right" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[3], "hamburg_convoy_search_briefcase_casualty" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[4], "hamburg_convoy_search_curb_casualty" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[5], "hamburg_convoy_search_front_gaz_russian_casualty" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[6], "hamburg_convoy_search_rear_gaz_russian_casualty" );
level.hvt_search_sceneorg anim_first_frame_solo(bodies[7], "hamburg_convoy_search_suv1_casualty" );
}
convoy_bodies()
{
spawners = getentarray( "convoy_bodies", "targetname" );
convoy_bodies = [];
foreach ( spawner in spawners )
{
guy = spawner dronespawn();
guy setcontents( 0 );
guy.animname = "generic";
guy.noragdoll = true;
guy.nocorpsedelete = true;
guy.ignoreme = true;
guy.reference = spawner;
guy.dontDoNotetracks = true;
guy.script_looping = 0;
guy gun_remove();
convoy_bodies[ convoy_bodies.size ] = guy;
guy.animation = spawner.animation;
guy.reference anim_first_frame_solo( guy, guy.animation );
}
}
prep_bodies()
{
self kill();
self setcontents( 0 );
self.noragdoll = true;
self.nocorpsedelete = true;
self.ignoreme = true;
self.dontDoNotetracks = true;
self.script_looping = 0;
self stopanimscripted();
self.allowdeath = false;
self.health = 1;
self.no_pain_sound = true;
self.diequietly = true;
self.delete_on_death = false;
self.ignoreme = true;
self.ignoreall = true;
self.dontEverShoot = true;
self gun_remove();
}
green1_handle_suv_search_anim_veh( ai, animname,vehanimname,vehbanimname, scene, veh, vehbullets, body )
{
if( !IsDefined( ai ) || !IsAlive( ai ) )
{
level waittill( "greenend1_spawned");
ai = level.green1;
}
if( !IsDefined( ai.magic_bullet_shield ) )
{
ai thread magic_bullet_shield();
}
handle_suv_search_anim_veh( ai, animname,vehanimname,vehbanimname, scene, veh, vehbullets, body ) ;
}
handle_suv_search_anim_veh( ai, animname,vehanimname,vehbanimname, scene, veh, vehbullets, body )
{
veh.animname = vehanimname;
vehbullets.animname = vehbanimname;
guys = [];
guys[0] = ai;
guys[1] = body;
guys[2] = veh;
guys[3] = vehbullets;
ai disable_ai_color();
ai set_ignoreall( false );
ai set_fixednode_false();
ai set_ignoresuppression( true );
ai.disablebulletwhizbyreaction = true;
ai.animname = animname;
if( ai == level.red1 )
{
level.red1.goalradius = 32;
level.red1 SetGoalPos( ( -300, 18219, -80 ) );
level.red1 waittill( "goal" );
}
level.hvt_search_sceneorg anim_reach_solo( ai, scene );
aud_send_msg("convoy_victim_1st_car");
level.hvt_search_sceneorg anim_single( guys ,scene );
if (scene == "hvt_search_scene_rogers")
{
aud_send_msg("stop_car_horn");
}
ai enable_ai_color();
}
blue1_handle_search_anim( ai , animname, scene )
{
if( !IsDefined( ai ) || !IsAlive( ai ) )
{
level waittill( "blueend1_spawned");
ai = level.blue1;
}
if( !IsDefined( ai.magic_bullet_shield ) )
{
ai thread magic_bullet_shield();
}
handle_search_anim( ai , animname, scene );
}
blue2_handle_search_anim( ai , animname, scene )
{
if( !IsDefined( ai ) || !IsAlive( ai ) )
{
level waittill( "blueend2_spawned");
ai = level.blue2;
}
if( !IsDefined( ai.magic_bullet_shield ) )
{
ai thread magic_bullet_shield();
}
handle_search_anim( ai , animname, scene );
}
handle_search_anim( ai , animname, scene )
{
ai disable_ai_color();
ai enable_cqbwalk();
ai set_ignoreall( false );
ai set_fixednode_false();
ai set_ignoresuppression( true );
ai.disablebulletwhizbyreaction = true;
ai.animname = animname;
level.hvt_search_sceneorg anim_reach_solo( ai, scene );
aud_send_msg("convoy_victim_2nd_car");
level.hvt_search_sceneorg anim_single_solo( ai ,scene );
ai disable_cqbwalk();
ai enable_ai_color();
}
setup_flickering_lights()
{
flares = getentarray( "flickerlight1", "targetname" );
foreach( flare in flares )
flare thread flareFlicker();
flares2 = getentarray( "flickerlight1a", "targetname" );
foreach( flare in flares2 )
flare thread flareFlicker();
fluorescents = getentarray( "fluorescentFlicker", "targetname" );
foreach( fluorescent in fluorescents )
fluorescent thread fluorescentFlicker();
}
fluorescentFlicker()
{
for ( ;; )
{
wait( randomfloatrange( .05, .1 ) );
self setLightIntensity( randomfloatrange( 0.2, 2.5 ) );
}
}
flareFlicker()
{
while( isdefined( self ) )
{
wait( randomfloatrange( .05, .1 ) );
self setLightIntensity( randomfloatrange( 0.6, 1.8 ) );
}
}
retreat_from_vol_to_vol( from_vol, retreat_vol, delay_min, delay_max)
{
AssertEx ( ((IsDefined(retreat_vol) && IsDefined( from_vol ) ) ), "Need the two info volume names ." );
checkvol = getEnt( from_vol , "targetname" );
retreaters = checkvol get_ai_touching_volume( "axis" );
goalvolume = getEnt( retreat_vol , "targetname" );
goalvolumetarget = getNode( goalvolume.target , "targetname" );
foreach( retreater in retreaters )
{
if(IsDefined(retreater) && IsAlive(retreater))
{
retreater.fixednode = 0;
retreater.pathRandomPercent = randomintrange( 75, 100 );
retreater SetGoalNode( goalvolumetarget );
retreater SetGoalVolume( goalvolume );
}
}
}
handle_null_breach()
{
flag_wait("approaching_null_breach");
maps\_slowmo_breach::slomo_sound_scale_setup();
thread maps\_autosave::_autosave_game_now_nochecks();
thread breachroom_close_the_door();
thread rogers_into_breach_room();
thread sandman_into_breach_room();
SetDvar("hostage_missionfail","1");
array_spawn_function_targetname("nestshadowguys", maps\hamburg_end::spawn_func_delete_at_path_end);
shadowguys = array_spawn_targetname_allow_fail("nestshadowguys");
foreach(guy in shadowguys)
{
guy.moveplaybackrate = 1.3;
guy.forcegoal = true;
guy.goalradius = 20;
guy.ignoreall = true;
guy.ignoreme = true;
guy.sprint = true;
guy.grenadeawareness = 0;
guy.ignoreexplosionevents = true;
guy.ignorerandombulletdamage = true;
guy.ignoresuppression = true;
guy.fixednode = false;
guy.disableBulletWhizbyReaction = true;
guy disable_pain();
guy magic_bullet_shield(true);
guy.og_newEnemyReactionDistSq = guy.newEnemyReactionDistSq;
guy.newEnemyReactionDistSq = 0;
}
thread setup_dead_hvts();
thread swinging_lamp_thread();
maps\_slowmo_breach::add_slowmo_breach_custom_function( "melee_B_attack", ::_slomo_breach_charger );
level waittill( "breaching" );
fade = 2;
thread music_stop( fade );
delayThread( fade, ::music_play, "ham_end_activatebreach" );
battlechatter_off("allies");
battlechatter_off("axis");
breach_enemies = [];
breach_enemies get_ai_group_ai("breach_enemies");
foreach(guy in breach_enemies)
{
guy disable_long_death();
}
goalpost = GetEntArray("scrgoalpost","script_noteworthy");
foreach(thing in goalpost)
{
if( !IsSpawner(thing))
{
level.realG = thing;
break;
}
}
flag_wait( "breaching_on" );
flag_set("stop_breach_chatter");
level.red1 disable_sprint();
if(IsDefined(level.green1) && IsAlive(level.green1))
{
level.green1 disable_sprint();
}
if(IsDefined(level.green2) && IsAlive(level.green2))
{
level.green2 disable_sprint();
}
if(IsDefined(level.blue1) && IsAlive(level.blue1))
{
level.blue1 disable_sprint();
}
if(IsDefined(level.blue2) && IsAlive(level.blue2))
{
level.blue2 disable_sprint();
}
level waittill("slowmo_breach_ending");
if(IsAlive(level.realG))
{
music_play( "ham_end_resuced");
battlechatter_on("allies");
thread handle_blue1_breach_anim();
thread handle_red1_breach_anim();
thread rescue_hvt_dialogue();
wait 4;
badguys = GetAIArray("axis");
foreach(ai in badguys)
{
if(IsDefined(ai) && IsAlive(ai))
{
ai Delete();
}
}
SafeActivateTrigger("trig_allies_into_breachroom");
wait 2;
spawn_vehicle_from_targetname_and_drive("nest_osprey_kill");
level.endvehiclearr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 350 );
aud_send_msg("end_osprey");
wait 4;
thread maps\hamburg_end_streets::handle_f15_rumble();
endvehiclearr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 351 );
wait 8;
wait 6;
fade_out_time = 3;
black_overlay = create_client_overlay( "black", 0, level.player );
black_overlay.sort = -1;
black_overlay.foreground = false;
black_overlay FadeOverTime( fade_out_time );
black_overlay.alpha = 1;
wait( fade_out_time );
nextmission();
}
}
_slomo_breach_charger()
{
self endon( "death" );
self maps\_slowmo_breach::breach_enemy_cancel_ragdoll();
self waittillmatch( "single anim", "start_ragdoll" );
wait( .1 );
self thread knife_guy_stabs_player();
}
knife_guy_stabs_player()
{
player = get_closest_player( self.origin );
dist = Distance( player.origin, self.origin );
if ( dist <= 75 )
{
player PlayRumbleOnEntity( "grenade_rumble" );
player thread play_sound_on_entity( "melee_knife_hit_body" );
player EnableHealthShield( false );
player EnableDeathShield( false );
waittillframeend;
player DoDamage( player.health + 50000, self GetTagOrigin( "tag_weapon_right" ), self );
player.breach_missionfailed = true;
}
}
sandman_into_breach_room()
{
level waittill( "sp_slowmo_breachanim_done" );
level.red1 anim_stopanimscripted();
level.red1 ally_breach_prep();
level.red1_pre_breach_accuracy = level.red1.baseaccuracy;
level.red1.baseaccuracy = level.red1.baseaccuracy / 4;
level.red1.ignoreme = true;
level.red1 teleport_ai( GetNode( "breach_room_sandman_spot" , "targetname" ) );
level.red1 SetGoalNode(GetNode( "breach_room_sandman_spot" , "targetname" ) );
level waittill( "slomo_breach_over" );
level.red1 set_force_color("r");
}
rogers_into_breach_room()
{
level waittill( "sp_slowmo_breachanim_done" );
level.blue1 anim_stopanimscripted();
level.blue1 ally_breach_prep();
level.blue1_pre_breach_accuracy = level.blue1.baseaccuracy;
level.blue1.baseaccuracy = level.blue1.baseaccuracy / 4;
level.blue1.ignoreme = true;
level.blue1 teleport_ai( GetNode( "breach_room_rogers_spot" , "targetname" ) );
level.blue1 SetGoalNode(GetNode( "breach_room_rogers_spot" , "targetname" ) );
level waittill( "slomo_breach_over" );
level.blue1 set_force_color("b");
}
ally_breach_prep()
{
self.ignoreexplosionevents = true;
self.ignoresuppression = true;
self.disableBulletWhizbyReaction = true;
self.ignorerandombulletdamage = true;
self thread disable_pain();
self thread disable_surprise();
self AllowedStances( "stand" );
}
nest_enemy_battlechatter()
{
level.player endon( "death" );
soundorg = getent("breach_chatter_org","targetname");
while ( !flag( "stop_breach_chatter" ))
{
soundorg PlaySound("RU_1_order_move_combat");
wait( RandomFloatRange( 3.0 , 5.5 ));
}
}
rescue_hvt_dialogue()
{
wait 2;
level.sandman thread dialogue_queue( "hamburg_snd_lookatme" );
wait 1;
level.sandman dialogue_queue( "hamburg_snd_itshim" );
wait 2;
level.sandman dialogue_queue("hamburg_snd_vicepres");
wait 1;
level.player radio_dialogue( "tank_hqr_onscene" );
wait 1;
level.sandman dialogue_queue("hamburg_snd_lzneptune");
wait 1.5;
level.player radio_dialogue("hamburg_rno_firstround");
}
handle_blue1_breach_anim()
{
level.blue1 rogers_door_open_hvt();
level.blue1 disable_ai_color();
level.blue1 set_force_color( "b" );
level.blue1 enable_ai_color();
}
handle_red1_breach_anim()
{
AnimNode = getstruct("nodehvt5","targetname");
guys = [];
guys[0] = level.realG;
guys[1] = level.red1;
guys[0].animname = "generic";
guys[1].animname = "sandman";
AnimNode anim_reach_and_approach_solo( level.red1, "secure_hvi" );
aud_send_msg("breach_free_hostage");
thread make_sure_door_open();
AnimNode anim_single( guys ,"secure_hvi");
}
make_sure_door_open()
{
wait 8.5;
if( flag("streets_kicked_door") )
{
doorr = GetEnt( "hvt_door_kick_door", "targetname" );
doorr ConnectPaths();
doorr RotateYaw( -120, 0.15 );
doorr thread play_sound_in_space( "wood_door_kick", doorr.origin );
flag_clear( "streets_kicked_door" );
}
}
setup_dead_hvts()
{
hvt5 = spawn_targetname("hvt5");
hvt5.animname = "generic";
hvt5 setcontents( 0 );
hvt5.noragdoll = true;
hvt5.nocorpsedelete = true;
hvt5.ignoreme = true;
hvt5.dontDoNotetracks = true;
hvt5.script_looping = 0;
hvt5 stopanimscripted();
hvt5.allowdeath = false;
hvt5.health = 1;
hvt5.no_pain_sound = true;
hvt5.diequietly = true;
hvt5.delete_on_death = false;
hvt5.ignoreme = true;
hvt5.ignoreall = true;
hvt5.dontEverShoot = true;
hvt5 gun_remove();
hvtanimnode5 = getstruct("nodehvt5","targetname");
hvtanimnode5 thread anim_first_frame_solo(hvt5,"dead_hvt5");
}
endstreets_apache()
{
streets_apache = spawn_vehicle_from_targetname_and_drive("endstreets_apache");
streets_apache.allowedToFire = false;
streets_apache.damageIsFromPlayer = true;
wait .5;
foreach(mg in streets_apache.mgturret)
{
mg SetMode( "sentry_offline" );
mg ClearTargetEntity();
mg StopFiring();
}
streets_apache thread apache_fire_missile_handler("endstreet_apache_killspot", 3, "flag_streets_apache_killspot", 0);
}
nest_javelin_apache()
{
flag_wait("advance1_outside_battle2");
level.nest_mi17_destroy = spawn_vehicle_from_targetname_and_drive("endstreets_heli_dropoff");
level.nest_mi17_destroy.enableRocketDeath = true;
wait 8;
nest_apache_destroy = spawn_vehicle_from_targetname_and_drive("nest_apache_kill");
rpgspots = getstructarray("end_apache_rpgs","targetname");
wait .5;
foreach(mg in nest_apache_destroy.mgturret)
{
mg SetMode( "sentry_offline" );
mg ClearTargetEntity();
mg StopFiring();
}
nest_apache_destroy.damageIsFromPlayer = true;
flag_wait("flag_nest_apache_killspot");
for( i = 0; i < 7; i++ )
{
offset_salvo = 0.15;
nest_apache_destroy thread maps\_helicopter_globals::fire_missile( "apache_zippy", 1, level.nest_mi17_destroy);
wait ( offset_salvo );
}
nest_apache_destroy thread apache_fire_missile_handler("nest_apache_killspot", 3, "flag_nest_apache_killspot", 0);
thread shoot_rpgs_at_heli(nest_apache_destroy, rpgspots);
if(IsDefined(level.nest_mi17_destroy) && IsAlive(level.nest_mi17_destroy))
{
level.nest_mi17_destroy Kill();
}
}
apache_fire_missile_handler( shoot_at_struct, targetcount, flag_to_wait, delay )
{
flag_wait(flag_to_wait);
zippycount = 4;
nestzippy = [];
if(IsDefined(delay))
{
wait(delay);
}
for(i = 0; i < targetcount; i++)
{
nestzippy[i] = getEnt( shoot_at_struct + i, "targetname");
}
for( i = 0; i < nestzippy.size; i++ )
{
for( j = 0; j < zippycount; j++ )
{
offset_salvo = 0.2;
self thread maps\_helicopter_globals::fire_missile( "apache_zippy", 1, nestzippy[i]);
wait ( offset_salvo );
}
wait .75;
}
}
shoot_rpgs_at_heli( target, spots )
{
for( i = 0; i < spots.size; i++ )
{
ambush_rpg = magicBullet( "rpg", spots[i].origin, target.origin, level.player );
wait 2;
}
}
swinging_lamp_thread()
{
level.swinging_lamps = GetEntArray( "hvt_swinging_lamps" , "targetname" );
foreach ( lamp in level.swinging_lamps )
{
if (IsDefined(lamp.target))
{
lamp.animname = "construction_lamp";
lamp SetAnimTree();
lamp thread anim_loop_solo( lamp , "wind_medium" , "end_lamp_swing" );
light = getEnt( lamp.target , "targetname" );
linkent = spawn_tag_origin();
linkent LinkTo( lamp, "J_Hanging_Light_03", ( 0, 0, 0 ), ( 0, 0, 0 ) );
light thread manual_linkto( linkent );
wait RandomFloatRange( 0.1 , 0.25 );
}
}
}








