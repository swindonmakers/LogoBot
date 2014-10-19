/*
	Vitamin: Breadboard
	Various common breadboard models
	
	
	
	Authors:
		Damian Axford
	
	Local Frame: 
		Bottom corner at the origin
	
	Parameters:
		BreadboardType - One of a set of Breadboard types
		
	Returns:
		A Breadboard model, colored
*/

// Breadboard Global Variables

BreadboardPinSpacing = 2.54;  // 0.1 inch pitch
BreadboardPinWidth   = 1;

// Breadboard types

Breadboard170 = [ 47, 35, 8.5, 17 ];

// Breadboard type getters

function Breadboard_Width(BreadboardType) = BreadboardType[0];
function Breadboard_Depth(BreadboardType) = BreadboardType[1];
function Breadboard_Height(BreadboardType) = BreadboardType[2];
function Breadboard_PinsWide(BreadboardType) = BreadboardType[3];


module Breadboard(BreadboardType = Breadboard170, ShowPins=true, BoardColor = "white") {
	
	w = Breadboard_Width(BreadboardType);
	d = Breadboard_Depth(BreadboardType);
	h = Breadboard_Height(BreadboardType);
	
	pinsWide = Breadboard_PinsWide(BreadboardType);
	
	ps = BreadboardPinSpacing;
	pw = BreadboardPinWidth;
	
	pox = (w - ((pinsWide-1) * ps))/2;
	poy = pox;
	
	// Base
	color(BoardColor)
		difference() {
			cube([w, d, h]);
			
			// mounting holes
			for (i=[-1,1])
				translate([w/2 + i * (w/2 - 4), d/2, -1])
				cylinder(r=4/2, h=h+2);
				
			// central recess
			translate([w/2, d/2, 2 + h/2])
				cube([w - 15, 4, h], center=true);
		}
		
	// Pins
	if (ShowPins)
		color("black")
		translate([0, 0, h-0.3])
		{
			// pins
			for (x=[0:pinsWide-1], y=[0:4], m=[-1,1])
				translate([pox + x * ps, d/2 + m * ( (3*2.54/2) + y * ps )])
				square([pw,pw], center=true);
		}	
}