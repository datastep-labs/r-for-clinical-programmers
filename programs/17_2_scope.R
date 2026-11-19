# Chapter 17: where R finds a name. First in the function, then where it was made
cutoff <- 65
is_old <- function(age) {
  age >= cutoff # cutoff is not an argument: R looks outside the function
}
is_old(c(60, 70, 85))

cutoff <- 80
is_old(c(60, 70, 85)) # the function did not change, the result did

# Better: every value that the function needs is an argument
is_old2 <- function(age, cutoff = 65) {
  age >= cutoff
}
is_old2(c(60, 70, 85))

# A name made inside a function stays inside it
f <- function() {
  inside <- "only here"
  inside
}
f()
exists("inside")

# A name with :: says where to look: no search at all
stats::sd(c(60, 70, 85))
