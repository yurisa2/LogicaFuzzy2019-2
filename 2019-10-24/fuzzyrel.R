library(FuzzyR)


A <- c(0.5,0.6,0.7)
A <- rbind(A,c(0.1,0.2,0.3))
A <- rbind(A,c(0.9,0.8,0.7))

# A <- data.frame(A)
# colnames(A) <- c("a","b","c")
# rownames(A) <- c("a","b","c")

B <- c(0.34,0.666,0.12)
B <- rbind(B,c(0.55,0.88,0.44))
B <- rbind(B,c(0.2,0.9,0.1))

# B <- data.frame(B)
# colnames(B) <- c("a","b","c")
# rownames(B) <- c("a","b","c")

tB <- t(B)


for(i in 1:nrow(A)) for(j in 1:ncol(A)) {
  min(A[i,j],tB[i,j])
}
