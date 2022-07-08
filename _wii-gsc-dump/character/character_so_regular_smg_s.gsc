
main()
{
self setModel("body_russian_military_smg_a_airborne_s");
codescripts\character::attachHead( "alias_so_regular_smg_heads_s", xmodelalias\alias_so_regular_smg_heads_s::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_smg_a_airborne_s");
codescripts\character::precacheModelArray(xmodelalias\alias_so_regular_smg_heads_s::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_smg_a_airborne_s";
models = codescripts\character::array_append(models,xmodelalias\alias_so_regular_smg_heads_s::main());
return models;
}
