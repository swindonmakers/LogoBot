/*
  Vitamin: Pro Micro
  Model of an Arduino Pro Micro

  Derived from: https://github.com/sparkfun/Pro_Micro/
           and: https://github.com/sparkfun/Arduino_Pro_Mini_328/

  Authors:
    Jamie Osborne (@jmeosbn)

  Local Frame:
    Point of origin is the centre of the bottom left pin (9)

  Parameters:
    FIXME: None

  Returns:
    FIXME: Model of an Arduino Pro Mini/Micro with header holes
*/

include <../config/config.scad>

// PCB Variables
holeDiam  = 1.25;         // The hole diameter in mm
holeSpace = 2.54;         // The spacing of the holes in mm
holeInset = holeSpace/2;  // The spacing of the holes in mm
pcbHeight = .063 * 25.4;  // The thickness of the PCB in mm
pcbLength =  1.3 * 25.4;  // The length of the PCB in mm
pcbWidth  =  0.7 * 25.4;  // The width of the PCB in mm

module ArduinoPro_PCB() {
  // Bare PCB, origin at location for bottom left hole
  translate([-holeInset, -holeInset, 0]) {
    square(size=[pcbWidth, pcbLength]);
  }
}

module ArduinoPro_Headers() {
  // Add headers to either side along y, leaving room for end header
  // distance between the two header rows
  rowpitch=pcbWidth-holeInset*2;
  // amount of holes in each row, leaving room for end header and insets
  rowcount=((pcbLength-holeSpace-holeInset*2)/holeSpace);

  // FIXME: rowcount doesn't get fully interated
  // rowcount=11;

  echo("Count=", rowcount * 10000);
  for (x=[0, rowpitch], y=[0:rowcount]) {
    echo("Loop=", y);
    translate([x, y*holeSpace, 0]) {
      // Standard PCB hole
      circle(r=holeDiam/2);
    }
  }
  echo("Count=", rowcount);
}

module ArduinoPro(type="mini") {
  // Common Features between Pro Mini and Pro Micro
  difference() {
    // Common PCB
    ArduinoPro_PCB();

    // Common headers
    ArduinoPro_Headers();
  }

  // Features for Pro Mini
  if (type=="mini") {
  }

  // Features for Pro Micro
  if (type=="micro") {
  }
}

ArduinoPro("mini");
*ArduinoPro("micro");