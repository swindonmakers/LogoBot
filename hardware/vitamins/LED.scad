/*
	Vitamin: LED
	Model of a 3mm LED.
	
	Authors:
		Robert Longbottom
	
	Local Frame: 
		Centred on the center of the base of the LED
	
	Parameters:
		None
		
	Returns:
		An LED, rendered
*/

module LED() {
	cylinder(r=3.75/2, h=1);
	cylinder(r=3/2, h=4);

	translate([0,0,4])
		sphere(r=3/2);
}
 