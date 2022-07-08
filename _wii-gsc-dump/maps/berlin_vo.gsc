#include maps\_utility;
#include common_scripts\utility;
#include maps\_audio;
#using_animtree( "generic_human" );
prepare_dialogue()
{
Sandman = "lone_star";
Truck = "truck";
Grinch = "essex";
AmericanSoldier = "generic";
AmericanSoldier2 = "generic";
Alena = "alena";
level.scr_sound[Sandman][ "berlin_cby_waitingfor" ] = "berlin_cby_waitingfor";
level.scr_radio[ "berlin_lbp_deltaboys" ] = "berlin_lbp_deltaboys";
level.scr_radio[ "berlin_rno_rippedapart" ] = "berlin_rno_rippedapart";
level.scr_sound[Grinch][ "berlin_rno_rpglookout" ] = "berlin_rno_rpglookout";
level.scr_sound[Sandman][ "berlin_cby_birdisdown" ] = "berlin_cby_birdisdown";
level.scr_radio[ "berlin_lbp_ondeck" ] = "berlin_lbp_ondeck";
level.scr_sound[Sandman][ "go_go_go" ] = "berlin_cby_gogogo";
level.scr_sound[Grinch][ "berlin_rno_secondfloor2" ] = "berlin_rno_secondfloor2";
level.scr_sound[Sandman][ "berlin_cby_headup" ] = "berlin_cby_headup";
level.scr_sound[Sandman][ "berlin_cby_headforroof2" ] = "berlin_cby_headforroof2";
level.scr_sound[Sandman][ "berlin_cby_destroysam" ] = "berlin_cby_destroysam";
level.scr_sound[Sandman][ "frost_with_me" ] = "berlin_cby_frostwithme";
level.scr_sound[Truck][ "berlin_trk_clear" ] = "berlin_trk_clear";
level.scr_sound[Truck][ "berlin_trk_clear2" ] = "berlin_trk_clear2";
level.scr_sound[Grinch][ "berlin_rno_rog" ] = "berlin_rno_rog";
level.scr_sound[Sandman][ "berlin_cby_upthestairs" ] = "berlin_cby_upthestairs";
level.scr_sound[Sandman][ "berlin_cby_move" ] = "berlin_cby_move";
level.scr_sound[Grinch][ "berlin_rno_moving" ] = "berlin_rno_moving";
level.scr_sound[Sandman][ "berlin_cby_visontarget" ] = "berlin_cby_visontarget";
level.scr_sound[Sandman][ "berlin_cby_strongpoint" ] = "berlin_cby_strongpoint";
level.scr_sound[Sandman][ "berlin_cby_userifle" ] = "berlin_cby_userifle";
level.scr_sound[Sandman][ "berlin_cby_grabrifle" ] = "berlin_cby_grabrifle";
level.scr_sound[Sandman][ "berlin_cby_overwatch" ] = "berlin_cby_overwatch";
level.scr_sound[Sandman][ "berlin_cby_wastingtime" ] = "berlin_cby_wastingtime";
level.scr_radio[ "berlin_cby_inposition" ] = "berlin_cby_inposition";
level.scr_radio[ "berlin_lbp_willrelay" ] = "berlin_lbp_willrelay";
level.scr_radio[ "berlin_lbp_overwatch" ] = "berlin_lbp_overwatch";
level.scr_radio[ "berlin_grl_breaching" ] = "berlin_grl_breaching";
level.scr_radio[ "berlin_apg_missilesloose" ] = "berlin_apg_missilesloose";
level.scr_sound[Grinch][ "berlin_rno_ontheroof" ] = "berlin_rno_ontheroof";
level.scr_sound[Sandman][ "berlin_cby_giveemcover" ] = "berlin_cby_giveemcover";
level.scr_sound[Truck][ "berlin_trk_guysonroof" ] = "berlin_trk_guysonroof";
level.scr_sound[Sandman][ "berlin_cby_takecare" ] = "berlin_cby_takecare";
level.scr_sound[Sandman][ "berlin_cby_canland" ] = "berlin_cby_canland";
level.scr_radio[ "berlin_lbp_ondecknow" ] = "berlin_lbp_ondecknow";
level.scr_sound[Truck][ "berlin_trk_gotcompany" ] = "berlin_trk_gotcompany";
level.scr_radio[ "berlin_grl_takingfire" ] = "berlin_grl_takingfire";
level.scr_sound[Sandman][ "berlin_cby_4enemies" ] = "berlin_cby_4enemies";
level.scr_sound[Sandman][ "berlin_cby_areaclear" ] = "berlin_cby_areaclear";
level.scr_sound[Sandman][ "berlin_cby_goodhit2" ] = "berlin_cby_goodhit2";
level.scr_sound[ Sandman ][ "goodkill" ] = "berlin_cby_goodkill2";
level.scr_sound[Sandman][ "berlin_cby_goodeffect" ] = "berlin_cby_goodeffect";
level.scr_sound[Truck][ "berlin_brvl_btrcrawl" ] = "berlin_brvl_btrcrawl";
level.scr_sound[Sandman][ "berlin_cby_firemission" ] = "berlin_cby_firemission";
level.scr_radio[ "race_track_clear" ] = "berlin_hqr_racetrackclear";
level.scr_radio["berlin_plt_standingby"]="berlin_plt_standingby";
level.scr_sound[Sandman]["paint_targets"] = "berlin_cby_laserdesignate";
level.scr_sound[Sandman][ "berlin_cby_tankonstreet" ] = "berlin_cby_tankonstreet";
level.scr_sound[Sandman][ "berlin_cby_belowus" ] = "berlin_cby_belowus";
level.scr_sound[Sandman][ "berlin_cby_stoplooking" ] = "berlin_cby_stoplooking";
level.scr_sound[Sandman][ "berlin_cby_twomoretanks" ] = "berlin_cby_twomoretanks";
level.scr_sound[Sandman][ "berlin_cby_targettanks" ] = "berlin_cby_targettanks";
level.scr_sound[Sandman][ "berlin_cby_eyesongranite" ] = "berlin_cby_eyesongranite";
level.scr_sound[Sandman][ "berlin_cby_gettogirl" ] = "berlin_cby_gettogirl";
level.scr_sound[Sandman][ "berlin_cby_directhit2" ] = "berlin_cby_directhit2";
level.scr_sound[Sandman][ "berlin_cby_flankclear" ] = "berlin_cby_flankclear";
level.scr_radio[ "berlin_grl_assault" ] = "berlin_grl_assault";
level.scr_sound[Sandman][ "berlin_cby_maintaineyes" ] = "berlin_cby_maintaineyes";
level.scr_radio[ "berlin_grl_goingin" ] = "berlin_grl_goingin";
level.scr_sound[Sandman][ "berlin_cby_eyesondaughter" ] = "berlin_cby_eyesondaughter";
level.scr_radio[ "berlin_grl_cantgettoher" ] = "berlin_grl_cantgettoher";
level.scr_sound[Grinch][ "berlin_rno_anythingmoving" ] = "berlin_rno_anythingmoving";
level.scr_sound[Truck][ "berlin_trk_damn" ] = "berlin_trk_damn";
level.scr_sound[Sandman][ "berlin_cby_granitegranite" ] = "berlin_cby_granitegranite";
level.scr_sound[Grinch][ "berlin_rno_eaglesdown" ] = "berlin_rno_eaglesdown";
level.scr_sound[Sandman][ "berlin_cby_pcteam" ] = "berlin_cby_pcteam";
level.scr_radio[ "berlin_hqr_linkup" ] = "berlin_hqr_linkup";
level.scr_radio[ "berlin_trk_takeit" ] = "berlin_trk_takeit";
level.scr_radio["berlin_plt_targetaquired"]="berlin_plt_targetaquired";
level.scr_radio["berlin_plt_tallytarget"]="berlin_plt_tallytarget";
level.scr_radio["berlin_plt_contact"]="berlin_plt_contact";
level.scr_radio["berlin_plt_tallyontarget"]="berlin_plt_tallyontarget";
level.scr_radio["berlin_plt_goinghot"]="berlin_plt_goinghot";
level.scr_radio["berlin_plt_standingby3"]="berlin_plt_standingby3";
level.scr_radio["berlin_plt_inposition2"]="berlin_plt_inposition2";
level.scr_radio["berlin_plt_ready"]="berlin_plt_ready";
level.scr_radio["berlin_plt_standingby4"]="berlin_plt_standingby4";
level.scr_radio["berlin_plt_notinposition"]="berlin_plt_notinposition";
level.scr_radio["berlin_plt_circleback"]="berlin_plt_circleback";
level.scr_radio["berlin_plt_negative"]="berlin_plt_negative";
level.scr_radio["berlin_plt_notinposition2"]="berlin_plt_notinposition2";
level.scr_radio["berlin_plt_holdfast"]="berlin_plt_holdfast";
level.scr_radio[ "berlin_plt_direction" ] = "berlin_plt_direction";
level.scr_radio["berlin_plt_altattack"]="berlin_plt_altattack";
level.scr_radio["berlin_plt_maxeffects"]="berlin_plt_maxeffects";
level.scr_radio["berlin_plt_reciprocal"]="berlin_plt_reciprocal";
level.scr_radio["berlin_plt_unable"]="berlin_plt_unable";
level.scr_radio["berlin_plt_newrunin"]="berlin_plt_newrunin";
level.scr_radio["berlin_plt_badapproach"]="berlin_plt_badapproach";
level.scr_sound[Sandman][ "berlin_cby_overhere" ] = "berlin_cby_overhere";
level.scr_sound[Sandman][ "berlin_cby_letsmove2" ] = "berlin_cby_letsmove2";
level.scr_sound[Sandman][ "berlin_cby_thisway2" ] = "berlin_cby_thisway2";
level.scr_sound[Sandman][ "berlin_cby_hookup2" ] = "berlin_cby_hookup2";
level.scr_sound[Sandman][ "berlin_cby_hookup" ] = "berlin_cby_hookup";
level.scr_sound[Sandman][ "berlin_cby_sandmanout" ] = "berlin_cby_sandmanout";
level.scr_sound[Truck][ "berlin_trk_casualties" ] = "berlin_trk_casualties";
level.scr_sound[Truck][ "berlin_trk_onyxteam" ] = "berlin_trk_onyxteam";
level.scr_sound[Sandman][ "berlin_cby_patchestags" ] = "berlin_cby_patchestags";
level.scr_sound[Truck][ "berlin_trk_rog" ] = "berlin_trk_rog";
level.scr_radio[ "berlin_trk_needevac" ] = "berlin_trk_needevac";
level.scr_radio[ "berlin_hqr_sarbird" ] = "berlin_hqr_sarbird";
level.scr_sound[Grinch][ "berlin_rno_notagoodday" ] = "berlin_rno_notagoodday";
level.scr_radio[ "berlin_gtc_pinneddown" ] = "berlin_gtc_pinneddown";
level.scr_sound[Sandman][ "berlin_cby_moveout" ] = "berlin_cby_moveout";
level.scr_sound[Truck][ "berlin_trk_dugin" ] = "berlin_trk_dugin";
level.scr_sound[Grinch][ "berlin_rno_killthatthing" ] = "berlin_rno_killthatthing";
level.scr_radio[ "berlin_gtc_hithard" ] = "berlin_gtc_hithard";
level.scr_sound[Sandman][ "berlin_cby_grabrpg" ] = "berlin_cby_grabrpg";
level.scr_sound[Sandman][ "berlin_cby_takeouttank" ] = "berlin_cby_takeouttank";
level.scr_sound[Sandman][ "berlin_cby_takecareofit" ] = "berlin_cby_takecareofit";
level.scr_sound[Sandman]["berlin_cby_armormoving"] = "berlin_cby_armormoving";
level.scr_radio[ "berlin_gtc_advancing" ] = "berlin_gtc_advancing";
level.scr_radio[ "berlin_gtc_firing" ] = "berlin_gtc_firing";
level.scr_sound[Sandman][ "berlin_cby_followtanks" ] = "berlin_cby_followtanks";
level.scr_sound[Sandman]["move_up"] = "berlin_cby_moveup";
level.scr_sound[Sandman]["push_forward"] = "berlin_cby_pushfwd";
level.scr_sound[Sandman][ "berlin_cby_contactahead" ] = "berlin_cby_contactahead";
level.scr_sound[Sandman][ "berlin_cby_useem" ] = "berlin_cby_useem";
level.scr_radio[ "berlin_gtc_straightahead" ] = "berlin_gtc_straightahead";
level.scr_sound[Sandman][ "berlin_cby_almostthere" ] = "berlin_cby_almostthere";
level.scr_sound[Sandman][ "press_attack" ] = "berlin_cby_presstheattack";
level.scr_radio[ "berlin_gtc_acquiring" ] = "berlin_gtc_acquiring";
level.scr_sound[Sandman][ "inside_bank" ] = "berlin_cby_insidebank2";
level.scr_radio[ "berlin_gtc_moretargets" ] = "berlin_gtc_moretargets";
level.scr_radio[ "berlin_gtc_left20degrees" ] = "berlin_gtc_left20degrees";
level.scr_radio[ "berlin_gtc_office" ] = "berlin_gtc_office";
level.scr_sound[Sandman]["an_ambush"] = "berlin_cby_anambush";
level.scr_radio[ "berlin_hqr_lostcontact" ] = "berlin_hqr_lostcontact";
level.scr_sound[Sandman][ "berlin_cby_aoislost" ] = "berlin_cby_aoislost";
level.scr_radio[ "berlin_hqr_missedyourlast" ] = "berlin_hqr_missedyourlast";
level.scr_sound[Sandman][ "berlin_cby_damnbuilding" ] = "berlin_cby_damnbuilding";
level.scr_radio[ "berlin_hqr_pullback" ] = "berlin_hqr_pullback";
level.scr_sound[Sandman][ "berlin_cby_goingforgirl" ] = "berlin_cby_goingforgirl";
level.scr_radio[ "berlin_hqr_berlinfalling" ] = "berlin_hqr_berlinfalling";
level.scr_sound[Sandman][ "berlin_cby_throughhere" ] = "berlin_cby_throughhere";
level.scr_sound[Grinch][ "berlin_rno_comedown" ] = "berlin_rno_comedown";
level.scr_sound[Truck][ "berlin_trk_easy" ] = "berlin_trk_easy";
level.scr_sound[Grinch][ "berlin_rno_thisissome" ] = "berlin_rno_thisissome";
level.scr_sound[Truck][ "berlin_trk_keepmoving" ] = "berlin_trk_keepmoving";
level.scr_sound[Truck][ "berlin_trk_rigged" ] = "berlin_trk_rigged";
level.scr_sound[Truck][ "berlin_trk_doorway" ] = "berlin_trk_doorway";
level.scr_sound[Sandman][ "berlin_cby_imonit" ] = "berlin_cby_imonit";
level.scr_sound[Sandman][ "berlin_cby_theresthehotel" ] = "berlin_cby_theresthehotel";
level.scr_sound[Sandman][ "berlin_cby_updateongirl" ] = "berlin_cby_updateongirl";
level.scr_radio[ "berlin_hqr_zerotime" ] = "berlin_hqr_zerotime";
level.scr_sound[Sandman][ "berlin_cby_losingher" ] = "berlin_cby_losingher";
level.scr_radio[ "berlin_hqr_standdown" ] = "berlin_hqr_standdown";
level.scr_sound[Sandman][ "berlin_cby_canmakeit" ] = "berlin_cby_canmakeit";
level.scr_sound[Sandman]["head_for_roof"] = "berlin_cby_headforroof";
level.scr_sound[Sandman]["get_to_roof"] = "berlin_cby_gettoroof";
level.scr_sound[Sandman][ "berlin_cby_frostthisway" ] = "berlin_cby_frostthisway";
level.scr_sound[Sandman][ "berlin_cby_letsgoletsgo" ] = "berlin_cby_letsgoletsgo";
level.scr_sound[Sandman][ "berlin_cby_gogogo3" ] = "berlin_cby_gogogo3";
level.scr_sound[Sandman][ "berlin_cby_keepmoving2" ] = "berlin_cby_keepmoving2";
level.scr_sound[Sandman][ "berlin_cby_stackup" ] = "berlin_cby_stackup";
level.scr_sound[Sandman][ "berlin_cby_hitthedoor" ] = "berlin_cby_hitthedoor";
level.scr_sound[Sandman][ "berlin_cby_upstairs" ] = "berlin_cby_upstairs";
level.scr_sound[Sandman][ "berlin_cby_behindthedoor" ] = "berlin_cby_behindthedoor";
level.scr_sound[Alena][ "berlin_aln_scream1" ] = "berlin_aln_scream1";
level.scr_sound[Alena][ "berlin_aln_helpme" ] = "berlin_aln_helpme";
level.scr_sound[Alena][ "berlin_aln_scream2" ] = "berlin_aln_scream2";
level.scr_sound[Alena][ "berlin_aln_scream3" ] = "berlin_aln_scream3";
level.scr_sound[Alena][ "bln_daughter_scream_exit" ] = "bln_daughter_scream_exit";
}
play_dialogue()
{
thread berlin_intro_dialog();
thread berlin_heli_ride_dialog();
thread berlin_chopper_crash_dialog();
thread berlin_aa_roof_clear_dialog();
thread berlin_sniper_dialog();
thread berlin_rappel_dialog();
thread berlin_rappel_complete_dialog();
thread berlin_clear_bridge_dialog();
thread berlin_advance_pkway_dialog();
thread berlin_building_collapse_dialog();
thread berlin_traverse_building_dialog();
thread berlin_emerge_dialog();
thread berlin_last_stand_dialog();
thread berlin_reverse_breach_hallway_dialog();
thread berlin_reverse_breach_dialog();
}
berlin_intro_dialog()
{
flag_wait( "is_intro" );
berlin_shared_ambush_dialog();
if(isaudiodisabled())
wait(15);
flag_set( "intro_dialogue_complete" );
level.lone_star dialogue_queue("berlin_cby_aoislost");
}
berlin_heli_ride_dialog()
{
flag_wait("start_sandman_vo");
radio_dialogue( "berlin_lbp_deltaboys" );
radio_dialogue( "berlin_rno_rippedapart" );
flag_wait( "rpg_attacker_fires" );
wait( 0.2 );
level.essex dialogue_queue( "berlin_rno_rpglookout" );
wait( 3 );
level.lone_star dialogue_queue( "berlin_cby_birdisdown" );
radio_dialogue( "berlin_lbp_ondeck" );
}
berlin_chopper_crash_dialog()
{
flag_wait("player_unloaded_from_intro_flight");
thread aa_building_first_floor_clear_dialog( "vo_reached_second_level" );
thread aa_building_second_floor_clear_dialog( "aa_building_obj_loc_3" );
level.lone_star dialogue_queue( "go_go_go" );
wait( 2 );
level.essex dialogue_queue( "berlin_rno_secondfloor2" );
wait( 6 );
level.lone_star dialogue_queue( "berlin_cby_headup" );
level.lone_star dialogue_queue(	"berlin_cby_destroysam" );
if( !flag( "aa_building_flank_right" ) )
thread aa_building_keep_moving_nag( "aa_building_flank_right" );
flag_wait( "aa_building_flank_right" );
wait( 3 );
level.lone_star dialogue_queue(	"berlin_cby_destroysam" );
level.lone_star dialogue_queue( "frost_with_me" );
if( !flag( "aa_building_flank_left" ) )
thread aa_building_keep_moving_nag( "aa_building_flank_left" );
flag_wait( "aa_building_flank_left" );
wait( 7.3 );
level notify( "vo_reached_second_level" );
level.lone_star dialogue_queue( "berlin_cby_move" );
level.essex dialogue_queue( "berlin_rno_moving" );
if( !flag( "aa_building_obj_loc_3" ) )
thread aa_building_keep_moving_nag( "aa_building_obj_loc_3" );
flag_wait( "aa_building_obj_loc_3" );
level.lone_star dialogue_queue( "berlin_cby_upthestairs" );
}
aa_building_first_floor_clear_dialog( endon_msg )
{
if( isDefined( endon_msg ) )
{
level endon( endon_msg );
}
flag_wait( "vo_aa_first_floor_clear" );
level.truck dialogue_queue( "berlin_trk_clear" );
}
aa_building_second_floor_clear_dialog( endon_msg )
{
if( isDefined( endon_msg ) )
{
level endon( endon_msg );
}
flag_wait( "vo_aa_second_floor_clear" );
level.truck dialogue_queue( "berlin_trk_clear2" );
level.essex dialogue_queue( "berlin_rno_rog" );
}
create_nag_prompt( how, line, who )
{
foo = [];
foo["how"] = how;
foo["line"] = line;
foo["who"] = who;
return foo;
}
generic_nag_loop( guy, prompt_arr, endon_msg, wait_min, wait_max, start_delay, flag_start )
{
if( isarray( endon_msg ) )
{
foreach( msg in endon_msg )
{
level endon( msg );
}
}
else
{
level endon( endon_msg );
}
if(isdefined(flag_start))
flag_wait(flag_start);
if(isdefined(start_delay))
wait( start_delay );
prompt_idx = 0;
prompt_size = prompt_arr.size;
while( 1 )
{
vo_info = undefined;
vo_info = prompt_arr[prompt_idx];
assert( isdefined( vo_info["how"] ) );
assert( isdefined( vo_info["line"] ) );
if( !isDefined( vo_info["who"] ) )
{
vo_info["who"] = guy;
}
choose_vo( vo_info["who"], vo_info["how"], vo_info["line"]);
prompt_idx = get_next_prompt_idx( prompt_idx, prompt_size );
wait( randomintrange( wait_min, wait_max ) );
}
}
aa_building_keep_moving_nag( endon_msg )
{
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_keepmoving2" );
prompt_arr[1] = create_nag_prompt("queue", "go_go_go" );
prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_waitingfor" );
generic_nag_loop( level.lone_star, prompt_arr, endon_msg, 16, 18, 3);
}
berlin_aa_roof_clear_dialog()
{
level endon( "aa_building_level4_dead" );
flag_wait("player_on_roof");
level.lone_star dialogue_queue( "berlin_cby_visontarget" );
}
berlin_sniper_dialog()
{
thread sniper_get_into_pos_nag();
flag_wait("snipe_player_in_position");
radio_dialogue( "berlin_cby_inposition" );
radio_dialogue( "berlin_lbp_willrelay" );
level.player sniper_rifle_pickup_nag();
if( !flag( "sniper_hotel_roof_clear" ) )
{
thread sniper_wave_1_player_kills_dialog();
thread sniper_clear_roof_top_nag();
}
flag_wait( "bravo_team_spawned" );
radio_dialogue( "berlin_lbp_overwatch" );
radio_dialogue( "berlin_grl_breaching" );
wait( .5 );
radio_dialogue( "berlin_apg_missilesloose" );
flag_wait( "sniper_delta_support_squad_unloaded" );
radio_dialogue( "berlin_lbp_ondecknow" );
level.in_monitor_kills_dialogue = false;
thread sniper_kills_dialog();
wait( 2 );
radio_dialogue("berlin_grl_takingfire");
level.truck dialogue_queue( "berlin_trk_gotcompany" );
wait( 1 );
level.lone_star dialogue_queue( "berlin_cby_giveemcover" );
wait( 1 );
if( !flag( "snipe_hotel_roof_complete" ) )
{
level.player sniper_rifle_pickup_nag();
}
if( !flag( "snipe_hotel_roof_complete" ) )
{
thread sniper_wave_2_player_kills_dialog();
thread sniper_rooftop_wave_2_nag();
}
flag_wait("tanks_scripted_fire");
level.truck dialogue_queue("berlin_brvl_btrcrawl");
wait( 1 );
level.lone_star dialogue_queue( "berlin_cby_firemission" );
radio_dialogue("race_track_clear");
radio_dialogue("berlin_plt_standingby");
flag_set("paint_targets_vo");
loc = getstruct( "player_looking_at_hotel_loc", "targetname" );
if( !flag( "sniper_tanks_one_dead" ) )
{
thread sniper_ignore_tank_nag( "sniper_tanks_one_dead", loc );
}
flag_wait("sniper_tanks_one_dead");
wait( 4 );
level.lone_star dialogue_queue( "berlin_cby_directhit2" );
if( !flag( "parkway_tank_dead" ) )
{
level.lone_star dialogue_queue("berlin_cby_twomoretanks");
}
if( !flag( "parkway_tank_dead" ) )
{
thread sniper_ignore_tanks_nag( "parkway_tank_dead", loc );
}
flag_wait( "parkway_tank_dead" );
wait( 3.25 );
radio_dialogue( "berlin_trk_takeit" );
wait( 1 );
level.lone_star dialogue_queue( "berlin_cby_flankclear" );
radio_dialogue("berlin_grl_assault");
aud_send_msg("prime_granite_breach");
flag_wait( "bravo_team_reached_lower_rooftop" );
level.lone_star dialogue_queue( "berlin_cby_maintaineyes" );
if( !flag( "player_looking_at_granite" ) )
{
thread sniper_granite_death_scene_nag();
}
flag_wait( "player_looking_at_granite" );
radio_dialogue( "berlin_grl_goingin" );
flag_wait("delta_support_breach_kick");
aud_send_msg("play_granite_breach");
wait(3.5);
level.lone_star dialogue_queue( "berlin_cby_eyesondaughter" );
wait(5.2);
aud_send_msg("prime_granite_explosion");
wait(1.0);
flag_set( "sniper_delta_support_guys_dead" );
aud_send_msg("play_granite_explosion");
wait( 4 );
level.lone_star dialogue_queue( "berlin_cby_granitegranite" );
wait( 1 );
level.truck dialogue_queue( "berlin_trk_damn" );
level.essex dialogue_queue( "berlin_rno_eaglesdown" );
wait( .5 );
level.lone_star dialogue_queue( "berlin_cby_pcteam" );
flag_set( "sniper_vo_complete" );
radio_dialogue( "berlin_hqr_linkup" );
level.lone_star dialogue_queue("berlin_cby_sandmanout");
flag_set( "begin_rappel_vo" );
}
sniper_granite_death_scene_nag()
{
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_eyesongranite" );
prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_maintaineyes" );
generic_nag_loop( level.lone_star, prompt_arr, "player_looking_at_granite", 7, 9, 5);
}
sniper_rooftop_wave_2_nag()
{
level endon("snipe_hotel_roof_complete");
wait( 5 );
prompt = 0;
prompt_size = 2;
vo_line = "berlin_trk_guysonroof";
dude = level.truck;
while( 1 )
{
switch( prompt )
{
case 0:
vo_line = "berlin_trk_guysonroof";
dude = level.truck;
break;
case 1:
vo_line = "berlin_rno_ontheroof";
dude = level.essex;
break;
}
dude thread dialogue_queue_no_overlap( vo_line );
prompt = get_next_prompt_idx( prompt, prompt_size );
wait( randomIntRange( 13,15 ) );
}
}
sniper_wave_1_player_kills_dialog()
{
level endon("bravo_team_spawned");
level endon("sniper_hotel_roof_clear");
total_kills = level.total_rooftop_patrollers;
while( 1 )
{
level waittill( "snipe_hotel_roof_player_kill" );
wait( .05 );
if(level.player_sniper_kills == 1)
{
level.lone_star dialogue_queue("berlin_cby_goodhit2");
}
else if(level.player_sniper_kills == total_kills)
{
level.lone_star dialogue_queue("goodkill");
}
}
}
sniper_wave_2_player_kills_dialog()
{
level endon("snipe_hotel_roof_complete");
first_line_played = false;
total_kills = level.total_roof_kills_needed;
while( 1 )
{
level waittill( "snipe_hotel_roof_player_kill" );
wait( .05 );
if( level.sniper_kills >= (level.total_roof_kills_needed - level.total_upperroof_enemies + 1) && !first_line_played )
{
level.lone_star thread dialogue_queue_no_overlap("berlin_cby_goodeffect");
first_line_played = true;
}
else if( level.sniper_kills == (total_kills - 3) )
{
level.lone_star thread dialogue_queue_no_overlap("berlin_cby_goodhit2");
}
else if( level.sniper_kills == total_kills)
{
level.lone_star thread dialogue_queue_no_overlap("goodkill");
}
}
}
dialogue_queue_no_overlap( line )
{
if( level.in_monitor_kills_dialogue )
{
while( level.in_monitor_kills_dialogue )
{
wait( .1 );
}
}
level.in_monitor_kills_dialogue = true;
self dialogue_queue( line );
level.in_monitor_kills_dialogue = false;
}
sniper_kills_dialog()
{
level endon( "paint_targets_vo" );
while(1)
{
level waittill("snipe_hotel_roof_death");
wait(.05);
if( level.sniper_kills == (level.total_roof_kills_needed - 4) )
{
level.lone_star thread dialogue_queue_no_overlap( "berlin_cby_4enemies" );
}
else if( level.sniper_kills == level.total_roof_kills_needed )
{
level.lone_star thread dialogue_queue_no_overlap( "berlin_cby_areaclear" );
}
}
}
sniper_clear_roof_top_nag()
{
endon_arr = [];
endon_arr[0] = "sniper_hotel_roof_clear";
endon_arr[1] = "bravo_team_spawned";
foreach( msg in endon_arr )
{
level endon( msg );
}
level.essex dialogue_queue( "berlin_rno_ontheroof" );
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_takecare" );
prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_canland" );
prompt_arr[2] = create_nag_prompt("queue", "berlin_rno_ontheroof", level.essex );
generic_nag_loop( level.lone_star, prompt_arr, endon_arr, 15, 17, 16 );
}
sniper_get_into_pos_nag()
{
level endon( "snipe_player_in_position" );
flag_wait( "aa_building_level4_dead" );
wait( 2 );
level.lone_star dialogue_queue( "berlin_cby_strongpoint" );
wait( 2 );
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_overwatch" );
prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_wastingtime" );
generic_nag_loop( level.lone_star, prompt_arr, "snipe_player_in_position", 15, 17 );
}
sniper_ignore_tank_nag( endon_msg, loc )
{
if( isDefined( endon_msg ) )
{
level endon ( endon_msg );
}
wait( 8 );
prompt = 0;
prompt_size = 3;
how = "";
while( 1 )
{
vo_line = "paint_targets";
switch( prompt )
{
case 0:
if ( within_fov( level.player.origin, level.player.angles, loc.origin, 0.766 ) )
{
how = "queue";
vo_line = "berlin_cby_stoplooking";
}
else
{
how = "queue";
vo_line = "berlin_cby_tankonstreet";
}
break;
case 1:
how = "queue";
vo_line = "paint_targets";
break;
case 2:
how = "queue";
vo_line = "berlin_cby_belowus";
break;
}
choose_vo( level.lone_star, how, vo_line );
prompt = get_next_prompt_idx( prompt, prompt_size );
wait( randomIntRange( 10, 13 ) );
}
}
choose_vo( guy, how, line )
{
switch( how )
{
case "radio":
radio_dialogue( line );
break;
case "hint":
IPrintlnBold( line );
break;
case "queue":
assert( isdefined( guy ) );
assert( isai( guy ) );
assert( isalive( guy ) );
guy dialogue_queue( line );
break;
default:
assertEx( 0, "unknown vo play type");
break;
}
}
get_next_prompt_idx( prompt, prompt_size )
{
prompt++;
return prompt % prompt_size;
}
sniper_ignore_tanks_nag( endon_msg, loc )
{
if( isDefined( endon_msg ) )
{
level endon ( endon_msg );
}
wait( 10 );
how = "";
prompt = 0;
prompt_size = 2;
while( 1 )
{
vo_line = "berlin_cby_waitingfor";
switch( prompt )
{
case 0:
how = "queue";
vo_line = "berlin_cby_waitingfor";
break;
case 1:
how = "queue";
if ( within_fov( level.player.origin, level.player.angles, loc.origin, 0.766 ) )
{
vo_line = "berlin_cby_stoplooking";
}
else
{
vo_line = "berlin_cby_targettanks";
}
break;
}
choose_vo( level.lone_star, how, vo_line );
prompt = get_next_prompt_idx( prompt, prompt_size );
wait( randomIntRange( 10, 13 ) );
}
}
sniper_rifle_pickup_nag()
{
assert(isplayer(self));
cur_weapon_list = self GetWeaponsListPrimaries();
nag = true;
foreach(weap in cur_weapon_list)
{
if(weap == level.sniper_rifle)
{
nag = false;
break;
}
}
if(nag)
{
level.lone_star dialogue_queue( "berlin_cby_grabrifle" );
}
else if(self GetCurrentWeapon() != level.sniper_rifle)
{
level.lone_star dialogue_queue( "berlin_cby_userifle" );
}
}
berlin_rappel_dialog()
{
flag_wait( "begin_rappel_vo" );
aud_send_msg( "mus_sniper_complete" );
endon_arr = [];
endon_arr[0] = "player_near_rappel";
endon_arr[1] = "ai_near_rappel";
if( !flag( endon_arr[0] ) && !flag( endon_arr[1] ) )
{
prompt_arr_1 = [];
prompt_arr_1[0] = create_nag_prompt("queue", "berlin_cby_frostthisway" );
prompt_arr_1[0] = create_nag_prompt("queue", "berlin_cby_overhere" );
prompt_arr_1[1] = create_nag_prompt("queue", "berlin_cby_letsmove2" );
prompt_arr_1[2] = create_nag_prompt("queue", "berlin_cby_thisway2" );
thread generic_nag_loop( level.lone_star, prompt_arr_1, endon_arr, 8, 10, 4 );
}
flag_wait_either( "ai_near_rappel", "player_near_rappel" );
endon_msg = "player_rappels";
if( !flag( endon_msg ) )
{
prompt_arr_2 = [];
prompt_arr_2[0] = create_nag_prompt("queue", "berlin_cby_hookup" );
prompt_arr_2[1] = create_nag_prompt("queue", "berlin_cby_hookup2" );
prompt_arr_2[2] = create_nag_prompt("queue", "berlin_cby_letsmove2" );
thread generic_nag_loop( level.lone_star, prompt_arr_2, endon_msg, 8, 10 );
}
}
berlin_rappel_complete_dialog()
{
flag_wait( "vo_check_wounded_soldier" );
level.truck dialogue_queue( "berlin_trk_casualties" );
level.lone_star dialogue_queue( "berlin_cby_patchestags" );
level.truck dialogue_queue( "berlin_trk_rog" );
alley_downed_apache_dialog( "start_bridge_battle" );
flag_set( "vo_downed_apache_complete" );
}
alley_downed_apache_dialog( endon_msg )
{
level endon( endon_msg );
level.truck dialogue_queue( "berlin_trk_onyxteam" );
radio_dialogue( "berlin_trk_needevac" );
radio_dialogue( "berlin_hqr_sarbird" );
level.essex dialogue_queue( "berlin_rno_notagoodday" );
}
berlin_clear_bridge_dialog()
{
flag_wait( "start_bridge_battle" );
flag_wait( "vo_downed_apache_complete" );
wait( 3 );
if(!flag("rus_all_tanks_dead"))
{
radio_dialogue("berlin_gtc_pinneddown");
}
if(!flag("rus_all_tanks_dead"))
{
level.truck dialogue_queue( "berlin_trk_dugin" );
}
if(!flag("rus_all_tanks_dead"))
{
level.lone_star dialogue_queue( "berlin_cby_takecareofit" );
}
wait( .5 );
if(!flag("rus_all_tanks_dead"))
{
thread bridge_kill_rus_tank_nag( "rus_all_tanks_dead" );
thread bridge_tanks_moving_dialog("rus_all_tanks_dead");
thread bridge_deadtank_death_dialog( "rus_all_tanks_dead" );
}
flag_wait( "rus_all_tanks_dead" );
wait( 1 );
level.lone_star dialogue_queue("berlin_cby_goodhit2");
wait( 2 );
level.lone_star dialogue_queue( "berlin_cby_moveout" );
if( !flag( "usa_tanks_start_parkway" ) )
{
thread bridge_player_stays_back_nag( "usa_tanks_start_parkway" );
}
}
bridge_deadtank_death_dialog( endon_msg )
{
level endon( endon_msg );
flag_wait( "bridge_deadtank_dead" );
radio_dialogue( "berlin_gtc_hithard" );
}
bridge_kill_rus_tank_nag( endon_msg )
{
level endon( endon_msg );
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_grabrpg" );
prompt_arr[1] = create_nag_prompt("queue", "berlin_rno_killthatthing", level.essex);
prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_takeouttank" );
prompt_arr[3] = create_nag_prompt("queue", "berlin_cby_gettogirl" );
generic_nag_loop( level.lone_star, prompt_arr, endon_msg, 10, 13, 1 );
}
bridge_player_stays_back_nag( endon_msg )
{
level endon( endon_msg );
wait( 16 );
prompt = 0;
prompt_size = 3;
vo_line = "move_up";
while( 1 )
{
switch( prompt )
{
case 0:
vo_line = "move_up";
break;
case 1:
vo_line = "push_forward";
break;
case 2:
vo_line = "berlin_cby_contactahead";
break;
}
level.lone_star dialogue_queue( vo_line );
prompt = get_next_prompt_idx( prompt, prompt_size );
wait( randomIntRange( 15, 16 ) );
}
}
bridge_tanks_moving_dialog( msg )
{
assert( !flag( msg ) );
level endon( msg );
flag_wait("usa_tanks_starting_on_bridge");
level.lone_star dialogue_queue("berlin_cby_armormoving");
}
berlin_advance_pkway_dialog()
{
flag_wait( "usa_tanks_start_parkway" );
thread parkway_bank_dialog();
thread parkway_office_dialog();
thread parkway_tank_scripted_fire_dialog();
radio_dialogue( "berlin_gtc_advancing" );
thread parkway_player_stays_back_nag( "player_interacting_with_wounded_lonestar" );
flag_wait( "vo_move_up" );
radio_dialogue( "berlin_gtc_straightahead" );
flag_wait( "vo_push_forward" );
level.lone_star dialogue_queue( "push_forward" );
flag_wait( "vo_lay_down_fire" );
level.lone_star dialogue_queue( "berlin_cby_almostthere" );
flag_wait( "vo_press_the_attack" );
level.lone_star dialogue_queue( "press_attack" );
}
parkway_bank_dialog()
{
flag_wait("parkway_player_near_bank");
radio_dialogue( "berlin_gtc_acquiring" );
wait( 1 );
level.lone_star dialogue_queue( "inside_bank" );
flag_wait( "bridge_bradleys_move_up" );
radio_dialogue( "berlin_gtc_moretargets" );
}
parkway_office_dialog()
{
flag_wait( "vo_parkway_near_office_building" );
radio_dialogue( "berlin_gtc_left20degrees" );
wait( 2 );
radio_dialogue( "berlin_gtc_office" );
}
parkway_tank_scripted_fire_dialog( endon_msg )
{
if( isDefined( endon_msg ) )
{
level endon( endon_msg );
}
flag_wait( "usa_tank2_in_pos" );
flag_wait( "parkway_tank_shot" );
radio_dialogue( "berlin_gtc_firing" );
}
parkway_player_stays_back_nag( endon_msg )
{
level endon( endon_msg );
wait( 2 );
prompt = 0;
prompt_size = 4;
vo_line = "berlin_cby_followtanks";
cover_line_played = false;
while( 1 )
{
switch( prompt )
{
case 0:
vo_line = "berlin_cby_followtanks";
break;
case 1:
vo_line = "berlin_cby_useem";
cover_line_played = true;
break;
case 2:
vo_line = "move_up";
break;
case 3:
vo_line = "berlin_cby_contactahead";
break;
}
level.lone_star dialogue_queue( vo_line );
prompt = get_next_prompt_idx( prompt, prompt_size );
if( prompt == 1 && cover_line_played )
{
prompt = get_next_prompt_idx( prompt, prompt_size );
}
wait( randomIntRange( 15, 16 ) );
}
}
berlin_building_collapse_dialog()
{
flag_wait( "parkway_retreat_start" );
aud_send_msg( "bln_ivan_falling_back" );
berlin_shared_ambush_dialog();
level.lone_star dialogue_queue("berlin_cby_aoislost");
radio_dialogue( "berlin_hqr_missedyourlast" );
level.lone_star dialogue_queue( "berlin_cby_damnbuilding" );
radio_dialogue( "berlin_hqr_pullback" );
level.lone_star dialogue_queue( "berlin_cby_goingforgirl" );
radio_dialogue( "berlin_hqr_berlinfalling" );
flag_set( "vo_building_collapse_complete" );
}
berlin_traverse_building_dialog()
{
flag_wait( "ceiling_collapse_complete" );
aud_send_msg( "mus_ceiling_collapse_complete" );
flag_wait( "vo_building_collapse_complete" );
level.lone_star dialogue_queue( "berlin_cby_throughhere" );
wait( 5.5 );
level.truck dialogue_queue( "berlin_trk_rigged" );
level.essex dialogue_queue( "berlin_rno_thisissome" );
level.lone_star waittill( "sliding_complete" );
level.essex dialogue_queue( "berlin_rno_comedown" );
level.truck dialogue_queue( "berlin_trk_keepmoving" );
flag_wait( "aud_ibeam_fall_complete" );
wait( 5 );
if( !flag( "truck_at_emerge_door" ) )
{
level.truck dialogue_queue( "berlin_trk_easy" );
}
flag_wait( "lone_star_at_emerge_door" );
flag_wait( "building_traverse_end" );
level.truck dialogue_queue( "berlin_trk_doorway" );
level.lone_star dialogue_queue( "berlin_cby_imonit" );
}
berlin_shared_ambush_dialog()
{
flag_wait("ambush_after_building_collapse_start");
wait( 6.0 );
dummy = spawn( "script_origin", level.lone_star.origin );
dummy.animname = "lone_star";
dummy dialogue_queue("an_ambush");
flag_wait( "intro_lone_star_facial_anim_complete" );
radio_dialogue( "berlin_hqr_lostcontact" );
}
berlin_emerge_dialog()
{
level.emerge_hotel_nag_played = false;
flag_wait( "emerge_door_open" );
if( level.emerge_hotel_nag_played == false )
{
level.lone_star dialogue_queue( "berlin_cby_theresthehotel" );
level.emerge_hotel_nag_played = true;
}
aud_send_msg( "mus_emerge_door_open" );
flag_wait_either( "emerge_dudes_dead", "start_last_stand" );
level.lone_star dialogue_queue( "berlin_cby_updateongirl" );
radio_dialogue( "berlin_hqr_zerotime" );
level.lone_star dialogue_queue( "berlin_cby_losingher" );
thread emerge_hotel_nag();
flag_set( "emerge_dialogue_done" );
}
emerge_hotel_nag()
{
flag_wait("vo_theres_the_hotel");
wait( 2.5 );
if(!flag("emerge_hotel_in_view") && level.emerge_hotel_nag_played == false )
{
level.lone_star dialogue_queue( "berlin_cby_theresthehotel" );
level.emerge_hotel_nag_played = true;
}
}
berlin_last_stand_dialog()
{
flag_wait("start_last_stand");
flag_wait( "emerge_dialogue_done" );
flag_wait( "last_stand_get_to_roof" );
level.lone_star dialogue_queue("head_for_roof");
thread last_stand_get_to_roof_nag();
flag_wait( "door_hotel_stairs_1_open" );
level.lone_star dialogue_queue( "berlin_cby_upstairs" );
level.lone_star dialogue_queue( "get_to_roof" );
radio_dialogue( "berlin_hqr_standdown" );
level.lone_star dialogue_queue( "berlin_cby_canmakeit" );
thread last_stand_stairwell_nag();
flag_wait("player_top_of_hotel_stairwell");
}
last_stand_get_to_roof_nag()
{
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_letsgoletsgo" );
prompt_arr[1] = create_nag_prompt("queue", "head_for_roof" );
generic_nag_loop( level.lone_star, prompt_arr, "door_hotel_stairs_1_open", 13, 15, 16);
}
last_stand_stairwell_nag()
{
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_frostthisway" );
prompt_arr[1] = create_nag_prompt("queue", "head_for_roof" );
prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_letsgoletsgo" );
prompt_arr[3] = create_nag_prompt("queue", "berlin_cby_gogogo3" );
prompt_arr[4] = create_nag_prompt("queue", "berlin_cby_keepmoving2" );
generic_nag_loop( level.lone_star, prompt_arr, "player_top_of_hotel_stairwell", 8, 10, 2);
}
reverse_breach_hall_nag()
{
prompt_arr = [];
prompt_arr[0] = create_nag_prompt("queue", "berlin_cby_stackup" );
prompt_arr[1] = create_nag_prompt("queue", "berlin_cby_hitthedoor" );
prompt_arr[2] = create_nag_prompt("queue", "berlin_cby_frostthisway" );
generic_nag_loop( level.lone_star, prompt_arr, "reverse_breach_start", 8, 10, 2, "exfil_hallway_dudes_dead");
}
berlin_reverse_breach_hallway_dialog()
{
flag_wait("player_top_of_hotel_stairwell");
level.alena dialogue_queue("berlin_aln_scream1");
level.lone_star dialogue_queue( "berlin_cby_behindthedoor" );
thread reverse_breach_hall_nag();
flag_wait( "exfil_hallway_dudes_dead" );
level.alena dialogue_queue("berlin_aln_scream2");
}
berlin_reverse_breach_dialog()
{
flag_wait("reverse_breach_complete");
wait( .5 );
level.alena dialogue_queue("berlin_aln_scream3");
flag_wait( "reverse_breach_getup_slowmo_start" );
level.alena dialogue_queue("berlin_aln_helpme");
flag_wait( "reverse_breach_player_back_in_business" );
wait( 4.5 );
flag_set( "reverse_breach_ending_vo_complete" );
}
