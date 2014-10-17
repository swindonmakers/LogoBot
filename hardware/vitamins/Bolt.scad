// Noddy Bolt and Nut library, I'm guessing there are libraries out
// there that do this in a much better way!

// Ratios make bolt heads grow relative to thread diameter.
// Should probably be some kind of lookup to get to precise sizes
BoltLib_HeadDiaRatio = 1.9;
BoltLibrary_HeadThicknessRatio = 1.3;

module HexHeadScrew(dia = 3, length = 20)
{
	// debug coordinate frame?
	if (DebugCoordinateFrames) {
		frame();
	}

	// Thread
	translate([0,0,-length])
		cylinder(r = dia/2, h = length + eta);

	// Head
	difference()
	{
		cylinder(r = (dia*BoltLib_HeadDiaRatio)/2, h=dia * BoltLibrary_HeadThicknessRatio);
		translate([0,0,1])
			cylinder(r=dia/2, h=dia * BoltLibrary_HeadThicknessRatio, $fn=6);
	}
}

module HexHeadBolt(dia = 3, length = 20)
{
	// debug coordinate frame?
	if (DebugCoordinateFrames) {
		frame();
	}

	// Thread
	translate([0,0,-length])
		cylinder(r = dia/2, h = length + eta);

	// Head
	difference()
	{
		cylinder(r = (dia*BoltLib_HeadDiaRatio)/2, h=dia * BoltLibrary_HeadThicknessRatio, $fn=6);
	}
}

module Nut(dia = 3)
{
	// debug coordinate frame?
	if (DebugCoordinateFrames) {
		frame();
	}

	translate([0,0,-dia * BoltLibrary_HeadThicknessRatio])
	linear_extrude(dia * BoltLibrary_HeadThicknessRatio)
		difference()
		{
			circle(r=(dia*BoltLib_HeadDiaRatio)/2, $fn=6);
			circle(r=(dia)/2, $fn=6);
		}
}