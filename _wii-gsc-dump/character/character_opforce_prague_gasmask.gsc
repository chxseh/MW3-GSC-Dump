
main()
{
codescripts\character::setModelFromArray(xmodelalias\alias_russian_military_gasmask_bodies::main());
self attach("head_russian_military_gasmask_wii", "", true);
self.headModel = "head_russian_military_gasmask_wii";
self.voice = "russian";
}
precache()
{
codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_gasmask_bodies::main());
precacheModel("head_russian_military_gasmask_wii");
}
enumerate_xmodels()
{
models = [];
models = codescripts\character::array_append(models,xmodelalias\alias_russian_military_gasmask_bodies::main());
models[models.size]="head_russian_military_gasmask_wii";
return models;
}
