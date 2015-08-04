/*
    A streamlined, minimalistic base for LogoBot

    Supports a bare minimum of plug-in parts

    Local Frame:
        Base lies on XY plane, centered on origin, front of robot is towards y+

*/

module SimpleBase_STL() {

    // turn off explosions inside STL!!!
    $Explode = false;

    printedPart("printedparts/SimpleBase.scad", "Simple Base", "SimpleBase_STL()") {

        view(t=[0,0,0], r=[58,0,225], d=681);

        // Color it as a printed plastic part
        color(PlasticColor)
            if (UseSTL) {
                import(str(STLPath, "SimpleBase.stl"));
            } else {
                // Start with an extruded base plate, with all the relevant holes punched in it
                linear_extrude(BaseThickness)
                    difference() {
                        // Union together all the bits to make the plate
                        hull() {
                            // critical mount points only
                            for (i=[0,1])
                                mirror([i,0,0]) {
                                    // front bumpers
                                    attach(LogoBot_Con_GridFixing(3,4,0), DefConUp) circle(r=5);

                                    // motor
                                    attach(LogoBot_Con_GridFixing(4,2,0), DefConUp) circle(r=5);
                                    attach(LogoBot_Con_GridFixing(4,-2,0), DefConUp) circle(r=5);

                                    // rear bumpers
                                    attach(LogoBot_Con_GridFixing(3,-4,0), DefConUp) circle(r=5);

                                    //caster
                                    attach(LogoBot_Con_GridFixing(0,-6,0), DefConUp) circle(r=5);
                                }

                        }



                        // slots for wheels
                        for (i=[0:1])
                            mirror([i,0,0])
                            translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
                            roundedSquare([WheelThickness + tw, WheelDiameter + tw], (WheelThickness + tw)/2, center=true);



                        // Centre hole for pen
                        circle(r=PenHoleDiameter/2);



                        LogoBotBase_GridHoles();

                        // Remove shell fittings
                        *Shell_TwistLockCutouts();
                    }
            }
    }
}

module LogoBotBase_GridHoles() {

    pitch = 10;
    xn = round((BaseDiameter / pitch)/2) + 1;
    yn = xn;

    for (x=[-xn:xn], y=[-yn:yn]) {
        if (
            circleInCircle(BaseDiameter/2 - dw, x*pitch, y*pitch, PinDiameter/2) &&
            circleOutsideCircle(PenHoleDiameter/2 + dw, x*pitch, y*pitch, PinDiameter/2) &&
            abs(x*pitch) <= BaseDiameter/2 + MotorOffsetX - 1 - dw - PinDiameter/2
        ) {
            translate([x*pitch, y*pitch,0])
                circle(r=PinDiameter/2, $fn=20);
        }

    }

}
