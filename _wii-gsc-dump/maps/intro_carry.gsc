#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
initCarry()
{
anims();
}
#using_animtree( "generic_human" );
anims()
{
level.scr_anim[ "soap" ][ "wounded_idle" ][ 0 ] = %intro_fireman_carry_lie_idle_carried;
level.scr_anim[ "soap" ][ "pickup_wounded" ] = %intro_fireman_carry_lift_guy_carried;
level.scr_anim[ "nikolai" ][ "pickup_carrier" ] = %intro_fireman_carry_lift_guy_carrier;
level.scr_anim[ "soap" ][ "wounded_walk_loop" ][ 0 ] = %wounded_carry_fastwalk_wounded_relative;
level.scr_anim[ "nikolai" ][ "carrier_walk_loop" ] = %wounded_carry_fastwalk_carrier;
level.scr_anim[ "nikolai" ][ "carrier_stairs_down_loop" ]	= %intro_fireman_carry_stairs_carrier;
level.scr_anim[ "soap" ][ "putdown_wounded" ] = %intro_fireman_carry_drop_guy_carried;
level.scr_anim[ "nikolai" ][ "putdown_carrier" ] = %intro_fireman_carry_drop_guy_carrier;
level.scr_anim[ "soap" ][ "carry_idle" ][ 0 ] = %intro_fireman_carry_idle_carried;
level.scr_anim[ "nikolai" ][ "carry_idle" ][ 0 ] = %intro_fireman_carry_idle_carrier;
level.carry_anims = SpawnStruct();
set_default_carry_anims();
}
set_default_carry_anims()
{
level.carry_anims.anims = [];
level.carry_anims.anims[ "wounded_idle" ] = "wounded_idle";
level.carry_anims.anims[ "pickup_wounded" ] = "pickup_wounded";
level.carry_anims.anims[ "pickup_carrier" ] = "pickup_carrier";
level.carry_anims.anims[ "putdown_wounded" ] = "putdown_wounded";
level.carry_anims.anims[ "putdown_carrier" ] = "putdown_carrier";
}
override_carry_anim( anim_type, anim_string )
{
AssertEx( IsDefined( level.carry_anims.anims[ anim_type ] ), "carry anim " + anim_type + " not defined." );
level.carry_anims.anims[ anim_type ] = anim_string;
}
get_carry_anim( anim_type )
{
AssertEx( IsDefined( level.carry_anims.anims[ anim_type ] ), "carry anim " + anim_type + " not defined." );
return level.carry_anims.anims[ anim_type ];
}
setWounded( eNode )
{
assert( isdefined( eNode ) );
self.woundedNode = eNode;
self.woundedNode thread anim_loop_solo( self, get_carry_anim( "wounded_idle" ), "stop_wounded_idle" );
}
move_wounded_to_node_by_color()
{
self endon( "stop_carry_by_color" );
forced_color = "c";
team = "allies";
while( 1 )
{
if( isdefined( level.currentColorForced[ team ][ forced_color ] ) )
{
currentColorCode = level.currentColorForced[ team ][ forced_color ];
level.carry_to_node_new = level.arrays_of_colorCoded_nodes[ team ][ currentColorCode ][0];
}
wait .1;
}
}
move_wounded_to_node_monitor( wounded, eNode )
{
self endon( "stop_wounded_node_monitor" );
level.carry_to_node = eNode;
level.carry_to_node_new = eNode;
while( 1 )
{
if ( isDefined( self.carrying ) )
{
if ( level.carry_to_node != level.carry_to_node_new )
{
level.carry_to_node = level.carry_to_node_new;
if ( !isdefined( level.carry_to_node.type ) )
{
self setgoalpos( level.carry_to_node.origin );
}
else
{
self setgoalnode( level.carry_to_node );
}
self thread carrier_reached_goal( wounded );
}
}
if( !isdefined( wounded.in_sequence ) )
{
if( level.carry_to_node != level.carry_to_node_new )
{
level.carry_to_node = level.carry_to_node_new;
thread move_wounded_to_node( wounded, level.carry_to_node );
}
}
wait( .05 );
}
}
move_wounded_to_node( wounded, eNode )
{
wounded.in_sequence = true;
goto_and_pickup_wounded( wounded, eNode );
carry_to_and_putdown_wounded( wounded, eNode );
}
goto_and_pickup_wounded( wounded, eNode )
{
assert( isdefined( self ) );
assert( isAI( self ) );
assert( isAlive( self ) );
assert( isdefined( wounded ) );
assert( isdefined( wounded.woundedNode ) );
self endon( "end_carry_ai" );
if( !wounded.woundedNode maps\intro_utility::check_anim_reached( self, get_carry_anim( "pickup_carrier" ), undefined, self.animname, 10 ) )
wounded.woundedNode anim_reach_solo( self, get_carry_anim( "pickup_carrier" ) );
wounded notify( "stop_wounded_idle" );
wounded.woundedNode notify( "stop_wounded_idle" );
wounded.woundedNode thread anim_single_solo( wounded, get_carry_anim( "pickup_wounded" ) );
wounded.woundedNode anim_single_solo( self, get_carry_anim( "pickup_carrier" ) );
self.dontMelee = true;
wounded notsolid();
self thread play_carry_wounded_anims( wounded );
self notify( "carry_picked_up" );
}
carry_to_and_putdown_wounded( wounded, eNode )
{
assert( isdefined( self ) );
assert( isAI( self ) );
assert( isAlive( self ) );
assert( isdefined( wounded ) );
assert( isdefined( eNode ) );
self endon( "end_carry_ai" );
wait(.05);
setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
self animmode( "none" );
self.allowpain = false;
self.disableBulletWhizbyReaction = true;
self.ignoreall = true;
self.ignoreme = true;
self.grenadeawareness = 0;
self setFlashbangImmunity( true );
self.neverEnableCqb = true;
self.disablearrivals = true;
self.disableexits = true;
self.nododgemove = true;
self disable_cqbwalk();
self.oldgoal = self.goalradius;
self pushplayer( true );
if( isdefined( level.carry_to_node ) )
{
self.ignoresuppression = true;
self.disablearrivals = true;
self.goalradius = 128;
if( !isdefined( level.carry_to_node.type ) )
{
self setgoalpos( level.carry_to_node.origin );
self.goalradius = 10;
}
else
{
self setgoalnode( level.carry_to_node );
if ( IsDefined( level.carry_then_idle ) )
self.goalradius = 10;
else
self.goalradius = 128;
}
self.carrying = true;
self thread carrier_reached_goal( wounded );
}
}
carrier_reached_goal( wounded )
{
self notify( "new_carrier_goal" );
self endon( "new_carrier_goal" );
self waittill( "goal" );
if( IsDefined( level.carry_then_idle ) )
return;
if ( IsDefined( level.carry_to_node.script_noteworthy ) && level.carry_to_node.script_noteworthy == "no_putdown" )
return;
self.carrying = undefined;
if( isdefined( level.carry_to_node.script_noteworthy ) && level.carry_to_node.script_noteworthy == "maars_control_load_helicopter" )
{
flag_set( "maars_control_loading_helicopter" );
self putdown_wounded_helicopter( wounded );
}
else
{
self putdown_wounded( wounded );
}
if( isdefined( wounded.in_sequence ) )
wounded.in_sequence = undefined;
}
putdown_wounded( wounded )
{
level.carry_to_node anim_reach_solo( self, get_carry_anim( "putdown_carrier" ) );
wounded.woundedNode = level.carry_to_node;
self thread stop_carry_wounded_anims( wounded );
self.ignoresuppression = false;
self.disablearrivals = false;
self.goalradius = self.oldgoal;
wounded.woundedNode thread anim_single_solo( self, get_carry_anim( "putdown_carrier" ) );
wounded.woundedNode anim_single_solo( wounded, get_carry_anim( "putdown_wounded" ) );
setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
self.allowpain = true;
self.disableBulletWhizbyReaction = false;
self.ignoreall = false;
self.grenadeawareness = 1;
self setFlashbangImmunity( false );
self.dontMelee = undefined;
self.neverEnableCqb = undefined;
self.disablearrivals = undefined;
self.disableexits = undefined;
self.nododgemove = false;
self pushplayer( false );
wounded solid();
wounded.woundedNode thread anim_loop_solo( wounded, get_carry_anim( "wounded_idle" ), "stop_wounded_idle" );
wounded notify( "stop_putdown" );
}
putdown_wounded_helicopter( wounded )
{
level.carry_to_node = getstruct( level.carry_to_node.script_noteworthy, "targetname" );
self notify( "stop_wouned_node_monitor" );
level.carry_to_node anim_reach_solo( self, "intro_ugv_helicopter" );
wounded.woundedNode = level.carry_to_node;
self thread stop_carry_wounded_anims( wounded );
self.ignoresuppression = false;
self.disablearrivals = false;
self.goalradius = self.oldgoal;
delaythread( 2, ::flag_set, "maars_control_soap_at_helicopter" );
self thread putdown_wounded_helicopter_nikolai( wounded );
wounded.woundedNode anim_single_solo( wounded, "intro_ugv_helicopter" );
wounded solid();
wounded.woundedNode thread anim_loop_solo( wounded, "intro_ugv_helicopter_idle", "stop_wounded_idle" );
wounded notify( "stop_putdown" );
}
putdown_wounded_helicopter_nikolai( wounded )
{
wounded.woundedNode anim_single_solo( self, "intro_ugv_helicopter" );
setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
self.allowpain = true;
self.disableBulletWhizbyReaction = false;
self.ignoreall = false;
self.grenadeawareness = 1;
self setFlashbangImmunity( false );
self.dontMelee = undefined;
self.neverEnableCqb = undefined;
self.disablearrivals = undefined;
self.disableexits = undefined;
self.nododgemove = false;
self pushplayer( false );
wounded.woundedNode thread anim_loop_solo( self, "intro_ugv_helicopter_idle", "stop_wounded_idle" );
}
play_carry_wounded_anims( wounded )
{
self endon( "death" );
self endon( "stop_carry_wounded_anims" );
wounded endon( "death" );
wounded LinkTo( self, "tag_origin" );
self thread handle_move_wounded_anims( wounded );
self thread handle_idle_wounded_anims();
while ( true )
{
if ( !IsDefined( self.previous_move_mode ) || self.previous_move_mode != self.movemode )
{
if ( self.movemode == "stop" || self.movemode == "stop_soon" )
{
if ( !IsDefined( wounded.is_idling ) )
{
wounded.is_idling = true;
self thread play_carry_wounded_idle( wounded );
}
}
else
{
if ( IsDefined( wounded.is_idling ) )
{
wounded.is_idling = undefined;
self notify( "stop_carry_idle" );
wounded thread anim_loop_solo( wounded, "wounded_walk_loop", "stop_wounded_walk_loop" );
}
}
}
self.previous_move_mode = self.movemode;
wait 0.05;
}
}
handle_idle_wounded_anims()
{
self endon( "stop_specialidle" );
while ( true )
{
self thread set_idle_anim( "carry_idle" );
self.animplaybackrate = 1;
self waittill( "clearing_specialIdleAnim" );
}
}
play_carry_wounded_idle( wounded )
{
wounded notify( "stop_wounded_walk_loop" );
self.animplaybackrate = 1;
self thread anim_loop_solo( wounded, "carry_idle", "stop_carry_idle" );
self thread synchronize_carry_anim( wounded );
}
synchronize_carry_anim( wounded )
{
self endon( "stop_carry_idle" );
carry_idle_loop = self getanim( "carry_idle" );
carry_idle_anim = carry_idle_loop[0];
wounded_idle_loop = wounded getanim( "carry_idle" );
wounded_idle_anim = wounded_idle_loop[0];
while ( true )
{
anim_time = self GetAnimTime( carry_idle_anim );
if ( IsDefined( anim_time ) && anim_time > 0 )
{
wounded SetAnimTime( wounded_idle_anim, anim_time );
break;
}
wait 0.05;
}
}
carry_to_new_node( eNode )
{
level.carry_to_node_new = eNode;
}
handle_move_wounded_anims( wounded )
{
self endon( "death" );
self endon( "stop_move_wounded_anims" );
self thread set_run_anim( "carrier_walk_loop", true );
prevStairsState = self.stairsState;
while ( true )
{
if ( prevStairsState != self.stairsState )
{
if ( self.stairsstate == "none" )
{
self thread set_run_anim( "carrier_walk_loop", true );
}
else if ( self.stairsstate == "up" )
{
self thread set_run_anim( "carrier_walk_loop", true );
}
else if ( self.stairsstate == "down" )
{
self thread set_run_anim( "carrier_stairs_down_loop", true );
}
prevStairsState = self.stairsState;
self notify( "move_loop_restart" );
}
wait 0.05;
}
}
stop_carry_wounded_anims( wounded )
{
self notify( "stop_carry_wounded_anims" );
self notify( "stop_move_wounded_anims" );
self thread clear_run_anim();
if ( IsDefined( self.specialIdleAnim ) )
{
self.specialIdleAnim = undefined;
self notify( "stop_specialidle" );
}
wounded notify( "stop_wounded_walk_loop" );
self notify( "stop_carry_idle" );
self.previous_move_mode = undefined;
wounded.is_idling = undefined;
if ( wounded IsLinked() )
{
wounded Unlink();
}
}
teleport_carrier_and_wounded( wounded, wounded_node, teleport_struct )
{
level notify( "color_volume_advance_stop" );
self thread stop_carry_wounded_anims( wounded );
wounded.in_sequence = undefined;
wounded.is_idling = undefined;
wounded notify( "stop_wounded_idle" );
wounded.woundedNode notify( "stop_wounded_idle" );
wounded anim_stopanimscripted();
wounded setWounded( wounded_node );
wounded solid();
self notify( "end_carry_ai" );
self anim_stopanimscripted();
self.carrying = undefined;
self.ignoresuppression = false;
self.disablearrivals = false;
setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
self.allowpain = true;
self.disableBulletWhizbyReaction = false;
self.ignoreall = false;
self.grenadeawareness = 1;
self setFlashbangImmunity( false );
self.dontMelee = undefined;
self.neverEnableCqb = undefined;
self.disablearrivals = undefined;
self.disableexits = undefined;
self.nododgemove = false;
self pushplayer( false );
level.carry_to_node = level.carry_to_node_new;
self forceteleport( teleport_struct.origin, teleport_struct.angles );
self set_goal_pos( teleport_struct.origin );
}
