"""Which way up does this print, and what does it cost in support.

Rotates the mesh about x by each angle given, then sums the area of every
downward-facing triangle steeper than the threshold -- the surfaces a slicer
would put support under. Also reports the bed footprint, because an
orientation with no overhangs and a 100 mm2 contact patch is not the win it
looks like.

Angle convention: 0 is the model as modelled. The rotation is about x only,
which is all this case needs -- it is symmetric about x = 0 and every face of
interest lies in the y-z plane.

    python tools/overhang.py build/prospector/prospector_shell.stl 0 110 -90
"""
import argparse

import numpy as np

from stlstat import load_stl


def rot_x(t, deg):
    a = np.radians(deg)
    c, s = np.cos(a), np.sin(a)
    m = np.array([[1, 0, 0], [0, c, -s], [0, s, c]])
    return t @ m.T


def report(t, deg, thresh, above):
    r = rot_x(t, deg)
    a, b, c = r[:, 0], r[:, 1], r[:, 2]
    n = np.cross(b - a, c - a)
    area = np.linalg.norm(n, axis=1) / 2
    keep = area > 0
    nz = np.zeros(len(n))
    nz[keep] = n[keep, 2] / (2 * area[keep])

    # A face's slope from horizontal equals its normal's angle from vertical,
    # so |nz| > cos(threshold) is the shallow, hard-to-print case.
    zmin = r.reshape(-1, 3)[:, 2].min()
    # A shallow face sitting a fraction of a millimetre off the bed is not a
    # support problem, it is the second layer. Without this the counterbore
    # ledge counts 153 mm2 against an orientation that is otherwise clean.
    high = r[:, :, 2].min(1) > zmin + above
    over = (nz < -np.cos(np.radians(thresh))) & keep & high
    on_bed = keep & (nz < -0.999) & (r[:, :, 2].max(1) < zmin + 0.05)
    hi = r.reshape(-1, 3).max(0)
    lo = r.reshape(-1, 3).min(0)
    print(f"  rot {deg:>6.1f}   overhang {area[over].sum():8.1f} mm2"
          f"   bed {area[on_bed].sum():7.1f} mm2"
          f"   height {hi[2]-lo[2]:6.2f} mm")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("stl")
    ap.add_argument("angles", type=float, nargs="+")
    ap.add_argument("--thresh", type=float, default=45.0,
                    help="faces shallower than this, in degrees, need support")
    ap.add_argument("--above", type=float, default=1.0,
                    help="ignore overhangs within this of the bed")
    a = ap.parse_args()
    t = load_stl(a.stl)
    print(f"{a.stl.split('/')[-1]}   support threshold {a.thresh} deg")
    for d in a.angles:
        report(t, d, a.thresh, a.above)
