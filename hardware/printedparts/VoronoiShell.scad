
module VoronoiShell_STL(type=2) {
	printedPart(
		"printedparts/VoronoiShell.scad",
		str("Voronoi Shell Type",type),
		str("VoronoiShell_STL(type=",type,")")
	) {
	    view(t=[-2, 6, 14], r=[63, 0, 26], d=726);

        color([Level2PlasticColor[0], Level2PlasticColor[1], Level2PlasticColor[2], 1])
             if (UseSTL) {
                import(str(STLPath, str("VoronoiShellType",type,".stl")));
            } else {
				if (type==1) {
					VoronoiShell_Model_1();
				} else{
					VoronoiShell_Model_2();
				}
            }
    }
}


module VoronoiShell_Model_1() {

	sw = 2 * perim;

	or = BaseDiameter/2 + Shell_NotchTol + dw;

	sr = or - sw + eta;

	supportAngle = 50;
	bridgeDist = 5;

	numRibs1 = round(circumference(sr * cos(supportAngle)) / bridgeDist);
	numRibs = 4 * (floor(numRibs1 / 4) + 1);

	ribThickness = 0.7;

	$fn=64;

	// shell with hole for LED
	//render()
		difference() {
			union() {
				// curved shell with centre hole for pen
				difference() {
					rotate_extrude()
						difference() {
							// outer shell
							donutSector(
								or=or,
								ir=BaseDiameter/2 + Shell_NotchTol,
								a=90
							);

							polygon(
								[
									[0, ShellOpeningHeight + 1000],
									[ShellOpeningDiameter/2 + 1000, ShellOpeningHeight + 1000],
									[ShellOpeningDiameter/2 - dw - 1, ShellOpeningHeight - dw - 1],
									[0, ShellOpeningHeight - dw - 1]
								]);

						}

					difference() {
						linear_extrude(or)
							random_voronoi(
								n = 240, nuclei = false,
								L = or+30, thickness = 1,
								round = 1, min = 0, max = 2*or,
								seed = 7, center = true
							);

						// hollow the middle of the voronoi mesh
						cylinder(r=ShellOpeningDiameter/2 + 5, h=or);
					}

				}



				// twist lock
				Shell_TwistLock();
			}
		}
}



module polarVoronoi(points, or=50, L = 200, thickness = 1) {
	for (p = points) {
        //polarLat = atan2(p[1], p[0]);
        polarLon = sqrt(p[1]*p[1] + p[0]*p[0]);

		t = thickness * polarLon / 90;

        // calc rot vector
        rv = [ p[1], -p[0], 0 ];

        if (polarLon < 90 )
            rotate(a=-polarLon, v=rv)
            linear_extrude(or, scale=or)
            scale([1/or,1/or,1])
            translate([-p[0], -p[1], 0])
            intersection_for(p1 = points){
                if (p != p1) {
					dsqr = (p[1] - p1[1])*(p[1] - p1[1]) +  (p[0] - p1[0])*(p[0] - p1[0]);
					if (dsqr < or*or) {
						angle = 90 + atan2(p[1] - p1[1], p[0] - p1[0]);

	                    translate((p + p1) / 2 - normalize(p1 - p) * (t))
	                        rotate([0, 0, angle])
	                        translate([-L, -L])
	                        square([2 * L, L]);
					}
                }
            }

	}
}

module polarVoronoiWrapper() {
    numPoints = 300;
    or = BaseDiameter/2 + Shell_NotchTol + dw + 2;

    function x(r,a) = r * cos(a);
    function y(r,a) = r * sin(a);

    seed = 139;
    rand_vec = [rands(20,110 * 1.1,numPoints,seed), rands(0,360,numPoints,seed+1)];

    point_set = [
        for (i=[0:numPoints-1])
            let (r = rand_vec[0][i], a = rand_vec[1][i])
            [ x(r,a), y(r,a) ]
    ];

	polarVoronoi(point_set, or=or, L = 2*or, thickness = 1.5);
}


module VoronoiShell_Model_2() {

	sw = 2 * perim;

	or = BaseDiameter/2 + Shell_NotchTol + dw;

	sr = or - sw + eta;

	supportAngle = 50;
	bridgeDist = 5;

	numRibs1 = round(circumference(sr * cos(supportAngle)) / bridgeDist);
	numRibs = 4 * (floor(numRibs1 / 4) + 1);

	ribThickness = 0.7;

	$fn=64;

	// shell with hole for LED
	//render()
		difference() {
			union() {
				// skirt
				rotate_extrude()
					donutSector(
						or=or,
						ir=BaseDiameter/2 + Shell_NotchTol,
						a=8
					);

				// shell coupling
				rotate_extrude()
					difference() {
						// skirt
						rotate([0,0,55])
							donutSector(
								or=or,
								ir=BaseDiameter/2 + Shell_NotchTol,
								a=10
							);

						polygon(
							[
								[0, ShellOpeningHeight + 1000],
								[ShellOpeningDiameter/2 + 1000, ShellOpeningHeight + 1000],
								[ShellOpeningDiameter/2 - dw - 1, ShellOpeningHeight - dw - 1],
								[0, ShellOpeningHeight - dw - 1]
							]);

					}


				difference() {
					rotate_extrude()
						donutSector(
							or=or,
							ir=BaseDiameter/2 + Shell_NotchTol,
							a=57
						);

					polarVoronoiWrapper();
				}


				// twist lock
				Shell_TwistLock();
			}
		}
}
