module Wheel_STL() {

	printedPart("printedparts/Wheel.scad", "Wheel", "Wheel_STL()") {
	
	    view(t=[0, -1, -1], r=[49, 0, 25], d=336);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) connector(Wheel_Con_Default);
	
	    color(Level2PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "Wheel.stl"));
            } else {
				WheelModel();
            }
        }
	}
}


module WheelModel()
{
	rimThickness = 4;
	spokeThickness = 5;
	hubDiameter = 10;

    // Outer Rim
    rotate_extrude($fn=100)
    translate ([(WheelDiameter / 2) - rimThickness, 0, 0])
    difference()
    {
        square([rimThickness, WheelThickness]);

        translate([rimThickness + 0.5 , WheelThickness / 2])
            circle(r = WheelThickness / 4);
    }
	
	// Spokes
	linear_extrude(WheelThickness)
	difference() {
		union() {
			// Cool, curvey spokes
			for (i = [0, 120, 240])
				rotate(i)
				translate([WheelDiameter / 4 - 1, 0 ])
				difference() {
					circle(r=WheelDiameter / 4 - 2);
					circle(r=WheelDiameter / 4 - 2 - spokeThickness/2);
				}

			// Boring straight spokes	
			*for (i = [0, 90, 180, 270])
				rotate(i)
				translate([hubDiameter / 2 - 1, -spokeThickness / 2, 0 ])
					square([(WheelDiameter / 2) - (hubDiameter / 2 - 1) - (rimThickness - 1), spokeThickness]);
		}

		// Chop out center where hub will go
		translate([0,0,-eta])
			circle(r=hubDiameter/2 - eta);
	}

	// Hub
	render()
	difference() {
		linear_extrude(6) // = motor_shaft_h - a bit?
		difference() {
			// Center Hub
			circle(r=hubDiameter / 2);

			MotorShaftSlot();
		}

		// Grub screw hole
		translate([0, 0, 3.5])
		rotate(a=90, v=[0, 1, 0])
			cylinder(r=1.5, h=hubDiameter/2 + eta);

	}
}

module MotorShaftSlot()
{
	difference() {
		circle(r = 5/2); // = motor_shaft_r / 2

		for(i = [0:1])
			mirror([i, 0, 0])		
			translate([MotorShaftFlatThickness / 2, -MotorShaftDiameter / 2, 0])
				square([MotorShaftDiameter / 2, MotorShaftDiameter]);
	}
}

module Tyre_STL()
{
	tyreThickness = 1.5;
	stretchAmount = 2; // Make tyre dia this much less than wheel so it is stretch to fit

	color(Grey80)
	rotate_extrude($fn=100)
	translate ([(WheelDiameter - stretchAmount) / 2, 0, 0]) {
        square([tyreThickness, WheelThickness]);

        translate([0 , WheelThickness / 2])
            circle(r = WheelThickness / 4);
	}
}