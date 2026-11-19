# Chapter 13: why a table program needs its own rounding function
round_half_up <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5 + 1e-9) / scale
}

# 6 black subjects in the low dose column, N = 96
pct <- 100 * 6 / 96
pct

round(pct, 1)
sprintf("%.1f", pct)
round_half_up(pct, 1)

