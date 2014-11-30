include <../config/config.scad>

// playground for pins libary
// Modules to call = pin(), pinpeg(), pintack(), pinhole()
//
// Parameters :
//
// h = Length or height of pin/hole.
// r = radius of pin body.
// lh = Height of lip.
// lt = Thickness of lip.
// t = Pin tolerance.
// bh = Base Height (pintack only).
// br = Base Radius (pintack only).
// tight = Hole friction, set to false if you want a joint that spins easily (pinhole only)
// fixed = Hole Twist, set to true so pins can't spin (pinhole only)
//	Side = Orientates pins on their side for printing : true/false (not pinhole).


translate([-25,0,0])
	pin();

translate([0,-20,0])
	pintack();

translate([25,0,0])
	pinpeg(l=10);

translate([-40,0,0])
	pin(side=true);

translate([0,-40,0])
	pintack(side=true);

translate([40,0,0])
	pinpeg(l=10, side=true);


translate([0,20,0])
	pinhole(fixed=true);

translate([10,0,0])difference(){
	cylinder(r=5.5,h=14);
	pinhole();
}

translate([-10,0,0])difference(){
	cylinder(r=5.5,h=14);
	pinhole(fixed=true);
}