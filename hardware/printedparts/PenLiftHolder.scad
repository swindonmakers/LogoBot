
PenLiftHolder_Con_Default = DefCon;

module PenLiftHolder_STL()
{
	printedPart("printedparts/PenLiftHolder.scad", "Pen Lift Holder", "PenLiftHolder_STL()") {

		markdown("guide","You may need to ream the pin holes to 7mm, depending on your print tolerances");

	    view(t=[1, -8, -11], r=[52, 0, 23], d=240);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) {
			connector(PenLiftHolder_Con_Default);
		}

		color(Level3PlasticColor) {
			if (UseSTL) {
				import(str(STLPath, "PenLiftHolder.stl"));
			} else {
				PenLiftHolderModel();
			}
		}
	}
}

module PenLiftHolderModel()
{
	render()
	difference() {
		linear_extrude(PenLiftPlateHeight) {
			difference() {
				union () {
					// Rear upright plate
					square([4perim, PenLiftPlateLength], center=true);

					// V-Shape pen holder
					translate([2perim + PenLiftPenOffset, 0, 0])
					difference() {
						square([10, 20], center=true);
						translate([7.5, 0, 0])
						rotate([0, 0, -45])
							square([15, 15], center=true);
					}
				}

				// Rear nubbin cutout
				square([4Perim, 2*4Perim + PenLiftHolderTolerance], center=true);

			}
		}

		// Slots for rubber band pen attachment
		translate([7, 0, 0])
			cube([2, PenLiftPlateLength, 4], center=true);
		translate([7, 0, PenLiftPlateHeight])
			cube([2, PenLiftPlateLength, 4], center=true);

		// Cutaways for rubber band pull down
		for (i=[0, 1])
		mirror([0, i, 0])
		translate([0, PenLiftPlateLength/2 - 2, 0])
			cube([20, 1.5, 4], center=true);

	}
}
