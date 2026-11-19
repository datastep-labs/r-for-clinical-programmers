# Chapter 3: regular expressions. Sort the AE start dates by how complete they are
library(dplyr)
library(stringr)

ae <- pharmaversesdtm::ae |>
  select(USUBJID, AESTDTC) |>
  mutate(
    DTC_TYPE = case_when(
      str_detect(AESTDTC, "^\\d{4}-\\d{2}-\\d{2}$") ~ "complete",
      str_detect(AESTDTC, "^\\d{4}-\\d{2}$") ~ "year-month",
      str_detect(AESTDTC, "^\\d{4}$") ~ "year",
      .default = "other"
    ),
    YEAR = str_extract(AESTDTC, "^\\d{4}")
  )

ae |> count(DTC_TYPE)

ae |>
  filter(DTC_TYPE != "complete") |>
  print(n = 3)
