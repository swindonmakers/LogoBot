// Battery packs
// battery_pack_linear - all batteries in a row
// battery_pack_double - 2 rows of batteries (can't cope with odd numbers!)

// Point of origin is the centre of the end of the end battery.

include <../config/colors.scad>

// AAs - http://en.wikipedia.org/wiki/AA_battery
// len includes the positive-end button
Battery_dia = 14.5;
Battery_len = 50.5;

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

*battery_pack_linear(2,4);
*battery_pack_double(2, 4);
