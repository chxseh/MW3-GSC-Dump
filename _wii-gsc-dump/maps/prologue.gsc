#include maps\_utility;
main()
{
PreCacheShader( "cinematic" );
maps\_load::main();
thread temp_blackscreen();
thread hide_player_hud();
wait(0.07);
nextmission();
}
temp_blackscreen()
{
overlay = newHudElem();
overlay.x = 0;
overlay.y = 0;
overlay setshader( "black", 640, 480 );
overlay.alignX = "left";
overlay.alignY = "top";
overlay.horzAlign = "fullscreen";
overlay.vertAlign = "fullscreen";
overlay.alpha = 1;
overlay.sort = 2;
}
hide_player_hud()
{
SetSavedDvar( "ui_hidemap", 1 );
SetSavedDvar( "hud_showStance", "0" );
SetSavedDvar( "compass", "0" );
SetDvar( "old_compass", "0" );
SetSavedDvar( "ammoCounterHide", "1" );
SetSavedDvar( "cg_drawCrosshair", 0 );
}