//
// LogoBot Assembly
//

// LogoBot Orientation
// -----------
// Centred at the origin
// Width is along the x-axis
// Depth is along the y-axis
// Front is towards y+


module LogoBotAssembly() {
	
	// Base
	// TODO: needs to be translated up to correct height
	translate([0, 0, 0])
		LogoBotBase_stl();
	
	// Bumper assembly
	
	// Motor + Wheel assembly
	
	// Battery assembly
	
	// Shell
	
	// etc
	
}


// The _stl suffix denotes this is a printable part, 
// and is used by the bulk STL generating program

module LogoBotBase_stl() {
	// Base lies on XY plane, centered on origin - ready for printing!
	// Front of robot is towards y+
	
	// Color it as a printed plastic part
	color(PlasticColor)
		// Pre-render to speed editing and avoid overloading the cache
		render()
		// Extrude to correct thickness
		linear_extrude(BaseThickness)
		difference() {
			// Union together all the bits to make the plate
			union() {
				// Base plate
				circle(r=BaseDiameter/2);
			}
			
			// Now punch some holes...
		
			// Centre hole for pen
			circle(r=PenHoleDiameter/2);
	
			// Chevron at the front so we're clear where the front is!
			translate([0, BaseDiameter/2 - 10, 0])
				Chevron(width=10, height=6, thickness=3);
	
		}
}