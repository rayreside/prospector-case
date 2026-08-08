"""Find and bound the regions where two STL cross-sections disagree.

    python tools/clusters.py <reference.stl> <candidate.stl> 6.0
    python tools/clusters.py ref.stl cand.stl 6.0 0.025 0.02

Rasterises both sections, then labels the disagreement into connected clusters
and reports each one's extent in mm. Answers "what feature is missing and
where" rather than "how much volume is off".

Volume is a poor detector and this is why: the mountains once read -0.14% off
because a 12 mm2 deficit on one wall was cancelling a 12 mm2 surplus elsewhere.
Fixing the deficit made the total look worse and the part better. Splitting the
two directions, as below, shows that; one scalar never will.

Resolution is the whole game. This defaulted to step 0.2 and min_area 3.0 for a
long time, which is why it reported the mountains as clean while they carried a
5.70 x 0.047 mm tongue, a 0.29 mm2 detached island and a 3.1 mm2 sliver: every
one of them was smaller than a cell or below the floor. Keep the step well
under the smallest thing being judged, and treat a cluster the size of one cell
as noise -- an edge that merely crosses a cell boundary during a parameter
sweep reads as a whole cluster appearing, which looks like a cliff and is not.
"""
import os
import sys
import numpy as np
from scipy import ndimage

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stlstat import load_stl
from raster import section_segments, fill

ref_path, cand_path, z = sys.argv[1], sys.argv[2], float(sys.argv[3])
step = float(sys.argv[4]) if len(sys.argv) > 4 else 0.05
min_area = float(sys.argv[5]) if len(sys.argv) > 5 else 0.05

xs = np.arange(126.767, 242.601, step)
ys = np.arange(14.311, 107.688, step)
ref = fill(section_segments(load_stl(ref_path), z), xs, ys)
cand = fill(section_segments(load_stl(cand_path), z), xs, ys)
cell = step * step

print(f"z={z}  step {step}  ref {ref.sum() * cell:.1f} mm2  "
      f"cand {cand.sum() * cell:.1f} mm2")

for label, mask in (("candidate has material the reference does not", cand & ~ref),
                    ("reference has material the candidate does not", ref & ~cand)):
    lab, _ = ndimage.label(mask, np.ones((3, 3)))
    out = []
    for i, sl in enumerate(ndimage.find_objects(lab), 1):
        area = (lab[sl] == i).sum() * cell
        if area < min_area:
            continue
        ry, rx = sl
        out.append((area, xs[rx.start], xs[rx.stop - 1],
                    ys[ry.start], ys[ry.stop - 1]))
    out.sort(reverse=True)
    print(f"\n=== {label} ===")
    print(f"    total {mask.sum() * cell:.2f} mm2 "
          f"in {len(out)} clusters over {min_area} mm2")
    for a, x0, x1, y0, y1 in out[:12]:
        print(f"    {a:8.3f} mm2   x {x0:8.2f} -> {x1:8.2f}   "
              f"y {y0:7.2f} -> {y1:7.2f}   ({x1 - x0:6.2f} x {y1 - y0:6.2f})")
