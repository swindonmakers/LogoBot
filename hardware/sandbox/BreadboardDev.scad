// test wrapper for the Breadboard vitamin

include <../config/config.scad>

include <../vitamins/Breadboard.scad>

DebugCoordinateFrame = true;
DebugConnectors = true;

Breadboard(Breadboard_170);

translate([Breadboard_Width(Breadboard_170) + 10, 0, 0])
	Breadboard(Breadboard_270, BoardColor = "red");
	
translate([0, Breadboard_Depth(Breadboard_270) + 10, 0])
	Breadboard(Breadboard_400, BoardColor = [0.3,1,0.3]);