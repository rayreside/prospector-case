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

## `clusters.py` — where two sections disagree

```bash
python tools/clusters.py <reference.stl> <candidate.stl> 6.0
python tools/clusters.py ref.stl cand.stl 6.0 0.025 0.02   # step, min area
```

Labels the disagreement into connected clusters and gives each one's extent, in
both directions separately. `slice.py` says how much and at what height; this
says whereabouts, which is the part that leads to a cause.

Splitting the two directions matters. The mountains once read −0.14% on volume
because a 12 mm² deficit on one wall was cancelling a 12 mm² surplus elsewhere;
fixing the deficit made the total look worse and the part better.

## `thin.py` — features too thin to print

```bash
python tools/thin.py build/urchin_mountains.stl 6.0 0.20
```

Opens the section with a disc and reports what the opening removed — anything
narrower than twice the radius cannot hold the disc. Pass about half a nozzle
width. Convex corners lose only r²(1−π/4), so a hit near that size is noise.

This found what diffing could not. The printed mountains carry no feature under
0.4 mm anywhere; the port had eighteen, one of them a 5.70 mm tongue just
0.047 mm wide, which a 0.10 mm section grid had stepped straight over.

It also brackets a threshold from both sides: if the printed part drops a 0.437
sliver but keeps a 0.485 strip, the radius that reproduces it is pinned to a
window rather than fitted to a curve.

## `fitedge.py` — is this edge straight, and at what angle

```bash
python tools/fitedge.py <part.stl> 6.0 128.4 135.0 44.0 86.0 max
```

Traces one boundary of the window row by row and fits a line. The residual is
the useful part: at the raster floor (`step/√12`) the edge is exactly straight
and the angle can be trusted; well above it, the window spans more than one
edge and the fit means nothing.

Check an angle at two heights before believing it. If they differ the part
isn't prismatic and one section was never going to describe it.

## `raster.py` — shared section fill

Not run directly. `clusters.py`, `thin.py` and `fitedge.py` all fill a section
onto a grid through it.

Both crossing tests are half-open rather than strict, which is not fussiness:
the strict form drops any segment with an endpoint exactly on the scan line,
and on a tessellated mesh vertices land on round coordinates constantly.
`probe.py` had that bug and it dropped two of four crossings at y=20 on the
printed mountains — and because the survivors are paired off in order, the
spans it printed were plausible and wrong.

**Resolution is the recurring trap in all of these.** A feature thinner than
one cell can vanish entirely. An edge that merely crosses a cell boundary
during a parameter sweep reads as a whole cluster appearing, which looks like a
cliff in the numbers and is not one. Keep the step well under the smallest
thing being judged.

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
