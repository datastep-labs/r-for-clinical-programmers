# Answer 12-4: what ADTTE is for. Events per arm, and the Kaplan-Meier estimate
library(dplyr)
library(survival)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRT01A)
adtte <- readRDS("data/adtte.rds") |>
  left_join(adsl, by = join_by(USUBJID), relationship = "one-to-one")

adtte |>
  count(TRT01A, CNSR)

# Surv() wants 1 for an event: the opposite of CNSR
survfit(Surv(AVAL, 1 - CNSR) ~ TRT01A, data = adtte)
