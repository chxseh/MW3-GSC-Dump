
main()
{
self setModel("body_gign_paris_assault");
codescripts\character::attachHead( "alias_gign_heads", xmodelalias\alias_gign_heads::main() );
self.voice = "french";
}
precache()
{
precacheModel("body_gign_paris_assault");
codescripts\character::precacheModelArray(xmodelalias\alias_gign_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_gign_paris_assault";
models = codescripts\character::array_append(models,xmodelalias\alias_gign_heads::main());
return models;
}
