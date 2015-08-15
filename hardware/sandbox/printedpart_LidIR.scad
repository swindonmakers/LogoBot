include <../config/config.scad>
UseSTL=false;
UseVitaminSTL=true;
DebugConnectors=false;
DebugCoordinateFrames=false;

//BasicShell_STL();

LogoBotBase_STL();
attach(Shell_Con_Lid, DefConDown) {
	render() 
		LidIR_STL();

	//rotate([0, 0, 90])
	attach(LidIR_Con_Servo, MicroServo_Con_Horn) {
		MicroServo();
		attach(MicroServo_Con_Horn, ServoHorn_Con_Default)
			ServoHorn();
	}
}


translate([0, (7.1+4.4)/2, 76])
rotate([90, 0, 0])
	Sharp2Y0A21();

/*
module ServoSharp2Y0A21Bracket()
{
	for (i=[0, 1])
	mirror([i, 0, 0]) {

		// Back
		translate([37/2, 0, 0])
		linear_extrude(1.5)
		difference() {
			hull() {
				circle(d=9.5);
			
				translate([-37/2, -37/2, 0])
					circle(d=10);
			}
			circle(d=3);
		}

		// Middle
		translate([37/2, 0, 1.5])
		linear_extrude(1.5)
		difference() {
			hull () {
				circle(d=9.5);
				translate([-37/2, -37/2, 0])
					circle(d=10);
			}
			circle(d=7.5);
			translate([-15, -4, 0])
				square([15, 10]);
			translate([-15, -7, 0])
				square([11.5, 10]);
			translate([-5, 1, 0])
				square([10, 5]);
		}
	
		// front
		translate([37/2, 0, 3])
		linear_extrude(1.5)
		difference() {
			hull() {
				circle(d=9.5);
				translate([-37/2, -37/2, 0])
					circle(d=10);
			}
			circle(d=3);
			translate([-5, -4, 0])
				square([4, 10]);
			translate([-15, -7, 0])
				square([11.5, 10]);
			translate([-5, 1, 0])
				square([10, 5]);
		}

	}	

	translate([0, 0, 2]) {
		translate([0, -30, 0])
		rotate([-90, 0, 0])
			cylinder(d=6.8, h=10);

		translate([0 ,-20, 0])
			sphere(d=6.8);

		// Servo connector
		translate([0, -30, 0])
		rotate([90, 0, 0])
		linear_extrude(4.5-1.4+eta)
		difference() {
			circle(d=6.8);
			circle(d=4.4);
		}
	}
}
*/