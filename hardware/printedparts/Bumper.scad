/* Pins required - 

pintack(side=true, h=7.8+2+2.5, bh=2);

*/

module Bumper_STL()
{
	printedPart("printedparts/Bumper.scad", "Bumper", "Bumper_STL()") {

	    //view(t=[0, -1, -1], r=[49, 0, 25], d=336);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) connector(Wheel_Con_Default);

		color(Level2PlasticColor) {
			if (UseSTL) {
				import(str(STLPath, "Bumper.stl"));
			} else {
				BumperModel();
			}
		}
	}
}

module BumperModel()
{
	// Parameters
	thickness = dw;				// bumper thickness
	height = 15;				// bumper height
	offset = 5;					// distance from base to inside of bumper
	wrapAngle = 170;			// angle that bumper wraps around
	microSwitchAngle = 43.5;	// angle that microswitches are placed at

	bumpstopWidth = 8;			// width of little block that sticks out to hit the microswitch
	bumpstopHeight = 5;			// height of little block that sticks out to hit the microswitch

	// Calculated parameters
	outr = BaseDiameter/2 + offset + thickness;		// outside radius or the bumper

	// Bumper arc
	linear_extrude(height)
	rotate([0, 0, (180 - wrapAngle) / 2])
		donutSector(outr, outr - thickness, wrapAngle);

	// Connectors
	for(i=[0, 1])
	mirror([i, 0, 0]) 
	rotate([0, 0, microSwitchAngle]) {

		// Springy bits
		translate([15, BaseDiameter/2 - 11, 0])
		rotate([0, 0, -130])
		linear_extrude(5)
			donutSector(17, 17 - 2*perim, 175);

		// Bumpstops to hit microwitch arm
		translate([0, BaseDiameter/2 - 1 , 0])
			cube([bumpstopWidth, offset + 1 , bumpstopHeight]);

		// Microswitch plates
		translate([-10, BaseDiameter/2 - 16, 0])
			MicroSwitchPlate();
	}
}

module MicroSwitchPlate()
{
	// Parameters - todo: pickup from microswitch model?
	ms_length=12.9;
	ms_width=6.6;
	ms_height=5.8;

	base_length = ms_length + 0.5 + 2*dw;
	base_width = ms_width + 6.5;

	// Base
	cube([base_length, base_width, dw]);
	// Microswitch surround
	cube([dw, base_width, dw + 3]);
	translate([base_length - dw, 0, 0])
		cube([dw, base_width, dw + 3]);
	translate([0, 4, 0])
		cube([base_length, dw, dw + 2]);
	

	// Rear support lozenge with pin hole
	lozenge_height = dw + ms_height;

	translate([0, -7, 0])
	difference() {
		linear_extrude(lozenge_height)
		hull() {
			translate([2.5, 7])
				circle(r=2.5);
			translate([base_length, 9.5])
				circle(r=eta);
			translate([13, 1])
				circle(r=2.5);
			translate([20, 1])
				circle(r=2.5);
		}

		// Actual hole
		translate([15.7, 2.65, lozenge_height + dw])
		mirror([0, 0, 1])
			pinhole(fixed=true);
	}
}
