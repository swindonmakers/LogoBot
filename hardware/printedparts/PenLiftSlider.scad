/*
	pins required, 2x
	pintack(side=false, h=2.5+4+2.5, bh=2);
*/


PenLiftSlider_Con_Holder = DefCon;
PenLiftSlider_Con_BaseFront = [[10, -20, 0], [0, 0, -1], 0, 0, 0];
PenLiftSlider_Con_BaseRear = [[10, 20, 0], [0, 0, -1], 0, 0, 0];

module PenLiftSlider_STL()
{
	printedPart("printedparts/PenLiftSlider.scad", "Pen Lift Slider", "PenLiftSlider_STL()") {

	    view(t=[1, -8, -11], r=[52, 0, 23], d=184);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) {
			connector(PenLiftSlider_Con_Holder);
			connector(PenLiftSlider_Con_BaseFront);
			connector(PenLiftSlider_Con_BaseRear);
		}

		color(Level2PlasticColor) {
			if (UseSTL) {
				import(str(STLPath, "PenLiftSlider.stl"));
			} else {
				PenLiftSliderModel();
			}
		}
	}
}

module PenLiftSliderModel()
{
	render()
	difference() {
		union() {
			linear_extrude(PenLiftPlateHeight) {
				difference () {
					square([4perim + 2 * 4perim, PenLiftPlateLength + 2 * 4perim], center=true);

					square([4perim + PenLiftHolderTolerance, PenLiftPlateLength + PenLiftHolderTolerance], center=true);

					translate([4Perim, 0, 0])
						square([3*4perim, 21], true);
				}
				translate([-PenLiftHolderTolerance/2, 0, 0])
					square([4Perim, 2*4Perim], center=true);
			}

			// Base plate attachment lugs
			linear_extrude(4)
			difference () {
				for (i=[0, 1])
				mirror([0, i, 0])
				translate([10, -20, 0])
				difference() {
					rotate([0, 0, 49]) {
						circle(d=10);
						translate([0, 5, 0])
							square([5, 15], center=true);
					}
					circle(d=7);
				}

				square([4perim + PenLiftHolderTolerance, PenLiftPlateLength + PenLiftHolderTolerance], center=true);

				translate([4Perim, 0, 0])
					square([3*4perim, 21], true);
			}
		}

		// Cutaways for rubber band pull down
		for (i=[0, 1])
		mirror([0, i, 0])
		translate([0, PenLiftPlateLength/2 - 2, 0])
			cube([20, 1.5, 4], center=true);
	}
}
