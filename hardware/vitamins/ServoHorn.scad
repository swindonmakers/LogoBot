/*
	Vitamin: Servo Horn for 9g servo
*/

ServoHorn_Con_Default = DefCon;

module ServoHorn() // honk honk
{
	vitamin("vitamins/ServoHorn.scad", "Servo Horn", "ServoHorn()") {
		view(t=[-1,0,-1], r=[66,0,60], d=119);

		if (DebugCoordinateFrames)
			frame();

		if (DebugConnectors)
			connector(ServoHorn_Con_Default);

		color(White) {
			linear_extrude(4.5-1.4+eta)
			difference() {
				circle(d=6.8);
				circle(d=4.4);
			}
		
			translate([0, 0, 4.5-1.4])
			linear_extrude(1.4)
			difference() {
				hull() {
					circle(d=6.8);
				
					translate([13.8, 0, 0])
						circle(d=3.8);
				}
			
				circle(d=4.8);
			
				for(i=[0:6])
				translate([13.8 - i*2, 0, 0,])
					circle(d=1);
			}
		}
	}
}
