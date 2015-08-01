/*
    Clip to hold the stepper motor and driver board, mates to base plate using the pin system.

    Local Frame:
        TBC

*/

MotorClip_DriverOffsetX = 20;
MotorClip_DriverOffsetZ = 8;

// Connectors
// connector for where the motor attaches...
Wheel_Con_Default				= [ [0, 0 ,2], [0, 0, 1], 90, 0, 0 ];

MotorClip_Con_Fixing1 = [[20, MotorOffsetZ - dw, 14], [0,1,0], 0,0,0];
MotorClip_Con_Fixing2 = [[-20, MotorOffsetZ -dw, 14], [0,1,0], 0,0,0];

// inner fixing holes
MotorClip_Con_Fixing3 = [[10, MotorOffsetZ - dw, 14], [0,1,0], 0,0,0];
MotorClip_Con_Fixing4 = [[-10, MotorOffsetZ -dw, 14], [0,1,0], 0,0,0];

MotorClip_Con_Motor = [[0, 0, 4.5], [0,0, 1], 0,0,0];

MotorClip_Con_Driver = [[-MotorClip_DriverOffsetX, 1, MotorClip_DriverOffsetZ], [1, 0, 0], 0,0,0];


module MotorClip_STL() {

    // turn off explosions inside STL!!!
    $Explode = false;

    printedPart("printedparts/MotorClip.scad", "Motor Clip", "MotorClip_STL()") {

        // TODO: Update view
        view(t=[0,0,0], r=[58,0,225], d=681);

        // Color it as a printed plastic part
        color(PlasticColor)
            if (UseSTL) {
                import(str(STLPath, "MotorClip.stl"));
            } else {
                MotorClip_Model();
            }
    }
}

module MotorClip_Model() {
    if (DebugConnectors) {
        // motor shaft
        connector(DefConDown);

        connector(MotorClip_Con_Fixing1);
        connector(MotorClip_Con_Fixing2);

        connector(MotorClip_Con_Driver);
    }

    difference() {
        // solid stuff
        union() {
            // plate for front of motor
            attach(MotorClip_Con_Motor, DefConDown)
                hull() {
                    // central disc
                    cylinder(r=MotorOffsetZ-dw, h=dw);

                    // fixing to base plate
                    translate([-10, MotorOffsetZ - 2*dw,0])
                        cube([20,dw, dw]);
                }

            // motor retaining clip
            attach(MotorClip_Con_Motor, DefConDown)
                attach(StepperMotor28YBJ48_Con_Body, DefConUp)
                    translate([0,0,2])
                    rotate([0,0,-10])
                    sector3D(r=StepperMotor28YBJ48_Body_OR + dw, a=200, h=StepperMotor28YBJ48_Body_Depth + 2*dw, center=false);


            // base plate
            hull () {
                // pins
                attach(MotorClip_Con_Fixing1, DefConDown) {
                    cylinder(r=12/2, h=dw);
                }

                attach(MotorClip_Con_Fixing2, DefConDown) {
                    cylinder(r=12/2, h=dw);
                }

                // mating join to front plate
                attach(MotorClip_Con_Motor, DefConDown)
                    translate([-10, MotorOffsetZ - 2*dw,0])
                    cube([20, dw, dw]);

                // mating to driver holder?
            }


            // driver holder
            translate([-MotorClip_DriverOffsetX  -2*dw, MotorOffsetZ - 2*dw, MotorClip_DriverOffsetZ-4])
                cube([3*dw, dw, ULN2003Driver_BoardWidth]);

            // outer post
            translate([-MotorClip_DriverOffsetX  -2*dw, MotorOffsetZ - dw - 12, MotorClip_DriverOffsetZ-4])
                cube([3*dw, 12, 4]);

            // inner post
            translate([-MotorClip_DriverOffsetX  -2*dw, MotorOffsetZ - dw - 20, MotorClip_DriverOffsetZ-5.5  + ULN2003Driver_BoardWidth])
                cube([3*dw, 20, 4]);



        }


        // pin fixings
        attach(MotorClip_Con_Fixing1, DefConDown)
            cylinder(r=PinDiameter/2, h=10, center=true);

        attach(MotorClip_Con_Fixing2, DefConDown)
            cylinder(r=PinDiameter/2, h=10, center=true);

        attach(MotorClip_Con_Fixing3, DefConDown)
            cylinder(r=PinDiameter/2, h=30, center=true);

        attach(MotorClip_Con_Fixing4, DefConDown)
            cylinder(r=PinDiameter/2, h=30, center=true);

        attach(MotorClip_Con_Motor, DefConDown) {
            // hollow for motor boss
            cylinder(r=5, h=100, center=true);

            // motor boss/shaft insertion channel
            translate([-10/2, -100, -50])
                cube([10, 100, 100]);


            // hollow for motor body
            attach(MotorClip_Con_Motor, DefConDown)
                attach(StepperMotor28YBJ48_Con_Body, DefConDown)
                cylinder(r=StepperMotor28YBJ48_Body_OR, h=StepperMotor28YBJ48_Body_Depth + 0.5, center=false);

            // hollow for motor tabs
            translate([0,-8, -0.5])
                cube([100, 7, 1.5], center=true);
        }



        // hollow for driver board
        attach(MotorClip_Con_Driver, ULN2003DriverBoard_Con_UpperLeft)
            ULN2003DriverBoard_PCB(false, 2);
    }
}


module OldClip() {
    // TODO: feed these local variables from the motor vitamin global vars
    mbr = 28/2;  // motor body radius
    mao = 8;     // motor axle offset from centre of motor body
    mth = 7;     // motor tab height

    linear_extrude(5) {
        difference() {
            union() {

                difference() {
                    hull() {
                        // main circle
                        circle(r=mbr + dw);

                        // extension to correctly union to the base plate
                        translate([-(mbr * 1.5)/2,  MotorOffsetZ + mao -1,0])
                            square([mbr * 1.5, 1]);
                    }

                    // trim the top off
                    rotate([0,0,180 + 30])
                        sector(r=mbr+30, a=120);
                }

                // welcoming hands
                for (k=[0,1])
                    mirror([k,0,0])
                    rotate([0,0,180+30])
                    translate([mbr, -dw, 0])
                    polygon([[1.5,0],[4,5],[3,5],[0,dw]],4);
            }

            // hollow for the motor
            circle(r=mbr);

        }
    }
}
