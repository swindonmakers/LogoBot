include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=true;
DebugCoordinateFrames=true;

LatticeShell_STL();




module LatticeShell_STL() {
	printedPart("printedparts/LatticeShell.scad", "Lattice Shell", "LatticeShell_STL()") {
	    view(t=[-2, 6, 14], r=[63, 0, 26], d=726);

        color([Level2PlasticColor[0], Level2PlasticColor[1], Level2PlasticColor[2], 1])
             if (UseSTL) {
                import(str(STLPath, "LatticeShell.stl"));
            } else {
				LatticeShell_Model();
            }
    }
}


module LatticeShell_Model() {

	sw = 2 * perim;

	or = BaseDiameter/2 + Shell_NotchTol + dw;

	sr = or - sw + eta;

	supportAngle = 50;
	bridgeDist = 5;

	numRibs1 = round(circumference(sr * cos(supportAngle)) / bridgeDist);
	numRibs = 4 * (floor(numRibs1 / 4) + 1);

	ribThickness = 0.7;

	$fn=64;

	//LatticeShell_Lattice();

	// shell with hole for LED
	//render()
	union() {
		// shell coupler and skirt
		difference() {
			rotate_extrude()
				difference() {
					union() {
						// upper coupling ring
						rotate([0,0,56])
							donutSector(
								or=or,
								ir=BaseDiameter/2 + Shell_NotchTol,
								a=20
							);

						// lower skirt
						rotate([0,0,0])
							donutSector(
								or=or,
								ir=BaseDiameter/2 + Shell_NotchTol,
								a=5
							);
					}


					polygon(
						[
							[0, ShellOpeningHeight + 1000],
							[ShellOpeningDiameter/2 + 1000, ShellOpeningHeight + 1000],
							[ShellOpeningDiameter/2 - dw - 1, ShellOpeningHeight - dw - 1],
							[0, ShellOpeningHeight - dw - 1]
						]);

				}
		}

		// Lattice
		LatticeShell_Lattice();

		// twist lock
		Shell_TwistLock();
	}

}


module LatticeShell_Lattice() {
	or = BaseDiameter/2 + Shell_NotchTol + dw;


	// number of steps in curve
	steps = 20;

	stripWidth = 2.5;
	numStrips = 40;

	intersection() {
		// shell
		rotate_extrude()
			donutSector(
				or=or,
				ir=BaseDiameter/2 + Shell_NotchTol,
				a=58
			);

		// lattice work
		for (k=[0:numStrips-1])
			rotate([0,0,k * 360/numStrips]) {
				// control points
				//cp1 = [rands(-10,10,1)[0], 0];  // start
				//cp4 = [rands(-5,5,1)[0] + (k%2 == 0 ? 20 : -20),  or * sin(60) + 5];  // end
				cp1 = [0, 0];  // start
				cp4 = [(k%2 == 0 ? 20 : -20),  or * sin(60)];  // end
				cp2 = [ cp1[0] + rands(-25,25,1)[0],  or * sin(20) ];  // handle 1
				cp3 = [ cp4[0] + rands(-25,25,1)[0],  or * sin(40)];  // handle 2

				// generate and position the curve
				rotate([90,0,0])
					translate([0,0,0])
					linear_extrude(2*or)
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
							translate(p1) circle(stripWidth/2);
							translate(p2) circle(stripWidth/2);
						}
					}
			}
	}


}
