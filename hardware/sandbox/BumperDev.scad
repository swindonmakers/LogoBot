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
    
    attach(Bumper_Con_LeftMicroSwitch, DefConUp)
        MicroSwitch();
    attachWithOffset(Bumper_Con_RightMicroSwitch, DefConDown, [0, 0, 5.8])
        MicroSwitch();
}




*MicroSwitchPlate();
*translate([dw + .5/2, 6.5, 0])
    translate([9.6, 1.25, 2])
        MicroSwitch();
