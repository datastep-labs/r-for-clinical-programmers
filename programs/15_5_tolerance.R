# Chapter 15: two right formulas for PCHG differ in the last digits. tolerance
library(dplyr)
library(diffdf)

advs <- readRDS("data/advs.rds") |>
  filter(PARAMCD == "WEIGHT", !is.na(CHG))

prod <- advs |>
  transmute(USUBJID, VSSEQ, PCHG = CHG / BASE * 100)
qc <- advs |>
  transmute(USUBJID, VSSEQ, PCHG = (AVAL / BASE - 1) * 100)

# How many values are not exactly equal, and by how much at most?
nrow(advs)
sum(prod$PCHG != qc$PCHG)
max(abs(prod$PCHG - qc$PCHG))

# tolerance = 0: every tiny difference counts
res <- diffdf(prod, qc,
  keys = c("USUBJID", "VSSEQ"), tolerance = 0,
  suppress_warnings = TRUE
)
res$NumDiff

# The default tolerance, sqrt(.Machine$double.eps), is about 1.5e-08
diffdf(prod, qc, keys = c("USUBJID", "VSSEQ"))
