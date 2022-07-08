#include maps\_utility;
#include common_scripts\utility;
#using_animtree ( "generic_human" );
pip_init()
{
level.scr_anim[ "generic" ][ "setup_pose" ] = %casual_stand_idle;
level.pip = level.player newpip();
level.pip.enable = 0;
}
ac130_pip_init(ent, shoulder_cam, optional_offset, optional_fov)
{
if( using_wii() )
{
return;
}
if(issentient(ent))
{
ent.current_animname = ent.animname;
ent.animname = "generic";
ent maps\_anim::anim_first_frame_solo(ent, "setup_pose");
if(!isDefined (shoulder_cam) )
{
spot = get_world_relative_offset(ent.origin, ent.angles, (12, 0, 0) );
eye = ent geteye();
cam = spawn ("script_model", (spot[0], spot[1], eye[2]) );
cam setmodel ("tag_origin");
cam.angles = ent.angles;
cam linkto(ent, "j_neck" );
}
else
{
offset = (-14, -14, 63);
spot = get_world_relative_offset(ent.origin, ent.angles, offset);
cam = spawn ("script_model", spot );
cam setmodel ("tag_origin");
cam.angles = ent.angles +(0, 6.8, 0);
cam linkto(ent, "j_neck" );
}
ent thread maps\_anim::anim_single_solo ( ent, "setup_pose" );
ent delaycall(.05, ::setanimtime, %casual_stand_idle, .99);
ent.animname = ent.current_animnam;
}
else
{
if(isdefined(optional_offset))
{
spot = ent.origin + optional_offset;
cam = spawn ("script_model", spot);
}
else
{
cam = spawn ("script_model", ent.origin);
}
cam setmodel ("tag_origin");
cam.angles = ent.angles;
cam linkto(ent);
}
level.pip.enable = 1;
level.pip.freeCamera = true;
level.pip.entity = cam;
level.pip.fov = ter_op(isdefined(optional_fov), optional_fov, 50);
is_wide_screen = GetDvarInt( "widescreen", 1 );
inv_standard_aspect_ratio	= 3 / 4;
level.pip_ai_cam = ent;
level.pip.closed_width = 16;
level.pip.opened_width = ter_op( is_wide_screen, 220, 130 );
level.pip.closed_height = ter_op( is_wide_screen, 135, Int( Floor( inv_standard_aspect_ratio * level.pip.opened_width ) ) );
level.pip.opened_height = ter_op( is_wide_screen, 135, Int( Floor( inv_standard_aspect_ratio * level.pip.opened_width ) ) );
level.pip.opened_x = ter_op( is_wide_screen, 490, 475 );
level.pip.opened_y = ter_op( is_wide_screen, 15, 30 );
level.pip.closed_x = level.pip.opened_x + ( level.pip.opened_width * 0.5 ) - ( level.pip.closed_width * 0.5 );
level.pip.closed_y = level.pip.opened_y;
level.pip.border_thickness = 2;
level.pip.enableshadows = false;
level.pip.tag = "tag_origin";
level.pip.x = level.pip.closed_x;
level.pip.y = level.pip.closed_y;
level.pip.width = level.pip.closed_width;
level.pip.height = level.pip.closed_height;
level.pip.visionsetnaked = "paris_ac130_pip";
x = level.pip.closed_x;
y = level.pip.closed_y;
level.pip.borders[ "top_left" ] = new_L_pip_corner( x, y, "top_left" );
level.pip.borders[ "top_right" ] = new_L_pip_corner( x, y, "top_right" );
level.pip.borders[ "bottom_left" ] = new_L_pip_corner( x, y, "bottom_left" );
level.pip.borders[ "bottom_right" ] = new_L_pip_corner( x, y, "bottom_right" );
level.player thread play_sound_on_entity ("sp_eog_summary");
level thread pip_static();
level thread pip_open();
level thread pip_display_timer();
level thread pip_border();
level thread pip_static_lines();
if(isdefined(level.pip_ai_cam.name) )
{
level thread pip_display_name();
}
}
pip_toggle_ai_cam(ai_array)
{
NotifyOnCommand( "toggle_pip_cam" , "+actionslot 4" );
while(1)
{
foreach(guy in ai_array)
{
level.player waittill( "toggle_pip_cam" );
ent = spawn ("script_model", guy.origin );
ent setmodel ("tag_origin");
ent.angles = guy.angles;
ent linkto(guy, "j_head", (-13, -12, 64), (0,0,0) );
level.pip.entity = ent;
level.pip_ai_cam = guy;
wait(.20);
}
}
}
pip_display_name()
{
level.pip_display_name = NewHudElem();
level.pip_display_name.alpha = 1;
level.pip_display_name.x = level.pip.opened_x +15;
level.pip_display_name.y = level.pip.opened_y +1;
level.pip_display_name.hidewheninmenu = false;
level.pip_display_name.hidewhendead = true;
level.pip_display_name.fontscale = 1.5;
level.pip_display_name.font = "objective";
level.pip_display_name settext(level.pip_ai_cam.name);
while(1)
{
level.player waittill( "toggle_pip_cam" );
wait(.10);
level.pip_display_name settext( (level.pip_ai_cam.name) );
}
}
pip_display_timer()
{
level.pip_timer = level.player maps\_hud_util::createClientTimer("objective", 1.5);
level.pip_timer.alpha = 1;
level.pip_timer.x = level.pip.opened_x +200;
level.pip_timer.y = level.pip.opened_y +82;
level.pip_timer.hidewheninmenu = false;
level.pip_timer.hidewhendead = true;
level.pip_timer settenthstimerup( 0.00 ) ;
}
pip_static()
{
hud = NewHudElem();
hud.alpha = 1;
hud.sort = -50;
hud.x = level.pip.opened_x;
hud.y = level.pip.opened_y;
hud.hidewheninmenu = false;
hud.hidewhendead = true;
hud SetShader( "overlay_static", level.pip.opened_width, level.pip.opened_height );
level.pip.static_overlay = hud;
}
pip_static_lines()
{
level.pip endon( "stop_interference" );
level.pip.line_a = NewHudElem();
level.pip.line_a.alpha = 1;
level.pip.line_a.sort = -50;
level.pip.line_a.x = level.pip.opened_x;
level.pip.line_a.y = level.pip.opened_y;
level.pip.line_a.hidewheninmenu = false;
level.pip.line_a.hidewhendead = true;
lines=[];
lines[0] = "ac130_overlay_pip_static_a";
lines[1] = "ac130_overlay_pip_static_b";
lines[2] = "ac130_overlay_pip_static_c";
lines = array_randomize(lines);
level thread random_line_flicker();
level thread random_line_placement();
pip_height = 135;
random_fraction = randomfloatrange(.10, .35);
while(1)
{
level.pip.line_a SetShader( random( lines ), level.pip.opened_width, int( pip_height*random_fraction ) );
wait(.05);
}
}
random_line_flicker()
{
level.pip endon( "stop_interference" );
while ( 1 )
{
time = RandomFloatRange( .05, .08 );
alpha = RandomFloatRange( 0.1, 0.8 );
level.pip.line_a FadeOverTime( time );
level.pip.line_a.alpha = alpha;
wait( time );
if(randomint(100) > 50)
{
time = RandomFloatRange( .25, .4 );
level.pip.line_a FadeOverTime( time );
level.pip.line_a.alpha = 0;
wait( time );
}
}
}
random_line_placement()
{
level.pip endon( "stop_interference" );
while(1)
{
num = randomintrange(10, 110);
level.pip.line_a.y = num;
wait( randomfloatrange(.05, .4) );
}
}
pip_border()
{
hud = NewHudElem();
hud.alpha = 1;
hud.sort = -50;
hud.x = level.pip.opened_x;
hud.y = level.pip.opened_y;
hud.hidewheninmenu = false;
hud.hidewhendead = true;
hud SetShader( "ac130_overlay_pip_vignette", level.pip.opened_width, level.pip.opened_height );
level.pip.border = hud;
}
pip_interference()
{
level.pip endon( "stop_interference" );
while ( 1 )
{
time = RandomFloatRange( 0.1, 1 );
delay = time + RandomFloatRange( 0.1, 0.4 );
alpha = RandomFloatRange( 0.1, 0.2 );
level.pip.static_overlay FadeOverTime( time );
level.pip.static_overlay.alpha = alpha;
wait( delay );
time = RandomFloatRange( 0.5, 0.75 );
delay = time + RandomFloatRange( 0.5, 1.5 );
level.pip.static_overlay FadeOverTime( time );
level.pip.static_overlay.alpha = 0.3;
wait( delay );
}
}
pip_open()
{
time = 0.1;
foreach( i, border in level.pip.borders )
{
border thread pip_open_L_corner( i, time );
}
wait( time + 0.05 );
level.pip.width = level.pip.opened_width;
level.pip.height = level.pip.opened_height;
level.pip.x = level.pip.opened_x;
level.pip.y = level.pip.opened_y;
level.pip.enable = true;
wait(.8);
level notify ("pip_in");
level.pip.static_overlay FadeOverTime(1);
level.pip.static_overlay.alpha = 0.2;
level thread pip_interference();
}
get_world_relative_offset( origin, angles, offset )
{
cos_yaw = cos( angles[ 1 ] );
sin_yaw = sin( angles[ 1 ] );
x = ( offset[ 0 ] * cos_yaw ) - ( offset[ 1 ] * sin_yaw );
y = ( offset[ 0 ] * sin_yaw ) + ( offset[ 1 ] * cos_yaw );
x += origin[ 0 ];
y += origin[ 1 ];
return ( x, y, origin[ 2 ] + offset[ 2 ] );
}
new_L_pip_corner( x, y, type )
{
width = level.pip.closed_width;
height = level.pip.closed_height;
struct = SpawnStruct();
thickness = level.pip.border_thickness;
l = 16;
if ( type == "top_left" )
{
v_align_x = "left";
v_align_y = "top";
h_align_x = "left";
h_align_y = "top";
x = x - thickness;
y = y - thickness;
}
else if ( type == "top_right" )
{
v_align_x = "left";
v_align_y = "top";
h_align_x = "right";
h_align_y = "top";
x = x + width + thickness - 1;
y = y - thickness;
}
else if ( type == "bottom_left" )
{
v_align_x = "left";
v_align_y = "bottom";
h_align_x = "left";
h_align_y = "bottom";
x = x - thickness;
y = y + height + thickness;
}
else
{
v_align_x = "left";
v_align_y = "bottom";
h_align_x = "right";
h_align_y = "bottom";
x = x + width + thickness - 1;
y = y + height + thickness;
}
hud = NewHudElem();
hud.alignx = v_align_x;
hud.aligny = v_align_y;
hud.x = x;
hud.y = y;
hud.hidewheninmenu = false;
hud.hidewhendead = true;
hud SetShader( "white", thickness, l );
struct.vertical = hud;
hud = NewHudElem();
hud.alignx = h_align_x;
hud.aligny = h_align_y;
hud.x = x;
hud.y = y;
hud.hidewheninmenu = false;
hud.hidewhendead = true;
hud SetShader( "white", l, thickness );
struct.horizontal = hud;
return struct;
}
pip_open_L_corner( index, time )
{
if ( index == "top_left" || index == "bottom_left" )
{
self.vertical MoveOverTime( time );
self.vertical.x = level.pip.opened_x;
self.horizontal MoveOverTime( time );
self.horizontal.x = level.pip.opened_x;
}
else
{
self.vertical MoveOverTime( time );
self.vertical.x = level.pip.opened_x + level.pip.opened_width;
self.horizontal MoveOverTime( time );
self.horizontal.x = level.pip.opened_x + level.pip.opened_width;
}
}
ac130_pip_close()
{
if( using_wii() )
{
return;
}
level.pip notify( "stop_interference" );
level.pip.static_overlay.alpha = 1;
wait(.5);
time = 0.25;
level.pip.enableshadows = true;
level.pip.static_overlay FadeOverTime( time );
level.pip.static_overlay.alpha = 1;
wait( time );
level.pip.enable = false;
if ( IsDefined( level.pip.linked_ent ) )
{
level.pip.linked_ent Delete();
}
time = 0.10;
foreach( i, border in level.pip.borders )
{
border thread pip_close_L_corner( i, time );
}
level.pip.static_overlay ScaleOverTime( time, level.pip.closed_width, level.pip.closed_height );
wait( time + 0.05 );
level.pip.width = level.pip.closed_width;
level.pip.height = level.pip.closed_height;
level.pip.x = level.pip.closed_x;
level.pip.y = level.pip.closed_y;
if ( IsDefined( level.pip.borders ) )
{
array_thread( level.pip.borders, ::pip_remove_L_corners );
}
level.pip.static_overlay Destroy();
if(IsDefined(level.pip_display_name) )
{
level.pip_display_name destroy();
}
if(IsDefined(level.pip_timer) )
{
level.pip_timer destroy();
}
if(IsDefined(level.pip.border) )
{
level.pip.border destroy();
}
if(IsDefined(level.pip.line_a) )
{
level.pip.line_a destroy();
}
level.pip.enable = 0;
}
pip_remove_L_corners()
{
self.vertical Destroy();
self.horizontal Destroy();
}
pip_close_L_corner( index, time )
{
if ( index == "top_left" || index == "bottom_left" )
{
self.vertical MoveOverTime( time );
self.vertical.x = level.pip.closed_x;
self.horizontal MoveOverTime( time );
self.horizontal.x = level.pip.closed_x;
}
else
{
self.vertical MoveOverTime( time );
self.vertical.x = level.pip.closed_x + level.pip.closed_width;
self.horizontal MoveOverTime( time );
self.horizontal.x = level.pip.closed_x + level.pip.closed_width;
}
}
Print3d_on_ent( msg )
{
}