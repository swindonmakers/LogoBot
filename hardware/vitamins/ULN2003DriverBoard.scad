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

module ULN2003DriverBoard() {
	h=35;
	w=30;
	pcb_thickness=1.5;
	hole_dia=3;
	hole_inset=2.5;
	 
	// offset origin to bottom left
	translate([(w/2)-hole_inset, (h/2)-hole_inset, 0])
	{
		// Base PCB
		linear_extrude(pcb_thickness)
			difference() {
				square([w,h], center=true);
	
				// Mounting holes
				for (i=[0:1], j=[0:1])
					mirror([i,0,0])
					mirror([0,j,0])
					translate([w/2-hole_inset,h/2-hole_inset,0])
						circle(r=hole_dia/2);
			}
	 
		// Move us to the bottom left of the PCB
		translate([-w/2,-h/2,0]) {
	
			// ULN2003 chip
			color("darkgrey")
			translate([1,8,pcb_thickness-eta])
				cube([20,10,8]);
	
			// Arduino header
			color("darkgrey")
			translate([5,4.5,pcb_thickness-eta])
				cube([10,3,15]);
	
			// Stepper Connection
			color("white")
			translate([1.5,19,pcb_thickness-eta])
				difference() {
					cube([15.5,6,8]);
					translate([1,1,1])
						cube([13.5,4,8]);
				}
	
	
			// Power & On/Off Jumper
			color("darkgrey")
			translate([23,8,pcb_thickness-eta])
				cube([3,10,15]);
	
	
			// LEDS
			color("red")
			{
				translate([6,29,pcb_thickness-eta])
					LED();
				translate([10,29,pcb_thickness-eta])
					LED();
				translate([14.5,29,pcb_thickness-eta])
					LED();
				translate([19,29,pcb_thickness-eta])
					LED();
			}
		}
	}
}

 