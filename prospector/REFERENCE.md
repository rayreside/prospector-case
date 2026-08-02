# Prospector dongle — measured reference

Everything here was measured off the upstream case
([carrefinho/prospector](https://github.com/carrefinho/prospector), `case/`),
not read off a datasheet. Waveshare publishes no usable drawing for the module
and the vendor pages return 403 to anything but a browser, so the display
outline below is derived from the pocket that holds it.

Tools used: `tools/loops.py` (tilted sections, loop by loop),
`tools/stlstat.py` (bulk properties), `tools/void.py` (where the air is).

## What the stock case costs

| | |
|---|---|
| Envelope | 43.2 x 51.4 x 38.0 mm |
| Convex-hull volume | 59.86 cm3 |
| Plastic | 15.92 cm3 |
| Free interior | 43.94 cm3 — **73% air** |

Parts: `main_body_no_sensor` 7.137 cm3, `rear_cap` 5.785 cm3,
`disp_mount` 3.002 cm3. All three are watertight, 0 boundary edges.

The three STLs share one origin, so they can be imported together and measured
as an assembly without any transform.

## Why it is that size

Not the width. The front face is 43.0 x 35.0 mm around a 39.09 x 31.09 pocket:
a **1.95 mm bezel**, already near the floor. About 0.5 mm is recoverable there
and no more.

The depth and the height. The two boards sit at opposite corners of an empty
shell — display at the front top, XIAO flat on the floor at the back — so the
wire run is a ~45 mm diagonal across a box that is otherwise air. The bezel
frame alone is 10.6 mm deep from the body face to the front rim, most of that
a styling recess around the glass.

## Screen plane

**55.000 degrees from horizontal.** Recovered from the area-weighted face
normal (0, -0.819, 0.574) = (0, -sin 55, cos 55), which is exact to the 0.01
rounding of the normal cluster.

Nothing about the display is measurable in the export frame. `tools/loops.py
--tilt 55` sections in the screen's own frame; `u` is across the screen, `v` up
it, `w` out of it, with `w = 0` at the export origin and `w` increasing
forward.

| Feature | w (mm) |
|---|---|
| Body screw tabs | 4.40 -> 6.40 |
| Body front face (pocket floor) | 6.40 |
| Mount screw tabs | 6.50 -> 8.50 |
| Mount front rim | 17.00 |

## Waveshare 1.69" Touch LCD Module (27057)

| | |
|---|---|
| Outline | **39.09 x 31.09** mm pocket -> module ~39.0 x 31.0 |
| Mounting holes | 4 x M2, **29.93 x 22.57** mm pattern, 2.40 mm clearance |
| Orientation | landscape — 280 px across, 240 px up |
| Active area | 32.58 x 27.93 mm (1.69" diagonal, 0.1164 mm pitch) |
| Bezel on the module | 3.25 mm each side, 1.58 mm top and bottom |
| Thickness to the standoff tops | **9.96** mm (measured) |
| Thickness to the connector, its tallest point | **11.39** mm (measured) |

The hole pattern is not quite symmetric about the pocket: centres come out at
u = +14.922 and -15.008. Measured, not assumed; do not round it to +/-15.

The module carries its **own standoffs** on the back, and its four mounting
holes are real holes through it — so the seat in the case bears on the standoff
tops at 9.96, and the connector stands **1.43 mm proud of that** and needs a
relief. The CAD could not have given either number: from the upstream pocket
alone the module could have been anything up to 8.5 mm thick, which turned out
to be wrong in the other direction.

### Wiring

The module carries a **12-pin connector** on its back, not solder pads: VCC,
GND, LCD_DIN, LCD_CLK, LCD_CS, LCD_DC, LCD_RST, LCD_BL, TP_SDA, TP_SCL,
TP_RST, TP_IRQ. The supplied cable plugs in; the four TP_* wires are cut,
leaving **8 conductors** to the XIAO, which are soldered at that end.

So the display end is a plug, and the connector body plus the cable's bend
radius set a hard standoff behind the module — the wires cannot leave flush.
The upstream body has a 39.09 x 17.57 mm window in its front face, centred on
the module, purely to clear that connector and cable.

The connector sits on the **left** as you face the screen — `-x` in the model's
frame, on the right if you are looking at the back of the board.

## The build this is actually for — not stock

The unit being designed around is **not** the upstream wiring. The XIAO carries
a **hat with its own connector for the LCD cable**, so the link is a plugged
cable at *both* ends rather than eight wires soldered to the XIAO's pads.

That changes three things and all of them matter:

Measured:

| | |
|---|---|
| Hat outline | **21.9 x 27.0** mm |
| Whole stack, USB-C shell to the hat's socket | **9.82** mm |
| Glass to the end of the USB-C, boards perpendicular | **~36** mm |

The XIAO is soldered flat to the hat with no gap. The hat runs past it to the
south for two mounting holes; the USB-C is at the north end and exits in-plane,
off the board's edge. The hat's socket is on the **opposite face** from the
USB-C and its cable leaves **perpendicular to the board**.

That last point drives the layout. The socket has to face into the cavity, so
the assembly goes in inverted relative to the stock build — XIAO down, socket
up — which also drops the USB-C to the bottom of the stack where it wants to be.

**The hat is 5.81 cm3 against a bare XIAO's 1.61.** With the display's 12.04
that is 17.9 cm3 of hardware, in a stock case enclosing 59.9 — only 30% full,
but the free space is the wrong shape, not surplus.

Reset access is **not required** — the user has never needed the button in
several months of use. Do not spend geometry on it.

### What this rules out

A 55-degree screen with the hat lying flat does not fit at any depth up to
70 mm. The hat's top lands at z = 13.6, which is level with the middle of the
display, so the display's back plane and the hat foul each other long before
the case is small. Steepening the screen rescues it, but only to about 48 mm
deep against upstream's 51.4 — a 7% win, not worth the change.

The screen angle is the binding constraint, not the wall thickness and not the
layout cleverness.

## Seeed XIAO nRF52840

21.0 x 17.5 x 3.5 mm, about 4.5 mm over the USB-C shell. It fits entirely
inside the display's own 39 x 31 shadow, which is what makes folding the two
boards together worthwhile.

In the stock case it lies flat on the floor at the back, USB-C out the rear
face through a **9.5 x 3.75 mm** slot centred at x = 0, z = 5.355. The rear
cap carries a 1.8 mm wide cantilever tab beside that slot — the external reset.

Rear cap also has two 6.0 mm counterbores at x = +/-16.55, z = 14.33 for the
M2.5 x 4 screws that hold it on.

## Fasteners

| Screw | Count | What |
|---|---|---|
| M2 x 6 | 4 | display / mount / body sandwich |
| M2.5 x 4 | 4 | rear cap, and the sensor board upstream |
