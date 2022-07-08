#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "ss_n_12", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( model );
level._effect[ "engineeffect" ] = loadfx( "fire/jet_afterburner" );
level._effect[ "contrail" ] = loadfx( "smoke/smoke_geotrail_ssnMissile_trail" );
level._effect[ "contrail12" ] = loadfx( "smoke/smoke_geotrail_ssnMissile12_trail" );
build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand", undefined, undefined, undefined, undefined, undefined, undefined, 0 );
build_life( 999, 500, 1500 );
build_rumble( "mig_rumble", 0.1, 0.2, 11300, 0.05, 0.05 );
build_team( "allies" );
}
init_local()
{
if (self.classname == "script_vehicle_s300_pmu2")
self.tag = "tag_fx";
thread playEngineEffects();
thread handle_death();
thread playConTrail12();
maps\_vehicle::lights_on( "running" );
}
#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
ropemodel = "rope_test";
precachemodel( ropemodel );
return positions;
}
#using_animtree( "generic_human" );
setanims()
{
positions = [];
for ( i = 0;i < 1;i++ )
positions[ i ] = spawnstruct();
return positions;
}
playEngineEffects( tag )
{
if (isdefined(self.tag))
tag = self.tag;
if (!isdefined(tag))
tag = "tag_tail";
self endon( "death" );
self endon( "stop_engineeffects" );
self ent_flag_init( "engineeffects" );
self ent_flag_set( "engineeffects" );
engineeffects = getfx( "engineeffect" );
for ( ;; )
{
self ent_flag_wait( "engineeffects" );
playfxontag( engineeffects, self, tag );
self ent_flag_waitopen( "engineeffects" );
StopFXOnTag( engineeffects, self, tag );
}
}
handle_death()
{
self waittill("death");
if (isdefined(self.tag1))
self.tag1 Delete();
}
playConTrail( tag )
{
if (isdefined(self.tag))
tag = self.tag;
if (!isdefined(tag))
tag = "tag_tail";
self.tag1 = add_contrail( tag );
contrail = getfx( "contrail" );
self endon( "death" );
ent_flag_init( "contrails" );
ent_flag_set( "contrails" );
for ( ;; )
{
ent_flag_wait( "contrails" );
wait(.65);
playfxontag( contrail, self.tag1, "tag_origin" );
ent_flag_waitopen( "contrails" );
stopfxontag( contrail, self.tag1, "tag_origin" );
}
}
playConTrail12( tag )
{
if (isdefined(self.tag))
tag = self.tag;
if (!isdefined(tag))
tag = "tag_tail";
self.tag1 = add_contrail( tag );
contrail = getfx( "contrail12" );
self endon( "death" );
ent_flag_init( "contrails" );
ent_flag_set( "contrails" );
for ( ;; )
{
ent_flag_wait( "contrails" );
wait(.65);
playfxontag( contrail, self.tag1, "tag_origin" );
ent_flag_waitopen( "contrails" );
stopfxontag( contrail, self.tag1, "tag_origin" );
}
}
add_contrail( fx_tag_name )
{
fx_tag = spawn_tag_origin();
fx_tag.origin = self getTagOrigin( fx_tag_name );
fx_tag.angles = self getTagAngles( fx_tag_name );
ent = spawnstruct();
ent.entity = fx_tag;
ent.forward = 0;
ent.up = 0;
ent.right = 0;
ent.yaw = 0;
ent.pitch = 0;
ent translate_local();
fx_tag LinkTo( self, fx_tag_name );
return fx_tag;
}
playerisclose( other )
{
infront = playerisinfront( other );
if ( infront )
dir = 1;
else
dir = -1;
a = flat_origin( other.origin );
b = a + ( anglestoforward( flat_angle( other.angles ) ) * ( dir * 100000 ) );
point = pointOnSegmentNearestToPoint( a, b, level.player.origin );
dist = distance( a, point );
if ( dist < 3000 )
return true;
else
return false;
}
playerisinfront( other )
{
forwardvec = anglestoforward( flat_angle( other.angles ) );
normalvec = vectorNormalize( flat_origin( level.player.origin ) - other.origin );
dot = vectordot( forwardvec, normalvec );
if ( dot > 0 )
return true;
else
return false;
}
plane_sound_node()
{
self waittill( "trigger", other );
other endon( "death" );
self thread plane_sound_node();
other thread play_loop_sound_on_entity( "veh_f15_dist_loop" );
while ( playerisinfront( other ) )
wait .05;
wait .5;
other thread play_sound_in_space( "veh_f15_sonic_boom" );
other waittill( "reached_end_node" );
other stop_sound( "veh_f15_dist_loop" );
other delete();
}
stop_sound( alias )
{
self notify( "stop sound" + alias );
}





