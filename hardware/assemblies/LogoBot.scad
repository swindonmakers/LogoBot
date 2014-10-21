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


module LogoBotAssembly ( PenLift=false ) {
	
	// TODO: needs to be translated up to correct height
	translate([0, 0, 0]) {
	
		// Default Design Elements
		// -----------------------
	
		// Base
		LogoBotBase_STL();
	
		// Bumper assemblies (x2)
	
		// Motor + Wheel assemblies (x2)
		
		// Arduino
		
		// Motor Drivers
	
		// Battery assembly
	
		// Power Switch
	
		// LED
		
		// Piezo
	
		// Shell + fixings
	
	
	
		// Caster
		//   Example of using attach
		// TODO: Insert correct ground clearance!
		attach(Base_Con_Caster, MarbleCastor_Con_Default)
			MarbleCasterAssembly( GroundClearance = 20);
		
			
		// Conditional Design Elements
		// ---------------------------
			
		// PenLift
		//   Placeholder of a micro servo to illustrate having conditional design elements
		if (PenLift) {
			// TODO: wrap into a PenLift sub-assembly
			attach( Base_Con_PenLift, MicroServo_Con_Horn )
				MicroServo();
		}
	}
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
	
	// Color it as a printed plastic part
	color(PlasticColor)
		// Pre-render to speed editing and avoid overloading the cache
		render()
		// Extrude to correct thickness
		linear_extrude(BaseThickness)
		difference() {
			// Union together all the bits to make the plate
			union() {
				// Base plate
				circle(r=BaseDiameter/2);
			}
			
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