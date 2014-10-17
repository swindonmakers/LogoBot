// Battery packs
// battery_pack_linear - all batteries in a row
// battery_pack_double - 2 rows of batteries (can't cope with odd numbers!)

// Point of origin is the centre of the end of the end battery.

// AAs - http://en.wikipedia.org/wiki/AA_battery
// len includes the positive-end button
Battery_dia = 14.5;
Battery_len = 50.5;

module battery() {

  linear_extrude(height=Battery_len) {
    circle(r=Battery_dia/2);
  }
}

module battery_pack_linear(battery_sep, battery_count) {
  for(i=[0:battery_count-1]) {
    translate([i*(Battery_dia+battery_sep), 0, 0])
      battery();
  }
}

module battery_pack_double(battery_sep, battery_count) {
  for(i=[0:(battery_count/2)-1]) {
    translate([i*(Battery_dia+battery_sep), 0, 0])
      battery();
    translate([i*(Battery_dia+battery_sep), Battery_dia+battery_sep, 0])
      battery();
  }
}

*battery_pack_linear(2,4);
*battery_pack_double(2, 4);
