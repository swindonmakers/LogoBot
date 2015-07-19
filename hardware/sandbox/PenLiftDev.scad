include <../config/config.scad>

// Set penUp to the angle of the servo arm to see
// the lift in action. eg 0 = down, 90 = up
penUp=0;
penUpHeight = penUp == 0 ? 0 : penUp > 25 ? 11.5 * ((penUp-25) / 90) : 0;

//PenLiftAssembly();

// Main printed pen lift parts
translate([-10, 0, 2]) {
	PenLiftSlider_STL();
	attachWithOffset(PenLiftSlider_Con_Holder, PenLiftHolder_Con_Default, [0, 0, penUpHeight])
		PenLiftHolder_STL();
}

// Servo
attach([[-12, -6, -6], [1, 0, 0], 90, 0, 0], MicroServo_Con_Horn)
{
	MicroServo();
	attach(MicroServo_Con_Horn, ServoHorn_Con_Default)
	rotate([0, 0, penUp])
		ServoHorn();
}


// Pins
for (i=[0, 1])
mirror([0, i, 0])
translate([0, -20, 4+2])
rotate([180, 0, 0])
	pintack(side=false, h=2.5+4+2.5, bh=2);

// Pen
translate([0, 0, -20 + penUpHeight])
	Pen();

// Other LogoBot parts for refence
union() {
	LogoBotBase_STL();
	for (i=[0:1])
		mirror([i,0,0])
		translate([BaseDiameter/2 + MotorOffsetX, 0, MotorOffsetZ])
		translate([-15,0,0])
		attach(DefConDown, DefConDown, ExplodeSpacing = 40)
		translate([15,0,0])
		rotate([-90, 0, 90]) {
			assign($rightSide= i == 0? 1 : 0)
				WheelAssembly();
		}
}

// Ground					
color([0, .8, 0], 0.3)
translate([0, 0, -GroundClearance - 1])
	cube([400, 400, 1], center=true);




