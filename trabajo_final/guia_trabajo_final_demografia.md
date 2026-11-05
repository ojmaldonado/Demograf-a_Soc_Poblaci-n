# Guía del trabajo final — Póster de análisis demográfico de una unidad territorial

Dinámica Poblacional y Demografía · Universidad del Rosario · 5 de noviembre de 2026
## Fecha de entrega: 23 de noviembre, antes de las 23:59 via e-aulas

## 1. Propósito y producto final

El trabajo final es un **póster académico** que presenta el análisis demográfico fundamental de una unidad territorial elegida por cada grupo. El póster es lo que se evalúa; el código en R y la base de datos se entregan como anexos que demuestran que el análisis es propio, correcto y reproducible.

Con este trabajo cada grupo debe demostrar que puede:

- Delimitar una población en el espacio y en el tiempo, y justificar por qué vale la pena estudiarla.
- Obtener, limpiar y documentar datos demográficos de fuentes oficiales.
- Calcular e interpretar los indicadores básicos de tamaño, estructura, fecundidad, mortalidad y migración.
- Ubicar la unidad territorial en el modelo de transición demográfica visto en clase.
- Comunicar hallazgos con gráficos claros y un argumento sintético en un formato visual.

**Modalidad sugerida:** Individual. Cualquier excepción se acuerda con el profesor.

## 2. Elección de la unidad territorial

Cada grupo elige **una** unidad territorial con datos suficientes para calcular todos los indicadores mínimos de la sección 3. La elección se justifica en un párrafo: por qué esa unidad y qué pregunta demográfica la hace interesante.

| Escala               | Ejemplos                       | Ventajas                                                 | Riesgos                                               |
|----------------------|--------------------------------|----------------------------------------------------------|-------------------------------------------------------|
| País                 | Colombia, Perú, Japón, Nigeria | Series largas y comparables (UN WPP, OWID)               | Análisis muy general si no hay pregunta clara         |
| Departamento         | Antioquia, Chocó, San Andrés   | Proyecciones DANE por edad y sexo; contrastes regionales | Migración interna difícil de estimar                  |
| Municipio o distrito | Bogotá, Leticia, Tumaco        | Cercanía empírica; preguntas muy concretas               | Pocos eventos: tasas inestables, hay que agregar años |

Reglas para la delimitación:

- **Periodo:** como mínimo dos momentos censales o un periodo de 20 años (por ejemplo 2005–2025), más una proyección al futuro.
- **Comparación:** el análisis gana mucho si la unidad se compara con un referente (municipio frente a departamento, departamento frente a país, país frente a región).
- **Pregunta guía:** el póster debe responder una pregunta, no solo describir. Ejemplos: ¿en qué etapa de la transición está Chocó frente a Colombia?, ¿cómo cambió la pirámide de Bogotá con la migración venezolana?, ¿qué tan rápido envejece Japón?
- Unidades con menos de 50.000 habitantes requieren aprobación previa, porque las tasas anuales son muy inestables.

## 3. Contenido mínimo del análisis

El póster debe cubrir siete componentes. Cada uno lleva al menos un indicador calculado en R y una interpretación de una o dos frases; no basta con mostrar el gráfico.

| \#  | Componente                 | Indicadores mínimos                                                                                                                        | Visualización sugerida                                |
|-----|----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------|
| 1   | Tamaño y crecimiento       | Población total por año; tasa de crecimiento exponencial r; tiempo de duplicación                                                          | Serie de tiempo de la población                       |
| 2   | Estructura por edad y sexo | Pirámide en dos momentos; índice de masculinidad; edad mediana; índice de envejecimiento; razón de dependencia (total, juvenil y de vejez) | Pirámides superpuestas o lado a lado                  |
| 3   | Fecundidad                 | Tasa bruta de natalidad (TBN); tasas específicas por edad (TEF); tasa global de fecundidad (TGF)                                           | Curva de TEF en dos momentos; serie de TGF            |
| 4   | Mortalidad                 | Tasa bruta de mortalidad (TBM); esperanza de vida al nacer por sexo; tasa de mortalidad infantil                                           | Serie de esperanza de vida por sexo                   |
| 5   | Migración                  | Saldo migratorio neto (por ecuación compensadora o dato oficial); tasa de migración neta                                                   | Barras del saldo por periodo                          |
| 6   | Transición demográfica     | TBN y TBM en el tiempo; ubicación de la unidad en una etapa del modelo                                                                     | Gráfico TBN vs. TBM con crecimiento natural sombreado |
| 7   | Proyección y síntesis      | Proyección simple (exponencial o la oficial) a 2035 o 2050; tres hallazgos clave                                                           | Serie observada + proyectada                          |

**Fórmulas de referencia.** Tasa de crecimiento exponencial entre dos momentos separados por t años:

```latex
r = \frac{\ln(P_{t} / P_{0})}{t} \qquad T_{dup} = \frac{\ln 2}{r}
```

Tasa global de fecundidad a partir de tasas específicas por grupos quinquenales (15–19 a 45–49):

```latex
TGF = 5 \sum_{x=15}^{45} {}_{5}f_{x}
```

Razón de dependencia total y ecuación compensadora para estimar el saldo migratorio:

```latex
RD = \frac{P_{0-14} + P_{65+}}{P_{15-64}} \times 100 \qquad SM = (P_{t} - P_{0}) - (N - D)
```

Donde N son los nacimientos y D las defunciones del periodo. Si la fuente ya trae alguno de estos indicadores calculado, el grupo debe **recalcular al menos tres** desde los datos brutos en su script y comparar con la cifra oficial.

## 4. Fuentes de datos recomendadas

Para unidades colombianas, la fuente principal son las proyecciones del DANE con base en el CNPV 2018; para países, el World Population Prospects 2024 de Naciones Unidas. Ambas se pueden cargar directamente desde R.

| Fuente                                                                                                                                                   | Cobertura                                                        | Qué trae                                                                                  | Acceso desde R                                                                       |
|----------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| [DANE — Proyecciones de población (CNPV 2018)](https://www.dane.gov.co/index.php/estadisticas-por-tema/demografia-y-poblacion/proyecciones-de-poblacion) | Nacional 1950–2070, departamental 1985–2050, municipal 1985–2035 | Población por sexo, edad simple y área (cabecera / rural)                                 | Paquete `ColOpenData`, función `download_pop_projections()`; o descarga de los .xlsx |
| DANE — Estadísticas vitales (EEVV)                                                                                                                       | Nacional, departamental, municipal; series anuales               | Nacimientos por edad de la madre; defunciones por edad y sexo                             | Descarga de cuadros en .xlsx y lectura con `readxl`                                  |
| [UN World Population Prospects 2024](https://www.un.org/development/desa/pd/node/4328)                                                                   | Más de 230 países y regiones, 1950–2100                          | Población por edad y sexo, TGF, esperanza de vida, TBN, TBM, migración neta, proyecciones | Paquete `wpp2024` desde GitHub                                                       |
| Our World in Data                                                                                                                                        | Países                                                           | Series largas ya armonizadas (útil para transición demográfica)                           | Descarga de CSV desde cada gráfico                                                   |
| Banco Mundial (WDI)                                                                                                                                      | Países                                                           | Indicadores agregados de población, fecundidad y mortalidad                               | Paquete `WDI`                                                                        |
| CEPAL / CELADE                                                                                                                                           | América Latina                                                   | Estimaciones y proyecciones regionales, tablas de vida                                    | Descarga de cuadros                                                                  |

**Notas importantes sobre las fuentes**

- El paquete `wpp2024` es muy pesado y no está en CRAN; se instala con `remotes::install_github("PPgp/wpp2024")` subiendo antes el tiempo de espera con `options(timeout = 600)`. [Fuente](https://github.ddaodan.workers.dev/PPgp/wpp2024)
- En `wpp2024` las cifras están en **miles** y la población anual está referida al 31 de diciembre, por lo que aparece desplazada un año frente a la publicación oficial de la ONU (la población de 2050 en el paquete corresponde a 2051 en la web de la ONU).
- Las proyecciones municipales del DANE terminan en un grupo abierto de 85 años y más; las departamentales y nacionales, en 100 y más. [Metadato DANE](https://www.dane.gov.co/files/censo2018/proyecciones-de-poblacion/Metadato-proyecciones-ActPostCOVID.pdf)
- Las proyecciones del DANE son estimaciones, no conteos: el póster debe decirlo y distinguir entre años observados (censos, estadísticas vitales) y años proyectados.

**Cómo documentar las fuentes:** cada gráfico del póster lleva una línea de fuente debajo ("Fuente: elaboración propia con base en DANE, proyecciones CNPV 2018"). La bibliografía completa, con fecha de consulta, va en el póster y en el README.

## 5. Requisitos del código en R y de la base de datos

El criterio central es la **reproducibilidad**: el profesor debe poder abrir el proyecto en RStudio, ejecutar el script de principio a fin y obtener las mismas cifras y gráficos que aparecen en el póster.

**Estructura de carpetas obligatoria** (un Proyecto de RStudio, archivo `.Rproj`):

```text
apellido1_apellido2_demografia/
├── apellido1_apellido2_demografia.Rproj
├── README.md                 # integrantes, unidad, fuentes, cómo correr el código
├── datos/
│   ├── brutos/               # archivos tal como se descargaron (xlsx, csv)
│   └── procesados/           # base final limpia que usa el análisis (csv)
├── scripts/
│   └── analisis_demografico.R
├── figuras/                  # gráficos exportados en PNG (300 dpi)
└── poster/
    └── poster_final.pdf
```

**Requisitos del código**

- Un solo script principal (o un `.Rmd` / `.qmd`) que corre completo sin errores después de reiniciar R (Session → Restart R).
- Rutas **relativas** al proyecto (por ejemplo con `here::here()`); nunca `setwd("C:/Users/...")`.
- Todos los paquetes se cargan al inicio, y el README indica cómo instalarlos.
- Código organizado por secciones que siguen los siete componentes de la sección 3, con comentarios en español que expliquen qué se calcula y por qué.
- Cada indicador del póster se puede rastrear hasta una línea del script.
- Los gráficos se hacen con `ggplot2` y se guardan con `ggsave()` en `figuras/`.
- Se permite usar asistentes de IA para escribir código, siempre que se declare en el README y el grupo pueda explicar cada línea en la socialización.

**Requisitos de la base de datos**

- Se entregan los datos brutos y la base procesada. Si un archivo bruto pesa más de 25 MB, se reemplaza por el enlace de descarga y la fecha de consulta en el README.
- Base procesada en formato **largo y ordenado** (tidy): una fila por unidad × año × sexo × edad, en `.csv` con codificación UTF-8.
- Nombres de variables en minúscula, sin tildes ni espacios: `unidad`, `anio`, `sexo`, `edad`, `grupo_edad`, `poblacion`, `nacimientos`, `defunciones`.
- **Diccionario de datos** en el README: nombre de cada variable, descripción, unidad de medida, fuente y año.

## 6. Script base en R

El script de abajo hace el análisis completo de un país con datos del WPP 2024: genera la base procesada, siete figuras y una tabla resumen. Se probó de principio a fin con Colombia (R 4.3) y los indicadores recalculados coinciden con los oficiales de la ONU. Para adaptarlo basta con cambiar los parámetros de la sección 1; para departamentos o municipios se usa el bloque alternativo DANE del final.

**Resultado de referencia para Colombia** (sirve para verificar que el script corre bien en cada computador):

| Indicador                                | 2003          | 2023          |
|------------------------------------------|---------------|---------------|
| Población total                          | 41,2 millones | 52,6 millones |
| Tasa de crecimiento r (2003–2023)        | 1,22 % anual  | —             |
| Edad mediana (años)                      | 25            | 32            |
| Razón de dependencia total               | 56,1          | 42,8          |
| Índice de envejecimiento                 | 15,5          | 46,9          |
| TBN (por mil)                            | 20,9          | 13,5          |
| TBM (por mil)                            | 5,2           | 5,4           |
| TGF (hijos por mujer)                    | 2,45          | 1,65          |
| Esperanza de vida hombres / mujeres      | 68,5 / 76,3   | 75,0 / 80,5   |
| Mortalidad infantil aproximada (por mil) | 18,7          | 9,8           |

La figura de proyección deja una lección útil para el póster: con la r de 2003–2023 constante, Colombia llegaría a unos 73 millones en 2050, mientras la ONU proyecta cerca de 59 millones porque supone que la fecundidad sigue bajando. Una proyección exponencial ingenua sirve para discutir, no para predecir.

**Advertencias prácticas**

- Guardar el script con codificación UTF-8 (File → Save with Encoding) para que las tildes salgan bien en los gráficos.
- La primera instalación de `wpp2024` tarda varios minutos. Si falla por conexión, se descarga el ZIP desde GitHub y se instala con `remotes::install_local()`.
- Los nombres de países van en inglés tal como los usa la ONU ("Peru", "Mexico", "Japan"); para revisarlos: `data(UNlocations, package = "wpp2024"); UNlocations$name`.
- Los datos observados de `wpp2024` llegan a 2023; de 2024 en adelante son proyección.

```r
# =============================================================================
# Dinámica Poblacional y Demografía — Trabajo final (póster)
# Script base: análisis demográfico fundamental de una unidad territorial
#
# Ejemplo con un PAÍS usando el World Population Prospects 2024 (paquete wpp2024).
# Para departamentos o municipios de Colombia, ver el BLOQUE ALTERNATIVO DANE
# al final del script.
#
# Integrantes: ______________________   Fecha: __________
# =============================================================================

# -----------------------------------------------------------------------------
# 0. Preparación
# -----------------------------------------------------------------------------
# Instalar UNA sola vez (no dejar estas líneas activas en la entrega):
# install.packages(c("dplyr", "tidyr", "ggplot2", "readr", "remotes", "data.table"))
# options(timeout = 600)                      # el paquete pesa varios cientos de MB
# remotes::install_github("PPgp/wpp2024")

library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(wpp2024)

# Carpetas del proyecto (rutas relativas al .Rproj)
dir.create("datos/procesados", recursive = TRUE, showWarnings = FALSE)
dir.create("figuras", showWarnings = FALSE)

# -----------------------------------------------------------------------------
# 1. Parámetros del análisis  >>> CAMBIAR AQUÍ <<<
# -----------------------------------------------------------------------------
unidad      <- "Colombia"   # nombre exacto como aparece en wpp2024 (ver UNlocations)
anio_ini    <- 2003         # primer año de comparación
anio_fin    <- 2023         # último año observado en wpp2024
anio_proy   <- 2050         # horizonte de proyección

# -----------------------------------------------------------------------------
# 2. Carga de datos y construcción de la base procesada
# -----------------------------------------------------------------------------
# OJO: en wpp2024 las cifras están en MILES y la población anual está referida
# al 31 de diciembre (desplazada un año frente a la web de la ONU).
data("popAge1dt", "popprojAge1dt", "misc1dt", "miscproj1dt",
     "tfr1dt", "percentASFR1dt", "e01dt", "mx1dt", package = "wpp2024")

# Los datos vienen como data.table y, en las proyecciones, el año viene como texto.
# Esta función los deja como tibble con el año en número entero.
como_tabla <- function(x) x %>% as_tibble() %>% mutate(year = as.integer(year))

# 2.1 Población por edad simple y sexo (observada + proyectada), formato largo
pob_edad <- bind_rows(
  como_tabla(popAge1dt) %>% mutate(tipo = "observado"),
  como_tabla(popprojAge1dt) %>% select(country_code, name, year, age, popM, popF, pop) %>%
    mutate(tipo = "proyectado")
) %>%
  filter(name == unidad) %>%
  select(unidad = name, anio = year, edad = age, tipo,
         hombres = popM, mujeres = popF) %>%
  pivot_longer(c(hombres, mujeres), names_to = "sexo", values_to = "poblacion") %>%
  mutate(poblacion = poblacion * 1000)         # de miles a personas

# 2.2 Indicadores vitales anuales (nacimientos, defunciones, tasas)
vitales <- bind_rows(como_tabla(misc1dt), como_tabla(miscproj1dt)) %>%
  filter(name == unidad) %>%
  transmute(anio = year,
            nacimientos = births * 1000,
            defunciones = deaths * 1000,
            cambio_pob  = PopChange * 1000,
            tbn_onu = cbr, tbm_onu = cdr, tmn_onu = cnmr)

stopifnot(nrow(pob_edad) > 0, nrow(vitales) > 0)  # si falla, revisar el nombre de la unidad

# 2.3 Guardar la base procesada (se entrega junto con el póster)
write_csv(pob_edad, "datos/procesados/poblacion_edad_sexo.csv")
write_csv(vitales,  "datos/procesados/indicadores_vitales.csv")

# Población total por año
pob_total <- pob_edad %>%
  group_by(anio, tipo) %>%
  summarise(poblacion = sum(poblacion), .groups = "drop")

# -----------------------------------------------------------------------------
# 3. COMPONENTE 1 — Tamaño y crecimiento
# -----------------------------------------------------------------------------
P0 <- pob_total$poblacion[pob_total$anio == anio_ini]
Pt <- pob_total$poblacion[pob_total$anio == anio_fin]
t  <- anio_fin - anio_ini

r     <- log(Pt / P0) / t      # tasa de crecimiento exponencial anual
t_dup <- log(2) / r            # tiempo de duplicación (años)

cat(sprintf("Población %d: %s | %d: %s\n", anio_ini, format(round(P0), big.mark = ".", decimal.mark = ","),
            anio_fin, format(round(Pt), big.mark = ".", decimal.mark = ",")))
cat(sprintf("r = %.2f %% anual | tiempo de duplicación = %.0f años\n", 100 * r, t_dup))

g1 <- ggplot(pob_total, aes(anio, poblacion / 1e6, linetype = tipo)) +
  geom_line(linewidth = 0.9) +
  labs(title = paste("Población total,", unidad),
       x = NULL, y = "Millones de personas", linetype = NULL,
       caption = "Fuente: elaboración propia con base en UN WPP 2024") +
  theme_minimal()
ggsave("figuras/01_poblacion_total.png", g1, width = 7, height = 4, dpi = 300)

# -----------------------------------------------------------------------------
# 4. COMPONENTE 2 — Estructura por edad y sexo
# -----------------------------------------------------------------------------
# Grupos quinquenales con grupo abierto de 80 y más
pob_quinq <- pob_edad %>%
  mutate(grupo = cut(edad, breaks = c(seq(0, 80, 5), Inf), right = FALSE,
                     labels = c(paste(seq(0, 75, 5), seq(4, 79, 5), sep = "-"), "80+")))

piramide <- pob_quinq %>%
  filter(anio %in% c(anio_ini, anio_fin)) %>%
  group_by(anio, sexo, grupo) %>%
  summarise(poblacion = sum(poblacion), .groups = "drop") %>%
  group_by(anio) %>%
  mutate(pct = 100 * poblacion / sum(poblacion),
         pct = if_else(sexo == "hombres", -pct, pct))   # hombres a la izquierda

g2 <- ggplot(piramide, aes(pct, grupo, fill = sexo)) +
  geom_col(width = 0.9) +
  facet_wrap(~anio) +
  scale_x_continuous(labels = function(x) paste0(abs(x), "%")) +
  labs(title = paste("Pirámide de población,", unidad),
       x = "% de la población total", y = NULL, fill = NULL,
       caption = "Fuente: elaboración propia con base en UN WPP 2024") +
  theme_minimal()
ggsave("figuras/02_piramides.png", g2, width = 8, height = 5, dpi = 300)

# Indicadores de estructura para un año dado
indicadores_estructura <- function(datos, a) {
  d <- datos %>% filter(anio == a)
  tot_edad <- d %>% group_by(edad) %>% summarise(p = sum(poblacion), .groups = "drop")
  acum <- cumsum(tot_edad$p) / sum(tot_edad$p)
  tibble(
    anio              = a,
    ind_masculinidad  = 100 * sum(d$poblacion[d$sexo == "hombres"]) /
                              sum(d$poblacion[d$sexo == "mujeres"]),
    edad_mediana      = tot_edad$edad[which(acum >= 0.5)[1]],   # aproximación en edad simple
    p_0_14            = sum(d$poblacion[d$edad <= 14]),
    p_15_64           = sum(d$poblacion[d$edad >= 15 & d$edad <= 64]),
    p_65mas           = sum(d$poblacion[d$edad >= 65])
  ) %>%
    mutate(rd_total   = 100 * (p_0_14 + p_65mas) / p_15_64,
           rd_juvenil = 100 * p_0_14 / p_15_64,
           rd_vejez   = 100 * p_65mas / p_15_64,
           ind_envejecimiento = 100 * p_65mas / p_0_14)
}

estructura <- bind_rows(lapply(c(anio_ini, anio_fin, anio_proy),
                               indicadores_estructura, datos = pob_edad))
print(estructura %>% select(anio, ind_masculinidad, edad_mediana,
                            rd_total, rd_juvenil, rd_vejez, ind_envejecimiento))

# -----------------------------------------------------------------------------
# 5. COMPONENTE 3 — Fecundidad
# -----------------------------------------------------------------------------
# 5.1 Tasa bruta de natalidad recalculada: nacimientos / población media * 1000
pob_media <- pob_total %>%
  arrange(anio) %>%
  mutate(pob_media = (poblacion + lag(poblacion)) / 2)   # promedio inicio y fin de año

tasas <- vitales %>%
  left_join(pob_media %>% select(anio, pob_media), by = "anio") %>%
  mutate(tbn = 1000 * nacimientos / pob_media,
         tbm = 1000 * defunciones / pob_media,
         crec_natural = tbn - tbm)

# Comparación con la cifra oficial (deben ser muy parecidas)
print(tasas %>% filter(anio %in% c(anio_ini, anio_fin)) %>%
        select(anio, tbn, tbn_onu, tbm, tbm_onu))

# 5.2 Tasas específicas de fecundidad (TEF) y TGF
# wpp2024 trae la distribución porcentual de la fecundidad por edad simple (pasfr)
# y la TGF. TEF_x = TGF * pasfr_x / 100 ; luego TGF = suma de TEF (edad simple).
tef <- como_tabla(percentASFR1dt) %>%
  filter(name == unidad, year %in% c(anio_ini, anio_fin)) %>%
  left_join(como_tabla(tfr1dt) %>% filter(name == unidad) %>% select(year, tfr),
            by = "year") %>%
  mutate(tef = tfr * pasfr / 100)

tgf <- tef %>% group_by(anio = year) %>%
  summarise(tgf_recalculada = sum(tef), tgf_onu = mean(tfr), .groups = "drop")
print(tgf)

g3 <- ggplot(tef, aes(age, tef * 1000, colour = factor(year))) +
  geom_line(linewidth = 0.9) +
  labs(title = paste("Tasas específicas de fecundidad por edad,", unidad),
       x = "Edad de la madre", y = "Nacimientos por 1.000 mujeres", colour = NULL,
       caption = "Fuente: elaboración propia con base en UN WPP 2024") +
  theme_minimal()
ggsave("figuras/03_fecundidad_tef.png", g3, width = 7, height = 4, dpi = 300)

# -----------------------------------------------------------------------------
# 6. COMPONENTE 4 — Mortalidad
# -----------------------------------------------------------------------------
e0 <- como_tabla(e01dt) %>% filter(name == unidad) %>%
  select(anio = year, Hombres = e0M, Mujeres = e0F) %>%
  pivot_longer(-anio, names_to = "sexo", values_to = "e0")

g4 <- ggplot(e0 %>% filter(anio >= 1950), aes(anio, e0, colour = sexo)) +
  geom_line(linewidth = 0.9) +
  labs(title = paste("Esperanza de vida al nacer por sexo,", unidad),
       x = NULL, y = "Años", colour = NULL,
       caption = "Fuente: elaboración propia con base en UN WPP 2024") +
  theme_minimal()
ggsave("figuras/04_esperanza_vida.png", g4, width = 7, height = 4, dpi = 300)

# Mortalidad infantil aproximada a partir de la tasa central de mortalidad a edad 0
# q0 ≈ m0 / (1 + (1 - a0) * m0), con a0 = 0.1 (supuesto usual con mortalidad baja)
mort_inf <- como_tabla(mx1dt) %>%
  filter(name == unidad, age == 0, year %in% c(anio_ini, anio_fin)) %>%
  transmute(anio = year, tmi_por_mil = 1000 * mxB / (1 + 0.9 * mxB))
print(mort_inf)

# -----------------------------------------------------------------------------
# 7. COMPONENTE 5 — Migración (ecuación compensadora)
# -----------------------------------------------------------------------------
# Saldo migratorio = cambio de población − (nacimientos − defunciones)
migracion <- tasas %>%
  mutate(saldo_migratorio = cambio_pob - (nacimientos - defunciones),
         tmn = 1000 * saldo_migratorio / pob_media) %>%
  filter(anio >= anio_ini, anio <= anio_fin)

print(migracion %>% select(anio, saldo_migratorio, tmn, tmn_onu) %>% tail(5))

g5 <- ggplot(migracion, aes(anio, saldo_migratorio / 1000, fill = saldo_migratorio > 0)) +
  geom_col(show.legend = FALSE) +
  geom_hline(yintercept = 0) +
  labs(title = paste("Saldo migratorio neto anual,", unidad),
       x = NULL, y = "Miles de personas",
       caption = "Fuente: elaboración propia con base en UN WPP 2024 (ecuación compensadora)") +
  theme_minimal()
ggsave("figuras/05_migracion.png", g5, width = 7, height = 4, dpi = 300)

# -----------------------------------------------------------------------------
# 8. COMPONENTE 6 — Transición demográfica
# -----------------------------------------------------------------------------
transicion <- tasas %>%
  filter(anio >= 1950, anio <= anio_fin) %>%
  select(anio, TBN = tbn_onu, TBM = tbm_onu)

g6 <- ggplot(transicion, aes(anio)) +
  geom_ribbon(aes(ymin = TBM, ymax = TBN), fill = "grey85") +
  geom_line(aes(y = TBN, colour = "Natalidad (TBN)"), linewidth = 0.9) +
  geom_line(aes(y = TBM, colour = "Mortalidad (TBM)"), linewidth = 0.9) +
  labs(title = paste("Transición demográfica,", unidad),
       subtitle = "El área gris es el crecimiento natural",
       x = NULL, y = "Por 1.000 habitantes", colour = NULL,
       caption = "Fuente: elaboración propia con base en UN WPP 2024") +
  theme_minimal()
ggsave("figuras/06_transicion.png", g6, width = 7, height = 4, dpi = 300)

# -----------------------------------------------------------------------------
# 9. COMPONENTE 7 — Proyección
# -----------------------------------------------------------------------------
# Proyección exponencial simple con la r del periodo, frente a la proyección ONU
proy <- tibble(anio = anio_fin:anio_proy) %>%
  mutate(exponencial = Pt * exp(r * (anio - anio_fin))) %>%
  left_join(pob_total %>% filter(tipo == "proyectado") %>%
              select(anio, onu = poblacion), by = "anio")

g7 <- ggplot() +
  geom_line(data = pob_total %>% filter(tipo == "observado", anio >= 1980),
            aes(anio, poblacion / 1e6, colour = "Observado"), linewidth = 0.9) +
  geom_line(data = proy, aes(anio, exponencial / 1e6, colour = "Exponencial (r constante)"),
            linetype = "dashed", linewidth = 0.9) +
  geom_line(data = filter(proy, !is.na(onu)), aes(anio, onu / 1e6, colour = "Proyección ONU"),
            linetype = "dashed", linewidth = 0.9) +
  labs(title = paste("Población observada y proyectada,", unidad),
       x = NULL, y = "Millones de personas", colour = NULL,
       caption = "Fuente: elaboración propia con base en UN WPP 2024") +
  theme_minimal()
ggsave("figuras/07_proyeccion.png", g7, width = 7, height = 4, dpi = 300)

# -----------------------------------------------------------------------------
# 10. Tabla resumen de indicadores (para el póster)
# -----------------------------------------------------------------------------
resumen <- estructura %>%
  filter(anio %in% c(anio_ini, anio_fin)) %>%
  left_join(tasas %>% select(anio, tbn, tbm, crec_natural), by = "anio") %>%
  left_join(tgf %>% select(anio, tgf = tgf_recalculada), by = "anio") %>%
  left_join(e0 %>% pivot_wider(names_from = sexo, values_from = e0,
                               names_prefix = "e0_"), by = "anio") %>%
  left_join(mort_inf, by = "anio") %>%
  mutate(across(where(is.numeric), ~ round(.x, 2)))

print(t(resumen))
write_csv(resumen, "datos/procesados/resumen_indicadores.csv")

# =============================================================================
# BLOQUE ALTERNATIVO — Departamentos y municipios de Colombia (DANE)
# =============================================================================
# El paquete ColOpenData descarga las proyecciones del DANE (base CNPV 2018).
# Disponibilidad: nacional 1950–2070, departamental 1985–2050, municipal 1985–2035.
#
# install.packages("ColOpenData")
# library(ColOpenData)
# dane <- download_pop_projections(spatial_level = "department",   # o "municipality"
#                                  start_year = 2005, end_year = 2035,
#                                  include_sex = TRUE)
# names(dane)          # revisar nombres de columnas (p. ej. area, sexo, edad, total)
#
# Pasos para adaptar el script:
# 1. Filtrar la unidad y area == "total"; convertir edad a número (el grupo abierto
#    viene como texto: "100_y_mas" en departamentos, 85+ en municipios).
# 2. Renombrar a: unidad, anio, edad, sexo, poblacion (ya vienen en personas).
# 3. Nacimientos (por edad de la madre) y defunciones: descargar los cuadros de
#    Estadísticas Vitales del DANE y leerlos con readxl::read_excel().
# 4. TEF_x = nacimientos de madres de edad x / mujeres de edad x;
#    TGF = 5 * suma de TEF quinquenales (15–19 a 45–49).
# 5. Esperanza de vida: usar las tablas de vida del DANE o construir una tabla
#    abreviada con las tasas de mortalidad por edad.
# =============================================================================
```

## 7. Diseño del póster

El póster se organiza en tres columnas que siguen el orden de la sección 3, con encabezado arriba y fuentes abajo; debe poder leerse en unos 3 minutos a 1,5 metros de distancia.

*Figura: distribución sugerida del póster · 90 × 120 cm, 3 columnas*

```text
┌──────────────────────────────────────────────────────────────┐
│  TÍTULO: la respuesta a la pregunta guía                     │
│  Integrantes · Dinámica Poblacional y Demografía · Rosario  │
├────────────────────┬────────────────────┬────────────────────┤
│ Introducción       │ 2 Estructura por   │ 5 Migración        │
│                    │   edad y sexo      │   [gráfico]        │
├────────────────────┤   [pirámides]      ├────────────────────┤
│ Datos y métodos    │                    │ 6 Transición       │
│                    ├────────────────────┤   [gráfico]        │
├────────────────────┤ 3 Fecundidad       ├────────────────────┤
│ 1 Tamaño y         │   [gráfico]        │ 7 Proyección       │
│   crecimiento      ├────────────────────┤   [gráfico]        │
│   [gráfico]        │ 4 Mortalidad       ├────────────────────┤
│                    │   [gráfico]        │ CONCLUSIONES       │
├────────────────────┴────────────────────┴────────────────────┤
│  Fuentes · Código y datos (enlace o QR) · Uso de IA          │
└──────────────────────────────────────────────────────────────┘
```

Las áreas sombreadas son los gráficos y el recuadro resaltado, las conclusiones. La distribución se puede cambiar siempre que estén todos los componentes y el orden de lectura sea evidente.

**Especificaciones**

- **Tamaño:** 90 × 120 cm vertical o A0 (84,1 × 118,9 cm); se entrega en PDF.
- **Tipografía:** título de 72 pt o más, subtítulos de 40 pt o más, texto de 24 pt o más; una sola familia sans serif.
- **Texto:** máximo unas 800 palabras en total; frases cortas y viñetas en lugar de párrafos largos.
- **Gráficos:** entre 5 y 8, exportados desde R a 300 dpi, con un título que diga el hallazgo ("La TGF cayó de 2,45 a 1,65 hijos por mujer") y no solo el tema, ejes en español y fuente debajo.
- **Tabla resumen:** los indicadores clave de los dos años comparados, en no más de 10 filas.
- **Color:** máximo tres colores más el gris, los mismos para hombres y mujeres en todo el póster, y legibles impresos en blanco y negro.
- **Identificación:** logo de la universidad, nombre del curso, integrantes y fecha.
- **Acceso al código:** enlace o código QR a la carpeta con el código y los datos.

## 8. Entregables y cronograma

Se entrega una sola carpeta comprimida (`.zip`) con el póster y sus anexos, nombrada con los apellidos del grupo.

| Entregable    | Formato                                                          | Qué se evalúa                                            |
|---------------|------------------------------------------------------------------|----------------------------------------------------------|
| Póster final  | PDF, tamaño 90 × 120 cm vertical (o A0)                          | Todo el trabajo se califica sobre el póster              |
| Código        | Proyecto RStudio con script `.R` o `.qmd`                        | Que corra completo y reproduzca las cifras del póster    |
| Base de datos | `.csv` procesados + brutos o enlaces                             | Limpieza, formato largo, diccionario                     |
| README        | `.md` o `.txt`                                                   | Integrantes, fuentes, paquetes, instrucciones, uso de IA |
| Socialización | Presentación oral de 5 minutos frente al póster + 3 de preguntas | Dominio del análisis y del código                        |

**Cronograma sugerido** (las fechas exactas las fija el profesor en el aula virtual):

1.  **Semana 1:** elegir unidad territorial, periodo y pregunta guía; enviarlos en un párrafo para aprobación.
2.  **Semana 2:** descargar datos, construir la base procesada y correr el script base adaptado.
3.  **Semana 3:** completar los siete componentes, interpretar resultados y llevar un borrador del póster a clase para retroalimentación entre pares.
4.  **Semana 4:** versión final del póster, revisión de reproducibilidad (otra persona del grupo corre el código desde cero) y entrega.
5.  **Sesión final:** socialización de los pósteres.

## 9. Rúbrica de evaluación

La nota se calcula sobre 5,0. El 70 % corresponde al contenido del póster y el 30 % a la evidencia técnica (código, datos) y a la socialización.

| Criterio                                | Peso | Excelente (4,5–5,0)                                                                                                    | Aceptable (3,0–4,4)                                      | Insuficiente (\< 3,0)                               |
|-----------------------------------------|------|------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------|-----------------------------------------------------|
| Delimitación y pregunta guía            | 10 % | Unidad, periodo y pregunta claros y justificados; hay un referente de comparación                                      | Unidad y periodo claros; la pregunta es genérica         | No hay pregunta o la delimitación es confusa        |
| Cálculo de indicadores                  | 25 % | Los siete componentes completos, cálculos correctos y al menos tres indicadores recalculados y contrastados            | Faltan uno o dos componentes o hay errores menores       | Faltan varios componentes o hay errores de concepto |
| Interpretación y transición demográfica | 20 % | Cada resultado se interpreta; la unidad se ubica en la transición con argumentos y se relaciona con el contexto social | Interpretación descriptiva, poco conectada con la teoría | Se muestran gráficos sin interpretarlos             |
| Diseño y comunicación visual            | 15 % | Jerarquía clara, gráficos legibles con fuente, texto breve; se entiende en 3 minutos                                   | Legible pero recargado o desordenado                     | Difícil de leer; gráficos sin títulos ni fuentes    |
| Código y reproducibilidad               | 15 % | Corre de principio a fin sin errores, rutas relativas, comentado, reproduce todas las cifras                           | Corre con ajustes menores o le faltan comentarios        | No corre o no corresponde con el póster             |
| Base de datos y documentación           | 5 %  | Brutos y procesados, formato largo, diccionario y fuentes completas                                                    | Base procesada sin diccionario completo                  | Datos faltantes o sin documentar                    |
| Socialización                           | 10 % | Todo el grupo explica resultados y código con dominio                                                                  | Explicación correcta pero desigual entre integrantes     | No logran explicar el análisis o el código          |

Un póster cuyas cifras no se puedan reproducir con el código entregado tiene una nota máxima de 3,0 en el criterio de cálculo de indicadores.

## 10. Errores frecuentes y recursos

**Errores que bajan la nota**

- Mezclar unidades: cifras en miles con cifras en personas, o tasas por mil con porcentajes.
- Comparar años observados con años proyectados sin decirlo.
- Calcular tasas brutas con la población de un solo extremo del año en vez de la población media.
- Pirámides en números absolutos para comparar dos años con poblaciones distintas: usar porcentajes.
- Leer la TGF como "número de hijos que tienen las mujeres hoy" en lugar de una medida de periodo.
- Interpretar la migración estimada por ecuación compensadora como dato medido: es un residuo que acumula los errores de las otras fuentes.
- Texto largo copiado de informes oficiales en el póster.
- Gráficos con los colores y títulos por defecto en inglés.

**Recursos**

- [DANE — Proyecciones de población](https://www.dane.gov.co/index.php/estadisticas-por-tema/demografia-y-poblacion/proyecciones-de-poblacion) y su [metadato metodológico](https://www.dane.gov.co/files/censo2018/proyecciones-de-poblacion/Metadato-proyecciones-ActPostCOVID.pdf).
- [UN World Population Prospects 2024](https://www.un.org/development/desa/pd/node/4328) y el [paquete `wpp2024`](https://github.ddaodan.workers.dev/PPgp/wpp2024).
- [Viñeta de proyecciones de población de `ColOpenData`](https://mirror.uned.ac.cr/cran/web/packages/ColOpenData/vignettes/population_projections.html) (Universidad de los Andes).
- Talleres del curso: transición demográfica con Our World in Data en R; crecimiento poblacional y trampa malthusiana con NetLogo; demografía y métodos digitales con la API de Wikipedia.
- Plantillas gratuitas de póster académico: PowerPoint o Google Slides con lienzo de 90 × 120 cm, Canva, o el paquete `posterdown` para hacerlo directamente desde R Markdown.
