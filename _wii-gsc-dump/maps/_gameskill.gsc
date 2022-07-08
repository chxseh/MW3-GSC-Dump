#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_hud_util;
setSkill( reset )
{
if ( !isdefined( level.script ) )
level.script = ToLower( GetDvar( "mapname" ) );
if ( !isdefined( reset ) || reset == false )
{
if ( IsDefined( level.gameSkill ) )
return;
if ( !isdefined( level.custom_player_attacker ) )
level.custom_player_attacker = ::return_false;
level.global_damage_func_ads = ::empty_kill_func;
level.global_damage_func = ::empty_kill_func;
level.global_kill_func = ::empty_kill_func;
if ( GetDvar( "arcademode" ) == "1" )
thread maps\_arcademode::main();
set_console_status();
foreach ( player in level.players )
{
player ent_flag_init( "player_has_red_flashing_overlay" );
player ent_flag_init( "player_is_invulnerable" );
player ent_flag_init( "player_zero_attacker_accuracy" );
player ent_flag_init( "player_no_auto_blur" );
player ent_flag_init( "near_death_vision_enabled" );
player ent_flag_set( "near_death_vision_enabled" );
player.gs = SpawnStruct();
player init_screeneffect_vars();
player.a = SpawnStruct();
player.damage_functions = [];
player maps\_player_stats::init_stats();
player ent_flag_init( "global_hint_in_use" );
player.pers = [];
if ( !isDefined( player.baseIgnoreRandomBulletDamage ) )
player.baseIgnoreRandomBulletDamage = false;
player.disabledWeapon = 0;
player.disabledWeaponSwitch = 0;
player.disabledUsability = 0;
player SetOffhandPrimaryClass( "frag" );
}
level.difficultyType[ 0 ] = "easy";
level.difficultyType[ 1 ] = "normal";
level.difficultyType[ 2 ] = "hardened";
level.difficultyType[ 3 ] = "veteran";
level.difficultyString[ "easy" ] = &"GAMESKILL_EASY";
level.difficultyString[ "normal" ] = &"GAMESKILL_NORMAL";
level.difficultyString[ "hardened" ] = &"GAMESKILL_HARDENED";
level.difficultyString[ "veteran" ] = &"GAMESKILL_VETERAN";
thread gameskill_change_monitor();
}
SetDvarIfUninitialized( "autodifficulty_playerDeathTimer", 0 );
anim.run_accuracy = 0.5;
anim.walk_accuracy = 0.8;
SetDvar( "autodifficulty_frac", 0 );
level.difficultySettings_frac_data_points = [];
foreach ( player in level.players )
{
player init_take_cover_warnings();
player thread increment_take_cover_warnings_on_death();
}
level.mg42badplace_mintime = 8;
level.mg42badplace_maxtime = 16;
level.difficultySettings[ "playerGrenadeBaseTime" ][ "easy" ] = 40000;
level.difficultySettings[ "playerGrenadeBaseTime" ][ "normal" ] = 35000;
level.difficultySettings[ "playerGrenadeBaseTime" ][ "hardened" ] = 25000;
level.difficultySettings[ "playerGrenadeBaseTime" ][ "veteran" ] = 25000;
level.difficultySettings[ "playerGrenadeRangeTime" ][ "easy" ] = 20000;
level.difficultySettings[ "playerGrenadeRangeTime" ][ "normal" ] = 15000;
level.difficultySettings[ "playerGrenadeRangeTime" ][ "hardened" ] = 10000;
level.difficultySettings[ "playerGrenadeRangeTime" ][ "veteran" ] = 10000;
level.difficultySettings[ "playerDoubleGrenadeTime" ][ "easy" ] = 60 * 60 * 1000;
level.difficultySettings[ "playerDoubleGrenadeTime" ][ "normal" ] = 150 * 1000;
level.difficultySettings[ "playerDoubleGrenadeTime" ][ "hardened" ] = 90 * 1000;
level.difficultySettings[ "playerDoubleGrenadeTime" ][ "veteran" ] = 90 * 1000;
level.difficultySettings[ "double_grenades_allowed" ][ "easy" ] = false;
level.difficultySettings[ "double_grenades_allowed" ][ "normal" ] = true;
level.difficultySettings[ "double_grenades_allowed" ][ "hardened" ] = true;
level.difficultySettings[ "double_grenades_allowed" ][ "veteran" ] = true;
level.difficultySettings[ "threatbias" ][ "easy" ] = 100;
level.difficultySettings[ "threatbias" ][ "normal" ] = 150;
level.difficultySettings[ "threatbias" ][ "hardened" ] = 200;
level.difficultySettings[ "threatbias" ][ "veteran" ] = 400;
level.difficultySettings[ "base_enemy_accuracy" ][ "easy" ] = 0.9;
level.difficultySettings[ "base_enemy_accuracy" ][ "normal" ] = 1.0;
level.difficultySettings[ "base_enemy_accuracy" ][ "hardened" ] = 1.15;
level.difficultySettings[ "base_enemy_accuracy" ][ "veteran" ] = 1.15;
level.difficultySettings[ "accuracyDistScale" ][ "easy" ] = 1.0;
level.difficultySettings[ "accuracyDistScale" ][ "normal" ] = 1.0;
level.difficultySettings[ "accuracyDistScale" ][ "hardened" ] = 0.6;
level.difficultySettings[ "accuracyDistScale" ][ "veteran" ] = 0.8;
level.difficultySettings[ "min_sniper_burst_delay_time" ][ "easy" ] = 3.0;
level.difficultySettings[ "min_sniper_burst_delay_time" ][ "normal" ] = 2.0;
level.difficultySettings[ "min_sniper_burst_delay_time" ][ "hardened" ] = 1.5;
level.difficultySettings[ "min_sniper_burst_delay_time" ][ "veteran" ] = 1.1;
level.difficultySettings[ "max_sniper_burst_delay_time" ][ "easy" ] = 4.0;
level.difficultySettings[ "max_sniper_burst_delay_time" ][ "normal" ] = 3.0;
level.difficultySettings[ "max_sniper_burst_delay_time" ][ "hardened" ] = 2.0;
level.difficultySettings[ "max_sniper_burst_delay_time" ][ "veteran" ] = 1.5;
level.difficultySettings[ "dog_health" ][ "easy" ] = 0.25;
level.difficultySettings[ "dog_health" ][ "normal" ] = 0.75;
level.difficultySettings[ "dog_health" ][ "hardened" ] = 1.0;
level.difficultySettings[ "dog_health" ][ "veteran" ] = 1.0;
level.difficultySettings[ "dog_presstime" ][ "easy" ] = 415;
level.difficultySettings[ "dog_presstime" ][ "normal" ] = 375;
level.difficultySettings[ "dog_presstime" ][ "hardened" ] = 250;
level.difficultySettings[ "dog_presstime" ][ "veteran" ] = 225;
level.difficultySettings[ "dog_hits_before_kill" ][ "easy" ] = 2;
level.difficultySettings[ "dog_hits_before_kill" ][ "normal" ] = 1;
level.difficultySettings[ "dog_hits_before_kill" ][ "hardened" ] = 0;
level.difficultySettings[ "dog_hits_before_kill" ][ "veteran" ] = 0;
level.difficultySettings[ "pain_test" ][ "easy" ] = ::always_pain;
level.difficultySettings[ "pain_test" ][ "normal" ] = ::always_pain;
level.difficultySettings[ "pain_test" ][ "hardened" ] = ::pain_protection;
level.difficultySettings[ "pain_test" ][ "veteran" ] = ::pain_protection;
level.difficultySettings[ "missTimeConstant" ][ "easy" ] = 1.0;
level.difficultySettings[ "missTimeConstant" ][ "normal" ] = 0.05;
level.difficultySettings[ "missTimeConstant" ][ "hardened" ] = 0;
level.difficultySettings[ "missTimeConstant" ][ "veteran" ] = 0;
level.difficultySettings[ "missTimeDistanceFactor" ][ "easy" ] = 0.8 / 1000;
level.difficultySettings[ "missTimeDistanceFactor" ][ "normal" ] = 0.1 / 1000;
level.difficultySettings[ "missTimeDistanceFactor" ][ "hardened" ] = 0.05 / 1000;
level.difficultySettings[ "missTimeDistanceFactor" ][ "veteran" ] = 0;
level.difficultySettings[ "flashbangedInvulFactor" ][ "easy" ] = 0.25;
level.difficultySettings[ "flashbangedInvulFactor" ][ "normal" ] = 0;
level.difficultySettings[ "flashbangedInvulFactor" ][ "hardened" ] = 0;
level.difficultySettings[ "flashbangedInvulFactor" ][ "veteran" ] = 0;
level.difficultySettings[ "player_criticalBulletDamageDist" ][ "easy" ] = 0;
level.difficultySettings[ "player_criticalBulletDamageDist" ][ "normal" ] = 0;
level.difficultySettings[ "player_criticalBulletDamageDist" ][ "hardened" ] = 0;
level.difficultySettings[ "player_criticalBulletDamageDist" ][ "veteran" ] = 0;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "easy" ] = 4000;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ] = 2500;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ] = 600;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ] = 100;
level.difficultySettings[ "invulTime_preShield" ][ "easy" ] = 0.6;
level.difficultySettings[ "invulTime_preShield" ][ "normal" ] = 0.5;
level.difficultySettings[ "invulTime_preShield" ][ "hardened" ] = 0.3;
level.difficultySettings[ "invulTime_preShield" ][ "veteran" ] = 0.0;
level.difficultySettings[ "invulTime_onShield" ][ "easy" ] = 1.6;
level.difficultySettings[ "invulTime_onShield" ][ "normal" ] = 1.0;
level.difficultySettings[ "invulTime_onShield" ][ "hardened" ] = 0.5;
level.difficultySettings[ "invulTime_onShield" ][ "veteran" ] = 0.25;
level.difficultySettings[ "invulTime_postShield" ][ "easy" ] = 0.5;
level.difficultySettings[ "invulTime_postShield" ][ "normal" ] = 0.4;
level.difficultySettings[ "invulTime_postShield" ][ "hardened" ] = 0.3;
level.difficultySettings[ "invulTime_postShield" ][ "veteran" ] = 0.0;
level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "easy" ] = 4000;
level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "normal" ] = 4000;
level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "hardened" ] = 3000;
level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "veteran" ] = 1200;
level.difficultySettings[ "worthyDamageRatio" ][ "easy" ] = 0.0;
level.difficultySettings[ "worthyDamageRatio" ][ "normal" ] = 0.1;
level.difficultySettings[ "worthyDamageRatio" ][ "hardened" ] = 0.3;
level.difficultySettings[ "worthyDamageRatio" ][ "veteran" ] = 0.3;
level.difficultySettings[ "playerDifficultyHealth" ][ "easy" ] = 475;
level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ] = 275;
level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ] = 165;
level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ] = 115;
level.difficultySettings[ "longRegenTime" ][ "easy" ] = 5000;
level.difficultySettings[ "longRegenTime" ][ "normal" ] = 5000;
level.difficultySettings[ "longRegenTime" ][ "hardened" ] = 3200;
level.difficultySettings[ "longRegenTime" ][ "veteran" ] = 3200;
level.difficultySettings[ "healthOverlayCutoff" ][ "easy" ] = 0.02;
level.difficultySettings[ "healthOverlayCutoff" ][ "normal" ] = 0.02;
level.difficultySettings[ "healthOverlayCutoff" ][ "hardened" ] = 0.02;
level.difficultySettings[ "healthOverlayCutoff" ][ "veteran" ] = 0.02;
level.difficultySettings[ "health_regenRate" ][ "easy" ] = 0.02;
level.difficultySettings[ "health_regenRate" ][ "normal" ] = 0.02;
level.difficultySettings[ "health_regenRate" ][ "hardened" ] = 0.02;
level.difficultySettings[ "health_regenRate" ][ "veteran" ] = 0.02;
level.difficultySettings[ "explosivePlantTime" ][ "easy" ] = 10;
level.difficultySettings[ "explosivePlantTime" ][ "normal" ] = 10;
level.difficultySettings[ "explosivePlantTime" ][ "hardened" ] = 5;
level.difficultySettings[ "explosivePlantTime" ][ "veteran" ] = 5;
level.difficultySettings[ "player_downed_buffer_time" ][ "normal" ] = 2;
level.difficultySettings[ "player_downed_buffer_time" ][ "hardened" ] = 1.5;
level.difficultySettings[ "player_downed_buffer_time" ][ "veteran" ] = 0;
level.lastPlayerSighted = 0;
SetSavedDvar( "player_meleeDamageMultiplier", 100 / 250 );
if ( IsDefined( level.custom_gameskill_func ) )
[[ level.custom_gameskill_func ]]();
if ( coop_with_one_player_downed() )
{
make_remaining_player_a_little_stronger();
}
updateGameSkill();
updateAllDifficulty();
SetDvar( "autodifficulty_original_setting", level.gameskill );
}
init_screeneffect_vars()
{
self.gs.screeneffect = [];
sides = [ "bottom", "left", "right" ];
types = [ "bloodsplat", "dirt" ];
foreach( type in types )
{
foreach( side in sides )
{
self.gs.screeneffect[ type ][ side ] = 0;
self.gs.screeneffect[ type + "_count" ][ side ] = 0;
}
}
}
coop_player_in_special_ops_survival()
{
SetSavedDvar( "player_meleeDamageMultiplier", 0.26 );
}
solo_player_in_special_ops()
{
AssertEx( level.players.size == 1, "This function is only for special ops featuring 1 player." );
if ( !is_survival() )
{
SetSavedDvar( "player_deathInvulnerableToMelee", "1" );
SetSavedDvar( "ai_accuracy_attackercountDecrease", "0.6" );
}
level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "normal" ] = 2000;
level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "hardened" ] = 2000;
level.difficultySettings[ "playerHealth_RegularRegenDelay" ][ "veteran" ] = 900;
if ( !is_survival() )
level.difficultySettings[ "invulTime_onShield" ][ "normal" ] = 2.5;
else
level.difficultySettings[ "invulTime_onShield" ][ "normal" ] = 1.5;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ] = 3000;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ] = 1300;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ] = 800;
level.difficultySettings[ "longRegenTime" ][ "normal" ] = 4500;
level.difficultySettings[ "longRegenTime" ][ "hardened" ] = 4500;
level.difficultySettings[ "longRegenTime" ][ "veteran" ] = 4500;
level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ] = 350;
level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ] = 205;
level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ] = 205;
if ( !is_survival() )
SetSavedDvar( "player_meleeDamageMultiplier", 0.5 );
else
SetSavedDvar( "player_meleeDamageMultiplier", 0.26 );
}
solo_player_in_coop_gameskill_settings()
{
AssertEx( level.players.size == 2, "This function is only for special ops featuring 2 players." );
level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ] = 2500;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ] = 1200;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "veteran" ] = 200;
multiplier = 1.35;
level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ] = Int( 275 * multiplier );
level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ] = Int( 165 * multiplier );
level.difficultySettings[ "playerDifficultyHealth" ][ "veteran" ] = Int( 115 * 1.2 );
}
make_remaining_player_a_little_stronger()
{
level.difficultySettings[ "player_deathInvulnerableTime" ][ "normal" ] = 2500;
level.difficultySettings[ "player_deathInvulnerableTime" ][ "hardened" ] = 1000;
multiplier = 1.25;
level.difficultySettings[ "playerDifficultyHealth" ][ "normal" ] = Int( 275 * multiplier );
level.difficultySettings[ "playerDifficultyHealth" ][ "hardened" ] = Int( 165 * multiplier );
}
updateAllDifficulty()
{
setGlobalDifficulty();
for ( i = 0; i < level.players.size; i++ )
{
level.players[ i ] setDifficulty();
}
}
setDifficulty()
{
Assert( IsPlayer( self ) );
Assert( IsDefined( self.gameskill ) );
self set_difficulty_from_locked_settings();
}
setGlobalDifficulty()
{
difficulty_func = ::get_locked_difficulty_val_global;
current_skill = get_skill_from_index( level.gameskill );
anim.dog_health = [[ difficulty_func ]]( "dog_health", level.gameskill );
anim.pain_test = level.difficultySettings[ "pain_test" ][ current_skill ];
level.explosiveplanttime = level.difficultySettings[ "explosivePlantTime" ][ current_skill ];
anim.min_sniper_burst_delay_time = [[ difficulty_func ]]( "min_sniper_burst_delay_time", level.gameskill );
anim.max_sniper_burst_delay_time = [[ difficulty_func ]]( "max_sniper_burst_delay_time", level.gameskill );
SetSavedDvar( "ai_accuracyDistScale", [[ difficulty_func ]]( "accuracyDistScale", level.gameskill ) );
if ( laststand_enabled() )
{
AssertEx( IsDefined( level.difficultySettings[ "player_downed_buffer_time" ][ current_skill ] ), "No player_downed_buffer_time for " + current_skill );
level.player_downed_death_buffer_time = level.difficultySettings[ "player_downed_buffer_time" ][ current_skill ];
}
maps\_mgturret::setdifficulty();
}
updateGameSkill()
{
foreach ( player in level.players )
{
if ( is_survival() )
{
player.gameskill = 1;
}
else
{
player.gameskill = player get_player_gameskill();
}
}
level.gameskill = level.player.gameskill;
if ( is_coop() && ( level.player2.gameskill > level.gameskill ) )
level.gameskill = level.player2.gameskill;
level.specops_reward_gameskill = level.player.gameskill;
if ( is_coop() && ( level.player2.gameskill < level.specops_reward_gameskill ) )
level.specops_reward_gameskill = level.player2.gameskill;
if ( IsDefined( level.forcedgameskill ) )
level.gameskill = level.forcedgameskill;
Assert( level.gameSkill >= 0 && level.gameSkill <= 3 );
return level.gameSkill;
}
gameskill_change_monitor()
{
current_gameskill = level.gameSkill;
while ( 1 )
{
if ( !isdefined( current_gameskill ) )
{
wait 1;
current_gameskill = level.gameSkill;
continue;
}
if ( current_gameskill != updateGameSkill() )
{
current_gameskill = level.gameSkill;
updateAllDifficulty();
}
wait 1;
}
}
get_skill_from_index( index )
{
return level.difficultyType[ index ];
}
aa_should_start_fresh()
{
if ( level.script == "killhouse" )
return true;
return level.gameskill == GetDvarInt( "autodifficulty_original_setting" );
}
apply_difficulty_frac_with_func( difficulty_func, current_frac )
{
Assert( IsPlayer( self ) );
self.gs.invulTime_preShield = [[ difficulty_func ]]( "invulTime_preShield", current_frac );
self.gs.invulTime_onShield = [[ difficulty_func ]]( "invulTime_onShield", current_frac );
self.gs.invulTime_postShield = [[ difficulty_func ]]( "invulTime_postShield", current_frac );
self.gs.playerHealth_RegularRegenDelay = [[ difficulty_func ]]( "playerHealth_RegularRegenDelay", current_frac );
self.gs.worthyDamageRatio = [[ difficulty_func ]]( "worthyDamageRatio", current_frac );
self.threatbias = Int( [[ difficulty_func ]]( "threatbias", current_frac ) );
self.gs.longRegenTime = [[ difficulty_func ]]( "longRegenTime", current_frac );
self.gs.healthOverlayCutoff = [[ difficulty_func ]]( "healthOverlayCutoff", current_frac );
self.gs.regenRate = [[ difficulty_func ]]( "health_regenRate", current_frac );
self.gs.player_attacker_accuracy = [[ difficulty_func ]]( "base_enemy_accuracy", current_frac );
update_player_attacker_accuracy();
self.gs.playerGrenadeBaseTime = Int( [[ difficulty_func ]]( "playerGrenadeBaseTime", current_frac ) );
self.gs.playerGrenadeRangeTime = Int( [[ difficulty_func ]]( "playerGrenadeRangeTime", current_frac ) );
self.gs.playerDoubleGrenadeTime = Int( [[ difficulty_func ]]( "playerDoubleGrenadeTime", current_frac ) );
self.gs.min_sniper_burst_delay_time = [[ difficulty_func ]]( "min_sniper_burst_delay_time", current_frac );
self.gs.max_sniper_burst_delay_time = [[ difficulty_func ]]( "max_sniper_burst_delay_time", current_frac );
self.gs.dog_presstime = [[ difficulty_func ]]( "dog_presstime", current_frac );
self.deathInvulnerableTime = Int( [[ difficulty_func ]]( "player_deathInvulnerableTime", current_frac ) );
self.criticalBulletDamageDist = Int( [[ difficulty_func ]]( "player_criticalBulletDamageDist", current_frac ) );
self.damageMultiplier = 100 / [[ difficulty_func ]]( "playerDifficultyHealth", current_frac );
}
update_player_attacker_accuracy()
{
if ( self ent_flag( "player_zero_attacker_accuracy" ) )
return;
self.IgnoreRandomBulletDamage = self.baseIgnoreRandomBulletDamage;
self.attackeraccuracy = self.gs.player_attacker_accuracy;
}
apply_difficulty_step_with_func( difficulty_func, current_frac )
{
Assert( IsPlayer( self ) );
self.gs.missTimeConstant = [[ difficulty_func ]]( "missTimeConstant", current_frac );
self.gs.missTimeDistanceFactor = [[ difficulty_func ]]( "missTimeDistanceFactor", current_frac );
self.gs.dog_hits_before_kill = [[ difficulty_func ]]( "dog_hits_before_kill", current_frac );
self.gs.double_grenades_allowed = [[ difficulty_func ]]( "double_grenades_allowed", current_frac );
}
set_difficulty_from_locked_settings()
{
apply_difficulty_frac_with_func( ::get_locked_difficulty_val_player, 1 );
apply_difficulty_step_with_func( ::get_locked_difficulty_step_val_player, 1 );
}
get_locked_difficulty_step_val_player( system, ignored )
{
return level.difficultySettings[ system ][ get_skill_from_index( self.gameskill ) ];
}
get_locked_difficulty_step_val_global( system, ignored )
{
return level.difficultySettings[ system ][ get_skill_from_index( level.gameskill ) ];
}
get_blended_difficulty( system, current_frac )
{
difficulty_array = level.difficultySettings_frac_data_points[ system ];
Assert( IsDefined( difficulty_array ) );
Assert( difficulty_array.size >= 1 );
for ( i = 1; i < difficulty_array.size; i++ )
{
high_frac = difficulty_array[ i ][ "frac" ];
high_val = difficulty_array[ i ][ "val" ];
if ( current_frac <= high_frac )
{
low_frac = difficulty_array[ i - 1 ][ "frac" ];
low_val = difficulty_array[ i - 1 ][ "val" ];
frac_range = high_frac - low_frac;
val_range = high_val - low_val;
base_frac = current_frac - low_frac;
result_frac = base_frac / frac_range;
return low_val + result_frac * val_range;
}
}
return difficulty_array[ difficulty_array.size - 1 ][ "val" ];
}
getCurrentDifficultySetting( msg )
{
return level.difficultySettings[ msg ][ get_skill_from_index( self.gameskill ) ];
}
getRatio( msg, min, max )
{
return( level.difficultySettings[ msg ][ level.difficultyType[ min ] ] * ( 100 - GetDvarInt( "autodifficulty_frac" ) ) + level.difficultySettings[ msg ][ level.difficultyType[ max ] ] * GetDvarInt( "autodifficulty_frac" ) ) * 0.01;
}
get_locked_difficulty_val_player( msg, ignored )
{
return level.difficultySettings[ msg ][ get_skill_from_index( self.gameskill ) ];
}
get_locked_difficulty_val_global( msg, ignored )
{
return level.difficultySettings[ msg ][ get_skill_from_index( level.gameskill ) ];
}
always_pain()
{
return false;
}
pain_protection()
{
if ( !pain_protection_check() )
return false;
return( RandomInt( 100 ) > 25 );
}
pain_protection_check()
{
if ( !isalive( self.enemy ) )
return false;
if ( !isplayer( self.enemy ) )
return false;
if ( !isalive( level.painAI ) || level.painAI.script != "pain" )
level.painAI = self;
if ( self == level.painAI )
return false;
if ( self.damageWeapon != "none" && WeaponIsBoltAction( self.damageWeapon ) )
return false;
return true;
}
set_accuracy_based_on_situation()
{
if ( self animscripts\combat_utility::isSniper() && IsAlive( self.enemy ) )
{
self setSniperAccuracy();
return;
}
if ( IsPlayer( self.enemy ) )
{
resetMissDebounceTime();
if ( self.a.missTime > GetTime() )
{
self.accuracy = 0;
return;
}
}
if ( self.script == "move" )
{
if ( self isCQBWalkingOrFacingEnemy() )
self.accuracy = anim.walk_accuracy * self.baseAccuracy;
else
self.accuracy = anim.run_accuracy * self.baseAccuracy;
return;
}
self.accuracy = self.baseAccuracy;
if ( IsDefined( self.isRambo ) && IsDefined( self.ramboAccuracyMult ) )
self.accuracy *= self.ramboAccuracyMult;
}
setSniperAccuracy()
{
if ( !isdefined( self.sniperShotCount ) )
{
self.sniperShotCount = 0;
self.sniperHitCount = 0;
}
self.sniperShotCount++;
gameskill = level.gameskill;
if ( IsPlayer( self.enemy ) )
gameskill = self.enemy.gameskill;
if ( shouldForceSniperMissShot() )
{
self.accuracy = 0;
if ( gameskill > 0 || self.sniperShotCount > 1 )
self.lastMissedEnemy = self.enemy;
return;
}
self.accuracy = ( 1 + 1 * self.sniperHitCount ) * self.baseAccuracy;
self.sniperHitCount++;
if ( gameskill < 1 && self.sniperHitCount == 1 )
self.lastMissedEnemy = undefined;
}
shouldForceSniperMissShot()
{
if ( isdefined( self.neverForceSniperMissEnemy ) && self.neverForceSniperMissEnemy )
return false;
if ( self.team == "allies" )
return false;
if ( isDefined( self.lastMissedEnemy ) && ( self.enemy == self.lastMissedEnemy ) )
return false;
if ( DistanceSquared( self.origin, self.enemy.origin ) > ( 500 * 500 ) )
return false;
return true;
}
shotsAfterPlayerBecomesInvul()
{
return( 1 + RandomFloat( 4 ) );
}
didSomethingOtherThanShooting()
{
self.a.missTimeDebounce = 0;
}
resetAccuracyAndPause()
{
self resetMissTime();
}
waitTimeIfPlayerIsHit()
{
waittime = 0;
waittillframeend;
if ( !isalive( self.enemy ) )
return waittime;
if ( !isplayer( self.enemy ) )
return waittime;
if ( self.enemy ent_flag( "player_is_invulnerable" ) )
waittime = ( 0.3 + RandomFloat( 0.4 ) );
return waittime;
}
print3d_time( org, text, color, timer )
{
timer *= 20;
for ( i = 0; i < timer; i++ )
{
Print3d( org, text, color );
wait( 0.05 );
}
}
resetMissTime()
{
if ( !self IsBadGuy() )
return;
if ( self.weapon == "none" )
return;
if ( !self animscripts\weaponList::usingAutomaticWeapon() && !self animscripts\weaponList::usingSemiAutoWeapon() )
{
self.missTime = 0;
return;
}
if ( !isalive( self.enemy ) )
{
return;
}
if ( !isplayer( self.enemy ) )
{
self.accuracy = self.baseAccuracy;
return;
}
dist = Distance( self.enemy.origin, self.origin );
self setMissTime( self.enemy.gs.missTimeConstant + dist * self.enemy.gs.missTimeDistanceFactor );
}
resetMissDebounceTime()
{
self.a.missTimeDebounce = GetTime() + 3000;
}
setMissTime( howLong )
{
AssertEx( self IsBadGuy(), "Non axis tried to set misstime" );
if ( self.a.missTimeDebounce > GetTime() )
{
return;
}
if ( howLong > 0 )
self.accuracy = 0;
howLong *= 1000;
self.a.missTime = GetTime() + howLong;
self.a.accuracyGrowthMultiplier = 1;
}
player_aim_debug()
{
self endon( "death" );
self notify( "playeraim" );
self endon( "playeraim" );
for ( ;; )
{
color = ( 0, 1, 0 );
if ( self.a.misstime > GetTime() )
color = ( 1, 0, 0 );
Print3d( self.origin + ( 0, 0, 32 ), self.finalaccuracy, color );
wait( 0.05 );
}
}
screen_effect_on_open_bottom( type, scaler, skip_fade )
{
x_offset = RandomFloatRange( -15, 15 );
y_offset = RandomFloatRange( -15, 15 );
self ScaleOverTime( 0.1, Int( 2048 * scaler ), Int( 1152 * scaler ) );
self.y = 100 + y_offset;
self MoveOverTime( 0.08 );
self.y = 0 + y_offset;
self.x += x_offset;
if ( IsDefined( skip_fade ) )
{
return;
}
self screen_effect_fade();
}
screen_effect_on_open_side( type, scaler, is_left )
{
mult = 1;
if ( is_left )
{
mult = -1;
}
x_offset = RandomFloatRange( -15, 15 );
y_offset = RandomFloatRange( -15, 15 );
self ScaleOverTime( 0.1, Int( 2048 * scaler ), Int( 1152 * scaler ) );
self.x = ( 1000 * mult ) + x_offset;
self MoveOverTime( 0.1 );
self.x = 0 + x_offset;
self.y += y_offset;
self screen_effect_fade();
}
screen_effect_fade()
{
self endon( "death" );
start_time = GetTime();
fade_out_time = 1;
fade_time = 0.05;
self.alpha = 0;
self FadeOverTime( fade_time );
self.alpha = 1;
wait( fade_time );
wait_for_buffer_time_to_pass( start_time, 2 );
self FadeOverTime( fade_out_time );
self.alpha = 0;
wait( fade_out_time );
self Destroy();
}
screen_detailed_alpha()
{
fade_in_time = 0.2;
self.alpha = 0.7;
self FadeOverTime( fade_in_time );
self.alpha = 0;
wait( fade_in_time );
self Destroy();
}
grenade_dirt_on_screen( side )
{
material = "fullscreen_dirt_" + side;
extra_material = undefined;
if ( side == "bottom" )
{
extra_material = "fullscreen_dirt_bottom_b";
}
self thread display_screen_effect( "dirt", side, material, extra_material, RandomFloatRange( 0.55, 0.66 ) );
}
blood_splat_on_screen( side )
{
material = "fullscreen_bloodsplat_" + side;
self thread display_screen_effect( "bloodsplat", side, material, undefined, RandomFloatRange( 0.45, 0.56 ) );
}
display_screen_effect( type, side, material, extra_bottom_material, scaler )
{
if ( !isalive( self ) )
return;
if ( IsDefined( self.is_controlling_UAV ) )
return;
time = GetTime();
if ( self.gs.screeneffect[ type ][ side ] == time )
{
return;
}
if ( self.gs.screeneffect[ type + "_count" ][ side ] == 1 )
{
return;
}
self.gs.screeneffect[ type + "_count" ][ side ]++;
self.gs.screeneffect[ type ][ side ] = time;
self endon( "death" );
switch( side )
{
case "bottom":
width = Int( 640 );
height = Int( 480 );
if ( type == "dirt" )
{
hud = create_client_overlay_custom_size( material, 1, width, height );
hud thread screen_effect_on_open_bottom( type, scaler, true );
hud screen_detailed_alpha();
}
else
{
hud = create_client_overlay_custom_size( material, 0, width, height );
hud screen_effect_on_open_bottom( type, scaler );
}
if ( IsDefined( extra_bottom_material ) )
{
detailed = create_client_overlay_custom_size( extra_bottom_material, 0, width, height );
detailed screen_effect_on_open_bottom( type, scaler );
}
break;
case "left":
hud = create_client_overlay_custom_size( material, 0, 1, 1 );
hud screen_effect_on_open_side( type, scaler, true );
break;
case "right":
hud = create_client_overlay_custom_size( material, 0, 1, 1 );
hud screen_effect_on_open_side( type, scaler, false );
break;
default:
AssertMsg( "Erroneous screen effect side " + side );
}
self.gs.screeneffect[ type + "_count" ][ side ]--;
AssertEx( self.gs.screeneffect[ type + "_count" ][ side ] >= 0, "Somehow this got lower than 0" );
}
playerHurtcheck()
{
explosive_func = ::dirt_on_screen_from_position;
bullet_func = ::bloodsplateffect;
mods = [];
mods[ "MOD_GRENADE" ] = explosive_func;
mods[ "MOD_GRENADE_SPLASH" ] = explosive_func;
mods[ "MOD_PROJECTILE" ] = explosive_func;
mods[ "MOD_PROJECTILE_SPLASH" ] = explosive_func;
mods[ "MOD_EXPLOSIVE" ] = explosive_func;
mods[ "MOD_PISTOL_BULLET" ] = bullet_func;
mods[ "MOD_RIFLE_BULLET" ] = bullet_func;
mods[ "MOD_EXPLOSIVE_BULLET" ] = bullet_func;
self.hurtAgain = false;
for ( ;; )
{
self waittill( "damage", amount, attacker, dir, point, type );
self.hurtAgain = true;
self.damagePoint = point;
self.damageAttacker = attacker;
mod_func = undefined;
if ( IsDefined( self.mods_override ) )
mod_func = self.mods_override[ type ];
if ( !IsDefined( mod_func ) && IsDefined( mods[ type ] ) )
mod_func = mods[ type ];
if ( IsDefined( mod_func ) )
{
waittillframeend;
[[ mod_func ]]( point );
}
}
}
player_health_packets()
{
Assert( IsPlayer( self ) );
self.player_health_packets = 3;
}
playerHealthRegenInit()
{
wait( 0.05 );
level.strings[ "take_cover" ] = SpawnStruct();
level.strings[ "take_cover" ].text = &"GAME_GET_TO_COVER";
level.strings[ "get_back_up" ] = SpawnStruct();
level.strings[ "get_back_up" ].text = &"GAME_LAST_STAND_GET_BACK_UP";
}
playerHealthRegen()
{
Assert( IsPlayer( self ) );
thread healthOverlay();
oldratio = 1;
health_add = 0;
thread player_health_packets();
veryHurt = false;
playerJustGotRedFlashing = false;
thread playerBreathingSound( self.maxhealth * 0.35 );
invulTime = 0;
hurtTime = 0;
newHealth = 0;
lastinvulratio = 1;
thread playerHurtcheck();
self.boltHit = false;
for ( ;; )
{
wait( 0.05 );
waittillframeend;
if ( laststand_enabled() )
self thread maps\_laststand::player_laststand_proc();
if ( self.health == self.maxhealth )
{
if ( self ent_flag( "player_has_red_flashing_overlay" ) )
{
player_recovers_from_red_flashing();
}
lastinvulratio = 1;
playerJustGotRedFlashing = false;
veryHurt = false;
continue;
}
if ( self.health <= 0 )
{
return;
}
wasVeryHurt = veryHurt;
ratio = self.health / self.maxHealth;
if ( ratio <= self.gs.healthOverlayCutoff && self.player_health_packets > 1 )
{
veryHurt = true;
if ( !wasVeryHurt )
{
hurtTime = GetTime();
if ( self ent_flag( "near_death_vision_enabled" ) )
{
thread blurView( 3.6, 2 );
thread maps\_audio::set_deathsdoor();
self PainVisionOn();
}
self ent_flag_set( "player_has_red_flashing_overlay" );
playerJustGotRedFlashing = true;
}
}
if ( self.hurtAgain )
{
hurtTime = GetTime();
self.hurtAgain = false;
}
if ( self.health / self.maxhealth >= oldratio )
{
if ( GetTime() - hurttime < self.gs.playerHealth_RegularRegenDelay )
continue;
if ( veryHurt )
{
newHealth = ratio;
if ( GetTime() > hurtTime + self.gs.longRegenTime )
newHealth += self.gs.regenRate;
if ( newHealth >= 1 )
reduceTakeCoverWarnings();
}
else
{
newHealth = 1;
}
if ( newHealth > 1.0 )
newHealth = 1.0;
if ( newHealth <= 0 )
{
return;
}
self SetNormalHealth( newHealth );
oldRatio = self.health / self.maxHealth;
continue;
}
oldratio = lastinvulRatio;
worthyDamageRatio = self.gs.worthyDamageRatio;
if ( self.attackerCount == 1 )
worthyDamageRatio *= 3;
invulWorthyHealthDrop = oldratio - ratio >= worthyDamageRatio;
if ( self.health <= 1 )
{
self SetNormalHealth( 2 / self.maxhealth );
invulWorthyHealthDrop = true;
}
oldRatio = self.health / self.maxHealth;
self notify( "hit_again" );
health_add = 0;
hurtTime = GetTime();
thread blurView( 3, 0.8 );
if ( !invulWorthyHealthDrop )
{
continue;
}
if ( self ent_flag( "player_is_invulnerable" ) )
continue;
self ent_flag_set( "player_is_invulnerable" );
level notify( "player_becoming_invulnerable" );
if ( playerJustGotRedFlashing )
{
invulTime = self.gs.invulTime_onShield;
playerJustGotRedFlashing = false;
}
else if ( veryHurt )
{
invulTime = self.gs.invulTime_postShield;
}
else
{
invulTime = self.gs.invulTime_preShield;
}
lastinvulratio = self.health / self.maxHealth;
self thread playerInvul( invulTime );
}
}
reduceTakeCoverWarnings()
{
Assert( IsPlayer( self ) );
if ( !self take_cover_warnings_enabled() )
return;
if ( IsAlive( self ) )
{
takeCoverWarnings = ( self GetLocalPlayerProfileData( "takeCoverWarnings" ) );
if ( takeCoverWarnings > 0 )
{
takeCoverWarnings--;
self SetLocalPlayerProfileData( "takeCoverWarnings", takeCoverWarnings );
}
}
}
playerInvul( timer )
{
Assert( IsPlayer( self ) );
if ( IsDefined( self.flashendtime ) && self.flashendtime > GetTime() )
timer = timer * getCurrentDifficultySetting( "flashbangedInvulFactor" );
if ( timer > 0 )
{
if ( !isdefined( self.noPlayerInvul ) )
self.attackeraccuracy = 0;
self.IgnoreRandomBulletDamage = true;
wait( timer );
}
update_player_attacker_accuracy();
self ent_flag_clear( "player_is_invulnerable" );
}
default_door_node_flashbang_frequency()
{
if ( self.team == "allies" )
self.doorFlashChance = .6;
if ( self IsBadGuy() )
{
if ( level.gameSkill >= 2 )
{
self.doorFlashChance = .8;
}
else
{
self.doorFlashChance = .6;
}
}
}
grenadeAwareness()
{
if ( self.team == "allies" )
{
self.grenadeawareness = 0.9;
return;
}
if ( self IsBadGuy() )
{
if ( level.gameSkill >= 2 )
{
if ( RandomInt( 100 ) < 33 )
self.grenadeawareness = 0.2;
else
self.grenadeawareness = 0.5;
}
else
{
if ( RandomInt( 100 ) < 33 )
self.grenadeawareness = 0;
else
self.grenadeawareness = 0.2;
}
}
}
blurView( blur, timer )
{
Assert( IsPlayer( self ) );
if ( ent_flag( "player_no_auto_blur" ) )
return;
self notify( "blurview_stop" );
self endon( "blurview_stop" );
self SetBlurForPlayer( blur, 0 );
wait( 0.05 );
self SetBlurForPlayer( 0, timer );
}
playerBreathingSound( healthcap )
{
Assert( IsPlayer( self ) );
wait( 2 );
for ( ;; )
{
wait( 0.2 );
if ( self.health <= 0 )
return;
ratio = self.health / self.maxHealth;
if ( ratio > self.gs.healthOverlayCutoff )
continue;
if ( IsDefined( self.disable_breathing_sound ) && self.disable_breathing_sound )
continue;
self PlayLocalSound( "breathing_hurt" );
wait( 0.1 + RandomFloat( 0.8 ) );
}
}
healthOverlay()
{
Assert( IsPlayer( self ) );
self endon( "noHealthOverlay" );
overlay = NewClientHudElem( self );
overlay.x = 0;
overlay.y = 0;
if ( issplitscreen() )
{
overlay SetShader( "splatter_alt_sp", 640, 480 * 2 );
if ( self == level.players[ 0 ] )
{
overlay.y -= 120;
}
}
else
{
overlay SetShader( "splatter_alt_sp", 640, 480 );
}
overlay.splatter = true;
overlay.alignX = "left";
overlay.alignY = "top";
overlay.sort = 1;
overlay.foreground = 0;
overlay.horzAlign = "fullscreen";
overlay.vertAlign = "fullscreen";
overlay.alpha = 0;
thread healthOverlay_remove( overlay );
thread take_cover_warning_loop();
damageAlpha = 0.0;
updateTime = 0.05;
lerpRate = 0.3;
while ( IsAlive( self ) )
{
wait updateTime;
ratio = 1.0 - ( self.health / self.maxhealth );
targetDamageAlpha = ( ratio * ratio ) * 1.2;
targetDamageAlpha = Clamp( targetDamageAlpha, 0, 1 );
if ( damageAlpha > targetDamageAlpha )
damageAlpha -= ( lerpRate * updateTime );
if ( damageAlpha < targetDamageAlpha )
damageAlpha = targetDamageAlpha;
overlay.alpha = damageAlpha;
}
}
take_cover_warning_loop()
{
while ( IsAlive( self ) )
{
self ent_flag_wait( "player_has_red_flashing_overlay" );
take_cover_warning();
while ( self ent_flag( "player_has_red_flashing_overlay" ) )
wait( 0.05 );
}
}
add_hudelm_position_internal( alignY )
{
if ( level.console )
self.fontScale = 2;
else
self.fontScale = 1.6;
self.x = 0;
self.y = -36;
self.alignX = "center";
self.alignY = "bottom";
self.horzAlign = "center";
self.vertAlign = "middle";
if ( !isdefined( self.background ) )
return;
self.background.x = 0;
self.background.y = -40;
self.background.alignX = "center";
self.background.alignY = "middle";
self.background.horzAlign = "center";
self.background.vertAlign = "middle";
if ( level.console )
self.background SetShader( "popmenu_bg", 650, 52 );
else
self.background SetShader( "popmenu_bg", 650, 42 );
self.background.alpha = .5;
}
create_warning_elem()
{
Assert( IsPlayer( self ) );
hudelem = NewClientHudElem( self );
hudelem add_hudelm_position_internal();
thread destroy_warning_elem_when_hit_again( hudelem );
hudelem thread destroy_warning_elem_when_mission_failed();
if ( is_player_down( self ) )
hudelem SetText( level.strings[ "get_back_up" ].text );
else
hudelem SetText( level.strings[ "take_cover" ].text );
hudelem.fontscale = 2;
hudelem.alpha = 1;
hudelem.color = ( 1, 0.9, 0.9 );
hudelem.sort = 1;
hudelem.foreground = 1;
return hudelem;
}
waitTillPlayerIsHitAgain()
{
self endon( "hit_again" );
self endon( "player_downed" );
self waittill( "damage" );
}
destroy_warning_elem_when_hit_again( hudelem )
{
Assert( IsPlayer( self ) );
hudelem endon( "being_destroyed" );
waitTillPlayerIsHitAgain();
fadeout = ( !isalive( self ) );
hudelem thread destroy_warning_elem( fadeout );
}
destroy_warning_elem_when_mission_failed()
{
self endon( "being_destroyed" );
flag_wait( "missionfailed" );
self thread destroy_warning_elem( true );
}
destroy_warning_elem( fadeout )
{
self notify( "being_destroyed" );
self.beingDestroyed = true;
if ( fadeout )
{
self FadeOverTime( 0.5 );
self.alpha = 0;
wait 0.5;
}
self notify( "death" );
self Destroy();
}
may_change_cover_warning_alpha( coverWarning )
{
if ( !isdefined( coverWarning ) )
return false;
if ( IsDefined( coverWarning.beingDestroyed ) )
return false;
return true;
}
fontScaler( scale, timer )
{
self endon( "death" );
scale *= 2;
dif = scale - self.fontscale;
self ChangeFontScaleOverTime( timer );
self.fontscale += dif;
}
fadeFunc( coverWarning, severity, mult, hud_scaleOnly )
{
pulseTime = 0.8;
scaleMin = 0.5;
fadeInTime = pulseTime * 0.1;
stayFullTime = pulseTime * ( .1 + severity * .2 );
fadeOutHalfTime = pulseTime * ( 0.1 + severity * .1 );
fadeOutFullTime = pulseTime * 0.3;
remainingTime = pulseTime - fadeInTime - stayFullTime - fadeOutHalfTime - fadeOutFullTime;
Assert( remainingTime >= -.001 );
if ( remainingTime < 0 )
remainingTime = 0;
halfAlpha = 0.8 + severity * 0.1;
leastAlpha = 0.5 + severity * 0.3;
if ( may_change_cover_warning_alpha( coverWarning ) )
{
if ( !hud_scaleOnly )
{
coverWarning FadeOverTime( fadeInTime );
coverWarning.alpha = mult * 1.0;
}
}
if ( IsDefined( coverWarning ) )
coverWarning thread fontScaler( 1.0, fadeInTime );
wait fadeInTime + stayFullTime;
if ( may_change_cover_warning_alpha( coverWarning ) )
{
if ( !hud_scaleOnly )
{
coverWarning FadeOverTime( fadeOutHalfTime );
coverWarning.alpha = mult * halfAlpha;
}
}
wait fadeOutHalfTime;
if ( may_change_cover_warning_alpha( coverWarning ) )
{
if ( !hud_scaleOnly )
{
coverWarning FadeOverTime( fadeOutFullTime );
coverWarning.alpha = mult * leastAlpha;
}
}
if ( IsDefined( coverWarning ) )
coverWarning thread fontScaler( 0.9, fadeOutFullTime );
wait fadeOutFullTime;
wait remainingTime;
}
take_cover_warnings_enabled()
{
Assert( IsPlayer( self ) );
if ( IsDefined( level.cover_warnings_disabled ) )
{
AssertEx( level.cover_warnings_disabled, "level.cover_warnings_disabled must be true or undefined" );
return false;
}
if ( IsDefined( self.vehicle ) )
return false;
return true;
}
should_show_cover_warning()
{
Assert( IsPlayer( self ) );
if ( !isAlive( self ) )
return false;
if ( self isLinked() )
return false;
if ( self.ignoreme )
return false;
if ( level.MissionFailed )
return false;
if ( !self take_cover_warnings_enabled() )
return false;
if ( self.gameskill > 1 && !maps\_load::map_is_early_in_the_game() )
return false;
takeCoverWarnings = ( self GetLocalPlayerProfileData( "takeCoverWarnings" ) );
if ( takeCoverWarnings <= 3 )
return false;
return true;
}
take_cover_warning()
{
Assert( IsPlayer( self ) );
self endon( "hit_again" );
self endon( "damage" );
coverWarning = undefined;
if ( should_show_cover_warning() )
{
coverWarning = create_warning_elem();
}
stopFlashingBadlyTime = GetTime() + self.gs.longRegenTime;
fadeFunc( coverWarning, 1, 1, false );
while ( GetTime() < stopFlashingBadlyTime && IsAlive( self ) && self ent_flag( "player_has_red_flashing_overlay" ) )
fadeFunc( coverWarning, .9, 1, false );
if ( IsAlive( self ) )
fadeFunc( coverWarning, .65, 0.8, false );
if ( may_change_cover_warning_alpha( coverWarning ) )
{
coverWarning FadeOverTime( 1.0 );
coverWarning.alpha = 0;
}
fadeFunc( coverWarning, 0, 0.6, true );
wait( 0.5 );
self notify( "take_cover_done" );
self notify( "hit_again" );
}
player_recovers_from_red_flashing()
{
self ent_flag_clear( "player_has_red_flashing_overlay" );
if ( self ent_flag( "near_death_vision_enabled" ) )
{
self PainVisionOff();
thread maps\_audio::restore_after_deathsdoor();
}
if ( !IsDefined( self.disable_breathing_sound ) || !self.disable_breathing_sound )
{
self PlayLocalSound( "breathing_better" );
}
self notify( "take_cover_done" );
}
healthOverlay_remove( overlay )
{
Assert( IsPlayer( self ) );
self waittill( "noHealthOverlay" );
overlay Destroy();
}
resetSkill()
{
waittillframeend;
setskill( true );
}
init_take_cover_warnings()
{
isPreGameplayLevel = level.script == "sp_intro" || level.script == "ny_manhattan";
if ( self GetLocalPlayerProfileData( "takeCoverWarnings" ) == -1 || isPreGameplayLevel )
{
self SetLocalPlayerProfileData( "takeCoverWarnings", 9 );
}
}
increment_take_cover_warnings_on_death()
{
self notify( "new_cover_on_death_thread" );
self endon( "new_cover_on_death_thread" );
self waittill( "death" );
if ( !self ent_flag( "player_has_red_flashing_overlay" ) )
return;
if ( !self take_cover_warnings_enabled() )
return;
warnings = ( self GetLocalPlayerProfileData( "takeCoverWarnings" ) );
if ( warnings < 10 )
self SetLocalPlayerProfileData( "takeCoverWarnings", warnings + 1 );
}
auto_adjust_difficulty_player_positioner()
{
Assert( IsPlayer( self ) );
org = self.origin;
wait( 5 );
if ( self autospot_is_close_to_player( org ) )
level.autoAdjust_playerSpots[ level.autoAdjust_playerSpots.size ] = org;
}
autospot_is_close_to_player( org )
{
Assert( IsPlayer( self ) );
return DistanceSquared( self.origin, org ) < ( 140 * 140 );
}
auto_adjust_difficulty_player_movement_check()
{
level.autoAdjust_playerSpots = [];
level.player.movedRecently = true;
wait( 1 );
for ( ;; )
{
level.player thread auto_adjust_difficulty_player_positioner();
level.player.movedRecently = true;
newSpots = [];
start = level.autoAdjust_playerSpots.size - 5;
if ( start < 0 )
start = 0;
for ( i = start; i < level.autoAdjust_playerSpots.size; i++ )
{
if ( !level.player autospot_is_close_to_player( level.autoAdjust_playerSpots[ i ] ) )
continue;
newSpots[ newSpots.size ] = level.autoAdjust_playerSpots[ i ];
level.player.movedRecently = false;
}
level.autoAdjust_playerSpots = newSpots;
wait( 1 );
}
}
auto_adjust_difficulty_track_player_death()
{
level.player waittill( "death" );
num = GetDvarInt( "autodifficulty_playerDeathTimer" );
num -= 60;
SetDvar( "autodifficulty_playerDeathTimer", num );
}
auto_adjust_difficulty_track_player_shots()
{
lastShotTime = GetTime();
for ( ;; )
{
if ( level.player AttackButtonPressed() )
lastShotTime = GetTime();
level.timeBetweenShots = GetTime() - lastShotTime;
wait( 0.05 );
}
}
hud_debug_add_frac( msg, num )
{
hud_debug_add_display( msg, num * 100, true );
}
hud_debug_add( msg, num )
{
hud_debug_add_display( msg, num, false );
}
hud_debug_clear()
{
level.hudNum = 0;
if ( IsDefined( level.hudDebugNum ) )
{
for ( i = 0; i < level.hudDebugNum.size; i++ )
level.hudDebugNum[ i ] Destroy();
}
level.hudDebugNum = [];
}
hud_debug_add_message( msg )
{
if ( !isdefined( level.hudMsgShare ) )
level.hudMsgShare = [];
if ( !isdefined( level.hudMsgShare[ msg ] ) )
{
hud = NewHudElem();
hud.x = level.debugLeft;
hud.y = level.debugHeight + level.hudNum * 15;
hud.foreground = 1;
hud.sort = 100;
hud.alpha = 1.0;
hud.alignX = "left";
hud.horzAlign = "left";
hud.fontScale = 1.0;
hud SetText( msg );
level.hudMsgShare[ msg ] = true;
}
}
hud_debug_add_display( msg, num, isfloat )
{
hud_debug_add_message( msg );
num = Int( num );
negative = false;
if ( num < 0 )
{
negative = true;
num *= -1;
}
thousands = 0;
hundreds = 0;
tens = 0;
ones = 0;
while ( num >= 10000 )
num -= 10000;
while ( num >= 1000 )
{
num -= 1000;
thousands++;
}
while ( num >= 100 )
{
num -= 100;
hundreds++;
}
while ( num >= 10 )
{
num -= 10;
tens++;
}
while ( num >= 1 )
{
num -= 1;
ones++;
}
offset = 0;
offsetSize = 10;
if ( thousands > 0 )
{
hud_debug_add_num( thousands, offset );
offset += offsetSize;
hud_debug_add_num( hundreds, offset );
offset += offsetSize;
hud_debug_add_num( tens, offset );
offset += offsetSize;
hud_debug_add_num( ones, offset );
offset += offsetSize;
}
else
if ( hundreds > 0 || isFloat )
{
hud_debug_add_num( hundreds, offset );
offset += offsetSize;
hud_debug_add_num( tens, offset );
offset += offsetSize;
hud_debug_add_num( ones, offset );
offset += offsetSize;
}
else
if ( tens > 0 )
{
hud_debug_add_num( tens, offset );
offset += offsetSize;
hud_debug_add_num( ones, offset );
offset += offsetSize;
}
else
{
hud_debug_add_num( ones, offset );
offset += offsetSize;
}
if ( isFloat )
{
decimalHud = NewHudElem();
decimalHud.x = 204.5;
decimalHud.y = level.debugHeight + level.hudNum * 15;
decimalHud.foreground = 1;
decimalHud.sort = 100;
decimalHud.alpha = 1.0;
decimalHud.alignX = "left";
decimalHud.horzAlign = "left";
decimalHud.fontScale = 1.0;
decimalHud SetText( "." );
level.hudDebugNum[ level.hudDebugNum.size ] = decimalHud;
}
if ( negative )
{
negativeHud = NewHudElem();
negativeHud.x = 195.5;
negativeHud.y = level.debugHeight + level.hudNum * 15;
negativeHud.foreground = 1;
negativeHud.sort = 100;
negativeHud.alpha = 1.0;
negativeHud.alignX = "left";
negativeHud.horzAlign = "left";
negativeHud.fontScale = 1.0;
negativeHud SetText( " - " );
level.hudDebugNum[ level.hudNum ] = negativeHud;
}
level.hudNum++;
}
hud_debug_add_string( msg, msg2 )
{
hud_debug_add_message( msg );
hud_debug_add_second_string( msg2, 0 );
level.hudNum++;
}
hud_debug_add_num( num, offset )
{
hud = NewHudElem();
hud.x = 200 + offset * 0.65;
hud.y = level.debugHeight + level.hudNum * 15;
hud.foreground = 1;
hud.sort = 100;
hud.alpha = 1.0;
hud.alignX = "left";
hud.horzAlign = "left";
hud.fontScale = 1.0;
hud SetText( num + "" );
level.hudDebugNum[ level.hudDebugNum.size ] = hud;
}
hud_debug_add_second_string( num, offset )
{
hud = NewHudElem();
hud.x = 200 + offset * 0.65;
hud.y = level.debugHeight + level.hudNum * 15;
hud.foreground = 1;
hud.sort = 100;
hud.alpha = 1.0;
hud.alignX = "left";
hud.horzAlign = "left";
hud.fontScale = 1.0;
hud SetText( num );
level.hudDebugNum[ level.hudDebugNum.size ] = hud;
}
aa_init_stats()
{
level.sp_stat_tracking_func = ::auto_adjust_new_zone;
SetDvar( "aa_player_kills", "0" );
SetDvar( "aa_enemy_deaths", "0" );
SetDvar( "aa_enemy_damage_taken", "0" );
SetDvar( "aa_player_damage_taken", "0" );
SetDvar( "aa_player_damage_dealt", "0" );
SetDvar( "aa_ads_damage_dealt", "0" );
SetDvar( "aa_time_tracking", "0" );
SetDvar( "aa_deaths", "0" );
SetDvar( "player_cheated", 0 );
level.auto_adjust_results = [];
thread aa_time_tracking();
thread aa_player_health_tracking();
thread aa_player_ads_tracking();
flag_set( "auto_adjust_initialized" );
flag_init( "aa_main_" + level.script );
flag_set( "aa_main_" + level.script );
}
command_used( cmd )
{
Assert( IsPlayer( self ) );
binding = GetKeyBinding( cmd );
if ( binding[ "count" ] <= 0 )
{
return false;
}
for ( i = 1; i < binding[ "count" ] + 1; i++ )
{
if ( self ButtonPressed( binding[ "key" + i ] ) )
{
return true;
}
}
return false;
}
aa_time_tracking()
{
waittillframeend;
for ( ;; )
{
wait( 0.2 );
}
}
aa_player_ads_tracking()
{
level.player endon( "death" );
level.player_ads_time = 0;
for ( ;; )
{
if ( level.player isADS() )
{
level.player_ads_time = GetTime();
while ( level.player isADS() )
{
wait( 0.05 );
}
continue;
}
wait( 0.05 );
}
}
aa_player_health_tracking()
{
for ( ;; )
{
level.player waittill( "damage", amount, a, b, c, d, e, f );
aa_add_event( "aa_player_damage_taken", amount );
if ( !isalive( level.player ) )
{
aa_add_event( "aa_deaths", 1 );
return;
}
}
}
auto_adjust_new_zone( zone )
{
if ( !isdefined( level.auto_adjust_flags ) )
{
level.auto_adjust_flags = [];
}
flag_wait( "auto_adjust_initialized" );
level.auto_adjust_results[ zone ] = [];
level.auto_adjust_flags[ zone ] = 0;
flag_wait( zone );
if ( GetDvar( "aa_zone" + zone ) == "" )
{
SetDvar( "aa_zone" + zone, "on" );
level.auto_adjust_flags[ zone ] = 1;
aa_update_flags();
SetDvar( "start_time" + zone, GetDvar( "aa_time_tracking" ) );
SetDvar( "starting_player_kills" + zone, GetDvar( "aa_player_kills" ) );
SetDvar( "starting_deaths" + zone, GetDvar( "aa_deaths" ) );
SetDvar( "starting_ads_damage_dealt" + zone, GetDvar( "aa_ads_damage_dealt" ) );
SetDvar( "starting_player_damage_dealt" + zone, GetDvar( "aa_player_damage_dealt" ) );
SetDvar( "starting_player_damage_taken" + zone, GetDvar( "aa_player_damage_taken" ) );
SetDvar( "starting_enemy_damage_taken" + zone, GetDvar( "aa_enemy_damage_taken" ) );
SetDvar( "starting_enemy_deaths" + zone, GetDvar( "aa_enemy_deaths" ) );
}
else
{
if ( GetDvar( "aa_zone" + zone ) == "done" )
{
return;
}
}
flag_waitopen( zone );
auto_adust_zone_complete( zone );
}
auto_adust_zone_complete( zone )
{
SetDvar( "aa_zone" + zone, "done" );
start_time = GetDvarFloat( "start_time" + zone );
starting_player_kills = GetDvarInt( "starting_player_kills" + zone );
starting_enemy_deaths = GetDvarInt( "aa_enemy_deaths" + zone );
starting_enemy_damage_taken = GetDvarInt( "aa_enemy_damage_taken" + zone );
starting_player_damage_taken = GetDvarInt( "aa_player_damage_taken" + zone );
starting_player_damage_dealt = GetDvarInt( "aa_player_damage_dealt" + zone );
starting_ads_damage_dealt = GetDvarInt( "aa_ads_damage_dealt" + zone );
starting_deaths = GetDvarInt( "aa_deaths" + zone );
level.auto_adjust_flags[ zone ] = 0;
aa_update_flags();
total_time = GetDvarFloat( "aa_time_tracking" ) - start_time;
total_player_kills = GetDvarInt( "aa_player_kills" ) - starting_player_kills;
total_enemy_deaths = GetDvarInt( "aa_enemy_deaths" ) - starting_enemy_deaths;
player_kill_ratio = 0;
if ( total_enemy_deaths > 0 )
{
player_kill_ratio = total_player_kills / total_enemy_deaths;
player_kill_ratio *= 100;
player_kill_ratio = Int( player_kill_ratio );
}
total_enemy_damage_taken = GetDvarInt( "aa_enemy_damage_taken" ) - starting_enemy_damage_taken;
total_player_damage_dealt = GetDvarInt( "aa_player_damage_dealt" ) - starting_player_damage_dealt;
player_damage_dealt_ratio = 0;
player_damage_dealt_per_minute = 0;
if ( total_enemy_damage_taken > 0 && total_time > 0 )
{
player_damage_dealt_ratio = total_player_damage_dealt / total_enemy_damage_taken;
player_damage_dealt_ratio *= 100;
player_damage_dealt_ratio = Int( player_damage_dealt_ratio );
player_damage_dealt_per_minute = total_player_damage_dealt / total_time;
player_damage_dealt_per_minute = player_damage_dealt_per_minute * 60;
player_damage_dealt_per_minute = Int( player_damage_dealt_per_minute );
}
total_ads_damage_dealt = GetDvarInt( "aa_ads_damage_dealt" ) - starting_ads_damage_dealt;
player_ads_damage_ratio = 0;
if ( total_player_damage_dealt > 0 )
{
player_ads_damage_ratio = total_ads_damage_dealt / total_player_damage_dealt;
player_ads_damage_ratio *= 100;
player_ads_damage_ratio = Int( player_ads_damage_ratio );
}
total_player_damage_taken = GetDvarInt( "aa_player_damage_taken" ) - starting_player_damage_taken;
player_damage_taken_ratio = 0;
if ( total_time > 0 )
{
player_damage_taken_ratio = total_player_damage_taken / total_time;
}
player_damage_taken_per_minute = player_damage_taken_ratio * 60;
player_damage_taken_per_minute = Int( player_damage_taken_per_minute );
total_deaths = GetDvarInt( "aa_deaths" ) - starting_deaths;
aa_array = [];
aa_array[ "player_damage_taken_per_minute" ] = player_damage_taken_per_minute;
aa_array[ "player_damage_dealt_per_minute" ] = player_damage_dealt_per_minute;
aa_array[ "minutes" ] = total_time / 60;
aa_array[ "deaths" ] = total_deaths;
aa_array[ "gameskill" ] = level.gameskill;
level.auto_adjust_results[ zone ] = aa_array;
msg = "Completed AA sequence: ";
msg += level.script + "/" + zone;
keys = GetArrayKeys( aa_array );
for ( i = 0; i < keys.size; i++ )
{
msg = msg + ", " + keys[ i ] + ": " + aa_array[ keys[ i ] ];
}
logString( msg );
PrintLn( "^6" + msg );
}
aa_print_vals( key, aa_array )
{
logString( key + ": " + aa_array[ key ] );
PrintLn( "^6" + key + ": " + aa_array[ key ] );
}
aa_update_flags()
{
}
aa_add_event( event, amount )
{
old_amount = GetDvarInt( event );
SetDvar( event, old_amount + amount );
}
aa_add_event_float( event, amount )
{
old_amount = GetDvarFloat( event );
SetDvar( event, old_amount + amount );
}
return_false( attacker )
{
return false;
}
player_attacker( attacker )
{
if ( [[ level.custom_player_attacker ]]( attacker ) )
return true;
if ( IsPlayer( attacker ) )
return true;
if ( !isdefined( attacker.car_damage_owner_recorder ) )
return false;
return attacker player_did_most_damage();
}
player_did_most_damage()
{
return self.player_damage * 1.75 > self.non_player_damage;
}
empty_kill_func( type, loc, point )
{
}
auto_adjust_enemy_died( amount, attacker, type, point )
{
aa_add_event( "aa_enemy_deaths", 1 );
if ( !isdefined( attacker ) )
{
return;
}
if ( !player_attacker( attacker ) )
{
return;
}
[[ level.global_kill_func ]]( type, self.damagelocation, point );
aa_add_event( "aa_player_kills", 1 );
}
auto_adjust_enemy_death_detection( amount, attacker, direction_vec, point, type, _, _ )
{
if ( !isalive( self ) || self.delayeddeath )
{
self auto_adjust_enemy_died( amount, attacker, type, point );
return;
}
if ( !player_attacker( attacker ) )
return;
aa_player_attacks_enemy_with_ads( amount, type, point );
}
aa_player_attacks_enemy_with_ads( amount, type, point )
{
aa_add_event( "aa_player_damage_dealt", amount );
AssertEx( GetDvarInt( "aa_player_damage_dealt" ) > 0 );
if ( !level.player isADS() )
{
[[ level.global_damage_func ]]( type, self.damagelocation, point );
return false;
}
if ( !bullet_attack( type ) )
{
[[ level.global_damage_func ]]( type, self.damagelocation, point );
return false;
}
[[ level.global_damage_func_ads ]]( type, self.damagelocation, point );
aa_add_event( "aa_ads_damage_dealt", amount );
return true;
}
bullet_attack( type )
{
if ( type == "MOD_PISTOL_BULLET" )
return true;
return type == "MOD_RIFLE_BULLET";
}
add_fractional_data_point( name, frac, val )
{
if ( !isdefined( level.difficultySettings_frac_data_points[ name ] ) )
{
level.difficultySettings_frac_data_points[ name ] = [];
}
array = [];
array[ "frac" ] = frac;
array[ "val" ] = val;
AssertEx( frac >= 0, "Tried to set a difficulty data point less than 0." );
AssertEx( frac <= 1, "Tried to set a difficulty data point greater than 1." );
level.difficultySettings_frac_data_points[ name ][ level.difficultySettings_frac_data_points[ name ].size ] = array;
}
coop_with_one_player_downed()
{
return is_coop() && get_players_healthy().size == 1;
}

