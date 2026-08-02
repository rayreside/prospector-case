// Measured hardware, shared by every Prospector layout. Nothing in here is
// geometry -- it is the record of what the parts actually are, so that the
// layouts cannot drift apart on the numbers. Provenance for all of it is in
// prospector/REFERENCE.md.

/* [Display -- Waveshare 1.69" Touch LCD, 27057] */
DISP_W    = 39.00;    // from the upstream pocket, 39.09 less clearance
DISP_H    = 31.00;
DISP_T    = 9.96;     // glass to the tops of the module's own standoffs
DISP_R    = 3.00;     // corner radius of the module outline

// The module drops in from the FRONT and its lip lands on the case, rather
// than being fed in from behind and trapped by a lip on the case. Read off the
// upstream mount, which counterbores its opening for exactly this: 39.09 x
// 31.09 straight through, stepping out to 41.33 x 33.33 for the last 0.80 mm.
// So the case never sits over the glass at all, and how close the picture runs
// to the module's edge stops mattering.
LIP_W     = 41.33;    // what rests on the case's front face
LIP_H     = 33.33;
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
RIM_R     = 7.00;     // cross-section corner radius, matches the upstream look
