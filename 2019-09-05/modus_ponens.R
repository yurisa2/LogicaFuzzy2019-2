X <- c(0.4,1,0.6);
Y <- c(0.8,0.4);

# Função que calcula a Implicação de Lukasiewicz
Lukasiewicz <- function(x,y) {ret <- min(c((1-x+y),1));return(ret);}

xy = matrix(nrow=length(Y), ncol=length(X)); # Gera uma matriz de resultados
xyb = matrix(nrow=length(Y), ncol=length(X)); # Gera uma matriz de comparação

for (i in 1:length(Y)) {
  for (j in 1:length(X)) {
    xy[i,j] <- Lukasiewicz(X[j],Y[i]); # Calcula a implicação para cada combinação da Matriz
    xyb[i,j] <- min(xy[i,j],X[j]); # Calcula O mínimo entre cada implicação e o vetor X
  }
}

max_y <- NULL   # Cria/Zera o vetor de resultado

for (i in 1:length(Y)) {
  max_y <- c(max_y, max(xyb[i,])) # Pega o máximo de cada Y
}

for(i in 1:length(max_y)) print(paste("Phi Y",i,max_y[i])) # Printa os resultados (opcional)
