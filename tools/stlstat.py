"""Measure STL meshes: bbox, volume, triangle count, connected components,
and edge-manifoldness. Pure numpy, handles both ASCII and binary STL."""
import sys, struct, re
import numpy as np


def load_stl(path):
    data = open(path, 'rb').read()
    # Binary STL: 80-byte header + uint32 count + 50 bytes per triangle
    if len(data) >= 84:
        n = struct.unpack('<I', data[80:84])[0]
        if len(data) == 84 + 50 * n:
            tris = np.frombuffer(data, dtype=np.uint8, count=50 * n, offset=84)
            tris = tris.reshape(n, 50)[:, 12:48].copy()
            return tris.view('<f4').reshape(n, 3, 3).astype(np.float64)
    # ASCII fallback
    txt = data.decode('utf-8', 'replace')
    v = re.findall(r'vertex\s+(\S+)\s+(\S+)\s+(\S+)', txt)
    return np.array(v, dtype=np.float64).reshape(-1, 3, 3)


def volume(t):
    # signed tetrahedron sum (divergence theorem)
    a, b, c = t[:, 0], t[:, 1], t[:, 2]
    return float(np.einsum('ij,ij->i', a, np.cross(b, c)).sum() / 6.0)


def components_and_manifold(t, tol=1e-5):
    """Weld vertices on a grid, then union-find over triangles.
    Also counts how many edges are not shared by exactly 2 triangles."""
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
    roots = {find(int(v)) for v in idx.reshape(-1)}

    # edge manifoldness
    e = np.concatenate([idx[:, [0, 1]], idx[:, [1, 2]], idx[:, [2, 0]]])
    e = np.sort(e, axis=1)
    _, counts = np.unique(e, axis=0, return_counts=True)
    return len(roots), int((counts != 2).sum()), int((counts == 1).sum())


def report(path):
    t = load_stl(path)
    lo, hi = t.reshape(-1, 3).min(0), t.reshape(-1, 3).max(0)
    ncomp, nonman, boundary = components_and_manifold(t)
    name = path.replace('\\', '/').split('/')[-1]
    print(f"{name}")
    print(f"  triangles : {len(t)}")
    print(f"  bbox min  : {lo[0]:10.3f} {lo[1]:10.3f} {lo[2]:10.3f}")
    print(f"  bbox max  : {hi[0]:10.3f} {hi[1]:10.3f} {hi[2]:10.3f}")
    print(f"  size      : {hi[0]-lo[0]:10.3f} {hi[1]-lo[1]:10.3f} {hi[2]-lo[2]:10.3f}")
    print(f"  volume    : {volume(t)/1000.0:.4f} cm3")
    print(f"  shells    : {ncomp}   non-2-manifold edges: {nonman}  boundary edges: {boundary}")
    print()


if __name__ == "__main__":
    for p in sys.argv[1:]:
        report(p)
