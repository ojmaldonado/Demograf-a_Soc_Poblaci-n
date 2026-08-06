# Introducción: ¿qué es la transición demográfica?

El **Modelo de Transición Demográfica (MTD)** describe cómo, a lo largo del tiempo,
las poblaciones pasan de un régimen de **altas tasas de natalidad y mortalidad**
a uno de **bajas tasas de natalidad y mortalidad**. La idea central es sencilla y
poderosa: la mortalidad suele empezar a caer *antes* que la natalidad (gracias a
mejoras en alimentación, saneamiento y salud pública), y ese **desfase** entre
ambas curvas produce el crecimiento acelerado de la población. Cuando la
natalidad finalmente cae y "alcanza" a la mortalidad, el crecimiento se frena.

La versión clásica distingue cuatro (a veces cinco) **etapas**:

| Etapa | Natalidad | Mortalidad | Crecimiento natural | Ejemplos aproximados (hoy) |
|:-----:|:----------|:-----------|:--------------------|:---------------------------|
| **1. Alta estacionaria** | Alta | Alta | Muy bajo | Ninguno desde ~1950 (histórico) |
| **2. Expansión inicial** | Alta | Cae rápido | Alto y creciente | Níger, África subsahariana |
| **3. Expansión tardía** | Empieza a caer | Baja | Alto pero decreciente | India, Colombia (mediados s. XX) |
| **4. Baja estacionaria** | Baja | Baja | Muy bajo | Estados Unidos, Francia |
| **5. (opcional) Declive** | Muy baja | Baja (o sube por envejecimiento) | **Negativo** | Japón, Alemania, Corea del Sur |

En este taller vamos a **descargar datos reales** de *Our World in Data* (basados en
las *World Population Prospects* de la ONU) y a **visualizar la transición** para
distintos países, para poder *ver* esas etapas con nuestros propios ojos.

> **Objetivos del taller**
>
> 1. Descargar datos abiertos de natalidad y mortalidad desde una fuente online.
> 2. Graficar la transición demográfica de un país e interpretar el "desfase".
> 3. Comparar varios países ubicados en distintas etapas del modelo.
> 4. Calcular la tasa de crecimiento natural y clasificar cada país.
> 5. Reflexionar críticamente sobre los alcances y límites del modelo.

---

# Preparación del entorno

Si es la primera vez que usas estos paquetes, quita el `#` de la primera línea
para instalarlos (solo se hace una vez).

```{r instalar, eval=FALSE}
# install.packages("tidyverse")   # incluye dplyr, ggplot2, tidyr, readr
```

```{r librerias}
library(tidyverse)
```

> **Nota:** este taller descarga datos desde internet, así que necesitas conexión
> activa. Si estás detrás de un proxy/firewall que bloquea la descarga, al final
> del documento hay una **alternativa** con el paquete `WDI` (Banco Mundial).

---

# Descargar los datos desde Our World in Data

*Our World in Data* (OWID) publica cada gráfico con una **URL de datos** que
podemos leer directamente en R. Usaremos dos indicadores:

- **Tasa bruta de natalidad** (nacimientos por cada 1.000 habitantes)
- **Tasa bruta de mortalidad** (muertes por cada 1.000 habitantes)

Página de referencia: <https://ourworldindata.org/demographic-transition>

```{r urls}
# URLs oficiales de descarga de datos de OWID (CSV, todos los países y años)
url_natalidad  <- "https://ourworldindata.org/grapher/crude-birth-rate.csv?v=1&csvType=full&useColumnShortNames=false"
url_mortalidad <- "https://ourworldindata.org/grapher/crude-death-rate.csv?v=1&csvType=full&useColumnShortNames=false"

# Leemos directamente desde la URL
natalidad  <- read.csv(url_natalidad)
mortalidad <- read.csv(url_mortalidad)
```

Los CSV de OWID siempre tienen las tres primeras columnas `Entity` (país),
`Code` (código ISO) y `Year` (año); la **cuarta** columna es el indicador, con un
nombre largo. Veámoslo:

```{r inspeccionar}
names(natalidad)
head(natalidad)
```

Para trabajar cómodamente, renombramos la **cuarta columna** por posición (así el
código sigue funcionando aunque el nombre largo del indicador cambie):

```{r renombrar}
names(natalidad)[4]  <- "tasa_natalidad"
names(mortalidad)[4] <- "tasa_mortalidad"
```

---

# Preparar los datos

Aquí decides **qué países** analizar. Cambia este vector libremente (usa el nombre
en inglés tal como aparece en la columna `Entity`, p. ej. `"Colombia"`, `"Japan"`,
`"Niger"`, `"India"`, `"Germany"`, `"Nigeria"`, `"South Korea"`).

```{r elegir-paises}
paises <- c("Colombia", "Niger", "India", "Japan", "Germany")
```

Filtramos, unimos natalidad con mortalidad y calculamos el **crecimiento natural**
(la diferencia entre ambas tasas, expresada como % anual):

```{r preparar}
nat <- natalidad  |> filter(Entity %in% paises) |> select(Entity, Code, Year, tasa_natalidad)
mor <- mortalidad |> filter(Entity %in% paises) |> select(Entity, Code, Year, tasa_mortalidad)

demografia <- inner_join(nat, mor, by = c("Entity", "Code", "Year")) |>
  mutate(
    # natalidad y mortalidad vienen por cada 1.000 hab.;
    # su diferencia dividida entre 10 da el crecimiento natural en % anual
    crecimiento_natural = (tasa_natalidad - tasa_mortalidad) / 10
  ) |>
  arrange(Entity, Year)

head(demografia)
```

---

# Ejercicio 1 — La transición de un país

Empecemos por **un** país. Graficamos natalidad y mortalidad en el tiempo y
sombreamos el **desfase** entre las dos curvas: ese espacio *es* el crecimiento
de la población.

```{r ej1, fig.height=5}
pais_foco <- "Colombia"   # cámbialo por el país que quieras analizar

d1 <- demografia |> filter(Entity == pais_foco)

ggplot(d1, aes(x = Year)) +
  # área entre las dos curvas (el "desfase" de la transición)
  geom_ribbon(aes(ymin = pmin(tasa_natalidad, tasa_mortalidad),
                  ymax = pmax(tasa_natalidad, tasa_mortalidad)),
              fill = "grey80", alpha = 0.6) +
  geom_line(aes(y = tasa_natalidad,  color = "Natalidad"),  linewidth = 1.1) +
  geom_line(aes(y = tasa_mortalidad, color = "Mortalidad"), linewidth = 1.1) +
  scale_color_manual(values = c("Natalidad" = "#1b7837", "Mortalidad" = "#762a83")) +
  labs(
    title = paste("Transición demográfica de", pais_foco),
    subtitle = "El área sombreada es la brecha entre natalidad y mortalidad",
    x = "Año", y = "Tasa por 1.000 habitantes", color = NULL,
    caption = "Fuente: Our World in Data (ONU, World Population Prospects)"
  ) +
  theme_minimal(base_size = 13) +
  theme(legend.position = "top")
```

> **Preguntas — Ejercicio 1**
>
> 1. ¿En qué década es **más ancha** la brecha? ¿Qué le pasa a la población en
>    ese momento?
> 2. ¿Cae primero la natalidad o la mortalidad? ¿Coincide con lo que predice el
>    modelo?
> 3. Según la forma de las curvas, ¿en qué **etapa** ubicarías a este país hoy?

---

# Ejercicio 2 — Comparar países en distintas etapas

Ahora comparamos **todos** los países elegidos, cada uno en su propio panel.
Fíjate en qué tan separadas o juntas están las curvas: eso indica en qué etapa
del modelo se encuentra cada país.

```{r ej2, fig.height=6.5, fig.width=9}
demografia |>
  pivot_longer(c(tasa_natalidad, tasa_mortalidad),
               names_to = "indicador", values_to = "tasa") |>
  mutate(indicador = recode(indicador,
                            tasa_natalidad  = "Natalidad",
                            tasa_mortalidad = "Mortalidad")) |>
  ggplot(aes(x = Year, y = tasa, color = indicador)) +
  geom_line(linewidth = 1) +
  facet_wrap(~ Entity, ncol = 2) +
  scale_color_manual(values = c("Natalidad" = "#1b7837", "Mortalidad" = "#762a83")) +
  labs(
    title = "Comparación de la transición demográfica",
    x = "Año", y = "Tasa por 1.000 habitantes", color = NULL,
    caption = "Fuente: Our World in Data (ONU, World Population Prospects)"
  ) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "top")
```

> **Preguntas — Ejercicio 2**
>
> 1. Ordena los países del **menos** al **más** avanzado en la transición.
> 2. ¿Hay algún país donde la mortalidad esté **por encima** de la natalidad?
>    ¿Qué significa eso para su población (etapa 5)?
> 3. Colombia y Níger partían de niveles parecidos en 1950. ¿Se transformaron al
>    mismo ritmo? ¿Qué factores podrían explicar la diferencia?

---

# Ejercicio 3 — Crecimiento natural y clasificación por etapa

El **crecimiento natural** resume la transición en una sola curva: cuando es alto,
la población crece rápido; cuando llega a cero o se vuelve negativo, se estanca o
decrece.

```{r ej3-linea, fig.height=5, fig.width=9}
ggplot(demografia, aes(x = Year, y = crecimiento_natural, color = Entity)) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  geom_line(linewidth = 1.1) +
  labs(
    title = "Tasa de crecimiento natural (% anual)",
    subtitle = "Por encima de 0 la población crece; por debajo, decrece",
    x = "Año", y = "Crecimiento natural (%)", color = "País",
    caption = "Fuente: Our World in Data (ONU, World Population Prospects)"
  ) +
  theme_minimal(base_size = 13)
```

Construimos una **tabla resumen** con el año más reciente disponible y una
clasificación automática (aproximada) de la etapa:

```{r ej3-tabla}
resumen <- demografia |>
  group_by(Entity) |>
  filter(Year == max(Year)) |>
  ungroup() |>
  mutate(
    etapa = case_when(
      tasa_natalidad >= 30      ~ "Etapa 2 (expansión inicial)",
      tasa_natalidad >= 18      ~ "Etapa 3 (expansión tardía)",
      crecimiento_natural < 0   ~ "Etapa 5 (declive)",
      TRUE                      ~ "Etapa 4 (baja estacionaria)"
    )
  ) |>
  select(Entity, Year, tasa_natalidad, tasa_mortalidad, crecimiento_natural, etapa) |>
  arrange(desc(tasa_natalidad))

resumen
```

> **Preguntas — Ejercicio 3**
>
> 1. ¿Coincide la clasificación automática con lo que observaste en las gráficas?
> 2. La regla que usamos es un umbral simple sobre la natalidad. ¿Qué casos
>    "engaña"? ¿Cómo la mejorarías?

---

# (Opcional) Extensión — La trayectoria de la transición

Una forma elegante de ver todo el proceso es un **diagrama de trayectoria**:
mortalidad en el eje X, natalidad en el eje Y y el tiempo como color. Cada país
dibuja un "camino". La diagonal marca dónde natalidad = mortalidad (crecimiento
cero): por encima la población crece, por debajo decrece.

```{r extension, fig.height=6, fig.width=8}
ggplot(demografia, aes(x = tasa_mortalidad, y = tasa_natalidad)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "grey60") +
  geom_path(aes(color = Year), linewidth = 1) +
  facet_wrap(~ Entity) +
  scale_color_viridis_c() +
  labs(
    title = "Trayectoria de la transición demográfica",
    subtitle = "Sobre la diagonal la población crece; bajo ella, decrece",
    x = "Tasa de mortalidad (por 1.000)", y = "Tasa de natalidad (por 1.000)",
    color = "Año", caption = "Fuente: Our World in Data (ONU, World Population Prospects)"
  ) +
  theme_minimal(base_size = 12)
```

---

# Reflexión final: el modelo como modelo

El MTD es una herramienta descriptiva muy útil, pero conviene mirarlo con ojo
crítico —justo lo que hacemos como cientistas sociales:

- **¿Es universal o eurocentrista?** El modelo se construyó a partir de la
  experiencia europea del siglo XIX–XX. ¿Se ajusta igual de bien a los países
  que ves en tus gráficas, o hay ritmos y saltos distintos?
- **¿Es lineal e inevitable?** El modelo sugiere una secuencia fija de etapas.
  ¿Los datos muestran retrocesos, estancamientos o caminos alternativos?
- **¿Qué queda fuera?** Las tasas *brutas* no distinguen por edad, clase, región
  o género. ¿Qué desigualdades internas oculta un promedio nacional?
- **La "segunda transición demográfica"** (fecundidad muy por debajo del reemplazo,
  nuevas formas de familia): ¿aparece en algún país de tu selección?

> **Entrega:** guarda este documento con tus respuestas (Knit → HTML o PDF) y
> súbelo al aula. Incluye al menos **una** gráfica con un país que **tú** hayas
> elegido (distinto de los del ejemplo).

---

# Apéndice — Alternativa sin OWID (Banco Mundial)

Si no puedes descargar de OWID, el paquete `WDI` trae los mismos indicadores
desde el Banco Mundial:

```{r wdi, eval=FALSE}
# install.packages("WDI")
library(WDI)

# SP.DYN.CBRT.IN = natalidad ; SP.DYN.CDRT.IN = mortalidad (por 1.000)
wb <- WDI(country   = c("CO", "NE", "IN", "JP", "DE"),
          indicator = c(tasa_natalidad  = "SP.DYN.CBRT.IN",
                        tasa_mortalidad = "SP.DYN.CDRT.IN"),
          start = 1960, end = 2023)

# 'wb' ya trae columnas country, year, tasa_natalidad, tasa_mortalidad;
# renombra 'country' -> 'Entity' y 'year' -> 'Year' y reutiliza los gráficos de arriba.
```

