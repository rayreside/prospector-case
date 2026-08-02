"""Cross-sectional area of an STL at given z heights.

Slices the triangle soup with a horizontal plane and sums the shoelace term
over each intersection segment, oriented from the triangle's outward normal
so the enclosed area comes out positive. No loop assembly needed.
"""
import sys
import numpy as np
from stlstat import load_stl


def area_at(t, z, _eps=1e-6):
    """Cross-sectional area at z.

    Sampling exactly on a coplanar face is unreliable: faces lying in the plane
    contribute no crossing, and the walls that die on it do not strictly cross
    either, so their segments vanish and the shoelace loses whole loops. On this
    model, asking for z=3.0000 -- the underside pocket's ceiling -- reported
    5399 mm^2 against a true 4867, an 11% phantom error, while z=3.0010 agreed
    with the raster to 0.1%. So nudge off any plane that holds a flat face.
    """
    zs = t[:, :, 2]
    flat = (np.abs(zs - z) < 1e-9).all(1)
    if flat.any():
        z = z + _eps

    total = 0.0
    crosses = (zs.min(1) < z) & (zs.max(1) > z)
    tris = t[crosses]
    if len(tris) == 0:
        return 0.0
    for tri in tris:
        pts = []
        for i in range(3):
            a, b = tri[i], tri[(i + 1) % 3]
            if (a[2] - z) * (b[2] - z) < 0:
                f = (z - a[2]) / (b[2] - a[2])
                pts.append(a[:2] + f * (b[:2] - a[:2]))
        if len(pts) != 2:
            continue
        n = np.cross(tri[1] - tri[0], tri[2] - tri[0])
        d = pts[1] - pts[0]
        # boundary runs CCW when its direction is (-n.y, n.x)
        if d[0] * -n[1] + d[1] * n[0] < 0:
            pts = pts[::-1]
        (x1, y1), (x2, y2) = pts[0], pts[1]
        total += 0.5 * (x1 * y2 - x2 * y1)
    return total


if __name__ == "__main__":
    ref, scad, heights = sys.argv[1], sys.argv[2], [float(h) for h in sys.argv[3:]]
    tr, ts = load_stl(ref), load_stl(scad)
    print(f"{'z (mm)':>8} {'reference':>12} {'openscad':>12} {'delta':>10} {'delta %':>9}")
    for z in heights:
        ar, as_ = area_at(tr, z), area_at(ts, z)
        d = as_ - ar
        pct = (d / ar * 100) if ar else float('nan')
        print(f"{z:8.2f} {ar:12.2f} {as_:12.2f} {d:10.2f} {pct:8.1f}%")
    print("\n(areas in mm^2)")
