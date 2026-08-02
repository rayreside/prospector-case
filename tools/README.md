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

## `build.py` — export every part

```bash
python tools/build.py
```

Writes all four parts to `build/` and prints each volume against the printed
reference. `--fused` builds the fused-mountains variant instead.

## `render.py` — look at it

```bash
python tools/render.py mountains
python tools/render.py top --cut y --cut-at 50 --at 185 50 4 --dist 135
```

Renders the model and its printed counterpart from the same camera, in the
canonical view (top down, thumb cluster bottom left). OpenSCAD's own default
camera is that view turned 180 degrees, so GUI screenshots are upside down.

`--cut x|y|z` sections the model. This is the one that finds things: of the
seven real errors in this port, six were interior and invisible from any
outside view at any render quality. The camera swings to an elevation
automatically, because a section viewed from above is edge-on and shows
nothing.

## Seeing anything in the OpenSCAD GUI

Two settings do almost all the work, and both are off by default:

- **View -> Show Edges.** Without it a plate is a flat slab and features
  disappear into it.
- **F6 (Render) rather than F5 (Preview).** Preview draws subtracted volumes
  as green ghosting; F6 shows the actual solid.

Perspective rather than orthographic also helps read depth. Even so the
viewport has no shading worth the name -- for judging outside shape, export
with `build.py` and open the STL in a real viewer.

## Rendering the OpenSCAD parts

```bash
openscad -D 'part="top"' -o top.stl scad/urchin.scad
```

Valid parts: `top`, `mountains`, `bottom`, `all`. `shield` is declared but not
yet implemented.
