include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;
UseSTL = false;


LogoBotBase_STL();
BasicShell_STL();

translate([0,0,-10])
    Bumper_STL();


