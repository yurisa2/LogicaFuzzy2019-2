install.packages("pls") # isso instala o pacote PLS, se quiser fazer pela interface, delete ou comente esta linha

library("pls")

summary(mtcars) # Mostra os dados que vamos usar no exemplo

# Cria o modelo PLS com o dataset padrao do R (mtcars, ja vem instalado e pronto para usar)
# O CV é'Cross-Validation'. método padrão para cálculo do erro e tal
pls.mtcars <- plsr(mpg ~ cyl + disp + hp + wt + qsec + gear + carb,
                    data=mtcars,
                    ncomp = 6 ,
                    validation="CV")

summary(pls.mtcars) # Aqui dá para ver a evolução do ERRO (RMSEP) e da
# explicação das variancia (Training) conforme o número de variáveis, veja que
# quase não variou de 1 - 2, com 3 explicou para caralho, depois volta a ficar ruim
plot(pls.mtcars) # Plot da validação, vai crescendo conforme o número de amostras

plot(RMSEP(pls.mtcars)) # Aqui você ve com quantos componentes tem o menor erro
# da validação cruzada utilizando RMSEP (Root Mean Square Error of Prediction)
# no caso, com quatro componentes é o menor erro, depois o erro começa a subir (overfitting)


# Verificar se o resultado muda com o SCALE (tenta jogar fora outliers)
testeScale <- scale(mtcars[,2:11]) # da scale em tudo, menos no resultado
testeScale <- cbind(testeScale,mtcars$mpg)  # coloca o resultado bruto no dataset escalado

# agora vou rodar a mesma análise e verificar se muda algo
testeScale <- as.data.frame(testeScale)
pls.mtcarsSCALE <- plsr(V11 ~ cyl + disp + hp + wt + qsec + gear + carb,
                    data=testeScale,
                    ncomp = 6 ,
                    validation="CV")
summary(pls.mtcarsSCALE)
plot(pls.mtcarsSCALE)
plot(RMSEP(pls.mtcarsSCALE))
# neste caso, mudou o numero de componentes, mas é dataset pequeno e bastante CARDINAL
# Talvez ajude num caso real, ou com muitos dados e muitos outliers


######################################
# Mesmo exemplo com regressão linear, que definitivamente não é o caso
# uma Bagunça quando se mistura todas as variaveis

lm.mtcars <- lm(mpg ~ cyl + disp + hp + wt + qsec + gear + carb,
                data=mtcars)
# escolhi as variáveis com "conhecimento de domínio", famoso CHUTEI

plot(lm.mtcars) # Plot da validação (neste caso é o plot de cada variável, pq é'linear')

summary(lm.mtcars) # Dá pra ver que só o peso está explicando algo

lm.wtcars <- lm(mpg ~ wt, data=mtcars) # Regressão somente com o peso

plot(lm.wtcars) # plot formal do modelo, geralmente diz nada ou perto disso
summary(lm.wtcars) # veja a diferença da Regressão linear usando só o peso
# (melhor resultado da PLS),
# interpretando: só com o peso (wt) da para prever o consumo (mpg)
