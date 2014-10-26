/*

StepperMotor28YBJ48() 

Created for the LogoBot project

*/

module StepperMotor28YBJ48(){
motor_shaft_r=5/2;
motor_shaft_h=8.27;
motor_flange_h = 1;
motor_flange_r = 9.20/2;
Motor_body_r = 28.09/2;
Motor_body_h = 19.24;


	
		// shaft
		
		difference() {
		color("grey");
		cylinder(r=motor_shaft_r, h=motor_shaft_h, center=true);
			///add some flats
				
				translate([-5,2,-4.27])
				cube([10,5,6.27]);
				
				mirror([0,1,0]){
				
				translate([-5,2,-4.27])
				cube([55,5,6.27]);
				}
					}
	
					//flange
					translate([0,0,motor_shaft_h/2]) 
						color("yellow")
						cylinder(r=motor_flange_r, h=motor_flange_h, center=true);
						// Main Body
								translate([0,-7,14])
								color("silver")
								cylinder(r=Motor_body_r, h=Motor_body_h, center=true);
							//Flanges

								translate([10,-8.5,4.27])							
								cube([7,7,1]);


								translate([17,-5,4.27])
								
								difference() {
												cylinder(r=3.5, h=1);
												cylinder(r=1.75, h=1);
												
												}
												
												mirror([1,0,0]){
																translate([10,-8.5,4.27])																									cube([7,7,1]);
																translate([17,-5,4.27])
																difference(){
																			cylinder(r=3.5, h=1);
																			cylinder(r=1.75, h=1);
																			}
																	}
										

										
												//bottom
							       			color("blue")
							      				translate([-7.25,-22.5,4.27]) 
								   				cube([14.5,5,19.24]);  
			
			
}


// Usage
 StepperMotor28YBJ48();
    