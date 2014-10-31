/*
	Vitamin: Nut
	
	Local Frame: 
		Top of the center of the nut
*/

// Ratios make nut heads grow relative to thread diameter.
// Should probably be some kind of lookup to get to precise sizes
Nut_HeadDiaRatio = 1.9;
Nut_HeadThicknessRatio = 1.3;

// Connector
Nut_Con	= DefCon;

// Nut types, single parameter, diameter
M3Nut = 3;
M4Nut = 4;
M5Nut = 5;
M6Nut = 6;
M7Nut = 7;
M8Nut = 8;

// Convenience Functions
module M3Nut() { Nut(M3Nut); }
module M4Nut() { Nut(M4Nut); }
module M5Nut() { Nut(M5Nut); }
module M6Nut() { Nut(M6Nut); }
module M7Nut() { Nut(M7Nut); }
module M8Nut() { Nut(M8Nut); }

module Nut(dia = 3)
{
	if (DebugCoordinateFrames)
		frame();

	if (DebugConnectors)
		connector(Nut_Con);

	color(MetalColor) {
		translate([0, 0, -dia * Nut_HeadThicknessRatio])
		linear_extrude(dia * Nut_HeadThicknessRatio)
		difference() {
			circle(r = (dia * Nut_HeadDiaRatio) / 2, $fn=6);
			circle(r = dia / 2, $fn=6);
		}
	}
}