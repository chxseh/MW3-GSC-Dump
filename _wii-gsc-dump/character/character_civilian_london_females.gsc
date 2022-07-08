
main()
{
codescripts\character::setModelFromArray(xmodelalias\alias_civilian_bodies_female::main());
self.voice = "british";
}
precache()
{
codescripts\character::precacheModelArray(xmodelalias\alias_civilian_bodies_female::main());
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,xmodelalias\alias_civilian_bodies_female::main());
return models;
}
