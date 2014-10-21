// test wrapper for the Breadboard vitamin

include <../config/config.scad>

include <../vitamins/Breadboard.scad>

DebugCoordinateFrame = true;
DebugConnectors = true;

Breadboard(Breadboard170);

translate([Breadboard_Width(Breadboard170) + 10, 0, 0])
	Breadboard(Breadboard270, BoardColor = "red");
	
translate([0, Breadboard_Depth(Breadboard270) + 10, 0])
	Breadboard(Breadboard400, BoardColor = [0.3,1,0.3]);