module logo_motor(motor_rotation_x=0, motor_rotation_y=0, motor_rotation_z=0){
motor_shaft_r=5;
motor_shaft_h=8.27;
motor_flange_h = 1;
motor_flange_r = 9.20;
Motor_body_r = 28.09;
Motor_body_h = 19.24;

	///rotate object around to Y access
	rotate([motor_rotation_x, motor_rotation_y, motor_rotation_z])
		scale([0.5, 0.5, 1]){
	
// shaft
		
			difference() {
		color("grey");
		cylinder(r=motor_shaft_r, h=motor_shaft_h, center=true);
			///add some flats
				
				translate([-5,2,-4.27])
				cube([10,5,6.27]);
				
				mirror([0,1,0]){
				
				translate([-5,2,-4.27])
				cube([10,5,6.27]);
				}
					}
	
					//flange
					translate([0,0,motor_shaft_h/2]) 
						color("yellow")
						cylinder(r=motor_flange_r, h=motor_flange_h, center=true);
						// Main Body
							translate([0,-15,14])
								color("silver")
						cylinder(r=Motor_body_r, h=Motor_body_h, center=true);
							//Flanges
								translate([35,-15,4.5]){
									difference() {
										cylinder(r=7, h=1);
											cylinder(r=4, h=1);
										}
										translate([-14,-7,0]){
											cube([14.5,14,1]);
										}
										//color("white")
										//cylinder(r=4, h=1);
									
								}
								translate([-35,-15,4.5]){
								difference() {
									cylinder(r=7, h=1);
									cylinder(r=4, h=1);
									}
									translate([0,-7,0]){
											cube([14.5,14,1]);
										}
											
										//color("white")
										//cylinder(r=4, h=1);
											
										}
							  //bottom
							color("blue")
							 translate([0-7,-46,4]) 
								  cube([14.5,5.5,Motor_body_h]);  
			
			}
}


// Usage
// logo_motor(x,y,z);
// logo_motor(90,0,0);
    