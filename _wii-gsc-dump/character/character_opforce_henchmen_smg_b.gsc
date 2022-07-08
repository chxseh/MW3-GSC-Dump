
main()
{
self setModel("body_henchmen_assault_a");
codescripts\character::attachHead( "alias_henchmen_heads", xmodelalias\alias_henchmen_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_henchmen_assault_a");
codescripts\character::precacheModelArray(xmodelalias\alias_henchmen_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_henchmen_assault_a";
models = codescripts\character::array_append(models,xmodelalias\alias_henchmen_heads::main());
return models;
}
