# Localización de una planta agroindustrial frente al Superniño: AHP con SQL

## Relación con los módulos anteriores

Este trabajo es la continuación del Módulo 1. Toma la decisión siguiente del proyecto final, usa los datos calculados en el Módulo 3 y la resuelve con una herramienta nueva: el lenguaje SQL.


**Módulo 1: toma de decisiones.** Con el proceso analítico jerárquico (AHP) se eligió el tema del proyecto final entre tres alternativas. Ganó la *planificación de la producción y el pronóstico de demanda en agroindustria bajo la variabilidad climática del Superniño*. Los cálculos se hicieron con una calculadora web (AHP-OS) y todas las prioridades salieron de juicios del grupo.

**Módulo 3: sistemas de información geográfica.** En QGIS se estimó el empleo de cada parque industrial de Mendoza (CEP XXI 2022) y se analizó el riesgo hídrico asociado a El Niño. Con un modelo digital de elevación se calculó el índice HAND y la superficie inundable en un año Niño, y se cruzó con los parques. El Módulo 3 concluyó que convenía orientar las plantas nuevas hacia parques de baja exposición.

**Este módulo: lenguaje SQL.** Con el tema ya elegido, la siguiente decisión del proyecto corresponde al capítulo IV del Manual de proyectos (tamaño y localización): *en qué parque industrial ubicar la planta agroindustrial*. Se vuelve a usar el AHP del Módulo 1, con dos diferencias:

- **Los datos de las alternativas no son juicios, son los resultados del Módulo 3.** La superficie inundable en año Niño, los puestos de trabajo y la ocupación de cada parque se cargaron en tablas, junto con la superficie de vid de cada departamento (INV). SQL los convierte a la escala de Saaty. Solo la logística, que no tiene un dato único, se evaluó por comparación de a pares.
- **Todo el cálculo se hace en SQL, sobre una base SQLite.** Juicios, datos y fuentes quedan guardados en tablas normalizadas. Los pesos, la razón de consistencia, las prioridades, el ranking y el análisis de sensibilidad son vistas que se recalculan solas al cambiar un juicio o un dato. Así se reemplaza la calculadora web del Módulo 1.

El resultado también cierra el circuito con el Módulo 3: el parque ganador, PASIP Palmira, es uno de los de baja exposición hídrica que ese módulo recomendaba.

## Resultado

| Posición | Parque | Puntaje |
|---|---|---|
| 1 | PASIP Palmira (San Martín) | 31,6 % |
| 2 | AI Acceso Sur (Luján de Cuyo) | 25,3 % |
| 3 | PI Provincial (Luján de Cuyo) | 19,7 % |
| 4 | PI Los Barriales (Junín) | 16,6 % |
| 5 | ZI San Roque (Junín) | 6,7 % |

Criterios y pesos: riesgo hídrico en año Niño 42,1 %, cercanía a la materia prima 26,6 %, acceso logístico 14,9 %, suelo disponible 8,6 %, mano de obra 7,8 % (CR = 0,8 %).

El análisis de sensibilidad muestra que la decisión queda entre dos finalistas: PASIP gana en 3 de 6 escenarios de pesos y AI Acceso Sur en los otros 3. La elección final entre ambos se deja para el estudio de costos (capítulos V y VI del Manual).

## Archivos
[`informe_localizacion_SQL.pdf`] 



## Fuentes de datos

- Informe del Módulo 3 (SIG): empleo CEP XXI 2022 y exposición hídrica (HAND).
- INV: superficie de vid por departamento, Mendoza 2018.

