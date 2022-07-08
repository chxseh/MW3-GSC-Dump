main()
{
/#
    if ( getdvar( "clientSideEffects", "1" ) != "1" )
        maps\createfx\mp_carbon_fx::main();
#/

	level._effect[ "dust_wind_fast_no_paper" ]				 		= loadfx( "dust/dust_wind_fast_no_paper" );
	level._effect[ "battlefield_smokebank_s_cheap_mp_carbon" ] 		= loadfx( "smoke/battlefield_smokebank_s_cheap_mp_carbon" );
	level._effect[ "hallway_smoke_light" ]			 				= loadfx( "smoke/hallway_smoke_light" );
	level._effect[ "room_smoke_200" ] 				 				= loadfx( "smoke/room_smoke_200" );
	level._effect[ "firelp_small_cheap_mp" ]			 			= loadfx( "fire/firelp_small_cheap_mp" );
	level._effect[ "smoke_plume_grey_01" ] 							= loadfx( "smoke/smoke_plume_grey_01" );
//	level._effect[ "steam_large_vent_rooftop" ] 					= loadfx( "smoke/steam_large_vent_rooftop" );
//	level._effect[ "steam_manhole" ] 								= loadfx( "smoke/steam_manhole" );
//	level._effect[ "steam_roof_ac" ] 								= loadfx( "smoke/steam_roof_ac" );
	level._effect[ "flame_refinery_far" ] 							= loadfx( "fire/flame_refinery_far" );
	level._effect[ "flame_refinery_small_far_2" ] 					= loadfx( "fire/flame_refinery_small_far_2" );
	level._effect[ "steam_cs_mp_carbon" ] 							= loadfx( "smoke/steam_cs_mp_carbon" );
//	level._effect[ "steam_jet_loop_cheap_mp_carbon" ] 				= loadfx( "smoke/steam_jet_loop_cheap_mp_carbon" );
//	level._effect[ "bootleg_alley_steam" ] 							= loadfx( "smoke/bootleg_alley_steam" );

}
