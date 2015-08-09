/*
    Vitamin: Line Sensor

    Local Frame:
*/


// Connectors

LineSensor_Con_Def				= [ [14/2,0,1.5], [0,0,-1], 0, 0, 0];



module LineSensor() {

    vitamin("vitamins/LineSensor.scad", "Line Sensor", "LineSensor()") {
        view(t=[6.9, 13.6, 10.3], r=[72,0,33], d=280);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(LineSensor_Con_Def);
        }

        // parts
        LineSensor_Body();
    }
}

module LineSensor_Body() {
    w = 14;
    d = 32;
    t = 1.5;

    // pcb
    color([0.2,0.3,0.5])
        cube([w,d,t]);

    // pot
    color([0.3,0.5,1])
        translate([0,13,-5])
        cube([7,7,5]);

    // sensor
    translate([w/2 - 5, d-5.5, 5]) {
        // body
        color(Grey20)
            cube([10,5.5,4]);

        // led/diode
        for (i=[0,1])
            color(Grey50)
            translate([3 + i*4, 2.8, 4 + 0.4])
            sphere(r=3.4/2);


        // pins
        for (i=[0,1], j=[0,1])
            color(Grey80)
            translate([2 + i*6, 1.5 + j*2.5, -4])
            cylinder(r=0.8/2, h=5);
    }



    // pin Header - uses pin header from HCSR04 sensor vitamin
    // TODO: clean-up dependency!
    attach([[w/2 - 1.5*2.54, 1.25, 0], [0,0,1], 180,0,0], DefConDown)
        RightAnglePinHeader(4);
}
