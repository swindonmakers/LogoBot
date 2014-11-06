/*
    Vitamin: LEDClip
    Model of an LED Clip

    Derived from: http://www.farnell.com/datasheets/1833430.pdf

    Authors:
        Jamie Osborne (@jmeosbn)

    Local Frame:
        Point of origin is through the centre of the shoulder mount

    Parameters: none

    Returns:
        Model of a an LED Clip
*/


// LEDClip Variants
LEDClip_Normal                  = 0;            // default / recessed
LEDClip_Closed                  = 1;            // closed (for diffuser)
// LEDClip_Prominent            = 2;            // not implemented


module LEDClip_Standard(EndType = LEDClip_Normal)
{
    LEDSize     =  5.0;
    LEDCollar   =  5.9;
    LEDHeight   =  8.6;
    EndCapDia   =  9.5;
    EndCapLen   =  3.0;
    EndCapDep   =  1.0;
    WallThick   =  1.0;
    BarrelDia   =  7.9;
    TotalLength = 15.0;

    // End cap

    translate([0, 0, EndCapLen - EndCapDep])
    linear_extrude(EndCapDep)
    {
        difference() {
            circle(d = EndCapDia);

            if (EndType == LEDClip_Normal) {
                // NOTE: LED can sit `EndCapDep` higher
                circle(d = LEDSize + 0.25);
            }
        }
    }

    // End cap wall (drawn at origin)

    linear_extrude(EndCapLen - EndCapDep)
    {
        difference() {
            circle(d = EndCapDia);
            circle(d = EndCapDia - WallThick*2);
        }
    }

    // Joining material (to barrel)

    linear_extrude(WallThick)
    {
        difference() {
            circle(d = EndCapDia - WallThick*2);
            circle(d = BarrelDia - WallThick*2);
        }
    }

    // Barrel

    translate([0, 0, EndCapLen - TotalLength])
    linear_extrude(TotalLength - EndCapLen)
    {
        difference() {
            circle(d = BarrelDia);
            circle(d = BarrelDia - WallThick*2);
        }
    }

}


module LEDClip(EndType = LEDClip_Normal)
{
    // Draw and colour LED Clip
    color(Grey50) {
        LEDClip_Standard(EndType);
    }
}


// Example Usage
// LEDClip();
