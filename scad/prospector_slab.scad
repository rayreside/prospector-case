// Prospector dongle case -- layout C, the slab.
//
// Display and hat lie back to back, both parallel to the screen, and the whole
// sandwich leans on the desk at the measured 55 degrees. This is the only one
// of the three candidate layouts that keeps the screen angle: the wedge and
// the tail-out-the-back both need the screen steepened before the hat fits.
//
// FRAME. As prospector.scad: +x right facing the screen, +y away from you,
// +z up, z = 0 the desk, and the model symmetric about x = 0.
//
// WHAT DECIDES THIS LAYOUT. Everything hangs on GAP -- the room between the
// module's back and the hat for two plugs and the cable between them. The slab
// is 22.4 + GAP thick along the screen normal, so GAP is not a detail, it is
// the design. At GAP = 2 this is the smallest thing on the table; by GAP = 8
// it is no better than upstream. The plug height is still an estimate, so
// treat the figures here as a sensitivity, not a result.

include <prospector_hw.scad>

/* [What to build] */
part   = "all";       // all | shell | cap
GAP    = 8.00;        // *** the number this layout lives or dies on
cut    = "";          // "" | x | y | z
cut_at = 0;
cut_flip = false;
show_parts = true;

$fa = 2; $fs = 0.4;

TILT   = TILT_UPSTREAM;   // the whole point of this layout
DISP_LIFT = 2.00;     // desk to the lowest point of the pocket
CAP_T  = 1.60;
SEAT   = 2.50;
HAT_V  = 4.55;        // hat's offset up the screen, from centre

/* ---------- derived ---------- */
POCK_W = DISP_W + 2 * DISP_CLR;
POCK_H = DISP_H + 2 * DISP_CLR;
POCK_R = DISP_R + DISP_CLR;
SEC_W  = POCK_W + 2 * BEZEL;
SEC_H  = POCK_H + 2 * BEZEL;

W_RIM  = DISP_T + LIP;                    // front face, w from the module back
W_HAT  = -(GAP + MCU_H);                  // hat's far face
W_BACK = W_HAT - CAP_T;                   // outside of the back
SLAB_T = W_RIM - W_BACK;

// The slab has to clear the desk twice over: the module's pocket must not dip
// below the floor, and neither must the hat's lower-back corner, which is the
// part that actually digs in because it is furthest back along the normal.
CZ_DISP = DISP_LIFT + POCK_H / 2 * sin(TILT);
CZ_HAT  = WALL - (HAT_V - MCU_D / 2 - MCU_CLR) * sin(TILT) - W_BACK * cos(TILT);
CZ = max(CZ_DISP, CZ_HAT);
CY = SEC_H / 2 * cos(TILT) + W_RIM * sin(TILT);

echo(str("slab ", SLAB_T, " thick along the normal, GAP ", GAP));
echo(str("height driven by ", CZ_HAT > CZ_DISP ? "the HAT's back corner" : "the display", ", CZ ", CZ));

/* ---------- primitives ---------- */

module rrect(w, h, r) { offset(r = r) square([w - 2 * r, h - 2 * r], center = true); }

module band(w, h, r, w0, w1, dv = 0) {
    translate([0, CY, CZ]) rotate([TILT, 0, 0])
        translate([0, dv, w0]) linear_extrude(w1 - w0) rrect(w, h, r);
}

module desk(floor = 0) {
    translate([-100, -100, floor]) cube(200);
}

/* ---------- the case ---------- */

module outer() {
    intersection() { band(SEC_W, SEC_H, RIM_R, W_BACK, W_RIM); desk(); }
}

module hollow() {
    band(POCK_W, POCK_H, POCK_R, 0, DISP_T);                       // module
    band(POCK_W - 2 * LIP, POCK_H - 2 * LIP,                       // window
         max(POCK_R - LIP, 0.5), DISP_T, W_RIM + 1);
    intersection() {                                               // cavity
        band(SEC_W - 2 * WALL, SEC_H - 2 * WALL, RIM_R - WALL,
             W_BACK, -WALL);
        desk(WALL);
    }
}

// USB-C leaves along the hat's long axis, so it goes out the side wall. That
// is the price of this layout and there is no way round it: the port is on
// the board edge and the board is parallel to the screen.
module usb_slot() {
    translate([0, CY, CZ]) rotate([TILT, 0, 0])
        translate([SEC_W / 2, HAT_V - MCU_D / 2 + USB_Z + MCU_CLR,
                   W_HAT + MCU_H / 2])
            cube([WALL * 6, USB_H, USB_W], center = true);
}

module mcu_box() {
    band(MCU_W + 2 * MCU_CLR, MCU_D + 2 * MCU_CLR, 1.0,
         W_HAT, W_HAT + MCU_H, HAT_V);
}

module shell() {
    difference() {
        outer();
        hollow();
        mcu_box();
        usb_slot();
        band(200, 200, 0.1, W_BACK - 60, W_BACK + CAP_T);          // cap slab
    }
}

module cap() {
    difference() {
        intersection() { outer(); band(200, 200, 0.1, W_BACK, W_BACK + CAP_T); }
        usb_slot();
    }
}

/* ---------- the hardware, for looking at ---------- */

module ghost_display() {
    color("SteelBlue", 0.55) band(DISP_W, DISP_H, DISP_R, 0, DISP_T);
    color("DimGray", 0.35)   band(ACT_W, ACT_H, 1.5, DISP_T, DISP_T + 0.1);
}
module ghost_mcu() {
    color("DarkSalmon", 0.6) band(MCU_W, MCU_D, 1.0, W_HAT, W_HAT + MCU_H, HAT_V);
}

module assembly() {
    if (part == "all" || part == "shell") color("Gainsboro") shell();
    if (part == "all" || part == "cap")   color("DarkSalmon") cap();
    if (show_parts && part != "cap") { ghost_display(); ghost_mcu(); }
}

module keep() {
    B = 500; o = cut_flip ? -B : 0;
    if (cut == "x") translate([cut_at + o, -250, -250]) cube(B);
    else if (cut == "y") translate([-250, cut_at + o, -250]) cube(B);
    else if (cut == "z") translate([-250, -250, cut_at + o]) cube(B);
}

if (cut == "") assembly();
else difference() { assembly(); keep(); }
