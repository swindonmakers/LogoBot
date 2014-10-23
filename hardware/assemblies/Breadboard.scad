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
    attachWithOffset(Breadboard_Con_Pin(Breadboard_170, along=3, across=7, ang=90), DefConDown, [0,0,3], Explode=Explode) {
        ArduinoPro("micro");
    }
			
	End("Breadboard");
}
