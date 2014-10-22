// Simple test of the ULN2003DriverBoard

include <../config/config.scad>
include <../vitamins/LED.scad>
include <../vitamins/ULN2003DriverBoard.scad>

$fn=50;

DebugCoordinateFrames = true;
DebugConnectors = true;

ULN2003DriverBoard();