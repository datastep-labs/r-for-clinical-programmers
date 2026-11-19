# Answer 3-2: a missing value in a sum and in a mean
a <- 1
b <- NA
c <- 3

(a + b + c) / 3
mean(c(a, b, c))
mean(c(a, b, c), na.rm = TRUE)
