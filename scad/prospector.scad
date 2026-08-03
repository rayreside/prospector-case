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
// The seat is no longer a ledge, because it was never doing the job of one:
// the module front-loads and its lip lands in the counterbore, so nothing can
// fall inward. All the ring was ever holding was the four bosses. What is left
// is a thin rim and a pad at each boss to tie it to that rim.
SEAT      = 1.60;     // rim around the pocket
SEAT_PAD  = 8.00;     // square of seat kept at each boss
BOSS_D    = 5.00;     // material kept around each screw
// Zero, and it should stay zero. The module brings its own standoffs, so the
// seat only has to be thick enough to pass a screw -- upstream's is a plain
// plate with holes and nothing more. A boss standing into the cavity just adds
// its height to what the screw has to cross before it reaches the standoff,
// and at 2.40 an M2 x 6 ran out of thread before it got there.
BOSS_H    = 0.00;
SCREW_D   = 2.20;     // clearance for M2

// The socket's footprint on the module's back, which the seat has to be
// relieved for. *** POSITION UNMEASURED -- known only to be on the LEFT, so
// this is a generous slot out to the pocket edge rather than a fitted pocket.
CONN_SLOT_V = 9.00;   // how tall a band it takes, centred on the module
CONN_SLOT_U = 14.00;  // how far in from the left pocket edge
// Mirrored on the right as well. Nothing is behind it there -- it is purely
// to open the seat up so the hat can be got past it on the way in.
CONN_SLOT_BOTH = true;

// The display's screws run along the screen normal, which at 70 degrees is
// only 20 degrees off horizontal -- so a driver has to come in almost level
// from behind, and the case floor cuts that line off before it reaches the
// back opening. These are the two channels that let it through, bored on the
// screw axis from just behind each lower boss. They come out as long shallow
// ellipses in the underside, and using them means tipping the case up.
LCD_ACCESS = true;
ACCESS_D   = 5.00;    // 3.60 took a shaft but not a bit

// Below the module the seat is carrying nothing -- the lower bosses sit at
// v = -11.285 and everything under them is there only because the ring was
// drawn at a uniform width. Opened out between them.
// Superseded: the window now reaches the rim on every side, so there is no
// lower band left to open out.
SEAT_OPEN_BOTTOM = false;
CAP_T     = 1.60;     // rear cap plate
CAP_SCR_X = 16.00;    // rear cap screws, clear of the hat at +/-11.25
CAP_SCR_Z = 7.00;
CAP_SCR_D = 2.70;     // clearance for M2.5
CAP_POST_D = 6.00;
CAP_PILOT = 2.10;     // M2.5 forming its own thread in the post
CAP_POST_L = 6.00;
KERB      = 1.50;     // wall of the tray that locates the hat
KERB_H    = 3.10;     // enough for the rail to sit clear above the board
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
// On. Reachable through the display opening as long as the hat goes in first.
HAT_SCREWS = true;
HAT_SCR_DX = 17.10;   // centre to centre, measured
HAT_SCR_DY = 2.65;    // up from the south edge: 1.60 to the near wall + 1.05
HAT_SCR_D  = 1.70;    // M2 forming its own thread; the board's hole is 2.10
HAT_POST_D = 4.50;

// Rails along the TOP OF THE SIDE KERBS, which is the version that works. The
// earlier hooks reached back over the hat's front corners, so the board had to
// slide into them, and everything ahead of it blocked that. A rail runs along
// the direction of travel instead: the hat goes in from the back, passes under
// both rails the whole way, and lands on its pads. The kerbs already stood
// 0.9 proud of the board, which is where the idea came from.
//
// OFF for now. The two screws hold the hat on their own, and the rails' 1.5 mm
// undersides run the full 27.6 as horizontal ledges, which is 107 mm2 of
// support for retention that is already covered. The geometry stays because
// the idea is sound if the screws ever turn out not to be enough.
MCU_HOOKS = false;
HOOK_W    = 6.00;     // hooks over the hat's front corners
HOOK_D    = 1.50;     // how far they reach back over it
HOOK_T    = 1.20;     // thickness of the tongue
TIE_POSTS = true;     // a pair of posts to zip-tie the bundle down to
TIE_X     = 7.00;
TIE_D     = 3.00;
TIE_H     = 5.00;
// Clearance at the hat's front corner, which is where this binds -- a bare
// board edge under the display's lower rim, 7 mm forward of where the socket
// even starts. No cable passes there and none ever will, so this is air, not
// cable room. 3.00 was arbitrary and cost the screen 15 degrees of angle.
SLACK     = 2.50;

DEPTH     = 43.00;    // *** the size knob. Back wall at y = DEPTH.

// The upstream angle, and it costs nothing. Every angle now comes out 43.0
// deep, and the shallower ones are shorter:
//
//     70 / lift 4   43.0 x 38.71
//     65 / lift 4   43.0 x 38.40
//     60 / lift 4   43.0 x 37.83
//     55 / lift 4   43.0 x 37.00   <-- here
//
// It took three corrections to see that. A skirt that leaned forward instead
// of dropping made shallow angles look deep; a ceiling test that subtracted a
// seat wall no longer present made them look tight; and the cable's headroom
// was measured from the socket rather than from the hat, which was the datum
// it had been given. Each one was found by being told the space was visible on
// the assembled part, and each time the geometry was arguing with a photograph
// and losing.
TILT      = TILT_UPSTREAM;
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
PCB_T  = 1.60;        // *** ESTIMATED: hat board thickness
// What stands tall on the hat is the socket, not the XIAO -- the XIAO hangs
// underneath and does not raise the top at all. So the profile steps up where
// the socket starts, 7.10 from the south edge, measured. It was stepping up at
// the XIAO's edge, 6.00, which is the wrong feature and 1.10 too early.
//
// Still conservative north of there: the socket is one connector, and this
// treats everything past it as standing at full stack height.
SOCKET_Y = 7.10;      // south edge of the hat to the near edge of the socket
TALL_Y = MCU_Y + MCU_CLR + SOCKET_Y;
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
// This ray checks the PLUG, and only the plug: how far a connector on the
// module's socket can reach straight back before meeting the hat. It was also
// being asked to carry the bundle's 15 mm, which is double counting -- the
// bundle is checked by the headroom test below, in the direction it actually
// travels. Behind the module's centre it only has to clear the plug.
//
// Worth knowing what the ray does NOT say. Clear run straight back from the
// module's face, sampled up it:
//
//     v      -12   -8    -4    0     +4    +8
//     55 deg  3.0  4.2   6.4   8.8  14.6  20.3
//     70 deg  2.7  9.2   9.3  20.3  40.0  40.0
//
// So at 55 the wire garage is real but thinner and higher up: 15 mm of run
// exists above about v = +4.5, against v = -2 at 70. The bundle has to rise
// rather than go straight back.
CONN_NEED = CONN_H + PLUG_H;

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
// whatever the display presents, going straight up.
//
// Two errors lived here, in opposite directions and both worth naming. It
// subtracted WALL vertically, but the seat's thickness is measured along the
// screen normal -- vertically that is WALL / cos(TILT), 2.79 at 55 degrees,
// not 1.6. And more importantly it assumed a seat there at all: since the seat
// was cut back to a rim, the window is open over |v| <= POCK_H/2 - SEAT and
// what is overhead is the module itself, with no plate under it.
//
// Over the hat's front corner at 55 degrees that is the difference between a
// reported 0.99 of clearance and a real 2.59. The physical part showed the
// space plainly; the model was subtracting a wall it no longer has.
function seat_drop(y) =
    let (zp = pocket_z(y),
         v = (y - CY) * cos(TILT) + (zp - CZ) * sin(TILT))
    abs(v) <= POCK_H / 2 - SEAT ? 0 : WALL / cos(TILT);
function ceil_at(y) = min(z_top(y), pocket_z(y) - seat_drop(y));

HAT_YS  = [for (i = [0 : 8]) MCU_Y + i * MCU_DY / 8];
MCU_FIT  = min([for (y = HAT_YS) ceil_at(y) - hat_top_at(y)]);
// Measured from the hat's BOARD, which is the datum the 20 mm was taken from.
// It was being measured from the top of the socket instead -- 3.92 mm higher,
// an extra requirement with nothing behind it, and the only thing that made a
// shallower screen fail this test.
//
// It is still a conservative proxy: it asks for 20 mm of clear space straight
// up, when the bundle is free to turn into any part of a 37 cm3 cavity. Treat
// a near miss here as worth looking at rather than as a verdict.
WIRE_FIT = max([for (y = HAT_YS) if (y >= TALL_Y) ceil_at(y)]) - (PCB_Z + PCB_T);

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

// FRONT is the one that mattered and was missing. Below the display the case
// still has to reach the desk, and the prism's cross-section was simply
// extended down the screen plane to get there -- so the skirt leaned FORWARD
// instead of dropping, by DROP * cos(TILT). At 70 that is 2.04 mm and easy to
// miss; at 55 it is 7.10, and it was the entire reason a shallower screen
// looked like it cost depth. It never did: the display's own geometry was
// being blamed for an artefact of how the case was closed underneath.
//
// Cut it off vertically at the rim instead. CY is chosen so the front rim's
// bottom corner sits at y = 0, and the module's own frontmost point is at
// y = +1.10 even at 55, so nothing of the display is touched.
FRONT = 0;

module trim(back, floor, r) {
    rotate([90, 0, 90]) linear_extrude(120, center = true)
        offset(r = r) offset(delta = -r)
            polygon(BACK_CHAMFER
                ? [[FRONT, floor], [back, floor], [back, CH_Z + floor],
                   [FRONT, CH_Z + floor + CH_M * (FRONT - back)]]
                : [[FRONT, floor], [back, floor], [back, 60], [FRONT, 60]]);
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
    difference() {                                       // opened-out window
        band(POCK_W - 2 * SEAT, POCK_H - 2 * SEAT,
             max(POCK_R - SEAT, 0.5), -WALL - BOSS_H - 1, 1);
        for (sx = [-1, 1], sy = [-1, 1])                  // keep the boss pads
            translate([0, CY, CZ]) rotate([TILT, 0, 0])
                translate([sx * HOLE_DX / 2 - SEAT_PAD / 2,
                           sy * HOLE_DY / 2 - SEAT_PAD / 2, -WALL - BOSS_H - 2])
                    cube([SEAT_PAD, SEAT_PAD, WALL + BOSS_H + 4]);
    }
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
    zt = PCB_Z + PCB_T + MCU_CLR;            // just clear of the board
    hx = MCU_DX / 2 + MCU_CLR;
    if (MCU_HOOKS)
        for (sx = [-1, 1])
            // Runs 0.5 into the kerb rather than stopping flush against it.
            // Flush is a coplanar contact, and the last time a retention
            // feature met the tray that way it came out as its own shell.
            translate([sx > 0 ? hx - HOOK_D : -hx - 0.5, MCU_Y, zt])
                cube([HOOK_D + 0.5, MCU_DY + 2 * MCU_CLR, HOOK_T]);
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
// The full brick, deliberately -- this is the room the assembly needs to get
// in, not the room it occupies once seated. Carving only the real profile left
// a shelf under the hat's bare strip at z = 6.0 with the XIAO hanging to 6.3:
// the whole thing could travel 0.3 mm before fouling, so it could only ever be
// dropped straight down, and the hooks need it to slide.
//
// The thin profile still governs the clearance checks -- see hat_top_at().
// Insertion volume and occupied volume are different things and the model now
// keeps them apart.
module mcu_box() {
    translate([-(MCU_DX + 2 * MCU_CLR) / 2, MCU_Y, MCU_Z])
        cube([MCU_DX + 2 * MCU_CLR, MCU_DY + 2 * MCU_CLR, MCU_DZ]);
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

// Bored from behind the boss, not through it: coaxial with the screw but
// starting past the head, so the boss keeps its 2.2 hole and its wall.
module lcd_access() {
    if (LCD_ACCESS)
        for (sx = [-1, 1])
            band_at(sx * HOLE_DX / 2, -HOLE_DY / 2, -WALL - BOSS_H - 0.5, 40);
}

module band_at(u, v, w0, len) {
    translate([0, CY, CZ]) rotate([TILT, 0, 0])
        translate([u, v, w0 - len]) cylinder(d = ACCESS_D, h = len);
}

module seat_bottom() {
    if (SEAT_OPEN_BOTTOM) {
        keep = HOLE_DX / 2 - BOSS_D / 2 - 1.0;      // stay clear of the bosses
        translate([0, CY, CZ]) rotate([TILT, 0, 0])
            translate([-keep, -POCK_H / 2, -WALL - BOSS_H - 1])
                cube([2 * keep, POCK_H / 2 - SEAT, WALL + BOSS_H + 2]);
    }
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
    // hat_screws() comes off the whole assembly at the end. Subtracted inside,
    // it bored the floor before the pads were unioned back on, and the pads
    // then capped the hole -- leaving a sealed 1.7 x 0.8 void in the floor
    // under each one, which shows up as two extra shells and nothing else.
    difference() {
    union() {
    // The pads and the hooks go back on AFTER the insertion volume is carved,
    // because both of them deliberately stand inside it -- that is what makes
    // them retention rather than decoration.
    intersection() { union() { hat_posts(); mcu_hooks(); } outer(); }
    difference() {
        union() {
            difference() { outer(); hollow(); }
            intersection() {
                union() { bosses(); mcu_tray_placed(); cap_posts(); tie_posts(); }
                outer();
            }
        }
        mcu_box();
        screw_holes();
        lcd_access();
        seat_bottom();
        cap_screws();
        translate([-100, DEPTH - CAP_T, -100]) cube([200, CAP_T + 60, 200]);
    }
    }
    hat_screws();
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
