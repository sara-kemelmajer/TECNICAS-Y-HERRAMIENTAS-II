"""Figuras del Informe 4 (calidad fotográfica). Requiere opencv-python, numpy, matplotlib."""
import cv2,numpy as np,matplotlib
matplotlib.use('Agg'); import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
plt.rcParams.update({'font.family':'serif','font.size':8})
ORANGE='#eb6834'; BLUE='#2a78d6'
def rgb(f): return cv2.cvtColor(cv2.imread(f),cv2.COLOR_BGR2RGB)
# --- Figura: problemas señalados
notes={1:[((0,250,70,330),'1 objeto ajeno (bolso)'),((0,1330,560,270),'2 borde de mesa y piso'),((60,560,300,300),'3 marcas de lápiz'),((330,60,250,1500),'4 pieza en vertical: ocupa\n   ~6 % del área')],
       3:[((0,1420,140,180),'1 mano en cuadro'),((0,600,260,330),'2 reflejo y sombra en el fondo'),((380,740,180,180),'3 desenfoque (detalle)'),((0,0,900,560),'4 fondo vacío')]}
fig,axs=plt.subplots(1,2,figsize=(6.4,5.2))
for ax,i in zip(axs,[1,3]):
    ax.imshow(rgb(f'foto{i}.jpg'))
    for (x,y,w,h),t in notes[i]:
        ax.add_patch(Rectangle((x,y),w,h,fill=False,ec=ORANGE,lw=1.4,ls='--'))
        ax.text(x+8,y+40,t.split()[0],color='white',fontsize=9,weight='bold',bbox=dict(fc=ORANGE,ec='none',pad=1.5))
    ax.set_title(f'Foto {i}'); ax.axis('off')
    ax.text(0,1.0,'',transform=ax.transAxes)
    leg='\n'.join(t for _,t in notes[i])
    ax.text(0,-0.02,leg,transform=ax.transAxes,va='top',fontsize=7.5)
plt.tight_layout(); plt.savefig('problemas.pdf',bbox_inches='tight'); plt.savefig('problemas.png',dpi=90,bbox_inches='tight')
# --- Figura: antes / después (solo ajustes globales)
im=cv2.imread('foto1.jpg').astype(float)
hsv=cv2.cvtColor(im.astype(np.uint8),cv2.COLOR_BGR2HSV); bg=(hsv[...,2]>150)&(hsv[...,1]<40)
ref=im[bg].mean(0); gain=235/ref                      # balance de blancos y niveles: fondo -> blanco neutro
out=np.clip(im*gain,0,255).astype(np.uint8)
out=cv2.rotate(out,cv2.ROTATE_90_COUNTERCLOCKWISE)    # pieza en horizontal
out=out[250:700, 60:1440]                     # recorte: ojo, coordenadas tras rotar
fig=plt.figure(figsize=(6.4,3.0))
a1=fig.add_axes([0,0.02,0.2,0.9]); a1.imshow(rgb('foto1.jpg')); a1.axis('off'); a1.set_title('(a) Original',fontsize=8)
a2=fig.add_axes([0.23,0.25,0.77,0.6]); a2.imshow(cv2.cvtColor(out,cv2.COLOR_BGR2RGB)); a2.axis('off'); a2.set_title('(b) Preparada: rotación, recorte, balance de blancos y niveles',fontsize=8)
plt.savefig('antes_despues.pdf',bbox_inches='tight'); plt.savefig('antes_despues.png',dpi=90,bbox_inches='tight')
print(gain, out.shape)
