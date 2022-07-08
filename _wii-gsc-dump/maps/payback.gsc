#include maps\_utility;
#include common_scripts\utility;
main()
{
template_level( "payback" );
if( !is_split_level() )
{
maps\payback_precache::main();
}
maps\sp_payback_precache::main();
if( !is_split_level() || !is_split_level_part("a") )
{
maps\payback_streets::init_streets_assets();
}
if( !is_split_level() || is_split_level_part("a") )
{
default_start( maps\payback_compound::start_compound );
}
else if( is_split_level_part("a2") )
{
default_start( maps\payback_streets::start_s2_city );
}
else if( is_split_level_part("b") )
{
default_start( maps\payback_sandstorm::start_sandstorm );
}
if( !is_split_level() || is_split_level_part("a") )
{
add_start( "s1_outer_compound", maps\payback_1_script_b::enter_compound );
add_start( "s1_main_compound", maps\payback_1_script_c::compound_c_jumpto );
add_start( "s1_interrogation", maps\payback_1_script_e::s1_interrogation_jumpto );
}
if( !is_split_level() )
{
add_start( "s2_city", maps\payback_streets::start_s2_city );
}
if( !is_split_level() || is_split_level_part("a2") )
{
add_start( "s2_postambush", maps\payback_streets::start_s2_postambush );
add_start( "s2_construction", maps\payback_streets_const::start_s2_construction );
add_start( "s2_rappel", maps\payback_streets_const::start_s2_rappel );
}
if( !is_split_level() )
{
add_start( "s2_sandstorm" , maps\payback_sandstorm::start_sandstorm );
}
if( !is_split_level() || is_split_level_part("b") )
{
add_start( "s3_rescue", maps\payback_rescue::start_s3_rescue );
add_start( "s3_escape", maps\payback_rescue::start_s3_escape );
}
maps\payback_main::main();
}
