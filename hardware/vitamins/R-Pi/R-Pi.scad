/*

Downloaded from Thomas Hodson's Raspberry-Pi-OpenSCAD-Model 
at https://github.com/TomHodson/Raspberry-Pi-OpenSCAD-Model

Edits by Philip McGaw include, but are not limited to
+ putting comments inline
+ adding Camera header
+ adding Display header
+ added label.

Can now be called using the line pi();

*/

//everything in mm

use <pin_headers.scad>;
use <TextGenerator.scad>;

width = 56;	// PCB Width
length = 85;	// PCB Lenth
height = 1.6;	// thickness of PCB

Version = "A";
 
module ethernet ()
	{
	color("silver")
	translate([length-20,1.5,height])
	if (Version == "A")
		{
		}
	else
		{
		//ethernet port
		cube([21.2,16,13.3]); 
		}
	}

module usb ()
	{
	color("silver")
	translate([length-9.5,25,height])
	if (Version == "A")
		{
		// Single USB Port
		cube([17.3,13.3,8]);		// Check hight!
		}
	else
		{
		//Double usb port
		cube([17.3,13.3,16]);
		}
	}

module composite ()
	{
	translate([length-43.6,width-12,height])
		{
		color("yellow")
		cube([10,10,13]);
		translate([5,19,8])
		rotate([90,0,0])
		color("silver")
		cylinder(h = 9, r = 4.15);
		}
	}

module audio ()
	{
	//audio jack
	translate([length-26,width-11.5,height])
		{
		color ([.2,.2,.7])
		cube([12,11.5,13]);
		translate([6,11.5,8])
		rotate([-90,0,0])
		color("silver")
		cylinder(h = 3.5, r = 4.15);
		}
	}

module gpio ()
	{
	//headers (uses pin_headers.scad to make the pins).
	rotate([0,0,180])
	translate([-1,-width+6,height])
	off_pin_header(rows = 13, cols = 2);
	}

module hdmi ()
	{
	color ("yellow")
	translate ([37.1,-1,height])
	cube([15.1,11.7,8-height]);
	}

module power ()
	{
	translate ([-0.8,3.8,height])
	cube ([5.6, 8,4.4-height]);
	}

module sd ()
	{
  	color ([0,0,0])
	translate ([0.9, 15.2,-5.2+height])
	cube ([16.8, 28.5, 5.2-height]);
	color ([.2,.2,.7])
	translate ([-17.3,17.7,-2.9])
	cube ([32, 24, 2] );
	}

module csicamera ()
	{
	color([0,0,0])
	translate ([55,5,height])
	cube ([5, 25,10-height]);

	color("white")
	translate ([55,5,11-height])
	cube ([5, 25,1]);
	}

module dsidisplay ()
	{
	color([0,0,0])
	translate ([10,15,height])
	cube ([5, 10,10-height]);
	color("white")
	translate ([10,15,11-height])
	cube ([5, 10,1]);
	}

module text ()
	{
	translate ([25,25,2.6-height])
	drawtext("R-Pi");
	}

module mounthole ()
	{
	cylinder (r=3/2, h=height+.2, $fs=0.1);
	}


module pi()
	{
	// full Assembly

	difference ()
		{
		color([0.2,0.5,0])
		linear_extrude(height = height)
		square([length,width]); //pcb
		translate ([25.5, 18,-0.1])
		mounthole (); 
		translate ([length-5, width-12.5, -0.1])
		mounthole (); 
		}

	ethernet ();
	usb ();
	composite ();
	audio ();
	gpio ();
	hdmi ();
	power ();
	sd ();
	csicamera ();
	dsidisplay ();
	text();
	}

pi(Version);