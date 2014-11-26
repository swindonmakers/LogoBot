/*
	Assembly: WheelAssembly
	Combined motor and wheel assembly

	Local Frame:
		Places the motor default connector at the origin - i.e. use the motor default connector for attaching into a parent assembly

*/

// Connectors
Wheel_Con_Default				= [ [0, 0 ,0], [0, 0, 1], 90, 0, 0 ];


module WheelAssembly( ) {

    assembly("assemblies/Wheel.scad", "Drive Wheel", str("WheelAssembly()")) {

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
                    [70, -15, 20],
                    [26, -8, 25]
                ],
                vectors = [
                    [-1, 0 ,0],
                    [-0.5, 0.5, 1],
                    [-0.5, 0, 1],
                    [0, 0, 1]
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
                    [70, -20, 40],
                    [26, -8, 18]
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
        step(1,  "Push the wheel onto the motor shaft \n**Optional:** add a rubber band to the wheel for extra grip.") {
            view(t=[0, -3, 5], r=[349,102,178], d=500);

            attach(Wheel_Con_Default, [[0,0,2],[0,0,-1],0,0,0], ExplodeSpacing=20)
                Wheel_STL();
        }
	}
}
