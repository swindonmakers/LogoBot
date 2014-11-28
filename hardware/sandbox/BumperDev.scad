include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;
UseSTL = false;

restOfModel = true;

if (restOfModel) {
LogoBotBase_STL();
BasicShell_STL();

attach(DefConUp, DefConUp, ExplodeSpacing=20)
    for (x=[0,1], y=[0,1])
        mirror([0,y,0])
        mirror([x,0,0])
        translate([(BaseDiameter/2-10) * cos(45), (BaseDiameter/2-10) * sin(45), -8 ])
        rotate([0,0,-45])
            MicroSwitch();
}

for (i=[0,1])
mirror([0,i,0])
translate([0,0,-10])
    Bumper_STL();


