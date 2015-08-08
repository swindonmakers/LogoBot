include <../config/config.scad>


// Cable clip pin

render()
difference() {
	union() {
		pintack(side=true, h=2.5+3, bh=2);

		translate([0, -2, 0])
		difference() {
			pintack(side=true, h=2.5+3, bh=2+1.5);
			translate([-5, 0, -eta])
				cube([10, 6, 6]);
		}
	}
	
	translate([-6, -2-1.5, -eta])
		cube([10, 1.5, 6]);
}