// test wrapper for the Breadboard vitamin

include <../config/config.scad>

include <../vitamins/Bolt.scad>
include <../vitamins/Breadboard.scad>


DebugCoordinateFrame = true;
DebugConnectors = true;

ScrewCon = [[0,0,0],[0,0,-1],0];

// Breadboard170
attach(
        [[20, 0, Breadboard_Height(Breadboard_170)],[0,0,-1], -90], 
        Breadboard_Con_BottomLeft(Breadboard_170)
    ) {
    Breadboard(Breadboard_170);
    
    // place a pin
    attach(Breadboard_Con_Pin(Breadboard_170, along=5, across=3), DefCon, Invert=true)
        cylinder(r=1/2, h=10);
    
    // put the screws in
    attach(Breadboard_Con_BottomLeft(Breadboard_170), ScrewCon)
        HexHeadScrew();

    attach(Breadboard_Con_BottomRight(Breadboard_170), ScrewCon)
        HexHeadScrew();
}

// Breadboard270
translate([Breadboard_Width(Breadboard_170) + 10, 0, 0]) {
	Breadboard(Breadboard_270, BoardColor = "red");
	
	// put the screws in
	for (i=[0:Breadboard_MountPoints(Breadboard_270)-1])
	    attach(Breadboard_Cons(Breadboard_270)[i], ScrewCon)
	    HexHeadScrew();
}
	
translate([0, Breadboard_Depth(Breadboard_270) + 10, 0])
	Breadboard(Breadboard_400, BoardColor = [0.3,1,0.3]);