# =============================================================================
# TALLER EN R
# Esperanza de vida al nacer y esperanza de vida saludable (HALE)
# Dinámica Poblacional y Demografía
#
# Datos: Observatorio Mundial de la Salud (GHO) de la OMS,
#        Global Health Estimates 2021 (años 2000–2021, 185 países)
# =============================================================================
#
# OBJETIVOS
#   1. Distinguir la esperanza de vida al nacer (e0) de la esperanza de vida
#      saludable al nacer (HALE).
#   2. Calcular cuántos años, en promedio, se esperaría vivir con mala salud.
#   3. Comparar Colombia en el tiempo, por sexo y frente a otros países.
#
# ANTES DE EMPEZAR
#   - Cree una carpeta para el taller (idealmente un Proyecto de RStudio:
#     File > New Project > New Directory).
#   - Guarde en esa carpeta este script y el archivo "oms_hale.csv".
#   - Ejecute el código línea por línea con Ctrl + Enter (Cmd + Enter en Mac).
#   - Use el panel "Outline" (Ctrl + Shift + O) para moverse entre secciones.
#   - Necesita conexión a internet para la sección 3.
#
# NOTA DE VOCABULARIO: "expectativa de vida" y "esperanza de vida" se usan como
# sinónimos; en demografía y en los documentos de la OMS en español es más
# frecuente "esperanza de vida".


# 0. CONCEPTOS BÁSICOS --------------------------------------------------------
#
# Esperanza de vida al nacer (e0):
#   Número promedio de años que viviría un recién nacido si, a lo largo de toda
#   su vida, se mantuvieran las tasas de mortalidad por edad observadas en un
#   año dado. Es un indicador de PERÍODO: resume la mortalidad de ese año; no es
#   un pronóstico de cuánto vivirá realmente la cohorte nacida ese año.
#
# Esperanza de vida saludable al nacer (HALE, Health-Adjusted Life Expectancy):
#   Número promedio de años que ese recién nacido viviría en "plena salud".
#   Descuenta de e0 los años que se viven con enfermedad o discapacidad,
#   ponderados según su gravedad. La OMS la calcula con el método de Sullivan:
#   combina la tabla de vida con la prevalencia de mala salud en cada edad.
#
# Dos medidas que construiremos:
#   Años con mala salud  = e0 - HALE
#   % de vida saludable  = 100 * HALE / e0
#
# Pregunta que guía el taller: cuando la gente vive más años,
# ¿esos años adicionales son años saludables?


# 1. PAQUETES -----------------------------------------------------------------

# Solo la primera vez: quite el # de la siguiente línea y ejecútela.
# install.packages(c("dplyr", "tidyr", "ggplot2", "readr", "jsonlite"))

library(dplyr)     # manipular tablas
library(tidyr)     # cambiar la forma de las tablas (ancho <-> largo)
library(ggplot2)   # gráficos
library(readr)     # leer archivos .csv
library(jsonlite)  # leer datos en formato JSON (sección 3)


# 2. DATOS DE ESPERANZA DE VIDA SALUDABLE (archivo de la OMS) -----------------

hale_raw <- read_csv("/Users/oscar/Documents/Demografía26/oms_hale.csv")

# Una primera mirada: ¿cuántas filas y columnas? ¿qué tipo de variables?
glimpse(hale_raw)

# Muchas columnas están vacías. El archivo trae DOS indicadores:
count(hale_raw, IndicatorCode, Indicator)
#   WHOSIS_000002 = HALE al nacer   <- el que usaremos
#   WHOSIS_000007 = HALE a los 60 años (lo retomamos en los ejercicios)

# ¿Cómo viene un dato? La columna "Value" es texto con el intervalo de
# incertidumbre entre corchetes; el valor numérico está en "FactValueNumeric".
hale_raw |>
  select(Location, Period, Dim1, Value, FactValueNumeric) |>
  head()

# Nos quedamos con HALE al nacer y con las columnas que necesitamos,
# renombradas en español.
hale <- hale_raw |>
  filter(IndicatorCode == "WHOSIS_000002") |>
  select(iso3   = SpatialDimValueCode,   # código de país (COL, ARG, ...)
         pais   = Location,
         region = ParentLocation,        # región de la OMS
         anio   = Period,
         sexo   = Dim1,
         hale   = FactValueNumeric) |>
  mutate(
    sexo = recode(sexo,
                  "Both sexes" = "Ambos sexos",
                  "Female"     = "Mujeres",
                  "Male"       = "Hombres"),
    region = recode(region,
                    "Africa"                = "África",
                    "Americas"              = "Américas",
                    "Eastern Mediterranean" = "Mediterráneo Oriental",
                    "Europe"                = "Europa",
                    "South-East Asia"       = "Asia Sudoriental",
                    "Western Pacific"       = "Pacífico Occidental")
  )

# Verifiquemos con Colombia en el último año disponible
hale |> filter(pais == "Colombia", anio == 2021)


# 3. DATOS DE ESPERANZA DE VIDA AL NACER (API de la OMS) ----------------------
#
# El archivo anterior solo trae HALE. La esperanza de vida al nacer
# (indicador WHOSIS_000001) la descargamos directamente del Observatorio
# Mundial de la Salud, a través de su API. Así ambas medidas vienen de la
# misma fuente y la misma ronda de estimaciones.

url_ev <- "https://ghoapi.azureedge.net/api/WHOSIS_000001"
ev_api <- fromJSON(url_ev)$value

# La API trae países, regiones, grupos de ingreso y el total mundial.
count(ev_api, SpatialDimType)

ev <- ev_api |>
  filter(SpatialDimType == "COUNTRY") |>
  select(iso3 = SpatialDim,
         anio = TimeDim,
         sexo = Dim1,
         e0   = NumericValue) |>
  mutate(sexo = recode(sexo,
                       "SEX_BTSX" = "Ambos sexos",
                       "SEX_FMLE" = "Mujeres",
                       "SEX_MLE"  = "Hombres"))

# ¿Qué años cubre?
range(ev$anio)

# --- PLAN B: si la API no responde ---
# En https://www.who.int/data/gho busque el indicador
# "Life expectancy at birth (years)" y descárguelo en CSV, igual que se hizo
# con el archivo de HALE. Guárdelo en la carpeta del taller como
# "oms_esperanza_vida.csv" y ejecute estas líneas (quite los #):
#
# ev <- read_csv("oms_esperanza_vida.csv") |>
#   select(iso3 = SpatialDimValueCode,
#          anio = Period,
#          sexo = Dim1,
#          e0   = FactValueNumeric) |>
#   mutate(sexo = recode(sexo,
#                        "Both sexes" = "Ambos sexos",
#                        "Female"     = "Mujeres",
#                        "Male"       = "Hombres"))


# 4. UNIR LAS DOS BASES Y CALCULAR LAS MEDIDAS --------------------------------

# Unimos por país, año y sexo: cada fila tendrá e0 y HALE.
datos <- hale |>
  inner_join(ev, by = c("iso3", "anio", "sexo")) |>
  mutate(anios_mala_salud = e0 - hale,
         pct_saludable    = 100 * hale / e0)

# Deberían ser 185 países x 22 años x 3 categorías de sexo = 12.210 filas
nrow(datos)

# Año de referencia para las comparaciones (puede cambiarlo más adelante)
anio_ref <- 2021

# Fuente para los gráficos
fuente <- "Fuente: OMS, Global Health Observatory (Global Health Estimates 2021)."


# 5. COLOMBIA, 2000–2021 ------------------------------------------------------

colombia <- datos |>
  filter(iso3 == "COL", sexo == "Ambos sexos")

colombia |>
  select(anio, e0, hale, anios_mala_salud, pct_saludable)

ggplot(colombia, aes(x = anio)) +
  # la franja gris son los años que se esperaría vivir con mala salud
  geom_ribbon(aes(ymin = hale, ymax = e0), fill = "grey85") +
  geom_line(aes(y = e0,   colour = "Esperanza de vida al nacer"), linewidth = 1.1) +
  geom_line(aes(y = hale, colour = "Esperanza de vida saludable (HALE)"), linewidth = 1.1) +
  scale_colour_manual(values = c("Esperanza de vida al nacer"         = "#1b6ca8",
                                 "Esperanza de vida saludable (HALE)" = "#e07a1f")) +
  labs(title    = "Colombia: esperanza de vida total y saludable, 2000–2021",
       subtitle = "La franja gris representa los años que se esperaría vivir con mala salud",
       x = NULL, y = "Años", colour = NULL,
       caption = fuente) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

# PREGUNTAS
#  a) ¿Cuántos años ganó Colombia en e0 entre 2000 y 2019? ¿Y en HALE?
#  b) ¿Qué ocurre en 2020 y 2021? ¿Qué acontecimiento lo explica?
#  c) ¿La franja gris se ensancha o se mantiene? ¿Qué significa eso?


# 6. DIFERENCIAS POR SEXO EN COLOMBIA -----------------------------------------

col_sexo <- datos |>
  filter(iso3 == "COL", anio == anio_ref, sexo != "Ambos sexos") |>
  select(sexo, e0, hale, anios_mala_salud, pct_saludable)

col_sexo

# Para graficar pasamos la tabla a formato "largo": cada barra (= e0) se divide
# en años saludables y años con mala salud.
col_sexo_largo <- col_sexo |>
  select(sexo, "Años saludables" = hale, "Años con mala salud" = anios_mala_salud) |>
  pivot_longer(-sexo, names_to = "componente", values_to = "anios") |>
  mutate(componente = factor(componente,
                             levels = c("Años con mala salud", "Años saludables")))

ggplot(col_sexo_largo, aes(x = sexo, y = anios, fill = componente)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = round(anios, 1)),
            position = position_stack(vjust = 0.5), colour = "white") +
  scale_fill_manual(values = c("Años saludables"     = "#1b6ca8",
                               "Años con mala salud" = "#c0392b")) +
  labs(title = paste0("Colombia, ", anio_ref, ": composición de la esperanza de vida por sexo"),
       subtitle = "La altura total de cada barra es la esperanza de vida al nacer",
       x = NULL, y = "Años", fill = NULL, caption = fuente) +
  theme_minimal(base_size = 12)

# PREGUNTAS
#  a) ¿Quiénes viven más años? ¿Quiénes viven más años con mala salud?
#  b) La literatura llama a esto la "paradoja salud-supervivencia" entre
#     mujeres y hombres. ¿Qué factores biológicos y sociales podrían explicarla?


# 7. COLOMBIA FRENTE A AMÉRICA LATINA -----------------------------------------

america_latina <- c("ARG", "BOL", "BRA", "CHL", "COL", "CRI", "CUB", "DOM",
                    "ECU", "SLV", "GTM", "HND", "HTI", "MEX", "NIC", "PAN",
                    "PRY", "PER", "URY", "VEN")

al <- datos |>
  filter(iso3 %in% america_latina, anio == anio_ref, sexo == "Ambos sexos") |>
  mutate(pais = reorder(pais, e0))   # ordena los países según e0

al_largo <- al |>
  select(pais, "Años saludables" = hale, "Años con mala salud" = anios_mala_salud) |>
  pivot_longer(-pais, names_to = "componente", values_to = "anios") |>
  mutate(componente = factor(componente,
                             levels = c("Años con mala salud", "Años saludables")))

ggplot(al_largo, aes(x = anios, y = pais, fill = componente)) +
  geom_col() +
  scale_fill_manual(values = c("Años saludables"     = "#1b6ca8",
                               "Años con mala salud" = "#c0392b")) +
  labs(title = paste0("América Latina, ", anio_ref, ": esperanza de vida total y saludable"),
       subtitle = "Países ordenados por esperanza de vida al nacer. Ambos sexos",
       x = "Años", y = NULL, fill = NULL, caption = fuente) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "bottom")

# Tabla ordenada por % de vida saludable
al |>
  arrange(desc(pct_saludable)) |>
  select(pais, e0, hale, anios_mala_salud, pct_saludable)

# PREGUNTAS
#  a) ¿En qué posición está Colombia en e0? ¿Y en HALE?
#  b) ¿El país con mayor e0 es también el de mayor % de vida saludable?


# 8. PANORAMA MUNDIAL: ¿VIVIR MÁS ES VIVIR MÁS AÑOS SANOS? --------------------

mundo <- datos |>
  filter(anio == anio_ref, sexo == "Ambos sexos")

# 8.1 Relación entre e0 y HALE
ggplot(mundo, aes(x = e0, y = hale, colour = region)) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed", colour = "grey50") +
  geom_point(alpha = 0.8, size = 2) +
  geom_point(data = filter(mundo, iso3 == "COL"), colour = "black", size = 4, shape = 21) +
  annotate("text", x = 60, y = 70, label = "Línea: HALE = e0\n(toda la vida en plena salud)",
           colour = "grey40", size = 3.3) +
  labs(title = paste0("Esperanza de vida al nacer y esperanza de vida saludable, ", anio_ref),
       subtitle = "Cada punto es un país. El círculo negro es Colombia",
       x = "Esperanza de vida al nacer (años)",
       y = "Esperanza de vida saludable (años)",
       colour = "Región OMS", caption = fuente) +
  theme_minimal(base_size = 12)

# 8.2 ¿Los países donde se vive más tienen más años con mala salud?
ggplot(mundo, aes(x = e0, y = anios_mala_salud)) +
  geom_point(aes(colour = region), alpha = 0.8, size = 2) +
  geom_smooth(method = "lm", se = FALSE, colour = "black") +
  labs(title = "Esperanza de vida y años vividos con mala salud",
       subtitle = paste0("Países, ambos sexos, ", anio_ref),
       x = "Esperanza de vida al nacer (años)",
       y = "Años con mala salud (e0 - HALE)",
       colour = "Región OMS", caption = fuente) +
  theme_minimal(base_size = 12)

# Correlación y regresión lineal simple
cor(mundo$e0, mundo$anios_mala_salud)

modelo <- lm(anios_mala_salud ~ e0, data = mundo)
summary(modelo)
# El coeficiente de e0 indica cuántos años de mala salud "vienen" en promedio
# con cada año adicional de esperanza de vida, comparando países.

# 8.3 Promedios por región (promedio simple de países, sin ponderar por población)
mundo |>
  group_by(region) |>
  summarise(paises           = n(),
            e0               = mean(e0),
            hale             = mean(hale),
            anios_mala_salud = mean(anios_mala_salud),
            pct_saludable    = mean(pct_saludable)) |>
  arrange(desc(e0))

# PARA DISCUTIR
#  En la demografía de la salud hay tres hipótesis clásicas:
#   - Compresión de la morbilidad (Fries, 1980): la mala salud se concentra en
#     un período cada vez más corto al final de la vida.
#   - Expansión de la morbilidad (Gruenberg, 1977; Kramer, 1980): sobrevivimos
#     más, pero con más años de enfermedad crónica y discapacidad.
#   - Equilibrio dinámico (Manton, 1982): aumentan los años con enfermedad,
#     pero con enfermedades menos graves.
#  ¿Qué sugieren los gráficos? Ojo: estamos comparando países en un solo año
#  (datos transversales). Para evaluar estas hipótesis habría que seguir a los
#  mismos países en el tiempo (vea el ejercicio 2).


# 9. GUARDAR UN GRÁFICO -------------------------------------------------------

# ggsave() guarda el último gráfico que se mostró en la carpeta del taller.
ggsave("grafico_mundo.png", width = 9, height = 6, dpi = 300)


# 10. EJERCICIOS --------------------------------------------------------------
#
# 1. Efecto de la pandemia. Cambie anio_ref a 2019 (sección 4) y vuelva a
#    ejecutar las secciones 6 a 8. ¿Qué cambia respecto a 2021?
#    Luego calcule qué países de América Latina perdieron más e0 entre 2019 y
#    2021. Pista:
#
#    datos |>
#      filter(iso3 %in% america_latina, sexo == "Ambos sexos",
#             anio %in% c(2019, 2021)) |>
#      select(pais, anio, e0) |>
#      pivot_wider(names_from = anio, values_from = e0, names_prefix = "e0_") |>
#      mutate(cambio = e0_2021 - e0_2019) |>
#      arrange(cambio)
#
# 2. Cambio en el tiempo. Calcule, para cada país, el cambio en e0 y en los
#    años con mala salud entre 2000 y 2019. ¿En la mayoría de países los años
#    con mala salud aumentaron o disminuyeron? ¿Qué hipótesis de la sección 8
#    apoya este resultado?
#
# 3. Hombres y mujeres en el tiempo. Rehaga el gráfico de la sección 5 para
#    Mujeres y Hombres en un mismo gráfico. Pista: filtre
#    sexo != "Ambos sexos" y agregue  + facet_wrap(~ sexo)  al gráfico.
#
# 4. HALE a los 60 años. Vuelva a hale_raw y filtre
#    IndicatorCode == "WHOSIS_000007". Grafique su evolución en Colombia por
#    sexo. ¿Cuántos años saludables le quedan en promedio a una persona de 60
#    años en Colombia? ¿Qué implicaciones tiene esto para el sistema de
#    pensiones y de cuidado?
#
# 5. Elija otro grupo de países (por ejemplo, los de una región de la OMS o
#    países que le interesen) y repita el análisis de la sección 7.
