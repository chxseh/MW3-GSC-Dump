
main()
{
self setModel("body_rangers_bdu_assault_a");
codescripts\character::attachHead( "alias_rangers_heads", xmodelalias\alias_rangers_heads::main() );
self.voice = "american";
}
precache()
{
precacheModel("body_rangers_bdu_assault_a");
codescripts\character::precacheModelArray(xmodelalias\alias_rangers_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_rangers_bdu_assault_a";
models = codescripts\character::array_append(models,xmodelalias\alias_rangers_heads::main());
return models;
}
