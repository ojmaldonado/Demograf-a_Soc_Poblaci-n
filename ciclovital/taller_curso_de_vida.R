# ============================================================
# TALLER: Trayectorias vitales y vidas que se cruzan
# Curso: Dinámica Poblacional y Demografía
# Visualización de trayectorias familiares con ggplot2 (carriles / swimlanes)
# ------------------------------------------------------------
# Idea: cada persona es un "carril". Sobre el eje de TIEMPO HISTÓRICO
# las intersecciones se leen como alineaciones verticales (un nacimiento
# inicia el carril del hijo y es un evento en el de los padres). Sobre el
# eje de EDAD comparamos a qué edad ocurre cada transición entre generaciones
# -> la transición demográfica en miniatura.
# ============================================================

# --- 0. Paquetes ---
# install.packages("tidyverse")   # solo la primera vez
library(tidyverse)

ANIO_ACTUAL <- 2026   # año de referencia para las personas vivas

# ============================================================
# 1. LA FICHA BIOGRÁFICA COMO data.frame
#    Los estudiantes reemplazan las filas de ejemplo por su familia.
#    (3 generaciones: G1 abuelos/as, G2 padres/tíos, G3 estudiante)
# ============================================================

# 1a. Una fila por PERSONA -----------------------------------
#     anio_fin = NA  -> la persona sigue viva
personas <- tribble(
  ~id,        ~rol,               ~generacion, ~anio_nac, ~anio_fin,
  "abuelo_m", "Abuelo materno",   "G1",        1945,      2001,
  "abuela_m", "Abuela materna",   "G1",        1948,      2019,
  "tia",      "Tía materna",      "G2",        1969,      NA,
  "madre",    "Madre",            "G2",        1972,      NA,
  "yo",       "Estudiante (yo)",  "G3",        1998,      NA
)

# 1b. Una fila por EVENTO ------------------------------------
#     'tipo' debe existir en la tabla 'categorias' (bloque 2).
eventos <- tribble(
  ~id,        ~tipo,        ~anio, ~descripcion,
  # -- G1
  "abuela_m", "union",      1968,  "Unión conyugal",
  "abuela_m", "hijo",       1969,  "Nace 1er hijo (tía)",
  "abuela_m", "hijo",       1972,  "Nace 2do hijo (madre)",
  "abuela_m", "hijo",       1976,  "Nace 3er hijo",
  "abuela_m", "migracion",  1975,  "Migración rural -> urbana",
  "abuela_m", "viudez",     2001,  "Viudez",
  # -- G2
  "madre",    "educacion",  1990,  "Ingreso a la universidad",
  "madre",    "union",      1996,  "Unión conyugal",
  "madre",    "hijo",       1998,  "Nace 1er hijo (yo)",
  "madre",    "hijo",       2002,  "Nace 2do hijo",
  "madre",    "laboral",    1995,  "Primer empleo",
  # -- G3
  "yo",       "educacion",  2016,  "Ingreso a la universidad",
  "yo",       "migracion",  2020,  "Se independiza / cambio de ciudad"
)

# 1c. (Opcional) CORRESIDENCIAS: tramos en que dos vidas comparten hogar.
#     Sirven para ver el cuidado / la corresidencia como superposición.
corresidencias <- tribble(
  ~id,        ~anio_ini, ~anio_fin, ~vinculo,
  "abuela_m", 1998,      2005,      "Cría al nieto",
  "yo",       1998,      2005,      "Cría al nieto"
)

# ============================================================
# 2. TIPOLOGÍA DE EVENTOS Y COLORES (coincide con la leyenda del taller)
# ============================================================
categorias <- tribble(
  ~tipo,           ~categoria,
  "union",         "Conyugal / unión",
  "separacion",    "Conyugal / unión",
  "viudez",        "Conyugal / unión",
  "hijo",          "Filiación",
  "migracion",     "Residencial / migración",
  "corresidencia", "Residencial / migración",
  "desplazamiento","Ruptura / inflexión",
  "enfermedad",    "Ruptura / inflexión",
  "muerte",        "Ruptura / inflexión",
  "educacion",     "Laboral / educativo",
  "laboral",       "Laboral / educativo"
)

colores_cat <- c(
  "Conyugal / unión"        = "#2c7fb8",  # azul
  "Filiación"               = "#31a354",  # verde
  "Residencial / migración" = "#e6b800",  # ámbar
  "Ruptura / inflexión"     = "#d7301f",  # rojo
  "Laboral / educativo"     = "#636363"   # gris
)

# ============================================================
# 3. PREPARACIÓN DE LOS DATOS
# ============================================================

# Ordenar los carriles por año de nacimiento (más viejo arriba)
niveles <- personas %>% arrange(anio_nac) %>% pull(rol) %>% rev()

personas <- personas %>%
  mutate(anio_fin_plot = coalesce(anio_fin, ANIO_ACTUAL),
         rol = factor(rol, levels = niveles))

eventos <- eventos %>%
  left_join(select(personas, id, rol, anio_nac, generacion), by = "id") %>%
  left_join(categorias, by = "tipo") %>%
  mutate(edad = anio - anio_nac,
         categoria = factor(categoria, levels = names(colores_cat)))

corresidencias <- corresidencias %>%
  left_join(select(personas, id, rol), by = "id")

# ============================================================
# 4. PLOT 1 — TIEMPO HISTÓRICO (aquí se ven las intersecciones)
# ============================================================

# Años de referencia para marcar efectos de periodo / nacimientos vinculantes
anios_clave <- c(1998, 2020)

p_tiempo <- ggplot() +
  # (a) Corresidencia: banda translúcida sobre los carriles implicados
  geom_segment(data = corresidencias,
               aes(x = anio_ini, xend = anio_fin, y = rol, yend = rol),
               linewidth = 5, color = "grey65", alpha = 0.35) +
  # (b) La vida de cada persona: de su nacimiento a hoy (o a su muerte)
  geom_segment(data = personas,
               aes(x = anio_nac, xend = anio_fin_plot, y = rol, yend = rol),
               linewidth = 1.1, color = "grey40") +
  # (c) Líneas guía para leer periodos compartidos entre familias
  geom_vline(xintercept = anios_clave, linetype = "dashed", color = "grey70") +
  # (d) Los eventos
  geom_point(data = eventos,
             aes(x = anio, y = rol, color = categoria),
             size = 3.2) +
  scale_color_manual(values = colores_cat, name = "Tipo de evento") +
  labs(title = "Trayectorias familiares en el tiempo histórico",
       subtitle = "Cada carril es una vida; los cruces se leen como alineaciones verticales",
       x = "Año", y = NULL,
       caption = "Banda gris = corresidencia · líneas punteadas = años de referencia (efectos de periodo)") +
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.y = element_blank())

print(p_tiempo)

# ============================================================
# 5. PLOT 2 — EDAD (comparar el 'timing' entre generaciones)
#    Las mismas transiciones, ahora sobre el eje de la edad:
#    revela el cambio de cohorte (transición demográfica).
# ============================================================

p_edad <- ggplot(eventos, aes(x = edad, y = rol, color = categoria)) +
  geom_point(size = 3.2) +
  scale_color_manual(values = colores_cat, name = "Tipo de evento") +
  scale_x_continuous(breaks = seq(0, 90, 10)) +
  labs(title = "Las mismas trayectorias sobre el eje de la edad",
       subtitle = "A qué edad ocurre cada transición: ¿se retrasa la unión y la 1a maternidad entre generaciones?",
       x = "Edad", y = NULL) +
  theme_minimal(base_size = 12) +
  theme(panel.grid.major.y = element_blank())

print(p_edad)

# ============================================================
# 6. TABLA RESUMEN — timing de transiciones por persona
#    (edad a la 1a unión, al 1er hijo, número de hijos)
# ============================================================

safe_min <- function(x) if (length(x)) min(x) else NA_real_

resumen_timing <- eventos %>%
  group_by(generacion, rol) %>%
  summarise(
    edad_1a_union  = safe_min(edad[tipo == "union"]),
    edad_1er_hijo  = safe_min(edad[tipo == "hijo"]),
    n_hijos        = sum(tipo == "hijo"),
    .groups = "drop"
  ) %>%
  arrange(generacion, rol)

print(resumen_timing)

# ============================================================
# 7. (Opcional) Guardar las figuras
# ============================================================
# ggsave("trayectorias_tiempo.png", p_tiempo, width = 9, height = 5, dpi = 300)
# ggsave("trayectorias_edad.png",   p_edad,   width = 9, height = 5, dpi = 300)
