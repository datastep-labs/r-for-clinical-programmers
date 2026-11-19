# Chapter 11: ADAE by hand: analysis dates, treatment emergent, first occurrences
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTSDT, TRTEDT, TRTA = TRT01A)

# Step 010: every AE with the treatment and the dates of the subject
adae_010 <- pharmaversesdtm::ae |>
  select(
    STUDYID, USUBJID, AESEQ, AETERM, AEDECOD, AEBODSYS, AESEV, AESER, AESTDTC,
    AEENDTC
  ) |>
  left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one")

# Step 020: ASTDT. A missing day is the 1st, a missing month is January;
# ASTDTF says which. When the first dose has the same known part, the event
# may have started after it: then the start is the first dose
adae_020 <- adae_010 |>
  mutate(
    ASTDTF = case_when(nchar(AESTDTC) == 7 ~ "D", nchar(AESTDTC) == 4 ~ "M"),
    ASTDT = lubridate::ymd(case_when(
      nchar(AESTDTC) == 10 ~ AESTDTC,
      nchar(AESTDTC) == 7 ~ paste0(AESTDTC, "-01"),
      nchar(AESTDTC) == 4 ~ paste0(AESTDTC, "-01-01")
    )),
    ASTDT = if_else(
      !is.na(ASTDTF) & startsWith(as.character(TRTSDT), AESTDTC),
      pmax(ASTDT, TRTSDT),
      ASTDT
    )
  )

# Step 021: AENDT. The end dates are complete or missing: no imputation
adae_021 <- adae_020 |>
  mutate(AENDT = lubridate::ymd(AEENDTC))

# Step 030: ASTDY, the study day of the start. There is no day 0
adae_030 <- adae_021 |>
  mutate(ASTDY = as.numeric(ASTDT - TRTSDT) + if_else(ASTDT >= TRTSDT, 1, 0))

# Step 040: treatment emergent: the event starts on or after the first dose
adae_040 <- adae_030 |>
  mutate(TRTEMFL = if_else(ASTDT >= TRTSDT, "Y", NA))

# Step 050: first occurrence flags. The same code three times, so a function:
# "Y" on the first treatment-emergent event of each group (by ASTDT, AESEQ)
flag_first <- function(data, by) {
  data |>
    arrange(ASTDT, AESEQ) |>
    mutate(
      FIRST = if_else(TRTEMFL %in% "Y" & row_number() == 1, "Y", NA),
      .by = all_of(c(by, "TRTEMFL"))
    )
}
adae_hand <- adae_040 |>
  flag_first("USUBJID") |>
  rename(AOCCFL = FIRST) |>
  flag_first(c("USUBJID", "AEBODSYS")) |>
  rename(AOCCSFL = FIRST) |>
  flag_first(c("USUBJID", "AEBODSYS", "AEDECOD")) |>
  rename(AOCCPFL = FIRST) |>
  arrange(USUBJID, AESEQ)

adae_hand |>
  filter(USUBJID == "01-701-1015") |>
  select(AESEQ, AEDECOD, ASTDT, ASTDY, TRTEMFL, AOCCFL, AOCCSFL, AOCCPFL)

adae_hand |>
  count(ASTDTF, TRTEMFL)

saveRDS(adae_hand, "data/adae_hand.rds")
