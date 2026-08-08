"""Print the exact solid intervals along a horizontal scan line.

Decisive check on wall positions: gives the x where material starts and stops,
so wall thickness and cavity position can be read off directly.
"""
import sys
import numpy as np
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stlstat import load_stl
from walls import section


def spans(path, z, y):
    p0, p1, _ = section(load_stl(path), z)
    y0, y1 = p0[:, 1], p1[:, 1]
    # Half-open, NOT (y0-y)*(y1-y) < 0. The strict form skips any segment with
    # an endpoint exactly on the scan line, and on a tessellated mesh vertices
    # land on round values constantly -- at y=20 on the printed mountains it
    # dropped two of four crossings, and since the rest are paired off in
    # order, the spans that survived were plausible and wrong. Counting each
    # crossing once either way makes the parity right whatever lies on the line.
    hit = ((y0 <= y) & (y1 > y)) | ((y1 <= y) & (y0 > y))
    f = (y - y0[hit]) / (y1[hit] - y0[hit])
    xc = np.sort(p0[hit, 0] + f * (p1[hit, 0] - p0[hit, 0]))
    return [(xc[i], xc[i + 1]) for i in range(0, len(xc) - 1, 2)]


if __name__ == "__main__":
    ref, scad, z = sys.argv[1], sys.argv[2], float(sys.argv[3])
    for y in [float(v) for v in sys.argv[4:]]:
        print(f"--- y = {y}, z = {z} ---")
        for label, path in (("reference", ref), ("openscad ", scad)):
            s = spans(path, z, y)
            txt = "  ".join(f"[{a:.3f} -> {b:.3f}  w={b-a:.3f}]" for a, b in s)
            print(f"  {label}: {txt if s else '(empty)'}")
        print()
