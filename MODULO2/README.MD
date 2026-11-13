# MÓDULO 2
## Asistente de Redacción con IA para planes y proyectos - Taller complementario fotografía forense digital

El módulo tiene cuatro informes, encadenados de a dos: el informe 1 dio la metodología con la que se hizo el 2, y el informe 3 dio el material que se evaluó en el 4.

## Cómo se hizo cada informe

### Informe 1: Asistencia de la IA en la redacción de planes y proyectos
- Se investigó cómo funcionan los modelos de lenguaje y en qué etapas de la redacción de un plan aportan más.
- De ahí salieron dos herramientas para usar después: una **tabla con el nivel de revisión que necesita cada sección** de un plan y una **metodología de cinco pasos** (definir el contexto, aportar datos propios, pedir por partes, revisar críticamente e iterar).

### Informe 2: Planificación de la producción ante el Superniño
- Se aplicó la **metodología de cinco pasos del informe 1** a un capítulo del proyecto final:
  1. **Contexto:** se definió el tipo de documento, el destinatario, el formato y el tono en una instrucción inicial (incluida en el informe).
  2. **Datos propios:** se usaron los resultados de módulos anteriores: el tema elegido en el Módulo 1, el riesgo hídrico del Módulo 3 (SIG) y la localización de la planta decidida en la continuación con SQL.
  3. **Por partes:** se redactó una sección por vez siguiendo la estructura estándar de un plan del informe 1 (diagnóstico, objetivos SMART, alcance, plan, cronograma, presupuesto y riesgos).
  4. **Revisión crítica:** cada cifra se verificó contra su fuente (INV, NOAA, SMN) y se dejó un registro de verificación. Lo que no tiene fuente se marcó como supuesto.
  5. **Iteración:** se corrigieron secciones puntuales; al agregar un supuesto cambió el escenario crítico.
- Se respetó la regla del informe 1 de **no poner valores de presupuesto sin fuente**: solo se armó la estructura.
- **Alcance del informe 2:** todavía no contamos con los datos reales de la planta, así que este informe es un **ejercicio preliminar** y no el informe definitivo del proyecto final.
  - El **diagnóstico** (Superniño, antecedente de 2016, vendimia 2026) se hizo con datos reales verificados.
  - El **plan de producción** usa **supuestos** del equipo (volumen, capacidad, distribución semanal), identificados como tales.
  - El informe definitivo del proyecto final se podría hacer siguiendo los mismos pasos, reemplazando los supuestos por datos reales.

- **Organización del informe 2:** el plan propiamente dicho está en las **secciones 3 a 9** (diagnóstico, objetivos, alcance, plan de producción, cronograma, presupuesto y riesgos). Las secciones 2 (metodología de redacción con IA) y 10 (revisión crítica y verificación de datos) documentan cómo se elaboró el plan con asistencia de IA. El resumen, la introducción y las conclusiones abarcan ambos aspectos. 


### Informe 3: Taller de fotografía forense digital
- Se fotografió la pieza con el protocolo forense **de lo general a lo particular**, sin limpiarla ni modificarla, sobre fondo neutro.
- Cada foto se numeró y se describió qué evidencia documenta.
- Se interpretaron las evidencias para identificar el mecanismo de falla y descartar los demás.

### Informe 4: Calidad de las fotografías
- Se tomaron las fotos del informe 3 y se evaluaron con los criterios que pide una **publicación científica**: exposición, luz, balance de blancos, nitidez, encuadre, fondo, perspectiva, escala, resolución e integridad.
- Se midió cada criterio sobre los píxeles cuando fue posible (Python/OpenCV) y se separó lo que está bien de lo que hay que mejorar.
- Se mostró qué ajustes están permitidos para publicar (solo ajustes globales, declarados y conservando el original) y se propuso un protocolo de toma.

## Indicaciones de la clase aplicadas a los informes;

- **Captions de las fotos abajo** y **captions de las tablas arriba**.
- **Cabecera en el margen interno** (cerca del cosido) y número de página en el margen externo (en informes 2 y 4)
- **Tabla con muchas columnas y filas en página horizontal** (rotada) en el informe 4 (`pdflscape`).
- **Abstract** de extensión acotada, con palabras clave.

## Herramientas

LaTeX (Overleaf), Python (OpenCV, NumPy, Matplotlib) e IA generativa como asistente de redacción y programación, con revisión del equipo.
