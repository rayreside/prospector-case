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
| [Urchin](https://github.com/duckyb/urchin) 36-key split keyboard | duckyb | MIT | the keyboard these cases are for. The case outlines and hardware positions follow it |
| [Prospector](https://github.com/carrefinho/prospector) ZMK dongle | carrefinho | CERN-OHL-P-2.0 | the dongle case in `scad/prospector.scad` is dimensioned from measurements taken off its published STLs. Provenance for every number is in [prospector/REFERENCE.md](prospector/REFERENCE.md) |

The *Urchin Plate Case* the keyboard cases derive from is the author's own
earlier design, so it carries no separate terms.

Both upstream licences are permissive — MIT and the permissive variant of the
CERN Open Hardware Licence. Neither is reciprocal, so neither reaches into this
repository's licensing.

## Not in this repository

A stand for the Prospector dongle lives outside version control, in a
gitignored `personal/` folder. Its proportions were measured from a third-party
model published under CC BY-NC-SA, and while measured ratios are not the
copyrightable part of a design, Non-Commercial and Share-Alike are terms that
cannot quietly coexist with MIT if that judgement were ever wrong. It is kept
out rather than reasoned about.
