
main()
{
self setModel("body_delta_elite_assault_ba");
codescripts\character::attachHead( "alias_delta_elite_heads", xmodelalias\alias_delta_elite_heads::main() );
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_elite_assault_ba");
codescripts\character::precacheModelArray(xmodelalias\alias_delta_elite_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_assault_ba";
models = codescripts\character::array_append(models,xmodelalias\alias_delta_elite_heads::main());
return models;
}
