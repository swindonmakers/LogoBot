/*
	Vitamin: Bolt
	
	Local Frame: 
		Top of the shaft of the bolt
*/

// Ratios make bolt heads grow relative to thread diameter.
// Should probably be some kind of lookup to get to precise sizes
Bolt_HeadDiaRatio = 1.9;
Bolt_HeadThicknessRatio = 1.3;

// Connector
Bolt_Con = DefCon;

// Bolt Types
// Parameters are
//  [0] - bolt type: 0 = Machine Screw (round head), 1 = Hex Head
//  [1] - diameter
M3Cap = [ 0, 3 ];
M4Cap = [ 0, 4 ];
M5Cap = [ 0, 5 ];
M6Cap = [ 0, 6 ];
M7Cap = [ 0, 7 ];
M8Cap = [ 0, 8 ];
M3Hex = [ 1, 3 ];
M4Hex = [ 1, 4 ];
M5Hex = [ 1, 5 ];
M6Hex = [ 1, 6 ];
M7Hex = [ 1, 7 ];
M8Hex = [ 1, 8 ];

module Bolt(BoltType = M3Cap, length = 20)
{
	type = BoltType[0];
	dia = BoltType[1];

	if (DebugCoordinateFrames)
		frame();

	if (DebugConnectors)
		connector(Bolt_Con);

	color(MetalColor) {

		// Thread
		translate([0, 0, -length])
			cylinder(r = dia / 2, h = length + eta);

		// Head
		if (type == 0) { 
			// Machine Screw
			difference() {
				cylinder(r = (dia * Bolt_HeadDiaRatio) /  2, h = dia * Bolt_HeadThicknessRatio);
				translate([0, 0, 1])
					cylinder(r = dia / 2, h = dia * Bolt_HeadThicknessRatio, $fn=6);
			}
		}
		else if (type == 1) { 
			// Hex Head Bolt
			cylinder(r = (dia * Bolt_HeadDiaRatio) / 2, h=dia * Bolt_HeadThicknessRatio, $fn=6);
		}

	}
}
