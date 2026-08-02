"""Section an STL and report every closed loop, not just the total area.

slice.py sums a shoelace and needs no loop assembly, which is what makes it a
trustworthy referee for area. It cannot tell you where a hole is. This one
chains the segments so each loop can be measured on its own: signed area
(negative = a hole), bounding box, centroid, and a circle fit when the loop
is round.

The section plane can be tilted, which is the point here -- the Prospector
display sits at 55 degrees, so nothing about it is measurable in the export
frame.

    python loops.py part.stl 6.8 --tilt 55
"""
import argparse

import numpy as np

from stlstat import load_stl


def frame(tilt_deg):
    """Rows are the local axes u, v, w. w is the section normal."""
    a = np.radians(tilt_deg)
    c, s = np.cos(a), np.sin(a)
    return np.array([[1, 0, 0], [0, c, s], [0, -s, c]])


def segments(t, w, eps=1e-6):
    """Intersection segments at plane w, oriented so solid is to the left."""
    ws = t[:, :, 2]
    if (np.abs(ws - w) < 1e-9).all(1).any():
        w += eps  # never sample on a coplanar face -- see slice.py
    out = []
    for tri in t[(ws.min(1) < w) & (ws.max(1) > w)]:
        pts = []
        for i in range(3):
            a, b = tri[i], tri[(i + 1) % 3]
            if (a[2] - w) * (b[2] - w) < 0:
                f = (w - a[2]) / (b[2] - a[2])
                pts.append(a[:2] + f * (b[:2] - a[:2]))
        if len(pts) != 2:
            continue
        n = np.cross(tri[1] - tri[0], tri[2] - tri[0])
        d = pts[1] - pts[0]
        if d[0] * -n[1] + d[1] * n[0] < 0:
            pts = pts[::-1]
        out.append(pts)
    return out


def chain(segs, tol=1e-4):
    """Weld segment endpoints on a grid and walk them into closed loops."""
    key = lambda p: (round(p[0] / tol), round(p[1] / tol))
    nxt = {}
    for a, b in segs:
        nxt.setdefault(key(a), []).append((b, key(b)))
    loops, used = [], set()
    for a, b in segs:
        ka = key(a)
        if ka in used:
            continue
        loop, k, p = [a], ka, a
        while True:
            used.add(k)
            cand = [x for x in nxt.get(k, []) if x[1] not in used]
            if not cand:
                break
            p, k = cand[0]
            loop.append(p)
            if k == ka:
                break
        if len(loop) > 2:
            loops.append(np.array(loop))
    return loops


def report(path, w, tilt):
    t = load_stl(path) @ frame(tilt).T
    loops = chain(segments(t, w))
    print(f"{path.split('/')[-1]}  w={w}  tilt={tilt}deg   {len(loops)} loop(s)")
    for lp in sorted(loops, key=lambda L: -abs(shoelace(L))):
        a = shoelace(lp)
        lo, hi = lp.min(0), lp.max(0)
        ctr = lp.mean(0)
        r = np.linalg.norm(lp - ctr, axis=1)
        kind = "solid" if a > 0 else "HOLE "
        circ = f"  circle r={r.mean():.3f} d={2*r.mean():.3f}" if r.std() < 0.02 * max(r.mean(), 1e-9) else ""
        print(f"  {kind} area={a:9.3f}  u {lo[0]:8.3f}..{hi[0]:8.3f} ({hi[0]-lo[0]:7.3f})"
              f"  v {lo[1]:8.3f}..{hi[1]:8.3f} ({hi[1]-lo[1]:7.3f})"
              f"  ctr ({ctr[0]:7.3f},{ctr[1]:7.3f}){circ}")


def shoelace(lp):
    x, y = lp[:, 0], lp[:, 1]
    return 0.5 * np.sum(x * np.roll(y, -1) - np.roll(x, -1) * y)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("stl")
    ap.add_argument("w", type=float, nargs="+")
    ap.add_argument("--tilt", type=float, default=0.0)
    a = ap.parse_args()
    for w in a.w:
        report(a.stl, w, a.tilt)
