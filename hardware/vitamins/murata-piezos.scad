$fs=0.1;

*murata_PKM12EPYH4002_B0();

// page 7: diaphram, external drive type
module murata_7BB_12_9  () {murata_7series(12.0, 9.0,  8.0, 0.22, 0.10);} // Brass
module murata_7BB_15_6  () {murata_7series(15.0, 10.0, 9.0, 0.22, 0.10);} // Brass
module murata_7BB_20_3  () {murata_7series(20.0, 14.0, 12.8, 0.22, 0.10);} // Brass
module murata_7BB_20_6  () {murata_7series(20.0, 14.0, 12.8, 0.42, 0.20);} // Brass
module murata_7BB_20_6L0() {murata_7series(20.0, 14.0, 12.8, 0.42, 0.20);} // Brass (with Lead Wire: AWG32 Length 50mm)
module murata_7BB_27_4  () {murata_7series(27.0, 19.7, 18.2, 0.54, 0.30);} // Brass
module murata_7BB_27_4L0() {murata_7series(27.0, 19.7, 18.2, 0.54, 0.30);} // Brass (with Lead Wire:AWG32 Length 50mm)
module murata_7BB_35_3  () {murata_7series(35.0, 25.0, 23.0, 0.53, 0.30);} // Brass
module murata_7BB_35_3L0() {murata_7series(35.0, 25.0, 23.0, 0.53, 0.30);} // Brass (with Lead Wire:AWG32 Length 50mm)
module murata_7BB_41_2  () {murata_7series(41.0, 25.0, 23.0, 0.63, 0.40);} // Brass
module murata_7BB_41_2L0() {murata_7series(41.0, 25.0, 23.0, 0.63, 0.40);} // Brass (with Lead Wire:AWG32 Length 50mm)
module murata_7NB_31R2_1() {murata_7series(31.2, 19.7, 18.2, 0.22, 0.10);} // Iron Nickel Alloy

// page 8: diaphram, self drive type
module murata_7BB_20_6C()   {murata_7series(20.0, 14.0, 12.8, 0.42, 0.20);} // Brass
module murata_7BB_20_6CL0() {murata_7series(20.0, 14.0, 12.8, 0.42, 0.20);} // Brass (with Lead Wire: AWG32 Length 50mm)
module murata_7BB_27_4C()   {murata_7series(27.0, 19.7, 18.2, 0.54, 0.30);} // Brass
module murata_7BB_27_4CL0() {murata_7series(27.0, 19.7, 18.2, 0.54, 0.30);} // Brass (with Lead Wire: AWG32 Length 50mm)
module murata_7BB_35_3C()   {murata_7series(35.0, 25.0, 23.0, 0.53, 0.30);} // Brass
module murata_7BB_35_3CL0() {murata_7series(35.0, 25.0, 23.0, 0.53, 0.30);} // Brass (with Lead Wire:AWG32 Length 50mm)
module murata_7BB_41_2C()   {murata_7series(41.0, 25.0, 23.0, 0.63, 0.40);} // Brass
module murata_7BB_41_2CL0() {murata_7series(41.0, 25.0, 23.0, 0.63, 0.40);} // Brass (with Lead Wire: AWG32 Length 50mm)
module murata_7SB_34R7_3C() {murata_7series(34.7, 25.0, 23.4, 0.50, 0.25);} // Stainless

// names are from http://docs-europe.electrocomponents.com/webdocs/0873/0900766b808736e6.pdf page 7
// D: plate size diameter (of lower bit)
// a: element size (thin plastic bit between the two metalic bits)
// b: electrode size (top metal bit)
// T: thickness (overall)
// t: plate thickness (top -- unclear if includes electrode)
module murata_7series(D, a, b, T, t) {
  plate_thick = t;
  element_thick = (T-t)/2;
  electrode_thick = (T-t)/2;
  cylinder(r=D/2, h=plate_thick);
  translate([0, 0, plate_thick])
    cylinder(r=a/2, h=element_thick);
  translate([0, 0, plate_thick+element_thick])
    cylinder(r=b/2, h=plate_thick);
}



// page 10: sounders, external drive, pin type
// These, somewhat oddly, don't have named parameters, just diagrams for each one, so the 
// parameter names here are my own invention.
module murata_PKM12EPYH4002_B0() {
 murata_PKM_cyl_type(od = 12.6, height_to_pcb = 6.9, height_gap = 0.9, lead_sep = 5.0, lead_dia = 0.5, lead_top_dia = 2.5, lead_len = 3.5, nub_dia = 1, nub_sep = 7.5);
}

module murata_PKM17EPP_2002_B0() {
 murata_PKM_cyl_type(od = 17.0, height_to_pcb = 8.6, height_gap = 1.2, lead_sep = 10.0, lead_dia = 0.5, lead_top_dia = 3.5, lead_len = 3.5, nub_dia = 1.2, nub_sep = 11);
}



module murata_PKM_cyl_type(od, height_to_pcb, height_gap, lead_sep, lead_dia, lead_top_dia, lead_len, nub_dia, nub_sep) {
 translate([0, 0, height_gap])
  cylinder(r=od/2, h=height_to_pcb-height_gap);

 // leads
 for (side=[-1, 1]) {
  translate([side * lead_sep/2, 0, 0]) {
   translate([0, 0, -lead_len+height_gap])
    cylinder(r=lead_dia/2, h=lead_len);
   cylinder(r=lead_top_dia/2, h=height_gap);
  }
 }

 // nubs
 for (side=[-1, 1]) {
  translate([0, side * nub_sep/2, 0]) {
   cylinder(r=nub_dia/2, h=height_gap);
  }
 }
}

*murata_PKM12EPYH4002_B0();