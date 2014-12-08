/*
	Assembly: LogoBotAssembly

	Master assembly for the LogoBot

	Local Frame:
		Centred on the origin, such that bottom edge of wheels sit on XY plane.
		Front of the robot faces towards y+

	Parameters:
		PenLift - Set to true to include a PenLift, defaults to false

	Returns:
		Complete LogoBot model

*/


// Connectors
// ----------
// These are used within this module to layout the various vitamins/sub-assemblies
// The same connectors are used to shape associated portions of the LogoBotBase_STL

LogoBot_Con_Breadboard          = [[-18, 40, 12],[0,0,-1], 0,0,0];

LogoBot_Con_LeftMotorDriver     = [[-45, 16, 8],[0,-1,0],0,0,0];
LogoBot_Con_RightMotorDriver    = [[45, 16, 8],[0,-1,0],0,0,0];

LogoBot_Con_Caster = [ [0, -BaseDiameter/2 + 10, 0], [0,0,1], 0, 0, 0];

LogoBot_Con_PenLift = [ [-20, -5, 10], [0,1,0], 0, 0, 0];

LogoBot_Con_SlideSwitch = [[-25, 0, 0], [0,0,-1], 90, 0,0];


// Assembly
// --------

function LogoBotAssembly_NumSteps() = 10 + (PenLift ? 1 : 0);

module LogoBotAssembly ( PenLift=false, Shell=true ) {

    assembly("assemblies/LogoBot.scad", "Final Assembly", str("LogoBotAssembly(PenLift=",PenLift,")")) {

        translate([0, 0, GroundClearance]) {

            // Default Design Elements
            // -----------------------

            // Base
            LogoBotBase_STL();

            step(1, "Connect the breadboard assembly to the underside of the base") {
                view(t=[0,17,12], r=[112,0,222], d=513);
                attach(LogoBot_Con_Breadboard, Breadboard_Con_BottomLeft(Breadboard_170), ExplodeSpacing=-20)
                    BreadboardAssembly();
            }


            // Bumper assemblies (x2)
            step(2, "Connect the two bumper assemblies" ) {
                view(t=[-6,7,19], r=[64,1,212], d=625);
					for (i=[0,1])
					translate([0, 0, -8])
					rotate([0, 0, i*180])
					{
						Bumper_STL();
	
						for(i=[0,1])
						mirror([i, 0, 0])
						rotate([0, 0, 43.5])
						translate([-10, BaseDiameter/2 - 21, 0])
						translate([dw + .5/2, 11.5, 0])
						translate([9.6, 1.25, 2])
							MicroSwitch();
					}
            }

            step(3, "Push the two motor drivers onto the mounting posts") {
                view(t=[-6,7,19], r=[64,1,212], d=625);
                // Left Motor Driver
                attach(LogoBot_Con_LeftMotorDriver, ULN2003DriverBoard_Con_UpperLeft, ExplodeSpacing=20)
                    ULN2003DriverBoard();

                // Right Motor Driver
                attach(LogoBot_Con_RightMotorDriver, ULN2003DriverBoard_Con_UpperRight, ExplodeSpacing=20)
                    ULN2003DriverBoard();
            }

            // Motor + Wheel assemblies (x2)
            step(4, "Clip the two wheels assemblies onto the base and
                    connect the motor leads to the the motor drivers") {
                view(t=[-4,6,47], r=[66,0,190], d=740);

                for (i=[0:1])
                    mirror([i,0,0])
                    translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
                    translate([-15,0,0])
                    attach(DefConDown, DefConDown, ExplodeSpacing = 40)
                    translate([15,0,0])
                    rotate([-90, 0, 90]) {
                        assign($rightSide= i == 0? 1 : 0)
                            WheelAssembly();
                    }
            }

            // Connect jumper wires
            step(5,
                "Connect the jumper wires between the motor drivers and the Arduino") {
                view(t=[9,26,54], r=[38,0,161], d=766);
                view(title="plan", t=[0,32,16], r=[0,0,0], d=337);

                // Left
                JumperWire(
                    type = JumperWire_FM4,
                    con1 = attachedConnector(
                        LogoBot_Con_LeftMotorDriver,
                        ULN2003DriverBoard_Con_UpperLeft,
                        ULN2003DriverBoard_Con_Arduino,
                        ExplodeSpacing=20
                    ),
                    con2 = attachedConnector(
                        LogoBot_Con_Breadboard,
                        Breadboard_Con_BottomLeft(Breadboard_170),
                        Breadboard_Con_Pin(Breadboard_170, along=6, across=8),
                        ExplodeSpacing=20
                    ),
                    length = 100,
                    conVec1 = attachedDirection(
                        LogoBot_Con_LeftMotorDriver,
                        ULN2003DriverBoard_Con_UpperLeft,
                        [0,[1,0,0]]),
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0]
                );

                // Right
                JumperWire(
                    type = JumperWire_FM4,
                    con1 = attachedConnector(
                        LogoBot_Con_RightMotorDriver,
                        ULN2003DriverBoard_Con_UpperRight,
                        ULN2003DriverBoard_Con_Arduino,
                        ExplodeSpacing=20
                    ),
                    con2 = attachedConnector(
                        LogoBot_Con_Breadboard,
                        Breadboard_Con_BottomLeft(Breadboard_170),
                        Breadboard_Con_Pin(Breadboard_170, along=10, across=8),
                        ExplodeSpacing=20
                    ),
                    length = 100,
                    conVec1 = attachedDirection(
                        LogoBot_Con_RightMotorDriver,
                        ULN2003DriverBoard_Con_UpperRight,
                        [0,[1,0,0]]),
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0]
                );
            }
            // Battery assembly
            step(6, "Clip in the battery pack") {
                view(t=[-6,7,19], r=[64,1,212], d=625);

                attach(DefConDown, DefConDown, ExplodeSpacing=20)
                    translate([-25, -45, 12])
                        rotate([90, 0, 90]) {
                            BatteryPack(BatteryPack_AA);
                            battery_pack_double(BatteryPack_AA, 2, 4);
                        }
            }

            // Power Switch
            step(7, "Clip the power switch into place") {
                view(t=[-6,7,19], r=[64,1,212], d=625);

                attach(LogoBot_Con_SlideSwitch, DefConUp)
                    SlideSwitch();
            }


            // LED
            step(8, "Clip the LED into place") {
                view(t=[-6,7,19], r=[64,1,212], d=625);

                attach(DefConDown, DefConDown, ExplodeSpacing=20)
                    translate([0, -10, BaseDiameter/2])
                    LED();
            }

            // Piezo
            step(9, "Clip the piezo sounder into place") {
                view(t=[-6,7,19], r=[64,1,212], d=625);

                attach(DefConDown, DefConDown, ExplodeSpacing=20)
                    translate([-37, -32, 10])
                    murata_7BB_12_9();
            }


            // Caster
            step(10, "Push the caster assembly into the base so that it snaps into place") {
                view(t=[-6,7,19], r=[115,1,26], d=625);

                attach(LogoBot_Con_Caster, MarbleCaster_Con_Default, ExplodeSpacing=15)
                    MarbleCasterAssembly();
            }


            // Conditional Design Elements
            // ---------------------------

            // PenLift
            //   Placeholder of a micro servo to illustrate having conditional design elements
            if (PenLift) {
                // TODO: wrap into a PenLift sub-assembly
                step(11, "Fit the pen lift assembly") {
                    view(t=[-6,7,19], r=[64,1,212], d=625);

                    attach( LogoBot_Con_PenLift, MicroServo_Con_Horn)
                        MicroServo();
                }
            }


            // Shell + fixings
			if (Shell) {
				step(PenLift ? 12 : 11,
					"Push the shell down onto the base and twist to lock into place") {
					view(t=[11,-23,65], r=[66,0,217], d=1171);

					attach(DefConDown, DefConDown, ExplodeSpacing=BaseDiameter/2)
						BasicShell_STL();
				}
            }
        }

	}
}
