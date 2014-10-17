/*
	Assembly: MarbleCasterAssembly
	Model of a printable ball caster, using a standard 16mm marble for the ball
	
	Authors:
		Damian Axford
	
	Local Frame: 
		Centred on the origin, the top edge of the mounting flange lies in XY plane
	
	Parameters:
		GroundClearance - distance from the ground plane to the top of the mounting flange
		
	Returns:
		A Marble Caster assembly, rendered and colored
*/



// Connectors
// ----------

// Connector: MarbleCastor_Con_Default
// Default connector for <MarbleCaster>
MarbleCastor_Con_Default				= [ [0,0,0], [0,0,1], 0, BaseThickness, 10];


module MarbleCasterAssembly ( GroundClearance = 20 ) {

	ballr = 16/2;
	
	// debug coordinate frame?
	if (DebugCoordinateFrames) {
		frame();
	}
	
	// debug connectors?
	if (DebugConnectors) {
		connector(MarbleCastor_Con_Default);
	}
	
	// STL
	MarbleCaster_STL(GroundClearance);
	
 	
	// caster ball
	color([0.7, 0.7, 0.7, 0.5])
		translate([0,0, -GroundClearance + ballr])
		sphere(ballr, $fn=32);
}


module MarbleCaster_STL ( GroundClearance ) {
	od = connector_bore(MarbleCastor_Con_Default) - 0.5;  // include some tolerance!
	fod = od + 3;
	ballr = 16/2;
	
	plateThickness = connector_thickness(MarbleCastor_Con_Default);
	
	balltol = 0.5;
	
	$fn=64;
	
	color(Level2PlasticColor)
 		//render() // pre-render for speed
 		difference() {
			union()  {
				// push fitting core
				cylinder(r=od/2, h=plateThickness+eta);
			
				// push fitting upper taper
				translate([0, 0, plateThickness + 2])
					cylinder(r1=od/2 + 1, r2=od/2 - dw, h= dw + 1);
				
				// push fitting lower taper
				translate([0, 0, plateThickness])
					cylinder(r1=od/2, r2=od/2 + 1, h=2 + eta);
			
			
				//flange
				translate([0, 0, -2])
					cylinder(r=fod/2, h=2 + eta);
			
				// tapered joint between ball casing and flange
				translate([0, 0, -GroundClearance + ballr])
					cylinder(r1=ballr + dw, r2=fod/2, h=GroundClearance - ballr + eta);
			
				// ball casing
				translate([0, 0, -GroundClearance + ballr])
					sphere(r=ballr + dw);
			
			}
			
			// slit the push fitting
			for (i=[0,1])
				rotate([0,0, i*90])
				translate([-ballr, -od/8, eta])
				cube([2*ballr, od/4, 100]);
			
			// chop the bottom off
			translate([-50, -50, -100 - GroundClearance + ballr/2])
				cube([100, 100, 100]);
			
			// hollow the casing for the ball - allow some tolerance
			translate([0,0, -GroundClearance + ballr])
				sphere(ballr + balltol);
				
			// taper the interior to allow for easier printing
			translate([0, 0, -GroundClearance + ballr])
					cylinder(r1=ballr, r2=1, h= GroundClearance - ballr + plateThickness + dw + 2, $fn=32);
			
			// cut a curve into the ball casing to allow flex for the marble to be inserted
			// and so it looks pretty :)
			translate([0, 0, -GroundClearance + ballr/2])
				rotate([0, 90, 0])
				scale([1, 0.5, 1])
				cylinder(r=ballr, h=100, center=true, $fn=16);
				
			// chop it in half for debugging
			*translate([0, -50, -50])
				cube([100,100,100]);
		}		
}