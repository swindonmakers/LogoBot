// Simple test of the ULN2003DriverBoard

include <../config/config.scad>
include <../vitamins/LED.scad>

$fn=50;

DebugCoordinateFrames = true;
DebugConnectors = true;

LED_3mm();
translate([10,0,0])
    LED_5mm();
translate([20,0,0])
    LED_RGB_5mm();
    
translate([0,10,0])
    LED_3mm(legs=true);
translate([10,10,0])
    LED_5mm(legs=true);
translate([20,10,0])
    LED_RGB_5mm(legs=true);
    
translate([0,20,0])
    LED_3mm(legs=true, color="Green");
translate([10,20,0])
    LED_5mm(legs=true, color="Yellow");
translate([20,20,0])
    LED_5mm(legs=true, color="Blue");