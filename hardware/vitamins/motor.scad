
/*

StepperMotor28YBJ48()

Created for the LogoBot project

*/

StepperMotor28YBJ48_Body_OR = 28/2;
StepperMotor28YBJ48_Body_Depth = 19.1;


StepperMotor28YBJ48_Con_Axle =[[0,0,0], [0,0,-1],0,0,0];
StepperMotor28YBJ48_Con_FlangeLeft =[[17.5,-8,4.27],[0,0,1],0,0,0];
StepperMotor28YBJ48_Con_FlangeRight =[[-17.5,-8,4.27],[0,0,1],0,0,0];


StepperMotor28YBJ48_Con_Body =[[0, -8, 4.4], [0,0,-1], 0,0,0];


module StepperMotor28YBJ48() {
	motor_shaft_r=5/2;
	motor_shaft_h=8.27;
	motor_flange_h = 1;
	motor_flange_r = 9.20/2;
	Motor_body_r = StepperMotor28YBJ48_Body_OR;
	Motor_body_h = StepperMotor28YBJ48_Body_Depth;


	vitamin("vitamins/motor.scad", "28YBJ48 Stepper Motor","StepperMotor28YBJ48()") {
		view(r=[170,334,0],d=140);
	}

	if (DebugConnectors) {
		connector(StepperMotor28YBJ48_Con_Axle);
		connector(StepperMotor28YBJ48_Con_FlangeLeft);
		connector(StepperMotor28YBJ48_Con_FlangeRight);
	}

	// Shaft
	difference() {
			color("grey")
			cylinder(r=motor_shaft_r, h=motor_shaft_h, center=true);

		///add some flats
		for (i=[0,1])
			mirror([0,i,0])
			translate([-5,1.5,-5])
			cube([55,5,6.27]);

	}


	//Axle
	translate([0,0,motor_shaft_h/2])
		color("yellow")
		cylinder(r=motor_flange_r, h=motor_flange_h, center=true);

	// Main Body
	translate([0,-8,14])
		color("silver")
		cylinder(r=Motor_body_r, h=Motor_body_h, center=true);

	//Flanges
	for (i=[0,1])
		mirror([i,0,0]) {
			translate([10,-11.5,4.27])
				difference() {
					cube([7,7,1]);
					translate([7.5,3.5,-5])
						cylinder(r=1.75, h=10);
				}

			translate([17.5,-8,4.27])
				difference() {
					cylinder(r=3.5, h=1);
					translate([0,0,-3]){
						cylinder(r=1.75, h=5);
					}
				}
		}





	//bottom
	color("blue")
		translate([-7.25,-22.5,4.27])
		cube([14.5,5,19.24]);
}
