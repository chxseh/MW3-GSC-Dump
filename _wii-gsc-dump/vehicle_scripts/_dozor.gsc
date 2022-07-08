#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
build_template( "dozor", model, type, classname );
build_localinit( ::init_local );
build_deathmodel( "russian_dozor_600" );
level._effect[ "jettrail" ] = loadfx( "smoke/jet_contrail" );
build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
build_life( 999, 500, 1500 );
build_team( "axis" );
build_mainturret();
}
init_local()
{
thread playJetTrail();
self.missileTags[ 0 ] = "tag_missile_left";
self.missileTags[ 1 ] = "tag_missile_right";
self.nextMissileTag = 0;
}
#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
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
playJetTrail()
{
playfxontag( level._effect[ "jettrail" ], self, "TAG_JET_TRAIL" );
}
plane_sound_node()
{
self waittill( "trigger", other );
other endon( "death" );
self thread plane_sound_node();
other thread play_sound_on_entity( "veh_uav_flyby" );
}
fire_missile_node()
{
self waittill( "trigger", other );
other endon( "death" );
self thread fire_missile_node();
other setVehWeapon( "ucav_sidewinder" );
eTarget = self get_linked_ent();
other fireWeapon( other.missileTags[ other.nextMissileTag ], eTarget, ( 0, 0, 0 ) );
other.nextMissileTag++;
if ( other.nextMissileTag >= other.missileTags.size )
other.nextMissileTag = 0;
}