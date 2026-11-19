# Chapter 14: write a SAS transport file (XPT) with xportr, read it back
library(dplyr)
library(xportr)

# the specification: one row per variable, as in the ADaM specification
spec <- tribble(
  ~dataset, ~variable, ~order, ~type, ~length, ~format, ~label,
  "ADSL", "STUDYID", 1, "character", 12, NA, "Study Identifier",
  "ADSL", "USUBJID", 2, "character", 11, NA, "Unique Subject Identifier",
  "ADSL", "TRT01A", 3, "character", 20, NA, "Actual Treatment for Period 01",
  "ADSL", "AGE", 4, "integer", 8, NA, "Age",
  "ADSL", "SEX", 5, "character", 1, NA, "Sex",
  "ADSL", "TRTSDT", 6, "integer", 8, "DATE9.", "Date of First Exposure",
  "ADSL", "SAFFL", 7, "character", 1, NA, "Safety Population Flag"
)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, STUDYID, AGE, SEX, TRT01A, TRTSDT, SAFFL)

adsl |>
  xportr_metadata(spec, domain = "ADSL") |>
  xportr_type() |>
  xportr_length() |>
  xportr_label() |>
  xportr_format() |>
  xportr_order() |>
  xportr_df_label(
    tibble(dataset = "ADSL", label = "Subject-Level Analysis Dataset")
  ) |>
  xportr_write("output/adsl.xpt")

# read the file back: the values (haven), then what the file says (foreign)
haven::read_xpt("output/adsl.xpt") |>
  filter(USUBJID == "01-701-1015")

file <- foreign::lookup.xport("output/adsl.xpt")$adsl
tibble(
  name = file$name, type = file$type, length = file$width,
  format = file$format, label = file$label
)
