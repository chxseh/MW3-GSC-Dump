#include maps\_utility;
#include common_scripts\utility;
#using_animtree( "generic_human" );
main()
{
turret = self getTurret();
death_anim = get_death_anim();
self.desired_anim_pose = "stand";
animscripts\utility::UpdateAnimPose();
self.primaryTurretAnim = %gazGunner_aim;
self.additiveTurretRotateLeft	= %gaz_turret_aim_6_add;
self.additiveTurretRotateRight	= %gaz_turret_aim_4_add;
self.additiveRotateRoot = %additive_gazGunner_aim_leftright ;
self.additiveTurretIdle = %gaz_turret_idle;
self.additiveTurretDriveIdle	= %gaz_turret_idle;
self.additiveTurretFire = %gaz_turret_fire;
self.additiveUsegunRoot = %additive_gazGunner_usegun ;
self.turretDeathAnimRoot = %gazGunner_death;
self.turretDeathAnim = death_anim;
self.turretPainAnims[ 0 ] = %gaz_turret_paina;
self.turretPainAnims[ 1 ] = %gaz_turret_painb;
self.turretFlashbangedAnim = %gaz_turret_flincha;
self.turretReloadAnim = %gaz_turret_paina;
self.turretSpecialAnimsRoot = %gazGunner;
arr = [];
arr[ "humvee_turret_flinchA" ] = %gaz_turret_flincha;
arr[ "humvee_turret_flinchB" ] = %gaz_turret_flinchb;
self.turretSpecialAnims = arr;
turret setup_turret_anims();
self thread animscripts\hummer_turret\minigun_code::main( turret );
}
get_death_anim()
{
death_anim = %gaz_turret_death;
if ( IsDefined( self.ridingvehicle ) )
{
if ( IsDefined( level.dshk_death_anim ) )
{
death_anim = self [[ level.dshk_death_anim ]]();
}
}
return death_anim;
}
#using_animtree( "vehicles" );
setup_turret_anims()
{
self UseAnimTree( #animtree );
self.passenger2turret_anime = %humvee_passenger_2_turret_minigun;
self.turret2passenger_anime = %humvee_turret_2_passenger_minigun;
}
