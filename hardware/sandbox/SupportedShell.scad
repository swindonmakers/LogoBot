include <../config/config.scad>

DebugCoordinateFrames = true;
DebugConnectors = true;

sw = 2 * 0.5;  // approx 2 perimeters



module domeSupportSegment(radius=100, inset=0, thickness=1, supportAngle=45) {
	insetAng = asin(inset/radius);
	theta = 180 - 2*supportAngle - 2*insetAng;

	sh = segmentHeight(radius,theta);

	if (sh > 2)
		rotate([0,0,90 - theta - insetAng])
		translate([0,0,-thickness/2])
		linear_extrude(thickness)
		circularSegment(radius,theta);
}


module shell() {

	or = BaseDiameter/2 + Shell_NotchTol + sw;

	sr = or - sw + eta;

	supportAngle = 50;
	bridgeDist = 6;

	numRibs1 = round(circumference(sr * cos(supportAngle)) / bridgeDist);
	numRibs = 4 * (floor(numRibs1 / 4) + 1);

	ribThickness = 0.7;

	$fn=64;

	// shell with hole for LED
	//render()
		difference() {
			union() {
				// curved shell with centre hole for pen
				rotate_extrude()
					difference() {
						// outer shell
						donutSector(
							or=or,
							ir=BaseDiameter/2 + Shell_NotchTol,
							a=90
						);

						// clearance for pen
						square([PenHoleDiameter/2, BaseDiameter]);

					}

				// large support ribs
				for (i=[0:numRibs/4])
					rotate([0,0,i*360/(numRibs/4)])
					rotate([90,0,0])
					domeSupportSegment(sr, PenHoleDiameter/2, ribThickness, supportAngle);

				// medium support ribs
				for (i=[0:numRibs/4])
					rotate([0,0,i*360/(numRibs/4) + 360/(numRibs/2)])
					rotate([90,0,0])
					domeSupportSegment(sr, PenHoleDiameter/2 + 2*bridgeDist, ribThickness, supportAngle);

				// small support ribs
				for (i=[0:numRibs/2])
					rotate([0,0,i*360/(numRibs/2) + 360/(numRibs)])
					rotate([90,0,0])
					domeSupportSegment(sr, PenHoleDiameter/2 + 4*bridgeDist, ribThickness, supportAngle);
			}
		}
}

shell();
