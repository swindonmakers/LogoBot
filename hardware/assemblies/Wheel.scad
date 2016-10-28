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

        // generate an animation video for this assembly
        animation(title="LeftWheel",framesPerStep=10);

        LeftMotorClip_STL();

        step(1, "Clip the motor into place") {
            view(t=[-5,-23,17], r=[170,35,0], d=220);

            attach(DefConFront, DefConFront, ExplodeSpacing=20)
                MotorAndCable();
        }

		step(2, "Push the pins into the motor clip") {
            view(t=[-5,-23,17], r=[141,170,0], d=220);

			attach(offsetConnector(MotorClip_Con_Fixing1, [0,-dw,0]), DefConUp, ExplodeSpacing=20)
                PinTack_STL(h=2*dw + 3);

			attach(offsetConnector(MotorClip_Con_Fixing2, [0,-dw,0]), DefConUp, ExplodeSpacing=20)
                PinTack_STL(h=2*dw + 3);
		}


        step(3,  "Push the wheel onto the motor shaft, then add a rubber band or o-ring to the wheel for extra grip.  You can also add a retaining grub screw if necessary.") {
            view(t=[-7,-6,0], r=[150,70,0], d=220);

            attach(Wheel_Con_Default, DefConDown, ExplodeSpacing=20)
                Wheel_STL();
        }

		step (4, "Slide the stepper driver into place and plug in the cable for the motor") {
            view(t=[-12,-7,14], r=[177,76,0], d=220);

            attach(LeftMotorClip_Con_Driver, ULN2003DriverBoard_Con_UpperLeft, ExplodeSpacing=0)
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

        // generate an animation video for this assembly
        animation(title="RightWheel",framesPerStep=10);

        RightMotorClip_STL();

        step(1, "Clip the motor into place") {
            view(t=[-5,-23,17], r=[170,35,0], d=220);

            attach(DefConFront, DefConFront, ExplodeSpacing=20)
                mirror([1,0,0])
                MotorAndCable(true);
        }

		step(2, "Push the pins into the motor clip") {
            view(t=[-5,-23,17], r=[141,170,0], d=220);

            attach(offsetConnector(MotorClip_Con_Fixing1, [0,-dw,0]), DefConUp, ExplodeSpacing=20)
                PinTack_STL(h=2*dw + 3);

            attach(offsetConnector(MotorClip_Con_Fixing2, [0,-dw,0]), DefConUp, ExplodeSpacing=20)
                PinTack_STL(h=2*dw + 3);
		}


        step(3,  "Push the wheel onto the motor shaft, then add a rubber band or o-ring to the wheel for extra grip.  You can also add a retaining grub screw if necessary.") {
            view(t=[-7,-6,0], r=[150,70,0], d=220);

            attach(Wheel_Con_Default, DefConDown, ExplodeSpacing=20)
                Wheel_STL();
        }

        step (4, "Slide the stepper driver into place and plug in the cable for the motor") {
            view(t=[5,-3,14], r=[177,295,0], d=220);

			attach(RightMotorClip_Con_Driver, ULN2003DriverBoard_Con_UpperRight, ExplodeSpacing=0)
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
                [-30, -9, 24]
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

        // TODO: fix this dirty hack
        color("white")
            translate([-31,-11,19.5])
            cube([6, 3.5, 13]);


    } else {
        ribbonCable(
            cables=5,
            cableRadius = 0.6,
            points= [
                [-2.5, -23, 7],
                [-10, -60, 10],
                [-70, -20, 40],
                [-30, -9, 17]
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

        // TODO: fix this dirty hack
        color("white")
            translate([-31,-11,8.5])
            cube([6, 3.5, 13]);
    }
}
