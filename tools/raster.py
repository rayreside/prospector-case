"""Fill a mesh's cross-section onto a grid, so questions about WHERE have answers.

stlstat says how much two parts differ, slice.py says at which z. Neither says
where in plan, and the errors that matter here are 0.3 mm2 slivers that both
report as nothing. A filled section is addressable: XOR two of them and the
difference comes back with coordinates.

Resolution is the whole game. A feature thinner than one cell can fall between
rows and disappear -- a 0.047 mm tongue did exactly that at STEP 0.10, after
31 mm2 of diffing had said the area was clean. An edge that crosses a cell
boundary reads as a whole blob appearing, which turns a smooth parameter sweep
into a cliff that is not there. Pick a step well under the smallest thing being
judged, and treat anything the size of one cell as noise.

Both crossing tests here are half-open rather than strict. The strict form
drops any segment with an endpoint exactly on the line, and on a tessellated
mesh vertices land on round coordinates constantly.
"""
import numpy as np


def section_segments(t, z):
    """Segments where the surface crosses the plane z, as (N, 2, 2)."""
    zs = t[:, :, 2]
    t = t[(zs.min(1) <= z) & (zs.max(1) > z)]
    segs = []
    for tri in t:
        pts = []
        for i in range(3):
            a, b = tri[i], tri[(i + 1) % 3]
            za, zb = a[2], b[2]
            if (za <= z < zb) or (zb <= z < za):
                u = (z - za) / (zb - za)
                pts.append(a[:2] + u * (b[:2] - a[:2]))
        if len(pts) == 2:
            segs.append(pts)
    return np.array(segs) if segs else np.zeros((0, 2, 2))


def fill(segs, xs, ys):
    """Even-odd rasterise a closed section onto the xs by ys grid."""
    g = np.zeros((len(ys), len(xs)), bool)
    if len(segs) == 0:
        return g
    x0, y0 = segs[:, 0, 0], segs[:, 0, 1]
    x1, y1 = segs[:, 1, 0], segs[:, 1, 1]
    for j, y in enumerate(ys):
        m = ((y0 <= y) & (y1 > y)) | ((y1 <= y) & (y0 > y))
        if not m.any():
            continue
        xc = x0[m] + (y - y0[m]) * (x1[m] - x0[m]) / (y1[m] - y0[m])
        xc.sort()
        g[j] = np.searchsorted(xc, xs) % 2 == 1
    return g


def grid(meshes, step, pad=0.5):
    """Common xs, ys covering every mesh given, sampled at cell centres.

    The half-step offset is not cosmetic. Part coordinates are round numbers and
    so are useful step sizes, so an un-offset grid puts rows exactly on model
    edges -- and on a horizontal edge the two meshes' float32 boundaries land
    either side of it, which came back as a 2.3 mm2 cluster of zero height
    sitting on y=14.311, the case's own bottom edge. Sampling at centres keeps
    rows off the coordinates a model is likely to be built on.
    """
    v = np.vstack([m.reshape(-1, 3) for m in meshes])
    lo, hi = v.min(0) - pad, v.max(0) + pad
    return (np.arange(lo[0] + step / 2, hi[0], step),
            np.arange(lo[1] + step / 2, hi[1], step))
