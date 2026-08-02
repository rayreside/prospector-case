"""How much of an assembly is air, and where the air sits.

Rasterises every part onto a shared grid by ray-parity along z, ORs them into
one solid, and compares that against the convex hull of all the vertices.
Anything inside the hull and outside the plastic is free space -- room the
components and their wiring occupy, and the only room a smaller case can take
back.

The obvious method, flood-filling from outside and calling whatever it cannot
reach "sealed void", reports **zero** on a real case. A finished enclosure is
not sealed: the USB slot, the screen aperture and the seams between parts all
connect the cavity to the outside, so the fill walks straight in. The convex
hull avoids that entirely, and is a fair envelope for anything convex-ish --
a rounded wedge, a puck, a slab. It will overstate the envelope of a part with
a deep concave feature, so look at what you are measuring first.

    python tools/void.py case/*.stl --pitch 0.5
"""
import argparse

import numpy as np
from scipy.spatial import ConvexHull

from stlstat import load_stl, volume


def rasterise(t, lo, pitch, shape):
    """Solid occupancy by z-parity. The mesh must be watertight."""
    nx, ny, nz = shape
    occ = np.zeros(shape, bool)
    xs = lo[0] + (np.arange(nx) + 0.5) * pitch
    ys = lo[1] + (np.arange(ny) + 0.5) * pitch
    zs = lo[2] + (np.arange(nz) + 0.5) * pitch

    a, b, c = t[:, 0], t[:, 1], t[:, 2]
    tlo = np.floor((t[:, :, :2].min(1) - lo[:2]) / pitch).astype(int)
    thi = np.ceil((t[:, :, :2].max(1) - lo[:2]) / pitch).astype(int)

    hits = [[[] for _ in range(ny)] for _ in range(nx)]
    e1, e2 = b - a, c - a
    for i in range(len(t)):
        x0, y0 = max(tlo[i, 0], 0), max(tlo[i, 1], 0)
        x1, y1 = min(thi[i, 0] + 1, nx), min(thi[i, 1] + 1, ny)
        if x0 >= x1 or y0 >= y1:
            continue
        gx, gy = np.meshgrid(xs[x0:x1], ys[y0:y1], indexing="ij")
        px, py = gx - a[i, 0], gy - a[i, 1]
        d = e1[i, 0] * e2[i, 1] - e1[i, 1] * e2[i, 0]
        if d == 0:
            continue
        u = (px * e2[i, 1] - py * e2[i, 0]) / d
        v = (py * e1[i, 0] - px * e1[i, 1]) / d
        m = (u >= 0) & (v >= 0) & (u + v <= 1)
        if not m.any():
            continue
        z = a[i, 2] + u * e1[i, 2] + v * e2[i, 2]
        ii, jj = np.nonzero(m)
        for k in range(len(ii)):
            hits[x0 + ii[k]][y0 + jj[k]].append(z[ii[k], jj[k]])

    for i in range(nx):
        for j in range(ny):
            h = hits[i][j]
            if len(h) < 2:
                continue
            h = np.sort(np.array(h))
            for s, e in zip(h[0::2], h[1::2]):
                occ[i, j, (zs > s) & (zs < e)] = True
    return occ


def hull_mesh(pts):
    """Convex hull as an outward-oriented triangle soup."""
    h = ConvexHull(pts)
    tris = []
    for s, eq in zip(h.simplices, h.equations):
        t = h.points[s]
        if np.dot(np.cross(t[1] - t[0], t[2] - t[0]), eq[:3]) < 0:
            t = t[[0, 2, 1]]
        tris.append(t)
    return np.array(tris), h.volume


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("stl", nargs="+")
    ap.add_argument("--pitch", type=float, default=0.5)
    a = ap.parse_args()

    meshes = [load_stl(p) for p in a.stl]
    pts = np.concatenate([m.reshape(-1, 3) for m in meshes])
    hull, hvol = hull_mesh(pts)
    plastic = sum(volume(m) for m in meshes)

    lo, hi = pts.min(0), pts.max(0)
    print(f"bbox          {hi[0]-lo[0]:7.2f} x {hi[1]-lo[1]:7.2f} x {hi[2]-lo[2]:7.2f} mm")
    print(f"envelope      {hvol/1000:8.3f} cm3   (convex hull)")
    print(f"plastic       {plastic/1000:8.3f} cm3")
    print(f"free          {(hvol-plastic)/1000:8.3f} cm3   "
          f"({100*(1-plastic/hvol):.0f}% air)")

    lo, hi = lo - a.pitch, hi + a.pitch
    shape = tuple(int(np.ceil((hi[i] - lo[i]) / a.pitch)) for i in range(3))
    occ = np.zeros(shape, bool)
    for m in meshes:
        occ |= rasterise(m, lo, a.pitch, shape)
    free = rasterise(hull, lo, a.pitch, shape) & ~occ

    step = max(1, int(round(2.0 / a.pitch)))
    for axis, label in ((2, "z"), (1, "y")):
        c = lo[axis] + (np.arange(shape[axis]) + 0.5) * a.pitch
        print(f"\nfree area by {label} (mm2):")
        for k in range(0, shape[axis], step):
            v = free.take(k, axis=axis).sum() * a.pitch ** 2
            if v > 0:
                print(f"  {label}={c[k]:6.1f} {v:8.1f}  {'#' * int(v / 40)}")


if __name__ == "__main__":
    main()
