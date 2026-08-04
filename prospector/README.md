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
| Envelope | 43.2 x 51.4 x 38.0 | **42.8 x 43.0 x 36.4** |
| Enclosed | 59.86 cm3 | **43.92 cm3** |
| Plastic | 15.92 cm3 | **11.95 cm3** |
| Parts | 3 | 3 |

Same width, 16% shallower, 1 mm shorter, 27% less enclosed volume, 25% less
filament, and the screen keeps the upstream 55 degrees. All three parts
watertight, one shell each, zero boundary and non-manifold edges.

Three parts again, after a spell at two. The back was one bent panel, and the
two halves of that bend want opposite print orientations — so whichever you
favour, the other face lands on the build plate, and the face that lost was the
roof, the one on show. Split at the bend, each half prints the way it wants and
the joint costs no extra fastener.

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

## The clearances

The size is set by the hat and the cable, not by walls or the display. Every
gate is computed and echoed on every build, because not one of them is visible
in a render:

```
ECHO: "hat clears the ceiling by 3.69987 mm  (want 2.5)"
ECHO: "plug room at the socket 8.78817 mm  (want 5.43)"
ECHO: "headroom over the hat 21.3755 mm  (want 20)"
ECHO: "tray kerbs from y 25.2476 to 41.4  (hat front 13.8)"
ECHO: "driver at the top screws 5.60833 mm across  (want 5)"
```

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
| back plate | 2 x M2 into posts at x = +/-16 |
| roof tile | lands on the shell's ledge at the front; its rear tongue is trapped in the back plate's groove. No fastener of its own |
| hat | two M2 into pads at its own hole positions |
| cable | two posts to zip-tie the bundle down, clear of the seat's bosses |

The display goes in from the **front** and its own lip lands on the case — not
fed in from behind and trapped under a lip on the case, which is what the model
did first. The upstream mount settles it: 39.09 x 31.09 straight through, then
out to 41.33 x 33.33 for the last **0.80 mm** before the rim. So the case never
sits over the glass, and how close the picture runs to the module's edge stops
mattering.

The seat is a 1.6 rim with an 8 mm pad at each screw, and nothing in between.
It was a 7.25 ledge until it became clear it was holding nothing: the module
front-loads and its lip lands on the face, so nothing can fall inward. All the
ring ever carried was the four screws. Before that it was 2.50, and all four
holes fell inside the connector window with no material under them — a case the
display could not be screwed to, invisible in every render.

**The roof has to lift off, and it is not fixed to the back.** The display's
upper screws run along the screen normal, and with the roof fixed to the shell
the driver's line is blocked by the roof's rear edge. With it off, the fattest
shaft that reaches those screws is **5.61 mm** — echoed on every build, because
it is the one clearance that moves when the joint moves. The alternative was
access holes through a face that is on show.

For a while the roof lifted off *with* the back, as one bent panel. That reads
well and prints badly: the vertical back wants to stand on its bottom edge, the
roof wants to lie flat, and bent together one of them always loses. The one
that lost was the roof, face-down on the build plate.

Split at the bend, with **no third screw**:

| | |
|---|---|
| front | the shell keeps the inner half of the chamfer for 2 mm past the seam; the tile's front tongue is the outer half, lying on that ledge |
| rear | the back plate keeps the outer half as a lip and carries a rib under it, so the tile's rear tongue runs into a groove |

A tongue captured above and below cannot rotate, and with the rear unable to
rotate the front cannot lift — which is what lets the front be a plain ledge.
To get the tile out you would have to slide it 1.7 mm forward to clear the
groove, and the shell's shoulder stops it at 0.15. So it is captive, and the
only way to release it is to take the back plate off. That is a better answer
than a snap: nothing has to flex, and nothing fatigues.

Assembly gains one step: display screwed, **tile laid in**, back plate slid on
over its rear tongue, two screws.

`SPLIT_Y` is the tip of the shell's **ledge**, not the seam — the seam sits
`JOINT` forward of it at `SEAM_Y`. The two were the same thing while the joint
was a butt. They must not be now: the ledge reaches further back than the seam,
the chamfer falls as it goes back, and a joint measured from the seam quietly
takes 0.6 mm off the driver clearance. Anchored on the tip, every clearance is
exactly what it was before the joint existed.

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

**Shell desk-down as modelled. Roof lying on its inner face, outer face up.
Back plate lying flat.** Measured with `tools/overhang.py`, not reasoned about
— for the shell it contradicts the obvious guess, that the sloping interior
roof made desk-down the bad orientation:

| | support | bed contact | height |
|---|---|---|---|
| **shell, desk-down** | **434 mm2** | **1446 mm2** | 36.4 |
| shell, front face down | 611 mm2 | 240 mm2 | 37.2 |
| shell, back face down | 738 mm2 | 121 mm2 | 41.4 |
| **roof, outer face up** (rot 46.5) | **0 mm2** | 467 mm2 | 1.60 |
| roof, outer face down | 9 mm2 | 548 mm2 | 1.60 |
| **back, laid flat** (rot -90) | 397 mm2 | **385 mm2** | 5.0 |
| back, standing | 21 mm2 | **0 mm2** | 19.2 |

All the shell's support is interior roof that nobody sees.

**The roof comes out 1.60 mm tall at rot 46.5, which is the whole point** —
both its faces are the chamfer plane and its offset, so it is a flat plate of
constant thickness and it lies down with the face that shows on top. No
support, no plate texture where it matters. `ROOF_Y` is forward of where
`BACK_R` starts rounding either face (42.11 outside, 40.51 in), which is what
keeps it planar.

The back plate has **no flat foot** — its bottom edge is inside the case's
bottom-back fillet, so standing it up is a line contact and the tool reports
0 mm2 on the bed. Laid flat it is a plain panel: 385 mm2 down, and the 397 mm2
of "support" is the fork at the top standing at 43.5 degrees, a degree and a
half the wrong side of the threshold and fine in practice. The cost is that the
build plate's texture lands on the back face. That is the face meant to carry
graphics, so it is a choice rather than a defect — flip to a smooth sheet if it
should be glossy.

The tool ignores shallow faces within 1 mm of the bed, which matters: without
that the 0.80 mm counterbore ledge scored 153 mm2 against an orientation where
it was really just the second layer.

## Still to do

- **The back plate's bottom-back fillet reaches 0.12 mm from the hat.** The
  `BACK_R` rounding where the back plate meets the desk curves forward of
  y = 41.4 by 0.18, and the hat's rear edge is at 41.1. Positive, and it is
  pre-existing geometry rather than anything the split introduced, but it is
  the tightest unintended clearance in the case and nothing checks it.
- **Three self-intersecting triangle pairs and twelve degenerate faces** remain
  in the shell, out of 3394. Down from 219, which is what the slicer was
  visibly choking on. Slicers deal with what is left routinely.
- **`PLUG_H` is the one estimated number** — 4 mm, inferred from the hat's 9.82
  stack rather than measured. The plug-room check has 8.79 against a need of
  5.43, so it does not fail until `PLUG_H` exceeds 7.36.
- **The socket's position across the module is still unknown**, only that it is
  on the left. `CONN_SLOT_*` is a generous relief rather than a fitted pocket.
- **No full assembly has been printed.** The shell has been through several
  test prints; neither the roof nor the back plate has. The joint's clearances
  are 0.15 throughout, checked by intersecting the parts pairwise rather than
  by fitting them — that check finds overlap, and found 7.7 mm3 of it once, but
  it cannot tell you whether 0.15 is enough on your printer.

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
