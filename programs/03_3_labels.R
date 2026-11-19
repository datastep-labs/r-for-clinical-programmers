# Chapter 3: a label is an attribute of a column. Some steps copy it, some drop it
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, AGE, SEX)

attr(adsl$AGE, "label")
sapply(adsl, attr, "label")

adsl <- adsl |>
  mutate(
    AGE_MONTHS = AGE * 12,
    AGE_C = as.character(AGE)
  )
attr(adsl$AGE_MONTHS, "label")
attr(adsl$AGE_C, "label")

attr(adsl$AGE_MONTHS, "label") <- "Age (months)"
attr(adsl$AGE_C, "label") <- "Age as text"
sapply(adsl, attr, "label")
