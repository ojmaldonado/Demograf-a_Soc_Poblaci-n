# Datos reales del documento (Magdalena, proyecciones DANE 2020)
# Instrucciones para construir pirámides poblacionales

# La pirámide poblacional es un histograma de frecuencias doble en forma horizontal en el cual se representan las frecuencias en el eje de las abscisas y las edades 
# (generalmente en forma quinquenal) en el eje de las ordenadas. Las edades menores se encuentran más cerca de la base y las edades mayores hacia la cúspide. 
# Usualmente las mujeres se colocan en el lado izquierdo y los hombres en el lado derecho.

La pirámide poblacional permite observar fenómenos demográficos tales como natalidad, mortalidad, distribución por género, distribución por edades o migraciones.

install.packages("pyramid")
library(pyramid)

Edad <- c("0","1-4","5-9","10-14","15-19","20-24","25-29","30-34",
          "35-39","40-44","45-49","50-54","55-59","60-64","65-69",
          "70-74","75-79","80+")

Hombres <- c(7237997,7140898,6755461,6274734,5794697,5315876,4839412,4366228,
             3896724,3431316,2971243,2518631,2076961,1651890,1251696,
             888724,578553,336903)

Mujeres <- c(7670919,7572985,7185128,6701851,6219305,5737676,5257418,4778795,
             4302166,3828361,3358356,2893711,2437026,1991572,1561456,
             1154812,783906,467084)

Pob_Hallownest = data.frame(Edad, Hombres, Mujeres)

print(Pob_Hallownest)

H1 = round(Hombres/1000)
M1 = round(Mujeres/1000)

Pob_hallownest = data.frame(H1, M1, Edad)
print(Pob_hallownest)

pyramid(Pob_hallownest,Llab = "Hombres", Rlab = "Mujeres",Clab = "Edad", main="Población Hallownest 2020 (en miles)",Lcol = "red", Rcol = "green", Cgap = 0.5 )

Poblacion_Total = sum(Mujeres, Hombres)

Densidad_Pob= Poblacion_Total/500
print(Densidad_Pob)

Total <- Hombres + Mujeres
print(Total)
