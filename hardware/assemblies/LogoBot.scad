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

// dynamic connector for a given fixing in the grid
function LogoBot_Con_GridFixing(x,y,r) = [[x*10, y*10, dw], [0,0,-1], r, 0,0];

LogoBot_Con_Breadboard          = [[-18, 40, 12],[0,0,-1], 0,0,0];

LogoBot_Con_LeftWheel           = [[-40,-20, dw],[0,0,-1],90,0,0];
LogoBot_Con_RightWheel           = [[40,20, dw],[0,0,-1],-90,0,0];

LogoBot_Con_LeftMotorDriver     = [[-46, 16, 10],[0,-1,0],0,0,0];
LogoBot_Con_RightMotorDriver    = [[46, 16, 10],[0,-1,0],0,0,0];

LogoBot_Con_Caster = [ [0, -BaseDiameter/2 + 10, 0], [0,0,1], 0, 0, 0];

LogoBot_Con_PenLift_Front = [ [0, -20, 2], [0,0,1], 0, 0, 0];
LogoBot_Con_PenLift_Rear = [ [0, 20, 2], [0,0,1], 0, 0, 0];
LogoBot_Con_PenLiftServo = [[-12, -6, -6], [1, 0, 0], 90, 0, 0];

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

            *step(1, "Connect the breadboard assembly to the underside of the base") {
                view(t=[0,17,12], r=[112,0,222], d=513);
                attach(LogoBot_Con_Breadboard, Breadboard_Con_BottomLeft(Breadboard_170), ExplodeSpacing=-20)
                    BreadboardAssembly();
            }

            step(1, "Plug the Pro Mini Clips into the base and then snap the Arduino Pro Mini into them") {
                view(t=[0,17,12], r=[112,0,222], d=513);

                attach(LogoBot_Con_GridFixing(1,4,90), DefConUp)
                    ProMiniClip_STL();

                attach(LogoBot_Con_GridFixing(-1,4,90), DefConUp)
                    ProMiniClip_STL();

                attach(offsetConnector(LogoBot_Con_GridFixing(0,4,-90), [0,0,3]), ArduinoPro_Con_Center, ExplodeSpacing=20)
                    ArduinoPro(ArduinoPro_Mini, ArduinoPro_Pins_Opposite, true);
            }


            // Bumper assemblies (x2)
            step(2, "Connect the two bumper assemblies using four of the push pins with flat heads" ) {
                view(t=[0,0,0], r=[63,0,146], d=400);
					for (i=[0,1])
					translate([0, 0, -8])
					rotate([0, 0, i*180]) {
						attach([Bumper_Con_LeftPin[0], Bumper_Con_LeftPin[1], 0, 0, 0], Bumper_Con_LeftPin, ExplodeSpacing=20)
							BumperAssembly();

						attachWithOffset(DefCon, DefCon, [0, 0, -6*layers])
							BumperStabiliser_STL();

						attach(Bumper_Con_LeftPin, DefConDown, ExplodeSpacing=-20, offset=[0,0,20])
							pintack(side=false, h=7.8+2+2.5+6*layers, bh=2);

						attach(Bumper_Con_RightPin, DefConDown, ExplodeSpacing=-20)
							pintack(side=false, h=7.8+2+2.5+6*layers, bh=2);
					}
            }

            // Motor + Wheel assemblies (x2)

            //LogoBot_Con_LeftWheel
            step(4, "Clip the two wheels assemblies onto the base and
                    connect the motor leads to the the motor drivers") {
                view(t=[-4,6,47], r=[66,0,190], d=740);

                attach(LogoBot_Con_LeftWheel, MotorClip_Con_Fixing1, ExplodeSpacing = 40)
                    LeftWheelAssembly();

                attach(LogoBot_Con_RightWheel, MotorClip_Con_Fixing1, ExplodeSpacing = 40)
                    RightWheelAssembly();
            }

            // Connect jumper wires
            step(5,
                "Connect the jumper wires between the motor drivers and the Arduino") {
                view(t=[9,26,54], r=[38,0,161], d=766);
                view(title="plan", t=[0,32,16], r=[0,0,0], d=337);

                // Left
                JumperWire(
                    type = JumperWire_FF4,
                    con1 = attachedConnector(
                        LogoBot_Con_LeftMotorDriver,
                        ULN2003DriverBoard_Con_UpperLeft,
                        ULN2003DriverBoard_Con_Arduino,
                        ExplodeSpacing=20
                    ),
                    con2 = attachedConnector(
                        LogoBot_Con_GridFixing(0,4,-90),
                        DefConDown,
                        [[-7.5, -5, 7],[0,0,-1],0,0,0],
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
                    type = JumperWire_FF4,
                    con1 = attachedConnector(
                        LogoBot_Con_RightMotorDriver,
                        ULN2003DriverBoard_Con_UpperRight,
                        ULN2003DriverBoard_Con_Arduino,
                        ExplodeSpacing=20
                    ),
                    con2 = attachedConnector(
                        LogoBot_Con_GridFixing(0,4,-90),
                        DefConDown,
                        [[-7.5, -15, 7],[0,0,-1],0,0,0],
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

            // TODO: Add velcro or to hold down battery pack
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

            // TODO: Replace with toggle switch
            //Power Switch
            *step(7, "Clip the power switch into place") {
                view(t=[-6,7,19], r=[64,1,212], d=625);

                attach(LogoBot_Con_SlideSwitch, DefConUp)
                    SlideSwitch();
            }


            // TODO: LED
            *step(8, "Clip the LED into place") {
                view(t=[-6,7,19], r=[64,1,212], d=625);

                attach(DefConDown, DefConDown, ExplodeSpacing=20)
                    translate([0, -10, BaseDiameter/2])
                    LED();
            }

            // TODO: Piezo
            *step(9, "Clip the piezo sounder into place") {
                view(t=[-6,7,19], r=[64,1,212], d=625);

                attach(DefConDown, DefConDown, ExplodeSpacing=20)
                    translate([-37, -32, 10])
                    murata_7BB_12_9();
            }


            // Caster
            step(10, "Align the caster assembly with the base, then insert a short pin to lock it to the base") {
                view(t=[-6,7,19], r=[115,1,26], d=625);

                attach(LogoBot_Con_Caster, MarbleCaster_Con_Default, ExplodeSpacing=15)
                    MarbleCasterAssembly();

                attach(offsetConnector(invertConnector(LogoBot_Con_Caster), [0,0,dw]), MarbleCaster_Con_Default)
                    pintack(side=false, h=dw+0.6+2+1.5, lh=2, bh=2);
            }

            // Conditional Design Elements
            // ---------------------------

            // PenLift
            //   Placeholder of a micro servo to illustrate having conditional design elements
            if (PenLift) {
                step(12, "Fit the pen lift assembly using two of the pins and zip tie the servo under the base.") {
                    view(t=[-6,7,19], r=[64,1,212], d=625);

					attach(LogoBot_Con_PenLift_Front, PenLiftSlider_Con_BaseFront)
						PenLiftAssembly();

					attach(LogoBot_Con_PenLift_Front, offsetConnector(DefConDown, [0, 0, 2 + 2.5]))
						pintack(side=false, h=2.5+4+2.5, bh=2);
					attach(LogoBot_Con_PenLift_Rear, offsetConnector(DefConDown, [0, 0, 2 + 2.5]))
						pintack(side=false, h=2.5+4+2.5, bh=2);

                    attach(LogoBot_Con_PenLiftServo, MicroServo_Con_Horn) {
						MicroServo();
						attach(MicroServo_Con_Horn, ServoHorn_Con_Default)
							ServoHorn();
					}
                }
            }


            // Shell + fixings
			if (Shell) {
				step(PenLift ? 13 : 12,
					"Push the shell down onto the base and twist to lock into place") {
					view(t=[11,-23,65], r=[66,0,217], d=625);

					attach(DefConDown, DefConDown, ExplodeSpacing=BaseDiameter/2)
						ShellAssembly(PenLift? false : true);
				}
            }
        }

	}
}
