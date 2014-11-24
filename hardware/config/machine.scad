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


// Pen
//

PenHoleDiameter = 25;
