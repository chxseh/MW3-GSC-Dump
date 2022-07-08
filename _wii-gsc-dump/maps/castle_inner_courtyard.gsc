#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_audio;
start_inner_courtyard()
{
move_player_to_start( "start_inner_courtyard" );
setup_price_for_start( "start_inner_courtyard" );
flag_set("objective_clear_prison");
flag_set("player_entered_prison");
flag_set("meatshield_done");
flag_set("objective_clear_prison_cleared");
flag_set("objective_comm_room");
flag_set("objective_plant_bomb_bridge");
flag_set("bomb_has_been_planted");
flag_set("objective_time_wall_charge");
flag_set("wet_wall_destroyed");
flag_set("peephole_start");
flag_set("kitchen_start");
level.price place_weapon_on( "mp5", "right" );
level.price.grenadeammo = 0;
level.price.baseaccuracy = 10;
level.price disable_danger_react();
level.price disable_pain();
level.price disable_surprise();
level.price disable_bulletwhizbyreaction();
level.price set_ignoreSuppression( true );
level thread check_trigger_flagset("price_left_color");
level thread check_trigger_flagset("trig_inner_courtyard_midpoint");
thread inner_courtyard_midpoint_fallback();
level.player GiveWeapon( "ump45_acog" );
level.player SwitchToWeaponImmediate( "ump45_acog" );
m_l_door = GetEnt( "foyer_left_door", "targetname" );
m_r_door = GetEnt( "foyer_right_door", "targetname" );
bm_l_door_clip = GetEnt( "foyer_left_door_clip", "targetname" );
bm_r_door_clip = GetEnt( "foyer_right_door_clip", "targetname" );
m_l_door LinkTo( bm_l_door_clip );
m_r_door LinkTo( bm_r_door_clip );
bm_l_door_clip RotateYaw( -90, 0.05 );
bm_r_door_clip RotateYaw( 90, 0.05 );
wait 0.05;
bm_l_door_clip ConnectPaths();
bm_r_door_clip ConnectPaths();
maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
}
inner_courtyard_main()
{
battlechatter_on( "allies" );
level.price set_ai_bcvoice( "taskforce" );
set_rain_level( 2 );
exploder ( 5000 );
level thread initial_reinforcement();
level thread check_first_wave_move_price();
level thread check_middle_move_price();
level thread check_end_move_price();
level.price thread inner_courtyard_price();
level.price thread price_door_kick();
level.price thread inner_courtyard_teleport_price_lower();
level.price thread inner_courtyard_teleport_price_upper();
level thread inner_courtyard_cleanup();
flag_wait("inner_courtyard_done");
}
init_event_flags()
{
flag_init( "inner_courtyard_initial_wave" );
flag_init( "inner_courtyard_left_exit" );
flag_init( "inner_courtyard_right_exit" );
flag_init( "inner_courtyard_right_side_exit" );
flag_init( "inner_courtyard_done" );
flag_init( "inner_courtyard_teleport_price" );
flag_init( "inner_courtyard_door_kick" );
flag_init( "inner_courtyard_door_open" );
flag_init( "inner_courtyard_rooftop_sniper");
flag_init( "inner_courtyard_rpg_fallback");
flag_init( "inner_courtyard_midpoint_fallback");
flag_init( "inner_courtyard_done_price" );
flag_init( "inner_courtyard_teleport_price_lower" );
flag_init( "inner_courtyard_teleport_price_upper" );
}
inner_courtyard_midpoint_fallback()
{
flag_wait("inner_courtyard_midpoint_fallback");
thread retreat_from_vol_to_vol("inner_courtyard_upper_right","inner_courtyard_upper_right_room",0,0);
thread retreat_from_vol_to_vol("inner_courtyard_back_south","inner_courtyard_back_middle",0,0);
thread retreat_from_vol_to_vol("inner_courtyard_back_north","inner_courtyard_back_north_fallback",2,4);
}
inner_courtyard_spotlights()
{
a_lights = GetEntArray( "inner_courtyard_spotlight", "targetname" );
foreach( light in a_lights )
{
PlayFXOnTag( getfx( "spotlight_modern_rain_lt_cheap" ), light, "tag_light" );
light SetMode( "manual" );
light SetModel( "ctl_spotlight_modern_3x_on" );
light MakeTurretInoperable();
e_target = GetEnt( light.target, "targetname" );
light SetTargetEntity( e_target );
light thread inner_courtyard_spotlight_death();
}
}
inner_courtyard_spotlight_death()
{
trigger_wait_targetname( self.script_noteworthy );
PlayFXOnTag( getfx( "spotlight_destroy" ), self, "tag_origin" );
StopFXOnTag( getfx( "spotlight_modern_rain_lt_cheap" ), self, "tag_light" );
self SetModel( "ctl_spotlight_modern_3x_destroyed" );
}
inner_courtyard_price()
{
self thread dialogue_queue( "castle_pri_onme2" );
self.grenadeammo = 3;
self.baseaccuracy = 4;
self PushPlayer(true);
self enable_pain();
self enable_bulletwhizbyreaction();
trigger = GetEnt( "inner_courtyard_snipers", "script_noteworthy" );
if( IsDefined( trigger ) )
{
trigger activate_trigger();
}
trigger = GetEnt( "inner_courtyard_snipers", "targetname" );
if( IsDefined( trigger ) )
{
trigger activate_trigger();
}
autosave_by_name( "middle_courtyard" );
}
price_building_nag()
{
level endon( "inner_courtyard_done" );
wait 5;
while( true )
{
self thread dialogue_queue( "castle_pri_onme2" );
wait 6;
self thread dialogue_queue( "castle_pri_overehere" );
wait 6;
self thread dialogue_queue( "castle_pri_throughere" );
wait 5;
}
}
price_door_kick()
{
level endon( "inner_courtyard_done" );
level endon( "inner_courtyard_teleport_price" );
flag_wait( "inner_courtyard_door_kick" );
self disable_ai_color();
self SetGoalNode( GetNode( "after_door_kick", "targetname" ) );
self.ignoresuppression = true;
self dialogue_queue( "castle_pri_staywithmeyuri" );
flag_wait("inner_courtyard_done_price");
thread price_building_nag();
self.ignoresuppression = false;
}
inner_courtyard_retreat()
{
self endon( "death" );
self set_ignoreme( true );
self set_ignoreall( true );
self.goalradius = 32;
self SetGoalNode( GetNode( "inner_courtyard_retreat", "targetname" ) );
self waittill( "goal" );
self set_ignoreme( false );
self set_ignoreall( false );
flag_wait( "inner_courtyard_done" );
self Kill();
}
check_first_wave_move_price()
{
thread initial_wave_fallback();
waittill_aigroupcount("ic_firstwave", 2);
trig = getent("price_left_color","targetname");
if(IsDefined(trig))
{
activate_trigger_with_targetname("price_left_color");
trig trigger_off();
}
}
check_middle_move_price()
{
waittill_aigroupcount("midway_group", 5);
trig = getent("price_color_midway","targetname");
if(IsDefined(trig))
{
activate_trigger_with_targetname("price_color_midway");
trig trigger_off();
}
}
check_end_move_price()
{
waittill_aigroupcount("endcourtyard_group", 3);
trig = getent("trig_inner_courtyard_midpoint","targetname");
if(IsDefined(trig))
{
activate_trigger_with_targetname("trig_inner_courtyard_midpoint");
trig trigger_off();
}
}
initial_wave_fallback()
{
flag_wait("inner_courtyard_rpg_fallback");
thread retreat_from_vol_to_vol("inner_courtyard_upper_start","inner_courtyard_upper_right_room",0,0);
}
initial_reinforcement()
{
flag_wait( "inner_courtyard_initial_wave" );
level thread initial_rpg();
}
initial_reinforcement_think()
{
self endon( "death" );
self.goalradius = 32;
self waittill( "goal" );
self Delete();
}
initial_rpg()
{
s_start = getstruct( "pillar_rpg", "targetname" );
s_end = getstruct( s_start.target, "targetname" );
e_rpg = MagicBullet( "rpg_straight", s_start.origin, s_end.origin );
e_rpg waittill( "death" );
aud_send_msg("rpg_hits_spire");
spire_clip = GetEnt( "spire_clip", "targetname" );
spire_clip Delete();
Earthquake( 0.2, 0.5, s_end.origin, 2000 );
level.player PlayRumbleOnEntity( "wii_damage_light" );
exploder ( 1301 );
GetEnt( "pillar_rpg", "targetname" ) spawn_ai( true );
level notify( "destroy_spire" );
level.price thread dialogue_queue("castle_pri_rpgs");
level waittill( "spire_hit_ground" );
exploder ( 1302 );
Earthquake( 0.3, .3, s_end.origin, 2000 );
level.player PlayRumbleOnEntity( "wii_damage_light" );
}
initial_roof_enemy_ignore()
{
self endon( "death" );
self set_ignoreall( true );
flag_wait( "inner_courtyard_initial_wave" );
self set_ignoreall( false );
}
inner_courtyard_left_exit()
{
level endon( "inner_courtyard_done" );
flag_wait( "inner_courtyard_left_exit" );
sp_custom_entrance = GetEnt( "inner_courtyard_custom_entrance", "targetname" );
s_anim_align = get_new_anim_node( "inner_courtyard" );
ai_new = sp_custom_entrance spawn_ai( true );
s_anim_align anim_generic_run( ai_new, "inner_courtyard_entry_03" );
}
inner_courtyard_right_exit()
{
level endon( "inner_courtyard_done" );
flag_wait( "inner_courtyard_right_exit" );
sp_custom_entrance = GetEnt( "inner_courtyard_custom_entrance", "targetname" );
s_anim_align = get_new_anim_node( "inner_courtyard" );
ai_new = sp_custom_entrance spawn_ai( true );
s_anim_align anim_generic_run( ai_new, "inner_courtyard_entry_01" );
ai_new = sp_custom_entrance spawn_ai( true );
s_anim_align anim_generic_run( ai_new, "inner_courtyard_entry_02" );
}
inner_courtyard_right_side_exit()
{
level endon( "inner_courtyard_done" );
flag_wait( "inner_courtyard_right_side_exit" );
sp_custom_entrance = GetEnt( "inner_courtyard_custom_entrance", "targetname" );
s_anim_align = get_new_anim_node( "inner_courtyard" );
ai_new = sp_custom_entrance spawn_ai( true );
s_anim_align anim_generic_run( ai_new, "inner_courtyard_entry_05" );
wait 2;
ai_new = sp_custom_entrance spawn_ai( true );
s_anim_align anim_generic_run( ai_new, "inner_courtyard_entry_04" );
}
inner_courtyard_teleport_price_upper()
{
level endon("innercourtyard_price_teleported");
flag_wait( "inner_courtyard_teleport_price_upper" );
if( !flag( "inner_courtyard_done" ) )
{
self anim_stopanimscripted();
waitframe();
self disable_ai_color();
self teleport_ai( GetNode( "inner_courtyard_teleport_price", "targetname" ) );
}
level notify("innercourtyard_price_teleported");
}
inner_courtyard_teleport_price_lower()
{
level endon("innercourtyard_price_teleported");
flag_wait( "inner_courtyard_teleport_price_lower" );
if( !flag( "inner_courtyard_done_price" ) )
{
self anim_stopanimscripted();
waitframe();
self disable_ai_color();
self teleport_ai( GetNode( "inner_courtyard_teleport_price_lower", "targetname" ) );
}
level notify("innercourtyard_price_teleported");
}
inner_courtyard_cleanup()
{
trigger_wait_targetname( "kill_inner_courtyard" );
a_current = GetAIArray( "axis" );
foreach ( ai in a_current )
{
if ( IsDefined( ai.script_noteworthy ) && ai.script_noteworthy == "inner_courtyard_ai" )
{
ai Delete();
}
}
}
watch_price_right_color()
{
trigger = GetEnt( "price_right_color", "targetname" );
while(1)
{
trigger waittill( "trigger");
level.price set_force_color("b");
}
}
watch_price_left_color()
{
trigger = GetEnt( "price_left_color", "targetname" );
while(1)
{
trigger waittill( "trigger");
level.price set_force_color("g");
}
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



