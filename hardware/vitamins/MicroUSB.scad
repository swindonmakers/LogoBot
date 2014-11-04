/*
    Vitamin: MicroUSB
    Model of a Micro USB receptacle

    TODO: Add different types of Micro USB Connectors

    Derived from: http://www.farnell.com/datasheets/1693470.pdf

    Authors:
        Jamie Osborne (@jmeosbn)

    Local Frame:
        Part width is in x+ (meeting PCB edge), depth is through center in y+

    Parameters:
        None

    Returns:
        Model of a Micro USB receptacle (SMT)
*/

// MicroUSB Variants
MicroUSB_Receptacle             = 0;            // default
// MicroUSB_Plug                = 1;            // not implemented


module MicroUSB_Receptacle()
{
    // dimensions for micro usb header
    // http://www.farnell.com/datasheets/1693470.pdf
    depth  = 5.3;
    width  = 7.5;
    height = 2.8;
    flange = 7.8;                 // width of front flange
    offset  = 2.15 + 0.6 - 1.45;  // distance to overhang board edge

    linear_extrude(height) {
        translate([0, offset - depth/2, 0])
            square(size=[flange, depth], center=true);
    }
}

module MicroUSB(type = MicroUSB_Receptacle)
{
    color(Grey90) {
        /* TODO: Add various MicroUSB types */
        MicroUSB_Receptacle();
    }
}
