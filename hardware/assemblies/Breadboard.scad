/*
	Assembly: BreadboardAssembly
	Breadboard assembly - includes Arduino and fixings
	
	Local Frame: 
		Origin

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
	Breadboard(Breadboard_170);
	
    // Arduino
    attach(Breadboard_Con_Pin(Breadboard_170, along=3, across=7, ang=90), DefConDown, Explode=true) {
        ArduinoPro("micro");
    }
			
	End("Breadboard");
}
