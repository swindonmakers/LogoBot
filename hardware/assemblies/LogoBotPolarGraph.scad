
module LogoBotPolarGraphAssembly () {

    assembly("assemblies/LogoBotPolarGraph.scad", "LogoBot Polar Graph", str("LogoBotPolarGraphAssembly()")) {

        step(1, "Cut a piece of wood to 500mm long, at least 20mm x 20mm cross section") {
            view(t=[10, -10, 86], r=[69, 0, 25], d=880);

            color([0.8,0.7,0.6])
                translate([-250,-10,-20])
                cube([500,20,20]);
        }

        // steps
        step(2, "Screw the capstan assemblies to the wooden beam, the axles should be 440mm apart.") {
            view(t=[10, -10, 86], r=[69, 0, 25], d=880);

            // wheels - aka winches
            attach([[240,0,0],[0,0,-1],0,00], MotorClip_Con_Fixing1, explodeChildren=true) {
                LeftCapstanAssembly();

                attach(offsetConnector(MotorClip_Con_Fixing1,[0,-dw,0]), DefConDown, ExplodeSpacing=70)
                    screw(No6_cs_screw);

                attach(offsetConnector(MotorClip_Con_Fixing2,[0,-dw,0]), DefConDown, ExplodeSpacing=70)
                    screw(No6_cs_screw);
            }


            attach([[-240,0,0],[0,0,-1],0,00], MotorClip_Con_Fixing2, explodeChildren=true) {
                RightCapstanAssembly();

                attach(offsetConnector(MotorClip_Con_Fixing1,[0,-dw,0]), DefConDown, ExplodeSpacing=70)
                    screw(No6_cs_screw);

                attach(offsetConnector(MotorClip_Con_Fixing2,[0,-dw,0]), DefConDown, ExplodeSpacing=70)
                    screw(No6_cs_screw);
            }

        }


        // gondola - aka base
        step(3, "String up the gondola using fishing line") {
            view(t=[10, -10, 86], r=[69, 0, 25], d=880);

            attach([[0,-GroundClearance-10,-150],[0,1,0],0,0,0], DefConDown, ExplodeSpacing=0) {
                GondolaAssembly();

                // TODO: proper strings
                attach(LogoBot_Con_GridFixing(0,2,0), DefConDown)
                    vector([1.4,1,-0.1], l=250, l_arrow=0, mark=false);

                attach(LogoBot_Con_GridFixing(0,2,0), DefConDown)
                    vector([-1.4,1,-0.1], l=250, l_arrow=0, mark=false);
            }
        }


        step(10, "Fix the arduino to the center of the beam - 200mm jumper wires should just reach from the motor drivers") {
            view(t=[10, -10, 86], r=[69, 0, 25], d=880);

            // electronic stuff at the top somewhere
            attach([[0,0,3],[0,0,-1],90,0,0], ArduinoPro_Con_Center, ExplodeSpacing=20)
                ArduinoPro(ArduinoPro_Mini, ArduinoPro_Pins_Opposite, true);

        }



        step(20, "Screw, tape or otherwise fix the polargraph onto the top of a suitable drawing surface - flipchart stands work well.") {
            view(t=[10, -10, 86], r=[69, 0, 25], d=880);

            // drawing surface
            color([0.9,0.9,0.9])
                translate([-250,-10,-420])
                cube([500,4,400]);
        }


    }
}
