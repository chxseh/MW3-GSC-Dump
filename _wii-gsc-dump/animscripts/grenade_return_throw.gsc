#include animscripts\Utility;
#using_animtree( "generic_human" );
main()
{
self orientMode( "face default" );
self endon( "killanimscript" );
animscripts\utility::initialize( "grenade_return_throw" );
self animMode( "zonly_physics" );
throwAnim = undefined;
throwDist = 1000;
if ( isdefined( self.enemy ) )
throwDist = distance( self.origin, self.enemy.origin );
animArray = [];
if ( throwDist < 600 && isLowThrowSafe() )
{
if ( throwDist < 300 )
{
animArray[ 0 ] = %grenade_return_running_throw_forward;
animArray[ 1 ] = %grenade_return_standing_throw_forward_1;
}
else
{
animArray[ 0 ] = %grenade_return_running_throw_forward;
animArray[ 1 ] = %grenade_return_standing_throw_overhand_forward;
}
}
if ( animArray.size == 0 )
{
animArray[ 0 ] = %grenade_return_standing_throw_overhand_forward;
}
assert( animArray.size );
throwAnim = animArray[ randomint( animArray.size ) ];
assert( isdefined( throwAnim ) );
self setFlaggedAnimKnoballRestart( "throwanim", throwAnim, %body, 1, .3 );
hasPickup = ( animHasNotetrack( throwAnim, "grenade_left" ) || animHasNotetrack( throwAnim, "grenade_right" ) );
if ( hasPickup )
{
self animscripts\shared::placeWeaponOn( self.weapon, "left" );
self thread putWeaponBackInRightHand();
self thread notifyGrenadePickup( "throwanim", "grenade_left" );
self thread notifyGrenadePickup( "throwanim", "grenade_right" );
self waittill( "grenade_pickup" );
self pickUpGrenade();
self animscripts\battleChatter_ai::evaluateAttackEvent( "grenade" );
self waittillmatch( "throwanim", "grenade_throw" );
}
else
{
self waittillmatch( "throwanim", "grenade_throw" );
self pickUpGrenade();
self animscripts\battleChatter_ai::evaluateAttackEvent( "grenade" );
}
if ( isDefined( self.grenade ) )
self throwGrenade();
wait 1;
if ( hasPickup )
{
self notify( "put_weapon_back_in_right_hand" );
self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}
}
isLowThrowSafe()
{
start = ( self.origin[ 0 ], self.origin[ 1 ], self.origin[ 2 ] + 20 );
end = start + anglesToForward( self.angles ) * 50;
return sightTracePassed( start, end, false, undefined );
}
putWeaponBackInRightHand()
{
self endon( "death" );
self endon( "put_weapon_back_in_right_hand" );
self waittill( "killanimscript" );
self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}
notifyGrenadePickup( animFlag, notetrack )
{
self endon( "killanimscript" );
self endon( "grenade_pickup" );
self waittillmatch( animFlag, notetrack );
self notify( "grenade_pickup" );
}
