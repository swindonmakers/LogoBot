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
    FIXME: type: can be "mini", or "micro";
           otherwise returns a blank board with header pin holes

  Returns:
    FIXME: Model of an Arduino Pro Mini/Micro with header holes
*/

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
    square(size = [pcbWidth, pcbLength]);
  }
}

module ArduinoPro_Headers() {
  // distance between the two header rows
  rowpitch  = pcbWidth - holeInset*2;
  // length for holes, leaving room for end header and insets
  rowlength = pcbLength - holeSpace - holeInset*2;

  // Add headers to either side (along y)
  for (x = [0, rowpitch], y = [0 : holeSpace : rowlength]) {
    translate([x, y, 0]) {
      // Standard PCB hole
      circle(r = holeDiam/2);
    }
  }

}

module ArduinoPro_Serial_Header() {
  // y position for header
  header_y = pcbLength - holeInset*2;
  // width for holes, leaving room for insets
  rowwidth = pcbWidth - holeInset*2;

  // Add serial header along top of board (along x)
  for (x = [holeInset : holeSpace : rowwidth]) {
    translate([x, header_y, 0]) {
      // Standard PCB hole
      circle(r = holeDiam/2);
    }
  }

}

module ArduinoPro(type = "mini") {
  difference() {
    // Common Features for Pro Mini/Micro
    ArduinoPro_PCB();
    ArduinoPro_Headers();

    // Features for Pro Mini
    if (type == "mini") {
      // Pro Mini Serial Header
      ArduinoPro_Serial_Header();
    }
  }

  // Features for Pro Micro
  if (type == "micro") {
  }
}

ArduinoPro("mini");
*ArduinoPro("micro");
