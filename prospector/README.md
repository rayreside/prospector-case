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
| Envelope | 43.2 x 51.4 x 38.0 | **42.8 x 43.0 x 35.4** |
| Enclosed | 59.86 cm3 | **42.59 cm3** |
| Plastic | 15.92 cm3 | **11.44 cm3** |
| Parts | 3 | 2 |

Same width, 16% shallower, 2.6 mm shorter, 29% less enclosed volume, 28% less
filament, and the screen keeps the upstream 55 degrees. Both parts watertight,
one shell each, zero boundary edges.

The width is the module's pocket plus a 1.7 bezel and cannot go below that.
Everything else saved is depth, and it comes from folding the boards together
instead of putting them at opposite corners of an empty box.

**The display face is flat.** `LIP_BORE` would recess the module's lip so it
finished flush, as upstream does, but that leaves a ring only 0.85 wide by
0.80 deep standing around it -- two extrusion widths and four layers, and it
does not print. Off, the face is one plane with the pocket's opening in it: the
lip lands on that face and stands 0.80 proud, and the material around the
opening is the full 1.7 bezel rather than a fragile ledge. 0.73 mm of case
shows around the lip, against upstream's 0.835.

**And that frame is a constant width, which it was not.** The section's corner
radius was 7.00 -- carried over as the upstream look -- while the pocket's is
3.20. Two roundings on the same face, not concentric, so the frame narrowed
towards the diagonal: 1.70 at the sides, **0.83** at the corner, and 0.829
measured off the mesh. The lip is wider than the pocket and lands on that same
face, so at the corner it **overhung the case by 0.13 mm** with nothing under
it. That is what the printed part shows and no render did -- a case corner
visibly rounder than the display's, with the black lip standing proud of the
plastic along it.

Upstream can afford a 7.00 body corner because its display sits in a separate
plate, `disp_mount`; here the outside of the case and the frame round the
display are one face, and the radius is not free. It is `DISP_R + DISP_CLR +
BEZEL` = **4.90** now, which puts both arcs on the same centres: 1.700 of frame
everywhere, 0.735 of case showing round the lip everywhere, both echoed on
every build. The envelope does not move; the four corners gain 0.115 cm3 of
plastic. Keeping 7.00 *and* making it concentric was the other way out, and it
costs a 3.80 bezel -- a 47.0 x 39.0 front face, 4.2 mm on the one dimension
this design cannot give away.

## The clearances

The size is set by the hat and the cable, not by walls or the display. Every
gate is computed and echoed on every build, because not one of them is visible
in a render:

```
ECHO: "frame round the pocket 1.7 mm at its thinnest  (want 1.7, its width on the flats)"
ECHO: "case showing round the lip 0.735 mm at its thinnest  (want 0.735, ditto)"
ECHO: "hat clears the ceiling by 2.69987 mm  (want 2.5)"
ECHO: "plug room at the socket 7.04472 mm  (want 5.43)"
ECHO: "headroom over the hat 20.3755 mm  (want 20)"
ECHO: "tray kerbs from y 23.8195 to 41.4  (hat front 13.8)"
ECHO: "driver at the top screws 6.07027 mm across  (want 5)"
```

The first two are not clearances at all -- they are the front face, taken at
the corner rather than on the flats, because that is where the section's
rounding and the module's meet and where a mismatch between them shows first.

The 20 is measured off the real bundle, from the hat's board. The plug-room ray
carries only the plug's own reach; it used to carry the bundle's 15 mm as well,
which was double counting -- the bundle is checked by the headroom test, in the
direction it actually travels. SLACK is 2.5 because it binds at the hat's bare
front corner, where nothing but air passes.

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

That sweep was taken at `DISP_LIFT = 4`; the case is now built at 3, one
millimetre lower and shorter throughout.

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
| display | drops in from the front, lip lands on the flat face, 4 x M2 from inside into its own standoffs |
| rear cap | 2 x M2 into posts at x = +/-16; carries the chamfered roof too |
| hat | two M2 into pads at its own hole positions |
| cable | two posts to zip-tie the bundle down, clear of the seat's bosses |

The display goes in from the **front** and its own lip lands on the case — not
fed in from behind and trapped under a lip on the case, which is what the model
did first. The upstream mount settles it: 39.09 x 31.09 straight through, then
out to 41.33 x 33.33 for the last **0.80 mm** before the rim. So the case never
sits over the glass, and how close the picture runs to the module's edge stops
mattering.

**The shell's own roof needed its thickness stated.** Between the display and
the cap the outer face is the chamfer, and for a long time the inner face was
just wherever the cavity prism's top face happened to fall. Those two planes
converge and cross at y = 30.2, so the roof ran out as a wedge — 0.59 mm thick
at y = 29, 0.27 at 29.9, nothing at the seam. On the printed part the feather
edge tore off and left an open slot along the top of the cap, which is what it
looked like: a gap where the cap meets the case. The cavity is now bounded by
the cap's own inner face forward of `SPLIT_Y`, so the shell's roof is the same
1.6 plate the cap is and the two butt flush. Behind the split that bound does
nothing, which leaves the deliberate overrun as the only thing describing that
surface — the arrangement that got the self-intersections down from 219.

The seat is a 1.6 rim with an 8 mm pad at each screw, and nothing in between.
It was a 7.25 ledge until it became clear it was holding nothing: the module
front-loads and its lip lands on the face, so nothing can fall inward. All the
ring ever carried was the four screws. Before that it was 2.50, and all four
holes fell inside the connector window with no material under them — a case the
display could not be screwed to, invisible in every render.

The cap is a **bent panel**: the vertical back and the chamfered roof in one
piece. It has to be. The display's upper screws run along the screen normal,
and with the roof fixed to the shell the driver's line is blocked by the roof's
rear edge; taking the roof off with the cap clears it, and the fattest shaft
that then reaches them is **5.61 mm**, echoed on every build. The alternative
was access holes through a visible face. It is also much the larger surface, if
it is going to carry anything printed on it.

> The cap was split into a roof tile and a back plate for three commits, so
> each half could print the way it wants — the tile flat with its show face up,
> the back plate on its bottom edge — held by a ledge at the front and a groove
> at the rear, with no third screw. The mechanism was sound and it is in the
> history at `bee6b9a`. What sank it is that a 1.6 mm plate has to be split
> three ways to make that joint: lip 0.80, groove 0.80, tongue 0.65, with a rib
> hanging below. No margin anywhere, and the rib was rooted in **0.15 mm** of
> neck until a side elevation caught it — every mesh check passed, because
> 0.15 mm of neck is still one shell.
>
> The bent panel's only cost is that the roof's outer face prints against the
> build plate. The split's cost was every feature in it having none to give.

### The seam

The cap does not merely meet the shell at y = 30, it laps under it. The shell
keeps the outer 0.80 of the chamfer for 2 mm past `SPLIT_Y`; the cap's roof tip
is the inner 0.80 and stops 0.30 short. Sectioned at y = 31 the shell holds
24.713..25.840 and the cap 23.585..24.713 — meeting on a plane, so the shell
also holds the roof down rather than only abutting it.

It is a lap because the butt did not work, for a reason that showed up only on
the part. Two faces in different planes — the back at y = 41.4 and the roof tip
at y = 30 — were both required to close in the same instant, on two separately
printed parts. Whichever lands first wins, and it was the tip: the back plate
could not close, the screws kept pulling, and the roof bent backwards. The
clearance now goes in y, where the lap hides all but a 0.3 line.

**The lesson, which cost a print.** A zero-volume intersection between two parts
says they do not overlap. It does not say they can be assembled. A face square
to the direction of travel must not touch before the seating face does, and no
static check in this repo can see the difference.

### The rear screws

The pilot has been wrong in both directions, which is worth recording because
neither number was arbitrary and both were still wrong:

| | | |
|---|---|---|
| 2.10 | screws spun straight through | sized for the M2.5 in upstream's BOM, above an M2's own major diameter |
| 1.60 | driver cammed out; head crushed into the plate | 0.8 x major, the textbook thread-forming pilot |
| **1.70** | | the pilot the **hat** screws use — same screw, same plastic, and the only one here that has been driven without complaint |

Both now come off `M2_PILOT`, so they cannot drift apart again.

The "head sinks in" half of that was the same fault seen from the other end,
not a second one: 4.4 mm of thread to form at once takes more torque than an
M2 head will take, and once the driver slips the head crushes 1.6 mm of plate.
Peak torque is the pilot times how much thread is being formed at once, and the
second term was free — `CAP_FREE` bores the post's mouth to clearance for
1 mm first, so an M2 x 6 forms **3.4 mm** of thread rather than 4.4, and finds
the hole square before it starts biting. The bore's lip is broken by 0.30 so
the head beds on flat material.

`CAP_HEAD` is `"pan"`. If the screws turn out to be **countersunk**, set it to
`"flat"` and the chamfer becomes a real 90-degree seat to `CAP_HEAD_D` instead
of an edge break — with a conical head in a straight 2.2 hole the head wedges
and buries itself no matter what the pilot does.

The hat drops onto pads at its own hole positions and takes two M2. With the
seat cut back to a rim a driver comes straight down through the display
opening, so the order is hat first, display second.

`MCU_HOOKS` adds rails along the top of both side kerbs, which capture the hat
without screws -- the kerbs already stand 0.9 mm proud of the board, so it
costs 1.2 mm of height and 99 mm3. Off, because the screws already do the job
and the rails' undersides are 107 mm2 of horizontal ledge to support. Worth
remembering that rails work where hooks did not: an earlier version reached
back over the hat's front corners, so the board had to slide *into* them, and
everything ahead of it blocked that in turn.

**The kerbs themselves stop at y = 25.2, not at the hat's front edge.** The
display's two lower access bores come down through exactly that space -- they
leave the bosses at 55 degrees and reach the desk around y = 22 -- and the
tray's outer corners sit on their line. Run the full length, the bores notch
each kerb over 8 mm of a 1.5 mm wall, which is what it looks like on the part.
`KERB_Y` is derived from the bore rather than typed in, and it is deliberately
about 2 mm conservative: it asks the whole 5 mm bore to be clear, not just the
0.29 mm sliver that actually overlaps, so it does not quietly go wrong if the
kerb moves. 16.2 mm of kerb is left, against the two screws at the front and
the cap behind. What the bores still graze is the 0.6 mm standoff pad, out
where it overhangs the board -- and they pass through the floor there anyway.

**The XIAO and its USB-C hang underneath**, propping the board 4.30 mm above the
bottom of the stack. Missed on the first test print, where the pads had been
drawn up to the stack's underside with no board there to meet them.

The alternative, if a bolted hat is ever wanted, is to move the pads onto a
tongue on the rear cap: the hat then bolts to the cap on the bench and the pair
slide in together. One more feature, no more parts.

> A feature that adds no material can still break the mesh. With `BOSS_H = 0`
> the seat's boss cylinders sat entirely inside the plate that already existed
> — zero volume — but their front faces landed exactly on the seat's front
> plane, and that coplanar contact was the shell's one non-manifold edge. The
> fix was not to draw them. Found by elimination: `outer()` and
> `outer() - hollow()` were both clean, so it had to be something unioned on
> afterwards, and the edge sat exactly on `w = 0`.
>
> Anything added inside the shell has to be unioned **after** `hollow()` is
> subtracted, or the cavity swallows it — built the wrong way round, the seat
> bosses, the tray and the cap posts all vanished and the shell came back at
> exactly the volume it had without them. Then they have to touch something: a
> post floating at screw height and a tray sitting flush on the floor both came
> out as separate shells until given a foot and a 0.2 mm overlap.

## Printing

**Shell desk-down as modelled; cap standing on its bottom edge, with a brim.**
Measured with `tools/overhang.py`, and it contradicts the obvious guess — that
the sloping interior roof made desk-down the bad orientation:

| | support | bed contact | height |
|---|---|---|---|
| **shell, desk-down** | 555 mm2 | **1446 mm2** | 35.4 |
| shell, front face down | 538 mm2 | 240 mm2 | 36.7 |
| shell, back face down | 504 mm2 | 117 mm2 | 41.4 |
| **cap, as modelled** | 638 mm2 | 69 mm2 | 26.8 |
| cap, laid flat | 0 mm2 | 378 mm2 | 13.0 |

**Read that table with the threshold in mind.** At `DISP_LIFT = 3` the chamfer
sits at **44.81 degrees** from horizontal, two tenths of a degree under the
45 the tool defaults to, and the whole 638 mm2 on the cap is that one surface
crossing the line. At `--thresh 44` the same orientation scores 20 mm2. Nothing
about the part got harder to print between 46.5 degrees and 44.8; set the
slicer's threshold to 40 and the cap still prints standing, as it did before.

All the shell's support is interior roof that nobody sees. The cap needs almost
none standing up, but 69 mm2 of contact under a 27.6 mm part wants a brim.

The tool ignores shallow faces within 1 mm of the bed, which matters: without
that the 0.80 mm counterbore ledge scored 153 mm2 against an orientation where
it was really just the second layer. **It also hides things.** On the split
roof tile it reported a clean 0 mm2 while a 2.9 mm ledge floated 0.80 above the
bed -- inside the exemption, and a mating face. Pass `--above 0` before trusting
a zero, and read the heights rather than the total.

Settings the geometry dictates, whatever the printer: **0.20 layer height**,
because the joint steps are 0.80 and the cap is 1.60 and both divide exactly;
thin-wall detection on; and support for the shell only. The cap standing up
needs almost none, and support anywhere near the display seat has to come back
out through the pocket.

## Still to do

- ~~Shell and cap meet at exactly 0.00~~ — **this was the wrong conclusion, and
  the printed part proved it.** Intersecting the two solids gives zero volume,
  and I read that as a butt joint located by two screws, which is what it should
  be. Right about the y = 41.4 plane, blind to the other one: the cap's roof tip
  met the shell's roof edge at y = 30, also at exactly 0.00, and that face is
  square to the direction the cap travels to seat. On the part the tip landed
  first, the screws kept pulling, and the roof bent backwards — opening the very
  gap the joint was meant to close. The seam is a lap now; see below.
- **The cap's bottom-back fillet reaches 0.12 mm from the hat.** The `BACK_R`
  rounding where the cap meets the desk curves forward of y = 41.4 by 0.18, and
  the hat's rear edge is at 41.1. Positive, but it is the tightest unintended
  clearance in the case and nothing checks it.
- **Three self-intersecting triangle pairs and twelve degenerate faces** remain
  in the shell, out of 3394. Down from 219, which is what the slicer was
  visibly choking on. Slicers deal with what is left routinely.
- **`PLUG_H` is the one estimated number** — 4 mm, inferred from the hat's 9.82
  stack rather than measured. The plug-room check has 8.79 against a need of
  5.43, so it does not fail until `PLUG_H` exceeds 7.36.
- **The socket's position across the module is still unknown**, only that it is
  on the left. `CONN_SLOT_*` is a generous relief rather than a fitted pocket.
- **No full assembly has been printed.** The shell has been through several
  test prints; the cap has not. The rear screws have, and drove badly enough to
  change the pilot twice — see above.

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
