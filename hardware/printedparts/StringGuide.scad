// Connectors

StringGuide_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module StringGuide_STL() {

    printedPart("printedparts/StringGuide.scad", "String Guide", "StringGuide_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(StringGuide_Con_Def);
        }

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "StringGuide.stl"));
            } else {
                StringGuide_Model();
            }
        }
    }
}


module StringGuide_Model()
{
    // local vars
    w = 10;
    d = 10;
    t1 = 8;
    t2 = t1 + dw;

    // model
    difference() {
        union() {
            // body
            translate([-w/2, -d/2, 0])
                roundedCube([w,d,t2], dw);

            // fixing tab
            translate([-w/2, -d/2, 0])
                roundedCube([w,d + 8,dw], 3);

        }

        // notch for String
        translate([0,0,t1 + 1]) {
            rotate([90,0,0])
                cylinder(r=2/1, h=100,center=true);

            translate([0,0,2])
                cube([4,100,4], center=true);
        }

        // fixing
        translate([0,d/2 + 4,0])
            cylinder(r=4/2, h=100, center=true);
    }
}
