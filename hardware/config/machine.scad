//
// Machine
//

// Coding-style
// ------------
//
// Global variables are written in UpperCamelCase.
// A logical hierarchy should be indicated using underscores, for example:
//     StepperMotor_Connections_Axle
//
// Global short-hand references should be kept to a minimum to avoid name-collisions


// Global Settings for Printed Parts
//

DefaultWall 	= 4*perim;
ThickWall 		= 8*perim;

// short-hand
dw 				= DefaultWall;
tw 				= ThickWall;


// Global design parameters
GroundClearance = 20;
PinDiameter = 7;

// Motor references
MotorOffsetX = -16;
MotorOffsetZ = 10;
MotorShaftDiameter = 5;
MotorShaftFlatThickness = 3;

// Wheels
//

WheelDiameter 	= 2*(GroundClearance + MotorOffsetZ);
WheelRadius 	= WheelDiameter / 2;
WheelThickness 	= 4;   // used to determine the size of slot in the base, clearance factor is added later


// Base
//

BaseDiameter 	= 140;
BaseThickness 	= dw;

// Shell
//
// Opening is calculated based on a maximal overhang of 60 degrees
// cos(60) is 0.5, so this is simply half the BaseDiameter
ShellOpeningDiameter = BaseDiameter * cos(60);  

// height above the datum
ShellOpeningHeight = BaseDiameter * sin(60)/2;  

// Pen
//
PenHoleDiameter = 25;

// Pen Lift
//
PenLiftPlateLength = 29;
PenLiftPlateHeight = 30;
PenLiftPenOffset = 5;
PenLiftHolderTolerance = .5;