/*
    Vitamin: SlideSwitch
    Model of various Slide Switches

    Derived from: http://www.maplin.co.uk/p/double-pole-sub-miniature-fh35q
        see also: http://www.edutronic.co.uk/examples/catalog.htm

    Authors:
        Jamie Osborne (@jmeosbn)

    Local Frame:
        Point of origin is through the centre of the bottom hole

    Parameters: none

    Returns:
        Model of a slide switch with mounting holes
*/


module SlideSwitch()
{

    plate_w =  7.0;
    plate_l = 23.0;
    plate_h =  1.0;         // FIXME: ASSUMED VALUE
    plate_r =  1.0;         // FIXME: ASSUMED VALUE
    centres = 19.0;         // distance between mounting holes
    holedia =  2.5;         // clearance for M2

    tang_w  =  4.0;         // FIXME: ASSUMED VALUE
    tang_d  =  4.0;         // FIXME: ASSUMED VALUE
    tang_h  =  7.5;
    tthrow  =  3.5;         // amount tang moves to actuate switch

    body_w  = 15.0;
    body_d  =  7.0;
    body_h  =  7.5;

    tags_w  =  1.5;
    tags_h  =  3.0;
    tags_d  =  1.0;         // FIXME: ASSUMED VALUE
    tags_x  =  4.0;         // FIXME: ASSUMED VALUE
    tags_y  =  4.0;         // FIXME: ASSUMED VALUE

    tags_a  =    2;         // amount of tags across
    tags_b  =    3;         // amount of tags down

    // Mounting Plate

    color(Grey60)
    translate([0, centres/2, 0])    // move origin to bottom hole
    linear_extrude(plate_h)
    {
        difference()
        {
            // mounting plate
            // TODO: Show rounded corners?
            roundedSquare(size=[plate_w, plate_l], radius=plate_r, center=true);

            // mounting holes
            translate([0, centres/2, 0])
                circle(d=holedia);
            translate([0, -centres/2, 0])
                circle(d=holedia);

            // tang hole
            square(size=[tang_w, tang_d + tthrow], center=true);
        }
    }

    // Switch Tang

    color(Grey50)
    translate([0, centres/2 + tthrow/2, 0])
    linear_extrude(tang_h)
    {
        square(size=[tang_w, tang_d], center=true);
    }

    // Switch Body

    color(Grey50)
    translate([0, centres/2, -body_h])
    linear_extrude(body_h)
    {
        square(size=[body_d, body_w], center=true);
    }

    // Switch Tags

    color("silver")
    translate([-tags_x * (tags_a-1)/2, centres/2-tags_y*(tags_b-1)/2, -body_h - tags_h])
    linear_extrude(tags_h)
    {
        for (x=[0 : tags_a-1], y=[0 : tags_b-1]) {
            translate([x * tags_x, y * tags_y, 0]) {
                square(size=[tags_d, tags_w], center=true);
            }
        }
    }
}


// Example Usage
// SlideSwitch();
