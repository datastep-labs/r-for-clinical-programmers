# Chapter 8: a function has a name, arguments with defaults and a return value
pct <- function(n, total, digits = 1) {
  round(100 * n / total, digits)
}

pct(65, 86)
pct(65, 86, digits = 2)
pct(n = c(65, 68, 84), total = c(86, 72, 96))

# return() ends the function early; otherwise the last value is returned
pct_or_na <- function(n, total, digits = 1) {
  if (total == 0) {
    return(NA_real_)
  }
  round(100 * n / total, digits)
}
pct_or_na(0, 0)
pct_or_na(65, 86)
