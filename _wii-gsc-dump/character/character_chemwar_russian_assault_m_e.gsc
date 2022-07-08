
main()
{
self setModel("body_chemwar_russian_assault_e");
codescripts\character::attachHead( "alias_chemwar_russian_heads_masked", xmodelalias\alias_chemwar_russian_heads_masked::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_e");
codescripts\character::precacheModelArray(xmodelalias\alias_chemwar_russian_heads_masked::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_e";
models = codescripts\character::array_append(models,xmodelalias\alias_chemwar_russian_heads_masked::main());
return models;
}
