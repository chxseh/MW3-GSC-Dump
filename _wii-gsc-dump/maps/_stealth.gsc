#include maps\_stealth_shared_utilities;
main()
{
maps\_stealth_visibility_system::stealth_visibility_system_main();
maps\_stealth_behavior_system::stealth_behavior_system_main();
maps\_stealth_corpse_system::stealth_corpse_system_main();
maps\_stealth_anims::main();
level.global_callbacks[ "_autosave_stealthcheck" ] = ::_autosave_stealthcheck;
level.global_callbacks[ "_patrol_endon_spotted_flag" ] = ::_patrol_endon_spotted_flag;
level.global_callbacks[ "_spawner_stealth_default" ] = ::_spawner_stealth_default;
}