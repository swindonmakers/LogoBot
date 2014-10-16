/*
	Vitamin: PlasticCaster
	Model of a simple plastic caster
	
	Authors:
		Damian Axford
	
	Local Frame: 
		Centred on the origin, the top edge of the mounting flange lies in XY plane
	
	Parameters:
		None
		
	Returns:
		A Plastic Caster model, rendered and colored
*/


// PlasticCaster Variables

// Variable: PlasticCastor_DistFromFlangeToGround
// Distance from top edge of mounting flange to the bottom of the ball
PlasticCastor_DistFromFlangeToGround	= 15;

// Connectors
//
// Connectors are defined as an array of 5 parameters:
// 0: Translation vector as [x,y,z]
// 1: Vector defining the normal of the connection as [x,y,z]
// 2: Rotation angle for the connection
// 3: Thickness of the mating part - used for bolt holes
// 4: Clearance diameter of the mating hole - used for bolt holes
//

// Connector: PlasticCastor_Con_Default
// Default connector for <PlasticCaster>
PlasticCastor_Con_Default				= [ [0,0,0], [0,0,1], 0, 6, 10];


module PlasticCaster() {

	od = connector_bore(PlasticCastor_Con_Default);
	fod = od + 3;
	ballr = 10/2;
	
	// debug coordinate frame?
	if (DebugCoordinateFrames) {
		frame();
	}
	
	// debug connectors?
	if (DebugConnectors) {
		connector(PlasticCastor_Con_Default);
	}
	
 	//shell
 	color(White)
 		render() // pre-render for speed
 		difference() {
			union()  {
				// push fitting
				cylinder(r=od/2, h= connector_thickness(PlasticCastor_Con_Default));
			
				//flange
				translate([0, 0, -2])
					cylinder(r=fod/2, h=2);
			
				// ball casing
				translate([0, 0, -PlasticCastor_DistFromFlangeToGround + ballr - 1])
					cylinder(r=ballr + 1, h=PlasticCastor_DistFromFlangeToGround - ballr + 1);
			
			}
			
			// cut a curve into the ball casing so it looks pretty
			translate([0, 0, -PlasticCastor_DistFromFlangeToGround + ballr/2])
				rotate([0, 90, 0])
				cylinder(r=ballr, h=100, center=true);
		}
	
	// caster ball
	color(MetalColor)
		translate([0,0, -PlasticCastor_DistFromFlangeToGround + ballr])
		sphere(ballr);
}