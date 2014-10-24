include <maths.scad>

steps = 10;

cps = [
    [0,0,0],
    [0,50,0],
    [50,50,0],
    [100,0,0]
];

t = 2;
h = 5;

linear_extrude(h)
    union()
    for (i=[0:steps-1])
        assign(p1 = berp(cps, i/steps),
               n1 = VNORM(VSWAP(berpTangent(cps, i/steps)))*t,
               p2 = berp(cps, (i+1)/steps),
               n2 = VNORM(VSWAP(berpTangent(cps, (i+1)/steps)))*t)
        polygon([
            [p1[0], p1[1]],
            [p1[0] + n1[0], p1[1] + n1[1]],
            [p2[0] + n2[0], p2[1] + n2[1]],
            [p2[0], p2[1]]
            ], 4);