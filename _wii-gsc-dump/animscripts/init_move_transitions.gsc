#include animscripts\Utility;
#include maps\_utility;
#include animscripts\Combat_utility;
#include common_scripts\Utility;
#using_animtree( "generic_human" );
init_move_transition_arrays()
{
if ( isdefined( anim.move_transition_arrays ) )
return;
anim.move_transition_arrays = 1;
if ( !isdefined( anim.coverTrans ) )
anim.coverTrans = [];
if ( !isdefined( anim.coverExit ) )
anim.coverExit = [];
anim.maxDirections = [];
anim.excludeDir = [];
anim.traverseInfo = [];
if ( !isdefined( anim.coverTransLongestDist ) )
anim.coverTransLongestDist = [];
if ( !isdefined( anim.coverTransDist ) )
anim.coverTransDist = [];
if ( !isdefined( anim.coverExitDist ) )
anim.coverExitDist = [];
anim.coverExitPostDist = [];
anim.coverTransPreDist = [];
if ( !isdefined( anim.coverTransAngles ) )
anim.coverTransAngles = [];
if ( !isdefined( anim.coverExitAngles ) )
anim.coverExitAngles = [];
anim.coverExitSplit = [];
anim.coverTransSplit = [];
anim.arrivalEndStance = [];
}
initMoveStartStopTransitions()
{
init_move_transition_arrays();
level.newArrivals = true;
transTypes = [];
transTypes[ 0 ] = "left";
transTypes[ 1 ] = "right";
transTypes[ 2 ] = "left_crouch";
transTypes[ 3 ] = "right_crouch";
transTypes[ 4 ] = "crouch";
transTypes[ 5 ] = "stand";
transTypes[ 6 ] = "exposed";
transTypes[ 7 ] = "exposed_crouch";
transTypes[ 8 ] = "stand_saw";
transTypes[ 9 ] = "prone_saw";
transTypes[ 10 ] = "crouch_saw";
transTypes[ 11 ] = "wall_over_40";
transTypes[ 12 ] = "right_cqb";
transTypes[ 13 ] = "right_crouch_cqb";
transTypes[ 14 ] = "left_cqb";
transTypes[ 15 ] = "left_crouch_cqb";
transTypes[ 16 ] = "exposed_cqb";
transTypes[ 17 ] = "exposed_crouch_cqb";
transTypes[ 18 ] = "heat";
transTypes[ 19 ] = "heat_left";
transTypes[ 20 ] = "heat_right";
transTypes[ 21 ] = "exposed_ready";
transTypes[ 22 ] = "exposed_ready_cqb";
lastCoverTrans = 6;
anim.approach_types = [];
anim.approach_types[ "Cover Left" ] = [];
anim.approach_types[ "Cover Left" ][ "stand" ] = "left";
anim.approach_types[ "Cover Left" ][ "crouch" ] = "left_crouch";
anim.maxDirections[ "Cover Left" ] = 9;
anim.excludeDir[ "Cover Left" ] = 9;
anim.approach_types[ "Cover Right" ] = [];
anim.approach_types[ "Cover Right" ][ "stand" ] = "right";
anim.approach_types[ "Cover Right" ][ "crouch" ] = "right_crouch";
anim.maxDirections[ "Cover Right" ] = 9;
anim.excludeDir[ "Cover Right" ] = 7;
anim.approach_types[ "Cover Crouch" ] = [];
anim.approach_types[ "Cover Crouch" ][ "stand" ] = "crouch";
anim.approach_types[ "Cover Crouch" ][ "crouch" ] = "crouch";
anim.approach_types[ "Conceal Crouch" ] = anim.approach_types[ "Cover Crouch" ];
anim.approach_types[ "Cover Crouch Window" ] = anim.approach_types[ "Cover Crouch" ];
anim.maxDirections[ "Cover Crouch" ] = 6;
anim.excludeDir[ "Cover Crouch" ] = -1;
anim.maxDirections[ "Conceal Crouch" ] = 6;
anim.excludeDir[ "Conceal Crouch" ] = -1;
anim.approach_types[ "Cover Stand" ] = [];
anim.approach_types[ "Cover Stand" ][ "stand" ] = "stand";
anim.approach_types[ "Cover Stand" ][ "crouch" ] = "stand";
anim.approach_types[ "Conceal Stand" ] = anim.approach_types[ "Cover Stand" ];
anim.maxDirections[ "Cover Stand" ] = 6;
anim.excludeDir[ "Cover Stand" ] = -1;
anim.maxDirections[ "Conceal Stand" ] = 6;
anim.excludeDir[ "Conceal Stand" ] = -1;
anim.approach_types[ "Cover Prone" ] = [];
anim.approach_types[ "Cover Prone" ][ "stand" ] = "exposed";
anim.approach_types[ "Cover Prone" ][ "crouch" ] = "exposed";
anim.approach_types[ "Conceal Prone" ] = anim.approach_types[ "Cover Prone" ];
anim.excludeDir[ "Conceal Prone" ] = -1;
anim.approach_types[ "Path" ] = [];
anim.approach_types[ "Path" ][ "stand" ] = "exposed";
anim.approach_types[ "Path" ][ "crouch" ] = "exposed_crouch";
anim.approach_types[ "Guard" ] = anim.approach_types[ "Path" ];
anim.approach_types[ "Ambush" ] = anim.approach_types[ "Path" ];
anim.approach_types[ "Scripted" ] = anim.approach_types[ "Path" ];
anim.approach_types[ "Exposed" ] = anim.approach_types[ "Path" ];
anim.isCombatPathNode[ "Guard" ] = true;
anim.isCombatPathNode[ "Ambush" ] = true;
anim.isCombatPathNode[ "Exposed" ] = true;
anim.isCombatScriptNode[ "Guard" ] = true;
anim.isCombatScriptNode[ "Exposed" ] = true;
anim.coverTrans[ "right" ][ 1 ] = %corner_standR_trans_IN_1;
anim.coverTrans[ "right" ][ 2 ] = %corner_standR_trans_IN_2;
anim.coverTrans[ "right" ][ 3 ] = %corner_standR_trans_IN_3;
anim.coverTrans[ "right" ][ 4 ] = %corner_standR_trans_IN_4;
anim.coverTrans[ "right" ][ 6 ] = %corner_standR_trans_IN_6;
anim.coverTrans[ "right" ][ 8 ] = %corner_standR_trans_IN_8;
anim.coverTrans[ "right" ][ 9 ] = %corner_standR_trans_IN_9;
anim.coverTrans[ "right_crouch" ][ 1 ] = %CornerCrR_trans_IN_ML;
anim.coverTrans[ "right_crouch" ][ 2 ] = %CornerCrR_trans_IN_M;
anim.coverTrans[ "right_crouch" ][ 3 ] = %CornerCrR_trans_IN_MR;
anim.coverTrans[ "right_crouch" ][ 4 ] = %CornerCrR_trans_IN_L;
anim.coverTrans[ "right_crouch" ][ 6 ] = %CornerCrR_trans_IN_R;
anim.coverTrans[ "right_crouch" ][ 8 ] = %CornerCrR_trans_IN_F;
anim.coverTrans[ "right_crouch" ][ 9 ] = %CornerCrR_trans_IN_MF;
anim.coverTrans[ "right_cqb" ][ 1 ] = %corner_standR_trans_CQB_IN_1;
anim.coverTrans[ "right_cqb" ][ 2 ] = %corner_standR_trans_CQB_IN_2;
anim.coverTrans[ "right_cqb" ][ 3 ] = %corner_standR_trans_CQB_IN_3;
anim.coverTrans[ "right_cqb" ][ 4 ] = %corner_standR_trans_CQB_IN_4;
anim.coverTrans[ "right_cqb" ][ 6 ] = %corner_standR_trans_CQB_IN_6;
anim.coverTrans[ "right_cqb" ][ 8 ] = %corner_standR_trans_CQB_IN_8;
anim.coverTrans[ "right_cqb" ][ 9 ] = %corner_standR_trans_CQB_IN_9;
anim.coverTrans[ "right_crouch_cqb" ][ 1 ] = %CornerCrR_CQB_trans_IN_1;
anim.coverTrans[ "right_crouch_cqb" ][ 2 ] = %CornerCrR_CQB_trans_IN_2;
anim.coverTrans[ "right_crouch_cqb" ][ 3 ] = %CornerCrR_CQB_trans_IN_3;
anim.coverTrans[ "right_crouch_cqb" ][ 4 ] = %CornerCrR_CQB_trans_IN_4;
anim.coverTrans[ "right_crouch_cqb" ][ 6 ] = %CornerCrR_CQB_trans_IN_6;
anim.coverTrans[ "right_crouch_cqb" ][ 8 ] = %CornerCrR_CQB_trans_IN_8;
anim.coverTrans[ "right_crouch_cqb" ][ 9 ] = %CornerCrR_CQB_trans_IN_9;
anim.coverTrans[ "left" ][ 1 ] = %corner_standL_trans_IN_1;
anim.coverTrans[ "left" ][ 2 ] = %corner_standL_trans_IN_2;
anim.coverTrans[ "left" ][ 3 ] = %corner_standL_trans_IN_3;
anim.coverTrans[ "left" ][ 4 ] = %corner_standL_trans_IN_4;
anim.coverTrans[ "left" ][ 6 ] = %corner_standL_trans_IN_6;
anim.coverTrans[ "left" ][ 7 ] = %corner_standL_trans_IN_7;
anim.coverTrans[ "left" ][ 8 ] = %corner_standL_trans_IN_8;
anim.coverTrans[ "left_crouch" ][ 1 ] = %CornerCrL_trans_IN_ML;
anim.coverTrans[ "left_crouch" ][ 2 ] = %CornerCrL_trans_IN_M;
anim.coverTrans[ "left_crouch" ][ 3 ] = %CornerCrL_trans_IN_MR;
anim.coverTrans[ "left_crouch" ][ 4 ] = %CornerCrL_trans_IN_L;
anim.coverTrans[ "left_crouch" ][ 6 ] = %CornerCrL_trans_IN_R;
anim.coverTrans[ "left_crouch" ][ 7 ] = %CornerCrL_trans_IN_MF;
anim.coverTrans[ "left_crouch" ][ 8 ] = %CornerCrL_trans_IN_F;
anim.coverTrans[ "left_cqb" ][ 1 ] = %corner_standL_trans_CQB_IN_1;
anim.coverTrans[ "left_cqb" ][ 2 ] = %corner_standL_trans_CQB_IN_2;
anim.coverTrans[ "left_cqb" ][ 3 ] = %corner_standL_trans_CQB_IN_3;
anim.coverTrans[ "left_cqb" ][ 4 ] = %corner_standL_trans_CQB_IN_4;
anim.coverTrans[ "left_cqb" ][ 6 ] = %corner_standL_trans_CQB_IN_6;
anim.coverTrans[ "left_cqb" ][ 7 ] = %corner_standL_trans_CQB_IN_7;
anim.coverTrans[ "left_cqb" ][ 8 ] = %corner_standL_trans_CQB_IN_8;
anim.coverTrans[ "left_crouch_cqb" ][ 1 ] = %CornerCrL_CQB_trans_IN_1;
anim.coverTrans[ "left_crouch_cqb" ][ 2 ] = %CornerCrL_CQB_trans_IN_2;
anim.coverTrans[ "left_crouch_cqb" ][ 3 ] = %CornerCrL_CQB_trans_IN_3;
anim.coverTrans[ "left_crouch_cqb" ][ 4 ] = %CornerCrL_CQB_trans_IN_4;
anim.coverTrans[ "left_crouch_cqb" ][ 6 ] = %CornerCrL_CQB_trans_IN_6;
anim.coverTrans[ "left_crouch_cqb" ][ 7 ] = %CornerCrL_CQB_trans_IN_7;
anim.coverTrans[ "left_crouch_cqb" ][ 8 ] = %CornerCrL_CQB_trans_IN_8;
anim.coverTrans[ "crouch" ][ 1 ] = %covercrouch_run_in_ML;
anim.coverTrans[ "crouch" ][ 2 ] = %covercrouch_run_in_M;
anim.coverTrans[ "crouch" ][ 3 ] = %covercrouch_run_in_MR;
anim.coverTrans[ "crouch" ][ 4 ] = %covercrouch_run_in_L;
anim.coverTrans[ "crouch" ][ 6 ] = %covercrouch_run_in_R;
anim.coverTrans[ "stand" ][ 1 ] = %coverstand_trans_IN_ML;
anim.coverTrans[ "stand" ][ 2 ] = %coverstand_trans_IN_M;
anim.coverTrans[ "stand" ][ 3 ] = %coverstand_trans_IN_MR;
anim.coverTrans[ "stand" ][ 4 ] = %coverstand_trans_IN_L;
anim.coverTrans[ "stand" ][ 6 ] = %coverstand_trans_IN_R;
anim.coverTrans[ "stand_saw" ][ 1 ] = %saw_gunner_runin_ML;
anim.coverTrans[ "stand_saw" ][ 2 ] = %saw_gunner_runin_M;
anim.coverTrans[ "stand_saw" ][ 3 ] = %saw_gunner_runin_MR;
anim.coverTrans[ "stand_saw" ][ 4 ] = %saw_gunner_runin_L;
anim.coverTrans[ "stand_saw" ][ 6 ] = %saw_gunner_runin_R;
anim.coverTrans[ "crouch_saw" ][ 1 ] = %saw_gunner_lowwall_runin_ML;
anim.coverTrans[ "crouch_saw" ][ 2 ] = %saw_gunner_lowwall_runin_M;
anim.coverTrans[ "crouch_saw" ][ 3 ] = %saw_gunner_lowwall_runin_MR;
anim.coverTrans[ "crouch_saw" ][ 4 ] = %saw_gunner_lowwall_runin_L;
anim.coverTrans[ "crouch_saw" ][ 6 ] = %saw_gunner_lowwall_runin_R;
anim.coverTrans[ "prone_saw" ][ 1 ] = %saw_gunner_prone_runin_ML;
anim.coverTrans[ "prone_saw" ][ 2 ] = %saw_gunner_prone_runin_M;
anim.coverTrans[ "prone_saw" ][ 3 ] = %saw_gunner_prone_runin_MR;
anim.coverTrans[ "exposed" ] = [];
anim.coverTrans[ "exposed" ][ 1 ] = %CQB_stop_1;
anim.coverTrans[ "exposed" ][ 2 ] = %run_2_stand_F_6;
anim.coverTrans[ "exposed" ][ 3 ] = %CQB_stop_3;
anim.coverTrans[ "exposed" ][ 4 ] = %run_2_stand_90L;
anim.coverTrans[ "exposed" ][ 6 ] = %run_2_stand_90R;
anim.coverTrans[ "exposed" ][ 7 ] = %CQB_stop_7;
anim.coverTrans[ "exposed" ][ 8 ] = %run_2_stand_180L;
anim.coverTrans[ "exposed" ][ 9 ] = %CQB_stop_9;
anim.coverTrans[ "exposed_crouch" ] = [];
anim.coverTrans[ "exposed_crouch" ][ 1 ] = %CQB_crouch_stop_1;
anim.coverTrans[ "exposed_crouch" ][ 2 ] = %run_2_crouch_F;
anim.coverTrans[ "exposed_crouch" ][ 3 ] = %CQB_crouch_stop_3;
anim.coverTrans[ "exposed_crouch" ][ 4 ] = %run_2_crouch_90L;
anim.coverTrans[ "exposed_crouch" ][ 6 ] = %run_2_crouch_90R;
anim.coverTrans[ "exposed_crouch" ][ 7 ] = %CQB_crouch_stop_7;
anim.coverTrans[ "exposed_crouch" ][ 8 ] = %run_2_crouch_180L;
anim.coverTrans[ "exposed_crouch" ][ 9 ] = %CQB_crouch_stop_9;
anim.coverTrans[ "exposed_cqb" ] = [];
anim.coverTrans[ "exposed_cqb" ][ 1 ] = %CQB_stop_1;
anim.coverTrans[ "exposed_cqb" ][ 2 ] = %CQB_stop_2;
anim.coverTrans[ "exposed_cqb" ][ 3 ] = %CQB_stop_3;
anim.coverTrans[ "exposed_cqb" ][ 4 ] = %CQB_stop_4;
anim.coverTrans[ "exposed_cqb" ][ 6 ] = %CQB_stop_6;
anim.coverTrans[ "exposed_cqb" ][ 7 ] = %CQB_stop_7;
anim.coverTrans[ "exposed_cqb" ][ 8 ] = %CQB_stop_8;
anim.coverTrans[ "exposed_cqb" ][ 9 ] = %CQB_stop_9;
anim.coverTrans[ "exposed_crouch_cqb" ] = [];
anim.coverTrans[ "exposed_crouch_cqb" ][ 1 ] = %CQB_crouch_stop_1;
anim.coverTrans[ "exposed_crouch_cqb" ][ 2 ] = %CQB_crouch_stop_2;
anim.coverTrans[ "exposed_crouch_cqb" ][ 3 ] = %CQB_crouch_stop_3;
anim.coverTrans[ "exposed_crouch_cqb" ][ 4 ] = %CQB_crouch_stop_4;
anim.coverTrans[ "exposed_crouch_cqb" ][ 6 ] = %CQB_crouch_stop_6;
anim.coverTrans[ "exposed_crouch_cqb" ][ 7 ] = %CQB_crouch_stop_7;
anim.coverTrans[ "exposed_crouch_cqb" ][ 8 ] = %CQB_crouch_stop_8;
anim.coverTrans[ "exposed_crouch_cqb" ][ 9 ] = %CQB_crouch_stop_9;
anim.coverTrans[ "heat" ] = [];
anim.coverTrans[ "heat" ][ 1 ] = %heat_approach_1;
anim.coverTrans[ "heat" ][ 2 ] = %heat_approach_2;
anim.coverTrans[ "heat" ][ 3 ] = %heat_approach_3;
anim.coverTrans[ "heat" ][ 4 ] = %heat_approach_4;
anim.coverTrans[ "heat" ][ 6 ] = %heat_approach_6;
anim.coverTrans[ "heat" ][ 8 ] = %heat_approach_8;
anim.coverTrans[ "heat_left" ] = [];
anim.coverTrans[ "heat_right" ] = [];
anim.coverStepInAnim = [];
anim.coverStepInAnim[ "right" ] = %corner_standR_trans_B_2_alert;
anim.coverStepInAnim[ "right_crouch" ] = %CornerCrR_trans_B_2_alert;
anim.coverStepInAnim[ "left" ] = %corner_standL_trans_B_2_alert_v2;
anim.coverStepInAnim[ "left_crouch" ] = %CornerCrL_trans_B_2_alert;
anim.coverStepInAnim[ "crouch" ] = %covercrouch_aim_2_hide;
anim.coverStepInAnim[ "stand" ] = %coverstand_aim_2_hide;
anim.coverStepInOffsets = [];
anim.coverStepInAngles = [];
for( i = 0; i < lastCoverTrans; i++ )
{
trans = transTypes[i];
anim.coverStepInOffsets[ trans ] = getMoveDelta( anim.coverStepInAnim[ trans ], 0, 1 );
anim.coverStepInAngles[ trans ] = getAngleDelta( anim.coverStepInAnim[ trans ], 0, 1 );
}
anim.coverStepInAngles[ "right" ] += 90;
anim.coverStepInAngles[ "right_crouch" ] += 90;
anim.coverStepInAngles[ "left" ] -= 90;
anim.coverStepInAngles[ "left_crouch" ] -= 90;
anim.coverTrans[ "wall_over_96" ][ 1 ] = %traverse90_IN_ML;
anim.coverTrans[ "wall_over_96" ][ 2 ] = %traverse90_IN_M;
anim.coverTrans[ "wall_over_96" ][ 3 ] = %traverse90_IN_MR;
anim.traverseInfo[ "wall_over_96" ][ "height" ] = 96;
anim.coverTrans[ "wall_over_40" ][ 1 ] = %traverse_window_M_2_run;
anim.coverTrans[ "wall_over_40" ][ 2 ] = %traverse_window_M_2_run;
anim.coverTrans[ "wall_over_40" ][ 3 ] = %traverse_window_M_2_run;
anim.coverExit[ "right" ][ 1 ] = %corner_standR_trans_OUT_1;
anim.coverExit[ "right" ][ 2 ] = %corner_standR_trans_OUT_2;
anim.coverExit[ "right" ][ 3 ] = %corner_standR_trans_OUT_3;
anim.coverExit[ "right" ][ 4 ] = %corner_standR_trans_OUT_4;
anim.coverExit[ "right" ][ 6 ] = %corner_standR_trans_OUT_6;
anim.coverExit[ "right" ][ 8 ] = %corner_standR_trans_OUT_8;
anim.coverExit[ "right" ][ 9 ] = %corner_standR_trans_OUT_9;
anim.coverExit[ "right_crouch" ][ 1 ] = %CornerCrR_trans_OUT_ML;
anim.coverExit[ "right_crouch" ][ 2 ] = %CornerCrR_trans_OUT_M;
anim.coverExit[ "right_crouch" ][ 3 ] = %CornerCrR_trans_OUT_MR;
anim.coverExit[ "right_crouch" ][ 4 ] = %CornerCrR_trans_OUT_L;
anim.coverExit[ "right_crouch" ][ 6 ] = %CornerCrR_trans_OUT_R;
anim.coverExit[ "right_crouch" ][ 8 ] = %CornerCrR_trans_OUT_F;
anim.coverExit[ "right_crouch" ][ 9 ] = %CornerCrR_trans_OUT_MF;
anim.coverExit[ "right_cqb" ][ 1 ] = %corner_standR_trans_CQB_OUT_1;
anim.coverExit[ "right_cqb" ][ 2 ] = %corner_standR_trans_CQB_OUT_2;
anim.coverExit[ "right_cqb" ][ 3 ] = %corner_standR_trans_CQB_OUT_3;
anim.coverExit[ "right_cqb" ][ 4 ] = %corner_standR_trans_CQB_OUT_4;
anim.coverExit[ "right_cqb" ][ 6 ] = %corner_standR_trans_CQB_OUT_6;
anim.coverExit[ "right_cqb" ][ 8 ] = %corner_standR_trans_CQB_OUT_8;
anim.coverExit[ "right_cqb" ][ 9 ] = %corner_standR_trans_CQB_OUT_9;
anim.coverExit[ "right_crouch_cqb" ][ 1 ] = %CornerCrR_CQB_trans_OUT_1;
anim.coverExit[ "right_crouch_cqb" ][ 2 ] = %CornerCrR_CQB_trans_OUT_2;
anim.coverExit[ "right_crouch_cqb" ][ 3 ] = %CornerCrR_CQB_trans_OUT_3;
anim.coverExit[ "right_crouch_cqb" ][ 4 ] = %CornerCrR_CQB_trans_OUT_4;
anim.coverExit[ "right_crouch_cqb" ][ 6 ] = %CornerCrR_CQB_trans_OUT_6;
anim.coverExit[ "right_crouch_cqb" ][ 8 ] = %CornerCrR_CQB_trans_OUT_8;
anim.coverExit[ "right_crouch_cqb" ][ 9 ] = %CornerCrR_CQB_trans_OUT_9;
anim.coverExit[ "left" ][ 1 ] = %corner_standL_trans_OUT_1;
anim.coverExit[ "left" ][ 2 ] = %corner_standL_trans_OUT_2;
anim.coverExit[ "left" ][ 3 ] = %corner_standL_trans_OUT_3;
anim.coverExit[ "left" ][ 4 ] = %corner_standL_trans_OUT_4;
anim.coverExit[ "left" ][ 6 ] = %corner_standL_trans_OUT_6;
anim.coverExit[ "left" ][ 7 ] = %corner_standL_trans_OUT_7;
anim.coverExit[ "left" ][ 8 ] = %corner_standL_trans_OUT_8;
anim.coverExit[ "left_crouch" ][ 1 ] = %CornerCrL_trans_OUT_ML;
anim.coverExit[ "left_crouch" ][ 2 ] = %CornerCrL_trans_OUT_M;
anim.coverExit[ "left_crouch" ][ 3 ] = %CornerCrL_trans_OUT_MR;
anim.coverExit[ "left_crouch" ][ 4 ] = %CornerCrL_trans_OUT_L;
anim.coverExit[ "left_crouch" ][ 6 ] = %CornerCrL_trans_OUT_R;
anim.coverExit[ "left_crouch" ][ 7 ] = %CornerCrL_trans_OUT_MF;
anim.coverExit[ "left_crouch" ][ 8 ] = %CornerCrL_trans_OUT_F;
anim.coverExit[ "left_cqb" ][ 1 ] = %corner_standL_trans_CQB_OUT_1;
anim.coverExit[ "left_cqb" ][ 2 ] = %corner_standL_trans_CQB_OUT_2;
anim.coverExit[ "left_cqb" ][ 3 ] = %corner_standL_trans_CQB_OUT_3;
anim.coverExit[ "left_cqb" ][ 4 ] = %corner_standL_trans_CQB_OUT_4;
anim.coverExit[ "left_cqb" ][ 6 ] = %corner_standL_trans_CQB_OUT_6;
anim.coverExit[ "left_cqb" ][ 7 ] = %corner_standL_trans_CQB_OUT_7;
anim.coverExit[ "left_cqb" ][ 8 ] = %corner_standL_trans_CQB_OUT_8;
anim.coverExit[ "left_crouch_cqb" ][ 1 ] = %CornerCrL_CQB_trans_OUT_1;
anim.coverExit[ "left_crouch_cqb" ][ 2 ] = %CornerCrL_CQB_trans_OUT_2;
anim.coverExit[ "left_crouch_cqb" ][ 3 ] = %CornerCrL_CQB_trans_OUT_3;
anim.coverExit[ "left_crouch_cqb" ][ 4 ] = %CornerCrL_CQB_trans_OUT_4;
anim.coverExit[ "left_crouch_cqb" ][ 6 ] = %CornerCrL_CQB_trans_OUT_6;
anim.coverExit[ "left_crouch_cqb" ][ 7 ] = %CornerCrL_CQB_trans_OUT_7;
anim.coverExit[ "left_crouch_cqb" ][ 8 ] = %CornerCrL_CQB_trans_OUT_8;
anim.coverExit[ "crouch" ][ 1 ] = %covercrouch_run_out_ML;
anim.coverExit[ "crouch" ][ 2 ] = %covercrouch_run_out_M;
anim.coverExit[ "crouch" ][ 3 ] = %covercrouch_run_out_MR;
anim.coverExit[ "crouch" ][ 4 ] = %covercrouch_run_out_L;
anim.coverExit[ "crouch" ][ 6 ] = %covercrouch_run_out_R;
anim.coverExit[ "stand" ][ 1 ] = %coverstand_trans_OUT_ML;
anim.coverExit[ "stand" ][ 2 ] = %coverstand_trans_OUT_M;
anim.coverExit[ "stand" ][ 3 ] = %coverstand_trans_OUT_MR;
anim.coverExit[ "stand" ][ 4 ] = %coverstand_trans_OUT_L;
anim.coverExit[ "stand" ][ 6 ] = %coverstand_trans_OUT_R;
anim.coverExit[ "stand_saw" ][ 1 ] = %saw_gunner_runout_ML;
anim.coverExit[ "stand_saw" ][ 2 ] = %saw_gunner_runout_M;
anim.coverExit[ "stand_saw" ][ 3 ] = %saw_gunner_runout_MR;
anim.coverExit[ "stand_saw" ][ 4 ] = %saw_gunner_runout_L;
anim.coverExit[ "stand_saw" ][ 6 ] = %saw_gunner_runout_R;
anim.coverExit[ "prone_saw" ][ 2 ] = %saw_gunner_prone_runout_M;
anim.coverExit[ "prone_saw" ][ 4 ] = %saw_gunner_prone_runout_L;
anim.coverExit[ "prone_saw" ][ 6 ] = %saw_gunner_prone_runout_R;
anim.coverExit[ "prone_saw" ][ 8 ] = %saw_gunner_prone_runout_F;
anim.coverExit[ "crouch_saw" ][ 1 ] = %saw_gunner_lowwall_runout_ML;
anim.coverExit[ "crouch_saw" ][ 2 ] = %saw_gunner_lowwall_runout_M;
anim.coverExit[ "crouch_saw" ][ 3 ] = %saw_gunner_lowwall_runout_MR;
anim.coverExit[ "crouch_saw" ][ 4 ] = %saw_gunner_lowwall_runout_L;
anim.coverExit[ "crouch_saw" ][ 6 ] = %saw_gunner_lowwall_runout_R;
anim.coverExit[ "exposed" ] = [];
anim.coverExit[ "exposed" ][ 1 ] = %CQB_start_1;
anim.coverExit[ "exposed" ][ 2 ] = %stand_2_run_180L;
anim.coverExit[ "exposed" ][ 3 ] = %CQB_start_3;
anim.coverExit[ "exposed" ][ 4 ] = %stand_2_run_L;
anim.coverExit[ "exposed" ][ 6 ] = %stand_2_run_R;
anim.coverExit[ "exposed" ][ 7 ] = %CQB_start_7;
anim.coverExit[ "exposed" ][ 8 ] = %surprise_start_v1;
anim.coverExit[ "exposed" ][ 9 ] = %CQB_start_9;
anim.coverExit[ "exposed_crouch" ] = [];
anim.coverExit[ "exposed_crouch" ][ 1 ] = %CQB_crouch_start_1;
anim.coverExit[ "exposed_crouch" ][ 2 ] = %crouch_2run_180;
anim.coverExit[ "exposed_crouch" ][ 3 ] = %CQB_crouch_start_3;
anim.coverExit[ "exposed_crouch" ][ 4 ] = %crouch_2run_L;
anim.coverExit[ "exposed_crouch" ][ 6 ] = %crouch_2run_R;
anim.coverExit[ "exposed_crouch" ][ 7 ] = %CQB_crouch_start_7;
anim.coverExit[ "exposed_crouch" ][ 8 ] = %crouch_2run_F;
anim.coverExit[ "exposed_crouch" ][ 9 ] = %CQB_crouch_start_9;
anim.coverExit[ "exposed_cqb" ] = [];
anim.coverExit[ "exposed_cqb" ][ 1 ] = %CQB_start_1;
anim.coverExit[ "exposed_cqb" ][ 2 ] = %CQB_start_2;
anim.coverExit[ "exposed_cqb" ][ 3 ] = %CQB_start_3;
anim.coverExit[ "exposed_cqb" ][ 4 ] = %CQB_start_4;
anim.coverExit[ "exposed_cqb" ][ 6 ] = %CQB_start_6;
anim.coverExit[ "exposed_cqb" ][ 7 ] = %CQB_start_7;
anim.coverExit[ "exposed_cqb" ][ 8 ] = %CQB_start_8;
anim.coverExit[ "exposed_cqb" ][ 9 ] = %CQB_start_9;
anim.coverExit[ "exposed_crouch_cqb" ] = [];
anim.coverExit[ "exposed_crouch_cqb" ][ 1 ] = %CQB_crouch_start_1;
anim.coverExit[ "exposed_crouch_cqb" ][ 2 ] = %CQB_crouch_start_2;
anim.coverExit[ "exposed_crouch_cqb" ][ 3 ] = %CQB_crouch_start_3;
anim.coverExit[ "exposed_crouch_cqb" ][ 4 ] = %CQB_crouch_start_4;
anim.coverExit[ "exposed_crouch_cqb" ][ 6 ] = %CQB_crouch_start_6;
anim.coverExit[ "exposed_crouch_cqb" ][ 7 ] = %CQB_crouch_start_7;
anim.coverExit[ "exposed_crouch_cqb" ][ 8 ] = %CQB_crouch_start_8;
anim.coverExit[ "exposed_crouch_cqb" ][ 9 ] = %CQB_crouch_start_9;
anim.coverExit[ "heat" ] = [];
anim.coverExit[ "heat" ][ 1 ] = %heat_exit_1;
anim.coverExit[ "heat" ][ 2 ] = %heat_exit_2;
anim.coverExit[ "heat" ][ 3 ] = %heat_exit_3;
anim.coverExit[ "heat" ][ 4 ] = %heat_exit_4;
anim.coverExit[ "heat" ][ 6 ] = %heat_exit_6;
anim.coverExit[ "heat" ][ 7 ] = %heat_exit_7;
anim.coverExit[ "heat" ][ 8 ] = %heat_exit_8;
anim.coverExit[ "heat" ][ 9 ] = %heat_exit_9;
anim.coverExit[ "heat_left" ] = [];
anim.coverExit[ "heat_left" ][ 1 ] = %heat_exit_1;
anim.coverExit[ "heat_left" ][ 2 ] = %heat_exit_2;
anim.coverExit[ "heat_left" ][ 3 ] = %heat_exit_3;
anim.coverExit[ "heat_left" ][ 4 ] = %heat_exit_4;
anim.coverExit[ "heat_left" ][ 6 ] = %heat_exit_6;
anim.coverExit[ "heat_left" ][ 7 ] = %heat_exit_8L;
anim.coverExit[ "heat_left" ][ 8 ] = %heat_exit_8L;
anim.coverExit[ "heat_left" ][ 9 ] = %heat_exit_8R;
anim.coverExit[ "heat_right" ] = [];
anim.coverExit[ "heat_right" ][ 1 ] = %heat_exit_1;
anim.coverExit[ "heat_right" ][ 2 ] = %heat_exit_2;
anim.coverExit[ "heat_right" ][ 3 ] = %heat_exit_3;
anim.coverExit[ "heat_right" ][ 4 ] = %heat_exit_4;
anim.coverExit[ "heat_right" ][ 6 ] = %heat_exit_6;
anim.coverExit[ "heat_right" ][ 7 ] = %heat_exit_8L;
anim.coverExit[ "heat_right" ][ 8 ] = %heat_exit_8R;
anim.coverExit[ "heat_right" ][ 9 ] = %heat_exit_8R;
for ( i = 1; i <= 6; i++ )
{
if ( i == 5 )
continue;
for ( j = 0; j < transTypes.size; j++ )
{
trans = transTypes[ j ];
if ( isdefined( anim.coverTrans[ trans ] ) && isdefined( anim.coverTrans[ trans ][ i ] ) )
{
anim.coverTransDist [ trans ][ i ] = getMoveDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
anim.coverTransAngles[ trans ][ i ] = getAngleDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
}
if ( isdefined( anim.coverExit [ trans ] ) && isdefined( anim.coverExit [ trans ][ i ] ) )
{
if ( animHasNotetrack( anim.coverExit[ trans ][ i ], "code_move" ) )
codeMoveTime = getNotetrackTimes( anim.coverExit[ trans ][ i ], "code_move" )[ 0 ];
else
codeMoveTime = 1;
anim.coverExitDist [ trans ][ i ] = getMoveDelta( anim.coverExit [ trans ][ i ], 0, codeMoveTime );
anim.coverExitAngles [ trans ][ i ] = getAngleDelta( anim.coverExit [ trans ][ i ], 0, 1 );
}
}
}
for ( j = 0; j < transTypes.size; j++ )
{
trans = transTypes[ j ];
anim.coverTransLongestDist[ trans ] = 0;
for ( i = 1; i <= 6; i++ )
{
if ( i == 5 || !isdefined( anim.coverTrans[ trans ]) || !isdefined( anim.coverTrans[ trans ][ i ] ) )
continue;
lengthSq = lengthSquared( anim.coverTransDist[ trans ][ i ] );
if ( anim.coverTransLongestDist[ trans ] < lengthSq )
anim.coverTransLongestDist[ trans ] = lengthSq;
}
anim.coverTransLongestDist[ trans ] = sqrt( anim.coverTransLongestDist[ trans ] );
}
anim.exposedTransition[ "exposed" ] = true;
anim.exposedTransition[ "exposed_crouch" ] = true;
anim.exposedTransition[ "exposed_cqb" ] = true;
anim.exposedTransition[ "exposed_crouch_cqb" ] = true;
anim.exposedTransition[ "exposed_ready_cqb" ] = true;
anim.exposedTransition[ "exposed_ready" ] = true;
anim.exposedTransition[ "heat" ] = true;
if ( !isdefined( anim.longestExposedApproachDist ) )
anim.longestExposedApproachDist = 0;
foreach ( trans, transType in anim.exposedTransition )
{
for ( i = 7; i <= 9; i++ )
{
if ( isdefined( anim.coverTrans[ trans ]) && isdefined( anim.coverTrans[ trans ][ i ] ) )
{
anim.coverTransDist [ trans ][ i ] = getMoveDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
anim.coverTransAngles[ trans ][ i ] = getAngleDelta( anim.coverTrans[ trans ][ i ], 0, 1 );
}
if ( isdefined( anim.coverExit[ trans ]) && isdefined( anim.coverExit [ trans ][ i ] ) )
{
codeMoveTime = getNotetrackTimes( anim.coverExit[ trans ][ i ], "code_move" )[ 0 ];
if( isdefined( codeMoveTime ) )
{
anim.coverExitDist [ trans ][ i ] = getMoveDelta( anim.coverExit [ trans ][ i ], 0, codeMoveTime );
anim.coverExitAngles [ trans ][ i ] = getAngleDelta( anim.coverExit [ trans ][ i ], 0, 1 );
}
else
{
println("^3XANIM OPTIMIZATION WARNING: Missing anim anim.coverExit[ " + trans + " ][ " + i + " ], this may need to be added to your level csv");
}
}
}
for ( i = 1; i <= 9; i++ )
{
if ( !isdefined( anim.coverTrans[ trans ]) || !isdefined( anim.coverTrans[ trans ][ i ] ) )
continue;
len = length( anim.coverTransDist[ trans ][ i ] );
if ( len > anim.longestExposedApproachDist )
anim.longestExposedApproachDist = len;
}
}
anim.coverTransSplit[ "left" ][ 7 ] = 0.369369;
anim.coverTransSplit[ "left_crouch" ][ 7 ] = 0.319319;
anim.coverTransSplit[ "left_cqb" ][ 7 ] = 0.451451;
anim.coverTransSplit[ "left_crouch_cqb" ][ 7 ] = 0.246246;
anim.coverExitSplit[ "left" ][ 7 ] = 0.547548;
anim.coverExitSplit[ "left_crouch" ][ 7 ] = 0.593594;
anim.coverExitSplit[ "left_cqb" ][ 7 ] = 0.702703;
anim.coverExitSplit[ "left_crouch_cqb" ][ 7 ] = 0.718719;
anim.coverExitSplit[ "heat_left" ][ 7 ] = 0.42;
anim.coverTransSplit[ "left" ][ 8 ] = 0.525526;
anim.coverTransSplit[ "left_crouch" ][ 8 ] = 0.428428;
anim.coverTransSplit[ "left_cqb" ][ 8 ] = 0.431431;
anim.coverTransSplit[ "left_crouch_cqb" ][ 8 ] = 0.33033;
anim.coverExitSplit[ "left" ][ 8 ] = 0.614615;
anim.coverExitSplit[ "left_crouch" ][ 8 ] = 0.451451;
anim.coverExitSplit[ "left_cqb" ][ 8 ] = 0.451451;
anim.coverExitSplit[ "left_crouch_cqb" ][ 8 ] = 0.603604;
anim.coverExitSplit[ "heat_left" ][ 8 ] = 0.42;
anim.coverTransSplit[ "right" ][ 8 ] = 0.458458;
anim.coverTransSplit[ "right_crouch" ][ 8 ] = 0.248248;
anim.coverTransSplit[ "right_cqb" ][ 8 ] = 0.458458;
anim.coverTransSplit[ "right_crouch_cqb" ][ 8 ] = 0.311311;
anim.coverExitSplit[ "right" ][ 8 ] = 0.457457;
anim.coverExitSplit[ "right_crouch" ][ 8 ] = 0.545546;
anim.coverExitSplit[ "right_cqb" ][ 8 ] = 0.540541;
anim.coverExitSplit[ "right_crouch_cqb" ][ 8 ] = 0.399399;
anim.coverExitSplit[ "heat_right" ][ 8 ] = 0.4;
anim.coverTransSplit[ "right" ][ 9 ] = 0.546547;
anim.coverTransSplit[ "right_crouch" ][ 9 ] = 0.2002;
anim.coverTransSplit[ "right_cqb" ][ 9 ] = 0.546547;
anim.coverTransSplit[ "right_crouch_cqb" ][ 9 ] = 0.232232;
anim.coverExitSplit[ "right" ][ 9 ] = 0.483483;
anim.coverExitSplit[ "right_crouch" ][ 9 ] = 0.493493;
anim.coverExitSplit[ "right_cqb" ][ 9 ] = 0.565566;
anim.coverExitSplit[ "right_crouch_cqb" ][ 9 ] = 0.518519;
anim.coverExitSplit[ "heat_right" ][ 9 ] = 0.4;
splitArrivals = [];
splitArrivals[ "left" ] = 1;
splitArrivals[ "left_crouch" ] = 1;
splitArrivals[ "left_crouch_cqb" ] = 1;
splitArrivals[ "left_cqb" ] = 1;
splitExits = [];
splitExits[ "left" ] = 1;
splitExits[ "left_crouch" ] = 1;
splitExits[ "left_crouch_cqb" ] = 1;
splitExits[ "left_cqb" ] = 1;
splitExits[ "heat_left" ] = 1;
GetSplitTimes( 7, 8, false, splitArrivals, splitExits );
splitArrivals = [];
splitArrivals[ "right" ] = 1;
splitArrivals[ "right_crouch" ] = 1;
splitArrivals[ "right_cqb" ] = 1;
splitArrivals[ "right_crouch_cqb" ] = 1;
splitExits = [];
splitExits[ "right" ] = 1;
splitExits[ "right_crouch" ] = 1;
splitExits[ "right_cqb" ] = 1;
splitExits[ "right_crouch_cqb" ] = 1;
splitExits[ "heat_right" ] = 1;
GetSplitTimes( 8, 9, true, splitArrivals, splitExits );
anim.arrivalEndStance["left"] = "stand";
anim.arrivalEndStance["left_cqb"] = "stand";
anim.arrivalEndStance["right"] = "stand";
anim.arrivalEndStance["right_cqb"] = "stand";
anim.arrivalEndStance["stand"] = "stand";
anim.arrivalEndStance["stand_saw"] = "stand";
anim.arrivalEndStance["exposed"] = "stand";
anim.arrivalEndStance["exposed_cqb"]	= "stand";
anim.arrivalEndStance["heat"] = "stand";
anim.arrivalEndStance["left_crouch"]	= "crouch";
anim.arrivalEndStance["left_crouch_cqb"] = "crouch";
anim.arrivalEndStance["right_crouch"]	= "crouch";
anim.arrivalEndStance["right_crouch_cqb"] = "crouch";
anim.arrivalEndStance["crouch_saw"] = "crouch";
anim.arrivalEndStance["crouch"] = "crouch";
anim.arrivalEndStance["exposed_crouch"] = "crouch";
anim.arrivalEndStance["exposed_crouch_cqb"] = "crouch";
anim.arrivalEndStance["prone_saw"] = "prone";
anim.arrivalEndStance["exposed_ready"]	= "stand";
anim.arrivalEndStance["exposed_ready_cqb"]="stand";
anim.requiredExitStance[ "Cover Stand" ] = "stand";
anim.requiredExitStance[ "Conceal Stand" ] = "stand";
anim.requiredExitStance[ "Cover Crouch" ] = "crouch";
anim.requiredExitStance[ "Conceal Crouch" ] = "crouch";
}
GetSplitTimes( begin, end, isRightSide, splitArrivals, splitExits )
{
for ( i = begin; i <= end; i++ )
{
foreach ( type, val in splitArrivals )
{
anim.coverTransPreDist[ type ][ i ] = getMoveDelta( anim.coverTrans[ type ][ i ], 0, getTransSplitTime( type, i ) );
anim.coverTransDist [ type ][ i ] = getMoveDelta( anim.coverTrans[ type ][ i ], 0, 1 ) - anim.coverTransPreDist[ type ][ i ];
anim.coverTransAngles [ type ][ i ] = getAngleDelta( anim.coverTrans[ type ][ i ], 0, 1 );
}
foreach ( type, val in splitExits )
{
anim.coverExitDist [ type ][ i ] = getMoveDelta( anim.coverExit [ type ][ i ], 0, getExitSplitTime( type, i ) );
anim.coverExitPostDist[ type ][ i ] = getMoveDelta( anim.coverExit [ type ][ i ], 0, 1 ) - anim.coverExitDist[ type ][ i ];
anim.coverExitAngles [ type ][ i ] = getAngleDelta( anim.coverExit [ type ][ i ], 0, 1 );
}
}
}
getExitSplitTime( approachType, dir )
{
return anim.coverExitSplit[ approachType ][ dir ];
}
getTransSplitTime( approachType, dir )
{
return anim.coverTransSplit[ approachType ][ dir ];
}
