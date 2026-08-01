"""Find and bound the regions where two STL cross-sections disagree.

Rasterises both sections, then flood-fills the disagreement into connected
clusters and reports each one's extent in mm. Answers "what feature is
missing and where" rather than "how much volume is off".
"""
import sys
import numpy as np
sys.path.insert(0, r"C:\Repos\urchin-cases\tools")
from stlstat import load_stl
from walls import section


def occupancy(path, z, xs, ys):
    p0, p1, _ = section(load_stl(path), z)
    grid = np.zeros((len(ys), len(xs)), dtype=bool)
    y0, y1 = p0[:, 1], p1[:, 1]
    x0, x1 = p0[:, 0], p1[:, 0]
    for r, y in enumerate(ys):
        hit = (y0 - y) * (y1 - y) < 0
        if not hit.any():
            continue
        f = (y - y0[hit]) / (y1[hit] - y0[hit])
        xc = np.sort(x0[hit] + f * (x1[hit] - x0[hit]))
        grid[r] = np.searchsorted(xc, xs) % 2 == 1
    return grid


def clusters(mask, xs, ys, min_area):
    seen = np.zeros_like(mask)
    step = (xs[1] - xs[0]) * (ys[1] - ys[0])
    out = []
    for r0, c0 in zip(*np.nonzero(mask)):
        if seen[r0, c0]:
            continue
        stack, cells = [(r0, c0)], []
        seen[r0, c0] = True
        while stack:
            r, c = stack.pop()
            cells.append((r, c))
            for dr, dc in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                rr, cc = r + dr, c + dc
                if (0 <= rr < mask.shape[0] and 0 <= cc < mask.shape[1]
                        and mask[rr, cc] and not seen[rr, cc]):
                    seen[rr, cc] = True
                    stack.append((rr, cc))
        area = len(cells) * step
        if area >= min_area:
            rs = [c[0] for c in cells]; cs = [c[1] for c in cells]
            out.append((area, xs[min(cs)], xs[max(cs)], ys[min(rs)], ys[max(rs)]))
    return sorted(out, key=lambda r: -r[0])


ref_path, scad_path, z = sys.argv[1], sys.argv[2], float(sys.argv[3])
step = float(sys.argv[4]) if len(sys.argv) > 4 else 0.2
min_area = float(sys.argv[5]) if len(sys.argv) > 5 else 3.0

xs = np.arange(126.767, 242.601, step)
ys = np.arange(14.311, 107.688, step)
ref = occupancy(ref_path, z, xs, ys)
scad = occupancy(scad_path, z, xs, ys)

for label, mask in (("scad has material the reference does not (missing opening)",
                     scad & ~ref),
                    ("reference has material the scad does not",
                     ref & ~scad)):
    cl = clusters(mask, xs, ys, min_area)
    print(f"\n=== z={z}: {label} ===")
    print(f"    total {mask.sum() * step * step:.1f} mm^2 "
          f"in {len(cl)} clusters over {min_area} mm^2")
    for a, x0, x1, y0, y1 in cl[:12]:
        print(f"    {a:8.1f} mm^2   x {x0:8.2f} -> {x1:8.2f}   "
              f"y {y0:7.2f} -> {y1:7.2f}   ({x1-x0:6.2f} x {y1-y0:6.2f})")
