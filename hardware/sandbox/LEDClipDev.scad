/*

	Playground for developing the vitamins/LEDClip.scad library

*/

include <../config/config.scad>

// include the LEDClip.scad library
include <../vitamins/LEDClip.scad>

// include the LED.scad library
include <../vitamins/LED.scad>

module LEDClip_Layout_Sandbox()
{
    // normal recessed clip for 5mm LED
    LEDClip();
    // show with LED
    translate([0, 0, 3 - 8.6])
        LED(LED_5mm);

    // closed (with diffuser) for 5mm LED
    color("white", 0.6) {
        translate([12, 0, 0])
            LEDClip(LEDClip_Closed);
    }
    // show with LED
    translate([12, 0, 2 - 8.6])
        LED(LED_5mm);

}

LEDClip_Layout_Sandbox();
