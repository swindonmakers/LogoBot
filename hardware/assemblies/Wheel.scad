/*
	Assembly: WheelAssembly
	Combined motor and wheel assembly
	
	Local Frame: 
		Places the motor default connector at the origin - i.e. use the motor default connector for attaching into a parent assembly

*/


// Connectors
// ----------

Wheel_Con_Default				= [ [0,0,0], [0,0,1], 0, 0, 0];



module WheelAssembly( ) {

    Assembly("Wheel");

	if (DebugCoordinateFrames) frame();
	
	// debug connectors?
	if (DebugConnectors) {
		
	}
	
	// Vitamins
	logo_motor();
	
	// ribbon Cable :)
	if ($rightSide) {
	    ribbonCable(
            cables=5,
            cableRadius = 0.6,
            points= [
                [2.5, -23, 7],
                [10, -60, 10],
                [20, -30,15],
                [26,0, 13]
            ],
            vectors = [
                [-1, 0 ,0],
                [-0.5, 0.5, 1],
                [-0.5, 0.5, 0],
                [0, 0,1]
            ],
            colors = [
                "blue",
                "orange",
                "red",
                "pink",
                "yellow"
            ],
            debug=false
        );
	
	
	} else {
        ribbonCable(
            cables=5,
            cableRadius = 0.6,
            points= [
                [-2.5, -23, 7],
                [10, -60, 10],
                [20, -30,25],
                [26,0, 30]
            ],
            vectors = [
                [1, 0 ,0],
                [0.5, 0.5, -1],
                [-0.5, 0.5, -1],
                [0, 0,-1]
            ],
            colors = [
                "blue",
                "orange",
                "red",
                "pink",
                "yellow"
            ],
            debug=false
        );
    }
	
	// STL
	step(1, 
            "Push the wheel onto the motor shaft", 
            "400 300 -0.4 0.2 0.7 349 125 180 415")
	    Wheel_STL();
	
		
	End("Wheel");
}


module Wheel_STL() {

	STL("Wheel");
	
	color(Level2PlasticColor)
	    cylinder(r=WheelDiameter/2, h=WheelThickness, $fn=64);
}


module Wheel_STL_View() {
    echo("400 300 0 -1 -1 49 0 25 336");
}