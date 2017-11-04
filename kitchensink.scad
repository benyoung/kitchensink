mm=1;
eps = 0.01*mm;
$fn=100;

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

slop = 0.15*mm;
metal_ring_r1=34.8*mm/2+slop; // bottom
metal_ring_r2=40.1*mm/2+slop; // middle
metal_ring_r3=37.8*mm/2+slop; //top
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
            cylinder(r1=metal_ring_r2,r2=metal_ring_r3,h=metal_ring_h3+eps);
        }
        union(){
            for(rot=[0,180]){
                rotate([0,0,rot])
                translate([cutout_x/2,-2*metal_ring_r2,-eps])
                cube([cutout_x,4*metal_ring_r2,cutout_z+eps]);
            }
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
*tap();

sink_hole_depth=20*mm; // made-up number
sink_hole_radius=42.3*mm/2;
sink_hole_outer_radius =tap_outer_radius; 
module sink_hole() {
    difference(){
        union(){
            translate([0,0,-sink_hole_depth])
            cylinder(r=sink_hole_outer_radius, h=sink_hole_depth);
        }
        union(){
             translate([0,0,-sink_hole_depth-eps])
             cylinder(r=sink_hole_radius, h=sink_hole_depth+2*eps,$fn=16);
             // make hole artificially chunky to cause ribs on gasket
        }
    }
}
//sink_hole();

collar_sep = 26.9*mm;
collar_z=5*mm; // really 2mm - artifically bigger
collar_y=2*sink_hole_outer_radius; // made-up number
collar_x=sink_hole_outer_radius;//made-up number
notch_x = 2*mm;
notch_y = 7*mm;
notch_placement=17.7*mm; // tweak until notch is at the side
module sink_collar(){
    for(rot=[0,180])
    rotate([0,0,rot])
    translate([collar_sep/2,-collar_y/2,-collar_z])
    cube([collar_x,collar_y,collar_z]);
    
    color("red")
    translate([collar_sep/2-notch_x,-notch_placement,-collar_z])
    cube([notch_x+eps,notch_y,collar_z]);
}
//sink_collar();

collar_z_offset=9.8*mm;
module sink(){
    sink_hole();
    translate([0,0,-collar_z_offset])
    sink_collar();
}
//sink();

tap_z = -15.5*mm; // tweak until it looks spiffy
module sink_assembly() {
    sink();
    translate([0,0,tap_z])
    tap();
}
*sink_assembly();

gasket_z = -10.5*mm;
gasket_h = 9.7*mm;
gasket_inner_hole_rad = cutout_x/2;
lop=0.8*mm;
cut_size=80*mm;
module gasket(){
    difference() {
        union() {
            translate([0,0,gasket_z])
            cylinder(r=tap_outer_radius-eps,h=gasket_h-eps);
        }
        union() {
            color("red")
            cube([cut_size,lop,cut_size],center=true);
            cylinder(r=gasket_inner_hole_rad,h=4*gasket_h, center=true);
            sink_assembly();
        }
    }
}
rotate([180,0,0])
gasket();




