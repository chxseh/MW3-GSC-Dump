
main()
{
self setModel("body_russian_military_assault_a_black_s");
codescripts\character::attachHead( "alias_so_veteran_ar_heads_s", xmodelalias\alias_so_veteran_ar_heads_s::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_russian_military_assault_a_black_s");
codescripts\character::precacheModelArray(xmodelalias\alias_so_veteran_ar_heads_s::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_russian_military_assault_a_black_s";
models = codescripts\character::array_append(models,xmodelalias\alias_so_veteran_ar_heads_s::main());
return models;
}
