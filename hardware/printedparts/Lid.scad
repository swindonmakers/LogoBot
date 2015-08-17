module Lid_STL() {

    printedPart("printedparts/Lid.scad", "Lid", "Lid_STL()") {

        markdown("guide","Includes built-in support material which should easily break out after printing");

        view(t=[0,0,0], r=[58,0,225], d=180);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) connector(Wheel_Con_Default);

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "Lid.stl"));
            } else {
                Lid_Model();
            }
        }
    }
}

module domeSupportSegment(radius=100, inset=0, thickness=1, supportAngle=45) {
    insetAng = asin(inset/radius);
    theta = 180 - 2*supportAngle - 2*insetAng;

    sh = segmentHeight(radius,theta);

    if (sh > 2)
        rotate([0,0,90 - theta - insetAng])
        translate([0,0,-thickness/2])
        linear_extrude(thickness)
        circularSegment(radius,theta);
}


module Lid_Model()
{
    sw = dw;

    or = BaseDiameter/2 + Shell_NotchTol + dw;

    sr = or - sw + eta;

    supportAngle = 50;
    bridgeDist = 6;

    numRibs1 = round(circumference(sr * cos(supportAngle)) / bridgeDist);
    numRibs = 4 * (floor(numRibs1 / 4) + 1);

    ribThickness = 0.7;

    $fn=64;

    clearance = 0.3;

    //render()
    translate([0,0,-ShellOpeningHeight])
        difference() {
            union() {

                // Swindon Hackspace Logo
                // S
                render()
                intersection() {
                    translate([0,0,50])
                        scale([0.3,0.3,2])
                        import(str(STLPath,"../snhack_logo_s.stl"));

                    // outer shell
                    rotate_extrude()
                        donutSector(
                            or=or+1,
                            ir=or-1,
                            a=90
                        );
                }

                // H
                render()
                intersection() {
                    translate([0,0,50])
                        scale([0.3,0.3,1])
                        import(str(STLPath,"../snhack_logo_H.stl"));

                    // outer shell
                    rotate_extrude()
                        donutSector(
                            or=or+1.5,
                            ir=or-1,
                            a=90
                        );
                }


                // dome
                rotate_extrude()
                    difference() {
                        // outer shell
                        donutSector(
                            or=or,
                            ir=BaseDiameter/2 + Shell_NotchTol,
                            a=90
                        );

                        // opening for lid, as a 45 degree chamfer starting at ShellOpeningDiameter and sloping inwards
                        // less fitting clearance
                        polygon(
                            [
                                [ShellOpeningDiameter/2 - dw - 1 - clearance, ShellOpeningHeight - dw - 1],
                                [ShellOpeningDiameter/2 + 1000, ShellOpeningHeight + 1000],
                                [BaseDiameter, 0],
                                [0,0],
                                [0, ShellOpeningHeight - dw - 1],

                            ]);
                    }


                // skirt
                translate([0,0, ShellOpeningHeight])
                    tube(or=ShellOpeningDiameter/2+dw - dw*cos(45) - clearance, ir=ShellOpeningDiameter/2- dw*cos(45), h=2*dw);



                // ribs
                intersection() {
                    union() {
                        // large support ribs
                        for (i=[0:numRibs/4])
                            rotate([0,0,i*360/(numRibs/4)])
                            rotate([90,0,0])
                            domeSupportSegment(sr, 0, ribThickness, supportAngle);

                        // medium support ribs
                        for (i=[0:numRibs/4])
                            rotate([0,0,i*360/(numRibs/4) + 360/(numRibs/2)])
                            rotate([90,0,0])
                            domeSupportSegment(sr, 0 + 2*bridgeDist, ribThickness, supportAngle);

                        // small support ribs
                        for (i=[0:numRibs/2])
                            rotate([0,0,i*360/(numRibs/2) + 360/(numRibs)])
                            rotate([90,0,0])
                            domeSupportSegment(sr, 0 + 4*bridgeDist, ribThickness, supportAngle);
                    }

                    cylinder(r=ShellOpeningDiameter/2, h=BaseDiameter);

                }


                // nubbins to snap fit the lid into the shell

                for (i=[0:2])
                    rotate([0,0,i*360/3])
                    translate([ShellOpeningDiameter/2+dw - dw*cos(45) - clearance, 0, ShellOpeningHeight-dw])
                    rotate([90,0,0])
                    translate([0,0,-dw/2])
                    linear_extrude(dw)
                    polygon([
                        [0,0],
                        [0,dw+1],
                        [dw/2,dw/2],
                        [0,0]
                    ]);



            }

            // trim off bottom
            translate([-500,-500,-1000 + ShellOpeningHeight - dw])
                cube([1000,1000,1000]);
        }
}
