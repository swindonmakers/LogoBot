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

	// Guide pins
	for(i=[0,1])
	mirror([i, 0, 0])
	rotate(a=microSwitchAngle, v=[0, 0, 1]) {
		for(i = [0,1])
		mirror([i, 0, 0,]) {
			translate([-1.5 - 8.6, BaseDiameter/2 - Bumper_Pin_Length, 0])
				cube([Bumper_Pin_Width, Bumper_Pin_Length + eta, 5]);
			translate([-1.5 - 8.6, BaseDiameter/2, 0])
				cube([Bumper_Pin_Width + 8.5, offset + eta, 5]);
		}
	}
}
