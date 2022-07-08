// _createart generated.  modify at your own risk. 
main()
{
	ent = maps\_utility::create_vision_set_fog( "mp_radar" );
	ent.startDist = 113.513;
	ent.halfwayDist = 2360.43;
	ent.red = 0.423529;
	ent.green = 0.46667;
	ent.blue = 0.572549;
	ent.maxOpacity = 0.885;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;

        ent = maps\_utility::create_vision_set_fog( "bunker_area" );
	ent.startDist = 731;
	ent.halfwayDist = 2370;
	ent.red = 0.423529;
	ent.green = 0.46667;
	ent.blue = 0.572549;
	ent.maxOpacity = 0.15;
	ent.transitionTime = 0;
	ent.sunFogEnabled = 0;
}
