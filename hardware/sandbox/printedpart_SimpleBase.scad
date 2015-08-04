include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=true;
DebugCoordinateFrames=true;
SimpleBase_STL();

translate([0,0,-5]) 
    color("red")
    LogoBotBase_STL();
