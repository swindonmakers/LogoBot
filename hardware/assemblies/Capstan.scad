/*
	Assembly: WheelAssembly
	Combined motor and wheel assembly

	Local Frame:
		Places the motor default connector at the origin - i.e. use the motor default connector for attaching into a parent assembly

*/

module LeftCapstanAssembly( ) {

    assembly("assemblies/Capstan.scad", "Left Capstan", str("LeftCapstanAssembly()")) {

        if (DebugCoordinateFrames) frame();

        // debug connectors?
        if (DebugConnectors) {

        }

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
                Capstan_STL();
        }

		step (4, "Slide the stepper driver into place and plug in the cable for the motor") {
            view(t=[-12,-7,14], r=[177,76,0], d=220);

            attach(LeftMotorClip_Con_Driver, ULN2003DriverBoard_Con_UpperLeft, ExplodeSpacing=0)
				ULN2003DriverBoard();
		}

	}
}

module RightCapstanAssembly( ) {

    assembly("assemblies/Capstan.scad", "Right Capstan", str("RightCapstanAssembly()")) {

        if (DebugCoordinateFrames) frame();

        // debug connectors?
        if (DebugConnectors) {

        }

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
                Capstan_STL();
        }

        step (4, "Slide the stepper driver into place and plug in the cable for the motor") {
            view(t=[5,-3,14], r=[177,295,0], d=220);

			attach(RightMotorClip_Con_Driver, ULN2003DriverBoard_Con_UpperRight, ExplodeSpacing=0)
				ULN2003DriverBoard();
		}

	}
}
