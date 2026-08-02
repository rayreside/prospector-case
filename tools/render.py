"""Render the model and the printed part from the canonical viewpoint.

The numbers in this repo will tell you a part is 0.04% off and not that its
keep-out is the wrong shape. Two 0.5 mm2 slivers pass every threshold worth
setting; the same defect is unmissable in a picture. Look at the part.

CANONICAL VIEWPOINT: top down, facing the keys, thumb cluster at the BOTTOM
LEFT. That is +x to the LEFT and +y DOWN, which is OpenSCAD's default view
turned 180 degrees about Z -- hence the rz=180 in the camera below. Renders
straight out of the OpenSCAD GUI are upside down relative to it. Unqualified
"up/down/left/right" in this repo always means this view.

    python tools/render.py mountains
    python tools/render.py mountains --at 147.575 34.495 --dist 22

Writes <part>.png (the model) and <part>_ref.png (the printed part) from the
same camera, so they can be flicked between. Needs openscad on PATH or at the
default Windows install location.
"""
import argparse
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
SCAD = os.path.join(REPO, "scad", "urchin.scad")
REF = {
    "top": "urchin_hp_top_right.stl",
    "mountains": "urchin_hp_mountains_right.stl",
    "bottom": "urchin_hp_bottom_right.stl",
    "shield": "urchin_hp_screenshield_right.stl",
}


def openscad():
    exe = shutil.which("openscad")
    if exe:
        return exe
    fallback = r"C:\Program Files\OpenSCAD\openscad.exe"
    if os.path.exists(fallback):
        return fallback
    sys.exit("openscad not found on PATH")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("part", choices=list(REF) + ["all"])
    ap.add_argument("--at", nargs="+", type=float, metavar="C",
                    help="centre the view here: X Y [Z]")
    ap.add_argument("--dist", type=float, help="smaller is closer; omit to fit")
    ap.add_argument("--size", type=int, default=1600)
    ap.add_argument("--cut", choices=["x", "y", "z"],
                    help="section the model on this axis and look inside")
    ap.add_argument("--cut-at", type=float, help="where the plane sits")
    ap.add_argument("--cut-flip", action="store_true", help="keep the other half")
    ap.add_argument("--edges", action="store_true",
                    help="draw facet edges; makes flat faces readable")
    # Off by default: in a flat top-down render the ghost is the same flat
    # colour as the model, so overlaying them makes the image ambiguous rather
    # than informative. Flicking between the two output files is clearer.
    ap.add_argument("--ghost", action="store_true",
                    help="draw the printed part underneath the model")
    ap.add_argument("--out", default=".")
    a = ap.parse_args()

    # A section has to be looked at side-on. Viewed from straight above, the cut
    # face is edge-on and you see nothing -- which is exactly what happens if
    # the canonical top-down camera is left in place.
    if a.cut == "y":
        rot = "90,0,0" if a.cut_flip else "90,0,180"
    elif a.cut == "x":
        rot = "90,0,90" if a.cut_flip else "90,0,270"
    else:
        rot = "0,0,180"                       # canonical top-down
    if a.at and a.dist:
        at = list(a.at) + [6.0] * (3 - len(a.at))
        cam = f"--camera={at[0]},{at[1]},{at[2]},{rot},{a.dist}"
        fit = []
    else:
        cam = f"--camera=0,0,0,{rot},0"
        fit = ["--viewall", "--autocenter"]

    common = [cam, *fit, "--projection=o",
              f"--imgsize={a.size},{int(a.size * 0.82)}",
              "--colorscheme=Tomorrow"]
    if a.edges or a.cut:
        # a section is unreadable without them: every cut face is flat
        common += ["--render", "--view=edges"]

    cutargs = []
    if a.cut:
        cutargs = ["-D", f'cut="{a.cut}"']
        if a.cut_at is not None:
            cutargs += ["-D", f"cut_at={a.cut_at}"]
        if a.cut_flip:
            cutargs += ["-D", "cut_flip=true"]
    exe = openscad()
    os.makedirs(a.out, exist_ok=True)

    model = os.path.join(a.out, f"{a.part}.png")
    cmd = [exe, *common, *cutargs, "-D", f'part="{a.part}"']
    if a.part == "mountains":
        # they vanish into the top when fused, which is not what you want to see
        cmd += ["-D", "fuse_mountains=false"]
    if a.ghost:
        cmd += ["-D", "show_ref=true"]
    subprocess.run(cmd + ["-o", model, SCAD], check=True)
    print(f"model  -> {model}")

    if a.part != "all":
        stl = os.path.join(REPO, "high-profile", "right", REF[a.part])
        tmp = os.path.join(a.out, "_ref.scad")
        body = f'import("{stl.replace(chr(92), "/")}");'
        if a.cut:
            # section the reference the same way, or the comparison is useless
            at = a.cut_at if a.cut_at is not None else 0
            B, o = 500, (-500 if a.cut_flip else 0)
            box = {
                "x": f"translate([{at + o},-250,-250])",
                "y": f"translate([-250,{at + o},-250])",
                "z": f"translate([-250,-250,{at + o}])",
            }[a.cut]
            body = f"difference() {{ {body} {box} cube({B}); }}"
        with open(tmp, "w") as f:
            f.write(body + "\n")
        ref = os.path.join(a.out, f"{a.part}_ref.png")
        subprocess.run([exe, *common, "-o", ref, tmp], check=True)
        os.remove(tmp)
        print(f"printed-> {ref}")


if __name__ == "__main__":
    main()
