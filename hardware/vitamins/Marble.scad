/*
	Vitamin: Marble
	Standard 16mm marble
	
	Local Frame: 
		Centred on origin
		
*/

// Types

// dummy type to support part STL generation
Marble_16mm = "16mm";


// Connectors
Marble_Con_Default = DefCon;


// Global variables

Marble_Diameter = 16;
Marble_Radius = Marble_Diameter / 2;


module Marble(type=Marble_16mm, color=[0.7,0.7,0.7]) {

    vitamin("vitamins/Marble.scad", "16mm Marble", "Marble(Marble_16mm)") {
        view(t=[-1,0,-1], r=[66,0,60], d=119);

        if (DebugCoordinateFrames) {
            frame();
        }

        if (DebugConnectors) {
            connector(Marble_Con_Default);
        }

        color([color[0], color[1], color[2], 0.5])
            sphere(r=16/2, $fn=32);
        
	}
    
}