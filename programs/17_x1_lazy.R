# Answer 17-1: a default is evaluated when it is first used, not when the call starts
f <- function(a, b = a * 2) {
  a <- 10
  b
}
f(1)

g <- function(a, b = a * 2) {
  force(b) # evaluate b now, while a is still 1
  a <- 10
  b
}
g(1)
