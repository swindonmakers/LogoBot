include <../config/config.scad>


*random_voronoi(
    n = 100, nuclei = false, L = 100,
    thickness = 1, round = 0, min = 0, max = 100,
    seed = undef, center = true);

module specialVoronoi() {

    // distributes voronoi points in a circular band around the origin

    numPoints = 80;
    or = 60;
    ir = 30;

    function x(r,a) = r * cos(a);
    function y(r,a) = r * sin(a);

    point_set = [
        for (i=[0:numPoints-1])
            let (r = rands(ir,or,1)[0], a = rands(0,360,1)[0])
            [ x(r,a), y(r,a) ]
    ];

    for (p = point_set)
        color("red")
        translate([0,0,1])
        translate(p)
        circle(r=1);
    voronoi(point_set, L = 2*or, thickness = 1, round = 0, nuclei = false);
}


//specialVoronoi();


module polarVoronoi(points, or=50, L = 200, thickness = 1) {
	for (p = points) {
        //polarLat = atan2(p[1], p[0]);
        polarLon = sqrt(p[1]*p[1] + p[0]*p[0]);

        // calc rot vector
        rv = [ p[1], -p[0], 0 ];

        if (polarLon < 90 )
            rotate(a=-polarLon, v=rv)
            linear_extrude(or, scale=or)
            scale([1/or,1/or,1])
            translate([-p[0], -p[1], 0])
            intersection_for(p1 = points){
                if (p != p1) {
                    angle = 90 + atan2(p[1] - p1[1], p[0] - p1[0]);

                    translate((p + p1) / 2 - normalize(p1 - p) * (thickness))
                        rotate([0, 0, angle])
                        translate([-L, -L])
                        square([2 * L, L]);
                }
            }

	}
}

module polarVoronoiWrapper() {
    numPoints = 200;
    or = 70;
    ir = 20;

    function x(r,a) = r * cos(a);
    function y(r,a) = r * sin(a);

    seed = 137;
    rand_vec = [rands(10,110 * 1.1,numPoints,seed), rands(0,360,numPoints,seed+1)];

    point_set = [
        for (i=[0:numPoints-1])
            let (r = rand_vec[0][i], a = rand_vec[1][i])
            [ x(r,a), y(r,a) ]
    ];

    polarVoronoi(point_set, or=or, L = 2*or, thickness = 1.5);
}

polarVoronoiWrapper();
