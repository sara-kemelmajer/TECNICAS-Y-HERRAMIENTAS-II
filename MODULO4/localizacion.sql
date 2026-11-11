-- =====================================================================
--  Localización de una planta agroindustrial frente al Superniño
--  AHP (proceso analítico jerárquico) resuelto con SQL (SQLite >= 3.25)
--  Técnicas y Herramientas Modernas II - Continuación del Módulo 1
--  Kemelmajer, Martinez, Mujica, Salamone - FING UNCuyo - 2026
--
--  Cómo usarlo en DB Browser for SQLite:
--    1. Nueva base de datos -> guardar como localizacion.db
--    2. Pestaña "Ejecutar SQL" -> abrir este archivo -> Ejecutar todo (F5)
--    3. Pestaña "Hoja de datos" -> elegir una vista (v_...) para ver resultados
--  Para probar otros juicios: editar los INSERT de la sección 2 y volver a ejecutar.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. LIMPIEZA (permite ejecutar el script las veces que se quiera)
-- ---------------------------------------------------------------------
DROP VIEW IF EXISTS v_peso_critico;
DROP VIEW IF EXISTS v_escenarios_ganador;
DROP VIEW IF EXISTS v_escenarios;
DROP VIEW IF EXISTS v_ranking;
DROP VIEW IF EXISTS v_aporte;
DROP VIEW IF EXISTS v_prioridad_local;
DROP VIEW IF EXISTS v_escala;
DROP VIEW IF EXISTS v_valores;
DROP VIEW IF EXISTS v_consistencia_logistica;
DROP VIEW IF EXISTS v_prioridad_logistica;
DROP VIEW IF EXISTS v_matriz_logistica;
DROP VIEW IF EXISTS v_consistencia_criterios;
DROP VIEW IF EXISTS v_pesos_criterios;
DROP VIEW IF EXISTS v_matriz_criterios;
DROP TABLE IF EXISTS escenario_peso;
DROP TABLE IF EXISTS escenario;
DROP TABLE IF EXISTS comparacion_logistica;
DROP TABLE IF EXISTS comparacion_criterios;
DROP TABLE IF EXISTS indice_aleatorio;
DROP TABLE IF EXISTS criterio;
DROP TABLE IF EXISTS parque;
DROP TABLE IF EXISTS departamento;
DROP TABLE IF EXISTS fuente;

-- ---------------------------------------------------------------------
-- 1. ESTRUCTURA (tablas normalizadas)
-- ---------------------------------------------------------------------
CREATE TABLE fuente (
  id_fuente   INTEGER PRIMARY KEY,
  descripcion TEXT NOT NULL,
  referencia  TEXT
);

CREATE TABLE departamento (
  id_depto    INTEGER PRIMARY KEY,
  nombre      TEXT NOT NULL UNIQUE,
  vid_ha      REAL NOT NULL,             -- superficie de vid del departamento (ha)
  id_fuente   INTEGER REFERENCES fuente(id_fuente)
);

CREATE TABLE parque (                    -- alternativas de localización
  id_parque     INTEGER PRIMARY KEY,
  nombre        TEXT NOT NULL UNIQUE,
  id_depto      INTEGER NOT NULL REFERENCES departamento(id_depto),
  sup_ha        REAL NOT NULL,           -- superficie del parque (ha, SIG)
  estab         INTEGER NOT NULL,        -- establecimientos industriales y logísticos
  puestos       INTEGER NOT NULL,        -- puestos de trabajo estimados
  ha_inund_nino REAL NOT NULL,           -- ha inundables a <= 500 m, escenario Niño
  id_fuente     INTEGER REFERENCES fuente(id_fuente)
);

CREATE TABLE criterio (
  cod      TEXT PRIMARY KEY,
  nombre   TEXT NOT NULL,
  tipo     TEXT NOT NULL CHECK (tipo IN ('dato','juicio')),
  sentido  TEXT CHECK (sentido IN ('max','min')),   -- solo para criterios con dato
  unidad   TEXT
);

CREATE TABLE comparacion_criterios (     -- triángulo superior de la matriz de Saaty
  fila   TEXT NOT NULL REFERENCES criterio(cod),
  col    TEXT NOT NULL REFERENCES criterio(cod),
  valor  REAL NOT NULL CHECK (valor > 0),
  razon  TEXT,
  PRIMARY KEY (fila, col)
);

CREATE TABLE comparacion_logistica (     -- juicios de logística entre parques
  fila   INTEGER NOT NULL REFERENCES parque(id_parque),
  col    INTEGER NOT NULL REFERENCES parque(id_parque),
  valor  REAL NOT NULL CHECK (valor > 0),
  razon  TEXT,
  PRIMARY KEY (fila, col)
);

CREATE TABLE indice_aleatorio (          -- índice aleatorio (RI) de Saaty
  n  INTEGER PRIMARY KEY,
  ri REAL NOT NULL
);

CREATE TABLE escenario (                 -- escenarios de sensibilidad
  id_escenario INTEGER PRIMARY KEY,
  nombre       TEXT NOT NULL
);

CREATE TABLE escenario_peso (
  id_escenario INTEGER REFERENCES escenario(id_escenario),
  cod          TEXT REFERENCES criterio(cod),
  peso         REAL NOT NULL,
  PRIMARY KEY (id_escenario, cod)
);

-- ---------------------------------------------------------------------
-- 2. DATOS
-- ---------------------------------------------------------------------
INSERT INTO fuente VALUES
 (1, 'INV - Evolución de la superficie de vid por oasis, Mendoza (2018)',
     'https://www.argentina.gob.ar/sites/default/files/evolucion_de_superficie_x_oasis_mza_0.pdf'),
 (2, 'Módulo 3 SIG (Tablas 2 y 6): CEP XXI 2022, MDE Copernicus GLO-30, HAND',
     'Informe Módulo 3, TyHM II 2026');

INSERT INTO departamento VALUES
 (1, 'San Martín',    28423, 1),
 (2, 'Junín',         11477, 1),
 (3, 'Luján de Cuyo', 15543, 1);

INSERT INTO parque VALUES
 (1, 'PASIP Palmira',    1, 537,  53,  405,   0.0, 2),
 (2, 'ZI San Roque',     2, 305,  41,  347, 264.2, 2),
 (3, 'PI Provincial',    3, 494,  24, 1303,  76.3, 2),
 (4, 'AI Acceso Sur',    3, 444, 520, 7180,  42.6, 2),
 (5, 'PI Los Barriales', 2, 109,  12,   61,   0.0, 2);

INSERT INTO criterio VALUES
 ('R', 'Riesgo hídrico en año Niño',  'dato',   'min', 'ha inundables a <= 500 m'),
 ('P', 'Cercanía a la materia prima', 'dato',   'max', 'ha de vid del departamento'),
 ('L', 'Acceso logístico',            'juicio', NULL,  'comparación por pares'),
 ('S', 'Suelo disponible',            'dato',   'min', 'establecimientos por ha'),
 ('M', 'Mano de obra y ecosistema',   'dato',   'max', 'puestos en el parque');

INSERT INTO comparacion_criterios VALUES
 ('R','P', 2, 'El proyecto trata sobre el Superniño: una planta inundable invalida lo demás'),
 ('R','L', 3, 'La logística se compensa con transporte; una crecida no'),
 ('R','S', 4, 'El suelo se consigue; el riesgo no se elige'),
 ('R','M', 5, 'La mano de obra del oasis se traslada en distancias cortas'),
 ('P','L', 2, 'La uva es perecedera: conviene procesarla cerca de la finca'),
 ('P','S', 3, 'Sin materia prima cercana el suelo barato no sirve'),
 ('P','M', 4, 'Mismo motivo'),
 ('L','S', 2, 'Acceso a RN 7 y RN 40 para despachar a Chile y a Buenos Aires'),
 ('L','M', 2, 'Mismo motivo'),
 ('S','M', 1, 'Ambos son secundarios');

INSERT INTO comparacion_logistica VALUES
 (4,3, 2, 'Acceso Sur: sobre RN 40, junto al Gran Mendoza y a la RN 7'),
 (4,1, 2, 'Acceso Sur: sobre RN 40, junto al Gran Mendoza y a la RN 7'),
 (4,2, 5, 'San Roque queda lejos de las rutas troncales'),
 (4,5, 5, 'Los Barriales queda lejos de las rutas troncales'),
 (3,1, 1, 'PIP: RN 7 hacia Chile; PASIP: RN 7 hacia el este y nodo ferroviario de Palmira'),
 (3,2, 3, 'Mejor conexión troncal'),
 (3,5, 3, 'Mejor conexión troncal'),
 (1,2, 3, 'Mejor conexión troncal y ferrocarril'),
 (1,5, 3, 'Mejor conexión troncal y ferrocarril'),
 (2,5, 1, 'Ambos en Junín, accesos similares');

INSERT INTO indice_aleatorio VALUES
 (1,0),(2,0),(3,0.58),(4,0.90),(5,1.12),(6,1.24),(7,1.32),(8,1.41),(9,1.45),(10,1.49);

INSERT INTO escenario VALUES
 (1,'Base (AHP)'), (2,'Pesos iguales'), (3,'Riesgo bajo'),
 (4,'Logística alta'), (5,'Mano de obra alta'), (6,'Sin riesgo');

-- el escenario 1 toma los pesos calculados por el AHP (ver v_escenarios)
INSERT INTO escenario_peso VALUES
 (2,'R',0.20),(2,'P',0.20),(2,'L',0.20),(2,'S',0.20),(2,'M',0.20),
 (3,'R',0.20),(3,'P',0.30),(3,'L',0.25),(3,'S',0.15),(3,'M',0.10),
 (4,'R',0.25),(4,'P',0.20),(4,'L',0.40),(4,'S',0.075),(4,'M',0.075),
 (5,'R',0.25),(5,'P',0.20),(5,'L',0.15),(5,'S',0.10),(5,'M',0.30),
 (6,'R',0.00),(6,'P',0.40),(6,'L',0.30),(6,'S',0.15),(6,'M',0.15);

-- ---------------------------------------------------------------------
-- 3. CÁLCULO DEL AHP (vistas: se recalculan solas al cambiar los datos)
-- ---------------------------------------------------------------------

-- 3.1 Matriz completa de criterios: juicios + recíprocos + diagonal
CREATE VIEW v_matriz_criterios AS
  SELECT fila, col, valor FROM comparacion_criterios
  UNION ALL
  SELECT col, fila, 1.0 / valor FROM comparacion_criterios
  UNION ALL
  SELECT cod, cod, 1.0 FROM criterio;

-- 3.2 Pesos: normalizar cada columna y promediar cada fila
CREATE VIEW v_pesos_criterios AS
  WITH suma_col AS (
    SELECT col, SUM(valor) AS s FROM v_matriz_criterios GROUP BY col
  )
  SELECT m.fila AS cod, AVG(m.valor / sc.s) AS peso
  FROM v_matriz_criterios m JOIN suma_col sc ON sc.col = m.col
  GROUP BY m.fila;

-- 3.3 Consistencia: lambda max, CI = (lmax - n)/(n - 1), CR = CI / RI
CREATE VIEW v_consistencia_criterios AS
  WITH aw AS (
    SELECT m.fila, SUM(m.valor * p.peso) AS ws
    FROM v_matriz_criterios m JOIN v_pesos_criterios p ON p.cod = m.col
    GROUP BY m.fila
  ),
  lam AS (
    SELECT AVG(aw.ws / p.peso) AS lambda_max, COUNT(*) AS n
    FROM aw JOIN v_pesos_criterios p ON p.cod = aw.fila
  )
  SELECT n, lambda_max,
         (lambda_max - n) / (n - 1)        AS ci,
         ((lambda_max - n) / (n - 1)) / ri AS cr,
         CASE WHEN ((lambda_max - n) / (n - 1)) / ri < 0.10
              THEN 'Consistente' ELSE 'Revisar juicios' END AS estado
  FROM lam JOIN indice_aleatorio USING (n);

-- 3.4 Lo mismo para la matriz de logística (5 parques)
CREATE VIEW v_matriz_logistica AS
  SELECT fila, col, valor FROM comparacion_logistica
  UNION ALL
  SELECT col, fila, 1.0 / valor FROM comparacion_logistica
  UNION ALL
  SELECT id_parque, id_parque, 1.0 FROM parque;

CREATE VIEW v_prioridad_logistica AS
  WITH suma_col AS (
    SELECT col, SUM(valor) AS s FROM v_matriz_logistica GROUP BY col
  )
  SELECT m.fila AS id_parque, AVG(m.valor / sc.s) AS prioridad
  FROM v_matriz_logistica m JOIN suma_col sc ON sc.col = m.col
  GROUP BY m.fila;

CREATE VIEW v_consistencia_logistica AS
  WITH aw AS (
    SELECT m.fila, SUM(m.valor * p.prioridad) AS ws
    FROM v_matriz_logistica m JOIN v_prioridad_logistica p ON p.id_parque = m.col
    GROUP BY m.fila
  ),
  lam AS (
    SELECT AVG(aw.ws / p.prioridad) AS lambda_max, COUNT(*) AS n
    FROM aw JOIN v_prioridad_logistica p ON p.id_parque = aw.fila
  )
  SELECT n, lambda_max,
         (lambda_max - n) / (n - 1)        AS ci,
         ((lambda_max - n) / (n - 1)) / ri AS cr,
         CASE WHEN ((lambda_max - n) / (n - 1)) / ri < 0.10
              THEN 'Consistente' ELSE 'Revisar juicios' END AS estado
  FROM lam JOIN indice_aleatorio USING (n);

-- 3.5 Valores de cada parque en los criterios con dato (formato "largo")
CREATE VIEW v_valores AS
  SELECT id_parque, 'R' AS cod, ha_inund_nino AS valor FROM parque
  UNION ALL
  SELECT p.id_parque, 'P', d.vid_ha
  FROM parque p JOIN departamento d ON d.id_depto = p.id_depto
  UNION ALL
  SELECT id_parque, 'S', estab / sup_ha FROM parque
  UNION ALL
  SELECT id_parque, 'M', puestos FROM parque;

-- 3.6 Conversión lineal a la escala 1-9: el mejor recibe 9, el peor 1
CREATE VIEW v_escala AS
  WITH extremos AS (
    SELECT cod, MIN(valor) AS mn, MAX(valor) AS mx FROM v_valores GROUP BY cod
  )
  SELECT v.id_parque, v.cod, v.valor,
         1 + 8 * CASE c.sentido
                   WHEN 'max' THEN (v.valor - e.mn) / (e.mx - e.mn)
                   ELSE            (e.mx - v.valor) / (e.mx - e.mn)
                 END AS puntaje_1a9
  FROM v_valores v
  JOIN extremos e ON e.cod = v.cod
  JOIN criterio c ON c.cod = v.cod;

-- 3.7 Prioridad local de cada parque en cada criterio (suma 1 por criterio)
CREATE VIEW v_prioridad_local AS
  SELECT id_parque, cod,
         puntaje_1a9 / SUM(puntaje_1a9) OVER (PARTITION BY cod) AS prioridad
  FROM v_escala
  UNION ALL
  SELECT id_parque, 'L', prioridad FROM v_prioridad_logistica;

-- 3.8 Aporte de cada criterio al puntaje de cada parque (peso x prioridad local)
CREATE VIEW v_aporte AS
  SELECT p.nombre AS parque, l.cod, c.nombre AS criterio,
         w.peso, l.prioridad, w.peso * l.prioridad AS aporte
  FROM v_prioridad_local l
  JOIN v_pesos_criterios w ON w.cod = l.cod
  JOIN criterio c          ON c.cod = l.cod
  JOIN parque p            ON p.id_parque = l.id_parque;

-- 3.9 Ranking final
CREATE VIEW v_ranking AS
  SELECT RANK() OVER (ORDER BY SUM(aporte) DESC) AS posicion,
         parque,
         ROUND(100 * SUM(aporte), 1) AS puntaje_pct
  FROM v_aporte
  GROUP BY parque;

-- ---------------------------------------------------------------------
-- 4. ANÁLISIS DE SENSIBILIDAD
-- ---------------------------------------------------------------------

-- 4.1 Puntaje de cada parque en cada escenario de pesos
CREATE VIEW v_escenarios AS
  WITH pesos AS (
    SELECT 1 AS id_escenario, cod, peso FROM v_pesos_criterios
    UNION ALL
    SELECT id_escenario, cod, peso FROM escenario_peso
  )
  SELECT e.id_escenario, e.nombre AS escenario, p.nombre AS parque,
         ROUND(100 * SUM(w.peso * l.prioridad), 1) AS puntaje_pct
  FROM pesos w
  JOIN escenario e         ON e.id_escenario = w.id_escenario
  JOIN v_prioridad_local l ON l.cod = w.cod
  JOIN parque p            ON p.id_parque = l.id_parque
  GROUP BY e.id_escenario, p.nombre;

-- 4.2 Ganador, segundo y margen por escenario
CREATE VIEW v_escenarios_ganador AS
  WITH orden AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY id_escenario
                                 ORDER BY puntaje_pct DESC) AS pos
    FROM v_escenarios
  )
  SELECT g.id_escenario, g.escenario, g.parque AS ganador, g.puntaje_pct,
         s.parque AS segundo, ROUND(g.puntaje_pct - s.puntaje_pct, 1) AS margen
  FROM orden g JOIN orden s ON s.id_escenario = g.id_escenario AND s.pos = 2
  WHERE g.pos = 1;

-- 4.3 Peso crítico: se lleva el peso de un criterio de 0 a 1 (pasos de 0,001),
--     los demás se reajustan proporcionalmente, y se busca el peso más cercano
--     al base en el que el ganador cambia. Usa un CTE recursivo.
CREATE VIEW v_peso_critico AS
  WITH RECURSIVE grilla(t) AS (
    SELECT 0.0 UNION ALL SELECT t + 0.001 FROM grilla WHERE t < 0.9995
  ),
  base_ganador AS (
    SELECT parque FROM v_ranking WHERE posicion = 1
  ),
  pesos_var AS (                         -- pesos de todos los criterios para cada (k, t)
    SELECT k.cod AS variado, g.t, w.cod,
           CASE WHEN w.cod = k.cod THEN g.t
                ELSE w.peso * (1 - g.t) / (1 - k.peso) END AS peso
    FROM v_pesos_criterios k CROSS JOIN grilla g CROSS JOIN v_pesos_criterios w
  ),
  puntajes AS (
    SELECT pv.variado, pv.t, l.id_parque, SUM(pv.peso * l.prioridad) AS puntaje
    FROM pesos_var pv JOIN v_prioridad_local l ON l.cod = pv.cod
    GROUP BY pv.variado, pv.t, l.id_parque
  ),
  puntaje_base AS (                      -- puntaje del ganador base en cada (k, t)
    SELECT pu.variado, pu.t, pu.puntaje
    FROM puntajes pu JOIN parque p ON p.id_parque = pu.id_parque
    WHERE p.nombre = (SELECT parque FROM base_ganador)
  ),
  ganadores AS (
    SELECT variado, t, id_parque, puntaje,
           ROW_NUMBER() OVER (PARTITION BY variado, t ORDER BY puntaje DESC) AS pos
    FROM puntajes
  ),
  cambios AS (                           -- otro parque lo supera (sin contar empates)
    SELECT g.variado, g.t, p.nombre AS nuevo_ganador
    FROM ganadores g
    JOIN parque p        ON p.id_parque = g.id_parque
    JOIN puntaje_base pb ON pb.variado = g.variado AND pb.t = g.t
    WHERE g.pos = 1 AND p.nombre <> (SELECT parque FROM base_ganador)
      AND g.puntaje > pb.puntaje + 1e-9
  ),
  mas_cercano AS (
    SELECT c.variado, c.t, c.nuevo_ganador,
           ROW_NUMBER() OVER (PARTITION BY c.variado
                              ORDER BY ABS(c.t - w.peso)) AS r
    FROM cambios c JOIN v_pesos_criterios w ON w.cod = c.variado
  )
  SELECT cr.nombre AS criterio,
         ROUND(100 * w.peso, 1) AS peso_base_pct,
         CASE WHEN m.t IS NULL THEN 'No cambia'
              ELSE ROUND(100 * m.t, 1) || ' %' END AS peso_critico,
         COALESCE(m.nuevo_ganador, '-') AS nuevo_ganador
  FROM v_pesos_criterios w
  JOIN criterio cr ON cr.cod = w.cod
  LEFT JOIN mas_cercano m ON m.variado = w.cod AND m.r = 1
  ORDER BY w.peso DESC;

-- ---------------------------------------------------------------------
-- 5. CONSULTAS PARA PRACTICAR (seleccionar una y ejecutar con Ctrl+Return)
-- ---------------------------------------------------------------------

-- 5.1 Estructura: ¿qué parques hay y en qué departamento están? (JOIN)
SELECT p.nombre AS parque, d.nombre AS departamento, p.sup_ha, p.puestos
FROM parque p JOIN departamento d ON d.id_depto = p.id_depto
ORDER BY p.puestos DESC;

-- 5.2 Filtro: parques sin superficie inundable en el escenario Niño (WHERE)
SELECT nombre FROM parque WHERE ha_inund_nino = 0;

-- 5.3 Agregación: puestos totales por departamento (GROUP BY)
SELECT d.nombre, COUNT(*) AS parques, SUM(p.puestos) AS puestos
FROM parque p JOIN departamento d USING (id_depto)
GROUP BY d.nombre;

-- 5.4 Pesos de los criterios y consistencia
SELECT c.nombre, ROUND(100 * w.peso, 1) AS peso_pct
FROM v_pesos_criterios w JOIN criterio c USING (cod)
ORDER BY w.peso DESC;
SELECT * FROM v_consistencia_criterios;
SELECT * FROM v_consistencia_logistica;

-- 5.5 Ranking final y aporte de cada criterio
SELECT * FROM v_ranking;
SELECT parque, criterio, ROUND(100 * aporte, 1) AS aporte_pct
FROM v_aporte ORDER BY parque, aporte DESC;

-- 5.6 Sensibilidad
SELECT * FROM v_escenarios_ganador;
SELECT * FROM v_peso_critico;
