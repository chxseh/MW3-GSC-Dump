
main()
{
self setModel("russian_presidents_daughter_body_dirty");
self attach("russian_presidents_daughter_head_dirty", "", true);
self.headModel = "russian_presidents_daughter_head_dirty";
self.voice = "russian";
}
precache()
{
precacheModel("russian_presidents_daughter_body_dirty");
precacheModel("russian_presidents_daughter_head_dirty");
}
enumerate_xmodels()
{
models = [];
models[models.size]="russian_presidents_daughter_body_dirty";
models[models.size]="russian_presidents_daughter_head_dirty";
return models;
}
