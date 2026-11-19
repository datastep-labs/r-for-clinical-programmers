# Chapter 10: ADLB chemistry by hand: the function of 10_2 again, and normal ranges
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTSDT)

# derive_baseline() of program 10_2, not changed
derive_baseline <- function(data, by, order) {
  data |>
    arrange(pick(all_of(order))) |>
    mutate(
      can_be_base = !is.na(AVAL) & ADT <= TRTSDT,
      ABLFL = if_else(row_number() %in% last(which(can_be_base)), "Y", NA),
      BASE = first(AVAL[ABLFL %in% "Y"]),
      .by = all_of(by)
    ) |>
    mutate(
      CHG = if_else(AVISITN > 0, AVAL - BASE, NA),
      PCHG = if_else(AVISITN > 0, CHG / BASE * 100, NA)
    ) |>
    select(-can_be_base)
}

adlb_hand <- pharmaversesdtm::lb |>
  filter(LBCAT == "CHEMISTRY") |>
  left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one") |>
  mutate(
    PARAMCD = LBTESTCD, PARAM = LBTEST, AVAL = LBSTRESN,
    ADT = lubridate::ymd(substr(LBDTC, 1, 10)),
    ADY = as.numeric(ADT - TRTSDT) + if_else(ADT >= TRTSDT, 1, 0),
    week = startsWith(VISIT, "WEEK"),
    AVISIT = if_else(week, stringr::str_to_title(VISIT), NA),
    AVISITN = if_else(
      week, as.numeric(stringr::str_extract(VISIT, "[0-9]+")), NA
    ),
    # the normal range of the lab, and where the value is in it
    ANRLO = LBSTNRLO, ANRHI = LBSTNRHI,
    ANRIND = case_when(
      AVAL < ANRLO ~ "LOW",
      AVAL > ANRHI ~ "HIGH",
      !is.na(AVAL) ~ "NORMAL"
    )
  ) |>
  derive_baseline(by = c("USUBJID", "PARAMCD"), order = c("ADT", "LBSEQ")) |>
  # BNRIND: ANRIND of the baseline row, on every row
  mutate(BNRIND = first(ANRIND[ABLFL %in% "Y"]), .by = c(USUBJID, PARAMCD)) |>
  select(
    STUDYID, USUBJID, LBSEQ, PARAMCD, PARAM, VISIT, AVISIT, AVISITN, ADT, ADY,
    TRTSDT, AVAL, ANRLO, ANRHI, ANRIND, ABLFL, BASE, BNRIND, CHG, PCHG
  ) |>
  arrange(USUBJID, PARAMCD, ADT, LBSEQ)

adlb_hand |>
  filter(USUBJID == "01-701-1015", PARAMCD == "ALT") |>
  select(VISIT, ADY, AVAL, ANRHI, ANRIND, ABLFL, BASE, BNRIND, CHG)

# The chemistry labs have no BASELINE visit. Where does the baseline of ALT
# come from?
adlb_hand |>
  filter(PARAMCD == "ALT", ABLFL == "Y") |>
  count(VISIT)

saveRDS(adlb_hand, "data/adlb_hand.rds")
