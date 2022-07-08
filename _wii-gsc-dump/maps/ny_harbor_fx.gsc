#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_gameevents;
#include maps\_shg_common;
main()
{
flag_init("start_sinking");
flag_init("russian_sub_spawned");
flag_init("fx_player_surfaced");
flag_init("detonate_torpedo");
flag_init("fx_chinook_screen_watersplash");
flag_init( "sub_surface_rumble" );
flag_init("trigger_vfx_pipe_burst");
flag_init("trigger_vfx_pipe_burst_cr");
flag_init("trigger_vfx_pipe_burst_mr");
flag_init("flag_ship_splode_1_fx");
flag_init("flag_ship_splode_2_fx");
flag_init("flag_ship_splode_3_fx");
flag_init("flag_ship_splode_4_fx");
flag_init("flag_ship_splode_5_fx");
flag_init("flag_ship_splode_6_fx");
flag_init("flag_destroyer_fx");
flag_init("msg_fx_under_docks");
init_smVals();
thread precacheFX();
thread treadfx_override();
maps\createfx\ny_harbor_fx::main();
setup_shg_fx();
thread convertoneshot();
thread vfx_pipe_burst();
thread vfx_pipe_burst_cr();
thread vfx_pipe_burst_mr();
thread setup_poison_wake_volumes();
thread kickoff_godrays_1();
thread bubble_wash_player_exiting_gate();
thread tunnel_vent_bubbles_wide();
thread tunnel_vent_bubbles();
thread sinking_ship_vfx_sequence();
thread minisub_dust_kick_player();
thread kill_distance_depth_charges();
thread torpedo_explosion_distance_vfx();
thread cine_sub_surfacing_explosions();
thread oscar02_propwash_vfx();
thread oscar02_body_water_displacement_vfx();
thread cine_sub_surfacing_env_vfx();
thread oscar_cine_water_displacement_vfx();
thread bubble_transition_entering_mine_plant();
thread bubble_on_player_mine_plant();
thread player_surfacing_vfx();
thread sandman_surfacing_vfx();
thread surface_dvora_hideparts();
thread surface_sub_breach_moment();
thread surface_start_smoke_column();
thread surface_building_hit_moment();
thread surface_building_hit_moment2();
thread surface_sub_ambient_fx();
thread starthindDust();
thread trigger_harbor_fx();
thread trigger_surface_vision_set();
thread sub_breach_vision_change();
thread zodiac_escape_vision_change();
level thread near_water_hits_watcherA();
level thread near_water_hits_watcherB();
level thread near_water_hits_watcherC();
thread calc_fire_reflections();
thread surface_sub_tail_foam();
thread loop_skybox_hinds();
thread loop_skybox_migs();
thread start_waves_hidden();
thread play_slava_missiles();
thread chinook_extraction_fx();
thread chinook_screen_watersplash();
thread sub_breached_drainage_fx();
thread chinook_interiorfx();
thread disable_ambient_under_docks();
thread fx_zone_watcher(1000,"msg_vfx_tunnel_a","msg_vfx_tunnel_b");
thread fx_zone_watcher(1500,"msg_vfx_tunnel_b");
thread fx_zone_watcher(1600,"msg_vfx_tunnel_a");
thread fx_zone_watcher(2000,"msg_vfx_udrwtr_a");
thread fx_zone_watcher(3000,"msg_vfx_udrwtr_b");
thread fx_zone_watcher(4000,"msg_vfx_udrwtr_c");
thread fx_zone_watcher(5000,"msg_vfx_sub_interior_a");
thread fx_zone_watcher(5100,"msg_vfx_sub_interior_a1");
thread fx_zone_watcher(5200,"msg_vfx_sub_interior_a2");
thread fx_zone_watcher(5300,"msg_vfx_sub_interior_a3");
thread fx_zone_watcher(260,"msg_vfx_sub_interior_red_light_pulse");
thread fx_zone_watcher(5400,"msg_vfx_sub_interior_a4");
thread fx_zone_watcher(5500,"msg_vfx_sub_interior_a5");
thread fx_zone_watcher(6000,"msg_vfx_sub_interior_b");
thread fx_zone_watcher(6050,"msg_vfx_sub_interior_b0");
thread fx_zone_watcher(6100,"msg_vfx_sub_interior_b1");
thread fx_zone_watcher(6200,"msg_vfx_sub_interior_b2");
thread fx_zone_watcher(6500,"msg_vfx_sub_interior_c");
thread fx_zone_watcher(20000,"msg_vfx_surface_zone_20000","msg_vfx_surface_zone_20000","msg_vfx_sub_interior_minus_25000");
thread fx_zone_watcher(21000,"msg_vfx_surface_zone_21000","msg_vfx_surface_zone_21000","msg_vfx_sub_interior_minus_25000");
thread fx_zone_watcher(22000,"msg_vfx_surface_zone_22000","msg_vfx_surface_zone_22000","msg_vfx_sub_interior_minus_25000");
thread fx_zone_watcher(23000,"msg_vfx_surface_zone_23000","msg_vfx_surface_zone_23000","msg_vfx_sub_interior_minus_25000");
thread fx_zone_watcher(25000,"msg_vfx_surface_zone_25000","msg_vfx_surface_zone_25000","msg_vfx_sub_interior_minus_25000");
thread fx_zone_watcher_both(25001,"msg_vfx_surface_zone_25000", "sub_breach_finished");
thread fx_zone_watcher(26000,"msg_vfx_surface_zone_26000");
}
init_smVals()
{
setsaveddvar("fx_alphathreshold",11);
}
start_harbor_landexplosions()
{
level endon("msg_nyharbor_stoplandexplosions");
wait(10.0);
missile_launchers = [(-23478, -7706, 2923),
(-22185, -8779, 2180),
(-23378, -6212, 5748),
(-23424, -6366, 7314),
(-19972, -9802, 5410),
(-20379, -10371, 4822),
(-20035, -10621, 5546),
(-15733, -13971, 3326),
(-15685, -14066, 4087),
(-14732, -11701, 5727),
(-15379, -14279, 4894),
(-15221, -14225, 6551),
(-15507, -13927, 7272),
(-15628, -13548, 7604),
(-15548, -14034, 8099),
(-14356, -14567, 4206),
(-14039, -14379, 3792),
(-10906, -12809, 1927),
(-25745, -10676, 1154),
(-11855, -17013, 87),
(-17644, -14389, 59),
(-40405, -20724, 47),
(-39551, -14037, 1154),
(3869, -55407, 2641),
(-591, -58842, 2617),
(-14109, -27253, 727),
(-16280, -26991, 559),
(-12941, -60922, 1411),
(-17831, -11150, 5230),
(-37800, -14379, 749),
(-36001, -14058, 1100),
(-28545, -9132, 767),
(6874, -30979, 1168),
(-11626, -27742, 750)];
thread shg_spawn_tendrils(700,"smoke_geotrail_genericexplosion",7,500,2000,10,30,200,75,1200);
to1 = spawn_tag_origin();
to1.origin = level.player getorigin();
to1.angles = ( 270, 0, -45);
fxEnts = [];
ent = get_exploder_ent(700);
wait(1.0);
for(;;)
{
flag_waitopen("msg_vfx_sub_interior_minus_25000");
playerAng = level.player getplayerangles();
eye = vectornormalize(anglestoforward(playerAng));
found_exp = -1;
final_exp_pos = [];
for ( i = 0;i < missile_launchers.size;i++ )
{
if ( !isdefined( ent ) )
continue;
toFX = vectornormalize(missile_launchers[i]-level.player.origin);
if(vectordot(eye,toFX)>.45)
{
found_exp = 1;
final_exp_pos[final_exp_pos.size] = missile_launchers[i];
}
}
if(found_exp >0)
{
curr_exp_num = randomInt((final_exp_pos.size+1));
if(isdefined(curr_exp_num))
{
origin = final_exp_pos[curr_exp_num];
if(isdefined(ent) && isdefined(origin) )
{
ent.v["origin"] = origin;
exploder(700);
aud_send_msg("land_explosion", origin);
}
}
}
wait(2.0);
}
}
start_harbor_waterexplosions()
{
level endon("msg_nyharbor_stopwaterexplosions");
level endon("switch_chinook");
wait(1.0);
missile_launchers = [(-16078.9, -21985.4, -200)
,(-16816.5, -20880.9, -200)
,(-18183.6, -18682.9, -200)
,(-18336.6, -22499, -200)
,(-19216.4, -24298.5, -200)
,(-20321.3, -23572.2, -200)
,(-20265.5, -25595.6, -200)
,(-20735.7, -27581.2, -200)
,(-22218.2, -27296.4, -200)
,(-19044.7, -27895.1, -200)
,(-18075.8, -29197.2, -200)
,(-17744, -30302.6, -200)
,(-17999.4, -28065.1, -200)
,(-16754.2, -24812.2, -200)
,(-15567.5, -21403.1, -200)
,(-20567.9, -22634.9, -200)
,(-22419.9, -22541.9, -200)
,(-23146.1, -22028.9, -200)
,(-25366.4, -21724.8, -200)
,(-25043.7, -17634.6, -200)
,(-25993.9, -18138.5, -200)
,(-26250.4, -15147.6, -200)
,(-25659.9, -14375.8, -200)
,(-23713.3, -13311.5, -200)
,(-22780.3, -13618.7, -200)
,(-21478, -14437.1, -200)
,(-22617.4, -14448.8, -200)
,(-23806.5, -14948.8, -200)
,(-23644.5, -15660.2, -200)
,(-28572.1, -13679.3, -200)
,(-28228.2, -12692.6, -200)
,(-27916.6, -12271.2, -200)
,(-29142.7, -12614.8, -200)
,(-28393.1, -13857.3, -200)
,(-31218.2, -10518.2, -200)
,(-32947.7, -9691.9, -200)
,(-33643.6, -8825.27, -200)
,(-33621, -7460.5, -200)
,(-32622.4, -7111.54, -200)
,(-35627.4, -7209.94, -200)
,(-35884.1, -6679.09, -200)
,(-36072.6, -5718.29, -200)
,(-35921.5, -4673.62, -200)
,(-35050.2, -4831.81, -200)
,(-35889.1, -5455.13, -200)
,(-38852.8, -5039.36, -200)
,(-40430.3, -4731.15, -200)
,(-40006.1, -5136.87, -200)
,(-41720, -6428.87, -200)
,(-42289.9, -6732.02, -200)
,(-42919, -7569.04, -200)
,(-43737.6, -7743.24, -200)
,(-44748.6, -7912.62, -200)
,(-45201.1, -8196.11, -200)
,(-43944.9, -9585.19, -200)
,(-45505.2, -10311.4, -200)
,(-45846.5, -10420.5, -200)
,(-46029.4, -10493.4, -200)
,(-47543.1, -11105.5, -200)
,(-47441.8, -11546.2, -200)
,(-47907.2, -13315.8, -200)
,(-49340.5, -13184.8, -200)
,(-49846.9, -13546.4, -200)
,(-49886.7, -13569.9, -200)
,(-50055.7, -13249.7, -200)
,(-50757.5, -11968.9, -200)
,(-51311.7, -11834.3, -200)
,(-52190.5, -12655.5, -200)
,(-52377.9, -13990.1, -200)
,(-51499.3, -14423, -200)
,(-51421, -14657.3, -200)
,(-52251.8, -16500.2, -200)
,(-52368.3, -16925.9, -200)
,(-52242.7, -16851.7, -200)
,(-51244.4, -17150.9, -200)
,(-50379.3, -17859.9, -200)
,(-50120.7, -18476.7, -200)
,(-44681.9, -17448.3, -200)
,(-43879.6, -17154.6, -200)
,(-43479.3, -16726, -200)
,(-43063.4, -15127.9, -200)
,(-42987.8, -15359.1, -200)
,(-42286.2, -16393.4, -200)
,(-41453.7, -17380.7, -200)
,(-41378.6, -17010.7, -200)
,(-41172.4, -15877.7, -200)
,(-40568, -16025.7, -200)
,(-40032.1, -17036.5, -200)
,(-40066.7, -17954.3, -200)
,(-41229.4, -18365.4, -200)
,(-42487, -18963, -200)
,(-33784.9, -22706.5, -200)
,(-32928.3, -24092.6, -200)
,(-32805.7, -25060.2, -200)
,(-32799.6, -25218.4, -200)
,(-32935.9, -25547.7, -200)
,(-33131.7, -26361, -200)
,(-33144.1, -26924.8, -200)
,(-32960.4, -27469.7, -200)
,(-32737.9, -28466.1, -200)
,(-32683.1, -28446, -200)
,(-32341.5, -28929.9, -200)
,(-31640.9, -30358.7, -200)
,(-31188.3, -31317.3, -200)
,(-31032.7, -31237.5, -200)
,(-29785.7, -30629.1, -200)
,(-28250.7, -31535.6, -200)
,(-28246.9, -31948.5, -200)
,(-28254.1, -31957, -200)
,(-28467.5, -32222.5, -200)
,(-28823.8, -32628.9, -200)
,(-29495.3, -33378.9, -200)
,(-29826.3, -33751.8, -200)
,(-29825.5, -33746.4, -200)
,(-29844.5, -33592, -200)
,(-30582.3, -32543.2, -200)
,(-31548.1, -32468, -200)
,(-32419.6, -32942.7, -200)
,(-32867, -33544.2, -200)
,(-33027.8, -34026.5, -200)
,(-32915.2, -34432, -200)
,(-32707.8, -34600.1, -200)
,(-32052.9, -34652.6, -200)
,(-31514.5, -34655.9, -200)
,(-30548.6, -34693.2, -200)
,(-29892.7, -34738.4, -200)
,(-28809.5, -34828.7, -200)
,(-26584.5, -34816.2, -200)
,(-25628.3, -34667.6, -200)
,(-25157.4, -34594, -200)
,(-24945.2, -34813.7, -200)
,(-24756, -35644.5, -200)
,(-24775, -37517, -200)
,(-25791.8, -38224.2, -200)
,(-28097.7, -38460.5, -200)
,(-29101.6, -38226.6, -200)
,(-29863.8, -37763.9, -200)
,(-30215.2, -37246.5, -200)
,(-30520.7, -36707.9, -200)
,(-31239.8, -35961.7, -200)
,(-31839.2, -35612.7, -200)
,(-32567.1, -35535.9, -200)
,(-33042.2, -35873.3, -200)
,(-33576.7, -36402.1, -200)
,(-34468, -37275.5, -200)
,(-35055.7, -38052.1, -200)
,(-35065.8, -38466.1, -200)
,(-34695.2, -38761.9, -200)
,(-34282.6, -38943.2, -200)
,(-34316.1, -39559.9, -200)
,(-36498.1, -41442.5, -200)
,(-36734.7, -41555.1, -200)
,(-36808.4, -41017.6, -200)
,(-36901.2, -40131.5, -200)
,(-37105.7, -38808.8, -200)
,(-37242.5, -38294.2, -200)
,(-37652.6, -37773.5, -200)
,(-38465, -37260.7, -200)
,(-39435.1, -36868.1, -200)
,(-40792.8, -36680.6, -200)
,(-41798.2, -36391.3, -200)
,(-41591.9, -37534.7, -200)
,(-41837, -38447.7, -200)
,(-42499.8, -39271.8, -200)
,(-43396.9, -39836.7, -200)
,(-44616.3, -39742.9, -200)
,(-45983.7, -39432, -200)
,(-47076.6, -39397, -200)
,(-47583.7, -39841.6, -200)
,(-47899.1, -40521.4, -200)
,(-48520, -41278.8, -200)
,(-50112.7, -40881.5, -200)
,(-50971.5, -40474.9, -200)
,(-50986.2, -40432.4, -200)
,(-51301.8, -39502.8, -200)];
to1 = spawn_tag_origin();
to1.origin = level.player getorigin();
to1.angles = ( 270, 0, -45);
fxEnts = [];
ent = get_exploder_ent(701);
wait(1.0);
for(;;)
{
flag_waitopen("msg_vfx_sub_interior_minus_25000");
playerAng = level.player getplayerangles();
eye = vectornormalize(anglestoforward(playerAng));
found_exp = -1;
final_exp_pos = [];
for ( i = 0;i < missile_launchers.size;i++ )
{
if ( !isdefined( ent ) )
continue;
toFX = vectornormalize(missile_launchers[i]-level.player.origin);
if(vectordot(eye,toFX)>.45)
{
found_exp = 1;
final_exp_pos[final_exp_pos.size] = missile_launchers[i];
}
}
if(found_exp >0)
{
curr_exp_num = randomInt((final_exp_pos.size+1));
if(isdefined(curr_exp_num))
{
origin = final_exp_pos[curr_exp_num];
if(isdefined(ent) && isdefined(origin) )
{
ent.v["origin"] = origin;
exploder(701);
}
}
}
wait(2.0);
}
}
near_water_hits_watcherA()
{
level waittill("msg_fx_trigger_waterHitA");
exploder(850);
wait(.25);
to1 = spawn_tag_origin();
to1.origin = self.player getorigin();
to1.angles = ( 270, 0, 0);
playfxontag(getfx("large_water_impact_close_rain"),to1,"tag_origin");
wait(10.0);
to1 delete();
}
near_water_hits_watcherB()
{
level waittill("msg_fx_trigger_waterHitB");
exploder(851);
wait(.25);
to1 = spawn_tag_origin();
to1.origin = self.player getorigin();
to1.angles = ( 270, 0, 0);
playfxontag(getfx("large_water_impact_close_rain"),to1,"tag_origin");
wait(10.0);
to1 delete();
}
near_water_hits_watcherC()
{
level waittill("msg_fx_trigger_waterHitC");
exploder(852);
wait(.25);
to1 = spawn_tag_origin();
to1.origin = self.player getorigin();
to1.angles = ( 270, 0, 0);
playfxontag(getfx("large_water_impact_close_rain"),to1,"tag_origin");
wait(10.0);
to1 delete();
}
kickoff_godrays_1()
{
wait(1);
fxent = getfx("lights_godray_beam_harbor");
missile_launchers = [(-39249, -23793.9, -309.083)
,(-39238.2, -23802.1, -302.346)
,(-39239.3, -23842.4, -305.435)
,(-39231.2, -23833.4, -298.456)
,(-39242.1, -23825.2, -305.193)
,(-39410.9, -23784.6, -315.104)
,(-39400.1, -23792.8, -308.367)
,(-39408.2, -23801.8, -315.346)
,(-39404, -23815.9, -311.214)
,(-39401.2, -23833.1, -311.456)
,(-39393.1, -23824.1, -304.477)
,(-38982.4, -23731.1, -300.505)
,(-38971.6, -23739.3, -293.768)
,(-38975.5, -23762.4, -296.615)
,(-38972.7, -23779.6, -296.857)
,(-38964.6, -23770.6, -289.878)
,(-38805.2, -23733.9, -302.235)
,(-38794.4, -23742.1, -295.498)
,(-38798.3, -23765.2, -298.345)
,(-38795.5, -23782.4, -298.587)
,(-38787.4, -23773.4, -291.608)];
expAng = [(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(47.8449, 314.967, 168.305)
,(41.9076, 9.07033, -152.016)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)];
ents = [];
for(;;)
{
flag_wait("fx_zone_5100_active");
for(i=0;i<missile_launchers.size;i++)
{
ents[i]=spawnfx(fxent,missile_launchers[i],anglestoforward(expAng[i]),anglestoup(expAng[i]));
triggerfx(ents[i]);
}
flag_waitopen("fx_zone_5100_active");
for(i=0;i<ents.size;i++)
{
ents[i] delete();
}
}
}
trigger_surface_vision_set()
{
level waittill("msg_fx_set_surface_visionset");
}
surface_building_hit_moment()
{
flag_init("msg_fx_set_buildinghit2");
wait(1.0);
node = getent( "sub_board_anim_node", "targetname" );
exp = get_exploder_ent(248);
exp.v["origin"]= node.origin + (-5035,-4309,380);
des_anim = getent("ny_manhattan_building_exchange_01_facade_des","targetname");
des_anim2 = getent("ny_manhattan_building_exchange_01_facade_des2","targetname");
des_anim3 = getent("ny_manhattan_building_exchange_01_facade_des3","targetname");
des_anim.animname = "building_des";
des_anim2.animname = "building_des";
des_anim3.animname = "building_des";
des_anim setAnimTree();
des_anim2 setAnimTree();
des_anim3 setAnimTree();
des_anim hide();
des_anim2 hide();
des_anim3 hide();
hide_ent = getent("surface_building_hit_undamaged","targetname");
flag_wait("msg_fx_set_buildinghit2");
level notify("msg_nyharbor_stoplandexplosions");
level notify("msg_nyharbor_stopwaterexplosions");
exploder(248);
aud_send_msg("harbor_missile_03");
wait(4.20);
des_anim show();
des_anim2 show();
des_anim3 show();
exploder(240);
aud_send_msg("building_missile_explosion_02");
exploder(241);
wait(.25);
des_anim SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
des_anim2 SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
des_anim3 SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
if( IsDefined( hide_ent ) )
{
hide_ent Hide();
}
wait(.75);
exploder(245);
wait(.25);
exploder(242);
wait(.5);
exploder(243);
wait(.25);
exploder(244);
wait(.50);
exploder(246);
wait(360);
des_anim hide();
des_anim2 hide();
des_anim3 hide();
thread start_harbor_landexplosions();
thread start_harbor_waterexplosions();
}
sub_interior_extinguisherfx( extinguisher )
{
self endon("death");
for(;;)
{
self waittillmatch("looping anim","start_fire");
aud_send_msg("aud_fire_extinguisher_spray", extinguisher);
for(i=0;i<5;i++)
{
playfxontag(getfx("fire_extinguisher_spray"),extinguisher,"tag_fx");
wait(.1);
}
}
}
sub_breach_vision_change()
{
flag_wait("sub_breach_started");
wait(24);
vision_set_fog_changes("ny_harbor_sub_breach", 2);
}
zodiac_escape_vision_change()
{
flag_wait("player_on_boat");
vision_set_fog_changes("ny_harbor_zodiac", 3);
}
surface_building_hit_moment2()
{
wait(1.0);
node = getent( "sub_breach_anim_node", "targetname" );
exp = get_exploder_ent(249);
exp.v["origin"]= (-37920.948,-22439.869,-335);
exp1 = get_exploder_ent(250);
exp1.v["origin"]= (-39290.909,-23624.614,-276.368);
desb_anim = getent("ny_manhattan_building_exchange_01_facade_des4","targetname");
desb_anim.animname = "building_des";
desb_anim setAnimTree();
hide_entb = getent("surface_building_hit_undamaged2","targetname");
desb_anim hide();
flag_wait("sub_breach_started");
wait(15.66);
level notify("msg_fx_player_surfaced");
wait(4.0);
exploder(249);
exploder(250);
aud_send_msg("harbor_missile_03");
desb_anim show();
wait(.7);
level thread screenshake(.25,.5,.2,.25);
wait(2.4);
desb_anim SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
aud_send_msg("building_missile_explosion_01");
exploder(251);
wait(.25);
exploder(252);
hide_entb hide();
wait(200);
desb_anim hide();
}
surface_col_thread(ent)
{
wait(.1);
rot_anim_set = randomfloat(1);
ent setanim(level.scr_anim[ "smoke_column" ][ "rot" ],1.0,1.0,0.0);
ent setanim(level.scr_anim[ "smoke_column" ][ "fire" ],1.0,1.0,0.0);
wait(.1);
for(;;)
{
v_toplayer = level.player.origin-ent.origin;
new_angles = vectortoangles(vectornormalize(v_toplayer));
f_ang_t = (new_angles[1]-90.00);
if(f_ang_t<0) f_ang_t = 360+f_ang_t;
rot_anim_set += .125/600.000;
if(rot_anim_set<0) rot_anim_set = 1.0 + rot_anim_set;
else if(rot_anim_set>1) rot_anim_set = rot_anim_set - 1.0;
ent setanimtime(level.scr_anim[ "smoke_column" ][ "fire" ],clamp(f_ang_t/360.00,0.0,1.0));
ent setanimtime(level.scr_anim[ "smoke_column" ][ "rot" ],rot_anim_set);
wait(.05);
}
}
surface_start_smoke_column()
{
smoke_col_a = getentarray("fx_ny_smoke_column","targetname");
smoke_org = [];
fxid = "ny_column_base";
exploders = level.createFXbyFXID[ fxid ];
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if ( ent.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( ent.v[ "exploder" ] ) )
continue;
smoke_org[smoke_org.size] = ent.v["origin"];
}
}
for(i=0;i<smoke_org.size;i++)
{
if(isdefined(smoke_col_a[i]))
{
smoke_col = smoke_col_a[i];
smoke_col.animname = "smoke_column";
smoke_col.origin = smoke_org[i];
smoke_col setAnimTree();
thread surface_col_thread(smoke_col);
}
}
starting_num = smoke_org.size;
total_bases = smoke_col_a.size+1;
for(i=starting_num;i<total_bases;i++)
{
if(isdefined(smoke_col_a[i]))
{
smoke_col_a[i] delete();
}
}
}
surface_player_water_sheeting()
{
level.player SetWaterSheeting( 2, 7.0 );
}
surface_player_water_sheeting_timed(time)
{
level.player SetWaterSheeting( 2, time );
}
surface_sub_breach_lerpsunlight(currlight,targetlight,time)
{
currframe = 0;
numframes = time*20;
numframes_less = numframes - 1;
while(currframe<(numframes))
{
lerpsun = (targetlight-currlight)*(currframe/numframes_less);
lerpsun += currlight;
setsunlight(lerpsun[0],lerpsun[1],lerpsun[2]);
currframe++;
}
setsunlight(targetlight[0],targetlight[1],targetlight[2]);
}
surface_sub_breach_sunanim(target_sun_dir)
{
sub = level.russian_cine_sub;
old_sun_dir = vectornormalize((.88,.5,.82));
mid_sun_dir = vectornormalize((.34,.939,.82));
final_sun_dir = vectornormalize((-.34,.939,.62));
map_sunlight = getmapsunlight();
amp_sunlight = vectornormalize((map_sunlight[0],map_sunlight[1],map_sunlight[2]))*2.25;
setsundirection(target_sun_dir);
level.sdv_player_arms waittillmatch( "single anim", "waterout" );
thread vision_set_fog_changes( "ny_harbor_surfacing", 0 );
level waitframe();
thread surface_player_water_sheeting_timed(2.0);
wait(2.05);
map_sunlight = getmapsunlight();
amp_sunlight = vectornormalize((map_sunlight[0],map_sunlight[1],map_sunlight[2]))*2.25;
sub waittillmatch("single anim","breach_impact");
lerpSunDirection(old_sun_dir,mid_sun_dir,6.3);
wait(6.3);
lerpSunDirection(mid_sun_dir,final_sun_dir,2);
level.player waittill( "stop_breathing" );
resetsundirection();
}
surface_sub_breach_moment()
{
wait(1.0);
node = getent("sub_breach_anim_node", "targetname" );
scriptnode = spawn( "script_origin", node.origin + (0,0,-96) );
scriptnode.angles = node.angles;
scriptnode2 = spawn( "script_origin", node.origin + (0,0,-96) );
scriptnode2.angles = node.angles;
chainoverride = spawnstruct();
chainoverride.v["name"] = "sub_override";
chainoverride.v["wake"] = ["tag_fx_wake","tag_fx_wake1","tag_fx_wake2","tag_fx_wake3","tag_fx_wake4","tag_fx_wake5","tag_fx_wake6"];
args = spawnstruct();
args.v["fx"]=getfx("ny_harbor_wavech");
args.v["chain"]="wake";
args.v["looptime"]=.04;
args.v["chainset_name"]="sub_override";
args.v["chainset_override"]=chainoverride;
flag_wait( "sub_breach_started" );
level notify("msg_nyharbor_stoplandexplosions");
level notify("msg_nyharbor_stopwaterexplosions");
level notify("msg_fx_stop_slava_missiles");
curr_sun_dir = getMapSunDirection();
new_sun_dir = vectornormalize((.88,.5,.82));
thread surface_sub_breach_sunanim(new_sun_dir);
level.sdv_player_arms waittillmatch( "single anim", "waterout" );
ripple_tag = spawn_tag_origin();
ripple_tag.origin = level.sdv_player_arms.origin + (0,0,40);
ripple_tag.angles = (270,0,0);
ripple_tag linkto(level.sdv_player_arms);
playfxontag(getfx("ny_sub_playerwaterripple"),ripple_tag,"tag_origin");
sub = level.russian_cine_sub;
sub waittillmatch("single anim","start_pre_displace");
flag_set( "sub_surface_rumble" );
displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], (-35271, -21133, -224) );
scriptnode2.origin = (node.origin + (0,0,displacement-118));
sub waittillmatch("single anim","start_wave_anim");
level notify("msg_breach_fx_started");
exploder(222);
xupbowtag = spawn_tag_origin();
xupbowtag.angles = (270,0,0);
xupbowtag.origin = sub gettagorigin("tag_fx_bow2");
xupbowtag linkto(sub,"tag_fx_bow2");
playfxontag(getfx("ny_sub_breachMainBow"),xupbowtag,"tag_origin");
gush_tagA = spawn_tag_origin();
gush_tagA.origin = sub gettagorigin("body");
gush_tagA.angles = sub gettagangles("body");
gush_tagA linkto(sub,"body",(2226,-216,221),(0,0,0));
playfxontag(getfx("ny_sub_breachmainBow_gush"),gush_tagA,"tag_origin");
wait(.1);
level thread screenshake(.25,1,.5,.3);
if ( ( level.Console && level.ps3 ) || !level.Console )
{
SetHalfResParticles( true );
}
sub waittillmatch("single anim","breach_water");
chainoverride.v["wake"] = ["tag_fx_wave","tag_fx_wave1","tag_fx_wave2","tag_fx_wave3","tag_fx_wave4","tag_fx_wave5"];
args.v["fx"]=getfx("ny_harbor_wavelargech");
args.v["chainset_override"]=chainoverride;
args.v["looptime"]=.08;
exploder(220);
playfxontag(getfx("ny_sub_fingush"),sub,"tag_fx_elevator");
playfxontag(getfx("ny_sub_towerbase"),sub,"tag_fx_towerbase");
gush_tagB = spawn_tag_origin();
gush_tagB.origin = sub gettagorigin("tag_origin");
gush_tagB.angles = sub gettagangles("tag_origin");
gush_tagB linkto(sub,"body",(-1130,0,233),(0,0,0));
gush_tagC = spawn_tag_origin();
gush_tagC.origin = gush_tagB.origin;
gush_tagC.angles = gush_tagB.angles;
gush_tagC linkto(sub,"body",(-708,0,233),(0,0,0));
gush_tagD = spawn_tag_origin();
gush_tagD.origin = gush_tagB.origin;
gush_tagD.angles = gush_tagB.angles;
gush_tagD linkto(sub,"body",(0,0,280),(0,0,0));
playfxontag(getfx("ny_sub_directionalgushes"),gush_tagA,"tag_origin");
chainoverride.v["wake"] = ["tag_fx_wake_","tag_fx_wake_1","tag_fx_wake_2","tag_fx_wake_3","tag_fx_wake_4"];
args.v["fx"]=getfx("ny_harbor_wavelargech2");
args.v["chainset_override"]=chainoverride;
args.v["looptime"]=.04;
wait(.5);
wait(.5);
level thread screenshake(.25,1,.3,.53);
wait(.25);
playfx(getfx("ny_sub_sidefroth_before"),(-34172,-20987,-260),anglestoforward((0,0,0)));
playfx(getfx("ny_sub_sidefroth_before"),(-34372,-20987,-260),anglestoforward((0,0,0)));
playfx(getfx("ny_sub_sidefroth_before"),(-34572,-20987,-260),anglestoforward((0,0,0)));
playfx(getfx("ny_sub_sidefroth_before"),(-34772,-20987,-260),anglestoforward((0,0,0)));
playfx(getfx("ny_sub_sidefroth_before"),(-34972,-20987,-260),anglestoforward((0,0,0)));
playfx(getfx("ny_sub_sidefroth_before"),(-35172,-20987,-260),anglestoforward((0,0,0)));
level waitframe();
playfx(getfx("ny_sub_sidefroth_before"),(-35272,-20987,-260),anglestoforward((0,0,0)));
playfx(getfx("ny_sub_sidefroth_before"),(-35372,-20987,-260),anglestoforward((0,0,0)));
playfxontag(getfx("ny_sub_fin_wisp"),gush_tagB,"tag_origin");
playfxontag(getfx("ny_sub_fin_wisp"),gush_tagC,"tag_origin");
playfxontag(getfx("ny_sub_fin_wisp"),gush_tagD,"tag_origin");
thread surface_player_water_sheeting_timed(3.75);
sub waittillmatch("single anim","breach_impact");
level notify("msg_breach_fx_ended");
scriptnode Delete();
wait(.5);
exploder(221);
level thread screenshake(.35,1.5,.3,.53);
wait(.5);
playfxontag(getfx("ny_sub_sideport_4"),sub,"tag_fx_ventback_single7");
wait(.5);
thread surface_player_water_sheeting_timed(4.75);
playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear2");
playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear3");
playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear4");
playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear5");
wait 2;
playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear6");
wait 1;
wait 2.5;
playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear1");
exploder(26011);
wait 1;
playfxontag(getfx("sub_foam_lapping_waves"),sub, "tag_fx_tail_foam");
playfxontag(getfx("sub_breaching_tail_steam"),sub, "tag_fx_tail_foam");
wait 5.35;
thread surface_player_water_sheeting_timed(3.75);
level.player waittill( "stop_breathing" );
if ( ( level.Console && level.ps3 ) || !level.Console )
{
SetHalfResParticles( false );
}
level thread start_harbor_landexplosions();
level thread start_harbor_waterexplosions();
level thread play_slava_missiles();
stopfxontag(getfx("sub_foam_lapping_waves"),sub, "tag_fx_tail_foam");
stopfxontag(getfx("sub_breaching_tail_steam"),sub, "tag_fx_tail_foam");
wait(27.8);
level notify("start_surface_missile_fx");
}
surface_sub_hatch_moment()
{
ent = undefined;
wait(.1);
trigger = getent("fx_id_smokeguy","targetname");
get_guys = getentarray("actor_enemy_opforce_navy_short_P90","classname");
foreach( curr in get_guys)
{
if(isdefined(curr) && isdefined(trigger))
{
if(curr istouching(trigger))
ent = curr;
}
}
if(isdefined(ent))
{
args = spawnstruct();
args.v["ent"]=ent;
args.v["fx"]=getfx("ny_harbor_actor_smoke");
args.v["chain"]="all";
args.v["looptime"]=.16;
notify1 = play_fx_on_actor(args);
args.v["ent"]=ent;
wait(2.0);
level notify(notify1);
}
level.sandman waittillmatch("single anim","show");
wait(3.3);
level thread screenshake(.25,1,.3,.53);
exploder(247);
}
surface_sub_ambient_fx()
{
to1 = spawn_tag_origin();
to1.origin = self.player getorigin();
to1.angles = ( 270, 0, -45);
wait(1);
for(;;)
{
flag_wait("fx_zone_26000_active");
flag_waitopen_both("fx_zone_5000_active","fx_zone_6000_active");
level.sandman waittillmatch("single anim","show");
wait(5.0);
randomInc = randomfloatrange(-1.5,1.5)+2.0;
wait(randomInc);
splashes = get_exploder_entarray(600);
choosesplash = splashes[randomint((splashes.size+1))];
if(isdefined(choosesplash))
{
big_splash = choosesplash activate_individual_exploder();
aud_send_msg("big_splash", big_splash);
}
}
}
surface_waterexp_res(exp_pos)
{
if(!isdefined(level.halfresfxon)) level.halfresfxon = 0;
new_target = exp_pos + (0,0,48);
to_target = (new_target-level.player.origin);
to_target_l = length(to_target);
to_target_n = vectornormalize(to_target);
eye = vectornormalize(anglestoforward(level.player.angles));
ratio = vectordot(to_target_n,eye);
if(ratio>.3 && to_target_l<1000)
{
if ( ( level.Console && level.ps3 ) || !level.Console )
{
SetHalfResParticles( true );
level.halfresfxon ++;
}
wait 2.0;
if ( ( level.Console && level.ps3 ) || !level.Console )
{
if(level.halfresfxon<2) SetHalfResParticles( false );
level.halfresfxon --;
}
}
}
surface_dvora_carrier_fx()
{
chainoverride = spawnstruct();
chainoverride.v["name"] = "dvora_wake";
chainoverride.v["wake"] = ["tag_wave_r1","tag_wave_r2","tag_wave_r3"];
args = spawnstruct();
args.v["ent"]=self;
args.v["fx"]=getfx("ny_harbor_wavech");
args.v["chain"]="wake";
args.v["looptime"]=.04;
args.v["chainset_name"]="dvora_wake";
args.v["chainset_override"]=chainoverride;
fx_tag = spawn_tag_origin();
fx_tag.origin = self gettagorigin("tag_body");
fx_tag.angles = self gettagangles("tag_body");
fx_tag thread updatepos(self,5,0);
fx_tag2 = spawn_tag_origin();
fx_tag2.origin = fx_tag.origin;
fx_tag2.angles = fx_tag.angles;
fx_tag2 thread updatepos(self,5,0);
fx_tag3 = spawn_tag_origin();
fx_tag3.origin = fx_tag.origin;
temp_angles = vectortoangles((-38135,-11469,-188)-(-40283,-13055,-188));
fx_tag3.angles = combineangles((temp_angles),(270,0,0));
fx_tag3 thread updatepos(self,5,0);
level waitframe();
level waittill("msg_fx_start_carrierfx");
PauseFXID( "burning_oil_slick_1" );
playfxontag(getfx("ny_dvora_wakestern_trail"),self,"tag_propeller_fx");
playfxontag(getfx("ny_dvora_wakebow"),fx_tag,"tag_origin");
playfxontag(getfx("ny_dvora_wakebow_trail"),fx_tag2,"tag_origin");
playfxontag(getfx("ny_dvora_wakebow_trailxup"),fx_tag3,"tag_origin");
self waittill( "dvora_destroyed" );
stopfxontag(getfx("ny_dvora_wakebow"),fx_tag,"tag_origin");
stopfxontag(getfx("ny_dvora_wakestern_trail"),self,"tag_propeller_fx");
level waitframe();
playfxontag(getfx("ny_dvora_wakebow2"),fx_tag,"tag_origin");
level waitframe();
playfxontag(getfx("ny_dvora_wakestern_trail2"),self,"tag_propeller_fx");
level waittill("msg_fx_stop_cin_dvorafx");
fx_tag2 notify("fx_stop_updatepos");
fx_tag3 notify("fx_stop_updatepos");
stopfxontag(getfx("ny_dvora_wakebow2"),fx_tag,"tag_origin");
stopfxontag(getfx("ny_dvora_wakebow_trail"),fx_tag2,"tag_origin");
stopfxontag(getfx("ny_dvora_wakebow_trailxup"),fx_tag3,"tag_origin");
stopfxontag(getfx("ny_dvora_wakestern_trail2"),fx_tag,"tag_origin");
fx_tag delete();
fx_tag2 delete();
fx_tag3 delete();
}
updatepos(parent, f_zoffset, i_usedisplacement)
{
self endon("fx_stop_updatepos");
dis_on = 0;
zoffset = 0;
if(isdefined(i_usedisplacement)) dis_on = i_usedisplacement;
if(isdefined(f_zoffset)) zoffset = f_zoffset;
for(;;)
{
origin = parent gettagorigin("tag_body");
angles = parent gettagangles("tag_body");
origin += anglestoforward(angles) * 250;
displacement = 0;
if(dis_on)
{
displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], origin );
}
if(isdefined(self))
{
self moveto((origin[0],origin[1],displacement + zoffset),.12);
}
wait(.12);
}
}
surface_escape_zodiac_bumbfx()
{
level notify("msg_nyharbor_stoplandexplosions");
level notify("msg_nyharbor_stopwaterexplosions");
level notify("msg_fx_stop_slava_missiles");
kill_exploder(242);
kill_exploder(252);
bump_fx_tag = spawn_tag_origin();
bump_fx_tag.origin = self gettagorigin("tag_wheel_front_left");
bump_fx_tag.angles = combineangles(self gettagangles("tag_origin"),(270,0,0));
bump_fx_tag linkto(self,"tag_wheel_front_left");
playfxontag(getfx("ny_dvora_zodiac_bump"),bump_fx_tag,"tag_origin");
wait(.25);
bump_fx_tag2 = spawn_tag_origin();
bump_fx_tag2.origin = level.escape_zodiac_fx gettagorigin("tag_wheel_front_left");
bump_fx_tag2.angles = combineangles(level.escape_zodiac_fx gettagangles("tag_wheel_front_left"),(270,0,0));
bump_fx_tag2 linkto(level.escape_zodiac_fx,"tag_wheel_front_left",(0,0,0),(0,0,0));
level thread screenshake(.35,1,.3,.53);
playfxontag(getfx("ny_dvora_zodiac_bump"),bump_fx_tag2,"tag_origin");
if ( ( level.Console && level.ps3 ) || !level.Console )
{
SetHalfResParticles( true );
level.halfresfxon ++;
}
wait(1.3);
if ( ( level.Console && level.ps3 ) || !level.Console )
{
if(level.halfresfxon<2) SetHalfResParticles( false );
level.halfresfxon --;
}
level notify("msg_fx_start_carrierfx");
bump_fx_tag delete();
bump_fx_tag2 delete();
}
surface_zbur_treadfx()
{
fxtagright = spawn_tag_origin();
fxtagright.origin = self gettagorigin("tag_wheel_back_right");
fxtagright.angles = self gettagangles("tag_wheel_back_right");
fxtagright linkto(self,"tag_wheel_back_right",(0,0,50), (0,0,0) );
fxtagleft = spawn_tag_origin();
fxtagleft.origin = self gettagorigin("tag_wheel_back_right");
fxtagleft.angles = self gettagangles("tag_wheel_back_right");
fxtagleft linkto(self,"tag_wheel_back_left",(0,0,-50),(0,0,0) );
playfxontag(getfx("zubr_wakeside_nyharbor"),fxtagright,"tag_origin");
playfxontag(getfx("zubr_wakeside_nyharbor"),fxtagleft,"tag_origin");
self waittill_either ("death", "stop_fx" );
stopfxontag(getfx("zubr_wakeside_nyharbor"),fxtagright,"tag_origin");
stopfxontag(getfx("zubr_wakeside_nyharbor"),fxtagleft,"tag_origin");
fxtagright delete();
fxtagleft delete();
}
surface_dvora_displace_wake(dvora)
{
dvora endon("death");
for(;;)
{
if(isdefined(self))
{
curr_origin = dvora gettagorigin("tag_propeller_fx");
displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], curr_origin );
origin = (curr_origin[0], curr_origin[1], -225);
angles = dvora gettagangles("tag_propeller_fx");
self.angles = angles;
origin += anglestoforward(angles) * -150;
self moveto((origin[0],origin[1],displacement-300),.2);
wait(.2);
}
}
}
surface_dvora_treadfx()
{
fxtag = spawn_tag_origin();
fxtag.origin = self gettagorigin("tag_propeller_fx");
fxtag.angles = self gettagangles("tag_propeller_fx");
fxtag thread surface_dvora_displace_wake(self);
playfxontag(getfx("dvora_wake_nyharbor"),fxtag,"tag_origin");
level endon("msg_fx_stop_cin_dvorafx");
self waittill("death");
stopfxontag(getfx("dvora_wake_nyharbor"),fxtag,"tag_origin");
fxtag delete();
}
surface_sub_tail_foam()
{
waitframe();
if(level.createfx_enabled) return 0;
foam_origin = ( -40344.3, -23924.7, -235.465 );
foam_angles = ( 288.103, 186.437, -6.33035 );
thread surface_sub_tail_foam_slide(foam_origin, foam_angles);
}
surface_sub_tail_foam_slide(foam_origin, foam_angles)
{
flag_wait("msg_vfx_surface_zone_26000");
fxtag = spawn_tag_origin();
fxtag.origin = foam_origin;
fxtag.angles = foam_angles;
playfxontag(getfx("sub_foam_lapping_waves"), fxtag, "tag_origin");
flag_waitopen("msg_vfx_surface_zone_26000");
stopfxontag(getfx("sub_foam_lapping_waves"), fxtag, "tag_origin");
fxtag delete();
}
surface_sub_tail_foam_slide_update(fxtag)
{
foam_origin = fxtag.origin;
for(;;)
{
if(isdefined(fxtag))
{
flag_wait("msg_vfx_surface_zone_26000");
displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], foam_origin );
origin = foam_origin;
origin += anglestoup(fxtag.angles) * (displacement * 2);
fxtag moveto((origin),.1);
wait(.1);
}
}
}
surface_dvora_npc_hit(dvora,num)
{
damage = undefined;
attacker = undefined;
direction_vec = undefined;
point = undefined;
type = undefined;
modelName = undefined;
tagName = undefined;
partName = undefined;
dflags = undefined;
self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
blood_tag = spawn_tag_origin();
blood_tag.origin = self gettagorigin("j_spine4");
blood_tag.angles = vectortoangles(direction_vec);
blood_tag linkto(self,tagName);
playfxontag(getfx("ny_harbor_dvora_bloodhit"),blood_tag,"tag_origin");
if(num==3)
{
playfxontag(getfx("ny_harbor_dvora_bloodsplat"),dvora,"tag_guy3");
}
wait(2);
blood_tag delete();
}
surface_dvora_npc_hit_thread()
{
i = 0;
foreach(rider in self.riders)
{
rider thread surface_dvora_npc_hit(self,i);
i++;
}
}
surface_dvora_flash()
{
currVis = getdvar("vision_set_current");
visionsetnaked("generic_flash",.08);
wait(.17);
visionsetnaked(currVis,.08);
}
surface_dvora_post_carrier_coverpop()
{
level waittill("msg_fx_play_lastsplash");
wait(2.0);
if ( ( level.Console && level.ps3 ) || !level.Console )
{
SetHalfResParticles( true );
level.halfresfxon ++;
}
wait(2.0);
if ( ( level.Console && level.ps3 ) || !level.Console )
{
if(level.halfresfxon<2) SetHalfResParticles( false );
level.halfresfxon --;
}	wait(2.0);
vel_mult = 20;
for_mult = 600;
curr_pos = level.player.origin;
curr_forward = anglestoforward(level.player.angles);
vel = ((level.player getvelocity())/20.00)+(1,0,0);
vel_vect = vectornormalize(vel);
for_mult = 1000;
target_pos = curr_pos + curr_forward * for_mult + vel * vel_mult;
displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], target_pos );
target_pos1 = (target_pos[0],target_pos[1],displacement-260);
playfx(getfx("ny_harbor_dvora_fallingchunks"),target_pos1,(0,0,1),vel_vect);
playfxontag(getfx("ny_dvora_finalexplosion_splash"),level.z_rail_1,"tag_origin");
}
chinook_board_coverpop()
{
level waittill("msg_fx_play_chinook_board_coverpop");
wait 1.1;
if (isdefined(level.escape_zodiac))
playfxontag(getfx("ny_dvora_finalexplosion_splash"),level.escape_zodiac,"tag_origin");
thread surface_player_water_sheeting_timed(2.0);
}
surface_dvora_post_carrier_waterhits()
{
for(i=0;i<8;i++)
{
vel_mult = 20;
for_mult = 600;
curr_pos = level.player.origin;
curr_forward = anglestoforward(level.player.angles);
vel = ((level.player getvelocity())/20.00)+(1,0,0);
vel_vect = vectornormalize(vel);
side_offset = vectorcross(curr_forward,(0,0,1));
if(i<5) for_mult = 1000;
target_pos = curr_pos + curr_forward * for_mult + vel * vel_mult + side_offset * (-250 + 500 * randomfloat(1.0));
displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], target_pos );
target_pos1 = (target_pos[0],target_pos[1],displacement-260);
aud_send_msg("dvora_post_carrier_splashes", target_pos1);
playfx(getfx("ny_harbor_dvora_fallingchunks"),target_pos1,(0,0,1),vel_vect);
thread surface_waterexp_res(target_pos1);
wait(1);
}
}
surface_dvora_debris_atplayer()
{
vfx_vel = 4000.0;
target = level.escape_zodiac gettagorigin("tag_origin");
source = self gettagorigin("tag_origin");
init_distance = distance(target , source);
init_time = init_distance / vfx_vel;
target += ((level.player getvelocity())/20.0) * init_time;
l_vector = target-source;
nl_vector = vectornormalize(l_vector);
playfx(getfx("ny_harbor_dvora_debrisatplayer"),source,nl_vector,(0,0,1));
}
surface_dvora_chunk_splash(ent,tag,frame)
{
waittime = (frame - 8 - 450.00) / 30.0;
wait(waittime);
lastpos = ent gettagorigin(tag);
level waitframe();
org = ent gettagorigin(tag);
xydiff = (org - lastpos);
org += (xydiff[0],xydiff[1],0)*7;
playfx(getfx("ny_dvora_debris_splash"),(org[0],org[1],-252),(0,0,1),(1,0,0));
}
surface_dvora_chunk_splash_watcher(A,B)
{
thread surface_dvora_chunk_splash(B,"chunk3_11",497);
thread surface_dvora_chunk_splash(A,"chunk2_6",501);
thread surface_dvora_chunk_splash(A,"chunk2_17",506);
thread surface_dvora_chunk_splash(A,"chunk2_14",514);
thread surface_dvora_chunk_splash(B,"chunk3_1",521);
thread surface_dvora_chunk_splash(A,"chunk2_11",522);
thread surface_dvora_chunk_splash(B,"chunk3_8",524);
thread surface_dvora_chunk_splash(B,"chunk3_10",525);
thread surface_dvora_chunk_splash(B,"chunk3_9",527);
thread surface_dvora_chunk_splash(B,"chunk3_4",530);
}
surface_dvora_chunk_firetrail(ent,tag,frame)
{
waittime = (frame - 450.00) / 30.0;
wait(waittime);
playfxontag(getfx("ny_harbor_dvora_chunkemitter"),ent,tag);
}
surface_dvora_chunk_firetrail_watcher(A,B)
{
thread surface_dvora_chunk_firetrail(A,"chunk2_3",455);
thread surface_dvora_chunk_firetrail(A,"chunk2_17",463);
thread surface_dvora_chunk_firetrail(A,"chunk2_11",468);
thread surface_dvora_chunk_firetrail(B,"chunk3_4",470);
thread surface_dvora_chunk_firetrail(B,"chunk3_5",478);
}
surface_dvora_hideparts()
{
level waitframe();
level waitframe();
chunkA_ent = getent("vehicle_russian_super_dvora_mark2_destroyA","targetname");
chunkB_ent = getent("vehicle_russian_super_dvora_mark2_destroyB","targetname");
chunkA_ent hide();
chunkB_ent hide();
}
surface_dvora_destroy_fx(org)
{
boats = [];
boats[0] = self;
self.animname = "dvora";
death2_tag = spawn_tag_origin();
state2_chunks = [];
state3_chunks = [];
for(i=1;i<18;i++)
{
curr_chunk_name = ("chunk2_"+i);
state2_chunks[state2_chunks.size] = curr_chunk_name;
}
for(i=1;i<10;i++)
{
curr_chunk_name = ("chunk3_"+i);
state3_chunks[state3_chunks.size] = curr_chunk_name;
}
chunkA_ent = getent("vehicle_russian_super_dvora_mark2_destroyA","targetname");
chunkB_ent = getent("vehicle_russian_super_dvora_mark2_destroyB","targetname");
death2_tag.origin = chunkA_ent gettagorigin("tag_body_state2");
death2_tag.angles = chunkA_ent gettagangles("tag_body_state2");
death2_tag linkto(chunkA_ent,"tag_body_state2");
chunkA_ent hide();
chunkB_ent hide();
self waittill( "dvora_destroyed" );
aud_send_msg("slowmo_dvora_destroyed");
chunkA_ent show();
chunkA_ent.origin = self gettagorigin("tag_origin");
chunkA_ent.angles = self gettagangles("tag_origin");
chunkA_ent linkto(self,"tag_origin");
chunkA_ent.animname = "dvora";
chunkA_ent setAnimTree();
chunkB_ent.origin = self gettagorigin("tag_origin");
chunkB_ent.angles = self gettagangles("tag_origin");
chunkB_ent linkto(self,"tag_origin");
chunkB_ent.animname = "dvora";
chunkB_ent setAnimTree();
chunkA_ent setanim( level.scr_anim[ "dvora" ][ "destorychunk" ] );
chunkB_ent setanim( level.scr_anim[ "dvora" ][ "destorychunk" ] );
thread surface_dvora_post_carrier_coverpop();
surface_dvora_chunk_splash_watcher(chunkA_ent,chunkB_ent);
surface_dvora_chunk_firetrail_watcher(chunkA_ent,chunkB_ent);
chunkA_ent surface_dvora_debris_atplayer();
playfxontag(getfx("ny_harbor_dvora_death_exp"),chunkA_ent,"tag_deathfx1");
fire_wave_pos = chunkA_ent gettagorigin("tag_deathfx");
fire_wave_pos = (fire_wave_pos[0],fire_wave_pos[1],-183);
playfx(getfx("ny_harbor_dvora_death_firewave"),fire_wave_pos,anglestoforward((270,0,0)));
wait(.05);
playfxontag(getfx("ny_harbor_dvora_death_expinit"),chunkA_ent,"tag_deathfx1");
self hide();
wait(.067);
playfxontag(getfx("ny_harbor_dvora_death_exp"),chunkA_ent,"tag_deathfx2");
playfxontag(getfx("ny_harbor_dvora_death"),chunkA_ent,"tag_deathfx");
wait(.5);
playfxontag(getfx("ny_harbor_dvora_death_exp2"),chunkA_ent,"tag_deathfx3");
wait(.06);
chunkA_ent hidepart("tag_body_state2");
chunkB_ent show();
wait(.27);
playfxontag(getfx("ny_harbor_dvora_death_exp3"),self,"tag_deathfx4");
chunkB_ent hidepart("chunk3_9");
wait(1.63);
curr_boat_pos = self gettagorigin("tag_origin")+(0,00,0);
level notify("msg_fx_stop_cin_dvorafx");
curr_boat_pos = self gettagorigin("tag_origin")+(0,00,0);
playfx(getfx("ny_harbor_dvora_death_splah"),curr_boat_pos,anglestoforward((0,-90,0)));
stopfxontag(getfx("ny_harbor_dvora_death"),self,"tag_deathfx");
aud_send_msg("boat_slowmo_final_splash");
wait(.2);
wait(.25);
level thread screenshake(.3,1,.3,.53);
wait(.25);
curr_boat_pos = chunkA_ent gettagorigin("tag_deathfx")+(150,-50,0);
playfx(getfx("ny_dvora_finalexplosion"),curr_boat_pos,anglestoforward((270,0,0)));
chunkA_ent hide();
chunkB_ent hide();
thread surface_dvora_post_carrier_waterhits();
wait(1.75);
bump_fx_tag = spawn_tag_origin();
chunkB_ent delete();
chunkA_ent delete();
death2_tag delete();
bump_fx_tag delete();
wait(2.0);
exploder(242);
exploder(252);
wait(2.0);
RestartFXID( "burning_oil_slick_1", "exploder" );
wait(3.0);
if (!flag("msg_fx_under_docks"))
{
level thread start_harbor_landexplosions();
wait(1.0);
level thread start_harbor_waterexplosions();
wait(1.0);
level thread play_slava_missiles();
}
thread chinook_board_coverpop();
}
precacheFX()
{
level._effect[ "fire_extinguisher_spray" ] = LoadFX( "props/fire_extinguisher_spray" );
level._effect[ "fire_extinguisher_exp" ] = LoadFX( "props/fire_extinguisher_exp" );
level._effect[ "ny_dvora_wakestern_trail2" ] = LoadFX( "maps/ny_harbor/ny_dvora_wakestern_trail2" );
level._effect[ "ny_harbor_dvora_death_expinit" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_exp2" );
level._effect[ "ny_harbor_dvora_bloodsplat" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_bloodsplat" );
level._effect[ "ny_harbor_dvora_bloodhit" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_bloodhit" );
level._effect[ "ny_harbor_dvora_fallingchunks" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_fallingchunks" );
level._effect[ "ny_harbor_dvora_debrisatplayer" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_debrisatplayer" );
level._effect[ "ny_dvora_wakebow2" ] = LoadFX( "maps/ny_harbor/ny_dvora_wakebow2" );
level._effect[ "ny_harbor_dvora_death_exp3" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_exp2" );
level._effect[ "ny_harbor_dvora_death_exp2" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_exp2" );
level._effect[ "ny_sub_playerwaterripple" ] = LoadFX( "maps/ny_harbor/ny_sub_playerwaterripple" );
level._effect[ "ny_dvora_finalexplosion_splash" ] = LoadFX( "maps/ny_harbor/ny_dvora_finalexplosion_splash" );
level._effect[ "ny_dvora_debris_splash" ] = LoadFX( "maps/ny_harbor/ny_dvora_debris_splash" );
level._effect[ "ny_dvora_sideSplash" ] = LoadFX( "maps/ny_harbor/ny_dvora_sideSplash" );
level._effect[ "ny_dvora_finalexplosion" ] = LoadFX( "maps/ny_harbor/ny_dvora_finalexplosion" );
level._effect[ "ny_harbor_dvora_death_firewave" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_firewave" );
level._effect[ "ny_harbor_dvora_death_splah" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_splah" );
level._effect[ "ny_harbor_dvora_chunkemitter" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_chunkemitter" );
level._effect[ "ny_harbor_dvora_death_exp" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_exp" );
level._effect[ "ny_dvora_wakestern_trail" ] = LoadFX( "maps/ny_harbor/ny_dvora_wakestern_trail" );
level._effect[ "ny_dvora_wakebow_trailxup" ] = LoadFX( "maps/ny_harbor/ny_dvora_wakebow_trailxup" );
level._effect[ "ny_dvora_wakebow_trail" ] = LoadFX( "maps/ny_harbor/ny_dvora_wakebow_trail" );
level._effect[ "ny_dvora_wakebow" ] = LoadFX( "maps/ny_harbor/ny_dvora_wakebow" );
level._effect[ "ny_sub_fin_wisp" ] = LoadFX( "maps/ny_harbor/ny_sub_fin_wisp" );
level._effect[ "ny_sub_sidefroth_before" ] = LoadFX( "maps/ny_harbor/ny_sub_sidefroth_before" );
level._effect[ "ny_sub_breachmainBow_gush" ] = LoadFX( "maps/ny_harbor/ny_sub_breachmainBow_gush" );
level._effect[ "ny_sub_directionalgushes" ] = LoadFX( "maps/ny_harbor/ny_sub_directionalgushes" );
level._effect[ "ny_sub_sidefroth" ] = LoadFX( "maps/ny_harbor/ny_sub_sidefroth" );
level._effect[ "ny_sub_sideport_4" ] = LoadFX( "maps/ny_harbor/ny_sub_sideport_4" );
level._effect[ "ny_sub_hatch_grenade" ] = LoadFX( "maps/ny_harbor/ny_sub_hatch_grenade" );
level._effect[ "dvora_wakeside_nyharbor" ] = LoadFX( "treadfx/dvora_wakeside_nyharbor" );
level._effect[ "dvora_wake_nyharbor" ] = LoadFX( "treadfx/dvora_wake_nyharbor" );
level._effect[ "zubr_wakeside_nyharbor" ] = LoadFX( "treadfx/zubr_wakeside_nyharbor" );
level._effect[ "zubr_wake_nyharbor" ] = LoadFX( "treadfx/zubr_wake_nyharbor" );
level._effect[ "ny_dvora_zodiac_bump" ] = LoadFX( "maps/ny_harbor/ny_dvora_zodiac_bump" );
level._effect[ "mortarExp_water" ] = LoadFX( "explosions/mortarExp_water" );
level._effect[ "ny_harbor_dvora_death" ] = LoadFX( "maps/ny_harbor/ny_harbor_dvora_death" );
level._effect[ "ny_harbor_actor_smoke" ] = LoadFX( "maps/ny_harbor/ny_harbor_actor_smoke" );
level._effect[ "ny_sub_hatch_smoke" ] = LoadFX( "maps/ny_harbor/ny_sub_hatch_smoke" );
level._effect[ "ny_sub_hatch_smoke_2" ] = LoadFX( "maps/ny_harbor/ny_sub_hatch_smoke_2" );
level._effect[ "nyharbor_sub_impact2" ] = LoadFX( "maps/ny_harbor/nyharbor_sub_impact2" );
level._effect[ "ny_sub_breachMainBow" ] = LoadFX( "maps/ny_harbor/ny_sub_breachMainBow" );
level._effect[ "ny_harbor_buildinghit2" ] = LoadFX( "maps/ny_harbor/ny_harbor_buildinghit2" );
level._effect[ "ny_harbor_building_missile3" ] = LoadFX( "maps/ny_harbor/ny_harbor_building_missile3" );
level._effect[ "ny_harbor_building_missile2" ] = LoadFX( "maps/ny_harbor/ny_harbor_building_missile2" );
level._effect[ "ny_harbor_building_missile" ] = LoadFX( "maps/ny_harbor/ny_harbor_building_missile" );
level._effect[ "ny_harbor_buildingchunkfall" ] = LoadFX( "maps/ny_harbor/ny_harbor_buildingchunkfall" );
level._effect[ "ny_harbor_buildinghit_edge" ] = LoadFX( "maps/ny_harbor/ny_harbor_buildinghit_edge" );
level._effect[ "ny_harbor_buildinghit" ] = LoadFX( "maps/ny_harbor/ny_harbor_buildinghit" );
level._effect[ "ny_sub_breachMain" ] = LoadFX( "maps/ny_harbor/ny_sub_breachMain" );
level._effect[ "ny_sub_towerbase" ] = LoadFX( "maps/ny_harbor/ny_sub_towerbase" );
level._effect[ "ny_sub_fingush" ] = LoadFX( "maps/ny_harbor/ny_sub_fingush" );
level._effect[ "nyharbor_sub_impact" ] = LoadFX( "maps/ny_harbor/nyharbor_sub_impact" );
level._effect[ "ny_column_base" ] = LoadFX( "maps/ny_harbor/ny_column_base" );
level._effect[ "fire_ceiling_lg_slow" ] = LoadFX( "fire/fire_ceiling_lg_slow" );
level._effect[ "firelp_large_med_pm_nolight_cheap" ] = LoadFX( "fire/firelp_large_med_pm_nolight_cheap" );
level._effect[ "firelp_large_pm_nolight_cheap" ] = LoadFX( "fire/firelp_large_pm_nolight_cheap" );
level._effect[ "firelp_large_pm_nolight_r" ] = LoadFX( "fire/firelp_large_pm_nolight" );
level._effect[ "firelp_large_pm_nolight_r_reflect" ] = LoadFX( "fire/firelp_large_pm_nolight" );
level._effect[ "ny_harbor_wavelargech2" ] = LoadFX( "maps/ny_harbor/ny_harbor_wavelargech2" );
level._effect[ "fire_line_sm_cheap" ] = LoadFX( "fire/fire_line_sm_cheap" );
level._effect[ "ny_harbor_wavelargech" ] = LoadFX( "maps/ny_harbor/ny_harbor_wavelargech" );
level._effect[ "ny_harbor_wavech" ] = LoadFX( "maps/ny_harbor/ny_harbor_wavech" );
level._effect[ "nyharbor_sub_breach" ] = LoadFX( "maps/ny_harbor/nyharbor_sub_breach" );
level._effect[ "ny_column_top" ] = LoadFX( "maps/ny_harbor/ny_column_top" );
level._effect[ "player_enter_water"] = loadfx( "water/player_submerge" );
level._effect[ "nyharbor_propwash_surfacing_player"] = loadfx( "maps/ny_harbor/nyharbor_propwash_surfacing_player" );
level._effect[ "nyharbor_propwash_surfacing_npc"] = loadfx( "maps/ny_harbor/nyharbor_propwash_surfacing_npc" );
level._effect[ "water_bubbles_longlife_lp" ] = loadfx( "water/water_bubbles_longlife_lp" );
level._effect[ "water_bubbles_longlife_sm_lp" ] = loadfx( "water/water_bubbles_longlife_sm_lp" );
level._effect[ "water_bubbles_wide_sm_lp" ] = loadfx( "water/water_bubbles_wide_sm_lp" );
level._effect[ "water_bubbles_wide_sm" ] = loadfx( "water/water_bubbles_wide_sm" );
level._effect[ "water_bubbles_random_runner_lp" ] = loadfx( "water/water_bubbles_random_runner_lp" );
level._effect[ "water_bubbles_lg_lp" ] = loadfx( "water/water_bubbles_lg_lp" );
level._effect[ "ny_harbor_submine_bubble_tiny" ] = loadfx( "maps/ny_harbor/ny_harbor_submine_bubble_tiny" );
level._effect[ "water_bubbles_tiny_cylind50" ] = loadfx( "water/water_bubbles_tiny_cylind50" );
level._effect[ "water_bubbles_trail_emit" ] = loadfx( "water/water_bubbles_trail_emit" );
level._effect[ "water_bubbles_trail_big_emit" ] = loadfx( "water/water_bubbles_trail_big_emit" );
level._effect[ "sub_waterdisp_tail" ] = loadfx( "water/sub_waterdisp_tail" );
level._effect[ "sub_waterdisp_fin_f" ] = loadfx( "water/sub_waterdisp_fin_f" );
level._effect[ "sub_waterdisp_head" ] = loadfx( "water/sub_waterdisp_head" );
level._effect[ "sub_waterdisp_midbody_offset" ] = loadfx( "water/sub_waterdisp_midbody_offset" );
level._effect[ "harbor_distort_cam" ] = loadfx( "maps/ny_harbor/harbor_distort_cam" );
level._effect[ "nyharbor_sdv_bubble_transition1" ] = loadfx( "maps/ny_harbor/nyharbor_sdv_bubble_transition1" );
level._effect[ "nyharbor_sdv_bubble_transition2" ] = loadfx( "maps/ny_harbor/nyharbor_sdv_bubble_transition2" );
level._effect[ "intro_player_scuba_bubble" ] = loadfx( "maps/ny_harbor/harbor_intro_player_scuba_bubble" );
level._effect[ "intro_npc_scuba_bubble" ] = loadfx( "maps/ny_harbor/harbor_intro_npc_scuba_bubble" );
level._effect[ "scuba_bubbles_breath_player" ] = loadfx( "water/scuba_bubbles_breath_player" );
level._effect[ "scuba_bubbles_NPC" ] = loadfx( "water/scuba_bubbles_breath_longlife" );
level._effect[ "underwater_particulates_player" ] = loadfx( "maps/ny_harbor/harbor_undrwtr_particulates_player" );
level._effect[ "underwater_particulates" ] = loadfx( "water/ny_harbor_underwater_particulates" );
level._effect[ "torch_flare" ] = loadfx( "misc/torch_cutting_fire_underwater" );
level._effect[ "torch_fire_gun" ] = loadfx( "misc/torch_cutting_fire_gun_underwater" );
level._effect[ "torch_metal_glow_underwater" ] = loadfx( "misc/torch_metal_glow_underwater" );
level._effect[ "torch_metal_glow_underwater_fade" ] = loadfx( "misc/torch_metal_glow_underwater_fade" );
level._effect[ "underwater_particulates_lit" ] = loadfx( "dust/light_shaft_dust_large" );
level._effect[ "underwater_particulates_glitter" ] = loadfx( "water/underwater_particulates_glitter" );
level._effect[ "ny_harbor_underwater_dust_bright" ] = loadfx( "water/ny_harbor_underwater_dust_bright" );
level._effect[ "ny_harbor_underwater_dust_narrow" ] = loadfx( "water/ny_harbor_underwater_dust_narrow" );
level._effect[ "ny_harbor_underwater_dust_tumble_wide" ]	= loadfx( "water/ny_harbor_underwater_dust_tumble_wide" );
level._effect[ "ny_harbor_underwater_dust_swirl" ] = loadfx( "water/ny_harbor_underwater_dust_swirl" );
level._effect[ "underwater_dust_kick_minisub" ] = loadfx( "water/underwater_dust_kick_minisub" );
level._effect[ "fish_school_top_oilrig_base" ] = loadfx( "animals/fish_school_top_oilrig_base" );
level._effect[ "fish_school_side_large" ] = loadfx( "animals/fish_school_side_large" );
level._effect[ "light_strobe_undrwtr_mine" ] = loadfx( "lights/light_strobe_undrwtr_mine" );
level._effect[ "underwater_murk" ] = loadfx( "water/ny_harbor_underwater_murk" );
level._effect[ "underwater_murk_xlg" ] = loadfx( "water/ny_harbor_underwater_murk_xlg" );
level._effect[ "depth_charge_distance_ambient_sm" ] = loadfx( "explosions/depth_charge_distance_ambient_sm" );
level._effect[ "depth_charge_distance_amb_runr" ] = loadfx( "explosions/depth_charge_distance_amb_runr" );
level._effect[ "depth_charge_explosion" ] = loadfx( "explosions/depth_charge" );
level._effect[ "sub_surfacing_explosion1" ] = loadfx( "maps/ny_harbor/ny_sub_surfacing_explosion1" );
level._effect[ "sub_surfacing_explosion2" ] = loadfx( "maps/ny_harbor/ny_sub_surfacing_explosion1" );
level._effect[ "sub_surfacing_explosion3" ] = loadfx( "maps/ny_harbor/ny_sub_surfacing_explosion1" );
level._effect[ "ny_harbor_ship_sink_explo" ] = loadfx( "maps/ny_harbor/ny_harbor_ship_sink_explo" );
level._effect[ "ny_harbor_ship_sink_explo_post" ] = loadfx( "maps/ny_harbor/ny_harbor_ship_sink_explo_post" );
level._effect[ "ny_harbor_ship_sink_post_smk" ] = loadfx( "maps/ny_harbor/ny_harbor_ship_sink_post_smk" );
level._effect[ "ny_harbor_ship_sink_oil" ] = loadfx( "maps/ny_harbor/ny_harbor_ship_sink_oil" );
level._effect[ "ny_harbor_ship_sink_oil_l" ] = loadfx( "maps/ny_harbor/ny_harbor_ship_sink_oil_l" );
level._effect[ "floating_debris_xlg_underwater" ] = loadfx( "misc/floating_debris_xlg_underwater" );
level._effect[ "floating_obj_trash_underwater" ] = loadfx( "misc/floating_obj_trash_underwater" );
level._effect[ "floating_obj_bottles_underwater" ] = loadfx( "misc/floating_obj_bottles_underwater" );
level._effect[ "floating_obj_boot_underwater" ] = loadfx( "misc/floating_obj_boot_underwater" );
level._effect[ "floating_obj_mug_underwater" ] = loadfx( "misc/floating_obj_mug_underwater" );
level._effect[ "panel_flash_left" ] = loadfx( "maps/ny_harbor/sdv_panel_left" );
level._effect[ "panel_flash_right" ] = loadfx( "maps/ny_harbor/sdv_panel_right" );
level._effect[ "lead_sdv_beacon" ] = loadfx( "maps/ny_harbor/sdv_beacon" );
level._effect[ "light_headlight" ] = loadfx( "lights/lights_headlight_harbor" );
level._effect[ "flashlight_spotlight" ] = loadfx( "misc/flashlight_spotlight_harbor" );
level._effect[ "lights_torch_cutting" ] = loadfx( "lights/lights_torch_cutting" );
level._effect[ "sub_propeller_propwash" ] = loadfx( "water/sub_propeller_propwash" );
level._effect[ "sub_ping" ] = loadfx( "misc/sonar_sub_ping" );
level._effect[ "mine_ping_scale1" ] = loadfx( "misc/sonar_mine_ping_scale1" );
level._effect[ "mine_ping_scale2" ] = loadfx( "misc/sonar_mine_ping_scale2" );
level._effect[ "mine_ping_scale3" ] = loadfx( "misc/sonar_mine_ping_scale3" );
level._effect[ "mine_ping_scale4" ] = loadfx( "misc/sonar_mine_ping_scale4" );
level._effect[ "sonar_mine_ping_scrn_right" ] = loadfx( "misc/sonar_mine_ping_scrn_right" );
level._effect[ "sonar_mine_ping_scrn_left" ] = loadfx( "misc/sonar_mine_ping_scrn_left" );
level._effect[ "friend_ping" ] = loadfx( "misc/sonar_friend_ping" );
level._effect[ "mine_cover_bubbles" ] = loadfx( "maps/ny_harbor/fx_ny_harbor_sub_mine_plant_cover");
level._effect[ "flesh_hit" ] = LoadFX( "impacts/flesh_hit_body_fatal_exit" );
level._effect[ "drips_slow" ] = loadfx( "misc/drips_slow" );
level._effect[ "drips_slow_sub_sfx" ] = loadfx( "misc/drips_slow_sub_sfx" );
level._effect[ "drips_fast" ] = loadfx( "misc/drips_fast" );
level._effect[ "drips_fast_sub_sfx" ] = loadfx( "misc/drips_fast_sub_sfx" );
level._effect[ "drips_fast_sub_2_sfx" ] = loadfx( "misc/drips_fast_sub_2_sfx" );
level._effect[ "sub_int_water_splash" ] = loadfx( "maps/ny_harbor/sub_int_water_splash" );
level._effect[ "sub_int_water_splash2" ] = loadfx( "maps/ny_harbor/sub_int_water_splash2" );
level._effect["powerline_runner_blue"] = loadfx ("explosions/powerline_runner_blue");
level._effect["powerline_runner_s_blue"] = loadfx ("explosions/powerline_runner_s_blue");
level._effect["powerline_runner_s_red"] = loadfx ("explosions/powerline_runner_s_red");
level._effect[ "red_steady_light" ] = loadfx( "misc/tower_light_red_sort_harbor" );
level._effect[ "steam_room_100" ] = loadfx( "smoke/steam_room_100" );
level._effect[ "steam_jet_loop_cheap" ] = loadfx( "smoke/steam_jet_loop_cheap" );
level._effect[ "steam_jet_loop_valve" ] = loadfx( "smoke/steam_jet_loop_valve" );
level._effect[ "lights_smokey_grating_sm" ] = loadfx( "lights/lights_smokey_grating_sm" );
level._effect[ "submarine_red_light" ] = loadfx( "misc/submarine_red_light" );
level._effect[ "chinook_red_light" ] = loadfx( "misc/chinook_red_light" );
level._effect[ "steam_vent_large_slow" ] = loadfx( "smoke/steam_vent_large_slow" );
level._effect[ "steam_vent_large_bright" ] = loadfx( "smoke/steam_vent_large_bright" );
level._effect[ "head_kick" ] = loadfx( "misc/blood_head_kick" );
level._effect[ "florescent_glow_blue" ] = loadfx( "misc/florescent_glow_blue" );
level._effect[ "breach_door_metal" ] = loadfx( "explosions/breach_door_metal" );
level._effect[ "breach_door_flash" ] = loadfx( "maps/ny_harbor/breach_door_flash" );
level._effect[ "sub_breach_door_seat_destroy" ] = loadfx( "maps/ny_harbor/sub_breach_door_seat_destroy" );
level._effect[ "steam_jet_s_loop" ] = loadfx( "smoke/steam_jet_s_loop" );
level._effect[ "steam_jet_s_loop_2" ] = loadfx( "smoke/steam_jet_s_loop_2" );
level._effect["light_glow_white_harbor"] = loadfx( "misc/light_glow_white_harbor" );
level._effect["smoke_rolling_small"] = loadfx( "smoke/smoke_rolling_small" );
level._effect["smoke_rolling_medium_cheap"] = loadfx( "smoke/smoke_rolling_medium_cheap" );
level._effect["steam_vent_skinny_slow"] = loadfx( "smoke/steam_vent_skinny_slow" );
level._effect["door_open_smokeout"] = loadfx ("maps/ny_harbor/door_open_smokeout");
level._effect["sub_grenade_decal"] = loadfx ("maps/ny_harbor/sub_grenade_decal");
level._effect["sub_missile_room_fire"] = loadfx ("maps/ny_harbor/sub_missile_room_fire");
level._effect["water_pipe_spray_3"] = loadfx( "water/water_pipe_spray_3" );
level._effect["water_pipe_burst"] = loadfx( "water/water_pipe_burst_3" );
level._effect["water_pipe_burst_2"] = loadfx( "water/water_pipe_burst_3" );
level._effect["water_pipe_burst_3"] = loadfx( "water/water_pipe_burst_3" );
level._effect["water_pipe_burst_4"] = loadfx( "water/water_pipe_burst_3" );
level._effect["cpu_fire"] = loadfx( "fire/cpu_fire" );
level._effect["lights_sub_alarm_strobe"] = loadfx( "lights/lights_sub_alarm_strobe" );
level._effect["sub_engine_sparks"] = loadfx ("maps/ny_harbor/sub_engine_sparks");
level._effect["sub_water_floating_junk"] = loadfx ("maps/ny_harbor/sub_water_floating_junk");
level._effect["sub_water_floating_junk_2"] = loadfx ("maps/ny_harbor/sub_water_floating_junk_2");
level._effect["light_red_pinlight_sort"] = loadfx ("lights/light_red_pinlight_sort");
level._effect["light_green_pinlight"] = loadfx ("lights/light_green_pinlight");
level._effect["footstep_water"] = loadfx ("maps/ny_harbor/footstep_water");
level._effect["footstep_water_slow"] = loadfx ("maps/ny_harbor/footstep_water_slow");
level._effect["death_water"] = loadfx ("maps/ny_harbor/death_water");
level._effect["lights_godray_beam_harbor"] = loadfx ("maps/ny_harbor/lights_godray_beam_harbor");
level._effect["lighthaze_sub_ladder_bottom"] = loadfx ("maps/ny_harbor/lighthaze_sub_ladder_bottom");
level._effect["lighthaze_sub_ladder_bottom_fade"] = loadfx ("maps/ny_harbor/lighthaze_sub_ladder_bottom_fade");
level._effect[ "sub_monitor_explosion" ] = loadfx( "maps/ny_harbor/sub_monitor_explosion" );
level._effect[ "sub_monitor_explosion_m" ] = loadfx( "maps/ny_harbor/sub_monitor_explosion" );
level._effect[ "sub_monitor_explosion_m2" ] = loadfx( "maps/ny_harbor/sub_monitor_explosion" );
level._effect[ "sub_monitor_explosion_r" ] = loadfx( "maps/ny_harbor/sub_monitor_explosion" );
level._effect[ "sub_monitor_explosion_s" ] = loadfx( "maps/ny_harbor/sub_monitor_explosion" );
level._effect[ "sub_control_room_smk" ] = loadfx( "maps/ny_harbor/sub_control_room_smk" );
level._effect[ "headshot" ] = loadfx( "impacts/flesh_hit_head_fatal_exit" );
level._effect[ "monitor_glow" ] = loadfx( "props/monitor_glow" );
level._effect[ "monitor_glow_point" ] = loadfx( "props/monitor_glow_point" );
level._effect[ "thick_dark_smoke_giant" ] = loadfx( "smoke/thick_dark_smoke_giant_nyharbor" );
level._effect[ "field_fire_distant" ] = LoadFX( "fire/field_fire_distant" );
level._effect["ny_harbor_waterbarrage"] = LoadFX("water/ny_harbor_waterbarrage");
level._effect["ny_harbor_waterbarrage2"] = LoadFX("water/ny_harbor_waterbarrage2");
level._effect["ny_harbor_explosionVerticalbarrage"] = LoadFX("explosions/fireball_nyharbor_verticalbarrage");
level._effect[ "antiair_runner" ] = loadfx( "misc/antiair_runner_flak" );
level._effect[ "battlefield_smokebank_large" ] = loadfx( "smoke/battlefield_smokebank_large" );
level._effect[ "mist_sea"] = loadfx("weather/mist_sea" );
level._effect[ "slava_splash"] = loadfx("misc/slava_splash" );
level._effect[ "slava_water_floor_rush"] = loadfx("maps/ny_harbor/slava_water_floor_rush" );
level._effect["generic_explosions"]	= loadfx("explosions/generic_explosion" );
level._effect["large_water_impact"]	= loadfx("maps/ny_harbor/large_water_impact" );
level._effect["large_water_impact_close"]	= loadfx("maps/ny_harbor/large_water_impact_close" );
level._effect["large_water_impact_close_rain"]	= loadfx("maps/ny_harbor/large_water_impact_close_rain" );
level._effect["large_water_impact_close_wave"]	= loadfx("maps/ny_harbor/large_water_impact_close_wave" );
level._effect["large_water_impact_close_rush"]	= loadfx("maps/ny_harbor/large_water_impact_close_rush" );
level._effect["smoke_geotrail_genericexplosion"]	= loadfx("smoke/smoke_geotrail_genericexplosion" );
level._effect["fireball_lp_smk_l"] = loadfx ("fire/fireball_lp_smk_l");
level._effect["fireball_lp_blue_smk_l"] = loadfx ("fire/fireball_lp_blue_smk_l");
level._effect["ny_blue_smk"] = loadfx ("maps/ny_harbor/ny_blue_smk");
level._effect["drifting_gray_smk_L"] = loadfx ("smoke/drifting_gray_smk_L");
level._effect["generic_explosion_debris"] = loadfx ("explosions/generic_explosion_debris");
level._effect["window_explosion_glass_only"] = loadfx ("explosions/window_explosion_glass_only");
level._effect[ "burning_oil_slick_1" ] = loadfx( "fire/burning_oil_slick_1" );
level._effect[ "burning_oil_slick_no_smk" ] = loadfx( "fire/burning_oil_slick_no_smk" );
level._effect[ "burning_oil_slick_1_reflect" ] = loadfx( "fire/burning_oil_slick_1_reflect" );
level._effect[ "sub_tail_foam" ] = loadfx( "maps/ny_harbor/sub_tail_foam" );
level._effect[ "hot_tub_bubbles" ] = loadfx( "maps/ny_harbor/hot_tub_bubbles" );
level._effect[ "sub_breaching_tail_steam" ] = loadfx( "maps/ny_harbor/sub_breaching_tail_steam" );
level._effect[ "sub_breaching_tail_steam_child" ] = loadfx( "maps/ny_harbor/sub_breaching_tail_steam_child" );
level._effect[ "sub_foam_lapping_waves" ] = loadfx( "maps/ny_harbor/sub_foam_lapping_waves" );
level._effect[ "sub_water_drainage" ] = loadfx( "maps/ny_harbor/sub_water_drainage" );
level._effect[ "carrier_foam_lapping_waves" ] = loadfx( "maps/ny_harbor/carrier_foam_lapping_waves" );
level._effect[ "waterfall_drainage_carrier" ] = loadfx( "water/waterfall_drainage_carrier" );
level._effect[ "waterfall_drainage_carrier_splash" ] = loadfx( "water/waterfall_drainage_carrier_splash" );
level._effect[ "carrier_underside_drips" ] = loadfx( "maps/ny_harbor/carrier_underside_drips" );
level._effect[ "wave_crest_spray" ] = loadfx( "maps/ny_harbor/wave_crest_spray" );
level._effect[ "wave_crest_spray_explosion" ] = loadfx( "maps/ny_harbor/wave_crest_spray_explosion" );
level._effect[ "heli_water_harbor_cinematic" ] = LoadFX( "treadfx/heli_water_harbor_cinematic" );
level._effect[ "lights_godray_beam" ] = LoadFX( "lights/lights_godray_beam_bright" );
level._effect[ "missile_launch_large" ] = loadfx( "smoke/smoke_geotrail_missile_large" );
level._effect[ "cloud_bank_gulag_z_feather" ] = loadfx( "weather/cloud_bank_gulag_z_feather" );
level._effect["ship_edge_foam_oriented"] = loadfx ("water/ship_edge_foam_oriented");
level._effect["ship_edge_foam_oriented_small"] = loadfx ("water/ship_edge_foam_oriented_small");
level._effect["ship_edge_foam_oriented_tiny"] = loadfx ("water/ship_edge_foam_oriented_tiny");
level._effect[ "corvette_explosion_front" ] = loadfx( "maps/ny_harbor/corvette_explosion_front" );
level._effect[ "corvette_explosion_other" ] = loadfx( "maps/ny_harbor/corvette_explosion_front" );
level._effect[ "corvette_explosion_front_reflect" ] = loadfx( "maps/ny_harbor/corvette_explosion_front_reflect" );
level._effect[ "burya_explosion_splash" ] = loadfx( "maps/ny_harbor/burya_explosion_splash" );
level._effect[ "destroyer_impact_splash" ] = loadfx( "maps/ny_harbor/destroyer_impact_splash" );
level._effect[ "destroyer_missile_impact" ] = loadfx( "maps/ny_harbor/destroyer_missile_impact" );
level._effect[ "ssn12_launch_smoke" ] = loadfx( "smoke/smoke_geotrail_ssnMissile" );
level._effect[ "ssn12_launch_smoke12" ] = loadfx( "maps/ny_harbor/smoke_ssnmissile12_launch" );
level._effect[ "ssn12_enhaust"] = loadfx( "maps/ny_harbor/ny_ssn12_exhaust" );
level._effect[ "ssn12_init"] = loadfx( "maps/ny_harbor/ny_ssn12_init" );
level._effect[ "ssn12_flash"] = loadfx( "maps/ny_harbor/ny_ssn12_flash" );
level._effect[ "slava_missile_bg" ] = loadfx( "maps/ny_harbor/smoke_geo_ssnm12_cheap_background" );
level._effect[ "horizon_flash_runner" ] = loadfx( "weather/horizon_flash_runner_harbor" );
level._effect[ "steam_missile_tube"] = loadfx( "maps/ny_harbor/steam_missile_tube" );
level._effect["heli_takeoff_swirl"] = loadfx ("dust/heli_takeoff_swirl");
level._effect["cloud_ash_lite_nyHarbor"] = loadfx ("weather/cloud_ash_lite_nyHarbor");
level._effect[ "building_collapse_nyharbor" ] = loadfx( "dust/building_collapse_nyharbor" );
level._effect[ "firelp_med_pm" ] = LoadFX( "fire/firelp_med_pm" );
level._effect[ "firelp_large_pm" ] = LoadFX( "fire/firelp_large_pm" );
level._effect[ "firelp_large_pm_r" ] = LoadFX( "fire/firelp_large_pm" );
level._effect[ "firelp_large_pm_r_reflect" ] = LoadFX( "fire/firelp_large_pm_reflect" );
level._effect[ "large_column" ] = loadfx( "props/dcburning_pillars" );
level._effect[ "firelp_small_pm_nolight" ] = loadfx( "fire/firelp_small_pm_nolight" );
level._effect[ "bloodspurt_underwater" ] = loadfx( "water/blood_spurt_underwater" );
level._effect[ "drips_player_hand" ] = loadfx( "water/drips_player_hand" );
level._effect[ "skybox_mig29_flyby_manual_loop" ] = loadfx( "misc/skybox_mig29_flyby_manual_loop" );
level._effect[ "skybox_hind_flyby" ] = loadfx( "misc/skybox_hind_flyby" );
level._effect[ "bird_seagull_flock_harbor" ] = loadfx( "misc/bird_seagull_flock_harbor" );
level._effect[ "thin_black_smoke_L" ] = loadfx( "smoke/thin_black_smoke_L" );
level._effect[ "light_c4_blink" ] = loadfx( "misc/light_c4_blink" );
if ( getdvarint( "sm_enable" ) && getdvar( "r_zfeather" ) != "0" )
level._effect[ "spotlight" ] = loadfx( "misc/hunted_spotlight_model" );
else
level._effect[ "ship_explosion" ] = loadfx( "explosions/tanker_explosion" );
level._effect[ "ocean_ripple" ] = LoadFX( "misc/ny_harbor_ripple" );
if (!isdefined(level.so_zodiac2_ny_harbor))
level._effect[ "zodiac_wake_geotrail" ] = LoadFX( "treadfx/zodiac_wake_geotrail_harbor" );
level._effect[ "zodiac_leftground" ] = LoadFX( "misc/watersplash_large" );
level._effect[ "player_zodiac_bumpbig" ] = LoadFX( "misc/watersplash_large" );
level._effect[ "zodiac_bumpbig" ] = LoadFX( "misc/watersplash_large" );
level._effect_tag[ "zodiac_bumpbig" ] = "tag_guy2";
level._effect[ "player_zodiac_bump" ] = LoadFX( "impacts/large_waterhit" );
level._effect[ "zodiac_bump" ] = LoadFX( "impacts/large_waterhit" );
level._effect[ "zodiac_collision" ] = LoadFX( "misc/watersplash_large" );
level._effect_tag[ "zodiac_collision" ] = "TAG_DEATH_FX";
if (!isdefined(level.so_zodiac2_ny_harbor))
{
level._effect[ "zodiac_bounce_small_left" ] = LoadFX( "water/zodiac_splash_bounce_small" );
level._effect_tag[ "zodiac_bounce_small_left" ] = "TAG_FX_LF";
level._effect[ "zodiac_bounce_small_right" ] = LoadFX( "water/zodiac_splash_bounce_small" );
level._effect_tag[ "zodiac_bounce_small_right" ] = "TAG_FX_RF";
level._effect[ "zodiac_bounce_large_left" ] = LoadFX( "water/zodiac_splash_bounce_large" );
level._effect_tag[ "zodiac_bounce_large_left" ] = "TAG_FX_LF";
level._effect[ "zodiac_bounce_large_right" ] = LoadFX( "water/zodiac_splash_bounce_large" );
level._effect_tag[ "zodiac_bounce_large_right" ] = "TAG_FX_RF";
level._effect[ "zodiac_sway_left" ] = LoadFX( "water/zodiac_splash_turn_hard" );
level._effect_tag[ "zodiac_sway_left" ] = "TAG_FX_LF";
level._effect[ "zodiac_sway_right" ] = LoadFX( "water/zodiac_splash_turn_hard" );
level._effect_tag[ "zodiac_sway_right" ] = "TAG_FX_RF";
level._effect[ "zodiac_sway_left_light" ] = LoadFX( "water/zodiac_splash_turn_light" );
level._effect_tag[ "zodiac_sway_left_light" ] = "TAG_FX_LF";
level._effect[ "zodiac_sway_right_light" ] = LoadFX( "water/zodiac_splash_turn_light" );
level._effect_tag[ "zodiac_sway_right_light" ] = "TAG_FX_RF";
}
level.water_sheating_time[ "bump_big_start" ] = 2;
level.water_sheating_time[ "bump_small_start" ] = 1;
level.water_sheating_time[ "bump_big_after_rapids" ] = 4;
level.water_sheating_time[ "bump_small_after_rapids" ] = 2;
level.water_sheating_time[ "bump_big_player_dies" ] = 7;
level.water_sheating_time[ "bump_small_player_dies" ] = 3;
}
tunnel_vent_bubbles_wide()
{
wait(2.0);
fxent = getfx("water_bubbles_wide_sm_lp");
missile_launchers = [( -16310.6, -24354.9, -1660.94 ),
( -16400.8, -24309.7, -1662.02 ),
( -16497.9, -24267.3, -1664.36 ),
( -16689, -24187.2, -1671.44 ),
( -16783.8, -24151.6, -1675.71 ),
( -17898, -23897.2, -1706.4 ),
( -17587.8, -23942.8, -1699.35 ),
( -17183.5, -24031.1, -1684.73 ),
( -17383.1, -23981.5, -1691.34 ),
( -17690.4, -23924.1, -1700.39 ),
( -17997.1, -23893.5, -1710.37 ),
( -18209.7, -23879.2, -1717.74 ),
( -18417.6, -23876.2, -1725.78 ),
( -18518.1, -23878.1, -1729.52 ),
( -15934.2, -24096.8, -1654.38 ),
( -16135.8, -23991.6, -1662.13 ),
( -16340.3, -23893.1, -1667.33 ),
( -16442.7, -23853.6, -1669.35 ),
( -16653.4, -23773.4, -1673.12 ),
( -16866, -23704.7, -1678.58 ),
( -16758.7, -23736, -1675.3 ),
( -17083.3, -23642.4, -1684.83 ),
( -18426.4, -23476.4, -1726.16 ),
( -18765.5, -23491.6, -1736.59 ),
( -18308, -23478.5, -1720.63 ),
( -16589.9, -24224.3, -1664.82 ),
( -16217.1, -24399.8, -1658.26 )];
expAng = [( 270.001, 359.927, -119.927 ),
( 270.001, 359.653, -113.653 ),
( 270.001, 359.788, -107.788 ),
( 270.001, 359.788, -107.788 ),
( 270.001, 359.788, -107.788 ),
( 270.002, 359.876, -97.8751 ),
( 270.001, 359.931, -99.931 ),
( 270.001, 359.861, -107.86 ),
( 270.001, 359.861, -107.86 ),
( 270.001, 359.861, -107.86 ),
( 270.002, 359.938, -99.9375 ),
( 270.002, 359.939, -89.9384 ),
( 270.002, 359.939, -89.9384 ),
( 270.002, 359.94, -87.9397 ),
( 270.002, 359.888, 62.1124 ),
( 270.002, 359.787, 68.2136 ),
( 270.002, 359.79, 70.2103),
( 270.002, 359.736, 68.2638 ),
( 270.002, 359.736, 68.2638 ),
( 270.002, 359.736, 68.2638 ),
( 270.002, 359.736, 68.2638 ),
( 270.002, 359.736, 68.2638 ),
( 270.002, 359.641, 92.3588 ),
( 270.002, 359.949, 94.0513 ),
( 270.002, 359.948, 94.0518 ),
( 270.001, 359.788, -107.788 ),
( 270.001, 359.927, -119.927 )];
ents = [];
for(;;)
{
flag_wait("fx_zone_1000_active");
for(i=0;i<missile_launchers.size;i++)
{
ents[i]=spawnfx(fxent,missile_launchers[i],anglestoforward(expAng[i]),anglestoup(expAng[i]));
triggerfx(ents[i]);
}
flag_waitopen("fx_zone_1000_active");
for(i=0;i<ents.size;i++)
{
ents[i] delete();
}
}
}
tunnel_vent_bubbles()
{
wait(2.0);
fxent = getfx("water_bubbles_longlife_sm_lp");
missile_launchers = [( -19169.2, -23550.2, -1620.38 ),
( -17729.9, -23753.6, -1691.15 ),
( -16714.1, -23923.9, -1686.64 ),
( -17500.4, -23808.9, -1711.69 ),
( -18807.6, -23672.9, -1725.55 ),
( -18674.8, -23735.8, -1742.5 ),
( -18236.5, -23736.7, -1710.42 ),
( -16923.1, -23960.2, -1651.07 ),
( -16422.9, -24120.7, -1676.75 ),
( -17101.3, -24057.6, -1605.14 ),
( -17102.5, -24057.6, -1663.11 ),
( -17568.7, -23952.2, -1619.49 ),
( -17568.7, -23952.2, -1676.49 ),
( -18042.9, -23895.6, -1635.93 ),
( -18043, -23896.5, -1693.51 ),
( -18517.3, -23887.7, -1652.97 ),
( -18983.3, -23927.8, -1669.41 ),
( -19051.3, -23460, -1642.84 ),
( -18537.1, -23415.3, -1627.26 ),
( -18013.9, -23423.6, -1611.15 ),
( -17491.6, -23485.4, -1594.57 ),
( -16221.2, -24407.5, -1581.35 ),
( -16651.4, -24209.9, -1648.76 )];
ents = [];
for(;;)
{
flag_wait("fx_zone_1000_active");
for(i=0;i<missile_launchers.size;i++)
{
ents[i]=spawnfx(fxent,missile_launchers[i]);
triggerfx(ents[i]);
}
flag_waitopen("fx_zone_1000_active");
for(i=0;i<ents.size;i++)
{
ents[i] delete();
}
}
}
underwater_particulate_fx()
{
level endon( "msg_fx_player_surfaced" );
while(true)
{
playfxontag( getfx( "underwater_particulates_player" ), self, "TAG_PROPELLER" );
wait(.25);
}
}
underwater_cam_distortion_fx()
{
level endon( "msg_fx_intro_end" );
level endon( "msg_fx_player_surfaced" );
while(true)
{
playfxontag( getfx( "harbor_distort_cam" ), self, "TAG_PROPELLER" );
wait(1);
}
}
ny_harbor_tunnel_sign_blinky()
{
self endon( "death" );
while ( 1 )
{
self SetModel( "ny_harbor_tunnel_evacuation_sign_01_alt" );
wait( randomfloatrange( .001, .15 ) );
self SetModel( "ny_harbor_tunnel_evacuation_sign_01" );
wait( randomfloatrange( .001, .25 ) );
}
}
ny_harbor_tunnel_taxi_rooftop_ad_blinky_base()
{
self endon( "death" );
while ( 1 )
{
self SetModel( "vehicle_taxi_rooftop_ad_base_on" );
wait( .5 );
self SetModel( "vehicle_taxi_rooftop_ad_base_off" );
wait( .15 );
self SetModel( "vehicle_taxi_rooftop_ad_base_on" );
wait( .3 );
self SetModel( "vehicle_taxi_rooftop_ad_base_off" );
wait( .65 );
}
}
ny_harbor_tunnel_taxi_rooftop_ad_blinky()
{
self endon( "death" );
while ( 1 )
{
self SetModel( "vehicle_taxi_rooftop_ad_2_on" );
wait( .5 );
self SetModel( "vehicle_taxi_rooftop_ad_2" );
wait( .15 );
self SetModel( "vehicle_taxi_rooftop_ad_2_on" );
wait( .3 );
self SetModel( "vehicle_taxi_rooftop_ad_2" );
wait( .65 );
}
}
intro_player_bubble_fx()
{
level endon("msg_fx_intro_end");
while(true)
{
aud_send_msg("player_scuba_bubbles");
playfxOnTag( getfx( "intro_player_scuba_bubble" ), self, "TAG_PLAYER" );
wait( 6.0 + randomfloat( 1 ) );
}
}
intro_npc_bubble_fx()
{
level endon("msg_fx_intro_end");
while(true)
{
playfxOnTag( getfx( "intro_npc_scuba_bubble" ), self, "TAG_EYE" );
wait( 2.5 + randomfloat( 2 ) );
}
}
torch_flare_fx()
{
exploder(1010);
wait(9);
pauseexploder (1010);
level notify("msg_torch_flare_fx_end");
}
intro_vision_reveal()
{
vision_set_fog_changes("ny_harbor_intro_dark",0);
setblur(5, 0);
wait(4);
vision_set_fog_changes("ny_harbor_intro", 1);
setblur(0, .75);
}
torch_contrast()
{
wait(5);
for(i=0;i<2;i++)
{
currVis = getdvar("vision_set_current");
visionsetnaked("ny_harbor_torch_contrast",.1);
wait(.1 + randomfloat (.2));
visionsetnaked("generic_flash",0);
aud_send_msg("torch_screen_flash");
setblur(8,0);
level.player SetHUDDynLight( 1, ( 1.0, 1.0, 1.0 ) );
wait(.01 + randomfloat (.02));
visionsetnaked(currVis,.4);
setblur(0,.6);
level.player SetHUDDynLight( 300, ( 0.0, 0.0, 0.0 ) );
wait( 1.5 + randomfloat( .5 ) );
}
}
ny_harbor_intro_dof()
{
wait(5);
start = level.dofDefault;
ny_harbor_dof_intro = [];
ny_harbor_dof_intro[ "nearStart" ] = 1;
ny_harbor_dof_intro[ "nearEnd" ] = 2;
ny_harbor_dof_intro[ "nearBlur" ] = 8;
ny_harbor_dof_intro[ "farStart" ] = 30;
ny_harbor_dof_intro[ "farEnd" ] = 420;
ny_harbor_dof_intro[ "farBlur" ] = 7;
blend_dof( start, ny_harbor_dof_intro, .2 );
wait(10);
blend_dof ( ny_harbor_dof_intro, start, 1 );
}
ny_harbor_intro_specular()
{
setsaveddvar("r_specularcolorscale", 3.25);
wait(15);
{
delta = ( 10 - 2.5 ) / 40;
val = 3.25;
while( val > 2.5 )
{
val = ( val - delta );
setsaveddvar("r_specularcolorscale", val);
wait(.05);
}
}
setsaveddvar("r_specularcolorscale", 2.5);
}
ny_harbor_enter_sub_shadowfix()
{
flag_wait("hatch_player_using_ladder");
wait(.05);
{
delta = ( 5 - 2.5 ) / 60;
val = .25;
while( val > .075 )
{
val = ( val - delta );
wait(.05);
}
}
wait(5);
}
ny_harbor_enter_zodiac_shadowfix()
{
flag_wait("get_on_zodiac");
wait(1);
{
delta = ( 5 - 2.5 ) / 60;
val = .25;
while( val > .075 )
{
val = ( val - delta );
wait(.05);
}
}
wait(1.5);
}
torch_grating_rays()
{
exploder(1020);
wait(15);
kill_exploder(1020);
}
ny_harbor_intro_metal_glow()
{
wait(0);
exploder(50000);
exploder(50001);
exploder(50002);
exploder(50003);
exploder(50004);
exploder(50005);
exploder(50006);
exploder(50007);
exploder(50008);
exploder(50009);
exploder(50010);
exploder(50011);
exploder(50012);
delaythread(10.03, ::kill_exploder, 50000 );
delaythread(10, ::exploder, 51000 );
delaythread(6.53, ::kill_exploder, 50001);
delaythread(6.5, ::exploder, 51001);
delaythread(7.03, ::kill_exploder, 50002);
delaythread(7, ::exploder, 51002);
delaythread(7.13, ::kill_exploder, 50003);
delaythread(7.1, ::exploder, 51003);
delaythread(8.03, ::kill_exploder, 50004);
delaythread(8, ::exploder, 51004);
delaythread(7.53, ::kill_exploder, 50005);
delaythread(7.5, ::exploder, 51005);
delaythread(11.03, ::kill_exploder, 50006);
delaythread(11, ::exploder, 51006);
delaythread(10.23, ::kill_exploder, 50007);
delaythread(10.2, ::exploder, 51007);
delaythread(8.23, ::kill_exploder, 50008);
delaythread(8.2, ::exploder, 51008);
delaythread(7.23, ::kill_exploder, 50009);
delaythread(7.2, ::exploder, 51009);
delaythread(7.03, ::kill_exploder, 50010);
delaythread(7, ::exploder, 51010);
delaythread(6.83, ::kill_exploder, 50011);
delaythread(6.8, ::exploder, 51011);
delaythread(6.23, ::kill_exploder, 50012);
delaythread(6.2, ::exploder, 51012);
}
bubble_on_falling_grate()
{
wait(15.1);
PlayFxOnTag( getfx( "water_bubbles_tiny_cylind50" ), self, "grate" );
wait(.1);
exploder(1030);
wait(5);
StopFxOnTag( getfx( "water_bubbles_tiny_cylind50" ), self, "grate" );
}
bubble_wash_player_exiting_gate()
{
level waittill ("bubble_wash_player_out_gate");
wait(5.5);
playfxOnTag( getfx( "scuba_bubbles_breath_player" ), level.sdv_player_arms, "TAG_PLAYER" );
wait(1.5);
playfxOnTag( getfx( "scuba_bubbles_breath_player" ), level.sdv_player_arms, "TAG_PLAYER" );
wait(1.0);
playfxOnTag( getfx( "scuba_bubbles_breath_player" ), level.sdv_player_arms, "TAG_PLAYER" );
}
sinking_ship_vfx_sequence()
{
flag_wait ("start_sinking");
thread sinking_ship_post_expl_env_vfx();
thread sinking_ship_elec_shortening_vfx();
thread sinking_ship_bubbles_vfx();
thread sinking_ship_post_smk_vfx();
thread sinking_ship_explosion();
flag_wait( "sinking_ship_fx" );
thread sinking_ship_flash_vision();
}
sinking_ship_explosion()
{
data = spawnStruct();
get_sinking_ship_fx("2900",data);
flash_locs = data.v["origins"];
flash_angs = data.v["angles"];
ents = data.v["ents"];
flash_playing = [];
for(i=0; i<flash_locs.size;i++)
{
flash_playing[i] = 0;
}
flash_origins = [];
for (i=0; i<flash_locs.size;i++)
{
flash_origins[i] = spawn_tag_origin();
flash_origins[i].origin = flash_locs[i];
flash_origins[i].angles = flash_angs[i];
flash_origins[i] linkto(level.fx_dummy,"tag_origin");
}
for(i=0; i<flash_locs.size;i++)
{
flag_wait( "sinking_ship_fx" );
PlayFxOnTag( getfx( "ny_harbor_ship_sink_explo" ), flash_origins[i], "tag_origin" );
aud_send_msg("ship_sink_flash_explosion", flash_origins[i]);
flash_playing[i] =1;
}
flag_wait( "russian_sub_spawned" );
for(i=0; i<flash_locs.size;i++)
{
StopFxOnTag( getfx( "ny_harbor_ship_sink_explo" ), flash_origins[i], "tag_origin" );
flash_origins[i] Delete();
}
}
sinking_ship_elec_shortening_vfx()
{
data = spawnStruct();
get_sinking_ship_fx("2905",data);
flash_locs = data.v["origins"];
flash_angs = data.v["angles"];
ents = data.v["ents"];
flash_origins = [];
for (i=0; i<flash_locs.size;i++)
{
flash_origins[i] = spawn_tag_origin();
flash_origins[i].origin = flash_locs[i];
flash_origins[i].angles = flash_angs[i];
flash_origins[i] linkto(level.fx_dummy,"tag_origin");
}
for(i=0; i<flash_locs.size;i++)
{
PlayFxOnTag( getfx( "ny_harbor_ship_sink_explo_post" ), flash_origins[i], "tag_origin" );
}
flag_wait( "russian_sub_spawned" );
for(i=0; i<flash_locs.size;i++)
{
StopFxOnTag( getfx( "ny_harbor_ship_sink_explo_post" ), flash_origins[i], "tag_origin" );
flash_origins[i] Delete();
}
}
sinking_ship_bubbles_vfx()
{
data = spawnStruct();
get_sinking_ship_fx("2910",data);
flash_locs = data.v["origins"];
flash_angs = data.v["angles"];
ents = data.v["ents"];
flash_origins = [];
for (i=0; i<flash_locs.size;i++)
{
flash_origins[i] = spawn_tag_origin();
flash_origins[i].origin = flash_locs[i];
flash_origins[i].angles = flash_angs[i];
flash_origins[i] linkto(level.fx_dummy,"tag_origin");
}
for(i=0; i<flash_locs.size;i++)
{
PlayFxOnTag( getfx( "water_bubbles_lg_lp" ), flash_origins[i], "tag_origin" );
}
flag_wait( "russian_sub_spawned" );
for(i=0; i<flash_locs.size;i++)
{
StopFxOnTag( getfx( "water_bubbles_lg_lp" ), flash_origins[i], "tag_origin" );
flash_origins[i] Delete();
}
}
sinking_ship_post_smk_vfx()
{
data = spawnStruct();
get_sinking_ship_fx("2915",data);
flash_locs = data.v["origins"];
flash_angs = data.v["angles"];
ents = data.v["ents"];
flash_origins = [];
for (i=0; i<flash_locs.size;i++)
{
flash_origins[i] = spawn_tag_origin();
flash_origins[i].origin = flash_locs[i];
flash_origins[i].angles = flash_angs[i];
flash_origins[i] linkto(level.fx_dummy,"tag_origin");
}
for(i=0; i<flash_locs.size;i++)
{
PlayFxOnTag( getfx( "ny_harbor_ship_sink_post_smk" ), flash_origins[i], "tag_origin" );
}
flag_wait( "russian_sub_spawned" );
for(i=0; i<flash_locs.size;i++)
{
StopFxOnTag( getfx( "ny_harbor_ship_sink_post_smk" ), flash_origins[i], "tag_origin" );
flash_origins[i] Delete();
}
}
get_sinking_ship_fx(num, data)
{
org = [];
ang = [];
ents = [];
id = string(num);
exploders = GetExploders( id );
if (isdefined(exploders))
{
foreach (ent in exploders)
{
org[(org.size)]=ent.v["origin"];
ang[(ang.size)]=ent.v["angles"];
ents[(ents.size)]=ent;
}
}
data.v["origins"] = org;
data.v["angles"] = ang;
data.v["ents"] = ents;
}
sinking_ship_flash_vision()
{
level.player viewdependent_vision_enable(false);
currVis = getdvar("vision_set_current");
visionsetnaked("ny_harbor_undrwtr_explo_flash_strong",.1);
wait(.1);
visionsetnaked(currVis,.15);
level.player viewdependent_vision_enable(true);
}
sinking_ship_post_expl_env_vfx()
{
aud_send_msg("sinking_ship_debris_splash");
exploder(2920);
flag_wait( "russian_sub_spawned" );
kill_exploder (2920);
}
minisub_dust_kick_player()
{
level waittill("start_submarine02");
wait(1.65);
playfxOnTag( getfx( "underwater_dust_kick_minisub" ), level.player_sdv, "TAG_PLAYER" );
}
kill_distance_depth_charges()
{
flag_wait("detonate_torpedo");
wait(2.3);
PauseFXID("depth_charge_distance_amb_runr");
}
torpedo_explosion_distance_vfx()
{
flag_wait( "detonate_torpedo" );
wait(2.5);
exploder(4011);
wait(0.45);
exploder(4012);
}
oscar02_propwash_vfx()
{
flag_wait( "russian_sub_spawned" );
playfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_left_porpeller");
playfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_right_propeller");
level waittill("submine_planted");
stopfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_left_porpeller");
stopfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_right_propeller");
}
oscar02_body_water_displacement_vfx()
{
flag_wait( "detonate_torpedo" );
playfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single4");
playfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single5");
playfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_fin_b_right");
playfxontag(getfx("sub_waterdisp_fin_f"),level.russian_sub_02,"tag_fx_fin_f_right");
playfxontag(getfx("sub_waterdisp_tail"),level.russian_sub_02,"tag_fx_fin_b");
playfxontag(getfx("sub_waterdisp_head"),level.russian_sub_02,"tag_fx_wake");
level waittill("entering_mine_plant");
stopfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single4");
stopfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single5");
stopfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_fin_b_right");
stopfxontag(getfx("sub_waterdisp_fin_f"),level.russian_sub_02,"tag_fx_fin_f_right");
stopfxontag(getfx("sub_waterdisp_tail"),level.russian_sub_02,"tag_fx_fin_b");
stopfxontag(getfx("sub_waterdisp_head"),level.russian_sub_02,"tag_fx_wake");
stopfxontag(getfx("sub_waterdisp_midbody_offset"),level.russian_sub_02,"tag_origin");
}
bubble_transition_entering_mine_plant()
{
level waittill("entering_mine_plant");
playfxOnTag( getfx( "nyharbor_sdv_bubble_transition1" ), level.player_sdv.sdv_model, "TAG_PLAYER" );
}
bubble_transition_starting_mine_plant()
{
level waittill("starting_mine_plant");
}
bubble_on_player_mine_plant()
{
level waittill("starting_mine_plant");
wait(2.5);
playfxOnTag( getfx( "nyharbor_sdv_bubble_transition2" ), level.sdv_player_arms, "TAG_PLAYER" );
fx_dummy1 = spawn_tag_origin();
fx_dummy1 linkto(level.sdv_player_arms, "tag_origin", (0, 0, 50), (0, 0, 90));
playfxOnTag( getfx( "mine_cover_bubbles" ), fx_dummy1, "tag_origin" );
wait 1.0;
playfxOnTag( getfx( "mine_cover_bubbles" ), fx_dummy1, "tag_origin" );
wait 1.0;
playfxOnTag( getfx( "mine_cover_bubbles" ), fx_dummy1, "tag_origin" );
}
submine_bubbles_vfx()
{
playfxontag(getfx("ny_harbor_submine_bubble_tiny"),self,"TAG_FX");
wait(5.0);
stopfxontag(getfx("ny_harbor_submine_bubble_tiny"),self,"TAG_FX");
}
cine_sub_surfacing_env_vfx()
{
level waittill("entering_mine_plant");
fxid = "ny_harbor_underwater_caustic_ray_long";
exploders = level.createFXbyFXID[ fxid ];
if (isdefined(exploders))
{
foreach (ent in exploders)
{
if (ent.v[ "exploder" ] == "3000")
ent pauseEffect();
}
}
exploder(4001);
level waittill ("msg_fx_player_surfaced");
kill_exploder (4001);
}
cine_sub_surfacing_explosions()
{
flag_wait( "detonate_sub" );
thread sub_mine_explosion_flash();
wait(0.05);
playfxontag(getfx("sub_surfacing_explosion1"),level.mine_sub_model,"tag_weapon");
level.player thread sub_explosion_rumble();
earthquake ( 0.3, 1.7, level.player.origin, 1024 );
flag_wait( "submine_detonated" );
wait(.7);
thread sub_mine_explosion_flash();
wait(0.05);
fx_dummy1 = spawn_tag_origin();
fx_dummy1 linkto(level.russian_cine_sub, "tag_fx_fin_b_left", (175, 0, 450), (0, 0, 0));
playfxontag(getfx("sub_surfacing_explosion2"),fx_dummy1,"tag_origin");
level.player thread sub_explosion_rumble();
earthquake ( 0.25, 1.7, level.player.origin, 1024 );
wait(1.85);
thread sub_mine_explosion_flash();
wait(0.05);
fx_dummy2 = spawn_tag_origin();
fx_dummy2 linkto(level.russian_cine_sub, "tag_fx_ventback_single7", (-200, -100, -100), (0, 0, 0));
playfxontag(getfx("sub_surfacing_explosion3"),fx_dummy2,"tag_origin");
level.player thread sub_explosion_rumble();
earthquake ( 0.4, 1.7, level.player.origin, 1024 );
level notify("sub_surfacing_explosion_vfx_end");
wait(1.0);
earthquake ( 0.25, 5, level.player.origin, 2048 );
}
sub_mine_explosion_flash()
{
level.player viewdependent_vision_enable(false);
level.player viewdependent_fog_enable(false);
currVis = getdvar("vision_set_current");
setblur(10, .5);
visionsetnaked("ny_harbor_torch_contrast",.05);
wait(.06);
visionsetnaked("ny_harbor_undrwtr_explo_flash_light",.05);
level.player SetHUDDynLight( 1, ( 1.0, 1.0, 1.0 ) );
wait(.1);
visionsetnaked(currVis,.1);
setblur(0, .5);
level.player SetHUDDynLight( 100, ( 0.0, 0.0, 0.0 ) );
level.player viewdependent_vision_enable(true);
level.player viewdependent_fog_enable(true);
}
oscar_cine_water_displacement_vfx()
{
flag_wait( "submine_planted" );
wait(4.0);
playfxontag(getfx("sub_waterdisp_midbody_offset"),level.russian_cine_sub,"tag_origin");
wait(0.2);
playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single3");
wait(0.2);
playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent8");
wait(0.2);
playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent6");
playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_tower_back");
flag_wait( "submine_detonated" );
stopfxontag(getfx("sub_waterdisp_midbody_offset"),level.russian_cine_sub,"tag_origin");
level waittill ("sub_surfacing_explosion_vfx_end");
wait(2.0);
stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single3");
wait(0.1);
stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent8");
wait(0.1);
stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent6");
stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_tower_back");
}
sandman_surfacing_vfx()
{
level waittill("sub_surfacing_explosion_vfx_end");
playfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_LE");
playfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_RI");
wait(2.0);
playfxontag(getfx("scuba_bubbles_NPC"),level.sdv_sandman,"TAG_EYE");
level waittill ("msg_fx_player_surfaced");
wait(2.0);
stopfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_LE");
stopfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_RI");
stopfxontag(getfx("scuba_bubbles_NPC"),level.sdv_sandman,"TAG_EYE");
}
player_surfacing_vfx()
{
level waittill("sub_surfacing_explosion_vfx_end");
wait(1.85);
playfxontag(getfx("nyharbor_propwash_surfacing_player"),level.sdv_player_arms,"tag_camera");
wait(1.4);
thread player_surfacing_postfx();
}
player_surfacing_postfx()
{
setblur(4, .5);
wait(0.2);
level.player viewdependent_vision_enable(false);
level.player viewdependent_fog_enable(false);
currVis = getdvar("vision_set_current");
wait(0.5);
visionsetnaked("ny_harbor_player_surfacing",.75);
level.player SetHUDDynLight( 500, ( 1.0, 1.0, 1.0 ) );
wait(0.35);
thread hide_underwater_surface_geo();
wait(0.65);
visionsetnaked(currVis,.35);
level.player SetHUDDynLight( 100, ( 0.0, 0.0, 0.0 ) );
level.player viewdependent_vision_enable(true);
level.player viewdependent_fog_enable(true);
wait(.5);
setblur(0, .5);
}
hide_underwater_surface_geo()
{
underwater_surface_geo = getent("harbor_underwater_geo","script_noteworthy");
underwater_surface_geo hide();
}
starthindDust()
{
self waittill("msg_fx_start_hindDust");
playfx(getfx("heli_takeoff_swirl"),(-671,598,16),anglestoforward((0,318,0)),(1,0,0));
}
player_sdv_fx()
{
while (true)
{
self waittill( "moving" );
if (self ent_flag( "moving" ))
{
self thread play_sound_on_tag( "veh_blackshadow_startup", "TAG_PROPELLER" );
self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_bubble_trail_01", "TAG_PROPELLER", true );
self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_loop", "TAG_PROPELLER", true );
}
else
{
self notify( "stop sound" + "veh_blackshadow_loop" );
self notify( "stop sound" + "veh_blackshadow_bubble_trail_01" );
self thread play_sound_on_tag( "veh_blackshadow_stop", "TAG_PROPELLER" );
}
}
}
npc_sdv_fx()
{
while (true)
{
self waittill( "moving" );
if (self ent_flag( "moving" ))
{
self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_bubble_trail_02", "TAG_PROPELLER", true );
self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_loop_npc", "TAG_PROPELLER", true );
}
else
{
self notify( "stop sound" + "veh_blackshadow_loop_npc" );
self notify( "stop sound" + "veh_blackshadow_bubble_trail_02" );
}
}
}
trigger_harbor_fx()
{
wait(.6);
if(flag("entering_water"))
{
PauseFXID( "thick_dark_smoke_giant" );
PauseFXID( "battlefield_smokebank_large" );
level notify("msg_nyharbor_stoplandexplosions");
level notify("msg_nyharbor_stopwaterexplosions");
wait(1.0);
level waittill("msg_breach_fx_ended");
level thread start_harbor_landexplosions();
level thread start_harbor_waterexplosions();
exploder(556);
RestartFXID( "battlefield_smokebank_large" );
RestartFXID( "thick_dark_smoke_giant", "oneshotfx" );
}
else
{
level thread start_harbor_waterexplosions();
level thread start_harbor_landexplosions();
exploder(556);
}
}
underwater_bleedout( guy )
{
playfxontag( getfx( "deathfx_bloodpool_underwater" ), guy, "J_NECK");
}
knife_blood( playerRig )
{
playfxontag( getfx( "bloodspurt_underwater" ), playerRig, "TAG_KNIFE_FX");
}
underwater_struggle( guy )
{
playfxontag( getfx( "splash_underwater_stealthkill" ), guy, "J_SpineUpper");
}
playerDrips_left( model )
{
tags_in_arm = [];
tags_in_arm[ tags_in_arm.size ] = "J_Wrist_LE";
tags_in_arm[ tags_in_arm.size ] = "J_Thumb_LE_1";
tags_in_arm[ tags_in_arm.size ] = "J_Thumb_LE_2";
num = 10;
for( i = 0 ; i < num ; i++ )
{
thread play_drip_fx( tags_in_arm, model );
wait randomfloatrange( 0.05, 0.3 );
}
}
playerDrips_right( model )
{
tags_in_arm = [];
tags_in_arm[ tags_in_arm.size ] = "J_Wrist_RI";
tags_in_arm[ tags_in_arm.size ] = "J_Thumb_RI_1";
tags_in_arm[ tags_in_arm.size ] = "J_Webbing_RI";
tags_in_arm[ tags_in_arm.size ] = "J_Elbow_RI";
num = 10;
for( i = 0 ; i < num ; i++ )
{
thread play_drip_fx( tags_in_arm, model );
wait randomfloatrange( 0.05, 0.3 );
}
}
play_drip_fx( tags_in_arm, model )
{
foreach( bone in tags_in_arm )
{
playfxontag( getfx( "drips_player_hand" ), model, bone );
}
}
treadfx_override()
{
level.treadfx_maxheight = 2000;
flying_tread_fx = "treadfx/heli_water_harbor";
flying_tread_fx_water = "treadfx/heli_water_harbor";
vehicletype_fx[0] = "script_vehicle_ny_blackhawk";
vehicletype_fx[1] = "script_vehicle_ch46e_ny_harbor";
vehicletype_fx[2] = "script_vehicle_mi24p_hind_woodland";
foreach(vehicletype in vehicletype_fx)
{
maps\_treadfx::setvehiclefx( vehicletype, "brick", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "bark", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "carpet", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "cloth", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "concrete", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "dirt", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "flesh", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "foliage", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "glass", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "grass", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "gravel", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "ice", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "metal", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "mud", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "paper", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "plaster", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "rock", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "sand", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "snow", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "water", flying_tread_fx_water );
maps\_treadfx::setvehiclefx( vehicletype, "wood", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "asphalt", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "ceramic", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "plastic", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "rubber", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "cushion", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "fruit", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "painted metal", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "default", flying_tread_fx );
maps\_treadfx::setvehiclefx( vehicletype, "none", flying_tread_fx );
}
}
door_open_smokeout_vfx()
{
wait(5.7);
exploder(254);
}
head_smash_vfx()
{
exploder(256);
}
door_breach_vision_change()
{
thread vision_set_fog_changes( "ny_harbor_sub_4_breach", 0 );
}
door_breach_blur()
{
setblur(6, 0);
wait(1.0);
setblur(0, .4);
}
door_breach_flash_vfx()
{
wait(5.95);
exploder(261);
}
door_breach_vfx(guy)
{
exploder(257);
thread vision_set_fog_changes( "ny_harbor_sub_5", 0 );
wait(1.0);
exploder(264);
wait(0.05);
control_room_seat = getent("control_room_seat", "script_noteworthy");
if( isDefined( control_room_seat ) )
{
control_room_seat hide();
}
}
vfx_pipe_burst()
{
flag_wait("trigger_vfx_pipe_burst");
aud_send_msg("aud_flooded_room_pipe_burst");
wait(0.2);
earthquake ( 0.3, 1.7, level.player.origin, 1024 );
}
vfx_pipe_burst_mr()
{
flag_wait("trigger_vfx_pipe_burst_mr");
aud_send_msg("aud_missile_room_pipe_burst");
wait(0.3);
earthquake ( 0.4, 1.7, level.player.origin, 1024 );
}
vfx_pipe_burst_cr()
{
flag_wait("trigger_vfx_pipe_burst_cr");
aud_send_msg("aud_control_room_pipe_burst");
wait(0.0);
earthquake ( 0.4, 1.7, level.player.origin, 1024 );
}
greenlighton_vfx( guy )
{
level.missile_key_panel_box showpart( "tag_lighton" );
playfxontag(getfx("light_green_pinlight"),level.missile_key_panel_box,"tag_lighton");
wait(1);
thread redlighton_vfx();
exploder(265);
}
redlighton_vfx( guy )
{
playfxontag(getfx("light_red_pinlight_sort"),level.missile_key_panel,"tag_lighton");
}
redlightoff_vfx( guy )
{
exploder(263);
level.missile_key_panel hidepart( "tag_lighton" );
stopfxontag(getfx("light_red_pinlight_sort"),level.missile_key_panel,"tag_lighton");
thread sub_exit_hatch_light();
}
sub_exit_hatch_light()
{
light = GetEnt( "hatch_light", "targetname" );
if( !isdefined( light ) )
return;
{
wait(3.8);
delta = .16;
val = 0.001;
while( val < 1.75 )
{
val = ( val + delta );
light SetLightIntensity( ( val ) );
wait(.05);
}
}
light SetLightIntensity( 1.75 );
}
footStepEffects()
{
animscripts\utility::setFootstepEffect( "water", loadfx ( "maps/ny_harbor/footstep_water" ) );
animscripts\utility::setNotetrackEffect( "knee fx left", "J_Knee_LE", "water", loadfx ( "maps/ny_harbor/footstep_water" ) );
animscripts\utility::setNotetrackEffect( "knee fx right", "J_Knee_RI", "water", loadfx ( "maps/ny_harbor/footstep_water" ) );
animscripts\utility::setFootstepEffectSmall( "water", loadfx ( "maps/ny_harbor/footstep_water" ) );
}
calc_fire_reflections()
{
foreach ( fx in level.createFXent )
{
if ( !isdefined( fx ) )
continue;
if ( fx.v[ "type" ] != "exploder" )
continue;
if ( !isdefined( fx.v[ "exploder" ] ) )
continue;
if ( isdefined( fx.v[ "flag" ] ) )
{
if ( fx.v[ "flag" ]=="fire_reflect" )
{
fx_origin = fx.v[ "origin" ];
fx_type = fx.v[ "fxid" ];
fx thread update_fire_reflections_manager(fx_type,fx_origin);
}
}
}
}
update_fire_reflections_manager(fx_type,fx_origin)
{
fx_distance = Distance(fx_origin, level.player.origin);
while (fx_distance >= 6500)
{
fx_distance = Distance(fx_origin, level.player.origin);
wait 0.25;
}
thread update_fire_reflections(fx_type,fx_origin);
}
update_fire_reflections(fx_type,fx_origin)
{
my_tag = spawn_tag_origin();
my_tag.origin = fx_origin;
reflectfx = getFx(fx_type + "_reflect");
if (isDefined(reflectfx))
playfxontag(reflectfx, my_tag, "tag_origin");
fx_distance = 1;
while (fx_distance < 6500)
{
fx_distance = Distance(my_tag.origin, level.player.origin);
angle_vector = my_tag.origin - (level.player geteye());
constrained_angle = VectorToAngles(angle_vector);
my_tag.angles = (-90,constrained_angle[1],0);
wait 0.05;
}
stopfxontag(reflectfx, my_tag, "tag_origin");
my_tag delete();
thread update_fire_reflections_manager(fx_type,fx_origin);
}
play_missile_hit_screenfx(pos)
{
impactDistance = Distance(pos, level.player.origin);
if (impactDistance < 7000)
{
intensity = 1 - (impactDistance / 7000);
Earthquake( 0.4, 2, pos, 5500 );
setblur(2.0 * intensity, 0.1);
wait .5;
setblur(0, 0.4);
}
}
loop_skybox_hinds()
{
waitframe();
data = spawnStruct();
get_createfx(999, data);
ents = data.v["ents"];
for (i=0; i<ents.size; i++)
{
thread loop_skybox_hinds_update(ents[i], "msg_vfx_surface_zone_25000");
}
}
loop_skybox_hinds_update(fx_ent,fx_flag)
{
flag_wait(fx_flag);
wait randomfloat(4);
endLoc = (anglestoright(fx_ent.v["angles"]) * -50000) + fx_ent.v["origin"];
aud_data[0] = fx_ent.v["origin"];
aud_data[1] = endLoc;
aud_data[2] = 25;
aud_send_msg("fx_skybox_hind", aud_data);
fx_ent activate_individual_exploder();
for(;;)
{
flag_wait(fx_flag);
flag_waitopen("msg_vfx_sub_interior_minus_25000");
wait(randomfloat(6) + 10);
fx_ent activate_individual_exploder();
aud_send_msg("fx_skybox_hind", aud_data);
}
}
loop_skybox_migs()
{
waitframe();
data = spawnStruct();
get_createfx(998, data);
ents = data.v["ents"];
for (i=0; i<ents.size; i++)
{
thread loop_skybox_migs_update(ents[i], "msg_vfx_surface_zone_25000");
}
}
loop_skybox_migs_update(fx_ent,fx_flag)
{
flag_wait(fx_flag);
wait randomfloat(4);
endLoc = anglestoright(fx_ent.v["angles"]) * -140000 + fx_ent.v["origin"] + (0,0,7000);
aud_data[0] = fx_ent.v["origin"];
aud_data[1] = endLoc;
aud_data[2] = 10;
aud_send_msg("fx_skybox_mig", aud_data);
fx_ent activate_individual_exploder();
for(;;)
{
flag_wait(fx_flag);
flag_waitopen("msg_vfx_sub_interior_minus_25000");
wait(randomfloat(12) + 4);
wait 2;
fx_ent activate_individual_exploder();
aud_send_msg("fx_skybox_mig", aud_data);
}
}
play_explode_wave_anim(fire)
{
wait 0.15;
self show();
collision = getent((self.script_noteworthy + "_col"), "script_noteworthy");
if(isdefined(collision))
collision linkto(self, "tag_collision", (0,0,0), (0,-90,0));
aud_send_msg("explode_wave", collision);
self.animname = "explosion_wave";
self SetAnimTree();
if (isDefined(fire))
thread play_wave_fire_fx();
else
thread play_wave_fx();
self anim_single_solo(self, "wave");
self hide();
}
play_wave_fx()
{
playfxontag(getfx("wave_crest_spray"), self, "tag_sprayfx");
wait(1.5);
stopfxontag(getfx("wave_crest_spray"), self, "tag_sprayfx");
}
play_wave_fire_fx()
{
playfxontag(getfx("wave_crest_spray_explosion"), self, "tag_sprayfx");
wait(1.5);
stopfxontag(getfx("wave_crest_spray_explosion"), self, "tag_sprayfx");
}
start_waves_hidden()
{
wait 1.0;
}
get_createfx(num, data)
{
org = [];
ang = [];
ents = [];
exploders = GetExploders( num );
foreach (ent in exploders)
{
org[(org.size)]=ent.v["origin"];
ang[(ang.size)]=ent.v["angles"];
ents[(ents.size)]=ent;
}
data.v["origins"] = org;
data.v["angles"] = ang;
data.v["ents"] = ents;
}
setup_poison_wake_volumes()
{
poison_wake_triggers = getentarray( "poison_wake_volume", "targetname" );
array_thread( poison_wake_triggers, ::poison_wake_trigger_think);
}
poison_wake_trigger_think()
{
for( ;; )
{
self waittill( "trigger", other );
if (other ent_flag_exist("in_poison_volume"))
{}
else
other ent_flag_init("in_poison_volume");
if (isDefined (other) && DistanceSquared( other.origin, level.player.origin ) < 9250000)
{
if (other ent_flag("in_poison_volume"))
{}
else
{
other thread poison_wakefx(self);
other ent_flag_set ("in_poison_volume");
}
}
}
}
poison_wakefx( parentTrigger )
{
self endon( "death" );
thread poison_wake_deathfx();
speed = 200;
for ( ;; )
{
if (self IsTouching(parentTrigger))
{
if (speed > 5)
wait(max(( 1 - (speed / 120)),0.1) );
else
wait (0.15);
fx = parentTrigger.script_fxid;
if ( IsPlayer( self ) )
{
speed = Distance( self GetVelocity(), ( 0, 0, 0 ) );
if ( speed < 5 )
{
fx = "footstep_water_slow";
}
}
if ( IsAI( self ) )
{
speed = Distance( self.velocity, ( 0, 0, 0 ) );
if ( speed < 5 )
{
fx = "footstep_water_slow";
}
}
start = self.origin + ( 0, 0, 64 );
end = self.origin - ( 0, 0, 150 );
trace = BulletTrace( start, end, false, undefined );
water_fx = getfx( fx );
start = trace[ "position" ];
angles = (0,self.angles[1],0);
forward = anglestoforward( angles );
up = anglestoup( angles );
PlayFX( water_fx, start, up, forward );
}
else
{
self ent_flag_clear("in_poison_volume");
return;
}
}
}
poison_wake_deathfx( parentTrigger )
{
self waittill( "death" );
if (self ent_flag_exist("in_poison_volume") && self ent_flag("in_poison_volume") && isdefined(self.origin))
playfx(getfx("death_water"),self.origin, ((270,0,0)));
}
play_slava_missiles()
{
waitframe();
level endon("msg_fx_stop_slava_missiles");
missile_launchers = getentarray("missile_launcher", "targetname");
lastPlayedExplosion = -1;
num = 0;
for(;;)
{
flag_wait("msg_vfx_surface_zone_25000");
flag_waitopen("msg_vfx_sub_interior_minus_25000");
playerAng = level.player getplayerangles();
eye = vectornormalize(anglestoforward(playerAng));
found_exp = -1;
facing_launchers = [];
for ( i = 0;i < missile_launchers.size;i++ )
{
toFX = vectornormalize(missile_launchers[i].origin - level.player.origin);
facingamount = vectordot(eye,toFX);
if(vectordot(eye,toFX)>.75)
{
if (i != lastPlayedExplosion)
{
facing_launchers[facing_launchers.size] = i;
found_exp = 1;
}
}
}
if ( (found_exp > 0) && (facing_launchers.size > 0) )
{
facing_launcher_num = randomInt((facing_launchers.size));
explosionToPlay = facing_launchers[facing_launcher_num];
thread slava_missile_trail(missile_launchers[explosionToPlay]);
lastPlayedExplosion = explosionToPlay;
}
else
{
while(num == lastPlayedExplosion)
{
num = randomint(missile_launchers.size);
explosionToPlay = missile_launchers[num];
}
lastPlayedExplosion = num;
thread slava_missile_trail(missile_launchers[num]);
}
randomwait = randomfloat(2) + 1;
wait (randomwait);
}
}
slava_missile_trail(ent)
{
mis = spawn("script_model", ent.origin);
mis SetModel("vehicle_s300_pmu2");
mis.angles = ent.angles;
aud_data[0] = mis;
aud_send_msg("slava_missile_launch", aud_data);
PlayFXOnTag( getfx( "slava_missile_bg" ), mis, "tag_fx" );
impulse = 12000;
lifetime = 130;
vectorUp = vectornormalize(anglestoforward(mis.angles));
finalVector = vectorUp;
currVel = finalVector * impulse * .05;
gravity = (0,0,(1600) * -1) * .05 * .05;
explode = 0;
while(explode == 0)
{
mis.origin += currVel;
currVel += gravity;
v_orient = vectornormalize(currVel);
n_angles = vectortoangles(v_orient);
mis.angles = n_angles;
level waitframe();
if(mis.origin[2] <= 0)
explode = 1;
}
stopfxontag( getfx( "slava_missile_bg" ), mis, "tag_fx" );
playfx(getfx("horizon_flash_runner"), mis.origin);
aud_data[0] = mis.origin;
aud_send_msg("slava_missile_explode", aud_data);
mis delete();
}
chinook_extraction_fx()
{
waitframe();
if(flag_exist("switch_chinook") == 0)
flag_init("switch_chinook");
flag_wait("switch_chinook");
takeoff = 0;
while(takeoff == 0)
{
fxorigin = level.exit_chinook gettagorigin("tail_rotor_jnt");
currOrigin = (fxorigin[0], fxorigin[1], -290);
fxangles = level.exit_chinook.angles;
currAngles = (270,fxangles[1], 0);
currVector = anglestoforward(currAngles);
playfx(getfx("heli_water_harbor_cinematic"), currOrigin, currVector);
wait 0.1;
}
}
chinook_screen_watersplash()
{
waitframe();
flag_wait("fx_chinook_screen_watersplash");
thread surface_player_water_sheeting_timed(3.0);
}
sub_breached_drainage_fx()
{
level.player waittill( "stop_breathing" );
exploder(26111);
wait 3;
PauseExploders(26111);
}
chinook_interiorfx()
{
waitframe();
if(flag_exist("switch_chinook") == 0)
flag_init("switch_chinook");
flag_wait("switch_chinook");
setsaveddvar("sm_spotlimit",1);
playfxontag(getfx("lights_godray_beam"), level.exit_chinook, "tag_window_light1");
playfxontag(getfx("lighthaze_sub_ladder_bottom"), level.exit_chinook, "tag_window_light2");
playfxontag(getfx("chinook_red_light"), level.exit_chinook, "tag_light_cargo02");
playfxontag(getfx("light_c4_blink"), level.exit_chinook, "tag_nearwall");
playfxontag(getfx("light_c4_blink"), level.exit_chinook, "tag_nearwall2");
}
sub_volumetric_lightbeam()
{
waitframe();
flag_wait("russian_sub_spawned");
wait 7.5;
volumetric_beam = GetEntsByFXID( "sub_volumetric_lightbeam2_static" );
origin = volumetric_beam[0].v["origin"];
angles = volumetric_beam[0].v["angles"];
anim_beam = spawnfx(getfx("sub_volumetric_lightbeam2"), origin, AnglesToForward(angles), AnglesToUp(angles));
triggerfx(anim_beam);
wait(0.01);
volumetric_beam[0] pauseEffect();
playfxontag(getfx("sub_volumetric_shadow_fin_front"),level.russian_sub_02,"tag_fx_fin_f_right");
wait(21.5);
playfxOnTag(getfx("sub_volumetric_shadow_fin_rear"),level.russian_sub_02,"tag_fx_fin_b_right");
leftFin = spawn_tag_origin();
leftFin linkto(level.russian_sub_02, "tag_fx_fin_b_left", (0, -365, -0), (0,0,0));
playfxOnTag(getfx("sub_volumetric_shadow_fin_rear"),leftFin,"tag_origin");
flag_waitopen("msg_vfx_udrwtr_b");
anim_beam delete();
leftFin delete();
}
disable_ambient_fx()
{
level notify("msg_nyharbor_stoplandexplosions");
level notify("msg_nyharbor_stopwaterexplosions");
level notify("msg_fx_stop_slava_missiles");
kill_exploder(242);
kill_exploder(252);
}
reenable_ambient_fx()
{
level thread start_harbor_waterexplosions();
level thread start_harbor_landexplosions();
level thread play_slava_missiles();
exploder(242);
exploder(252);
}
disable_ambient_under_docks()
{
wait 3.0;
flag_wait("msg_fx_under_docks");
disable_ambient_fx();
flag_waitopen("msg_fx_under_docks");
reenable_ambient_fx();
}
sub_explosion_rumble()
{
time = 0.25;
counter = 0;
while( counter < time )
{
level.player PlayRumbleOnEntity( "falling_land" );
wait( 0.05 );
counter += 0.05;
}
StopAllRumbles();
}
viewdependent_vision_enable( bEnable )
{
assert( isplayer( self ) );
self.viewdependent_vision_enabled = bEnable;
}
viewdependent_fog_enable( bEnable )
{
assert( isplayer( self ) );
self.viewdependent_fog_enabled = bEnable;
}
