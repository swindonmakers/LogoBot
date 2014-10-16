//
// Chevron
//
// Utility module for making 2D chevrons


// Chevron
// -------
// Width is along x, height is along y, points towards y+
// Centred along x, base on y=0

module Chevron(width=10, height=6, thickness=3) {

	// Union the two halves together
	union() {	
		// short loop to mirror the sides
		for (x=[0,1])
			// mirror the two sides
			mirror([x,0,0])
			// polygon to define the right (x+) side of the chevron shape
			polygon([
				[0, height],  			// tip of chevron 
				[width/2, thickness],  	// top right corner
				[width/2, 0],			// bottom right corner	
				[0, height-thickness]	// inside tip
			]);
	}
}