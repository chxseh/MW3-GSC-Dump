setModelFromArray( a )
{
self setModel( a[ randomint( a.size ) ] );
}
precacheModelArray( a )
{
for ( i = 0; i < a.size; i++ )
precacheModel( a[ i ] );
}
attachHead( headAlias, headArray )
{
if ( !isdefined( level.character_head_index ) )
level.character_head_index = [];
if ( !isdefined( level.character_head_index[ headAlias ] ) )
level.character_head_index[ headAlias ] = randomint( headArray.size );
assert( level.character_head_index[ headAlias ] < headArray.size );
index = ( level.character_head_index[ headAlias ] + 1 ) % headArray.size;
if ( isdefined( self.script_char_index ) )
{
index = self.script_char_index % headArray.size;
}
level.character_head_index[ headAlias ] = index;
self attach( headArray[ index ], "", true );
self.headModel = headArray[ index ];
}
attachHat( hatAlias, hatArray )
{
if ( !isdefined( level.character_hat_index ) )
level.character_hat_index = [];
if ( !isdefined( level.character_hat_index[ hatAlias ] ) )
level.character_hat_index[ hatAlias ] = randomint( hatArray.size );
assert( level.character_hat_index[ hatAlias ] < hatArray.size );
index = ( level.character_hat_index[ hatAlias ] + 1 ) % hatArray.size;
level.character_hat_index[ hatAlias ] = index;
self attach( hatArray[ index ] );
self.hatModel = hatArray[ index ];
}
new()
{
self detachAll();
oldGunHand = self.anim_gunHand;
if ( !isdefined( oldGunHand ) )
return;
self.anim_gunHand = "none";
self [[ anim.PutGunInHand ]]( oldGunHand );
}
save()
{
info[ "gunHand" ] = self.anim_gunHand;
info[ "gunInHand" ] = self.anim_gunInHand;
info[ "model" ] = self.model;
info[ "hatModel" ] = self.hatModel;
if ( isdefined( self.name ) )
{
info[ "name" ] = self.name;
println( "Save: Guy has name ", self.name );
}
else
println( "save: Guy had no name!" );
attachSize = self getAttachSize();
for ( i = 0; i < attachSize; i++ )
{
info[ "attach" ][ i ][ "model" ] = self getAttachModelName( i );
info[ "attach" ][ i ][ "tag" ] = self getAttachTagName( i );
}
return info;
}
load( info )
{
self detachAll();
self.anim_gunHand = info[ "gunHand" ];
self.anim_gunInHand = info[ "gunInHand" ];
self setModel( info[ "model" ] );
self.hatModel = info[ "hatModel" ];
if ( isdefined( info[ "name" ] ) )
{
self.name = info[ "name" ];
println( "Load: Guy has name ", self.name );
}
else
println( "Load: Guy had no name!" );
attachInfo = info[ "attach" ];
attachSize = attachInfo.size;
for ( i = 0; i < attachSize; i++ )
self attach( attachInfo[ i ][ "model" ], attachInfo[ i ][ "tag" ] );
}
precache( info )
{
if ( isdefined( info[ "name" ] ) )
println( "Precache: Guy has name ", info[ "name" ] );
else
println( "Precache: Guy had no name!" );
precacheModel( info[ "model" ] );
attachInfo = info[ "attach" ];
attachSize = attachInfo.size;
for ( i = 0; i < attachSize; i++ )
precacheModel( attachInfo[ i ][ "model" ] );
}
get_random_character( amount )
{
self_info = strtok( self.classname, "_" );
if ( !common_scripts\utility::isSP() )
{
if ( isDefined( self.pers["modelIndex"] ) && self.pers["modelIndex"] < amount )
return self.pers["modelIndex"];
index = randomInt( amount );
self.pers["modelIndex"] = index;
return index;
}
else if ( self_info.size <= 2 )
{
return randomint( amount );
}
group = "auto";
index = undefined;
prefix = self_info[ 2 ];
if ( isdefined( self.script_char_index ) )
{
index = self.script_char_index;
}
if ( isdefined( self.script_char_group ) )
{
type = "grouped";
group = "group_" + self.script_char_group;
}
if ( !isdefined( level.character_index_cache ) )
{
level.character_index_cache = [];
}
if ( !isdefined( level.character_index_cache[ prefix ] ) )
{
level.character_index_cache[ prefix ] = [];
}
if ( !isdefined( level.character_index_cache[ prefix ][ group ] ) )
{
initialize_character_group( prefix, group, amount );
}
if ( !isdefined( index ) )
{
index = get_least_used_index( prefix, group );
if ( !isdefined( index ) )
{
index = randomint( 5000 );
}
}
while ( index >= amount )
{
index -= amount;
}
level.character_index_cache[ prefix ][ group ][ index ]++;
return index;
}
get_least_used_index( prefix, group )
{
lowest_indices = [];
lowest_use = level.character_index_cache[ prefix ][ group ][ 0 ];
lowest_indices[ 0 ] = 0;
for ( i = 1; i < level.character_index_cache[ prefix ][ group ].size; i++ )
{
if ( level.character_index_cache[ prefix ][ group ][ i ] > lowest_use )
{
continue;
}
if ( level.character_index_cache[ prefix ][ group ][ i ] < lowest_use )
{
lowest_indices = [];
lowest_use = level.character_index_cache[ prefix ][ group ][ i ];
}
lowest_indices[ lowest_indices.size ] = i;
}
assertex( lowest_indices.size, "Tried to spawn a character but the lowest indices didn't exist" );
return random( lowest_indices );
}
initialize_character_group( prefix, group, amount )
{
for ( i = 0; i < amount; i++ )
{
level.character_index_cache[ prefix ][ group ][ i ] = 0;
}
}
get_random_weapon( amount )
{
return randomint( amount );
}
random( array )
{
return array [ randomint( array.size ) ];
}
array_append( a1, a2 )
{
a = [];
if (IsDefined(a1) && IsDefined(a1.size) && a1.size>0 )
for (i=0; i<a1.size; i++)
a[a.size]=a1[i];
if (IsDefined(a2) && IsDefined(a2.size) && a2.size>0 )
for (i=0; i<a2.size; i++)
a[a.size]=a2[i];
return a;
}
call_enumerate_xmodel_callback( list )
{
if (IsDefined(list) && IsDefined(list.size) && list.size>0 )
for (i=0; i<list.size; i++)
executexmodelenumerationcallback( list[i] );
}