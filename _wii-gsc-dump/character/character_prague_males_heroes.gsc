
main()
{
codescripts\character::setModelFromArray(xmodelalias\alias_prague_civilian_nonhood_bodies::main());
self.voice = "czech";
}
precache()
{
codescripts\character::precacheModelArray(xmodelalias\alias_prague_civilian_nonhood_bodies::main());
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,xmodelalias\alias_prague_civilian_nonhood_bodies::main());
return models;
}
