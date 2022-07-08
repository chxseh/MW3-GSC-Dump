
main()
{
self setModel("body_russian_military_smg_a_woodland");
codescripts\character::attachHead( "alias_russian_military_germany_heads", xmodelalias\alias_russian_military_germany_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_smg_a_woodland");
codescripts\character::precacheModelArray(xmodelalias\alias_russian_military_germany_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_smg_a_woodland";
models = codescripts\character::array_append(models,xmodelalias\alias_russian_military_germany_heads::main());
return models;
}
