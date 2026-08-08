"""Find features too thin to print.

    python tools/thin.py <part.stl> 6.0 0.20

Opens the section with a disc of the given radius and reports what the opening
removed. Anything narrower than twice the radius cannot hold the disc and
vanishes; convex corners lose only r^2(1-pi/4), which is noise at these sizes.
Pass roughly half a nozzle width to find what the slicer will struggle with.

This is the check that found what diffing could not. The printed mountains
carry no feature under 0.4 mm anywhere -- opening them at r=0.2 removes nothing
but corner shavings -- while the port had eighteen, including a 5.70 mm tongue
only 0.047 mm wide. A section diff on a 0.10 mm grid had stepped straight over
it, because the whole feature was thinner than one cell.

It also brackets a threshold from both sides, which is worth more than it
sounds: if the printed part drops a 0.437 sliver but keeps a 0.485 strip, the
radius that reproduces it is pinned to a window, not fitted to a curve.
"""
import argparse
import os
import sys
import numpy as np
from scipy import ndimage

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stlstat import load_stl
from raster import section_segments, fill, grid


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("stl")
    ap.add_argument("z", type=float)
    ap.add_argument("radius", type=float, help="mm; finds features under 2x this")
    ap.add_argument("--step", type=float, default=0.05, help="grid mm")
    ap.add_argument("--min-area", type=float, default=0.02, help="mm2")
    ap.add_argument("--top", type=int, default=16)
    a = ap.parse_args()

    t = load_stl(a.stl)
    xs, ys = grid([t], a.step)
    g = fill(section_segments(t, a.z), xs, ys)
    cell = a.step * a.step

    r = int(round(a.radius / a.step))
    if r < 2:
        sys.exit(f"radius {a.radius} is under two cells at step {a.step}; "
                 f"the disc is too coarse to mean anything")
    yy, xx = np.mgrid[-r:r + 1, -r:r + 1]
    lost = g & ~ndimage.binary_opening(g, (xx ** 2 + yy ** 2) <= r * r)

    lab, _ = ndimage.label(lost, np.ones((3, 3)))
    rows = []
    for i, sl in enumerate(ndimage.find_objects(lab), 1):
        area = (lab[sl] == i).sum() * cell
        if area < a.min_area:
            continue
        ry, rx = sl
        w, h = (rx.stop - rx.start) * a.step, (ry.stop - ry.start) * a.step
        rows.append((area, xs[rx.start], xs[rx.stop - 1],
                     ys[ry.start], ys[ry.stop - 1], max(w, h), min(w, h)))
    rows.sort(reverse=True)

    name = a.stl.replace("\\", "/").split("/")[-1]
    print(f"{name}  z={a.z}  material {g.sum() * cell:.1f} mm2")
    print(f"  opening r={a.radius} finds features under {2 * a.radius:.2f} mm "
          f"-> {len(rows)} over {a.min_area} mm2\n")
    if not rows:
        print("  nothing thin")
        return
    print(f"  {'area mm2':>9} {'x range':>17} {'y range':>17} {'long':>7} {'short':>7}")
    for area, xa, xb, ya, yb, lng, sht in rows[:a.top]:
        print(f"  {area:9.3f}  {xa:7.2f}..{xb:6.2f}  {ya:7.2f}..{yb:6.2f} "
              f"{lng:7.2f} {sht:7.2f}")


if __name__ == "__main__":
    main()
