
main()
{
self setModel("body_chemwar_russian_assault_c");
codescripts\character::attachHead( "alias_chemwar_russian_heads", xmodelalias\alias_chemwar_russian_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_c");
codescripts\character::precacheModelArray(xmodelalias\alias_chemwar_russian_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_c";
models = codescripts\character::array_append(models,xmodelalias\alias_chemwar_russian_heads::main());
return models;
}
