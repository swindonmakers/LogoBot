// Simple test of the bolt library

include <../config/config.scad>
include <../vitamins/Bolt.scad>

$fn=50;

for(i=[0:4]) {
	translate([i*15, 0, 0]) {
		HexHeadScrew(dia=3+i, length=20);
		translate([0,0,-6])
			Nut(dia=3+i);
		
		translate([0,15,0]) {
			HexHeadBolt(dia=3+i, length=20);
			translate([0,0,-6])
				Nut(dia=3+i);
		}
	}
}