// Battery packs
// battery_pack_linear - all batteries in a row
// battery_pack_double - 2 rows of batteries (can't cope with odd numbers!)

// Point of origin is the centre of the end of the end battery.

include <../config/colors.scad>

eta = 0.01;

// AAs - http://en.wikipedia.org/wiki/AA_battery

//                    Battery len, Battery dia, Pack width, Pack depth, Pack height, Linear?, Batteries, Name
BatteryPack_AA_4_SQ = [ 50.5,       14.5,        31.4,       27.5,       57.4,        0,      , 4,       "AA" ];

// Default:
BatteryPack_AA = BatteryPack_AA_4_SQ;

// Constants for access:
BatteryPack_Const_BLen = 0;
BatteryPack_Const_BDia = 1;
BatteryPack_Const_PWidth = 2;
BatteryPack_Const_PDepth = 3;
BatteryPack_Const_PHeight = 4;
BatteryPack_Const_Linear = 5;
BatteryPack_Const_Count = 6;
BatteryPack_Const_Name = 7;

// Connectors:
function BatteryPack_Con_SideFace(BP=BatteryPack_AA_4_SQ) = [
  [
    BP[BatteryPack_Const_PWidth] - BP[BatteryPack_Const_BDia]/2,
    (BP[BatteryPack_Const_PDepth]/2 - BP[BatteryPack_Const_BDia]/2),
    BP[BatteryPack_Const_PHeight]/2,
  ],
  [ 1,0,0 ],
  0, 0, 0
];

module battery_pack_linear(BP, battery_sep, battery_count) {

  Battery_len = BP[BatteryPack_Const_BLen];
  Battery_dia = BP[BatteryPack_Const_BDia];

  for(i=[0:battery_count-1]) {
    translate([i*(Battery_dia+battery_sep), 0, 0])
      if(i % 2 == 1) {
        translate([0,0,Battery_len/2])
          rotate([180, 0, 0])
            translate([0,0,-Battery_len/2])
              Battery(Battery_AA);
      } else {
        Battery(Battery_AA);
      }
  }
}

module battery_pack_double(BP, battery_sep, battery_count) {

  Battery_len = BP[BatteryPack_Const_BLen];
  Battery_dia = BP[BatteryPack_Const_BDia];
  BatteryPack_height = BP[BatteryPack_Const_PHeight];

  translate([0,0,(BatteryPack_height-Battery_len)/2])
  for(i=[0:(battery_count/2)-1]) {
    translate([i*(Battery_dia+battery_sep), 0, 0])
      Battery(Battery_AA);
    translate([i*(Battery_dia+battery_sep), Battery_dia+battery_sep, 0])
      translate([0,0,Battery_len/2])
        rotate([180, 0, 0])
          translate([0,0,-Battery_len/2])
            Battery(Battery_AA);
  }
}

// NB, This completely ignores battery count/linear setting! 2x2 is what you get!
module BatteryPack(BP=BatteryPack_AA_4_SQ, showBatteries=false) {

  Battery_len = BP[BatteryPack_Const_BLen];
  Battery_dia = BP[BatteryPack_Const_BDia];
  BatteryPack_height = BP[BatteryPack_Const_PHeight];
  BatteryPack_width = BP[BatteryPack_Const_PWidth];
  BatteryPack_depth = BP[BatteryPack_Const_PDepth];

  // Actually measured, it overhangs by 2mm, 1 because this is actually
  // a radius -- how far is the center-line of the battery offset from the edge
  // of the case (in the y direction).
  battery_depth_offset = Battery_dia/2 - 1;

  if (showBatteries) {
      translate([0,-2,0])
        battery_pack_double(BatteryPack_AA, 2, 4);
  }

  if (DebugConnectors) {
      connector(BatteryPack_Con_SideFace(BP));
  }

  vitamin(
      "vitamins/BatteryPack.scad",
      str("Battery Pack"),
      str("BatteryPack()")
  ) {
      view(t=[6.9, 13.6, 10.3], r=[72,0,33], d=280);
  }

  $fn = 16;

  color([0.3,0.3,0.3])
  render()
  translate([-Battery_dia/2, -Battery_dia/2,0])
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


*battery_pack_linear(BatteryPack_AA, 2,4);
*battery_pack_double(BatteryPack_AA, 2, 4);
*battery(BatteryPack_AA);
*BatteryPack(BatteryPack_AA);
