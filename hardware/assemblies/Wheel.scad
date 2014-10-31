/*
	Assembly: WheelAssembly
	Combined motor and wheel assembly
	
	Local Frame: 
		Places the motor default connector at the origin - i.e. use the motor default connector for attaching into a parent assembly

*/


// Connectors
// ----------

Wheel_Con_Default				= [ [0, 0 ,0], [0, 0, -1], 90, 0, 0 ];



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
	attach([[0,0,2],[0,0,1],0,0,0], Wheel_Con_Default)
	    Wheel_STL();
	
		
	End("Wheel");
}


module Wheel_STL() {

	STL("Wheel");

	if (DebugConnectors) connector(Wheel_Con_Default);
	
	color(Level2PlasticColor) {

		// Main wheel
		rotate_extrude($fn=100)
		translate ([MotorShaftDiameter / 2, 0, 0])
		difference()
		{
			square([(WheelDiameter - MotorShaftDiameter) / 2, WheelThickness]);

			translate([(WheelDiameter - MotorShaftDiameter) / 2 , WheelThickness / 2])
				circle(r = WheelThickness / 4);
		}
		
		// Flats in center
		for(i = [0:1])
			mirror([i, 0, 0])		
				translate([MotorShaftFlatThickness / 2, -MotorShaftDiameter / 2, 0])
					cube([MotorShaftDiameter / 2, MotorShaftDiameter, WheelThickness]);
	}
}


module Wheel_STL_View() {
    echo("400 300 0 -1 -1 49 0 25 336");
}