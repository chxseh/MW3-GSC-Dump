
main()
{
models();
vehicles();
props();
generic_human();
destructibles();
}
#using_animtree( "generic_human" );
generic_human()
{
}
#using_animtree( "script_model" );
models()
{
level.scr_animtree[ "lamp" ] = #animtree;
level.scr_model[ "lamp" ] = "ch_industrial_light_animated_01_on";
level.scr_anim[ "lamp" ][ "swing" ] = %swinging_industrial_light_01_mild;
level.scr_anim[ "lamp" ][ "swing_dup" ] = %swinging_industrial_light_01_mild_dup;
level.scr_anim[ "lamp" ][ "swing_aggro" ] = %swinging_industrial_light_01_severe;
level.scr_anim[ "lamp" ][ "swing_root" ] = %root;
}
#using_animtree( "vehicles" );
vehicles()
{
}
#using_animtree( "animated_props" );
props()
{
}
#using_animtree( "player" );
player_anims()
{
}
#using_animtree( "destructibles" );
destructibles()
{
level.scr_animtree[ "tank_move_car" ] = #animtree;
level.scr_anim[ "tank_move_car" ][ "rock" ] = %vehicle_80s_sedan1_destroy;
level.scr_anim[ "tank_move_car" ][ "flat_tire" ] = %vehicle_80s_sedan1_flattire_RB;
level.scr_anim[ "tank_move_car" ][ "root" ] = %root;
}

