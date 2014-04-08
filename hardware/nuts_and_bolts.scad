include <units.scad>
// Copyright 2010 D1plo1d
// modified by Ben Howes 2012
// uses hexagon module from https://github.com/josefprusa/PrusaMendel

// This library is dual licensed under the GPL 3.0 and the GNU Lesser General Public License as per http://creativecommons.org/licenses/LGPL/2.1/ .

module test1()
{
	$fn = 360;

	translate([0,15])
		nutHole(3, proj=-1);
	boltHole(3, length= 30,tolerance=10, proj=-1);

}
//test1();

module test2()
{
	$fn = 360;
	difference(){
		cube(size = [10,20,10], center = true);
		union(){
			translate([0,15])
				nutHole(3, proj=2);
			linear_extrude(height = 20, center = true, convexity = 10, twist = 0)
			boltHole(3, length= 30, proj=2);
		}
	}
}
//test2();

MM = "mm";
INCH = "inch"; //Not yet supported

//Based on: http://www.roymech.co.uk/Useful_Tables/Screws/Hex_Screws.htm
METRIC_NUT_AC_WIDTHS =
[
	-1, //0 index is not used but reduces computation
	-1,
	-1,
	6.40,//m3
	8.10,//m4
	9.20,//m5
	11.50,//m6
	-1,
	15.00,//m8
	-1,
	19.60,//m10
	-1,
	22.10,//m12
	-1,
	-1,
	-1,
	27.70,//m16
	-1,
	-1,
	-1,
	34.60,//m20
	-1,
	-1,
	-1,
	41.60,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	53.1,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	63.5//m36
];
METRIC_NUT_THICKNESS =
[
	-1, //0 index is not used but reduces computation
	-1,
	-1,
	2.40,//m3
	3.20,//m4
	4.00,//m5
	5.00,//m6
	-1,
	6.50,//m8
	-1,
	8.00,//m10
	-1,
	10.00,//m12
	-1,
	-1,
	-1,
	13.00,//m16
	-1,
	-1,
	-1,
	16.00//m20
	-1,
	-1,
	-1,
	19.00,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	24.00,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	29.00//m36
];

COARSE_THREAD_METRIC_BOLT_MAJOR_DIAMETERS =
[//based on max values
	-1, //0 index is not used but reduces computation
	-1,
	-1,
	2.98,//m3
	3.978,//m4
	4.976,//m5
	5.974,//m6
	-1,
	7.972,//m8
	-1,
	9.968,//m10
	-1,
	11.966,//m12
	-1,
	-1,
	-1,
	15.962,//m16
	-1,
	-1,
	-1,
	19.958,//m20
	-1,
	-1,
	-1,
	23.952,//m24
	-1,
	-1,
	-1,
	-1,
	-1,
	29.947,//m30
	-1,
	-1,
	-1,
	-1,
	-1,
	35.940//m36
];

module hexagon(height, depth) {
	boxWidth=height/1.75;
	union(){
		cube([boxWidth, height, depth], true);
		rotate([0,0,60]) cube([boxWidth, height, depth], true);
		rotate([0,0,-60]) cube([boxWidth, height, depth], true);
	}
}

module nutHole(size, units=MM, tolerance = +0.0001, proj = -1)
{
	//takes a metric screw/nut size and looksup nut dimensions
	radius = METRIC_NUT_AC_WIDTHS[size]+2*tolerance;
	height = METRIC_NUT_THICKNESS[size]+tolerance*2;
	if (proj == -1)
	{
		translate([0,0,(height/2)-tolerance]) hexagon(height=radius, depth=height);
	}
	if (proj == 1)
	{
		circle(r= radius, $fn = 6);
	}
	if (proj == 2)
	{
		translate([-radius/2, 0])
			square([radius*2, height]);
	}
}

module boltHole(size, units=MM, length, tolerance = +0.0001, proj = -1)
{
	radius = COARSE_THREAD_METRIC_BOLT_MAJOR_DIAMETERS[size]/2+tolerance;

	capHeight = METRIC_NUT_THICKNESS[size]+tolerance; //METRIC_BOLT_CAP_HEIGHTS[size]+tolerance;
	capRadius = METRIC_NUT_AC_WIDTHS[size]/2+tolerance; //METRIC_BOLT_CAP_RADIUS[size]+tolerance;

	if (proj == -1)
	{
	translate([0, 0, -capHeight-epsilon])
		//cylinder(r= capRadius, h=capHeight+2*epsilon);
		nutHole(size=size, units=units, tolerance = tolerance, proj = proj);
	cylinder(r = radius, h = length);
	}
	if (proj == 1)
	{
		circle(r = radius);
	}
	if (proj == 2)
	{
		translate([-capRadius, -capHeight])
			square([capRadius*2, capHeight]);
		translate([-radius,0])
			square([radius*2, length]);
	}
}