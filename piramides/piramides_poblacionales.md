# Pirámides poblacionales de Colombia (2018, 2028, 2038, 2058)

Script en R para visualizar pirámides poblacionales a partir de las
proyecciones de población del DANE (PPED 2018–2070).

- **Fuente:** DANE — *Proyecciones de Población por área geográfica según sexo y edades simples, 2018–2070.*
- **Archivo de datos:** `PPED-AreaSexoEdadNac-2018-2070.xlsx`
- **Hoja usada:** `PobNacionalxÁreaSexoEdad`

---

## Requisitos

- R (≥ 4.0) y, de preferencia, RStudio.
- Paquetes: `readxl`, `dplyr`, `tidyr`, `stringr`, `ggplot2`, `scales`.
  El script los instala automáticamente si faltan.

---

## Instrucciones de uso

1. Guarda el archivo de datos `PPED-AreaSexoEdadNac-2018-2070.xlsx` y el script
   `piramides_poblacionales.R` en la misma carpeta.
2. Abre el script en RStudio.
3. Ajusta la variable `ruta` a la ubicación del `.xlsx` en tu equipo
   (o reemplázala por `file.choose()` para seleccionarlo con un cuadro de diálogo).
4. Ejecuta todo el script (`Ctrl/Cmd + Shift + Enter`).
5. La figura aparece en el panel *Plots* y se guarda como
   `piramides_poblacionales.png` en el directorio de trabajo.

### Parámetros que puedes modificar

| Variable     | Qué controla                                                                 |
|--------------|------------------------------------------------------------------------------|
| `ruta`       | Ruta al archivo de Excel.                                                     |
| `anios`      | Años a graficar. Por defecto `c(2018, 2028, 2038, 2058)`.                     |
| `quinquenal` | `TRUE` = grupos de 5 años (pirámide clásica); `FALSE` = edad simple (101 barras). |

---

## Notas metodológicas

- Se usa el área **Total** (cabecera + centros poblados y rural disperso).
- La hoja trae encabezados en varias filas; la fila 9 del Excel contiene los
  nombres útiles (`Hombres 0 años`, `Mujeres 0 años`, …), por eso se lee con
  `skip = 8`.
- Las 101 columnas de edad simple de cada sexo suman exactamente los totales
  reportados en el archivo, lo que confirma que la lectura es correcta.
- Los hombres se grafican a la izquierda (valores negativos) y las mujeres a la
  derecha, con un eje simétrico común a los cuatro años para apreciar el
  envejecimiento de la estructura entre 2018 y 2058.
- Para comparar la **forma** independientemente del tamaño total (útil al
  discutir la transición demográfica), puede convertirse el eje a porcentaje de
  la población de cada año.

---

## Código

```r
# ============================================================================
#  Pirámides poblacionales – Colombia (DANE, PPED 2018–2070)
#  Años: 2018, 2028, 2038, 2058
#
#  Fuente: "NACIONAL. PROYECCIONES DE POBLACIÓN POR ÁREA GEOGRÁFICA SEGÚN
#           SEXO Y EDADES SIMPLES, 2018–2070"
#  Hoja de datos: "PobNacionalxÁreaSexoEdad"
# ============================================================================

# ---- 1. Paquetes -----------------------------------------------------------
# Instala los que falten y los carga.
paquetes <- c("readxl", "dplyr", "tidyr", "stringr", "ggplot2", "scales")
faltan   <- setdiff(paquetes, rownames(installed.packages()))
if (length(faltan)) install.packages(faltan)
invisible(lapply(paquetes, library, character.only = TRUE))

# ---- 2. Parámetros ---------------------------------------------------------
# Ajusta la ruta al archivo (o usa file.choose()).
ruta   <- "PPED-AreaSexoEdadNac-2018-2070.xlsx"
hoja   <- "PobNacionalxÁreaSexoEdad"
anios  <- c(2018, 2028, 2038, 2058)   # años a graficar
quinquenal <- TRUE                    # TRUE = grupos de 5 años; FALSE = edad simple

# ---- 3. Lectura ------------------------------------------------------------
# La tabla tiene encabezados en varias filas. La fila 9 del Excel trae los
# nombres de columna útiles ("Hombres 0 años", "Mujeres 0 años", ...), por eso
# se salta hasta ella con skip = 8. Las 3 primeras columnas vienen sin nombre.
crudo <- read_excel(ruta, sheet = hoja, skip = 8)
names(crudo)[1:3] <- c("territorio", "anio", "area")

# ---- 4. Reestructuración a formato largo -----------------------------------
# Nos quedamos con el área "Total" (cabecera + rural) y pasamos las columnas
# de edad simple por sexo a filas: una fila por (año, sexo, edad).
piramide <- crudo %>%
  filter(area == "Total", anio %in% anios) %>%
  select(anio, matches("^(Hombres|Mujeres) \\d+")) %>%
  pivot_longer(-anio, names_to = "columna", values_to = "poblacion") %>%
  mutate(
    sexo = str_extract(columna, "^(Hombres|Mujeres)"),
    edad = as.integer(str_extract(columna, "\\d+")),   # "100 años y más" -> 100
    poblacion = as.numeric(poblacion)
  ) %>%
  select(anio, sexo, edad, poblacion)

# ---- 5. (Opcional) agrupación en quinquenios -------------------------------
if (quinquenal) {
  piramide <- piramide %>%
    mutate(g = pmin(floor(edad / 5) * 5, 100)) %>%
    group_by(anio, sexo, g) %>%
    summarise(poblacion = sum(poblacion), .groups = "drop") %>%
    mutate(grupo = ifelse(g == 100, "100+", paste0(g, "–", g + 4))) %>%
    rename(orden = g)
} else {
  piramide <- piramide %>%
    mutate(grupo = ifelse(edad == 100, "100+", as.character(edad)),
           orden = edad)
}

# Ordena las categorías de edad de menor a mayor (base de la pirámide abajo)
piramide <- piramide %>%
  mutate(grupo = reorder(grupo, orden),
         # Hombres a la izquierda (negativo), mujeres a la derecha (positivo)
         pob_graf = ifelse(sexo == "Hombres", -poblacion, poblacion))

# ---- 6. Gráfico ------------------------------------------------------------
tope <- max(abs(piramide$pob_graf))   # límite simétrico común a todos los años

ggplot(piramide, aes(x = grupo, y = pob_graf, fill = sexo)) +
  geom_col(width = 0.9) +
  coord_flip() +
  facet_wrap(~ anio, nrow = 1) +
  scale_y_continuous(
    limits = c(-tope, tope),
    labels = function(x) comma(abs(x))
  ) +
  scale_fill_manual(values = c("Hombres" = "#2C6E91", "Mujeres" = "#D1495B")) +
  labs(
    title    = "Pirámides poblacionales de Colombia",
    subtitle = "Proyecciones DANE (PPED) · total nacional por sexo y edad",
    x = "Edad", y = "Población", fill = NULL,
    caption  = "Fuente: DANE, Proyecciones de Población 2018–2070"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "top",
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold")
  )

# ---- 7. Guardar ------------------------------------------------------------
ggsave("piramides_poblacionales.png", width = 12, height = 5, dpi = 300)
```
