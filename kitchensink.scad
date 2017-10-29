mm=1;
eps = 0.01*mm;

tap_outer_radius = 49.8*mm/2;
tap_height=20*mm;
module tap_body() {
    color([0.9,0.9,0.9])
    cylinder(r=tap_outer_radius, h=tap_height);
}
*tap_body();

plastic_gasket_r1 = 43.4*mm/2; //closest to tap
plastic_gasket_r2 = 40.9*mm/2;
plastic_gasket_h1 = 0.5*mm;
plastic_gasket_h2 = 0.9*mm;
plastic_gasket_h=plastic_gasket_h1+plastic_gasket_h2;
module plastic_gasket(){
    color("gray")
    union(){
        translate([0,0,plastic_gasket_h2])
        cylinder(r=plastic_gasket_r1,h=plastic_gasket_h1);
        cylinder(r=plastic_gasket_r2,h=plastic_gasket_h1+plastic_gasket_h2);
    }
}
*plastic_gasket(); 

metal_ring_r1=34.8*mm/2; // bottom
metal_ring_r2=40.1*mm/2; // middle
metal_ring_r3=37.8*mm/2; //top
metal_ring_h1=2.8*mm; //bottom segment
metal_ring_h2=6.5*mm; // middle segment
metal_ring_h3=5.4*mm; //top segment
metal_ring_h=metal_ring_h1+metal_ring_h2+metal_ring_h3;
cutout_x = 24.7*mm;
cutout_z=4.6*mm;
module metal_ring() {
    color("orange")
    difference(){
        union(){
            cylinder(r1=metal_ring_r1,r2=metal_ring_r2,h=metal_ring_h1+eps);
            translate([0,0,metal_ring_h1])
            cylinder(r=metal_ring_r2,h=metal_ring_h2+eps);
            translate([0,0,metal_ring_h1+metal_ring_h2])
            cylinder(r1=metal_ring_r2,r2=metal_ring_r3,h=metal_ring_h3);
        }
        union(){
            translate([-cutout_x/2,-2*metal_ring_r2,-eps])
            cube([cutout_x,4*metal_ring_r2,cutout_z+eps]);
        }
    }
}
*metal_ring();

module tap(){
    translate([0,0,metal_ring_h+plastic_gasket_h])
    tap_body();
    translate([0,0,metal_ring_h])
    plastic_gasket();
    metal_ring();
}
tap();
