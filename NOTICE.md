# Notice

Everything in this repository is MIT — see [LICENSE](LICENSE). That covers the
OpenSCAD sources, the Python tools, the documentation, and the STLs built from
them, all of which are original work by Ray Reside.

**No third-party files are vendored here.** Every part is generated from source
in this repository. Where an upstream design is involved it was *measured* and
the measurements recorded in Markdown; none of its geometry was copied. That is
why the list below is credit rather than a set of licence obligations.

## Upstream designs this work relates to

| | by | licence | relationship |
|---|---|---|---|
| [Prospector](https://github.com/carrefinho/prospector) ZMK dongle | carrefinho | CERN-OHL-P-2.0 | the dongle case in `scad/prospector.scad` is dimensioned from measurements taken off its published STLs. Provenance for every number is in [prospector/REFERENCE.md](prospector/REFERENCE.md) |
| [Prospector DIY kit](https://shop.beekeeb.com/products/zmk-wireless-dongle-prospector-diy-kit) | beekeeb | — | the **physical build** this case is cut around. Its adapter PCB — the "hat" that turns the display link into a plugged cable at both ends — is what sets this case's proportions. Measured, not copied; no file of theirs is here |

That first licence is the permissive variant of the CERN Open Hardware Licence.
It is not reciprocal, so it does not reach into this repository's licensing.

beekeeb's kit is credited because the case would not have this shape without
it, and because a reader needs to know which build it fits. Nothing of theirs
is reproduced here either — the hat appears in this repository only as an
envelope in millimetres, arrived at with calipers.

## Not in this repository

A stand for the Prospector dongle, and an adapter letting a display kit carry
the dongle, were both explored and are **not part of this project**. Their
proportions were taken from a third-party model by **Tortel3D**, published
under CC BY-NC-SA.

Measured ratios are not the copyrightable part of a design, but Non-Commercial
and Share-Alike are terms that cannot quietly coexist with MIT if that
judgement were ever wrong. So the work was kept out of version control while it
existed, and has since been removed outright — the files, the built STLs, and
the `personal/` folder that held them.

The credit above is for that exploratory work. Nothing in this repository
derives from that model.
