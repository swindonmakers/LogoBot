/*
	Assembly: BreadboardAssembly
	Breadboard assembly - includes Arduino and fixings
	
	Local Frame: 
		Origin

*/

// Connectors
// ----------

module BreadboardAssembly() {

    assembly("assemblies/Breadboard.scad", "Brain", str("BreadboardAssembly()")) {

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
                "Push the Arduino onto the breadboard - make sure you position it correctly, 
                 as it\\'s a tight fit with the Robot base!") {
            view(t=[21,17,9], r=[62,0,218], d=316);
  
            attachWithOffset(Breadboard_Con_Pin(Breadboard_170, along=3, across=7, ang=90), DefConDown, [0,0,3]) {
                ArduinoPro(ArduinoPro_Micro, ArduinoPro_Pins_Normal);
            }
        }
            
	}
}
