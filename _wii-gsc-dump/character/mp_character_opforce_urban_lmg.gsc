// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_russian_military_lmg_a_urban_wii");
	self attach("head_russian_military_b", "", true);
	self.headModel = "head_russian_military_b";
	self setViewmodel("viewhands_russian_a");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_body_russian_military_lmg_a_urban_wii");
	precacheModel("head_russian_military_b");
	precacheModel("viewhands_russian_a");
}

enumerate_xmodels()
{
	models = [];
	models[models.size]="mp_body_russian_military_lmg_a_urban_wii";
	models[models.size]="head_russian_military_b";
	models[models.size]="viewhands_russian_a";
	return models;
}
