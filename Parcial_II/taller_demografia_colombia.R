# =====================================================================
#  TALLER: Análisis demográfico básico de Colombia en R
#  Fecundidad, nupcialidad y esperanza de vida al nacer
#  Datos: Our World in Data (OWID)
#  Nivel: muy básico (no se necesita experiencia previa en R)
# =====================================================================
#
# CÓMO USAR ESTE ARCHIVO EN RSTUDIO
# ---------------------------------
# 1. Abra este archivo en RStudio (File > Open File...).
# 2. Ponga el cursor en una línea de código y presione
#        Ctrl + Enter   (Windows / Linux)
#        Cmd  + Enter   (Mac)
#    para ejecutarla. El resultado aparece en la CONSOLA (panel de abajo)
#    y los gráficos en la pestaña "Plots" (panel de abajo a la derecha).
# 3. Las líneas que empiezan con # son COMENTARIOS: R no las ejecuta,
#    solo sirven para explicar el código.
# 4. Avance sección por sección y en orden. Puede usar el panel
#    "Outline" (botón en la esquina superior derecha del editor)
#    para saltar entre secciones.
#
# No hay que instalar ningún paquete: todo se hace con R "base".
#
# FUENTES (datos descargados de ourworldindata.org, septiembre de 2026)
#  - Fecundidad: UN, World Population Prospects (2024), procesado por OWID.
#  - Esperanza de vida: UN, World Population Prospects (2024), procesado por OWID.
#  - Nupcialidad: OECD Family Database, procesado por OWID.
#  Algunos valores fueron redondeados para facilitar la lectura.
# =====================================================================


# ---- 0. Calentamiento: R como calculadora ---------------------------

2 + 2
10 / 4
(6.41 - 1.645) / 6.41

# Guardamos valores en OBJETOS con la flecha  <-
# Se lee: "hijos_1950 recibe el valor 6.41"
hijos_1950 <- 6.41
hijos_2023 <- 1.645

hijos_1950                 # escribir el nombre muestra su contenido
hijos_1950 - hijos_2023    # ¿cuántos hijos menos por mujer?

# Un VECTOR es un conjunto de valores del mismo tipo.
# Se crea con c()  ("c" de combinar).
algunos_anios <- c(1950, 1985, 2023)
algunos_anios
length(algunos_anios)      # ¿cuántos elementos tiene?

# Los dos puntos crean una secuencia de números enteros
1950:1960

# OJO: en R el separador decimal es el PUNTO (6.41), no la coma.


# ---- 1. FECUNDIDAD: Tasa Global de Fecundidad (TGF) -----------------
#
# La TGF es el número promedio de hijos que tendría una mujer a lo
# largo de su vida si viviera, en cada edad, las tasas de fecundidad
# observadas en un año determinado. Es un indicador "de periodo":
# resume la situación de un año, no predice cuántos hijos tendrá
# una generación concreta de mujeres.
#
# Un valor cercano a 2,1 hijos por mujer se conoce como "nivel de
# reemplazo": el nivel con el que, a largo plazo y sin migración,
# una población se reemplaza a sí misma.

# 1.1 Construir el dataset ---------------------------------------------

# Vector con la TGF de Colombia, un valor por año, de 1950 a 2023
tgf <- c(
  6.410, 6.436, 6.488, 6.537, 6.582, 6.625, 6.664, 6.697, 6.723, 6.737,  # 1950-1959
  6.735, 6.712, 6.663, 6.584, 6.475, 6.333, 6.159, 5.957, 5.737, 5.506,  # 1960-1969
  5.276, 5.057, 4.857, 4.680, 4.527, 4.398, 4.285, 4.163, 3.998, 3.888,  # 1970-1979
  3.798, 3.706, 3.618, 3.501, 3.350, 3.225, 3.147, 3.087, 3.039, 3.012,  # 1980-1989
  2.995, 2.982, 2.983, 2.978, 2.937, 2.850, 2.768, 2.743, 2.717, 2.637,  # 1990-1999
  2.574, 2.522, 2.489, 2.450, 2.384, 2.309, 2.241, 2.195, 2.155, 2.096,  # 2000-2009
  2.010, 1.938, 1.899, 1.860, 1.822, 1.771, 1.719, 1.717, 1.715, 1.710,  # 2010-2019
  1.694, 1.680, 1.663, 1.645                                             # 2020-2023
)

# Verificamos: deben ser 74 valores (de 1950 a 2023)
length(tgf)
length(1950:2023)

# Unimos años y valores en una TABLA de datos (data.frame).
# Cada columna es una variable; cada fila es una observación (un año).
fecundidad <- data.frame(anio = 1950:2023, tgf = tgf)

# 1.2 Explorar el dataset ----------------------------------------------

View(fecundidad)       # abre la tabla en una pestaña (como una hoja de cálculo)
head(fecundidad)       # primeras 6 filas
tail(fecundidad)       # últimas 6 filas
nrow(fecundidad)       # número de filas
str(fecundidad)        # estructura: nombres y tipos de las columnas
summary(fecundidad)    # resumen estadístico: mínimo, máximo, media...

# El signo $ sirve para tomar UNA columna de la tabla
fecundidad$tgf
mean(fecundidad$tgf)   # promedio de todo el periodo (poco informativo, pero sirve de práctica)

# 1.3 Hacerle preguntas a los datos ------------------------------------

# ¿Cuál fue la TGF más alta y en qué año?
max(fecundidad$tgf)
fecundidad$anio[which.max(fecundidad$tgf)]

# ¿Cuál fue la más baja y en qué año?
min(fecundidad$tgf)
fecundidad$anio[which.min(fecundidad$tgf)]

# Para tomar el valor de un año específico usamos corchetes [ ]
# y la condición ==  (doble igual significa "es igual a")
tgf_1950 <- fecundidad$tgf[fecundidad$anio == 1950]
tgf_2023 <- fecundidad$tgf[fecundidad$anio == 2023]
tgf_1950
tgf_2023

# Cambio porcentual entre 1950 y 2023
cambio_pct <- (tgf_2023 - tgf_1950) / tgf_1950 * 100
round(cambio_pct, 1)   # round() redondea; aquí a 1 decimal

# ¿En qué año Colombia bajó por primera vez del nivel de reemplazo?
# subset() filtra las filas que cumplen una condición
bajo_reemplazo <- subset(fecundidad, tgf < 2.1)
head(bajo_reemplazo, 1)     # la primera fila es el primer año

# 1.4 Graficar ---------------------------------------------------------

# Gráfico de línea: el eje x es el año, el eje y la TGF
plot(fecundidad$anio, fecundidad$tgf,
     type = "l",               # "l" = línea
     lwd  = 3,                 # grosor de la línea
     col  = "darkblue",        # color
     ylim = c(0, 7),           # rango del eje y
     main = "Colombia: Tasa Global de Fecundidad, 1950-2023",
     xlab = "Año",
     ylab = "Hijos por mujer")
abline(h = 2.1, lty = 2, col = "red")   # línea horizontal punteada
text(x = 1965, y = 1.7, labels = "Nivel de reemplazo (2,1)", col = "red")
grid()                                   # cuadrícula de fondo

# Gráfico de barras con un año por década
# seq() crea una secuencia: de 1950 a 2020, de 10 en 10
seq(1950, 2020, by = 10)

decadas <- subset(fecundidad, anio %in% seq(1950, 2020, by = 10))
decadas

barplot(decadas$tgf,
        names.arg = decadas$anio,
        col  = "steelblue",
        ylim = c(0, 7),
        main = "Colombia: TGF al inicio de cada década",
        ylab = "Hijos por mujer")
abline(h = 2.1, lty = 2, col = "red")

# PARA DISCUTIR:
# - La TGF subió un poco en los años 50 antes de caer. ¿Por qué podría pasar esto?
# - ¿En qué décadas fue más rápida la caída?
# - ¿Qué procesos sociales pueden explicar el descenso? (educación de las
#   mujeres, urbanización, anticoncepción, caída de la mortalidad infantil...)


# ---- 2. ESPERANZA DE VIDA AL NACER ----------------------------------
#
# La esperanza de vida al nacer es el número promedio de años que
# viviría un recién nacido si durante toda su vida se mantuvieran las
# tasas de mortalidad por edad observadas en ese año. También es un
# indicador "de periodo": una crisis de mortalidad (una catástrofe o
# una pandemia) la hace caer de golpe ese año.

# 2.1 Construir el dataset ---------------------------------------------

ev <- c(
  48.29, 48.96, 49.81, 50.61, 51.28, 51.93, 52.52, 54.08, 54.72, 55.86,  # 1950-1959
  56.61, 57.20, 57.74, 58.30, 58.77, 59.25, 59.71, 60.15, 60.57, 61.03,  # 1960-1969
  61.46, 62.01, 62.53, 62.99, 63.50, 64.01, 64.64, 65.24, 65.83, 66.16,  # 1970-1979
  66.69, 67.19, 67.86, 68.12, 68.31, 65.36, 68.30, 68.17, 68.30, 68.62,  # 1980-1989
  68.70, 68.77, 68.76, 69.08, 69.42, 69.81, 70.21, 70.63, 70.92, 70.91,  # 1990-1999
  70.91, 71.19, 71.54, 72.31, 72.76, 73.16, 73.50, 73.75, 74.21, 74.53,  # 2000-2009
  74.88, 75.18, 75.61, 75.83, 75.95, 76.07, 76.23, 76.42, 76.58, 76.79,  # 2010-2019
  74.76, 72.70, 76.51, 77.72                                             # 2020-2023
)

length(ev)   # también deben ser 74

esperanza <- data.frame(anio = 1950:2023, ev = ev)

head(esperanza)
summary(esperanza)

# 2.2 Preguntas --------------------------------------------------------

# ¿Cuántos años de vida se ganaron entre 1950 y 2023?
ev_1950 <- esperanza$ev[esperanza$anio == 1950]
ev_2023 <- esperanza$ev[esperanza$anio == 2023]
ev_2023 - ev_1950

# ¿Hubo años en que la esperanza de vida BAJÓ?
# diff() calcula la diferencia entre cada año y el anterior.
# Agregamos un NA al inicio porque 1950 no tiene año anterior.
# NA significa "dato faltante" (Not Available).
esperanza$cambio <- c(NA, diff(esperanza$ev))
head(esperanza)

# Filtramos los años con cambio negativo
subset(esperanza, cambio < 0)

# 2.3 Graficar ---------------------------------------------------------

plot(esperanza$anio, esperanza$ev,
     type = "l", lwd = 3, col = "darkgreen",
     ylim = c(40, 80),
     main = "Colombia: esperanza de vida al nacer, 1950-2023",
     xlab = "Año",
     ylab = "Años")
grid()

# Marcamos con puntos rojos las dos caídas más fuertes
caidas <- subset(esperanza, anio %in% c(1985, 2021))
points(caidas$anio, caidas$ev, pch = 19, col = "red", cex = 1.5)
text(caidas$anio, caidas$ev - 2.5, labels = caidas$anio, col = "red")

# Gráfico de barras del cambio anual: rojo si bajó, gris si subió.
# ifelse() elige un valor u otro según se cumpla o no la condición.
colores <- ifelse(esperanza$cambio < 0, "red", "grey60")

barplot(esperanza$cambio,
        names.arg = esperanza$anio,
        col = colores,
        border = NA,
        ylim = c(-3.5, 4.5),
        las = 2,             # pone las etiquetas del eje x en vertical
        cex.names = 0.6,     # tamaño de las etiquetas
        main = "Cambio anual en la esperanza de vida (años)",
        ylab = "Diferencia con el año anterior")

# PARA DISCUTIR:
# - Entre mediados de los 80 y mediados de los 90 la esperanza de vida
#   casi se estanca. ¿Qué pasaba en Colombia en esos años?
#   (pista: la violencia homicida, que afectó sobre todo a hombres jóvenes)
# - 2020-2021: ¿qué efecto tuvo la pandemia de COVID-19? ¿Se recuperó?


# ---- 3. NUPCIALIDAD: tasa bruta de nupcialidad ----------------------
#
# La tasa bruta de nupcialidad es el número de matrimonios registrados
# en un año por cada 1.000 habitantes:
#
#     tasa = (matrimonios del año / población total) x 1.000
#
# Advertencias importantes:
# - Solo cuenta matrimonios FORMALES registrados. En Colombia la unión
#   libre está muy extendida, así que esta tasa subestima la formación
#   de parejas.
# - Es una tasa "bruta": depende también de la estructura por edad de
#   la población, no solo del comportamiento de las personas.
# - OWID solo tiene datos de Colombia para 2011-2022.
#
# Para comparar, incluimos Chile y México (misma fuente).

# 3.1 Construir el dataset ---------------------------------------------

nupcialidad <- data.frame(
  anio     = 2011:2022,
  colombia = c(0.80, 1.46, 1.40, 1.40, 1.33, 1.27, 1.20, 1.15, 1.13, 0.85, 1.22, 1.39),
  chile    = c(3.76, 3.65, 3.48, 3.64, 3.43, 3.43, 3.33, 3.37, 3.20, 1.90, 2.70, NA),
  mexico   = c(4.90, 5.00, 4.90, 4.80, 4.60, 4.40, 4.20, 4.00, 4.00, 2.70, 3.60, 3.90)
)
# Chile no tiene dato para 2022, por eso escribimos NA (dato faltante)

nupcialidad

# 3.2 Preguntas --------------------------------------------------------

mean(nupcialidad$colombia)
mean(nupcialidad$mexico)

# Con Chile el promedio da NA, porque falta un dato...
mean(nupcialidad$chile)
# ...así que le pedimos a R que ignore los NA con na.rm = TRUE
mean(nupcialidad$chile, na.rm = TRUE)

# ¿Cuántas veces más alta es la tasa de México que la de Colombia en 2019?
nupcialidad$mexico[nupcialidad$anio == 2019] / nupcialidad$colombia[nupcialidad$anio == 2019]

# 3.3 Graficar ---------------------------------------------------------

# Barras para Colombia, resaltando los años atípicos
colores_nup <- ifelse(nupcialidad$anio %in% c(2011, 2020), "orange", "steelblue")

barplot(nupcialidad$colombia,
        names.arg = nupcialidad$anio,
        col  = colores_nup,
        ylim = c(0, 2),
        main = "Colombia: matrimonios por cada 1.000 habitantes",
        ylab = "Tasa bruta de nupcialidad")

# Comparación de los tres países con líneas.
# type = "b" dibuja línea y puntos ("both").
# Primero se dibuja un país con plot() y luego se AGREGAN los otros con lines().
plot(nupcialidad$anio, nupcialidad$colombia,
     type = "b", pch = 19, lwd = 2, col = "gold3",
     ylim = c(0, 6),
     main = "Tasa bruta de nupcialidad, 2011-2022",
     xlab = "Año",
     ylab = "Matrimonios por cada 1.000 habitantes")
lines(nupcialidad$anio, nupcialidad$chile,  type = "b", pch = 19, lwd = 2, col = "firebrick")
lines(nupcialidad$anio, nupcialidad$mexico, type = "b", pch = 19, lwd = 2, col = "darkgreen")
legend("topright",
       legend = c("Colombia", "Chile", "México"),
       col    = c("gold3", "firebrick", "darkgreen"),
       lwd = 2, pch = 19, bty = "n")
grid()

# PARA DISCUTIR:
# - El dato de 2011 (0,80) es mucho más bajo que los de 2012 en adelante.
#   ¿Es un cambio real o puede ser un problema de registro o cobertura?
#   ¿Cómo lo verificaríamos? (por ejemplo, con estadísticas vitales del DANE)
# - ¿Qué pasó en 2020 en los tres países? ¿Por qué?
# - ¿Por qué la tasa de Colombia es tan baja comparada con Chile y México?
#   ¿Qué nos dice (y qué NO nos dice) sobre las parejas en Colombia?


# ---- 4. JUNTANDO INDICADORES: fecundidad y esperanza de vida ---------
#
# La teoría de la transición demográfica plantea que primero cae la
# mortalidad (sube la esperanza de vida) y después cae la fecundidad.
# Veamos cómo se relacionan ambos indicadores en Colombia.

# merge() une dos tablas usando una columna en común (aquí, el año)
transicion <- merge(fecundidad, esperanza, by = "anio")
head(transicion)

# Diagrama de dispersión: cada punto es un año
plot(transicion$ev, transicion$tgf,
     pch = 19, col = "purple",
     xlim = c(45, 82),
     main = "Colombia 1950-2023: esperanza de vida vs. fecundidad",
     xlab = "Esperanza de vida al nacer (años)",
     ylab = "Hijos por mujer")
grid()

# Etiquetamos algunos años para orientarnos
etiquetas <- subset(transicion, anio %in% c(1950, 1970, 1990, 2010, 2023))
text(etiquetas$ev, etiquetas$tgf, labels = etiquetas$anio, pos = 4, cex = 0.8)

# Correlación: va de -1 a 1. Cerca de -1 = cuando una sube, la otra baja.
cor(transicion$ev, transicion$tgf)
# Recuerde: correlación no es causalidad. Ambas variables cambian
# con el tiempo y responden a procesos sociales más amplios.

# Un "tablero" con los tres indicadores lado a lado.
# par(mfrow = c(1, 3)) divide la ventana en 1 fila y 3 columnas.
par(mfrow = c(1, 3))

plot(fecundidad$anio, fecundidad$tgf, type = "l", lwd = 2, col = "darkblue",
     main = "Fecundidad (TGF)", xlab = "Año", ylab = "Hijos por mujer")
plot(esperanza$anio, esperanza$ev, type = "l", lwd = 2, col = "darkgreen",
     main = "Esperanza de vida", xlab = "Año", ylab = "Años")
plot(nupcialidad$anio, nupcialidad$colombia, type = "b", pch = 19, col = "gold3",
     main = "Nupcialidad", xlab = "Año", ylab = "Por 1.000 hab.")

par(mfrow = c(1, 1))   # volvemos a un solo gráfico por ventana


# ---- 5. GUARDAR RESULTADOS ------------------------------------------

# ¿En qué carpeta se guardan los archivos? (directorio de trabajo)
getwd()

# Guardar las tablas como archivos CSV (se abren en Excel)
write.csv(fecundidad,  "fecundidad_colombia.csv",  row.names = FALSE)
write.csv(esperanza,   "esperanza_vida_colombia.csv", row.names = FALSE)
write.csv(nupcialidad, "nupcialidad_comparada.csv",  row.names = FALSE)

# Guardar un gráfico como imagen PNG:
# 1) abrir el archivo con png(), 2) dibujar, 3) cerrar con dev.off()
png("fecundidad_colombia.png", width = 900, height = 600)
plot(fecundidad$anio, fecundidad$tgf, type = "l", lwd = 3, col = "darkblue",
     ylim = c(0, 7),
     main = "Colombia: Tasa Global de Fecundidad, 1950-2023",
     xlab = "Año", ylab = "Hijos por mujer")
abline(h = 2.1, lty = 2, col = "red")
dev.off()

# (También puede usar el botón "Export" de la pestaña Plots.)


# ---- 6. EJERCICIOS ---------------------------------------------------
#
#
# E1. Calcule la TGF promedio de la década de 1970.
#     Pista:  mean(subset(fecundidad, anio >= 1970 & anio <= 1979)$tgf)
#
# E2. ¿Cuántos años de esperanza de vida se ganaron entre 1950 y 2019,
#     es decir, antes de la pandemia?
#
# E3. ¿En qué año la esperanza de vida en Colombia superó por primera
#     vez los 70 años?  Pista: use subset() y head(..., 1)
#
# ---- EXTRA: descargar los datos directamente de OWID ------------------
#
# Si tiene conexión a internet, puede leer los datos completos (todos
# los países) sin copiarlos a mano. Quite el # de las líneas para probar:
#
# owid_tgf <- read.csv("https://ourworldindata.org/grapher/children-per-woman-un.csv?v=1&csvType=full&useColumnShortNames=false")
# head(owid_tgf)
# colombia_tgf <- subset(owid_tgf, Entity == "Colombia")
# head(colombia_tgf)
#
# Lo mismo funciona con:
#   https://ourworldindata.org/grapher/life-expectancy.csv
#   https://ourworldindata.org/grapher/marriage-rate-per-1000-inhabitants.csv?v=1&csvType=full&useColumnShortNames=false

# =====================================================================
# FIN DEL TALLER
# =====================================================================
