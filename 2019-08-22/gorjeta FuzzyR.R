rm(list=ls())

library(FuzzyR)

#cria FIS
gorjeta <- newfis("Problema da Gorjeta")


#adiciona variavel
gorjeta <- addvar(gorjeta, "input", "service", c(0,10))
gorjeta <- addvar(gorjeta, "input", "quality", c(0,10))
gorjeta <- addvar(gorjeta, "output", "tip", c(0,30))


#Cria Membership Functions
gorjeta <- addmf(gorjeta, "input", 1, "poor", "trapmf", c(0,0,2.5,5))
gorjeta <- addmf(gorjeta, "input", 1, "good", "trimf", c(2.5,5,7.5))
gorjeta <- addmf(gorjeta, "input", 1, "excellent", "trapmf", c(5,7.5,10,10))

gorjeta <- addmf(gorjeta, "input", 2, "rancid", "trapmf", c(0,0,2,5))
gorjeta <- addmf(gorjeta, "input", 2, "delicious", "trapmf", c(5,7,10,10))

gorjeta <- addmf(gorjeta, "output", 1, "cheap", "trapmf", c(0,0,5,15))
gorjeta <- addmf(gorjeta, "output", 1, "average", "trimf", c(7.5,15,22.5))
gorjeta <- addmf(gorjeta, "output", 1, "generous", "trapmf", c(15,25,30,30))


#Graficos das Variaveis Fuzzy
par(mfrow=c(3,1))
plotmf(gorjeta,"input",1)
plotmf(gorjeta,"input",2)
plotmf(gorjeta,"output",1)

ruleList <- rbind(c(1,1,1,1,2),
                  c(2,0,2,1,1),
                  c(3,2,3,1,2))
gorjeta <- addrule(gorjeta, ruleList)


par(mfrow=c(1,1))
gensurf(gorjeta)

matrixEntrada <- matrix(c(5.5,4.3,
                          7,8,
                          10,10,
                          3,8,
                          0,0,
                          10,10),ncol=2, byrow=TRUE)
evalfis(matrixEntrada,gorjeta)


#Ambiente Visual, com Shiny
showGUI(gorjeta)


#Normalização da saída
normalize <- function(x, fis){
  minimos <- NULL
  maximos <- NULL
  for(i in 1:length(fis$input)){
    minimos <- c(minimos, fis$input[[i]]$range[1])
    maximos <- c(maximos, fis$input[[i]]$range[2])
  }
  input <- evalfis(matrix(c(minimos, maximos), ncol=2, byrow=T), fis)

  output <- fis$output[[1]]$range

  m <- (output[2] - output[1]) / (input[2] - input[1])
  y <- m * (x - input[1]) + output[1]
  y
}

normalize(evalfis(matrixEntrada,gorjeta), gorjeta)

