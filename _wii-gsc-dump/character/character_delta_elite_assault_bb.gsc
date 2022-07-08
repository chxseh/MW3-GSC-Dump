
main()
{
self setModel("body_delta_elite_assault_bb");
codescripts\character::attachHead( "alias_delta_elite_heads_longsleeves", xmodelalias\alias_delta_elite_heads_longsleeves::main() );
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_elite_assault_bb");
codescripts\character::precacheModelArray(xmodelalias\alias_delta_elite_heads_longsleeves::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_assault_bb";
models = codescripts\character::array_append(models,xmodelalias\alias_delta_elite_heads_longsleeves::main());
return models;
}
