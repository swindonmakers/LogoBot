/*
	STL: LogoBotBase_STL
	
	The printable base plate for the robot.
	
	The _STL suffix denotes this is a printable part, and is used by the bulk STL generating program
	
	Local Frame:
		Base lies on XY plane, centered on origin, front of robot is towards y+
	
	Parameters:
		None
	
	Returns:
		Base plate, rendered and colored
*/

module LogoBotBase_STL() {

    // turn off explosions inside STL!!!
    $Explode = false;
    
    printedPart("printedparts/LogoBotBase.scad", "Base", "LogoBotBase_STL()") {
    
        view(t=[0,0,0], r=[58,0,225], d=681);
    	
        // Color it as a printed plastic part
        color(PlasticColor)
            if (UseSTL) {
                import(str(STLPath, "Base.stl"));
            } else {
                union() {
                    // Start with an extruded base plate, with all the relevant holes punched in it
                    linear_extrude(BaseThickness)
                        difference() {
                            // Union together all the bits to make the plate
                            union() {
                                // Base plate
                                circle(r=BaseDiameter/2);
                            }
                
                            // hole for breadboard
                            attach(LogoBot_Con_Breadboard, Breadboard_Con_BottomLeft(Breadboard_170))
                                difference() {
                                    translate([2,2,0])
                                        square([Breadboard_Width(Breadboard_170)-4, Breadboard_Depth(Breadboard_170)-4]);
                            
                                    // attach mounting points, has the effect of not differencing them
                                    attach(Breadboard_Con_BottomLeft(Breadboard_170),DefCon) {
                                        circle(r=4/2 + dw);
                                        translate([0, -2 - dw, 0])
                                            square([10, 4 + 2*dw]);
                                    }
                                    
                                    attach(Breadboard_Con_BottomRight(Breadboard_170),DefCon) {
                                        circle(r=4/2 + dw);
                                        rotate([0,0,180])
                                            translate([0, -2 - dw, 0])
                                            square([10, 4 + 2*dw]);
                                    }
                                }
                            
                            // mounting holes for breadboard
                            attach(LogoBot_Con_Breadboard, Breadboard_Con_BottomLeft(Breadboard_170)) {
                                attach(Breadboard_Con_BottomLeft(Breadboard_170),DefCon)
                                    circle(r=4.3/2);
                                    
                                attach(Breadboard_Con_BottomRight(Breadboard_170),DefCon)
                                    circle(r=4.3/2);
                            }
                        
                            // weight loss holes under the motor drivers
                            attach(LogoBot_Con_LeftMotorDriver, (ULN2003DriverBoard_Con_UpperLeft))
                                roundedSquare([ULN2003Driver_BoardWidth - 2*ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight - 2*ULN2003Driver_HoleInset], tw);
        
                            // Right Motor Driver
                            attach(LogoBot_Con_RightMotorDriver, (ULN2003DriverBoard_Con_UpperRight))
                                roundedSquare([ULN2003Driver_BoardWidth - 2*ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight - 2*ULN2003Driver_HoleInset], tw);

                            // slots for wheels
                            for (i=[0:1])
                                mirror([i,0,0])
                                translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
                                rotate([-90, 0, 90]) {
                                    translate([-1,0,0])
                                        roundedSquare([WheelThickness + tw, WheelDiameter + tw], (WheelThickness + tw)/2, center=true);
                                }
                            
                            // weight loss under battery pack
                            translate([-57/2, -45])
                                roundedSquare([57, 30], tw);
        
                            // Centre hole for pen
                            circle(r=PenHoleDiameter/2);
    
                            // Chevron at the front so we're clear where the front is!
                            translate([0, BaseDiameter/2 - 10, 0])
                                Chevron(width=10, height=6, thickness=3);
                
                            // Caster
                            //   Example of using attach to punch an appropriate fixing hole
                            attach(LogoBot_Con_Caster, MarbleCaster_Con_Default)
                                circle(r = connector_bore(MarbleCaster_Con_Default) / 2);
    
            
            
                            // A load of fixing holes around the edge...  just as an example of how to do it
                            // NB: This is one of the examples we discussed during the wk1 session
                            // TODO: Decide if we want these back...
                            *for (i=[0:9])
                                rotate([0, 0, i * 360/10])
                                translate([BaseDiameter/2 - 5, 0, 0])
                                circle(r=4.3/2);  // M4 fixing holes
                            
                            // Remove shell fittings
                            Shell_TwistLockCutouts();
                        }
                    
                    // Now union on any other bits (i.e. sticky-up bits!)
                
                    // clips for the motors
                    LogoBotBase_MotorClips();
                
                    LogoBotBase_MotorDriverPosts();
                
                    
                }
            }
    }
}


module LogoBotBase_MotorClips() {
    // TODO: feed these local variables from the motor vitamin global vars
    mbr = 28/2;  // motor body radius
    mao = 8;     // motor axle offset from centre of motor body
    mth = 7;     // motor tab height

    // clips
    for (i=[0:1], j=[0,1])
        mirror([i,0,0])
        translate([BaseDiameter/2 + MotorOffsetX - 6 - j*12, 0, MotorOffsetZ + mao])
        rotate([-90, 0, 90])
        rotate([0,0, 0])
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
                            sector2D(r=mbr+30, a=120);
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

module LogoBotBase_MotorDriverPosts() {
    // mounting posts for motor drivers
    // using a mirror because the layout is symmetrical
        
    for (i=[0,1])
        mirror([i,0,0])
            for (j=[0:3])
                attach(offsetConnector(LogoBot_Con_RightMotorDriver, [0,0,-LogoBot_Con_RightMotorDriver[0][2]]), 
                        ULN2003DriverBoard_Cons[j],
                        $Explode=false)
                LogoBotBase_MountingPost(r1=(ULN2003Driver_HoleDia+2)/2, h1 = LogoBot_Con_RightMotorDriver[0][2], r2=ULN2003Driver_HoleDia/2, h2=3);
}

module LogoBotBase_MountingPost(r1=5/2, h1=3, r2=3/2, h2=3) {
    cylinder(r=r1, h=h1);
    translate([0,0,h1-eta])
        cylinder(r1=r2, r2=r2 * 0.7, h=h2 +eta);
}