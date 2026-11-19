# Answer 3-3: 1 subject of 8 is 12.5%. Shown with no decimals
round_half_up <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5 + 1e-9) / scale
}

pct <- 100 * 1 / 8
pct
round(pct)
sprintf("%.0f", pct)
round_half_up(pct)
