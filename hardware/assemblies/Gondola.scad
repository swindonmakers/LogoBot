
module GondolaAssembly () {

    assembly("assemblies/Gondola.scad", "Gondola", str("GondolaAssembly()")) {

        LogoBotBase_STL();

        step(1, "Attach the pen lift") {
            view(r=[54,0,123],d=300);

            // need the pen lift and servo, but rotated 90 deg
            attach(DefConDown, DefConDown, ExplodeSpacing=0)
                rotate([0,0,90]) {
                    attach(LogoBot_Con_PenLift_Front, PenLiftSlider_Con_BaseFront)
                        PenLiftAssembly();

                    attach(LogoBot_Con_PenLift_Front, offsetConnector(DefConUp, [0, 0, 2 + 2.5]), ExplodeSpacing=20)
                        PinTack_STL(h=2.5+4+2.5);
                    attach(LogoBot_Con_PenLift_Rear, offsetConnector(DefConUp, [0, 0, 2 + 2.5]), ExplodeSpacing=20)
                        PinTack_STL(h=2.5+4+2.5);

                    attach(LogoBot_Con_PenLiftServo, MicroServo_Con_Horn, ExplodeSpacing=0) {
                        MicroServo();
                        attach(MicroServo_Con_Horn, ServoHorn_Con_Default)
                            ServoHorn();
                }
            }
        }


        step(2, "Attach the three castors") {
            view(r=[54,0,123],d=300);

            // and some castors to hold the base away from the drawing surface
            attach(offsetConnector(invertConnector(LogoBot_Con_GridFixing(3,4,0)), [0,0,-dw]), MarbleCaster_Con_Default, ExplodeSpacing=15)
                MarbleCasterAssembly();

            attach(offsetConnector(invertConnector(LogoBot_Con_GridFixing(-3,4,0)), [0,0,-dw]), MarbleCaster_Con_Default, ExplodeSpacing=15)
                    MarbleCasterAssembly();

            attach(offsetConnector(invertConnector(LogoBot_Con_GridFixing(0,-6,0)), [0,0,-dw]), MarbleCaster_Con_Default, ExplodeSpacing=15)
                            MarbleCasterAssembly();
        }

    }
}
