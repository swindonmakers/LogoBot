include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=true;
DebugCoordinateFrames=true;

StealthShell_STL();




module StealthShell_STL() {
	printedPart("printedparts/StealthShell.scad", "Stealth Shell", "StealthShell_STL()") {
	    view(t=[-2, 6, 14], r=[63, 0, 26], d=726);

        color([Level2PlasticColor[0], Level2PlasticColor[1], Level2PlasticColor[2], 1])
             if (UseSTL) {
                import(str(STLPath, "StealthShell.stl"));
            } else {
				StealthShell_Model();
            }
    }
}


module StealthShell_Model() {

	sw = 2 * perim;

	or = BaseDiameter/2 + Shell_NotchTol + dw;

	sr = or - sw + eta;

	supportAngle = 50;
	bridgeDist = 5;

	numRibs1 = round(circumference(sr * cos(supportAngle)) / bridgeDist);
	numRibs = 4 * (floor(numRibs1 / 4) + 1);

	ribThickness = 0.7;

	$fn=64;

	// shell with hole for LED
	//render()
		difference() {
			union() {
				// curved shell with centre hole for pen
				difference() {
					rotate_extrude()
						difference() {
							// outer shell
							donutSector(
								or=or,
								ir=BaseDiameter/2 + Shell_NotchTol,
								a=90
							);

							polygon(
								[
									[0, ShellOpeningHeight + 1000],
									[ShellOpeningDiameter/2 + 1000, ShellOpeningHeight + 1000],
									[ShellOpeningDiameter/2 - dw - 1, ShellOpeningHeight - dw - 1],
									[0, ShellOpeningHeight - dw - 1]
								]);

						}

					difference() {
						linear_extrude(or)
							random_voronoi(
								n = 80, nuclei = false,
								L = or+30, thickness = 1.5,
								round = 1, min = 0, max = 2*or,
								seed = 7, center = true
							);

						// hollow the middle of the voronoi mesh
						cylinder(r=ShellOpeningDiameter/2 + 5, h=or);
					}

				}



				// twist lock
				Shell_TwistLock();
			}
		}
}


/*

    Shell API Functions

    To help build loads of funky shells...  with twist-lock fitting

*/

Shell_NotchOuterWidth   = 20;
Shell_NotchSlope        = 2;
Shell_NotchInnerWidth   = Shell_NotchOuterWidth - 2* Shell_NotchSlope;
Shell_NotchDepth        = 5;
Shell_NotchTol          = 1;
Shell_NotchStop         = dw;
Shell_NotchRotation = 2 * atan2(Shell_NotchOuterWidth/2 - Shell_NotchStop/2, BaseDiameter/2);

// 2D shape to be removed from the base to support shell twist-lock
module Shell_TwistLockCutouts() {
    a = Shell_NotchOuterWidth + 2*Shell_NotchTol;
    b = Shell_NotchInnerWidth + 2*Shell_NotchTol;
    h = Shell_NotchDepth + Shell_NotchTol;
    aOffset = Shell_NotchSlope;

    for (i=[0,1])
        rotate([0,0, i*180 + Shell_NotchRotation/2])
        translate([BaseDiameter/2 - h/2 + eta, 0, 0])
        rotate([0,0, 90])
        trapezoid(b, a, h, aOffset, center=true);
}

// 3D twist-lock ring to mate a shell to the base
module Shell_TwistLock() {
    a = Shell_NotchOuterWidth;
    b = Shell_NotchInnerWidth;
    h = Shell_NotchDepth;
    aOffset = Shell_NotchSlope;

    union() {
        // Locking tabs
        for (i=[0,1])
            translate([0,0,-dw])
            difference() {
                // create the basic tab shape
                linear_extrude(dw)
                    hull() {
                        // Locking tab
                        rotate([0,0, i*180 - Shell_NotchRotation/2])
                            translate([BaseDiameter/2 - h/2 + eta, 0, 0])
                            rotate([0,0, 90])
                            trapezoid(b, a, h, aOffset, center=true);

                        // linking piece to connect locking tab to outer ring
                        translate([0,0,0])
                            rotate([0,0, i*180 - Shell_NotchRotation])
                            donutSector(or=BaseDiameter/2 + Shell_NotchTol + dw,
                                ir=BaseDiameter/2,
                                a=Shell_NotchRotation
                            );
                    }

                // now chop out a slight slope to allow for a tight friction fit
                rotate([0,0, i*180 - Shell_NotchRotation/2])
                    translate([BaseDiameter/2 - h - 3, 0, dw * 0.8])
                    rotate([5,0,0])
                    translate([0,-a/2-1,0])
                    cube([10, a + 2,10]);
            }


        // notch stops
        for (i=[0,1])
            rotate([0,0, i*180 - Shell_NotchRotation/2 + 0.3])
            translate([BaseDiameter/2 - h/2 + 1+eta, a/2 - Shell_NotchStop/2 - 0.5/2, -dw])
            rotate([0,0, 90])
            linear_extrude(dw*2)
            trapezoid(Shell_NotchStop-aOffset+0.7, Shell_NotchStop+1.3, h+2, 0, center=true);

        // outer ring
        translate([0,0,-dw])
            rotate_extrude()
            translate([BaseDiameter/2 + Shell_NotchTol, 0])
            union() {
                square([dw, 3*dw]);

                translate([eta, 3*dw - Shell_NotchTol, 0])
                    mirror([1,1,0])
                    rightTriangle(dw, dw, center = true);

                translate([-dw+eta, 3*dw - Shell_NotchTol - eta,0])
                    square([dw, Shell_NotchTol+eta]);
            }

    }
}
