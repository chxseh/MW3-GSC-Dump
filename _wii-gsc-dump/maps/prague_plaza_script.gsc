#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_code;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;
start_plaza()
{
level.player vision_set_fog_changes( "prague_courtyard2", 1 );
spawn_sandman();
set_start_positions( "start_plaza" );
flag_set( "start_sewers" );
flag_set( "player_out_of_water" );
flag_set( "start_alcove" );
flag_set( "start_alley" );
flag_set( "start_long_convoy" );
flag_set( "start_courtyard" );
flag_set( "pre_courtyard_ally_clean_up" );
thread magic_smoke( "plaza_smoke" );
wait( 1.0 );
}
plaza_setup()
{
trigger = get_Target_Ent( "player_infrontof_apartment_gate" );
trigger trigger_off();
thread flare();
thread flare_two();
thread btrs_pass_by();
thread rebels_in_building();
thread tank_near_miss_player();
thread hurt_ally_controller();
thread vectors_and_fx();
thread lights_on_and_off();
thread player_death_trigger();
name = getstruct( "rpg_stack_struct", "targetname");
thread rpg_logic( name );
thread converstaion_in_building();
}
flare()
{
flag_wait( "fire_flare" );
paired_death_restart();
thread flare_talk();
thread maps\_flare_no_sunchange::flare_from_targetname( "flare" );
level waittill( "flare_explodes" );
last_visionset = level.player.vision_set_transition_ent.vision_set;
level.player vision_set_fog_changes( "prague_flare", 1 );
level waittill( "flare_done" );
level.player vision_set_fog_changes( last_visionset, 2 );
}
flare_two()
{
flag_wait( "fire_flare_two" );
paired_death_restart();
thread maps\_flare_no_sunchange::flare_from_targetname( "flare_two" );
level waittill( "flare_explodes" );
last_visionset = level.player.vision_set_transition_ent.vision_set;
level.player vision_set_fog_changes( "prague_flare", 1 );
level waittill( "flare_done" );
level.player vision_set_fog_changes( last_visionset, 2 );
}
flare_talk()
{
wait( 2.0 );
thread display_hint_timeout( "short_scope", 5 );
}
btrs_pass_by()
{
level.origin_repulsor_two = spawn( "script_origin", ( 15107, -12768, -78.5) );
waitframe();
level.repulsor_two = Missile_CreateRepulsorEnt( level.origin_repulsor_two, 10000, 1048 );
flag_wait( "plaza_btrs_show_up" );
btrs2 = spawn_vehicle_from_targetname_and_drive( "plaza_btr_attack_two" );
level notify( "turn_death_trigger_on_for_btr" );
btrs2.veh_pathtype = "constrained";
level delaythread( 7, ::rebels_save_the_day, btrs2 );
wait( 1 );
btrs2 thread btr_target_player_two();
thread radio_dialogue( "prague_pri_gettocover" );
delaythread ( 3, ::radio_dialogue, "prague_mct_nowherefast" );
wait( 6 );
btrs2 notify ( "awake" );
flag_set( "btr_attack_plaza" );
flag_wait( "btr_dead_now" );
Objective_OnEntity( obj( "fight" ), level.sandman, ( 0, 0, 35 ) );
tank = spawn_vehicle_from_targetname_and_drive( "plaza_tank_attack" );
tank thread kill_player_if_waits_too_long();
tank thread tank_lights_on();
tank.health = 50000;
tank thread vehicle_lights_on();
tank mgon();
tank.veh_pathtype = "constrained";
tank thread attack_building();
tank thread delete_on_notify( "start_apartment_fight" );
rebel_cover_nodes_six = getent( "rebel_cover_nodes_six", "targetname" );
rebel_cover_nodes_six activate_trigger();
level.sandman waittill( "goal" );
flag_set ( "spotlight_aim_at_sandman" );
wait( 3 );
node = getnode( "sandman_cover_door_before_under", "targetname" );
level.sandman setgoalnode( node );
thread radio_dialogue( "prague_mct_fallback" );
thread follow_me_nag_lines();
fake_goal = GetStruct ( "sandman_stumble_apt_gate", "targetname" );
delayThread( 3, ::flag_set, "spotlight_aim_at_player" );
delaythread( 3, ::music_stop, 3 );
maps\_spawner::killspawner( 5000 );
level.sandman.baseaccuracy = 999;
level.sandman.ignoresuppression = true;
level.sandman disable_pain();
level.sandman disable_bulletwhizbyreaction();
level.sandman disable_surprise();
objective_setpointertextoverride( obj( "fight" ), "" );
objective_position( obj( "fight" ), node.origin );
level.sandman waittill( "goal" );
goal_distance = 300;
while( 1 )
{
if ( distance2d( level.sandman.origin, level.player.origin ) <= goal_distance )
{
break;
}
wait( 0.05 );
}
node = getnode( "sandman_cover_before_kick", "targetname" );
level.sandman setgoalnode( node );
goal_distance = 300;
while( 1 )
{
if ( distance2d( level.sandman.origin, level.player.origin ) <= goal_distance )
{
break;
}
wait( 0.05 );
}
badplace_cylinder( "dont_shoot_from_behind", 300, ( 14256, -12582, -72 ), 800, 200, "axis" );
level notify( "plaza_player_at_building" );
Objective_OnEntity( obj( "fight" ), level.sandman, ( 0, 0, 35 ) );
level.sandman.ignoreall = true;
level.sandman.ignoreme = true;
level.sandman.baseaccuracy = 0.5;
node = get_target_ent( "sandman_kick_apt_gate" );
thread radio_dialogue( "prague_snd_thisway2" );
node anim_reach_solo( level.sandman, "door_kick_2_cqbwalk" );
node thread anim_generic_run( level.sandman, "door_kick_2_cqbwalk" );
door_l = get_target_ent( "apartment_gate_l" );
door_r = get_target_ent( "apartment_gate_r" );
kick_double_door_open( door_l, door_r, "scn_prague_metal_door_kick", undefined, get_target_ent( "apartment_gate_fxnode" ) );
trigger = get_Target_Ent( "player_infrontof_apartment_gate" );
trigger trigger_on();
level.sandman.goalradius = 128;
level.sandman enable_cqbwalk();
level.sandman disable_dynamic_run_speed();
battlechatter_off( "allies" );
level.sandman set_battlechatter( false );
level.sandman enable_pain();
level.sandman enable_bulletwhizbyreaction();
level.sandman enable_surprise();
thread kill_heli_fx();
stop_last_spot_light();
level.sandman thread follow_path_waitforplayer( get_target_ent( "sandman_apt_enter_path" ) );
flag_wait( "plaza_move_sandman_up" );
level.sandman thread follow_path_waitforplayer( get_target_ent( "sandman_apt_up_stairs" ) );
level.sandman disable_cqbwalk();
}
kill_heli_fx()
{
vehicles = getvehiclearray();
foreach ( v in vehicles )
{
v notify( "stop_kicking_up_dust" );
}
}
kill_player_if_waits_too_long()
{
self endon ( "death" );
wait( 60 );
self setturrettargetent( level.player );
self waittill ( "turret_on_target" );
if( !flag( "plaza_see" ) )
{
self fireweapon();
level.player kill();
wait( 3 );
}
}
tank_lights_on()
{
}
follow_me_nag_lines()
{
level endon( "plaza_player_at_building" );
level endon( "player_at_gate" );
wait( 5 );
while( !flag( "player_at_gate" ) )
{
num = randomintrange( 0, 4 );
switch( num )
{
case 0:
thread radio_dialogue( "prague_mct_goleftgoleft" );
wait( 6.5 );
case 1:
thread radio_dialogue( "prague_mct_getinbuilding" );
wait( 7 );
case 2:
thread radio_dialogue( "prague_mct_getoverhere2" );
wait( 7 );
case 3:
thread radio_dialogue( "prague_pri_yurioffroad" );
wait( 7 );
case 4:
thread radio_dialogue( "prague_mct_offstreetnow" );
wait( 7 );
}
wait( 0.005 );
}
}
converstaion_in_building()
{
flag_wait( "plaza_see" );
wait( 0.3 );
radio_dialogue( "prague_pri_soapstatus" );
wait( 0.3 );
radio_dialogue( "prague_mct_tiptop" );
wait( 0.3 );
radio_dialogue( "prague_mct_findaway" );
wait( 0.3 );
radio_dialogue( "prague_pri_goodluck" );
wait( 1 );
radio_dialogue( "prague_mct_throughhere2" );
}
hurt_ally_controller()
{
flag_wait( "retreat_three" );
trigger = get_Target_Ent( "player_infrontof_apartment_gate" );
trigger waittill( "trigger" );
flag_set( "player_at_gate" );
spawnpoints = getstructarray( "apt_resistance_drone_scene_under", "targetname" );
thread apartment_scene_under( spawnpoints );
flag_wait( "plaza_see" );
level notify( "kill_courtyard_smoke");
thread child_of_men();
spawnpoints = getstructarray( "apt_resistance_drone_scene_under_one", "targetname" );
thread apartment_scene_under_two( spawnpoints );
spawnpoints = getstructarray( "apt_resistance_drone_scene_under_two", "targetname" );
thread apartment_scene_under_two( spawnpoints );
thread spawn_timer_for_drones();
flag_wait( "plaza_see_two_two" );
spawnpoints = getstructarray( "apt_resistance_drone_scene_under_crawl", "targetname" );
thread apartment_scene_under_two( spawnpoints );
}
spawn_timer_for_drones()
{
wait( 0.4 );
}
plaza_resistance_drone_runner_think()
{
self.goalradius = 400;
self.goalheight = 400;
self.disablepain = true;
self.health = 10000;
}
attack_building()
{
vec1 = spawn( "script_origin", ( 15046, -11947, 12 ) );
vec2 = spawn( "script_origin", ( 14800, -11949, 292 ) );
vec3 = spawn( "script_origin", ( 15052.5, -11945.5, 311 ) );
vec4 = spawn( "script_origin", ( 14241.4, -12234.6, 38.2986 ) );
vec5 = spawn( "script_origin", ( 14615.7, -12226.5, 200.996 ) );
self thread tank_near_miss_player( );
wait( 5.5 );
self setturrettargetent( vec1 );
self waittill ( "turret_on_target" );
self fireweapon();
Earthquake( 1, 1, level.player.origin, 400 );
PlayFX( level._effect[ "explosion_type_1" ], vec1.origin , ( 0,100,5 ) );
wait( 1 );
flag_wait ( "tank_attack_building" );
wait( 2 );
self setturrettargetent( vec1 );
self waittill ( "turret_on_target" );
self fireweapon();
wait( 0.5 );
Earthquake( 1, 0.7, level.player.origin, 400 );
PlayFX( level._effect[ "explosion_type_1" ], vec1.origin , ( 0,100,5 ) );
wait( 3 );
self setturrettargetent( vec2 );
self waittill ( "turret_on_target" );
self fireweapon();
PlayFX( level._effect[ "explosion_type_1" ], vec2.origin , ( 0,100,5 ) );
Earthquake( 1, 0.7, level.player.origin, 400 );
wait( 3 );
self setturrettargetent( vec3 );
self waittill ( "turret_on_target" );
self fireweapon();
Earthquake( 1, 0.7, level.player.origin, 400 );
PlayFX( level._effect[ "explosion_type_1" ], vec3.origin , ( 0,100,5 ) );
}
tank_near_miss_player()
{
trigger = get_Target_Ent( "player_infrontof_apartment_gate" );
trigger waittill( "trigger" );
level notify( "turn_death_trigger_on" );
vec4 = spawn( "script_origin", ( 14384, -12254, 0 ) );
Earthquake( 1, 0.7, level.player.origin, 400 );
vec4 playsound ( "scn_prague_tank_explode_building");
PlayFx( getfx( "tank_impact_exaggerated" ), vec4.origin , ( 0,100,5 ) );
flag_wait( "apart_blowup_window_2nd" );
maps\_spawner::killspawner( 5002 );
Earthquake( 1, 0.7, level.player.origin, 400 );
play_sound_in_space( "scn_prague_tank_explode_building", ( 15062, -11964, 147 ) );
}
player_death_trigger()
{
trigger_array = getentarray( "courtyard_death_trigger", "targetname" );
foreach( ent in trigger_array )
{
ent thread death_trigger_think();
}
trigger = getent( "courtyard_kill_player_early", "targetname" );
trigger waittill( "trigger" );
PlayFx( getfx( "tank_impact_exaggerated" ), level.player.origin );
wait( 0.1 );
level.player kill();
}
death_trigger_think()
{
self trigger_off();
level waittill( "turn_death_trigger_on" );
self trigger_on();
self waittill( "trigger" );
PlayFx( getfx( "tank_impact_exaggerated" ), level.player.origin );
wait( 0.1 );
level.player kill();
}
death_trigger_two_think()
{
trigger = GetEnt( "courtyard_tank_killer", "targetname" );
self trigger_off();
level waittill( "turn_death_trigger_on_for_btr" );
self trigger_on();
self waittill( "trigger" );
PlayFx( getfx( "tank_impact_exaggerated" ), level.player.origin );
wait( 0.1 );
level.player kill();
}
rebels_save_the_day( btrs2 )
{
MagicBullet( "rpg_straight",( 15030, -11864, -12 ), ( 14507, -13040, 7 ) );
wait( 0.7 );
MagicBullet( "rpg",( 14696, -11972, 192 ), ( 15424, -12640, 64 ) );
wait( 1.7 );
MagicBullet( "rpg_straight",( 14689.5, -11972.5, 474.5 ), btrs2.origin + ( 0, 0, 400 ) );
wait( 0.6 );
flag_set( "player_take_out_btr" );
btrs2 waittill( "death" );
flag_set( "btr_dead_now" );
Earthquake( 0.7, 0.7, level.player.origin, 400 );
thread rpg_weapon_switch();
thread heli_support();
wait( 2.5 );
thread radio_dialogue( "prague_mct_itsdown" );
wait( 1.3 );
flag_set( "tank_attack_building" );
}
heli_support()
{
heli1 = spawn_vehicle_from_targetname_and_drive ( "plaza_heli_support_one" );
heli1 thread helicopter_searchlight_on();
heli1 thread delete_on_notify( "start_apartment_fight" );
wait( 0.3 );
flag_wait ( "spotlight_aim_at_sandman" );
heli1 helicopter_setturrettargetent( level.sandman );
flag_wait ( "spotlight_aim_at_player" );
heli1 helicopter_setturrettargetent( level.player );
heli1 waittill( "death" );
heli1 thread helicopter_searchlight_off();
}
rebels_in_building()
{
trigger = get_Target_Ent( "player_infrontof_apartment_gate" );
trigger waittill( "trigger" );
flag_set( "start_apartments" );
while( !flag( "apart_blowup_window_2nd" ) )
{
wait( 0.05 );
}
thread plaza_clean_up();
}
apartment_scene_under( spawnpoints )
{
spawner = get_target_ent( "apt_resistance_drone_spawner_under" );
foreach ( p in spawnpoints )
{
spawner.origin = p.origin;
spawner.angles = p.angles;
if ( isdefined( p.target ) )
{
spawner.target = p.target;
}
drone = spawner spawn_ai( true );
if ( IsDefined( p.script_noteworthy ) )
{
drone thread maps\_drone::drone_fight( p.script_noteworthy, p );
if ( IsSubStr( p.animation, "death" ) )
drone.deathanim = getgenericanim( p.animation );
}
else if ( IsDefined( p.animation ) )
{
switch ( p.animation )
{
case "roadkill_cover_soldier_idle":
break;
default:
drone gun_remove();
break;
}
p delayThread( RandomFloatRange( 0, 1 ), ::anim_generic_loop, drone, p.animation );
}
else
{
}
spawner.target = undefined;
}
}
apartment_scene_under_two( spawnpoints )
{
spawner = get_target_ent( "apt_resistance_drone_spawner_under" );
foreach ( p in spawnpoints )
{
spawner.origin = p.origin;
spawner.angles = p.angles;
drone = spawner spawn_ai( true );
drone.animname = "generic";
drone.animation = p.animation;
if( IsDefined ( p.script_noteworthy ) && ( p.script_noteworthy == "stand_sit" ) )
drone thread inside_apt_resistance_anim_then_idle_think();
else
drone thread inside_apt_resistance_anim_then_die_think();
}
}
child_of_men()
{
array_spawn_targetname( "plaza_rebel_hero" );
dudes = get_living_ai_array_parameters( "apartment_rebel_hero_one", "parameters" );
foreach( b in dudes )
{
b.goalradius = 10;
b.goalheight = 10;
b magic_bullet_shield();
}
flag_wait( "start_apartment_exit" );
foreach( b in dudes )
{
b stop_magic_bullet_shield();
b delete();
}
}
plaza_clean_up()
{
tank = get_vehicle ( "plaza_tank_attack", "targetname" );
tank delete();
level notify ( "cleanup_dead_bodies_three" );
guys = get_living_ai_array( "rooftop_courtyard_apt_resistance", "parameters" );
for( i = 0; i < guys.size; i++ )
{
guys[ i ] dodamage( guys[ i ].health + 300, guys[ i ].origin );
}
guys = get_living_ai_array( "courtyard_apt_resistance_five", "script_noteworthy" );
for( i = 0; i < guys.size; i++ )
{
guys[ i ] dodamage( guys[ i ].health + 300, guys[ i ].origin );
}
guys = get_living_ai_array( "courtyard_apt_resistance_three", "script_noteworthy" );
for( i = 0; i < guys.size; i++ )
{
guys[ i ] dodamage( guys[ i ].health + 300, guys[ i ].origin );
}
guys = get_living_ai_array( "courtyard_apt_resistance_two", "script_noteworthy" );
for( i = 0; i < guys.size; i++ )
{
guys[ i ] dodamage( guys[ i ].health + 300, guys[ i ].origin );
}
guys = get_living_ai_array( "rebels_ground", "script_noteworthy" );
for( i = 0; i < guys.size; i++ )
{
guys[ i ] dodamage( guys[ i ].health + 300, guys[ i ].origin );
}
axis = getaiarray( "axis" );
foreach ( b in axis )
{
b dodamage( b.health + 300, b.origin );
}
trigger_array = getentarray( "courtyard_death_trigger", "targetname" );
foreach ( b in trigger_array )
{
b delete();
}
heli = get_vehicle( "plaza_heli_support_one", "targetname" );
if( IsAlive( heli ) )
{
heli thread stop_last_spot_light();
heli delete();
}
}
shootMG()
{
diff = getdifficulty();
if ( diff == "hard" || diff == "fu" )
{
foreach ( mg in self.mgturret )
{
mg notify( "stop_burst_fire_unmanned" );
mg setTargetEntity( level.player );
}
}
while( 1 )
{
foreach ( mg in self.mgturret )
{
mg maps\_mgturret::DoShoot();
}
wait( RandomFloatRange( 0.1, 0.2 ) );
if ( cointoss() )
wait( RandomFloatRange( 3, 7 ) );
}
}
btr_target_player_two()
{
self endon( "death" );
self endon( "stop_shooting" );
if ( IsDefined( self.fxtag ) )
{
StopFXOnTag( getfx( "heli_spotlight_cheap" ), self, self.fxtag );
StopFXOnTag( getfx( "heli_spotlight" ), self, self.fxtag );
}
self childthread shootMG();
wait( 7 );
time = 0;
while ( IsAlive( level.player ) )
{
if ( self can_see_player_two() )
{
time ++;
if( time <= 3 )
{
self SetTurretTargetEnt( level.player, ( 0,30,100 ) );
self.mgturret[0].accuracy = 0.2;
self.mgturret[0].playerspread = 0;
}
else if( time <= 5 )
{
self SetTurretTargetEnt( level.player, ( 0, 15, 40 ) );
self.mgturret[0].accuracy = 0.5;
self.mgturret[0].playerspread = 0;
}
else if( time <= 6 )
{
self SetTurretTargetEnt( level.player );
self.mgturret[0].accuracy = 0.7;
self.mgturret[0].playerspread = 0;
}
else if( time >= 9 )
{
self SetTurretTargetEnt( level.player );
self.mgturret[0].accuracy = 99999;
self.mgturret[0].playerspread = 0;
}
self.mgturret[0].favoriteenemy = level.player;
}
else if ( !self can_see_player_two() )
{
time = 0;
self.baseaccuracy = 0.05;
}
wait( 0.005 );
self fire_at_target_two();
}
}
fire_at_target_two()
{
burstsize = RandomIntRange( 3, 7 );
fireTime = 0.1;
for ( i = 0; i < burstsize; i++ )
{
if( level.btr_turret_in_use == 0)
{
level.btr_turret_in_use = 1;
self FireWeapon();
wait fireTime;
}
if ( burstsize >= 3 )
{
wait randomfloatrange( 0.7, 3 );
level.btr_turret_in_use = 0;
}
}
}
can_see_player_two()
{
player = level.player;
tag_flash_loc = self GetTagOrigin( "tag_flash" );
player_eye = player GetEye();
if ( SightTracePassed( tag_flash_loc, player_eye, false, self ) )
{
if ( IsDefined( level.debug ) )
Line( tag_flash_loc, player_eye, ( 0.2, 0.5, 0.8 ), 0.5, false, 60 );
return true;
}
else
{
return false;
}
}
vectors_and_fx()
{
fx_to_play = level._effect[ "electrical_transformer_spark_runner_lon" ];
vec1 = spawn( "script_origin", ( 14206.1, -11606.3, 6.94517 ) );
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = spawn( "script_origin", ( 14198.1, -11606.2, 46.2516 ) );
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = spawn( "script_origin", ( 14343.8, -11759.6, 18.6523 ) );
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = spawn( "script_origin", ( 14659.2, -11705.1, -27.5403 ) );
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = spawn( "script_origin", ( 14745.4, -11706.5, 26.8936 ) );
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = spawn( "script_origin", ( 14754.8, -11583.3, 20.082 ) );
thread hallway_cool_explosions( vec1, fx_to_play );
fx_to_play = level._effect[ "smoke_stream" ];
vec1 = getent("steam_fx_four", "targetname");
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = getent("steam_fx_three", "targetname");
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = getent("steam_fx_two", "targetname");
thread hallway_cool_explosions( vec1, fx_to_play );
vec1 = getent("steam_fx_one", "targetname");
thread hallway_cool_explosions( vec1, fx_to_play );
}
hallway_cool_explosions( vec1, fx_to_play )
{
level endon( "apartment_upstairs" );
goal_distance = 240;
num = 0;
while( 1 )
{
if( num >= 3 )
{
goal_distance = 400;
}
if ( distance2d( level.player.origin, vec1.origin ) <= goal_distance )
{
num ++;
if( level._effect[ "electrical_transformer_spark_runner_lon" ] == fx_to_play )
{
PlayFX( level._effect[ "electrical_transformer_sparks_a" ] , vec1.origin , ( 0,0,1 ) );
PlayFX( fx_to_play , vec1.origin, ( 0,0,1 ) );
}
else if ( level._effect[ "smoke_stream" ] == fx_to_play )
{
PlayFX( fx_to_play, vec1.origin , anglestoforward( vec1.angles ), anglestoup( vec1.angles ) );
}
break;
}
wait( 0.05 );
}
}
lights_on_and_off()
{
level endon( "apartment_upstairs" );
model_lights_on = getentarray ( "hanging_light_on", "targetname" );
model_lights_off = getentarray ( "hanging_light_off", "targetname" );
foreach ( b in model_lights_off )
{
b hide();
}
foreach ( c in model_lights_on )
{
c hide();
}
trigger = get_Target_Ent( "player_infrontof_apartment_gate" );
trigger waittill( "trigger" );
while( 1 )
{
lights = getentarray( "building_light", "targetname" );
foreach ( l in lights )
{
l.old_intensity = l GetLightIntensity();
thread flickering_light( l, 0.5, 1.3 );
thread moving_light( l, 4 );
l thread lights_on_and_off_models();
}
wait( 1.0 );
foreach ( l in lights )
{
l notify( "stop_flicker" );
l notify( "stop_movement" );
l setLightIntensity( l.old_intensity * RandomFloatRange( 0.7, 1.0 ) );
foreach ( b in model_lights_off )
{
b hide();
}
foreach ( c in model_lights_on )
{
c show();
}
if ( cointoss() )
wait( RandomFloatRange( 0, 0.5 ) );
}
wait( 3 );
}
}
lights_on_and_off_models()
{
model_lights_on = getentarray ( "hanging_light_on", "targetname" );
model_lights_off = getentarray ( "hanging_light_off", "targetname" );
self endon( "stop_flicker" );
self endon( "stop_movement" );
while( 1 )
{
wait( 0.1 );
foreach ( b in model_lights_off )
{
b show();
}
foreach ( c in model_lights_on )
{
c hide();
}
wait( 0.1 );
foreach ( b in model_lights_off )
{
b hide();
}
foreach ( c in model_lights_on )
{
c show();
}
}
}
rpg_pickup_logic()
{
level thread rpg_stop_glow();
rpgs = getentarray( "rpgs_glow", "script_noteworthy");
waitframe();
foreach( r in rpgs )
{
r.glowmodel = Spawn( "script_model", r.origin );
r.glowmodel.angles = r.angles;
r.glowmodel setModel( "weapon_rpg7_obj" );
r thread delete_on_death( r.glowmodel );
r thread delete_on_trigger( r.glowmodel );
}
}
delete_on_trigger( ent )
{
ent endon( "death" );
self waittill( "trigger" );
ent delete();
}
rpg_stop_glow()
{
flag_wait( "btr_dead_now" );
rpg_two = getentarray( "rpgs_glow", "script_noteworthy");
foreach( rpgs_kill in rpg_two )
{
if ( IsDefined ( rpgs_kill ) )
{
rpgs_kill delete();
}
}
}
rpg_logic( name )
{
rpgs = getentarray( "rpgs_glow", "script_noteworthy");
foreach( r in rpgs )
{
r ItemWeaponSetAmmo( 1, 1 );
}
flag_wait( "player_take_out_btr" );
autosave_by_name( "player_take_out_btr" );
thread rpg_pickup_logic();
thread grab_rpg_nag_lines();
thread blow_up_btr_nag_lines();
thread place_objective_on_weapon_before_pickup( name );
missile_deleteattractor( level.repulsor_two );
badplace_cylinder( "dont_flank_player_while_destoying_btr", 60, ( 13477, -12685, -64 ), 670, 200, "axis" );
level endon( "btr_dead_now" );
while( !flag( "btr_dead_now" ) )
{
weap = level.player getCurrentPrimaryWeapon();
if ( isSubstr( weap, "rpg" ) )
{
if ( level.player getweaponammostock( weap ) < 1 )
{
level.player setweaponammostock( weap, 1 );
}
}
wait( 0.2 );
}
}
place_objective_on_weapon_before_pickup( name )
{
ent_origin = spawn( "script_origin", name.origin );
objective_position( obj( "fight" ), ent_origin.origin );
btr = get_vehicle( "plaza_btr_attack_two", "targetname" );
num = 0;
while( 1 )
{
weapon = level.player GetCurrentWeapon();
weapon_two = level.player GetCurrentprimaryweapon();
if(IsDefined(weapon) && ( weapon == "rpg_player" ) || ( weapon_two == "rpg_player_objective" ) )
{
objective_position( obj( "fight" ), btr.origin );
objective_setpointertextoverride( obj( "fight" ), &"prague_target");
flag_set( "player_has_rpg" );
break;
}
else if(IsDefined(weapon) && ( num == 0 ) && ( weapon != "rpg_player" ) || ( weapon_two != "rpg_player_objective" ) )
{
num = 1;
objective_position( obj( "fight" ), ent_origin.origin );
}
wait( 0.05 );
}
}
grab_rpg_nag_lines()
{
level endon( "player_has_rpg" );
level endon( "btr_dead_now" );
wait( 5 );
while( !flag( "player_has_rpg" ) )
{
thread radio_dialogue(	"prague_mct_getanrpg" );
wait( 9 );
thread radio_dialogue(	"prague_mct_takeoutarmor" );
wait( 9 );
}
}
blow_up_btr_nag_lines()
{
level endon( "btr_dead_now" );
flag_wait( "player_has_rpg" );
while( !flag( "btr_dead_now" ) )
{
thread radio_dialogue( "prague_mct_takeout" );
wait( 9 );
thread radio_dialogue( "prague_mct_userpg" );
wait( 9 );
thread radio_dialogue( "prague_mct_hitthatthing" );
wait( 9 );
}
}
rpg_weapon_switch()
{
if ( !player_has_rpg() )
return;
hasGren = false;
tookWeapon = false;
weaponList = level.player GetWeaponsListPrimaries();
tookMainWeapon = false;
foreach ( weapon in weaponList )
{
if ( issubstr( weapon, "rpg" ) )
{
tookWeapon = true;
if ( issubstr( level.player GetCurrentWeapon(), "rpg" ) )
{
tookMainWeapon = true;
level.player DisableWeapons();
wait( 1.5 );
}
level.player takeweapon( weapon );
continue;
}
if ( weapon == level.default_weapon )
{
hasGren = true;
}
}
if ( !tookWeapon )
{
return;
}
level.player EnableWeapons();
if ( !hasGren )
{
level.player giveWeapon( level.default_weapon );
}
if ( tookMainWeapon )
level.player switchToWeapon( level.default_weapon );
}
player_has_rpg()
{
weapons = level.player GetWeaponsListAll();
if ( !isdefined( weapons ) )
return false;
foreach ( weapon in weapons )
{
if ( IsSubStr( weapon, "rpg" ) )
return true;
}
return false;
}