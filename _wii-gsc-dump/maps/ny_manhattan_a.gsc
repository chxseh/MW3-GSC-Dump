#include maps\_utility;
#include common_scripts\utility;
main()
{
level.createFXFunc = maps\createfx\ny_manhattan_a_fx::main;
level.mainFXFunc = maps\ny_manhattan_a_fx::main;
stryker_infantry = GetEntArray( "stryker_infantry", "targetname" );
foreach( guy in stryker_infantry )
{
if( !IsSpawner( guy ) )
{
continue;
}
if( Distance2D( guy.origin, ( -5327.2, 568.7, -115.8 ) ) < 1 )
{
guy Delete();
continue;
}
if( Distance2D( guy.origin, ( -5296.4, 485.8, -111.9 ) ) < 1 )
{
guy Delete();
continue;
}
if( Distance2D( guy.origin, ( -5440, 640, -120 ) ) < 1 )
{
guy Delete();
continue;
}
}
baddies_spawners = GetSpawnerTeamArray( "axis" );
foreach( possibleRider in baddies_spawners )
{
if( Distance2D( possibleRider.origin, ( -416.0, -784.0, 1876.0 ) ) < 1 || Distance2D( possibleRider.origin, ( -352.0, -832.0, 1876.0 ) ) < 1 )
{
possibleRider Delete();
}
}
maps\ny_manhattan::main();
SetSavedDvar( "ai_count", 24 );
}