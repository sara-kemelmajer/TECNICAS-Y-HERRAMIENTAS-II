# Módulo 3: Geomática y Sistemas de Información Geográfica

**Técnicas y Herramientas Modernas II · Ingeniería Industrial**

## Descripción del proyecto

En este módulo se procesaron datos geográficos y alfanuméricos con **QGIS**. El objetivo fue usar el análisis espacial para **tomar decisiones territoriales, logísticas y de riesgo** en Mendoza.


| Actividad | Tema | Mapa web |
|---|---|---|
| 1 | Mapa de **empleo industrial** real por parque y por departamento | [`Actividad 1/web/index.html`](Mapa1.html) |
| 2 | Comparación de la **superficie nevada** 2024 vs. 2026 en la cordillera de Mendoza (Sentinel‑2) | [`Actividad 2/web/index.html`](Mapa2.html) |
| 3 | Propuesta: **riesgo hídrico y El Niño** en el Gran Mendoza | [`Actividad 3/web/index.html`](Mapa3.html) |

---


## Actividad 1: Mapa web de empleo industrial

En clase se digitalizaron los parques y zonas industriales sobre un mapa ráster georreferenciado, con valores de superficie y empleo **supuestos**. En esta versión esos valores se reemplazaron por **datos reales**.

### Datos
* **CEP XXI, Ministerio de Economía:** 29.683 establecimientos empleadores de Mendoza en 2022, con latitud/longitud, rubro (CLAE) y rango de empleo.
* **Puestos asalariados privados registrados por departamento:** 2021 y 2022, valores exactos.
* Límites departamentales del IGN, polígonos de clase y polígonos COGAR.

### Metodología
1. **Edición de geometrías.** Se agregaron 7 parques que faltaban y se corrigieron 3 polígonos que estaban corridos entre 2 y 4 km. La superficie se recalculó con `$area / 10000`.
2. **Estimación del empleo.** A cada establecimiento se le asignó el punto medio de su rango de empleo. Luego se calibró por departamento para que el total coincida con el empleo oficial: `k = empleo_oficial / Σ puntos_medios`.
3. **Unión espacial.** Cada establecimiento industrial o logístico se asignó al **parque más cercano a 2 km o menos**.
4. **Demanda laboral.** Se calcularon los puestos netos creados entre 2021 y 2022 y los rubros que más crecieron en cada departamento.

### Resultados
* Se relevaron **3.074 establecimientos** y unos **37.000 puestos** industriales y logísticos alrededor de 17 parques y zonas.
* La **Zona Industrial Rodríguez Peña** concentra unos 21.300 puestos (58 %) y el **Acceso Sur** unos 7.200.
* Los parques nuevos del Este (PASIP, Los Barriales, Santa Rosa) tienen poco empleo registrado: son suelo industrial disponible.

### Mapa web
Permite conmutar estas capas:
* empleo por departamento;
* variación 2021‑22;
* parques coloreados por puestos estimados;
* establecimientos individuales;
* área de influencia de 2 km;
* el ráster original de la clase.

---

## Actividad 2: Superficie nevada en la cordillera de Mendoza (2024 vs. 2026)

Monitoreo de la cobertura nival con imágenes **Sentinel‑2 L2A** (Copernicus) a fines del invierno: **11/09/2024** (hace dos años) y **16/09/2026** (imagen actual).

Las escenas cubren el sector **Volcán Maipo – Laguna del Diamante** (San Carlos), unos 25 km al norte del Valle de las Lágrimas. Se descartaron las zonas que no aparecen en ambas fechas y se comparó solo el **área común: 11.792 km²**.

### Metodología
1. **Gestión ráster.** Importación de las bandas B03 (verde) y B08 (infrarrojo cercano) y de la imagen en color verdadero de cada fecha.
2. **Proyección.** Todo se trabaja en **EPSG:32719, WGS 84 / UTM 19S**, para medir en metros sin distorsión.
3. **Índice de nieve.** El navegador de Copernicus no ofrecía la banda SWIR B11, así que no se pudo usar el NDSI. Se usó un índice visible/NIR: `IVN = (B03 − B08) / (B03 + B08)`. Un píxel es nieve si `IVN > −0,10` y `B03 > 0,18`. Los umbrales se fijaron en el valle del histograma bimodal y se clasifica en la *Calculadora ráster*.
4. **Vectorización.** `Ráster ▸ Conversión ▸ Poligonizar`. Se eliminan manchas menores a 0,5 ha.
5. **Superficie.** Se calcula con la *Calculadora de campos*, `$area / 10000`, en hectáreas.
6. **Mapa de cambio.** Cada zona se clasifica como nieve persistente, ganancia o pérdida.

### Resultados

| Período | Superficie nevada | % del área común |
|---|---|---|
| 11/09/2024 | 634.072 ha | 53,8 % |
| 16/09/2026 | 734.646 ha | 62,3 % |
| **Diferencia** | **+100.573 ha (+15,9 %)** | +8,5 p.p. |

* La ganancia (~106.800 ha) se concentra en el **borde oriental** y en los fondos de valle: la línea de nieve bajó en 2026. La pérdida es mínima (~8.300 ha).

---

## Actividad 3 (propuesta): Riesgo hídrico y El Niño en el Gran Mendoza

¿Qué parte del territorio y de la infraestructura industrial está expuesta al agua, y cuánto cambia esa exposición en un **año Niño**?

### Datos
* **MDE Copernicus GLO‑30** (OpenTopography): 7.466 km² del Gran Mendoza.
* **NASA POWER:** precipitación mensual de 1981 a 2025 en el Gran Mendoza y en el Valle de las Lágrimas.
* **NOAA‑CPC RONI:** índice oficial de El Niño, usado para clasificar cada año como Niño, Niña o neutral.
* Parques de la Actividad 1.

### Metodología
1. **Hidrología D8.** Relleno de depresiones, dirección y acumulación de flujo, red de drenaje con orden de Strahler y 30 **cuencas aluvionales** del piedemonte.
2. **HAND** (*Height Above Nearest Drainage*): altura de cada punto sobre el cauce al que drena.
3. **Peligro hídrico (1 a 5).** Es el máximo entre dos componentes:
   * **aluvional:** pendiente, área de aporte y HAND en el piedemonte;
   * **crecida fluvial:** HAND respecto de ríos y colectores.
4. **Escenarios.** Año normal con HAND ≤ 1,5 m y año Niño con HAND ≤ 3 m.
5. **Exposición.** Intersección con los parques industriales, las líneas de alta tensión y los departamentos.

### Resultados
* En el llano, El Niño **no cambia la lluvia de verano**: r = 0,00.
* En la cordillera, El Niño **aumenta un 22 % la precipitación invernal**: r = 0,40, p = 0,007. En Mendoza el riesgo de El Niño es sobre todo **nival y fluvial**.
* La superficie potencialmente inundable pasa de **258 km² a 425 km²** (+64 %).
* Cinco parques, que reúnen unos **30.600 puestos** (83 % del empleo industrial estimado), tienen exposición media o alta: San Roque, PIMEN, PIP, Acceso Sur y Rodríguez Peña.
* Las líneas de AT más expuestas son *Cruz de Piedra – Cañada Honda* y *Gran Mendoza – San Juan* (500 kV).

---

## Descargas

* [Paquete Actividad 1 (.zip)](Actividad1.zip)
* [Paquete Actividad 2 (.zip)](Actividad2.zip)
* [Paquete Actividad 3 (.zip)](Actividad3.zip)
* [Informe (PDF / LaTeX)](InformeMódulo3.pdf)


## Fuentes

CEP XXI – datos.gob.ar · Los Andes (2018, 2022) · Copernicus Sentinel‑2 / Copernicus Data Space · Copernicus DEM GLO‑30 / OpenTopography · NASA POWER · NOAA Climate Prediction Center (RONI) · IGN · Masiokas et al. (2006) · Nobre et al. (2011) · Hall et al. (1995).
