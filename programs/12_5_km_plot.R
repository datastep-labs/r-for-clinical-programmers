# Chapter 12: what ADTTE is for. A Kaplan-Meier curve for each arm
library(dplyr)
library(ggsurvfit)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRT01A)
adtte <- readRDS("data/adtte.rds") |>
  left_join(adsl, by = join_by(USUBJID), relationship = "one-to-one")

# Surv() wants 1 for an event: the opposite of CNSR
survfit2(Surv(AVAL, 1 - CNSR) ~ TRT01A, data = adtte) |>
  ggsurvfit() +
  add_censor_mark() +
  labs(
    x = "Days since the first dose",
    y = "Subjects without a dermatologic event"
  )
