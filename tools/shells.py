"""Report each connected shell of an STL separately: bbox, volume, triangles."""
import sys
import numpy as np
sys.path.insert(0, r"C:\Repos\urchin-cases\tools")
from stlstat import load_stl, volume

path = sys.argv[1]
t = load_stl(path)
tol = 1e-4
q = np.round(t.reshape(-1, 3) / tol).astype(np.int64)
_, idx = np.unique(q, axis=0, return_inverse=True)
idx = idx.reshape(-1, 3)

parent = np.arange(idx.max() + 1)


def find(x):
    while parent[x] != x:
        parent[x] = parent[parent[x]]
        x = parent[x]
    return x


for tri in idx:
    r = [find(int(v)) for v in tri]
    for s in r[1:]:
        if s != r[0]:
            parent[s] = r[0]

label = np.array([find(int(v)) for v in idx[:, 0]])
print(f"{path.replace(chr(92), '/').split('/')[-1]}\n")
for k in np.unique(label):
    sub = t[label == k]
    lo, hi = sub.reshape(-1, 3).min(0), sub.reshape(-1, 3).max(0)
    print(f"  shell: {len(sub):6d} tris  vol {volume(sub)/1000:7.4f} cm3")
    print(f"    x {lo[0]:8.3f} -> {hi[0]:8.3f}   y {lo[1]:8.3f} -> {hi[1]:8.3f}"
          f"   z {lo[2]:7.3f} -> {hi[2]:7.3f}")
