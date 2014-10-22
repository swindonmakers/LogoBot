/*

	Playground for developing the vitamins/MarbleCaster.scad library

*/

include <../config/config.scad>

include <../assemblies/MarbleCaster.scad>

DebugCoordinateFrames = false;
DebugConnectors = false;

*MarbleCasterAssembly();

MarbleCaster_STL(20);

// test plate
*difference() {
	cylinder(r=15, h=dw);
	
	cylinder(r=connector_bore(MarbleCastor_Con_Default)/2, h=100, center=true);

}