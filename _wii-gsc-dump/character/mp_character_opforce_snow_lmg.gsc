// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_russian_military_lmg_a_snow_wii");
	codescripts\character::attachHead( "alias_russian_military_arctic_heads", xmodelalias\alias_russian_military_arctic_heads::main() );
	self setViewmodel("viewhands_russian_d");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_body_russian_military_lmg_a_snow_wii");
	codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_arctic_heads::main());
	precacheModel("viewhands_russian_d");
}

enumerate_xmodels()
{
	models = [];
	models[models.size]="mp_body_russian_military_lmg_a_snow_wii";
	models = codescripts\character::array_append(models,xmodelalias\alias_russian_military_arctic_heads::main());
	models[models.size]="viewhands_russian_d";
	return models;
}
