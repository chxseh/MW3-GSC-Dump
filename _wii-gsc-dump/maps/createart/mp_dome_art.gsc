// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 

	//* Fog section * 

	if (!using_wii())
	{
		setDevDvar( "scr_fog_disable", "0" );

		setExpFog( 0, 0, 0.278, 0.345, 0.482, 1.0, 0 );
	}
	VisionSetNaked( "mp_dome", 0 );

}
