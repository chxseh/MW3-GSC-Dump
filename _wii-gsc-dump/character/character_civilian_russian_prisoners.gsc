
main()
{
codescripts\character::setModelFromArray(xmodelalias\alias_russian_prisoner_bodies::main());
codescripts\character::attachHead( "alias_russian_naval_heads", xmodelalias\alias_russian_naval_heads::main() );
self.voice = "russian";
}
precache()
{
codescripts\character::precacheModelArray(xmodelalias\alias_russian_prisoner_bodies::main());
codescripts\character::precacheModelArray(xmodelalias\alias_russian_naval_heads::main());
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,xmodelalias\alias_russian_prisoner_bodies::main());
models = codescripts\character::array_append(models,xmodelalias\alias_russian_naval_heads::main());
return models;
}
