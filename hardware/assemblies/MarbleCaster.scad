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

MarbleCaster_BallRadius = 16/2;


// Connectors
// ----------

// Connector: MarbleCastor_Con_Default
// Default connector for <MarbleCaster>
MarbleCastor_Con_Default				= [ [0,0,0], [0,0,1], 0, BaseThickness, 10];


function MarbleCastor_Con_Ball(GroundClearance) = [ 
    [0,0, -GroundClearance + MarbleCaster_BallRadius], 
    [0,0,1], 
    0, BaseThickness, 10
];


module MarbleCasterAssembly () {

    Assembly("MarbleCaster");

	ballr = MarbleCaster_BallRadius;
	
	// debug coordinate frame?
	if (DebugCoordinateFrames) {
		frame();
	}
	
	// debug connectors?
	if (DebugConnectors) {
		connector(MarbleCastor_Con_Default);
	}
	
	// STL
	MarbleCaster_STL();
	
 	
	// caster ball
	step(1, 
            "Insert the marble into the printed housing", 
            "300 200 0.67 0 -15 108 0 91 261")
	    attach(MarbleCastor_Con_Ball(GroundClearance), Marble_Con_Default, ExplodeSpacing = 16)
		Marble(Marble_16mm);
		
	End("MarbleCaster");
}


module MarbleCaster_STL () {
	od = connector_bore(MarbleCastor_Con_Default) - 0.5;  // include some tolerance!
	fod = od + 3;
	ballr = 16/2;
	
	plateThickness = connector_thickness(MarbleCastor_Con_Default);
	
	balltol = 0.5;
	
	$fn=64;
	
	STL("MarbleCaster");
	
	color(Level2PlasticColor)
	    if (UseSTL) {
	        import(str(STLPath, "MarbleCaster.stl"));
	    } else {
            //render() // pre-render for speed
            difference() {
                union()  {
                    // push fitting core
                    cylinder(r=od/2, h=plateThickness+eta);
            
                    // push fitting upper taper
                    translate([0, 0, plateThickness + 1])
                        cylinder(r1=od/2 + 0.5, r2=od/2 - 1, h= dw + 1);
                
                    // push fitting lower taper
                    translate([0, 0, plateThickness])
                        cylinder(r1=od/2, r2=od/2 + 0.5, h=1 + eta);
            
            
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
                    translate([-ballr, -1, eta])
                    cube([2*ballr, 2, 100]);
            
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
}

module MarbleCaster_STL_View() {
    echo("300 200 1.4 .8 -5.6 63.4 0 114 172");
}