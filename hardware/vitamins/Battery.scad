/*
    Vitamin: Battery

    Local Frame:
    Battery "stands" on origin, extending up in Z+
*/

// Type getters
function Battery_TypeSuffix(t) = t[0];
function Battery_Length(t)     = t[1];
function Battery_OD(t)         = t[2];

// Type table
//             TypeSuffix, Len,       OD,
Battery_AA = [ "AA",       50.5,      14.5  ];


// Connectors
Battery_Con_Negative   = [ [0,0,0], [0,0,1], 0, 0, 0];
function Battery_Con_Positive(t) = [ [0,0, Battery_Length(t) ], [0,0,-1], 0, 0, 0];



module Battery(type=Battery_AA) {
    ts = Battery_TypeSuffix(type);

    vitamin(
        "vitamins/Battery.scad",
        str(ts," Battery"),
        str("Battery(Battery_",ts,")")
    ) {
        view(t=[6.9, 13.6, 10.3], r=[72,0,33], d=280);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(Battery_Con_Negative);
            connector(Battery_Con_Positive(type));
        }

        // parts
        Battery_Body(type);
    }
}

module Battery_Body(t) {

      Battery_len = Battery_Length(t);
      Battery_dia = Battery_OD(t);

      button_h = (1/20)*Battery_len;
      top_h = (1/3)*Battery_len;
      bottom_h = Battery_len-(top_h+button_h);

      $fn=32;

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
