// Connectors

LineSensorHolder_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module LineSensorHolder_STL() {

    printedPart("printedparts/LineSensorHolder.scad", "Line Sensor Holder", "LineSensorHolder_STL()") {

        markdown("guide","No support required, pin hole may need to be reamed to 7mm");

        view(t=[0,0,0],r=[72,0,130],d=140);

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
        hull() {
            // surrounds for sensors
            for (i=[0,1])
                mirror([i,0,0])
                translate([5,-4.5,-GroundClearance+2])
                cube([14,9,10]);

            // walls
            *for (i=[0,1])
                mirror([i,0,0])
                translate([3,-5,-GroundClearance+2])
                cube([dw,10,GroundClearance-2]);

            // pin plate
            translate([-5,-6,-2])
                cube([10, 12, 2]);
        }

        // hollow for Pin
        translate([0,0,-5])
            rotate([0,0,90])
            scale(1.05)  // make it an easy fit
            pinhole(h=10, r=PinDiameter/2, lh=3, lt=1, t=0.3, tight=true, fixed=true);

        // hollow between sensors
        translate([-3, -50, -GroundClearance])
            cube([6, 100, GroundClearance-2]);

        // hollow for sensors
        for (i=[0,1])
            mirror([i,0,0])
            translate([6.2,-3.5,-GroundClearance-1])
            cube([11,6.5,20]);

        // hollow for sensor pcbs
        for (i=[0,1])
            mirror([i,0,0])
            translate([5,-50,-8])
            cube([20,100,20]);
    }
}
