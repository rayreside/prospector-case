# Prospector dongle case — compact

A smaller enclosure for a [Prospector](https://github.com/carrefinho/prospector)
built **without** the ambient light sensor, and with a **hat on the XIAO**
carrying a socket for the LCD cable — so the link is a plugged cable at both
ends rather than eight wires soldered to the XIAO's pads. That hat is what the
design is really shaped around.

Model: [`scad/prospector.scad`](../scad/prospector.scad), hardware constants in
[`prospector_hw.scad`](../scad/prospector_hw.scad), measurements and their
provenance in [REFERENCE.md](REFERENCE.md). Built to `build/prospector/`.

## Where it stands

| | upstream, no sensor | this |
|---|---|---|
| Envelope | 43.2 x 51.4 x 38.0 | 43.2 x **43.0 x 37.0** |
| Enclosed | 59.86 cm3 | **45.16 cm3** |
| Plastic | 15.92 cm3 | **11.74 cm3** |
| Parts | 3 | 2 |

Same width, 16% shallower, 1 mm shorter, 25% less enclosed volume, 27% less
filament, and the screen keeps the upstream 55 degrees. Both parts watertight,
one shell each, zero boundary edges.

The width does not move and cannot: it is the display's lip counterbore plus
the ring left standing around it. Everything saved is depth, and it comes from
folding the boards together instead of putting them at opposite corners of an
empty box.

## The three clearances

The size is set by the hat and the cable, not by walls or the display. All
three gates are computed and echoed on every build, because not one of them is
visible in a render:

```
ECHO: "hat clears the ceiling by 6.47606 mm  (want 3)"
ECHO: "plug room at the socket 20.2712 mm  (want 15)"
ECHO: "headroom over the hat 21.3678 mm  (want 20)"
```

The 15 and the 20 are measured off the real bundle — it takes 15 mm bunched and
uncompressed, and wants 20 mm above the hat to turn upward comfortably.

Each of these has been wrong at least once in a way that only a number caught:

- **Hat vs ceiling** started as a test against the display's back plane treated
  as *infinite*, which silently forbade sliding the hat forward under the
  display's lower edge. The display is a bounded slab; the test is now against
  the actual pocket.
- **Plug room** was measured to the hat's front face at the module's centre
  height and read 3.58 mm. The hat is 9.8 tall and that centre is 17 up, so the
  hat is not there at all — a proper ray against its box gives 20.6.
- **Headroom** has an optimum, not a floor. The ceiling over the hat is the
  lower of the display's back plane rising toward the rear and the case's top
  face falling; the tallest point is where they cross, and the depth is chosen
  to land the hat's front edge on it.

## The screen angle is free

It is 55 degrees, the same as upstream, and it costs nothing. Every angle comes
out 43.0 deep; the shallower ones are slightly shorter:

| screen | lift | depth | height |
|---|---|---|---|
| 70 | 4 | 43.0 | 38.71 |
| 65 | 4 | 43.0 | 38.40 |
| 60 | 4 | 43.0 | 37.83 |
| **55** | **4** | **43.0** | **37.00** |

For most of this project the model insisted a shallower screen cost 5-7 mm of
depth, and it was wrong three separate ways, each found the same way -- by
being told the space was plainly visible on the assembled part:

1. **The skirt leaned forward.** Below the display the case reaches the desk by
   extending its cross-section down the *screen plane*, so at a shallow angle
   it threw material forward instead of dropping: 7.10 mm at 55 against 2.04 at
   70. Trimmed vertically at the rim, and the depth difference vanished.
2. **The ceiling test subtracted a wall that was gone.** After the seat was cut
   back to a rim the window is open above the hat, so what is overhead is the
   module itself -- not a plate 1.6 below it. And 1.6 was being taken
   vertically when it is measured along the normal. Over the hat's front corner
   that was 0.99 reported against 2.59 real.
3. **The cable's headroom was measured from the socket**, 3.92 mm above the hat
   it had been measured from.

What remains true is that a 31 mm display at 55 lies over 17.8 mm of the case's
depth against 10.6 at 70. That is real, and it is why the *interior* is
shallower behind the module at 55 -- but it does not reach the outside, because
the depth is set by the hat, not by the display.

## The form

Underneath the rounding, the upstream case is a rounded-rectangle prism whose
axis is the screen normal, trimmed by the desk plane and a vertical back wall.
This is the same prism with the back pulled forward and its top-back corner
chamfered off — which is where the volume actually was. The chamfer stops short
of a clean triangle on purpose: a single line from the apex to the bottom-back
corner has to clear a 9.8 mm brick sitting 45 mm out, and solving that puts the
case at **69 mm** deep. The hat owns the bottom-back corner.

## What holds what

| part | held by |
|---|---|
| display | drops in from the front, lip in the counterbore, 4 x M2 from inside into its own standoffs |
| rear cap | 2 x M2.5 into posts at x = +/-16, from outside |
| hat | pads at its own hole positions, rails along both side kerbs; screws optional |
| cable | two posts to zip-tie the bundle down, clear of the seat's bosses |

The display goes in from the **front** and its own lip lands on the case — not
fed in from behind and trapped under a lip on the case, which is what the model
did first. The upstream mount settles it: 39.09 x 31.09 straight through, then
out to 41.33 x 33.33 for the last **0.80 mm** before the rim. So the case never
sits over the glass, and how close the picture runs to the module's edge stops
mattering.

The seat is 7.25 mm wide because that is what it takes to carry the module's
own mounting bosses. At the 2.50 it started at, all four holes fell inside the
connector window with nothing under them — a case the display could not be
screwed to, invisible in every render.

The hat slides in from the back under **rails along the top of both side
kerbs**, and lands on pads at its own hole positions. The kerbs already stood
0.9 mm proud of the board, so the rails cost 1.2 mm of height and 99 mm3.

Rails, not hooks, and the difference is the direction of travel. An earlier
version reached back over the hat's front corners, which meant the board had to
slide *into* them -- and everything ahead of it blocked that: first a front
kerb 0.9 taller than the board, then a shelf under its bare strip that let it
move 0.3 mm before fouling. A rail runs along the way the hat is going.

The two screw pads stay and the screws still work -- with the seat cut back to
a rim, a driver comes straight down through the display opening onto them, so
long as the hat goes in before the display. They are belt and braces now
rather than the retention.

**The XIAO and its USB-C hang underneath**, propping the board 4.30 mm above the
bottom of the stack. Missed on the first test print, where the pads had been
drawn up to the stack's underside with no board there to meet them.

The alternative, if a bolted hat is ever wanted, is to move the pads onto a
tongue on the rear cap: the hat then bolts to the cap on the bench and the pair
slide in together. One more feature, no more parts.

> Anything added inside the shell has to be unioned **after** `hollow()` is
> subtracted, or the cavity swallows it — built the wrong way round, the seat
> bosses, the tray and the cap posts all vanished and the shell came back at
> exactly the volume it had without them. Then they have to touch something: a
> post floating at screw height and a tray sitting flush on the floor both came
> out as separate shells until given a foot and a 0.2 mm overlap.

## Printing

**Shell desk-down as modelled, cap flat.** Measured with `tools/overhang.py`,
and it contradicts the obvious guess — that the sloping interior roof made
desk-down the bad orientation:

| shell orientation | support | bed contact | height |
|---|---|---|---|
| **desk-down (0)** | **579 mm2** | **1842 mm2** | 38.7 |
| front face down (110) | 988 mm2 | 361 mm2 | 42.6 |
| back face down (-90) | 989 mm2 | 202 mm2 | 45.4 |

Least support *and* five times the bed contact. All of its support is interior
roof that nobody sees. The cap laid flat needs none.

The tool ignores shallow faces within 1 mm of the bed, which matters: without
that the 0.80 mm counterbore ledge scores 153 mm2 against an orientation where
it is really just the second layer.

## Still to do

**Nothing has been printed yet.** Every figure here is measured off geometry,
not off a part. That is the only open item.

`PLUG_H` is the one estimated number in the model — 4 mm, inferred from the
hat's 9.82 stack rather than measured — and it is provably not binding. The
plug-room check has 20.27 mm against a requirement that is the greater of 15
and `CONN_H + PLUG_H`, so it does not fail until `PLUG_H` exceeds **18.85**.
The entire hat stack is 9.82 tall. Measuring it would change nothing.

## Layouts that were considered and dropped

| | screen | depth | height | why not |
|---|---|---|---|---|
| slab, boards back to back | 55 | 41.6+ | 36.5+ | `GAP` must be 15 for the bundle, which puts it past 45 deep; stands on 13.7 mm of base |
| tail out the back | ~90 | 42 | 34 | needs a near-vertical screen |
| hat under the display | 75 | 30.0 | 52.8 | 52.71 cm3 — same volume, trades 19 mm of depth for 16 of height |
| hat turned, USB out the side | 70 | ~42 | 38.7 | 5 mm shallower, but the USB-C leaves sideways |

`scad/prospector_slab.scad` still builds the slab if it is ever wanted.
`DISP_LIFT = 18, DEPTH = 30, TILT = 75` builds the hat-under variant;
`-D MCU_DY=MCU_D -D MCU_DX=MCU_W` turns the hat.
