# Taller — Crecimiento poblacional y la *trampa malthusiana*
### Una aproximación desde el modelamiento basado en agentes (ABM)

**Curso:** Dinámica Poblacional y Demografía
**Modalidad:** Sesión práctica con simulación en el navegador (no requiere instalación)
**Duración estimada:** 2.5 – 3 horas
**Herramienta:** Modelo *Wolf Sheep Predation* en NetLogo Web

---

## 1. Objetivos de aprendizaje

Al finalizar el taller, cada estudiante estará en capacidad de:

1. **Explicar** el argumento central de la trampa malthusiana (crecimiento geométrico de la población frente a crecimiento aritmético de los medios de subsistencia) y distinguir entre *frenos preventivos* y *frenos positivos*.
2. **Manipular** un modelo depredador-presa para observar cómo emergen la capacidad de carga, las oscilaciones poblacionales y los episodios de *sobrepaso y colapso* (*overshoot and collapse*).
3. **Traducir** los parámetros de un modelo ecológico a categorías demográficas y discutir hasta dónde la analogía es fértil y dónde se rompe.
4. **Evaluar críticamente** el estatus epistemológico de un ABM: qué tipo de conocimiento produce una simulación y qué precauciones exige su interpretación.

---

## 2. Marco conceptual

### 2.1 La trampa malthusiana

En el *Ensayo sobre el principio de población* (1798), Thomas Malthus formula una tensión entre dos ritmos de crecimiento:

- La **población**, si no encuentra obstáculos, tiende a crecer de forma **geométrica** (1, 2, 4, 8, 16…).
- Los **medios de subsistencia** crecen, en el mejor de los casos, de forma **aritmética** (1, 2, 3, 4, 5…).

De ese desajuste se sigue que ninguna población puede crecer indefinidamente: tarde o temprano choca contra el límite de los recursos disponibles. Ese límite regula el tamaño de la población mediante dos tipos de frenos:

| Tipo de freno | Mecanismo | Efecto demográfico | Ejemplos |
|---|---|---|---|
| **Preventivo** | Reduce la natalidad | Menos nacimientos | Matrimonio tardío, "restricción moral", control de la fecundidad |
| **Positivo** | Aumenta la mortalidad | Más muertes | Hambruna, epidemias, guerra |

La **trampa** consiste en que toda ganancia de productividad se disuelve en más bocas que alimentar: la población crece hasta reabsorber el excedente y el nivel de vida promedio regresa a la subsistencia. En términos contemporáneos, hablamos de una **capacidad de carga** (*carrying capacity*): el tamaño poblacional máximo que un entorno puede sostener de forma estable dado un flujo de recursos.

> **Idea clave para el taller:** la capacidad de carga no es un número fijado de antemano. En un sistema complejo, *emerge* de la interacción entre la reproducción, el consumo y la renovación de los recursos. Precisamente eso es lo que un ABM nos permite *ver* funcionar.

### 2.2 ¿Por qué un modelo de lobos y ovejas para pensar la población humana?

El modelo que usaremos es un clásico **depredador-presa** de la ecología, emparentado con las ecuaciones de Lotka-Volterra. No es un modelo de población humana: es una **analogía deliberadamente simple**. Su valor pedagógico está justamente ahí. Al reducir el problema a ovejas que comen pasto y lobos que comen ovejas, podemos aislar el mecanismo malthusiano fundamental —población contra recurso— y observarlo sin el ruido de la tecnología, las instituciones o la cultura.

En la Parte 4 discutiremos qué se pierde en esa reducción. Por ahora, adoptamos la analogía como un **experimento mental** al que le podemos "dar cuerda".

### 2.3 El modelamiento basado en agentes (ABM) en cinco ideas

Siguiendo la guía de Chueca Del Cerro (2026), un ABM es una simulación que reconstruye un sistema complejo a partir de sus componentes individuales y sus interacciones. Cinco rasgos lo definen:

1. **Enfoque de abajo hacia arriba (*bottom-up*).** No se programa el resultado agregado; se programan las reglas de los individuos y el patrón colectivo *emerge* de sus interacciones.
2. **Emergencia.** El todo es más que la suma de las partes: comportamientos macro (una oscilación poblacional, un colapso) que ningún agente "decidió".
3. **Agentes autónomos y heterogéneos.** Cada agente sigue reglas simples, tiene características propias (aquí: su energía) y actúa sin control central.
4. **Racionalidad limitada.** Los agentes deciden con información y recursos parciales sobre su entorno inmediato.
5. **Experimentos de contrafactuales.** Un ABM sirve para explorar escenarios "¿qué pasaría si…?" y las consecuencias de una posición teórica, más que para predecir el futuro con exactitud.

En NetLogo, los agentes se llaman **turtles** (aquí, ovejas y lobos) y el entorno se compone de **patches** (aquí, las celdas de pasto).

---

## 3. El modelo *Wolf Sheep Predation*

Antes de simular, describimos el modelo con una versión ligera del protocolo **ODD** (*Overview, Design concepts, Details*) que menciona la guía. Esto es parte del oficio: un modelo solo es interpretable si sabemos qué representa cada pieza.

### 3.1 Agentes, entorno y reglas

- **Ovejas** (presa): se mueven, gastan energía al moverse, ganan energía al comer pasto, se reproducen con cierta probabilidad y mueren si su energía llega a cero.
- **Lobos** (depredador): se mueven, gastan energía, ganan energía al comer ovejas, se reproducen con cierta probabilidad y mueren si su energía llega a cero.
- **Pasto** (recurso / entorno): cada celda está "con pasto" o "sin pasto". Cuando una oveja se lo come, la celda queda pelada y tarda un número fijo de pasos (*ticks*) en volver a crecer.

### 3.2 Las dos versiones del modelo

El selector **`model-version`** cambia por completo la lógica del sistema:

- **`sheep-wolves`**: el pasto es **ilimitado**. Las ovejas nunca pasan hambre; la única mortalidad es la depredación. El sistema es un depredador-presa "puro".
- **`sheep-wolves-grass`**: el pasto es **limitado y se regenera con demora**. Ahora las ovejas también pueden morir de hambre. Este es el escenario propiamente malthusiano.

### 3.3 Traducción demográfica de los parámetros

Esta tabla es el corazón del taller. Téngala a la vista durante toda la sesión.

| Parámetro NetLogo | Qué controla | Lectura demográfica / malthusiana |
|---|---|---|
| `initial-number-sheep` | Población inicial de ovejas | Tamaño poblacional de partida |
| `initial-number-wolves` | Población inicial de lobos | Intensidad inicial del freno positivo (mortalidad externa) |
| `sheep-reproduce` (%) | Probabilidad de reproducción de ovejas | Tasa de natalidad / potencial de crecimiento geométrico |
| `grass-regrowth-time` | Pasos que tarda el pasto en volver a crecer | Ritmo de renovación de los medios de subsistencia (crecimiento "aritmético") |
| `sheep-gain-from-food` | Energía que gana una oveja al comer | Productividad del recurso por unidad consumida |
| `wolf-gain-from-food` | Energía que gana un lobo al comer | Eficiencia del freno positivo |
| `wolf-reproduce` (%) | Probabilidad de reproducción de lobos | Retroalimentación del freno de mortalidad |
| Muerte por energía = 0 | Inanición | **Freno positivo** malthusiano (hambruna) |
| Depredación | Muerte por lobos | **Freno positivo** análogo a guerra/epidemia |

> **Ovejas ↔ población. Pasto ↔ subsistencia. Regeneración lenta del pasto ↔ límite malthusiano.**

---

## 4. Ejercicios guiados

Abra el modelo aquí (funciona en el navegador, sin instalar nada):
**[Wolf Sheep Predation en NetLogo Web](https://www.netlogoweb.org/launch#https://www.netlogoweb.org/assets/modelslib/Sample%20Models/Biology/Wolf%20Sheep%20Predation.nlogox)**

**Cómo operar el modelo:** pulse `setup` para inicializar, `go` para correr en continuo (púlselo de nuevo para pausar). Mueva los deslizadores *antes* de `setup` para fijar condiciones iniciales; algunos pueden moverse en caliente. Observe los **monitores** (número de ovejas, lobos, pasto) y el **gráfico de poblaciones** en el tiempo.

> **Registre sus resultados.** Para cada ejercicio, use la plantilla de la sección 4.6. Un modelo sin registro no enseña nada; el dato es la mitad del experimento.

### 4.0 Calentamiento (5 min)

Ponga `model-version` en **`sheep-wolves`**, deje los valores por defecto, pulse `setup` y luego `go`. Deje correr un par de minutos. Observe el gráfico sin tocar nada.

- ¿Las poblaciones se estabilizan, oscilan o alguna se extingue?
- ¿Quién sube primero, la presa o el depredador? ¿Por qué ese orden?

### 4.1 Crecimiento sin límite: solo frenos positivos (15 min)

Mantenga **`sheep-wolves`** (pasto ilimitado). Corra la simulación varias veces (`setup` + `go`) sin cambiar parámetros.

- Con pasto infinito, la única regulación de las ovejas son los lobos. ¿El sistema encuentra un equilibrio o produce **auges y caídas** (*boom and bust*) cada vez más violentos?
- Corra la simulación **cinco veces**. ¿Los resultados son idénticos? ¿Alguna corrida termina en extinción de una especie? Anote cuántas.

**Conexión:** aquí el crecimiento poblacional solo está frenado por la mortalidad (depredación). Es un mundo malthusiano *sin límite de subsistencia*: paradójicamente, esa ausencia de techo lo vuelve **más inestable**, no más próspero.

### 4.2 Introducir la subsistencia como capacidad de carga (20 min)

Cambie `model-version` a **`sheep-wolves-grass`**. Deje el resto por defecto. `setup` + `go`.

- Ahora el pasto es finito y las ovejas pueden morir de hambre. Deje correr varios minutos. ¿Aparece una **oscilación sostenida** alrededor de un nivel más o menos estable?
- Compare la *forma* del gráfico con la del ejercicio 4.1. ¿Cuál se parece más a un sistema que "se autorregula"?

**Conexión clave:** el límite de recursos, lejos de ser solo una catástrofe, introduce una **capacidad de carga emergente**. Nadie la programó: surge de la interacción entre reproducción, consumo y regeneración. Este es el sentido más profundo de la "trampa": es a la vez un límite *y* un equilibrio en torno a la subsistencia.

### 4.3 El ritmo de la subsistencia: manipular la regeneración del pasto (20 min)

Trabaje en **`sheep-wolves-grass`**. Varíe únicamente **`grass-regrowth-time`** y deje todo lo demás fijo. Pruebe tres valores: **bajo** (p. ej. 10), **medio** (p. ej. 30) y **alto** (p. ej. 60). Corra cada configuración el mismo tiempo y registre el número promedio de ovejas.

- Un `grass-regrowth-time` alto = el recurso se renueva **más lento** = medios de subsistencia más escasos. ¿Cómo cambia la población de ovejas que el sistema puede sostener?
- ¿Puede identificar un umbral en el que el pasto se renueva tan lento que la población de ovejas colapsa?

**Conexión:** este deslizador es el corazón cuantitativo del argumento malthusiano. Modela el ritmo (casi "aritmético") con que se renuevan los alimentos frente al potencial geométrico de reproducción de las ovejas.

### 4.4 Sobrepaso y colapso (*overshoot and collapse*) (15 min)

Busque, en la versión **`sheep-wolves-grass`**, una combinación de parámetros que produzca una población que **crece rápido, agota el pasto y colapsa** (idealmente hasta la extinción). Pistas: suba `sheep-reproduce`, suba `sheep-gain-from-food` y/o alargue `grass-regrowth-time`; puede reducir los lobos para aislar el efecto del hambre.

- Describa la secuencia: ¿qué pasa con el pasto justo antes del colapso de las ovejas?
- ¿El colapso es gradual o abrupto? ¿Se recupera el sistema o la extinción es definitiva?

**Conexión:** esto es una **catástrofe malthusiana** en miniatura. La población sobrepasa la capacidad de carga porque la reproducción "no ve" el límite del recurso hasta que ya es tarde. Es el argumento clásico de un *punto de inflexión* (*tipping point*) en un sistema complejo.

### 4.5 Frenos preventivos vs. positivos (10 min)

Reflexione con el modelo en mano:

- Bajar `sheep-reproduce` equivale a un **freno preventivo** (menos nacimientos). Súbalo y bájelo: ¿estabiliza o desestabiliza el sistema?
- Subir el número de lobos o su eficiencia (`wolf-gain-from-food`) equivale a intensificar un **freno positivo** (más mortalidad). Compare el "costo" sistémico de regular la población por natalidad frente a regularla por mortalidad.

**Conexión:** Malthus prefería los frenos preventivos precisamente porque los positivos operan a través del sufrimiento. El modelo permite *sentir* esa diferencia en la dinámica del sistema.

### 4.6 Plantilla de registro

Complete una fila por corrida:

| Corrida | model-version | grass-regrowth-time | sheep-reproduce | N.º inicial lobos | Resultado (estable / oscila / colapsa / extinción) | N.º ovejas aprox. al estabilizarse | Observaciones |
|---|---|---|---|---|---|---|---|
| 1 | | | | | | | |
| 2 | | | | | | | |
| 3 | | | | | | | |
| 4 | | | | | | | |
| 5 | | | | | | | |

---

## 5. Discusión crítica

### 5.1 Del modelo a la demografía

1. **Capacidad de carga.** El modelo la hace visible como propiedad emergente. En poblaciones humanas, ¿qué la determina? ¿Es fija? ¿Quién la define y con qué supuestos?
2. **Frenos.** Identificamos frenos positivos (hambre, depredación) en el modelo. ¿Dónde están los frenos *preventivos* de Malthus, y por qué son difíciles de representar con ovejas?
3. **Oscilaciones vs. equilibrio.** Las poblaciones reales rara vez descansan en un punto fijo; oscilan. ¿Qué añade el modelo a nuestra intuición sobre esas fluctuaciones?

### 5.2 Las grandes críticas a Malthus

El modelo reproduce la lógica malthusiana con fidelidad… y por eso mismo hereda sus puntos ciegos. Discuta:

- **Ester Boserup:** invirtió el argumento. La presión demográfica no solo produce hambre; también **induce innovación agrícola**. En el modelo, `grass-regrowth-time` y `sheep-gain-from-food` son *constantes*. ¿Qué habría que cambiar para que el sistema "aprenda" a producir más comida cuando hay más bocas?
- **Cambio tecnológico.** Malthus escribió justo antes de que la Revolución Industrial rompiera la relación histórica entre población y subsistencia. La "gran escapada" de la trampa. Ningún parámetro del modelo captura esto.
- **La transición demográfica.** En las sociedades humanas, la fecundidad **cae** con el desarrollo (un freno preventivo endógeno que Malthus no anticipó en su magnitud). Las ovejas no deciden tener menos crías cuando mejora su nivel de vida. ¿Qué implica esa diferencia?
- **Instituciones, poder y distribución.** El hambre rara vez es solo cuestión de cantidad total de alimento (cf. Amartya Sen). El modelo no tiene mercados, propiedad ni desigualdad. ¿Qué fenómenos quedan fuera?

### 5.3 Reflexión sobre el estatus del modelo

Cierre la sesión volviendo sobre el ABM como método:

- Un ABM es un **experimento mental "opaco"**: nos deja explorar las consecuencias de unos supuestos, no describir el mundo. ¿Qué hemos *aprendido* con este modelo que no supiéramos ya, y qué solo hemos *ilustrado*?
- **Abstracción.** El modelo es deliberadamente irreal. ¿Esa simplicidad es una debilidad o la fuente de su poder explicativo?
- **Validación y calibración.** No calibramos el modelo contra datos reales. ¿Qué haría falta para pasar de este experimento conceptual a un modelo empíricamente fundamentado de una población concreta? ¿Sería deseable, o perderíamos claridad?

---

## 6. Entregable

Un reporte breve (máx. 2 páginas) que incluya:

1. La tabla de registro completa (sección 4.6).
2. Un gráfico o descripción de **un** escenario de colapso que hayan producido, explicando la secuencia causal.
3. Un párrafo que responda: *¿En qué sentido este modelo apoya la tesis malthusiana y en qué sentido, al hacerla explícita, revela sus límites para pensar poblaciones humanas?*
4. Una crítica metodológica de una frase: la simplificación del modelo que más les incomodó y por qué.

---

## 7. Recursos

- **Modelo:** Wilensky, U. (1997). *Wolf Sheep Predation.* NetLogo Models Library. Versión web: https://www.netlogoweb.org/launch#https://www.netlogoweb.org/assets/modelslib/Sample%20Models/Biology/Wolf%20Sheep%20Predation.nlogox
- **Guía de ABM:** Chueca Del Cerro, C. (2026). *What is Agent-Based Modeling?* (GESIS Guides to Digital Behavioral Data, 21). https://doi.org/10.60762/ggdbd25021.1.0
- **Lecturas de apoyo sugeridas:** Malthus, T. (1798), *An Essay on the Principle of Population*; Boserup, E. (1965), *The Conditions of Agricultural Growth*; Epstein, J. & Axtell, R. (1996), *Growing Artificial Societies* (para el vínculo entre subsistencia, agentes y desigualdad, vía el modelo Sugarscape).
