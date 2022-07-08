#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_sandstorm;
#include maps\payback_util;
#include maps\payback_sandstorm_code;
#include maps\payback_env_code;
#include maps\payback_streets_const;
#include maps\_audio;
init_flags_sandstorm()
{
flag_init("start_blackout");
flag_init("stop_blackout");
flag_init("ai_heat_is_on");
flag_init("ai_heat_is_off");
flag_init("sandstorm_uaz1_vo_ready");
flag_init("sandstorm_dead_ahead");
flag_init("spawn_uaz1");
flag_init("uaz_guys_dead");
flag_init("blackout_flare_on");
flag_init("contact_echo");
flag_init("runners_shot");
flag_init("sandstorm_runner_see_you");
flag_init("sandstorm_in_alley");
flag_init("enemies_right");
flag_init("lookers_dead");
flag_init("echo_vo");
flag_init("sandstorm_end_runners2");
flag_init("price_at_end_runners");
flag_init("end_runners_fight");
flag_init("end_runners_dead");
flag_init("lighten_sandstorm");
}
lighten_sandstorm()
{
level endon("death");
level endon("end_sandstorm");
trigs = GetEntArray("sandstorm_lightener", "script_noteworthy");
while(true)
{
flag_wait("lighten_sandstorm");
lighten_to = 0.75;
foreach (trig in trigs)
{
if (all_players_istouching(trig))
{
if (IsDefined(trig.script_parameter))
{
lighten_to = trig.script_parameter;
}
break;
}
}
new_rate = level.sandstormSpawnrate / lighten_to;
set_sandstorm_spawnrate(new_rate);
flag_waitopen("lighten_sandstorm");
set_sandstorm_spawnrate();
}
}
try_activate(trigger)
{
if (IsDefined(trigger) && !IsDefined(trigger.trigger_off))
{
trigger activate_trigger();
}
}
activate_one_trigger(trigger_name)
{
ents = GetEntArray(trigger_name, "targetname");
try_activate(ents[0]);
}
init_sandstorm_assets()
{
setup_vehicle_light_types();
PreCacheTurret( "heli_spotlight" );
PreCacheItem( "rpg_straight" );
}
setup_vehicle_light_types()
{
lightmodel = get_light_model( "vehicle_uaz_hardtop" , "script_vehicle_uaz_hardtop" );
build_light( lightmodel , "headlight_right", "TAG_LIGHT_RIGHT_FRONT", "maps/payback/payback_headlights_l", "headlights" , 0.2 );
build_light( lightmodel , "headlight_left", "TAG_LIGHT_LEFT_FRONT", "maps/payback/payback_headlights_l", "headlights" , 0.2 );
build_light( lightmodel , "taillight_right", "TAG_LIGHT_RIGHT_TAIL", "misc/car_taillight_uaz_pb", "headlights" , 0.2 );
build_light( lightmodel , "taillight_left", "TAG_LIGHT_LEFT_TAIL", "misc/car_taillight_uaz_pb", "headlights" , 0.2 );
technical_lightmodels = [];
technical_lightmodels[0] = get_light_model( "vehicle_vehicle_pickup_technical_pb_rusted" , "script_vehicle_pickup_technical_payback" );
technical_lightmodels[1] = get_light_model( "vehicle_vehicle_pickup_technical_pb_rusted" , "script_vehicle_pickup_technical_payback_physics" );
technical_lightmodels[2] = get_light_model( "vehicle_vehicle_pickup_technical_pb_rusted" , "script_vehicle_pickup_technical_payback_instant_death" );
foreach( lightmodel in technical_lightmodels )
{
build_light( lightmodel, "headlight_truck_left", "tag_headlight_left",	"maps/payback/payback_headlights_l_sq", "headlights" );
build_light( lightmodel, "headlight_truck_right", "tag_headlight_right", "maps/payback/payback_headlights_r_sq", "headlights" );
build_light( lightmodel, "parkinglight_truck_left_f", "tag_parkinglight_left_f", "misc/blank", "headlights" );
build_light( lightmodel, "parkinglight_truck_right_f", "tag_parkinglight_right_f", "misc/blank", "headlights" );
build_light( lightmodel, "taillight_truck_right", "tag_taillight_right", "misc/car_taillight_truck_R_pb", "headlights" );
build_light( lightmodel, "taillight_truck_left", "tag_taillight_left", "misc/car_taillight_truck_L_pb", "headlights" );
build_light( lightmodel, "brakelight_truck_right", "tag_taillight_right", "misc/car_brakelight_truck_R_pb", "brakelights" );
build_light( lightmodel, "brakelight_truck_left", "tag_taillight_left", "misc/car_brakelight_truck_L_pb", "brakelights" );
}
}
setup_vehicle_inview_lights()
{
wait(.2);
lightmodel = get_light_model( "vehicle_jeep_rubicon" , "script_vehicle_jeep_rubicon_payback" );
level.rescue_jeep_a thread lights_off_internal();
level.rescue_jeep_b lights_off_internal();
build_light( lightmodel , "headlight_truck_right", "tag_headlight_right", "maps/payback/payback_headlights_view", "headlights" );
build_light( lightmodel , "headlight_truck_left", "tag_headlight_left", "maps/payback/payback_headlights_view", "headlights" );
level.rescue_jeep_a lights_on_internal();
level.rescue_jeep_b lights_on_internal();
}
start_sandstorm()
{
aud_send_msg("s2_sandstorm");
exploder(6000);
thread post_rappel_light();
chopper_init_fog_brushes();
sslight_01 = GetEnt( "payback_geo_2b_lights2_sslight_01" , "targetname" );
sslight_01 SetLightIntensity( 7 );
street_light_gate = GetEnt( "payback_geo_2b_lights2_street_light_gate" , "targetname" );
street_light_gate SetLightIntensity( 3 );
level.start_point = "s2_sandstorm";
kill_triggers = getEntArray( "strconst_fallkill" , "targetname" );
array_thread( kill_triggers , ::trigger_off );
move_player_to_start();
if ( !debug_no_heroes() )
{
level.price = spawn_ally( "price" );
level.soap = spawn_ally( "soap" );
}
init_sandstorm_env_effects("s2_sandstorm");
thread set_sandstorm_level( "extreme" , 0.051 );
level.chopper_fog_brushes = GetEntArray( "chopper_fog_brush", "targetname" );
foreach ( brush in level.chopper_fog_brushes )
{
brush Hide();
brush NotSolid();
}
thread sandstorm();
wait 1;
maps\payback_streets_const::post_rappel_gate_open();
activate_one_trigger("allies_into_sandstorm");
level.price thread dialogue_queue("payback_pri_cmonlads");
wait 2;
activate_one_trigger("soap_into_sandstorm");
}
sandstorm()
{
thread lighten_sandstorm();
thread sandstorm_contact_echo_vo();
level.shot_uaz1 = false;
aud_send_msg("s2_sandstorm");
aud_send_msg("sandstorm_start");
sandstorm_skybox_show();
maps\_compass::setupMiniMap("compass_map_payback_sandstorm","sandstorm_minimap_corner");
if (!is_specialop())
{
maps\payback_fx_sp::setup_sandstorm_replacement_fx();
}
flag_wait( "sandstorm_script_trigger" );
SetSunFlarePosition(( -29, 313.993, 0 ));
battlechatter_off( "allies" );
thread uaz1_handler();
thread ambient_pickups();
thread sandstorm_blackout();
thread watertower_thread( "sandstorm_water_tower" , "sandstorm_watertower_event" );
thread marketstall_thread( "sandstorm_market_stall" );
thread scaffold_thread();
thread moroccan_lamp_thread_2();
SetSavedDvar( "objectiveFadeTooFar", 5 );
if ( !debug_no_heroes() )
{
Objective_OnEntity( obj( "obj_find_chopper" ), level.price , (0,0,50) );
Objective_SetPointerTextOverride( obj( "obj_find_chopper" ) , "" );
level.price enable_pain();
level.price.ignoreall = false;
level.soap.ignoreall = false;
level.price.baseAccuracy = 2.0;
level.soap.baseAccuracy = 2.0;
}
thread sandstorm_price_leading_tracker();
flag_wait( "sandstorm_intro_disable_color_end_triggers" );
thread sandstorm_enemy_battlechatter();
thread sandstorm_runners_thread();
level thread sandstorm_next_section_wait();
flag_wait( "heat_is_off" );
if ( !debug_no_heroes() )
{
level.soap disable_cqbwalk();
level.price disable_cqbwalk();
level.price.moveplaybackrate = 1.0;
level.soap.moveplaybackrate = 1.0;
objective_state( obj ( "follow" ) , "invisible" );
}
}
sandstorm_blackout()
{
flag_wait("start_blackout");
thread radio_dialogue( "payback_mct_cantsee_r" );
thread set_sandstorm_level( "blackout" , 5 );
delayThread(30, ::flag_set, "stop_blackout");
guys = array_spawn_targetname_allow_fail("flare_guy");
allguys = array_combine(level.uaz_riders, guys);
thread sandstorm_move_to_alley(allguys);
thread uaz_guys_on(guys);
array_thread(guys, ::setup_sandstorm_guy);
array_thread(guys, ::wait_till_shot);
flare_guy = guys[0];
foreach (guy in guys)
{
guy.ignoreall = true;
guy disable_ai_color();
guy.pathrandompercent = 0;
guy.moveplaybackrate = 1;
guy.goalradius = 8;
guy.walkdist = 0;
guy.disablearrivals = true;
if (IsDefined(guy.script_noteworthy) && guy.script_noteworthy == "the_flare_guy")
{
flare_guy = guy;
fight_zone = GetEnt("uaz_fight_volume", "targetname");
struct = GetStruct("sstorm_flare_anim", "targetname");
guy setGoalPos(struct.origin);
guy setgoalvolume(fight_zone);
}
else
{
level.not_flare_guy = guy;
}
}
thread flare_notify(flare_guy);
flag_wait("stop_blackout");
wait 1.5;
}
flare_notify(flare_guy)
{
flare_guy endon("death");
flare_guy set_run_anim("payback_pmc_sandstorm_stumble_2");
flare_guy thread anim_generic(flare_guy, "deploy_flare");
flare_light = GetEnt("payback_geo_2b_lights2_sand_flare_01", "targetname");
waitframe();
level.blackout_flare = Spawn( "script_model", flare_guy.origin );
level.blackout_flare.owner = flare_guy;
level.blackout_flare SetModel( "mil_emergency_flare" );
level.blackout_flare LinkTo( flare_guy, "TAG_INHAND", (0,0,0), (0,0,0) );
playfxontag( getfx( "flare_ambient" ), level.blackout_flare, "TAG_ORIGIN" );
flare_light thread manual_linkto( level.blackout_flare );
flare_guy thread detach_flare_on_death();
flare_guy thread detach_flare_on_alert();
aud_send_msg("flare_audio_start", flare_guy.origin);
flare_guy waittillmatch("single anim", "end" );
flag_set("blackout_flare_on");
if( IsDefined(level.blackout_flare) )
{
level.blackout_flare Unlink();
level.blackout_flare = undefined;
}
}
detach_flare_on_death()
{
self addAIEventListener( "death" );
self addAIEventListener( "grenade danger" );
self addAIEventListener( "gunshot" );
self addAIEventListener( "silenced_shot" );
self addAIEventListener( "bulletwhizby" );
self addAIEventListener( "projectile_impact" );
self waittill( "ai_event", eventtype );
detach_flare();
}
detach_flare_on_alert()
{
level waittill( "uaz1_guys_fighting" );
detach_flare();
}
detach_flare()
{
if( !IsDefined(level.blackout_flare) )
{
return;
}
flare_drop_pos = groundpos(level.blackout_flare.origin);
level.blackout_flare Unlink();
level.blackout_flare moveto(flare_drop_pos, 0.5, 0.05, 0);
level.blackout_flare = undefined;
}
setup_sandstorm_guy()
{
self.ignoreall = true;
self.baseaccuracy = 0.25;
self.animname = "generic";
switch(RandomInt(3))
{
case 0: self set_run_anim( "payback_pmc_sandstorm_stumble_1" ); break;
case 1: self set_run_anim( "payback_pmc_sandstorm_stumble_2" ); break;
case 2: self set_run_anim( "payback_pmc_sandstorm_stumble_3" ); break;
}
}
ambient_pickups()
{
pickups = getEntArray( "sandstorm_amb_pickup" , "targetname" );
array_thread( pickups , ::vehicle_lights_on );
}
sandstorm_allies_sprint()
{
if ( !debug_no_heroes() )
{
level.price disable_cqbwalk();
level.soap disable_cqbwalk();
level.price.moveplaybackrate = 1.0;
level.soap.moveplaybackrate = 1.0;
}
}
sandstorm_allies_cqb()
{
if ( !debug_no_heroes() )
{
level.price enable_cqbwalk();
level.soap enable_cqbwalk();
level.price.moveplaybackrate = 1.1;
level.soap.moveplaybackrate = 1.1;
}
}
sandstorm_ally_needs_to_catch_up()
{
to_player = ( level.player.origin - self.origin );
to_player_dist = Length( to_player );
if ( to_player_dist < 600 )
{
return false;
}
to_player = VectorNormalize( to_player );
to_goal = VectorNormalize( self.goalpos - self.origin );
dot = VectorDot( to_goal , to_player );
if ( dot < -0.5 )
{
return false;
}
return true;
}
sandstorm_price_leading_tracker()
{
level.player endon( "death" );
price_is_sprinting = false;
if ( debug_no_heroes() )
{
return;
}
while ( 1 )
{
if ( price_is_sprinting )
{
if ( !(level.price sandstorm_ally_needs_to_catch_up() ))
{
sandstorm_allies_cqb();
price_is_sprinting = false;
}
}
else
{
if ( level.price sandstorm_ally_needs_to_catch_up() )
{
sandstorm_allies_sprint();
price_is_sprinting = true;
}
}
wait 1;
}
}
sandstorm_runners_thread()
{
level endon( "sandstorm_section_end" );
flag_wait( "sandstorm_runners" );
thread sandstorm_window_lookers();
thread sandstorm_end_runners2();
thread vo_echo_team_reports_in();
clear_vol = getEnt( "sandstorm_runners_clear_volume" , "targetname" );
level.sandstorm_runners_in_volume = array_spawn_targetname( "sandstorm_runner" );
thread sandstorm_runner_guys_handler(level.sandstorm_runners_in_volume);
thread sandstorm_runner_vo();
thread sandstorm_runner_clear_watch( clear_vol );
thread sandstorm_runner_see_you();
wait 2;
while ( level.sandstorm_runners_in_volume.size > 0 )
{
index = RandomIntRange( 0 , level.sandstorm_runners_in_volume.size );
enemy = level.sandstorm_runners_in_volume[index];
if (IsDefined(enemy) && IsAlive(enemy))
{
enemy custom_battlechatter( "order_move_combat" );
wait( RandomFloatRange( 0.1 , 0.3 ));
}
else
{
level.sandstorm_runners_in_volume = array_removeDead( level.sandstorm_runners_in_volume );
wait 0.05;
}
}
autosave_by_name("runners_past");
sandstorm_allies_cqb();
activate_trigger("sandstorm_post_runsquad", "targetname");
thread radio_dialogue( "payback_pri_moveout_r" );
}
sandstorm_runner_vo()
{
vo_origin = GetStruct("sandstorm_runner_vo_spot", "targetname");
play_sound_in_space("payback_mrc1_foundchopper", vo_origin.origin);
radio_dialogue( "payback_pri_getdown_r" );
wait 1;
radio_dialogue( "payback_pri_foundnikolai_r" );
if (!flag("runners_shot"))
{
play_sound_in_space("payback_afm_keepsearching", vo_origin.origin);
}
}
sandstorm_runner_runner_vo()
{
vo_origin = GetStruct("sandstorm_runner_vo_spot", "targetname");
play_sound_in_space("payback_mrc1_foundchopper", vo_origin.origin);
wait 0.5;
if (!flag("runners_shot"))
{
play_sound_in_space("payback_afm_keepsearching", vo_origin.origin);
}
}
sandstorm_runner_see_you()
{
flag_wait("sandstorm_runner_see_you");
sandstorm_allies_cqb();
foreach (guy in level.sandstorm_runners_in_volume)
{
if (IsDefined(guy) && IsAlive(guy))
{
level notify("runners_shot");
guy.ignoreall = false;
guy.ignoreme = false;
}
}
}
sandstorm_runner_guys_handler(guys)
{
foreach (guy in guys)
{
if (IsDefined(guy.script_noteworthy))
{
goalnode = GetNode(guy.script_noteworthy, "targetname");
if (IsDefined(goalnode))
{
guy.default_radius = guy.goalradius;
guy set_goal_radius( goalnode.radius );
guy SetGoalNode(goalnode);
}
}
guy.ignoreall = true;
guy.ignoreme = true;
guy.baseaccuracy = 0.25;
guy thread awake_on_shot();
guy enable_sprint();
if (RandomFloat(10) > 5)
{
guy maps\payback_sandstorm_code::flashlight_on_guy();
}
guy thread remove_at_end(350);
}
level waittill("runners_shot");
foreach(guy in guys)
{
if (IsDefined(guy) && IsAlive(guy)
&& (DistanceSquared(guy.origin, level.player.origin) < 360000) || (RandomFloat(10) > 5 ) )
{
guy sandstorm_runners_fight();
}
}
}
sandstorm_runners_fight(who)
{
self endon("death");
self notify("fighting_time");
wait 0.2;
if (IsDefined(self) && IsAlive(self) )
{
if (!IsDefined(who))
{
wait RandomFloatRange(0.25, 1.0);
}
self.ignoreall = false;
self.ignoreme = false;
self set_goal_radius(self.default_radius);
self disable_sprint();
self.alertlevel = "combat";
if (IsDefined(who))
{
self GetEnemyInfo(who);
}
self.baseaccuracy = 0.15;
if (IsDefined(self) && IsAlive(self) )
{
self setgoalpos( self.origin );
}
fight_zone = GetEnt("fight_zone", "targetname");
goalVolumeTarget = getNode( fight_zone.target , "targetname" );
if ( IsDefined(self) && IsAlive(self) && self IsTouching(fight_zone) )
{
self SetGoalNode(goalVolumeTarget);
self SetGoalVolume(fight_zone);
}
}
}
remove_at_end(safe_distance)
{
self endon("death");
self endon("fighting_time");
wait 0.5;
self waittill("goal");
dist = DistanceSquared(self.origin, level.player.origin);
if (dist > (safe_distance*safe_distance) && !raven_player_can_see_ai(self))
{
self Delete();
}
else
{
self notify("got_to_end");
self.ignoreall = false;
self.ignoreme = false;
self GetEnemyInfo(level.player);
self.alertlevel = "combat";
}
}
awake_on_shot()
{
self endon("death");
self endon("got_to_end");
self addAIEventListener( "grenade danger" );
self addAIEventListener( "gunshot" );
self addAIEventListener( "silenced_shot" );
self addAIEventListener( "bulletwhizby" );
self addAIEventListener( "projectile_impact" );
self waittill( "ai_event", eventtype );
self sandstorm_runners_fight(level.player);
level notify("runners_shot");
flag_set("runners_shot");
}
sandstorm_runner_clear_watch( volume )
{
while ( level.sandstorm_runners_in_volume.size > 0 )
{
foreach( runner in level.sandstorm_runners_in_volume )
{
if ( !IsAlive( runner ) || !(runner IsTouching( volume )))
{
level.sandstorm_runners_in_volume = array_remove( level.sandstorm_runners_in_volume , runner );
}
}
wait 0.1;
}
}
sandstorm_next_section_wait()
{
flag_wait( "sandstorm_section_end" );
level notify( "sandstorm_section_end" );
maps\payback_rescue::rescue_thread();
}
sandstorm_enemy_battlechatter()
{
level endon( "sandstorm_section_end" );
level.player endon( "death" );
while ( !flag( "sandstorm_section_end" ))
{
enemies = GetAIArray( "axis" );
enemies = array_removeDead( enemies );
if ( enemies.size > 0 )
{
index = RandomIntRange( 0 , enemies.size );
enemy = enemies[index];
enemy custom_battlechatter( "order_move_combat" );
}
wait( RandomFloatRange( 1.5 , 5.0 ));
}
}
marketstall_thread( targetname )
{
level endon( "sandstorm_section_end" );
marketstall = getEnt( targetname , "targetname" );
marketstall.animname = "marketstall";
marketstall setanimtree();
marketstall thread anim_loop_solo( marketstall , "payback_sstorm_market_stall_loop" , "end_market_stall_loop" );
flag_wait( targetname + "_tear" );
marketstall notify( "end_market_stall_loop" );
aud_send_msg("sandstorm_market_tear", marketstall);
thread market_explosion();
marketstall anim_single_solo( marketstall , "payback_sstorm_market_stall_tear" );
marketstall anim_single_solo( marketstall , "payback_sstorm_market_stall_exit" );
}
market_explosion()
{
wait 1;
physics_locs = getstructarray("wind_physics", "targetname");
force = 0.25;
foreach (loc in physics_locs)
{
PhysicsExplosionSphere(loc.origin, 50, 40, force);
wait randomfloatrange(0.15, 0.35);
force = force + 0.5;
}
}
watertower_thread( modelname , locname )
{
level endon( "sandstorm_section_end" );
animloc = getStruct( locname , "targetname" );
tower = getEnt( modelname , "targetname" );
tower.animname = "watertower";
tower setanimtree();
animloc thread anim_loop_solo( tower , "payback_sstorm_water_tower_idle" , "end_water_tower" );
flag_wait( locname + "_fall" );
animloc notify( "end_water_tower" );
aud_send_msg("sandstorm_watertower_fall", tower);
animloc anim_single_solo( tower , "payback_sstorm_water_tower_fall" );
}
scaffold_thread()
{
level endon( "sandstorm_section_end" );
flag_wait( "sandstorm_scaffold_fall" );
anim_start = GetStruct("sandstorm_construction_anim_origin","targetname");
scaffold = GetEnt("sandstorm_scaffolding_collapse","targetname");
scaffold.animname = "payback_scaffolding_collapse";
scaffold useAnimTree( level.scr_animtree[ scaffold.animname ] );
aud_send_msg("payback_scaffolding_collapse", scaffold);
anim_start thread anim_single_solo(scaffold, "payback_scaffolding_collapse");
}
moroccan_lamp_thread()
{
level endon( "sandstorm_section_end" );
level.sandstorm_swinging_lamps = GetEntArray( "sandstorm_swinging_lamps" , "targetname" );
foreach ( lamp in level.sandstorm_swinging_lamps )
{
lamp.animname = "moroccan_lamp";
lamp SetAnimTree();
lamp thread anim_loop_solo( lamp , "wind_heavy" , "end_lamp_swing" );
PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp , "tag_light" );
wait RandomFloatRange( 0.1 , 0.25 );
}
}
moroccan_lamp_thread_2()
{
level endon( "sandstorm_section_end" );
level.sandstorm_swinging_lamps = GetEntArray( "sandstorm_swinging_lamps" , "targetname" );
foreach ( lamp in level.sandstorm_swinging_lamps )
{
if (IsDefined(lamp.target))
{
lamp.animname = "moroccan_lamp";
lamp SetAnimTree();
lamp thread anim_loop_solo( lamp , "wind_heavy" , "end_lamp_swing" );
light = getEnt( lamp.target , "targetname" );
linkent = spawn_tag_origin();
linkent LinkTo( lamp, "tag_light", ( 0, 0, 0 ), ( 0, 0, 0 ) );
light thread manual_linkto( linkent );
PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp, "tag_light" );
wait RandomFloatRange( 0.1 , 0.25 );
}
}
}
uaz1_handler( evt_info , trigger )
{
level endon( "sandstorm_section_end" );
flag_wait("spawn_uaz1");
uaz = spawn_vehicle_from_targetname_and_drive( "uaz1" );
uaz thread handle_vehicle_lights();
uaz thread uaz1_vo_handler();
level.blackout_shots_fired = false;
uaz thread init_uaz_riders();
uaz waittill( "damage" , amount , who );
level.shot_uaz1 = true;
if ( who == level.player )
{
uaz Vehicle_SetSpeed( 0, 35 );
uaz_ai = uaz vehicle_unload();
foreach( ai in uaz_ai )
{
ai.ignoreme = false;
ai.ignoreall = false;
ai GetEnemyInfo(who);
ai.baseaccuracy = 0.25;
}
}
}
init_uaz_riders()
{
wait 0.25;
level.uaz_riders = self.riders;
foreach (guy in level.uaz_riders)
{
if (IsDefined(guy) && IsAlive(guy))
{
guy.ignoreall = true;
guy disable_ai_color();
guy.pathrandompercent = 0;
guy.moveplaybackrate = 1;
guy.goalradius = 8;
guy.walkdist = 0;
guy.disablearrivals = true;
guy.animname = "generic";
switch(RandomInt(3))
{
case 0: guy set_run_anim( "payback_pmc_sandstorm_stumble_1" ); break;
case 1: guy set_run_anim( "payback_pmc_sandstorm_stumble_2" ); break;
case 2: guy set_run_anim( "payback_pmc_sandstorm_stumble_3" ); break;
}
guy thread sandstorm_uaz_unload();
guy thread wait_till_shot();
}
}
self waittill( "reached_end_node" );
thread uaz_guys_on(level.uaz_riders);
}
sandstorm_uaz_unload()
{
self endon("death");
node = GetNode(self.script_noteworthy, "targetname");
self waittill("jumpedout");
if (level.shot_uaz1)
{
self.ignoreall = false;
self maps\payback_sandstorm_code::flashlight_on_guy();
}
else
{
self.goalradius = 8;
self SetGoalNode(node);
self waittill("goal");
if (IsAlive(self) && !level.blackout_shots_fired)
{
self anim_generic(self, self.animation);
}
}
}
wait_till_shot()
{
level endon("uaz1_guys_fighting");
self addAIEventListener( "grenade danger" );
self addAIEventListener( "gunshot" );
self addAIEventListener( "silenced_shot" );
self addAIEventListener( "bulletwhizby" );
self addAIEventListener( "projectile_impact" );
self waittill( "ai_event", eventtype );
level.blackout_shots_fired = true;
self StopAnimScripted();
self clear_run_anim();
self SetGoalPos(self.origin);
self.ignoreall = false;
self.ignoreme = false;
self.baseaccuracy = 0.25;
wait 0.1;
fight_zone = GetEnt("uaz_fight_volume", "targetname");
struct = GetStruct("sstorm_flare_anim", "targetname");
self setGoalPos(struct.origin);
self setgoalvolume(fight_zone);
level notify("uaz1_guys_fighting");
}
uaz_guys_on(guys)
{
level waittill("uaz1_guys_fighting");
foreach (guy in guys)
{
if (IsDefined(guy) && IsAlive(guy))
{
guy stopanimscripted();
guy OrientMode("face default");
guy enable_ai_color();
guy.ignoreall = false;
self.goalradius = 200;
guy.baseaccuracy = 0.15;
guy.alertlevel = "combat";
}
}
}
sandstorm_move_to_alley(guys)
{
if (guys.size > 0)
{
thread ai_array_killcount_flag_set(guys, guys.size, "uaz_guys_dead");
flag_wait("uaz_guys_dead");
}
else
{
flag_set("uaz_guys_dead");
}
activate_one_trigger("sandstorm_move_to_alley");
wait 2;
flag_set("stop_blackout");
}
uaz1_vo_handler()
{
flag_wait( "sandstorm_uaz1_vo_ready" );
autosave_by_name_silent("see_jeep");
sandstorm_allies_cqb();
trig = GetEnt("sandstorm_intro_after_vehicle", "targetname");
thread radio_dialogue( "payback_pri_vehiclecoming_r" );
try_activate(trig);
thread blackout_vo();
}
blackout_takedown_vo()
{
flag_wait("blackout_flare_on");
level.price dialogue_queue("payback_pri_takeemout");
wait 0.5;
blackout_soap_price_fight();
}
blackout_soap_price_fight()
{
level.soap.baseaccuracy = 10;
level.price.baseaccuracy = 10;
allguys = getaiarray("axis");
foreach (guy in allguys)
{
guy.ignoreme = false;
}
if (IsDefined(allguys[0]) && IsAlive(allguys[0]))
{
level.soap GetEnemyInfo(allguys[0]);
level.price GetEnemyInfo(allguys[0]);
}
}
blackout_vo()
{
flag_wait("sandstorm_dead_ahead");
sa = level.soap.baseaccuracy;
pa = level.price.baseaccuracy;
radio_dialogue("payback_mct_deadahead_r");
level.price.animname = "price";
if (level.blackout_shots_fired == false)
{
thread blackout_takedown_vo();
}
else
{
level.price dialogue_queue("payback_pri_takeemout");
blackout_soap_price_fight();
}
flag_wait("uaz_guys_dead");
level.soap.baseaccuracy = sa;
level.price.baseaccuracy = pa;
autosave_by_name("blackout_done");
sandstorm_allies_sprint();
radio_dialogue("payback_mct_wereclear_r");
level.price dialogue_queue("payback_pri_gottamove");
wait 0.5;
flag_set("contact_echo");
}
sandstorm_contact_echo_vo()
{
flag_wait("contact_echo");
level.price dialogue_queue("payback_pri_echoteam2");
wait 0.25;
radio_dialogue("payback_eol_locatedchopper");
}
sandstorm_window_lookers()
{
flag_wait("sandstorm_runner_see_you");
thread callout_lookers();
thread lookers_autosave();
spawner = GetEnt("ss_window_guy_c", "targetname");
middle_guy = spawner spawn_ai(true);
middle_guy thread maps\payback_sandstorm_code::flashlight_on_guy();
middle_guy.animname = "generic";
middle_guy set_run_anim( "payback_pmc_sandstorm_stumble_3" );
middle_node = GetNode("ss_middle_search_node", "targetname");
spawner = GetEnt("ss_window_guy_l", "targetname");
left_guy = spawner spawn_ai(true);
left_guy thread maps\payback_sandstorm_code::attachFlashlight("alley_fight");
left_origin = GetEnt("ss_left_search_guy", "targetname");
spawner = GetEnt("ss_window_guy_r", "targetname");
right_guy = spawner spawn_ai(true);
right_guy thread maps\payback_sandstorm_code::attachFlashlight("alley_fight");
right_origin = GetEnt("ss_right_search_guy", "targetname");
alley_guys = [middle_guy, left_guy, right_guy];
thread handle_unawares(alley_guys, "alley_fight");
middle_guy setGoalNode(middle_node);
thread left_looker(left_guy);
right_looker(right_guy);
thread ai_array_killcount_flag_set(alley_guys, alley_guys.size, "lookers_dead");
if (flag("sandstorm_in_alley"))
{
if (!flag("alley_fight") && !flag("lookers_dead"))
{
radio_dialogue("payback_mct_theyknow_r");
flag_set("alley_fight");
}
}
else
{
level notify("lookers_deleted");
foreach (guy in alley_guys)
{
if (IsDefined(guy) && IsAlive(guy))
{
guy delete();
}
}
}
}
lookers_autosave()
{
level endon("lookers_deleted");
flag_wait("alley_fight");
flag_wait("lookers_dead");
autosave_by_name_silent("window_lookers");
}
callout_lookers()
{
level endon("death");
level endon("lookers_deleted");
flag_wait("enemies_right");
if (!flag("alley_fight"))
{
flag_wait("lookers_dead");
radio_dialogue("payback_mct_thatwaseasy_r");
}
}
left_looker(left_guy)
{
left_guy endon("death");
left_guy anim_generic(left_guy, "active_patrolwalk_pause");
left_guy anim_generic(left_guy, "active_patrolwalk_turn_180");
}
right_looker(right_guy)
{
right_guy endon ("death");
right_guy anim_generic(right_guy, "active_patrolwalk_v5");
right_guy anim_generic(right_guy, "active_patrolwalk_v5");
right_guy anim_generic(right_guy, "active_patrolwalk_turn_180");
}
vo_echo_team_reports_in()
{
flag_wait("echo_vo");
radio_dialogue("payback_tm2_reachednikolai");
wait 0.5;
level.price dialogue_queue("payback_pri_hangon");
}
sandstorm_end_runners2()
{
flag_wait("sandstorm_end_runners2");
thread blizzard_level_transition_extreme2(5);
badguys = array_spawn_targetname_allow_fail("sandstorm_end_runners2");
wavers = array_spawn_targetname_allow_fail("sandstorm_end_wavers2");
allbadguys = array_combine(badguys, wavers);
thread handle_unawares(allbadguys, "end_runners_fight");
default_endgoal_node = GetNode("sandstorm_end_runners2_node", "targetname");
array_thread(badguys, ::do_end_runners, default_endgoal_node);
array_thread(wavers, ::do_end_wavers, default_endgoal_node);
extras = array_spawn_targetname_allow_fail("sandstorm_end_runners3");
array_thread(extras, ::do_end_runners, default_endgoal_node);
thread ai_array_killcount_flag_set(allbadguys, allbadguys.size, "end_runners_dead");
thread boost_sstorm_allies_combat_accuracy("end_runners_fight", "end_runners_dead");
waver_vo_spot = GetStruct("sandstorm_waver_vo_spot", "targetname");
thread play_sound_in_space("payback_afm_hurry",waver_vo_spot.origin);
wait 1.5;
level.price dialogue_queue("payback_mct_headingfornik" );
if (!flag("end_runners_fight"))
{
level.price dialogue_queue( "payback_pri_dropem" );
wait 1;
flag_set("end_runners_fight");
}
flag_wait("end_runners_dead");
autosave_by_name("end_runners_dead");
sandstorm_allies_sprint();
trigger_off("ss_allies_wavers1", "targetname");
activate_one_trigger("ss_allies_wavers2");
radio_dialogue("payback_mct_wereclear_r");
}
boost_sstorm_allies_combat_accuracy(start_flag, stop_flag)
{
soap_acc = level.soap.baseaccuracy;
price_acc = level.price.baseaccuracy;
flag_wait(start_flag);
level.soap.baseaccuracy = 1000;
level.price.baseaccuracy = 1000;
flag_wait(stop_flag);
level.soap.baseaccuracy = soap_acc;
level.price.baseaccuracy = price_acc;
}
do_end_runners(final_node)
{
if( !IsDefined(self) || !IsAlive(self) )
return;
if (randomfloat(100) < 75)
{
self maps\payback_sandstorm_code::flashlight_on_guy();
}
self set_goal_radius(10);
self SetGoalPos(self.origin);
wait 2;
if (IsDefined(self) && IsAlive(self))
{
self run_and_delete(final_node, "end_runners_fight");
}
}
do_end_wavers(final_node)
{
self endon("death");
self endon("end_runners_fight");
if( !IsDefined(self) || !IsAlive(self) )
return;
wave_struct = GetStruct(self.script_noteworthy, "targetname");
wave_struct anim_generic_teleport(self, self.animation);
wave_struct anim_generic(self, self.animation);
self run_and_delete(final_node, "end_runners_fight");
}
run_and_delete(final_node, endon_notify)
{
self endon("death");
if ( IsDefined(endon_notify) &&
(!IsDefined(self.script_noteworthy) ||
(IsDefined(self.script_noteworthy) && self.script_noteworthy != "no_intterupt")) )
{
level endon(endon_notify);
}
self set_goal_radius(100);
self SetGoalNode(final_node);
wait 1;
self waittill("goal");
wait 0.2;
if ( raven_player_can_see_ai(self) )
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
handle_unawares(guys, notify_name)
{
level endon("death");
self endon("deleted");
foreach (guy in guys)
{
guy thread handle_unaware_shot(notify_name);
}
level waittill(notify_name);
array_thread(guys, ::unawares_attack);
}
handle_unaware_shot(notify_name)
{
self endon("death");
self endon("deleted");
level endon(notify_name);
if( !IsDefined(self) || !IsAlive(self) )
return;
self addAIEventListener( "grenade danger" );
self addAIEventListener( "gunshot" );
self addAIEventListener( "silenced_shot" );
self addAIEventListener( "bulletwhizby" );
self addAIEventListener( "projectile_impact" );
self waittill( "ai_event", eventtype );
self unawares_attack(level.player);
level notify(notify_name);
flag_set(notify_name);
}
unawares_attack(target)
{
self endon("death");
self endon("deleted");
if (!IsDefined(target))
{
wait RandomFloatRange(0.5, 2.0);
}
if (IsDefined(self) && IsAlive(self))
{
self.ignoreme = false;
self.ignoreall = false;
self.baseaccuracy = 0.2;
self stopanimscripted();
self SetGoalPos(self.origin);
if (IsDefined(target))
{
self GetEnemyInfo(target);
}
else
{
self GetEnemyInfo(level.player);
}
}
}