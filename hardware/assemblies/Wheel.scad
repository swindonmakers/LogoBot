/*
	Assembly: WheelAssembly
	Combined motor and wheel assembly

	Local Frame:
		Places the motor default connector at the origin - i.e. use the motor default connector for attaching into a parent assembly

*/

module LeftWheelAssembly( ) {

    assembly("assemblies/Wheel.scad", "Left Drive Wheel", str("LeftWheelAssembly()")) {

        if (DebugCoordinateFrames) frame();

        // debug connectors?
        if (DebugConnectors) {

        }

        LeftMotorClip_STL();

        step(1, "Clip the motor into place") {
            view();

            MotorAndCable();
        }

		step(2, "Push the pins into the motor clip") {
			view();

			attach(offsetConnector(MotorClip_Con_Fixing1, [0,-dw,0]), DefConUp)
                PinTack_STL(side=false, h=2*dw + 3, bh=2);

			attach(offsetConnector(MotorClip_Con_Fixing2, [0,-dw,0]), DefConUp)
                PinTack_STL(side=false, h=2*dw + 3, bh=2);
		}


        step(3,  "Push the wheel onto the motor shaft **Optional:** add a rubber band to the wheel for extra grip.") {
            view(t=[0, -3, 5], r=[349,102,178], d=500);

            attach(Wheel_Con_Default, DefConDown, ExplodeSpacing=20)
                Wheel_STL();
        }

		step (4, "Push the stepper driver into place") {
			attach(LeftMotorClip_Con_Driver, ULN2003DriverBoard_Con_UpperLeft)
				ULN2003DriverBoard();
		}

	}
}

module RightWheelAssembly( ) {

    assembly("assemblies/Wheel.scad", "Right Drive Wheel", str("RightWheelAssembly()")) {

        if (DebugCoordinateFrames) frame();

        // debug connectors?
        if (DebugConnectors) {

        }

        RightMotorClip_STL();

        step(1, "Clip the motor into place") {
            view();

            mirror([1,0,0])
                MotorAndCable(true);
        }

		step(2, "Push the pins into the motor clip") {
			view();

			attach(offsetConnector(MotorClip_Con_Fixing1, [0,-dw,0]), DefConUp)
				pintack(side=false, h=2*dw + 3, bh=2);

			attach(offsetConnector(MotorClip_Con_Fixing2, [0,-dw,0]), DefConUp)
				pintack(side=false, h=2*dw + 3, bh=2);
		}


        step(3,  "Push the wheel onto the motor shaft **Optional:** add a rubber band to the wheel for extra grip.") {
            view(t=[0, -3, 5], r=[349,102,178], d=500);

            attach(Wheel_Con_Default, DefConDown, ExplodeSpacing=20)
                Wheel_STL();
        }

		step (4, "Push the stepper driver into place") {
			attach(RightMotorClip_Con_Driver, ULN2003DriverBoard_Con_UpperRight)
				ULN2003DriverBoard();
		}

	}
}


module MotorAndCable(rightSide=false) {
    StepperMotor28YBJ48();

    // ribbon Cable :)
    if (rightSide) {
        ribbonCable(
            cables=5,
            cableRadius = 0.6,
            points= [
                [2.5, -23, 7],
                [-10, -60, 10],
                [-70, -15, 20],
                [-26, -8, 25]
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
                [-10, -60, 10],
                [-70, -20, 40],
                [-26, -8, 18]
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
}
