"""Mediciones de calidad de las fotos (Informe 4). Uso: python mediciones.py  (con foto1.jpg ... foto5.jpg en la carpeta).
Requiere opencv-python, numpy, scipy."""
import cv2, numpy as np, hashlib
from scipy.ndimage import binary_fill_holes

def pieza(im):
    g = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
    m = (g < 105).astype(np.uint8)
    m = cv2.morphologyEx(m, cv2.MORPH_OPEN, np.ones((5, 5), np.uint8))
    m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((9, 9), np.uint8))
    n, lab, st, _ = cv2.connectedComponentsWithStats(m)
    cand = [k for k in range(1, n) if st[k][3] > 600]          # región alargada (pieza completa)
    if not cand: return None
    k = max(cand, key=lambda k: st[k][4])
    mm = binary_fill_holes(lab == k)
    # recorta la parte que se une con el piso/borde de la mesa: filas con ancho anómalo
    w = mm.sum(1); med = np.median(w[w > 0]); mm[w > 2.2 * med] = False
    return mm

for i in range(1, 6):
    f = f'foto{i}.jpg'; im = cv2.imread(f); h, wd = im.shape[:2]
    g = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
    lab = cv2.cvtColor(im, cv2.COLOR_BGR2LAB).astype(float)
    L, A, B = lab[..., 0] * 100 / 255, lab[..., 1] - 128, lab[..., 2] - 128
    hsv = cv2.cvtColor(im, cv2.COLOR_BGR2HSV)
    bg = (hsv[..., 2] > 150) & (hsv[..., 1] < 40)               # fondo: claro y poco saturado
    celdas = []
    for r in range(4):
        for c in range(4):
            sl = (slice(r * h // 4, (r + 1) * h // 4), slice(c * wd // 4, (c + 1) * wd // 4))
            if bg[sl].mean() > 0.3: celdas.append(L[sl][bg[sl]].mean())
    p = pieza(im) if i in (1, 4, 5) else None                   # 2 y 3 son tomas de detalle
    print(f"Foto {i}: {wd}x{h} px | SHA-256 {hashlib.sha256(open(f,'rb').read()).hexdigest()[:16]} | "
          f"nitidez {cv2.Laplacian(g, cv2.CV_64F).var():.0f} | L* fondo {L[bg].mean():.0f} | "
          f"a* {A[bg].mean():+.1f} b* {B[bg].mean():+.1f} | dL* fondo {max(celdas)-min(celdas):.0f} | "
          f"p1-p99 {np.percentile(g,1):.0f}-{np.percentile(g,99):.0f} | saturados {(g>245).mean()*100:.2f} % | "
          f"fondo {bg.mean()*100:.0f} % | ocupacion {'detalle' if p is None else f'{p.mean()*100:.1f} %'}")
