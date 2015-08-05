/*
    Vitamin: ESP8266

    Local Frame:
*/

// getters
function ESP8266_TypeSuffix(t)      = t[0];

// types
//             TypeSuffix,
ESP8266_01 =  ["01"        ];

// type collection
ESP8266_Types = [
    ESP8266_01
];

// Vitamin Catalogue
module ESP8266_Catalogue() {
    for (t = ESP8266_Types) ESP8266(t);
}

// Connectors
ESP8266_Con_Def				= [ [0,0,0], [0,0,-1], 0, 0, 0];

ESP8266_01_Con_Header1       = [ [(14.3 - 3*2.54)/2, 2.54/2, -2.5], [0,0,-1], 0, 0, 0];
ESP8266_01_Con_Header2       = [ [(14.3 - 3*2.54)/2, 3*2.54/2, -2.5], [0,0,-1], 0, 0, 0];


module ESP8266(type=ESP8266_01) {
    ts = ESP8266_TypeSuffix(type);

    vitamin("vitamins/ESP8266.scad", str("ESP8266 ",ts), str("ESP8266(ESP8266_",ts,")")) {
        view(t=[6.9, 13.6, 10.3], r=[72,0,33], d=280);

        if (DebugCoordinateFrames) frame();
        if (DebugConnectors) {
            connector(ESP8266_Con_Def);
        }

        // variants
        if (type == ESP8266_01) ESP8266_01();
    }
}

module ESP8266_01() {

    if (DebugConnectors) {
        connector(ESP8266_01_Con_Header1);
        connector(ESP8266_01_Con_Header2);
    }

    // pcb
    color([0.2,0.3,0.6])
        cube([14.3, 24.8, 1]);

    // big chips
    color(Grey20)
        translate([1,7,1])
        cube([7,7,1]);

    color(Grey20)
        translate([9,8,1])
        cube([5,4,1]);

    // header pins
    // TODO: Split pinstrip out into separate vitamin
    attach(offsetConnector(ESP8266_01_Con_Header1, [0,0,2.5]), DefConUp, ExplodeSpacing=0)
        PcbPinStrip(numPins = 4, a = 180, spacers = true);

    attach(offsetConnector(ESP8266_01_Con_Header2, [0,0,2.5]), DefConUp, ExplodeSpacing=0)
        PcbPinStrip(numPins = 4, a = 180, spacers = true);

}
