#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_hud_util;
paris_equip_player()
{
}
teleport_to_scriptstruct(name)
{
scriptstruct = GetStruct(name, "script_noteworthy");
level.player SetOrigin(scriptstruct.origin);
if(IsDefined(scriptstruct.angles))
level.player SetPlayerAngles(scriptstruct.angles);
allies = GetEntArray("hero", "script_noteworthy");
foreach(ally in allies)
{
if(IsSpawner(ally)) allies = array_remove(allies, ally);
}
ally_structs = GetStructArray(scriptstruct.target, "targetname");
for(i = 0; i < allies.size; i++)
{
if(i < ally_structs.size)
{
allies[i] ForceTeleport(ally_structs[i].origin, ally_structs[i].angles);
allies[i] SetGoalPos(ally_structs[i].origin);
}
else
{
allies[i] ForceTeleport(level.player.origin, level.player.angles);
allies[i] SetGoalPos(level.player.origin);
}
}
}
getent_safe(name, type)
{
ret = GetEnt(name, type);
return ret;
}
spawn_metrics_init()
{
level.spawn_metrics_spawn_count = [];
level.spawn_metrics_death_count = [];
add_global_spawn_function("axis", ::spawn_metrics_spawn_func);
foreach(guy in GetAIArray("axis"))
{
if(!IsSpawner(guy) && IsAlive(guy))
{
guy spawn_metrics_spawn_func();
}
}
}
spawn_metrics_spawn_func()
{
Assert(IsDefined(self));
Assert(IsAlive(self));
Assert(!IsSpawner(self));
Assert(IsAI(self));
if(IsDefined(self.script_noteworthy))
{
if(IsDefined(level.spawn_metrics_spawn_count[self.script_noteworthy]))
{
level.spawn_metrics_spawn_count[self.script_noteworthy] += 1;
}
else
{
level.spawn_metrics_spawn_count[self.script_noteworthy] = 1;
}
self thread spawn_metrics_death_watcher();
}
}
spawn_metrics_death_watcher()
{
Assert(IsDefined(self));
Assert(IsDefined(self.script_noteworthy));
orig_script_noteworthy = self.script_noteworthy;
self waittill("death");
if(IsDefined(level.spawn_metrics_death_count[orig_script_noteworthy]))
{
level.spawn_metrics_death_count[orig_script_noteworthy] += 1;
}
else
{
level.spawn_metrics_death_count[orig_script_noteworthy] = 1;
}
}
spawn_metrics_number_spawned(script_noteworthy)
{
if(IsArray(script_noteworthy))
{
sum = 0;
foreach(nw in script_noteworthy)
sum += spawn_metrics_number_spawned(nw);
return sum;
}
if(IsDefined(level.spawn_metrics_spawn_count[script_noteworthy]))
return level.spawn_metrics_spawn_count[script_noteworthy];
else
return 0;
}
spawn_metrics_number_died(script_noteworthy)
{
if(IsArray(script_noteworthy))
{
sum = 0;
foreach(nw in script_noteworthy)
sum += spawn_metrics_number_died(nw);
return sum;
}
if(IsDefined(level.spawn_metrics_death_count[script_noteworthy]))
return level.spawn_metrics_death_count[script_noteworthy];
else
return 0;
}
spawn_metrics_number_alive(script_noteworthy)
{
return spawn_metrics_number_spawned(script_noteworthy) - spawn_metrics_number_died(script_noteworthy);
}
spawn_metrics_waittill_count_reaches(count, noteworthies, debug)
{
if(!IsArray(noteworthies)) noteworthies = [noteworthies];
waittillframeend;
for(;; wait 1)
{
current = 0;
foreach(noteworthy in noteworthies)
{
current += spawn_metrics_number_alive(noteworthy);
}
if(current <= count)
{
break;
}
}
}
spawn_metrics_waittill_deaths_reach(death_count, noteworthies, debug)
{
if(!IsArray(noteworthies)) noteworthies = [noteworthies];
for(;; wait 1)
{
deaths = 0;
foreach(noteworthy in noteworthies)
{
deaths += spawn_metrics_number_died(noteworthy);
}
if(deaths >= death_count)
{
break;
}
}
}
delete_spawners(noteworthies)
{
if(!IsArray(noteworthies)) noteworthies = [noteworthies];
foreach(noteworthy in noteworthies)
{
foreach(spawner in GetEntArray(noteworthy, "script_noteworthy"))
{
if(IsSpawner(spawner))
{
spawner Delete();
}
}
}
}
array_filter(array, method)
{
result = [];
foreach(key, value in array)
{
if(self [[method]](value))
{
result[key]	= value;
}
}
return result;
}
cleanup_ai_with_script_noteworthy(script_noteworthy, distance)
{
if(!IsDefined(distance))
{
distance = 512;
}
ai_array = [];
foreach(ai_or_spawner in GetEntArray(script_noteworthy, "script_noteworthy"))
{
if(IsSpawner(ai_or_spawner))
{
ai_or_spawner Delete();
}
else
{
ai_array[ai_array.size] = ai_or_spawner;
}
}
thread AI_delete_when_out_of_sight(ai_array, distance);
}
anim_generic_set_rate_single( guys, anime, rate )
{
array_thread( guys, ::anim_set_rate_internal, anime, rate, "generic" );
}
goto_node(node_or_script_noteworthy, bWait, radius)
{
self endon("stop_goto_node");
if(!IsDefined(radius)) radius = 16;
self set_goal_radius(radius);
if(IsString(node_or_script_noteworthy))
{
node = GetNode(node_or_script_noteworthy, "script_noteworthy");
}
else
{
node = node_or_script_noteworthy;
}
if(IsDefined(node))
{
self set_goal_node(node);
}
else
{
node = GetStruct(node_or_script_noteworthy, "script_noteworthy");
AssertEx(IsDefined(node), "Couldn't find node or struct with script_noteworthy " + node_or_script_noteworthy);
self set_goal_pos(node.origin);
}
if(bWait)
{
self waittill("goal");
}
}
animname_not_overridden(guy)
{
return !(guy animname_is_overridden());
}
animname_override(new_animname)
{
AssertEx(!IsDefined(self.old_animname), "Tried to override animname " + to_str(self.old_animname) + " to " + to_str(new_animname) + " but it was already overridden to " + to_str(self.animname));
self.old_animname = self.animname;
self.animname = new_animname;
self.animname_overridden = true;
}
animname_restore()
{
AssertEx(animname_is_overridden(), "called animname_restore() without first calling animname_override() on " + to_str(self.animname));
self.animname = self.old_animname;
self.old_animname = undefined;
self.animname_overridden = undefined;
}
animname_is_overridden()
{
return IsDefined(self.animname_overridden);
}
to_str(obj)
{
if(!IsDefined(obj)) obj = "(undefined)";
return obj + "";
}
anim_set_rate_single_delay(guy, scene, rate)
{
waittillframeend;
self anim_set_rate_single(guy, scene, rate);
wait(0.05);
self anim_set_rate_single(guy, scene, rate);
}
waittill_range_or_eta(origin, min_range, min_eta)
{
AssertEx(IsPlayer(self), "waittill_range_or_eta() only works on players");
for(;; waitframe())
{
self_to_origin = origin - self.origin;
range = Length(self_to_origin);
if(range < min_range)
break;
projected_velocity = VectorDot(self GetVelocity(), VectorNormalize(self_to_origin));
if(projected_velocity > 0)
{
eta = range / projected_velocity;
if(eta < min_eta)
break;
}
}
}
_waittill(msg)
{
self waittill(msg);
}
fade_in( fade_time )
{
if ( level.MissionFailed )
return;
level notify( "now_fade_in" );
black_overlay = get_black_overlay();
if ( fade_time )
black_overlay FadeOverTime( fade_time );
black_overlay.alpha = 0;
wait( fade_time );
}
fade_out( fade_out_time )
{
black_overlay = get_black_overlay();
if ( fade_out_time )
black_overlay FadeOverTime( fade_out_time );
black_overlay.alpha = 1;
wait( fade_out_time );
}
get_black_overlay()
{
if ( !IsDefined( level.black_overlay ) )
level.black_overlay = create_client_overlay( "black", 0, level.player );
level.black_overlay.sort = -1;
level.black_overlay.foreground = false;
return level.black_overlay;
}
disable_enemy_grenades()
{
add_global_spawn_function("axis", ::disable_grenades);
foreach(guy in GetAIArray("axis"))
{
if(IsAlive(guy))
{
guy disable_grenades();
}
}
}
enable_enemy_grenades()
{
remove_global_spawn_function("axis", ::disable_grenades);
foreach(guy in GetAIArray("axis"))
{
if(IsAlive(guy))
{
guy enable_grenades();
}
}
}
disable_grenades()
{
Assert(IsAI(self), "disable_grenades() is for AI");
if(IsDefined(self.grenadeammo) && !IsDefined(self.oldgrenadeammo))
self.oldgrenadeammo = self.grenadeammo;
self.grenadeammo = 0;
}
enable_grenades()
{
Assert(IsAI(self), "enable_grenades() is for AI");
if(IsDefined(self.oldgrenadeammo))
{
self.grenadeammo = self.oldgrenadeammo;
self.oldgrenadeammo = undefined;
}
}
spawn_corpses(targetname, anime_override)
{
corpses = [];
foreach(corpse_spawner in GetEntArray(targetname, "targetname"))
{
if(IsSpawner(corpse_spawner))
{
anime = corpse_spawner.script_noteworthy;
if(IsDefined(anime_override))
{
anime = anime_override;
}
corpses[corpses.size] = spawn_corpse(corpse_spawner, anime, corpse_spawner.origin, corpse_spawner.angles);
}
}
structs = getstructarray(targetname, "targetname");
foreach(corpse_struct in structs)
{
AssertEx(IsDefined(corpse_struct.script_noteworthy), "Corpse struct needs script_noteworthy of the classname of actor to spawn");
spawner_classname = corpse_struct.script_noteworthy;
spawners = GetEntArray(spawner_classname, "classname");
spawner = undefined;
foreach(possible_spawner in spawners)
{
if(IsSpawner(possible_spawner) && IsDefined(possible_spawner.script_noteworthy) && possible_spawner.script_noteworthy == "corpse_spawner")
{
spawner = possible_spawner;
break;
}
}
if(IsDefined(spawner))
{
AssertEx(IsDefined(corpse_struct.script_animation), "Corpse struct needs script_animation set to the anime of the animation");
corpses[corpses.size] = spawn_corpse(spawner, corpse_struct.script_animation, corpse_struct.origin, corpse_struct.angles);
}
else
{
AssertEx(false, "couldn't find spawner with classname " + spawner_classname + "and script_noteworthy corpse_spawner for spawning a corpse (NOTE: classnames are case-sensitive)");
}
}
return corpses;
}
spawn_corpse(spawner, anime, origin, angles)
{
spawner.count++;
corpse_drone = undefined;
while(true)
{
corpse_drone = spawner spawn_ai( true );
if(IsDefined(corpse_drone))
break;
waitframe();
}
if(IsDefined(corpse_drone))
{
corpse_drone.animname = "generic";
corpse_drone gun_remove();
corpse_drone ForceTeleport(origin, angles);
sAnim = corpse_drone getanim(anime);
corpse_drone anim_generic_first_frame(corpse_drone, anime);
dummy = maps\_vehicle_aianim::convert_guy_to_drone(corpse_drone);
dummy SetAnim( sAnim, 1, .2 );
dummy NotSolid();
return dummy;
}
}
vehicle_scripted_animation_wait(anim_ent, animation)
{
Assert(IsDefined(anim_ent));
Assert(IsDefined(anim_ent.origin));
Assert(IsDefined(anim_ent.angles));
if(IsString(animation)) animation = self getanim(animation);
start_origin = GetStartOrigin(anim_ent.origin, anim_ent.angles, animation);
start_angles = GetStartAngles(anim_ent.origin, anim_ent.angles, animation);
start_forward = AnglesToForward(start_angles);
while(Distance(start_origin, self.origin) > 512 || VectorDot(start_origin - self.origin, start_forward) > 0)
{
waitframe();
}
}
vehicle_scripted_animation(anim_ent, animation, should_pop, pop_flatten_only, vehicle_end_node, rate, print_debug_info)
{
self endon("death");
Assert(IsDefined(anim_ent));
Assert(IsDefined(anim_ent.origin));
Assert(IsDefined(anim_ent.angles));
if(!IsDefined(should_pop)) should_pop = true;
if(!IsDefined(pop_flatten_only)) pop_flatten_only = false;
if(!IsDefined(rate)) rate = 1;
if(!IsDefined(print_debug_info)) print_debug_info = false;
if(IsString(animation)) animation = self getanim(animation);
start_origin = GetStartOrigin(anim_ent.origin, anim_ent.angles, animation);
start_angles = GetStartAngles(anim_ent.origin, anim_ent.angles, animation);
vehicle_origin = self.origin;
vehicle_angles = self.angles;
if(should_pop)
{
if(pop_flatten_only)
{
vehicle_angles = (start_angles[0], self.angles[1], start_angles[2]);
}
else
{
vehicle_origin = start_origin;
vehicle_angles = start_angles;
if(Distance(vehicle_origin, self.origin) > 3)
{
self Vehicle_Teleport(vehicle_origin, vehicle_angles);
}
}
}
adjusted_anim_ent = TransformMove(vehicle_origin, vehicle_angles, start_origin, start_angles, anim_ent.origin, anim_ent.angles);
if(IsDefined(self.animscripted_root))
self AnimScripted("vehicle_scripted_animation", adjusted_anim_ent["origin"], adjusted_anim_ent["angles"], animation, "normal", self.animscripted_root);
else
self AnimScripted("vehicle_scripted_animation", adjusted_anim_ent["origin"], adjusted_anim_ent["angles"], animation);
self SetFlaggedAnim("vehicle_scripted_animation", animation, 1, 0, rate);
self.last_velocity_ips = self Vehicle_GetVelocity();
self childthread vehicle_speed_watcher(print_debug_info);
self waittillmatch("vehicle_scripted_animation", "end");
if(IsDefined(vehicle_end_node))
{
self StopAnimScripted();
self thread vehicle_paths(vehicle_end_node, false);
self StartPath(vehicle_end_node);
resume_speed_mph = Length(self.last_velocity_ips) / 17.6;
self Vehicle_SetSpeedImmediate(resume_speed_mph, 100, 100);
self ResumeSpeed(10);
}
}
anim_scripted_in_place(notifier, animation, mode, root)
{
start_origin = GetStartOrigin((0, 0, 0), (0, 0, 0), animation);
start_angles = GetStartAngles((0, 0, 0), (0, 0, 0), animation);
adjusted = TransformMove(self.origin, self.angles, start_origin, start_angles, (0, 0, 0), (0, 0, 0));
if(IsDefined(mode) && IsDefined(root))
self AnimScripted(notifier, adjusted["origin"], adjusted["angles"], animation, mode, root);
else if(IsDefined(mode))
self AnimScripted(notifier, adjusted["origin"], adjusted["angles"], animation, mode);
else
self AnimScripted(notifier, adjusted["origin"], adjusted["angles"], animation);
}
vehicle_speed_watcher(print_debug_info)
{
self endon("death");
self endon("vehicle_scripted_animation_done");
for(i = 0; ; i++)
{
waittillframeend;
if(self Vehicle_IsPhysVeh())
{
self.last_velocity_ips = self Vehicle_GetVelocity();
}
else
{
if(IsDefined(self.last_origin))
{
self.last_velocity_ips = (self.origin - self.last_origin) * 20;
}
else
{
self.last_velocity_ips = (0, 0, 0);
}
self.last_origin = self.origin;
}
waitframe();
}
}
array_to_parameters(func, parameter_array)
{
switch(parameter_array.size)
{
case 0:
self [[func]]();
break;
case 1:
self [[func]](parameter_array[0]);
break;
case 2:
self [[func]](parameter_array[0], parameter_array[1]);
break;
case 3:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2]);
break;
case 4:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2], parameter_array[3]);
break;
case 5:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2], parameter_array[3], parameter_array[4]);
break;
case 6:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2], parameter_array[3], parameter_array[4], parameter_array[5]);
break;
case 7:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2], parameter_array[3], parameter_array[4], parameter_array[5], parameter_array[6]);
break;
case 8:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2], parameter_array[3], parameter_array[4], parameter_array[5], parameter_array[6], parameter_array[7]);
break;
case 9:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2], parameter_array[3], parameter_array[4], parameter_array[5], parameter_array[6], parameter_array[7], parameter_array[8]);
break;
case 10:
self [[func]](parameter_array[0], parameter_array[1], parameter_array[2], parameter_array[3], parameter_array[4], parameter_array[5], parameter_array[6], parameter_array[7], parameter_array[8], parameter_array[9]);
break;
default:
AssertEx("array_to_parameters called with too many parameters");
}
}
add_wait_arg_array(func, arg_array)
{
add_wait(::array_to_parameters, func, arg_array);
}
add_lines(character, lines)
{
foreach(line in lines)
{
level.scr_sound[character][line] = line;
}
}
add_radio(lines)
{
foreach(line in lines)
{
level.scr_radio[line] = line;
}
}
conversation_begin()
{
flag_waitopen("flag_conversation_in_progress");
flag_set("flag_conversation_in_progress");
}
conversation_end()
{
flag_clear("flag_conversation_in_progress");
}
Objective_OnEntity_safe(objective_number, entity, offset)
{
thread Objective_OnEntity_safe_internal(objective_number, entity, offset);
}
Objective_OnEntity_safe_internal(objective_number, entity, offset)
{
if(IsDefined(offset))
Objective_OnEntity(objective_number, entity, offset);
else
Objective_OnEntity(objective_number, entity);
entity waittill("death");
Objective_Position(objective_number, (0, 0, 0));
}
disable_awareness()
{
Assert(IsDefined(self));
self.ignoreall = true;
self.dontmelee = true;
self.ignoreSuppression = true;
assert(!isdefined(self.suppressionwait_old));
self.suppressionwait_old = self.suppressionwait;
self.suppressionwait = 0;
self disable_surprise();
self.IgnoreRandomBulletDamage = true;
self disable_bulletwhizbyreaction();
self disable_pain();
self.grenadeawareness = 0;
self.ignoreme = 1;
self enable_dontevershoot();
self.disableFriendlyFireReaction = true;
self setFlashbangImmunity(true);
}
enable_awareness()
{
Assert(IsDefined(self));
self.ignoreall = false;
self.dontmelee = undefined;
self.ignoreSuppression = false;
if(isdefined(self.suppressionwait_old))
{
self.suppressionwait = self.suppressionwait_old;
self.suppressionwait_old = undefined;
}
self enable_surprise();
self.IgnoreRandomBulletDamage = false;
self enable_bulletwhizbyreaction();
self enable_pain();
self.grenadeawareness = 1;
self.ignoreme = 0;
self disable_dontevershoot();
self.disableFriendlyFireReaction = undefined;
self setFlashbangImmunity(false);
}
create_player_rig(anim_ent, tag, anime)
{
player_rig = spawn_anim_model("player_rig", level.player.origin);
player_rig Hide();
anim_ent anim_first_frame_solo(player_rig, anime, tag);
if(IsDefined(anim_ent.classname) && anim_ent.classname != "script_struct")
{
player_rig LinkTo(anim_ent, tag);
}
return player_rig;
}
player_control_off(bWait)
{
Assert(IsPlayer(self));
if(!IsDefined(bWait)) bWait = true;
self DisableWeapons();
self AllowStand(true);
self AllowCrouch(false);
self AllowProne(false);
self AllowSprint(false);
self SetStance("stand");
if(bWait)
{
while((self GetStance() != "stand") || self IsThrowingGrenade() || self IsSwitchingWeapon())
waitframe();
}
}
player_control_on()
{
Assert(IsPlayer(self));
self EnableWeapons();
self AllowStand(true);
self AllowCrouch(true);
self AllowProne(true);
self AllowSprint(true);
}
create_anim_ent_for_my_position(anime)
{
Assert(IsDefined(self.origin));
Assert(IsDefined(self.angles));
if(IsString(anime)) anime = self getanim(anime);
ideal_start_origin = GetStartOrigin((0, 0, 0), (0, 0, 0), anime);
ideal_start_angles = GetStartAngles((0, 0, 0), (0, 0, 0), anime);
adjusted_anim_ent = TransformMove(self.origin, self.angles,
ideal_start_origin, ideal_start_angles,
(0, 0, 0), (0, 0, 0));
anim_ent = SpawnStruct();
anim_ent.origin = adjusted_anim_ent["origin"];
anim_ent.angles = adjusted_anim_ent["angles"];
return anim_ent;
}
bob_mask( hudElement )
{
self endon( "stop_mask_bob" );
weapIdleTime = 0;
previousAngles = level.player GetPlayerAngles();
offsetY = 0;
offsetX = 0;
addYoffset = hudElement.y;
addXoffset = hudElement.x;
frameTime = 0.05;
while (1)
{
if ( IsDefined( hudElement ) )
{
angles = level.player GetPlayerAngles();
velocity = level.player GetVelocity();
zVelocity = velocity[2];
velocity = velocity - velocity * ( 0, 0, 1 );
speedXY = Length( velocity );
stance = level.player GetStance();
speedScale = clamp( speedXY, 0, 280 ) / 280;
bobXFraction = 0.1 + speedScale * 0.25;
bobYFraction = 0.1 + speedScale * 0.25;
bobScale = 1.0;
if ( stance == "crouch" )	bobScale = 0.75;
if ( stance == "prone" )	bobScale = 0.4;
if ( stance == "stand" )	bobScale = 1.0;
idleSpeed = 5.0;
ADSSpeed = 0.9;
playerADS = level.player playerADS();
bobSpeed = idleSpeed * ( 1.0 - playerADS ) + ADSSpeed * playerADS;
bobSpeed = bobSpeed * ( 1 + speedScale * 2 );
maxXYDisplacement = 5;
bobAmplitudeX = maxXYDisplacement * bobXFraction * bobScale;
bobAmplitudeY = maxXYDisplacement * bobYFraction * bobScale;
weapIdleTime = weapIdleTime + frameTime * 1000.0 * bobSpeed;
rad_to_deg = 57.295779513;
verticalBob = sin( weapIdleTime * 0.001 * rad_to_deg );
horizontalBob = sin( weapIdleTime * 0.0007 * rad_to_deg );
angleDiffYaw = AngleClamp180( angles[ 1 ] - previousAngles[ 1 ] );
angleDiffYaw = clamp( angleDiffYaw, -10, 10 );
offsetXTarget = ( angleDiffYaw / 10 ) * maxXYDisplacement * ( 1 - bobXFraction );
offsetXChange = offsetXTarget - offsetX;
offsetX = offsetX + clamp( offsetXChange, -1.0, 1.0 );
offsetYTarget = ( clamp( zVelocity, -200, 200 ) / 200 ) * maxXYDisplacement * ( 1 - bobYFraction );
offsetYChange = offsetYTarget - offsetY;
offsetY = offsetY + clamp( offsetYChange, -0.6, 0.6 );
hudElement MoveOverTime( 0.05 );
hudElement.x = addXoffset + clamp( ( verticalBob * bobAmplitudeX + offsetX - maxXYDisplacement ), ( 0 - 2 * maxXYDisplacement ), 0 );
hudElement.y = addYoffset + clamp( ( horizontalBob * bobAmplitudeY + offsetY - maxXYDisplacement ), ( 0 - 2 * maxXYDisplacement ), 0 );
previousAngles = angles;
}
wait frameTime;
}
}
gasmask_on_player(bFadeIn, fadeOutTime, fadeInTime, darkTime)
{
Assert(IsPlayer(self));
if(!IsDefined(bFadeIn)) bFadeIn = true;
if(!IsDefined(fadeOutTime)) fadeOutTime = 0;
if(!IsDefined(fadeInTime)) fadeInTime = 1;
if(!IsDefined(darkTime)) darkTime = .25;
if(bFadeIn)
{
fade_out( fadeOutTime );
}
SetHUDLighting( true );
self.gasmask_hud_elem = NewClientHudElem( self );
self.gasmask_hud_elem.x = 0;
self.gasmask_hud_elem.y = 0;
self.gasmask_hud_elem.horzAlign = "fullscreen";
self.gasmask_hud_elem.vertAlign = "fullscreen";
self.gasmask_hud_elem.foreground = false;
self.gasmask_hud_elem.sort = -1;
self.gasmask_hud_elem SetShader("gasmask_overlay_delta2_top", 650, 138);
self.gasmask_hud_elem.alpha = 1.0;
self.gasmask_hud_elem1 = NewClientHudElem( self );
self.gasmask_hud_elem1.x = 0;
self.gasmask_hud_elem1.y = 490 - 138;
self.gasmask_hud_elem1.horzAlign = "fullscreen";
self.gasmask_hud_elem1.vertAlign = "fullscreen";
self.gasmask_hud_elem1.foreground = false;
self.gasmask_hud_elem1.sort = -1;
self.gasmask_hud_elem1 SetShader("gasmask_overlay_delta2_bottom", 650, 138);
self.gasmask_hud_elem1.alpha = 1.0;
level.player delaythread( 1.0, ::gasmask_breathing );
vision_set_fog_changes( "paris_gasmask", .5 );
thread bob_mask( self.gasmask_hud_elem );
thread bob_mask( self.gasmask_hud_elem1 );
if(bFadeIn)
{
wait( darkTime );
fade_in( fadeInTime );
}
}
gasmask_off_player()
{
Assert(IsPlayer(self));
fade_out( 0.25 );
self notify( "stop_mask_bob" );
if(IsDefined(self.gasmask_hud_elem))
{
self.gasmask_hud_elem Destroy();
self.gasmask_hud_elem = undefined;
}
if(IsDefined(self.gasmask_hud_elem1))
{
self.gasmask_hud_elem1 Destroy();
self.gasmask_hud_elem1 = undefined;
}
SetHUDLighting( false );
vision_set_fog_changes( "paris_catacombs", 0 );
level.player notify( "stop_breathing" );
wait( 0.25 );
fade_in( 1.5 );
}
gasmask_breathing()
{
delay = 1.0;
self endon( "stop_breathing" );
while ( 1 )
{
self play_sound_on_entity( "breathing_gasmask" );
wait( delay );
}
}
gasmask_on_npc()
{
self.gasmask = Spawn("script_model", (0, 0, 0));
self.gasmask SetModel("prop_sas_gasmask");
self.gasmask LinkTo(self, "tag_eye", (-4, 0, 2), (120, 0, 0));
}
gasmask_off_npc()
{
if(IsDefined(self.gasmask))
self.gasmask Delete();
}
ally_keep_player_distance(ideal_distance, min_rate, max_rate, slope)
{
self endon( "death" );
if(!IsDefined(min_rate)) min_rate = 0.7;
if(!IsDefined(max_rate)) max_rate = 1.3;
if(!IsDefined(slope)) slope = .5;
self notify("ally_keep_player_distance_stop");
self endon("ally_keep_player_distance_stop");
rate_smoothing = .05;
heuristic_count = 1.5;
rate_unsmoothing = 1 - rate_smoothing;
if(ideal_distance > 0)
{
min_rate_distance = ideal_distance * ((1 - min_rate) / slope + 1);
max_rate_distance = ideal_distance * ((1 - max_rate) / slope + 1);
}
else
{
min_rate_distance = -1 * ideal_distance * ((1 - min_rate) / slope + 1) + ideal_distance * 2;
max_rate_distance = -1 * ideal_distance * ((1 - max_rate) / slope + 1) + ideal_distance * 2;
}
center_rate = linear_map_clamp(ideal_distance, min_rate_distance, max_rate_distance, min_rate, max_rate);
Assert(abs(center_rate - 1) < .001);
Assert(min_rate_distance > max_rate_distance);
last_rate = self.moveplaybackrate;
for(;; waitframe())
{
if(IsDefined(self.velocity) && Length(self.velocity) < .01)
{
self.moveplaybackrate = 1;
last_rate = 1;
continue;
}
player_to_self = flat_origin(self.origin - level.player.origin);
player_to_self_dir = VectorNormalize(player_to_self);
self_forward = AnglesToForward(flat_angle(self.angles));
player_forward = AnglesToForward(flat_angle(level.player GetPlayerAngles()));
flow = (0, 0, 0);
if(IsDefined(self.goalpos) && Distance(self.goalpos, self.origin) > 32)
{
player_to_goal = VectorNormalize(flat_origin(self.goalpos - level.player.origin));
flow += player_to_goal * clamp(VectorDot(player_to_goal, player_forward), 0, 1);
}
flow += self_forward * clamp(VectorDot(self_forward, player_forward), 0, 1);
flow += -1.0 * player_to_self_dir * clamp(-1.0 * VectorDot(player_to_self, self_forward), 0, 1);
heuristic_strength = clamp(Length(flow) / heuristic_count, 0, 1);
if(IsDefined(self.goalpos))
{
start_attenuate = 96;
stop_attenuate = 64;
heuristic_strength *= clamp((Distance(self.goalpos, self.origin) - stop_attenuate) / (start_attenuate - stop_attenuate), 0, 1);
}
flow_dir = VectorNormalize(flow);
distance = VectorDot(player_to_self, flow_dir);
raw_rate = linear_map_clamp(distance, min_rate_distance, max_rate_distance, min_rate, max_rate);
heuristic_rate = (raw_rate - 1) * heuristic_strength + 1;
smooth_rate = heuristic_rate * rate_smoothing + last_rate * rate_unsmoothing;
last_rate = self.moveplaybackrate;
self.moveplaybackrate = smooth_rate;
}
}
ally_keep_player_distance_stop()
{
self notify("ally_keep_player_distance_stop");
self.moveplaybackrate = 1;
}
linear_map(x, in_min, in_max, out_min, out_max)
{
return out_min + (x - in_min) * (out_max - out_min) / (in_max - in_min);
}
linear_map_clamp(x, in_min, in_max, out_min, out_max)
{
return clamp(linear_map(x, in_min, in_max, out_min, out_max), out_min, out_max);
}
angle_lerp(from, to, fraction)
{
return AngleClamp(from + AngleClamp180(to - from) * fraction);
}
euler_lerp(from, to, fraction)
{
return (
angle_lerp(from[0], to[0], fraction),
angle_lerp(from[1], to[1], fraction),
angle_lerp(from[2], to[2], fraction)
);
}
fire_while_moving()
{
self endon( "death" );
self.accuracy = 0.08;
self enable_heat_behavior( true );
}
lower_accuracy()
{
self endon( "death" );
self.accuracy = 0.08;
}
bloody_death( delay )
{
self endon( "death" );
if( !IsSentient( self ) || !IsAlive( self ) )
{
return;
}
if( IsDefined( self.bloody_death ) && self.bloody_death )
{
return;
}
self.bloody_death = true;
if( IsDefined( delay ) )
{
wait( RandomFloat( delay ) );
}
tags = [];
tags[0] = "j_hip_le";
tags[1] = "j_hip_ri";
tags[2] = "j_head";
tags[3] = "j_spine4";
tags[4] = "j_elbow_le";
tags[5] = "j_elbow_ri";
tags[6] = "j_clavicle_le";
tags[7] = "j_clavicle_ri";
for( i = 0; i < 3 + RandomInt( 5 ); i++ )
{
random = RandomIntRange( 0, tags.size );
self thread bloody_death_fx( tags[random], undefined );
wait( RandomFloat( 0.1 ) );
}
self DoDamage( self.health + 50, self.origin );
}
bloody_death_fx( tag, fxName )
{
if( !IsDefined( fxName ) )
{
fxName = level._effect["flesh_hit"];
}
PlayFxOnTag( fxName, self, tag );
}
windy_tree_system()
{
thread monitor_all_tree_damage();
windy_trees = [];
animated_models = GetEntArray( "animated_model", "targetname" );
foreach ( model in animated_models )
{
keys = GetArrayKeys( level.anim_prop_models[ model.model ] );
foreach ( key in keys )
{
if ( key == "windy_idle" )
{
windy_trees[ windy_trees.size ] = model;
}
}
}
while ( true )
{
level waittill( "wind_blast", blast_origin, blast_radius, fade_in_time, fade_out_time, duration, ignore_z );
foreach ( windy_tree in windy_trees )
{
distance_to_blast = undefined;
if ( IsDefined( ignore_z ) && ignore_z )
{
windy_tree_xy = ( windy_tree.origin[0], windy_tree.origin[1], 0 );
blast_origin_xy = ( blast_origin[0], blast_origin[1], 0 );
distance_to_blast = Distance( windy_tree_xy, blast_origin_xy );
}
else
{
distance_to_blast = Distance( windy_tree.origin, blast_origin );
}
if ( distance_to_blast < blast_radius )
{
windy_tree thread shake_tree( fade_in_time, fade_out_time, duration );
}
}
}
}
monitor_all_tree_damage()
{
tree_damage_triggers = GetEntArray( "tree_damage_trigger", "targetname" );
foreach ( tree_damage_trigger in tree_damage_triggers )
{
tree_damage_trigger thread monitor_tree_damage();
}
}
monitor_tree_damage()
{
self endon( "death" );
while ( true )
{
self waittill( "damage", amount, attacker, direction, pos, mod );
if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
{
level notify( "wind_blast", pos, 512, 0.2, 0.2, 1 );
}
}
}
shake_tree( fade_in_time, fade_out_time, duration )
{
self notify( "playing_windy_idle" );
self endon( "playing_windy_idle" );
windy_idle_anim = level.anim_prop_models[ self.model ][ "windy_idle" ];
self SetAnim( windy_idle_anim, 1, fade_in_time, 1 );
wait duration;
self ClearAnim( windy_idle_anim, fade_out_time );
}
entity_blast_wind( wind_radius, ignore_z )
{
self endon( "death" );
while ( true )
{
level notify( "wind_blast", self.origin, wind_radius, 0.2, 0.5, 1, ignore_z );
wait 0.5;
}
}
randomizer_create(array)
{
Assert(array.size != 0);
randomizer = SpawnStruct();
randomizer.array = array;
return randomizer;
}
randomizer_get_no_repeat()
{
Assert(self.array.size > 0);
index = undefined;
if(self.array.size > 1 && IsDefined(self.last_index))
{
index = RandomInt(self.array.size - 1);
if(index >= self.last_index)
index++;
}
else
{
index = RandomInt(self.array.size);
}
self.last_index = index;
return self.array[index];
}
randomizer_get()
{
return random(self.array);
}
introscreen_generic_fade_out( shader, pause_time, fade_in_time, fade_out_time )
{
if ( !isdefined( fade_in_time ) )
fade_in_time = 1.5;
introblack = NewHudElem();
introblack.x = 0;
introblack.y = 0;
introblack.horzAlign = "fullscreen";
introblack.vertAlign = "fullscreen";
introblack.foreground = true;
introblack SetShader( shader, 640, 480 );
if ( IsDefined( fade_out_time ) && fade_out_time > 0 )
{
introblack.alpha = 0;
introblack FadeOverTime( fade_out_time );
introblack.alpha = 1;
wait( fade_out_time );
}
wait pause_time;
if ( fade_in_time > 0 )
introblack FadeOverTime( fade_in_time );
introblack.alpha = 0;
wait fade_in_time;
introblack destroy();
}
alternate_deadquote(deadquote)
{
thread alternate_deadquote_internal(deadquote);
}
alternate_deadquote_internal(deadquote)
{
level notify( "new_quote_string" );
level endon( "new_quote_string" );
level endon( "mine death" );
if ( isalive( level.player ) )
level.player waittill( "death" );
if ( !level.missionfailed )
{
SetDvar("ui_deadquote", deadquote);
}
}
alternate_deadquote_stop()
{
level thread maps\_quotes::setDeadQuote();
}
vehicle_get_driver()
{
foreach(guy in self.attachedguys)
{
if(IsDefined(guy.drivingVehicle) && guy.drivingVehicle)
return guy;
}
}
vehicle_get_crash_struct(min_time, max_time, max_angle_degrees, slowdown_factor)
{
crash_speed_ips = self Vehicle_GetSpeed() * 17.6 * slowdown_factor;
min_range_sq = squared(crash_speed_ips * min_time);
max_range_sq = squared(crash_speed_ips * max_time);
min_dp = Cos(max_angle_degrees);
crash_structs = SortByDistance(GetStructArray("vehicle_crash_struct", "script_noteworthy"), self.origin);
foreach(crash_struct in crash_structs)
{
distance_sq = DistanceSquared(crash_struct.origin, self.origin);
if(distance_sq < min_range_sq)
continue;
if(distance_sq > max_range_sq)
break;
if(IsDefined(crash_struct.used))
continue;
if(VectorDot(VectorNormalize(crash_struct.origin - self.origin), AnglesToForward(self.angles)) < min_dp)
continue;
return crash_struct;
}
return undefined;
}
vehicle_wait_for_crash(args)
{
self thread notify_delay("max_time", args.wait_time);
self thread vehicle_detect_crash(args);
msg = self waittill_any_return("max_time", "veh_collision", "script_vehicle_collision", "detect_crash");
if(!IsDefined(msg))
msg = "unknown";
self notify("stop_vehicle_detect_crash");
}
vehicle_detect_crash(args)
{
self endon("stop_vehicle_detect_crash");
waittillframeend;
min_player_distance_sq = squared(39*6);
if(IsDefined(level.vehicle_death_radiusdamage[self.classname]) && IsDefined(level.vehicle_death_radiusdamage[self.classname].range))
min_player_distance_sq = squared(level.vehicle_death_radiusdamage[self.classname].range * .75);
for(;; waitframe())
{
if(abs(AngleClamp180(self.angles[0])) > 30 || abs(AngleClamp180(self.angles[2])) > 30)
{
break;
}
if(DistanceSquared(self.origin, level.player.origin) < min_player_distance_sq)
{
break;
}
if(self Vehicle_GetSpeed() / args.crash_speed_mph < .25)
{
break;
}
if(VectorDot(args.goal_pos - self.origin, args.vehicle_to_crash_struct_dir) < 0)
{
break;
}
}
self notify("detect_crash");
}
vehicle_crazy_steering(args)
{
max_angle = 45;
accel_time = 4;
lookahead = 39*5;
max_sideways = lookahead * Tan(max_angle);
init_speed_mph = self Vehicle_GetSpeed();
elapsed_time = 0;
self endon("death");
for(;;)
{
right_of_center = false;
if(VectorDot(args.crash_struct.origin - self.origin, args.right_dir) < 0)
right_of_center = true;
sideways = RandomFloat(max_sideways);
if(right_of_center)
sideways *= -1;
goal_pos = self.origin + args.vehicle_to_crash_struct_dir * lookahead + args.right_dir * sideways;
t = clamp(elapsed_time / accel_time, 0, 1);
speed_mph = linear_interpolate(t, init_speed_mph, args.crash_speed_mph);
self vehicleDriveTo(goal_pos, args.crash_speed_mph);
delay = RandomFloatRange(.05, .2);
elapsed_time += delay;
wait(delay);
}
}
paris_vehicle_death()
{
self thread vehicle_crash_when_driver_dies();
self thread vehicle_crash_on_death();
self thread vehicle_crash_when_blocked();
}
vehicle_crash_when_driver_dies()
{
AssertEx(IsDefined(self.script_allow_driver_death) && self.script_allow_driver_death, "script_allow_driver_death should be set the vehicle or vehicle_crash_when_driver_dies() won't work");
self endon("death");
self.vehicle_keeps_going_after_driver_dies = true;
driver = self vehicle_get_driver();
if(!IsDefined(driver))
{
AssertEx(false, "vehicle_crash_when_driver_dies() counldn't find a driver, so we're returning early");
return;
}
driver waittill("death");
if(IsDefined(driver))
PlayFxOnTag( getfx( "blood_gaz_driver" ), driver, "tag_eye" );
attacker = undefined;
if(IsDefined(driver))
attacker = driver.lastattacker;
self vehicle_crash_now(attacker);
}
vehicle_crash_on_death()
{
self.vehicle_stays_alive = true;
while(self.health > 0)
{
self waittill("damage");
waittillframeend;
if(self.health < self.healthbuffer)
break;
}
self vehicle_crash_now(self.attacker);
}
vehicle_crash_when_blocked()
{
self endon("death");
height = 24;
start_forward = 39;
end_forward = 39*4;
attacker = undefined;
for(;; wait .5)
{
start = self LocalToWorldCoords((start_forward, 0, height));
end = self LocalToWorldCoords((end_forward, 0, height));
result = BulletTrace(start, end, false, self);
entity = result["entity"];
if(IsDefined(entity))
{
if(entity.code_classname == "script_model" ||
(entity.code_classname == "script_vehicle" && entity.health <= 0))
{
attacker = entity.attacker;
break;
}
}
if(IsDefined(self.vehicle_crashing_now))
return;
}
self thread vehicle_crash_now(attacker);
}
vehicle_crash_now(attacker)
{
min_time = .75;
max_time = 3;
max_angle_degrees = 60;
slowdown_factor = 1.5;
overshoot_distance = 39*1;
wait_time_fudge_factor = 1.8;
if(IsDefined(self.vehicle_crashing_now))
return;
self.vehicle_crashing_now = true;
self notify("vehicle_crashing_now");
crash_struct = vehicle_get_crash_struct(min_time, max_time, max_angle_degrees, slowdown_factor);
if(IsDefined(crash_struct))
{
crash_struct.used = true;
args = SpawnStruct();
args.crash_struct = crash_struct;
args.vehicle = self;
args.vehicle_to_crash_struct = args.crash_struct.origin - args.vehicle.origin;
args.vehicle_to_crash_struct_dir = VectorNormalize(args.vehicle_to_crash_struct);
args.right_dir = AnglesToRight(flat_angle(VectorToAngles(args.vehicle_to_crash_struct_dir)));
args.goal_pos = args.crash_struct.origin + VectorNormalize(args.vehicle_to_crash_struct) * overshoot_distance;
args.crash_speed_ips = max(self Vehicle_GetSpeed() * 17.6 * slowdown_factor, 1);
args.crash_speed_mph = args.crash_speed_ips / 17.6;
args.wait_time = Length(args.vehicle_to_crash_struct) / args.crash_speed_ips * wait_time_fudge_factor;
self thread vehicle_crazy_steering(args);
vehicle_wait_for_crash(args);
}
else
{
}
self.vehicle_stays_alive = undefined;
if(IsDefined(attacker))
self DoDamage(self.health + 2000, self.origin, attacker, self);
else
self DoDamage(self.health + 2000, self.origin);
}
change_turret_accuracy_over_time( start_accuracy, end_accuracy, time )
{
if ( IsDefined( self.mgturret ) )
{
foreach ( turret in self.mgturret )
{
if ( IsDefined( turret ) )
{
turret thread change_accuracy_over_time( start_accuracy, end_accuracy, time );
}
}
}
}
change_accuracy_over_time( start_accuracy, end_accuracy, time )
{
self endon( "death" );
while ( !IsDefined( self.aiowner ) )
{
wait 0.05;
}
self.aiowner endon( "death" );
self.aiowner.ignoreme = true;
self.aiowner.ignorerandombulletdamage = true;
self SetMode( "manual_ai" );
self SetTargetEntity( level.player, (0,0,32) );
if ( !IsDefined( self.turretState ) || self.turretState != "fire" )
{
self waittill( "startfiring" );
}
start_time = GetTime();
end_time = start_time + ( time * 1000 );
time_pct = 0;
while ( time_pct < 1 )
{
lerp_accuracy = ( ( end_accuracy - start_accuracy ) * time_pct ) + start_accuracy;
self SetAISpread( lerp_accuracy );
wait 0.05;
time_pct = ( GetTime() - start_time ) / ( end_time - start_time );
}
self SetAISpread( end_accuracy );
}
player_smooth_unclamp(duration, orig_clamp_right, orig_clamp_left, orig_clamp_top, orig_clamp_bottom)
{
Assert(IsPlayer(self));
Assert(duration > 0);
Assert(orig_clamp_right < 180);
Assert(orig_clamp_left < 180);
Assert(orig_clamp_top < 90);
Assert(orig_clamp_bottom < 90);
aim_turnrate_pitch = 90.0;
aim_turnrate_pitch_ads = 55.0;
aim_turnrate_yaw = 260.0;
aim_turnrate_yaw_ads = 90.0;
sensitivity = self GetLocalPlayerProfileData("viewSensitivity");
if(!IsDefined(sensitivity))
sensitivity = 1;
sensitivity = Float(sensitivity);
if(sensitivity < .001)
sensitivity = 1;
max_pitch_dps = aim_turnrate_pitch * sensitivity;
max_yaw_dps = aim_turnrate_yaw * sensitivity;
time_needed = duration;
time_needed = Min(time_needed, 2 * (180 - orig_clamp_right ) / max_yaw_dps );
time_needed = Min(time_needed, 2 * (180 - orig_clamp_left ) / max_yaw_dps );
time_needed = Min(time_needed, 2 * ( 90 - orig_clamp_top ) / max_pitch_dps);
time_needed = Min(time_needed, 2 * ( 90 - orig_clamp_bottom) / max_pitch_dps);
Assert(time_needed > 0);
wait_before_unclamp = duration - time_needed;
if(wait_before_unclamp > 0)
wait wait_before_unclamp;
if(IsAlive(self) && self IsLinked())
{
self LerpViewAngleClamp(
time_needed,
time_needed,
0,
Min(180, orig_clamp_right + 0.5 * time_needed * max_yaw_dps ),
Min(180, orig_clamp_left + 0.5 * time_needed * max_yaw_dps ),
Min( 90, orig_clamp_top + 0.5 * time_needed * max_pitch_dps),
Min( 90, orig_clamp_bottom + 0.5 * time_needed * max_pitch_dps)
);
}
wait(time_needed);
}
scripted_sequence_recon(scene_id_string, bPlayed, view_check_origin_or_ai, delay)
{
thread scripted_sequence_recon_internal(scene_id_string, bPlayed, view_check_origin_or_ai, delay);
}
scripted_sequence_recon_internal(scene_id_string, bPlayed, view_check_origin_or_ai, delay)
{
view_check_origin = undefined;
if(bPlayed && !IsAi(view_check_origin_or_ai))
{
view_check_origin = view_check_origin_or_ai;
}
if(IsDefined(delay))
wait delay;
if(bPlayed && !IsDefined(view_check_origin) && IsAI(view_check_origin_or_ai) && IsAlive(view_check_origin_or_ai))
{
view_check_origin = view_check_origin_or_ai GetShootAtPos();
}
seen = false;
if(bPlayed && IsDefined(view_check_origin))
{
if(level.player can_see_origin(view_check_origin, false))
{
seen = true;
}
}
ReconSpatialEvent(level.player.origin, "script_scripted_sequence: scene %s, played %b, seen %b", scene_id_string, bPlayed, seen);
}
lerp_move_speed_scale(oldSpeedScale, targetSpeedScale, totalSeconds)
{
Assert(IsPlayer(self));
Assert(totalSeconds > 0);
self notify("lerp_move_speed_scale");
self endon("lerp_move_speed_scale");
startSeconds = GetTime() * .001;
for(;;)
{
currentSeconds = GetTime() * .001 - startSeconds;
if(currentSeconds >= totalSeconds)
break;
self SetMoveSpeedScale(linear_interpolate(currentSeconds / totalSeconds, oldSpeedScale, targetSpeedScale));
waitframe();
}
self SetMoveSpeedScale(targetSpeedScale);
}
setup_ignore_suppression_triggers()
{
triggers = GetEntArray("trigger_ignore_suppression", "targetname");
foreach(trigger in triggers)
{
level thread ignore_suppression_trigger_think(trigger);
}
}
ignore_suppression_trigger_think(trigger)
{
for(;;)
{
trigger waittill("trigger", other);
if(IsDefined(other) && IsAI(other) && !other IsBadGuy())
{
other thread ignore_suppression_trigger_ai_think(trigger);
}
}
}
ignore_suppression_trigger_ai_think(trigger)
{
self notify("ignore_suppression_trigger_ai_think_stop");
self endon("ignore_suppression_trigger_ai_think_stop");
self endon("death");
self set_ignoresuppression(true);
while(self IsTouching(trigger))
{
wait .5;
}
self set_ignoresuppression(false);
}
setup_ignore_all_triggers()
{
triggers = GetEntArray("trigger_ignore_all", "targetname");
foreach(trigger in triggers)
{
level thread ignore_all_trigger_think(trigger);
}
}
ignore_all_trigger_think(trigger)
{
for(;;)
{
trigger waittill("trigger", other);
if(IsDefined(other) && other IsBadGuy())
{
other thread ignore_all_trigger_ai_think(trigger);
}
}
}
ignore_all_trigger_ai_think(trigger)
{
self notify("ignore_all_trigger_ai_think_stop");
self endon("ignore_all_trigger_ai_think_stop");
self endon("death");
self set_ignoreall(true);
self setFlashbangImmunity(true);
while(self IsTouching(trigger))
{
wait .05;
}
self set_ignoreall(false);
self setFlashbangImmunity(false);
}
bomb_truck_hide_windshield()
{
level.bomb_truck_model HidePart("windshield01");
level.bomb_truck_model HidePart("windshield02");
level.bomb_truck_model HidePart("windshield03");
level.bomb_truck_model HidePart("windshield04");
level.bomb_truck_model HidePart("windshield05");
}
path_squad_with_trigger(targetname, touch_once)
{
next_color_nodes = GetEnt( targetname, "targetname" );
if(IsDefined(next_color_nodes))
next_color_nodes notify( "trigger", level.player );
if(!IsDefined(touch_once)) touch_once = false;
if(touch_once && IsDefined(next_color_nodes))
{
next_color_nodes trigger_off();
}
}
hud_off()
{
SetSavedDvar( "compass", "0" );
SetSavedDvar( "ammoCounterHide", "1" );
SetSavedDvar( "hud_showstance", "0" );
SetSavedDvar( "actionSlotsHide", "1" );
}
hud_on()
{
SetSavedDvar( "compass", "1" );
SetSavedDvar( "ammoCounterHide", "0" );
SetSavedDvar( "hud_showstance", "1" );
SetSavedDvar( "actionSlotsHide", "0" );
}