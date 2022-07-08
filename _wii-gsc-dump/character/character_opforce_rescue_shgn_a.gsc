
main()
{
self setModel("body_russian_military_assault_a_arctic");
codescripts\character::attachHead( "alias_russian_military_rescue_heads", xmodelalias\alias_russian_military_rescue_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_assault_a_arctic");
codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_rescue_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_assault_a_arctic";
models = codescripts\character::array_append(models,xmodelalias\alias_russian_military_rescue_heads::main());
return models;
}
