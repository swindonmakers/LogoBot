/*
  Vitamin: ArduinoPro
  Model of an Arduino Pro Mini/Micro

  Derived from: https://github.com/sparkfun/Pro_Micro/
           and: https://github.com/sparkfun/Arduino_Pro_Mini_328/

  Authors:
    Jamie Osborne (@jmeosbn)

  Local Frame:
    Point of origin is the centre of the bottom left pin (9)

  Parameters:
    type: can be "mini", or "micro";
          otherwise returns a blank board with header pin holes

  Returns:
    Model of an Arduino Pro Mini/Micro with header holes
*/

// ArduinoPro PCB Variables
ArduinoPro_PCB_Pitch  = 2.54;                       // spacing of the holes
ArduinoPro_PCB_Inset  = ArduinoPro_PCB_Pitch/2;     // inset from board edge
ArduinoPro_PCB_Width  =  0.7 * 25.4;                // width of the PCB     (along x)
ArduinoPro_PCB_Length =  1.3 * 25.4;                // length of the PCB    (along y)
ArduinoPro_PCB_Height = .063 * 25.4;                // thickness of the PCB (along z)
ArduinoPro_PCB_Colour = [26/255, 90/255, 160/255];  // colour of solder mask

// Show board clearance area for components
ArduinoPro_PCB_Clearance = 3;
ArduinoPro_PCB_Clearance_Show  = true;

// FIXME: export to external vitamin?
module Micro_USB_Clearance() {
  // dimensions for micro usb header
  // http://www.farnell.com/datasheets/1693470.pdf
  height = 2.8;
  width  = 7.5;
  depth  = 5.3;
  flange = 7.8;  // width of front flange

  // distance to overhang board edge
  offset  = 2.15 + 0.6 - 1.45;

  move_x  = ArduinoPro_PCB_Width / 2 - ArduinoPro_PCB_Inset;
  move_y  = ArduinoPro_PCB_Length - ArduinoPro_PCB_Inset + offset - depth/2;
  move_z  = ArduinoPro_PCB_Height;

  color(Grey80)
  translate([move_x, move_y, move_z])
    linear_extrude(height=height)
    square([flange, depth], center=true);
}

module ArduinoPro_PCB() {
  // Bare PCB, origin through location for bottom left hole
  translate([-ArduinoPro_PCB_Inset, -ArduinoPro_PCB_Inset, 0])
    square(size = [ArduinoPro_PCB_Width, ArduinoPro_PCB_Length]);
}

// TODO: Add throughhole/padding
// TODO: Option to show header pins?
// FIXME: export to external vitamin?
module ArduinoPro_Header_Hole(d = 1.25) {
  // Standard PCB hole
  circle(d = d);
}

module ArduinoPro_Headers() {
  // distance between the two header rows
  rowpitch  = ArduinoPro_PCB_Width - ArduinoPro_PCB_Inset*2;
  // length for holes, leaving room for end header and insets
  rowlength = ArduinoPro_PCB_Length - ArduinoPro_PCB_Pitch - ArduinoPro_PCB_Inset*2;

  // Add headers to either side (along y)
  for (x = [0, rowpitch], y = [0 : ArduinoPro_PCB_Pitch : rowlength]) {
    translate([x, y, 0]) ArduinoPro_Header_Hole();
  }

}

module ArduinoPro_Serial_Header() {
  // y position for header
  header_y = ArduinoPro_PCB_Length - ArduinoPro_PCB_Inset*2;
  // width for holes, leaving room for insets
  rowwidth = ArduinoPro_PCB_Width - ArduinoPro_PCB_Inset*2;

  // Add serial header along top of board (along x)
  for (x = [ArduinoPro_PCB_Inset : ArduinoPro_PCB_Pitch : rowwidth]) {
    translate([x, header_y, 0]) ArduinoPro_Header_Hole();
  }
}

module ArduinoPro(type = "mini") {
  union() {
    color(ArduinoPro_PCB_Colour)
    linear_extrude(height=ArduinoPro_PCB_Height)
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
      // Pro Micro USB port
      Micro_USB_Clearance();
    }

    // Indicate area for minimum board clearance
    if (ArduinoPro_PCB_Clearance_Show)
      color(ArduinoPro_PCB_Colour, 0.1)
      translate([-ArduinoPro_PCB_Inset, -ArduinoPro_PCB_Inset, ArduinoPro_PCB_Height])
      linear_extrude(height=ArduinoPro_PCB_Clearance)
      square(size = [ArduinoPro_PCB_Width, ArduinoPro_PCB_Length]);
  }
}



// Example Usage
*ArduinoPro("mini");
*ArduinoPro("micro");
