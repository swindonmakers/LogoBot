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


// ArduinoPro Model Variants
ArduinoPro_Mini             = 1;            // default
ArduinoPro_Micro            = 2;

// ArduinoPro Without Programming Port
ArduinoPro_No_Port          = 0;

// Show Header Pins
ArduinoPro_Pins_Normal      = 1;
ArduinoPro_Pins_Opposite    = 2;

// ArduinoPro Without Header Pins
ArduinoPro_No_Pins          = 0;            // default

// ArduinoPro PCB Variables
ArduinoPro_PCB_Pitch    = 0.1 * 25.4;                   // spacing of the holes
ArduinoPro_PCB_Inset    = ArduinoPro_PCB_Pitch /2;      // inset from board edge
ArduinoPro_PCB_Type     = 0.047 * 25.4; // .047 .063    // standard PCB thickness
ArduinoPro_PCB_Layers   = 0.035 * 2;                    // total copper layer thickness
ArduinoPro_PCB_Height   = ArduinoPro_PCB_Type +
                          ArduinoPro_PCB_Layers;        // height of the PCB (along z)
ArduinoPro_PCB_Length   = 1.3 * 25.4;                   // length of the PCB (along y)
ArduinoPro_PCB_Width    = 0.7 * 25.4;                   //  width of the PCB (along x)
ArduinoPro_PCB_Colour   = [26/255, 90/255, 160/255];    // colour of solder mask

// Connectors
ArduinoPro_Con_Pin9     = [[0,0,0],[0,0,1],0,0,0];  // local origin
ArduinoPro_Con_Center   = [
    [
        (ArduinoPro_PCB_Width - 2*ArduinoPro_PCB_Inset)/2,
        (ArduinoPro_PCB_Length - 2*ArduinoPro_PCB_Inset)/2,
        0
    ],
    [0,0,-1],
    0,0,0
];


module ArduinoPro_MicroUSB()
{
    include <MicroUSB.scad>
    // Subtracting `ArduinoPro_PCB_Inset` compansates for board origin
    //-: Not sure if board origin would be better set after creation
    move_x  = ArduinoPro_PCB_Width / 2 - ArduinoPro_PCB_Inset;
    move_y  = ArduinoPro_PCB_Length - ArduinoPro_PCB_Inset;
    move_z  = ArduinoPro_PCB_Height;

    // Add USB header and move to top of board (along x)
    translate([move_x, move_y, move_z])
        MicroUSB(MicroUSB_Receptacle);
}

module ArduinoPro_PCB()
{
    // Bare PCB, origin through location for bottom left hole
    translate([-ArduinoPro_PCB_Inset, -ArduinoPro_PCB_Inset, 0])
        square(size = [ArduinoPro_PCB_Width, ArduinoPro_PCB_Length]);
}

module ArduinoPro_Header_Hole()
{
    // Standard PCB hole
    holediameter        = 1.25;         // diameter of PCB hole
    circle(d = holediameter);
}

module ArduinoPro_Header_Pin(rotation = 0)
{
    // Standard PCB header pin
    pcbholepitch        = 2.54;         // spacing of PCB holes
    holediameter        = 1.25;         // diameter of PCB hole
    pinheight           =   11;         // length of PCB pins
    pinoffset           =    3;         // offset of PCB pins
    pinwidth            = 0.63;         // width/gauge of PCB pins
    spacerwidth         = 2.25;         // height of breakaway pin frame
    spacerheight        = 2.25;         // height of breakaway pin frame

    // Header Pins
    color("white")
    translate([0, 0, -pinoffset])
    linear_extrude(pinheight)
        square(pinwidth, center = true);

    // Pin Spacers
    color(Grey20)
    linear_extrude(spacerheight)
        square(spacerwidth, center = true);

    // Break-Away Material
    color(Grey20)
    // FIXME: material needs to be rotated based on vector argument
    rotate(rotation, 0, 0)
    translate([0, pcbholepitch/2, 0])
    linear_extrude(spacerheight)
        square([spacerwidth * 0.85, pcbholepitch - spacerwidth], center = true);
}

module ArduinoPro_Headers_Layout()
{
    // distance between the two header rows
    // FIXME: improve this to be a multiple of 0.1 inch
    rowpitch  = ArduinoPro_PCB_Width - ArduinoPro_PCB_Inset*2;
    // length for holes, leaving room for end header and insets
    rowlength = ArduinoPro_PCB_Length - ArduinoPro_PCB_Pitch - ArduinoPro_PCB_Inset*2;

    // Add headers to either side (along y)
    for (x = [0, rowpitch], y = [0 : ArduinoPro_PCB_Pitch : rowlength]) {
        translate([x, y, 0]) children();
    }
}

module ArduinoPro_Serial_Header_Layout()
{
    // y position for header
    header_y = ArduinoPro_PCB_Length - ArduinoPro_PCB_Inset*2;
    // width for holes, leaving room for insets
    rowwidth = ArduinoPro_PCB_Width - ArduinoPro_PCB_Inset*2;

    // Add serial header along top of board (along x)
    for (x = [ArduinoPro_PCB_Inset : ArduinoPro_PCB_Pitch : rowwidth]) {
        translate([x, header_y, 0]) children();
    }
}

module ArduinoPro_SMT_Components(type = ArduinoPro_Mini)
{
    // Distance from origin to middle along y
    datumX = ArduinoPro_PCB_Width/2 - ArduinoPro_PCB_Inset;
    datumZ = ArduinoPro_PCB_Height;

    // Controller IC
    color(Grey20)
    translate([datumX, 0.5 * 25.4, datumZ])
    rotate([0,0,45])
    linear_extrude(1)
      square(sqrt(pow(0.4 * 25.4, 2)/2), center=true);

    // Parts for Pro Mini
    if (type == ArduinoPro_Mini) {
        // Reset switch
        translate([datumX, 0.05 * 25.4, datumZ])
        {
            color("silver")
            linear_extrude(1.2)
                square([4.5, 4.5], center=true);
            color(ArduinoPro_PCB_Colour)
            translate([0, 0, 1.2])
            linear_extrude(0.5)
                circle(d=2.5);
        }

        // RX and TX LEDs
        color("white")
        translate([datumX, 0.05 * 25.4, datumZ])
        linear_extrude(1)
        {
            // Red - Power
            translate([0, 0.75 * 25.4, 0])
                square([1.2,0.7], center=true);
            // Green - Status
            translate([0.2 * 25.4, 0, 0])
                square([0.7,1.2], center=true);
        }

    }

    // Parts for Pro Micro
    if (type == ArduinoPro_Micro) {
        // Crystal
        color("silver")
        translate([datumX, 0.15 * 25.4, datumZ])
        linear_extrude(1)
            square([5, 3], center=true);

        // RX and TX LEDs
        color("white")
        translate([datumX, 0.2 * 25.4, datumZ])
        linear_extrude(1)
        {
            // RX - Yellow
            translate([-0.3 * 25.4/2, 0, 0])
                square([0.7,1.2], center=true);
            // Power - Red
            translate([-0.15 * 25.4, 0.75 * 25.4, 0])
                square([1.2,0.7], center=true);
            // TX - Green
            translate([0.3 * 25.4/2, 0, 0])
                square([0.7,1.2], center=true);
        }
    }

    // Capacitors
    moveY = (type == ArduinoPro_Mini ? 0.9 : 0.8) * 25.4;
    color("silver")
    translate([datumX, moveY, datumZ])
    linear_extrude(2)
    {
        translate([-7.5/2, 0, 0])
            square([1.5, 3.5], center=true);
        translate([7.5/2, 0, 0])
          square([1.5, 3.5], center=true);
    }

    // Other components
    color("silver")
    translate([datumX, moveY, datumZ])
    linear_extrude(1)
    {
        square([1, 2.5], center=true);
        translate([0, 3.25, 0])
            square([2.5, 1.5], center=true);
    }
}

module ArduinoPro(type = ArduinoPro_Mini, headerpins = 0, serialpins = 0)
{
    pinStr = headerpins == 0 ? "No Header Pins" : (headerpins == 2 ? "Pins on top" : "Pins underneath");
    serialStr = serialpins ? "inc serial pins" : "no serial pins";

    vitamin(
        "vitamins/ArduinoPro.scad",
        str("Arduino Pro ", type == ArduinoPro_Mini ? "Mini" : "Micro", " ",pinStr,", ",serialStr),
        str("ArduinoPro(type=ArduinoPro_",type == ArduinoPro_Mini ? "Mini" : "Micro",", headerpins=",headerpins,",serialpins=",serialpins,")")
    ) {
        view(d=140);
    }

    color(ArduinoPro_PCB_Colour)
    linear_extrude(ArduinoPro_PCB_Height)
    difference() {
        // Base PCB
        ArduinoPro_PCB();

        // Common Headers for Pro Mini/Micro
        ArduinoPro_Headers_Layout()
            ArduinoPro_Header_Hole();

        // Pro Mini Serial Header
        if (type == ArduinoPro_Mini) {
            ArduinoPro_Serial_Header_Layout()
                ArduinoPro_Header_Hole();
        }
    }

    // Pro Mini Serial Header Pins
    serialontop = (serialpins != ArduinoPro_Pins_Opposite);
    if (serialpins > 0 && type == ArduinoPro_Mini) {
        // Offset for board height if located on top
        translate([0, 0, serialontop ? ArduinoPro_PCB_Height : 0])
            mirror([0, 0, serialontop ? 0 : 1 ])
            ArduinoPro_Serial_Header_Layout()
                ArduinoPro_Header_Pin(rotation = 90);
    }

    // Common Header Pins
    headerontop = (headerpins == ArduinoPro_Pins_Opposite);
    if (headerpins > 0) {
        // Offset for board height located on top
        translate([0, 0, headerontop ? ArduinoPro_PCB_Height : 0])
            mirror([0, 0, headerontop ? 0 : 1 ])
            ArduinoPro_Headers_Layout()
                ArduinoPro_Header_Pin();
    }

    // Pro Micro USB port
    if (type == ArduinoPro_Micro) ArduinoPro_MicroUSB();

    // Surface mount components
    ArduinoPro_SMT_Components(type);
}



// Example Usage
// ArduinoPro(ArduinoPro_Micro, ArduinoPro_Pins_Normal);
// ArduinoPro(ArduinoPro_Mini,  ArduinoPro_Pins_Normal, ArduinoPro_Pins_Normal);
