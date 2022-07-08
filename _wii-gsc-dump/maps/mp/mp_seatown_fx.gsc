main()
{

//ambient fx

	level._effect[ "sand_spray_detail_oriented_runner_mp_dome" ]		= loadfx( "dust/sand_spray_detail_oriented_runner_mp_dome" );
	level._effect[ "battlefield_smokebank_S_warm" ]									= loadfx( "smoke/battlefield_smokebank_S_warm" );
//	level._effect[ "dust_wind_fast_paper" ]													= loadfx( "dust/dust_wind_fast_paper" );
	level._effect[ "trash_spiral_runner" ]													= loadfx( "misc/trash_spiral_runner" );
	level._effect[ "room_dust_200_mp_seatown" ]											= loadfx( "dust/room_dust_200_blend_mp_seatown" );	
	level._effect[ "ceiling_smoke_seatown" ]												= loadfx( "weather/ceiling_smoke_seatown" );
	level._effect[ "insects_carcass_flies" ] 												= loadfx( "misc/insects_carcass_flies" );
//	level._effect[ "spark_fall_runner_mp" ] 			                  = loadfx( "explosions/spark_fall_runner_mp" );
	level._effect[ "seatown_lookout_splash_runner" ] 								= loadfx( "water/seatown_lookout_splash_runner" );
	level._effect[ "seatown_pillar_mist" ] 													= loadfx( "water/seatown_pillar_mist" );
	level._effect[ "palm_leaves" ] 		         											= loadfx( "misc/palm_leaves" );
	level._effect[ "falling_dirt_frequent_runner" ] 								= loadfx( "dust/falling_dirt_frequent_runner" );
	level._effect[ "flocking_birds_mp" ] 					    							= loadfx( "misc/flocking_birds_mp" );
//	level._effect[ "insects_light_hunted_a_mp" ] 		  							= loadfx( "misc/insects_light_hunted_a_mp" );
	level._effect[ "firelp_small_cheap_mp" ] 		      							= loadfx( "fire/firelp_small_cheap_mp" );
//	level._effect[ "car_fire_mp" ] 		                							= loadfx( "fire/car_fire_mp" );
//	level._effect[ "bg_smoke_plume" ] 		            							= loadfx( "smoke/bg_smoke_plume" );
	level._effect[ "room_dust_200_blend_seatown_wind_fast" ]							= loadfx( "dust/room_dust_200_blend_seatown_wind_fast" );	
	
/#		
	if ( getdvar( "clientSideEffects", "1" ) != "1" )
		maps\createfx\mp_seatown_fx::main();
#/		

}

