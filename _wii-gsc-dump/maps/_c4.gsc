
#include maps\_utility;
#include common_scripts\utility;
main( c4_weaponname, model, obj_model )
{
if (!isdefined(model))
model = "weapon_c4";
if (!isdefined(obj_model))
obj_model = "weapon_c4_obj";
if (!isdefined(c4_weaponname))
level.c4_weaponname = "c4";
else
level.c4_weaponname = c4_weaponname;
precacheModel( model );
precacheModel( obj_model );
precacheItem( level.c4_weaponname );
level._effect[ "c4_explosion" ] = loadfx( "explosions/grenadeExp_metal" );
}
c4_location( tag, origin_offset, angles_offset, org, model, obj_model )
{
tag_origin = undefined;
if ( !isdefined( origin_offset ) )
origin_offset = ( 0, 0, 0 );
if ( !isdefined( angles_offset ) )
angles_offset = ( 0, 0, 0 );
if (!isdefined(model))
model = "weapon_c4";
if (!isdefined(obj_model))
obj_model = "weapon_c4_obj";
if ( isdefined( tag ) )
tag_origin = self gettagorigin( tag );
else if ( isdefined( org ) )
tag_origin = org;
else
assertmsg( "need to specify either a 'tag' or an 'org' parameter to attach the c4 to" );
c4_model = spawn( "script_model", tag_origin + origin_offset );
c4_model setmodel( obj_model );
if ( isdefined( tag ) )
c4_model linkto( self, tag, origin_offset, angles_offset );
else
c4_model.angles = self.angles;
c4_model.trigger = get_use_trigger();
if ( isdefined ( level.c4_hintstring ) )
c4_model.trigger sethintstring( level.c4_hintstring );
else
c4_model.trigger sethintstring( &"SCRIPT_PLATFORM_HINT_PLANTEXPLOSIVES" );
if ( isdefined( tag ) )
{
c4_model.trigger linkto( self, tag, origin_offset, angles_offset );
c4_model.trigger.islinked = true;
}
else
c4_model.trigger.origin = c4_model.origin;
c4_model thread handle_use( self, model );
if ( !isdefined( self.multiple_c4 ) )
c4_model thread handle_delete( self );
c4_model thread handle_clear_c4( self );
return c4_model;
}
playC4Effects()
{
self endon( "death" );
wait .1;
playFXOnTag( getfx( "c4_light_blink" ), self, "tag_fx" );
}
handle_use( c4_target, model )
{
c4_target endon( "clear_c4" );
if (!isdefined(model))
model = "weapon_c4";
if ( !isdefined( c4_target.multiple_c4 ) )
c4_target endon( "c4_planted" );
if ( !isdefined( c4_target.c4_count ) )
c4_target.c4_count = 0;
c4_target.c4_count++ ;
self.trigger usetriggerrequirelookat();
self.trigger waittill( "trigger", player );
level notify( "c4_in_place", self );
self.trigger unlink();
self.trigger release_use_trigger();
self playsound( "c4_bounce_default" );
self setmodel( model );
self thread playC4Effects();
c4_target.c4_count -- ;
if ( !isdefined( c4_target.multiple_c4 ) || !c4_target.c4_count )
player switch_to_detonator();
self thread handle_detonation( c4_target, player );
c4_target notify( "c4_planted", self );
}
handle_delete( c4_target )
{
c4_target endon( "clear_c4" );
self.trigger endon( "trigger" );
c4_target waittill( "c4_planted", c4_model );
self.trigger unlink();
self.trigger release_use_trigger();
self delete();
}
handle_detonation( c4_target, player )
{
c4_target endon( "clear_c4" );
player waittill( "detonate" );
playfx( level._effect[ "c4_explosion" ], self.origin );
soundPlayer = spawn( "script_origin", self.origin );
if ( isdefined( level.c4_sound_override ) )
soundPlayer playsound( "detpack_explo_main", "sound_done" );
self radiusdamage( self.origin, 256, 200, 50 );
earthquake( 0.4, 1, self.origin, 1000 );
if ( isdefined( self ) )
self delete();
player thread remove_detonator();
c4_target notify( "c4_detonation" );
soundPlayer waittill( "sound_done" );
soundPlayer delete();
}
handle_clear_c4( c4_target )
{
c4_target endon( "c4_detonation" );
c4_target waittill( "clear_c4" );
if ( !isdefined( self ) )
return;
if ( isdefined( self.trigger.inuse ) && self.trigger.inuse )
self.trigger release_use_trigger();
if ( isdefined( self ) )
self delete();
level.player thread remove_detonator();
}
remove_detonator()
{
level endon( "c4_in_place" );
wait 1;
had_empty_old_weapon = false;
if ( level.c4_weaponname == self getcurrentweapon() && ( isdefined( self.old_weapon ) ) )
{
if ( self.old_weapon == "none" )
{
had_empty_old_weapon = true;
self switchtoweapon( self GetWeaponsListPrimaries()[ 0 ] );
}
else
{
if ( ( self HasWeapon( self.old_weapon ) ) && ( self.old_weapon != level.c4_weaponname ) )
self switchtoweapon( self.old_weapon );
else
self switchtoweapon( self GetWeaponsListPrimaries()[ 0 ] );
}
}
self.old_weapon = undefined;
if ( 0 != self getammocount( level.c4_weaponname ) )
return;
self waittill( "weapon_change" );
self takeweapon( level.c4_weaponname );
self SetPreloadWeapon( "", 0 );
}
switch_to_detonator()
{
c4_weapon = undefined;
if ( !isdefined( self.old_weapon ) )
self.old_weapon = self getcurrentweapon();
weapons = self GetWeaponsListAll();
for ( i = 0; i < weapons.size; i++ )
{
if ( weapons[ i ] != level.c4_weaponname )
continue;
c4_weapon = weapons[ i ];
}
if ( !isdefined( c4_weapon ) )
{
self giveWeapon( level.c4_weaponname );
self SetPreloadWeapon( level.c4_weaponname, 0 );
self SetWeaponAmmoClip( level.c4_weaponname, 0 );
self SetActionSlot( 2, "weapon", level.c4_weaponname );
}
self switchtoweapon( level.c4_weaponname );
}
get_use_trigger()
{
ents = getentarray( "generic_use_trigger", "targetname" );
assertex( isdefined( ents ) && ents.size > 0, "Missing use trigger with targetname: generic_use_trigger." );
for ( i = 0; i < ents.size; i++ )
{
if ( isdefined( ents[ i ].inuse ) && ents[ i ].inuse )
continue;
if ( !isdefined( ents[ i ].inuse ) )
ents[ i ] enablelinkto();
ents[ i ].inuse = true;
ents[ i ].oldorigin = ents[ i ].origin;
return ents[ i ];
}
assertmsg( "all generic use triggers are in use. Place more of them in the map." );
}
release_use_trigger()
{
if ( isdefined( self.islinked ) )
self unlink();
self.islinked = undefined;
self.origin = self.oldorigin;
self.inuse = false;
}