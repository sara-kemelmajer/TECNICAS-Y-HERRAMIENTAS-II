"""Plan agregado de recepción de uva - vendimia 2027 (Informe 2).
Todos los parámetros de la planta son SUPUESTOS del equipo (ver Tabla de supuestos del informe).
Los factores de caída de volumen se basan en datos del INV (2015-2016)."""
import numpy as np, matplotlib
matplotlib.use('Agg'); import matplotlib.pyplot as plt
plt.rcParams.update({'font.family':'serif','font.size':8})
V_NORMAL=12000            # t contratadas en año normal (supuesto)
CAP=320*6                 # t/semana: 320 t/día x 6 días (supuesto)
CAP_SEL=CAP*0.85          # capacidad efectiva con mesa de selección por sanidad (-15 %, supuesto)
caida_2016=1-9244773/16810000   # Mendoza 2016 vs 2015 (INV)
esc={'Normal':        dict(caida=0.0, w=[3,7,11,14,16,15,13,10,7,4], sel=False),
     'Niño moderado': dict(caida=0.20,w=[4,9,15,19,20,16,11,6],     sel=True),
     'Superniño (como 2016)': dict(caida=round(caida_2016,2), w=[6,12,18,22,20,14,8], sel=True)}
rows=[]
for k,e in esc.items():
    V=V_NORMAL*(1-e['caida']); w=np.array(e['w'])/100; sem=V*w
    cap=CAP_SEL if e['sel'] else CAP
    e.update(V=V,sem=sem,cap=cap)
    rows.append((k,e['caida']*100,V,len(w),sem.max(),cap,sem.max()/cap*100,max(0,sem.max()-cap),sem.sum()/(cap*len(w))*100))
    print(f"{k:24s} caida {e['caida']*100:4.0f}% V={V:7.0f} t sem={len(w)} pico={sem.max():6.0f} cap={cap:6.0f} uso_pico={sem.max()/cap*100:5.1f}% exceso={max(0,sem.max()-cap):5.0f} uso_medio={sem.sum()/(cap*len(w))*100:5.1f}%")
    print('   semanas:',np.round(sem).astype(int).tolist())
print('caida 2016 Mendoza:',round(caida_2016*100,1))
# figura
C=['#2a78d6','#eb6834','#1baf7a']
fig,ax=plt.subplots(figsize=(6.0,2.8))
for (k,e),c,m in zip(esc.items(),C,['o','s','^']):
    x=np.arange(1,len(e['sem'])+1); ax.plot(x,e['sem'],color=c,lw=2,marker=m,ms=4,label=f"{k}: {e['V']:,.0f} t".replace(',','.'))
ax.axhline(CAP,color='#52514e',lw=1,ls='--'); ax.text(10.1,CAP+30,'capacidad nominal',va='bottom',fontsize=7,color='#52514e')
ax.axhline(CAP_SEL,color='#52514e',lw=1,ls=':'); ax.text(10.1,CAP_SEL-30,'capacidad con\nselección',va='top',fontsize=7,color='#52514e')
ax.set_xlabel('Semana de vendimia (desde mediados de febrero)'); ax.set_ylabel('Uva recibida (t/semana)')
ax.set_xticks(range(1,11)); ax.set_xlim(0.6,11.6); ax.set_ylim(0,2600)
for s in ['top','right']: ax.spines[s].set_visible(False)
ax.grid(axis='y',color='#e5e5e2',lw=0.6); ax.legend(frameon=False,fontsize=7,loc='upper left',ncol=3,bbox_to_anchor=(0,1.06))
plt.tight_layout(); plt.savefig('recepcion_semanal.pdf',bbox_inches='tight'); plt.savefig('recepcion_semanal.png',dpi=110,bbox_inches='tight')
