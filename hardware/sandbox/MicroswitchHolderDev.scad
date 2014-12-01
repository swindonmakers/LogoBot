include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;
UseSTL = false;



//length = 12.9, width = 6.6, height = 5.8;

MicroSwitchHolder_STL();


// From MicroSwitch model
datxoffset = -9.6;
datyoffset = -1.25;
width = 6.6;

translate([-datxoffset + dw + (Bumper_Pin_Width + 1), datyoffset + width, dw])
mirror([0,1,0])
    MicroSwitch();