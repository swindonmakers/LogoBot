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
	microSwitchAngle = 45;	// angle that microswitches are placed at

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
		translate([0, BaseDiameter/2, 0])
			cube([8, offset + eta, 10]);
	}

	// Microswitch plates
	for(i=[0,1])
	mirror([i, 0, 0])
	rotate([0, 0, microSwitchAngle])
	translate([-8, BaseDiameter/2 - 9.5, 0])
	linear_extrude(dw)
	difference() {
		square([15.5, 8]);
	
		// Microswitch mount holes
		translate([-ms_datxoffset, ms_datyoffset + ms_height/2])
			circle(d=ms_holedia);
		translate([-ms_datxoffset - ms_xholepitch, ms_datyoffset + ms_height/2])
			circle(d=ms_holedia);
	}
}
