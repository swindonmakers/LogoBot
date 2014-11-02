/*

StepperMotor28YBJ48() 

Created for the LogoBot project

*/

StepperMotor28YBJ48_Con_Axle =[[0,0,0], [0,0,-1],0,0,0];
StepperMotor28YBJ48_Con_FlangeLeft =[[17,-5,4.27],[0,0,1],0,0,0];
StepperMotor28YBJ48_Con_FlangeRight =[[-17,-5,4.27],[0,0,1],0,0,0];
module StepperMotor28YBJ48() {
	motor_shaft_r=5/2;
	motor_shaft_h=8.27;
	motor_flange_h = 1;
	motor_flange_r = 9.20/2;
	Motor_body_r = 28.09/2;
	Motor_body_h = 19.24;
	
	connector(StepperMotor28YBJ48_Axle);
	connector(StepperMotor28YBJ48_Con_FlangeLeft);
	connector(StepperMotor28YBJ48_Con_FlangeRight);
	difference() {
			color("grey")
			cylinder(r=motor_shaft_r, h=motor_shaft_h, center=true);
		
		///add some flats
		translate([-5,1,-5])
			cube([10,5,6.27]);
				
		mirror([0,1,0]) {
			translate([-5,1,-5])
				cube([55,5,6.27]);
		}
	}
	
	
	//Axle
	translate([0,0,motor_shaft_h/2]) 
		color("yellow")
		cylinder(r=motor_flange_r, h=motor_flange_h, center=true);
						
	// Main Body
	translate([0,-7,14])
		color("silver")
		cylinder(r=Motor_body_r, h=Motor_body_h, center=true);
							
	//Flanges
		
		translate([10,-8.5,4.27])	
			difference() {
				cube([7,7,1]);
				translate([7,3.5,-5])
				cylinder(r=1.75, h=10);
			}
			
			translate([17,-5,4.27])
				difference() {
					cylinder(r=3.5, h=1);
					translate([0,0,-3]){
						cylinder(r=1.75, h=5);
					}
				}
												
			mirror([1,0,0]) {
				translate([10,-8.5,4.27])	
				difference() {
					cube([7,7,1]);
					translate([7,3.5,-5])
					cylinder(r=1.75, h=10);
				}
			
				translate([17,-5,4.27])
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


// Usage
 
