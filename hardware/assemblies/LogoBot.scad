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

function LogoBotAssembly_NumSteps() = PenLift ? 10 : 9;

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
	
		// Motor + Wheel assemblies (x2)
		step(3, "Connect the two wheel assemblies", "400 300 -6 7 19 64 1 212 625")
		for (i=[0:1])
			mirror([i,0,0])
			translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
			rotate([-90, 0, 90]) {
				WheelAssembly();
			}
		
		step(4, "Push the two motor drivers onto the mounting posts", "400 300 -6 7 19 64 1 212 625") {
		    // Left Motor Driver
		    attach(LogoBot_Con_LeftMotorDriver, ULN2003DriverBoard_Con_UpperLeft, ExplodeSpacing=-20)
			    ULN2003DriverBoard();
		
		    // Right Motor Driver
		    attach(LogoBot_Con_RightMotorDriver, ULN2003DriverBoard_Con_UpperRight, ExplodeSpacing=-20)
			    ULN2003DriverBoard();
		}
	
		// Battery assembly
		step(5, "Clip in the battery pack", "400 300 -6 7 19 64 1 212 625")
		    translate([-25, -45, 12])
			rotate([90, 0, 90])
			battery_pack_double(2, 4);
	
		// Power Switch
	
		// LED
		step(6, "Clip the LED into place", "400 300 -6 7 19 64 1 212 625")
		    translate([0, -10, BaseDiameter/2]) 
			LED();
		
		// Piezo
		step(7, "Clip the piezo sounder into place", "400 300 -6 7 19 64 1 212 625")
		    translate([-37, -32, 10])
			murata_7BB_12_9();
	
	
		// Caster
		//   Example of using attach
		// TODO: Correct ground clearance!
		step(8, "Push the caster assembly into the base so that it snaps into place", 
		    "400 300 -6 7 19 115 1 26 625")
		    attach(LogoBot_Con_Caster, MarbleCastor_Con_Default, Explode=Explode, ExplodeSpacing=15)
			MarbleCasterAssembly();
		
			
		// Conditional Design Elements
		// ---------------------------
			
		// PenLift
		//   Placeholder of a micro servo to illustrate having conditional design elements
		if (PenLift) {
			// TODO: wrap into a PenLift sub-assembly
			step(10, "Fit the pen lift assembly", "400 300 -6 7 19 64 1 212 625")
			    attach( LogoBot_Con_PenLift, MicroServo_Con_Horn, Explode=Explode )
				MicroServo();
		}
		
		
		// Shell + fixings
		step(PenLift ? 10 : 9, 
		    "Push the shell down onto the base and twist to lock into place", 
		    "400 400 11 -23 65 66 0 217 1171")
	        attach(DefConDown, DefConDown, ExplodeSpacing=BaseDiameter/2)
	        ShellAssembly();
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

                        // slots for wheels
                        for (i=[0:1])
                            mirror([i,0,0])
                            translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
                            rotate([-90, 0, 90]) {
                                translate([-1,0,0])
                                    square([WheelThickness + tw, WheelDiameter], center=true);
                            }
        
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
                
                // mounting posts for motor drivers
                // left driver example
                // TODO: Replace this with a loop
                attachWithOffset(LogoBot_Con_LeftMotorDriver, ULN2003DriverBoard_Con_UpperLeft, [0,0, -LogoBot_Con_LeftMotorDriver[0][2]])
                    LogoBotBase_MountingPost(r1=(ULN2003Driver_HoleDia+2)/2, h1 = LogoBot_Con_LeftMotorDriver[0][2], r2=ULN2003Driver_HoleDia/2, h2=3);
                
                
                    
            }
        }
}



module LogoBotBase_MountingPost(r1=5/2, h1=3, r2=3/2, h2=3) {
    cylinder(r=r1, h=h1);
    translate([0,0,h1-eta])
        cylinder(r1=r2, r2=r2 * 0.7, h=h2 +eta);
}