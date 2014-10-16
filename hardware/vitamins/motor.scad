motor_shaft_r=5;
motor_shaft_h=8;
motor_flange_h = 1;
motor_flange_r = 9.20;
Motor_body_r = 28.00;
Motor_body_h = 19.30;

	///rotate object around to Y access
	rotate([90,0,0]){
	// shaft
		color("grey")
	cylinder(r=motor_shaft_r, h=motor_shaft_h, center=true);
		//flange
		translate([0,0,motor_shaft_h/2]) 
			color("yellow")
			cylinder(r=motor_flange_r, h=motor_flange_h, center=true);
			// Main Body
				translate([0,-15,14])///don't understand this 
					color("silver")
			cylinder(r=Motor_body_r, h=Motor_body_h, center=true);
				//Flanges
					translate([35,-15,4.5]){///don't understand this 
					
					cylinder(r=7, h=1);
							translate([-14,-7,0]){
								cube([14.5,14,1]);
							}
					color("white")
					cylinder(r=4, h=1);
						
					}
					translate([-35,-15,4.5]){///don't understand this 
					
					cylinder(r=7, h=1);
						translate([0,-7,0]){
								cube([14.5,14,1]);
							}
								
								color("white")
					cylinder(r=4, h=1);
								
							}
				  //bottom
				color("blue")
				 translate([0-7,-46,4]) 
					  cube([14.5,5.5,Motor_body_h]);  

}
    