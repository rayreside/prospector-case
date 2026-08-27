// The plug-in fitting, shared by the case's sockets and by anything that
// plugs into them. It is its own file for the same reason prospector_hw.scad
// is: a socket and a peg are two halves of one dimension, and a file each is
// exactly how they drift apart.
//
// A TEARDROP RATHER THAN A CIRCLE, and it earns that twice over.
//
// The arm sockets are horizontal blind bores in a wall that prints desk-down,
// so a round hole has to bridge its own ceiling and droops into the bore --
// the apex carries it up at 45 degrees instead and nothing overhangs. That
// alone would be reason enough, but the second reason is the one that shows on
// the toy: a round peg in a round hole spins. An arm sags to wherever gravity
// puts it and a brim wanders off centre. The apex keys both, and it costs
// nothing to draw.
//
// The crown is keyed twice over, because the PAD is a 14 x 5.5 rounded
// rectangle and a hat that pockets over it cannot rotate at all. There the
// teardrop is only carrying the bore's ceiling. On the arms it is the whole
// mechanism.

PEG_D    = 3.00;      // the peg's circular part
// Added to the socket, and the one number here that is a property of the
// printer rather than of the design. 0.20 is a starting guess for a 0.4 mm
// nozzle at 0.2 mm layers; print the coupon in prospector_dress.scad before
// committing a set of accessories to it.
PEG_FIT  = 0.20;
PEG_TIP  = 0.30;      // the apex is blunted to this radius, so it can print
SOCK_D   = PEG_D + PEG_FIT;

// How deep each socket is, and how long the peg that goes in it. The peg is
// always the shorter, so it seats on its shoulder against the case and never
// bottoms out in a hole whose floor it cannot see.
CROWN_DEPTH = 3.20;
CROWN_PEG_L = 3.00;
ARM_DEPTH   = 4.50;
ARM_PEG_L   = 4.30;

// The crown pad, which is the seat as well as the key. An accessory that
// pockets over this needs the footprint; one that only takes the peg does not.
PAD_W    = 14.00;     // across the case
PAD_L    = 5.50;      // along the roof
PAD_R    = 2.50;      // corner radius
PAD_H    = 3.00;      // how far it stands proud of the chamfer
PAD_CLR  = 0.25;      // per side, pad to a pocket that goes over it
// An accessory's seating face against the pad's outer face. Drawn flush the
// two are coplanar over 77 mm2, and this project has a long record of what
// coplanar contacts do -- here it left a 2.2 mm3 sliver in the intersection
// check that took three passes to stop chasing as a real collision. On the
// printed pair it means nothing: the peg is 0.10 loose in its bore, so the cap
// beds down on the pad whatever the model says.
SEAT_CLR = 0.15;

// The roof's angle from horizontal, which an accessory needs if it is to sit
// level on a case that leans back. It is NOT independent -- the case derives
// the same angle from CH_M, and prospector.scad echoes the difference between
// the two on every dressed build so this cannot quietly go stale. Change the
// case's proportions and that echo is what will say so.
PAD_TILT = 44.81;

// Apex toward +y. The tangents leave the circle at about 45 degrees, which is
// the whole point -- nothing in the profile overhangs more than that. The apex
// is blunted rather than brought to a point: a true point is one triangle wide
// at the tip, prints as a blob anyway, and is a reliable source of degenerate
// faces.
function tear_h(d) = d / 2 * sqrt(2);      // apex height above the centre

module teardrop2d(d, tip = PEG_TIP) {
    r = d / 2;
    hull() {
        circle(r = r);
        translate([0, r * sqrt(2) - tip]) circle(r = tip);
    }
}

module pad2d(clr = 0) {
    offset(r = PAD_R + clr)
        square([PAD_W - 2 * PAD_R, PAD_L - 2 * PAD_R], center = true);
}
