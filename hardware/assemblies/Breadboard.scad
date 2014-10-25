/*
	Assembly: BreadboardAssembly
	Breadboard assembly - includes Arduino and fixings
	
	Local Frame: 
		Origin

*/


// Connectors
// ----------

module BreadboardAssembly() {

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
    step(1, 
            "Push the Arduino onto the breadboard - make sure you position it correctly, as it's a tight fit with the Robot base!", 
            "400 300 21 17 9 62 0 218 316")
        attachWithOffset(Breadboard_Con_Pin(Breadboard_170, along=3, across=7, ang=90), DefConDown, [0,0,3]) {
            ArduinoPro("micro");
        }
			
	End("Breadboard");
}
