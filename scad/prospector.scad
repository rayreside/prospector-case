// Prospector dongle case -- compact variant, no ambient sensor.
//
// FRAME. +x right as you face the screen, +y away from you, +z up, z = 0 is
// the desk. The canonical view is the front elevation, looking along +y. Every
// unqualified up/down/left/right in this file means that view. Sections are
// taken in the y-z plane, which is where all the interesting geometry lives --
// the model is symmetric about x = 0.
//
// FORM. The upstream case is, underneath the rounding, a rounded-rectangle
// prism whose axis is the screen normal, trimmed by the desk plane and by a
// vertical back wall. Measuring it that way (see prospector/REFERENCE.md) is
// what makes this parametric: the cross-section is pinned by the display and
// cannot shrink, so DEPTH is very nearly the only size knob, and pulling the
// back wall forward lowers the case at the same time as it shortens it,
// because the top face slopes back and up.
//
// PRINTING. Desk-down, as modelled, and the cap flat. Measured rather than
// reasoned about, with tools/overhang.py: desk-down needs 557 mm2 of support
// against 888 for front-face-down and 891 for back-down, and it puts 1842 mm2
// on the bed where the others manage 361 and 202. All of its support is the
// interior roof, which nobody sees. Upstream's body needs support too.
//
// WHAT SETS THE SIZE. Not the walls and not the display -- the hat. It is 27
// long front to back and 9.8 tall, and the display's back plane has to climb
// over it before the case can end, which is why the screen is at 70 here and
// not the upstream 55: at 55 the case comes out bigger than upstream.
// Three clearances gate the depth and all three are echoed on every build.
// PLUG_H is the only estimate left; everything else is measured.

/* [What to build] */
part  = "all";        // all | shell | cap
cut   = "";           // "" | x | y | z   -- section it, see CONTEXT.md
cut_at = 0;
cut_flip = false;
show_parts = true;    // ghost the display and the XIAO in place

$fa = 2; $fs = 0.4;

include <prospector_hw.scad>

/* [Geometry] */
BACK_CHAMFER = true;  // break the top-back corner, per the sketch
BACK_R    = 3.00;     // rounding where the back wall meets desk and top
// The seat has to be wide enough to carry the module's own mounting bosses,
// which is what sets 7.25 rather than anything to do with stiffness. At the
// 2.50 it started at, all four of the module's holes fell inside the connector
// window with no material under them -- a case the display could not be
// screwed to, and nothing in a render would have said so.
SEAT      = 7.25;     // ledge the module's back bears on, all round
BOSS_D    = 5.00;     // boss around each screw, on the cavity side
BOSS_H    = 2.40;     // how far it stands into the cavity
SCREW_D   = 2.20;     // clearance for M2

// The socket's footprint on the module's back, which the seat has to be
// relieved for. *** POSITION UNMEASURED -- known only to be on the LEFT, so
// this is a generous slot out to the pocket edge rather than a fitted pocket.
CONN_SLOT_V = 9.00;   // how tall a band it takes, centred on the module
CONN_SLOT_U = 14.00;  // how far in from the left pocket edge
// Mirrored on the right as well. Nothing is behind it there -- it is purely
// to open the seat up so the hat can be got past it on the way in.
CONN_SLOT_BOTH = true;
CAP_T     = 1.60;     // rear cap plate
CAP_SCR_X = 16.00;    // rear cap screws, clear of the hat at +/-11.25
CAP_SCR_Z = 7.00;
CAP_SCR_D = 2.70;     // clearance for M2.5
CAP_POST_D = 6.00;
CAP_PILOT = 2.10;     // M2.5 forming its own thread in the post
CAP_POST_L = 6.00;
KERB      = 1.50;     // wall of the tray that locates the hat
KERB_H    = 2.50;     // how far it rises past the hat's underside
// The hat's own mounting holes. Centre-to-centre comes from two straddling
// spans -- 19.2 over the far walls and 15.0 between the near ones -- which
// average to the centre distance and cancel the hole diameter. Their half
// difference gives that diameter back as a check: 2.10, exactly an M2
// clearance hole, so both spans were taken on centre.
//
// A photograph had put the spacing at 16.80, which was 0.3 out. Fine as a
// sanity check, useless as a dimension.
// Both numbers now measured. The south strip is 6.0 wide (27 board less the
// XIAO's 21), so a centre has to fall between 1.05 and 4.95 of the south edge
// -- which is how a mis-keyed 16 for the near-wall distance was caught: from
// either edge it put the hole inside the XIAO's footprint.
// Pilot holes only. The pads below stay either way -- they set the board's
// height -- but there is no way to drive a screw into them once assembled.
HAT_SCREWS = false;
HAT_SCR_DX = 17.10;   // centre to centre, measured
HAT_SCR_DY = 2.65;    // up from the south edge: 1.60 to the near wall + 1.05
HAT_SCR_D  = 1.70;    // M2 forming its own thread; the board's hole is 2.10
HAT_POST_D = 4.50;

// Back on, and this time bearing where they should. The hat's screws cannot be
// reached once the case is together -- they are vertical with the display
// directly overhead, and no face of the case looks along that axis. So the hat
// is trapped rather than bolted: it rests on pads at its own hole positions,
// slides forward under these hooks, and the rear cap closes behind it. The
// hooks land on the bare board south of the XIAO, which is the one part of the
// hat with nothing mounted on it.
MCU_HOOKS = true;
HOOK_W    = 6.00;     // hooks over the hat's front corners
HOOK_D    = 1.50;     // how far they reach back over it
HOOK_T    = 1.20;     // thickness of the tongue
TIE_POSTS = true;     // a pair of posts to zip-tie the bundle down to
TIE_X     = 7.00;
TIE_D     = 3.00;
TIE_H     = 5.00;
SLACK     = 3.00;     // cable room between the hat and the module's seat

DEPTH     = 43.00;    // *** the size knob. Back wall at y = DEPTH.

// Screen angle and display height are one decision, and 70 is the minimum of
// the curve rather than a preference. Steepening the screen makes the display's
// back plane climb over the hat faster, which buys depth; past about 70 the
// display's own 9.96 mm thickness starts projecting further forward at its
// bottom edge and gives the depth back. Measured, all watertight builds:
//
//     55 / lift 10 -> 55.4 deep, 43.4 tall, 60.39 cm3   (worse than upstream)
//     65 / lift  6 -> 49.2 deep, 40.6 tall, 53.74 cm3
//     70 / lift  4 -> 47.2 deep, 38.9 tall, 51.23 cm3   <-- here
//     75 / lift  2 -> 49.9 deep, 36.8 tall, 53.19 cm3
//
// The lift goes with the angle: shallower screens need the display raised
// further before the hat clears underneath, and the skirt that brings the case
// back down to the desk then juts forward, which is what ruins 55.
TILT      = 70.0;     // upstream is 55 -- see TILT_UPSTREAM
DISP_LIFT = 4.00;     // desk to the lowest point of the pocket

// The hat lies flat on the floor at the back, long axis front to back, so the
// USB-C leaves through the rear cap exactly as it does now.
MCU_LIFT  = 0.40;     // standoff under the hat
MCU_DX    = MCU_D;    // across the case
MCU_DY    = MCU_W;    // front to back -- the axis the USB-C exits along
MCU_DZ    = MCU_H;

/* ---------- derived ---------- */
POCK_W = DISP_W + 2 * DISP_CLR;
POCK_H = DISP_H + 2 * DISP_CLR;
POCK_R = DISP_R + DISP_CLR;
BORE_W = LIP_W + 2 * LIP_CLR;         // counterbore the lip seats in
BORE_H = LIP_H + 2 * LIP_CLR;
BORE_R = DISP_R + (LIP_W - DISP_W) / 2;
RIM_MIN = 0.85;                       // material left around the counterbore
// The cross-section is now the larger of what the module's body needs and what
// the lip's counterbore leaves standing. Upstream keeps 0.835 mm around its
// counterbore, and that ring is only LIP_T deep, so it is a lip rather than a
// wall.
SEC_W  = max(POCK_W + 2 * BEZEL, BORE_W + 2 * RIM_MIN);
SEC_H  = max(POCK_H + 2 * BEZEL, BORE_H + 2 * RIM_MIN);
W_RIM  = DISP_T;                      // the lip's face is flush with the rim
W_BACK = -40;                         // prism runs well past the trim planes

// Frontmost point of the case at y = 0; pocket's lowest point at DISP_LIFT.
CY = SEC_H / 2 * cos(TILT) + W_RIM * sin(TILT);
CZ = DISP_LIFT + POCK_H / 2 * sin(TILT);

FLOOR = WALL;                         // inside face of the desk-side wall
MCU_Z = FLOOR + MCU_LIFT;             // bottom of the stack, the USB-C shell
PCB_Z = MCU_Z + PCB_UP;               // the hat board itself, what screws to


MCU_Y  = DEPTH - CAP_T - MCU_DY - 2 * MCU_CLR;  // hat's front face
// The hat is not the solid brick it was modelled as. Its southern strip -- the
// 6 mm past the XIAO that carries the mounting holes -- is bare board, 1.6
// thick, while only the part with the XIAO beneath it and the socket above it
// stands the full 9.82. Treating the whole thing as full height held the case
// about 4 mm deeper than it needs to be, which is visible on the printed part
// as room to push the hat further in.
PCB_T = 1.60;         // *** ESTIMATED: hat board thickness
STRIP = MCU_W - 21.0; // bare board south of the XIAO's 21 mm length
TALL_Y = MCU_Y + MCU_CLR + STRIP;     // where the full-height part starts
function hat_top_at(y) = y < TALL_Y ? PCB_Z + PCB_T : MCU_Z + MCU_DZ;


// Distance of a point in the y-z plane from the module's back face, measured
// along the screen normal. Positive is in front of the module, so anything
// inside the case that comes out positive is fouling the display.
function wof(y, z) = -(y - CY) * sin(TILT) + (z - CZ) * cos(TILT);

// Where the hat is allowed to be. An earlier version of this tested the hat
// against the display's back plane as though that plane were infinite, which
// silently forbade the one move that helps most: the display is a bounded
// slab, and the hat can slide forward UNDERNEATH its lower edge. Raising the
// display buys depth at the cost of height, and only this test can see it.
//
// vof is position up the screen, wof position out of it. The pocket is
// vof in [-POCK_H/2, POCK_H/2] and wof in [0, DISP_T]; a vertical line at y
// enters it at pocket_z and misses it entirely when that comes back empty.
function vof(y, z) = (y - CY) * cos(TILT) + (z - CZ) * sin(TILT);
function pocket_z(y) =
    let (dy = y - CY, H2 = POCK_H / 2,
         ze = max(CZ + (-H2 - dy * cos(TILT)) / sin(TILT),
                  CZ + dy * sin(TILT) / cos(TILT)),
         zx = min(CZ + ( H2 - dy * cos(TILT)) / sin(TILT),
                  CZ + (dy * sin(TILT) + DISP_T) / cos(TILT)))
    ze < zx ? ze : 1e6;

// Plug room: how far a plug on the module's socket can reach straight back
// before it meets the hat. This has to be a ray against the hat's actual box,
// not a distance to one of its planes -- measuring to the front face alone
// said 3.58 mm where the true figure is 20.6, because at the module's centre
// height the hat is not there at all. It is 9.8 tall and that centre is 17 up.
T_FRONT = (MCU_Y - CY) / sin(TILT);                 // to the hat's front face
T_TOP   = (CZ - (MCU_Z + MCU_DZ)) / cos(TILT);      // to the hat's top face
Z_AT_F  = CZ - T_FRONT * cos(TILT);
Y_AT_T  = CY + T_TOP * sin(TILT);
HIT_F   = T_FRONT > 0 && Z_AT_F >= MCU_Z && Z_AT_F <= MCU_Z + MCU_DZ;
HIT_T   = T_TOP > 0 && Y_AT_T >= MCU_Y && Y_AT_T <= MCU_Y + MCU_DY;
CONN_FIT = HIT_F && HIT_T ? min(T_FRONT, T_TOP)
         : HIT_F ? T_FRONT
         : HIT_T ? T_TOP
         : 999;                                     // the ray misses the hat
// Measured on the real bundle, not derived: the wires are many and bunched,
// and 15 mm is what they take without being compressed. That dominates the
// plug's own reach, so it is the number the depth actually has to satisfy.
WIRE_ROOM = 15.00;
CONN_NEED = max(CONN_H + PLUG_H, WIRE_ROOM);

// Headroom: the cable comes off the hat's socket and turns upward, and it wants
// about 20 mm above the hat before it is bent comfortably. Measured on the real
// bundle. The ceiling over the hat is the lower of two sloping surfaces -- the
// display's back plane, which rises going back, and the case's own top face,
// which falls -- so the tallest point in the cavity is where they cross, and
// that is where the bend has to happen.
WIRE_UP  = 20.00;
function z_top(y) = CZ + (SEC_H / 2 - WALL) * sin(TILT)
    + ((CY + (SEC_H / 2 - WALL) * cos(TILT) - y) / sin(TILT)) * cos(TILT);

// The cavity's ceiling at abscissa y: the lower of the case's own top face and
// the underside of the display, whichever the hat meets first going up.
function ceil_at(y) = min(z_top(y), pocket_z(y) - WALL);

HAT_YS  = [for (i = [0 : 8]) MCU_Y + i * MCU_DY / 8];
MCU_FIT  = min([for (y = HAT_YS) ceil_at(y) - hat_top_at(y)]);
// The cable rises off the socket, which is on the full-height part, so the
// headroom that matters is measured there and not over the bare strip.
WIRE_FIT = max([for (y = HAT_YS) if (y >= TALL_Y) ceil_at(y) - hat_top_at(y)]);

echo(str("section ", SEC_W, " x ", SEC_H, ", depth ", DEPTH,
         ", screen ", TILT, " deg, lift ", DISP_LIFT));
echo(str("hat clears the ceiling by ", MCU_FIT, " mm  (want ", SLACK, ")"));
echo(str("plug room at the socket ", CONN_FIT, " mm  (want ", CONN_NEED, ")"));
echo(str("headroom over the hat ", WIRE_FIT, " mm  (want ", WIRE_UP, ")"));

/* ---------- primitives ---------- */

module rrect(w, h, r) {
    offset(r = r) square([w - 2 * r, h - 2 * r], center = true);
}

// A slab of the prism: cross-section (w,h,r) from w0 to w1 along the screen
// normal, in world coordinates.
module band(w, h, r, w0, w1, dv = 0) {
    translate([0, CY, CZ]) rotate([TILT, 0, 0])
        translate([0, dv, w0]) linear_extrude(w1 - w0) rrect(w, h, r);
}

// Lifting the display to slide the hat under it leaves the case hanging in the
// air: the prism's underside no longer descends far enough to meet the desk
// inside the case's depth, and the desk trim then cuts nothing at all. At
// lift 18 the whole shell floated 11.6 mm clear, which no volume figure shows
// and the bounding box gives away at once. DROP is how much the cross-section
// has to grow downward to stand up again -- and it grows the case upward by
// the same amount, because the extension runs down the screen's own plane.
DROP = max(0, (CZ + W_RIM * cos(TILT)) / sin(TILT) - SEC_H / 2);

// The desk-and-back trim, as one rounded profile in the y-z plane rather than
// two half-spaces, so the edges it creates are broken rather than sharp.
// `floor` is the desk-side face: 0 for the outside, WALL for the cavity. The
// first version of this took no floor argument and the cavity ran straight
// down to z = 0, leaving the case with no bottom at all.
//
// The back is vertical only as far up as the hat reaches, then it chamfers
// forward to meet the top face -- the sketch's straight run from apex to
// bottom-back, as far as it can be taken. It cannot be taken all the way: a
// single line from the apex to the bottom-back corner has to pass over a
// 9.8 mm brick sitting 47 mm out, and solving that puts the case at 69 mm
// deep. The hat owns the bottom-back corner, so the back stands up beside it
// and only the volume above it can go.
CH_Z = MCU_Z + MCU_DZ + WALL + 0.50;             // clear of the hat
Y_DTB = CY + POCK_H / 2 * cos(TILT);             // display's top-back corner
Z_DTB = CZ + POCK_H / 2 * sin(TILT);
CH_M = (Z_DTB + WALL - CH_Z) / (Y_DTB - DEPTH);  // and clear of the display

module trim(back, floor, r) {
    rotate([90, 0, 90]) linear_extrude(120, center = true)
        offset(r = r) offset(delta = -r)
            polygon(BACK_CHAMFER
                ? [[-60, floor], [back, floor], [back, CH_Z + floor],
                   [-60, CH_Z + floor + CH_M * (-60 - back)]]
                : [[-60, floor], [back, floor], [back, 60], [-60, 60]]);
}

/* ---------- the case ---------- */

module outer() {
    intersection() {
        band(SEC_W, SEC_H + DROP, RIM_R, W_BACK, W_RIM, -DROP / 2);
        trim(DEPTH, 0, BACK_R);
    }
}

// Everything the shell has to hold. Kept as one module so the shell is
// outer() minus this.
//
// The cavity stops WALL short of the module, leaving a plate for the module's
// back to bear on; the window through that plate is what clears the cable
// connector. Upstream does the same thing and takes its window right out to
// the full pocket width, so its module is only supported top and bottom --
// a ring is stiffer for the same clearance.
module hollow() {
    band(POCK_W, POCK_H, POCK_R, 0, DISP_T - LIP_T);     // the module's body
    band(BORE_W, BORE_H, BORE_R, DISP_T - LIP_T, W_RIM + 1);   // its lip
    band(POCK_W - 2 * SEAT, POCK_H - 2 * SEAT,           // connector window
         max(POCK_R - SEAT, 0.5), -WALL - BOSS_H - 1, 1);
    for (sx = CONN_SLOT_BOTH ? [-1, 1] : [-1])            // socket relief
        translate([0, CY, CZ]) rotate([TILT, 0, 0])
            translate([sx < 0 ? -POCK_W / 2 : POCK_W / 2 - CONN_SLOT_U,
                       -CONN_SLOT_V / 2, -WALL - BOSS_H - 1])
                cube([CONN_SLOT_U, CONN_SLOT_V, WALL + BOSS_H + 2]);
    intersection() {                                      // main cavity
        band(SEC_W - 2 * WALL, SEC_H + DROP - 2 * WALL, RIM_R - WALL,
             W_BACK, -WALL, -DROP / 2);
        // Past the back, not up to it. Ending the cavity on the same plane the
        // shell is cut on left the two coplanar, and the back came out closed:
        // a +y face of 825 mm2 where there should have been a ring of about 90.
        trim(DEPTH + 1, WALL, max(BACK_R - WALL, 0.5));
    }
}

// The hat is located by a tray rather than by its screws, because its two
// mounting holes are in the strip south of the XIAO and their spacing has not
// been measured. The tray is the hat's measured 21.9 x 27.0 outline with a
// kerb on the sides and front; mcu_box() is subtracted after this is unioned
// in, so the kerb falls out of the difference rather than being drawn.
// Overlapping the floor by 0.2 rather than sitting on it: a coplanar contact
// is the awkward case for a union, and this one has to fuse or the tray comes
// out as its own shell.
// Sides and back only. A kerb across the front as well was 0.9 mm taller than
// the board it was meant to guide, so the hat could neither slide forward under
// the hooks nor drop in past them -- the hooks were real geometry that nothing
// could ever reach. The hook towers are the front stop now.
module mcu_tray() {
    translate([0, MCU_Y, FLOOR - 0.2])
        cube([MCU_DX + 2 * MCU_CLR + 2 * KERB, MCU_DY + 2 * MCU_CLR,
              PCB_Z - FLOOR + KERB_H + 0.2], center = false);
}

// Two hooks over the hat's front corners, so it is held down as well as
// located. This is deliberately not a screw: the hat's two mounting holes are
// in the strip south of the XIAO and their spacing is not known, and a post in
// the wrong place fouls the board instead of holding it. The hat goes in from
// the back, slides forward under these, and the rear cap closes behind it --
// which leaves it constrained in every direction without needing the holes at
// all. The USB-C passing through the cap slot pins the far end.
// One L-shaped profile extruded across, not a tower cube plus a tongue cube.
// Built from two cubes the pieces met on a plane, and the upper one ended up
// hanging off a coplanar contact with the tray's side kerb -- two non-manifold
// edges, and a hook attached to the case by nothing but a shared face.
module mcu_hooks() {
    y0 = MCU_Y - KERB;                       // clear in front of the hat
    y1 = MCU_Y;                              // stops at its front face
    y2 = y1 + MCU_CLR + HOOK_D;              // and reaches back over the board
    // 0.1 above the board's own envelope: landing exactly on it is coplanar,
    // and coplanar is the case a union handles worst.
    zt = PCB_Z + PCB_T + 2 * MCU_CLR + 0.1;
    if (MCU_HOOKS)
        for (sx = [-1, 1])
            translate([sx * (MCU_DX / 2 + MCU_CLR) - (sx > 0 ? HOOK_W : 0), 0, 0])
                rotate([90, 0, 90]) linear_extrude(HOOK_W)
                    polygon([[y0, FLOOR - 0.2], [y1, FLOOR - 0.2], [y1, zt],
                             [y2, zt], [y2, zt + HOOK_T], [y0, zt + HOOK_T]]);
}

module hat_posts() {
        for (sx = [-1, 1])
            translate([sx * HAT_SCR_DX / 2, MCU_Y + MCU_CLR + HAT_SCR_DY,
                       FLOOR - 0.2])
                cylinder(d = HAT_POST_D, h = PCB_Z - FLOOR + 0.2);
}

module hat_screws() {
    if (HAT_SCREWS)
        for (sx = [-1, 1])
            translate([sx * HAT_SCR_DX / 2, MCU_Y + MCU_CLR + HAT_SCR_DY,
                       FLOOR - 1])
                cylinder(d = HAT_SCR_D, h = PCB_Z - FLOOR + 1.5);
}

module mcu_tray_placed() {
    intersection() {
        translate([-(MCU_DX + 2 * MCU_CLR + 2 * KERB) / 2, 0, 0]) mcu_tray();
        outer();
    }
}

// Somewhere to tie the bundle down so it cannot wander forward into the seat's
// screw bosses. Vertical posts rather than a bar over the floor: a bar would
// be a 43 mm bridge, and this part already needs support for its roof without
// adding more.
module tie_posts() {
    if (TIE_POSTS)
        for (sx = [-1, 1])
            translate([sx * TIE_X, MCU_Y - KERB - TIE_D, FLOOR - 0.2])
                cylinder(d = TIE_D, h = TIE_H + 0.2);
}

// Two posts for the rear cap, out at +/-16 where the hat is not. Each stands
// on a foot down to the cavity floor -- a bare cylinder floating at screw
// height is not attached to anything, and comes out as a separate shell.
module cap_posts() {
    for (sx = [-1, 1]) {
        translate([sx * CAP_SCR_X, DEPTH - CAP_T - CAP_POST_L, CAP_SCR_Z])
            rotate([-90, 0, 0]) cylinder(d = CAP_POST_D, h = CAP_POST_L);
        translate([sx * CAP_SCR_X - CAP_POST_D / 2, DEPTH - CAP_T - CAP_POST_L,
                   FLOOR - 0.2])
            cube([CAP_POST_D, CAP_POST_L, CAP_SCR_Z - FLOOR + 0.2]);
    }
}

module cap_screws() {
    for (sx = [-1, 1])
        translate([sx * CAP_SCR_X, DEPTH - CAP_T - CAP_POST_L - 0.5, CAP_SCR_Z])
            rotate([-90, 0, 0]) {
                cylinder(d = CAP_PILOT, h = CAP_POST_L + 0.5);
                translate([0, 0, CAP_POST_L + 0.5])
                    cylinder(d = CAP_SCR_D, h = CAP_T + 1);
            }
}

module usb_slot() {
    translate([0, DEPTH - CAP_T / 2, MCU_Z + USB_Z])
        cube([USB_W, CAP_T * 4, USB_H], center = true);
}

// The back is where the case opens: it is the one face that is flat, and the
// module has to go in from behind it because the front frame's lip is what
// holds the module in.
module cap() {
    difference() {
        intersection() {
            outer();
            translate([-100, DEPTH - CAP_T, -100]) cube([200, CAP_T, 200]);
        }
        usb_slot();
        cap_screws();
    }
}

// The hat, flat against the rear cap, XIAO down so its socket faces up into
// the cavity and the USB-C sits at the bottom of the stack.
module mcu_box() {
    w = MCU_DX + 2 * MCU_CLR;
    // bare board over the whole footprint
    translate([-w / 2, MCU_Y, PCB_Z - MCU_CLR])
        cube([w, MCU_DY + 2 * MCU_CLR, PCB_T + 2 * MCU_CLR]);
    // XIAO below and socket above, north of the strip
    translate([-w / 2, TALL_Y - MCU_CLR, MCU_Z])
        cube([w, MCU_Y + MCU_CLR + MCU_DY - TALL_Y + 2 * MCU_CLR, MCU_DZ]);
}

// The front frame is part of the shell, not a separate ring. LIP is how far it
// overhangs the module's face, and it is the number to watch: the module's own
// bezel is only 1.58 mm above and below the pixels, so a lip much over 1.0
// starts covering them. Upstream ducked this by using no lip at all and
// retaining the module some other way -- worth understanding before trusting
// this to clear the glass.
// Four bosses on the cavity side of the seat, on the module's own measured
// hole pattern. The screws go in from inside the case: the display drops into
// its pocket from the back and the glass is in the way from the front.
module bosses() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([0, CY, CZ]) rotate([TILT, 0, 0])
            translate([sx * HOLE_DX / 2, sy * HOLE_DY / 2, -WALL - BOSS_H])
                cylinder(d = BOSS_D, h = WALL + BOSS_H);
}

module screw_holes() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([0, CY, CZ]) rotate([TILT, 0, 0])
            translate([sx * HOLE_DX / 2, sy * HOLE_DY / 2, -WALL - BOSS_H - 1])
                cylinder(d = SCREW_D, h = WALL + BOSS_H + 3);
}

// Order matters here and it is not obvious. Anything added to the shell has to
// be unioned on AFTER hollow() is subtracted, never before: the cavity fills
// the whole interior, so material standing in it gets swallowed. Built the
// wrong way round first, and the seat bosses, the hat tray and the cap posts
// all silently vanished -- the volume came back byte-identical to the build
// without them, which is the only reason it was caught.
module shell() {
    difference() {
        union() {
            difference() { outer(); hollow(); }
            intersection() {
                union() {
                    bosses(); mcu_tray_placed(); cap_posts(); tie_posts();
                    mcu_hooks(); hat_posts();
                }
                outer();
            }
        }
        mcu_box();
        screw_holes();
        cap_screws();
        hat_screws();
        translate([-100, DEPTH - CAP_T, -100]) cube([200, CAP_T + 60, 200]);
    }
}

/* ---------- the hardware, for looking at ---------- */

module ghost_display() {
    color("SteelBlue", 0.55) band(DISP_W, DISP_H, DISP_R, 0, DISP_T);
    color("DimGray", 0.35) band(ACT_W, ACT_H, 1.5, DISP_T, DISP_T + 0.1);
}

module ghost_mcu() {
    color("DarkSalmon", 0.6)
        translate([0, MCU_Y + MCU_CLR + MCU_DY / 2, MCU_Z + MCU_DZ / 2])
            cube([MCU_DX, MCU_DY, MCU_DZ], center = true);
}

module assembly() {
    if (part == "all" || part == "shell") color("Gainsboro") shell();
    if (part == "all" || part == "cap") color("DarkSalmon") cap();
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
