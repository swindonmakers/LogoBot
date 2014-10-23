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


module LogoBotAssembly ( PenLift=false, Explode=false ) {

   Assembly("LogoBot");

	// TODO: needs to be translated up to correct height
	translate([0, 0, 20]) {
	
	    
	
		// Default Design Elements
		// -----------------------
	
		// Base
		LogoBotBase_STL();

		attach([[0, 12, 0],[0,0,1], 90,0,0], DefCon)
		    BreadboardAssembly();
	
		// Bumper assemblies (x2)
		for (x=[0,1], y=[0,1])
			mirror([0,y,0])
			mirror([x,0,0])
			translate([(BaseDiameter/2-10) * cos(45), (BaseDiameter/2-10) * sin(45), -8 ])
			rotate([0,0,-30])
			microswitch();
	
		// Motor + Wheel assemblies (x2)
		for (i=[0:1])
			mirror([i,0,0])
			translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
			rotate([-90, 0, 90]) {
				WheelAssembly();
			}
		
		// Left Motor Driver
		attach([[-20, 16, 3],[0,0,1],180,0,0], ULN2003DriverBoard_Con_UpperLeft)
			ULN2003DriverBoard();
		
		// Right Motor Driver
		attach([[20, 16, 3],[0,0,1],180,0,0], ULN2003DriverBoard_Con_UpperRight)
			ULN2003DriverBoard();
	
		// Battery assembly
		translate([-25, -45, 12])
			rotate([90, 0, 90])
			battery_pack_double(2, 4);
	
		// Power Switch
	
		// LED
		translate([0, -10, BaseDiameter/2 - 4]) 
			LED();
		
		// Piezo
		translate([-37, -32, 10])
			murata_7BB_12_9();
	
	
		// Caster
		//   Example of using attach
		// TODO: Correct ground clearance!
		attach(Base_Con_Caster, MarbleCastor_Con_Default, Explode=Explode, ExplodeSpacing=15)
			MarbleCasterAssembly();
		
			
		// Conditional Design Elements
		// ---------------------------
			
		// PenLift
		//   Placeholder of a micro servo to illustrate having conditional design elements
		if (PenLift) {
			// TODO: wrap into a PenLift sub-assembly
			attach( Base_Con_PenLift, MicroServo_Con_Horn, Explode=Explode )
				MicroServo();
		}
		
		
		// Shell + fixings
	    color([0,0,0, 0.3])
			render()
			difference() {
				hull() {
					sphere(BaseDiameter/2);
					
				}
				
				translate([-BaseDiameter, -BaseDiameter, -BaseDiameter*2])
					cube([BaseDiameter*2, BaseDiameter*2, BaseDiameter*2]);
			}
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

// LogoBot Base Connectors
// -----------------------

// Connectors are defined as an array of 5 parameters:
// 0: Translation vector as [x,y,z]
// 1: Vector defining the normal of the connection as [x,y,z]
// 2: Rotation angle for the connection
// 3: Thickness of the mating part - used for bolt holes
// 4: Clearance diameter of the mating hole - used for bolt holes


// Connector: Base_Con_Caster
// Connection point for the caster at back edge of the base plate
Base_Con_Caster = [ [0, -BaseDiameter/2 + 10, 0], [0,0,1], 0, 0, 0];


// Connector: Base_Con_Caster
// Connection point for the caster at back edge of the base plate
Base_Con_PenLift = [ [-20, -5, 10], [0,1,0], 0, 0, 0];



module LogoBotBase_STL() {

    STL("LogoBotBase");
	
	// Color it as a printed plastic part
	color(PlasticColor)
	     if (UseSTL && false) {
	        import(str(STLPath, "LogoBotBase.stl"));
	    } else {
            // Extrude to correct thickness
            linear_extrude(BaseThickness)
            difference() {
                // Union together all the bits to make the plate
                union() {
                    // Base plate
                    circle(r=BaseDiameter/2);
                }
				
				// hole for breadboard
				translate([-Breadboard_Depth(Breadboard_170)/2, 15, -9])
					square([Breadboard_Depth(Breadboard_170), Breadboard_Width(Breadboard_170) - 12]);
            
                // Now punch some holes...
        
                // Centre hole for pen
                circle(r=PenHoleDiameter/2);
    
                // Chevron at the front so we're clear where the front is!
                translate([0, BaseDiameter/2 - 10, 0])
                    Chevron(width=10, height=6, thickness=3);
                
                // Caster
                //   Example of using attach to punch an appropriate fixing hole
                attach(Base_Con_Caster, PlasticCastor_Con_Default)
                    circle(r = connector_bore(PlasticCastor_Con_Default) / 2);
    
            
            
                // A load of fixing holes around the edge...  just as an example of how to do it
                // NB: This is one of the examples we discussed during the wk1 session
                for (i=[0:9])
                    rotate([0, 0, i * 360/10])
                    translate([BaseDiameter/2 - 5, 0, 0])
                    circle(r=4.3/2);  // M4 fixing holes
            }
        }
}