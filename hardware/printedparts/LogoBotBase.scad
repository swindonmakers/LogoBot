/*
	STL: LogoBotBase_STL

	The printable base plate for the robot.

	The _STL suffix denotes this is a printable part, and is used by the bulk STL generating program

	Local Frame:
		Base lies on XY plane, centered on origin, front of robot is towards y+

	Parameters:
		None

	Returns:
		Base plate, rendered and colored
*/

module LogoBotBase_STL() {

	// turn off explosions inside STL!!!
	$Explode = false;

	printedPart("printedparts/LogoBotBase.scad", "Base", "LogoBotBase_STL()") {

		markdown("guide","The base requires a well calibrated printer to avoid adhesion issues.  You may also need to ream the holes to 7mm, depending on your print tolerances.");

		view(t=[0,0,0], r=[58,0,225], d=681);

		// Color it as a printed plastic part
		color(PlasticColor)
			if (UseSTL) {
				import(str(STLPath, "Base.stl"));
			} else {
				union()
				{
					// Start with an extruded base plate, with all the relevant holes punched in it
					linear_extrude(BaseThickness)
						difference() {
							// Union together all the bits to make the plate
							union() {
								// Base plate
								circle(r=BaseDiameter/2);
							}

/*
							// hole for breadboard
							attach(LogoBot_Con_Breadboard, Breadboard_Con_BottomLeft(Breadboard_170))
								difference() {
									translate([2,2,0])
										square([Breadboard_Width(Breadboard_170)-4, Breadboard_Depth(Breadboard_170)-4]);

									// attach mounting points, has the effect of not differencing them
									attach(Breadboard_Con_BottomLeft(Breadboard_170),DefCon) {
										circle(r=4/2 + dw);
										translate([0, -2 - dw, 0])
											square([10, 4 + 2*dw]);
									}

									attach(Breadboard_Con_BottomRight(Breadboard_170),DefCon) {
										circle(r=4/2 + dw);
										rotate([0,0,180])
											translate([0, -2 - dw, 0])
											square([10, 4 + 2*dw]);
									}
								}

							// mounting holes for breadboard
							attach(LogoBot_Con_Breadboard, Breadboard_Con_BottomLeft(Breadboard_170)) {
								attach(Breadboard_Con_BottomLeft(Breadboard_170),DefCon)
									circle(r=4.3/2);

								attach(Breadboard_Con_BottomRight(Breadboard_170),DefCon)
									circle(r=4.3/2);
							}

							// weight loss holes under the motor drivers
							attach(LogoBot_Con_LeftMotorDriver, (ULN2003DriverBoard_Con_UpperLeft))
								roundedSquare([ULN2003Driver_BoardWidth - 2*ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight - 2*ULN2003Driver_HoleInset], tw);

							// Right Motor Driver
							attach(LogoBot_Con_RightMotorDriver, (ULN2003DriverBoard_Con_UpperRight))
								roundedSquare([ULN2003Driver_BoardWidth - 2*ULN2003Driver_HoleInset, ULN2003Driver_BoardHeight - 2*ULN2003Driver_HoleInset], tw);
*/
							// slots for wheels
							for (i=[0:1])
								mirror([i,0,0])
								translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
								roundedSquare([WheelThickness + tw, WheelDiameter + tw], (WheelThickness + tw)/2, center=true);



							// Centre hole for pen
							circle(r=PenHoleDiameter/2);

							// Chevron at the front so we're clear where the front is!
							*translate([0, BaseBigHolesRadius - 3, 0])
								chevron(width=10, height=6, thickness=3);

							// Caster
							// TODO: Replace with sep "skid" part and pin connector
							//attach(LogoBot_Con_Caster, MarbleCaster_Con_Default)
							//    circle(r = connector_bore(MarbleCaster_Con_Default) / 2);


							if (false) {
								LogoBotBase_RadialHoles();
							} else {
								LogoBotBase_GridHoles();
							}

							// Remove shell fittings
							Shell_TwistLockCutouts();
						}

					// Now union on any other bits (i.e. sticky-up bits!)

					// clips for the motors
					// TODO: Move these into separate printed part
					//LogoBotBase_MotorClips();

					// Not required in new design, they will be integrated with the motor clips
					//LogoBotBase_MotorDriverPosts();


				}
			}
	}
}

module LogoBotBase_GridHoles() {

	pitch = 10;
	xn = round((BaseDiameter / pitch)/2) + 1;
	yn = xn;

	for (x=[-xn:xn], y=[-yn:yn]) {
		if (
			circleInCircle(BaseDiameter/2 - dw, x*pitch, y*pitch, PinDiameter/2) &&
			circleOutsideCircle(PenHoleDiameter/2 + dw, x*pitch, y*pitch, PinDiameter/2) &&
			abs(x*pitch) <= BaseDiameter/2 + MotorOffsetX - 1 - dw - PinDiameter/2
		) {
			translate([x*pitch, y*pitch,0])
				circle(r=PinDiameter/2, $fn=20);
		}

	}

}

function circleInCircle(r1,x,y,r2) = sqrt(sqr(x)+sqr(y))+r2 <= r1;

function circleOutsideCircle(r1,x,y,r2) = !circleInCircle(r1 + 2*r2,x,y,r2);

function circleIntersectSquare(x1,y1,x2,y2,x,y,r) = pointInSquare(x1,y1,x2,y2,x,y) ||
													circleIntersectLine(x1,y1,x2,y1,x,y,r) ||
													circleIntersectLine(x1,y2,x2,y2,x,y,r) ||
													circleIntersectLine(x1,y1,x1,y2,x,y,r) ||
													circleIntersectLine(x2,y1,x2,y2,x,y,r);

function pointInSquare(x1,y1,x2,y2,x,y) = x>=x1 && x<=x2 && y>=y1 && y<=y2;

function circleIntersectLine(x1,y1,x2,y2,x,y,r) = circleInCircle(r,x-x1,y-y1,0) ||
												circleInCircle(r,x-x2,y-y2,0) ||
												false;
												// TODO: fix this!!
												//((abs((x2-x1)*(y-y1) - (x-x1)*(y2-y1)) / sqrt(sqr(x2-x1) + sqr(y2-y1))) <= r);



module LogoBotBase_RadialHoles() {

	// Outer fixing holes - for bumpers, sensors, etc
	for (ang=[-3:3], frontBack=[0,1])
		mirror([0,frontBack,0])
		rotate([0, 0, ang * 15 + 90])
		translate([BaseOuterFixingsRadius, 0, 0])
		circle(r=PinDiameter/2, $fn=20);

	// Mid fixing holes - motor drivers, battery pack
	for (i=[0:360/15])
		rotate([0, 0, i*15])
		translate([BaseMiddleFixingsRadius, 0, 0])
		circle(r=PinDiameter/2, $fn=20);


	// Inner fixing holes (around pen hole) - for pen lift
	for (i=[0:360/30])
		rotate([0, 0, i*30])
		translate([BaseInnerFixingsRadius, 0, 0])
		circle(r=PinDiameter/2, $fn=20);


	// Ring of big holes

	for (i=[0:360/60])
		rotate([0, 0, i*60])
		translate([BaseBigHolesRadius, 0, 0])
		circle(r=BaseBigHoleRadius, $fn=20);

}


module LogoBotBase_MotorClips() {
	// TODO: feed these local variables from the motor vitamin global vars
	mbr = 28/2;  // motor body radius
	mao = 8;     // motor axle offset from centre of motor body
	mth = 7;     // motor tab height

	// clips
	for (i=[0:1], j=[0,1])
		mirror([i,0,0])
		translate([BaseDiameter/2 + MotorOffsetX - 6 - j*12, 0, MotorOffsetZ + mao])
		rotate([-90, 0, 90])
		rotate([0,0, 0])
		linear_extrude(5) {
			difference() {
				union() {

					difference() {
						hull() {
							// main circle
							circle(r=mbr + dw);

							// extension to correctly union to the base plate
							translate([-(mbr * 1.5)/2,  MotorOffsetZ + mao -1,0])
								square([mbr * 1.5, 1]);
						}

						// trim the top off
						rotate([0,0,180 + 30])
							sector(r=mbr+30, a=120);
					}

					// welcoming hands
					for (k=[0,1])
						mirror([k,0,0])
						rotate([0,0,180+30])
						translate([mbr, -dw, 0])
						polygon([[1.5,0],[4,5],[3,5],[0,dw]],4);
				}

				// hollow for the motor
				circle(r=mbr);

			}
		}
}

module LogoBotBase_MotorDriverPosts() {
	// mounting posts for motor drivers
	// using a mirror because the layout is symmetrical

	for (i=[0,1])
		mirror([i,0,0])
			for (j=[0:3])
				attach(offsetConnector(LogoBot_Con_RightMotorDriver, [0,0,-LogoBot_Con_RightMotorDriver[0][2]]),
						ULN2003DriverBoard_Cons[j],
						$Explode=false)
				LogoBotBase_MountingPost(r1=(ULN2003Driver_HoleDia+2)/2, h1 = LogoBot_Con_RightMotorDriver[0][2], r2=ULN2003Driver_HoleDia/2, h2=3);
}

module LogoBotBase_MountingPost(r1=5/2, h1=3, r2=3/2, h2=3) {
	cylinder(r=r1, h=h1);
	translate([0,0,h1-eta])
		cylinder(r1=r2, r2=r2 * 0.7, h=h2 +eta);
}
