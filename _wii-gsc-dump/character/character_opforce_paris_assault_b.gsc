
main()
{
self setModel("body_russian_military_assault_b_airborne");
codescripts\character::attachHead( "alias_russian_military_paris_heads", xmodelalias\alias_russian_military_paris_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_assault_b_airborne");
codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_paris_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_assault_b_airborne";
models = codescripts\character::array_append(models,xmodelalias\alias_russian_military_paris_heads::main());
return models;
}
