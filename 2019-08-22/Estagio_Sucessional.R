rm(list=ls())


library(FuzzyR)


estagio <- newfis("Estagio Sucessional")

#Variáveis de entrada
estagio <- addvar(estagio, "input", "porte", c(0,60))
estagio <- addvar(estagio, "input", "DAP", c(0,120))
estagio <- addvar(estagio, "output", "estagio", c(0,10))


estagio <- addmf(estagio,"input", 1, "peq", "trapmf", c(0,0,5,20) )
estagio <- addmf(estagio,"input", 1, "med", "trapmf", c(5,20,30,40))
estagio <- addmf(estagio,"input", 1, "gde", "trapmf", c(30,40,60,60) )


estagio <- addmf(estagio,"input", 2, "fino", "trapmf", c(1,1,10,30) )
estagio <- addmf(estagio,"input", 2, "med", "trapmf", c(10,30,45,60))
estagio <- addmf(estagio,"input", 2, "grosso", "trapmf", c(45,60,120,120) )



estagio <- addmf(estagio,"output", 1, "pioneiro", "trapmf", c(0,0,2,3) )
estagio <- addmf(estagio,"output", 1, "inicial", "trapmf", c(2,3,4.5,5.5))
estagio <- addmf(estagio,"output", 1, "medio", "trapmf", c(4.5,5.5,7,8) )
estagio <- addmf(estagio,"output", 1, "avancado", "trapmf", c(7,8,10,10) )

plotmf(estagio,"input",1)
plotmf(estagio,"input",2)
plotmf(estagio,"output",1)

rulelist <- rbind( c(1,1,1,1,1),
                  c(1,2,2,1,1),
                  c(1,3,3,1,1),

                  c(2,1,2,1,1),
                  c(2,2,3,1,1),
                  c(2,3,4,1,1),

                  c(3,1,3,1,1),
                  c(3,2,4,1,1),
                  c(3,3,4,1,1)
        )

estagio <- addrule(estagio, rulelist)

gensurf(estagio)
showGUI(estagio)

matrixEntrada <- matrix(c(20,30, # Aqui vao as entradas
                          10,10),ncol=2, byrow=TRUE)
evalfis(matrixEntrada,estagio)
