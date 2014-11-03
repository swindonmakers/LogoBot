/*
	Assembly: MarbleCasterAssembly
	Model of a printable ball caster, using a standard 16mm marble for the ball
	
	Authors:
		Damian Axford
	
	Local Frame: 
		Centred on the origin, the top edge of the mounting flange lies in XY plane
	
	Parameters:
		GroundClearance - distance from the ground plane to the top of the mounting flange
		
	Returns:
		A Marble Caster assembly, rendered and colored
*/

MarbleCaster_BallRadius = Marble_Radius;


// Connectors
// ----------

// Connector: MarbleCaster_Con_Default
// Default connector for <MarbleCaster>
MarbleCaster_Con_Default				= [ [0,0,0], [0,0,1], 0, BaseThickness, 10];


function MarbleCaster_Con_Ball(GroundClearance) = [ 
    [0,0, -GroundClearance + MarbleCaster_BallRadius], 
    [0,0,1], 
    0, BaseThickness, 10
];


module MarbleCasterAssembly () {
    
    ballr = MarbleCaster_BallRadius;

    assembly("assemblies/MarbleCaster.scad", "Rear Caster", str("MarbleCasterAssembly()")) {
    
        // debug coordinate frame?
        if (DebugCoordinateFrames) {
            frame();
        }
    
        // debug connectors?
        if (DebugConnectors) {
            connector(MarbleCaster_Con_Default);
        }
    
        // STL
        MarbleCaster_STL();
    
    
        // caster ball
        step(1, 
                "Insert the marble into the printed housing") {
            view(t=[0.67,0,-15], r=[108,0,91], d=261);
         
            attach(MarbleCaster_Con_Ball(GroundClearance), Marble_Con_Default, ExplodeSpacing = 16)
                Marble(Marble_16mm);
        }
        
	}
}
