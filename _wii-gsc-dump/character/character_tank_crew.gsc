
main()
{
self setModel("body_tank_crew_a");
codescripts\character::attachHead( "alias_tank_crew_heads", xmodelalias\alias_tank_crew_heads::main() );
self.voice = "american";
}
precache()
{
precacheModel("body_tank_crew_a");
codescripts\character::precacheModelArray(xmodelalias\alias_tank_crew_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_tank_crew_a";
models = codescripts\character::array_append(models,xmodelalias\alias_tank_crew_heads::main());
return models;
}
