include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=false;
DebugCoordinateFrames=false;
PinTack_STL(side=false, h=7, lh=2, bh=2);

translate([20,0,0])
    PinTack_STL(side=false, h=14.1, lh=2, bh=2);
