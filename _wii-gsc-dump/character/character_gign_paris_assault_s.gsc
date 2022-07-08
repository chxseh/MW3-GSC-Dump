
main()
{
self setModel("body_gign_paris_assault_s");
codescripts\character::attachHead( "alias_gign_heads_s", xmodelalias\alias_gign_heads_s::main() );
self.voice = "french";
}
precache()
{
precacheModel("body_gign_paris_assault_s");
codescripts\character::precacheModelArray(xmodelalias\alias_gign_heads_s::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_gign_paris_assault_s";
models = codescripts\character::array_append(models,xmodelalias\alias_gign_heads_s::main());
return models;
}
