
main()
{
self setModel("body_russian_military_lmg_a_airborne");
codescripts\character::attachHead( "alias_russian_military_prague_heads", xmodelalias\alias_russian_military_prague_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_lmg_a_airborne");
codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_prague_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_lmg_a_airborne";
models = codescripts\character::array_append(models,xmodelalias\alias_russian_military_prague_heads::main());
return models;
}
