# Chapter 10: ADVS for body weight by hand, one derivation per step
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTSDT)

# Step 010: one row per weight measurement, with the first dose from ADSL
advs_010 <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT") |>
  select(STUDYID, USUBJID, VSSEQ, VISIT, VSDTC, VSSTRESN) |>
  left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one") |>
  mutate(PARAMCD = "WEIGHT", PARAM = "Weight (kg)", AVAL = VSSTRESN)

# Step 020: the date and the study day. There is no day 0
advs_020 <- advs_010 |>
  mutate(
    ADT = lubridate::ymd(VSDTC),
    ADY = as.numeric(ADT - TRTSDT) + if_else(ADT >= TRTSDT, 1, 0)
  )

# Step 030: the analysis visit. Screening and unscheduled visits get none
advs_030 <- advs_020 |>
  mutate(
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

# Step 040: ABLFL, the last non-missing value on or before the first dose
advs_040 <- advs_030 |>
  arrange(USUBJID, ADT, VSSEQ) |>
  mutate(
    can_be_base = !is.na(AVAL) & ADT <= TRTSDT,
    ABLFL = if_else(row_number() %in% last(which(can_be_base)), "Y", NA),
    .by = USUBJID
  )

# Step 050: BASE, the baseline value on every row of the subject
advs_050 <- advs_040 |>
  mutate(BASE = first(AVAL[ABLFL %in% "Y"]), .by = USUBJID)

# Step 060: change and percent change, for the visits after baseline
advs_weight <- advs_050 |>
  mutate(
    CHG = if_else(AVISITN > 0, AVAL - BASE, NA),
    PCHG = if_else(AVISITN > 0, CHG / BASE * 100, NA)
  ) |>
  select(
    STUDYID, USUBJID, VSSEQ, PARAMCD, PARAM, VISIT, AVISIT, AVISITN, ADT, ADY,
    TRTSDT, AVAL, ABLFL, BASE, CHG, PCHG
  )

advs_weight |>
  filter(USUBJID == "01-701-1015") |>
  select(AVISIT, ADT, ADY, AVAL, ABLFL, BASE, CHG, PCHG)

# Baselines that do not come from the visit called BASELINE
advs_weight |>
  filter(ABLFL == "Y", VISIT != "BASELINE") |>
  select(USUBJID, VISIT, ADT, AVAL)

saveRDS(advs_weight, "data/advs_weight.rds")
