// Noddy Bolt and Nut library, I'm guessing there are libraries out
// there that do this in a much better way!

// Ratios make bolt heads grow relative to thread diameter.
// Should probably be some kind of lookup to get to precise sizes
BoltLibrary_HeadDiaRatio = 1.9;
BoltLibrary_HeadThicknessRatio = 1.3;

// Connectors
//
// Connectors are defined as an array of 5 parameters:
// 0: Translation vector as [x,y,z]
// 1: Vector defining the normal of the connection as [x,y,z]
// 2: Rotation angle for the connection
// 3: Thickness of the mating part - used for bolt holes
// 4: Clearance diameter of the mating hole - used for bolt holes

BoltLibrary_HexHeadScrew_Con	= [ [0, 0, 0], [0, 0, 1], 0, 0, 0];
BoltLibrary_HexHeadBolt_Con		= [ [0, 0, 0], [0, 0, 1], 0, 0, 0];

module HexHeadScrew(dia = 3, length = 20)
{
	if (DebugCoordinateFrames) {
		frame();
	}

	if (DebugConnectors) {
		connector(BoltLibrary_HexHeadScrew_Con);
	} 

	color(MetalColor) {

		// Thread
		translate([0, 0, -length])
			cylinder(r = dia / 2, h = length + eta);

		// Head
		render()
		difference() {
			cylinder(r = (dia * BoltLibrary_HeadDiaRatio) /  2, h = dia * BoltLibrary_HeadThicknessRatio);
			translate([0, 0, 1])
				cylinder(r = dia / 2, h = dia * BoltLibrary_HeadThicknessRatio, $fn=6);
		}
	}
}

module HexHeadBolt(dia = 3, length = 20)
{
	if (DebugCoordinateFrames) {
		frame();
	}

	if (DebugConnectors) {
		connector(BoltLibrary_HexHeadBolt_Con);
	} 

	color(MetalColor) {

		// Thread
		translate([0, 0, -length])
			cylinder(r = dia / 2, h = length + eta);

		// Head
		difference() {
			cylinder(r = (dia * BoltLibrary_HeadDiaRatio) / 2, h=dia * BoltLibrary_HeadThicknessRatio, $fn=6);
		}
	}
}
