#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\_anim;
#include maps\castle_code;
#include maps\_audio;
start_kitchen_battle()
{
move_player_to_start( "start_kitchen_battle" );
setup_price_for_start( "start_kitchen_battle" );
maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
battlechatter_off( "axis" );
SetSavedDvar( "ai_count", 24 );
}
init_event_flags()
{
flag_init( "kitchen_start" );
flag_init( "launch_cart" );
flag_init( "cart_stopped" );
flag_init( "price_say_open_fire" );
}
kitchen_battle()
{
m_anim_wall = GetEnt( "fxanim_castle_kitchen_wall_mod", "targetname" );
m_anim_wall Hide();
flag_wait( "stop_peeping" );
level.price.baseaccuracy = 1;
level.price enable_pain();
level.price enable_surprise();
level.price enable_bulletwhizbyreaction();
level.price set_ignoreSuppression( false );
level.price.aggressivemode = false;
s_align = get_new_anim_node( "spiderclimb" );
s_align thread player_fall();
level.price thread price_kitchen_battle( s_align );
level.price thread price_kitchen_dialog();
level.price set_ai_bcvoice( "taskforce" );
array_spawn_function_targetname( "kitchen_guys_initial", ::kitchen_guy_setup );
flag_wait( "kitchen_start" );
t_fryer = GetEnt( "trig_fryer", "targetname" );
t_fryer thread fryer();
level thread fx_anims();
delayThread( 0.7, ::kitchen_wall, m_anim_wall );
level kitchen_battle_monitor();
}
kitchen_wall( m_anim_wall )
{
exploder( 1100 );
exploder( 1101 );
m_anim_wall Show();
m_anim_wall.animname = "kitchen_wall";
m_anim_wall assign_animtree();
m_anim_wall thread anim_single_solo( m_anim_wall, "crash_thru" );
aud_send_msg("player_crash_to_kitchen");
m_kitchen_destroyed = GetEntArray( "kitchen_wall_destroyed", "targetname" );
foreach( brush_model in m_kitchen_destroyed )
{
brush_model Show();
}
m_kitchen_full = GetEnt( "kitchen_wall_full", "targetname" );
m_kitchen_full Delete();
level.player ShellShock( "default", 1.5 );
level.player PlayRumbleOnEntity( "wii_damage_heavy" );
Earthquake( 1, 0.5, level.player.origin, 100 );
SetSlowMotion( 1.0, 0.25, 0.5 );
level.player EnableSlowAim();
wait 0.75;
a_pulse = getstructarray( "kitchen_pulse", "targetname" );
foreach( s_pulse in a_pulse )
{
RadiusDamage( s_pulse.origin, s_pulse.radius, 100, 100, level.player );
PhysicsExplosionSphere( s_pulse.origin, s_pulse.radius, s_pulse.radius, 1 );
}
maps\_autosave::_autosave_game_now_nochecks();
wait 1.25;
SetSlowMotion( 0.25, 1.0, 1.0 );
level.player DisableSlowAim();
}
player_fall()
{
PlayFX( level._effect["wall_fall_dust"], level.player.origin, AnglesToForward( self.angles ) );
exploder( 1010 );
if ( IsDefined( level.player.m_player_rig ) )
{
level.player PlayerLinkToAbsolute( level.player.m_player_rig, "tag_player" );
self anim_single_solo( level.player.m_player_rig, "wall_climb_peek_fall" );
}
else
{
self player_anim_start( "wall_climb_peek_fall", undefined, 0.0, true );
}
player_anim_cleanup( false );
ForceYellowDot(false);
battlechatter_on( "axis" );
level.player AllowCrouch( true );
level.player AllowProne( true );
}
#using_animtree( "generic_human" );
kitchen_guy_setup()
{
self.animname = self.script_noteworthy;
self set_allowdeath( true );
if( self.script_noteworthy == "kitchen_guy1" )
{
self thread kitchen_guy_front();
}
if ( self.script_noteworthy == "kitchen_guy5" )
{
self endon( "death" );
self add_damage_function( ::avoid_clipping_wall);
self magic_bullet_shield();
self.ignoreall = 1;
self waittill ("intro_over" );
wait 0.4;
if( !IsDefined( self.on_fire ))
{
self.on_fire = true;
self remove_damage_function( ::avoid_clipping_wall );
if( IsDefined( self.magic_bullet_shield) && self.magic_bullet_shield )
self stop_magic_bullet_shield();
}
self waittill( "goal" );
self.ignoreall = 0;
if( IsDefined( self.magic_bullet_shield) && self.magic_bullet_shield )
self stop_magic_bullet_shield();
}
else if ( self.script_noteworthy == "kitchen_guy6" )
{
self thread freezer_cart();
}
}
avoid_clipping_wall( damage, attacker, direction_vec, point, type, modelName, tagName )
{
t_fryer = GetEnt( "trig_fryer", "targetname" );
if( IsDefined( t_fryer ) && !IsDefined( self.on_fire) )
{
t_fryer notify( "trigger" );
}
self.health = 150;
angles = VectorToAngles( direction_vec );
forward = AnglesToForward( angles );
up = AnglesToUp( angles );
anglesReversed = VectorToAngles( direction_vec ) + ( 0, 180, 0 );
backward = AnglesToForward( anglesReversed );
PlayFX( getfx( "flesh_hit" ), point, backward, up );
}
kitchen_guy_front()
{
self endon( "death" );
flag_wait( "kitchen_start" );
self set_generic_deathanim( "kitchen_death" );
self waittill( "intro_over" );
self.allowdeath = true;
self Kill();
}
#using_animtree( "generic_human" );
price_kitchen_battle( s_align )
{
self disable_surprise();
flag_set( "price_say_open_fire" );
s_align anim_single_solo( self, "peep_show_fall" );
waitframe();
self ClearAnim( %root, 0 );
wait( 2 );
self enable_ai_color();
}
freezer_cart()
{
self endon( "death" );
m_cart = GetEnt( "freezer_cart", "targetname" );
m_cart_clip = GetEnt( "freezer_cart_clip", "targetname" );
m_cart_stuff = GetEntArray( "freezer_cart_food", "targetname" );
m_cart_clip LinkTo( m_cart );
foreach( m_item in m_cart_stuff )
{
m_item LinkTo( m_cart );
}
flag_wait( "launch_cart" );
aud_send_msg("enemy_roll_cart", m_cart);
m_cart thread launch_cart( m_cart_clip );
}
launch_cart( m_cart_clip )
{
self endon( "hit_player" );
self thread cart_clip_failsafe( m_cart_clip );
v_start = m_cart_clip.origin;
n_time = 2.0;
s_destination = GetStruct( "freezer_cart_dest", "targetname" );
self MoveTo( s_destination.origin, n_time, 0.1 );
self RotateTo( s_destination.angles, n_time, 0.1 );
m_cart_clip ConnectPaths();
self thread cart_hit_player( v_start, n_time, m_cart_clip );
wait 2.0;
aud_send_msg("cart_impact", self);
flag_set( "cart_stopped" );
v_backwards = m_cart_clip.origin - v_start;
v_backwards = ( v_backwards[0], v_backwards[1], 0 );
v_backwards = VectorNormalize(v_backwards) * 25;
self MoveTo( self.origin - v_backwards, 0.5, 0, 0.25 );
self RotateTo( self.angles, 0.5, 0, 0.25 );
m_cart_clip DisconnectPaths();
}
cart_hit_player( v_start, n_time, m_cart_clip )
{
n_timeout = GetTime() + (n_time * 1000);
b_cart_hit_player = false;
n_front_cos = cos(30);
while ( !flag( "cart_stopped" ) )
{
b_touched_player = m_cart_clip IsTouching( level.player );
if ( b_touched_player )
{
v_to_player = VectorNormalize( level.player.origin - m_cart_clip.origin );
b_cart_hit_player = VectorDot( AnglesToForward(self.angles), v_to_player ) < n_front_cos;
if ( b_cart_hit_player )
{
aud_send_msg("cart_impact", self);
self notify( "hit_player");
level.player DoDamage( 20, m_cart_clip.origin, m_cart_clip );
v_backwards = m_cart_clip.origin - v_start;
v_backwards = ( v_backwards[0], v_backwards[1], 0 );
v_backwards = VectorNormalize(v_backwards) * 25;
self MoveTo( self.origin - v_backwards, 0.5, 0, 0.25 );
self RotateTo( self.angles, 0.5, 0, 0.25 );
m_cart_clip DisconnectPaths();
flag_set( "cart_stopped" );
return;
}
}
waitframe();
}
}
cart_clip_failsafe( m_cart_clip )
{
level endon( "flash_grenade_spawn" );
flag_wait( "cart_stopped" );
setup = 1;
while( 1 )
{
while( m_cart_clip IsTouching( level.player ) )
{
if( setup )
{
setup = 0;
m_cart_clip NotSolid();
wait 1;
}
wait 0.1;
}
if( !setup )
{
setup = 1;
m_cart_clip Solid();
}
wait 0.25;
}
}
kitchen_battle_monitor()
{
t_kitchen_end = GetEnt( "trig_kitchen_to_stairs", "targetname" );
t_kitchen_end endon( "trigger" );
activate_trigger( "kitchen_guys_initial", "target" );
wait( 0.05 );
a_ai_kitchen_guys = get_ai_group_ai( "kitchen_guys" );
s_align = get_new_anim_node( "kitchen_battle" );
s_align anim_single( a_ai_kitchen_guys, "wall_break_react" );
array_notify( a_ai_kitchen_guys, "intro_over" );
waittill_dead_or_dying( a_ai_kitchen_guys, 3 );
activate_trigger( "trig_kitchen_wave2", "targetname" );
a_ai_enemies = GetAIArray( "axis" );
waittill_dead_or_dying( a_ai_enemies, a_ai_enemies.size );
t_kitchen_end activate_trigger();
}
price_kitchen_dialog()
{
battlechatter_off( "allies" );
flag_wait( "price_say_open_fire" );
wait 6.4;
self dialogue_queue( "castle_pri_onyourfeet" );
battlechatter_on( "allies" );
flag_wait( "price_kitchen_restdialog" );
self dialogue_queue( "castle_pri_inberlin" );
wait 0.2;
radio_dialogue( "castle_nik_contact" );
wait 0.2;
self dialogue_queue( "castle_pri_willbreak" );
wait 0.2;
radio_dialogue( "castle_nik_letyoudown" );
}
boiling_water_pot()
{
AssertEx( IsDefined(self.target), "boiling water damage trigger needs to target a struct for the FX" );
s_fx_origin = GetStruct( self.target, "targetname" );
v_fx_dir = AnglesToForward( (-90, 0, 0) );
e_fx = SpawnFx( getfx("boiling_pot"), s_fx_origin.origin, v_fx_dir );
TriggerFX( e_fx );
self waittill( "trigger" );
e_fx Delete();
v_fx_dir = AnglesToForward( (0, 0, 0) );
PlayFX( getfx("pot_water_splash"), s_fx_origin.origin, v_fx_dir );
}
fryer()
{
self waittill( "trigger" );
if( Distance2D( level.player.origin, self.origin ) < 64 )
{
level.player DoDamage( 50, self.origin );
}
exploder(1110);
s_align = get_new_anim_node( "kitchen_battle" );
a_ai = GetAIArray( "axis" );
foreach( ai_guy in a_ai )
{
if(IsDefined(ai_guy) && IsAlive(ai_guy) )
{
if ( Distance2D( ai_guy.origin, self.origin ) < 64 )
{
if( !IsDefined( ai_guy.magic_bullet_shield) || (!ai_guy.magic_bullet_shield) )
ai_guy magic_bullet_shield();
ai_guy.on_fire = true;
ai_guy thread on_fire();
ai_guy animscripts\shared::DropAIWeapon();
ai_guy.allowdeath = true;
s_align anim_generic( ai_guy, "catch_fire" );
if( IsDefined( ai_guy.magic_bullet_shield) && ai_guy.magic_bullet_shield )
ai_guy stop_magic_bullet_shield();
ai_guy notify( "stop_fire" );
ai_guy.a.nodeath = true;
ai_guy die();
}
}
}
}
on_fire()
{
self endon( "stop_fire" );
while( 1 )
{
PlayFXOnTag( getfx( "on_fire" ), self, "j_spine4" );
wait 0.1;
}
}
fx_anims()
{
a_m_meat = GetEntArray( "fxanim_castle_meat_large_mod", "targetname" );
foreach( m_meat in a_m_meat )
{
m_meat.animname = "meat";
m_meat assign_animtree();
m_meat thread anim_loop_solo( m_meat, "swing" );
wait( RandomFloatRange( 0.1, 1.0 ) );
}
}