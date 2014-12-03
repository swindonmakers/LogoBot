include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;
UseSTL = false;

showOtherParts = false;

if (showOtherParts) {
    translate([0,0,7]){ 
        LogoBotBase_STL();
        BasicShell_STL();
    }
}

// From MicroSwitch model
datxoffset = -9.6;
datyoffset = -1.25;


for (x=[0,1], y=[0,1])
    mirror([0, y, 0])
    mirror([x, 0, 0])
    translate([3,0,0]) // center on axis
    rotate([0, 0, 45])
    translate([0, BaseDiameter/2 - 5, dw])
        MicroSwitch();
        

for (i=[0,1])
mirror([0,i,0])
translate([0,0,0])
    Bumper_STL();

