/*

LogoBot.scad

*/

// Master include statement, causes everything else for the model to be included
include <config/config.scad>


EnclosureWidth 		= 500;
EnclosureDepth 		= 500;
EnclosureThickness 	= 1;
EnclosureWallHeight = 30;
EnclosureWallWidth 	= 10;

BotPosition 		= [50, 30];
BotRotation 		= 30;



// Enclosure / Pen
// ---------------

// Pen
//
module EnclosureBase() {

	// base
	color(White)
		translate([0,0, EnclosureThickness/2])
		cube([EnclosureWidth, EnclosureDepth, EnclosureThickness], center=true);
	
	// walls
	color(Grey50) 
		translate([0,0, EnclosureThickness])
		linear_extrude(EnclosureWallHeight - EnclosureThickness)
		difference() {
			// outer-edge of wall
			square([EnclosureWidth, EnclosureDepth], center=true);
			
			// hollow out the inside
			square([EnclosureWidth - 2*EnclosureWallWidth, EnclosureDepth - 2*EnclosureWallWidth], center=true);
		}

}




// Draw the enclosure
EnclosureBase();


// Position LogoBot inside it
translate([ BotPosition[0], BotPosition[1], EnclosureThickness])
	rotate(BotRotation)
	LogoBotAssembly();