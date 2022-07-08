
LevelNotify(level_notify, param1, param2)
{
if ( isdefined( param1 ) && isdefined( param2 ) )
{
level notify( level_notify, param1, param2 );
}
else if( isdefined( param1 ) )
{
level notify( level_notify, param1 );
}
else
{
level notify ( level_notify );
}
}
