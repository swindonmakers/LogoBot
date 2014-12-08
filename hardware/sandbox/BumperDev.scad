include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;
UseSTL = false;

showOtherParts = false;

if (showOtherParts) {
    translate([0,0,8]){ 
        LogoBotBase_STL();
        BasicShell_STL();
    }
}


for (i=[0,1])
rotate([0, 0, i*180])
{
    Bumper_STL();
	
    for(i=[0,1])
    mirror([i, 0, 0])
    rotate([0, 0, 43.5])
    translate([-10, BaseDiameter/2 - 21, 0])
    translate([dw + .5/2, 11.5, 0])
        MicroSwitchAtOrigin();
}




*MicroSwitchPlate();
*translate([dw + .5/2, 10, 0])
    MicroSwitchAtOrigin();


module MicroSwitchAtOrigin()
{
    translate([9.6, 1.25, 2])
        MicroSwitch();
}