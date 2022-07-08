
main()
{
self setModel("body_chemwar_russian_assault_d_s");
codescripts\character::attachHead( "alias_chemwar_russian_heads_so_s", xmodelalias\alias_chemwar_russian_heads_so_s::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_chemwar_russian_assault_d_s");
codescripts\character::precacheModelArray(xmodelalias\alias_chemwar_russian_heads_so_s::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_chemwar_russian_assault_d_s";
models = codescripts\character::array_append(models,xmodelalias\alias_chemwar_russian_heads_so_s::main());
return models;
}
