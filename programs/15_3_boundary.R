# EXPECT: WARNING Not all Values Compared Equal
# Chapter 15: a QC program with one mistake. cut() closes each group on the right
library(dplyr)
library(diffdf)

prod <- readRDS("data/adsl.rds") |>
  select(USUBJID, AGE, AGEGR1) |>
  haven::zap_label()

qc <- prod |>
  mutate(AGEGR1 = as.character(cut(
    AGE,
    breaks = c(-Inf, 65, 80, Inf), labels = c("<65", "65-80", ">80")
  )))

diffdf(prod, qc, keys = "USUBJID")
