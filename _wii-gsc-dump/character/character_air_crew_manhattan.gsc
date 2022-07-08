
main()
{
self setModel("body_delta_elite_assault_aa");
codescripts\character::attachHead( "alias_air_crew_heads", xmodelalias\alias_air_crew_heads::main() );
self.voice = "american";
}
precache()
{
precacheModel("body_delta_elite_assault_aa");
codescripts\character::precacheModelArray(xmodelalias\alias_air_crew_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_assault_aa";
models = codescripts\character::array_append(models,xmodelalias\alias_air_crew_heads::main());
return models;
}
