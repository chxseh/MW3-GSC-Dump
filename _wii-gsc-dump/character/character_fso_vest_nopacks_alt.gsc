
main()
{
self setModel("body_fso_vest_a");
codescripts\character::attachHead( "alias_fso_heads", xmodelalias\alias_fso_heads::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_fso_vest_a");
codescripts\character::precacheModelArray(xmodelalias\alias_fso_heads::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_fso_vest_a";
models = codescripts\character::array_append(models,xmodelalias\alias_fso_heads::main());
return models;
}
