// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_gign_paris_shotgun");
	codescripts\character::attachHead( "alias_gign_heads", xmodelalias\alias_gign_heads::main() );
	self setViewmodel("viewhands_sas");
	self.voice = "french";
}

precache()
{
	precacheModel("mp_body_gign_paris_shotgun");
	codescripts\character::precacheModelArray(xmodelalias\alias_gign_heads::main());
	precacheModel("viewhands_sas");
}

enumerate_xmodels()
{
	models = [];
	models[models.size]="mp_body_gign_paris_shotgun";
	models = codescripts\character::array_append(models,xmodelalias\alias_gign_heads::main());
	models[models.size]="viewhands_sas";
	return models;
}
