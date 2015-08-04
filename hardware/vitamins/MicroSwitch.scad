// MicroSwitch v1.1 by Gyrobot
// http://www.gyrobot.co.uk
//
// Default values based upon :
// Farnell P/N : 2352329
// Omron Electronic Components P/N : SS-01GLT
//
// Datum X is centre of mounting hole with X pointing away from mounting slot.
// Datum Y is pointing away from terminals towards the lever.
// Datum Z is in on base of model.
//
// Parameters :
//
// length           = Length of body in X.
// width            = Width of body in Y.
// height           = Height (thickness) of body in Z.
// datxoffset       = X Position of lower left corner of body from Datum hole.
// datyoffset       = Y Position of lower left corner of body from Datum hole.
// orientation      = Defines whether the switch is mounted left or right (0:1).
// holedia        = Size of Datum mounting hole and slot width of second hole.
// xholepitch       = Mounting hole X pitch.
// yholepitch       = Mounting hole Y pitch.
// hole_slot_length = Slot length of second mounting hole.
// lever_length     = Length of lever.
// lever_width      = Width of lever.
// lever_thickness  = Thickness of lever.
// lever_height     = Height of lever (OP) from Datum hole.
// tab_length       = Length of terminal tab from Datum hole.
// tab_width        = Width of terminal tab.
// tab_thickness    = Thickness of terminal tab.
// tab_holedia    = Diameter of terminal tab hole.
//

module MicroSwitch(length = 12.9, width = 6.6, height = 5.8, datxoffset = -9.6, datyoffset = -1.25, orientation = 0, holedia = 2, xholepitch = 6.2, yholepitch = 0, hole_slot_length = 0, lever_length = 12, lever_width = 4, lever_thickness = 0.3, lever_height = 6.6, tab_length = 4.5, tab_width = 0.5, tab_thickness = 0.5, tab_holedia = 0){

	cutout_offset = 0;
	foot_offset = datyoffset - 0.4;

	vitamin(
		"vitamins/MicroSwitch.scad",
		str("MicroSwitch"),
		str("MicroSwitch()")
	) {
		view(d=140);
	}

	mirror ([orientation, 0, 0]){
		// Mirror to provide a left or right mounted switch.
		//
		translate ([datxoffset, datyoffset, height / 2]){
			//Move datum position.
			//
			color("DarkSlateGray")
			linear_extrude(height, center=true){
				// Body
				//
				difference(){
					union(){
						//Add all Additive profiles together, place any extras here.
						//
						square ([length, width]); //Main body cuboid.
						translate ([-datxoffset, -datyoffset])
						square ([holedia, foot_offset * -2], center=true);
						translate ([-datxoffset - xholepitch - hole_slot_length / 2, -datyoffset + yholepitch])
						square ([holedia, foot_offset * -2], center=true);

					}
					union(){
						//Add all Subtractive profiles together, place any extras here.
						//
						translate ([length / 2, width - cutout_offset]) // Move corner cutout.
						square ([length, width]); // Corner cutout.
						translate ([-datxoffset, -datyoffset]) // Move datum hole.
						circle (d = holedia); // Remove datum hole.
						translate ([-datxoffset - xholepitch - hole_slot_length / 2, -datyoffset + yholepitch]){ // Move second mounting hole (slot)
							// Second mounting hole (slot)
							//
							hull(){
								circle (d = holedia);
								translate ([hole_slot_length, 0]) // Move circle to create slot.
								circle (d = holedia);
							}
						}
					}
				}
			}
			color("Silver")
			linear_extrude(lever_width, center=true){
				// Lever
				//
				translate([1 ,+ lever_height - datyoffset,0]) // Move lever to position
				mirror([0, 1, 0]) // Mirror lever to invert shape
				union (){
					//Add all Additive profiles together, place any extras here.
					//
					square ([lever_length + 2.5 , lever_thickness]);
					square ([lever_thickness,width / 2]);
				}
			}
			for ( x = [1.6, 6.3, 11.4]){
				color ("Silver")
				translate ([x, -tab_length - datyoffset, 0])
				terminal(tab_length, tab_width, tab_thickness, tab_holedia);
			}
		}
	}
}
//
// Terminal module for solder pad. Other terminal types are available.
//
module terminal (tab_length, tab_width, tab_thickness, tab_holedia){
	rotate ([0,90,0]){
		translate ([tab_width / -2,0,0]) {
			linear_extrude(tab_thickness, center=true){
				difference (){
					square ([tab_width , tab_length]);
					translate ([tab_width / 2, tab_width / 2, 0])
					circle (d = tab_holedia);
				}
			}
		}
	}
}
