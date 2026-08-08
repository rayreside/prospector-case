"""Trace one boundary and fit a line to it: is this edge straight, and at what angle?

    python tools/fitedge.py <part.stl> 6.0 128.4 135.0 44.0 86.0 max

Scans the window row by row and takes the largest x carrying material (`max`,
a right-hand edge) or the smallest (`min`, a left-hand edge), then fits
x = a + b*y and reports the residual. The residual is what makes it useful: it
separates "this edge is tilted" from "this edge is curved" from "my window
caught a corner and the fit is meaningless".

A residual at the raster floor -- step/sqrt(12), so 0.0029 at step 0.01 --
means the underlying edge is exactly straight and the angle is trustworthy.
Anything much above that means the window spans more than one edge.

Worth checking the same edge at two heights before believing an angle. If they
differ the part is not prismatic and a single section was never going to
describe it; if they agree to the last digit, the slope is real.
"""
import argparse
import os
import sys
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stlstat import load_stl
from raster import section_segments, fill


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("stl")
    ap.add_argument("z", type=float)
    ap.add_argument("xlo", type=float)
    ap.add_argument("xhi", type=float)
    ap.add_argument("ylo", type=float)
    ap.add_argument("yhi", type=float)
    ap.add_argument("side", choices=["min", "max"])
    ap.add_argument("--step", type=float, default=0.01, help="x resolution mm")
    ap.add_argument("--rows", type=float, default=0.10, help="y spacing mm")
    a = ap.parse_args()

    xs = np.arange(a.xlo, a.xhi, a.step)
    ys = np.arange(a.ylo, a.yhi, a.rows)
    g = fill(section_segments(load_stl(a.stl), a.z), xs, ys)

    yy, ee = [], []
    for j, y in enumerate(ys):
        nz = np.nonzero(g[j])[0]
        if len(nz):
            yy.append(y)
            ee.append(xs[nz[-1] if a.side == "max" else nz[0]])
    yy, ee = np.array(yy), np.array(ee)
    if len(yy) < 3:
        sys.exit("fewer than three rows carry material; widen the window")

    b, c = np.polyfit(yy, ee, 1)
    res = ee - (c + b * yy)
    floor = a.step / np.sqrt(12)
    print(f"  rows {len(yy)}   y {yy[0]:.2f}..{yy[-1]:.2f}   "
          f"x {ee.min():.3f}..{ee.max():.3f}")
    print(f"  fit   x = {c:.4f} {b:+.6f}*y      "
          f"{np.degrees(np.arctan(-b)):+.3f} deg off vertical")
    print(f"  residual  max {np.abs(res).max():.4f}   "
          f"rms {np.sqrt((res ** 2).mean()):.4f}   raster floor {floor:.4f}")
    if ee.min() <= a.xlo + a.step or ee.max() >= a.xhi - a.step:
        print("  WARNING: the trace reaches the window edge, so the fit is "
              "following the window, not the part")


if __name__ == "__main__":
    main()
