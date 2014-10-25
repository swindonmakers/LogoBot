include <maths.scad>
include <Renderer.scad>

/*

steps = 10;

cps = [
    [0,0,0],
    [0,50,00],
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
            
*/


steps = 20;

cps = [
    [0,30,0],
    [0,20,50],
    [90,0,30],
    [100,0,0]
];

cables = 5;
cableR = 0.5;
cableD = cableR*2;

cableColors = [
    "blue",
    "orange",
    "red",
    "pink",
    "yellow"
];

// vectors to align the strips of the ribbon
cv = [
    [0, 1 ,0],
    [0.3, 1, 0],
    [0.7, 0.3, 0],
    [1, 0,0]
];

cableWidth = (cables - 1) * cableD;

cps2 = [
    cps[0] + VNORM(cv[0]) * cableWidth,
    cps[1] + VNORM(cv[1]) * cableWidth,
    cps[2] + VNORM(cv[2]) * cableWidth,
    cps[3] + VNORM(cv[3]) * cableWidth
];

t = 2;
h = 5;

// alignment vector
va = [0,0,1];


for (cable= [0:cables-1])
    color(cableColors[cable])
    for (i=[0:steps-1])
        assign(u1=i/steps, u2 = (i+1.02)/steps)
        assign(
            p1 = berp(cps, u1),
            p2 = berp(cps2, u1),
            p3 = berp(cps, u2),
            p4 = berp(cps2, u2)
        )
        assign(
               n1 =  VNORM(VCROSS(berpTangent(cps, u1), p1-berp(cps2, u1))) *t,
               n2 = p2 - p1,
               n3 = p4 - p3
               )
        {    
            PlaceLine([
                p1 + n2 * cable/(cables-1), 
                p3 + n3 * cable/(cables-1)
            ], radius=cableR, $fn=6);
        }