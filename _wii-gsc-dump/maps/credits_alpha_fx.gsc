main()
{
level._effect[ "test_effect" ] = loadfx( "misc/moth_runner" );
if ( !getdvarint( "r_reflectionProbeGenerate" ) )
maps\createfx\credits_alpha_fx::main();
}
