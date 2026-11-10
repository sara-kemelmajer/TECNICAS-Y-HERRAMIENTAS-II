# Módulo 5 — Dinámica de Sistemas: Control de temperatura por termostato

Modelado en **Vensim PLE** del caso *Mistakes and Misunderstandings: Examining Dimensional Inconsistency* (M. S. Gary, MIT, 1992): una vivienda calefaccionada por un horno controlado con termostato.

Se desarrollan tres versiones del modelo:

1. **Modelo erróneo:** la temperatura como stock; el *Units Check* detecta la inconsistencia dimensional.
2. **Modelo corregido:** el stock pasa a ser el calor y la temperatura se calcula con un factor de conversión.
3. **Modelo mejorado:** termostato con histéresis (análogo a un disparador Schmitt) para evitar el encendido y apagado continuo del horno.

## Entrega

Todo el trabajo se encuentra en **[`Modulo5_RMarkdown.zip`](Modulo5_RMarkdown.zip)**, que contiene:

- `README.Rmd`: desarrollo completo en R Markdown
- **Informe** en PDF
- **Modelos de Vensim** (`.mdl`): erróneo, corregido y mejorado
- Capturas de los diagramas y simulaciones
