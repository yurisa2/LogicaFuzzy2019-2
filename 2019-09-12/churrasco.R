library(FuzzyR)
churrasco <- readfis("/home/yurisa2/lampstack-7.3.7-1/apache2/htdocs/LogicaFuzzy2019-2/2019-09-12/churrasco.fis")


inputs <- matrix(c(6,170),ncol=2, byrow=TRUE)

evalfis(inputs,churrasco)
