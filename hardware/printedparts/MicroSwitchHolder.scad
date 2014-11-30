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

module MircoSwitchHolderModel()
{
	cube([13 + 6, 20, 2]);

	translate([0,0,2-eta])
		cube([6, 20, 3+eta]);
	translate([13,0,2-eta])
		cube([6, 20, 3+eta]);

	translate([0,0,5-eta])
		cube([3, 6.6, 7+eta]);
	translate([16,0,5-eta])
		cube([3, 6.6, 7+eta]);

	translate([0,6.6,5-eta])
		cube([4, 3, 7+eta]);
	translate([15,6.6,5-eta])
		cube([4, 3, 7+eta]);
    
	translate([0, 15, 5-eta])
		cube([13 + 6, 5, 3+eta]);
}