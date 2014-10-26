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

LogoBot_Con_Breadboard          = [[0, 12, 0],[0,0,-1], -90,0,0];

LogoBot_Con_LeftMotorDriver     = [[-20, 16, 3],[0,0,1],180,0,0];
LogoBot_Con_RightMotorDriver    = [[20, 16, 3],[0,0,1],180,0,0];

LogoBot_Con_Caster = [ [0, -BaseDiameter/2 + 10, 0], [0,0,1], 0, 0, 0];

LogoBot_Con_PenLift = [ [-20, -5, 10], [0,1,0], 0, 0, 0];


// Assembly
// --------

function LogoBotAssembly_NumSteps() = 10 + (PenLift ? 1 : 0);

module LogoBotAssembly ( PenLift=false ) {

    Assembly("LogoBot");

	translate([0, 0, GroundClearance]) {
	
		// Default Design Elements
		// -----------------------
	
		// Base
		LogoBotBase_STL();

        step(1, 
            "Connect the breadboard assembly to the underside of the base", 
            "400 300 0 17 12 112 0 222 513")
		    attach(LogoBot_Con_Breadboard, Breadboard_Con_BottomLeft(Breadboard_170), ExplodeSpacing=-20)
		    BreadboardAssembly();
	
		// Bumper assemblies (x2)
		step(2, "Connect the two bumper assemblies", "400 300 -6 7 19 64 1 212 625" )
		    for (x=[0,1], y=[0,1])
			mirror([0,y,0])
			mirror([x,0,0])
			translate([(BaseDiameter/2-10) * cos(45), (BaseDiameter/2-10) * sin(45), -8 ])
			rotate([0,0,-30])
			MicroSwitch();
			
		step(3, "Push the two motor drivers onto the mounting posts", "400 300 -6 7 19 64 1 212 625") {
		    // Left Motor Driver
		    attach(LogoBot_Con_LeftMotorDriver, invertConnector(ULN2003DriverBoard_Con_UpperLeft), ExplodeSpacing=-20)
			    ULN2003DriverBoard();
		
		    // Right Motor Driver
		    attach(LogoBot_Con_RightMotorDriver, invertConnector(ULN2003DriverBoard_Con_UpperRight), ExplodeSpacing=-20)
			    ULN2003DriverBoard();
		}
	
		// Motor + Wheel assemblies (x2)
		step(4, "Clip the two wheels assemblies onto the base and connect the motor leads to the the motor drivers", "400 300 -4 6 47 66 0 190 740")
            for (i=[0:1])
                mirror([i,0,0])
                translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
                translate([-15,0,0])
                attach(DefConDown, DefConDown, ExplodeSpacing = 40)
                translate([15,0,0])
                rotate([-90, 0, 90]) {
                    assign($rightSide= i == 0? 1 : 0)
                        WheelAssembly();
                }
		
		// Connect jumper wires
		step(5, 
		    "Connect the jumper wires between the motor drivers and the Arduino", 
		    "400 300 9 26 54 38 0 161 766")
		    {
		        // TODO: Insert appropriate connectors
		        JumperWire(
                    type = JumperWire_FM4,
                    con1 = [[34,43,10], [0,0,-1], 0,0,0],
                    con2 = [[11.5,31.5, -6], [0,0,-1], 0,0,0],
                    length = 70,
                    conVec1 = [1,0,0],
                    conVec2 = [0,-1,0],
                    midVec = [0.5,-1,0]
                );
                
                // TODO: Insert appropriate connectors
		        JumperWire(
                    type = JumperWire_FM4,
                    con1 = [[-31.5,43,10], [0,0,-1], 0,0,0],
                    con2 = [[-9,31.5, -6], [0,0,-1], 0,0,0],
                    length = 70,
                    conVec1 = [1,0,0],
                    conVec2 = [0,-1,0],
                    midVec = [0,0,-1]
                );
		    
		    }
	
		// Battery assembly
		step(6, "Clip in the battery pack", "400 300 -6 7 19 64 1 212 625")
		    translate([-25, -45, 12])
			rotate([90, 0, 90])
			battery_pack_double(2, 4);
	
		// Power Switch
	
		// LED
		step(7, "Clip the LED into place", "400 300 -6 7 19 64 1 212 625")
		    translate([0, -10, BaseDiameter/2]) 
			LED();
		
		// Piezo
		step(8, "Clip the piezo sounder into place", "400 300 -6 7 19 64 1 212 625")
		    translate([-37, -32, 10])
			murata_7BB_12_9();
	
	
		// Caster
		//   Example of using attach
		// TODO: Correct ground clearance!
		step(9, "Push the caster assembly into the base so that it snaps into place", 
		    "400 300 -6 7 19 115 1 26 625")
		    attach(LogoBot_Con_Caster, MarbleCastor_Con_Default, ExplodeSpacing=15)
			MarbleCasterAssembly();
		
			
		// Conditional Design Elements
		// ---------------------------
			
		// PenLift
		//   Placeholder of a micro servo to illustrate having conditional design elements
		if (PenLift) {
			// TODO: wrap into a PenLift sub-assembly
			step(10, "Fit the pen lift assembly", "400 300 -6 7 19 64 1 212 625")
			    attach( LogoBot_Con_PenLift, MicroServo_Con_Horn)
				MicroServo();
		}
		
		
		// Shell + fixings
		step(PenLift ? 11 : 10, 
		    "Push the shell down onto the base and twist to lock into place", 
		    "400 400 11 -23 65 66 0 217 1171")
	        attach(DefConDown, DefConDown, ExplodeSpacing=BaseDiameter/2)
	        BasicShell_STL();
	}
	
	End("LogoBot");
}



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

    STL("LogoBotBase");
    
    // turn off explosions inside STL!!!
    $Explode = false;
	
	// Color it as a printed plastic part
	color(PlasticColor)
	    if (UseSTL) {
	        import(str(STLPath, "LogoBotBase.stl"));
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
                        attach(LogoBot_Con_LeftMotorDriver, invertConnector(ULN2003DriverBoard_Con_UpperLeft))
                            roundedSquare([ULN2003Driver_BoardWidth - 2*ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight - 2*ULN2003Driver_HoleInset], tw);
		
		                // Right Motor Driver
		                attach(LogoBot_Con_RightMotorDriver, invertConnector(ULN2003DriverBoard_Con_UpperRight))
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
                        attach(LogoBot_Con_Caster, PlasticCastor_Con_Default)
                            circle(r = connector_bore(PlasticCastor_Con_Default) / 2);
    
            
            
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

module LogoBotBase_STL_View() {
    echo("400 300 0 0 0 58 0 225 681");
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
    // left driver example
    // TODO: Replace this with a loop
    // using a mirror because the layout is symmetrical
    for (i=[0,1])
        mirror([i,0,0])
        attach(
            offsetConnector(invertConnector(LogoBot_Con_LeftMotorDriver), [0,0, -LogoBot_Con_LeftMotorDriver[0][2]]), 
            ULN2003DriverBoard_Con_UpperLeft) 
        {
            // Now we're inside the driver boards local coordinate system, which is relative to the LowerLeft mount point.
            // To position things relative to the local frame, we need to "reverse" attach them by swapping the order
            // of the connectors.
            attach(ULN2003DriverBoard_Con_UpperLeft, ULN2003DriverBoard_Con_LowerLeft)
                LogoBotBase_MountingPost(r1=(ULN2003Driver_HoleDia+2)/2, h1 = LogoBot_Con_LeftMotorDriver[0][2], r2=ULN2003Driver_HoleDia/2, h2=3);
   
            attach(ULN2003DriverBoard_Con_UpperRight, ULN2003DriverBoard_Con_LowerLeft) 
                 LogoBotBase_MountingPost(r1=(ULN2003Driver_HoleDia+2)/2, h1 = LogoBot_Con_LeftMotorDriver[0][2], r2=ULN2003Driver_HoleDia/2, h2=3);
            
            attach(ULN2003DriverBoard_Con_LowerRight, ULN2003DriverBoard_Con_LowerLeft) 
                 LogoBotBase_MountingPost(r1=(ULN2003Driver_HoleDia+2)/2, h1 = LogoBot_Con_LeftMotorDriver[0][2], r2=ULN2003Driver_HoleDia/2, h2=3);
             
            // the lower left post doesn't need translating
            LogoBotBase_MountingPost(r1=(ULN2003Driver_HoleDia+2)/2, h1 = LogoBot_Con_LeftMotorDriver[0][2], r2=ULN2003Driver_HoleDia/2, h2=3);
        }
}

module LogoBotBase_MountingPost(r1=5/2, h1=3, r2=3/2, h2=3) {
    cylinder(r=r1, h=h1);
    translate([0,0,h1-eta])
        cylinder(r1=r2, r2=r2 * 0.7, h=h2 +eta);
}