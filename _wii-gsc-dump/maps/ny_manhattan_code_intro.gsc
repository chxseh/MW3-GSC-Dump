#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_vehicle;
#include maps\_helicopter_globals;
#include maps\_shg_fx;
#include maps\_shg_common;
#include maps\ss_util;
#include maps\ny_manhattan_code_downtown;
ny_manhattan_intro()
{
wait(.5);
setsaveddvar("sm_spotlimit",2);
thread vision_set_fog_changes("ny_manhattan_intro", 1);
wait(20);
thread vision_set_fog_changes("ny_manhattan", 2.5);
wait(15);
setsaveddvar("sm_spotlimit",1);
}
ny_manhattan_intro_blur()
{
setBlur (10, 0);
wait(5);
setBlur (0, 3);
}
ny_manhattan_intro_dof()
{
start = level.dofDefault;
ny_manhattan_dof_intro = [];
ny_manhattan_dof_intro[ "nearStart" ] = 4;
ny_manhattan_dof_intro[ "nearEnd" ] = 21;
ny_manhattan_dof_intro[ "nearBlur" ] = 4.5;
ny_manhattan_dof_intro[ "farStart" ] = 138;
ny_manhattan_dof_intro[ "farEnd" ] = 468;
ny_manhattan_dof_intro[ "farBlur" ] = 1.35;
blend_dof( start, ny_manhattan_dof_intro, .2 );
wait( 20 );
blend_dof ( ny_manhattan_dof_intro, start, 1 );
}
give_player_weapon( isdemo )
{
if( is_split_level_part( "b" ) )
{
return;
}
level.player takeallweapons();
level.player giveWeapon( "m4_hybrid_grunt_optim" );
level.player setweaponammostock ( "m4_hybrid_grunt_optim", 1500 );
level.player SwitchToWeaponImmediate( "alt_m4_hybrid_grunt_optim" );
level.player giveWeapon( "fraggrenade" );
level.player setOffhandSecondaryClass( "flash" );
level.player giveWeapon( "ninebang_grenade" );
level.player giveWeapon( "xm25" );
}
squad_magic_bullet_shield(squad)
{
foreach (guy in squad)
{
if(isAlive( guy ))
{
guy magic_bullet_shield();
}
else
{
continue;
}
}
}
squad_ignoreme_on(squad)
{
foreach(guy in squad)
{
guy.ignoreme = true;
}
}
squad_ignoreme_off(squad)
{
foreach(guy in squad)
{
guy.ignoreme = false;
}
}
define_squad_leader()
{
foreach (guy in level.squad1)
{
if ( isDefined(guy.script_noteworthy) && guy.script_noteworthy == "leader")
{
level.squad_leader = guy;
level.squad_leader.animname = "lonestar";
}
else
{
continue;
}
}
}
humvees_interupt_heat_battle()
{
thread humvee_1_interupts_heat_battle();
wait(1);
thread humvee_2_interupts_heat_battle();
wait 3;
level.reno dialogue_queue ( "reno_line5" );
wait randomfloatrange( 1, 3 );
thread incoming_exploder( 204 );
wait 0.2;
thread incoming_exploder( 203 );
wait 0.5;
thread incoming_exploder( 202 );
wait randomfloatrange( 2, 4 );
thread incoming_exploder( 203 );
wait randomfloatrange( 1, 3 );
thread incoming_exploder( 204 );
}
heat_combat_humvees()
{
flag_wait("heat_combat_humvees");
thread humvees_interupt_heat_battle();
}
humvee_1_interupts_heat_battle()
{
humvee_1 = spawn_vehicle_from_targetname_and_drive( "heat_humvee_1" );
humvee_1 maps\_vehicle::lights_on("running");
aud_send_msg("humvee_1_heat_battle", humvee_1);
flag_wait( "heat_humvee_1_path_end" );
enemies_1 = humvee_1 vehicle_unload();
wait 3.05;
thread rubble_enemy_entrance_anim (level.gaz_entrance_guys1);
}
humvee_2_interupts_heat_battle()
{
humvee_2 = spawn_vehicle_from_targetname_and_drive( "heat_humvee_2" );
humvee_2 maps\_vehicle::lights_on("running");
aud_send_msg("humvee_2_heat_battle", humvee_2);
flag_wait( "heat_humvee_2_path_end" );
enemies_2 = humvee_2 vehicle_unload();
wait 3.23;
thread rubble_enemy_entrance_anim (level.gaz_entrance_guys2);
activate_trigger_with_noteworthy ( "broad_gaz_assault_spawn" );
broad_gaz_rpg = [];
broad_gaz_rpg_spawners = getentarray ( "broad_gaz_rpg", "targetname" );
foreach ( spawner in broad_gaz_rpg_spawners )
{
if ( isdefined ( spawner ) )
{
guy = spawner spawn_ai (true);
if (isdefined(guy))
{
guy.targetname = spawner.targetname;
guy.grenadeammo = 0;
}
}
}
}
broad_gaz_assault_think()
{
self.animname = self.script_noteworthy;
self.grenadeammo = 0;
thread gaz_entrance_guys_go ( self );
}
squad_stop_magic_bullet_shield(squad)
{
foreach (guy in squad)
{
if(isAlive( guy ))
{
guy stop_magic_bullet_shield();
}
else
{
continue;
}
}
}
path_squad_to_destroyed_building()
{
next_color_nodes = GetEnt( "", "targetname" );
next_color_nodes notify( "trigger", level.player );
}
broad_start()
{
thread first_combat_delay();
thread broad_hind_start();
thread broad_squad_moveup();
thread broad_hind_strafe_setup();
thread broad_hind_strafe();
thread waste_bankers();
thread intro_gaz();
thread broad_breach();
thread exchange_hind();
thread broad_hide_vehicles();
thread exchange_combat();
thread broad_player_kill();
thread setup_tvs();
thread monitor_player_exits_exchange_street();
thread monitor_hint_ads();
thread monitor_hint_xm25();
level.gaz_entrance_guys1 = [];
level.gaz_entrance_guys2 = [];
level.player DisableWeapons();
level.player disableoffhandweapons();
player_start_origin = spawn_tag_origin();
player_start_origin.origin = level.player.origin;
player_start_origin.angles = level.player.angles;
thread battlechatter_off ( "allies" );
thread battlechatter_off ( "axis" );
array_spawn_function_noteworthy( "fc_gaz_guys", ::no_grenades );
array_spawn_function_noteworthy( "russians_destroyed_building_fl2", ::no_grenades );
array_spawn_function_targetname( "russian_heat_enemies", ::no_grenades );
array_spawn_function_targetname( "gaz_entrance_guys1", ::gaz_entrance_guy1_think );
array_spawn_function_targetname( "gaz_entrance_guys2", ::gaz_entrance_guy2_think );
array_spawn_function_targetname( "broad_gaz_assault", ::broad_gaz_assault_think );
for ( i = 2 ; i < 6 ; i++ )
run_thread_on_noteworthy ( "exchange_path_0" + i, ::vehicle_path_disconnect );
createthreatbiasgroup ( "first_combat" );
createthreatbiasgroup ( "player_squad_broad" );
createthreatbiasgroup ( "first_combat_done" );
setignoremegroup ( "player_squad_broad", "first_combat" );
setignoremegroup ( "first_combat", "player_squad_broad" );
level.player setthreatbiasgroup ( "player_squad_broad" );
foreach ( squad1_guy in level.squad1 )
{
squad1_guy setthreatbiasgroup ( "player_squad_broad" );
if (!flag ( "no_briefing_start" ) )
{
squad1_guy magic_bullet_shield();
}
}
fc_spawners = getentarray ( "first_combat", "script_noteworthy" );
first_combat_backup = getentarray ( "first_combat_backup", "script_noteworthy" );
army01_spawners = getentarray ( "us_army_01", "targetname" );
level.army01 = [];
foreach ( spawner in army01_spawners )
{
army01_guy = spawner spawn_ai(true);
army01_guy.grenadeammo = 0;
army01_guy magic_bullet_shield();
army01_guy.ignoresuppression = true;
level.army01[level.army01.size] = army01_guy;
}
thread exchange_vignettes();
flag_wait ( "briefing_done" );
level.player EnableWeapons();
thread first_combat();
flag_wait ( "player_shot_or_advanced" );
battlechatter_on ( "allies" );
battlechatter_on ( "axis" );
thread monitor_player_first_shot();
level.player enableoffhandweapons();
}
compass_nodraw()
{
if ( !flag ( "obj_jammer_complete" ) )
self.drawoncompass = false;
}
monitor_player_exits_exchange_street()
{
flag_wait("exiting_exchange");
srcEnt = getent( "exchange_street", "targetname" );
dstEnt = getent( "broad_street", "targetname" );
remapStage(srcEnt.origin,dstEnt.origin);
}
monitor_player_first_shot()
{
level.player waittill_any ( "weapon_fired", "grenade_fire", "flashbang" );
flag_set ( "player_shot" );
}
exchange_vignettes()
{
level.wounded_guy = getent ( "wounded_guy", "targetname" );
level.wounded_medic = getent ( "wounded_medic", "targetname" );
level.radio_guy = getent ( "radio_guy", "targetname" );
level.wounded_guy disable_awareness();
level.wounded_medic disable_awareness();
level.wounded_guy magic_bullet_shield();
level.wounded_medic magic_bullet_shield();
level.wounded_guy.animname = "wounded_guy";
level.wounded_medic.animname = "wounded_carrier";
level.radio_guy.animname = "generic";
level.org_radio_guy = getent ( "org_radio_guy", "targetname" );
level.org_wounded = getent ( "org_wounded_new", "targetname" );
level.org_radio_guy thread anim_loop_solo ( level.radio_guy, "radio_idle", "radio_stop" );
level.org_wounded thread anim_first_frame_solo ( level.wounded_medic, "run_to" );
level.org_wounded thread anim_first_frame_solo ( level.wounded_guy, "wounded_idle" );
level.wounded_guy gun_remove();
level.wounded_guy.name = undefined;
level.wounded_medic.name = undefined;
wounded_guys = [];
wounded_guys [0] = level.wounded_medic;
wounded_guys [1] = level.wounded_guy;
flag_wait ( "exchange_humvee_go" );
wait 2;
level.org_wounded anim_single_solo ( level.wounded_medic, "run_to" );
level.org_wounded anim_single ( wounded_guys, "drag" );
level.org_wounded thread anim_loop ( wounded_guys, "help_loop", "wounded_stop" );
flag_wait ( "intro_gaz" );
if ( isdefined ( level.wounded_guy ) && isdefined ( level.wounded_guy.magic_bullet_shield ) )
level.wounded_guy stop_magic_bullet_shield();
if ( isdefined ( level.wounded_medic ) && isdefined ( level.wounded_medic.magic_bullet_shield ) )
level.wounded_medic stop_magic_bullet_shield();
level.org_radio_guy notify ( "radio_stop" );
level.wounded_guy delete();
level.wounded_medic delete();
}
fc_think()
{
self endon ( "death" );
volume_02 = getent ( "volume_exchange_fallback", "targetname" );
if ( !flag ( "out_of_sewer" ) )
self magic_bullet_shield ();
if ( flag ( "first_combat_fallback" ) )
self SetGoalVolumeAuto ( volume_02 );
}
exchange_combat()
{
array_spawn_function_noteworthy ( "first_combat_backup", ::fc_think );
activate_trigger_with_noteworthy ( "fc_backup" );
flag_wait ( "briefing_done" );
backup_guys = getentarray ( "first_combat_backup", "script_noteworthy" );
foreach ( guy in backup_guys )
{
if ( isdefined ( guy ) && isalive ( guy ) )
if (isdefined(guy.magic_bullet_shield) && guy.magic_bullet_shield)
guy stop_magic_bullet_shield();
}
flag_wait ( "first_combat_fallback" );
backup_guys = getentarray ( "first_combat_backup", "script_noteworthy" );
thread array_setgoalvolume ( backup_guys, "volume_exchange_fallback" );
flag_wait ( "exchange_guys_retreat" );
fc_gaz_guys = getentarray ( "fc_gaz_guys", "script_noteworthy" );
thread array_setgoalvolume ( fc_gaz_guys, "broad_enemies_volume_02" );
thread array_setgoalvolume ( level.first_combat_backup_02, "broad_enemies_volume_02" );
}
setup_remote_missile_target_guy()
{
if( isdefined( self.script_noteworthy ) )
{
if( self.script_noteworthy == "paradrop_guy_left" )
return;
if( self.script_noteworthy == "paradrop_guy_right" )
return;
}
if( isdefined( self.ridingvehicle ) )
{
self endon( "death" );
self waittill( "jumpedout" );
}
if( !isdefined( self.unique_id ) )
return;
if( is_split_level_part( "a" ) )
{
return;
}
self maps\_remotemissile_utility::setup_remote_missile_target();
}
broad_hide_vehicles()
{
vehicles = getentarray ( "broad_vehicles_hide", "script_noteworthy" );
foreach ( vehicle in vehicles )
{
vehicle hide();
}
flag_wait ( "tiff_sandman_moveout" );
foreach ( vehicle in vehicles )
{
vehicle show();
}
}
broad_squad_moveup()
{
flag_wait ( "broad_squad_moveup" );
thread hint_hybrid();
level.sandman dialogue_queue_single ( "lonestar_line23" );
level.truck dialogue_queue_single ( "manhattan_trk_moving" );
wait 15;
flag_set ( "broad_hind_start" );
}
hint_hybrid()
{
wait 5;
if ( !flag ( "player_used_hybrid" ) )
thread display_hint_timeout( "hint_hybrid", 10 );
}
safe_disable_awareness()
{
self notify("enable_awareness");
wait 0.05;
self thread disable_awareness();
}
broad_hind_strafe_setup()
{
flag_wait ( "broad_hind_strafe_setup" );
flag_set ( "player_reached_15_broad" );
level.broad_hind_fly notify ( "stop_ai" );
level.broad_hind_fly notify ( "stop_missiles" );
thread clear_hints();
thread broad_hind_backtrack();
array_thread( level.squad1, ::safe_disable_awareness );
SetSavedDvar ( "ai_friendlysuppression", 1 );
level.truck set_force_color ( "o" );
level.truck SetGoalNode ( getnode ( "truck_goal_15_broad", "targetname" ) );
aud_send_msg("15_broad_lobby_first_vo_line");
thread dialog_broad_lobby();
trigger_wait_targetname ( "dialog_sandman_up_stairs" );
level.sandman dialogue_queue_single ( "lonestar_line102" );
trigger_wait_targetname ( "dialog_sandman_stairwell" );
level.sandman dialogue_queue ( "lonestar_line146" );
}
dialog_broad_lobby()
{
conversation_start();
level.truck dialogue_queue ( "manhattan_trk_gameplan" );
level.sandman dialogue_queue ( "manhattan_snd_sameasbefore" );
level.reno dialogue_queue ( "manhattan_rno_likeit" );
conversation_stop();
}
broad_hind_strafe()
{
hind_hull = getent ( "ny_hind_crash_hull", "targetname" );
hind_hull.animname = "15_broad_hind";
hind_hull assign_animtree();
org_deadguy = getent ( "org_deadguy", "targetname" );
deadguy = getent ( "crashed_hind_deadguy", "targetname" );
deadguy.animname = "hind_deadguy";
deadguy assign_animtree();
deadguy attach ( "head_russian_military_b", "" );
org_deadguy thread anim_first_frame_solo ( deadguy, "dead_idle" );
hind_hull thread anim_loop_solo ( hind_hull, "blades_spin", "stop_loop" );
wall = getent ( "ny_hind_crash_wall", "targetname" );
couch = getent ( "broad_couch_hide", "targetname" );
painting = getent ( "broad_painting_hide", "targetname" );
rpg_org01 = getent ( "org_hind_rpg01", "targetname" );
rpg_org02 = getent ( "org_hind_rpg02", "targetname" );
rpg_org03 = getent ( "org_hind_rpg03", "targetname" );
connector = getent ( "broad_hind_crash_connection", "targetname" );
wall connectpaths();
wall hide();
wall notsolid();
couch hide();
painting hide();
painting notsolid();
connector connectpaths();
connector notsolid();
start_node = getstruct ( "broad_hind_flyby", "targetname" );
flag_wait ( "broad_hind_start_shooting" );
if ( isdefined ( level.broad_hind_fly ) )
{
aud_send_msg("broad_hind_flyby");
level.broad_hind_fly thread vehicle_paths_helicopter ( start_node );
level.broad_hind_fly vehicle_setspeed ( 45, 45, 45 );
level.broad_hind_fly waittill ( "reached_dynamic_path_end" );
level.broad_hind_fly delete ();
}
}
broad_hind_backtrack()
{
level endon ( "broad_hind_start_shooting" );
while ( true )
{
if ( flag ( "broad_hind_backtrack" ) )
{
if ( isdefined ( level.broad_hind_fly ) )
level.broad_hind_fly thread broad_hind_think();
flag_waitopen ( "broad_hind_backtrack" );
if (isdefined ( level.broad_hind_fly ) )
{
level.broad_hind_fly notify ( "stop_ai" );
level.broad_hind_fly notify ( "stop_missiles" );
}
}
wait 0.1;
}
}
broad_hind_start()
{
broad_hind = getent ( "broad_hind", "targetname" );
broad_hind.godmode = true;
flag_wait ( "broad_hind_start" );
thread humvees_interupt_heat_battle();
wait 15;
flag_set( "obj_follow_through_buildings_given" );
flag_set ( "obj_broad_complete" );
activate_trigger_with_targetname ( "path_squad_into_15broad" );
SetSavedDvar ( "ai_friendlysuppression", 0 );
thread broad_hind_timer ();
SetSavedDvar ( "ai_friendlysuppression", 0 );
thread reenable_ai_friendlysuppression();
level.broad_hind_fly = spawn_vehicle_from_targetname_and_drive ( "broad_hind" );
assert(IsDefined(level.broad_hind_fly) && IsDefined(level.broad_stryker));
attractor = missile_createattractororigin ( level.broad_stryker.origin + ( 0, 0, 64), 10000, 10000, level.broad_hind_fly );
level.broad_stryker.health = 200;
assert(IsDefined(attractor));
aud_send_msg("broad_hind_start", level.broad_hind_fly);
level.org_ragdoll_explode_force = getdvarint("ragdoll_explode_force");
setsaveddvar("ragdoll_explode_force", "1000" );
level.org_physveh_explodeforce = getdvarint("physveh_explodeforce");
setsaveddvar("physveh_explodeforce", "200");
level.broad_hind_fly thread broad_hind_think(level.broad_stryker);
level.broad_hind_fly thread hind_dmg_hint();
level.broad_hind_fly notify ( "stop_ai" );
level.broad_hind_fly notify ( "stop_street_strafe" );
level.broad_hind_fly delaythread ( 8, ::broad_hind_turret_ai );
thread catch_broad_hind_first_shot();
wait 3;
array_thread ( level.squad1, ::broad_allies_runaway );
level.truck dialogue_queue ( "truck_line26" );
level.sandman delaythread ( 2.5, ::dialogue_queue, "lonestar_line25" );
lines = [];
lines [ lines.size ] = "lonestar_line52";
lines [ lines.size ] = "lonestar_line53";
lines [ lines.size ] = "manhattan_rno_getinhere";
thread dialogue_reminder ( level.sandman, "broad_hind_strafe_setup", lines );
thread broad_stryker_delete_attractor(attractor);
thread broad_hind_deathquote();
wait 7;
if ( !flag ( "broad_hind_strafe_setup" ) )
thread obj_hint();
}
broad_stryker_delete_attractor(attractor)
{
level.broad_stryker waittill ( "death" );
if ( isdefined ( attractor ) )
missile_deleteattractor( attractor );
}
obj_hint()
{
level endon ( "broad_hind_strafe_setup" );
while ( !flag ( "broad_hind_strafe_setup" ) )
{
display_hint ( "hint_obj" );
flag_waitopen_or_timeout ( "hind_dmg_hint", 6 );
wait 0.05;
}
}
hind_dmg_hint()
{
self endon ( "death" );
while ( true )
{
self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, dFlags, weaponName );
if ( isdefined ( weaponname ) && !issubstr ( weaponname, "remote_missile" ) && attacker == level.player )
if ( isdefined ( level.broad_hind_fly ) && self == level.broad_hind_fly && ( !isdefined ( level.high_priority_hint ) ) )
{
flag_set ( "hind_dmg_hint" );
display_hint_timeout ( "hint_hind_dmg", 3 );
delaythread ( 3, ::flag_clear, "hind_dmg_hint" );
}
else if ( !isdefined(level.high_priority_hint) || !level.high_priority_hint )
{
flag_set ( "hind_dmg_hint" );
display_hint ( "hint_hind_dmg_predator" );
delaythread ( 3.5, ::flag_clear, "hind_dmg_hint" );
}
}
}
broad_hind_deathquote()
{
level endon ( "broad_hind_strafe_setup" );
level.player waittill ( "death" );
SetDvar( "ui_deadquote", "@NY_MANHATTAN_DEATH_BROAD_HIND" );
}
reenable_ai_friendlysuppression()
{
flag_wait ( "squad_reached_15_broad" );
wait 10;
SetSavedDvar ( "ai_friendlysuppression", 1 );
}
broad_allies_runaway()
{
self thread disable_awareness();
self waittill_either ( "goal", "enable_awareness" );
self enable_awareness();
}
waste_bankers()
{
flag_wait ( "start_banker_massacre" );
wait 3;
delayThread ( 2, ::activate_trigger_with_targetname, "trigger_ally_path_start_heat_combat" );
level.wounded_guy notify ( "wounded_stop" );
level.wounded_medic notify ( "wounded_stop" );
flag_set ( "obj_broad_given" );
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
missile_hit( pos, angles )
{
dummy = spawn_tag_origin();
dummy.origin = pos;
dummy.angles = angles;
PlayFXOnTag( getfx( "ship_explosion" ), dummy, "tag_origin" );
wait 2;
dummy delete();
}
wait_for_intro_missile_to_hit(flagname, aud_msg)
{
flag_wait( flagname );
thread missile_hit( self.origin, self.angles );
self thread missile_cleanup();
}
exchange_hind()
{
level.intro_stryker = spawn_vehicle_from_targetname_and_drive ( "humvee_front" );
aud_send_msg("intro_stryker", level.intro_stryker);
level.broad_stryker = spawn_vehicle_from_targetname ( "broad_stryker" );
level.broad_stryker.godmode = true;
aud_send_msg("broad_stryker", level.broad_stryker);
level.broad_stryker02 = spawn_vehicle_from_targetname ( "broad_stryker02" );
aud_send_msg("broad_stryker02", level.broad_stryker02);
level.intro_stryker SetVehicleLookAtText( "", &"" );
level.broad_stryker02 SetVehicleLookAtText( "", &"" );
level.broad_stryker SetVehicleLookAtText( "", &"" );
level.intro_stryker.godmode = true;
level.intro_stryker.dont_crush_player = true;
thread intro_stryker_monitor_player_distance();
wait 0.05;
flag_wait ( "out_of_sewer" );
level.intro_stryker thread stryker_think();
}
stryker_think()
{
self endon ( "death" );
self endon ( "stop_shooting" );
if (!isdefined(level.strykers))
level.strykers[0] = self;
else
level.strykers[level.strykers.size] = self;
while ( 1 )
{
target = self stryker_get_target();
if ( isdefined ( target ) )
self stryker_shoot( target );
wait randomintrange ( 5, 10 );
}
}
intro_stryker_monitor_player_distance()
{
level endon ( "start_banker_massacre" );
triggers = getentarray ( "intro_stryker_prox_trigger", "targetname" );
foreach ( trigger in triggers )
{
trigger enablelinkto();
trigger linkto ( level.intro_stryker );
}
while ( true )
{
flag_wait ( "player_close_to_stryker" );
speed = level.intro_stryker vehicle_getspeed();
level.intro_stryker vehicle_setspeed ( 0, 15, 5 );
flag_waitopen ( "player_close_to_stryker" );
level.intro_stryker vehicle_setspeed ( speed, 15, 5 );
}
}
test_if_ally_strkyer_in_way( target )
{
start = self gettagorigin ( "tag_flash" );
tgtpos = target geteye();
dir = tgtpos - start;
normdir = VectorNormalize(dir);
dist = Length(dir);
radius = 90;
radiussqr = radius*radius;
foreach (ally in level.strykers)
{
if (ally == self)
continue;
tostryker = (ally gettagorigin("tag_player")) - start;
allydist = Length(tostryker);
if ((allydist-dist) > radius)
continue;
tostryker = VectorNormalize(tostryker);
dp = VectorDot(tostryker, normdir);
if (dp < 0)
continue;
hyp = sqrt( allydist*allydist + radiussqr );
sideadj = allydist;
testdp = sideadj/hyp;
if (testdp < dp)
{
return true;
}
}
return false;
}
stryker_get_target()
{
possibles = getaiarray ( "axis" );
possibles = get_array_of_closest( self.origin, possibles, undefined, undefined, 4000, 1024 );
foreach ( possible in possibles )
{
if ( isAI ( possible ) )
{
if ( !isdefined ( possible.ignoreme) || possible.ignoreme == false )
{
if ( sighttracepassed ( self gettagorigin ( "tag_barrel" ), possible geteye(), false, self ) )
{
if ( !self test_if_ally_strkyer_in_way( possible ) )
{
return possible;
}
}
}
}
}
return undefined;
}
stryker_shoot( target )
{
self endon ( "death" );
if ( isdefined ( target ) )
{
self setturrettargetent ( target, ( 0, 0, 0 ) );
while (isdefined(target))
{
start = self gettagorigin ( "tag_barrel" );
end = target geteye();
angles = self gettagangles( "tag_flash" );
forward = anglestoforward( angles );
desired = end - start;
desired = VectorNormalize(desired);
dp = VectorDot(forward, desired);
if (dp > 0.999)
break;
wait 0.05;
}
if (!isdefined(target))
{
self notify( "stop_debug" );
return;
}
}
target_is_ai = isai(target);
shots = randomintrange ( 5, 15 );
for( i = 0 ; i < shots ; i++ )
{
if (target_is_ai && !isdefined(target))
break;
if (test_if_ally_strkyer_in_way( target ))
break;
self fireWeapon( "tag_flash", target, ( 0, 0, 0 ), 0.0 );
aud_send_msg("Stryker_fire_weapon", target);
wait 0.1;
}
self notify( "stop_debug" );
}
vehicle_path_disconnect()
{
previous_blocker = undefined;
blocker = undefined;
if ( isdefined ( self.target ) )
{
blocker = getent ( self.target, "targetname" );
}
if ( isdefined ( self.script_parameters ) )
{
previous_blocker = getent ( self.script_parameters, "targetname" );
}
self waittill ( "trigger" );
if ( isdefined ( previous_blocker ) )
{
previous_blocker connectpaths();
previous_blocker notsolid();
}
}
intro_gazcrash( guys, gaz )
{
gaz.maxlightstopsperframe = 2;
anm = getanim_from_animname("gazcrash", gaz.animname);
animtime = GetAnimLength( anm );
unload_wait = animtime - 2.0;
self thread anim_single( guys, "gazcrash" );
wait unload_wait;
gaz thread vehicle_unload ( "all_but_gunner" );
wait 3;
foreach (guy in gaz.riders)
{
if ( guy.vehicle_position != 3 )
guy.noragdoll = false;
}
gaz.godmode = false;
}
gazcrash_kill()
{
volume = getent ( "gazcrash_kill", "targetname" );
wait 0.5;
enemies = getaiarray ( "axis" );
foreach ( ai in enemies )
{
if ( isdefined ( ai ) && isdefined ( ai ) && ( ai istouching ( volume ) ) )
ai fake_death_bullet();
}
}
handle_rider_death( guy, gaz )
{
guy.noragdoll = true;
guy.no_vehicle_ragdoll = true;
}
intro_gaz()
{
blockers = getentarray ( "gaz_path_blocker", "targetname" );
flag_wait ( "briefing_done" );
wait 1;
intro_gaz = spawn_vehicle_from_targetname( "intro_gaz" );
intro_gaz.health = 10000;
intro_gaz build_bulletshield ( true );
intro_gaz_turret_guy = undefined;
aud_send_msg("intro_gaz", intro_gaz);
foreach ( guy in intro_gaz.riders )
{
intro_gaz thread handle_rider_death( guy, intro_gaz );
if ( guy.vehicle_position == 3 )
{
intro_gaz_turret_guy = guy;
guy.dontunloadonend = true;
}
}
intro_gaz.godmode = true;
intro_gaz.animname = "intro_gaz";
intro_gaz setAnimTree();
intro_gaz maps\_vehicle::lights_on("running");
intro_luxurysedan = getent( "intro_luxurysedan", "targetname");
intro_luxurysedan.animname = "intro_luxurysedan";
intro_luxurysedan setAnimTree();
intro_subcompact = getent( "intro_subcompact", "targetname");
intro_subcompact.animname = "intro_subcompact";
intro_subcompact setAnimTree();
guys[0] = intro_gaz;
guys[1] = intro_luxurysedan;
guys[2] = intro_subcompact;
scripted_node = getent( "gazcrash_scripted_node", "targetname");
scripted_node thread anim_first_frame( guys, "gazcrash" );
flag_wait ( "intro_gaz" );
fc_guys = getentarray ( "first_combat_backup", "script_noteworthy" );
foreach ( guy in fc_guys )
thread fake_death_over_time ( "bullet", 1, 6 );
thread gazcrash_kill();
intro_gaz ConnectPaths();
scripted_node thread intro_gazcrash(guys, intro_gaz);
level.first_combat_backup_02 = getentarray ( "first_combat_backup_02", "script_noteworthy" );
foreach ( spawner in level.first_combat_backup_02 )
{
backup_guy = spawner spawn_ai(true);
backup_guy.targetname = spawner.targetname;
backup_guy.grenadeammo = 0;
level.first_combat_backup_02[level.first_combat_backup_02.size] = backup_guy;
}
wait 2.0;
level.reno dialogue_queue ( "reno_line3" );
level.truck dialogue_queue ( "truck_line25" );
foreach ( blocker in blockers )
{
blocker connectpaths();
blocker notsolid();
}
level.intro_stryker notify ( "stop_shooting" );
flag_wait_or_timeout ( "exchange_guys_dead", 45 );
if ( !flag ( "start_banker_massacre" ) )
activate_trigger_with_targetname ( "colors2004" );
}
no_grenades()
{
self.grenadeammo = 0;
}
broad_hind_timer()
{
wait 180;
flag_set ( "punish_time" );
}
broad_hind_turret_ai()
{
self endon( "death" );
self endon( "stop_street_strafe" );
self endon ( "stop_ai" );
self thread maps\ny_hind_ai::nym_Hind_Turret_AI();
target = spawn ( "script_origin", level.player.origin );
self.main_turret["target"] = target;
self.main_turret["sweepcount"] = 0;
while (true)
{
self maps\ny_hind_ai::nym_hind_change_turret_state( "aiming" );
forward = (1, 0, 0);
sideways = (0, 1, 0);
if (RandomInt(2) > 0)
sideways = -1 * sideways;
forscale = RandomFloatRange( 120, 480 );
startsidescale = RandomFloatRange(60,240);
endsidescale = -1 * RandomFloatRange(60,240);
timeforscan = (startsidescale - endsidescale) / 60;
startpos = level.player.origin + forscale*forward + startsidescale*sideways;
endpos = level.player.origin + forscale*forward + endsidescale*sideways;
target.origin = startpos;
target moveto( endpos, timeforscan, 0.2, 0.2);
wait timeforscan;
}
}
punish_with_turret()
{
self endon( "death" );
flag_wait("punish_time");
self notify( "stop_stret_strafe" );
self thread maps\ny_hind_ai::nym_hind_turret_punish_player();
}
broad_hind_think( start_target )
{
self endon( "death" );
self endon ( "stop_missiles" );
self thread broad_hind_turret_ai();
self thread punish_with_turret();
attractor = undefined;
attractor_target = undefined;
cosTinE = 0.94;
target = start_target;
while (true)
{
if ( !isdefined(start_target) || !isalive(start_target) )
{
if ( !isdefined(attractor_target) )
{
attractor_target = spawn ( "script_origin", level.player.origin );
attractor = Missile_CreateAttractorEnt ( attractor_target, 10000, 2048, self );
target = level.player;
}
}
wait 0.1;
if ( maps\ny_manhattan_code_hind::can_shoot (target, .707, cosTinE))
{
numRockets = 1;
if (randomfloat(100) > 75)
{
numRockets = 2;
if (randomfloat(100) > 75)
{
numRockets = 4;
}
}
if (!flag ( "punish_time" ) )
{
x = RandomFloatRange ( 256, 512 );
y = RandomFloatRange ( -512, 512);
}
else
{
x = RandomFloatRange ( 0, 128 );
y = RandomFloatRange ( -128, 128 );
}
deltax = self.origin[0] - target.origin[0];
if (deltax < x)
x = 0;
offset = ( x, y, 0 );
if ( isdefined ( attractor_target ) )
{
attractor_target.origin = target.origin + offset;
}
if (maps\ny_manhattan_code_hind::isVehicleAlive(self))
{
self thread fire_missile( "hind_rpg_cheap", numRockets, target );
aud_hind_info = [];
aud_hind_info[0] = self;
aud_hind_info[1] = numRockets;
aud_hind_info[2] = target;
aud_send_msg("broad_hind_missiles", aud_hind_info);
self notify ( "fired_missiles" );
}
if (flag( "punish_time" ))
{
wait randomfloatrange( 1, 3 );
cosTinE = 0.707;
}
else
wait randomfloatrange( 2, 5 );
}
}
}
exchange_hind_think()
{
self endon( "death" );
self thread broad_hind_turret_ai();
flag_wait ( "exchange_hind_fire" );
if (maps\ny_manhattan_code_hind::isVehicleAlive(self))
self thread fire_missile( "hind_rpg_cheap", 4, level.player );
}
intro_hind_flyover()
{
wait 20.5;
hinds = spawn_vehicles_from_targetname_and_drive ( "intro_hind_flyover" );
wait 0.05;
wait 6;
foreach ( hind in hinds )
{
hind delete();
}
}
gaz_entrance_guys_go( guy )
{
goal = getent ( "broad_enemies_volume_02", "targetname" );
node = getent ( "intro_slide_tag", "targetname" );
node anim_reach_solo(guy, "broad_enemy_entrance" );
if (isdefined(guy) && isalive(guy) && !guy doingLongDeath())
{
node anim_single_solo(guy, "broad_enemy_entrance" );
wait 0.1;
if (isdefined(guy) && isalive(guy))
guy setgoalvolumeauto ( goal );
}
}
rubble_enemy_entrance_anim(guys)
{
foreach (guy in guys)
{
if (isdefined(guy) && isalive(guy) && !guy doingLongDeath() )
{
guy.animname = guy.script_noteworthy;
thread gaz_entrance_guys_go(guy);
}
}
}
gaz_entrance_guy1_think()
{
level.gaz_entrance_guys1 [level.gaz_entrance_guys1.size] = self;
self.grenadeammo = 0;
}
gaz_entrance_guy2_think()
{
level.gaz_entrance_guys2 [level.gaz_entrance_guys2.size] = self;
self.grenadeammo = 0;
}
dialog_holdtilmygo()
{
level.sandman dialogue_queue ( "lonestar_line103" );
level.reno thread dialogue_queue ( "reno_line34" );
}
broad_breach()
{
door = getent ( "15_broad_breach_door", "targetname" );
door.animname = "broad_door";
door SetAnimTree();
col = getent ( "broad_breach_col", "targetname" );
flag_wait ( "15_broad_breach" );
enemies_left = getaiarray ( "axis" );
CreateThreatBiasGroup ( "street_guys" );
CreateThreatBiasGroup ( "sandman_15_broad" );
array_thread( GetEntArray( "broad_gaz_rpg", "targetname" ), ::self_delete );
array_thread( GetEntArray( "broad_gaz_assault", "targetname" ), ::self_delete );
array_thread( GetEntArray( "russian_heat_enemies", "targetname" ), ::self_delete );
array_thread( GetEntArray( "script_vehicle_stryker50cal_notrophy", "classname" ), ::self_delete );
array_thread( enemies_left, ::self_delete );
level.sandman SetThreatBiasGroup ( "sandman_15_broad" );
setignoremegroup ( "street_guys", "sandman_15_broad" );
setignoremegroup ( "sandman_15_broad", "street_guys" );
array_thread ( level.squad1, ::enable_awareness );
thread dialog_holdtilmygo();
autosave_by_name( "15_broad" );
door anim_reach_solo ( level.sandman, "mulekick_transition", "tag_origin" );
door anim_single_solo (level.sandman, "mulekick_transition", "tag_origin" );
door thread anim_loop_solo (level.sandman, "mulekick_idle", "stop_loop" );
flag_wait ( "15_broad_breach_go" );
GetEnt( "intro_humvee", "targetname" ) Delete();
GetEnt( "humvee_deadguy", "targetname" ) Delete();
level.truck set_force_color ( "b" );
level.truck enable_ai_color();
if (isdefined(level.org_ragdoll_explode_force))
setsaveddvar("ragdoll_explode_force", "" + level.org_ragdoll_explode_force );
if (isdefined(level.org_physveh_explodeforce))
setsaveddvar("physveh_explodeforce", "" + level.org_physveh_explodeforce );
aud_send_msg("15_broad_breach_door_anim");
door notify( "stop_loop" );
door thread anim_single_solo ( level.sandman, "mulekick_kick", "tag_origin" );
aud_send_msg("mulekick_kick");
thread maps\ny_manhattan_fx::vfx_door_kick();
col connectpaths();
col delaycall ( 1, ::delete );
flag_set ( "mulekick_done" );
door anim_single_solo ( door, "door_kick_door" );
thread battlechatter_off ( "allies" );
SetSavedDvar ( "ai_friendlysuppression", 0 );
noself_delaycall ( 3, ::SetSavedDvar, "ai_friendlysuppression", 1 );
flag_set ( "broad_hind_strafe_setup" );
level.sandman enable_ai_color();
level.sandman dialogue_queue ( "lonestar_line105" );
level.sandman.ignoresuppression = true;
flag_wait ( "15_broad_first_guys_dead" );
wait 1;
activate_trigger_with_targetname ( "sandman_15_broad_moveup" );
flag_wait ( "15_broad_guys_dead" );
activate_trigger_with_targetname ( "colors_c9b" );
}
cleanup_ai ( name, key )
{
guys = getentarray ( name, key );
foreach ( guy in guys )
{
if (isDefined ( guy ) )
{
if (isdefined(guy.magic_bullet_shield) && guy.magic_bullet_shield)
guy stop_magic_bullet_shield();
guy delete();
}
}
}
catch_broad_stryker_death()
{
level.broad_stryker waittill ( "death" );
flag_set ( "broad_humvee_dead" );
}
catch_broad_hind_first_shot()
{
level.broad_hind_fly waittill ( "fired_missiles" );
level.broad_stryker.godmode = false;
}
broad_stryker_monitor()
{
thread catch_broad_stryker_death();
connector = getent ( "broad_stryker_disconnect", "targetname" );
org = getent ( "org_stryker_infantry_explosion", "targetname" );
dest = getent ( "dest_stryker_infantry_explosion", "targetname" );
flag_wait ( "broad_stryker_endpath" );
guys = getentarray ( "army_02_deadguys", "script_noteworthy" );
foreach ( guy in guys )
{
wait randomfloatrange ( 0, 2 );
guy thread kill_guy_with_explosion();
}
flag_wait ( "broad_humvee_explosion" );
thread incoming_exploder( 205 );
flag_wait ( "broad_stryker_endpath" );
connector connectpaths();
connector notsolid();
}
humvee_intro()
{
org = getent ( "sewer_exit_scripted_node", "targetname" );
humvee = Getent( "intro_humvee", "targetname" );
humvee.animname = "intro_humvee";
humvee assign_animtree();
intro_m4 = getent ( "intro_m4", "targetname" );
intro_m4.animname = "intro_m4";
intro_m4 assign_animtree();
intro_knife = getent ( "intro_knife", "targetname" );
intro_knife.animname = "intro_knife";
intro_knife assign_animtree();
m4_model = "viewmodel_m4_hybrid_iw5";
intro_m4 hidepart ( "tag_acog_2", m4_model );
intro_m4 hidepart ( "tag_m203", m4_model );
intro_m4 hidepart ( "tag_shotgun", m4_model );
intro_m4 hidepart ( "tag_silencer", m4_model );
intro_m4 hidepart ( "tag_sight_on", m4_model );
intro_m4 hidepart ( "tag_thermal_scope", m4_model );
intro_m4 hidepart ( "tag_red_dot", m4_model );
intro_m4 hidepart ( "tag_heartbeat", m4_model );
intro_m4 hidepart ( "tag_flash", m4_model );
intro_m4 hidepart ( "tag_brass", m4_model );
intro_m4 hidepart ( "tag_laser", m4_model );
intro_m4 hidepart ( "tag_magnifier", m4_model );
intro_m4 hidepart ( "tag_reticle_acog", m4_model );
intro_m4 hidepart ( "j_slider_m203", m4_model );
intro_m4 hidepart ( "j_grenade_m203", m4_model );
intro_m4 hidepart ( "tag_reticle_thermal_scope", m4_model );
intro_m4 hidepart ( "j_motion_tracker_roty", m4_model );
intro_m4 hidepart ( "j_release", m4_model );
intro_m4 hidepart ( "j_flip", m4_model );
intro_m4 hidepart ( "tag_motion_tracker", m4_model );
intro_m4 hidepart ( "j_pump_shotgun", m4_model );
intro_m4 hidepart ( "j_ammo_shotgun", m4_model );
intro_m4 hidepart ( "j_reload_shotgun", m4_model );
intro_m4 hidepart ( "j_plate_shotgun", m4_model );
intro_hybrid = spawn ( "script_model", ( 0, 0, 0 ) );
intro_hybrid setmodel ( "viewmodel_magnifier" );
intro_hybrid.animname = "intro_m4_scope";
intro_hybrid setanimtree();
intro_m4 anim_first_frame_solo ( intro_hybrid, "ny_intro", "tag_magnifier" );
intro_hybrid linkto ( intro_m4, "tag_magnifier" );
level.sandman.name = undefined;
guys = [];
guys [0] = level.sandman;
guys [1] = level.player_arms;
guys [3] = intro_m4;
org anim_first_frame( guys, "ny_intro" );
org anim_first_frame_solo ( level.player_legs, "ny_intro" );
org anim_first_frame_solo ( intro_knife, "ny_intro" );
org anim_first_frame_solo ( humvee, "ny_intro" );
level.player freezecontrols(true);
level.player disableWeapons();
thread intro_rumble();
SetSavedDvar( "compass", 0 );
SetSavedDvar( "ammoCounterHide", 1 );
SetSavedDvar( "hud_showstance", 0 );
SetSavedDvar( "actionSlotsHide", 1 );
level.player PlayerLinkToBlend ( level.player_arms, "tag_player", 0.5 );
flag_wait ( "obj_follow_to_hind_given" );
wait 0.5;
level.player_arms show();
level.player_legs show();
thread humvee_intro_missiles();
thread intro_hind_flyover();
thread humvee_intro_dialog();
thread maps\ny_manhattan_fx::hummer_intro();
thread ny_manhattan_intro();
thread ny_manhattan_intro_blur();
thread ny_manhattan_intro_dof();
deadguy = getent ( "humvee_deadguy", "targetname" );
deadguy.animname = "humvee_deadguy";
deadguy assign_animtree();
org thread anim_first_frame_solo ( deadguy, "dead_idle" );
humvee setflaggedanimrestart ( "blah", level.scr_anim[ "intro_humvee" ][ "wheel_loop" ][0] , 1, 1 );
humvee setflaggedanimrestart ( "blargh", level.scr_anim[ "intro_humvee" ][ "ny_intro" ] , 1, 1 );
org thread anim_single_solo ( level.player_legs, "ny_intro" );
org thread anim_single_solo ( intro_knife, "ny_intro" );
org anim_single_run ( guys, "ny_intro" );
level.sandman.name = "Sandman";
level.wounded_medic.name = "Cpl. Soucy";
intro_m4 hide();
intro_hybrid hide();
intro_knife hide();
maps\_autosave::_autosave_game_now_nochecks();
activate_trigger_with_targetname ("first_combat_2");
level.sandman enable_heat_behavior();
level.sandman delaythread ( 10, ::disable_heat_behavior );
level.reno enable_dontevershoot();
level.reno delaythread ( 5, ::disable_dontevershoot );
level.player_arms hide();
level.player_legs hide();
level.player unlink();
level.player enableWeapons();
level.player enableoffhandweapons();
level.player freezecontrols ( false );
SetSavedDvar( "compass", 1 );
SetSavedDvar( "ammoCounterHide", 0 );
SetSavedDvar( "hud_showstance", 1 );
SetSavedDvar( "actionSlotsHide", 0 );
level.intro_stryker SetVehicleLookAtText( "Samaritan", &"" );
level.broad_stryker02 SetVehicleLookAtText( "Frolic", &"" );
level.broad_stryker SetVehicleLookAtText( "Firefly", &"" );
flag_set ( "out_of_sewer" );
flag_set ( "briefing_done" );
wait 1;
}
intro_rumble()
{
wait 4.5;
level.rumble rumble_ramp_on ( 0.1 );
wait 1;
level.rumble rumble_ramp_off( 3 );
flag_wait ( "exchange_humvee_go" );
wait 0.2;
level.rumble rumble_ramp_on ( 0.1 );
wait 0.5;
level.rumble rumble_ramp_off ( 0.5 );
}
humvee_intro_missiles()
{
level.player_arms waittillmatch ( "single anim", "start_missiles" );
cruiseMissile1 = spawn_vehicle_from_targetname_and_drive( "intro_missile_1" );
cruiseMissile1 thread wait_for_intro_missile_to_hit( "intro_missile_1_hits", "intro_missile1_hits");
wait 1;
cruiseMissile2 = spawn_vehicle_from_targetname_and_drive( "intro_missile_2" );
cruiseMissile2 thread wait_for_intro_missile_to_hit( "intro_missile_2_hits", "intro_missile2_hits");
intro_taxi = getent ( "intro_taxi", "script_noteworthy" );
wait 6.4;
aud_send_msg("taxi_explode", intro_taxi);
intro_taxi destructible_force_explosion();
wait 0.5;
flag_set ( "exchange_humvee_go" );
rpg_org = getent ( "org_intro_rpg", "targetname" );
rpg_dest = getent ( "dest_intro_rpg", "targetname" );
wait 7;
rpg = Magicbullet ( "rpg_straight", rpg_org.origin, rpg_dest.origin );
flag_wait("out_of_sewer");
flag_set ( "player_shot_or_advanced" );
}
dialog_prime( msg )
{
assert( isdefined(self.animname) && isdefined( level.scr_sound[self.animname][msg] ) );
alias = level.scr_sound[self.animname][msg];
self aud_prime_stream( alias );
}
dialog_release( msg )
{
assert( isdefined(self.animname) && isdefined( level.scr_sound[self.animname][msg] ) );
alias = level.scr_sound[self.animname][msg];
aud_release_stream( alias );
}
dialog_is_primed( msg )
{
assert( isdefined(self.animname) && isdefined( level.scr_sound[self.animname][msg] ) );
alias = level.scr_sound[self.animname][msg];
return aud_is_stream_primed( alias );
}
humvee_intro_dialog()
{
level.sandman dialog_prime( "lonestar_line135" );
level.sandman dialog_prime( "lonestar_line136" );
wait 5.0;
level.sandman dialogue_queue ( "manhattan_snd_frostfrost" );
level.sandman waittillmatch ( "single anim", "dialog1" );
level.sandman dialogue_queue ( "lonestar_line135" );
level.sandman waittillmatch ( "single anim", "dialog2" );
level.sandman dialogue_queue ( "lonestar_line136" );
conversation_start();
level.sandman dialogue_queue ( "manhattan_snd_youup" );
level.reno dialogue_queue ( "manhattan_rno_weregood" );
conversation_stop();
}
getadsbinding()
{
adsholdbound = true;
adsbound = false;
binds = GetKeyBinding( "+speed_throw");
if (!isdefined(binds) || (binds["count"] == 0))
{
adsholdbound = false;
binds = GetKeyBinding( "+toggleads_throw");
if (isdefined(binds) && (binds["count"] > 0))
adsbound = true;
}
mask = 0;
if (adsbound)
mask = 1;
else if (adsholdbound)
mask = 2;
return mask;
}
handle_ads_hint( hint, hint_toggle, timeout, loc_ads, loc_ads_toggle )
{
adsbind = getadsbinding();
switch(adsbind)
{
case 0:
thread display_hint_timeout ( "hint_ads_empty", timeout );
break;
case 1:
thread display_hint_timeout ( hint_toggle, timeout );
break;
case 2:
thread display_hint_timeout ( hint, timeout );
break;
}
if (level.console)
return;
prv_adsbind = adsbind;
while (isdefined(level.current_hint))
{
adsbind = getadsbinding();
if (adsbind != prv_adsbind)
{
switch(adsbind)
{
case 0:
level.current_hint SetText( "" );
break;
case 1:
level.current_hint SetText( loc_ads_toggle );
break;
case 2:
level.current_hint SetText( loc_ads );
break;
}
prv_adsbind = adsbind;
}
wait 0.05;
}
}
first_combat()
{
thread first_combat_2();
flag_wait ( "sandman_sewer_exit_moveup" );
aud_send_msg ("russian_radio_chatter");
flag_set ( "reno_truck_start" );
wait 4;
activate_trigger_with_targetname ( "trigger_p1" );
flag_wait ( "reno_truck_take_left" );
thread radio_guy_loop();
flag_wait ( "reno_tangos_ahead" );
if ( !flag ( "player_used_ads" ) )
{
thread handle_ads_hint( "hint_ads", "hint_ads_toggle", 5, &"NY_MANHATTAN_HINT_ADS", &"NY_MANHATTAN_HINT_ADS_TOGGLE" );
}
if (level.console)
delaythread ( 10, ::handle_ads_hint, "hint_snapto", "hint_ads_empty", 3, &"NY_MANHATTAN_HINT_SNAPTO", "" );
wait randomfloatrange( 7, 10 );
thread incoming_exploder( 201 );
wait 0.2;
thread incoming_exploder( 200 );
wait randomfloatrange( 1, 3 );
thread incoming_exploder( 200 );
Magicbullet ( "rpg", (-1267.9, -3028.8, 24 ), (-1267.9, -3028.8, 20 ) );
wait 1;
level.sandman dialogue_queue ( "lonestar_line19" );
}
first_combat_2()
{
flag_wait ( "start_banker_massacre" );
level notify ( "broad_combat_start" );
level.broad_stryker gopath();
level.broad_stryker02 delaythread ( 1.5, ::gopath );
level.broad_stryker thread stryker_think();
spawners = getentarray ( "stryker_infantry", "targetname" );
foreach ( spawner in spawners )
{
guy = spawner spawn_ai ( true );
}
thread broad_stryker_monitor();
wait 1;
aud_send_msg("broad_humvee_02", level.broad_humvee_02);
conversation_start();
level.truck dialogue_queue ( "truck_line5" );
level.truck dialogue_queue ( "manhattan_trk_dontshoothim" );
level.reno dialogue_queue ( "manhattan_rno_noshit" );
conversation_stop();
flag_wait ( "dialog_truck_15broad" );
if ( !flag ( "15broad_highguys_dead" ) )
level.truck dialogue_queue ( "truck_line4" );
flag_wait ( "15_broad_retreat" );
apartment_guys = getentarray ( "russians_destroyed_building_fl2", "script_noteworthy" );
thread array_setgoalvolume ( apartment_guys, "volume_15_broad_retreat" );
}
first_combat_delay()
{
flag_wait ( "player_advanced" );
fc_delay_spawners = getentarray ( "first_combat_delay", "script_noteworthy" );
fc_delay_guys = [];
foreach ( spawner in fc_delay_spawners )
{
fc_delay_guy = spawner stalingradspawn();
fc_delay_guys [ fc_delay_guys.size ] = fc_delay_guy;
fc_delay_guy.targetname = spawner.targetname;
fc_delay_guy.grenadeammo = 0;
goalnode = getnode ( fc_delay_guy.targetname, "targetname" );
fc_delay_guy setgoalnode ( goalnode );
fc_delay_guy thread fc_delay_kill();
}
wait 4;
thread array_setgoalvolume ( fc_delay_guys, "volume_exchange_fallback" );
wait 5;
foreach ( guy in fc_delay_guys )
{
wait randomfloatrange ( 0, 2 );
guy thread fake_death_bullet();
}
}
fc_delay_kill()
{
self endon ( "death" );
self waittill ( "goal" );
wait randomfloatrange ( 1, 2 );
if ( isdefined ( self ) && isalive ( self ) )
self thread fake_death_bullet();
}
radio_guy_loop()
{
level.radio_guy dialogue_queue ( "radio_loop02" );
}
monitor_hint_ads()
{
level endon ( "reno_tangos_ahead" );
level endon ( "player_used_ads" );
while ( true )
{
if ( level.player adsbuttonpressed () )
flag_set ( "player_used_ads" );
wait 0.05;
}
}
monitor_hint_xm25()
{
level endon ( "tiff_fight_02" );
level endon ( "player_used_xm25" );
while ( true )
{
weapon = level.player GetCurrentPrimaryWeapon();
if ( IsSubStr( weapon, "xm25" ) )
flag_set ( "player_used_xm25" );
wait 0.05;
}
}
vo_hurry_up(while_flag)
{
while (!flag ( while_flag ) )
{
rand_delay = RandomIntRange ( 10, 20 );
rand_line = RandomIntRange ( 1, 3 );
wait rand_delay;
if (!flag ( while_flag ) )
{
if (rand_line == 1 )
{
level.sandman dialogue_queue ( "lonestar_line52" );
}
else if ( rand_line == 2 )
{
level.sandman dialogue_queue ( "lonestar_line53" );
}
else level.sandman dialogue_queue ( "lonestar_line54" );
}
}
}
dialog_objective_reminder ( character, while_flag, lines, delay_min, delay_max )
{
last_line = undefined;
if ( !isdefined ( delay_min ) )
delay_min = 10;
if ( !isdefined ( delay_max ) )
delay_max = 20;
while (!flag ( while_flag ) )
{
rand_delay = RandomfloatRange ( delay_min, delay_max );
rand_line = random ( lines );
if ( isdefined ( last_line ) && rand_line == last_line )
continue;
else
{
last_line = rand_line;
wait rand_delay;
if ( !flag ( while_flag ) )
character dialogue_queue ( rand_line );
}
}
}
enable_awareness()
{
if ( isdefined ( self.suppressionwait_old ) )
{
self.ignoreall = false;
self.dontmelee = undefined;
self.ignoreSuppression = false;
self.suppressionwait = self.suppressionwait_old;
self.suppressionwait_old = undefined;
self enable_surprise();
self.IgnoreRandomBulletDamage = false;
self enable_bulletwhizbyreaction();
self enable_pain();
self enable_danger_react(3);
self.grenadeawareness = 1;
self.ignoreme = 0;
self disable_dontevershoot();
self.disableFriendlyFireReaction = undefined;
}
}
disable_awareness()
{
if (!isdefined(self.suppressionwait_old))
{
self.ignoreall = true;
self.dontmelee = true;
self.ignoreSuppression = true;
self.suppressionwait_old = self.suppressionwait;
self.suppressionwait = 0;
self disable_surprise();
self.IgnoreRandomBulletDamage = true;
self disable_bulletwhizbyreaction();
self disable_pain();
self disable_danger_react();
self.grenadeawareness = 0;
self.ignoreme = 1;
self enable_dontevershoot();
self.disableFriendlyFireReaction = true;
}
}
kill_guy_with_explosion ()
{
if ( isdefined ( self ) && isai ( self ) || isplayer ( self ) )
{
pos = self.origin;
incoming_dur = 0.9;
aud_send_msg( "kill_guy_missile_incoming", [pos, incoming_dur] );
wait(incoming_dur);
aud_send_msg( "kill_guy_missile_explosion", pos );
playfx ( getfx( "ny_mortarexp_dud" ), pos );
if ( isdefined ( self ) && isai ( self ) )
{
self kill();
}
}
}
incoming_exploder( num )
{
assert( IsDefined( num ) );
incoming_dur = randomfloatrange( 1.0, 1.5 );
aud_send_msg( "exploder_incoming", [num, incoming_dur] );
wait( incoming_dur );
aud_send_msg( "exploder_explosion", num );
exploder ( num );
}
broad_player_kill()
{
level endon ( "stop_kill_player" );
while ( true )
{
flag_wait ( "broad_player_kill" );
wait 3;
if ( flag ( "broad_player_kill" ) )
{
level.player endon ( "death" );
Magicbullet ( "rpg_straight", level.player.origin + ( 0, 0, 8 ), level.player.origin + ( 0, 16, 6 ) );
while ( true )
{
level.player dodamage ( 10, level.player.origin );
wait 0.1;
}
}
}
}
player_backtrack_fail_setup()
{
if( is_split_level_part( "b" ) )
{
return;
}
thread backtrack_warn();
triggers = getentarray ( "player_backtracked", "targetname" );
array_thread ( triggers, ::backtrack_fail );
}
backtrack_fail()
{
self waittill ( "trigger" );
flag_set ( "player_backtracked" );
SetDvar( "ui_deadquote", "@NY_MANHATTAN_FAIL_BACKTRACK" );
missionfailedwrapper();
}
backtrack_warn()
{
level endon ( "entering_hind" );
while ( true )
{
flag_wait ( "backtrack_warn" );
display_hint ( "hint_backtrack" );
flag_waitopen ( "backtrack_warn" );
wait 0.05;
}
}
setup_tvs()
{
SetSavedDvar( "cg_cinematicFullScreen", "0" );
thread tv_cinematic_think_broad();
thread tv_cinematic_think_nyse();
}
tv_cinematic_think_broad()
{
flag_wait( "broad_squad_moveup" );
thread tv_movie();
flag_wait( "flashbang_start" );
level notify( "stop_cinematic" );
StopCinematicInGame();
}
tv_cinematic_think_nyse()
{
if( is_split_level_part( "a" ) )
{
return;
}
flag_wait_either ( "give_xm25", "skip_paw" );
thread tv_movie();
flag_wait ( "dialog_second_tier" );
level notify( "stop_cinematic" );
StopCinematicInGame();
}
tv_movie()
{
level endon( "stop_cinematic" );
while ( 1 )
{
CinematicInGameLoopResident( "ny_manhattan_tvanamorphic" );
wait( 5 );
while ( IsCinematicPlaying() )
{
wait( 1 );
}
}
}
	
