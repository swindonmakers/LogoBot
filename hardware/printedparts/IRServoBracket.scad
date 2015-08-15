IRServoBracket_Con_Left = [[-20, 0, 2], [0, 0, 1], 0, 0, 0];
IRServoBracket_Con_Right = [[20, 0, 2], [0, 0, 1], 0, 0, 0];

module IRServoBracket_STL() {

    printedPart("printedparts/IRServoBracket.scad", "IR Servo Bracket", "IRServoBracket_STL()") {

        view(t=[0,0,0], r=[160,295,180], d=150);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
			connector(IRServoBracket_Con_Left);
			connector(IRServoBracket_Con_Right);
		}

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "IRServoBracket.stl"));
            } else {
                IRServoBracket_Model();
            }
        }
    }
}


module IRServoBracket_Model()
{
	// Base
	linear_extrude(2)
	difference() {
		chamferedSquare([52, 12], 3, center=true);

		// pin holes
		for (i=[0, 1])
		mirror([i, 0, 0])
		translate([20, 0, 0])
			circle(d=7);
	}

	// Sides
	for (i=[0, 1])
	mirror([i, 0, 0])
	translate([6.25, 0, 44/2])
	rotate([0, 90, 0])
	linear_extrude(2) {
		square([44, 12], center=true);
		translate([-13, 10, 0])
			square([18, 15], center=true);
	}

	// Servo base support
	translate([0, 5.75, 26])
	linear_extrude(2)
		square([12.5, 12 + 11.5], center=true);
}
