include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;

sw = 2 * 0.5;  // approx 2 perimeters

function sqr(a) = a*a;

function circumference(radius) = 2 * PI * radius;
function arcLength(radius, theta) = PI * radius * theta / 180;
function chordLength(radius, theta) = radius * sqrt(2 - 2*cos(theta));
function segmentHeight(radius, theta) = radius - sqrt(sqr(radius) - sqr(chordLength(radius, theta))/4);
function segmentDistance(radius,theta) = radius - segmentHeight(radius,theta);


// 2D
// in XY plane
// chord begins at intersection of x+
// extends towards y+
// theta should be <= 180 degrees
module circularSegment(radius, theta) {
	echo(segmentHeight(radius,theta));
	intersection() {
		circle(radius);
		
		// chord hull
		polygon(
		[
			[radius, 0],
			[2*radius * cos(theta*0.25), 2*radius * sin(theta*0.1)],
			[2*radius * cos(theta*0.5), 2*radius * sin(theta*0.5)],
			[2*radius * cos(theta*0.75), 2*radius * sin(theta*0.9)],
			[radius * cos(theta), radius * sin(theta)]
		], 5);
	}
}


module domeSupportSegment(radius=100, inset=0, thickness=1, supportAngle=45) {
	insetAng = asin(inset/radius);	
	theta = 180 - 2*supportAngle - 2*insetAng;

	rotate([0,0,90 - theta - insetAng])
		linear_extrude(thickness)
		circularSegment(radius,theta);
}


module shell() {
	// shell with hole for LED
	//render()
		difference() {
			union() {		
				// curved shell with centre hole for pen
				rotate_extrude()
					difference() {
						// outer shell
						donutSector2D(
							or=BaseDiameter/2 + Shell_NotchTol + sw, 
							ir=BaseDiameter/2 + Shell_NotchTol,
							a=90
						);
			
						// clearance for pen
						square([PenHoleDiameter/2, BaseDiameter]);

					}
					
				// large support ribs
				for (i=[0:9])
					rotate([0,0,i*360/10])
					rotate([90,0,0])
					domeSupportSegment(BaseDiameter/2, PenHoleDiameter/2, perim, 50);
					
				// small support ribs
				for (i=[0:9])
					rotate([0,0,i*360/10 + 360/20])
					rotate([90,0,0])
					domeSupportSegment(BaseDiameter/2, PenHoleDiameter/2 + 10, perim, 50);
			}
		
			// section
			*translate([-100,-200,-100])
				cube([200,200,200]);
		}
}

shell();