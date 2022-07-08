#include maps\_utility;
#include common_scripts\utility;
emptyMissionDifficultyStr = "00000000000000000000000000000000000000000000000000";
SOTABLE_COL_INDEX = 0;
SOTABLE_COL_REF = 1;
SOTABLE_COL_NAME = 2;
SOTABLE_COL_GROUP = 13;
SOTABLE_COL_UNLOCK = 5;
main()
{
missionSettings = [];
missionSettings = createMission( "THE_BEST_OF_THE_BEST" );
missionSettings addLevel( "prologue", false, "BACK_IN_THE_FIGHT", true,	"THE_BIG_APPLE", undefined, 0 );
missionSettings addLevel( "ny_manhattan_a", true, undefined, true,	"THE_BIG_APPLE", undefined, -1 );
missionSettings addLevel( "ny_manhattan_b", false, "TOO_BIG_TO_FAIL", true,	"THE_BIG_APPLE", undefined, 1 );
missionSettings addLevel( "ny_harbor", false, "WET_WORK", true,	"THE_BIG_APPLE", undefined, 2 );
missionSettings addLevel( "intro", false, "CARPE_DIEM", true,	"OUT_OF_THE_FRYING_PAN",	undefined, 3 );
missionSettings addLevel( "hijack", false, "FREQUENT_FLIER", true,	"OUT_OF_THE_FRYING_PAN",	undefined, 4 );
missionSettings addLevel( "warlord_a", true, undefined, true,	"OUT_OF_THE_FRYING_PAN", undefined, -1 );
missionSettings addLevel( "warlord_b", false, "UP_TO_NO_GOOD", true,	"OUT_OF_THE_FRYING_PAN", undefined, 5 );
missionSettings addLevel( "london", true, undefined, true,	"EUROPEAN_VACATION", 1, 6 );
missionSettings addLevel( "innocent", false, "ONE_WAY_TICKET", true,	"EUROPEAN_VACATION", 0.1, 7 );
missionSettings addLevel( "hamburg_a", true, undefined, true,	"EUROPEAN_VACATION", undefined, -1 );
missionSettings addLevel( "hamburg_b", false, "WELCOME_TO_WW3", true,	"EUROPEAN_VACATION", undefined, 8 );
missionSettings addLevel( "payback_a", true, "SANDSTORM", true,	"EUROPEAN_VACATION", undefined, -1 );
missionSettings addLevel( "payback_a2", true, "SANDSTORM", true,	"EUROPEAN_VACATION", undefined, -1 );
missionSettings addLevel( "payback_b", false, "SANDSTORM", true,	"EUROPEAN_VACATION", undefined, 9 );
missionSettings addLevel( "paris_a", true, undefined, true,	"CITY_OF_LIGHTS", undefined, 10 );
missionSettings addLevel( "paris_b", false, "BACK_SEAT_DRIVER", true,	"CITY_OF_LIGHTS", undefined, 11 );
missionSettings addLevel( "paris_ac130_a", true, undefined, true,	"CITY_OF_LIGHTS", undefined, -1 );
missionSettings addLevel( "paris_ac130_b", false, "WELL_ALWAYS_HAVE_PARIS",	true,	"CITY_OF_LIGHTS", undefined, 12 );
missionSettings addLevel( "prague", false, "VIVE_LA_REVOLUTION", true,	"THE_DARKEST_HOUR", undefined, 13 );
missionSettings addLevel( "prague_escape", false, undefined, true,	"THE_DARKEST_HOUR", undefined, -1 );
missionSettings addLevel( "prague_escape_end", false, "REQUIEM", true,	"THE_DARKEST_HOUR", undefined, 14 );
missionSettings addLevel( "castle", false, "STORM_THE_CASTLE", true,	"THE_DARKEST_HOUR", undefined, 15 );
missionSettings addLevel( "berlin_a", true, undefined, true,	"THIS_IS_THE_END", undefined, -1 );
missionSettings addLevel( "berlin_b", false, "BAD_FIRST_DATE", true,	"THIS_IS_THE_END", undefined, 16 );
missionSettings addLevel( "rescue_2", false, "DIAMOND_IN_THE_ROUGH", true,	"THIS_IS_THE_END", undefined, 17 );
missionSettings addLevel( "dubai", false, "WHO_DARES_WINS", true,	"THIS_IS_THE_END", undefined, 18 );
if( is_specialop() )
{
level.specOpsGroups = [];
for( i=0; i<100; i++ )
{
ref = tablelookup( "sp/specopstable.csv", SOTABLE_COL_INDEX, i, SOTABLE_COL_REF );
if ( ref != "" )
setupSoGroup( ref );
else
break;
}
specOpsSettings = createMission( "SPECIAL_OPS" );
release_survival_number = int( tablelookup( "sp/specopstable.csv", 0, "survival_count", 1 ) );
for( i=100; i<200; i++ )
{
internal_index = i - 100;
ref = tablelookup( "sp/specopstable.csv", SOTABLE_COL_INDEX, i, SOTABLE_COL_REF );
if ( ref != "" )
specOpsSettings addSpecOpLevel( ref, internal_index );
else
break;
}
for( i=200; i<300; i++ )
{
internal_index = i - 200 + release_survival_number;
ref = tablelookup( "sp/specopstable.csv", SOTABLE_COL_INDEX, i, SOTABLE_COL_REF );
if ( ref != "" )
specOpsSettings addSpecOpLevel( ref, internal_index );
else
break;
}
level.specOpsSettings = specOpsSettings;
}
level.missionSettings = missionSettings;
}
debug_test_next_mission()
{
wait( 10 );
while ( GetDvarInt( "test_next_mission" ) < 1 )
{
wait( 3 );
}
_nextmission();
}
setupSoGroup( so_ref )
{
level.specOpsGroups[ so_ref ] = spawnStruct();
level.specOpsGroups[ so_ref ].ref = so_ref;
level.specOpsGroups[ so_ref ].unlock = int( tablelookup( "sp/specopstable.csv", SOTABLE_COL_REF, so_ref, SOTABLE_COL_UNLOCK ) );
}
_nextmission()
{
if ( is_demo() )
{
SetSavedDvar( "ui_nextMission", "0" );
if ( IsDefined( level.nextmission_exit_time ) )
{
ChangeLevel( "", false, level.nextmission_exit_time );
}
else
{
ChangeLevel( "", false );
}
return;
}
level notify( "nextmission" );
level.nextmission = true;
level.player enableinvulnerability();
levelIndex = undefined;
setsaveddvar( "ui_nextMission", "1" );
setdvar( "ui_showPopup", "0" );
setdvar( "ui_popupString", "" );
SetDvar( "ui_prev_map", level.script );
if ( level.script == "london" )
{
game[ "previous_map" ] = "london";
}
else
{
game[ "previous_map" ] = undefined;
}
levelIndex = level.missionSettings getLevelIndex( level.script );
if ( level.script == "intro" && !getdvarint( "prologue_select" ) )
{
assert(levelIndex >= 0 && levelIndex < level.missionSettings.levels.size );
for ( i = levelIndex + 1; i < level.missionSettings.levels.size-1; i++ )
{
if ( level.missionSettings.levels[i].name == "intro" )
{
levelIndex = i;
break;
}
}
}
setdvar( "prologue_select", "0" );
maps\_gameskill::auto_adust_zone_complete( "aa_main_" + level.script );
if ( !isDefined( levelIndex ) )
{
MissionSuccess( level.script );
return;
}
if ( level.script != "dubai" )
maps\_utility::level_end_save();
finishLevelIndex = level.missionSettings getLevelCompletedIndex(levelIndex);
if ( finishLevelIndex >= 0 )
level.missionSettings setLevelCompleted( finishLevelIndex );
if ( (level.player GetLocalPlayerProfileData( "highestMission" )) < levelindex + 1 && ( level.script == "dubai" ) && getdvarint( "mis_cheat" ) == 0 )
{
setdvar( "ui_sp_unlock", "0" );
setdvar( "ui_sp_unlock", "1" );
}
completion_percentage = updateSpPercent();
UpdateGamerProfile();
if ( level.missionSettings hasAchievement( levelIndex ) )
maps\_utility::giveachievement_wrapper( level.missionSettings getAchievement( levelIndex ) );
if ( level.missionSettings hasLevelVeteranAward( levelIndex ) && getLevelCompleted( levelIndex ) == 4
&& level.missionSettings check_other_hasLevelVeteranAchievement( levelIndex ) )
maps\_utility::giveachievement_wrapper( level.missionSettings getLevelVeteranAward( levelIndex ) );
if ( level.missionSettings hasMissionHardenedAward() &&
level.missionSettings getLowestSkill() > 2 )
giveachievement_wrapper( level.missionSettings getHardenedAward() );
if ( level.script == "dubai" )
return;
nextLevelIndex = levelIndex + 1;
Assert(nextLevelIndex < level.missionSettings.levels.size);
if ( arcadeMode() )
{
if ( !getdvarint( "arcademode_full" ) )
{
SetSavedDvar( "ui_nextMission", "0" );
missionSuccess( level.script );
return;
}
}
nextLevelName = level.missionSettings getLevelName( nextLevelIndex );
if ( using_wii() && GetSubStr( nextLevelName, 0, 3 ) == "sp_" )
{
nextLevelName = GetSubStr( nextLevelName, 3 );
}
if ( level.missionSettings skipssuccess( levelIndex ) )
{
if ( IsDefined( level.missionsettings getfadetime( levelIndex ) ) )
{
ChangeLevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ), level.missionsettings getfadetime( levelIndex ) );
}
else
{
ChangeLevel( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
}
}
else
{
MissionSuccess( level.missionSettings getLevelName( nextLevelIndex ), level.missionSettings getKeepWeapons( levelIndex ) );
}
}
updateSpPercent()
{
completion_percentage = int( getTotalpercentCompleteSP()*100 );
if( getdvarint( "mis_cheat" ) == 0 )
{
assertex( ( completion_percentage >= 0 && completion_percentage <= 10000 ), "SP's Completion percentage [ " + completion_percentage + "% ] is outside of 0 to 100 range!" );
level.player SetLocalPlayerProfileData( "percentCompleteSP", completion_percentage );
}
return completion_percentage;
}
getTotalpercentCompleteSP()
{
stat_progression = max( getStat_easy(), getStat_regular() );
stat_progression_ratio = 0.5/1;
stat_hardened = getStat_hardened();
stat_hardened_ratio = 0.25/1;
stat_veteran = getStat_veteran();
stat_veteran_ratio = 0.1/1;
stat_intel = getStat_intel();
stat_intel_ratio = 0.15/1;
assertex( ( stat_progression_ratio + stat_hardened_ratio + stat_veteran_ratio + stat_intel_ratio ) <= 1.0, "Total sum of SP progress breakdown contributes to more than 100%!" );
total_progress = 0.0;
total_progress += stat_progression_ratio*stat_progression;
total_progress += stat_hardened_ratio*stat_hardened;
total_progress += stat_veteran_ratio*stat_veteran;
total_progress += stat_intel_ratio*stat_intel;
assertex( total_progress <= 100.0, "Total Percentage calculation is out of bound, larger then 100%" );
return total_progress;
}
getStat_progression( difficulty )
{
assert( isdefined( level.missionSettings ) );
assert( isdefined( level.script ) );
difficulty_string = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
levels = 0;
notplayed = [];
skipped = false;
total_levels = 19;
for ( i = 0; i < total_levels; i++ )
{
if ( int( difficulty_string[ i ] ) >= difficulty )
levels++;
}
completion = ( levels/(total_levels) )*100;
return completion;
}
getStat_easy()
{
easy = 1;
return getStat_progression( easy );
}
getStat_regular()
{
regular = 2;
return getStat_progression( regular );
}
getStat_hardened()
{
hardened = 3;
return getStat_progression( hardened );
}
getStat_veteran()
{
veteran = 4;
return getStat_progression( veteran );
}
getStat_intel()
{
total_intel_items = 45;
intel_percentage = ( (level.player GetLocalPlayerProfileData( "cheatPoints" ) )/total_intel_items )*100;
return intel_percentage;
}
getLevelCompleted( levelIndex )
{
return int( (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ))[ levelIndex ] );
}
getSoLevelCompleted( levelIndex )
{
return int( (level.player GetLocalPlayerProfileData( "missionSOHighestDifficulty" ))[ levelIndex ] );
}
setSoLevelCompleted( levelIndex )
{
foreach( player in level.players )
{
if ( isdefined( player.eog_noreward ) && player.eog_noreward )
continue;
specOpsString = player GetLocalPlayerProfileData( "missionSOHighestDifficulty" );
if ( !isdefined( specOpsString ) )
continue;
if ( isdefined( player.award_no_stars ) )
continue;
pre_total_stars = 0;
for ( i = 0; i < specOpsString.size; i++ )
pre_total_stars += max( 0, int( specOpsString[ i ] ) - 1 );
if ( specOpsString.size == 0 )
specOpsString = emptyMissionDifficultyStr;
while( levelIndex >= specOpsString.size )
specOpsString += "0";
stars = 0;
if ( is_survival() )
{
stars = 0;
if (level.current_wave >= 20)
stars = 3;
else if (level.current_wave >= 10)
stars = 2;
else if (level.current_wave >= 5)
stars = 1;
}
else
{
assertex( isdefined( level.specops_reward_gameskill ), "Game skill not setup correctly for coop." );
stars = level.specops_reward_gameskill;
if ( isdefined( player.forcedGameSkill ) )
stars = player.forcedGameSkill;
}
if ( int( specOpsString[ levelIndex ] ) > stars )
continue;
newString = "";
for ( index = 0; index < specOpsString.size; index++ )
{
if ( index != levelIndex )
newString += specOpsString[ index ];
else
newString += stars + 1;
}
post_total_stars = 0;
for ( i = 0; i < newString.size; i++ )
post_total_stars += max( 0, int( newString[ i ] ) - 1 );
delta_total_stars = post_total_stars - pre_total_stars;
if ( delta_total_stars > 0 && !is_survival() )
{
player.eog_firststar = is_first_difficulty_star( newString );
player.eog_newstar = true;
player.eog_newstar_value = delta_total_stars;
foreach ( group in level.specOpsGroups )
{
if ( group.unlock == 0 )
continue;
if ( level.ps3 && isSplitscreen() && isdefined( level.player2 ) && player == level.player2 )
continue;
if ( pre_total_stars < group.unlock && post_total_stars >= group.unlock )
{
player.eog_unlock = true;
player.eog_unlock_value = group.ref;
}
}
if ( post_total_stars >= 48 )
{
player.eog_unlock = true;
player.eog_unlock_value = "so_completed";
music_stop( 1 );
}
}
if ( player maps\_specialops_code::can_save_to_profile() || ( isSplitscreen() && level.ps3 && isdefined( level.player2 ) && player == level.player2 ) )
player SetLocalPlayerProfileData( "missionSOHighestDifficulty", newString );
}
}
is_first_difficulty_star( specOpsString )
{
if ( !is_survival() )
{
if( int( tablelookup( "sp/specOpsTable.csv", 1, level.script, 14 ) ) == 0 )
return false;
}
release_survival_number = int( tablelookup( "sp/specopstable.csv", 0, "survival_count", 1 ) );
release_mission_number = int( tablelookup( "sp/specopstable.csv", 0, "mission_count", 1 ) );
release_total = release_survival_number + release_mission_number;
specOpsSum = 0;
if ( is_survival() )
{
for( i=0; i<release_survival_number; i++ )
specOpsSum += int( max ( 0, int( specOpsString[i] ) - 1 ) );
}
else
{
for( i=release_survival_number; i<release_total; i++ )
specOpsSum += int( max ( 0, int( specOpsString[i] ) - 1 ) );
}
return ( specOpsSum == 1 );
}
setLevelCompleted( levelIndex )
{
missionString = ( level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ) );
newString = "";
for ( index = 0; index < missionString.size; index++ )
{
if ( index != levelIndex )
{
newString += missionString[ index ];
}
else
{
if ( level.gameskill + 1 > int( missionString[ levelIndex ] ) )
newString += level.gameskill + 1;
else
newString += missionString[ index ];
}
}
finalString = "";
skip = false;
highest = 0;
for ( i = 0; i < newString.size; i++ )
{
if ( int( newString[ i ] ) == 0 || skip )
{
finalString += "0";
skip = true;
}
else
{
finalString += newString[ i ];
highest++;
}
}
_setHighestMissionIfNotCheating( highest );
_setMissionDiffStringIfNotCheating( finalString );
}
_setHighestMissionIfNotCheating( mission )
{
if ( getdvar( "mis_cheat" ) == "1" )
return;
level.player SetLocalPlayerProfileData( "highestMission", mission );
}
_setMissionDiffStringIfNotCheating( missionsDifficultyString )
{
if ( getdvar( "mis_cheat" ) == "1" )
return;
level.player SetLocalPlayerProfileData( "missionHighestDifficulty", missionsDifficultyString );
}
getLevelSkill( levelIndex )
{
missionString = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
return( int( missionString[ levelIndex ] ) );
}
getMissionDvarString( missionIndex )
{
if ( missionIndex < 9 )
return( "mis_0" + ( missionIndex + 1 ) );
else
return( "mis_" + ( missionIndex + 1 ) );
}
getLowestSkill()
{
missionString = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
lowestSkill = 4;
total_levels = 19;
for ( index = 0; index < total_levels; index++ )
{
if ( int( missionString[ index ] ) < lowestSkill )
lowestSkill = int( missionString[ index ] );
}
return( lowestSkill );
}
createMission( HardenedAward )
{
mission = spawnStruct();
mission.levels = [];
mission.prereqs = [];
mission.HardenedAward = HardenedAward;
return( mission );
}
addLevel( levelName, keepWeapons, achievement, skipsSuccess, veteran_achievement, fade_time, completedIndex, for_kleenex )
{
assert( isdefined( keepweapons ) );
levelIndex = self.levels.size;
self.levels[ levelIndex ] = spawnStruct();
self.levels[ levelIndex ].name = levelName;
self.levels[ levelIndex ].keepWeapons = keepWeapons;
self.levels[ levelIndex ].achievement = achievement;
self.levels[ levelIndex ].skipsSuccess = skipsSuccess;
self.levels[ levelIndex ].veteran_achievement = veteran_achievement;
self.levels[ levelIndex ].completedIndex = completedIndex;
assert( isdefined(self.levels[ levelIndex ].completedIndex) );
if ( IsDefined( fade_time ) )
{
self.levels[ levelIndex ].fade_time = fade_time;
}
}
addSpecOpLevel( levelName, internal_index )
{
if ( isdefined( internal_index ) )
levelIndex = internal_index;
else
levelIndex = self.levels.size;
self.levels[ levelIndex ] = spawnStruct();
self.levels[ levelIndex ].name = levelName;
level_group = tablelookup( "sp/specopstable.csv", SOTABLE_COL_REF, levelName, SOTABLE_COL_GROUP );
if ( level_group == "" )
return;
if( !isdefined( level.specOpsGroups ) )
level.specOpsGroups = [];
if( !isdefined( level.specOpsGroups[ level_group ].group_members ) )
level.specOpsGroups[ level_group ].group_members = [];
member_size = level.specOpsGroups[ level_group ].group_members.size;
level.specOpsGroups[ level_group ].group_members[ member_size ] = levelName;
}
addPreReq( missionIndex )
{
preReqIndex = self.prereqs.size;
self.prereqs[ preReqIndex ] = missionIndex;
}
getLevelIndex( levelName )
{
if ( using_wii() )
{
for ( i=0; i<self.levels.size; i++ )
{
if ( self.levels[i].name == levelName )
return i;
if ( self.levels[i].name == "sp_"+levelName )
return i;
}
}
foreach ( levelIndex, so_level in self.levels )
{
if ( so_level.name == levelName )
return levelIndex;
}
return ( undefined );
}
getLevelName( levelIndex )
{
return( self.levels[ levelIndex ].name );
}
getLevelCompletedIndex( levelIndex )
{
if ( levelIndex >=0 && levelIndex < self.levels.size )
if ( IsDefined( self.levels[ levelIndex ].completedIndex ) )
return self.levels[ levelIndex ].completedIndex;
return -1;
}
getKeepWeapons( levelIndex )
{
return( self.levels[ levelIndex ].keepWeapons );
}
getAchievement( levelIndex )
{
return( self.levels[ levelIndex ].achievement );
}
getLevelVeteranAward( levelIndex )
{
return( self.levels[ levelIndex ].veteran_achievement );
}
getfadetime( index )
{
if ( !IsDefined( self.levels[ index ].fade_time ) )
{
return undefined;
}
return self.levels[ index ].fade_time;
}
hasLevelVeteranAward( levelIndex )
{
if ( isDefined( self.levels[ levelIndex ].veteran_achievement ) )
return( true );
else
return( false );
}
hasAchievement( levelIndex )
{
if ( isDefined( self.levels[ levelIndex ].achievement ) )
return( true );
else
return( false );
}
check_other_hasLevelVeteranAchievement( levelIndex )
{
for ( i = 0; i < self.levels.size; i++ )
{
if ( i == levelIndex )
continue;
if ( ! hasLevelVeteranAward( i ) )
continue;
if ( self.levels[ i ].veteran_achievement == self.levels[ levelIndex ].veteran_achievement )
if ( getLevelCompleted( i ) < 4 )
return false;
}
return true;
}
skipsSuccess( levelIndex )
{
if ( !isDefined( self.levels[ levelIndex ].skipsSuccess ) )
return false;
return true;
}
getHardenedAward()
{
return( self.HardenedAward );
}
hasMissionHardenedAward()
{
if ( isDefined( self.HardenedAward ) )
return( true );
else
return( false );
}
getNextLevelIndex()
{
for ( index = 0; index < self.levels.size; index++ )
{
if ( !self getLevelSkill( index ) )
return( index );
}
return( 0 );
}
force_all_complete()
{
println( "tada!" );
missionString = (level.player GetLocalPlayerProfileData( "missionHighestDifficulty" ));
newString = "";
for ( index = 0; index < missionString.size; index++ )
{
if ( index < 20 )
newString += 2;
else
newstring += 0;
}
level.player SetLocalPlayerProfileData( "missionHighestDifficulty", newString );
level.player SetLocalPlayerProfileData( "highestMission", 20 );
}
clearall()
{
level.player SetLocalPlayerProfileData( "missionHighestDifficulty", emptyMissionDifficultyStr );
level.player SetLocalPlayerProfileData( "highestMission", 1 );
}
credits_end()
{
ChangeLevel( "airplane", false );
}
so_eog_summary_calculate( was_success )
{
assertex( isdefined( was_success ), "so_eog_summary_calculate() requires a true or false value for the was_success parameter." );
if ( !isdefined( self.so_eog_summary_data ) )
self.so_eog_summary_data = [];
if ( !isdefined( level.challenge_start_time ) )
{
level.challenge_start_time = 0;
level.challenge_end_time = 0;
}
assertex( isdefined( level.challenge_end_time ), "level.challenge_end_time is not defined" );
session_time = min( level.challenge_end_time - level.challenge_start_time, 86400000 );
session_time = round_millisec_on_sec( session_time, 1, false );
foreach ( player in level.players )
{
player.so_eog_summary_data[ "time" ] = session_time;
player.so_eog_summary_data[ "name" ] = player.playername;
player.so_eog_summary_data[ "difficulty" ] = player get_player_gameskill();
if ( isdefined( player.forcedGameSkill ) )
player.so_eog_summary_data[ "difficulty" ] = player.forcedGameSkill;
}
level.session_score = 0;
if ( is_survival() )
{
assert( isdefined( level.so_survival_score_func ) );
assert( isdefined( level.so_survival_wave_func ) );
foreach ( player in level.players )
{
player.so_eog_summary_data[ "score" ] = [[ level.so_survival_score_func ]]();
player.so_eog_summary_data[ "wave" ] = [[ level.so_survival_wave_func ]]();
assert( isdefined( player.game_performance ) && isdefined( player.game_performance[ "kill" ] ) );
player.so_eog_summary_data[ "kills" ]	= player.game_performance[ "kill" ];
}
level.session_score	= [[ level.so_survival_score_func ]]();
}
else
{
worst_time = 300000;
if ( isdefined( level.so_mission_worst_time ) )
worst_time = level.so_mission_worst_time;
session_time_score = 0;
if ( session_time < worst_time )
session_time_score = int ( ( ( worst_time - session_time ) / worst_time ) * 10000 );
assertex( isdefined( level.specops_reward_gameskill ), "SpecOps difficult is not setup correctly. 'level.specops_reward_gameskill'" );
level.session_score = int( level.specops_reward_gameskill * 10000 ) + session_time_score;
foreach ( player in level.players )
{
assert( isdefined( player.stats ) && isdefined( player.stats[ "kills" ] ) );
player.so_eog_summary_data[ "kills" ]	= player.stats[ "kills" ];
player.so_eog_summary_data[ "score" ] = level.session_score;
}
}
if ( !isdefined( level.custom_eog_no_defaults ) || !level.custom_eog_no_defaults )
{
foreach ( player in level.players )
{
if ( is_coop() )
player.eog_line = 4;
else
player.eog_line = 3;
}
}
if( isdefined( level.eog_summary_callback ) )
[[level.eog_summary_callback]]();
if ( was_success )
{
flag_set( "special_op_final_xp_given" );
foreach ( player in level.players )
{
xp_earned = calculate_xp( player.so_eog_summary_data[ "score" ] );
first_time_completion_xp = 0;
if ( isdefined( level.never_played ) && level.never_played )
{
player thread givexp( "completion_xp" );
first_time_completion_xp = maps\_rank::getScoreInfoValue( "completion_xp" );
}
else
{
best_score = undefined;
best_score_var = tablelookup( "sp/specOpsTable.csv", 1, level.script, 9 );
if ( IsDefined( best_score_var ) && best_score_var != "" )
best_score = player GetLocalPlayerProfileData( best_score_var );
if ( isdefined( best_score ) && best_score == 0 && !is_survival() )
{
player thread givexp( "completion_xp" );
first_time_completion_xp = maps\_rank::getScoreInfoValue( "completion_xp" );
}
}
if ( !is_survival() )
{
total_xp = first_time_completion_xp + xp_earned;
player thread add_custom_eog_summary_line( "@SPECIAL_OPS_UI_XP_COMPLETION", "", "^3+" + total_xp );
player thread giveXP( "final_score_xp", xp_earned );
}
}
}
if ( !isdefined( level.custom_eog_no_defaults ) || !level.custom_eog_no_defaults )
add_eog_default_stats();
}
calculate_xp( score )
{
return int( score / 10 );
}
so_eog_summary_display()
{
if ( isdefined( level.eog_summary_delay ) && level.eog_summary_delay > 0 )
wait level.eog_summary_delay;
thread maps\_ambient::use_eq_settings( "specialop_fadeout", level.eq_mix_track );
thread maps\_ambient::blend_to_eq_track( level.eq_mix_track, 10 );
reset_eog_popup_dvars();
if( isdefined( level.player.eog_firststar ) && level.player.eog_firststar )
setdvar( "ui_first_star_player1", level.player.eog_firststar );
if( isdefined( level.player.eog_newstar ) && level.player.eog_newstar )
setdvar( "ui_eog_player1_stars", level.player.eog_newstar_value );
if( isdefined( level.player.eog_unlock ) && level.player.eog_unlock )
setdvar( "ui_eog_player1_unlock", level.player.eog_unlock_value );
if( isdefined( level.player.eog_bestscore ) && level.player.eog_bestscore )
setdvar( "ui_eog_player1_bestscore", level.player.eog_bestscore_value );
if ( is_coop() )
{
if( isdefined( level.player.eog_noreward ) && level.player.eog_noreward )
setdvar( "ui_eog_player1_noreward", level.player.eog_noreward );
if( isdefined( level.player2.eog_firststar ) && level.player2.eog_firststar )
setdvar( "ui_first_star_player2", level.player2.eog_firststar );
if( isdefined( level.player2.eog_newstar ) && level.player2.eog_newstar )
setdvar( "ui_eog_player2_stars", level.player2.eog_newstar_value );
if( isdefined( level.player2.eog_unlock ) && level.player2.eog_unlock )
setdvar( "ui_eog_player2_unlock", level.player2.eog_unlock_value );
if( isdefined( level.player2.eog_noreward ) && level.player2.eog_noreward )
setdvar( "ui_eog_player2_noreward", level.player2.eog_noreward );
if( isdefined( level.player2.eog_bestscore ) && level.player2.eog_bestscore )
setdvar( "ui_eog_player2_bestscore", level.player2.eog_bestscore_value );
wait 0.05;
level.player openpopupmenu( "coop_eog_summary" );
level.player2 openpopupmenu( "coop_eog_summary2" );
}
else
{
wait 0.05;
level.player openpopupmenu( "sp_eog_summary" );
}
}
reset_eog_popup_dvars()
{
setdvar( "ui_eog_player1_stars", "" );
setdvar( "ui_eog_player1_unlock", "" );
setdvar( "ui_eog_player1_besttime", "" );
setdvar( "ui_eog_player1_bestscore", "" );
setdvar( "ui_eog_player1_noreward", "" );
setdvar( "ui_eog_player2_stars", "" );
setdvar( "ui_eog_player2_unlock", "" );
setdvar( "ui_eog_player2_besttime", "" );
setdvar( "ui_eog_player2_bestscore", "" );
setdvar( "ui_eog_player2_noreward", "" );
}
add_eog_default_stats()
{
foreach ( player in level.players )
{
player so_eog_default_playerlabel();
player so_eog_default_kills();
player so_eog_default_time();
player so_eog_default_difficulty();
if ( !level.missionfailed )
player so_eog_default_score();
}
}
so_eog_default_playerlabel()
{
if ( is_coop() )
self add_custom_eog_summary_line( "", "@SPECIAL_OPS_PERFORMANCE_YOU", "@SPECIAL_OPS_PERFORMANCE_PARTNER", undefined, 1 );
}
so_eog_default_kills()
{
kills = self.so_eog_summary_data[ "kills" ];
if ( is_coop() )
{
p2_kills = get_other_player( self ).so_eog_summary_data[ "kills" ];
self add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", kills, p2_kills, undefined, 2 );
}
else
{
self add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", kills, undefined, undefined, 1 );
}
}
so_eog_default_difficulty()
{
diffString[ 0 ] = "@MENU_RECRUIT";
diffString[ 1 ] = "@MENU_REGULAR";
diffString[ 2 ] = "@MENU_HARDENED";
diffString[ 3 ] = "@MENU_VETERAN";
diff = self get_player_gameskill();
self add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", diff, undefined, undefined, 2 + int( is_coop() ) );
}
so_eog_default_time()
{
seconds = self.so_eog_summary_data[ "time" ] * 0.001;
time_string = convert_to_time_string( seconds, true );
self add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", time_string, undefined, undefined, 3 + int( is_coop() ) );
}
so_eog_default_score()
{
if ( is_coop() )
score_label = "@SPECIAL_OPS_UI_TEAM_SCORE";
else
score_label = "@SPECIAL_OPS_UI_SCORE";
final_score = self.so_eog_summary_data[ "score" ];
self add_custom_eog_summary_line( score_label, final_score );
}
