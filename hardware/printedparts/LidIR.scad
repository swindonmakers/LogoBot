LidIR_Con_Servo = [[0, 0, -3], [0, 0, 1], 90, 0, 0];

module LidIR_STL() {

    printedPart("printedparts/LidIR.scad", "LidIR", "LidIR_STL()") {

        markdown("guide","Includes built-in support material which should easily break out after printing");

        view(t=[0,0,0], r=[58,0,225], d=180);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
			connector(DefCon);
			connector(LidIR_Con_Servo);
		}

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "LidIR.stl"));
            } else {
                LidIR_Model();
            }
        }
    }
}


module LidIR_Model()
{
    sw = dw;

    or = BaseDiameter/2 + Shell_NotchTol + dw;

    sr = or - sw + eta;

    supportAngle = 50;
    bridgeDist = 6;

    numRibs1 = round(circumference(sr * cos(supportAngle)) / bridgeDist);
    numRibs = 4 * (floor(numRibs1 / 4) + 1);

    ribThickness = 0.7;

    $fn=64;

    clearance = 0.5;

    //render()
    translate([0,0,-ShellOpeningHeight])
    difference() {
        union() {

            // dome
            rotate_extrude()
            difference() {
                // outer shell
                donutSector(
                    or=or,
                    ir=BaseDiameter/2 + Shell_NotchTol,
                    a=90
                );

                // opening for lid, as a 45 degree chamfer starting at ShellOpeningDiameter and sloping inwards
                // less fitting clearance
                polygon(
                    [
                        [ShellOpeningDiameter/2 - dw - 1 - clearance, ShellOpeningHeight - dw - 1],
                        [ShellOpeningDiameter/2 + 1000, ShellOpeningHeight + 1000],
                        [BaseDiameter, 0],
                        [0,0],
                        [0, ShellOpeningHeight - dw - 1],

                    ]);
            }


            // skirt
            translate([0,0, ShellOpeningHeight])
                tube(or=ShellOpeningDiameter/2+dw - dw*cos(45) - clearance, ir=ShellOpeningDiameter/2- dw*cos(45), h=2*dw);



            // ribs
			render()
			difference() {
				intersection() {
					union() {
						// large support ribs
						for (i=[0:numRibs/4])
							rotate([0,0,i*360/(numRibs/4)])
							rotate([90,0,0])
							domeSupportSegment(sr, 0, ribThickness, supportAngle);

						// medium support ribs
						for (i=[0:numRibs/4])
							rotate([0,0,i*360/(numRibs/4) + 360/(numRibs/2)])
							rotate([90,0,0])
							domeSupportSegment(sr, 0 + 2*bridgeDist, ribThickness, supportAngle);

						// small support ribs
						for (i=[0:numRibs/2])
							rotate([0,0,i*360/(numRibs/2) + 360/(numRibs)])
							rotate([90,0,0])
							domeSupportSegment(sr, 0 + 4*bridgeDist, ribThickness, supportAngle);
					}

					cylinder(r=ShellOpeningDiameter/2, h=BaseDiameter);

				}

				// trim off bottom
				translate([-500,-500,-1000 + ShellOpeningHeight - dw])
					cube([1000,1000,1000]);

				// trim out servo bar
				translate([0, 0, ShellOpeningHeight - 2])
				linear_extrude(4)
				hull() {
					circle(d=6.8+4);

					for(i=[0, 1])
					mirror([0, i, 0])
					translate([0, ShellOpeningDiameter/2 - 2, 0])
						circle(d=3);
				}
			}


            // nubbins to snap fit the lid into the shell

            for (i=[0:2])
                rotate([0,0,i*360/3])
                translate([ShellOpeningDiameter/2+dw - dw*cos(45) - clearance, 0, ShellOpeningHeight-dw])
                rotate([90,0,0])
                translate([0,0,-dw/2])
                linear_extrude(dw)
                polygon([
                    [0,0],
                    [0,dw+1],
                    [dw/2,dw/2],
                    [0,0]
                ]);
        }

		// cutouts for IR sensor
		translate([0, 0, ShellOpeningHeight-dw])
		linear_extrude(20) {
			translate([0, 2.2, 0])
			square([29.5, 7.1], center=true);
			translate([0, -2, 0])
				square([8.3, 4], center=true);
		}
		translate([0, 0, ShellOpeningHeight + 11.2])
		linear_extrude(5) {
			translate([0, -4.8, 0])
				square([29.5, 7], center=true);
		}

    }
		
	// Servo connector bar
	translate([0, 0, -2])
	linear_extrude(4)
	difference() {
		// Main structure
		hull() {
			circle(d=6.8 + 4);
			translate([0, 13.8, 0])
				circle(d=3.8+4);

			for(i=[0, 1])
			mirror([0, i, 0])
			translate([0, ShellOpeningDiameter/2 - 2, 0])
				circle(d=3);

		}

		// Cutout for servo horn to fit into
		hull() {
			circle(d=6.8+.5);
			translate([0, 13.8+.5, 0])
				circle(d=3.8);
		}

		// Weight / filament saving cutouts
		hull() {
			translate([0, -8, 0])
				circle(d=5);
			translate([0, -ShellOpeningDiameter/2 + 2, 0])
				circle(d=.5);
		}
		hull() {
			translate([0, 20, 0])
				circle(d=3);
			translate([0, ShellOpeningDiameter/2 - 2, 0])
				circle(d=.5);
		}
	}
}
