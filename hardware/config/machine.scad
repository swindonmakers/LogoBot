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



// Wheels
//

WheelDiameter 	= 80;
WheelRadius 	= WheelDiameter / 2;
WheelThickness 	= dw;


// Base
//

BaseDiameter 	= 140;
BaseThickness 	= dw;


// Pen
//

PenHoleDiameter = 12;