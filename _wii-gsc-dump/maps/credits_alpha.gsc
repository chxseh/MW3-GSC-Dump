#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_credits;
main()
{
template_level( "credits_alpha" );
maps\createart\credits_alpha_art::main();
maps\credits_alpha_fx::main();
maps\credits_alpha_precache::main();
maps\_load::main();
initCredits("none");
if ( getdvar( "ui_char_museum_mode" ) == "credits_black" )
{
level.black = create_client_overlay( "black", 1 );
}
level.player allowcrouch( false );
level.player allowprone( false );
level.player TakeAllWeapons();
level.player DisableWeapons();
level.player FreezeControls( true );
addCenterName( "Placeholder Credits" );
addGap();
addCenterName( "Placeholder Person A" );
addCenterName( "Placeholder Person B" );
addCenterName( "Placeholder Person C" );
playCredits();
wait 30;
nextmission();
}
