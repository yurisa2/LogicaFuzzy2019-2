library("sf")
library("FuzzyR")


setwd("C:/Bitnami/wampstack-7.1.28-0/apache2/htdocs/LogicaFuzzy2019-2/ArtigoFinal")
# Tem que colocar a pasta que ele est�, se for no windows, trocar as \ por /

camadas_unidas <- read_sf("ShapeFiles/camadas_unidas.shp")

CN <- camadas_unidas$CN
Declividade <- camadas_unidas$Slope
Permeabilidade <- camadas_unidas$PER

# cria FIS PERCOLACAO COM dois FIS o processamento � mais r�pido
# (mas a gente pode dizer que foi um S�, sem crise)

fis_TP <- newfis("Tanque Percola��o")

#adiciona variaveis
fis_TP <- addvar(fis_TP, "input", "CN", c(0,100))
fis_TP <- addvar(fis_TP, "input", "Declividade", c(0,160))
fis_TP <- addvar(fis_TP, "input", "Permeabilidade", c(0,1000))
fis_TP <- addvar(fis_TP, "output", "TPercolacao", c(0,1))

#Cria Membership Functions
fis_TP <- addmf(fis_TP, "input", 1, "baixa", "trapmf", c(0,0,40,55))
fis_TP <- addmf(fis_TP, "input", 1, "media", "trapmf", c(40,55,60,75))
fis_TP <- addmf(fis_TP, "input", 1, "alta", "trapmf", c(60,75,100,100))

fis_TP <- addmf(fis_TP, "input", 2, "baixa", "trapmf", c(0,0,5,6))
fis_TP <- addmf(fis_TP, "input", 2, "media", "trapmf", c(5,6,20,30))
fis_TP <- addmf(fis_TP, "input", 2, "alta", "trapmf", c(20,30,160,160))

fis_TP <- addmf(fis_TP, "input", 3, "baixa", "trapmf", c(0,0,50,150))
fis_TP <- addmf(fis_TP, "input", 3, "media", "trapmf", c(50,150,225,400))
fis_TP <- addmf(fis_TP, "input", 3, "alta", "trapmf", c(225,400,1000,1000))


fis_TP <- addmf(fis_TP, "output", 1, "MuitoBaixa", "trimf", c(0,0,0.25))
fis_TP <- addmf(fis_TP, "output", 1, "Baixa", "trimf", c(0,0.25,0.5))
fis_TP <- addmf(fis_TP, "output", 1, "media", "trimf", c(0.25,0.5,0.75))
fis_TP <- addmf(fis_TP, "output", 1, "Alta", "trimf", c(0.5,0.75,1))
fis_TP <- addmf(fis_TP, "output", 1, "MuitoAlta", "trimf", c(0.75,1,1))

plotmf(fis_TP,"input",1)
plotmf(fis_TP,"input",2)
plotmf(fis_TP,"input",3)

plotmf(fis_TP,"output",1)


ruleList <- rbind(c(1,1,1,1,1,1),
                  c(1,1,2,3,1,1),
                  c(1,1,3,4,1,1),
                  c(1,2,1,2,1,1),
                  c(1,2,2,3,1,1),
                  c(1,2,3,4,1,1),
                  c(1,3,1,1,1,1),
                  c(1,3,2,2,1,1),
                  c(1,3,3,4,1,1),

                  c(2,1,1,2,1,1),
                  c(2,1,2,3,1,1),
                  c(2,1,3,4,1,1),
                  c(2,2,1,1,1,1),
                  c(2,2,2,3,1,1),
                  c(2,2,3,4,1,1),
                  c(2,3,1,1,1,1),
                  c(2,3,2,2,1,1),
                  c(2,3,3,4,1,1),

                  c(3,1,1,2,1,1),
                  c(3,1,2,3,1,1),
                  c(3,1,3,5,1,1),
                  c(3,2,1,2,1,1),
                  c(3,2,2,3,1,1),
                  c(3,2,3,5,1,1),
                  c(3,3,1,1,1,1),
                  c(3,3,2,3,1,1),
                  c(3,3,3,4,1,1)

                  )

fis_TP <- addrule(fis_TP,matrix(ruleList,ncol=6)) # Adiciona as regras
# showrule(fis_TP) # Mostra As regras

#cria FIS TANQUE AGRICOLA
fis_TA <- newfis("Tanque Agricola")

#adiciona variaveis
fis_TA <- addvar(fis_TA, "input", "CN", c(0,100))
fis_TA <- addvar(fis_TA, "input", "Declividade", c(0,160))
fis_TA <- addvar(fis_TA, "input", "Permeabilidade", c(0,1000))
fis_TA <- addvar(fis_TA, "output", "TPercolacao", c(0,1))

#Cria Membership Functions
fis_TA <- addmf(fis_TA, "input", 1, "baixa", "trapmf", c(0,0,40,55))
fis_TA <- addmf(fis_TA, "input", 1, "media", "trapmf", c(40,55,60,75))
fis_TA <- addmf(fis_TA, "input", 1, "alta", "trapmf", c(60,75,100,100))

fis_TA <- addmf(fis_TA, "input", 2, "baixa", "trapmf", c(0,0,5,6))
fis_TA <- addmf(fis_TA, "input", 2, "media", "trapmf", c(5,6,20,30))
fis_TA <- addmf(fis_TA, "input", 2, "alta", "trapmf", c(20,30,160,160))

fis_TA <- addmf(fis_TA, "input", 3, "baixa", "trapmf", c(0,0,50,150))
fis_TA <- addmf(fis_TA, "input", 3, "media", "trapmf", c(50,150,225,400))
fis_TA <- addmf(fis_TA, "input", 3, "alta", "trapmf", c(225,400,1000,1000))

fis_TA <- addmf(fis_TA, "output", 1, "MuitoBaixa", "trimf", c(0,0,0.25))
fis_TA <- addmf(fis_TA, "output", 1, "Baixa", "trimf", c(0,0.25,0.5))
fis_TA <- addmf(fis_TA, "output", 1, "media", "trimf", c(0.25,0.5,0.75))
fis_TA <- addmf(fis_TA, "output", 1, "Alta", "trimf", c(0.5,0.75,1))
fis_TA <- addmf(fis_TA, "output", 1, "MuitoAlta", "trimf", c(0.75,1,1))


ruleList <- rbind(c(1,1,1,4,1,1),
                  c(1,1,2,2,1,1),
                  c(1,1,3,1,1,1),
                  c(1,2,1,4,1,1),
                  c(1,2,2,2,1,1),
                  c(1,2,3,1,1,1),
                  c(1,3,1,4,1,1),
                  c(1,3,2,3,1,1),
                  c(1,3,3,1,1,1),

                  c(2,1,1,5,1,1),
                  c(2,1,2,3,1,1),
                  c(2,1,3,1,1,1),
                  c(2,2,1,5,1,1),
                  c(2,2,2,3,1,1),
                  c(2,2,3,2,1,1),
                  c(2,3,1,4,1,1),
                  c(2,3,2,3,1,1),
                  c(2,3,3,1,1,1),

                  c(3,1,1,5,1,1),
                  c(3,1,2,3,1,1),
                  c(3,1,3,2,1,1),
                  c(3,2,1,5,1,1),
                  c(3,2,2,3,1,1),
                  c(3,2,3,2,1,1),
                  c(3,3,1,4,1,1),
                  c(3,3,2,2,1,1),
                  c(3,3,3,1,1,1)

)

fis_TA <- addrule(fis_TA,matrix(ruleList,ncol=6))
# showrule(fis_TA) # Mostra As regras

# Tudo Lido, modelos criados, vamos executar

# Cria uma entrada para os FIS's
entrada <- cbind(CN,Declividade,Permeabilidade)
entrada <- matrix(entrada, ncol = 3)

# Verifica��es da Entrada
str(entrada)
summary(entrada)


# Executa os FIS
resultadoTAgr <- evalfis(entrada,fis_TA)
resultadoTPerc <- evalfis(entrada,fis_TP)

# Copia o objeto em outro SHP
shp_results <- camadas_unidas

# Copia o resultado dos FISs para o Objeto SHP
shp_results$TA <- as.vector(resultadoTAgr)
shp_results$TP <- as.vector(resultadoTPerc)

shp_graph <- shp_results
shp_graph$geometry <- NULL

# Mostrar sumarios
summary(shp_graph)

summary(cbind(shp_graph$TA,shp_graph$TP))

# Graficos
hist(shp_graph$TP)
hist(shp_graph$TA)

boxplot(shp_graph$TP)
boxplot(shp_graph$TA)

testelm <- lm(shp_graph$TP ~ camadas_unidas$CN + camadas_unidas$PER + camadas_unidas$Slope)
testeglm <- glm(shp_graph$TP ~ camadas_unidas$CN + camadas_unidas$PER + camadas_unidas$Slope)

plot(testelm)
anova(testelm)


hist(shp_results$TA)
hist(resultadoTPerc)

h <- hist(shp_results$TA, 
     breaks=c(0.0,0.33,0.66,1), 
     xlab='Classifica��o Fuzzy da Adequabilidade', 
     ylab='Densidade', 
     main='Distribui��o da adequabilidade do Tanque Agr�cola', 
     col= c('dodgerblue','lightyellow1','brown'), labels=TRUE)


histPercent <- function(x, ...) {
  H <- hist(x, plot = FALSE,breaks=c(0.0,0.33,0.66,1)
            )
  H$density <- with(H, 100 * density* diff(breaks)[1])
  labs <- paste(round(H$density), "%", sep="")
  plot(H, freq = FALSE, 
       labels = labs, 
       
       col= c('dodgerblue','lightyellow1','brown'),
       ylim=c(0, 1.08*max(H$density)),
       xlab='Classifica��o Fuzzy da Adequabilidade', 
       ylab='% dos pontos', ...)
}


histPercent(shp_results$TA, main='Distribui��o da adequabilidade do Tanque Agr�cola')
histPercent(shp_results$TP, main='Distribui��o da adequabilidade do Tanque  de Percola��o')

hist(shp_results$TA)


# Escrever o Shapefile final
st_write(shp_results, "ShapeFiles/output/shp_results.shp")
