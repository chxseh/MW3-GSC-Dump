main()
{
	
/#
    if ( getdvar( "clientSideEffects", "1" ) != "1" )
        maps\createfx\mp_hardhat_fx::main();
#/


	level._effect[ "large_vehicle_explosion_ir" ] 					= loadfx( "explosions/large_vehicle_explosion_ir" );
	level._effect[ "vehicle_explosion_btr80" ] 						= loadfx( "explosions/vehicle_explosion_btr80" );
	level._effect[ "falling_dirt_light_1_runner_bravo" ] 			= loadfx( "dust/falling_dirt_light_1_runner_bravo" );
	level._effect[ "ash_prague" ] 									= loadfx( "weather/ash_prague" );
	level._effect[ "embers_prague_light" ] 							= loadfx( "weather/embers_prague_light" );
	level._effect[ "bg_smoke_plume_mp" ] 							= loadfx( "smoke/bg_smoke_plume_mp" );
	level._effect[ "white_battle_smoke" ] 							= loadfx( "smoke/white_battle_smoke" );
	level._effect[ "hallway_smoke_light" ] 							= loadfx( "smoke/hallway_smoke_light" );
	level._effect[ "room_smoke_400" ] 								= loadfx( "smoke/room_smoke_400" );
	level._effect[ "smoke_plume_grey_01" ] 							= loadfx( "smoke/smoke_plume_grey_01" );
	level._effect[ "smoke_plume_grey_02" ] 							= loadfx( "smoke/smoke_plume_grey_02" );
	level._effect[ "light_glow_white_lamp" ] 						= loadfx( "misc/light_glow_white_lamp" );
	level._effect[ "falling_ash_mp" ] 								= loadfx( "misc/falling_ash_mp" );
	level._effect[ "trash_spiral_runner" ] 							= loadfx( "misc/trash_spiral_runner" );
//	level._effect[ "antiair_runner_cloudy" ] 						= loadfx( "misc/antiair_runner_cloudy" );
	level._effect[ "moth_runner" ] 									= loadfx( "misc/moth_runner" );
	level._effect[ "firelp_small_cheap_mp" ] 						= loadfx( "fire/firelp_small_cheap_mp" );
	level._effect[ "car_fire_mp_far" ] 									= loadfx( "fire/car_fire_mp_far" );
	level._effect[ "dust_cloud_mp_hardhat" ] 						= loadfx( "dust/dust_cloud_mp_hardhat" );
	level._effect[ "sand_spray_detail_oriented_runner_hardhat" ] 	= loadfx( "dust/sand_spray_detail_oriented_runner_hardhat" );
	level._effect[ "dust_spiral_runner_small" ] 					= loadfx( "dust/dust_spiral_runner_small" );
	level._effect[ "building_missilehit_runner" ] 					= loadfx( "explosions/building_missilehit_runner" );

}
