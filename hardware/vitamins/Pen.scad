/*
	Vitamin: Pen
	A Uni Pin Fine Line 0.1mm
*/

Pen_Con_Default = DefCon;

module Pen()
{
	vitamin("vitamins/Pen.scad", "Fine Line Pen", "Pen()") {
		view(t=[-1,0,-1], r=[66,0,60], d=119);

		if (DebugCoordinateFrames)
			frame();

		if (DebugConnectors)
			connector(Pen_Con_Default);

		color(Grey20) {
			cylinder(d=1, h=4);
			translate([0, 0, 4-eta]) {
				cylinder(d1=2.5, d2=4, h=5);
				translate([0, 0, 5-eta]) {
					cylinder(d=5.4, h=6);
					translate([0, 0, 6-eta]){
						cylinder(d1=5.4, d2=8.4, h=1.75);
						translate([0, 0, 1.75-eta]){
							cylinder(d=9.4, h=8);
							translate([0, 0, 8-eta]) {
								cylinder(d=10, h=95);
								translate([0, 0, 95-eta])
									cylinder(d=8.7, h=4.85);
							}
						}
					}
				}
			}
		}
	}
}