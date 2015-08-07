include <../config/config.scad>


*random_voronoi(
    n = 100, nuclei = false, L = 100,
    thickness = 1, round = 0, min = 0, max = 100,
    seed = undef, center = true);

module specialVoronoi() {

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


specialVoronoi();
