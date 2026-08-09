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
openscad -D 'part="shell"' -o build/prospector_shell.stl scad/prospector.scad
openscad -D 'part="cap"'   -o build/prospector_cap.stl   scad/prospector.scad
```

`part` also takes `all`, which is the assembled view rather than something to
print.

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
