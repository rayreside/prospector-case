"""Measure local wall thickness from an STL at a given z.

Takes the horizontal cross-section, then from sample points along it casts a
ray inward along the surface normal and records the distance to the first
opposing wall. For a uniform wall the distances cluster tightly; a spread means
the wall varies or the section has openings.
"""
import sys
import numpy as np
from stlstat import load_stl


def section(t, z):
    """Cross-section at z as (p0, p1, outward_normal_2d) arrays."""
    zs = t[:, :, 2]
    tris = t[(zs.min(1) < z) & (zs.max(1) > z)]
    p0, p1, nn = [], [], []
    for tri in tris:
        pts = []
        for i in range(3):
            a, b = tri[i], tri[(i + 1) % 3]
            if (a[2] - z) * (b[2] - z) < 0:
                f = (z - a[2]) / (b[2] - a[2])
                pts.append(a[:2] + f * (b[:2] - a[:2]))
        if len(pts) != 2:
            continue
        n = np.cross(tri[1] - tri[0], tri[2] - tri[0])[:2]
        ln = np.hypot(*n)
        if ln < 1e-12:
            continue
        p0.append(pts[0]); p1.append(pts[1]); nn.append(n / ln)
    return np.array(p0), np.array(p1), np.array(nn)


def thickness(p0, p1, nn, samples=3, eps=1e-4):
    """Inward ray cast from sample points on each segment."""
    fs = (np.arange(samples) + 0.5) / samples
    org = (p0[:, None, :] + fs[None, :, None] * (p1 - p0)[:, None, :]).reshape(-1, 2)
    dirs = np.repeat(-nn, samples, axis=0)
    org = org + eps * dirs

    a, b = p0, p1
    ab = b - a
    out = np.full(len(org), np.inf)
    for lo in range(0, len(org), 512):          # chunk to bound memory
        o = org[lo:lo + 512, None, :]
        d = dirs[lo:lo + 512, None, :]
        den = d[..., 0] * ab[None, :, 1] - d[..., 1] * ab[None, :, 0]
        ao = a[None, :, :] - o
        with np.errstate(divide='ignore', invalid='ignore'):
            t = (ao[..., 0] * ab[None, :, 1] - ao[..., 1] * ab[None, :, 0]) / den
            s = (ao[..., 0] * d[..., 1] - ao[..., 1] * d[..., 0]) / den
        ok = (np.abs(den) > 1e-12) & (t > eps) & (s >= 0) & (s <= 1)
        t = np.where(ok, t, np.inf)
        out[lo:lo + 512] = t.min(axis=1)
    return out[np.isfinite(out)]


if __name__ == "__main__":
    path, heights = sys.argv[1], [float(h) for h in sys.argv[2:]]
    t = load_stl(path)
    name = path.replace('\\', '/').split('/')[-1]
    for z in heights:
        p0, p1, nn = section(t, z)
        d = thickness(p0, p1, nn)
        if len(d) == 0:
            print(f"{name}  z={z}: empty section")
            continue
        # 0.05 mm histogram, to find the dominant wall
        bins = np.round(d / 0.05) * 0.05
        vals, counts = np.unique(bins, return_counts=True)
        top = vals[np.argsort(-counts)][:4]
        share = np.sort(counts)[::-1][:4] / len(d) * 100
        print(f"{name}  z={z:.2f}  ({len(p0)} segments, {len(d)} rays)")
        print(f"    median {np.median(d):6.3f}   p10 {np.percentile(d, 10):6.3f} "
              f"  p90 {np.percentile(d, 90):6.3f}   min {d.min():6.3f}")
        print("    dominant: " + "  ".join(
            f"{v:.2f}mm {s:.0f}%" for v, s in zip(top, share)))
