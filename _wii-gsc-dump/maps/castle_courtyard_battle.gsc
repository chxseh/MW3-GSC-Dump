#include common_scripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#include maps\castle_code;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_audio;
#include maps\_stealth_utility;
start_bridge_explode()
{
move_player_to_start( "start_bridge_explode" );
setup_price_for_start( "start_bridge_explode" );
level.price place_weapon_on( "mp5", "right" );
level.price.grenadeammo = 3;
level.price.baseaccuracy = 10;
level.price.aggressivemode = true;
level.price disable_danger_react();
level.price disable_surprise();
level.price set_ignoreall( true );
maps\_utility::vision_set_fog_changes( "castle_interior", 0 );
SetSavedDvar( "ai_count", 24 );
}
start_courtyard_battle()
{
move_player_to_start( "start_courtyard_battle" );
setup_price_for_start( "start_courtyard_battle" );
set_rain_level( 2 );
exploder( 507 );
exploder( 508 );
exploder( 509 );
level.bridge_mantle = GetEnt("inner_courtyard_mantle","targetname");
level.price place_weapon_on( "mp5", "right" );
level.price.grenadeammo = 3;
level.price.baseaccuracy = 1;
level.price enable_pain();
level.price enable_surprise();
level.price enable_bulletwhizbyreaction();
level.price set_ignoreSuppression( false );
level.price.aggressivemode = false;
level.price enable_danger_react( 3 );
level.player GiveWeapon( "ump45_acog" );
level.player SwitchToWeaponImmediate( "ump45_acog" );
flag_set( "bridge_price_kill_done" );
maps\_utility::vision_set_fog_changes( "castle_exterior", 0 );
SetSavedDvar( "ai_count", 24 );
}
bridge_explode_main()
{
show_bridge_objects();
set_rain_level( 2 );
level notify( "security_office_closed" );
stop_exploder( 501 );
stop_exploder( 502 );
stop_exploder( 503 );
stop_exploder( 504 );
stop_exploder( 505 );
stop_exploder( 506 );
stop_exploder( 530 );
exploder ( 5000 );
exploder( 507 );
exploder( 508 );
exploder( 509 );
level.bridge_clip = GetEnt("outer_courtyard_playerclip","targetname");
level.bridge_clip Solid();
level.player thread player_jump();
level.player thread player_give_c4();
level.price thread price_overlook();
level.price thread price_bridge();
level thread bridge_entrance();
level thread bridge_spotlight();
flag_wait( "bridge_detonated" );
}
courtyard_battle_main()
{
enable_battle_triggers();
add_global_spawn_function( "axis", ::set_baseaccuracy, 0.3 );
level.price.baseaccuracy = 1;
level.price enable_pain();
level.price enable_surprise();
level.price enable_bulletwhizbyreaction();
level.price set_ignoreSuppression( false );
level.price.aggressivemode = false;
level thread maps\castle_escape_new::setup_escape_truck();
level.player thread player_zone_check();
level.price thread price_courtyard();
level thread courtyard_spotlight();
level thread outer_courtyard_gate();
level thread courtyard_btr_think();
level thread turn_off_lights_under_bridge();
flag_wait( "get_to_escape_truck" );
}
turn_off_lights_under_bridge()
{
flag_wait( "turn_off_lights_under_bridge" );
bridgeunder_lights = GetEntArray( "bridgeunder_lights", "targetname" );
foreach( bridgeunder_light in bridgeunder_lights )
{
bridgeunder_light SetLightIntensity( 0.1 );
}
}
courtyard_spotlight()
{
road_spotlight = GetEnt( "road_spotlight", "targetname" );
if( IsDefined( road_spotlight.dead ) )
{
return;
}
PlayFXOnTag( getfx( "spotlight_modern_rain_lt_cheap" ), road_spotlight, "tag_light" );
road_spotlight SetMode( "manual" );
road_spotlight SetModel( "ctl_spotlight_modern_3x_on" );
road_spotlight MakeTurretInoperable();
e_target = GetEnt( "outer_courtyard_spotlight_target", "targetname" );
road_spotlight SetTargetEntity( e_target );
road_spotlight thread courtyard_spotlight_death();
}
courtyard_spotlight_death()
{
trigger_wait_targetname( self.target );
PlayFXOnTag( getfx( "spotlight_destroy" ), self, "tag_origin" );
StopFXOnTag( getfx( "spotlight_modern_rain_lt_cheap" ), self, "tag_light" );
self SetModel( "ctl_spotlight_modern_3x_destroyed" );
}
init_event_flags()
{
flag_init( "give_bridge_detonator" );
flag_init( "start_bridge_entrance" );
flag_init( "jumped_to_bridge" );
flag_init( "bridge_player_fired" );
flag_init( "bridge_detonated" );
flag_init( "bridge_price_kill" );
flag_init( "bridge_price_kill_done" );
flag_init( "ccb_player_entered_cy" );
flag_init( "ccb_begin_driveout" );
flag_init( "15second_delay");
flag_init( "ccb_btr_inposition" );
flag_init( "courtyard_btr_alive" );
flag_init( "courtyard_btr_destroyed" );
flag_init("get_to_escape_truck");
flag_init("price_in_truck");
}
player_jump()
{
flag_wait( "jumped_to_bridge" );
aud_send_msg("player_jumped_to_bridge");
flag_set( "re_start_water_splash_fx" );
self.old_weapon = self GetCurrentWeapon();
disable_stealth_system();
level.player AllowCrouch( false );
level.player AllowProne( false );
s_anim_align = get_new_anim_node( "castle_bridge" );
s_anim_align thread do_player_anim( "bridge_jump", undefined, true, 0.5 );
wait 0.5;
self PlayRumbleOnEntity( "wii_damage_heavy" );
Earthquake( 1.0, 0.5, level.player.origin, 2000 );
if( !flag( "bridge_detonated" ) )
{
}
s_anim_align waittill( "bridge_jump" );
level.player AllowCrouch( true );
level.player AllowProne( true );
if ( self HasWeapon( self.old_weapon ) )
{
self switchtoweapon( self.old_weapon );
}
else
{
self switchtoweapon( self GetWeaponsListPrimaries()[ 0 ] );
}
if( !flag( "bridge_detonated" ) )
{
level.price thread dialogue_queue( "castle_pri_detonate" );
flag_wait( "bridge_detonated" );
level.price thread dialogue_queue( "castle_pri_sloppybastard" );
}
}
handle_bridge_jump( player_rig )
{
level.player EnableWeapons();
}
player_give_c4()
{
flag_wait( "give_bridge_detonator" );
self maps\_c4::switch_to_detonator();
self thread player_spotted_timer();
self waittill( "detonate" );
if( isDefined( level.m_bridge_bomb ))
{
level.m_bridge_bomb Delete();
}
flag_set( "bridge_detonated" );
level notify( "bridge_destroy" );
Earthquake( 0.4, 0.8, level.player.origin, 2000 );
self PlayRumbleOnEntity( "wii_damage_heavy" );
self thread maps\_c4::remove_detonator();
level.bridge_clip NotSolid();
}
player_spotted_timer()
{
level endon( "bridge_detonated" );
wait 8;
flag_set( "bridge_player_fired" );
}
player_stealth_break()
{
level endon( "bridge_detonated" );
while ( !self IsFiring() && !self IsThrowingGrenade() )
{
wait 0.05;
}
flag_set( "bridge_player_fired" );
level.price set_ignoreall( false );
}
player_zone_check()
{
debug_zone = false;
self.zone = 1;
zone_1 = GetEnt( "courtyard_zone_1", "targetname" );
zone_2 = GetEnt( "courtyard_zone_2", "targetname" );
zone_3 = GetEnt( "courtyard_zone_3", "targetname" );
hud_zone = newHudElem();
hud_zone.foreground = true;
hud_zone.alignX = "left";
hud_zone.alignY = "top";
hud_zone.horzAlign = "left";
hud_zone.vertAlign = "top";
hud_zone.x = -20;
hud_zone.y = -20;
hud_zone.fontScale = 1.5;
hud_zone.color = ( 0.8, 1.0, 0.8 );
hud_zone.glowColor = ( 0.3, 0.6, 0.3 );
hud_zone.glowAlpha = 1;
hud_zone.hidewheninmenu = true;
while( !flag( "courtyard_btr_destroyed" ) )
{
if( self IsTouching( zone_1 ) )
{
self.zone = 1;
}
else if( self IsTouching( zone_2 ) )
{
self.zone = 2;
}
else if( self IsTouching( zone_3 ) )
{
self.zone = 3;
}
wait .1;
if( debug_zone )
{
hud_zone SetText( "Zone " + self.zone );
}
}
hud_zone Destroy();
}
price_overlook()
{
level endon( "jumped_to_bridge" );
s_anim_align = get_new_anim_node( "bridge_overlook" );
self.s_anim_align = s_anim_align;
self set_ignoreall( true );
autosave_by_name( "end_inner_courtyard" );
level.player delayThread( 2.0, ::player_stealth_break );
s_anim_align anim_reach_solo( self, "overlook_intro" );
self thread dialogue_queue("castle_pri_justintime");
s_anim_align anim_single_solo( self, "overlook_intro" );
s_anim_align thread anim_loop_solo( self, "overlook_idle" );
flag_wait( "give_bridge_detonator" );
if( !flag( "bridge_detonated" ) )
{
self thread dialogue_queue( "castle_pri_doit" );
s_anim_align notify( "stop_loop" );
s_anim_align anim_single_solo( self, "overlook_talk" );
s_anim_align thread anim_loop_solo( self, "overlook_idle" );
if( !flag( "bridge_detonated" ) )
{
self thread price_overlook_nag( s_anim_align );
}
flag_wait_any( "bridge_detonated" , "jumped_to_bridge");
}
s_anim_align notify( "stop_loop" );
self anim_stopanimscripted();
brush = getent( "after_explosion_pathclip", "targetname" );
brush DisconnectPaths();
if( !flag( "bridge_player_fired" ) )
{
self thread dialogue_queue( "castle_pri_move4" );
}
self enable_ai_color();
self set_force_color("g");
activate_trigger_with_targetname( "price_move_bridge_jump" );
self.goalradius = 32;
s_anim_align anim_single_solo_run( self, "overlook_exit" );
self waittill( "goal" );
self thread dialogue_queue( "castle_pri_jumpgo" );
}
price_overlook_nag( s_anim_align )
{
level endon( "bridge_detonated" );
level endon( "jumped_to_bridge" );
while( true )
{
wait 6;
s_anim_align notify( "stop_loop" );
self thread dialogue_queue( "castle_pri_detonate" );
s_anim_align anim_single_solo( self, "overlook_nag" );
s_anim_align thread anim_loop_solo( self, "overlook_idle" );
}
}
price_bridge()
{
flag_wait( "jumped_to_bridge" );
self set_ignoreall( false );
self.s_anim_align notify( "stop_loop" );
self anim_stopanimscripted();
level.player.maxvisibledist = 8196;
level.price.maxvisibledist = 8196;
wait 2.5;
s_price_pos = GetStruct( "price_bridge_jump", "targetname" );
self ForceTeleport( s_price_pos.origin, s_price_pos.angles );
if( flag( "bridge_detonated" ) )
{
s_anim_align = get_new_anim_node( "castle_bridge" );
s_anim_align anim_reach_solo( self, "bridge_idle" );
s_anim_align thread anim_loop_solo( self, "bridge_idle");
flag_wait_all( "bridge_price_kill", "bridge_detonated" );
s_anim_align notify( "stop_loop" );
flag_set( "bridge_price_kill_done" );
}
else
{
self SetGoalNode( self FindBestCoverNode() );
flag_wait( "bridge_detonated" );
wait 8.0;
flag_set( "bridge_price_kill_done" );
ai_victim = GetEnt( "price_kill", "script_noteworthy" );
if( IsDefined( ai_victim ) && IsAlive( ai_victim ) )
{
ai_victim Kill();
}
}
autosave_by_name( "approaching_outer_courtyard" );
}
price_bridge_skip()
{
level endon( "bridge_price_kill_done" );
while( true )
{
if( level.player.origin[1] < level.price.origin[1] )
{
if( !player_can_see_ai( level.price ) )
{
level notify( "skip_price_bridge" );
level.price anim_stopanimscripted();
return;
}
}
waitframe();
}
}
enemy_bridge_kill()
{
self endon( "death" );
self flashlight_off();
self set_deathanim( "bridge_deadloop" );
self thread enemy_bridge_kill_watch();
self.s_anim_align notify( "stop_loop" );
self animscripts\shared::DropAIWeapon();
self.s_anim_align anim_single_solo( self, "bridge_death" );
self Kill();
}
enemy_bridge_kill_watch()
{
self endon( "stop_watch" );
self waittill( "death" );
level notify( "skip_price_bridge" );
}
aggressively_load_ai( vehicle_load_ai )
{
foreach( guy in vehicle_load_ai )
{
guy.attackeraccuracy = 0;
guy.fixednode = true;
guy.accuracy = 1;
guy set_ignoresuppression( true );
guy.grenadeawareness = 0;
guy.disablebulletwhizbyreaction = true;
guy.takedamage = false;
guy.suppressionwait = 0;
guy.ignoreExplosionEvents = true;
guy.ignoreSuppression = true;
guy PushPlayer( true );
guy disable_pain();
guy disable_surprise();
guy.a.disableLongDeath = true;
guy.disablefriendlyfirereaction = true;
guy.dontmelee = true;
guy.old_pathenemyfightdist = guy.pathenemyfightdist;
guy.old_pathenemylookahead = guy.pathenemylookahead;
guy.old_maxfaceenemydist = guy.maxfaceenemydist;
guy.pathenemyfightdist = 0;
guy.pathenemylookahead = 0;
guy.maxfaceenemydist = 32;
guy.disableReactionAnims = true;
}
self thread vehicle_load_ai( vehicle_load_ai );
}
price_courtyard()
{
flag_wait( "bridge_price_kill_done" );
self anim_stopanimscripted();
self disable_pain();
self disable_bulletwhizbyreaction();
self set_ignoreSuppression( true );
self disable_cqbwalk();
level.price enable_ai_color();
flag_wait( "ccb_player_entered_cy" );
self thread price_courtyard_vo();
trigger_wait_targetname( "spawn_courtyard_btr" );
wait 22;
self thread courtyard_auto_kill( "price_kill" );
self enable_sprint();
thread price_waiting_for_player();
guys[0] = level.price;
level.price.ignoreall = true;
level.escape_truck aggressively_load_ai(guys);
level.price thread price_enter_vehicle_sound();
while( Length(level.escape_truck GetTagOrigin("tag_driver") - level.price.origin)> 300)
{
wait 0.05;
}
flag_set("get_to_escape_truck");
level.price waittill("enteredvehicle");
level.price.ignoreme = true;
level.price thread maps\castle_escape_new::price_idles_in_truck();
aud_send_msg("price_in_truck");
wait 1.0;
flag_set("price_in_truck");
level.btr_target = level.player;
self disable_sprint();
self enable_ai_color();
flag_wait( "courtyard_btr_destroyed" );
battlechatter_off( "allies" );
colors = GetEntArray( "courtyard_battle_color", "targetname" );
foreach( trigger in colors )
{
trigger Delete();
}
activate_trigger_with_targetname( "outer_courtyard_done_price" );
self set_ignoreall( true );
self enable_sprint();
}
price_waiting_for_player()
{
level endon( "death" );
level endon( "notify_player_entered_car" );
wait 35;
gren = Getstruct ("cy_magicgren_org", "targetname" );
MagicGrenadeManual ( "fraggrenade", gren.origin, ( 0, 0, 0 ), 0 );
wait 1;
level.player freezeControls( true );
musicstop( 1 );
quote = &"CASTLE_YOUR_ACTIONS_GOT_PRICE";
setDvar( "ui_deadquote", quote );
maps\_utility::missionFailedWrapper();
}
price_enter_vehicle_sound()
{
self waittill("boarding_vehicle");
aud_send_msg("price_enter_vehicle_start");
}
price_courtyard_vo()
{
flag_wait ( "courtyard_btr_alive" );
self delayThread( 6, ::dialogue_queue, "castle_pri_btrblocking" );
wait 0.5;
flag_wait("get_to_escape_truck");
wait 3;
self dialogue_queue( "castle_pri_onme2" );
}
price_btr_target()
{
vh_btr = level.vh_outer_courtyard_btr;
while( !flag( "courtyard_btr_destroyed" ) )
{
n_btr_dist = DistanceSquared( vh_btr.origin, self.origin );
n_enemy_dist = self GetClosestEnemySqDist();
if( n_btr_dist < n_enemy_dist )
{
self SetEntityTarget( vh_btr );
}
else
{
self ClearEntityTarget();
}
wait 5;
}
self ClearEntityTarget();
}
bridge_spotlight()
{
e_spotlight = GetEnt( "bridge_spotlight", "targetname" );
s_target_start = getstruct( "bridge_spotlight_start", "targetname" );
s_target_bridge = getstruct( "bridge_spotlight_bridge", "targetname" );
s_target_window = getstruct( "bridge_spotlight_window", "targetname" );
s_target_overlook = getstruct( "bridge_spotlight_overlook", "targetname" );
PlayFXOnTag( getfx( "spotlight_modern_rain_br" ), e_spotlight, "tag_light" );
e_spotlight SetModel( "ctl_spotlight_modern_3x_on" );
e_spotlight thread bridge_spotlight_death();
e_target = Spawn( "script_origin", s_target_start.origin );
e_spotlight thread bridge_spotlight_track_ent( e_target );
flag_wait( "give_bridge_detonator" );
e_target MoveTo( s_target_bridge.origin, .1, 0, 0 );
wait 6;
e_target MoveTo( s_target_window.origin, .1, 0, 0 );
wait 6;
e_target MoveTo( s_target_overlook.origin, .1, 0, 0 );
flag_wait( "jumped_to_bridge" );
e_target MoveTo( s_target_bridge.origin, .1, 0, 0 );
}
bridge_spotlight_death()
{
trigger_wait_targetname( self.target );
self notify( "death" );
PlayFXOnTag( getfx( "spotlight_destroy" ), self, "tag_origin" );
StopFXOnTag( getfx( "spotlight_modern_rain_br" ), self, "tag_light" );
self SetModel( "ctl_spotlight_modern_3x_destroyed" );
}
bridge_spotlight_track_ent( e_target )
{
self endon( "death" );
self notify( "castle_spotlight_track_ent" );
self endon( "castle_spotlight_track_ent" );
self SetMode( "manual" );
ent = Spawn( "script_origin", e_target.origin );
self SetTargetEntity( ent );
units_per_second = 220;
while ( true )
{
dist = Distance( e_target.origin, ent.origin );
vec = RandomVector( 1 );
extra_z = RandomFloatRange( -16, 16 );
vec += ( 0, 0, extra_z );
time = dist / units_per_second;
random_min = RandomFloatRange( 0.7, 1.3 );
if ( time < random_min )
{
time = random_min;
}
spotlight_org = e_target.origin + vec;
if ( IsDefined( level.spotlight_override_pos ) )
{
spotlight_org = level.spotlight_override_pos;
}
if ( DistanceSquared( ent.origin, spotlight_org ) > 10000 )
{
ent MoveTo( spotlight_org, time, time * 0.4, time * 0.4 );
}
wait time;
self notify( "spotlight_on_target" );
}
}
bridge_entrance()
{
sp_bridge_guard = GetEnt( "bridge_btr_escort", "targetname" );
sp_bridge_guard add_spawn_function( ::bridge_btr_escort_think );
trigger_wait_targetname( "start_bridge_entrance" );
wait 0.05;
vh_btr = get_vehicle( "bridge_btr", "targetname" );
vh_btr.animname = "btr";
vh_btr.s_anim_align = get_new_anim_node( "castle_bridge" );
vh_btr.s_anim_align anim_first_frame_solo( vh_btr, "bridge_entrance" );
vh_btr thread bridge_btr_rpg_watch();
vh_btr thread bridge_btr_attack();
player_kills = [];
for( i = 0; i < 10; i++ )
{
new_guard = sp_bridge_guard spawn_ai( true );
new_guard.animname = "guard" + i;
new_guard.s_anim_align = get_new_anim_node( "castle_bridge" );
new_guard.goalradius = 32;
if( ( i == 0 ) || ( i > 5 ) )
{
new_guard.stance = "crouch";
}
else
{
new_guard.stance = "stand";
}
new_guard thread bridge_btr_escort_animate();
wait 0.05;
}
flag_wait( "start_bridge_entrance" );
vh_btr.s_anim_align thread anim_single_solo( vh_btr, "bridge_entrance" );
flag_wait( "bridge_detonated" );
n_dist = 200;
s_damage = getstruct( "bridge_explosion", "targetname" );
a_corpses = GetCorpseArray();
foreach( e_corpse in a_corpses )
{
if( distance( e_corpse.origin, s_damage.origin ) < n_dist )
{
e_corpse Delete();
}
}
aud_send_msg("bridge_detonate", vh_btr);
vh_btr maps\_vehicle::mgoff();
vh_btr.s_anim_align thread anim_single_solo( vh_btr, "bridge_death" );
vh_btr thread vehicle_shield();
t_kill = GetEnt( "destroyed_bridge_kill_trigger", "targetname" );
t_kill trigger_on();
flag_wait( "bridge_btr_kill" );
vh_btr ConnectPaths();
vh_btr maps\_vehicle::kill_lights( self.model );
vh_btr maps\_vehicle::kill_fx( self.model, false );
PlayFXOnTag( getfx( "btr_death" ), vh_btr, "tag_origin" );
vh_btr SetModel( "vehicle_btr80_d" );
Earthquake( 0.2, 0.5, level.player.origin, 2000 );
level.player PlayRumbleOnEntity( "wii_damage_light" );
}
vehicle_shield()
{
while( 1 )
{
self.health = 30000;
waitframe();
}
}
bridge_btr_rpg_watch()
{
level endon( "bridge_detonated" );
self.health = 30000;
while( self.health > 20000 )
{
self waittill( "damage", amount, attacker, direction_vec, point, type );
if( amount >= 500 )
{
break;
}
}
level.player notify( "detonate" );
}
bridge_btr_attack()
{
level endon( "bridge_detonated" );
flag_wait_any( "bridge_player_fired", "jumped_to_bridge" );
self SetTurretTargetEnt( level.player );
thread price_blows_bridge();
while ( IsAlive( self ) )
{
wait RandomFloatRange( 5.0, 7.0 );
self FireWeapon();
}
}
price_blows_bridge()
{
wait 1;
flag_set("price_blew_bridge");
level.price dialogue_queue("castle_pri_illdoit");
level.player notify("detonate");
wait 2;
level.price dialogue_queue("castle_pri_sloppybastard");
}
bridge_btr_escort_animate()
{
self endon( "death" );
self.s_anim_align anim_first_frame_solo( self, "bridge_entrance" );
flag_wait( "start_bridge_entrance" );
self.a.pose = self.stance;
self AllowedStances( self.stance );
self thread bridge_btr_escort_animate_loop( self.s_anim_align );
flag_wait( "bridge_detonated" );
self.s_anim_align notify( "stop_loop" );
self.s_anim_align anim_single_solo( self, "bridge_explode" );
self flashlight_off();
switch ( self.animname )
{
case "guard0":
self.script_noteworthy = "price_kill";
self.s_anim_align thread anim_loop_solo( self, "bridge_dying" );
self gun_remove();
self set_allowdeath(true);
self.a.nodeath = true;
break;
case "guard1":
case "guard2":
case "guard3":
case "guard7":
case "guard8":
self.s_anim_align anim_single_solo( self, "bridge_deadloop" );
self gun_remove();
self.a.nodeath = true;
self set_allowdeath(true);
self.noragdoll = undefined;
self.forceRagdollImmediate = true;
self Kill();
break;
default:
self Delete();
break;
}
}
bridge_btr_escort_animate_loop( s_anim_align )
{
self endon( "death" );
level endon( "bridge_detonated" );
s_anim_align anim_single_solo( self, "bridge_entrance" );
s_anim_align thread anim_loop_solo( self, "bridge_idle" );
flag_wait_any( "bridge_player_fired", "jumped_to_bridge" );
s_anim_align notify( "stop_loop" );
s_anim_align anim_single_solo( self, "bridge_alert" );
self set_ignoreall( false );
}
bridge_btr_escort_think()
{
self set_ignoreall( true );
self set_ignoreme( true );
self set_allowdeath(true);
self.noragdoll = true;
if( RandomInt( 100 ) > 50 )
{
self flashlight_on( true );
}
}
courtyard_weapon_glow()
{
turrets = GetEntArray( "stinger_emplacement", "targetname" );
foreach ( turret in turrets )
{
turret SetModel( "ctl_missile_emplacement_obj" );
}
rpgs = GetEntArray( "courtyard_rpg", "targetname" );
foreach ( rpg in rpgs )
{
rpg SetModel( "ctl_weapon_rpg7_obj" );
}
flag_wait( "courtyard_btr_destroyed" );
foreach ( turret in turrets )
{
turret SetModel( "ctl_missile_emplacement" );
}
rpgs = GetEntArray( "courtyard_rpg", "targetname" );
foreach ( rpg in rpgs )
{
rpg SetModel( "weapon_rpg7" );
}
}
courtyard_btr_think()
{
trigger_wait_targetname( "spawn_courtyard_btr" );
wait 0.05;
vh_btr = get_vehicle( "courtyard_btr", "targetname" );
vh_btr ThermalDrawEnable();
vh_btr maps\_vehicle::mgoff();
delayThread(2.0, maps\castle_escape_new::escape_doors_set_open, false);
level.vh_outer_courtyard_btr = vh_btr;
flag_set( "courtyard_btr_alive" );
flag_wait( "ccb_btr_inposition" );
vh_btr maps\_vehicle::mgon();
vh_btr thread courtyard_btr_mg();
vh_btr thread courtyard_btr_gate();
}
btr_burst(burstshots, accuracyScalar, target)
{
for( i = 0; i < burstShots; i++ )
{
turret_org = self GetTagOrigin( "tag_turret2" );
x = target.origin[ 0 ] + RandomIntRange( -64, 64 ) * accuracyScalar;
y = target.origin[ 1 ] + RandomIntRange( -64, 64 ) * accuracyScalar;
z = target.origin[ 2 ] + RandomIntRange( -32, 0 ) * accuracyScalar;
targetOrigin = ( x, y, z );
angles = VectorToAngles( targetOrigin - turret_org );
forward = AnglesToForward( angles );
vec = ( forward* 12 );
end = turret_org + vec;
PlayFX( getfx( "bmp_flash_wv" ), turret_org, forward, ( 0,0,1 ) );
MagicBullet( "btr80_turret_castle", turret_org, end );
self PlaySound( "btr80_fire" );
wait( RandomFloatRange( .10, .2 ) );
}
}
courtyard_btr_mg()
{
self mgoff();
self endon( "death" );
level endon( "notify_player_entered_car" );
level.btr_target = level.price;
self SetTurretTargetEnt( level.btr_target );
while( IsAlive( self ) )
{
burstShots = RandomIntRange( 12, 16 );
self btr_burst(burstShots, 2.0, level.btr_target );
wait( RandomFloatRange( 2.5, 3.5 ) );
}
}
courtyard_btr_turret()
{
self endon( "death" );
level endon( "notify_player_entered_car" );
while ( IsAlive( self ) )
{
wait RandomFloatRange( 8.0, 10.0 );
self FireWeapon();
self SetTurretTargetEnt( level.btr_target );
}
}
courtyard_btr_gate()
{
while( 1 )
{
self waittill( "damage", amount, attacker, direction_vec, point, type );
if( amount >= 500 )
{
self notify( "death" );
flag_set( "courtyard_btr_destroyed" );
return;
}
}
}
courtyard_detonate_c4( price )
{
s_c4_1 = getstruct( "outer_courtyard_c4_1", "targetname" );
s_c4_2 = getstruct( "outer_courtyard_c4_2", "targetname" );
aud_send_msg("detonate_c4");
godtrucks = GetEntArray("castle_escape_noexplode", "script_noteworthy");
foreach(truck in godtrucks)
{
truck maps\_vehicle::godon();
truck notify("stop_taking_damage");
}
RadiusDamage( s_c4_2.origin, 256, 1000, 500 );
PhysicsExplosionSphere( s_c4_2.origin, 512, 256, 2 );
Earthquake( 0.3, .3, level.player.origin, 2000 );
exploder(1403);
stop_exploder ( 530 );
level.price thread ignore_me_timer( 1.5 );
level.player thread ignore_me_timer( 1.5 );
a_enemies = GetEntArray( "c4_2_die", "script_noteworthy" );
foreach ( enemy in a_enemies )
{
if ( IsAI( enemy ) && IsAlive( enemy ) )
{
enemy Kill();
}
}
wait 0.5;
RadiusDamage( s_c4_1.origin, 512, 5000, 1000 );
PhysicsExplosionSphere( s_c4_1.origin, 512, 256, 2 );
Earthquake( 0.4, 0.8, level.player.origin, 2000 );
exploder(1402);
a_enemies = GetEntArray( "c4_1_die", "script_noteworthy" );
foreach ( enemy in a_enemies )
{
if ( IsAI( enemy ) && IsAlive( enemy ) )
{
enemy Kill();
}
}
if(isdefined(level.vh_outer_courtyard_btr))
{
level.vh_outer_courtyard_btr maps\_vehicle::godoff();
level.vh_outer_courtyard_btr DoDamage(10001, level.vh_outer_courtyard_btr.origin);
}
a_destructible_vehicles = GetEntArray( "destructible_vehicle", "targetname" );
a_force_destroy = get_array_of_closest( s_c4_1.origin, a_destructible_vehicles, undefined );
n_waittime = 2;
n_vehicle_counter = 1;
}
courtyard_auto_kill( str_name )
{
a_ai = GetEntArray( str_name, "script_noteworthy" );
foreach( ai in a_ai )
{
if ( IsAI( ai ) )
{
ai Kill( level.price.origin, level.price );
}
wait RandomFloatRange( 0.5, 2.0 );
}
}
outer_courtyard_gate()
{
flag_wait( "give_bridge_detonator" );
gate_l = GetEnt( "outer_gate_l", "targetname" );
gate_l_clip = GetEnt( "outer_gate_l_clip", "targetname" );
gate_l LinkTo( gate_l_clip );
gate_r = GetEnt( "outer_gate_r", "targetname" );
gate_r_clip = GetEnt( "outer_gate_r_clip", "targetname" );
gate_r LinkTo( gate_r_clip );
gate_l_clip RotateYaw( -95, 0.05 );
gate_r_clip RotateYaw( 100, 0.05 );
gate_l_clip ConnectPaths();
gate_r_clip ConnectPaths();
}
disable_battle_triggers()
{
a_triggers = GetEntArray( "outer_courtyard_battle", "script_noteworthy" );
foreach ( trigger in a_triggers )
{
trigger trigger_off();
}
a_bridge = GetEntArray( "bridge_bad", "targetname" );
foreach ( part in a_bridge )
{
part Hide();
}
a_props = GetEntArray( "stealth_hide", "targetname" );
foreach ( prop in a_props )
{
prop trigger_off();
}
}
enable_battle_triggers()
{
a_triggers = GetEntArray( "outer_courtyard_battle", "script_noteworthy" );
foreach ( trigger in a_triggers )
{
trigger trigger_on();
}
m_nosight = GetEnt( "courtyard_stealth_nosight", "targetname" );
m_nosight Delete();
a_props = GetEntArray( "stealth_hide", "targetname" );
foreach ( prop in a_props )
{
prop trigger_on();
}
}
hide_bridge_objects()
{
a_models = GetEntArray( "bridge_jeep", "script_noteworthy" );
foreach ( model in a_models )
{
model trigger_off();
}
bridge = GetEnt( "fxanim_castle_bridge_mod", "targetname" );
bridge Hide();
scaffolding = GetEnt( "fxanim_castle_bridge_scaff_mod", "targetname" );
scaffolding Hide();
t_kill = GetEnt( "destroyed_bridge_kill_trigger", "targetname" );
t_kill trigger_off();
}
show_bridge_objects()
{
a_models = GetEntArray( "bridge_jeep", "script_noteworthy" );
foreach ( model in a_models )
{
model trigger_on();
}
scaffolding = GetEnt( "fxanim_castle_bridge_scaff_mod", "targetname" );
scaffolding Show();
scaffolding_old = GetEntArray( "scaff_hide_fxanim", "targetname" );
foreach ( model in scaffolding_old )
{
model Hide();
}
}
wait_until_enemies_in_volume( vol, num_in )
{
checkvol= GetEnt( vol ,"targetname");
AssertEx( IsDefined(checkvol), "volume undefined " + vol );
enemies = checkvol get_ai_touching_volume( "axis" );
numenemies = enemies.size;
while( numenemies > num_in)
{
wait 1;
enemies = checkvol get_ai_touching_volume( "axis" );
numenemies = enemies.size;
if( numenemies - num_in < 3 )
{
foreach( enemy in enemies )
{
if( enemy doingLongDeath() || enemy.delayedDeath )
{
numenemies --;
}
}
}
}
}
