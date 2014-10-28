// Battery packs
// battery_pack_linear - all batteries in a row
// battery_pack_double - 2 rows of batteries (can't cope with odd numbers!)

// Point of origin is the centre of the end of the end battery.

include <../config/colors.scad>

// AAs - http://en.wikipedia.org/wiki/AA_battery
// len includes the positive-end button
Battery_dia = 14.5;
Battery_len = 50.5;
BatteryPack_width = 31.4;
BatteryPack_depth = 27.5;
BatteryPack_height = 57.4;

// We have the total battery length, assume the positive terminal is 1/20th of the length
module battery() {
  button_h = (1/20)*Battery_len;
  top_h = (1/3)*Battery_len;
  bottom_h = Battery_len-(top_h+button_h);

  color("black")
  linear_extrude(height=bottom_h)
    circle(r=Battery_dia/2);

  color("red")
  translate([0, 0, bottom_h])
    linear_extrude(height=top_h)
      circle(r=Battery_dia/2);

  color(MetalColor)
  translate([0, 0, bottom_h+top_h])
    linear_extrude(height=button_h)
      circle(r=Battery_dia/4);

}

module battery_pack_linear(battery_sep, battery_count) {
  for(i=[0:battery_count-1]) {
    translate([i*(Battery_dia+battery_sep), 0, 0])
      if(i % 2 == 1) {
        translate([0,0,Battery_len/2])
          rotate([180, 0, 0])
            translate([0,0,-Battery_len/2])
              battery();
      } else {
        battery();
      }
  }
}

module battery_pack_double(battery_sep, battery_count) {
  for(i=[0:(battery_count/2)-1]) {
    translate([i*(Battery_dia+battery_sep), 0, 0])
      battery();
    translate([i*(Battery_dia+battery_sep), Battery_dia+battery_sep, 0])
      translate([0,0,Battery_len/2])
        rotate([180, 0, 0])
          translate([0,0,-Battery_len/2])
            battery();
  }
}

module BatteryPack(battery_count) {
  // Actually measured, it overhangs by 2mm, 1 because this is actually
  // a radius -- how far is the center-line of the battery offset from the edge
  // of the case (in the y direction).
  battery_depth_offset = Battery_dia/2 - 1;

  render()
  difference() {
   linear_extrude(height=BatteryPack_height)
     hull() {
      // Main body
      translate([Battery_dia/2, Battery_dia/2, 0])
        circle(r=Battery_dia/2);
      translate([BatteryPack_width-Battery_dia/2, Battery_dia/2, 0])
        circle(r=Battery_dia/2);
      translate([Battery_dia/2, BatteryPack_depth-Battery_dia/2, 0])
        circle(r=Battery_dia/2);
      translate([BatteryPack_width-Battery_dia/2, BatteryPack_depth-Battery_dia/2, 0])
        circle(r=Battery_dia/2);
   }

   // Subtract battery shapes
   translate([Battery_dia/2-eta, battery_depth_offset-eta, (BatteryPack_height-Battery_len)/2])
     cylinder(h=Battery_len, r=Battery_dia/2);
    

   translate([BatteryPack_width-Battery_dia/2+eta, battery_depth_offset-eta, (BatteryPack_height-Battery_len)/2])
    cylinder(h=Battery_len, r=Battery_dia/2);

   translate([Battery_dia/2-eta, BatteryPack_depth-battery_depth_offset+eta, (BatteryPack_height-Battery_len)/2])
    cylinder(h=Battery_len, r=Battery_dia/2);
   translate([BatteryPack_width-Battery_dia/2+eta,BatteryPack_depth-battery_depth_offset+eta,(BatteryPack_height-Battery_len)/2])
    cylinder(h=Battery_len, r=Battery_dia/2);

   translate([BatteryPack_width/4,-BatteryPack_depth+6,(BatteryPack_height-Battery_len)/2])
     cube([BatteryPack_width/2, BatteryPack_depth, Battery_len]);
   translate([BatteryPack_width/4,BatteryPack_depth-6,(BatteryPack_height-Battery_len)/2])
     cube([BatteryPack_width/2, BatteryPack_depth, Battery_len]);

 }
}

*battery_pack_linear(2,4);
*battery_pack_double(2, 4);
