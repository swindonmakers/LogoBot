include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;
UseSTL = false;

showOtherParts = true;

if (showOtherParts) {
LogoBotBase_STL();
BasicShell_STL();
}

// From MicroSwitch model
datxoffset = -9.6;
datyoffset = -1.25;
width = 6.6;

attach(DefConUp, DefConUp, ExplodeSpacing=20)
    for (x=[0,1], y=[0,1])
        mirror([0,y,0])
        mirror([x,0,0])
        translate([(BaseDiameter/2-10) * cos(45), (BaseDiameter/2-10) * sin(45), -17 ])
        rotate([0,0,-45])
        translate([12.7,8,8]) {
            rotate(a=180, v=[0,0,1]) {
                MicroSwitchHolder_STL();

                translate([-datxoffset + dw + (Bumper_Pin_Width + 1), datyoffset + width, dw])
                mirror([0,1,0])
                    MicroSwitch();
            }
        }

for (i=[0,1])
mirror([0,i,0])
translate([0,0,-7])
    Bumper_STL();

