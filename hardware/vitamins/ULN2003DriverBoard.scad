/*
	Vitamin: ULN2003DriverBoard
	Model of a stepper driver board.
	Based on http://42bots.com/tutorials/28byj-48-stepper-motor-with-uln2003-driver-and-arduino-uno/
	
	Authors:
		Robert Longbottom
	
	Local Frame: 
		Centred on the bottom left mounting hole
	
	Parameters:
		None
		
	Returns:
		A Stepper Driver Board, rendered and colored
*/

ULN2003Driver_BoardHeight = 35;
ULN2003Driver_BoardWidth = 30;
ULN2003Driver_PCBThickness = 1.5;
ULN2003Driver_HoleDia = 3;
ULN2003Driver_HoleInset = 2.5;

// Connectors
ULN2003DriverBoard_Con_LowerLeft	= [ [0, 0, 0], [0, 0, 1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];
ULN2003DriverBoard_Con_LowerRight	= [ [ULN2003Driver_BoardWidth - 2 * ULN2003Driver_HoleInset, 0, 0], [0, 0, 1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];
ULN2003DriverBoard_Con_UpperLeft	= [ [0, ULN2003Driver_BoardHeight - 2 * ULN2003Driver_HoleInset, 0], [0, 0, 1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];
ULN2003DriverBoard_Con_UpperRight	= [ [ULN2003Driver_BoardWidth - 2 * ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight - 2 * ULN2003Driver_HoleInset, 0], [0, 0, 1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];

module ULN2003DriverBoard() {

	if (DebugCoordinateFrames) {
		frame();
	}
	
	if (DebugConnectors) {
		connector(ULN2003DriverBoard_Con_LowerLeft);
		connector(ULN2003DriverBoard_Con_LowerRight);
		connector(ULN2003DriverBoard_Con_UpperLeft);
		connector(ULN2003DriverBoard_Con_UpperRight);
	} 

	// offset origin to bottom left
	translate([(ULN2003Driver_BoardWidth / 2) - ULN2003Driver_HoleInset, (ULN2003Driver_BoardHeight / 2) - ULN2003Driver_HoleInset, 0])
	{
		// Base PCB
		linear_extrude(ULN2003Driver_PCBThickness)
			difference() {
				square([ULN2003Driver_BoardWidth, ULN2003Driver_BoardHeight], center=true);
	
				// Mounting holes
				for (i = [0:1], j = [0:1])
					mirror([i, 0, 0])
					mirror([0, j, 0])
					translate([ULN2003Driver_BoardWidth / 2 - ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight / 2 - ULN2003Driver_HoleInset, 0])
						circle(r = ULN2003Driver_HoleDia / 2);
			}
	 
		// Move us to the bottom left of the PCB
		translate([-ULN2003Driver_BoardWidth / 2, -ULN2003Driver_BoardHeight / 2, 0]) {
	
			// ULN2003 chip
			color("darkgrey")
			translate([1, 8, ULN2003Driver_PCBThickness - eta])
				cube([20, 10, 8]);
	
			// Arduino header
			color("darkgrey")
			translate([5, 4.5, ULN2003Driver_PCBThickness - eta])
				cube([10, 3, 15]);
	
			// Stepper Connection
			color("white")
			translate([1.5, 19, ULN2003Driver_PCBThickness - eta])
				difference() {
					cube([15.5, 6, 8]);
					translate([1, 1, 1])
						cube([13.5, 4, 8]);
				}
	
			// Power & On/Off Jumper
			color("darkgrey")
			translate([23, 8, ULN2003Driver_PCBThickness - eta])
				cube([3, 10, 15]);
	
			// LEDS
			color("red")
			{
				translate([6, 29, ULN2003Driver_PCBThickness - eta])
					LED();
				translate([10, 29, ULN2003Driver_PCBThickness - eta])
					LED();
				translate([14.5, 29, ULN2003Driver_PCBThickness - eta])
					LED();
				translate([19, 29, ULN2003Driver_PCBThickness - eta])
					LED();
			}
		}
	}
}
