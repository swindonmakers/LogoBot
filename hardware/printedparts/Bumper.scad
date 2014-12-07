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

Bumper_Pin_Width = 3;
Bumper_Pin_Length = 18;

module BumperModel()
{
	thickness = dw;
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

	// Springy bits
	for(i=[0,1])
		mirror([i, 0, 0])
		translate([30, outr - 24, 0])
		rotate([0,0,90])
		linear_extrude(5)
			donutSector(17, 17 - 2*perim, 175, center=true);

	// Flanges to hit microwitch
	for(i=[0,1])
	mirror([i, 0, 0])
	rotate(a=microSwitchAngle, v=[0, 0, 1]) {
		translate([0, BaseDiameter/2 - 1 , 0])
			cube([8, offset + 1 + eta, 5]);
	}

	// Microswitch plates
	for(i=[0,1])
	mirror([i, 0, 0])
	rotate([0, 0, microSwitchAngle])
	translate([-10, BaseDiameter/2 - 23, 0])
		MicroSwitchPlate();
	
}


module MicroSwitchPlate()
{
	ms_length=12.9;
	ms_width=6.6;
	ms_height=5.8;

	base_length = ms_length + 2 * dw + 0.5;
	base_width = ms_width + 13.5;

	// Base
	translate([0, 6.5, 0])
		cube([base_length, base_width - 6.5, dw]);

	// Microswitch surround
	translate([0, 7, 0])
		cube([dw, base_width - 7, dw + 3]);
	translate([base_length - dw, 7, 0])
		cube([dw, base_width - 7, dw + 3]);
	translate([0, 13-dw, 0])
		cube([base_length, dw, dw + 2]);

	// Pin section
	difference() {
		linear_extrude(dw + ms_height)
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

		translate([base_length/2 + 7, 2.65, dw + ms_height - eta])
		translate([0,0,dw])
		mirror([0,0,1])
			pinhole(fixed=true);
	}
}