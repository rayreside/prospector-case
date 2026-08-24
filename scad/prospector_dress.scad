// Things that plug into the dressed case: a baseball cap for the crown, an
// arm for each side, and a coupon for finding out what fit your printer gives
// before you commit a set of accessories to it.
//
// These are examples. The deliverable is the socket, not the styling -- fork
// hat() and arm() into whatever you like and keep the seat and the peg, which
// come from prospector_plug.scad and are the only part the case knows about.
//
// TWO FRAMES, AND THEY ARE NOT THE SAME ONE. This caught me on the first pass
// and it is worth stating rather than leaving to be re-derived.
//
//   The CAP is drawn in the crown pad's frame: origin at the centre of the
//   pad's outer face, z out along the roof's normal, y down the slope. That
//   frame leans back 44.81 degrees, so anything that should look level -- the
//   crown, the brim -- is drawn inside level(). Anything that has to mate with
//   the pad is drawn outside it.
//
//   The ARM is drawn in the case's own frame, origin at the socket's mouth on
//   the +x wall, peg along -x. The side sockets are horizontal, so world up is
//   already up and level() has no business here. Wrapped in it by mistake the
//   arm hangs at 45 degrees, which looks deliberate enough in a render to go
//   unnoticed.
//
// PRINTING. Both parts print with their peg horizontal, lying on the flat the
// model already gives them: the cap on the back of its crown, the arm on its
// side. That is what the teardrop is for. Printed the other way up a peg is a
// stack of unsupported arcs and comes out oval, which is a fit problem rather
// than a cosmetic one.

include <prospector_plug.scad>

/* [What to build] */
part = "all";         // all | hat | arm | coupon
$fa = 2; $fs = 0.4;

/* [Cap] */
COLLAR_LIP = 1.20;    // skirt down the pad's sides -- this is the rotation key
COLLAR_H   = 3.00;    // and how much stands above the pad
COLLAR_W   = 1.70;    // wall around the pad
CROWN_RX   = 14.00;   // the dome, half-width across
CROWN_RY   = 10.50;   // half-length fore and aft
CROWN_RZ   = 7.50;
CROWN_CY   = 2.50;    // dome centre, pushed back off the case's front corner
// The dome is CUT at its equator and that cut is not cosmetic. Drawn as a
// whole ellipsoid it reached 6.5 mm below the pad's face -- the roof is 3.0
// below it -- so the cap sat 3.5 mm inside the case's roof. Nothing said so:
// the cap was one watertight shell, the case was one watertight shell, and
// each was correct on its own. Only intersecting the two gave it up, at
// 0.48 cm3 of overlap.
// 6.50, and it is set by the crown's own hull rather than by looks.
//
// The hull runs from the collar's plate out to the dome's front rim, and a
// straight line between those two points passes UNDER the collar on its way --
// so a rim set too low drags the crown's underside down through the pad the
// collar is sitting on. At 4.00 it dipped to 0.26 below the pad's face and the
// cap fouled the case over 11 mm of that edge.
//
// The condition is on the line, not on the dome: the segment from the rim to
// the plate's back corner has to still be above the pad's face where the pad
// ends. 6.50 puts it 0.77 clear. The dome's rim itself ends up 8.0 forward and
// 1.2 above the case's top ridge, which is the other thing it must miss.
CROWN_BASE = 6.50;    // the dome's underside, above the pad's face
// The case's top-front corner stands 3.92 above the pad's face in this frame
// and 9.65 ahead of it -- that one point is the only thing the brim can hit,
// because forward of it the front face falls away and there is nothing left to
// foul. Over it the brim passes at 7.57, and its root still sits inside the
// dome, which is what keeps the two one solid.
BRIM_Z     = 9.00;
BRIM_T     = 1.60;
BRIM_ROOT  = 4.00;    // how far INTO the dome it starts, so the two fuse
BRIM_OUT   = 21.00;   // and how far forward it reaches
BRIM_W     = 22.00;
BRIM_DROP  = 8.00;    // degrees, so it does not read as a visor

/* [Arm] */
ARM_SHOULDER = 9.00;  // covers the socket's mouth
ARM_LEN      = 16.00;
ARM_THICK    = 4.40;
HAND_D       = 6.40;

/* [Coupon] */
COUPON_STEPS = [-0.10, 0.00, 0.10, 0.20];   // added to PEG_D, in order

/* ---------- shared ---------- */

// Rotate out of the pad's frame into world-up. The pad's normal leans back by
// PAD_TILT, so this is what takes a brim from "sticking up at 45 degrees" to
// level.
module level() { rotate([PAD_TILT, 0, 0]) children(); }

// Every peg runs INTO the part it belongs to by `into` as well as out of it.
// Stopping flush on the seating face is a coplanar contact, and this case has
// produced a detached shell, a non-manifold edge and 219 self-intersections
// from exactly that. It cost a shell here too, on the first build.
PEG_INTO = 0.60;

/* ---------- the cap ---------- */

// The collar does the work: it pockets over the pad, and because the pad is a
// rounded rectangle rather than a circle the cap cannot rotate at all. The peg
// carries the pull-out load and nothing else. That is the right way round -- a
// 3 mm peg is a poor torque fitting and a fine tension one.
//
// It seats on the pad's TOP face, not on the roof, and the skirt hangs 1.20
// down the pad's sides with 1.80 of pad still showing beneath. That gap is
// deliberate. A skirt long enough to reach the roof would have to land on it,
// and the roof band is only five millimetres wide -- the back of the skirt
// would come down on the rear cap instead and hold it off its seat, which is
// the same failure the seam had and for the same reason.
module collar() {
    difference() {
        translate([0, 0, -COLLAR_LIP])
            linear_extrude(COLLAR_LIP + COLLAR_H) pad2d(COLLAR_W);
        // Up to SEAT_CLR, not to zero: the ceiling of this pocket and the
        // pad's outer face are otherwise the same plane.
        translate([0, 0, -COLLAR_LIP - 1])
            linear_extrude(COLLAR_LIP + 1 + SEAT_CLR) pad2d(PAD_CLR);
    }
}

// Apex toward +x, which is how the case bores it -- see the note in
// prospector.scad about why the crown's key runs across the case rather than
// up the slope.
module crown_peg() {
    translate([0, 0, -CROWN_PEG_L])
        linear_extrude(CROWN_PEG_L + COLLAR_LIP + PEG_INTO)
            rotate([0, 0, -90]) teardrop2d(PEG_D);
}

// HULLED ACROSS THE TWO FRAMES ON PURPOSE. The dome is levelled and the plate
// it stands on is not, so the hull spans both -- which is what guarantees they
// are one solid. Drawn with the plate inside level() the dome came out
// 44 degrees away from its own collar and the cap built as three separate
// shells, watertight and in pieces.
// Scaled from a sphere of the real radius, not from a unit one. scale() does
// not touch $fs, so sphere(r = 1) resolves at radius 1 -- sixteen facets --
// and then gets blown up to 28 mm across. The dome came out visibly faceted
// and the triangle count said so first: 388 for the whole cap.
module dome() {
    intersection() {
        translate([0, CROWN_CY, CROWN_BASE])
            scale([CROWN_RX / CROWN_RZ, CROWN_RY / CROWN_RZ, 1])
                sphere(r = CROWN_RZ);
        translate([-60, -60, CROWN_BASE]) cube(120);
    }
}

module crown() {
    hull() {
        level() dome();
        translate([0, 0, COLLAR_H - 0.5]) linear_extrude(0.5) pad2d(COLLAR_W);
    }
}

module brim_slice(w) {
    linear_extrude(BRIM_T)
        offset(r = BRIM_T / 2) square([w - BRIM_T, 0.01], center = true);
}

// Rooted INSIDE the dome rather than against it. At the brim's height the dome
// only reaches y = -7.9, so a brim starting at its nominal front edge began in
// clear air and came out as its own shell -- the second of the three.
module brim() {
    rotate([BRIM_DROP, 0, 0]) hull() {
        translate([0, -BRIM_ROOT, BRIM_Z]) brim_slice(BRIM_W * 0.55);
        translate([0, -BRIM_OUT, BRIM_Z - 0.60]) brim_slice(BRIM_W);
    }
}

module hat() {
    collar();
    crown_peg();
    crown();
    level() brim();
}

/* ---------- the arms ---------- */

// Drawn for the case's +x side, peg along -x. Mirror it for the other.
// A hull of spheres: an arm is a tapering tube with a ball on the end, and
// there is no reason to draw it as anything more complicated.
module arm_body() {
    hull() {
        // Clear of the wall by 0.20, not centred on a quarter of the
        // shoulder. At ARM_SHOULDER/4 this sphere's radius carried it 0.65
        // INSIDE the case's outer face, where the socket bore does not reach
        // -- 0.2 mm3 of interference, which is small enough to look like
        // rounding in the check and is not.
        translate([(ARM_THICK + 1.40) / 2 + 0.20, 0, 0])
            sphere(d = ARM_THICK + 1.40);
        translate([ARM_LEN * 0.55, 0, -ARM_LEN * 0.16]) sphere(d = ARM_THICK);
    }
    hull() {
        translate([ARM_LEN * 0.55, 0, -ARM_LEN * 0.16]) sphere(d = ARM_THICK);
        translate([ARM_LEN, 0, -ARM_LEN * 0.45]) sphere(d = HAND_D);
    }
}

module arm() {
    // The shoulder is a plate over the socket's mouth, not a fillet into it:
    // the socket is a teardrop, and a round fillet around a teardrop leaves a
    // crescent 0.3 mm wide at the apex.
    rotate([0, 90, 0]) cylinder(d = ARM_SHOULDER, h = 1.60);
    arm_body();
    // Apex up in the world, which is up on the bed as well once the arm is
    // laid on its side to print -- the orientation this shape already wants.
    translate([-ARM_PEG_L, 0, 0]) rotate([0, 90, 0]) rotate([0, 0, 90])
        linear_extrude(ARM_PEG_L + PEG_INTO) teardrop2d(PEG_D);
}

/* ---------- the coupon ---------- */

// PEG_FIT is the one number in prospector_plug.scad that belongs to the
// printer rather than to the design, and guessing it wrong is expensive in a
// way that is not obvious: too tight splits a 1.6 mm side wall from the inside
// and there is no getting the peg back out; too loose and an arm falls off
// every time the case is picked up.
//
// So print this and push each peg into a real socket on a real case. The one
// that goes in firmly under thumb pressure and comes out again is the answer;
// set PEG_D to that peg's diameter, or move PEG_FIT by the difference.
//
// READ IT AS A BRACKET, NOT AS A MEASUREMENT. These pegs stand up off the bed
// and the one on an arm lies along it, and the two do not come out the same
// size on any printer worth the name. What this gives is which way to move and
// roughly how far, which is what is actually wanted.
module coupon() {
    n = len(COUPON_STEPS);
    plate_l = n * 10.00 + 4.00;
    difference() {
        translate([-plate_l / 2, -7, 0]) cube([plate_l, 14, 3]);
        // A notch at one end, so the plate cannot be read backwards once the
        // first peg has been broken off it.
        translate([-plate_l / 2 + 2, -7.5, 2]) cube([2, 2, 2]);
    }
    for (i = [0 : n - 1]) {
        x = -plate_l / 2 + 7 + i * 10;
        translate([x, 0, 3 - 0.20]) linear_extrude(ARM_PEG_L + 0.20)
            teardrop2d(PEG_D + COUPON_STEPS[i]);
        // i+1 bumps, so each peg says which step it is without a label that
        // has to survive a 0.4 mm nozzle.
        for (b = [0 : i])
            translate([x - 3 + b * 1.6, -5.4, 2.8]) cylinder(d = 1.20, h = 1.20);
    }
}

/* ---------- what to build ---------- */

if (part == "hat") hat();
else if (part == "arm") arm();
else if (part == "coupon") coupon();
else if (part == "all") {
    hat();
    translate([30, 0, 0]) arm();
    translate([0, 40, 0]) coupon();
}
