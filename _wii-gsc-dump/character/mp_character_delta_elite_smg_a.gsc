// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_delta_elite_smg_wii");
	codescripts\character::attachHead( "alias_delta_elite_heads", xmodelalias\alias_delta_elite_heads::main() );
	self setViewmodel("viewhands_delta_mp");
	self.voice = "delta";
}

precache()
{
	precacheModel("mp_body_delta_elite_smg_wii");
	codescripts\character::precacheModelArray(xmodelalias\alias_delta_elite_heads::main());
	precacheModel("viewhands_delta_mp");
}

enumerate_xmodels()
{
	models = [];
	models[models.size]="mp_body_delta_elite_smg_wii";
	models = codescripts\character::array_append(models,xmodelalias\alias_delta_elite_heads::main());
	models[models.size]="viewhands_delta_mp";
	return models;
}
