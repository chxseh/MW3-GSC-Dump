// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_opforce_henchmen_sniper");
	self setViewmodel("viewhands_iw5_sniper_hench");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_body_opforce_henchmen_sniper");
	precacheModel("viewhands_iw5_sniper_hench");
}

enumerate_xmodels()
{
	models = [];
	models[models.size]="mp_body_opforce_henchmen_sniper";
	models[models.size]="viewhands_iw5_sniper_hench";
	return models;
}
