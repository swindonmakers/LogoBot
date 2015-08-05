/*

    Vitamin: HC-SR04 Ultrasonic Sensor
    Based on cheap chinese version of the same

    Authors:
        Damian Axford

    Local Frame:
        bottom left corner of the pcb

*/


// Connectors
HCSR04UltrasonicSensor_Con_VCC = [[44.5/2 - 1.5*2.54, 0, -4.3], [0,-1,0], 0,0,0];
HCSR04UltrasonicSensor_Con_GND = [[44.5/2 + 1.5*2.54, 0, -4.3], [0,-1,0], 0,0,0];


module RightAnglePinHeader(pins) {
    // width along x+
    // pins point along y+
    // plastic base sits on XY plane at z=0
    // origin is first pin
    // Designed for use with DefConDown

    pitch = 2.54;
    pinw = 0.6;

    for (i=[0:pins-1]) {
        // plastic
        color(Grey20)
            translate([-pitch/2 + i*pitch, -pitch/2, 0])
            chamferedCube([pitch,pitch,pitch], 0.5);


        // pins
        color(Grey80)
            translate([-pinw/2 + i*pitch, -pinw/2, 0])
            {
                // upright
                translate([0,0,-3])
                    cube([pinw,pinw,7]);

                // angle
                translate([0,0,4])
                    cube([pinw,8,pinw]);
            }

    }

}

module HCSR04UltrasonicSensor() {
    w = 44.5;
    d = 20;
    t = 1.3;

    vitamin("vitamins/HCSR04UltrasonicSensor.scad", "HCSR04 Ultrasonic Sensor", "HCSR04UltrasonicSensor()") {
        view(t=[23,9,3],r=[34,2,22],d=320);
    }

    if (DebugCoordinateFrames) frame();
    if (DebugConnectors) {
        connector(HCSR04UltrasonicSensor_Con_VCC);
        connector(HCSR04UltrasonicSensor_Con_GND);
    }

    // PCB
    color([0.1,0.4,0.6])
        cube([w,d,t]);

    // Ultrasonic transducers
    translate([w/2,d/2, t])
        for (i=[0:1])
        mirror([i,0,0])
        translate([26/2,0,0]) {
            color([0.8,0.8,0.8])
                tube(16/2, 14/2, 12, center=false);
            color([0.8,0.8,0.8])
                cylinder(r=15/2, h=1);
            color([1,1,1])
                cylinder(r=9/2, h=2);

            translate([0,0, 10.5])
                color([0,0,0,0.4])
                cylinder(r=14/2, h=1);


        }

    // Header pins
    attach([[w/2 - 1.5*2.54, 1.25, 0], [0,0,1], 180,0,0], DefConDown)
        RightAnglePinHeader(4);


}
