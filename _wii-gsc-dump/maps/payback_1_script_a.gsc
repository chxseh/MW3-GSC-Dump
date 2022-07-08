#include maps\_utility;
#include common_scripts\utility;
#include maps\payback_util;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\_audio;
CONST_MPHTOIPS = 17.6;
CONST_PLAYER_LINKTO = "tag_player2";
DISABLE_INTRO_FOG_HACK = true;
init_compound_a_flags()
{
flag_init("intro_tech1_shootme");
flag_init("intro_tech2_shootme");
}
do_path(acc, spd)
{
self goPath();
}
intro()
{
set_black_fade(1, 0);
maps\_compass::setupMiniMap("compass_map_payback_drivein","drivein_minimap_corner");
leaving_triggers = GetEntArray( "Player_Leaving_Compound_Trigger", "targetname" );
foreach ( trigger in leaving_triggers )
{
trigger trigger_off();
}
left_triggers = GetEntArray( "Player_Left_Compound_Trigger", "targetname" );
foreach ( trigger in left_triggers )
{
trigger trigger_off();
}
aud_send_msg("player_slamzoom_prime");
thread hack_shadow_quality();
thread manage_intro_viewdistance();
thread intro_technicals();
thread bravo_puddlesplash();
thread reset_chopper_treadfx();
thread windshield_cracks();
maps\payback_1_script_b::remove_placeholder_hummers();
level thread gate_closing_guys();
hide_hud_for_scripted_sequence();
waittillframeend;
level.player EnableInvulnerability();
forceyellowdot(true);
chopper_intro_struct = GetStruct("chopper_new_intro_path", "targetname");
aud_send_msg("intro_hummer_ride");
alpha_hummer = spawn_vehicle_from_targetname( "alpha_hummer" );
level.alpha_hummer = alpha_hummer;
level.alpha_hummer.dontunloadonend = true;
bravo_hummer = spawn_vehicle_from_targetname( "bravo_hummer" );
level.bravo_hummer = bravo_hummer;
level.bravo_hummer thread alpha_createfx_exploders();
level.bravo_hummer thread bravo_treadfx_logic();
level.bravo_hummer thread bravo_wheel_skidmark_hack();
level thread bravo_truck_gatecrash_anim_thread();
thread intro_hummer_soap_events(level.soap);
thread bravo_guy_signals();
thread barracus_intro_events();
thread nikolai_blows_stuff_up();
level.price.get_out_override = level.scr_anim[ "price" ][ "intro_price_getout" ];
level.price gun_remove();
alpha_hummer thread maps\_vehicle_aianim::guy_enter( level.price );
alpha_hummer thread maps\_vehicle_aianim::guy_enter( level.soap );
level.hannibal.animname = "Hannibal";
bravo_hummer thread maps\_vehicle_aianim::guy_enter( level.Hannibal);
bravo_hummer thread maps\_vehicle_aianim::guy_enter( level.Murdock);
bravo_hummer thread maps\_vehicle_aianim::guy_enter( level.Barracus);
thread intro_dialog();
thread intro_player_events();
level.player FreezeControls( true );
cinematicingamesync( "payback_fade" );
wait 0.5;
exploder(1000);
aud_send_msg("intro_black_begin");
WiiGeomStreamNotify(true);
level waittill( "geom_stream_done" );
set_black_fade(1, 0);
thread slamzoom_coverup();
thread intro_slamzoom();
level.chopper Vehicle_Teleport(chopper_intro_struct.origin, chopper_intro_struct.angles);
level.chopper thread vehicle_paths(chopper_intro_struct);
level.chopper Vehicle_SetSpeedImmediate( 70, 20, 20 );
thread maps\payback_1_script_b::spawn_ground_opposition();
set_introguys_ignoreme(true);
thread turn_off_ignoreme();
thread price_intro_anim();
level.price thread price_unload_events();
level notify("price_intro_line");
bravo_invulnerability(true);
thread jump_reaction_anims();
alpha_hummer do_path();
bravo_hummer do_path();
thread maps\payback_aud::initialize_intro_hummers();
battlechatter_off( "allies" );
thread intro_civillians();
thread sandstorm_fx(1);
level.soap thread soap_kills_intro_guys_thread();
level thread barrels_explode_thread();
wait(24);
maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
gate_node = getvehiclenode("player_truck_gate_node", "targetname");
gate_node waittill("trigger");
level.player PlayRumbleOnEntity( "heavy_3s" );
Earthquake( 0.3, 0.75, level.player.origin, 200 );
level waittill("player_exited_jeep");
forceyellowdot(false);
thread safety_timer();
foreach ( trigger in leaving_triggers )
{
trigger trigger_on();
}
foreach ( trigger in left_triggers )
{
trigger trigger_on();
}
thread Player_Leaving_Compound();
thread Player_Left_Compound();
maps\payback_1_script_b::main();
}
slamzoom_coverup()
{
wait 1.5;
set_black_fade(0, 0.25);
}
turn_off_ignoreme()
{
vehicle_node_trigger_wait("alpha_jump_land_node");
wait 2.0;
set_introguys_ignoreme(false);
}
intro_dialog()
{
wait 4.5;
vehicle_node_trigger_wait("player_stand_node");
wait 4.0;
level.price dialogue_queue("payback_pri_throughgate");
vehicle_node_trigger_wait("alpha_jump_land_node");
wait 2.0;
wait 1.8;
radio_dialogue("payback_nik_misslesaway");
aud_send_msg("start_lfe_loop");
wait .65;
level.price dialogue_queue("payback_pri_targetsahead");
}
vehicle_node_trigger_wait(nodename)
{
node = GetVehicleNode(nodename, "script_noteworthy");
node waittill("trigger");
}
vehicle_play_guy_anim(anime, guy, pos, playIdle)
{
animpos = anim_pos( self, pos );
animation = guy getanim(anime);
guy notify ("newanim");
guy endon( "newanim" );
guy endon( "death" );
self anim_single_solo(guy, anime, animpos.sittag);
if(!IsDefined(playIdle) || playIdle == true)
{
self guy_idle(guy, pos);
}
}
vehicle_play_guy_anim_at_nodename(nodename, anime, guy, pos, delay, playIdle, notifyName)
{
vehicle_node_trigger_wait(nodename);
wait delay;
guy endon( "death" );
if(IsDefined(notifyName))
{
guy notify(notifyName);
}
vehicle_play_guy_anim(anime, guy, pos, playIdle);
}
vehicle_play_guy_anim_on_notify(event, anime, guy, pos)
{
level waittill(event);
guy endon( "death" );
animpos = anim_pos( self, pos );
animation = guy getanim(anime);
guy notify ("newanim");
guy endon( "newanim" );
self anim_single_solo(guy, anime, animpos.sittag);
self guy_idle(guy, pos);
}
gate_approach_slowmo()
{
vehicle_node_trigger_wait("barrels_explode_node");
wait .4;
SetSlowMotion(1.0, 0.3, .3);
wait 1.0;
SetSlowMotion(0.3, 1.0, 0.1);
}
windshield_cracks()
{
vehicle_node_trigger_wait("soap_leans_out_node");
wait 2.0;
for(i=0; i < 5; i++)
{
target = level.alpha_hummer.origin + (RandomFloatRange(-25, 25),0.0,RandomFloatRange(55, 60));
forward = AnglesToForward(level.alpha_hummer.angles);
source = (target + forward* 500);
MagicBullet("ak47", source, target);
wait (RandomFloatRange(0.1, 0.5));
}
}
alpha_createfx_exploders()
{
createfx_birds_node = getvehiclenode("alpha_fx_birds", "script_noteworthy");
createfx_birds_node waittill("trigger");
wait(2.5);
exploder(1001);
}
bravo_treadfx_logic()
{
jeep_treadfx_sand = level._effect["pb_jeep_trail"] ;
jeep_treadfx_water = level._effect["pb_jeep_trail_water_left"] ;
jeap_treadfx_road = level._effect["pb_jeep_trail_road"] ;
jeep_blankfx = level._effect["blank"] ;
skidfx = level._effect["pb_jeep_trail_road_skid"] ;
level.bravo_hummer thread override_treadfx_all_wheels(jeep_treadfx_sand);
level.bravo_hummer thread override_treadfx_left_wheels(jeep_treadfx_water,"bravo_left_water");
level.bravo_hummer thread override_treadfx_left_wheels(jeep_treadfx_sand,"bravo_left_water_end");
level.bravo_hummer thread override_treadfx_all_wheels(jeep_blankfx,"bravo_jump_start_node",0.7);
jump_land_node = getvehiclenode("bravo_jump_land_node", "script_noteworthy");
jump_land_node waittill("trigger");
effectUp = AnglesToUp(self.angles);
effectFwd = AnglesToForward(self.angles);
PlayFX(level._effect["sand_vehicle_impact"], self.origin, effectFwd, effectUp);
level.bravo_hummer thread override_treadfx_all_wheels(jeap_treadfx_road);
wait(.1);
PlayFXOnTag(skidfx, level.bravo_hummer.tagleftWheelHack,"tag_origin");
PlayFXOnTag(skidfx, level.bravo_hummer.tagrightWheelHack,"tag_origin");
texploder(2300);
exploder(2000);
exploder(2500);
}
override_treadfx_left_wheels(fx,nodename,delay)
{
if (IsDefined(nodename))
{
vehicle_node_trigger_wait(nodename);
}
if (IsDefined(delay))
{
wait(delay);
}
wait(.05);
override_treadfx_on_wheel(fx,"tag_wheel_front_left");
wait(.05);
override_treadfx_on_wheel(fx,"tag_wheel_back_left");
}
override_treadfx_right_wheels(fx,nodename,delay)
{
if (IsDefined(nodename))
{
vehicle_node_trigger_wait(nodename);
}
if (IsDefined(delay))
{
wait(delay);
}
wait(.05);
override_treadfx_on_wheel(fx,"tag_wheel_front_right");
wait(.05);
override_treadfx_on_wheel(fx,"tag_wheel_back_right");
}
override_treadfx_all_wheels(fx,nodename,delay)
{
if (IsDefined(nodename))
{
vehicle_node_trigger_wait(nodename);
}
if (IsDefined(delay))
{
wait(delay);
}
override_treadfx_on_wheel(fx,"tag_wheel_front_left");
wait(.05);
override_treadfx_on_wheel(fx,"tag_wheel_front_right");
wait(.05);
override_treadfx_on_wheel(fx,"tag_wheel_back_left");
wait(.05);
override_treadfx_on_wheel(fx,"tag_wheel_back_right");
}
override_treadfx_at_node(nodename, fx, tag, delay)
{
if(!isdefined(delay))
{
delay = 0.0;
}
vehicle_node_trigger_wait(nodename);
wait delay;
thread override_treadfx_on_wheel(fx, tag);
}
override_treadfx_on_wheel(fx, tag )
{
sNotifyName = (tag);
self notify("new_treadfx", sNotifyName);
waittillframeend;
self thread override_treadfx_killthread(fx, tag);
if ( IsDefined(fx) )
{
PlayFXOnTag(fx, self, tag);
}
}
override_treadfx_killthread(fx, tag)
{
sNotifyName = (tag);
self waittillmatch("new_treadfx", sNotifyName);
StopFXOnTag(fx, self, tag);
}
safety_timer()
{
wait 3;
level.player disableInvulnerability();
}
HasPlayerReturnedToCompound()
{
return !flag( "Player_Leaving_Compound" );
}
Player_Leaving_Compound()
{
while ( 1 )
{
flag_wait( "Player_Leaving_Compound" );
thread radio_dialogue("payback_pri_staywithteam");
level.player display_hint( "Payback_Dont_Abandon_Mission" );
flag_waitopen( "Player_Leaving_Compound" );
}
}
Player_Left_Compound()
{
flag_wait( "Player_Left_Compound" );
setDvar( "ui_deadquote", &"PAYBACK_FAIL_ABANDONED" );
level notify( "mission failed" );
missionFailedWrapper();
}
Handle_Chopper_Destructables()
{
triggers = GetEntArray( "pb_guardtower_compound_trigger", "targetname" );
foreach ( trig in triggers )
{
trig thread Handle_Guard_Tower_Explosion( "pb_guardtower_compound", trig.script_index, "a10_explosion", "thick_building_fire_small" );
}
triggers = GetEntArray( "pb_guardtower_compound_02_trigger", "targetname" );
foreach ( trig in triggers )
{
trig thread Handle_Guard_Tower_Explosion( "pb_guardtower_compound_02", trig.script_index, "a10_explosion", "thick_building_fire_small" );
}
}
Handle_Guard_Tower_Explosion( tower_name, part_radius, fx_name1, fx_name2 )
{
attacker = undefined;
while ( 1 )
{
self waittill( "damage", damage, attacker );
if ( attacker == level.chopper )
{
break;
}
}
fx_origins = GetEntArray( tower_name + "_fx", "targetname" );
fx_origin = self.origin;
foreach ( fx in fx_origins )
{
if ( distancesquared( fx.origin, self.origin ) < part_radius )
{
fx_origin = fx.origin;
break;
}
}
if ( IsDefined( fx_name1 ) )
{
playfx( getfx( fx_name1 ), fx_origin );
}
if ( IsDefined( fx_name2 ) )
{
playfx( getfx( fx_name2 ), fx_origin );
}
parts = GetEntArray( tower_name + "_parts", "script_noteworthy" );
foreach ( part in parts )
{
if ( distancesquared( part.origin, self.origin ) < part_radius )
{
part delete();
}
}
self delete();
}
soap_kills_intro_guys_thread()
{
node = getvehiclenode("soap_kills_guys_node", "script_noteworthy");
node waittill("trigger");
guys = get_ai_group_ai("soap_intro_targets");
foreach(guy in guys)
{
if(isdefined(guy) && isalive(guy))
{
MagicBullet( level.soap.weapon, level.soap gettagorigin( "TAG_INHAND" ), guy geteye() );
if(IsAlive(guy))
{
guy kill(level.soap.origin, level.soap, level.player);
}
}
wait .1;
}
}
intro_civillians()
{
vehicle_node_trigger_wait("bravo_jump_start_node");
aud_send_msg("s1_chopper_by");
civies = array_spawn_targetname("intro_civillians");
foreach(civ in civies)
{
civ.ignoreall = true;
civ set_generic_run_anim( "intro_civilian_A_run", true );
civ putGunAway();
if (IsEndStr(civ.target, "auto136"))
{
aud_send_msg("intro_civies_run_by", civ);
}
}
wait 9;
foreach(civ in civies)
{
if( IsDefined( civ ) )
{
civ Delete();
}
}
}
barrels_explode_thread()
{
vehNode = getvehiclenode("barrels_explode_node","script_noteworthy");
vehNode waittill("trigger");
intro_barrels_target = getstruct("intro_barrels_target", "targetname");
radiusdamage(intro_barrels_target.origin, 500, 500, 500);
}
freeze_at(nodename)
{
node = getvehiclenode(nodename, "targetname");
node waittill("trigger");
self Vehicle_SetSpeed(0, 1000, 1000);
}
gate_closing_guys()
{
guys = array_spawn_targetname("gate_closing_guys", 1);
gate_left = getent("intro_gate_left", "targetname");
gate_right = getent("intro_gate_right", "targetname");
gate_left.animname = "intro_gate";
gate_right.animname = "intro_gate";
gate_left SetAnimTree();
gate_right SetAnimTree();
gatestruct = getstruct("bravo_gate_script_anim_origin", "targetname");
guys[0].animname = "gate_guy_left";
guys[1].animname = "gate_guy_right";
group1[0] = guys[0];
group1[1] = gate_left;
group2[0] = guys[1];
group2[1] = gate_right;
gatestruct anim_first_frame(group1, "gate_close");
gatestruct anim_first_frame(group2, "gate_close");
round_last_corner_node = getvehiclenode("soap_leans_out_node", "script_noteworthy");
round_last_corner_node waittill("trigger");
wait 1.2;
level notify("close_gate");
aud_send_msg("aud_gatecrash_mix");
thread gate_close_guy(group1, gatestruct);
thread gate_close_guy(group2, gatestruct);
}
gate_close_guy(guys, gatestruct)
{
guys[0] endon("death");
gatestruct thread anim_single(guys, "gate_close");
guys[0] waittillmatch("single anim", "allow_kill");
foreach ( guy in guys )
{
if( (guy.animname == "gate_guy_left" ) || ( guy.animname == "gate_guy_right" ) )
{
guy.allowdeath = true;
}
}
}
bravo_truck_gatecrash_anim_thread()
{
bravo_node = getvehiclenode("bravo_gate_node","targetname");
player_node =getvehiclenode("player_truck_gate_node", "targetname");
gatestruct = getstruct("bravo_gate_script_anim_origin", "targetname");
gate_left = getent("intro_gate_left", "targetname");
thread gatecrash_anim( getent("intro_gate_right","targetname"), gatestruct, bravo_node);
thread gatecrash_anim( gate_left, gatestruct, player_node);
thread gatecrash_fx_right( getent("intro_gate_right","targetname"), bravo_node);
thread gatecrash_fx_left( gate_left, player_node);
player_node waittill("trigger");
jeep_blankfx = level._effect["blank"];
level.bravo_hummer thread override_treadfx_all_wheels(jeep_blankfx);
aud_send_msg("s1_gate_crash", gate_left);
lastGateGuy = getentarray("gate_intro_deletemeguy","script_noteworthy");
if(isdefined(lastGateGuy))
{
array_call(lastGateGuy , ::delete);
}
anyoneElseLeft = getentarray("intro_roofguy","script_noteworthy");
if(isdefined(anyoneElseLeft ))
{
array_call(anyoneElseLeft , ::delete, level.player.origin, level.soap);
}
}
gatecrash_anim(gateEnt, originStruct, node)
{
node waittill("trigger");
originStruct thread anim_single_solo( gateEnt, "gate_crash" );
}
gatecrash_fx_left(gateEnt,node)
{
impactFX = level._effect[ "gate_metal_impact" ];
node waittill("trigger");
PlayFXOnTag(impactFX,gateEnt,"fx_tag_left");
window_fx = level._effect[ "car_glass_large_moving" ];
PlayFXOnTag(window_fx,level.alpha_hummer,"TAG_BLOOD");
stop_exploder(1000);
}
gatecrash_fx_right(gateEnt,node)
{
impactFX = level._effect[ "gate_metal_impact" ];
node waittill("trigger");
PlayFXOnTag(impactFX,gateEnt,"fx_tag_right");
}
enable_weapons()
{
self EnableWeapons();
show_hud_after_scripted_sequence();
}
intro_player_events()
{
player_rig = spawn_anim_model( "const_player_jeep_rig_1" );
level.player_rig = player_rig;
level.player AllowCrouch(false);
level.player AllowProne(false);
level.player DisableWeapons();
level.player DisableOffhandWeapons();
level.player AllowSprint(false);
player_rig LinkTo(level.alpha_hummer, CONST_PLAYER_LINKTO, (0,0,0), (0,0,0));
level.player playerlinkto(level.player_rig, "tag_player");
waittillframeend;
wait .1;
level.alpha_hummer anim_first_frame_solo( level.player_rig , "intro_jeep_stand_player", CONST_PLAYER_LINKTO);
level.player SetPlayerAngles(level.player_rig GetTagAngles("tag_player"));
level waittill("slam_zoom_done");
thread intro_rumble();
level.player_rig Show();
level.player PlayerLinkToDelta(level.player_rig, "tag_player", 1.0, 15, 40, 30, 15);
vehicle_node_trigger_wait("player_stand_node");
wait 2.5;
thread notify_Remove_Wall();
level.alpha_hummer anim_single_solo(level.player_rig, "intro_jeep_stand_player", CONST_PLAYER_LINKTO);
vehicle_node_trigger_wait("alpha_jump_start_node");
level.player LerpViewAngleClamp(0.5, 0.1,0.1, 15,15,30,30);
level.alpha_hummer thread anim_single_solo(level.player_rig, "intro_jeep_jump_player", CONST_PLAYER_LINKTO);
vehicle_node_trigger_wait("soap_leans_out_node");
level.player LerpViewAngleClamp(0.5, 0.1,0.1, 40, 40, 30,20);
level.player delayThread( 2.0, ::enable_weapons);
round_last_corner_node = getvehiclenode("round_last_corner_node", "script_noteworthy");
round_last_corner_node waittill("trigger");
wait .2;
level.player PlayerLinkTo(level.player_rig, "tag_player", 0.0, 90, 90, 30, 20);
level.player_rig hide();
barrels_explode_node = GetVehicleNode("barrels_explode_node", "script_noteworthy");
barrels_explode_node waittill("trigger");
wait .7;
level.player_rig show();
level notify("player_exiting_jeep");
level.player DisableWeapons();
wait .1;
level.player PlayerLinkToAbsolute(level.player_rig, "tag_player");
level.alpha_hummer delayThread(2.3, ::vehicle_unload, "driver");
level.player_rig show();
level.alpha_hummer anim_single_solo(level.player_rig, "intro_jeep_exit_player", CONST_PLAYER_LINKTO);
level.player Unlink();
level.player_rig Delete();
level.player EnableWeapons();
level.player EnableOffhandWeapons();
level.player AllowCrouch(true);
level.player AllowProne(true);
level.player AllowSprint(true);
level notify("player_exited_jeep");
}
intro_rumble()
{
level.player PlayRumbleLoopOnEntity("subtle_tank_rumble");
vehicle_node_trigger_wait("alpha_jump_start_node");
wait 1.0;
level.player StopRumble("subtle_tank_rumble");
wait .85;
level.player PlayRumbleOnEntity("grenade_rumble");
wait .8;
level.player PlayRumbleLoopOnEntity("subtle_tank_rumble");
gate_node = getvehiclenode("player_truck_gate_node", "targetname");
gate_node waittill("trigger");
level.player StopRumble("subtle_tank_rumble");
level.player PlayRumbleOnEntity("grenade_rumble");
}
notify_Remove_Wall()
{
wait 10;
sandstorm_fx(2);
}
bravo_guy_signals()
{
level.Murdock.animname = "Murdock";
level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_signals_node", "bravo_intro_signal", level.Murdock, 1, 2.0);
}
barracus_intro_events()
{
level.barracus.animname = "Barracus";
thread barracus_jump_react();
level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_guy_stands_node", "bravo_intro_stand_gatecrash", level.barracus, 2, 8.0, false, "gatecrash");
level.bravo_hummer vehicle_play_guy_anim_at_nodename("bravo_signals_node", "bravo_intro_stand", level.Barracus, 2, 1.0, false);
level.barracus endon("jump");
while(1)
{
level.bravo_hummer vehicle_play_guy_anim("bravo_intro_stand_idle", level.barracus, 2, false);
}
}
barracus_jump_react()
{
vehicle_node_trigger_wait("bravo_splash_node");
level.barracus notify("jump");
level.bravo_hummer vehicle_play_guy_anim("bravo_intro_stand_turn", level.barracus, 2, false);
level.barracus endon( "gatecrash" );
while(1)
{
level.bravo_hummer vehicle_play_guy_anim("bravo_intro_stand_idle_2", level.barracus, 2, false);
}
}
jump_reaction_anims()
{
level.alpha_hummer thread vehicle_play_guy_anim_at_nodename("alpha_jump_start_node", "intro_jump_react", level.price, 0, 0.0);
level.alpha_hummer thread vehicle_play_guy_anim_at_nodename("alpha_jump_start_node", "intro_jump_react", level.soap, 1, 0.0);
level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_jump_start_node", "intro_jump_react", level.Hannibal, 0, 0.0);
level.bravo_hummer thread vehicle_play_guy_anim_at_nodename("bravo_jump_start_node", "intro_jump_react", level.Murdock, 1, 0.0);
vehicle_node_trigger_wait("alpha_jump_start_node");
level.alpha_hummer SetFlaggedAnimRestart( "vehicle_anim_flag", level.alpha_hummer getanim("wheel_turn") );
}
price_intro_anim()
{
level waittill("slam_zoom_done");
animlen = GetAnimLength(level.scr_anim["price"]["intro_price"]);
level thread notify_delay("soap_intro_line", (animlen-2.0));
level.alpha_hummer vehicle_play_guy_anim("intro_price", level.price, 0, false);
level.alpha_hummer.animname = "alpha_hummer";
level.alpha_hummer SetFlaggedAnimRestart( "vehicle_anim_flag", level.alpha_hummer getanim("shift_up") );
level.alpha_hummer vehicle_play_guy_anim("intro_price_shift_up", level.price, 0, true);
}
price_killguy_setup()
{
self thread magic_bullet_shield();
level waittill("price_unloading");
self thread stop_magic_bullet_shield();
self waittill("price_kills_me");
self.noragdoll = 1;
self.a.nodeath = true;
self.ignoreme = true;
self.ignoreall = true;
self.diequietly = true;
self.allowdeath = true;
self DropWeapon(self.weapon, "right", 1);
self gun_remove();
MagicBullet( level.price.weapon, level.price gettagorigin( "tag_flash" ), self geteye() );
if(IsAlive(self))
{
self Kill(level.price.origin, level.price,level.price);
}
}
price_unload_events()
{
level.price.ignoreSuppression = true;
level.price.ignoreall = true;
array_spawn_function_targetname("price_intro_killguys", ::price_killguy_setup);
killguys = array_spawn_targetname("price_intro_killguys");
thread gatecrash_price_victims_anims(killguys, getstruct("bravo_gate_script_anim_origin", "targetname"));
self waittill("unload");
self thread price_exit_jeep_pathing();
level notify("price_unloading");
flag_set("price_intro_targets_move");
level.price gun_recall();
old_primary = self.primaryweapon;
self forceUseWeapon("deserteagle", "secondary");
animscripts\shared::placeWeaponOn( self.secondaryweapon, "right", true );
animscripts\shared::placeWeaponOn( self.primaryweapon, "left", false );
self waittillmatch("animontagdone", "fire");
aud_send_msg("postgate_shot_01");
killguys[0] notify("price_kills_me");
self waittillmatch("animontagdone", "fire");
aud_send_msg("postgate_shot_02");
self waittillmatch("animontagdone", "fire");
aud_send_msg("postgate_shot_03");
killguys[1] notify("price_kills_me");
self waittillmatch("animontagdone", "hide_pistol" );
animscripts\shared::placeWeaponOn( self.secondaryweapon, "none");
self.lastWeapon = self.primaryweapon;
self.weapon = self.primaryweapon;
}
gatecrash_price_victims_anims(victims, origin)
{
victims[0].animname = "price_killguy_1";
victims[1].animname = "price_killguy_2";
origin anim_first_frame(victims, "intro_price_shoots_guys");
player_node =getvehiclenode("player_truck_gate_node", "targetname");
player_node waittill("trigger");
tag = spawn_tag_origin();
tag.origin = origin.origin;
tag.angles = origin.angles;
foreach(vic in victims)
{
vic linkto(tag, "tag_origin");
}
tag anim_single(victims, "intro_price_shoots_guys", "tag_origin");
}
price_exit_jeep_pathing()
{
price_jeep_exit_goal	= getnode("price_jeep_exit_goal", "targetname");
old_radius = self.goalradius;
self SetGoalNode(price_jeep_exit_goal);
self set_forcegoal();
self set_fixednode_true();
self.goalradius = 16;
self waittill("goal");
self set_fixednode_false();
self unset_forcegoal();
self.goalradius = old_radius;
}
intro_hummer_soap_events(soap)
{
level.alpha_hummer thread vehicle_play_guy_anim_on_notify("soap_intro_line", "intro_soap", level.soap, 1);
thread soap_stands();
vehicle_node_trigger_wait("barrels_explode_node");
level notify("soap_sits_down");
level.alpha_hummer vehicle_play_guy_anim("intro_soap_stand_end", level.soap, 1, false);
}
soap_stands()
{
level endon("soap_sits_down");
level.alpha_hummer vehicle_play_guy_anim_at_nodename("alpha_post_land_node", "intro_soap_stand", level.soap, 1, 0.2, false);
while(1)
{
level.alpha_hummer vehicle_play_guy_anim("intro_soap_stand_idle", level.soap, 1, false);
}
}
soap_gun_right(guy)
{
level.soap place_weapon_on(level.soap.weapon, "right");
}
soap_gun_left(guy)
{
level.soap place_weapon_on(level.soap.weapon, "left");
}
intro_technicals()
{
vehicles = maps\_vehicle::scripted_spawn( 10 );
tech1 = vehicles[0];
tech1 thread handle_tech("shootme");
vehicle_node_trigger_wait("alpha_post_land_node");
wait 5.0;
tech1 notify("shootme");
}
handle_tech(event, target, explode_node)
{
self thread maps\_vehicle::godon();
{
}
level waittill("boom");
self thread maps\_vehicle::godoff();
RadiusDamage(self.origin, 100, (self.maxhealth*5), self.maxhealth);
}
bravo_puddlesplash()
{
vehicle_node_trigger_wait("bravo_splash_node");
effectUp = AnglesToUp(level.bravo_hummer.angles);
effectFwd = AnglesToForward(level.bravo_hummer.angles);
jeep_sand_fx = level._effect["pb_jeep_trail"] ;
jeep_treadfx_water = level._effect["pb_jeep_trail_water"] ;
jeep_treadfx_water_left = level._effect["pb_jeep_trail_water_left"] ;
level.bravo_hummer thread override_treadfx_left_wheels(jeep_treadfx_water_left);
level.bravo_hummer thread override_treadfx_right_wheels(jeep_treadfx_water);
level.player thread alpha_screenSplash();
level.bravo_hummer PlaySound("jeep_splash_puddle");
level.bravo_hummer PlaySound("jeep_splash_puddle_face");
wait(.5);
level.bravo_hummer thread override_treadfx_all_wheels(jeep_sand_fx);
}
alpha_screenSplash()
{
wait(.5);
self SetWaterSheeting(1, 2 );
level.player thread maps\_gameskill::grenade_dirt_on_screen( "left" );
}
create_overlay_element( shader_name)
{
overlay = newHudElem();
overlay.x = 0;
overlay.y = 0;
overlay setshader( shader_name, 640, 480 );
overlay.alignX = "left";
overlay.alignY = "top";
overlay.horzAlign = "fullscreen";
overlay.vertAlign = "fullscreen";
return overlay;
}
nikolai_blows_stuff_up()
{
thread nikolai_missiles();
vehicle_node_trigger_wait("alpha_post_land_node");
wait 5.0;
target1 = getent("intro_heli_target1", "targetname");
target_ent = Spawn( "script_origin", level.chopper.origin );
missileAttractor = Missile_CreateAttractorEnt( target_ent, 200000, 5000 );
magicBullet( "rpg", target1.origin+ (0,0,200.0), target_ent.origin );
wait 5.0;
Missile_DeleteAttractor(missileAttractor);
level.chopper thread maps\payback_1_script_d::Chopper_Attack_Target( target1, 0 );
wait 1.0;
radiusdamage(target1.origin, 100, 1000, 1000, level.player);
}
handle_missile(missile, tag, localoffset)
{
missile SetModel("projectile_sidewinder_missile");
missile hide();
dummy = spawn("script_model",(0,0,0));
dummy SetModel("projectile_sidewinder_missile");
dummy LinkTo(level.chopper, tag, localoffset, (0,0,0));
missile waittill("launch");
missile Vehicle_Teleport(dummy.origin, dummy.angles);
missile show();
dummy delete();
mytarget = GetVehicleNode(missile.target, "targetname");
missile StartPath(mytarget);
missile Vehicle_SetSpeedImmediate(level.chopper Vehicle_GetSpeed() -30, 100, 100);
wait .45;
fx = getfx( "f15_missile" );
PlayFXOnTag( fx, missile, "tag_origin" );
aud_send_msg("s1_chopper_missiles");
wait .2;
missile Vehicle_SetSpeed(300, 150, 200);
missile waittill("reached_dynamic_path_end");
level notify("boom");
aud_send_msg("intro_rockets_hit");
missile delete();
}
nikolai_missiles()
{
missile1 = spawn_vehicle_from_targetname("intro_nikolai_missile_1");
missile2 = spawn_vehicle_from_targetname("intro_nikolai_missile_2");
thread handle_missile(missile1, "tag_flash_2", (0, 15, 0));
thread handle_missile(missile2, "tag_flash_22", (0, -15, 0));
fire_missile_node = getstruct("nikolai_fires_missiles_node", "script_noteworthy");
fire_missile_node waittill("trigger");
wait 1.75;
missile1 notify("launch");
wait 0.3;
missile2 notify("launch");
}
set_introguys_ignoreme(ignoreme)
{
level.price.ignoreme = ignoreme;
level.soap.ignoreme = ignoreme;
level.player.ignoreme = ignoreme;
level.barracus.ignoreme = ignoreme;
level.hannibal.ignoreme = ignoreme;
level.Murdock.ignoreme = ignoreme;
}
hack_shadow_quality()
{
vehicle_node_trigger_wait("alpha_jump_start_node");
setsaveddvar( "sm_sunSampleSizeNear", 0.60 );
vehicle_node_trigger_wait("barrels_explode_node");
setsaveddvar( "sm_sunSampleSizeNear", 0.25 );
}
manage_intro_viewdistance()
{
if(DISABLE_INTRO_FOG_HACK)
{
return;
}
maps\_utility::vision_set_fog_changes( "payback_intro1", 0 );
SetCullDist(15000);
vehicle_node_trigger_wait("barrels_explode_node");
wait 0.5;
SetCullDist(0);
maps\_utility::vision_set_fog_changes( "payback", 1.0 );
}
reset_chopper_treadfx()
{
vehicle_node_trigger_wait("barrels_explode_node");
maps\_treadfx::main( "script_vehicle_payback_hind");
}
bravo_wheel_skidmark_hack()
{
self.tagleftWheelHack = self setup_wheel_rubicon_treadmark_tag("tag_wheel_back_left");
self.tagrightWheelHack = self setup_wheel_rubicon_treadmark_tag("tag_wheel_back_right");
}
setup_wheel_rubicon_treadmark_tag(wheeltag)
{
tag_origin = spawn_tag_origin();
tag_origin LinkTo(self, wheeltag, (0,0,0),(-90,0,0));
return tag_origin;
}
intro_slamzoom()
{
level.snap_zoom_start_ent = spawn_tag_origin();
level.snap_zoom_start_ent.origin = level.alpha_hummer getTagOrigin(CONST_PLAYER_LINKTO);
level.snap_zoom_start_ent.angles = level.alpha_hummer.angles;
level.player PlayerSetStreamOrigin( level.snap_zoom_start_ent.origin );
level.snap_zoom_start_ent.origin += (0,0, 4000);
level.snap_zoom_end_ent = spawn_tag_origin();
level.snap_zoom_end_ent.origin = level.alpha_hummer getTagOrigin(CONST_PLAYER_LINKTO);
level.snap_zoom_end_ent.angles = level.alpha_hummer.angles;
level.snap_zoom_end_ent linkto(level.alpha_hummer, CONST_PLAYER_LINKTO, (0,0,0), (0,0,0));
ground_origin = level.snap_zoom_end_ent.origin;
ground_angles = level.snap_zoom_end_ent.angles;
start_ent = level.snap_zoom_start_ent;
start_angles = start_ent.angles;
start_origin = start_ent.origin;
lerp_time = 1.0;
hummer_speed = 38;
hummer_dir = anglestoforward(level.alpha_hummer.angles);
offset = hummer_dir * lerp_time * hummer_speed * CONST_MPHTOIPS * .9;
ground_origin += offset;
start_origin += offset;
aud_send_msg("player_slamzoom");
flying_ent = Spawn( "script_origin", start_origin );
angles = VectorToAngles( ground_origin - start_origin );
flying_ent.angles = (angles[0], start_ent.angles[1], angles[2]);
org = level.player.origin;
level.player PlayerLinkTo( flying_ent, undefined, 1, 0, 0, 0, 0 );
level.player SetOrigin( flying_ent.origin );
flying_ent MoveTo( ground_origin, lerp_time, 0, 0.5 );
level.player LerpFOV( 65, 2.5 );
wait(lerp_time - .3);
flying_ent RotateTo( ground_angles, 0.3, 0.15, 0.15 );
wait( 0.3 );
level notify("slam_zoom_done");
SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "whatever", true );
level.player FreezeControls( false );
level.player PlayerClearStreamOrigin();
wait .1;
flying_ent Delete();
}

