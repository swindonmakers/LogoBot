// Connectors

LineSensorHolder_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module LineSensorHolder_STL() {

    printedPart("printedparts/LineSensorHolder.scad", "Line Sensor Holder", "LineSensorHolder_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(LineSensorHolder_Con_Def);
        }

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "LineSensorHolder.stl"));
            } else {
                LineSensorHolder_Model();
            }
        }
    }
}


module LineSensorHolder_Model()
{
    // local vars

    // model
    difference() {
        union() {
            // surrounds for sensors
            for (i=[0,1])
                mirror([i,0,0])
                translate([4,-5,-GroundClearance+2])
                cube([15,10,10]);

            // walls
            for (i=[0,1])
                mirror([i,0,0])
                translate([3,-5,-GroundClearance+2])
                cube([dw,10,GroundClearance-2]);

            // pin plate
            translate([-5,-5,-2])
                cube([10, 10, 2]);
        }

        // hollow for Pin
        cylinder(r=PinDiameter/2, h=20, center=true);

        // hollow for sensors
        for (i=[0,1])
            mirror([i,0,0])
            translate([6.2,-3.5,-GroundClearance-1])
            cube([11,6.5,14]);
    }
}
