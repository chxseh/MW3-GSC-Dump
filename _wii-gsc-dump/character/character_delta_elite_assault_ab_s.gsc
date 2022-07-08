
main()
{
self setModel("body_delta_elite_assault_ab_s");
codescripts\character::attachHead( "alias_delta_elite_heads_longsleeves_s", xmodelalias\alias_delta_elite_heads_longsleeves_s::main() );
self.voice = "delta";
}
precache()
{
precacheModel("body_delta_elite_assault_ab_s");
codescripts\character::precacheModelArray(xmodelalias\alias_delta_elite_heads_longsleeves_s::main());
}
enumerate_xmodels()
{
models = [];
models[models.size]="body_delta_elite_assault_ab_s";
models = codescripts\character::array_append(models,xmodelalias\alias_delta_elite_heads_longsleeves_s::main());
return models;
}
