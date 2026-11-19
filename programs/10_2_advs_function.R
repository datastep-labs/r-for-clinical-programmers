# Chapter 10: blood pressure needs the same steps, per position. Write them once
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTSDT)
params <- tibble(
  VSTESTCD = c("SYSBP", "DIABP", "PULSE", "WEIGHT"),
  PARAMCD = c("SYSBP", "DIABP", "PULSE", "WEIGHT"),
  PARAM = c(
    "Systolic Blood Pressure (mmHg)", "Diastolic Blood Pressure (mmHg)",
    "Pulse Rate (beats/min)", "Weight (kg)"
  )
)

# Steps 010 to 030: the BDS rows of some VS tests, with dates and visits
vs_to_bds <- function(vs, adsl, params) {
  vs |>
    inner_join(params, by = join_by(VSTESTCD), relationship = "many-to-one") |>
    left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one") |>
    mutate(
      AVAL = VSSTRESN, ATPTN = VSTPTNUM, ATPT = VSTPT,
      ADT = lubridate::ymd(VSDTC),
      ADY = as.numeric(ADT - TRTSDT) + if_else(ADT >= TRTSDT, 1, 0),
      AVISIT = case_when(
        VISIT == "BASELINE" ~ "Baseline",
        startsWith(VISIT, "WEEK") ~ stringr::str_to_title(VISIT)
      ),
      AVISITN = case_when(
        VISIT == "BASELINE" ~ 0,
        startsWith(VISIT, "WEEK") ~
          as.numeric(stringr::str_extract(VISIT, "[0-9]+"))
      )
    )
}

# Steps 040 to 060: ABLFL, BASE, CHG and PCHG in each group of `by`.
# `order` says which row is the last one
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

advs_hand <- pharmaversesdtm::vs |>
  vs_to_bds(adsl, params) |>
  derive_baseline(
    by = c("USUBJID", "PARAMCD", "ATPTN"), order = c("ADT", "VSSEQ")
  ) |>
  select(
    STUDYID, USUBJID, VSSEQ, PARAMCD, PARAM, ATPTN, ATPT, VISIT, AVISIT,
    AVISITN, ADT, ADY, TRTSDT, AVAL, ABLFL, BASE, CHG, PCHG
  ) |>
  arrange(USUBJID, PARAMCD, ADT, ATPTN)

advs_hand |>
  count(PARAMCD, ABLFL)

# One baseline per position: systolic blood pressure of 01-701-1015
advs_hand |>
  filter(USUBJID == "01-701-1015", PARAMCD == "SYSBP", ABLFL == "Y") |>
  select(PARAMCD, ATPTN, ATPT, AVAL, BASE)

# Baselines that do not come from the visit called BASELINE
advs_hand |>
  filter(ABLFL == "Y", VISIT != "BASELINE") |>
  count(USUBJID, VISIT)

# The test: the function gives the same weight rows as program 10_1
weight_10_1 <- readRDS("data/advs_weight.rds")
weight_10_2 <- advs_hand |>
  filter(PARAMCD == "WEIGHT") |>
  select(-ATPTN, -ATPT)
diffdf::diffdf(weight_10_1, weight_10_2, keys = c("USUBJID", "VSSEQ"))

saveRDS(advs_hand, "data/advs_hand.rds")
