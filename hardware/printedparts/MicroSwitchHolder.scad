module MicroSwitchHolder_STL()
{
	printedPart("printedparts/MicroSwitchHolder.scad", "MicroSwitchHolder", "MicroSwitchHolder_STL()") {
	
	    //view(t=[0, -1, -1], r=[49, 0, 25], d=336);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) connector(DefCon);
	
	    color(Level2PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "MircoSwitchHolder.stl"));
            } else {
				MircoSwitchHolderModel();
            }
        }
	}
}

// TODO: import from Microswitch model?
// + 0.6 tolerances
ms_length = 12.9 + 0.6;
ms_width = 6.6 + 0.6;
ms_height = 5.8 + 0.6;
ms_datxoffset = -9.6;
ms_datyoffset = -1.25;
ms_holedia = 2;
ms_xholepitch = 6.2;

module MircoSwitchHolderModel()
{
	depth = 16;
	// TODO: Bumper pin width is defined in Bumper.scad, which conveniently is included before this file.
	//       I don't like such a "convenience" 
	width = ms_length + 2*dw + 2*(Bumper_Pin_Width + 1); 

	// Base
	linear_extrude(dw)
	difference() {
		square([width, depth]);

		translate([(Bumper_Pin_Width + 1) + dw, 0, 0]) {
			// Microswitch mount holes
			translate([-ms_datxoffset, ms_datyoffset + ms_height])
				circle(d=ms_holedia);
			translate([-ms_datxoffset - ms_xholepitch, ms_datyoffset + ms_height])
				circle(d=ms_holedia);
		}
	}

	// Guide rails
	cube([dw, depth, dw + ms_height]);
	translate([width - dw, 0, 0])
		cube([dw, depth, dw + ms_height]);

	translate([dw + (Bumper_Pin_Width + 1), depth - 5, 0])
		cube([dw, 5, dw + ms_height]);
	translate([width - 2 * dw - (Bumper_Pin_Width + 1), depth - 5, 0])
		cube([dw, 5, dw + ms_height]);
}
