// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_henchmen_shotgun_wii");
	self attach("head_henchmen_a", "", true);
	self.headModel = "head_henchmen_a";
	self setViewmodel("viewhands_henchmen");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_body_henchmen_shotgun_wii");
	precacheModel("head_henchmen_a");
	precacheModel("viewhands_henchmen");
}

enumerate_xmodels()
{
	models = [];
	models[models.size]="mp_body_henchmen_shotgun_wii";
	models[models.size]="head_henchmen_a";
	models[models.size]="viewhands_henchmen";
	return models;
}
