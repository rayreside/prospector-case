# Prospector Case

A compact 3D-printed case for the
[Prospector](https://github.com/carrefinho/prospector) ZMK dongle — a Seeed
XIAO and a round display, in a shell small enough to sit beside a keyboard
rather than in front of it.

Every dimension is measured off carrefinho's published STLs and off the built
shell; no upstream geometry is copied. The measurements and the reasoning
behind each one are in [prospector/REFERENCE.md](prospector/REFERENCE.md), and
the design itself is documented in [prospector/README.md](prospector/README.md).

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
the shell exports with both of them inside it, three shells and 27.13 cm3
against one and 9.56. The cap never draws them, so its line needs nothing.
Either way `tools/stlstat.py` says at once which one you have.

You do not have to build it to print it. [`release/`](release/) holds the two
STLs, checked in and refreshed with the geometry, so a `git pull` puts the
printable parts on disk -- with the figures to check them against and the
orientations to print them in.

## The dress-up variant

An alternative version of the same case, with a pad and socket on the crown for
plug-in hats and a socket in each side wall for plug-in arms. It is a flag, not
a fork — off by default, and the default build is unchanged:

```bash
openscad -D 'part="shell"' -D 'show_parts=false' -D 'DRESS=true' -o build/prospector_shell_dress.stl scad/prospector.scad
```

The rear cap is unaffected; print the ordinary one. The accessories are
separate:

```bash
openscad -D 'part="hat"'    -o build/prospector_hat.stl    scad/prospector_dress.scad
openscad -D 'part="arm"'    -o build/prospector_arm.stl    scad/prospector_dress.scad
openscad -D 'part="coupon"' -o build/prospector_coupon.stl scad/prospector_dress.scad
```

Print two arms, mirrored. Print the coupon first — it is what tells you the
peg clearance your printer actually gives. The socket and the peg share
[`scad/prospector_plug.scad`](scad/prospector_plug.scad) so they cannot drift
apart, and the reasoning is in
[prospector/README.md](prospector/README.md#the-dress-up-variant).

## Checking it

`tools/` holds the verification scripts — cross-section diffs, thin-feature
detection, wall thickness, overhang and free-space analysis. They are described
in [tools/README.md](tools/README.md).

The habit they exist to support: a volume figure will tell you a part is 0.1%
off and never tell you which face moved. Measure where, not how much.

## Licence

MIT — see [LICENSE](LICENSE). Upstream credit and the reasoning about what is
deliberately *not* here are in [NOTICE.md](NOTICE.md).

---

Split out of the Urchin case repository, which is where this work started; the
history came with it.
