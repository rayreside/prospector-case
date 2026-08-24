// Measured hardware, shared by every Prospector layout. Nothing in here is
// geometry -- it is the record of what the parts actually are, so that the
// layouts cannot drift apart on the numbers. Provenance for all of it is in
// prospector/REFERENCE.md.

/* [Display -- Waveshare 1.69" Touch LCD, 27057] */
DISP_W    = 39.00;    // from the upstream pocket, 39.09 less clearance
DISP_H    = 31.00;
DISP_T    = 9.96;     // glass to the tops of the module's own standoffs
// *** WAS 3.00, AND IT WAS THE ROOT OF THE CORNER FAULT. Nothing measured it;
// REFERENCE.md carries provenance for every other number here and never
// mentioned this one. Waveshare's panel table gives the corner as R5, and two
// independent things agree with that rather than with 3.00:
//
//   - The pocket is cut to this radius plus DISP_CLR. At 3.00 that is 3.20,
//     about two millimetres squarer than the module at every corner, so the
//     module's round corner sat inside a squarer hole and left a crescent of
//     open pocket. The module's own rim normally hides the pocket -- at 3.00 it
//     covers the corner by 0.865, at R5 by 0.037, and a hair past that the
//     pocket is exposed. That is the gap on the printed part, and it is why it
//     showed at the corners and nowhere else.
//   - Upstream's outer radius of 7.00, long written off here as "the upstream
//     look", is what the concentric identity below returns for a module of
//     about R5. It was never arbitrary. Reading this as 3.00 made 7.00 look
//     2 mm too round, and the correction went the wrong way: it squared the
//     outside down to 4.90, where the frame swells from 0.835 on the flats to
//     1.705 at the corners.
//
// So the identity was right and its input was wrong. STILL WANTS CALIPERS on a
// real corner -- 5.00 is the vendor's figure, not a measurement of this part.
DISP_R    = 5.00;     // corner radius of the module outline

// The module drops in from the FRONT and its lip lands on the case, rather
// than being fed in from behind and trapped by a lip on the case. Read off the
// upstream mount, which counterbores its opening for exactly this: 39.09 x
// 31.09 straight through, stepping out to 41.33 x 33.33 for the last 0.80 mm.
// So the case never sits over the glass at all, and how close the picture runs
// to the module's edge stops mattering.
//
// *** WAS 41.33 x 33.33, WHICH IS THE COUNTERBORE AND NOT THE MODULE. A bore
// is cut oversize so the part drops into it; Waveshare give the module as
// 41.13 x 33.13, so upstream's bore carries 0.10 of clearance a side -- the
// same 0.10 that LIP_CLR adds again for a bore drawn here. Taken as the part
// it understated the frame showing round the lip at 0.735 against upstream's
// 0.835, which read as this case being the tighter of the two. On the real
// module both are 0.835 and they are the same.
LIP_W     = 41.13;    // what rests on the case's front face
LIP_H     = 33.13;
LIP_T     = 0.80;     // 17.00 rim less the 16.20 step
LIP_CLR   = 0.10;
DISP_CLR  = 0.20;     // per side, module to pocket
ACT_W     = 32.58;    // active area, 280 px across at 0.1164 mm pitch
ACT_H     = 27.93;    // 240 px up
HOLE_DX   = 29.93;    // M2 pattern, measured -- not symmetric, see REFERENCE
HOLE_DY   = 22.57;
HOLE_D    = 2.40;

// The module's socket is its tallest point, 11.39 from the glass against 9.96
// to the standoffs, and it sits on the LEFT as you face the screen.
CONN_H    = 1.43;     // how far the socket stands proud of the standoff plane
PLUG_H    = 4.00;     // *** ESTIMATE. How much further a seated plug reaches.
                      // Inferred from the hat's 9.82 stack, not measured.

/* [XIAO nRF52840 on its hat] */
// The XIAO is soldered flat to the hat with no gap; the hat runs past it to
// the south for two mounting holes. USB-C is at the north end and leaves in
// the plane of the board. The hat's socket is on the opposite face and its
// cable leaves perpendicular to the board -- that one fact drives every
// layout decision here.
MCU_W     = 27.00;    // the long axis, the one the USB-C exits along
MCU_D     = 21.90;
MCU_H     = 9.82;     // whole stack, USB-C shell to the hat's socket
// The XIAO and its USB-C sit UNDERNEATH the hat once the assembly is inverted,
// so the hat's board is propped this far above the bottom of the stack. Found
// on the first test print: the screw posts had been drawn up to the stack's
// underside, where there is no board to meet them.
PCB_UP    = 4.30;     // stack bottom to the hat board's underside
MCU_CLR   = 0.30;
USB_W     = 9.50;     // upstream slot, which fits the plug shell with clearance
USB_H     = 3.75;
USB_Z     = 1.60;     // opening centre above the bottom of the stack

/* [Geometry common to the layouts] */
// 55 is the upstream screen angle, measured exactly off its geometry. It is a
// design choice rather than a property of the hardware, so each layout sets its
// own TILT and this is only the reference value.
TILT_UPSTREAM = 55.0;
WALL      = 1.60;
BEZEL     = 1.70;     // material around the module, in the screen plane
LIP       = 1.00;     // how far the front frame overhangs the module face
// Cross-section corner radius -- and it is not the free styling number it was
// taken for. The section is the module's pocket grown by BEZEL on every side,
// so its corners have to be the pocket's corners grown by that same BEZEL, or
// the frame stops being a constant width.
//
// The identity to keep is SEC - 2 * RIM_R == POCK - 2 * POCK_R on both axes --
// one rectangle underneath, two radii, a constant frame. prospector.scad
// measures it and echoes it on every build.
//
// WHAT THIS LINE GOT WRONG ONCE, because it is worth keeping and it is not the
// identity's fault. 7.00 was carried over as "the upstream look" and was
// written off here as free styling upstream could afford, its display sitting
// in a separate `disp_mount` plate. Read against DISP_R = 3.00 it looked 2 mm
// too round: 1.70 of frame on the flats against 0.83 at the diagonal, measured
// off the mesh at 0.829, with the module's lip overhanging the case corner by
// 0.13 with nothing underneath it.
//
// Every one of those numbers is a consequence of DISP_R being 3.00, and the
// module's corner is about 5. On the real module the frame at 7.00 was already
// uniform, and the correction squared the outside to 4.90 -- where the frame
// runs 0.835 on the flats and swells to 1.705 at the corners, the same fault
// mirrored. Upstream had not been careless; the radius was concentric with the
// module all along, and it is what this identity returns for a module of R5.
//
// The lesson is not about corners. A derived number is only as good as what it
// derives from, and this one derived from the one figure in the file that
// nothing had ever measured.
RIM_R     = DISP_R + DISP_CLR + BEZEL;   // 6.90, concentric with the pocket
