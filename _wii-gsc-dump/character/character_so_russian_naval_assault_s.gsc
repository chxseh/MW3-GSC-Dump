
main()
{
codescripts\character::setModelFromArray(xmodelalias\alias_so_russian_naval_bodies_s::main());
codescripts\character::attachHead( "alias_russian_naval_heads_s", xmodelalias\alias_russian_naval_heads_s::main() );
self.voice = "russian";
}
precache()
{
codescripts\character::precacheModelArray(xmodelalias\alias_so_russian_naval_bodies_s::main());
codescripts\character::precacheModelArray(xmodelalias\alias_russian_naval_heads_s::main());
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,xmodelalias\alias_so_russian_naval_bodies_s::main());
models = codescripts\character::array_append(models,xmodelalias\alias_russian_naval_heads_s::main());
return models;
}
