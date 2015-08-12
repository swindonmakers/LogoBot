module ProMiniClip_STL()
{
	printedPart("printedparts/ProMiniClip.scad", "Pro Mini Clip", "ProMiniClip_STL()") {

		view(t=[0,0,0],r=[145,135,0],d=150);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) connector(Con_Default);

		color(Level2PlasticColor) {
			if (UseSTL) {
				import(str(STLPath, "ProMiniClip.stl"));
			} else {
				ProMiniClipModel();
			}
		}
	}
}

module ProMiniClipModel()
{
	ProMini_Width = 18 + 0.5; // +0.5 tolerance (note this doesn't currently agree with the dimensions in the vitamin)
	ProMini_BoardHeight = 3.5; // PCB thickness including room for solder pads to stick out underneath

	clip = 1.5; // How much the clip protrudes to hold the board

	rotate([90, 0, 0])
	translate([0, 0, -2.5]) {

		pintack(side=true, h=2.25 + 3, bh=0);

		linear_extrude(5)
		translate([0, -(2Perim + ProMini_BoardHeight + 2Perim)/2, 0])
		difference() {
			square([ProMini_Width + 4Perim, 2Perim + ProMini_BoardHeight + 2Perim], center=true);

			translate([0, -(2Perim - 2Perim)/2, 0])
				square([ProMini_Width, ProMini_BoardHeight], center=true);
			translate([0, -(2Perim)/2, 0])
				square([ProMini_Width-clip, ProMini_BoardHeight+2Perim], center=true);
		}
	}
}
