# Prospector Case

A compact 3D-printed case for the
[Prospector](https://github.com/carrefinho/prospector) ZMK dongle — a Seeed
XIAO and a round display, in a shell small enough to sit beside a keyboard
rather than in front of it.

42.8 × 43.0 × 35.4 mm assembled, two printed parts, 11.5 cm3 of plastic.

> ### ⚠ This is for the **beekeeb** Prospector
>
> It is cut around [beekeeb's Prospector kit](https://shop.beekeeb.com/products/zmk-wireless-dongle-prospector-diy-kit),
> and every dimension in it was measured off that build. Two things about it
> drive the whole design:
>
> - **beekeeb's adapter PCB** — the "hat" — sits on the XIAO and carries a
>   socket for the display's cable, so the link is a plugged cable at both ends
>   rather than eight wires soldered to the XIAO's pads. **That board is what
>   the case is shaped around.** It is what sets the depth, and every clearance
>   in the model is measured against it.
> - **No ambient light sensor.** There is no room for the sensor board and no
>   window for it.
>
> **On the original Prospector: this may or may not fit, and expect to modify
> it.** The upstream build solders the display straight to the XIAO's pads, so
> the stack is a different shape and sits at a different height — the hat is the
> single biggest thing this case is built around, and without it the interior is
> wrong. The numbers are all in the open and parametric, so adapting it is
> realistic work rather than a rewrite, but it is work. Start from
> [What it expects](#what-it-expects) and measure your own build first.

Every dimension is measured off carrefinho's published STLs and off the built
shell; no upstream geometry is copied. The measurements and the reasoning
behind each one are in [prospector/REFERENCE.md](prospector/REFERENCE.md), and
the design itself is documented in [prospector/README.md](prospector/README.md).

## What it expects

| | |
|---|---|
| Display | Waveshare 1.69" Touch LCD, 240 × 280, part **27057** — 41.13 × 33.13 mm, four M2 holes on a 29.93 × 22.57 pattern |
| MCU | Seeed **XIAO nRF52840**, soldered flat to the hat |
| The hat | beekeeb's adapter PCB, carrying a socket for the display's cable. The case has room for a stack **21.9 × 27.0 × 9.82 mm**, with the XIAO and its USB-C hanging *underneath* — the hat's own board sits 4.30 mm above the bottom of that stack, and its USB-C leaves along the 27 mm axis, flush with one end |
| Hat mounting | two M2 into printed pads, 17.10 mm apart, 2.65 mm in from the board's edge |
| Fasteners | **8 × M2** — four for the display into its own standoffs, two M2 × 6 for the rear cap, two for the hat |
| Cable | about 20 mm of clear run above the hat for the bundle to turn upward, which the model checks and echoes |

Those are the dimensions the case is cut to, taken off a beekeeb build.
Anything that fits inside them and puts its USB-C in the same place will go in.
**Measure yours before printing** — the three clearances that matter are echoed
on every build, so a changed number tells you at once whether it still fits.

## Printing

The STLs in [`release/`](release/) are ready to print and are what came off the
bed here — see [release/README.md](release/README.md) for figures to check them
against.

- **Shell** desk-down as modelled, with support. All of it is interior roof
  nobody sees.
- **Cap** standing on its bottom edge, with a brim.
- **0.20 mm layers**, whatever the printer: the joint steps are 0.80 and the cap
  is 1.60, and both divide exactly.
- Set the slicer's support threshold **below 44.81°**. The chamfered roof sits
  at exactly that, two tenths under the usual 45, and above the line it counts
  as an overhang when it is not one.

Assemble **hat first, display second, cap last** — the hat's screws are driven
straight down through the display opening, so the display has to go in after it.

## Building

```bash
openscad -D 'part="shell"' -D 'show_parts=false' \
         -o build/prospector_shell.stl scad/prospector.scad
openscad -D 'part="cap"' -o build/prospector_cap.stl scad/prospector.scad
```

`part` also takes `all`, which is the assembled view rather than something to
print.

`show_parts` ghosts the display and the XIAO in place. That is what you want on
screen and not what you want in an STL: left on -- and it is on by default --
the shell exports with both of them inside it, three shells and 27.20 cm3
against one and 9.62. The cap never draws them, so its line needs nothing.
Either way `tools/stlstat.py` says at once which one you have.

You do not have to build it to print it. [`release/`](release/) holds the two
STLs, checked in and refreshed with the geometry, so a `git pull` puts the
printable parts on disk -- with the figures to check them against and the
orientations to print them in.

## Checking it

`tools/` holds the verification scripts — cross-section diffs, thin-feature
detection, wall thickness, overhang and free-space analysis. They are described
in [tools/README.md](tools/README.md).

The habit they exist to support: a volume figure will tell you a part is 0.1%
off and never tell you which face moved. Measure where, not how much.

## Credits

- **[Prospector](https://github.com/carrefinho/prospector)** by **carrefinho** —
  the dongle this is a case for, and the design every dimension here was
  measured against. Licensed CERN-OHL-P-2.0.
- **[beekeeb](https://shop.beekeeb.com/products/zmk-wireless-dongle-prospector-diy-kit)**
  — the kit this case is actually cut around. Their adapter PCB is what makes
  the display a plugged cable at both ends, and it is the single component that
  determines this case's proportions. Their
  [build log](https://docs.beekeeb.com/build-guide/prospector-zmk-dongle-photo-build-log)
  is the reference for how the stack goes together.
- **[ZMK](https://zmk.dev)** — the firmware the dongle runs.
- **Waveshare** — the 1.69" Touch LCD Module (27057) the case is cut around.
- **Seeed Studio** — the XIAO nRF52840.

Named because the work stands on theirs, not because any of it is vendored:
no third-party file is checked in here, and no upstream geometry is copied.
[NOTICE.md](NOTICE.md) sets out that relationship, the licence each upstream
carries, and the reasoning about what is deliberately *not* in this repository.

## Licence

MIT — see [LICENSE](LICENSE). That covers the OpenSCAD sources, the Python
tools, the documentation and the STLs built from them.

**No warranty, and one caveat worth stating plainly:** this is a case measured
off someone else's hardware and printed on one printer. It fits a beekeeb
Prospector without the ambient light sensor. If yours differs — and an original
Prospector does differ — the numbers are all in the open. Change them and
rebuild rather than trusting these.

---

Split out of the Urchin case repository, which is where this work started; the
history came with it.
