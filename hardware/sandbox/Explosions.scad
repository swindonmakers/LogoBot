// test wrapper for the Breadboard vitamin

include <../config/config.scad>


DebugCoordinateFrame = false;
DebugConnectors = false;

ScrewCon = [[0,0,0],[0,0,-1],0];

// Breadboard170
attach(
        [[20, 0, Breadboard_Height(Breadboard_170)],[0,0,-1], -90], 
        Breadboard_Con_BottomLeft(Breadboard_170)
    ) {
    Breadboard(Breadboard_170);
    
    // put the screws in
    attach(Breadboard_Con_BottomLeft(Breadboard_170), ScrewCon)
        Bolt(M3Cap);

    attach(Breadboard_Con_BottomRight(Breadboard_170), ScrewCon)
        Bolt(M3Cap);
}