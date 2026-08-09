"""Extract a closed boundary loop from an STL cross-section as a polygon.

For prismatic features it is often more honest to lift the real boundary out of
the printed part than to invent a parametric rule that only approximates it --
the repo already stores pcb_outline this way.

Welds section endpoints with a tolerance that tolerates the floating-point
noise in interpolated crossings (a plain grid round breaks connectivity), then
walks each loop and decimates it with Douglas-Peucker.

    python tools/outline.py <stl> <z> [decimation_eps_mm]

LIMITATION, and it matters: this is only trustworthy on clean meshes. On
OpenSCAD output it returns exactly the loops you expect. On the Blender-derived
reference STLs it fragments -- a sectioned case bottom carries 32
non-2-manifold edges, and loop walking has no correct answer at a vertex where
three faces meet, so the outer boundary comes back in dozens of pieces. Check
the reported loop count and areas before believing any of it; if the shape you
want is not a single loop of plausible area, it did not work. tools/probe.py
is unaffected by mesh defects and is the safer measurement.
"""
import sys
import numpy as np
from walls import section


def build_loops(p0, p1, weld=2e-3):
    """Weld endpoints, then walk closed loops."""
    pts = np.vstack([p0, p1])
    keys = {}
    ids = np.empty(len(pts), dtype=int)
    for i, p in enumerate(pts):
        cell = (int(round(p[0] / weld)), int(round(p[1] / weld)))
        hit = None
        for dx in (-1, 0, 1):                      # check neighbours too, so a
            for dy in (-1, 0, 1):                  # point landing just across a
                hit = hit or keys.get((cell[0] + dx, cell[1] + dy))  # cell edge
                if hit is not None:                # still matches
                    break
            if hit is not None:
                break
        if hit is None:
            hit = len(keys)
            keys[cell] = hit
        else:
            keys.setdefault(cell, hit)
        ids[i] = hit

    n = len(p0)
    adj = {}
    for a, b in zip(ids[:n], ids[n:]):
        adj.setdefault(a, []).append(b)
        adj.setdefault(b, []).append(a)

    coord = {}
    for i, p in enumerate(pts):
        coord.setdefault(ids[i], p)

    loops, used = [], set()
    for start in adj:
        if start in used or len(adj[start]) < 2:
            continue
        used.add(start)
        loop, prev, cur = [start], None, start
        while True:
            nbrs = [v for v in adj[cur] if v != prev]
            if not nbrs:
                break
            nxt = nbrs[0]
            if nxt == start:          # closed -- check this before `used`,
                break                 # or the loop can never come home
            if nxt in used:
                break
            used.add(nxt)
            loop.append(nxt)
            prev, cur = cur, nxt
        if len(loop) > 8:
            loops.append(np.array([coord[i] for i in loop]))
    return loops


def rdp(pts, eps):
    """Douglas-Peucker decimation."""
    if len(pts) < 3:
        return pts
    a, b = pts[0], pts[-1]
    ab = b - a
    L = np.hypot(*ab)
    if L < 1e-9:
        d = np.hypot(*(pts - a).T)
    else:
        rel = pts - a                       # 2-D cross by hand; numpy 2 dropped it
        d = np.abs(ab[0] * rel[:, 1] - ab[1] * rel[:, 0]) / L
    i = int(np.argmax(d))
    if d[i] <= eps:
        return np.array([a, b])
    return np.vstack([rdp(pts[:i + 1], eps)[:-1], rdp(pts[i:], eps)])


if __name__ == "__main__":
    sys.setrecursionlimit(10000)
    from stlstat import load_stl
    path, z = sys.argv[1], float(sys.argv[2])
    eps = float(sys.argv[3]) if len(sys.argv) > 3 else 0.05

    p0, p1, _ = section(load_stl(path), z)
    loops = build_loops(p0, p1)
    areas = []
    for L in loops:
        x, y = L[:, 0], L[:, 1]
        areas.append(0.5 * np.sum(x * np.roll(y, -1) - np.roll(x, -1) * y))
    order = np.argsort([-abs(a) for a in areas])
    print(f"// {len(loops)} loops at z={z}")
    for k in order:
        L, a = loops[k], areas[k]
        d = rdp(L, eps)
        lo, hi = L.min(0), L.max(0)
        print(f"// area {a:10.2f}  {len(L):5d} pts -> {len(d):4d}  "
              f"x {lo[0]:.3f}->{hi[0]:.3f}  y {lo[1]:.3f}->{hi[1]:.3f}")
