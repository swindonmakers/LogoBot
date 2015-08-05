/*
	Vitamin:
		LED - Models of a 3mm and 5mm LEDs.

	Local Frame:
		Centred on the center of the base of the LED
*/

// LED Types
// Parameters are
//  [0] - dia,
//  [1] - height (excluding dome)
//  [2] - stepout, how much bigger the base diameter is than the main body diameter
//  [3] - RGB?
//  [4] - TypeSuffix
LED_3mm		= [ 3, 4, .75 , false, "3mm"];
LED_5mm		= [ 5, 6, .75 , false, "5mm"];
LED_RGB_5mm	= [ 5, 6, .75 , true,  "RGB_5mm"];

// Types collection
LED_Types = [
	LED_3mm,
	LED_5mm,
	LED_RGB_5mm
];

//Vitamin catalogue
module LED_Catalogue() {
    for (t = LED_Types) LED(t);
}

// Convenience Functions
module LED_3mm(color = "Red", legs = false) { LED(LED_3mm, color, legs); }
module LED_5mm(color = "Red", legs = false) { LED(LED_5mm, color, legs); }
module LED_RGB_5mm(color = "Red", legs = false) { LED(LED_RGB_5mm, color, legs); }

// Connector, center, base
LED_Con	= DefConDown;

module LED(LEDType = LED_3mm, color = "Red", legs = true) {

	dia = LEDType[0];
	height = LEDType[1];
	stepout = LEDType[2];
	isRgb = LEDType[3];
	ts = LEDType[4];

	baseDia = dia + stepout;

	if (DebugConnectors) {
		connector(LED_Con);
	}

	vitamin("vitamins/LED.scad", str(ts," LED"), str("LED(LEDType=LED_",ts,")")) {
        view(t=[23,9,3],r=[34,2,22],d=200);
    }

	color(color, 0.8) {
		linear_extrude(1)
		difference() {
			circle(r=baseDia/2);

			translate([-baseDia/2 - stepout/2, -baseDia/2, 0])
				square([stepout, baseDia]);
		}

		cylinder(r = dia/2, h = height);

		translate([0, 0, height])
			sphere(r = dia/2);
	}

	if (legs) {
		color(MetalColor) {
			if (isRgb) {
				translate([-1.2, 0, -14.5])
					cylinder(r=0.25, h=14.5);
				translate([-0.4, 0, -16.5])
					cylinder(r=0.25, h=16.5);
				translate([0.4, 0, -15.5])
					cylinder(r=0.25, h=15.5);
				translate([1.2, 0, -13.5])
					cylinder(r=0.25, h=13.5);
			}
			else {
				translate([-2.54/2, 0, -14.5])
					cylinder(r=0.25, h=14.5);
				translate([2.54/2, 0, -16.5])
					cylinder(r=0.25, h=16.5);
			}
		}
	}
}
