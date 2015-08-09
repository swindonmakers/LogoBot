
// Connectors
// ----------
// Mostly inherited from the core LogoBot.scad assembly

LogoBotLineFollower_Con_LineSensors = [[0,0,0], [0,0,1], 0,0,0];


// Assembly
// --------

module LogoBotLineFollowerAssembly ( Shell=true ) {

    assembly("assemblies/LogoBotLineFollower.scad", "Final Assembly", str("LogoBotLineFollowerAssembly()")) {

        translate([0, 0, GroundClearance]) {

            // Default Design Elements
            // -----------------------

            // Base
            LogoBotBase_STL();


            step(1, "Plug the Pro Mini Clips into the base and then snap the Arduino Pro Mini into them") {
                view(t=[0,0,0], r=[49,0,153], d=370);

                *attach(LogoBot_Con_GridFixing(1,4,90), DefConUp)
                    ProMiniClip_STL();

                *attach(LogoBot_Con_GridFixing(-1,4,90), DefConUp)
                    ProMiniClip_STL();

                attach(offsetConnector(LogoBot_Con_GridFixing(0,4,-90), [0,0,3]), ArduinoPro_Con_Center, ExplodeSpacing=20)
                    ArduinoPro(ArduinoPro_Mini, ArduinoPro_Pins_Opposite, true);
            }


            step(2, "Pin the line sensor assembly to the underside") {
                view(t=[-4,6,47], r=[66,0,190], d=450);

                attach(LogotBotLineFollower_Con_LineSensors, DefConUp)
                    LineSensorAssembly();

                attach(LogoBot_Con_GridFixing(0,6,90), DefConUp)
                    PinTack_STL(h=7);
            }


            // Motor + Wheel assemblies (x2)

            //LogoBot_Con_LeftWheel
            step(4, "Plug the two wheels assemblies into the base") {
                view(t=[-4,6,47], r=[66,0,190], d=450);

                attach(LogoBot_Con_LeftWheel, MotorClip_Con_Fixing1, ExplodeSpacing = 40)
                    LeftWheelAssembly();

                attach(LogoBot_Con_RightWheel, MotorClip_Con_Fixing1, ExplodeSpacing = 40)
                    RightWheelAssembly();
            }

            // Connect jumper wires
            step(5,
                "Connect the jumper wires between the motor drivers and the Arduino") {
                view(t=[-15,11,28], r=[62,0,204], d=340);
                view(title="plan", t=[0,32,16], r=[0,0,0], d=340);

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

            //Power Switch
            step(6, "Fix the power toggle switch into place") {
                view(t=[8,-10,26], r=[47,0,300], d=260);

                attach(LogoBot_Con_PowerSwitch, MiniToggleSwitch_Con_Def, ExplodeSpacing=20)
                    MiniToggleSwitch(type=MiniToggleSwitch_SPST6A, showWasher=true, washerOffset = dw);
            }


            // Caster
            step(9, "Align the caster assembly with the base, then insert a short pin to lock it to the base") {
                view(t=[7,-36,31], r=[145,0,303], d=200);

                attach(LogoBot_Con_Caster, MarbleCaster_Con_Default, ExplodeSpacing=15)
                    MarbleCasterAssembly();

                attach(offsetConnector(invertConnector(LogoBot_Con_Caster), [0,0,dw]), MarbleCaster_Con_Default)
                    PinTack_STL(h=dw+0.6+2+1.5);
            }



            // TODO: Add velcro or to hold down battery pack
            // Battery assembly
            step(11, "Attach the battery pack with self-adhesive hook and loop tape") {
                view(t=[0,0,20], r=[52,0,337], d=400);

                attach(LogoBot_Con_BatteryPack, BatteryPack_Con_SideFace(), ExplodeSpacing=20)
                    BatteryPack(BatteryPack_AA, showBatteries=true);

                // hook and loop tape
                attach(LogoBot_Con_GridFixing(0,-4,0), HookAndLoopTape_Con_Def, ExplodeSpacing=0)
                    HookAndLoopTape(length=40, width=10);
            }

            step(12, "Wire in the terminal block to distribute power") {
                view(t=[8,-10,26], r=[47,0,300], d=260);

                attach(LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def, ExplodeSpacing=0)
                    TerminalBlock(TerminalBlock_20A, 2);

                // positive from toggle switch to terminal block
                JumperWire(
                    type = JumperWire_NN1,
                    con1 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 2, false),
                        ExplodeSpacing=0
                    ),
                    con2 = [[20, 0, 10], [0,0,-1], 0,0,0],
                    length = 50,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors=["red"]
                );

                // positive from battery to toggle switch
                JumperWire(
                    type = JumperWire_NN1,
                    con1 = [[28, -30, 30], [-1,0,0], 0,0,0],
                    con2 = [[20, -4, 10], [0,0,-1], 0,0,0],
                    length = 50,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors=["red"]
                );

                // ground from battery to terminal block
                JumperWire(
                    type = JumperWire_NN1,
                    con1 = [[28, -30, 31], [-1,0,0], 0,0,0],
                    con2 =  attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 1, false),
                        ExplodeSpacing=0
                    ),
                    length = 50,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0]
                );
            }

            step(13, "Wire up power to the stepper drivers and Arduino.  Then connect the microswitches to the Arduino.") {
                view(t=[0,20,40], r=[62,0,190], d=250);

                // experimental wiring :)

                // arduino to ground
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[-12.5, 47, 8], [0,0,-1], 0,0,0],
                    con2 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 1, true),
                        ExplodeSpacing=0
                    ),
                    length = 100,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors = ["black"]
                );

                // arduino to power
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[-10, 47, 8], [0,0,-1], 0,0,0],
                    con2 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 2, true),
                        ExplodeSpacing=0
                    ),
                    length = 100,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors = ["red"]
                );

                // left motor driver to ground
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[-24, 24, 33], [0,-1,0], 0,0,0],
                    con2 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 1, true),
                        ExplodeSpacing=0
                    ),
                    length = 70,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors=["black"]
                );

                // left motor driver to power
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[-24, 24, 30.5], [0,-1,0], 0,0,0],
                    con2 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 2, true),
                        ExplodeSpacing=0
                    ),
                    length = 70,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors=["red"]
                );

                // right motor driver to ground
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[43, 24, 33], [0,-1,0], 0,0,0],
                    con2 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 1, true),
                        ExplodeSpacing=0
                    ),
                    length = 70,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors=["black"]
                );

                // right motor driver to power
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[43, 24, 30.5], [0,-1,0], 0,0,0],
                    con2 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 2, true),
                        ExplodeSpacing=0
                    ),
                    length = 70,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0],
                    overrideColors=["red"]
                );

                //  arduino to left microswitch
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[5,47,8], [0,0,-1], 0,0,0],
                    con2 = [[-40, 50, 0], [-0.5,0,-1], 0,0,0],
                    length = 100,
                    conVec1 = [-1,0,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0]
                );

                //  arduino to right microswitch
                JumperWire(
                    type = JumperWire_FN1,
                    con1 = [[2.5,47,8], [0,0,-1], 0,0,0],
                    con2 = [[40, 50, 0], [0.5,0.1,-1], 0,0,0],
                    length = 100,
                    conVec1 = [-1,0,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0]
                );

                // terminal block ground to left microswitch
                JumperWire(
                    type = JumperWire_NN1,
                    con1 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 1, true),
                        ExplodeSpacing=0
                    ),
                    con2 = [[-42, 50, 0], [-0.5,0,-1], 0,0,0],
                    length = 100,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0]
                );

                // terminal block ground to right microswitch
                JumperWire(
                    type = JumperWire_NN1,
                    con1 = attachedConnector(
                        LogoBot_Con_TerminalBlock, TerminalBlock_Con_Def,
                        TerminalBlock_Con_Pole(TerminalBlock_20A, 1, true),
                        ExplodeSpacing=0
                    ),
                    con2 = [[42, 50, 0], [0.7,0,-1], 0,0,0],
                    length = 100,
                    conVec1 = [0,1,0],
                    conVec2 = [-1,0,0],
                    midVec = [0.5,-1,0]
                );

            }


            // Shell + fixings
			if (Shell) {
				step(14,
					"Push the shell down onto the base and twist to lock into place") {
					view(t=[11,-23,65], r=[66,0,217], d=570);

					attach(DefConDown, DefConDown, ExplodeSpacing=BaseDiameter/2)
						ShellAssembly(true);
				}
            }
        }

	}
}
