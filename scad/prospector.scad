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
// PRINTING. Shell desk-down as modelled; cap standing on its bottom edge, with
// a brim. Measured with tools/overhang.py, not reasoned about:
//
//     shell   desk-down     555 mm2 support, 1446 on the bed
//             front down    538                240
//             back down     504                117
//     cap     as modelled   638 mm2 support,   69 on the bed  <- 44.8 deg,
//             laid flat       0                378     see README
//
// All the shell's support is interior roof that nobody sees.
//
// WHAT SETS THE SIZE. Not the walls and not the display -- the hat. It is 27
// long front to back and 9.8 tall, and the display's back plane has to climb
// over it before the case can end. Three clearances gate the depth and all
// three are echoed on every build.
//
// The screen is at the upstream 55 and costs nothing for it. For a long time
// this file claimed a shallower screen bought depth back; that was three
// separate modelling faults, and prospector/README.md records them.

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
CONN_SLOT_OVER = 0.60; // past the pocket wall, leaving 1.1 of rim

// The display's screws run along the screen normal, which at 70 degrees is
// only 20 degrees off horizontal -- so a driver has to come in almost level
// from behind, and the case floor cuts that line off before it reaches the
// back opening. These are the two channels that let it through, bored on the
// screw axis from just behind each lower boss. They come out as long shallow
// ellipses in the underside, and using them means tipping the case up.
LCD_ACCESS = true;
ACCESS_D   = 5.00;    // 3.60 took a shaft but not a bit

// A pin hole for the XIAO's reset button. REFERENCE.md used to say not to
// spend geometry on this -- the button had never been needed in months of use
// -- and that is now reversed.
//
// It goes through the FLOOR because of how this build sits: the XIAO hangs
// underneath the hat and the whole stack is inverted, so the component face
// the button is on points down at the case's underside. Upstream's answer, a
// cantilever tab in the rear cap, was for a bare XIAO the other way up and
// does not transfer.
//
// A SLOT open to the shell's back edge, not a pin hole, and that is the whole
// trick. A hole has to be aimed, and neither number needed to aim it is known
// to better than a couple of millimetres: the button was measured 0.5 from the
// board's edge and 2.85 from the connector's face -- consistent with each
// other, the difference being a 2.35 Type-C overhang -- but whether either is
// to the button's centre or its near edge is not settled, and the offset ACROSS
// the board is not measured at all. A slot spanning the board's width and open
// at the back needs neither.
//
// It also gives up almost nothing. The underside is filleted at the back, so
// the floor there is already vestigial:
//
//     outer surface reaches y = 38.914 at z = 0.05
//                               39.464    0.20
//                               40.196    0.60
//                               41.023    1.55
//
// At y = 40.6 that is 0.6 mm of steeply curved floor -- a pin hole through it
// would have come out as a smeared crescent and might have broken the back
// edge. The slot removes a strip that was never carrying anything: the walls,
// the kerbs and the cap's posts all sit outside |x| = 9.75.
//
// Not a plunger or a sprung tab either. The floor's top is at 1.6 and the
// button sits around z = 3 to 4, so anything captive would have to bridge a
// couple of millimetres of air and would rattle for the rest of its life to
// save reaching for a paperclip on an operation needed once in several months.
//
// Where the button can be, now that the XIAO's own position is known: its
// USB-C edge sits flush with the hat's north edge, so with the hat at
// y = 14.1..41.1 and the XIAO 21.0 x 17.5, the chip spans y = 20.1..41.1 and
// x = +/-8.75. The 6 mm of bare hat south of that is the strip carrying the
// mounting holes, which agrees with SOCKET_Y and the screws at y = 16.75.
//
// The button is beside the USB-C, so it is near y = 41 -- the far end from the
// screws, which is exactly why MCU_HOOKS had to come back.
//
// And it is on the +x side, the right as you face the screen. Reported as "to
// the LEFT of the port, looking at the bottom with the port pointing up", which
// is a mirrored view and worth writing the conversion down rather than trusting
// twice. Seen from outside, the underside's viewer looks along +z; in this
// frame +y cross +x = -z, which points at that viewer, so turning from +y (up
// in their view) to +x is counterclockwise -- to their left. Assuming instead
// that they laid it face-down and looked from above gives the same answer: a
// 180-degree flip about the away axis sends +x to their left either way.
//
// So the button is around x = +6, y = 40.6. The slot is symmetric and covers
// both sides, which is deliberate -- a mirroring argument is not something to
// stake reachability on, and the floor being asymmetric would buy nothing.
// Verified regardless: a 1.5 mm pin is clear at (6.0, 40.3), (6.5, 40.6),
// (7.0, 40.6) and (8.0, 40.3).
//
// That whole region is clear underneath, which is the good news: the tray kerbs
// and rails keep to |x| >= 9.75, the rear cap's post feet to |x| >= 13, the
// hat's own screw pads to y <= 19, and the display's access bores to
// y <= 26. Anywhere inside the XIAO's footprint misses all of it.
//
// The slot is what makes that enough. A 2.6 hole would have had to find a
// button about 2 across, from numbers uncertain by a couple of millimetres in
// one axis and unmeasured in the other. Opening the strip instead trades a
// little of the underside -- which nobody sees and which was 0.6 mm thick --
// for not having to know.
// XIAO_Y1 and RESET_Y are set further down, where MCU_Y exists. Put here they
// read it before it is assigned, which OpenSCAD resolves to undef rather than
// erroring -- the hole would simply not appear and nothing would say why.
XIAO_L     = 21.00;   // bare board, from REFERENCE.md
XIAO_W     = 17.50;
RESET      = true;
// 18, so a pin can reach |x| = 7.5 rather than 6.5. Seeed put the button "on
// the side of the Type-C interface", and the connector is about 9 wide, so it
// most likely sits somewhere around |x| = 5.5 to 7 -- close enough to the edge
// of a 16 slot that a probe fouls the rim. This leaves a 0.75 sliver of floor
// out to the kerb at 9.75, which is thin but backed by the kerb its whole
// length.
RESET_W    = 18.00;
RESET_R    = 1.50;    // rounded ends
// Where the slot starts. Back of this and it is open to the shell's rear edge,
// where the cap takes over -- so the opening is bounded by the cap once the
// case is closed, and reads as a deliberate letterbox rather than a broken
// corner.

// Below the module the seat is carrying nothing -- the lower bosses sit at
// v = -11.285 and everything under them is there only because the ring was
// drawn at a uniform width. Opened out between them.
// Superseded: the window now reaches the rim on every side, so there is no
// lower band left to open out.
SEAT_OPEN_BOTTOM = false;
CAP_T     = 1.60;     // rear cap plate
CAP_SCR_X = 16.00;    // rear cap screws, clear of the hat at +/-11.25
CAP_SCR_Z = 7.00;
// One number picks the rear-cap screw and the other two follow. The cap's hole
// is clearance -- the screw is meant to pass through it and bite in the post
// behind -- so a screw that "goes straight through" is the pilot being loose,
// not the cap being wrong.
//
// These are the same M2 as the display's, which is the whole explanation: the
// pilot was 2.10, above the screw's own major diameter, so there was nothing
// for it to cut into. It was sized for the M2.5 the upstream BOM lists.
//
// Then it was 2.00 x 0.80 = 1.60, the textbook thread-forming pilot, and that
// was too tight the other way -- 4.4 mm of thread to form at once, and the
// driver cammed out of the head before the plate was down. The head then
// crushed into 1.6 mm of plate, which is the same fault seen from the other
// end rather than a second one.
//
// 1.70 is not a calculation. It is the pilot the hat's screws use, which is
// the only one in this case that has actually been driven and not complained
// about -- same screw, same plastic, same wall. Both now come off it.
M2_PILOT  = 1.70;
CAP_SCREW = 2.00;                     // M2, as the display uses
CAP_SCR_D = CAP_SCREW + 0.20;         // clearance through the cap
CAP_PILOT = M2_PILOT;
// Peak torque is the pilot times how much thread is being formed at once, and
// the second term was free to fix: the post's mouth is bored to clearance for
// CAP_FREE first, so an M2 x 6 forms about 3.4 mm of thread instead of 4.4.
// The lead-in also lets the screw find the hole square before it starts biting.
CAP_FREE  = 1.00;
// Where the head lands. A pan head wants the bore's lip broken and nothing
// more -- take too much and the head ends up bearing on a narrow ring, which
// is worse than the sharp edge. A countersunk head wants a real 90 degree seat.
CAP_HEAD    = "pan";                  // pan | flat
CAP_HEAD_D  = 3.80;                   // M2, either kind
CAP_CSK     = CAP_HEAD == "flat" ? (CAP_HEAD_D - CAP_SCR_D) / 2 : 0.30;
CAP_POST_D = 6.00;
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
HAT_SCR_D  = M2_PILOT; // M2 forming its own thread; the board's hole is 2.10
HAT_POST_D = 4.50;

// Rails along the TOP OF THE SIDE KERBS, which is the version that works. The
// earlier hooks reached back over the hat's front corners, so the board had to
// slide into them, and everything ahead of it blocked that. A rail runs along
// the direction of travel instead: the hat goes in from the back, passes under
// both rails the whole way, and lands on its pads. The kerbs already stood
// 0.9 proud of the board, which is where the idea came from.
//
// BACK ON, and the reason is worth keeping because this reverses twice.
//
// They were on, then off -- the two screws hold the hat perfectly well against
// gravity and against the cable, and the rails' undersides are horizontal ledge
// to support for retention that was already covered.
//
// Then the reset button. Both screws are at the hat's SOUTH end, y = 16.75, and
// the button is at the far end; pressing it from below is a force trying to
// lift the free end, and the board would tilt about those two screws. Nothing
// else in the case touches the hat's north end. So the rails come back -- not
// for retention in general, but to take that one load.
MCU_HOOKS = true;
HOOK_W    = 6.00;     // hooks over the hat's front corners
// Rails only need to reach back from the cap far enough to stop the hat's free
// end lifting -- the two screws hold the front. Running them the full length
// took them forward into the display's screw holes.
// They also moved NORTH once the reset gave them a job. At RAIL_BACK = 8 they
// sat over y = 25..33, the middle of the board, with little leverage on a press
// at the north end. At 2 they run y = 29.4..39.4 and hold the end being pushed.
//
// 8 had been chosen to stand clear of the rear cap's posts, which on measuring
// is a clearance rather than a collision: the posts are at |x| = 13..19 and the
// rails reach 11.75, so they miss by 1.25 whatever the length.
RAIL_LEN  = 10.00;    // length of each rail
RAIL_BACK = 2.00;     // how far short of the hat's back edge they stop
HOOK_D    = 1.50;     // how far they reach back over it
HOOK_T    = 1.20;     // thickness of the tongue
TIE_POSTS = false;    // a pair of posts to zip-tie the bundle down to
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
// Desk to the LOWEST point of the pocket, which is its back-bottom corner on
// the seat plane -- not the visible bottom edge of the opening, which is 5.25
// higher up the screen.
//
// 3 rather than 4: it drops the screen 1 mm nearer the desk and takes the case
// down with it, 36.37 to 35.37, for nothing in depth or width. What it spends
// is margin. Both gates fall 1:1 with it and they run out together at 2:
//
//     lift 4   36.37 tall   hat 3.70   cable 21.38
//     lift 3   35.37        hat 2.70   cable 20.38   <-- here, want 2.5 and 20
//     lift 2   34.37        hat 1.70   cable 19.38   both fail
//
// Depth does not buy lift 2 back either. Lowering the display lowers the whole
// cross-section, so the ceiling over the hat comes down with it; at DEPTH 46
// the hat recovers to 3.90 but the cable is still 19.64.
DISP_LIFT = 3.00;

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
// The counterbore recessed the module's lip so it finished flush, and left a
// ring only 0.85 wide by 0.80 deep standing around it -- two extrusion widths
// and four layers, which does not print. Off: the front is one flat face with
// the pocket's opening in it, the lip lands on that face and stands 0.80 proud,
// and the material around the opening becomes the full 1.7 bezel instead of a
// fragile ledge. Upstream's is flush, but its ring is 0.835 and no better.
LIP_BORE = false;
LIP_R  = DISP_R + (LIP_W - DISP_W) / 2;  // the lip's own corner radius
BORE_W = LIP_W + 2 * LIP_CLR;         // counterbore the lip seats in
BORE_H = LIP_H + 2 * LIP_CLR;
BORE_R = LIP_R;
RIM_MIN = 0.85;                       // material left around the counterbore
// The cross-section is now the larger of what the module's body needs and what
// the lip's counterbore leaves standing. Upstream keeps 0.835 mm around its
// counterbore, and that ring is only LIP_T deep, so it is a lip rather than a
// wall.
SEC_W  = LIP_BORE ? max(POCK_W + 2 * BEZEL, BORE_W + 2 * RIM_MIN)
                  : POCK_W + 2 * BEZEL;
SEC_H  = LIP_BORE ? max(POCK_H + 2 * BEZEL, BORE_H + 2 * RIM_MIN)
                  : POCK_H + 2 * BEZEL;
// Flush with the rim if it is recessed; otherwise the face sits at the lip's
// underside and the lip stands on it.
W_RIM  = LIP_BORE ? DISP_T : DISP_T - LIP_T;
W_BACK = -40;                         // prism runs well past the trim planes

// What the frame actually measures, all the way round. BEZEL is only its width
// on the flats; the corners are where the section's rounding and the module's
// rounding meet, and where a mismatch shows first. Both outlines are the same
// kind of shape -- a rectangle grown by a radius -- so the material outside an
// inner outline is RIM_R less the distance from each point of the inner arc to
// the outer rectangle. Concentric corners make that a constant, which is the
// whole point, but it is measured rather than assumed: change RIM_R and this
// says what it costs instead of failing quietly on the printed part.
function frame_min(w, h, r) =
    min([for (a = [0 : 1 : 90])
        RIM_R - norm([max(0, w / 2 - r + r * cos(a) - (SEC_W / 2 - RIM_R)),
                      max(0, h / 2 - r + r * sin(a) - (SEC_H / 2 - RIM_R))])]);
FRAME_MIN = frame_min(POCK_W, POCK_H, POCK_R);
// With LIP_BORE off the lip lands on the front face, so this is the case that
// shows around it. Negative means the lip hangs over the corner in the air.
LIP_SHOW  = frame_min(LIP_W, LIP_H, LIP_R);

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

// The XIAO's own footprint, which is what bounds where the reset button can be.
// Its USB-C edge sits flush with the hat's north edge -- measured -- so the
// board runs back from there by its own length, and the 6 mm of bare hat left
// to the south is the strip carrying the mounting holes.
XIAO_Y1 = MCU_Y + MCU_CLR + MCU_DY;      // north edge, flush with the hat's
XIAO_Y0 = XIAO_Y1 - XIAO_L;
// Front edge of the slot. 3 in from the board's north edge covers the button
// wherever in that range it turns out to sit -- 0.5 from the edge to its centre
// puts it at 40.6, 0.5 to its near edge puts it at about 39.6, and both fall
// inside 38.1..41.4 with room to spare.
RESET_Y = XIAO_Y1 - 3.00;
echo(str("XIAO spans y ", XIAO_Y0, "..", XIAO_Y1, ", x +/-", XIAO_W / 2,
         RESET ? str("; reset slot ", RESET_W, " wide, y ", RESET_Y, "..",
                     DEPTH - CAP_T)
               : "; reset slot OFF"));

// Where the tray's side kerbs are allowed to start. The display's two lower
// access bores come down through this part of the case -- they leave the
// bosses at 55 degrees and reach the desk around y = 22 -- and the tray's
// outer corners are right on their line. Drawn the full length, the bores cut
// a notch out of each kerb: it reads as a collision on the printed part and it
// is one, a nicked 1.5 mm wall over 8 mm of its length.
//
// So the kerbs stop short instead. This is the y at which the bore, taken at
// its full radius rather than at the sliver that actually overlaps, has
// dropped clear below the tray's underside -- about 2 mm more than the tight
// answer, and worth it for not depending on where the kerb's outer face is.
KERB_CLR = 1.00;
ACC_Y0 = CY - HOLE_DY / 2 * cos(TILT);              // lower boss, world y-z
ACC_Z0 = CZ - HOLE_DY / 2 * sin(TILT);
KERB_Y = LCD_ACCESS
    ? max(MCU_Y, ACC_Y0 + ACCESS_D / 2 * cos(TILT) + KERB_CLR
                 + (ACC_Z0 + ACCESS_D / 2 * sin(TILT) - (FLOOR - 0.2)) * tan(TILT))
    : MCU_Y;


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
echo(str("frame round the pocket ", FRAME_MIN, " mm at its thinnest  (want ",
         BEZEL, ", its width on the flats)"));
if (!LIP_BORE)
    echo(str("case showing round the lip ", LIP_SHOW, " mm at its thinnest  (want ",
             (SEC_W - LIP_W) / 2, ", ditto)"));
echo(str("hat clears the ceiling by ", MCU_FIT, " mm  (want ", SLACK, ")"));
echo(str("plug room at the socket ", CONN_FIT, " mm  (want ", CONN_NEED, ")"));
echo(str("headroom over the hat ", WIRE_FIT, " mm  (want ", WIRE_UP, ")"));
echo(str("tray kerbs from y ", KERB_Y, " to ", MCU_Y + MCU_DY + 2 * MCU_CLR,
         "  (hat front ", MCU_Y, ")"));

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

// CH_DROP is the vertical offset that corresponds to insetting the chamfer
// perpendicularly by one wall. Without it the cavity's chamfer was written as
// CH_Z + WALL + CH_M * (y - back) with back = DEPTH + 1, which put it 2.71 mm
// ABOVE the outer skin instead of 2.39 below -- so the whole chamfered roof
// had no material behind it and the top of the back was simply missing. It
// looked like a panel that had not been designed yet.
CH_DROP = WALL * sqrt(1 + CH_M * CH_M);
CAP_DROP = CAP_T * sqrt(1 + CH_M * CH_M);

// The chamfer line is always referenced to DEPTH, never to `back`, or moving
// the back plane tilts the roof.
function ch_at(y, drop) = CH_Z - drop + CH_M * (y - DEPTH);

module trim(back, floor, r, drop = 0) {
    rotate([90, 0, 90]) linear_extrude(120, center = true)
        offset(r = r) offset(delta = -r)
            polygon(BACK_CHAMFER
                ? [[FRONT, floor], [back, floor], [back, ch_at(back, drop)],
                   [FRONT, ch_at(FRONT, drop)]]
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
    band(POCK_W, POCK_H, POCK_R, 0, DISP_T - LIP_T + 1); // the module's body
    if (LIP_BORE)
        band(BORE_W, BORE_H, BORE_R, DISP_T - LIP_T, W_RIM + 1);
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
            // Overruns the pocket wall by CONN_SLOT_OVER. Landing exactly on
            // it put the slot's side face and the pocket's side face in the
            // same plane, which is where the last self-intersections were.
            translate([sx < 0 ? -POCK_W / 2 - CONN_SLOT_OVER
                              : POCK_W / 2 - CONN_SLOT_U,
                       -CONN_SLOT_V / 2, -WALL - BOSS_H - 1])
                cube([CONN_SLOT_U + CONN_SLOT_OVER, CONN_SLOT_V,
                      WALL + BOSS_H + 2]);
    intersection() {                                      // main cavity
        band(SEC_W - 2 * WALL, SEC_H + DROP - 2 * WALL, RIM_R - WALL,
             W_BACK, -WALL, -DROP / 2);
        // Past the back, not up to it. Ending the cavity on the same plane the
        // shell is cut on left the two coplanar, and the back came out closed:
        // a +y face of 825 mm2 where there should have been a ring of about 90.
        // Past the cap's inner face, not level with it. The cap carries the
        // roof now, so the shell must have no material there at all -- but
        // asking two trims with different corner radii to land on the same
        // surface left paper-thin slivers instead of nothing, and 219
        // self-intersecting triangle pairs with them. Let the cavity overrun
        // and let cap_solid() alone define where the shell stops.
        trim(DEPTH + 1, WALL, max(BACK_R - WALL, 0.5), -0.5);
        // That overrun is right BEHIND the split and wrong in front of it.
        // Forward of SPLIT_Y the shell has to carry the roof itself, and
        // nothing was setting its thickness: its outer face is the chamfer,
        // its inner face was whatever the cavity prism's top face happened to
        // be, and those two planes converge and cross at y = 30.2. So the roof
        // ran out as a wedge -- 0.59 mm thick at y = 29, 0.27 at y = 29.9,
        // nothing at the seam -- and the feather edge tore off the printed
        // part and left a slot along the top of the cap.
        //
        // Bounded by the cap's own inner face instead, so the shell's roof is
        // the same 1.6 plate the cap is and the two butt flush. Behind the
        // split this bound does nothing, which is what keeps the overrun above
        // free to be the only thing describing that surface.
        union() {
            trim(DEPTH + 1, WALL, max(BACK_R - WALL, 0.5), CAP_DROP);
            translate([-100, SPLIT_Y, -100]) cube(200);
        }
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
// Two pieces, because they stop in different places. The pad under the board
// runs the whole length -- it is only MCU_LIFT proud of the floor and nothing
// comes near it -- while the kerbs start at KERB_Y, clear of the display's
// access bores.
module mcu_tray() {
    W = MCU_DX + 2 * MCU_CLR + 2 * KERB;
    L = MCU_DY + 2 * MCU_CLR;
    translate([0, MCU_Y, FLOOR - 0.2])
        cube([W, L, MCU_Z - FLOOR + 0.2], center = false);
    translate([0, KERB_Y, FLOOR - 0.2])
        cube([W, MCU_Y + L - KERB_Y, PCB_Z - FLOOR + KERB_H + 0.2],
             center = false);
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
            translate([sx > 0 ? hx - HOOK_D : -hx - 0.5,
                       MCU_Y + MCU_DY + 2 * MCU_CLR - RAIL_BACK - RAIL_LEN, zt])
                cube([HOOK_D + 0.5, RAIL_LEN, HOOK_T]);
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
    y0 = DEPTH - CAP_T - CAP_POST_L - 0.5;      // behind the post's far end
    thread = DEPTH - CAP_T - CAP_FREE - y0;     // and the rest is lead-in
    for (sx = [-1, 1])
        translate([sx * CAP_SCR_X, y0, CAP_SCR_Z]) rotate([-90, 0, 0]) {
            cylinder(d = CAP_PILOT, h = thread);
            translate([0, 0, thread])
                cylinder(d = CAP_SCR_D, h = CAP_FREE + CAP_T + 1);
            translate([0, 0, DEPTH - CAP_CSK - y0])
                cylinder(d1 = CAP_SCR_D, d2 = CAP_SCR_D + 2 * CAP_CSK,
                         h = CAP_CSK);
            translate([0, 0, DEPTH - y0])
                cylinder(d = CAP_SCR_D + 2 * CAP_CSK, h = 1);
        }
}

// Cut through the floor from RESET_Y back to where the shell ends, so the
// button can be reached with anything to hand.
module reset_hole() {
    if (RESET)
        hull() for (sx = [-1, 1], sy = [0, 1])
            translate([sx * (RESET_W / 2 - RESET_R),
                       RESET_Y + sy * (DEPTH - CAP_T - RESET_Y), -1])
                cylinder(r = RESET_R, h = FLOOR + 2);
}

module usb_slot() {
    translate([0, DEPTH - CAP_T / 2, MCU_Z + USB_Z])
        cube([USB_W, CAP_T * 4, USB_H], center = true);
}

// The back is where the case opens: it is the one face that is flat, and the
// module has to go in from behind it because the front frame's lip is what
// holds the module in.
// The cap is the back AND the chamfered roof, as one bent panel. It has to be:
// the display's upper screws run along the screen normal, and with a fixed
// roof the driver's line clips the top edge of the back opening by about a
// millimetre. Taking the roof off with the cap clears it, and avoids putting
// access holes through a face that is on show.
//
// It is also the larger surface, which is the other thing it is wanted for.
// SPLIT_Y stops the cap's roof running forward to the display. Left to the
// chamfer alone it reached y = 19.76, and the display face's top edge is at
// 19.96 -- so with the cap off the case was open right up to the back of the
// screen, which is the slot that keeps showing up in the slicer.
SPLIT_Y = 30.00;

// The reason the roof leaves with the cap, as a number rather than an
// assertion. The upper display screws run along the screen normal, and with the
// cap off the nearest thing to that line is the corner where the shell's roof
// stops. Twice the perpendicular distance is the fattest shaft that can reach
// them, and it wants to beat ACCESS_D -- the bottom screws needed 5.00 before a
// bit would pass, and there is no reason the top ones need less.
//
// Everything it reads must be defined already. A forward reference here comes
// back undef and the number is silently wrong rather than missing, which is a
// mistake this file has made before.
SCR_Y = CY + HOLE_DY / 2 * cos(TILT);        // upper display screw, world y-z
SCR_Z = CZ + HOLE_DY / 2 * sin(TILT);
DRIVER_FIT = 2 * ((SPLIT_Y - SCR_Y) * cos(TILT)
                + (ch_at(SPLIT_Y, CAP_DROP) - SCR_Z) * sin(TILT));
echo(str("driver at the top screws ", DRIVER_FIT, " mm across  (want ",
         ACCESS_D, ")"));
// What the seam actually shows on the roof, which is the number to watch when
// SEAM_SHOW is touched -- the gap is cut in y and read on a 45 degree face, so
// it is always the wider of the two.
echo(str("seam shows ", SEAM_SHOW / cos(atan(-CH_M)),
         " mm across the roof  (cut at ", SEAM_SHOW, " in y)"));

// THE SEAM IS A LAP NOW, NOT A BUTT, AND THIS IS WHY.
//
// The cap seats by travelling forward until its back plate meets the shell at
// y = 41.4. Its roof tip arrives at y = SPLIT_Y at the same instant, because
// both were cut on that one plane -- so the joint was over-constrained: two
// faces, in different planes, both required to close at once, on two parts
// printed separately.
//
// On the part the tip lands first. Then the screws keep pulling, the back plate
// cannot close, and the roof has nowhere to go but backwards -- which is
// exactly the small gap that showed up.
//
// I had checked shell against cap and found they only touched, and called it a
// butt joint located by two screws. That was right about the BACK plane and
// blind to this one: a face square to the direction of travel must not touch
// before the seating face does.
//
// So the cap's tip stops SEAM_CLR short, and the shell's outer skin laps back
// over the gap. The clearance goes in y, where nothing sees it; the lap's
// underside and the tip's top face still meet, so the shell also holds the
// cap's roof down instead of merely abutting it.
SEAM_CLR  = 0.30;     // the cap's roof tip stops this far short of SPLIT_Y
// The OTHER end of the lap, and it was the same number until it became clear
// the two are not the same problem.
//
// SEAM_CLR above is the tongue's tip against the shell's roof end. It sits
// under the lap where nothing can see it, and it is the clearance that bent the
// roof backwards when it was zero -- so it stays generous.
//
// This one is the cap's shoulder, where its skin steps back up to full
// thickness, against the trailing end of the shell's lap. Neither part owns the
// roof across it, so it is the 0.3 line the note above admits to -- and on a
// 45 degree roof it opens up by 1/cos, showing 1.41 times its own width: 0.42
// at 0.30. That is a groove 0.80 deep, not a hairline, and it is the mark on
// the printed part after the lap itself was fixed.
//
// The two ends do not carry the same risk either. If this one binds, the cap
// stops 0.15 short of a seat it is being pulled onto by two screws, on a step
// only 0.80 deep, and the fault shows as a gap at the back plate. If the TIP
// binds it levers the whole roof. So this end can be tightened and that one
// should not be.
//
// What it has to absorb: the difference between two nominally 9.4 mm runs, from
// each part's own seating face to its end of the lap. Both are plain y
// positions in the print -- vertical walls placed by XY motion on both parts,
// not layer-quantised -- so it is XY accuracy twice over and nothing worse.
SEAM_SHOW = 0.15;     // and how far the cap's shoulder stands off the lap's end
SEAM_LAP  = 2.00;     // how far the shell's skin reaches back over it
SEAM_T    = 0.80;     // half of CAP_T, so neither member is thinner than that
SEAM_DROP = SEAM_T * sqrt(1 + CH_M * CH_M);

module cap_solid() {
    intersection() {
        difference() { outer(); trim(DEPTH - CAP_T, 0, BACK_R, CAP_DROP); }
        translate([-100, SPLIT_Y, -100]) cube(200);
    }
}

// The outer skin over the lap band, which stays with the SHELL. Bounded by
// outer() and by a plane parallel to the chamfer -- not by cap_solid(), whose
// own boundary is a differently rounded trim and would leave slivers where the
// two describe the same surface.
//
// IT HAS TO BE UNIONED ON, and for a long time it was not. Excluding it from
// cap_void() only stops the cap's region taking it away; it does not put it
// there. What was actually left behind the split was whatever outer() minus
// hollow() happened to leave, and behind SPLIT_Y hollow() is deliberately
// unbounded above -- so the roof there was governed by the cavity prism's own
// top face, which crosses the chamfer. The lap came out as a WEDGE: 0.44 mm at
// y = 30, 0.14 at 31, nothing by 31.5, against the 0.80 slab it is written as.
//
// That is the same feather edge that tore off the roof FORWARD of the split
// and left a slot along the top of the cap. The forward side was fixed by
// bounding the cavity with the cap's inner face; this side kept the fault,
// because the fix was never applied to the material the lap is made of. On the
// printed part it reads as a slot in the roof about 1.5 mm wide -- the lap
// simply is not there, and what little of it printed was under one extrusion
// width for its whole length.
module seam_lip() {
    intersection() {
        difference() { outer(); trim(DEPTH + 1, -50, 0.5, SEAM_DROP); }
        translate([-100, SPLIT_Y, -100]) cube([200, SEAM_LAP, 200]);
    }
}

// What the shell gives up: the cap's region less the lip it keeps.
module cap_void() { difference() { cap_solid(); seam_lip(); } }

module cap() {
    difference() {
        intersection() {
            cap_solid();
            translate([-100, SPLIT_Y + SEAM_CLR, -100]) cube(200);
        }
        // its tip is the inner half, so the shell's skin can lie over it
        intersection() {
            difference() { outer(); trim(DEPTH + 1, -50, 0.5, SEAM_DROP); }
            translate([-100, -100, -100])
                cube([200, 100 + SPLIT_Y + SEAM_LAP + SEAM_SHOW, 200]);
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
// Nothing to draw once BOSS_H is zero: the cylinder would sit entirely inside
// the seat plate that already exists, adding no material but landing its front
// face exactly on the seat's front plane. That coplanar contact was the shell's
// one non-manifold edge -- 0.33 mm of it, at (-12.5, 11.4, 8.1).
module bosses() {
    if (BOSS_H > 0)
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
                union() { bosses(); mcu_tray_placed(); cap_posts(); tie_posts();
                          seam_lip(); }
                outer();
            }
        }
        mcu_box();
        screw_holes();
        lcd_access();
        reset_hole();
        seat_bottom();
        cap_screws();
        cap_void();
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
