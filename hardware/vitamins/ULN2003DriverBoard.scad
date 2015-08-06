/*
	Vitamin: ULN2003DriverBoard
	Model of a stepper driver board.
	Based on http://42bots.com/tutorials/28byj-48-stepper-motor-with-uln2003-driver-and-arduino-uno/

	Local Frame:
		Centred on the bottom left mounting hole
*/

ULN2003Driver_BoardHeight = 35.5;
ULN2003Driver_BoardWidth = 32.5;
ULN2003Driver_PCBThickness = 1.7;
ULN2003Driver_HoleDia = 3;
ULN2003Driver_HoleInset = 2.5;

// Connectors
ULN2003DriverBoard_Con_LowerLeft	= [ [0, 0, 0], [0, 0, -1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];
ULN2003DriverBoard_Con_LowerRight	= [ [ULN2003Driver_BoardWidth - 2 * ULN2003Driver_HoleInset, 0, 0], [0, 0, -1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];
ULN2003DriverBoard_Con_UpperLeft	= [ [0, ULN2003Driver_BoardHeight - 2 * ULN2003Driver_HoleInset, 0], [0, 0, -1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];
ULN2003DriverBoard_Con_UpperRight	= [ [ULN2003Driver_BoardWidth - 2 * ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight - 2 * ULN2003Driver_HoleInset, 0], [0, 0, -1], 0, ULN2003Driver_PCBThickness, ULN2003Driver_HoleDia];

ULN2003DriverBoard_Con_Stepper		= [ [4 - ULN2003Driver_HoleInset, 22 - ULN2003Driver_HoleInset, ULN2003Driver_PCBThickness + 2.25], [0, 0, -1], 0, 0 ];
ULN2003DriverBoard_Con_Arduino		= [ [6 - ULN2003Driver_HoleInset, 6 - ULN2003Driver_HoleInset, ULN2003Driver_PCBThickness + 2.25], [0, 0, -1], 180, 0 ];
ULN2003DriverBoard_Con_Power		= [ [24.5 - ULN2003Driver_HoleInset, 9 - ULN2003Driver_HoleInset, ULN2003Driver_PCBThickness + 2.25], [0, 0, -1], 90, 0 ];

ULN2003DriverBoard_Cons = [
	ULN2003DriverBoard_Con_LowerLeft,
	ULN2003DriverBoard_Con_LowerRight,
	ULN2003DriverBoard_Con_UpperLeft,
	ULN2003DriverBoard_Con_UpperRight,
	ULN2003DriverBoard_Con_Stepper,
	ULN2003DriverBoard_Con_Arduino,
	ULN2003DriverBoard_Con_Power
];



module ULN2003DriverBoard_PCB(includeFixings=true, thickness=ULN2003Driver_PCBThickness) {
	// Base PCB
	// offset origin to bottom left
	color([0.2,0.6,0.3])
	translate([(ULN2003Driver_BoardWidth / 2) - ULN2003Driver_HoleInset, (ULN2003Driver_BoardHeight / 2) - ULN2003Driver_HoleInset, 0])
		linear_extrude(thickness)
		difference() {
			square([ULN2003Driver_BoardWidth, ULN2003Driver_BoardHeight], center=true);

			// Mounting holes
			if (includeFixings)
				for (i = [0:1], j = [0:1])
				mirror([i, 0, 0])
				mirror([0, j, 0])
				translate([ULN2003Driver_BoardWidth / 2 - ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight / 2 - ULN2003Driver_HoleInset, 0])
					circle(r = ULN2003Driver_HoleDia / 2);
		}
}


module ULN2003DriverBoard() {

	if (DebugCoordinateFrames) frame();

	if (DebugConnectors)
		for (c = ULN2003DriverBoard_Cons)
			connector(c);

	vitamin(
		"vitamins/ULN2003DriverBoard.scad",
		str("ULN2003 Driver Board"),
		str("ULN2003DriverBoard()")
	) {
		view(d=140);

		ULN2003DriverBoard_PCB();

		// everything else
		translate([(ULN2003Driver_BoardWidth / 2) - ULN2003Driver_HoleInset, (ULN2003Driver_BoardHeight / 2) - ULN2003Driver_HoleInset, 0])
		{
			// Move us to the bottom left of the PCB
			translate([-ULN2003Driver_BoardWidth / 2, -ULN2003Driver_BoardHeight / 2, 0]) {

				// ULN2003 chip
				color("darkgrey")
				translate([1, 8, ULN2003Driver_PCBThickness - eta])
					cube([20, 10, 8]);

				// Arduino header
				translate([6, 6, ULN2003Driver_PCBThickness - eta])
					PcbPinStrip(4);

				// Stepper Connection
				color("white")
				translate([1.5, 19, ULN2003Driver_PCBThickness - eta])
					difference() {
						cube([15.5, 6, 8]);
						translate([1, 1, 1])
							cube([13.5, 4, 8]);
					}
				translate([4, 22, ULN2003Driver_PCBThickness - eta])
					PcbPinStrip(5, 0, false);

				// Power & On/Off Jumper
				translate([24.5, 9, ULN2003Driver_PCBThickness - eta])
					PcbPinStrip(4, 90);

				// LEDS
				translate([6, 29, ULN2003Driver_PCBThickness - eta])
					LED_3mm();
				translate([10, 29, ULN2003Driver_PCBThickness - eta])
					LED_3mm();
				translate([14.5, 29, ULN2003Driver_PCBThickness - eta])
					LED_3mm();
				translate([19, 29, ULN2003Driver_PCBThickness - eta])
					LED_3mm();
			}
		}
	}
}

module PcbPinStrip(numPins = 4, a = 0, spacers = true)
{
    // Standard PCB header pin
    pcbholepitch        = 2.54;         // spacing of PCB holes
    holediameter        = 1.25;         // diameter of PCB hole
    pinheight           =   11;         // length of PCB pins
    pinoffset           =    3;         // offset of PCB pins
    pinwidth            = 0.63;         // width/gauge of PCB pins
    spacerwidth         = 2.25;         // height of breakaway pin frame
    spacerheight        = 2.25;         // height of breakaway pin frame

	rotate(a = a)
	for (i = [0 : numPins - 1]) {
		translate([i * pcbholepitch, 0, 0]) {
			// Header Pins
			color("white")
			translate([0, 0, -pinoffset])
			linear_extrude(pinheight)
				square(pinwidth, center = true);

			if (spacers) {
				// Pin Spacers
				color(Grey20)
				linear_extrude(spacerheight)
					square(spacerwidth, center = true);

				// Break-Away Material
				color(Grey20)
				translate([pcbholepitch/2, 0, 0])
				linear_extrude(spacerheight)
					square([pcbholepitch - spacerwidth, spacerwidth * 0.85], center = true);
			}
		}
	}
}
