library("sf")
library("FuzzyR")


setwd("C:/Bitnami/wampstack-7.1.28-0/apache2/htdocs/LogicaFuzzy2019-2/ArtigoFinal")

CN <- read_sf("ShapeFiles/pontos_CN.shp")
Declividade <- read_sf("ShapeFiles/Declividade.shp")
Permeabilidade <- read_sf("ShapeFiles/permeabi.shp")


n_lines <- min(nrow(CN), nrow(Declividade),  nrow(Permeabilidade))

CN <- CN[1:n_lines,]
Declividade <- Declividade[1:n_lines,]
Permeabilidade <- Permeabilidade[1:n_lines,]


summary(CN$grid_code)
summary(Declividade$grid_code)
summary(Permeabilidade$grid_code)

result <- CN

#cria FIS
fis <- newfis("Artigo Fuzzy")


#adiciona variaveis
fis <- addvar(fis, "input", "CN", c(0,100))
fis <- addvar(fis, "input", "Declividade", c(0,160))
fis <- addvar(fis, "input", "Permeabilidade", c(0,1))
fis <- addvar(fis, "output", "Percolacao", c(0,1))
fis <- addvar(fis, "output", "Barragem", c(0,1))



#Cria Membership Functions
fis <- addmf(fis, "input", 1, "baixa", "trimf", c(0,0,50))
fis <- addmf(fis, "input", 1, "media", "trimf", c(0,50,100))
fis <- addmf(fis, "input", 1, "alta", "trimf", c(50,100,100))

fis <- addmf(fis, "input", 2, "baixa", "trimf", c(0,0,80))
fis <- addmf(fis, "input", 2, "media", "trimf", c(0,80,160))
fis <- addmf(fis, "input", 2, "alta", "trimf", c(80,160,160))

fis <- addmf(fis, "input", 3, "baixa", "trimf", c(0,0,0.5))
fis <- addmf(fis, "input", 3, "media", "trimf", c(0,0.5,1))
fis <- addmf(fis, "input", 3, "alta", "trimf", c(0.5,1,1))

fis <- addmf(fis, "output", 1, "baixa", "trimf", c(0,0,0.5))
fis <- addmf(fis, "output", 1, "media", "trimf", c(0,0.5,1))
fis <- addmf(fis, "output", 1, "alta", "trimf", c(0.5,1,1))

fis <- addmf(fis, "output", 2, "baixa", "trimf", c(0,0,0.5))
fis <- addmf(fis, "output", 2, "media", "trimf", c(0,0.5,1))
fis <- addmf(fis, "output", 2, "alta", "trimf", c(0.5,1,1))

plotmf(fis,"input",1)
plotmf(fis,"input",2)
plotmf(fis,"input",3)

plotmf(fis,"output",1)
plotmf(fis,"output",2)




ruleList <- rbind(c(1,1,1,1,1,1,1),
                  c(1,1,2,1,1,1,1),
                  c(1,1,3,1,1,1,1),
                  c(1,2,1,1,1,1,1),
                  c(1,2,2,1,1,1,1),
                  c(1,2,3,1,1,1,1),
                  c(1,3,1,1,1,1,1),
                  c(1,3,2,1,1,1,1),
                  c(1,3,3,1,1,1,1),
                  c(2,1,1,1,1,1,1),
                  c(2,1,2,1,1,1,1),
                  c(2,1,3,1,1,1,1),
                  c(2,2,1,1,1,1,1),
                  c(2,2,2,1,1,1,1),
                  c(2,2,3,1,1,1,1),
                  c(2,3,1,1,1,1,1),
                  c(2,3,2,1,1,1,1),
                  c(2,3,3,1,1,1,1),
                  c(3,1,1,1,1,1,1),
                  c(3,1,2,1,1,1,1),
                  c(3,1,3,1,1,1,1),
                  c(3,2,1,1,1,1,1),
                  c(3,2,2,1,1,1,1),
                  c(3,2,3,1,1,1,1),
                  c(3,3,1,1,1,1,1),
                  c(3,3,2,1,1,1,1),
                  c(3,3,3,1,1,1,1)
                  
                  )


