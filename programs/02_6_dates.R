# Chapter 2: from ISO 8601 text to a real date. A partial date cannot become a full date by itself
library(dplyr)
library(lubridate)

tibble(DTC = c("2014-03-15", "2014-03-15T09:30", "2014-03", "2014", NA)) |>
  mutate(DT = as.Date(DTC, format = "%Y-%m-%d"))

as.numeric(as.Date("2014-01-02"))
as.Date("2014-01-11") - as.Date("2014-01-09")

ae <- pharmaversesdtm::ae |>
  select(USUBJID, AESTDTC) |>
  mutate(ASTDT = ymd(AESTDTC))

ae |>
  filter(nchar(AESTDTC) < 10, !is.na(ASTDT)) |>
  print(n = 3)
