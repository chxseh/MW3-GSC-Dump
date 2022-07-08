#include common_scripts\utility;
#include common_scripts\_fx;
#include maps\_shg_fx;
main()
{
level._effect[ "nvg_dlight"] = LoadFX( "misc/NV_dlight_castle" );
level._effect[ "fx_castle_floodlight"] = LoadFX( "lights/fx_floodlight_castle" );
level._effect[ "flashbang" ] = LoadFX( "explosions/flashbang" );
level._effect[ "rotor_rain_effect" ] = LoadFX( "weather/heli_rain_rotor_mist" );
level._effect[ "tree_fall_impact_wet" ]	= LoadFX( "breakables/tree_fall_impact_wet" );
level._effect[ "tree_shake_wet" ] = LoadFX( "breakables/tree_shake_wet" );
level._effect[ "tree_trunk_snap" ] = LoadFX( "breakables/tree_trunk_snap" );
level._effect["roof_slide_ai_castle"]	= LoadFX("misc/roof_slide_ai_castle");
level._effect["price_smokewall_push"]	= loadfx("smoke/smoke_push_ai");
level._effect["smoke_push_player"]	= loadfx("smoke/smoke_push_player");
level._effect["wall_hand_plant"] = LoadFX("dust/hand_wall_plant_castle");
level._effect["wall_fall_dust"] = LoadFX("dust/dust_fall_wet_wall_castle");
level._effect["bullet_strafe"] = LoadFX("impacts/bullet_strafe_castle");
level._effect["boiling_pot"] = LoadFX("props/boiling_pot");
level._effect["pot_water_splash"] = LoadFX("props/pot_water_splash");
level._effect["on_fire"] = LoadFX("fire/burninng_soldier_torso");
level._effect[ "flesh_hit" ] = loadfx( "impacts/flesh_hit" );
level._effect[ "btr_death" ] = LoadFX( "explosions/vehicle_explosion_btr80" );
level._effect[ "bridge_chunk_trail"]	= LoadFX( "dust/debris_dust_trail_emitter" );
level._effect["generator_spark" ] = LoadFx("explosions/lightbulb_pop_lg");
level._effect[ "bmp_flash_wv" ] = LoadFX( "muzzleflashes/bmp_flash_wv" );
level._effect["pistol_muzzle_flash"] = loadfx("muzzleflashes/pistolflash");
level._effect["pistol_shell_eject"] = loadfx("shellejects/pistol");
level._effect[ "knife_attack_throat_fx" ] = loadfx( "misc/blood_throat_stab" );
level._effect[ "knife_attack_throat_fx2" ] = loadfx( "misc/blood_throat_stab2" );
level._effect["player_hydroplane"] = loadfx("water/splash_player_hydroplane_castle");
level._effect["tv_castle_makarov"] = loadfx("misc/tv_castle_makarov");
level._effect["tv_castle_makarov_small"] = loadfx("misc/tv_castle_makarov_small");
level._effect["tv_castle_security_4up"] = loadfx("misc/tv_castle_security_4up");
level._effect["tv_castle_security_cycle"] = loadfx("misc/tv_castle_security_cycle");
level._effect["tv_castle_security_random"] = loadfx("misc/tv_castle_security_random");
level._effect[ "flashlight_ai" ] = LoadFX( "misc/flashlight_spotlight_castle" );
level._effect[ "flashlight_ai_grate" ]	= LoadFX( "misc/flashlight_spotlight_grate_castle" );
level._effect[ "flashlight_ai_cheap" ]	= LoadFX( "misc/flashlight_cheap_castle" );
level._effect[ "bulb_glow" ] = LoadFX( "maps/castle/castle_lightbulb_glow" );
level._effect[ "bulb_glow_white" ] = LoadFX( "maps/castle/castle_lightbulb_white" );
level._effect[ "gen_lamp_glow_white" ] = LoadFX( "maps/castle/castle_gen_lamp_glow" );
level._effect[ "light_crawl_fill" ] = LoadFX( "maps/castle/castle_light_crawl_fill" );
level._effect["spotlight_modern_rain"]	= loadfx("lights/lights_spotlight_modern_rain_hvy");
level._effect["spotlight_modern_rain_lt"]	= loadfx("lights/lights_spotlight_modern_rain_lt");
level._effect["spotlight_modern_rain_br"]	= loadfx("lights/lights_spotlight_modern_rain_br");
level._effect["light_spot_innercourt"] = loadfx("maps/castle/castle_spot_inner");
level._effect["spotlight_modern_rain_lt_cheap"]	= loadfx("lights/lights_spotlight_modern_rain_lt_cheap");
level._effect["spotlight_destroy"] = LoadFX("props/spotlight_modern_dest");
level._effect[ "spotlight_dlight" ] = loadfx( "lights/spotlight_uaz_headlights_castle" );
level._effect[ "uaz_taillight" ] = loadfx( "misc/car_taillight_uaz_castle" );
level._effect[ "car_headlight_beam_50_percent" ] = loadfx( "misc/car_headlight_beam_50_percent" );
level._effect[ "castle_truck_damage_moving" ] = loadfx( "maps/castle/castle_truck_damage_moving" );
level._effect[ "lightning" ] = LoadFX( "weather/lightning" );
level._effect[ "lightning_bolt" ] = LoadFX( "weather/lightning_bolt" );
level._effect[ "lightning_bolt_fast" ]	= LoadFX( "weather/lightning_bolt_fast" );
level._effect[ "lightning_bolt_slow" ]	= LoadFX( "weather/lightning_bolt_slow" );
level._effect["fullscreen_fire_death"] = LoadFX("fire/fullscreen_fire_death");
level._effect[ "fire_tree_embers" ] = LoadFX( "fire/fire_tree_embers" );
level._effect[ "rain1" ]	= LoadFX( "weather/rain_drizzle_castle" );
level._effect[ "rain2" ]	= LoadFX( "weather/rain_light_castle" );
level._effect[ "rain3" ]	= LoadFX( "weather/rain_med1_castle" );
level._effect[ "rain4" ]	= LoadFX( "weather/rain_med2_castle" );
level._effect[ "rain5" ]	= LoadFX( "weather/rain_heavy_castle" );
level._effect[ "rain6" ]	= LoadFX( "weather/rain_heavy_mist_castle" );
level._effect[ "rain7" ]	= LoadFX( "weather/rain_heavy_mist_castle_always" );
level._effect[ "fx_rain_box1000_castle" ] = LoadFX( "weather/fx_rain_box1000_castle" );
level._effect[ "fx_rain_box2000_castle" ] = LoadFX( "weather/fx_rain_box2000_castle" );
level._effect[ "fx_rain_box4000_castle" ] = LoadFX( "weather/fx_rain_box4000_castle" );
level._effect[ "fx_rain_box200x500_castle" ] = LoadFX( "weather/fx_rain_box200x500_castle" );
level._effect[ "fx_rain_box250x250_castle" ] = LoadFX( "weather/fx_rain_box250x250_castle" );
level._effect[ "fx_rain_box500x500_castle" ] = LoadFX( "weather/fx_rain_box500x500_castle" );
level._effect[ "wind_rush_chute" ]	= LoadFX( "misc/wind_rush_chute" );
level._effect["cigarette_lit"] = loadfx("smoke/cigarette_lit");
level._effect["cigarette_off"] = loadfx("smoke/cigarette_off");
createfx_ambient_fx();
level.forestFireEffectsOn = true;
thread spire_destroy();
thread bridge_destroy();
thread generator_destroy_fx();
if ( !getdvarint( "r_reflectionProbeGenerate" ) )
maps\createfx\castle_fx::main();
level thread convertOneShot();
}
createfx_ambient_fx()
{
level._effect["fx_field_fire_smolder_250x250"] = loadfx("fire/field_fire_smolder_250x250");
level._effect["fx_field_fire_smolder_500x500"] = loadfx("fire/field_fire_smolder_500x500");
level._effect["fx_fire_field_patch_md"] = loadfx("fire/fire_field_patch_md");
level._effect["fx_fire_field_patch_lg"] = loadfx("fire/fire_field_patch_lg");
level._effect["fx_field_embers_lg"] = loadfx("fire/field_embers_lg");
level._effect["fx_bird_flock_large_left"] = loadfx("animals/bird_flock_large_left");
level._effect["fx_bird_flock_large_right"] = loadfx("animals/bird_flock_large_right");
level._effect["castle_int_haze"] = loadfx("maps/castle/castle_int_haze");
level._effect["fx_bats_tree_panicked"] = loadfx("animals/bats_tree_panicked");
level._effect["fx_chute_landing_impact"] = loadfx("impacts/chute_landing_impact");
level._effect["fx_rain_splash_drizzle_100x200"] = loadfx("weather/rain_splash_drizzle_100x200");
level._effect["fx_rain_splash_drizzle_256x256"] = loadfx("weather/rain_splash_drizzle_256x256");
level._effect["fx_rain_splash_drizzle_128x128"] = loadfx("weather/rain_splash_drizzle_128x128");
level._effect["fx_rain_splash_drizzle_64x64"] = loadfx("weather/rain_splash_drizzle_64x64");
level._effect["fx_rain_splash_drizzle_16x128"] = loadfx("weather/rain_splash_drizzle_16x128");
level._effect["fx_rain_splash_drizzle_8x64"] = loadfx("weather/rain_splash_drizzle_8x64");
level._effect["fx_rain_splash_drizzle_16x64"] = loadfx("weather/rain_splash_drizzle_16x64");
level._effect["fx_rain_splash_drizzle_8x32"] = loadfx("weather/rain_splash_drizzle_8x32");
level._effect["fx_water_drips_edge_short"] = loadfx("water/water_drips_edge_short");
level._effect["fx_water_drips_edge_shorter"] = loadfx("water/water_drips_edge_shorter");
level._effect["fx_rain_splash_puddles_md"] = loadfx("weather/rain_splash_puddles_md");
level._effect["fx_heli_hover_rainy_surface"] = loadfx("misc/heli_hover_rainy_surface");
level._effect["castle_water_drop"] = loadfx("maps/castle/castle_water_drop");
level._effect["castle_wet_footstep"] = loadfx("maps/castle/castle_wet_footstep");
level._effect["castle_culvert_water"] = loadfx("maps/castle/castle_culvert_water");
level._effect["fx_lights_stadium"] = loadfx("lights/lights_stadium_castle");
level._effect["fx_lights_stadium_drizzle"] = loadfx("lights/lights_stadium_drizzle_castle");
level._effect["fx_lights_stadium_ir"] = loadfx("lights/lights_stadium_ir");
level._effect["fx_lights_strobe_red"] = loadfx("lights/lights_strobe_red_castle");
level._effect["fx_water_drips_grate_castle"] = loadfx("water/water_drips_grate_castle");
level._effect["fx_water_drips_grate_line_castle"]	= loadfx("water/water_drips_grate_line_castle");
level._effect["fx_rain_splash_heavy_50x50"] = loadfx("weather/rain_splash_heavy_50x50");
level._effect["fx_rain_splash_heavy_100x200"] = loadfx("weather/rain_splash_heavy_100x200");
level._effect["fx_rain_splash_heavy_200x200"] = loadfx("weather/rain_splash_heavy_200x200");
level._effect["fx_rain_splash_heavy_300x300"] = loadfx("weather/rain_splash_heavy_300x300");
level._effect["fx_rain_splash_heavy_helipad"] = loadfx("weather/rain_splash_heavy_helipad");
level._effect["fx_lights_uplight_rain"] = loadfx("lights/lights_uplight_rain");
level._effect["fx_light_biometric_lock_red"] = loadfx("lights/light_biometric_lock_red");
level._effect["fx_light_biometric_lock_green"] = loadfx("lights/light_biometric_lock_green");
level._effect["fx_jumper_cable_sparks"] = loadfx("misc/jumper_cable_sparks");
level._effect["fx_water_drips_hallway"] = loadfx("water/water_drips_hallway");
level._effect["fx_ground_fog_sm_castle"] = loadfx("weather/ground_fog_sm_castle");
level._effect["fx_light_drip_short"] = loadfx("water/light_drip_short");
level._effect["fx_light_drip_long"] = loadfx("water/light_drip_long");
level._effect["fx_light_drip_splash"] = loadfx("water/light_drip_splash");
level._effect["fx_light_drip_splash_floor"] = loadfx("water/light_drip_splash_floor");
level._effect["castle_amb_smoke"] = loadfx("maps/castle/castle_amb_smoke");
level._effect["fx_flare_trail"] = loadfx("misc/flare_trail");
level._effect["fx_flare_ambient"] = loadfx("misc/flare_ambient_flat_btm");
level._effect["castle_int_flare_haze"] = loadfx("maps/castle/castle_int_flare_haze");
level._effect["castle_int_flare_haze_static"] = loadfx("maps/castle/castle_int_flare_haze_st");
level._effect[ "castle_prison_godrays" ] = loadFX( "maps/castle/castle_prison_godrays" );
level._effect[ "castle_mist_filler" ] = loadFX( "maps/castle/castle_mist_filler" );
level._effect[ "castle_mist_waterfall" ] = loadFX( "maps/castle/castle_mist_waterfall" );
level._effect[ "castle_haze_bridge" ] = loadFX( "maps/castle/castle_haze_bridge" );
level._effect["fx_bridge_dust_fall_wet_castle"] = loadfx("dust/bridge_dust_fall_wet_castle");
level._effect["fx_bridge_dust_crumble_after_castle"]	= loadfx("dust/bridge_dust_crumble_after_castle");
level._effect["fx_waterfall_drainage_castle"] = loadfx("water/waterfall_drainage_castle");
level._effect["fx_waterfall_drainage_short_castle"]	= loadfx("water/waterfall_drainage_short_castle");
level._effect["fx_waterfall_splash_medium"] = loadfx("water/waterfall_splash_medium");
level._effect["fx_waterfall_drainage_splash"] = loadfx("water/waterfall_drainage_splash_castle");
level._effect["fx_waterfall_drainage_thin_castle"]	= loadfx("water/waterfall_drainage_thin_castle");
level._effect["fx_edge_drip_light_short"] = loadfx("water/edge_drip_light_short");
level._effect["fx_edge_drip_light_splash"] = loadfx("water/edge_drip_light_splash");
level._effect["fx_glow_stick_green"] = loadfx("maps/castle/castle_stick_green");
level._effect["fx_glow_stick_white"] = loadfx("maps/castle/castle_stick_white");
level._effect["fx_lightbeam_square"] = loadfx("maps/castle/castle_square_beam");
level._effect["fx_lightbeam_square_short"] = loadfx("maps/castle/castle_square_beam_short");
level._effect["fx_lightbeam_square_wide"] = loadfx("maps/castle/castle_square_beam_wide");
level._effect["castle_bridge_smoke"] = loadfx("maps/castle/castle_bridge_smoke");
level._effect["fx_breach_wall_concrete_detcord"]	= loadfx("explosions/breach_wall_concrete_detcord");
level._effect["fx_bullet_wall_exit_group_castle"]	= loadfx("impacts/bullet_wall_exit_group_castle");
level._effect["fx_insects_flies_wall_castle"] = loadfx("animals/insects_flies_wall_castle");
level._effect["fx_water_drips_singlestream_dirty_castle"]	= loadfx("water/water_drips_singlestream_dirty_castle");
level._effect["fx_water_drips_wall_dirty_castle"]	= loadfx("water/water_drips_wall_dirty_castle");
level._effect["fx_window_drip_shadow"] = loadfx("water/window_drip_shadow");
level._effect["fx_window_drip_shadow_side"] = loadfx("water/window_drip_shadow_side");
level._effect["fx_window_drip_shadow_top"] = loadfx("water/window_drip_shadow_top");
level._effect["fx_window_drip_pane"] = loadfx("water/window_drip_pane");
level._effect["castle_wetwall_haze"] = loadfx("maps/castle/castle_wetwall_haze");
level._effect["castle_wetwall_grenade"] = loadfx("maps/castle/castle_wetwall_grenade");
level._effect["castle_wetwall_godrays"] = loadfx("maps/castle/castle_wetwall_godrays");
level._effect["fx_kitchen_wall_collapse_castle"]	= loadfx("breakables/kitchen_wall_collapse_castle");
level._effect["fx_wall_bust_dust_linger_castle"]	= loadfx("dust/wall_bust_dust_linger_castle");
level._effect["fx_french_fry_oil"] = loadfx("misc/french_fry_oil");
level._effect["fx_drips_faucet_slow"] = loadfx("water/drips_faucet_slow");
level._effect["fx_refrigerator_vapor"] = loadfx("props/refrigerator_vapor");
level._effect["fx_cold_fog_freezer_room"] = loadfx("smoke/cold_fog_freezer_room");
level._effect["fx_cold_fog_door_outpour"] = loadfx("smoke/cold_fog_door_outpour");
level._effect["fx_stovetop_flareup"] = loadfx("props/stovetop_flareup");
level._effect["castle_kitchen_haze"] = loadfx("maps/castle/castle_kitchen_haze");
level._effect["castle_round_ceiling"] = loadfx("maps/castle/castle_round_ceiling");
level._effect[ "candle" ] = loadFX( "maps/castle/candle_castle" );
level._effect[ "candlelight" ] = loadFX( "maps/castle/castle_candle_light" );
level._effect[ "ambient_dust" ] = loadFX( "maps/castle/castle_amb_dust" );
level._effect["fx_rain_window_castle"] = loadfx("weather/rain_window_castle");
level._effect["fx_spire_impact_initial_castle"] = loadfx("dust/spire_impact_initial_castle");
level._effect["fx_spire_impact_castle"] = loadfx("dust/spire_impact_castle");
level._effect["fx_spire_hit"] = loadfx("breakables/spire_hit");
level._effect["fx_rpg_spire"] = loadfx("maps/castle/castle_spire_rpg_impact");
level._effect["fx_low_fog"] = loadfx("maps/castle/castle_low_fog");
level._effect["fx_low_fog_light"] = loadfx("maps/castle/castle_low_fog_lt");
level._effect[ "chandelier_glow" ] = loadFX( "maps/castle/castle_chnd_glow" );
level._effect[ "light_sconce" ] = loadFX( "maps/castle/castle_light_sconce" );
level._effect[ "light_lamp_tall" ] = loadFX( "maps/castle/castle_lamp_tall" );
level._effect[ "light_lamp_tall_dust" ] = loadFX( "maps/castle/castle_lamp_tall_dust" );
level._effect["fx_c4_exp_supplies_castle"] = loadfx("explosions/c4_exp_supplies_castle");
level._effect["fx_vehicle_explosion_bm21"] = loadfx("maps/castle/castle_c4_courtyard");
level._effect["fx_bridge_explode"] = loadfx("explosions/bridge_exp_castle");
level._effect["fx_bridge_dust_btr_slide"] = loadfx("dust/bridge_dust_btr_slide");
level._effect["fx_bridge_dust_edge_runner"] = loadfx("dust/bridge_dust_edge_runner");
level._effect["fx_castle_truck_gate_impact"] = loadfx("maps/castle/castle_truck_gate_impact");
level._effect["fx_castle_fence_impact"] = loadfx("maps/castle/castle_fence_impact");
level._effect["fx_castle_brick_impact"] = loadfx("maps/castle/castle_brick_impact");
level._effect["fx_castle_truck_fence_impact"] = loadfx("maps/castle/castle_truck_fence_impact");
level._effect["fx_jeep_explosion"] = loadfx("maps/castle/castle_jeep_explode");
level._effect["fx_lights_cliff"] = loadfx("maps/castle/castle_lights_cliff");
level._effect["fx_waterfall_base_sm_castle"] = loadfx("water/waterfall_base_sm_castle");
level._effect["fx_waterfall_base_md_castle"] = loadfx("water/waterfall_base_md_castle");
level._effect["fx_waterfall_splash_falling_lg"] = loadfx("water/waterfall_splash_falling_lg");
level._effect["fx_rapids_splash_sm_castle"] = loadfx("water/rapids_splash_sm_castle");
level._effect["fx_rapids_splash_md_castle"] = loadfx("water/rapids_splash_md_castle");
level._effect["fx_rapids_splash_md_fast_castle"]	= loadfx("water/rapids_splash_md_fast_castle");
level._effect["fx_waterfall_splash_bounce_md"] = loadfx("water/waterfall_splash_bounce_md");
level._effect["fx_river_splash_small_castle"] = loadfx("water/river_splash_small_castle");
level._effect["fx_river_splash_lg_castle"] = loadfx("water/river_splash_lg_castle");
level._effect["fx_rapids_splash_xlg_fast_castle"]	= loadfx("water/rapids_splash_xlg_fast_castle");
}
delete_fx_later( fx, fxName )
{
wait 10.0;
StopFXOnTag( level._effect[ fxName ], fx, "TAG_ORIGIN" );
wait 10.0;
fx delete();
}
rotate_vector( vector, rotation )
{
right = anglestoright( rotation ) * -1;
forward = anglestoforward( rotation );
up = anglestoup( rotation );
new_vector = forward * vector[ 0 ] + right * vector[ 1 ] + up * vector[ 2 ];
return new_vector;
}
monitor_player_speed()
{
prevPlayerPosition = level.player.origin;
loopInterval = 1.0;
while( !flag( "stop_embers_above_player" ) )
{
playerPosition = level.player.origin;
distance2D = Distance2D( prevPlayerPosition, playerPosition );
level.player_speed = distance2D / loopInterval;
wait loopInterval;
prevPlayerPosition = playerPosition;
}
}
embers_above_player( fxName, relativeToThis, offsetRelative )
{
thread monitor_player_speed();
while (1)
{
flag_clear( "start_embers_above_player" );
flag_wait( "start_embers_above_player" );
flag_clear( "stop_embers_above_player" );
while( !flag( "stop_embers_above_player" ) )
{
playerAngles = level.player GetPlayerAngles();
offsetRelativeWithPredict = offsetRelative;
predictVector = ( level.player_speed * 3.0, 0, 0 );
offsetRelativeWithPredict += predictVector;
offsetAbsolute = rotate_vector( offsetRelativeWithPredict, playerAngles );
origin = relativeToThis.origin + offsetAbsolute;
fx = spawn( "script_model", origin );
fx.angles = relativeToThis.angles;
fx setmodel( "tag_origin" );
playfxontag( level._effect[ fxName ], fx, "TAG_ORIGIN" );
wait 3.0;
thread delete_fx_later( fx, fxName );
}
}
}
pause_forest_fire_fx()
{
forest_fx_radii = getentarray( "forest_fx_radius", "script_noteworthy" );
if(isdefined(forest_fx_radii))
{
array_thread( forest_fx_radii, ::disable_fx_in_radius );
}
}
disable_fx_in_radius()
{
radius = squared( self.radius );
foreach ( fx in level.createFXent )
{
if( distancesquared( fx.v[ "origin" ], self.origin ) < radius )
{
if ( isdefined(fx.looper) )
{
fx.looper delete();
}
}
}
level.forestFireEffectsOn = false;
}
restart_forest_fire_fx()
{
forest_fx_radii = getentarray( "forest_fx_radius", "script_noteworthy" );
if(isdefined(forest_fx_radii))
{
array_thread( forest_fx_radii, ::enable_fx_in_radius );
}
}
enable_fx_in_radius()
{
radius = squared( self.radius );
foreach ( fx in level.createFXent )
{
if( distancesquared( fx.v[ "origin" ], self.origin ) < radius )
{
if ( fx.v[ "type" ] == "loopfx" )
fx thread loopfxthread();
if ( fx.v[ "type" ] == "oneshotfx" )
fx thread oneshotfxthread();
if ( fx.v[ "type" ] == "soundfx" )
fx thread create_loopsound();
if ( fx.v[ "type" ] == "soundfx_interval" )
fx thread create_interval_sound();
}
}
level.forestFireEffectsOn = true;
}
monitor_forest_fire_fx()
{
wait 0.1;
while ( 1 )
{
flag_wait_any( "forest_fire_effects_on", "forest_fire_effects_off" );
if ( level.forestFireEffectsOn )
{
flag_clear( "forest_fire_effects_on" );
if ( flag( "forest_fire_effects_off" ) )
{
pause_forest_fire_fx();
flag_clear( "forest_fire_effects_off" );
}
}
else
{
flag_clear( "forest_fire_effects_off" );
if ( flag( "forest_fire_effects_on" ) )
{
wait 0.5;
restart_forest_fire_fx();
flag_clear( "forest_fire_effects_on" );
}
}
}
}
tree_fire_light(lightId)
{
light = GetEnt( lightId, "script_noteworthy" );
if( !isdefined( light ) )
return;
ang_range = ( 6, 6, 6);
org_range = ( 44, 44, 0 );
flare_offset = ( 50, 32, 64);
dir = 1;
original_origin = light.origin;
original_angles = light.angles;
while ( 1 )
{
delay = RandomFloatRange( 0.4, 0.7 );
if ( RandomInt( 50 ) > 25 )
dir *= -1;
light moveto( original_origin + ( 0, 0, -64 ), .1 ) ;
wait .1;
light MoveTo( original_origin + ( dir * org_range ) + flare_offset, delay );
if ( RandomInt( 50 ) > 25 )
dir *= -1;
light RotateTo( original_angles + ( dir * ang_range ), delay );
wait delay-.05;
}
random_x = 30;
random_y = 200;
random_z = 25;
min_delay = 0.8;
max_delay = 1.6;
}
#using_animtree( "script_model" );
bridge_destroy()
{
level waittill( "bridge_destroy" );
exploder( 1401 );
bridge = GetEnt( "fxanim_castle_bridge_mod", "targetname" );
bridge Show();
bridge UseAnimTree( #animtree );
bridge.animname = "bridge";
scaffolding = GetEnt( "fxanim_castle_bridge_scaff_mod", "targetname" );
scaffolding.animname = "bridge_scaffolding";
scaffolding UseAnimTree( #animtree );
bridge thread bridge_dust_fx();
bridge SetAnim( %fxanim_castle_bridge_anim );
scaffolding SetAnim( %fxanim_castle_bridge_scaff_anim );
a_bridge = GetEntArray( "bridge_good", "targetname" );
foreach ( part in a_bridge )
{
part Delete();
}
a_bridge = GetEntArray( "bridge_bad", "targetname" );
foreach ( part in a_bridge )
{
part Show();
}
wait 3;
exploder( 1404 );
}
bridge_dust_fx()
{
dust_fx = getfx( "bridge_chunk_trail" );
PlayFXOnTag( dust_fx, self, "bridge_chunk_003_jnt" );
PlayFXOnTag( dust_fx, self, "bridge_chunk_007_jnt" );
PlayFXOnTag( dust_fx, self, "bridge_chunk_042_jnt" );
PlayFXOnTag( dust_fx, self, "bridge_chunk_056_jnt" );
wait 3.5;
StopFXOnTag( dust_fx, self, "bridge_chunk_003_jnt" );
StopFXOnTag( dust_fx, self, "bridge_chunk_007_jnt" );
StopFXOnTag( dust_fx, self, "bridge_chunk_042_jnt" );
StopFXOnTag( dust_fx, self, "bridge_chunk_056_jnt" );
}
spire_destroy()
{
damage_trigger = GetEnt( "spire_damage", "targetname" );
damage_trigger trigger_off();
level waittill( "destroy_spire" );
damage_trigger maps\_utility::delayThread( 1.8, ::trigger_on );
spire = GetEnt( "fxanim_castle_spire_mod", "targetname" );
spire UseAnimTree( #animtree );
spire.animname = "spire";
spire SetFlaggedAnim( "spire", %fxanim_castle_spire_anim );
spire waittillmatch( "spire", "spire_hit" );
level notify( "spire_hit_ground" );
damage_trigger Delete();
}
generator_destroy_fx()
{
generators = GetEntArray( "fxanim_castle_generator_mod", "targetname" );
for(i = 0; i < generators.size; i++)
{
generators[i] thread wait_for_damage_to_play_fx();
}
}
wait_for_damage_to_play_fx()
{
self SetCanDamage(true);
self waittill("damage");
PlayFXOnTag(level._effect["generator_spark" ], self, "tag_fx_spark_1");
PlayFXOnTag(level._effect["generator_spark" ], self, "tag_fx_spark_2");
}
	
