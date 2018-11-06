$fn=32;

translate([0,0,45]) rotate(a=90, v=[0,1,0]) {
    difference() {
        mainBody(45,8,28);
        mainSubtractions(45,8,28);
    }
}

module cubeWithXHorizontalFillets(length, width, height, radius, center) {
    diameter = radius * 2;
    translate([0, radius/2, radius/2]) {
        minkowski() {
            cube([length/2, width-radius, height-radius]);
            rotate(a=90,v=[0,1,0]) cylinder(r=radius/2,h=length/2);
        } 
    }
}

module mainBody(length, width, height) {
    cubeWithXHorizontalFillets(length,width,height,6);
    translate([length-10,-5,-1]) cubeWithXHorizontalFillets(10,18,30,8);
}

module mainSubtractions(length, width, height) {
    offsetValue = length - 5;
    translate([10,0,8]) cube([35,8,12]);
    translate([0,4,14]) rotate(a=90,v=[0,1,0]) cylinder(h=10,r=2.1);
    translate([7,4,14]) rotate(a=90,v=[0,1,0]) cylinder($fn=6, h=3,r=3);
    translate([offsetValue,9,14]) scale([1.4,1,1]) rotate(a=90,v=[1,0,0]) halfCylinder(10,10.5);
    translate([offsetValue,-1,3.5]) cubeWithXHorizontalFillets(10,10,21,2);
    
    // Pully Hole
    translate([offsetValue,13,14]) rotate(a=90, v=[1,0,0]) cylinder(h=18,r=1.6);
    translate([offsetValue,13,14]) rotate(a=90, v=[1,0,0]) cylinder(h=1.5,r=3);
    translate([offsetValue,-4,14]) rotate(a=90, v=[1,0,0]) cylinder($fn=6, h=1.5,r=3.1);
}

module halfCylinder(height, radius) {
    difference() {
        cylinder(h=height,r=radius);
        translate([0,-radius,0]) cube([radius, radius*2, height]);
    }
}
