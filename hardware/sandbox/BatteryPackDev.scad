// Simple test of the bolt library

include <../config/config.scad>
include <../vitamins/BatteryPack.scad>

$fn=50;

BatteryPack();

*battery_pack_linear(2, 4);

*translate([75, 0, 0])
  battery_pack_double(3,4);