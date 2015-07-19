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


union() {
    Bumper_STL();
    
    attach(Bumper_Con_LeftMicroSwitch, DefConUp)
        MicroSwitch();
    attachWithOffset(Bumper_Con_RightMicroSwitch, DefConDown, [0, 0, 5.8])
        MicroSwitch();

	attachWithOffset(DefCon, DefCon, [0, 0, -6*layers])
		BumperStabiliserModel();
}


*MicroSwitchPlate();
*translate([dw + .5/2, 6.5, 0])
    translate([9.6, 1.25, 2])
        MicroSwitch();

*translate([0, 0, -6*layers])
	BumperStabiliserModel();

*pintack(side=true, h=7.8+2+2.5+6*layers, bh=2);

