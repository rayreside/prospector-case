# Verification tools

Used to check `scad/urchin.scad` against the printed STLs in `high-profile/`.
The STLs are the milestone-1 ground truth; the OpenSCAD port is measured
against them, never the other way round.

Requires Python 3 and numpy. Both scripts read ASCII and binary STL.

## `stlstat.py` — bulk properties

```bash
python tools/stlstat.py high-profile/right/urchin_hp_top_right.stl
```

Reports triangle count, bounding box, volume, shell count, and edge
manifoldness. It reproduces the figures published in the root README exactly,
which is the check that it is measuring correctly.

Note: the non-2-manifold edge count here (25 on the top) is higher than the 17
the README cites from Blender — a different counting convention. Both agree on
zero boundary edges, which is what actually determines watertightness.

## `slice.py` — cross-section areas

```bash
python tools/slice.py <reference.stl> <candidate.stl> 2.0 3.0 4.5 8.5
```

Prints the cross-sectional area of both meshes at each z, with the delta.
Volume alone says *how much* two parts differ; this says *where*. A constant
delta across a z band means both parts are prismatic there and the section
itself is wrong. A delta that varies with z means the reference has features
the candidate lacks.

## Rendering the OpenSCAD parts

```bash
openscad -D 'part="top"' -o top.stl scad/urchin.scad
```

Valid parts: `top`, `mountains`, `bottom`, `all`. `shield` is declared but not
yet implemented.
