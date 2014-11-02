/*

	Playground for developing the vitamins/ArduinoPro.scad library

*/

include <../config/config.scad>

// include the ArduinoPro.scad library
include <../vitamins/ArduinoPro.scad>

// Set custom board properties
// ArduinoPro_PCB_Width  =  1.0 * 25.4;
// ArduinoPro_PCB_Length =  1.5 * 25.4;
// ArduinoPro_PCB_Colour = "green";


module ArduinoPro_Layout_Sandbox()
{
    // show pins in layout
    showpins = ArduinoPro_Pins_Normal;

    // how far apart to layout boards
    margin_x = ArduinoPro_PCB_Inset * 2;

    // amount origin is offset in board
    origin_o = ArduinoPro_PCB_Inset;

    // layout offsets to use in translate
    layout_o = origin_o + margin_x;
    layout_x = ArduinoPro_PCB_Width  - origin_o + margin_x;
    layout_y = ArduinoPro_PCB_Length - origin_o + margin_x;

    // Create an Arduino Pro Mini with header pins
    translate([-layout_x, layout_o, 0])
        ArduinoPro(ArduinoPro_Mini, showpins, showpins);

    // Create an Arduino Pro Micro with header pins
    translate([layout_o, layout_o, 0])
        ArduinoPro(ArduinoPro_Micro, showpins);

    // Create an Arduino Pro (common features only, pin mounting reversed)
    translate([-layout_x, -layout_y, 0])
        ArduinoPro(ArduinoPro_No_Port, showpins * ArduinoPro_Pins_Opposite);

    // Create an Arduino Pro Mini without any header pins
    translate([layout_o, -layout_y, 0])
        ArduinoPro(ArduinoPro_Mini);
}

ArduinoPro_Layout_Sandbox();