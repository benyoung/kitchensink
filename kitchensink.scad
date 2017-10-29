mm=1;

tap_outer_radius = 49.8*mm/2;
tap_height=20*mm;

module tap_body() {
    cylinder(r=tap_outer_radius, h=tap_height);
}
*tap_body();

plastic_gasket_r1 = 43.4*mm;
plastic_gasket_r2 = 40.9*mm;
plastic_gasket_h1 = 0.5*mm;
plastic_gasket_h2 = 0.9*mm;
module plastic_gasket(){
    union(){
        translate([0,0,plastic_gasket_h2])
        cylinder(r=plastic_gasket_r1,h=plastic_gasket_h1);
        cylinder(r=plastic_gasket_r2,h=plastic_gasket_h1+plastic_gasket_h2);
    }
}
*plastic_gasket(); 

