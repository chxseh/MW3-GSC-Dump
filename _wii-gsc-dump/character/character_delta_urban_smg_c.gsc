
main()
{
self setModel("body_delta_urban_smg_c");
codescripts\character::attachHead( "alias_delta_heads", xmodelalias\alias_delta_heads::main() );
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_urban_smg_c");
codescripts\character::precacheModelArray(xmodelalias\alias_delta_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_urban_smg_c";
models = codescripts\character::array_append(models,xmodelalias\alias_delta_heads::main());
return models;
}
