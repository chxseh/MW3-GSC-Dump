#include maps\_utility;
#include maps\_hud_util;
#include common_scripts\utility;
#include maps\hamburg_code;
#include maps\_anim;
#include maps\_audio;
tank_crash_exit()
{
println("tank_crash_exit");
flag_set( "tank_crash_exit" );
allies = GetAIArray( "allies" );
foreach(ally in allies)
{
if( isdefined( level.sandman) && ally == level.sandman )
continue;
ally Delete();
}
scene_org = getstruct( "tank_crash_org", "targetname" );
dummy_tank = get_post_crash_tank();
thread prep_idle_exit_sequence( dummy_tank );
exploder( "tank_fall_after_sparks" );
if( is_after_start( "hamburg_garage_ramp" ) || is_split_level_part("b") )
{
explode_the_ramps();;
spawn_garage_rig();
thread turn_on_exterior_light();
thread vision_set_fog_changes( "hamburg_garage_inside_tank", 0);
level.garage_rig thread gather_linkables();
collapse_anim = level.garage_rig getanim( "collapse" );
level.garage_rig SetAnim( collapse_anim , 1 );
level.garage_rig SetAnimTime( collapse_anim, 0.8 );
scene_org thread anim_single_solo( dummy_tank, "hamburg_tank_crash" );
scene_org anim_set_rate( [dummy_tank], "hamburg_tank_crash", 16 );
}
else
{
scene_org waittill ( "hamburg_tank_crash" );
}
wait 0.07;
if( !isdefined( level.garage_scene_objects ) )
level.garage_scene_objects = [];
set_stance_for_crash_anims();
level.garage_scene_objects = array_add( level.garage_scene_objects, dummy_tank );
foreach( object in level.garage_scene_objects )
if( isdefined( object.tagname ) && issubstr ( object.tagname ,"J_Vehicle_" ) )
object delete();
black_overlay = maps\_hud_util::create_client_overlay( "black", 0, level.player );
black_overlay.alpha = 1;
dummy_tank waittillmatch( "single anim", "end" );
player_rig = spawn_anim_model( "player_rig", scene_org.origin );
player_rig_gun = spawn_anim_model( "player_rig_gun", scene_org.origin );
player_rig_legs = spawn_anim_model( "player_rig_legs", scene_org.origin );
guys = [ player_rig, player_rig_gun, player_rig_legs ];
array_call( guys, ::Hide );
dummy_tank anim_first_frame( guys , "garage_crash_exit", "tag_guy0" );
level.player PlayerLinkToDeltaBlend( 0.3, 0, 0, player_rig, "tag_player", 1, 60, 20, 60, 20, false);
music_play( "ham_end_start");
axis = GetAIArray( "axis" );
array_call(axis, ::Delete);
level.player lerp_player_view_to_position( set_z( level.player.origin, -245.875), level.player getplayerangles(), 0.3,1,5,5,5,5,false );
fadeTime = 0.3;
black_overlay FadeOverTime( fadeTime );
black_overlay.alpha = 0;
black_overlay delayCall( fadeTime, ::destroy );
do_exit_sequence( dummy_tank );
eyeheight = level.player geteye()[2] + 256;
foreach( ent in level.all_linkables_from_crash )
{
if( !isdefined( ent ) )
{
continue;
}
if( ent.origin[2] > eyeheight )
continue;
ent Delete();
}
aud_send_msg("exit_tank");
delaythread( 3, ::vision_set_fog_changes, "hamburg_garage", 2.0 );
get_post_crash_tank() delaythread( 3 , ::turn_off_the_tanks_lights, true );
get_post_crash_tank() Show();
inside_the_tank_fire = get_exploder_array( "inside_the_tank_fire" );
delaythread( 3, ::array_thread, inside_the_tank_fire, ::pauseEffect );
delaythread( 1.25, maps\hamburg_a_to_b::turn_on_exterior_light );
thread bring_on_sandman();
level notify_delay( "player_on_his_way_out" , 0.1 );
cleanup_ents( "bridge_joints" );
level notify ( "stop_flicker_the_light" );
level.player PlayerLinkToDeltaBlend( 0.5, 0, 0, player_rig, "tag_player", 1, 0, 0, 0, 0, true );
dummy_tank thread anim_single( guys , "garage_crash_exit", "tag_guy0" );
wait 0.3;
array_call( guys, ::Show );
thread handle_ally_exit(dummy_tank);
player_rig waittill_match_or_timeout( "single anim", "end", 12 );
if( !is_split_level() )
{
level.player maps\_loadout::give_loadout();
}
else
{
persistantLoadout = maps\_loadout::RestorePlayerWeaponStatePersistent( "hamburg_a", true );
if( !persistantLoadout )
{
level.player maps\_loadout::give_loadout();
}
}
level.player EnableWeapons();
level.player Unlink();
set_ambient( "hamburg_garage" );
array_delete( guys );
level.player lerp_player_view_to_position( set_z( level.player.origin, -245.875), level.player getplayerangles(), 0.3,1,5,5,5,5,false );
level.player AllowSprint( true );
level.player AllowCrouch( true );
level.player AllowProne( true );
vehicle_scripts\_m1a1_player_control::reset_player_stuff_after_tank();
}
turn_on_exterior_light()
{
if( isdefined( level.garage_crash_light_exit ) )
{
thread handle_spot_lighter();
return;
}
garage_crash_light_exit = getstruct( "garage_crash_light_exit", "targetname" );
garage_crash_light_exit_target = getstruct( garage_crash_light_exit.target, "targetname" );
if( isdefined(garage_crash_light_exit_target) )
{
garage_crash_light_exit.angles = vectortoangles( garage_crash_light_exit_target.origin - garage_crash_light_exit.origin );
angles = garage_crash_light_exit.angles;
emitter = garage_crash_light_exit spawn_tag_origin();
emitter.angles = angles;
level.garage_crash_light_exit = emitter;
emitter thread spot_light( "tank_god_ray_light", undefined, "tag_origin", emitter );
}
}
handle_spot_lighter()
{
handle_garage_spotlight = GetEnt( "handle_garage_spotlight", "targetname" );
while( true )
{
handle_garage_spotlight waittill ( "trigger" );
setsaveddvar( "sm_sunenable", 0 );
level.garage_crash_light_exit thread spot_light( "tank_god_ray_light", undefined , "tag_origin", level.garage_crash_light_exit );
while( level.player istouching( handle_garage_spotlight ) )
wait 0.05;
setsaveddvar( "sm_sunenable", 1 );
wait 2;
stop_last_spot_light();
wait 2;
}
}
do_idle_guys_in_tank( dummy_tank )
{
if ( IsDefined( level.do_idle_guys_in_tank ) )
return;
level.do_idle_guys_in_tank = true;
driver = get_tank_driver();
gunner = get_tank_gunner();
driver linkto( dummy_tank );
gunner linkto( dummy_tank );
driver thread driver_exit_idle(dummy_tank);
gunner thread gunner_exit_idle(dummy_tank);
}
flicker_the_light()
{
garage_crash_light_flicker = GetEnt( "parking_garage_ramps5_garage_crash_light_flicker", "targetname" );
garage_crash_light_flicker SetLightIntensity( 1.0 );
garage_crash_light_flicker flickery();
garage_crash_light_flicker setLightIntensity( 0 );
}
flickery()
{
level endon ( "stop_flicker_the_light" );
initial_intensity = self GetLightIntensity();
startColor = ( 1.0, 0.501961, 0.000000 );
targetColor = ( 1.0, 1.0, 1.0);
while(true)
{
random_flicker = RandomIntRange( 2, 6 );
for ( i = 0; i < random_flicker; i++ )
{
self SetLightIntensity( initial_intensity * RandomFloatRange( 0.7, 1.0 ) );
self setLightColor( vectorlerp( startColor, targetColor, RandomFloatRange(0.2,1.0) ) );
wait RandomFloatRange( 0.05, 0.1 );
self setLightIntensity( 0.1 );
wait RandomFloatRange( 0.05, 0.2 );
}
wait RandomFloatRange( 1, 3 );
}
}
prep_idle_exit_sequence( dummy_tank )
{
thread exploder( "while_in_tank" );
thread flicker_the_light();
thread do_idle_guys_in_tank( dummy_tank );
}
do_exit_sequence( dummy_tank )
{
wait 1;
level.sandman thread dialogue_queue( "hamburg_snd_frost" );
wait 2;
level.player thread radio_dialogue( "tank_rh1_22comein" );
wait 0.5;
end_message = "exit_tank_button";
notifyOnCommand( end_message, "+activate" );
notifyOnCommand( end_message, "+usereload" );
do_exit_wait( end_message );
thread hint_fade();
}
do_exit_wait( end_message )
{
next_hint_time = 0;
level.player endon ( end_message );
while ( true )
{
if( gettime() > next_hint_time )
{
thread hint(&"SCRIPT_PLATFORM_EXITCRASHTANK",99);
next_hint_time = gettime() + 100000;
}
wait 0.05;
}
}
driver_exit_idle( dummy_tank )
{
level endon ( "player_on_his_way_out" );
dummy_tank anim_generic( self, "driver_after_fall", "tag_guy0" );
dummy_tank anim_generic_loop( self, "driver_after_fall_loop", "player_getting_out_now", "tag_guy0" );
}
gunner_exit_idle( dummy_tank )
{
level endon ( "player_on_his_way_out" );
dummy_tank anim_generic( self, "loader_after_fall", "tag_guy0" );
dummy_tank anim_generic_loop( self, "loader_after_fall_loop", "player_getting_out_now", "tag_guy0" );
}
dump_collision_map( export_mapname )
{
fileprint_launcher_start_file();
fileprint_map_start();
foreach( object in level.garage_scene_objects )
{
if ( !IsDefined( object ) )
continue;
fileprint_map_entity_start();
fileprint_map_keypairprint( "spawnflags", "1" );
fileprint_map_keypairprint( "origin", fileprint_radiant_vec( object.origin ) );
fileprint_map_keypairprint( "targetname", "delete_on_load" );
fileprint_map_keypairprint( "_color", "0.686275 0.847059 0.847059" );
fileprint_map_keypairprint( "classname", "script_model" );
fileprint_map_keypairprint( "model", object.model );
if( IsDefined( object.tagname ) )
fileprint_map_keypairprint( "tagname", object.tagname );
if( IsDefined( object.angles ) )
fileprint_map_keypairprint( "angles", fileprint_radiant_vec( object.angles ) );
fileprint_map_entity_end();
}
fileprint_launcher_end_file(export_mapname , false );
}
spawn_garage_rig()
{
scene_org = getstruct( "tank_crash_org", "targetname" );
rig = spawn_anim_model( "garage_floor" , scene_org.origin );
rig Hide();
rig.origin = scene_org.origin;
rig.angles = ( 0, 0, 0 );
level.garage_rig = rig;
}
explode_the_ramps()
{
exploder( "garage_ramp_1" );
exploder( "garage_ramp_2" );
exploder( "garage_floor_collapse_dust_hang" );
exploder( "garage_ramp_3" );
delaythread( 3, ::exploder, "garage_floor_collapse_dust_hang_during" );
waittillframeend;
}
set_stance_for_crash_anims()
{
level.player allowstand( true );
level.player allowcrouch( false );
level.player allowprone( false );
level.player SetStance( "stand" );
}
gather_linkables()
{
joints =
[
"Ground_02_jnt",
"Ground_01_jnt",
"Ground_03_jnt",
"Ground_04_jnt",
"Ground_05_jnt",
"Ground_06_jnt",
"Ground_07_jnt",
"Ground_08_jnt",
"Ground_09_jnt",
"Ground_010_jnt",
"Ground_011_jnt",
"Ground_012_jnt",
"Ground_013_jnt",
"Ground_014_jnt",
"Ground_015_jnt",
"Ground_016_jnt",
"Ground_017_jnt",
"Ground_018_jnt",
"Ground_019_jnt",
"Ground_020_jnt",
"Ground_021_jnt",
"Ground_022_jnt",
"Ground_023_jnt",
"Ground_024_jnt",
"Ground_025_jnt",
"Ground_026_jnt",
"Ground_027_jnt",
"Ground_028_jnt",
"Ground_029_jnt",
"Ground_030_jnt",
"Ground_031_jnt",
"Ground_032_jnt",
"Ground_033_jnt",
"Ground_034_jnt",
"Ground_035_jnt"
];
garage_ramp_pieces = GetEntArray( "garage_ramp_piece" , "script_noteworthy" );
level.all_linkables_from_crash = garage_ramp_pieces;
foreach( joint in joints )
{
ent = getClosest_bmodel( self GetTagOrigin( joint ), garage_ramp_pieces, 64 );
if ( !IsDefined( ent ) )
{
continue;
}
if( joint == "Ground_08_jnt" )
{
garage_ramp_pieces = array_remove( garage_ramp_pieces, ent );
ent delaycall( 0.25, ::Hide );
continue;
}
ent NotSolid();
intermediate = spawn_tag_origin();
intermediate DontInterpolate();
intermediate.origin = self GetTagOrigin( joint );
intermediate.angles = self GetTagAngles( joint );
intermediate LinkTo( self, joint, ( 0, 0, 0 ), ( 0, 0, 0 ) );
add_cleanup_ent( intermediate, "bridge_joints" );
ent linkto( intermediate );
rebars = ent get_linked_ents();
foreach( bar in rebars )
{
bar linkto( intermediate );
level.all_linkables_from_crash[ level.all_linkables_from_crash.size ] = bar;
}
}
joints =
[
"J_Vehicle_1",
"J_Vehicle_2",
"J_Vehicle_3",
"J_Vehicle_4",
"J_Vehicle_5"
];
destructible_vehicle = GetEntArray( "destructible_vehicle", "targetname" );
foreach( joint in joints )
{
ent = getClosest( self GetTagOrigin( joint ), destructible_vehicle, 64 );
if ( !IsDefined( ent ) )
{
continue;
}
if( !IsDefined( level.garage_scene_objects ) )
level.garage_scene_objects = [];
ent.tagname = joint;
level.garage_scene_objects = array_add( level.garage_scene_objects , ent );
intermediate = spawn_tag_origin();
intermediate DontInterpolate();
intermediate.origin = self GetTagOrigin( joint );
intermediate.angles = self GetTagAngles( joint );
intermediate LinkTo( self, joint, ( 0, 0, 0 ), ( 0, 0, 0 ) );
add_cleanup_ent( intermediate, "bridge_joints" );
ent linkto( intermediate );
}
}
getClosest_bmodel( org, array, maxdist )
{
if ( !IsDefined( maxdist ) )
maxdist = 500000;
ent = undefined;
foreach ( item in array )
{
newdist = Distance( item GetCentroid(), org );
if ( newdist >= maxdist )
continue;
maxdist = newdist;
ent = item;
}
return ent;
}
get_tank_driver()
{
if ( ! IsDefined( level.tank_crew_1 ) )
level.tank_crew_1 = spawn_targetname( "tank_crew_1", true );
return level.tank_crew_1;
}
get_tank_gunner()
{
if ( !IsDefined( level.tank_crew_2 ) )
level.tank_crew_2 = spawn_targetname( "tank_crew_2", true );
return level.tank_crew_2;
}
#using_animtree( "generic_human" );
bring_on_sandman()
{
noteworthy_start = getstruct( "sandman_jump_start_high" , "targetname" );
spawned = get_sandman();
if( IsDefined( spawned.magic_bullet_shield ) )
spawned stop_magic_bullet_shield();
spawned Delete();
spawned = get_sandman();
spawned.animplaybackrate = 1;
spawned.moveTransitionRate = 1;
spawned ForceTeleport( noteworthy_start.origin, noteworthy_start.origin );
wait 0.5;
noteworthy_start thread anim_single_solo( spawned, "traverse_jumpdown_130" );
wait 2.4;
spawned stopanimscripted();
spawned ForceTeleport( noteworthy_start.origin, noteworthy_start.origin );
wait 1.0;
noteworthy_start = getstruct( "sandman_jump_start_low" , "targetname" );
spawned ForceTeleport( noteworthy_start.origin, noteworthy_start.origin );
wait 1.35;
spawned set_force_color("r");
level.sandman = spawned;
level.sandman.animname = "sandman";
activate_trigger_with_targetname("go_sandman_go");
}
handle_final_vo( gunner )
{
level.sandman dialogue_queue( "hamburg_snd_guysok" );
gunner dialogue_queue( "hamburg_rhg_weregood" );
level.sandman dialogue_queue( "hamburg_snd_canyoushoot" );
gunner dialogue_queue( "hamburg_rhg_holdmyown" );
level.sandman dialogue_queue( "hamburg_snd_basics" );
level.sandman dialogue_queue( "hamburg_snd_movefast" );
}
handle_ally_exit(dummy_tank)
{
wait 8.5;
gunner = get_tank_gunner() ;
driver = get_tank_driver() ;
gunner.spawner = GetEnt( "greenend1", "targetname");
driver.spawner = GetEnt( "greenend2", "targetname");
gunner.spawner.count = 1;
driver.spawner.count = 1;
allies = GetAIArray( "allies" );
gunner_real = makerealai(gunner);
driver_real = makerealai(driver);
maps\hamburg_end_ramp::assign_allies();
driver_real.animname = "generic";
gunner_real.animname = "generic";
dummy_tank thread anim_generic( gunner_real, "loader_after_fall_exit", "tag_guy0" );
dummy_tank thread anim_generic( driver_real, "driver_after_fall_exit", "tag_guy0" );
wait 0.05;
driver_real anim_self_set_time("driver_after_fall_exit", 0.1 );
animation = gunner_real getanim( "loader_after_fall_exit" );
anim2 = driver_real getanim( "driver_after_fall_exit" );
anim_set_rate_single(gunner_real,"loader_after_fall_exit",1.2);
anim_set_rate_single(driver_real,"driver_after_fall_exit",1.2);
check = [];
checktime = [];
check[check.size]=gunner_real;
check[check.size]=driver_real;
checktime[checktime.size]=0.89;
checktime[checktime.size]=0.91;
tocheck = 0;
checkflag = true;
thread handle_final_vo( gunner_real );
while(1)
{
if( checkflag && flag( "player_off_tank" ) )
{
checkflag = false;
if(tocheck == 0)
{
anim_set_rate_single(gunner_real,"loader_after_fall_exit",2);
}
anim_set_rate_single(driver_real,"driver_after_fall_exit",2);
}
perc = check[tocheck] GetAnimTime( animation );
if(perc >=checktime[tocheck])
{
check[tocheck] stopanimscripted();
tocheck++;
if(tocheck >= check.size)
break;
animation = check[tocheck] getanim( "driver_after_fall_exit" );
}
wait 0.05;
}
}
get_post_crash_tank()
{
if( !isdefined( level.post_crash_tank ) )
{
level.post_crash_tank = spawn_anim_model( "post_crash_tank" );
level.post_crash_tank SetModel( "vehicle_m1a1_abrams_viewmodel_tread_stop_nomip" );
}
return level.post_crash_tank;
}
