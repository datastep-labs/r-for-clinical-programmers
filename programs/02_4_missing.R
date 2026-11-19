# Chapter 2: NA in a comparison gives NA, and filter() drops those rows without a message
library(dplyr)

sysbp <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "SYSBP") |>
  select(USUBJID, VISIT, VSSTRESN)

NA < 140

nrow(sysbp)
sysbp |> filter(VSSTRESN >= 140) |> nrow()
sysbp |> filter(VSSTRESN < 140) |> nrow()

sysbp |> filter(is.na(VSSTRESN))

sysbp |>
  mutate(BPCAT = case_when(
    is.na(VSSTRESN) ~ "missing",
    VSSTRESN >= 140 ~ "high",
    .default = "normal"
  )) |>
  count(BPCAT)

# Missing text: NA here, but "" after a trip through a SAS transport file
ae <- pharmaversesdtm::ae |>
  filter(USUBJID == "01-701-1015") |>
  select(AEDECOD, AEENDTC)
xpt <- tempfile(fileext = ".xpt")
haven::write_xpt(ae, xpt)
ae_sas <- haven::read_xpt(xpt)

ae$AEENDTC
ae_sas$AEENDTC
is.na(ae_sas$AEENDTC)
