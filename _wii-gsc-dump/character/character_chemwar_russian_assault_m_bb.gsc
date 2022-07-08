
main()
{
self setModel("body_chemwar_russian_assault_bb");
codescripts\character::attachHead( "alias_chemwar_russian_heads_masked", xmodelalias\alias_chemwar_russian_heads_masked::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_bb");
codescripts\character::precacheModelArray(xmodelalias\alias_chemwar_russian_heads_masked::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_bb";
models = codescripts\character::array_append(models,xmodelalias\alias_chemwar_russian_heads_masked::main());
return models;
}
