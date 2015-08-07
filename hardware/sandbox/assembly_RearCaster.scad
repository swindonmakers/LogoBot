include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=true;
DebugCoordinateFrames=true;
MarbleCasterAssembly();

translate([0,0,dw])
mirror([0,0,1])
PinTack_STL(h=7);