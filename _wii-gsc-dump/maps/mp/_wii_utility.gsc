//#include common_scripts\utility;
//#include animscripts\utility;
//#include maps\_utility_code;

/*
=============
///ScriptDocBegin
"Name: button_monitor( <signal> , <bind>, <intermediate>, <checkfunc> )"
"Summary: monitor button presses"
"Module: _wii_utility"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
player_button_monitor( signal, bind, intermediate, checkfunc )
{
//iprintln("WII_UTILITY:player_button_monitor("+intermediate+","+bind+")\n");		
//println("WII_UTILITY:player_button_monitor("+intermediate+","+bind+")\n");		
	self NotifyOnPlayerCommand( intermediate, bind );
	for(;;)
	{
		self waittill( intermediate );
		if ( self [[ checkfunc ]]() )
		{
//iprintln("WII_UTILITY:"+intermediate+" hit");		
//println("WII_UTILITY:"+intermediate+" hit\n");		
			self notify( signal );
		}
		wait 0.07;
	}
}


checkfunc_wii()
{
	return (!self using_classic_controller() && !self using_wii_zapper());
}
checkfunc_ccp()
{
	return (self using_classic_controller());
}
checkfunc_zap()
{
	return (self using_wii_zapper());
}


/*
=============
///ScriptDocBegin
"Name: wii_NotifyOnCommand( <signal> , <ccp_bind>, <wii_bind>, <zap_bind> )"
"Summary: acts like NotifyOnCommand() but looks for different buttons on different types of controllers. Unlike NotifyOnCommand() this notification ends when the calling thread ends"
"Module: _wii_utility"
"CallOn: A player"
"MandatoryArg: <signal>: The signal raised when the button is pressed."
"MandatoryArg: <ccp_bind>: The binding to watch on the CCP controller."
"MandatoryArg: <wii_bind>: The binding to watch on a non-Zapper wiimote controller."
"MandatoryArg: <zap_bind>: The binding to watch on the Zapper controller."
"Example: level.player wii_notifyOnCommand("we_get_signal","weapnext", "weapnext", "+actionslot 4"); level.player waittill("we_get_signal:) main_screen_turn_on();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

wii_NotifyOnPlayerCommand( signal, ccp_bind, wii_bind, zap_bind )
{
	intermediate_w=signal + "_w";
	intermediate_c=signal + "_c";
	intermediate_z=signal + "_z";
	self childthread player_button_monitor(signal, wii_bind, intermediate_w, ::checkfunc_wii );
	self childthread player_button_monitor(signal, ccp_bind, intermediate_c, ::checkfunc_ccp );
	self childthread player_button_monitor(signal, zap_bind, intermediate_z, ::checkfunc_zap );
}

wii_NotifyOnPlayerCommand_persistent( signal, ccp_bind, wii_bind, zap_bind )
{
	intermediate_w=signal + "_w";
	intermediate_c=signal + "_c";
	intermediate_z=signal + "_z";
	self thread player_button_monitor(signal, wii_bind, intermediate_w, ::checkfunc_wii );
	self thread player_button_monitor(signal, ccp_bind, intermediate_c, ::checkfunc_ccp );
	self thread player_button_monitor(signal, zap_bind, intermediate_z, ::checkfunc_zap );
}


