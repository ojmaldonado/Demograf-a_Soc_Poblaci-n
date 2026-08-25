# Parcial asignatura: Dinámica poblacional y demografía

**Tema:** Transición demográfica en América Latina — datos, medición y debates sobre el futuro de la población.

**Modalidad:** Trabajo aplicado (individual o en grupos de hasta 3 personas).

**Fecha de entrega:** Viernes 28 de agosto hasta las 23:59 en e-aulas. Entregas extemporáneas tienen penalidad de -1.

---

## 1. Presentación

En esta evaluación construirán y analizarán, de principio a fin, un conjunto de datos demográficos comparados para América Latina. El ejercicio integra las tres competencias centrales del curso: (a) el manejo de fuentes y la construcción rigurosa de una base de datos, (b) la descripción estadística de indicadores demográficos, y (c) la interpretación teórica de esos indicadores a la luz del modelo de transición demográfica y de los debates públicos actuales sobre el crecimiento o el declive de la población.

No se trata solo de calcular medidas, sino de argumentar qué nos dicen —y qué no— los números sobre las dinámicas poblacionales de la región.

## 2. Objetivos de aprendizaje

Al finalizar, cada estudiante será capaz de:

- Identificar, seleccionar y depurar fuentes de datos demográficos secundarios de acceso abierto.
- Construir una base de datos limpia, documentada y reproducible.
- Calcular e interpretar medidas de tendencia central y de dispersión aplicadas a indicadores demográficos.
- Clasificar países según su fase en el modelo de transición demográfica y justificar la clasificación con evidencia empírica.
- Evaluar críticamente los relatos contemporáneos sobre "explosión" y "colapso" poblacional a partir de los datos.

---

## 3. Tareas

### Tarea 1 — Construcción de la base de datos

Armen una base de datos con información comparada para al menos **12 países de América Latina** (procuren cubrir la diversidad regional: Cono Sur, Región Andina, Centroamérica, Caribe hispano y México). Para cada país deben incluir, como mínimo, las siguientes variables:

- **Tasa bruta de natalidad** (nacimientos por cada 1.000 habitantes)
- **Tasa bruta de mortalidad** (defunciones por cada 1.000 habitantes)
- **Tasa global de fecundidad** (número promedio de hijos por mujer)

Se sugiere agregar, si el análisis lo requiere: tasa de mortalidad infantil, esperanza de vida al nacer y tasa de crecimiento natural (calculable como natalidad − mortalidad).

Requisitos de la base:
- Formato tabular limpio (una fila por país, una columna por variable; formato *tidy*).
- Año de referencia común y explícito para todas las variables (o una nota clara cuando no coincida).
- Cada variable debe indicar su **fuente y año** en un archivo o pestaña de metadatos.
- Fuentes recomendadas: [Our World in Data](https://ourworldindata.org), CEPAL/CELADE, [World Population Prospects (ONU)](https://population.un.org/wpp/), Banco Mundial.

*Entregable:* archivo `.csv` o `.xlsx` con una hoja de datos y una hoja (o documento) de metadatos.

### Tarea 2 — Descripción estadística

Calculen, para cada uno de los tres indicadores principales, medidas de:

- **Tendencia central:** media, mediana y moda.
- **Dispersión:** rango, varianza, desviación estándar y coeficiente de variación.

Presenten los resultados en una tabla-resumen e interpreten al menos: ¿qué indicador presenta mayor heterogeneidad entre países y por qué?, ¿coinciden media y mediana o hay asimetría?, ¿qué países se comportan como valores atípicos y en qué dirección?

### Tarea 3 — Fase de la transición demográfica

Con base en los datos, clasifiquen cada país en una de las fases del modelo de transición demográfica (pre-transición; transición temprana; transición avanzada; post-transición / régimen demográfico moderno). Justifiquen cada clasificación combinando los valores de natalidad, mortalidad y fecundidad, y prestando atención especial al umbral de reemplazo (TGF ≈ 2,1 hijos por mujer).

Se recomienda construir un **diagrama de transición** (natalidad y mortalidad en el eje vertical; países o tiempo en el horizontal) o un gráfico de dispersión natalidad × fecundidad que haga visible el ordenamiento de la región. Discutan la heterogeneidad interna: ¿está América Latina en una sola fase o conviven varias?

### Tarea 4 — Los datos frente a los debates sobre el futuro de la población

A partir de sus resultados, discutan de manera argumentada cómo pueden leerse estos datos en relación con los dos grandes relatos que hoy compiten en la esfera pública:

- El relato del **desbordamiento / sobrepoblación** (linaje maltusiano, *The Population Bomb*, límites al crecimiento).
- El relato del **declive / invierno demográfico** (fecundidad bajo el reemplazo, envejecimiento, despoblación).

La discusión debe ir más allá de elegir un bando. Se espera que problematicen: ¿qué supuestos hacen que un mismo dato sostenga narrativas opuestas?, ¿qué queda fuera cuando la población se lee únicamente como número (distribución, desigualdad, migración, cuidado, sostenibilidad)?, ¿cómo se construyen políticamente estas cifras y quién las moviliza? Vinculen el argumento con al menos dos lecturas del curso.

---

## 4. Entregables

1. **Base de datos** — archivo `.csv`/`.xlsx` con datos y metadatos (Tarea 1).
2. **Documento de análisis en Word** (`.docx`), que integre las Tareas 2, 3 y 4 con tablas, al menos un gráfico y las referencias bibliográficas.
3. **Código en R** — *opcional pero valorado, +0.5 en el siguiente parcial*: script `.R` o cuaderno `.Rmd`/Quarto que reproduzca la limpieza de datos, los cálculos estadísticos y los gráficos.

---

## 5. Criterios de evaluación

| Criterio | Descripción | Peso |
|---|---|---|
| Base de datos | Cobertura, limpieza, formato *tidy* y documentación de fuentes | 20 % |
| Estadística descriptiva | Cálculo correcto e interpretación de las medidas | 20 % |
| Transición demográfica | Clasificación fundamentada y uso adecuado del modelo | 20 % |
| Discusión crítica | Solidez argumentativa y diálogo con la literatura del curso | 20 % |
| Presentación y forma | Claridad, tablas/gráficos legibles, citación correcta | 20 % |
| Reproducibilidad (R) | Bonificación por código limpio y reproducible | 5 % (bono Parcial II) |

## 6. Recomendaciones

- Fijen el año de referencia **antes** de empezar a descargar datos; es el error más común.
- Distingan siempre tasa *bruta* de natalidad (por 1.000 habitantes) de tasa *global* de fecundidad (por mujer): miden cosas distintas.
- El coeficiente de variación es su mejor aliado para comparar la dispersión entre indicadores con escalas diferentes.
- Si usan R, `tidyverse` basta para todo el flujo; el paquete `WDI` permite descargar directamente indicadores del Banco Mundial.
