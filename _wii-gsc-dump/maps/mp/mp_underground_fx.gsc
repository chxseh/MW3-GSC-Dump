main()
{
//	level._effect[ "test_effect" ]										= loadfx( "misc/moth_runner" );
/#
    if ( getdvar( "clientSideEffects", "1" ) != "1" )
        maps\createfx\mp_underground_fx::main();
#/

//ambient fx
	level._effect[ "falling_dirt_frequent_runner" ] 					= loadfx( "dust/falling_dirt_frequent_runner" );
//	level._effect[ "dust_wind_fast_paper" ]								    = loadfx( "dust/dust_wind_fast_paper" );
//	level._effect[ "dust_wind_slow_paper" ]								    = loadfx( "dust/dust_wind_slow_paper" );
	level._effect[ "trash_spiral_runner" ]								    = loadfx( "misc/trash_spiral_runner" );
//  level._effect[ "room_dust_200_blend_mp_vacant" ]					= loadfx( "dust/room_dust_200_blend_mp_vacant" );	
  level._effect[ "insects_carcass_flies" ] 		      				= loadfx( "misc/insects_carcass_flies" );	
//	level._effect[ "spark_fall_runner_mp" ] 		              = loadfx( "explosions/spark_fall_runner_mp" );
  level._effect[ "embers_prague_light" ]								            = loadfx( "weather/embers_prague_light" );
  level._effect[ "thin_black_smoke_s_fast" ] 		                    = loadfx( "smoke/thin_black_smoke_s_fast" );
	level._effect[ "steam_manhole" ] 		                              = loadfx( "smoke/steam_manhole" );
//	level._effect[ "battlefield_smokebank_S_warm_dense" ] 		        = loadfx( "smoke/battlefield_smokebank_S_warm_dense" );
//  level._effect[ "building_hole_smoke_mp" ] 		                    = loadfx( "smoke/building_hole_smoke_mp" );
	level._effect[ "firelp_small_cheap_mp" ] 		              		    = loadfx( "fire/firelp_small_cheap_mp" );
	level._effect[ "falling_ash_mp" ] 		            				        = loadfx( "misc/falling_ash_mp" );	
//	level._effect[ "insects_light_hunted_a_mp" ] 		                  = loadfx( "misc/insects_light_hunted_a_mp" );
	level._effect[ "bootleg_alley_steam" ] 		                        = loadfx( "smoke/bootleg_alley_steam" );
//	level._effect[ "building_hole_paper_fall_mp" ] 		      				  = loadfx( "misc/building_hole_paper_fall_mp" );
//	level._effect[ "ground_fog_mp" ] 		      				                = loadfx( "weather/ground_fog_mp" );
	level._effect[ "leaves_fall_gentlewind_green" ]								    = loadfx( "misc/leaves_fall_gentlewind_green" );
//	level._effect[ "chimney_smoke_mp" ] 		                          = loadfx( "smoke/chimney_smoke_mp" );
//	level._effect[ "oil_drip_puddle" ]								                = loadfx( "misc/oil_drip_puddle" );
//	level._effect[ "antiair_runner_cloudy" ]								          = loadfx( "misc/antiair_runner_cloudy" );
	level._effect[ "large_battle_smoke_mp" ] 		                      = loadfx( "smoke/large_battle_smoke_mp" );
//	level._effect[ "light_glow_white" ] 		      				            = loadfx( "misc/light_glow_white" );	
  level._effect[ "room_dust_200_z150_mp" ]							            = loadfx( "dust/room_dust_200_z150_mp" );	
	level._effect[ "chimney_smoke_large_mp" ] 		                    = loadfx( "smoke/chimney_smoke_large_mp" );	
	level._effect[ "building_hole_embers_mp" ] 		                    = loadfx( "fire/building_hole_embers_mp" );	
	
}
