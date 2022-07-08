#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_audio;
bravo_bullet_shield(flag_wait)
{
bravo_guy = self;
if (IsDefined(self.Melee))
{
while (IsAlive(self) && IsDefined(self.Melee))
{
wait 0.1;
}
}
if ( !IsDefined( self ) || !IsAlive(self))
{
level waittill( flag_wait );
switch(flag_wait)
{
case "hannibal_spawned":
bravo_guy = level.hannibal;
break;
case "barracus_spawned":
bravo_guy = level.barracus;
break;
case "murdock_spawned":
bravo_guy = level.murdock;
break;
}
}
if ( isDefined(bravo_guy) && IsAlive(bravo_guy) && !isDefined( bravo_guy.magic_bullet_shield ) )
{
bravo_guy thread magic_bullet_shield();
}
}
bravo_invulnerability(enable)
{
if (enable == true)
{
level.murdock magic_bullet_shield();
level.barracus magic_bullet_shield();
level.hannibal magic_bullet_shield();
}
else
{
level.murdock stop_magic_bullet_shield();
level.barracus stop_magic_bullet_shield();
level.hannibal stop_magic_bullet_shield();
}
}
start_sandstorm_streets_fx()
{
level.sandstormfx = [];
sand_createfx_origin = ( -1613.14, -9162.08, 419.447);
sand_createfx_angles = ( 0, 268.001, 1.99871);
sand_up = anglestoup(sand_createfx_angles);
sand_fwd = anglestoforward(sand_createfx_angles);
fx0 = spawnFx( level._effect["sand_wall_payback_still_md"],sand_createfx_origin , sand_fwd, sand_up );
triggerFx( fx0, -2240);
level.sandstormfx[level.sandstormfx.size] = fx0;
}
start_sandstorm_post_interrogation()
{
level.sandstormfx = [];
sand_createfx_origin = ( -1613.14, -7862.08, 419.447);
sand_createfx_angles = ( 0, 268.001, 1.99871);
sand_up = anglestoup(sand_createfx_angles);
sand_fwd = anglestoforward(sand_createfx_angles);
fx0 = spawnFx( level._effect["sand_wall_payback_still_md"],sand_createfx_origin , sand_fwd, sand_up );
triggerFx( fx0, -2240);
level.sandstormfx[level.sandstormfx.size] = fx0;
}
toggle_chopper_fx()
{
if (level.snowlevel <2)
{
sandstorm_fx(2);
texploder(2300,-2240);
}
else
{
sandstorm_fx(3,-2240);
texploder(5300,-2240);
}
}
sandstorm_fx(fxlevel, delay)
{
if (fxlevel == 4)
{
delay_delete_wall(5);
}
else if (IsDefined(level.sandstormfx))
{
level.sandstormfx = array_removeUndefined(level.sandstormfx);
array_delete(level.sandstormfx);
}
if (!IsDefined(fxlevel))
{
fxlevel = 0;
}
if (fxlevel == 1)
{
start_sandstorm_intro_fx();
}
else if (fxlevel == 2)
{
start_sandstorm_streets_fx();
}
else if (fxlevel == 3)
{
if (!IsDefined(delay))
{
start_sandstorm_construction_fx();
}
else
{
start_sandstorm_construction_fx(delay);
}
}
else if (fxlevel == 4)
{
start_sandstorm_post_interrogation();
}
}
delay_delete_wall(delay)
{
if (IsDefined(level.sandstormfx))
{
level.sandstormfx = array_removeUndefined(level.sandstormfx);
new_array = level.sandstormfx;
wait(delay);
array_delete(new_array);
array_removeUndefined(level.sandstormfx);
}
}
start_sandstorm_intro_fx()
{
level.sandstormfx = [];
sand_createfx_origin = ( 3329.18, -7502.85, 1257.04 );
sand_createfx_angles = ( 359.318, 352.837, 0.881786 );
sand_up = anglestoup(sand_createfx_angles);
sand_fwd = anglestoforward(sand_createfx_angles);
fx0 = spawnFx( level._effect["sand_wall_payback_still_lg"],sand_createfx_origin , sand_fwd, sand_up );
triggerFx( fx0, -2240);
level.sandstormfx[level.sandstormfx.size] = fx0;
}
start_sandstorm_construction_fx(ramp)
{
level.sandstormfx = [];
sand_createfx_origin = (-737.243, -2444.67, 531.125 );
sand_createfx_angles = ( 0, 258, 0 );
sand_up = anglestoup(sand_createfx_angles);
sand_fwd = anglestoforward(sand_createfx_angles);
fx1 = spawnFx( level._effect["sand_wall_payback_still"],sand_createfx_origin , sand_fwd, sand_up );
sand_createfx_origin = ( 1091.39, -2842.78, 245.922 );
sand_createfx_angles = ( 357.269, 272.002, 0.534172 );
sand_up = anglestoup(sand_createfx_angles);
sand_fwd = anglestoforward(sand_createfx_angles);
fx2 = spawnFx( level._effect["sand_wall_payback_still"],sand_createfx_origin , sand_fwd, sand_up );
sand_createfx_origin = ( -3324.35, -2031.53, 415.489 );
sand_createfx_angles = ( 0, 242, 0 );
sand_up = anglestoup(sand_createfx_angles);
sand_fwd = anglestoforward(sand_createfx_angles);
fx3 = spawnFx( level._effect["sand_wall_payback_still"],sand_createfx_origin , sand_fwd, sand_up );
if (!IsDefined(ramp))
{
triggerFx( fx1);
triggerFx( fx2);
triggerFx( fx3);
}
else
{
triggerFx( fx1, ramp);
triggerFx( fx2, ramp);
triggerFx( fx3, ramp);
}
level.sandstormfx[level.sandstormfx.size] = fx1;
level.sandstormfx[level.sandstormfx.size] = fx2;
level.sandstormfx[level.sandstormfx.size] = fx3;
}
disable_hands()
{
level.player DisableWeapons();
level.player DisableWeaponSwitch();
level.player DisableOffhandWeapons();
}
enable_hands()
{
level.player EnableWeapons();
level.player EnableWeaponSwitch();
level.player EnableOffhandWeapons();
}
spawn_smoke(ent)
{
smoke_fx = getfx("thick_black_smoke_L");
PlayFxOnTag(smoke_fx, ent, "tag_origin");
if (!IsDefined(level.smokes))
{
level.smokes = [];
}
ent.smokeFXId = smoke_fx;
level.smokes[level.smokes.size] = ent;
}
remove_smokes()
{
if (IsDefined(level.smokes))
{
for (i=0; i < level.smokes.size; i++)
{
smokeEnt = level.smokes[i];
if (IsDefined(smokeEnt))
{
StopFxOnTag(smokeEnt.smokeFXId, smokeEnt, "tag_origin");
}
}
level.smokes = [];
}
}
waittill_spawn_finished()
{
if ( !IsDefined( self.finished_spawning ) || !self.finished_spawning )
{
self waittill( "finished spawning" );
}
}
get_nikolai_chopper()
{
if ( !IsDefined( level.chopper ) )
{
nikolai_chopper_init();
}
return level.chopper;
}
nikolai_chopper_init()
{
if ( !IsDefined( level.chopper ) )
{
level.chopper = maps\_vehicle::spawn_vehicle_from_targetname( "heli_nikolai" );
}
level.chopper.repulsor = Missile_CreateRepulsorEnt( level.chopper, 5000, 800 );
level.chopper setCanDamage( false );
level.chopper SetVehicleTeam( "allies" );
level.chopper.ignoreall = true;
level.chopper SetMaxPitchRoll( 30, 30 );
level.chopper SetTurningAbility( 1.0 );
level.chopper SetJitterParams( ( 1000, 1000, 500 ), 0.25, 0.75 );
level.chopper SetHoverParams( 100, 20, 10 );
origin = level.chopper GetTagOrigin("tag_origin");
ground = level.chopper GetTagOrigin("tag_ground");
level.chopper.originheightoffset = origin[2] - ground[2] + 22;
thread maps\payback_aud::loop_chopper();
return level.chopper;
}
nikolai_init()
{
if ( !IsDefined(level.nikolai) )
{
level.nikolai = spawn_ally("nikolai", "nikolai_spawn_point");
}
if ( !IsDefined(level.nikolai_in_chopper) )
{
get_nikolai_chopper() vehicle_load_ai_single(level.nikolai);
level.nikolai_in_chopper = true;
}
}
tag_vicinity_check(ent, tagName, radius, eventName)
{
level endon(eventName);
waittillframeend;
radiusSqr = radius * radius;
for(;;)
{
tagOrigin = ent GetTagOrigin(tagName);
if ( DistanceSquared(tagOrigin, self.origin) <= radiusSqr )
{
level notify(eventName);
}
wait 0.05;
}
}
hide_hud_for_scripted_sequence()
{
SetSavedDvar( "compass", 0 );
SetSavedDvar( "ammoCounterHide", 1 );
SetSavedDvar( "hud_showstance", 0 );
SetSavedDvar( "actionSlotsHide", 1 );
}
show_hud_after_scripted_sequence()
{
SetSavedDvar( "compass", 1 );
SetSavedDvar( "ammoCounterHide", 0 );
SetSavedDvar( "hud_showstance", 1 );
SetSavedDvar( "actionSlotsHide", 0 );
}
move_player_to_start( overrideSpawnPointName )
{
if ( !IsDefined( overrideSpawnPointName ))
{
overrideSpawnPointName = level.start_point + "_playerstart";
}
return move_player_to_scriptstruct( overrideSpawnPointName , "targetname" );
}
move_player_to_scriptstruct( structName , keyName )
{
startstruct = getstruct( structName , keyName );
if ( IsDefined( startstruct ))
{
level.player setOrigin( startstruct.origin );
level.player setPlayerAngles( startstruct.angles );
return true;
}
return false;
}
spawn_ally( allyName , overrideSpawnPointName )
{
if ( !IsDefined( overrideSpawnPointName ))
{
overrideSpawnPointName = level.start_point + "_" + allyName;
}
ally = spawn_noteworthy_at_struct_targetname( allyName , overrideSpawnPointName );
return ally;
}
ai_array_killcount_flag_set( enemies , killcount , flag , timeout )
{
waittill_dead_or_dying( enemies , killcount , timeout );
flag_set( flag );
}
array_spawn_allow_fail( spawners, bForceSpawn )
{
guys = [];
foreach ( spawner in spawners )
{
spawner.count = 1;
guy = spawner spawn_ai( bForceSpawn );
if ( IsDefined( guy ))
{
guys[ guys.size ] = guy;
}
}
return guys;
}
array_spawn_targetname_allow_fail( targetname )
{
spawners = GetEntArray( targetname, "targetname" );
AssertEx( spawners.size, "Tried to spawn spawners with targetname " + targetname + " but there are no spawners" );
return array_spawn_allow_fail( spawners );
}
spawn_noteworthy_at_struct_targetname( noteworthyName , structName )
{
noteworthy_spawner = getent( noteworthyName , "script_noteworthy" );
noteworthy_start = getstruct( structName , "targetname" );
noteworthy_spawner.origin = noteworthy_start.origin;
if(isdefined(noteworthy_start.angles))
{
noteworthy_spawner.angles = noteworthy_start.angles;
}
spawned = noteworthy_spawner spawn_ai();
return spawned;
}
setup_spawn_funcs()
{
level.custom_spawn_funcs = [];
level.custom_spawn_funcs["chopper_street_runners"] = ::spawn_func_chopper_street_runners;
level.custom_spawn_funcs["respawn_on_death_flashlights"] = ::spawn_func_respawn_on_death_flashlights;
level.custom_spawn_funcs["flashlight_runner"] = ::spawn_func_flashlight_runner;
level.custom_spawn_funcs["flashlight_runner_delete_at_path_end"] = ::spawn_func_flashlight_runner_delete_at_path_end;
level.custom_spawn_funcs["crush_player"] = ::spawn_func_crushplayer;
level.custom_spawn_funcs["sandstorm_combat"] = ::spawn_func_sandstorm_combat;
level.custom_spawn_funcs["sandstorm_combat_delete"] = ::spawn_func_sandstorm_combat_delete;
level.custom_spawn_funcs["sandstorm_combat_rusher"] = ::spawn_func_sandstorm_combat_rusher;
level.custom_spawn_funcs["sandstorm_combat_pather"] = ::spawn_func_sandstorm_combat_pather;
level.custom_spawn_funcs["sandstorm_combat_flood"] = ::spawn_func_sandstorm_combat_flood;
level.custom_spawn_funcs["ignore_till_path_end"] = ::spawn_func_ignore_till_path_end;
level.custom_spawn_funcs["delete_at_path_end"] = ::spawn_func_delete_at_path_end;
level.custom_spawn_funcs["respawn_on_death"] = ::spawn_func_respawn_on_death ;
level.custom_spawn_funcs["target_escape_chopper"] = ::spawn_func_target_escape_chopper;
level.custom_spawn_funcs["ignore_til_pathend_or_damage_spawners"] = ::chase_ignore_til_pathend_or_damage;
level.custom_spawn_funcs["chopper_drop_off_land"] = ::spawn_func_chopper_drop_off_land;
keys = getarraykeys(level.custom_spawn_funcs);
foreach ( key in keys )
{
array = getentarray(key, "script_noteworthy");
if(isdefined(array) && array.size)
{
array_spawn_function_noteworthy( key, level.custom_spawn_funcs[key] );
}
}
all_axis_spawners = GetSpawnerTeamArray( "axis" );
script_parameter_spawners = [];
foreach ( spawner in all_axis_spawners )
{
if ( !IsDefined( spawner.script_parameters ) )
continue;
script_parameter_spawners[ script_parameter_spawners.size ] = spawner;
}
if( script_parameter_spawners.size > 0 )
{
array_spawn_function( script_parameter_spawners, ::process_ai_script_parameters );
}
}
array_custom_spawn_func(guys, custom_spawn_func_name)
{
if ( IsDefined(custom_spawn_func_name) )
{
spawn_func = level.custom_spawn_funcs[custom_spawn_func_name];
assertex( isdefined( spawn_func ), "Invalid custom spawn function name <" + custom_spawn_func_name + ">" );
foreach ( guy in guys )
{
if ( IsAlive(guy) )
{
guy thread [[ spawn_func ]]();
}
}
}
}
spawn_func_chopper_street_runners()
{
self endon( "death" );
self maps\payback_sandstorm_code::flashlight_on_guy();
self enable_cqbwalk();
self waittill_either( "goal", "damage" );
self disable_cqbwalk();
}
spawn_func_respawn_on_death_flashlights()
{
self maps\payback_sandstorm_code::flashlight_on_guy();
self thread spawn_func_force_respawn_on_death();
waittill_spawn_finished();
self.baseaccuracy = 0.15;
}
spawn_func_flashlight_runner()
{
self.sprint = true;
self maps\payback_sandstorm_code::flashlight_on_guy();
}
spawn_func_flashlight_runner_delete_at_path_end()
{
self spawn_func_flashlight_runner();
self spawn_func_delete_at_path_end();
}
spawn_func_crushplayer()
{
rush_player = (!IsDefined(self.script_fixednode) || !self.script_fixednode);
self activate_crush_player_mode(rush_player);
}
spawn_func_sandstorm_combat()
{
self maps\payback_sandstorm_code::flashlight_on_guy();
waittill_spawn_finished();
self.baseaccuracy = 0.01;
}
spawn_func_sandstorm_combat_delete()
{
self endon("death");
self thread spawn_func_sandstorm_combat();
self combat_runner_enable();
self thread spawn_func_delete_at_path_end();
}
spawn_func_sandstorm_combat_flood()
{
self thread spawn_func_sandstorm_combat();
self thread spawn_func_respawn_on_death();
}
spawn_func_sandstorm_combat_rusher()
{
self endon("death");
self thread spawn_func_sandstorm_combat();
self SetGoalEntity(level.player);
self combat_runner_enable();
self enable_sprint();
wake_up_radius = 512;
wake_up_radius_sqr = wake_up_radius * wake_up_radius;
for(;;)
{
if ( DistanceSquared( self.origin, level.player.origin ) <= wake_up_radius_sqr )
{
self combat_runner_disable();
return;
}
wait 0.2;
}
}
spawn_func_sandstorm_combat_pather()
{
self endon("death");
self thread spawn_func_sandstorm_combat();
self combat_runner_enable();
self waittill( "reached_path_end" );
self combat_runner_disable();
}
spawn_func_ignore_till_path_end()
{
self.ignoreall = true;
self clearenemy();
self waittill( "reached_path_end" );
self.ignoreall = false;
}
spawn_func_delete_at_path_end()
{
self endon("death");
self waittill( "reached_path_end" );
if( IsDefined( self ) )
{
self Delete();
}
}
spawn_func_chopper_drop_off_land()
{
self ent_flag_init("drop_off");
self ent_flag_wait("drop_off");
self vehicle_detachfrompath();
wait 0.1;
self vehicle_land();
self vehicle_unload();
self ent_flag_wait("unloaded");
self thread vehicle_liftoff();
wait 0.5;
self vehicle_resumepath();
}
chase_ignore_til_pathend_or_damage()
{
self endon( "death" );
self ignore_everything();
self waittill_either( "reached_path_end", "damage" );
self clear_ignore_everything();
}
ignore_everything()
{
self.ignoreall = true;
self.grenadeawareness = 0;
self.ignoreexplosionevents = true;
self.ignorerandombulletdamage = true;
self.ignoresuppression = true;
self.fixednode = false;
self.disableBulletWhizbyReaction = true;
self disable_pain();
self.og_newEnemyReactionDistSq = self.newEnemyReactionDistSq;
self.newEnemyReactionDistSq = 0;
}
clear_ignore_everything()
{
self.ignoreall = false;
self.grenadeawareness = 1;
self.ignoreexplosionevents = false;
self.ignorerandombulletdamage = false;
self.ignoresuppression = false;
self.fixednode = true;
self.disableBulletWhizbyReaction = false;
self enable_pain();
if( IsDefined( self.og_newEnemyReactionDistSq ) )
{
self.newEnemyReactionDistSq = self.og_newEnemyReactionDistSq;
}
}
spawn_func_respawn_on_death()
{
spawner = self.spawner;
if ( IsDefined(spawner) && IsDefined(spawner.script_parameters) )
{
level endon(spawner.script_parameters);
}
self waittill_either( "death", "pain_death" );
wait 1;
guy = undefined;
while ( !IsDefined(guy) && IsDefined(spawner) && IsDefined(spawner.count) && spawner.count > 0 )
{
guy = spawner spawn_ai();
wait 1;
}
}
spawn_func_force_respawn_on_death()
{
spawner = self.spawner;
if ( IsDefined(spawner) && IsDefined(spawner.script_parameters) )
{
level endon(spawner.script_parameters);
}
self waittill_either( "death", "pain_death" );
wait 1;
guy = undefined;
while ( !IsDefined(guy) && IsDefined(spawner) && IsDefined(spawner.count) && spawner.count > 0 )
{
guy = spawner spawn_ai( true );
wait 1;
}
}
spawn_func_target_escape_chopper()
{
if ( IsSentient(self) )
{
self thread thread_target_escape_chopper();
}
else if ( IsDefined(self.riders) )
{
waittillframeend;
foreach ( rider in self.riders )
{
if ( IsDefined( rider ) && IsAlive(rider) )
{
rider thread thread_target_escape_chopper();
}
}
}
}
thread_target_escape_chopper()
{
self notify("thread_target_escape_chopper");
self endon("thread_target_escape_chopper");
self endon("death");
flag_wait("escape_chopper_took_off");
self SetEntityTarget(get_nikolai_chopper());
}
trigger_activate_targetname_safe( trigTN )
{
trig = GetEnt( trigTN, "targetname" );
if( IsDefined( trig ) )
{
trig notify( "trigger" );
}
}
array_wait_any( ents , msg , timeout )
{
setmsg = "array_wait_any_" + msg;
foreach( ent in ents )
{
ent thread array_wait_set( msg , setmsg );
}
if ( !IsDefined( timeout ))
{
level waittill( setmsg );
}
else
{
level waittill_any_timeout( timeout , setmsg );
}
}
array_wait_set( msg , setmsg )
{
self waittill( msg );
level notify( setmsg );
}
ally_chase_setup()
{
self disable_cqbwalk();
self.grenadeawareness = true;
self.ignoreexplosionevents = true;
self.ignorerandombulletdamage = true;
self.disableBulletWhizbyReaction = true;
self disable_pain();
self disable_surprise();
self.pathenemylookahead = 1024;
self enable_heat_behavior(1);
self.baseaccuracy = 50;
}
ally_chase_setup_clear()
{
self.grenadeawareness = false;
self.ignoreexplosionevents = false;
self.ignorerandombulletdamage = false;
self.disableBulletWhizbyReaction = false;
self enable_pain();
self enable_surprise();
self disable_heat_behavior();
self.moveplaybackrate = 1;
}
custom_move_to( goal, customMoveAnim, resetWhenDone )
{
self disable_cqbwalk();
self set_generic_run_anim( customMoveAnim, true );
self.disablearrivals = true;
self.disableexits = true;
self.goalradius = 32;
self setgoalnode( goal );
self waittill( "goal" );
self setgoalpos( self.origin );
if ( IsDefined( resetWhenDone ) && resetWhenDone == true )
{
custom_move_reset();
}
}
custom_move_reset()
{
self clear_run_anim();
self.disablearrivals = false;
self.disableexits = false;
}
activate_crush_player_mode( rush_player )
{
if ( !IsDefined( self.crush_player_mode ) )
{
self.crush_player_mode = true;
self.perfectAim = true;
if ( IsAlive(self) )
{
self.health *= 3;
}
self.maxhealth *= 3;
if ( !ThreatBiasGroupExists( "player" ) )
{
CreateThreatBiasGroup( "player" );
level.player.orig_threat_bias_group = level.player GetThreatBiasGroup();
}
if ( !ThreatBiasGroupExists( "crush_player" ) )
{
CreateThreatBiasGroup( "crush_player" );
SetThreatBias( "crush_player", "player", 10000 );
}
level.player SetThreatBiasGroup("player");
self.orig_threat_bias_group = self GetThreatBiasGroup();
self SetThreatBiasGroup( "crush_player" );
if ( IsDefined( rush_player ) && rush_player )
{
thread player_seek();
}
}
}
activate_crush_player_mode_all( rush_player )
{
ai = getaiarray( "axis" );
array_thread( ai , ::activate_crush_player_mode , rush_player );
}
deactivate_crush_player_mode()
{
if ( IsDefined( self.crush_player_mode ) )
{
self.crush_player_mode = undefined;
self.perfectAim = false;
self.maxhealth = int( self.maxhealth / 3 );
if ( IsAlive(self) )
{
newHealth = int(Max(1,int(Min(self.health, self.maxhealth))));
self.health = newHealth;
}
self SetThreatBiasGroup( self.orig_threat_bias_group );
enemies = getaiarray( "axis" );
foreach( guy in enemies )
{
if ( IsAlive(guy) && IsDefined(guy.crush_player_mode) )
{
return;
}
}
level.player SetThreatBiasGroup(level.player.orig_threat_bias_group);
}
}
deactivate_crush_player_mode_all()
{
ai = getaiarray( "axis" );
array_thread( ai , ::deactivate_crush_player_mode );
}
init_color_trigger_listeners( script_noteworthy_name , disable_all_previous )
{
if ( !IsDefined( disable_all_previous ))
{
disable_all_previous = false;
}
if ( disable_all_previous )
{
if ( !IsDefined( level.payback_color_trigger_disable_previous ))
{
level.payback_color_trigger_disable_previous = [];
}
level.payback_color_trigger_disable_previous[script_noteworthy_name] = true;
}
color_triggers = GetEntArray( script_noteworthy_name , "script_noteworthy" );
foreach ( trigger in color_triggers )
{
if ( disable_all_previous )
{
tokens = StrTok( trigger.targetname , "_" );
color_value = tokens[tokens.size-1];
trigger.payback_color_value = Int( color_value );
}
trigger thread payback_color_trigger_listener();
}
}
payback_color_trigger_listener()
{
self endon( "disable_trigger" );
self.payback_color_trigger_active = true;
self waittill( "trigger" );
otherTriggers = [];
if ( IsDefined(level.payback_color_trigger_disable_previous) && IsDefined( level.payback_color_trigger_disable_previous[self.script_noteworthy] ))
{
tempTriggers = GetEntArray( self.script_noteworthy , "script_noteworthy" );
foreach ( trigger in tempTriggers )
{
if ( trigger.payback_color_trigger_active
&& trigger.payback_color_value <= self.payback_color_value )
{
otherTriggers[otherTriggers.size] = trigger;
trigger.payback_color_trigger_active = false;
}
}
}
else
{
otherTriggers = GetEntArray( self.targetname , "targetname" );
}
foreach ( trigger in otherTriggers )
{
trigger notify("disable_trigger");
trigger trigger_off();
}
}
chopper_init_fog_brushes()
{
level.chopper_fog_brushes = GetEntArray( "chopper_fog_brush", "targetname" );
foreach ( brush in level.chopper_fog_brushes )
{
brush Hide();
brush NotSolid();
if ( IsDefined(level.chopper) )
{
brush.origin = level.chopper.origin;
brush LinkTo( level.chopper );
}
}
}
notify_on_trigger(trigger_target_name)
{
flag_init( trigger_target_name );
triggers = GetEntArray(trigger_target_name, "targetname");
foreach (trigger in triggers)
{
trigger thread notify_on_trigger_thread(self, trigger_target_name);
}
}
notify_on_trigger_thread(notifyTarget, trigger_target_name)
{
notifyTarget endon(trigger_target_name);
self waittill( "trigger", eOther );
thread flag_set_delayed( trigger_target_name, 0.05 );
level notify( trigger_target_name, eOther );
notifyTarget notify(trigger_target_name, eOther);
}
explosion_ragdoll_fling(victim_species, origin, exp_radius, grenade_force)
{
victims = GetAISpeciesArray( victim_species, "all" );
foreach (victim in victims)
{
if ( IsDefined(victim) && (Distance(victim.origin, origin) <= exp_radius) )
{
victim.flashlight_off_delay = 2.0;
victim notify("flashlight_off_delayed");
victim StartRagdoll();
victim DoDamage(victim.health, (0,0,0));
}
}
wait 0.1;
PhysicsExplosionSphere( origin - (0,0,exp_radius / 4), exp_radius, exp_radius / 2, grenade_force );
}
randomize_normal( inNormal, randFrac )
{
randomVector = VectorNormalize( (RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 )) );
randomVectorSign = 1;
if ( VectorDot( randomVector, inNormal ) < 0 )
{
randomVectorSign = -1;
}
normalFactor = ( 1.0 - randFrac ) * inNormal;
randomFactor = ( randomVectorSign * randFrac ) * randomVector;
return VectorNormalize( normalFactor + randomFactor );
}
wait_till_stopped( freq )
{
wait 0.1;
if ( !IsDefined( freq ) )
{
freq = 0.1;
}
for(;;)
{
last_org = self.origin;
last_ang = self.angles;
wait freq;
if ( last_org == self.origin && last_ang == self.angles )
{
break;
}
}
}
oscillate_entity( dir, amp, freq, debug )
{
self endon("death");
base = self.origin;
dir = VectorNormalize(dir);
waittime = ( 1.0 / freq );
if ( IsDefined( debug ) )
{
self thread oscillate_entity_debug();
}
for(;;)
{
self MoveTo( base + ( dir * amp ), waittime, .05, .05 );
wait waittime;
self MoveTo( base + ( dir * amp * -1 ), waittime, .05, .05 );
wait waittime;
}
}
oscillate_entity_debug( )
{
self endon("death");
for (;;)
{
{
line( self.origin - (0,0,25), self.origin + (0,0,25), (1, 0, 0) );
line( self.origin - (0,25,0), self.origin + (0,25,0), (1, 0, 0) );
}
wait 0.05;
}
}
drop_to_floor()
{
trace = bullettrace( self.origin + ( 0, 0, 32 ), self.origin, false, undefined );
self.origin = trace[ "position" ];
}
combat_runner_enable()
{
self.grenadeawareness = 0;
self.notarget = true;
self.ignoreme = true;
self.ignoresuppression = true;
self.suppressionwait_old = self.suppressionwait;
self.suppressionwait = 0;
self.disableBulletWhizbyReaction = true;
}
combat_runner_disable()
{
self.grenadeawareness = 1;
self.notarget = false;
self.ignoreme = false;
self.ignoresuppression = false;
self.suppressionwait = self.suppressionwait_old;
self.suppressionwait_old = undefined;
self.disableBulletWhizbyReaction = false;
}
temp_dialogue( speaker, text, duration )
{
level notify("temp_dialogue", speaker, text, duration);
level endon("temp_dialogue");
if ( !IsDefined( duration ) )
{
duration = 4;
}
if ( IsDefined( level.tmp_subtitle ) )
{
level.tmp_subtitle destroy();
level.tmp_subtitle = undefined;
}
level.tmp_subtitle = newHudElem();
level.tmp_subtitle.x = -60;
level.tmp_subtitle.y = -62;
level.tmp_subtitle settext( "^2" + speaker + ": ^7" + text );
level.tmp_subtitle.fontScale = 1.46;
level.tmp_subtitle.alignX = "center";
level.tmp_subtitle.alignY = "middle";
level.tmp_subtitle.horzAlign = "center";
level.tmp_subtitle.vertAlign = "bottom";
level.tmp_subtitle.sort = 1;
wait duration;
thread temp_dialogue_fade();
}
temp_dialogue_fade()
{
level endon("temp_dialogue");
for ( alpha = 1.0; alpha > 0.0; alpha -= 0.1 )
{
level.tmp_subtitle.alpha = alpha;
wait 0.05;
}
level.tmp_subtitle destroy();
}
set_black_fade( black_amount, fade_duration )
{
level notify("set_black_fade", black_amount, fade_duration);
level endon("set_black_fade");
if ( !IsDefined( black_amount ) )
{
black_amount = 1;
}
black_amount = max(0.0, min(1.0, black_amount));
if ( !IsDefined( fade_duration ) )
{
fade_duration = 1;
}
fade_duration = max(0.01, fade_duration);
if ( !IsDefined( level.hud_black ) )
{
level.hud_black = NewHudElem();
level.hud_black.x = 0;
level.hud_black.y = 0;
level.hud_black.horzAlign = "fullscreen";
level.hud_black.vertAlign = "fullscreen";
level.hud_black.foreground = true;
level.hud_black.sort = -999;
level.hud_black SetShader("black", 650, 490);
level.hud_black.alpha = 0.0;
}
level.hud_black FadeOverTime(fade_duration);
level.hud_black.alpha = max(0.0, min(1.0, black_amount));
if ( black_amount <= 0 )
{
wait fade_duration;
level.hud_black destroy();
level.hud_black = undefined;
}
}
greater_dot( guy, other )
{
return guy.dot > other.dot;
}
lesser_dot( guy, other )
{
return guy.dot < other.dot;
}
insert_in_array( array, guy, compare_func )
{
newarray = [];
inserted = false;
for ( i = 0; i < array.size; i++ )
{
if ( !inserted )
{
if ( [[ compare_func ]]( array[ i ], guy ) )
{
newarray[ newarray.size ] = guy;
inserted = true;
}
}
newarray[ newarray.size ] = array[ i ];
}
if ( !inserted )
{
newarray[ newarray.size ] = guy;
}
return newarray;
}
get_array_within_fov( org, forward, ai, dot_range )
{
guys = [];
guys[ true ] = [];
guys[ false ] = [];
compare_dots[ true ] = ::lesser_dot;
compare_dots[ false ] = ::lesser_dot;
for ( i = 0; i < ai.size; i++ )
{
guy = ai[ i ];
normal = vectorNormalize( guy.origin - org );
dot = vectorDot( forward, normal );
guy.dot = dot;
in_range = dot >= dot_range;
guys[ in_range ] = insert_in_array( guys[ in_range ], guy, compare_dots[ in_range ] );
}
return guys;
}
get_cantrace_array( ai )
{
guys = [];
eyepos = self geteye();
for ( i = 0; i < ai.size; i++ )
{
if ( !( bullettracepassed( eyepos, ai[ i ] GetTagOrigin( "tag_eye" ), false, undefined ) ) )
{
continue;
}
guys[ guys.size ] = ai[ i ];
}
return guys;
}
unlimited_ammo_till( event, timeout )
{
self notify( "unlimited_ammo_till" );
self endon( "unlimited_ammo_till" );
if ( IsDefined( event ) )
{
level endon( event );
self endon( event );
}
duration = 0;
for(;;)
{
if ( IsDefined( timeout ) && duration >= timeout )
{
return;
}
weap = self GetCurrentWeapon();
if ( weap != "none" )
{
curAmt = self GetCurrentWeaponClipAmmo();
clipSize = WeaponClipSize(weap);
if ( IsDefined(clipSize) )
{
giveAmt = clipSize - curAmt;
if ( IsDefined(giveAmt) && giveAmt > 0 )
{
self SetWeaponAmmoClip(weap, curAmt + giveAmt);
}
}
}
wait 0.05;
duration += 0.05;
}
}
phantom_pressure( target_ent, weapon_type, source_array, min_rate, max_rate, min_range, max_range, accuracy )
{
level notify( "phantom_pressure" );
level endon( "phantom_pressure" );
for(;;)
{
if ( !IsDefined(target_ent) )
{
return;
}
radius = 500;
source = source_array[ RandomInt(source_array.size) ];
if ( IsDefined( source.radius ) )
{
radius = source.radius;
}
rand_vec = VectorNormalize( ( RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ) ) );
if ( VectorDot( rand_vec, ( 0, 0, 1 ) ) < 0 )
{
rand_vec = rand_vec * -1;
}
rand_vec = rand_vec * RandomFloatRange( 0, radius );
shot_origin = source.origin + rand_vec;
dir = shot_origin - target_ent.origin;
dist = Length(dir);
dir = VectorNormalize(dir);
target_offset = VectorToAngles( dir );
target_offset = AnglesToUp( target_offset );
target_offset = randomize_normal( target_offset, 0.6 );
offset_dist = 200;
if ( RandomInt( 4 ) == 0 )
{
target_offset *= -1;
offset_dist = 50;
}
if ( IsDefined(accuracy) )
{
offset_dist *= 1.0/accuracy;
}
target_offset *= RandomFloatRange( offset_dist, offset_dist + 50 );
target = target_ent.origin + target_offset + ( dir * -1000 );
trace = BulletTrace( shot_origin, target, true );
hit_ent = trace[ "entity" ];
if ( !IsDefined( hit_ent ) || !IsDefined( hit_ent.team ) || (hit_ent.team != level.player.team) )
{
magicbullet(weapon_type, shot_origin, target);
aud_send_msg("magic_bullet_fire", shot_origin);
}
waitTime = RandomFloatRange( min_rate, (min_rate * 2) );
ease_off = ( dist - min_range ) / ( max_range - min_range );
if ( ease_off > 0 )
{
diff = max_rate - (min_rate * 2);
waitTime += RandomFloatRange(diff * 0.5, diff);
}
wait waitTime;
}
}
moderate_ai_moveplaybackrate( endon_notify , min_playback , max_playback , min_dist , max_dist ,
min_sprint , max_sprint , min_sprint_dist , max_sprint_dist ,
max_speed_dif , max_dist_dif , distance_mods , ai )
{
level endon( endon_notify );
range_dist = max_dist - min_dist;
range_playback = max_playback - min_playback;
range_sprint = max_sprint - min_sprint;
range_sprint_dist = max_sprint_dist - min_sprint_dist;
for ( ;; )
{
center = (0,0,0);
ai_dist = [];
foreach ( index, guy in ai )
{
center += guy.origin;
dist = distance( guy.origin, level.friendly_endpoint );
ai_dist[ index ] = dist + distance_mods[ index ];
}
center /= ai.size;
lowest = 99999999;
foreach ( dist in ai_dist )
{
if ( dist < lowest )
lowest = dist;
}
ai_speedmod = [];
foreach ( index, dist in ai_dist )
{
ai_dist[ index ] -= lowest;
}
highest = 0;
foreach ( dist in ai_dist )
{
if ( dist > highest )
highest = dist;
}
current_speed_dif = highest * max_speed_dif / max_dist_dif;
current_speed_dif *= 0.5;
if ( current_speed_dif > max_speed_dif )
current_speed_dif = max_speed_dif;
half_range = highest * 0.5;
ai_speedmod = [];
foreach ( index, dist in ai_dist )
{
dist -= half_range;
dist /= abs( half_range );
ai_speedmod[ index ] = dist * current_speed_dif;
}
dist1 = distance( center, level.friendly_endpoint );
dist2 = distance( level.player.origin, level.friendly_endpoint );
dist = dist2 - dist1;
level notify( "player_dist_from_squad", dist );
old_dist = dist;
dist -= min_dist;
scale = dist / range_dist;
if ( scale < 0 )
scale = 0;
else
if ( scale > 1 )
scale = 1;
scale = 1 - scale;
ai_playback = min_playback + range_playback * scale;
dist = old_dist - min_sprint_dist;
scale = dist / range_sprint_dist;
if ( scale < 0 )
scale = 0;
else
if ( scale > 1 )
scale = 1;
sprint_speed = min_sprint + range_sprint * scale;
setsaveddvar( "player_sprintSpeedScale", sprint_speed );
if ( true )
{
foreach ( index, guy in ai )
{
guy.moveplaybackrate = ai_playback + ai_speedmod[ index ];
if ( guy.moveplaybackrate > 1.15 )
guy.moveplaybackrate = 1.15;
}
}
wait( 0.05 );
}
}
process_ai_script_parameters()
{
if ( !isdefined( self.script_parameters ) )
return;
parms = strtok( self.script_parameters, ":;, " );
foreach( parm in parms )
{
parm = tolower( parm );
if ( parm == "balcony" )
self.deathFunction = ::try_balcony_death;
}
}
try_balcony_death()
{
if ( !isdefined( self ) )
return false;
if ( self.a.pose == "prone" )
return false;
if ( !isdefined( self.prevnode ) )
return false;
if ( !isdefined( self.prevnode.script_balcony ) )
return false;
angleAI = self.angles[ 1 ];
angleNode = self.prevnode.angles[ 1 ];
angleDiff = abs( AngleClamp180( angleAI - angleNode ) );
if ( angleDiff > 45 )
return false;
d = distance( self.origin, self.prevnode.origin );
if ( d > 16 )
return false;
if ( isdefined( level.last_balcony_death ) )
{
elapsedTime = getTime() - level.last_balcony_death;
if ( elapsedTime < 5 * 1000 )
return false;
}
trigger_balcony = GetEntArray( "trigger_balcony", "targetname" );
foreach ( trigger in trigger_balcony )
{
d = Distance( trigger.origin, self.origin );
if ( d < 48 )
{
trigger notify( "trigger" );
}
}
GlassRadiusDamage( self.origin, 48, 500, 500 );
level.last_balcony_death = getTime();
deathAnims = getGenericAnim( "balcony_death" );
self.deathanim = deathAnims[ RandomInt( deathAnims.size ) ];
return false;
}
wait_until_enemies_in_volume( vol, num_in )
{
checkvol= GetEnt( vol ,"targetname");
AssertEx( IsDefined(checkvol), "volume undefined " + vol );
enemies = checkvol get_ai_touching_volume( "axis" );
numenemies = enemies.size;
while( numenemies > num_in)
{
wait 1;
enemies = checkvol get_ai_touching_volume( "axis" );
numenemies = enemies.size;
if( numenemies - num_in < 3 )
{
foreach( enemy in enemies )
{
if( enemy doingLongDeath() || enemy.delayedDeath )
{
numenemies --;
}
}
}
}
}
moderate_reset( ai )
{
setsaveddvar( "player_sprintSpeedScale", 1.5 );
foreach ( index, guy in ai )
{
guy.moveplaybackrate = 1;
}
}
payback_array_waittill_combat( ai , id )
{
foreach( soldier in ai )
{
thread payback_waittill_combat_internal( soldier , id );
}
level waittill( "sandstorm_combat_" + id );
}
payback_waittill_combat_internal( soldier , id )
{
soldier waittill_any( "enemy" , "death" , "damage" );
level notify( "sandstorm_combat_" + id );
}
play_vo( msg, radio )
{
level function_stack( ::play_vo_internal, self, msg, radio );
}
play_vo_internal( guy, msg, radio )
{
if ( IsDefined( radio ) && radio )
{
guy radio_dialogue( msg );
}
else
{
guy dialogue_queue( msg );
}
}
raven_player_can_see_ai( ai, latency )
{
currentTime = getTime();
if ( !isdefined( latency ) )
latency = 0;
if ( isdefined( ai.playerSeesMeTime ) && ai.playerSeesMeTime + latency >= currentTime )
{
assert( isdefined( ai.playerSeesMe ) );
return ai.playerSeesMe;
}
ai.playerSeesMeTime = currentTime;
if ( !within_fov( level.player.origin, level.player.angles, ai.origin, 0.766 ) )
{
ai.playerSeesMe = false;
return false;
}
playerEye = level.player GetEye();
feetOrigin = ai.origin;
if ( SightTracePassed( playerEye, feetOrigin, false, level.player ) )
{
ai.playerSeesMe = true;
return true;
}
eyeOrigin = ai GetEye();
if ( SightTracePassed( playerEye, eyeOrigin, false, level.player ) )
{
ai.playerSeesMe = true;
return true;
}
midOrigin = ( eyeOrigin + feetOrigin ) * 0.5;
if ( SightTracePassed( playerEye, midOrigin, false, level.player ) )
{
ai.playerSeesMe = true;
return true;
}
ai.playerSeesMe = false;
return false;
}
tv_trigger_wait_enter( movieName, soundName )
{
self notify("tv_trigger_wait_enter");
self endon("tv_trigger_wait_enter");
for (;;)
{
self waittill( "trigger", eOther );
level thread tv_movies_play( movieName, soundName );
self tv_trigger_wait_leave( eOther );
}
}
tv_trigger_wait_leave( eOther )
{
self notify("tv_trigger_wait_leave");
self endon("tv_trigger_wait_leave");
level endon("tv_movies_played");
while ( IsAlive( eOther ) && eOther IsTouching( self ) )
{
wait 0.05;
}
tv_movies_stop();
level.tv_movie_name = undefined;
level.tv_sound_name = undefined;
}
tv_movies_play( newMovieName, newSoundName )
{
level notify("tv_movies_play");
level endon("tv_movies_play");
level endon("tv_movies_stop");
if ( IsDefined(newMovieName) )
{
level.tv_movie_name = newMovieName;
}
if ( IsDefined(newSoundName) )
{
level.tv_sound_name = newSoundName;
}
while ( IsDefined(level.tv_movie_name) && level.tv_movie_name != "" )
{
level notify("tv_movies_played");
SetSavedDvar( "cg_cinematicFullScreen", "0" );
CinematicInGame( level.tv_movie_name );
tvs = GetEntArray( "interactive_tv", "targetname" );
foreach ( tv in tvs )
{
if ( !IsDefined( tv.is_destroyed ) )
{
if ( IsDefined( level.tv_sound_name ) && level.tv_sound_name != "" )
{
tv PlayLoopSound( level.tv_sound_name );
}
tv thread tv_death();
}
}
wait(.05);
while ( IsCinematicPlaying() )
{
wait( 1 );
}
}
}
tv_movies_stop()
{
level notify("tv_movies_stop");
StopCinematicInGame();
tvList = GetEntArray( "interactive_tv", "targetname" );
foreach ( tv in tvList )
{
tv notify("tv_death");
tv StopLoopSound();
}
}
tv_death()
{
self notify( "tv_death" );
self endon( "tv_death" );
self waittill_any( "death", "destroyed" );
self.is_destroyed = true;
self StopLoopSound();
}
custom_in_game_movie( movieName, preDelay, waitTime )
{
level notify("custom_in_game_movie");
level endon("custom_in_game_movie");
tv_movies_stop();
if ( IsDefined( preDelay ) && preDelay > 0 )
{
wait preDelay;
}
SetSavedDvar( "cg_cinematicFullScreen", "0" );
CinematicInGame( movieName );
wait waitTime;
level thread tv_movies_play();
}
texploder(num,offset)
{
if (!IsDefined(offset))
{
offset = .05;
}
num += "";
if (!IsDefined(level.triggerfxarray))
{
level.triggerfxarray = [];
}
level.triggerfxarray["num"] = [];
for ( i = 0;i < level.createFXent.size;i++ )
{
ent = level.createFXent[ i ];
if ( isdefined( ent ) && ( ent.v[ "type" ] == "exploder" ) && (ent.v[ "exploder" ] + "" == num ))
{
createfxOrigin = ent.v[ "origin" ];
fx_up = anglestoup(createfxOrigin);
createfxAngle = ent.v[ "angles" ];
fx_fwd = anglestoforward(createfxAngle);
effect = spawnFx( level._effect[ent.v["fxid"]] , ent.v["origin"],fx_fwd, fx_up );
triggerFx( effect, offset);
level.triggerfxarray["num"][level.triggerfxarray["num"].size] = effect;
}
}
}
texploder_delete(num)
{
if (IsDefined(level.triggerfxarray["num"]))
{
level.triggerfxarray["num"] =array_removeUndefined(level.triggerfxarray["num"] );
new_array = level.triggerfxarray["num"];
array_delete(level.triggerfxarray["num"]);
array_removeUndefined(level.triggerfxarray["num"]);
}
}
toggle_hud_elements( compass , ammo , stance , slots, crosshair )
{
AssertEx( !IsDefined( compass ) , "You didn't specify if you wanted to hide or show the compass" );
if( compass == 0 )
{
SetSavedDvar( "compass", 0 );
}
else
{
SetSavedDvar( "compass", 1 );
}
AssertEx( !IsDefined( ammo ) , "You didn't specify if you wanted to hide or show the ammo" );
if( ammo == 0 )
{
SetSavedDvar( "ammoCounterHide", 1 );
}
else
{
SetSavedDvar( "ammoCounterHide", 0 );
}
AssertEx( !IsDefined( stance ) , "You didn't specify if you wanted to hide or show the stance" );
if( stance == 0 )
{
SetSavedDvar( "hud_showstance", 0 );
}
else
{
SetSavedDvar( "hud_showstance", 1 );
}
AssertEx( !IsDefined( slots ) , "You didn't specify if you wanted to hide or show the slots" );
if( slots == 0 )
{
SetSavedDvar( "actionSlotsHide", 1 );
}
else
{
SetSavedDvar( "actionSlotsHide", 0 );
}
AssertEx( !IsDefined( crosshair ) , "You didn't specify if you wanted to hide or show the crosshair" );
if( crosshair == 0 )
{
SetSavedDvar( "hud_drawhud", 0 );
}
else
{
SetSavedDvar( "hud_drawhud", 1 );
}
}