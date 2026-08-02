"""Export every part to STL in one go, so opening them elsewhere is not a chore.

    python tools/build.py                 # canonical parts -> build/
    python tools/build.py --fused         # mountains fused into the top
    python tools/build.py --out somewhere

Prints each part's volume next to the printed reference, which is a cheap
regression check: if a number moves and you did not expect it to, look.
"""
import argparse
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SCAD = os.path.join(REPO, "scad", "urchin.scad")
sys.path.insert(0, HERE)

PARTS = ["top", "mountains", "bottom", "shield"]
REF = {
    "top": "urchin_hp_top_right.stl",
    "mountains": "urchin_hp_mountains_right.stl",
    "bottom": "urchin_hp_bottom_right.stl",
    "shield": "urchin_hp_screenshield_right.stl",
}


def openscad():
    exe = shutil.which("openscad") or r"C:\Program Files\OpenSCAD\openscad.exe"
    if not os.path.exists(exe):
        sys.exit("openscad not found on PATH")
    return exe


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=os.path.join(REPO, "build"))
    ap.add_argument("--fused", action="store_true",
                    help="fuse the mountains into the top (skips mountains)")
    a = ap.parse_args()

    os.makedirs(a.out, exist_ok=True)
    exe = openscad()
    from stlstat import load_stl, volume

    print(f"{'part':>10} {'printed':>9} {'scad':>9} {'delta':>8}")
    for part in PARTS:
        if a.fused and part == "mountains":
            continue
        out = os.path.join(a.out, f"urchin_{part}.stl")
        cmd = [exe, "-D", f'part="{part}"',
               "-D", f"fuse_mountains={'true' if a.fused else 'false'}",
               "-o", out, SCAD]
        r = subprocess.run(cmd, capture_output=True, text=True)
        if r.returncode != 0:
            print(f"{part:>10}   FAILED\n{r.stderr.strip()[:400]}")
            continue
        b = volume(load_stl(out)) / 1000
        ref = os.path.join(REPO, "high-profile", "right", REF[part])
        # the fused top is top+mountains, so its reference comparison is moot
        if a.fused and part == "top":
            print(f"{part:>10} {'(fused)':>9} {b:9.4f} {'--':>8}")
        else:
            x = volume(load_stl(ref)) / 1000
            print(f"{part:>10} {x:9.4f} {b:9.4f} {(b - x) / x * 100:+7.2f}%")
    print(f"\n-> {a.out}")


if __name__ == "__main__":
    main()
