#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\payback_util;
#include maps\_audio;
init_compound_c_flags()
{
flag_init( "flag_entered_compound" );
flag_init("compound_fire_rpg");
flag_init("compound_soap_clear_right");
flag_init("sidehall_guy_dead");
flag_init("stair_guy_dead");
flag_init("compound_soap_stairs_clear");
flag_init("compound_stair_landing1");
flag_init("compound_upstairs1");
flag_init("compound_upstairs2");
flag_init("compound_upstairs3");
flag_init("compound_upstairs4");
flag_init("compound_door_shooter");
flag_init("price_in_position");
flag_init("compound_soap_kick_door");
flag_init("compound_int_see_door");
flag_init("wilhelm_over");
}
compound_c_jumpto()
{
texploder(2300);
exploder(2000);
exploder(2500);
aud_send_msg("s1_main_compound");
thread sandstorm_fx(2);
thread init_kick_doors();
thread compound_curtain_anims();
player_start = getstruct( "start_courtyard", "targetname" );
level.player setOrigin( player_start.origin );
level.player setPlayerAngles( player_start.angles );
objective_state (obj( "obj_kruger" ), "current");
maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
level.price = spawn_ally("price");
level.soap = spawn_ally("soap");
level.hannibal = spawn_ally("hannibal");
level.barracus = spawn_ally("barracus");
level.murdock = spawn_ally("murdock");
level.player thread maps\payback_1_script_b::no_prone_water_trigger();
maps\payback_1_script_d::chopper_main();
flag_clear("chopper_give_player_control");
level.price thread dialogue_queue( "payback_pri_bravoteamsecure_r" );
main();
}
main()
{
thread compound_downstairs();
thread compound_upstairs_hall();
thread compound_enemy_battlechatter();
kruger_breach_use_trig = GetEnt( "trigger_use_breach", "classname" );
kruger_breach_use_trig trigger_off();
flag_wait("compound_upstairs2");
level.hannibal thread bravo_bullet_shield("hannibal_spawned");
level.barracus thread bravo_bullet_shield("barracus_spawned");
level.murdock thread bravo_bullet_shield("murdock_spawned");
}
compound_fire_rpg()
{
flag_wait("compound_fire_rpg");
autosave_by_name("enter_compound");
}
compound_downstairs()
{
thread compound_fire_rpg();
flag_wait( "compound_fire_rpg" );
SetSavedDvar( "objectiveFadeTooFar", 5 );
Objective_OnEntity( obj( "obj_kruger" ), level.price , (0,0,50) );
Objective_SetPointerTextOverride( obj( "obj_kruger" ) , "" );
level.soap.notarget = true;
level.soap.ignoreme = true;
level.price.notarget = true;
level.price.ignoreme = true;
soap_path = GetNode("compound_path_soap1", "targetname");
price_path = GetNode("price_compound_node03", "targetname");
player_speed_percent(85);
level.price enable_interior_compound_behavior();
level.soap enable_interior_compound_behavior();
level.price thread Follow_Path(price_path);
wait 1;
level.soap thread Follow_Path(soap_path);
thread price_vo_lines();
thread soap_vo_lines();
price_vo_trigger = GetEnt("price_clear_left_trigger","targetname");
price_hit_trigger = false;
while(!price_hit_trigger)
{
price_vo_trigger waittill( "trigger", dude );
if ( dude == level.price )
{
price_hit_trigger = true;
}
wait(0.05);
}
level.price thread dialogue_queue( "payback_pri_clearleft1_r" );
thread first_floor_clear_vo();
flag_wait("compound_stair_landing2");
level.soap.notarget = false;
level.soap.ignoreme = false;
level.price.notarget = false;
level.price.ignoreme = false;
}
compound_curtain_anims()
{
compound_curtains1 = GetEnt( "compound_curtains1", "targetname" );
compound_curtains2 = GetEnt( "compound_curtains2", "targetname" );
compound_curtains_node = GetEnt( "first_floor_curtains", "targetname" );
compound_curtains1.animname = "compound_curtains";
compound_curtains1 setanimtree();
wait( RandomFloatRange( 0.0 , 1.5 ));
compound_curtains_node thread anim_loop_solo( compound_curtains1, "lower_curtains_01", "stop_looping_curtain_anims" );
compound_curtains2.animname = "compound_curtains";
compound_curtains2 setanimtree();
wait( RandomFloatRange( 0.0 , 1.5 ));
compound_curtains_node thread anim_loop_solo( compound_curtains2, "lower_curtains_02", "stop_looping_curtain_anims" );
flag_wait("start_construction_anims");
compound_curtains1 notify("stop_looping_curtain_anims");
compound_curtains1 delete();
compound_curtains2 notify("stop_looping_curtain_anims");
compound_curtains2 delete();
}
price_vo_lines()
{
level.price dialogue_queue( "payback_pri_baseplatetarget" );
level.player radio_dialogue( "payback_eol_prepforexfil" );
}
soap_vo_lines()
{
flag_wait("compound_soap_clear_right");
level.soap thread dialogue_queue( "payback_mct_clearright1_r" );
}
first_floor_clear_vo()
{
level.price waittill("reached_path_end");
level.price dialogue_queue( "payback_pri_firstfloorclear" );
level.player radio_dialogue("payback_eol_proceedtosecond");
}
compound_upstairs_hall()
{
flag_wait("compound_stair_landing1");
thread compound_kill_rooftop_mg_guys();
if ( !flag("compound_stair_landing2") )
{
level.price thread dialogue_queue( "payback_pri_wahtthecorners_r" );
}
flag_wait("compound_stair_landing2");
thread chopper_flyby();
thread close_kick_doors();
objective_state( obj ( "follow1" ) , "invisible" );
thread balcony_guys();
flag_wait("compound_upstairs1");
level.price thread dialogue_queue("payback_pri_contactfront");
player_speed_percent(100);
level.price thread disable_interior_compound_behavior(0);
level.soap thread disable_interior_compound_behavior(0);
}
breach_lead_up_vo()
{
level endon( "A door in breach group 1 has been activated." );
level.price dialogue_queue( "payback_pri_bravooneposition" );
wait .75;
radio_dialogue( "payback_brvl_flankingtoback" );
wait .5;
while (level.price.animname == "generic")
{
wait 0.15;
}
level.price dialogue_queue( "payback_pri_office" );
}
balcony_guys()
{
balc_guys = array_spawn_targetname( "compound_wave2b", "targetname" );
array_thread(balc_guys, ::run_and_delete);
flag_wait("compound_upstairs2");
autosave_by_name( "compound_floor2" );
thread breach_lead_up_vo();
thread soap_kick_door();
thread price_kick_door();
thread compound_door_shooter();
enemies = array_spawn_targetname( "compound_wave3_left", "targetname" );
spawner = getEnt( "compound_anim_overbalcony_ai" , "targetname" );
level.wilhelm = spawner spawn_ai();
if ( IsDefined(level.wilhelm) )
{
level.wilhelm.notarget = true;
level.wilhelm.ignoreme = true;
level.wilhelm.ignoreall = true;
level.wilhelm thread wake_up_when_player_close(200);
enemies = array_add(enemies, level.wilhelm);
}
thread ai_array_killcount_flag_set(enemies, (enemies.size-3), "compound_upstairs3");
thread ai_array_killcount_flag_set(enemies, enemies.size, "compound_upstairs4");
thread balcony_room_dynamic_accuracy(enemies);
soap_accuracy = level.soap.baseaccuracy;
price_accuracy = level.soap.baseaccuracy;
level.soap.baseaccuracy = level.soap.baseaccuracy * 2;
level.price.baseaccuracy = level.price.baseaccuracy * 2;
flag_wait("compound_upstairs3");
level.soap.baseaccuracy = 1000;
level.price.baseaccuracy = 1000;
activate_trigger_with_targetname("compound_int_last_room");
flag_wait("compound_upstairs4");
flag_wait("compound_soap_kick_door");
level.soap.baseaccuracy = soap_accuracy;
level.price.baseaccuracy = price_accuracy;
thread maps\payback_1_script_e::setup_breach();
}
wake_up_when_player_close(range)
{
level endon("death");
self endon("death");
self waittill_entity_in_range(level.player, range);
self.ignoreall = false;
wait 10;
if (IsDefined(self) && IsAlive(self))
{
self GetEnemyInfo(level.player);
self.ignoreme = false;
self.notarget = false;
self set_fixednode_false();
self set_goal_radius(500);
self SetGoalEntity(level.player);
}
}
balcony_room_dynamic_accuracy(guys)
{
control_enemy_accuracy(guys, 0.75);
level waittill("price_in_fight");
if (!flag("compound_upstairs4"))
{
control_enemy_accuracy(guys, 1.0);
flag_wait("wilhelm_over");
if (!flag("compound_upstairs4"))
{
control_enemy_accuracy(guys, 1.5);
}
}
}
control_enemy_accuracy(guys, accuracy)
{
foreach (guy in guys)
{
if (IsDefined(guy) && IsAlive(guy))
{
guy.baseaccuracy = accuracy;
}
}
}
run_and_delete()
{
self endon("death");
self waittill("goal");
wait 1;
if (flag("compound_upstairs2"))
{
self.ignoreall = false;
self.ignoreme = false;
wait 1;
self GetEnemyInfo(level.player);
}
else
{
self Delete();
}
}
compound_door_shooter()
{
flag_wait("compound_door_shooter");
if (!flag("compound_soap_kick_door"))
{
guys = GetEntArray("compound_door_shooter", "script_noteworthy");
foreach (guy in guys)
{
if (IsAlive(guy))
{
targ = GetEnt("compound_door_targ", "targetname");
guy SetEntityTarget(targ);
wait 2;
guy ClearEntityTarget();
}
}
}
}
chopper_flyby()
{
flag_wait("compound_stair_landing2");
wait(3);
chopper_path = getvehiclenode( "chopper_balcony_flyby_structB", "targetname" );
level.chopper notify( "chopper_new_path" );
level.chopper notify( "end_strafing_run" );
level.chopper vehicle_teleport( chopper_path.origin , chopper_path.angles );
level.chopper ClearLookAtEnt();
level.chopper SetMaxPitchRoll(80,80);
level.chopper StartPath(chopper_path);
level.chopper Vehicle_SetSpeedImmediate( 50, 20, 20 );
aud_send_msg("compound_chopperby");
level.player radio_dialogue("payback_nik_2ndflrbalcony");
level.player radio_dialogue("payback_eol_2ndfloor");
level.chopper waittill("reached_end_node");
bye_node = getvehiclenode( "post_compound_heli_flyoff", "targetname" );
level.chopper SetVehGoalPos(bye_node.origin, 1);
wait(15);
level.chopper delete();
}
enable_interior_compound_behavior()
{
self enable_cqbwalk();
self disable_surprise();
self.ignoreSuppression = true;
self.IgnoreRandomBulletDamage = true;
self.ignoreExplosionEvents = true;
self.disableBulletWhizbyReaction = true;
self.dontavoidplayer = true;
self.grenadeWeapon = "flash_grenade";
self.grenadeAmmo = 0;
}
disable_interior_compound_behavior( baseacc )
{
self disable_cqbwalk();
self enable_surprise();
self.ignoreSuppression = false;
self.IgnoreRandomBulletDamage = false;
self.ignoreExplosionEvents = false;
self.disableBulletWhizbyReaction = false;
self.dontavoidplayer = false;
}
compound_enemy_battlechatter()
{
level.player endon( "death" );
while ( !flag( "compound_int_see_door" ))
{
enemies = GetAIArray( "axis" );
if ( enemies.size > 0 )
{
index = RandomIntRange( 0 , enemies.size );
enemy = enemies[index];
if ( IsAlive(enemy))
{
enemy custom_battlechatter( "order_move_combat" );
}
}
else
{
break;
}
wait( RandomFloatRange( 1.5 , 5.0 ));
}
}
compound_kill_rooftop_mg_guys()
{
dead_men = GetEntArray("rooftop_mg", "script_noteworthy");
foreach(mens in dead_men)
{
if (IsAlive(mens))
{
mens Kill();
}
}
}
init_kick_doors()
{
door1 = GetEnt("compound_price_door_r", "targetname");
door2 = GetEnt("compound_price_door_l", "targetname");
door1 ConnectPaths();
door2 ConnectPaths();
door1 RotateYaw(-120,0.1);
door2 RotateYaw(120,0.1);
}
close_kick_doors()
{
door1 = GetEnt("compound_price_door_r", "targetname");
door2 = GetEnt("compound_price_door_l", "targetname");
door1 RotateYaw(120,0.1);
door2 RotateYaw(-120,0.1);
wait 0.2;
door1 DisConnectPaths();
door2 DisConnectPaths();
}
soap_kick_door()
{
level.soap PushPlayer( true );
animname = level.soap.animname;
level.soap disable_ai_color();
level.soap.animname = "generic" ;
goalnode = GetNode( "soap_door_kick_node" , "targetname" );
goalnode anim_reach_and_approach_node_solo( level.soap, "doorkick_2_stand");
flag_set("compound_soap_kick_door");
thread doors_open_from_kick("compound_soap_door_l", "compound_soap_door_r");
goalnode anim_single_solo_run( level.soap, "doorkick_2_stand" );
level.soap PushPlayer( false );
level.soap.animname = animname;
level.soap enable_ai_color();
level.soap.ignoresuppression = true;
soap_over_balcony_sequence();
}
price_kick_door()
{
level.price PushPlayer( true );
animname = level.price.animname;
level.price disable_ai_color();
goalnode = GetNode( "price_door_kick_node" , "targetname" );
goalnode anim_reach_and_approach_node_solo( level.price, "doorkick_2_stand");
flag_set("price_in_position");
level.price.animname = "generic" ;
thread doors_open_from_kick("compound_price_door_l", "compound_price_door_r");
goalnode anim_single_solo_run( level.price, "doorkick_2_stand" );
level.price PushPlayer( false );
level.price.animname = animname;
level.price enable_ai_color();
level notify("price_in_fight");
}
doors_open_from_kick(left_door, right_door)
{
wait 0.4;
doorl = GetEnt( left_door, "targetname" );
doorl ConnectPaths();
doorr = GetEnt( right_door, "targetname" );
doorr ConnectPaths();
doorr RotateYaw( (-80 + randomIntRange(-10,10)), 0.15 );
doorl RotateYaw( (80 + randomIntRange(-10,10)), 0.15 );
wait(RandomFloatRange(0.05, 0.1));
doorr playSound("pybk_door_kick");
wait(RandomFloatRange(0.05, 0.15));
doorl playSound("pybk_door_kick");
}
soap_over_balcony_sequence()
{
ref = getStruct( "compound_anim_overbalcony" , "targetname" );
if (IsDefined(level.wilhelm) && IsAlive(level.wilhelm) && level.wilhelm.ignoreall == true)
{
level.wilhelm.animname = "generic";
ref thread anim_reach_solo( level.wilhelm , "payback_comp_balcony_kick_enemy" );
ref anim_reach_solo( level.soap , "payback_comp_balcony_kick_soap" );
if (IsDefined(level.wilhelm) && IsAlive(level.wilhelm))
{
ref thread anim_single_solo( level.soap , "payback_comp_balcony_kick_soap" );
ref thread anim_single_solo( level.wilhelm , "payback_comp_balcony_kick_enemy" );
aud_send_msg("soap_over_balcony", level.wilhelm);
level.wilhelm.a.nodeath = true;
level.wilhelm WiiSetAllowRagdoll(true);
level.wilhelm Kill();
}
}
level.soap enable_ai_color();
level.soap.ignoresuppression = false;
flag_set("wilhelm_over");
}
