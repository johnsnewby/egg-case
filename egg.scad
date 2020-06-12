egginess = 0; //[-100:100]

length = 68;
thickness = 5;
band_width = 5;
translate([length/2,0,0])
    half_eggshell_with_band(length, thickness, band_width);

module half_eggshell_with_band(height, thickness, width) {
   difference() {
        half_eggshell(height+thickness, thickness);
        band(height + thickness + 1, thickness, width);
    }
}

module half_eggshell(height, thickness) {
    peg(height, thickness);    
    difference() {
        half_egg(height);
        translate([-thickness,0,0]) half_egg(height-(thickness*2));
        rotate([180,0,0]) peg(height, thickness + 1);
    }
}

module band(height, thickness, width) {
   intersection() {
        half_eggshell(height, thickness/4);
        translate([-(0.4 * height), 0, 0]) rotate([0,90,0]) cylinder(h = width, r  = height, center = true);
       }
}

module peg(height,thickness) {
    translate([-height/3, height/3-thickness/3, 0]) cylinder(1);
}


module half_egg(h) {
    rotate([0,0,180])
    difference() {
        rotated_egg(curveFactor = (100 + egginess) / 100, height = h);
        translate([0,-(h/2),0])
        cube([h,h,h], center=false);
    }
}


module rotated_egg(steps = 60, height = 100, curveFactor = 1, faces = 45) {
    rotate([180,270,0])egg(steps,height,curveFactor,faces);
}

module egg( steps = 60, height = 100, curveFactor = 1, faces = 45 ) {	
    a = height;
    b = height * (0.78 * curveFactor);  //Through keen observation I have determined that egginess should be 0.78

    //Equation for the egg curve
    function eggCurve( offset ) = sqrt( 
                                  a - b - 2 * offset * step 
                                  + sqrt( 4 * b * offset * step + pow(a - b, 2) ) ) 
                                  * sqrt(offset * step) / sqrt(2);
	
	step = a / steps;
	union() {
        //This resembles the construction of a UV sphere
        //A series of stacked cylinders with slanted sides
        for( i = [0:steps]) {
		  //echo(i * step);
		  translate( [0, 0, a - ( i + 1 ) * step - 0.01] )
		    cylinder( r1 = eggCurve( i + 1 ),
		              r2 = eggCurve( i ), 
		              h = step,
		              $fn = faces );
		}
    }
}