# Chapter 3: three traps with numbers. Decimal fractions, NA in a sum, and round() to even
0.1 * 3 == 0.3
isTRUE(all.equal(0.1 * 3, 0.3))

p <- NA
q <- 4
p + q
sum(p, q)
sum(p, q, na.rm = TRUE)

round(c(0.5, 1.5, 2.5, 3.5, -2.5))
sprintf("%.0f", c(0.5, 1.5, 2.5))

round_half_up <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5 + 1e-9) / scale
}
round_half_up(c(0.5, 1.5, 2.5, 3.5, -2.5))
round(12.45, 1)
round_half_up(12.45, 1)
