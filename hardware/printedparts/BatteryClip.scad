
BatteryPack_Width = 32.5;
BatteryPack_Height = 31;
Battery_Dia = 15;

BatteryClip_Con_Pin = [[0, -BatteryPack_Height/2 - 4Perim, 5/2], [0,-1,0], 0,0,0];

module BatteryClip_STL()
{
	printedPart("printedparts/BatteryClip.scad", "Battery Clip", "BatteryClip_STL()") {

		view(t=[0,0,0],r=[145,135,0],d=150);

		if (DebugCoordinateFrames) frame();
		if (DebugConnectors) connector(BatteryClip_Con_Pin);

		color(Level2PlasticColor) {
			if (UseSTL) {
				import(str(STLPath,"BatteryClip.stl"));
			} else {
				BatteryClipModel();
			}
		}
	}
}

module BatteryClipModel()
{
	break = BatteryPack_Width - 15;

	linear_extrude(5)
	difference() {
		batteryOutline(BatteryPack_Width + 2 * 4Perim, BatteryPack_Height + 2 * 4Perim, Battery_Dia);
		batteryOutline(BatteryPack_Width, BatteryPack_Height, Battery_Dia);

		translate([-break/2, 0, 0])
			square([break, BatteryPack_Height]);
	}

	translate([0, -BatteryPack_Height/2 - 4Perim, 0])
	mirror([0, 1, 0])
	render()
		pintack(side=true, h=2.25 + 3, bh=0);
}

module batteryOutline(pw, ph, bd)
{
	hull()
	for (i=[0, 1], j=[0, 1])
	mirror([i, 0, 0])
	mirror([0, j, 0])
	translate([pw/2 - bd/2, ph/2 - bd/2])
		circle(d=bd);
}