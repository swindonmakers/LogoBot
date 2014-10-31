// Simple test of the bolt library

include <../config/config.scad>
include <../vitamins/Bolt.scad>
include <../vitamins/Nut.scad>

$fn=50;

// You can just specify diameters
for(i = [0:4]) {
	translate([i * 15, 0, 0]) {
		HexHeadScrew(dia = 3 + i, length = 20);
		translate([0, 0, -6])
			Nut(dia = 3 + i);
		
		translate([0, 15, 0]) {
			HexHeadBolt(dia = 3 + i, length = 20);
			translate([0, 0, -6])
				Nut(dia = 3 + i);
		}

		translate([0, 30, 0]) {
			Nut(dia = 3 + i);
		}
	}
}

// Or (if you are paid by the keystroke) you can use the enum types
translate([0, 50, 0]) Nut(M3Nut);
translate([15, 50, 0]) Nut(M4Nut);
translate([30, 50, 0]) Nut(M5Nut);
translate([45, 50, 0]) Nut(M6Nut);
translate([60, 50, 0]) Nut(M7Nut);
translate([75, 50, 0]) Nut(M8Nut);

// Or you can use the convenience functions
translate([0, 70, 0]) M3Nut();
translate([15, 70, 0]) M4Nut();
translate([30, 70, 0]) M5Nut();
translate([45, 70, 0]) M6Nut();
translate([60, 70, 0]) M7Nut();
translate([75, 70, 0]) M8Nut();
