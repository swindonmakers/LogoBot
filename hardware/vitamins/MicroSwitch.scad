// MicroSwitch v1.0 by Gyrobot
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
// ms_length           = Length of body in X.
// ms_width            = Width of body in Y.
// ms_height           = Height (thickness) of body in Z.
// ms_datxoffset       = X Position of lower left corner of body from Datum hole.
// ms_datyoffset       = Y Position of lower left corner of body from Datum hole.
// ms_orientation      = Defines whether the switch is mounted left or right (0:1).
// ms_hole_diam        = Size of Datum mounting hole and slot width of second hole.
// ms_xholepitch       = Mounting hole X pitch.
// ms_yholepitch       = Mounting hole Y pitch.
// ms_hole_slot_length = Slot length of second mounting hole.
// ms_lever_length     = Length of lever.
// ms_lever_width      = Width of lever.
// ms_lever_thickness  = Thickness of lever.
// ms_lever_height     = Height of lever (OP) from Datum hole.
// ms_tab_length       = Length of terminal tab from Datum hole.
// ms_tab_width        = Width of terminal tab.
// ms_tab_thickness    = Thickness of terminal tab.
// ms_tab_hole_diam    = Diameter of terminal tab hole.
//

module microswitch(ms_length = 19.8, ms_width = 10.2, ms_height = 6.4, ms_datxoffset = -14.6, ms_datyoffset = -2.5, ms_orientation = 0, ms_hole_diam = 2.35, ms_xholepitch = 9.5, ms_yholepitch = 0, ms_hole_slot_length = 0.15, ms_lever_length = 14.5, ms_lever_width = 3.6, ms_lever_thickness = 0.3, ms_lever_height = 8.8, ms_tab_length = 6.4, ms_tab_width = 3.2, ms_tab_thickness = 0.3, ms_tab_hole_diam = 1.6){

	cutout_offset = 0.7;
	foot_offset = ms_datyoffset - 0.4;

	mirror ([ms_orientation, 0, 0]){
		// Mirror to provide a left or right mounted switch.
		//
		translate ([ms_datxoffset, ms_datyoffset, ms_height / 2]){
			//Move datum position.
			//
			color("DarkSlateGray")
			linear_extrude(ms_height, center=true){
				//
				// Body
				//
				difference(){
					union(){
						//Add all Additive profiles together, place any extras here.
						//
						square ([ms_length, ms_width]); //Main body cuboid.
						translate ([-ms_datxoffset, -ms_datyoffset])
							square ([ms_hole_diam, foot_offset * -2], center=true);
						translate ([-ms_datxoffset - ms_xholepitch - ms_hole_slot_length / 2, -ms_datyoffset + ms_yholepitch])
							square ([ms_hole_diam, foot_offset * -2], center=true);
									
					}
					union(){
						//Add all Subtractive profiles together, place any extras here.
						//
						translate ([ms_length / 2, ms_width - cutout_offset]) // Move corner cutout.
							square ([ms_length, ms_width]); // Corner cutout.
						translate ([-ms_datxoffset, -ms_datyoffset]) // Move datum hole.
							circle (d = ms_hole_diam, $fn = 32); // Remove datum hole.
						translate ([-ms_datxoffset - ms_xholepitch - ms_hole_slot_length / 2, -ms_datyoffset + ms_yholepitch]){ // Move second mounting hole (slot)
							// Second mounting hole (slot)
							hull(){
								circle (d = ms_hole_diam, $fn = 32);
								translate ([ms_hole_slot_length, 0]) // Move circle to create slot.
									circle (d = ms_hole_diam, $fn = 32);
							}
						}
					}
				}
			}
			color("Silver")
			linear_extrude(ms_lever_width, center=true){
				//
				// Lever
				//
				translate([2.5 ,+ ms_lever_height - ms_datyoffset,0]) // Move lever to position
					mirror([0, 1, 0]) // Mirror lever to invert shape
						union (){
							//Add all Additive profiles together, place any extras here.
							//
							square ([ms_lever_length + 2.5 , ms_lever_thickness]);
							square ([ms_lever_thickness,ms_width / 2]);
						}
			}
			for ( x = [1.6, 10.4, 17.7]){
				color ("Silver")
				translate ([x, -ms_tab_length - ms_datyoffset, 0])
					terminal(ms_tab_length, ms_tab_width, ms_tab_thickness, ms_tab_hole_diam);
			}
		}
	}
}

//
// Terminal module for solder pad. Other terminal types are available. 
//

module terminal (ms_tab_length, ms_tab_width, ms_tab_thickness, ms_tab_hole_diam){
	rotate ([0,90,0]){
		translate ([ms_tab_width / -2,0,0]) {
			linear_extrude(ms_tab_thickness, center=true){
				difference (){
					square ([ms_tab_width , ms_tab_length]);
					translate ([ms_tab_width / 2, ms_tab_width / 2, 0])
						circle (d = ms_tab_hole_diam, $fn = 32);
				}
			}
		}
	}
}
