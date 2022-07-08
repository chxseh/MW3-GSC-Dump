#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\_wii_utility;
#include maps\_audio;
start_bridge_crossing()
{
move_player_to_start( "start_bridge_crossing" );
setup_price_for_start( "start_bridge_crossing" );
maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );
SetSavedDvar( "ai_count", 24 );
}
init_event_flags()
{
flag_init( "objective_comm_room" );
flag_init( "objective_plant_bomb_bridge" );
flag_init( "bomb_plant_start" );
flag_init( "bomb_has_been_planted" );
flag_init( "on_scaffolding" );
flag_init( "price_teleported" );
flag_init( "shimmy_start" );
flag_init( "shimmy_middle" );
flag_init( "price_shimmies" );
flag_init( "price_shimmy_done" );
flag_init( "price_across_bridge" );
flag_init( "alert_bridge_end_guys" );
}
bridge_crossing()
{
set_lightning( 3, 10 );
set_rain_level( 6 );
level thread maps\castle_into_wet_wall::thundercracker();
maps\_compass::setupMiniMap("compass_map_castle");
level.price PushPlayer( true );
flag_set( "objective_comm_room" );
level.m_bridge_bomb = GetEnt( "bridge_bomb", "targetname" );
level.price thread price_bridge_dialog();
level.price thread price_watch_bomb_plant();
level thread btr_drives_across_bridge();
level thread bomb_plant();
level thread bridge_fxanims();
level thread bridge_exploders();
flag_wait( "shimmy_start" );
level thread player_shimmy_creak_and_rumble();
level thread player_shimmy( "wall_climb_start" );
flag_wait( "wet_wall_start" );
level.price PushPlayer( false );
level notify( "price_stealth_end" );
}
btr_drives_across_bridge()
{
btr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 910 )[0];
level.price.ignoreme = true;
level.price.ignoreall = true;
level.price.alertlevel = "noncombat";
level.player.ignoreme = true;
aud_send_msg("btr_drives_across_bridge", btr);
btr thread scaffold_shake();
btr waittill( "reached_end_node" );
flag_wait( "shimmy_start" );
nd_leave = GetVehicleNode( "nd_bomb_btr_leave", "targetname" );
btr StartPath( nd_leave );
flag_wait( "wet_wall_start" );
level.price.ignoreme = false;
level.price.ignoreall = false;
level.player.ignoreme = false;
btr Delete();
}
scaffold_shake()
{
self endon( "death" );
}
bridge_fxanims()
{
a_m_scaffolding_sm = GetEntArray( "fxanim_castle_scaff_sm_mod", "targetname" );
foreach( m_scaffolding in a_m_scaffolding_sm )
{
m_scaffolding.animname = "bridge_scaffolding_small";
m_scaffolding assign_animtree();
m_scaffolding thread anim_loop_solo( m_scaffolding, "shake" );
wait RandomFloatRange( 0.5, 3.0 );
}
a_m_scaffolding_lg = GetEntArray( "fxanim_castle_scaff_lrg_x_mod", "targetname" );
foreach( m_scaffolding in a_m_scaffolding_lg )
{
m_scaffolding.animname = "bridge_scaffolding_large";
m_scaffolding assign_animtree();
m_scaffolding thread anim_loop_solo( m_scaffolding, "shake" );
wait RandomFloatRange( 0.5, 3.0 );
}
flag_wait( "bridge_tarp_fly" );
flag_wait( "wet_wall_start" );
foreach( m_scaffolding in a_m_scaffolding_sm )
{
m_scaffolding notify( "stop_loop" );
}
foreach( m_scaffolding in a_m_scaffolding_lg )
{
m_scaffolding notify( "stop_loop" );
}
}
bridge_exploders()
{
flag_wait( "on_scaffolding" );
exploder( 910 );
flag_wait( "bomb_plant_start" );
exploder( 911 );
flag_wait( "shimmy_middle" );
exploder( 914 );
flag_wait( "passed_bomb" );
exploder( 912 );
}
price_watch_bomb_plant()
{
self endon( "death" );
s_align = get_new_anim_node( "castle_bridge" );
flag_wait_any( "bomb_plant_start", "bomb_has_been_planted" );
level.price disable_ai_color();
flag_set( "objective_plant_bomb_bridge" );
if( !flag( "bomb_has_been_planted" ))
{
s_align price_to_bomb_plant( level.price );
}
distance_player_to_price = Distance(level.player.origin,level.price.origin);
if ( distance_player_to_price > 250 )
{
level.price notify( "killanimscript" );
s_teleport = getstruct( "bridge_price_teleport", "targetname" );
level.price ForceTeleport( s_teleport.origin, s_teleport.angles );
flag_set( "price_teleported" );
}
s_align anim_reach_solo( level.price, "bridge_shimmy" );
if( !flag( "price_teleported" ))
{
wait(3.0);
}
else
{
wait(1.25);
}
flag_set( "price_shimmies" );
s_align notify( "stop_loop" );
s_align anim_single_solo( level.price, "bridge_shimmy" );
flag_set( "price_shimmy_done" );
level.price enable_ai_color();
flag_wait( "passed_bomb" );
wait 3;
s_align anim_reach_solo( level.price, "bridge_mantle" );
s_align anim_single_solo_run( level.price, "bridge_mantle" );
level.price enable_ai_color();
flag_set( "price_across_bridge" );
}
price_to_bomb_plant( price )
{
level endon( "bomb_has_been_planted" );
self anim_reach_solo( price, "bridge_instruct_bombplant" );
self anim_single_solo( price, "bridge_instruct_bombplant" );
self anim_loop_solo( price, "bridge_instruct_idle" );
}
bomb_plant()
{
t_bomb_plant = GetEnt( "trig_bridge_bomb", "targetname" );
t_bomb_plant UseTriggerRequireLookAt();
t_bomb_plant waittill( "trigger" );
t_bomb_plant Delete();
aud_send_msg("player_plant_c4_bridge");
level.player AllowCrouch( false );
level.player AllowProne( false );
flag_set( "bomb_has_been_planted" );
level.m_bridge_bomb Hide();
s_align = get_new_anim_node( "castle_bridge" );
s_align thread do_player_anim( "bridge_bomb_plant", undefined, true, 0.5 );
level.player.m_player_rig Attach( "weapon_c4", "tag_weapon", true );
s_align waittill( "bridge_bomb_plant" );
level.player AllowCrouch( true );
level.player AllowProne( true );
level.m_bridge_bomb SetModel( "weapon_c4" );
level.m_bridge_bomb Show();
}
price_bridge_dialog()
{
level endon( "bridge_stealth_broken" );
flag_wait( "on_scaffolding" );
self thread price_ladder_wait();
flag_wait( "bomb_plant_start" );
self dialogue_queue( "castle_pri_thisbridge2" );
self dialogue_queue( "castle_pri_c4oncolumn" );
self thread price_shimmy_wait();
}
price_ladder_wait()
{
level endon( "bomb_has_been_planted" );
level endon( "bridge_stealth_broken" );
self waittill( "goal" );
wait 3;
if( !flag( "on_scaffolding" ) )
{
}
}
price_shimmy_wait()
{
a_nag_lines[0] = "castle_pri_plantc4hurry";
a_nag_lines[1] = "castle_pri_plantc4hurry";
a_nag_lines[2] = "castle_pri_plantc4hurry";
nag_vo_until_flag( a_nag_lines, "bomb_has_been_planted", 10, false, false );
flag_wait( "bomb_has_been_planted" );
wait(3.0);
flag_wait( "price_shimmies" );
wait 3.0;
self dialogue_queue( "castle_pri_abouttocollapse" );
wait(.5);
self dialogue_queue( "castle_pri_sotakeitslow" );
wait(6);
if ( !flag( "shimmy_creak2" ) )
{
self dialogue_queue( "castle_pri_alittletooslow" );
}
}
player_shimmy_creak_and_rumble()
{
flag_wait( "shimmy_creak1" );
level.player PlayRumbleOnEntity( "grenade_rumble" );
aud_send_msg("player_shimmy_boards");
flag_wait( "shimmy_creak2" );
level.player PlayRumbleOnEntity( "grenade_rumble" );
aud_send_msg("player_shimmy_boards");
flag_wait( "shimmy_creak3" );
level.player PlayRumbleOnEntity( "grenade_rumble" );
aud_send_msg("player_shimmy_boards");
}


