#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\dubai_code;
#include maps\_audio;
setup_pip()
{
pip_video = true;
if( pip_video )
{
thread pip_video_scripting();
}
else
{
level.pip = level.player newpip();
level.pip.enable = 0;
level.pip.closetime = 0.5;
thread pip_scripting();
}
}
pip_init(ent, optional_fov )
{
cam = spawn ("script_model", ent.origin);
cam setmodel ("tag_origin");
cam.angles = ent.angles;
cam linkto(ent);
level.pip.enable = 1;
level.pip.freeCamera = true;
level.pip.entity = cam;
level.pip.foreground = true;
level.pip.fov = ter_op(isdefined(optional_fov), optional_fov, 50);
level.pip.ent_source = ent;
level.pip.closed_width = 16;
level.pip.opened_width = 220;
level.pip.closed_height = 135;
level.pip.opened_height = 135;
level.pip.opened_x = 490;
level.pip.opened_y = 25;
level.pip.closed_x = level.pip.opened_x + ( level.pip.opened_width * 0.5 ) - ( level.pip.closed_width * 0.5 );
level.pip.closed_y = level.pip.opened_y;
level.pip.border_thickness = 2;
level.pip.tag = "tag_origin";
level.pip.x = level.pip.closed_x;
level.pip.y = level.pip.closed_y;
level.pip.width = level.pip.closed_width;
level.pip.height = level.pip.closed_height;
x = level.pip.closed_x;
y = level.pip.closed_y;
level.player thread play_sound_on_entity ("sp_eog_summary");
level thread pip_static();
level thread pip_open();
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
level.pip.static_overlay.alpha = 0.2;
wait( delay );
}
}
pip_open()
{
time = 0.1;
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
pip_close()
{
level.pip notify( "stop_interference" );
level.pip.static_overlay.alpha = 1;
wait( level.pip.closetime );
time = 0.25;
level.pip.static_overlay FadeOverTime( time );
level.pip.static_overlay.alpha = 1;
wait( time );
level.pip.enable = false;
if ( IsDefined( level.pip.linked_ent ) )
{
level.pip.linked_ent Delete();
}
time = 0.10;
wait( time + 0.05 );
level.pip.width = level.pip.closed_width;
level.pip.height = level.pip.closed_height;
level.pip.x = level.pip.closed_x;
level.pip.y = level.pip.closed_y;
level.pip.static_overlay Destroy();
if(IsDefined(level.pip_display_name) )
{
level.pip_display_name destroy();
}
if(IsDefined(level.pip_timer) )
{
level.pip_timer destroy();
}
level.pip.enable = 0;
level notify( "pip_closed" );
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
pip_scripting()
{
pip_atrium_time = 8;
pip_lounge_time = 8;
pip_restaurant_time = 8;
pip_elevator_chopper_time = 5;
thread pip_cam( "pip_camera_atrium", 15, "pip_atrium_start", pip_atrium_time, ::pip_cam_atrium_scene );
thread pip_cam( "pip_camera_lounge", 7.5, "pip_lounge_start", pip_lounge_time, ::pip_cam_lounge_scene );
thread pip_cam( "pip_camera_restaurant", 10, "pip_restaurant_start", pip_restaurant_time, ::pip_cam_restaurant_scene );
test_pip = 0;
if( test_pip )
{
wait 1;
flag_set( "pip_atrium_start" );
wait pip_atrium_time + 1;
flag_set( "pip_lounge_start" );
wait pip_lounge_time + 1;
flag_set( "pip_restaurant_start" );
wait pip_restaurant_time + 1;
flag_set( "pip_elevator_chopper_start" );
wait pip_elevator_chopper_time + 1;
}
}
pip_cam( cam_targetname, fov, start_flag, duration, scene_func )
{
flag_wait( start_flag );
camera = getent( cam_targetname, "targetname" );
if( IsDefined( scene_func ) )
{
camera thread [[ scene_func ]]();
}
pip_init( camera, fov );
wait duration;
pip_close();
}
pip_cam_atrium_scene()
{
thread pip_cam_atrium_scene_makarov();
final_pitch = -15;
final_yaw = 35;
pitch_time = 8;
self rotateto( self.angles + (final_pitch, final_yaw, 0), pitch_time );
level waittill( "pip_in" );
array_spawn_function_targetname( "pip_atrium_npc", ::pip_cam_atrium_scene_ai_think );
array_spawn_targetname( "pip_atrium_npc" );
delaythread( 3, ::pip_zoom, 40, 5 );
level waittill( "pip_closed" );
}
pip_cam_atrium_scene_makarov()
{
makarov_start_ent = getent( "pip_makarov_pos_atrium", "targetname" );
makarov_spawner = getent( "pip_makarov", "targetname" );
if( makarov_spawner.count < 1 )
{
makarov_spawner.count++;
}
pip_makarov = makarov_spawner spawn_ai( true );
pip_makarov teleport( makarov_start_ent.origin );
pip_makarov forceuseweapon( "ak47", "primary" );
pip_makarov.animname = "makarov";
actors = [];
actors[actors.size] = pip_makarov;
makarov_start_ent thread anim_single( actors, "pip_scene_atrium" );
delayThread( 0.05, ::anim_set_time, actors, "pip_scene_atrium", 0.1 );
level waittill( "pip_in" );
level waittill( "pip_closed" );
pip_makarov delete();
}
pip_cam_atrium_scene_ai_think()
{
self.goalradius = 8;
self setgoalpos( self.origin );
if( IsDefined( self.script_delay ) )
wait( self.script_delay );
self.goalradius = 32;
self setgoalpos( (696, 643, 7776) );
self waittill( "goal" );
self delete();
}
pip_cam_lounge_scene()
{
thread pip_cam_lounge_scene_makarov();
thread exterior_civilian_drones_wave( 4, "civilians_atrium_initial" );
thread exterior_civilian_drones_wave( 4, "civilians_atrium" );
delaythread( 2, ::exterior_civilian_drones_wave, 4, "civilians_atrium" );
delaythread( 4, ::exterior_civilian_drones_wave, 4, "civilians_atrium" );
delaythread( 6, ::exterior_civilian_drones_wave, 4, "civilians_atrium" );
delaythread( 8, ::exterior_civilian_drones_wave, 4, "civilians_atrium" );
self delaycall( 3, ::rotateto, self.angles + ( -2, 20, 0), 9 );
delaythread( 2, ::pip_zoom, 22, 5 );
level waittill( "pip_in" );
level waittill( "pip_closed" );
}
pip_cam_lounge_scene_ai_think()
{
if( IsDefined( self.script_delay ) )
wait( self.script_delay );
guy = self spawn_ai();
guy.fixednode = true;
level waittill( "pip_closed" );
guy delete();
}
pip_cam_lounge_scene_makarov()
{
makarov_start_ent = getent( "pip_makarov_pos_lounge", "targetname" );
makarov_spawner = getent( "pip_makarov", "targetname" );
if( makarov_spawner.count < 1 )
{
makarov_spawner.count++;
}
pip_makarov = makarov_spawner spawn_ai( true );
pip_makarov teleport( (1022, -416, 7780), makarov_start_ent.angles );
pip_makarov.animname = "makarov";
pip_makarov forceuseweapon( "ak47", "primary" );
anime = "pip_scene_lounge";
makarov_start_ent anim_reach_solo( pip_makarov, anime );
pip_makarov.goalradius = 8;
pip_makarov setgoalpos( (235, -345, 7792) );
makarov_start_ent thread anim_single_solo_run( pip_makarov, anime );
level waittill( "pip_closed" );
pip_makarov delete();
}
pip_cam_restaurant_scene()
{
thread pip_cam_restaurant_scene_makarov();
delaythread( 2, ::pip_zoom, 22, 5 );
array_thread( getentarray( "pip_restaurant_npc", "targetname" ), ::pip_cam_restaurant_scene_ai_think );
thread pip_restaurant_npc_special( "pip_restaurant_npc_left", (-1012, -108, 7769), 2.5, "pip_restaurant_npc_left_goal_node" );
thread pip_restaurant_npc_special( "pip_restaurant_npc_right", (-952, -148, 7769), 4.25, "pip_restaurant_npc_right_goal_node" );
}
pip_cam_restaurant_scene_makarov()
{
makarov_start_ent = getent( "pip_makarov_pos_restaurant", "targetname" );
makarov_spawner = getent( "pip_makarov", "targetname" );
if( makarov_spawner.count < 1 )
{
makarov_spawner.count++;
}
pip_makarov = makarov_spawner spawn_ai( true );
pip_makarov teleport( (-984, -316, 7754), makarov_start_ent.angles );
pip_makarov forceuseweapon( "ak47", "primary" );
pip_makarov.animname = "makarov";
makarov_start_ent anim_reach_solo( pip_makarov, "pip_scene_restaurant" );
pip_makarov.goalradius = 8;
pip_makarov setgoalpos( (-876, 740, 7760) );
makarov_start_ent thread anim_single_solo_run( pip_makarov, "pip_scene_restaurant" );
level waittill( "pip_closed" );
pip_makarov delete();
}
pip_restaurant_npc_special( name, goal_initial, delay, goalnode_final )
{
guy = getent( name, "targetname" );
guy = guy spawn_ai( true );
guy disable_sprint();
guy setgoalpos( goal_initial );
guy.goalradius = 8;
guy.ignoreall = true;
wait delay;
guy setgoalnode( getnode( goalnode_final, "targetname" ) );
level waittill( "pip_closed" );
guy delete();
}
pip_cam_restaurant_scene_ai_think()
{
if( IsDefined( self.script_delay ) )
wait( self.script_delay );
guy = self spawn_ai( true );
guy.ignoreall = true;
guy.fixednode = true;
level waittill( "pip_closed" );
guy delete();
}
pip_zoom( new_fov, dur )
{
org_fov = level.pip.fov;
time_step = 0.05;
fov_step = (( new_fov - level.pip.fov ) * time_step ) / ( dur );
for( i = 0; i < dur; i += time_step )
{
level.pip.fov = level.pip.fov + fov_step;
wait time_step;
}
}
pip_video_scripting()
{
thread setup_pip_cinematic( "pip_atrium_start", "dubai_pip01" );
thread setup_pip_cinematic( "pip_lounge_start", "dubai_pip02" );
thread setup_pip_cinematic( "pip_restaurant_start", "dubai_pip03" );
test_pip = 0;
if( test_pip )
{
wait 1;
flag_set( "pip_atrium_start" );
wait 9;
flag_set( "pip_lounge_start" );
wait 9;
flag_set( "pip_restaurant_start" );
wait 9;
}
}
setup_pip_cinematic( flagName, cinematicName )
{
flag_wait( flagName );
SetSavedDvar( "cg_cinematicFullScreen", "0" );
hud_elem = NewHudElem();
hud_elem.x = 450;
hud_elem.y = 47;
hud_elem.horzAlign = "fullscreen";
hud_elem.vertAlign = "fullscreen";
hud_elem.sort = -1;
hud_elem SetShader("cinematic", 175, 170);
hud_elem.alpha = 1.0;
if (isdefined(level.current_cinematic))
{
assert(level.current_cinematic == cinematicName);
pauseCinematicInGame( 0 );
setsaveddvar("cg_cinematicFullScreen", "1");
level.current_cinematic = undefined;
}
else
{
cinematicingame( cinematicName );
aud_send_msg("aud_pip_open");
}
setsaveddvar("cg_cinematicCanPause", "1");
wait 1;
while( iscinematicplaying() )
{
wait .05;
}
aud_send_msg("aud_pip_close");
setsaveddvar("cg_cinematicCanPause", "0");
hud_elem destroy();
SetSavedDvar( "cg_cinematicFullScreen", "1" );
}