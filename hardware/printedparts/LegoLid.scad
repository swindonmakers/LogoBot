// Connectors

LegoLid_Con_Def = [[0,0,0], [0,0,-1], 0,0,0];


module LegoLid_STL() {

    printedPart("printedparts/LegoLid.scad", "Lego Lid", "LegoLid_STL()") {

        view(t=[0,0,0],r=[72,0,130],d=400);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(LegoLid_Con_Def);
        }

        color(Level3PlasticColor) {
            if (UseSTL) {
                import(str(STLPath, "LegoLid.stl"));
            } else {
                LegoLid_Model();
            }
        }
    }
}


module LegoLid_Model()
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

    FLU = 1.6; // Fundamental Lego Unit = 1.6 mm
    studTol = 0.05;
    studSpacing = 5*FLU;
    studRadius = 1.5*FLU - studTol;
    studHeight = FLU;


    //render()
    translate([0,0,-ShellOpeningHeight])
        union() {
            // studs
            for (x=[-6:6],y=[-6:6]) {
                x1 = x*studSpacing;
                y1 = y*studSpacing;
                if(sqrt(x1*x1 + y1*y1) + FLU < ShellOpeningDiameter/2)
                translate([x1,y1, ShellOpeningHeight+dw-eta + 3*layers])
                cylinder(r=studRadius, h=studHeight, $fn=24);
            }


            // top plate
            rotate_extrude()
                difference() {
                    translate([0,ShellOpeningHeight])
                        square([ShellOpeningDiameter/2 + dw, dw+3*layers]);

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



            // support ribs
            for (i=[0:numRibs])
                rotate([0,0,i*360/(numRibs)])
                translate([-ShellOpeningDiameter/2, -perim/2, ShellOpeningHeight-dw])
                cube([ShellOpeningDiameter/2 - (i%3 * 10), perim, dw+eta]);




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
}
