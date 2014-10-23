/*
	Assembly: BreadboardAssembly
	Breadboard assembly - includes Arduino and fixings
	
	Local Frame: 
		Breadboard_Con_BottomLeft at origin

*/


// Connectors
// ----------

module BreadboardAssembly( Explode=false ) {

    Assembly("Breadboard");

	if (DebugCoordinateFrames) frame();
	
	// debug connectors?
	if (DebugConnectors) {
		
	}
	
	// Vitamins
	// --------
	
	// Breadboard
	attach(DefCon, Breadboard_Con_BottomLeft(Breadboard_170), Invert=true) {
	    Breadboard(Breadboard_170);
	
	    // Arduino
	    attach([[8.3, 23.8, 10], [0,0,1], -90,0,0], DefCon) {
	        frame();
	        ArduinoPro("micro");
	    }
	
	}
	
		
	End("Breadboard");
}
