# Printable exports

The two STLs beside this file are what comes off `scad/prospector.scad`. They
are checked in so that a `git pull` puts the printable parts on disk -- the
repository is the sync channel, and not everyone who wants to print this has
OpenSCAD installed.

Built with OpenSCAD 2021.01, from the commits that unioned the seam lip into
the shell and tightened the shoulder behind it. Before them the lap over the
rear cap was a feather edge, with an open slot about 1.5 mm wide behind it and
a 0.42 mm groove behind that; what is left is a 0.21 mm line.

| | shell | cap |
|---|---|---|
| triangles | 3550 | 864 |
| bounding box | 42.800 x 41.400 x 35.368 | 42.800 x 12.700 x 25.408 |
| volume | 9.6219 cm3 | 1.8788 cm3 |
| shells | 1 | 1 |
| non-2-manifold edges | 0 | 0 |
| boundary edges | 0 | 0 |

`python tools/stlstat.py release/prospector_shell.stl` reproduces that column,
which is the check that you have the file you think you have. The shell at
27.1 cm3 and three shells is the one with the ghosted display and XIAO
exported inside it -- see below.

## Printing

**Shell desk-down as modelled.** 555 mm2 of support and **1446 mm2** of bed
contact, against 117 mm2 back-down -- and all of that support is interior roof
nobody sees. Measured with `tools/overhang.py`, not reasoned about; it
contradicts the obvious guess about the sloping roof.

**Cap standing on its bottom edge, with a brim.** Its 638 mm2 is one surface,
the chamfer, sitting at 44.81 degrees -- two tenths under the 45 the tool
defaults to. At `--thresh 44` the same orientation scores 20 mm2, so it needs
almost no support standing up; what it does need is the brim, because 69 mm2 of
bed contact under a part 26.8 mm tall is not enough on its own.

**0.20 layer height**, whatever the printer: the joint steps are 0.80 and the
cap is 1.60, and both divide exactly. Support for the shell only -- anything
near the display seat has to come back out through the pocket.

The full orientation table and what the overhang tool hides are in
[../prospector/README.md](../prospector/README.md).

## Rebuilding

```bash
openscad -D 'part="shell"' -D 'show_parts=false' \
         -o release/prospector_shell.stl scad/prospector.scad
openscad -D 'part="cap"' -o release/prospector_cap.stl scad/prospector.scad
```

`show_parts` is on by default and ghosts the display and the XIAO in place. On
screen that is the point; in an STL it is the display and the XIAO exported
inside the shell -- three shells and 27.20 cm3. The cap never draws them, so
its line needs nothing.

Two things follow from checking these in:

**They go stale silently.** Nothing rebuilds them. Anything that changes the
geometry has to rebuild both and commit them in the same commit, or the files
here describe a case that no longer exists.

**Do not diff them by hash.** OpenSCAD does not emit facets in a stable order,
so two builds of the same tree give two different files -- 134981 bytes apart
on the shell, with the same 3226 triangles and the same vertex set. `stlstat.py`
is the comparison that means anything; `md5sum` is not.
