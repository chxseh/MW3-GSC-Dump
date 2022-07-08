
main()
{
self setModel("body_fso_vest_a_dirty");
codescripts\character::attachHead( "alias_fso_heads_dirty", xmodelalias\alias_fso_heads_dirty::main() );
self.voice = "russian";
}
precache()
{
precacheModel("body_fso_vest_a_dirty");
codescripts\character::precacheModelArray(xmodelalias\alias_fso_heads_dirty::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_fso_vest_a_dirty";
models = codescripts\character::array_append(models,xmodelalias\alias_fso_heads_dirty::main());
return models;
}
