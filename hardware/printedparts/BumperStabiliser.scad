module BumperStabiliser_STL()
{
	printedPart("printedparts/BumperStabiliser.scad", "BumperStabiliser", "BumperStabiliser_STL()") {

	    view(t=[0,0,0], r=[58,0,225], d=681);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) {
			connector(Bumper_Con_LeftPin);
			connector(Bumper_Con_RightPin);
		}

		color(Level2PlasticColor) {
			if (UseSTL) {
				import(str(STLPath, "BumperStabiliser.stl"));
			} else {
				BumperStabiliserModel();
			}
		}
	}
}


module BumperStabiliserModel()
{
	microSwitchAngle = 43.5;	// angle that microswitches are placed at

	offset = 5;					// distance from base to inside of bumper
	bumpstopWidth = 8;			// width of little block that sticks out to hit the microswitch

	difference() {
		linear_extrude(6*layers) {
		for(i=[0, 1])
		mirror([i, 0, 0])
		hull() {
			translate([Bumper_Con_LeftPin[0][0], Bumper_Con_LeftPin[0][1], 0])
				circle(d=10);

			rotate([0, 0, microSwitchAngle])
			translate([0, BaseDiameter/2 - 1 , 0])
				square([bumpstopWidth, offset-1]);
		}

		// generate a nice connecting bezier curve :)
		// number of steps in curve
		steps = 50;

		// control points
		cp1 = [Bumper_Con_LeftPin[0][0], Bumper_Con_LeftPin[0][1]];  // start
		cp4 = [-Bumper_Con_LeftPin[0][0], Bumper_Con_LeftPin[0][1], 0];  // end
		cp2 = [ -5,  cp1[1]-15 ];  // handle 1
		cp3 = [ 5,  cp1[1]-15 ];  // handle 2

		// generate the actual curve
		union() // union lots of little "pill" shapes for each segment of the curve
			for (i=[0:steps-2]) {
				// curve time parameters for this step and next
				u1 = i / (steps-1);
				u2 = (i+1) / (steps-1);

				// 2D points for this step and next
				p1 = PtOnBez2D(cp1, cp2, cp3, cp4, u1);
				p2 = PtOnBez2D(cp1, cp2, cp3, cp4, u2);

				// hull together circles at this the position of this step and next
				hull($fn=8) {
					translate(p1) circle(2perim);
					translate(p2) circle(2perim);
				}
			}

		}

		for(i=[0, 1])
		mirror([i, 0, 0])
		translate([Bumper_Con_LeftPin[0][0], Bumper_Con_LeftPin[0][1], 0])
		rotate([0, 0, microSwitchAngle])
			pinhole(fixed=true);
	}
}
