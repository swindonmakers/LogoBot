// Connectors

Capstan_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module Capstan_STL() {

    printedPart("printedparts/Capstan.scad", "Capstan", "Capstan_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(Capstan_Con_Def);
        }

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "Capstan.stl"));
            } else {
                Capstan_Model();
            }
        }
    }
}


module Capstan_Model()
{
    rimThickness = 4;
	spokeThickness = 6;
	hubDiameter = 10;

    od = 34;
    t = 6;

    // Outer Rim
    rotate_extrude($fn=64)
    translate ([(od / 2) - rimThickness, 0, 0])
    difference()
    {
        square([rimThickness, t]);

        translate([rimThickness -2 , 0.5])
            chamferedSquare([5,t-1],2);
    }

    // spokes
    for (i=[0:5])
        rotate([0,0,i*360/6])
        translate([hubDiameter/2-1,-dw/2,0])
        cube([od/2-hubDiameter/2-2, dw, spokeThickness]);

	// Hub
	difference() {
		linear_extrude(6) // = motor_shaft_h - a bit?
		difference() {
			// Center Hub
			circle(r=hubDiameter / 2);

			MotorShaftSlot();
		}

		// Grub screw hole
		*translate([0, 0, 3.5])
		rotate(a=90, v=[0, 1, 0])
			cylinder(r=1.5, h=hubDiameter/2 + eta);

	}
}
