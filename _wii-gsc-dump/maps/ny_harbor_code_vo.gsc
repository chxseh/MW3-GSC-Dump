#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
vo_wetsub_intro(delay)
{
if (isdefined(delay))
{
wait delay;
}
flag_wait( "npcs_spawned" );
radio_dialogue( "nyharbor_rno_inposition" );
radio_dialogue( "nyharbor_lns_radiocheck" );
radio_dialogue( "nyharbor_sel_fivebyfive" );
radio_dialogue( "nyharbor_lns_starttheparty" );
radio_dialogue( "nyharbor_sel_copythat" );
radio_dialogue( "nyharbor_rno_dontstart" );
wait( 1 );
radio_dialogue( "nyharbor_lns_almostthrough" );
flag_wait( "tunnel_linkup_dialogue" );
radio_dialogue( "nyharbor_rno_gotout" );
radio_dialogue( "nyharbor_lns_forthem" );
wait( 4 );
radio_dialogue( "nyharbor_lns_linkup" );
flag_wait( "tunnel_tracker_dialogue" );
radio_dialogue( "nyharbor_sel_ontracker" );
radio_dialogue( "nyharbor_lns_approachingrv" );
flag_wait( "up_ahead_vo" );
radio_dialogue( "nyharbor_lns_upahead" );
radio_dialogue( "nyharbor_rno_iseethem" );
flag_wait( "leaving_tunnel" );
wait( 2 );
radio_dialogue( "nyharbor_sel_intercept" );
radio_dialogue( "nyharbor_lns_leadtheway" );
flag_set( "light_toggle_on_1" );
}
vo_sandman_grate( guy )
{
radio_dialogue( "nyharbor_lns_entrypoint" );
}
vo_mines( delay )
{
level endon( "russian_sub_event" );
if( isDefined( delay ) )
{
wait delay;
}
radio_dialogue( "nyharbor_sel_watchsonar" );
wait( 2 );
radio_dialogue( "nyharbor_lns_eyesonsonar" );
flag_wait( "mine_2" );
radio_dialogue( "nyharbor_rno_mine" );
radio_dialogue( "nyharbor_lns_keepitsteady" );
flag_wait( "mine_3" );
radio_dialogue( "nyharbor_lns_right" );
flag_wait( "mine_5" );
radio_dialogue( "nyharbor_lns_anothermine" );
wait( 1 );
radio_dialogue( "nyharbor_lns_clear" );
}
vo_wetsub_russian_sub(delay)
{
if (isdefined(delay))
wait delay;
radio_dialogue( "nyharbor_lns_powerdown" );
wait( 3 );
radio_dialogue( "nyharbor_sel_targetapproaching" );
wait( 8 );
radio_dialogue( "nyharbor_sel_steady" );
wait( 8 );
radio_dialogue( "nyharbor_lns_waittilpasses" );
flag_wait( "sdvs_chase_sub" );
radio_dialogue( "nyharbor_lns_okaygo" );
thread mine_nag_lines();
wait( 3 );
radio_dialogue( "nyharbor_lns_getinposition" );
radio_dialogue( "nyharbor_sel_planting" );
wait( 1.5 );
radio_dialogue( "nyharbor_rno_planting" );
if( !flag( "vo_stop_mine_nag" ) )
{
radio_dialogue( "nyharbor_lns_plantjaywick" );
}
flag_wait( "submine_planted" );
wait( 3 );
radio_dialogue( "nyharbor_lns_minesarmed" );
radio_dialogue( "nyharbor_sel_goodjob" );
radio_dialogue( "nyharbor_lns_goingexplosive" );
wait( 1 );
radio_dialogue( "nyharbor_lns_commencingassault" );
radio_dialogue( "nyharbor_hqr_primaryobjective" );
wait( 2.5 );
radio_dialogue( "nyharbor_lns_holdposition" );
}
sdv_follow_nag_lines()
{
level endon("stop_sdv_follow_nag");
lines = [];
lines[ lines.size ] = "nyharbor_lns_hurryup";
lines[ lines.size ] = "nyharbor_lns_frostmove";
last_line = undefined;
delay_min = 10;
delay_max = 20;
while ( true )
{
flag_wait("vo_sdv_follow_nag");
rand_delay = RandomfloatRange( delay_min, delay_max );
rand_line = random( lines );
if ( isdefined( last_line ) && rand_line == last_line )
continue;
else
{
last_line = rand_line;
radio_dialogue( rand_line );
wait rand_delay;
}
}
}
mine_nag_lines()
{
lines = [];
lines[ lines.size ] = "nyharbor_lns_plantyourmine";
lines[ lines.size ] = "nyharbor_lns_frostgetinposition";
lines[ lines.size ] = "nyharbor_lns_hurryup";
lines[ lines.size ] = "nyharbor_lns_frostmove";
last_line = undefined;
delay_min = 10;
delay_max = 20;
while ( !flag( "vo_stop_mine_nag" ) )
{
rand_delay = RandomfloatRange( delay_min, delay_max );
rand_line = random( lines );
if ( isdefined( last_line ) && rand_line == last_line )
continue;
else
{
last_line = rand_line;
wait rand_delay;
if ( !flag( "vo_stop_mine_nag" ) )
radio_dialogue( rand_line );
}
}
}
vo_sub_exterior()
{
flag_wait( "vo_hatch_open" );
level.sandman dialogue_queue( "nyharbor_lns_hatchopening" );
level.sandman dialogue_queue ( "nyharbor_lns_comingout" );
flag_wait("vo_frag_out");
level.sandman dialogue_queue ( "nyharbor_lns_fragout" );
flag_wait("vo_frag_out_clear");
level.sandman dialogue_queue ( "nyharbor_lns_clearheaddown" );
flag_set( "sandman_talking_on_deck" );
}
vo_sub_exterior_allies()
{
level endon( "hatch_player_using_ladder" );
flag_wait( "sub_exterior_guys_dead" );
flag_wait( "sandman_talking_on_deck" );
wait( 1 );
level.sub_truck dialogue_queue( "nyharbor_trk_decksecured" );
wait( 3.0 );
if( !flag( "hatch_player_using_ladder" ) )
{
level.sub_grinch dialogue_queue( "nyharbor_rno_headdown" );
}
wait( 5 );
if( !flag( "hatch_player_using_ladder" ) )
{
level.sub_truck dialogue_queue( "nyharbor_trk_jobtodo" );
}
wait( 5 );
if( !flag( "hatch_player_using_ladder" ) )
{
level.sub_grinch dialogue_queue( "nyharbor_rno_downthere" );
}
flag_wait( "sub_exterior_hind_1_fire" );
level.sub_truck dialogue_queue( "nyharbor_trk_incominghind" );
}
vo_sub_interior_engine_room()
{
flag_wait( "vo_sub_interior_1" );
level.sandman dialogue_queue ( "nyharbor_lns_unknowns" );
flag_wait("vo_go_downstairs");
level.sandman dialogue_queue ( "nyharbor_lns_rvdownstairs" );
}
sandman_exit_nag_vo()
{
flag_wait( "barracks_exit_nag_vo" );
lines = [];
lines[0] = "nyharbor_snd_downstairs";
lines[1] = "nyharbor_lns_rvdownstairs";
counter = 0;
while( !flag( "sandman_paired_kill" ) && !flag( "barracks_move_sandman" ) )
{
level.sandman dialogue_queue( lines[ counter ] );
if( counter == 0 )
{
counter = 1;
}
else
{
counter = 0;
}
wait( 6 );
}
}
vo_sub_interior_barracks( )
{
flag_wait( "barracks_vo" );
}
vo_sub_interior_reactor()
{
flag_wait( "sandman_paired_kill_complete" );
level.sandman dialogue_queue ( "nyharbor_lns_stairsclear" );
level.sandman dialogue_queue ( "nyharbor_lns_takeleft" );
flag_wait( "reactor_room_announcement" );
thread sandman_translate_scuttle();
radio_dialogue( "nyharbor_rpa_evacuate" );
}
sandman_translate_scuttle()
{
wait( 2.5 );
level.sandman dialogue_queue ( "nyharbor_lns_scuttle" );
level.sandman dialogue_queue( "nyharbor_lns_takepoint" );
}
vo_sub_interior_missile_room_1()
{
flag_wait( "vo_to_bridge" );
level.sandman dialogue_queue( "nyharbor_lns_tothebridge2" );
}
vo_sub_interior_missile_room_2( )
{
flag_wait( "vo_wait_at_door" );
wait(1);
if( !flag( "ready_for_breach" ) )
{
level.sandman dialogue_queue( "nyharbor_lns_atthedoor2" );
wait 0.05;
}
flag_wait( "vo_breach" );
level.sandman dialogue_queue ( "nyharbor_lns_kickercharge" );
level.sandman SetLookAtEntity();
flag_wait( "breach_guys_dead" );
wait( 2 );
level.sandman dialogue_queue( "nyharbor_lns_areasecure" );
}
vo_sub_sandman_got_key( guy )
{
level.sandman dialogue_queue( "nyharbor_lns_launchkeys" );
}
vo_sub_sandman_captain_flip_wface()
{
level waittill("start_missilekey");
level.sandman dialogue_queue ( "nyharbor_lns_missilekey" );
level notify("gridcoords");
level.sandman dialogue_queue ( "nyharbor_lns_launchin30" );
level.sandman dialogue_queue( "nyharbor_lns_console" );
flag_set( "sub_control_room_player_to_controls" );
delaythread( 6, ::sub_interior_bridge_console_nag );
}
vo_sub_sandman_captain_flip(guy)
{
thread vo_sub_sandman_captain_flip_wface();
flag_set("vo_sandman_checkpointneptune");
level.sandman dialogue_queue ( "nyharbor_lns_checkpointneptune" );
radio_dialogue( "nyharbor_hqr_copyneptune" );
level waittill("gridcoords");
radio_dialogue( "nyharbor_hqr_coordinates" );
}
vo_sandman_count_down(guy)
{
level.sandman dialogue_queue ( "nyharbor_lns_321turn" );
level.sandman dialogue_queue ( "nyharbor_lns_missiles" );
flag_set("vo_bridge_is_done");
radio_dialogue( "nyharbor_hqr_teaminposition" );
level.sandman dialogue_queue ( "nyharbor_lns_gogo" );
aud_send_msg("mus_to_the_zodiac");
}
vo_sub_interior_bridge()
{
flag_wait("vo_sub_interior_6");
}
sub_interior_bridge_console_nag()
{
wait( 1 );
lines = [];
lines[ 0 ] = "nyharbor_lns_overhere";
lines[ 1 ] = "nyharbor_lns_console";
counter = 0;
while( !flag( "player_at_controls" ) )
{
level.sandman dialogue_queue( lines[ counter ] );
if( counter == 0 )
{
counter = 1;
}
else
{
counter = 0;
}
wait( 6 );
}
}
live_dialog_queue( msg )
{
if (IsAlive(self))
self dialogue_queue( msg );
else
wait 100;
}
vo_zodiac_ride( delay )
{
if( isDefined( delay ) )
{
wait delay;
}
flag_wait ( "sub_exit_player_going_out_hatch" );
wait 3;
level.sandman live_dialog_queue( "nyharbor_lns_letsroll" );
radio_dialogue ( "nyharbor_rno_amentothat" );
flag_wait( "player_on_boat" );
level.sandman live_dialog_queue( "nyharbor_lns_punchit" );
wait( 1 );
level.sandman live_dialog_queue( "nyharbor_lns_missileslaunching" );
flag_wait( "zubrs" );
level.sandman live_dialog_queue( "nyharbor_lns_keepup" );
flag_wait( "spawn_hind01" );
wait 4;
level.sandman live_dialog_queue( "nyharbor_lns_gunit" );
flag_wait( "vo_missiles_incoming" );
level.sandman live_dialog_queue( "nyharbor_lns_missilescoming" );
wait( 2 );
level.sandman live_dialog_queue( "nyharbor_lns_keepongoing" );
flag_wait( "start_boat_crash" );
wait( 1 );
level.sandman live_dialog_queue( "nyharbor_lns_lookout" );
wait ( 0.5 );
level.sandman live_dialog_queue( "nyharbor_lns_shootmines" );
flag_wait( "spawn_chinook" );
wait( 2 );
level.sandman live_dialog_queue( "nyharbor_lns_theresourbird" );
flag_wait( "switch_chinook" );
wait 3;
level.sandman live_dialog_queue( "nyharbor_lns_theresheis" );
wait 0;
radio_dialogue( "nyharbor_plt_feetwet" );
flag_wait( "finale_dialogue" );
level.sandman live_dialog_queue( "nyharbor_lns_missioncomplete" );
radio_dialogue( "nyharbor_hqr_oneforbooks" );
}
