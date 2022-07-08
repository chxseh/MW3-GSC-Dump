#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_escape_code;
#include maps\_shg_common;
#include maps\_utility_chetan;
#using_animtree( "generic_human" );
start_medic()
{
move_player_to_start( "medic_player" );
maps\_compass::setupMiniMap( "compass_map_prague_escape_standoff", "standoff_minimap_corner" );
if ( !IsDefined( level.player ) )
{
level.player = GetEntArray( "player", "classname" )[ 0 ];
level.player.animname = "player_rig";
}
level.player EnableWeapons();
level.player GiveWeapon( "m4m203_reflex" );
level.player SwitchToWeapon( "m4m203_reflex" );
setup_hero_for_start( "price", "medic" );
setup_hero_for_start( "soap", "medic" );
trig_player_bar_door = GetEnt( "trig_player_bar_door", "targetname" );
trig_player_bar_door trigger_off();
sp_medic4 = GetEnt( "resistance_medic4", "targetname" );
level.ai_medic4 = sp_medic4 spawn_ai( true );
sp_leader = GetEnt( "resistance_leader", "targetname" );
level.ai_leader = sp_leader spawn_ai( true );
level.ai_leader forceUseWeapon("ak74u", "primary");
setup_props();
spawn_resistance_leader();
thread resistance_leader();
spawn_resistance_guys();
setup_heroes();
level thread setup_soap_death_scene();
flag_set( "soap_on_table" );
maps\prague_escape_sniper::prague_escape_skippast_cleanup();
flag_set( "queue_sniper_music" );
flag_set( "queue_player_carry_music" );
flag_set( "queue_price_carry_music" );
flag_set( "queue_defend_music" );
flag_set( "queue_soap_death_music" );
}
medic_main()
{
battlechatter_off();
thread soap_death_objectives();
if( level.start_point != "medic" )
{
thread soap_death_mission_fail_1();
thread soap_death_mission_fail_2();
}
thread setup_alley_btrs();
post_soap_death();
}
init_medic_level_flags()
{
flag_init( "start_window_gun_fire" );
flag_init( "player_door_objective" );
flag_init( "soap_death_scene" );
flag_init( "start_convulsion_death" );
flag_init( "player_hit_controls" );
flag_init( "player_trigger_check" );
flag_init( "leader_wave_start" );
flag_init( "leader_wave_clear" );
flag_init( "FLAG_soap_death_started" );
flag_init( "spawn_alley_btrs" );
flag_init( "stop_price_nag_lines" );
flag_init( "soap_convulsion_needtoknow" );
flag_init( "soap_convulsion_knowsyuri" );
flag_init( "price_convulsion_waitingfor" );
flag_init( "price_convulsion_dialogue10" );
flag_init( "price_convulsion_soap2" );
flag_init( "price_slowdeath_tellmelater" );
flag_init( "soap_slowdeath_needtoknow" );
flag_init( "soap_slowdeath_knowsyuri" );
flag_init( "price_put_pressure_dialogue02" );
flag_init( "stop_pistol_slowmo" );
flag_init( "play_soap_heartbeat" );
flag_init( "fast_heartbeat" );
flag_init( "medium_heartbeat" );
flag_init( "dying_heartbeat" );
flag_init( "queue_soap_death_music" );
}
setup_heroes()
{
level.price.ignoreme = true;
level.price.ignoreall = true;
level.price.goalradius = 32;
level.price gun_remove();
level.price forceUseWeapon( "ak47", "primary" );
level.soap.ignoreme = true;
level.soap.ignoreall = true;
level.soap SetCanDamage( false );
}
setup_props()
{
s_anim_align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
m_escape_door_punch = GetEnt( "escape_door_punch", "targetname" );
level.m_escape_door = Spawn( "script_model", m_escape_door_punch.origin );
level.m_escape_door SetModel( "tag_origin_animate" );
level.m_escape_door.angles = m_escape_door_punch.angles;
level.m_escape_door.animname = "punch_door";
level.m_escape_door UseAnimTree( level.scr_animtree[ "punch_door" ] );
m_escape_door_punch.origin = level.m_escape_door GetTagOrigin( "origin_animate_jnt" );
m_escape_door_punch.angles = level.m_escape_door GetTagAngles( "origin_animate_jnt" );
m_escape_door_punch LinkTo( level.m_escape_door, "origin_animate_jnt" );
s_anim_align_soap_death thread anim_first_frame_solo( level.m_escape_door, "price_punch" );
m_price_pistol = GetEnt( "price_pistol", "targetname" );
journal = Spawn( "script_model", m_price_pistol.origin );
journal.angles = m_price_pistol.angles;
journal SetModel( "prop_journal" );
m_price_pistol delete();
level.m_link_pistol = Spawn( "script_model", journal.origin );
level.m_link_pistol SetModel( "tag_origin_animate" );
level.m_link_pistol.angles = journal.angles;
level.m_link_pistol.animname = "price_journal";
level.m_link_pistol UseAnimTree( level.scr_animtree[ "price_journal" ] );
journal.origin = level.m_link_pistol GetTagOrigin( "origin_animate_jnt" );
journal.angles = level.m_link_pistol GetTagAngles( "origin_animate_jnt" );
journal LinkTo( level.m_link_pistol, "origin_animate_jnt" );
}
price_attach_pistol( guy )
{
pistol = spawn_model_in_prices_hand( "weapon_colt1911_black" );
level.price waittill( "detach_pistol" );
origin = level.price gettagorigin( "TAG_INHAND" );
angles = level.price gettagangles( "TAG_INHAND" );
pistol unlink();
pistol.origin = origin;
pistol.angles = angles;
}
price_detach_pistol( guy )
{
level.price notify( "detach_pistol" );
}
price_attach_journal( guy )
{
journal = spawn_model_in_prices_hand( "prop_journal" );
level.price waittill( "delete_journal" );
journal delete();
}
price_detach_journal( guy )
{
level.price notify( "delete_journal" );
}
spawn_model_in_prices_hand( model_string )
{
origin = level.price gettagorigin( "TAG_INHAND" );
angles = level.price gettagangles( "TAG_INHAND" );
model = Spawn( "script_model", origin );
model.angles = angles;
model SetModel( model_string );
model linkto( level.price, "TAG_INHAND" );
return model;
}
spawn_resistance_leader()
{
spawner = GetEnt( "ai_resistance_leader", "targetname" );
level.ai_resistance_leader = spawner spawn_ai( true );
level.ai_resistance_leader.animname = "resistance_leader";
level.ai_resistance_leader.ignoreme = true;
level.ai_resistance_leader.ignoreall = true;
level.ai_resistance_leader.goalradius = 32;
level.ai_resistance_leader enable_magic_bullet_shield();
spawner Delete();
}
disable_magic_bullet_shield()
{
if ( self compare_value( "magic_bullet_shield", true ) )
self stop_magic_bullet_shield();
}
enable_magic_bullet_shield()
{
if ( ( !IsDefined( self.magic_bullet_shield ) || !self.magic_bullet_shield ) && !self.delayedDeath )
self deletable_magic_bullet_shield();
}
spawn_resistance_guys()
{
level.ai_resistance_guy = level.ai_leader;
level.ai_resistance_guy2 = level.ai_medic4;
level.ai_resistance_guy.animname = "resistance_guy1";
level.ai_resistance_guy.ignoreme = true;
level.ai_resistance_guy.ignoreall = true;
level.ai_resistance_guy.deathfunction	= ::deathfunc_ragdoll;
level.ai_resistance_guy2.animname = "resistance_guy2";
level.ai_resistance_guy2.ignoreme = true;
level.ai_resistance_guy2.ignoreall = true;
}
kill_resistance_guy( guy )
{
if(guy.animname == "resistance_guy1")
{
guy DropWeapon( "ak74u", "right", 0 );
}
guy.allowdeath = true;
guy kill();
}
post_soap_death()
{
level thread resistance_post_soap_death();
level thread price_post_soap_death();
flag_wait( "soap_death_scene" );
wait 0.50;
flag_set( "start_window_gun_fire" );
}
setup_soap_death_scene()
{
align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
level.a_anim_ents = [ level.soap, level.price, level.ai_resistance_leader ];
flag_wait("soap_on_table");
musicstop( 5 );
align_soap_death thread anim_loop( level.a_anim_ents, "soap_death_idle" );
trig_medic_start = GetEnt( "trig_medic_start", "targetname" );
trig_medic_start SetHintString( &"PRAGUE_ESCAPE_HINT_MEDIC_SOAP" );
trig_medic_start trigger_on();
trig_medic_start waittill( "trigger" );
trig_medic_start Delete();
wii_clean_up();
maps\prague_escape_code::hide_player_hud();
level.soap.name = " ";
level.price.name = " ";
flag_set( "stop_price_nag_lines" );
flag_set( "FLAG_soap_death_started" );
align_soap_death notify( "stop_loop" );
align_soap_death notify( "stop_death_idle" );
level.player DisableWeapons();
level.player EnableInvulnerability();
level.player AllowCrouch( false );
level.player AllowProne( false );
level.player EnableDeathShield( true );
player_rig = spawn_anim_model( "player_rig", level.player.origin );
player_rig.angles = level.player GetPlayerAngles();
align_soap_death anim_first_frame_solo( player_rig, "soap_death" );
player_rig Hide();
lerp_time = 0.25;
level.player PlayerLinkToBlend( player_rig, "tag_player", lerp_time, lerp_time * 0.25, lerp_time * 0.25 );
wait lerp_time;
player_rig Show();
level.player playerlinktoabsolute( player_rig, "tag_player" );
level.player delaycall( 4, ::PlayerLinkToDelta, player_rig, "tag_player", 0, 15, 15, 15, 15 );
level thread death_music_change();
level thread soap_heartbeat();
delaythread(3, :: heartbeat_flags);
align_soap_death thread anim_single_solo( player_rig, "soap_death" );
align_soap_death anim_single( level.a_anim_ents, "soap_death" );
level notify( "soap_is_dead" );
level thread soap_death_idle( "soap_dead" );
align_soap_death notify( "stop_loop" );
flag_set( "soap_death_scene");
flag_set_delayed("spawn_alley_btrs", 1.35);
flag_wait( "start_window_gun_fire" );
player_rig Delete();
level.player Unlink();
level.player EnableWeapons();
flag_set( "player_door_objective" );
level thread autosave_by_name_silent( "cellar_escape" );
maps\prague_escape_code::show_player_hud();
level.price.name = "Price";
level.soap.team = "neutral";
level.player AllowCrouch( true );
level.player AllowProne( true );
escape_nag_lines = [ "presc_pri_yurimoveyour",
"presc_pri_overherenow",
"presc_pri_yurigetoverhere2" ];
wait(15);
thread do_random_dialogue_until_flags( level.price, escape_nag_lines, [ "player_opened_door" ], 8 );
}
wii_clean_up()
{
flag_set ("wii_delete");
level notify ("wii_soap_dead");
maps\_spawner::killSpawner( 1 );
maps\_spawner::killSpawner( 2 );
maps\_spawner::killSpawner( 3 );
maps\_spawner::killSpawner( 4 );
maps\_spawner::killSpawner( 5 );
axis = GetAIArray( "axis" );
array_call(axis, ::Delete);
level.wii_btr delete();
}
heartbeat_flags()
{
time = 19;
thread flag_clear_delayed( "play_soap_heartbeat", time );
thread flag_clear_delayed( "fast_heartbeat", time*.5 );
flag_set_delayed( "dying_heartbeat", time*.5 );
}
death_music_change()
{
music_play( "prague_escape_soap_death_end" );
}
temp_move_player_from_geo()
{
mover = spawn("script_origin", level.player.origin );
level.player playerlinktoabsolute( mover );
mover moveto( (26013, 19636, level.player.origin[2]), .5 );
wait(.5);
level.player unlink();
level.player EnableWeapons();
}
do_vo_nag_loop( vo_array, ender, repeat_interval )
{
x = 0;
is_first_time = true;
level.used_nag_lines = [];
while( !flag( ender ) )
{
wait 1;
x++;
if (flag( ender ))
{
return;
}
if( x >= repeat_interval || is_first_time )
{
is_first_time = false;
mixed_lines = array_randomize( vo_array );
random_line = random (mixed_lines);
level.price thread dialogue_queue( random_line );
x = 0;
level.used_nag_lines = add_to_array (level.used_nag_lines, random_line );
vo_array = array_remove (vo_array, random_line);
if(vo_array.size == 0)
{
vo_array = level.used_nag_lines;
level.used_nag_lines = [];
}
}
}
}
resistance_leader( node )
{
align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
if(!isDefined( node) )
{
align_leader = spawnstruct();
align_leader.origin = align_soap_death.origin;
align_leader.angles = align_soap_death.angles;
}
else
{
align_leader = node;
}
flag_wait( "start_window_gun_fire" );
align_leader notify( "stop_loop" );
wait 5;
level.ai_resistance_leader stop_magic_bullet_shield();
level.ai_resistance_leader kill();
}
resistance_leader_nag_lines()
{
self endon( "kill_leader_nag_lines" );
self endon( "death" );
self dialogue_queue( "presc_rl_getout" );
}
soap_death_idle( str_anim )
{
s_soap_align = getstruct( "anim_align_soap_death", "targetname" );
s_soap_align_death = SpawnStruct();
s_soap_align_death.origin = s_soap_align.origin;
s_soap_align_death.angles = s_soap_align.angles;
s_soap_align_death anim_loop_solo( level.soap, str_anim );
flag_wait( "player_opened_door" );
s_soap_align_death notify ( "stop_loop" );
level.soap stop_magic_bullet_shield();
level.soap Delete();
}
resistance_post_soap_death()
{
s_anim_align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
s_resistance_align = SpawnStruct();
s_resistance_align.origin = s_anim_align_soap_death.origin;
s_resistance_align.angles = s_anim_align_soap_death.angles;
flag_wait( "soap_death_scene" );
level.ai_resistance_guy stop_magic_bullet_shield();
level.ai_resistance_guy2 stop_magic_bullet_shield();
flag_wait( "start_window_gun_fire" );
s_anim_align_soap_death notify( "stop_loop" );
flag_wait("start_blood_fx");
PlayFXOnTag( level._effect[ "ai_blood_splash" ], level.ai_resistance_guy, "J_Spine4" );
}
price_post_soap_death()
{
align_soap_death = getstruct( "anim_align_soap_death", "targetname" );
flag_wait( "soap_death_scene" );
align_price = SpawnStruct();
align_price.origin = (25999, 19539, 32);
align_price.angles = align_soap_death.angles;
align_soap_death notify( "stop_loop" );
align_price anim_reach_solo( level.price, "price_punch_loop" );
align_price thread anim_loop_solo( level.price, "price_punch_loop" );
}
blinds()
{
m_blind_01 = GetEnt( "fxanim_prague2_blind01_mod", "targetname" );
m_blind_02 = GetEnt( "fxanim_prague2_blind02_mod", "targetname" );
m_blind_03 = GetEnt( "fxanim_prague2_blind03_mod", "targetname" );
m_blind_01 UseAnimTree( level.scr_animtree[ "script_model" ] );
m_blind_02 UseAnimTree( level.scr_animtree[ "script_model" ] );
m_blind_03 UseAnimTree( level.scr_animtree[ "script_model" ] );
m_blind_01.animname = "blind_01";
m_blind_02.animname = "blind_02";
m_blind_03.animname = "blind_03";
m_blind_01 thread start_blind();
m_blind_02 thread start_blind();
m_blind_03 thread start_blind();
}
start_blind()
{
self anim_single_solo( self, "cellar_blinds" );
self thread anim_loop_solo(self, "cellar_blinds_idle");
flag_wait( "player_opened_door" );
wait 5.0;
self notify( "stop_loop" );
wait 0.05;
self Delete();
}
slowmo_pistol_moment( guy )
{
}
setup_alley_btrs()
{
btr_spawners = GetEntArray( "alley_btrs", "targetname" );
array_thread( btr_spawners, ::add_spawn_function, ::alley_btr_think );
flag_wait( "spawn_alley_btrs" );
trig_spawn_alley_btrs = GetEnt( "trig_spawn_alley_btrs", "targetname" );
trig_spawn_alley_btrs notify( "trigger" );
wait 2.5;
level thread monitor_player_danger_zone();
level thread blinds();
exploder(1100);
}
adjust_engine_noise()
{
self endon("death");
flag_wait("stop_stair_rumble");
self Vehicle_TurnEngineOff();
flag_wait("begin_outro_anim");
self Vehicle_TurnEngineOn();
}
monitor_player_danger_zone()
{
level endon( "player_opened_door" );
level.player endon( "death" );
trig_danger_zone = GetEnt( "player_danger_zone", "targetname" );
level.player EnableInvulnerability();
level.cover_warnings_disabled = 1;
counter = 0;
while( 1 )
{
if ( level.player IsTouching( trig_danger_zone ) )
{
fake_fire_at_player();
counter += 1;
if(counter >= 3)
{
level.player DisableInvulnerability();
level.player kill();
}
wait( 2.5 );
}
else
{
counter = 0;
wait( 0.05 );
}
}
}
fake_fire_at_player()
{
warn_shot_starts = GetEntArray( "warn_shot_starts", "script_noteworthy" );
level.player DisableInvulnerability();
shots = RandomIntRange( 5, 8 );
for ( i = 0; i < shots; i++ )
{
damage_dir = getClosest( level.player.origin, warn_shot_starts );
level.player DoDamage( 10, damage_dir.origin );
wait 0.1;
}
level.player EnableInvulnerability();
}
alley_btr_think()
{
self endon( "death" );
self Vehicle_TurnEngineOff();
self SetCanDamage( false );
PlayFXOnTag( getfx( "spotlight_btr80_daytime" ), self, "tag_turret_light" );
PlayFXOnTag( getfx( "spotlight_btr80_daytime" ), self, "TAG_FRONT_LIGHT_LEFT" );
PlayFXOnTag( getfx( "spotlight_btr80_daytime" ), self, "TAG_FRONT_LIGHT_RIGHT" );
mg_turret = self.mgturret[ 0 ];
mg_turret.accuarcy = 0.1;
mg_turret.aiSpread = 5;
mg_turret SetMode( "manual" );
mg_turret notify( "stop_burst_fire_unmanned" );
self waittill( "reached_end_node" );
self thread adjust_engine_noise();
mg_turret thread maps\_mgturret::burst_fire_unmanned();
targets = [ GetEnt( "btr_1_target_a", "targetname" ),
GetEnt( "btr_1_target_b", "targetname" ),
GetEnt( "btr_1_target_c", "targetname" ),
GetEnt( "btr_1_target_d", "targetname" ),
GetEnt( "btr_2_target_a", "targetname" ),
GetEnt( "btr_2_target_b", "targetname" ),
GetEnt( "btr_2_target_c", "targetname" ),
GetEnt( "btr_2_target_d", "targetname" ) ];
for ( ; !flag( "kill_window_bullets" ); wait RandomFloatRange( 0.5, 1.0 ) )
{
index = ter_op( self.script_noteworthy == "vh_alley_btr_1", RandomIntRange( 0, 4 ), RandomIntRange( 4, 8 ) );
target = targets[ index ];
if ( IsDefined( target ) )
{
mg_turret SetTargetEntity( target );
self SetTurretTargetEnt( target );
if ( cointoss() )
self SetTurretTargetEnt( target, ( RandomIntRange( -50, 50 ), 0, RandomIntRange( -30, 30 ) ) );
}
mg_turret StartFiring();
shots = RandomIntRange( 20, 40 );
for ( i = 0; i < shots; i++ )
{
self FireWeapon();
wait 0.5;
}
mg_turret StopFiring();
}
}
soap_death_objectives()
{
flag_wait( "soap_on_table" );
save_soap_obj = GetEnt( "e_save_soap_obj", "targetname" );
Objective_Position( level.objective_iterator, save_soap_obj.origin );
Objective_SetPointerTextOverride( level.objective_iterator, &"PRAGUE_ESCAPE_HELP_SOAP" );
flag_wait( "soap_death_scene" );
flag_wait( "player_door_objective" );
if( IsDefined( level.n_obj_follow ) )
Objective_State_NoMessage( level.n_obj_follow, "done" );
if( IsDefined( level.n_obj_protect ) )
Objective_State_NoMessage( level.n_obj_protect, "done" );
door_objective = GetEnt( "e_door_objective", "targetname" );
level.n_obj_escape = prague_objective_add( &"PRAGUE_ESCAPE_OPEN_DOOR", true, true, door_objective.origin );
flag_wait( "player_opened_door" );
Objective_State( level.n_obj_escape, "done" );
}
soap_death_mission_fail_1()
{
flag_wait( "soap_on_table" );
trigger = GetEnt( "soap_death_mission_fail_trigger", "targetname" );
Assert( IsDefined( trigger ) );
timeout = 15;
elapsed = 0;
for ( ; !( level.player IsTouching( trigger ) ) && elapsed < timeout ; elapsed += 0.05 )
wait 0.05;
if ( elapsed >= timeout && !flag( "FLAG_soap_death_started" ) )
{
SetDvar( "ui_deadquote", &"PRAGUE_ESCAPE_HELP_SOAP" );
level notify( "mission failed" );
maps\_utility::missionFailedWrapper();
}
}
soap_death_mission_fail_2()
{
flag_wait( "soap_on_table" );
trigger = GetEnt( "soap_death_mission_fail_trigger", "targetname" );
Assert( IsDefined( trigger ) );
for ( ; ; )
{
trigger waittill( "trigger", triggerer );
if ( triggerer == level.player )
break;
}
timeout = 15;
for ( elapsed = 0; !flag( "FLAG_soap_death_started" ) && elapsed < timeout; elapsed += 0.05 )
wait 0.05;
if ( !flag( "FLAG_soap_death_started" ) )
{
SetDvar( "ui_deadquote", &"PRAGUE_ESCAPE_HELP_SOAP" );
level notify( "mission failed" );
maps\_utility::missionFailedWrapper();
}
}
soap_heartbeat()
{
level endon( "soap_is_dead" );
flag_set( "play_soap_heartbeat" );
flag_set( "fast_heartbeat" );
heart_beat_delay = 0;
while ( flag( "play_soap_heartbeat" ) )
{
if( flag( "fast_heartbeat" ) )
{
level.player PlayRumbleOnEntity( "damage_light" );
wait .4;
wait( 0 + randomfloat( 0.1 ) );
}
if( flag( "dying_heartbeat" ) )
{
wait 0.05;
level.player PlayRumbleOnEntity( "damage_light" );
wait .8;
wait( 0 + randomfloat( 0.1 ) + ( heart_beat_delay + 0.1 ) );
}
}
}
price_slowdeath_dialogue( guy )
{
level.price dialogue_queue( "presc_pri_donttrytospeak" );
flag_wait( "price_slowdeath_tellmelater" );
level.price dialogue_queue( "presc_pri_tellmelater" );
flag_wait( "price_slowdeath_soap2" );
level.price dialogue_queue( "presc_pri_soap2" );
}
soap_slowdeath_dialogue( guy )
{
level.soap dialogue_queue( "presc_mct_price2" );
flag_wait( "soap_slowdeath_needtoknow" );
level.soap dialogue_queue( "presc_mct_needtoknow" );
flag_clear( "fast_heartbeat" );
flag_set( "dying_heartbeat" );
flag_wait( "soap_slowdeath_knowsyuri" );
level.soap dialogue_queue( "presc_mct_knowsyuri" );
wait 4.65;
flag_set( "spawn_alley_btrs" );
}
price_gesture_dialogue( guy )
{
level.price dialogue_queue( "presc_pri_yurigetoverhere" );
}
