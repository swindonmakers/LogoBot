include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;
UseSTL = false;



//length = 12.9, width = 6.6, height = 5.8;

MicroSwitchHolder_STL();


translate([12.7, 5.3, 3 + 3])
mirror([0,1,0])
    MicroSwitch();