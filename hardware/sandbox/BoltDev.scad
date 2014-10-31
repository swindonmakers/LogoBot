// Simple test of the bolt library

include <../config/config.scad>

HexBolts = [ M3Hex, M4Hex, M5Hex, M6Hex, M7Hex, M8Hex ];
CapBolts = [ M3Cap, M4Cap, M5Cap, M6Cap, M7Cap, M8Cap ];
Nuts = [ M3Nut, M4Nut, M5Nut, M6Nut, M7Nut, M8Nut];

$fn=50;

for (i = [0:5]) {
	translate([20*i, 0, 0]) {
		Bolt(HexBolts[i], length = 10 + i * 10);
		translate([0, 0, -i*5])
			Nut(Nuts[i]);
	}
}

for (i = [0:5]) {
	translate([20*i, 20, 0]) {
		Bolt(CapBolts[i], length = 10 + i * 10);
		translate([0, 0, -i*5])
			Nut(Nuts[i]);
	}
}

for (i = [0:5]) {
	translate([20*i, 40, 0]) {
		Nut(Nuts[i]);
	}
}
