// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_fullbody_opforce_juggernaut");
	self setViewmodel("viewhands_juggernaut_opforce");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_fullbody_opforce_juggernaut");
	precacheModel("viewhands_juggernaut_opforce");
}

enumerate_xmodels()
{
	models = [];
	models[models.size]="mp_fullbody_opforce_juggernaut";
	models[models.size]="viewhands_juggernaut_opforce";
	return models;
}
