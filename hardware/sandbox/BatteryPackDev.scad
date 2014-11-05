// Simple test of the bolt library

include <../vitamins/BatteryPack.scad>

$fn=50;

*battery_pack_linear(BatteryPack_AA, 2,4);
*battery_pack_double(BatteryPack_AA, 2, 4);
/*
battery(BatteryPack_AA);
*BatteryPack(BatteryPack_AA);

*/