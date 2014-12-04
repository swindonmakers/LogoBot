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

Bumper_Pin_Width = 3;
Bumper_Pin_Length = 18;

module BumperModel()
{
	thickness = 2;
	height = 15;
	offset = 5;				// distance from base to inside of bumper
	wrapAngle = 170;		// angle that bumper wraps around
	microSwitchAngle = 43.5;	// angle that microswitches are placed at

	outr = BaseDiameter/2 + offset + thickness; // outr is the outside radius or the bumper



	// Bumper arc
	linear_extrude(height)
	difference() {
		circle(r = outr);

		circle(r = outr - thickness);

		// Chop off below X-axis
		translate([-outr, -outr])
			square([outr*2, outr]);

		// Trim left side of arc
		rotate(a=wrapAngle/2, v=[0,0,1])
		translate([-outr, 0])
			square([outr, outr * 2]);

		// Trim right side of arc
		rotate(a=-wrapAngle/2, v=[0,0,1])
			square([outr, outr * 2]);
	}

	// Springy bits - to illustrate the idea
	// would also get rid of the need for the guide pins
	for(i=[0,1])
		mirror([i, 0, 0])
		translate([32, outr - 19, 0])
		rotate([0,0,90])
		linear_extrude(5)
			donutSector(12, 12 - 2*perim, 230, center=true);

	// Flanges to hit microwitch
	for(i=[0,1])
	mirror([i, 0, 0])
	rotate(a=microSwitchAngle, v=[0, 0, 1]) {
		translate([0, BaseDiameter/2+2, 0])
			cube([8, offset-2 + eta, 6]);
	}

	// Microswitch plates
	for(i=[0,1])
	mirror([i, 0, 0])
	rotate([0, 0, microSwitchAngle])
	translate([-10, BaseDiameter/2 - 16, 0])
		MicroSwitchPlate();
	
}


module MicroSwitchPlate()
{
	ms_length=12.9;
	ms_width=6.6;
	ms_height=5.8;

	base_length = ms_length + 2 * dw + 0.5;
	base_width = ms_width + 10;

	// Base
	translate([0, 4, 0])
		cube([base_length, base_width - 4, dw]);

	// Microswitch surround
	translate([0, 4, 0])
		cube([dw, base_width - 4, dw + 3]);
	translate([base_length - dw, 4, 0])
		cube([dw, base_width - 4, dw + 3]);
	translate([0, 10-dw-.5, 0])
		cube([base_length, dw, dw + 2]);

	// Pin section
	linear_extrude(dw + ms_height)
	hull() {
		translate([0, 5])
			circle(r=eta);
		translate([base_length, 5])
			circle(r=eta);
		translate([2.5, 2.5])
			circle(r=2.5);
		translate([base_length - 2.5, 2.5])
			circle(r=2.5);
	}
	translate([base_length/2, 2.5, dw + ms_height - eta])
		pin(h=BaseThickness + 3, lh=3);
}