
module LogoBotPolarGraphAssembly () {

    assembly("assemblies/LogoBotPolarGraph.scad", "LogoBot Polar Graph", str("LogoBotPolarGraphAssembly()")) {

    // Rough placement of the polar graph parts


    // bit of wood to fix it all to
    color([0.8,0.7,0.6])
        translate([-200,-10,-20])
        cube([400,20,20]);

    // drawing surface
    color([0.9,0.9,0.9])
        translate([-200,-10,-420])
        cube([400,4,400]);

    // wheels - aka winches
    attach([[200,0,0],[0,0,-1],0,00], MotorClip_Con_Fixing1, ExplodeSpacing = 40)
        RightWheelAssembly();

    attach([[-200,0,0],[0,0,-1],0,00], MotorClip_Con_Fixing2, ExplodeSpacing = 40)
        LeftWheelAssembly();


    // gondola - aka base
    attach([[0,-GroundClearance-10,-150],[0,1,0],0,0,0], DefConDown) {
        LogoBotBase_STL();

        // need the pen lift and servo, but rotated 90 deg
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

        // and some castors to hold the base away from the drawing surface
        attach(invertConnector(LogoBot_Con_GridFixing(3,4,0)), MarbleCaster_Con_Default, ExplodeSpacing=15)
            MarbleCasterAssembly();

        attach(invertConnector(LogoBot_Con_GridFixing(-3,4,0)), MarbleCaster_Con_Default, ExplodeSpacing=15)
                MarbleCasterAssembly();

        attach(invertConnector(LogoBot_Con_GridFixing(0,-6,0)), MarbleCaster_Con_Default, ExplodeSpacing=15)
                        MarbleCasterAssembly();

    }


    // electronic stuff at the top somewhere
    attach([[0,0,3],[0,0,-1],90,0,0], ArduinoPro_Con_Center, ExplodeSpacing=20)
        ArduinoPro(ArduinoPro_Mini, ArduinoPro_Pins_Opposite, true);


    // steps
    step(1, "Do something") {
            view(t=[0,0,0], r=[52,0,218], d=400);

            //attach(DefConDown, DefConDown)
            //      AnotherAssembly();
        }



    }
}
