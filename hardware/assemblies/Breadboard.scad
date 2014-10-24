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
    attach([[8.3, 23.8, 11], [0,0,-1], 90,0,0], [[0,0,0],[0,0,-1],0,0,0], Explode=Explode) {
        ArduinoPro(ArduinoPro_Micro, ArduinoPro_Pins_Normal);
    }
			
	End("Breadboard");
}
