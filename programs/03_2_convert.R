# Chapter 3: as.character() makes text and as.numeric() makes numbers. Text that is no number gives NA
library(dplyr)
library(stringr)

pharmaversesdtm::dm |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1023", "01-701-1028")) |>
  select(USUBJID, SITEID, AGE) |>
  mutate(
    AGE_C = as.character(AGE),
    SUBJ = str_split_i(USUBJID, "-", 3),
    TXT = str_c(USUBJID, " / ", AGE),
    SITE_N = as.numeric(SITEID)
  )

bili <- pharmaversesdtm::lb |>
  filter(LBTESTCD == "BILI") |>
  mutate(VALUE = as.numeric(LBSTRESC))

bili |>
  filter(is.na(VALUE)) |>
  select(USUBJID, VISIT, LBSTRESC, VALUE)
