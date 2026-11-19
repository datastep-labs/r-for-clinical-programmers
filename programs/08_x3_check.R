# EXPECT: ERROR total > 0 is not TRUE
# Exercise 8-3: a check stops the function before it divides by zero
pct <- function(n, total, digits = 1) {
  stopifnot(is.numeric(n), is.numeric(total), total > 0)
  round(100 * n / total, digits)
}

pct(65, 86)
pct(5, 0)
