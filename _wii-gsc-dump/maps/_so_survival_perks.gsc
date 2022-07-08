#include common_scripts\utility;
#include maps\_utility;
#include maps\_so_survival_code;
perks_preload()
{
}
perks_init()
{
}
give_perk( give_ref )
{
if ( self hasPerk( give_ref, true ) )
return true;
self ClearPerks();
switch ( give_ref )
{
case "specialty_stalker":
self thread give_perk_stalker();
break;
case "specialty_longersprint":
self thread give_perk_longersprint();
break;
case "specialty_fastreload":
self thread give_perk_fastreload();
break;
case "specialty_quickdraw":
self thread give_perk_quickdraw();
break;
case "specialty_detectexplosive":
self thread give_perk_detectexplosive();
break;
case "specialty_bulletaccuracy":
self thread give_perk_bulletaccuracy();
break;
default:
self thread give_perk_dummy();
break;
}
self notify( "give_perk", give_ref );
return true;
}
take_perk( take_ref )
{
if ( !self hasperk( take_ref, true ) )
return;
switch ( take_ref )
{
case "specialty_stalker":
self thread take_perk_stalker();
break;
case "specialty_longersprint":
self thread take_perk_longersprint();
break;
case "specialty_fastreload":
self thread take_perk_fastreload();
break;
case "specialty_quickdraw":
self thread take_perk_quickdraw();
break;
case "specialty_detectexplosive":
self thread take_perk_detectexplosive();
break;
case "specialty_bulletaccuracy":
self thread take_perk_bulletaccuracy();
break;
default:
self thread take_perk_dummy();
break;
}
self notify( "take_perk", take_ref );
}
give_perk_dummy()
{
}
take_perk_dummy()
{
}
give_perk_longersprint()
{
self SetPerk( "specialty_longersprint", true, false );
}
take_perk_longersprint()
{
self UnSetPerk( "specialty_longersprint", true );
}
give_perk_fastreload()
{
self SetPerk( "specialty_fastreload", true, false );
}
take_perk_fastreload()
{
self UnSetPerk( "specialty_fastreload", true );
}
give_perk_quickdraw()
{
self SetPerk( "specialty_quickdraw", true, false );
}
take_perk_quickdraw()
{
self UnSetPerk( "specialty_quickdraw", true );
}
give_perk_detectexplosive()
{
self SetPerk( "specialty_detectexplosive", true, false );
}
take_perk_detectexplosive()
{
self UnSetPerk( "specialty_detectexplosive", true );
}
give_perk_bulletaccuracy()
{
self SetPerk( "specialty_bulletaccuracy", true, false );
}
take_perk_bulletaccuracy()
{
self UnSetPerk( "specialty_bulletaccuracy", true );
}
give_perk_stalker()
{
self SetPerk( "specialty_stalker", true, false );
}
take_perk_stalker()
{
self UnSetPerk( "specialty_stalker", true );
}
perk_HUD()
{
self flag_init( "HUD_giving_perk" );
self flag_init( "HUD_taking_perk" );
self thread update_on_give_perk();
self thread update_on_take_perk();
}
update_on_give_perk()
{
self endon( "death" );
while ( 1 )
{
self waittill( "give_perk", ref );
self flag_set( "HUD_giving_perk" );
while ( self flag( "HUD_taking_perk" ) )
wait 0.05;
wait 1;
self flag_clear( "HUD_giving_perk" );
}
}
update_on_take_perk()
{
self endon( "death" );
while ( 1 )
{
self waittill( "take_perk", ref );
self flag_set( "HUD_taking_perk" );
while ( self flag( "HUD_giving_perk" ) )
wait 0.05;
wait 1;
self flag_clear( "HUD_taking_perk" );
}
}