# Chapter 17: lazy evaluation. R evaluates an argument when the body first uses it
show_order <- function(x) {
  cat("1. the function starts\n")
  value <- x
  cat("3. the function has x\n")
  value
}
show_order({
  cat("2. now R evaluates x\n")
  5
})

# An argument that the body never uses is never evaluated
first_only <- function(a, b) {
  a * 2
}
first_only(10, stop("this is never evaluated"))

# A default can use another argument: R evaluates it when it is needed
pct <- function(n, total = sum(n)) {
  round(100 * n / total, 1)
}
pct(c(86, 84, 84))
pct(c(86, 84, 84), total = 306)
