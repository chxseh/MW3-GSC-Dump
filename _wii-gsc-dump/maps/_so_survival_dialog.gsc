#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_survival_AI;
survival_dialog_init()
{
survival_dialog_radio_setup();
thread survival_dialog_wave_start();
thread survival_dialog_boss();
thread survival_dialog_wave_end();
thread survival_dialog_airsupport();
thread survival_dialog_claymore_plant();
thread survival_dialog_sentry_updates();
}
survival_dialog_wave_start()
{
level endon( "special_op_terminated" );
ai_use_info = [];
while ( 1 )
{
level waittill( "wave_started", wave_num );
msg = level waittill_any_timeout( 1.5, "wave_ended" );
if ( msg == "wave_ended" )
continue;
if ( wave_num == 1 )
{
if ( is_coop() )
radio_dialogue( "so_hq_mission_intro" );
else
radio_dialogue( "so_hq_mission_intro_sp" );
continue;
}
ai_type = dialog_get_special_ai_type( wave_num, ai_use_info );
if ( isdefined( ai_type ) && ai_type != "" )
{
if ( !isdefined( ai_use_info[ ai_type ] ) )
ai_use_info[ ai_type ] = 1;
else
ai_use_info[ ai_type ]++;
}
else
{
ai_type = get_squad_type( wave_num );
}
if ( isdefined( ai_type ) && ai_type != "" )
{
assertex( isdefined( level.scr_radio[ "so_hq_enemy_intel_" + ai_type ] ), ai_type + " ai type does not have radio intel message." );
if ( isdefined( level.scr_radio[ "so_hq_enemy_intel_" + ai_type ] ) )
{
radio_dialogue( "so_hq_enemy_intel_" + ai_type );
}
}
}
}
dialog_get_special_ai_type( wave_num, ai_use_info )
{
special_types = get_special_ai( wave_num );
if ( !isdefined( special_types ) || !special_types.size )
return undefined;
foreach ( s_type in special_types )
{
if ( !isdefined( ai_use_info[ s_type ] ) )
{
ai_use_info[ s_type ] = 0;
}
}
chosen_ai_type = "";
chosen_use_count = 0;
foreach ( ai_type, ai_count in ai_use_info )
{
if ( array_contains( special_types, ai_type ) && ( chosen_ai_type == "" || ai_count < chosen_use_count ) )
{
chosen_ai_type = ai_type;
chosen_use_count	= ai_count;
}
}
return chosen_ai_type;
}
survival_dialog_boss()
{
level endon( "special_op_terminated" );
while ( 1 )
{
boss_msg_played = false;
level waittill( "boss_spawning", wave_num );
AI_bosses = get_bosses_ai( wave_num );
nonAI_bosses = get_bosses_nonai( wave_num );
if ( isdefined( nonAI_bosses ) && nonAI_bosses.size )
{
if ( nonAI_bosses.size == 1 )
{
if ( isdefined( level.scr_radio[ "so_hq_boss_intel_" + nonAI_bosses[ 0 ] ] ) )
{
radio_dialogue( "so_hq_boss_intel_" + nonAI_bosses[ 0 ] );
boss_msg_played = true;
}
}
else
{
if ( isdefined( level.scr_radio[ "so_hq_boss_intel_" + nonAI_bosses[ 0 ] + "_many" ] ) )
{
radio_dialogue("so_hq_boss_intel_" + nonAI_bosses[ 0 ] + "_many" );
boss_msg_played = true;
}
}
}
if ( isdefined( AI_bosses ) && AI_bosses.size )
{
if ( boss_msg_played )
{
msg = level waittill_any_timeout( 1.5, "wave_ended" );
if ( msg == "wave_ended" )
continue;
}
if ( AI_bosses.size == 1 )
{
if ( isdefined( level.scr_radio[ "so_hq_boss_intel_" + AI_bosses[ 0 ] ] ) )
{
radio_dialogue("so_hq_boss_intel_" + AI_bosses[ 0 ] );
}
}
else
{
if ( isdefined( level.scr_radio[ "so_hq_enemy_intel_boss_transport_many" ] ) )
{
radio_dialogue( "so_hq_enemy_intel_boss_transport_many" );
}
}
}
}
}
survival_dialog_wave_end()
{
level endon( "special_op_terminated" );
while ( 1 )
{
level waittill( "wave_ended", wave_num );
msg = level waittill_any_timeout( 1.5, "wave_started" );
if ( msg == "wave_started" )
continue;
armory_type = "";
if ( isdefined( level.armory_unlock ) )
{
if ( isdefined( level.armory_unlock[ "weapon" ] ) && level.armory_unlock[ "weapon" ] == wave_num )
armory_type = "weapon";
else if ( isdefined( level.armory_unlock[ "equipment" ] ) && level.armory_unlock[ "equipment" ] == wave_num )
armory_type = "equipment";
else if ( isdefined( level.armory_unlock[ "airsupport" ] ) && level.armory_unlock[ "airsupport" ] == wave_num )
armory_type = "airsupport";
}
if ( armory_type != "" && isdefined( level.scr_radio[ "so_hq_armory_open_" + armory_type ] ) )
{
radio_dialogue( "so_hq_armory_open_" + armory_type );
}
else
{
radio_dialogue( "so_hq_wave_over_flavor" );
}
}
}
survival_dialog_airsupport()
{
level endon( "special_op_terminated" );
while ( 1 )
{
level waittill( "so_airsupport_incoming", support_type );
if ( isdefined( level.scr_radio[ "so_hq_as_" + support_type ] ) )
radio_dialogue( "so_hq_as_" + support_type );
}
}
survival_dialog_claymore_plant()
{
level endon( "special_op_terminated" );
while ( 1 )
{
msg = level waittill_any_return( "ai_claymore_planted", "ai_chembomb_planted" );
if ( msg == "ai_claymore_planted" )
{
if ( isdefined( level.scr_radio[ "so_hq_enemy_update_claymore" ] ) )
{
radio_dialogue( "so_hq_enemy_update_claymore" );
}
}
else if ( msg == "ai_chembomb_planted" )
{
}
level waittill( "wave_ended" );
}
}
survival_dialog_armory_restocked( armory_type )
{
assertex( isdefined( level.scr_radio[ "so_hq_armory_stocked_" + armory_type ] ), armory_type + " armory does not have restock chatter." );
if ( armory_type != "" && isdefined( level.scr_radio[ "so_hq_armory_stocked_" + armory_type ] ) )
radio_dialogue( "so_hq_armory_stocked_" + armory_type );
}
survival_dialog_sentry_updates()
{
level endon( "special_op_terminated" );
msg_last = "";
while ( 1 )
{
msg = level waittill_any_return( "a_sentry_died", "a_sentry_is_underattack", "wave_ended" );
if ( msg == "wave_ended" )
{
msg_last = "";
}
else if ( msg == "a_sentry_is_underattack" && msg_last != "a_sentry_is_underattack" )
{
thread survival_dialog_radio_sentry_underattack();
}
else if ( msg == "a_sentry_died" )
{
thread survival_dialog_radio_sentry_down();
}
msg_last = msg;
}
}
survival_dialog_radio_sentry_down()
{
if ( isdefined( level.scr_radio[ "so_hq_sentry_down" ] ) )
radio_dialogue( "so_hq_sentry_down" );
}
survival_dialog_radio_sentry_underattack()
{
if ( isdefined( level.scr_radio[ "so_hq_sentry_underattack" ] ) )
radio_dialogue( "so_hq_sentry_underattack" );
}
survival_dialog_player_down()
{
level endon( "special_op_terminated" );
while ( 1 )
{
level waittill( "so_player_down" );
if ( isdefined( level.scr_radio[ "so_hq_player_down" ] ) )
radio_dialogue( "so_hq_player_down" );
}
}
survival_dialog_radio_setup()
{
level.scr_radio[ "so_hq_mission_intro" ] = "so_hq_mission_intro";
level.scr_radio[ "so_hq_mission_intro_sp" ] = "so_hq_mission_intro_sp";
level.scr_radio[ "so_hq_enemy_intel_easy" ] = "so_hq_enemy_intel_generic";
level.scr_radio[ "so_hq_enemy_intel_regular" ] = "so_hq_enemy_intel_generic";
level.scr_radio[ "so_hq_enemy_intel_hardened" ] = "so_hq_enemy_intel_generic";
level.scr_radio[ "so_hq_enemy_intel_veteran" ] = "so_hq_enemy_intel_generic";
level.scr_radio[ "so_hq_enemy_intel_elite" ] = "so_hq_enemy_intel_generic";
level.scr_radio[ "so_hq_enemy_intel_claymore" ] = "so_hq_enemy_intel_generic";
level.scr_radio[ "so_hq_enemy_intel_martyrdom" ] = "so_hq_enemy_intel_martyrdom";
level.scr_radio[ "so_hq_enemy_intel_chemical" ] = "so_hq_enemy_intel_chemical";
level.scr_radio[ "so_hq_enemy_intel_dog_splode" ] = "so_hq_enemy_intel_dog_splode";
level.scr_radio[ "so_hq_enemy_intel_dog_reg" ] = "so_hq_enemy_intel_dog_reg";
level.scr_radio[ "so_hq_armory_open_weapon" ] = "so_hq_armory_open_weapon";
level.scr_radio[ "so_hq_armory_open_equipment" ] = "so_hq_armory_open_equipment";
level.scr_radio[ "so_hq_armory_open_airsupport" ] = "so_hq_armory_open_airstrike";
level.scr_radio[ "so_hq_armory_stocked_all" ] = "so_hq_armory_stocked_all";
level.scr_radio[ "so_hq_armory_stocked_equipment" ] = "so_hq_armory_stocked_equipment";
level.scr_radio[ "so_hq_wave_over_flavor" ] = "so_hq_wave_over_flavor";
level.scr_radio[ "so_hq_enemy_update_claymore" ] = "so_hq_enemy_update_claymore";
level.scr_radio[ "so_hq_sentry_down" ] = "so_hq_sentry_down";
level.scr_radio[ "so_hq_sentry_underattack" ] = "so_hq_sentry_underattack";
level.scr_radio[ "so_hq_player_down" ] = "so_hq_player_down";
level.scr_radio[ "so_hq_boss_intel_jug_regular" ] = "so_hq_enemy_intel_boss_transport";
level.scr_radio[ "so_hq_boss_intel_jug_riotshield" ] = "so_hq_enemy_intel_boss_transport";
level.scr_radio[ "so_hq_boss_intel_jug_explosive" ] = "so_hq_enemy_intel_boss_transport";
level.scr_radio[ "so_hq_boss_intel_jug_headshot" ] = "so_hq_enemy_intel_boss_transport";
level.scr_radio[ "so_hq_boss_intel_jug_minigun" ] = "so_hq_enemy_intel_boss_transport";
level.scr_radio[ "so_hq_enemy_intel_boss_transport_many" ]	= "so_hq_enemy_intel_boss_transport_many";
level.scr_radio[ "so_hq_boss_intel_chopper" ] = "so_hq_boss_intel_chopper";
level.scr_radio[ "so_hq_boss_intel_chopper_many" ] = "so_hq_boss_intel_chopper_many";
level.scr_radio[ "so_hq_as_friendly_support_delta" ]	= "so_hq_airsupport_ally_delta";
level.scr_radio[ "so_hq_as_friendly_support_riotshield" ]	= "so_hq_airsupport_ally_riotshield";
level.scr_radio[ "so_hq_uav_busy" ] = "so_hq_uav_busy";
}