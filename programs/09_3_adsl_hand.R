# Chapter 9: ADSL by hand, part 1. Steps 010 to 031: each step adds one variable, or one pair
library(dplyr)

dm <- pharmaversesdtm::dm
ex <- pharmaversesdtm::ex

# Step 010: one row per randomised subject, from DM
adsl_010 <- dm |>
  filter(ARMCD != "Scrnfail") |>
  select(
    STUDYID, USUBJID, SUBJID, SITEID, AGE, AGEU, SEX, RACE, ETHNIC,
    ARM, ACTARM, RFSTDTC, RFENDTC
  )

# Step 020: planned and actual treatment, text and number. From ADSL itself
dose_of <- function(arm) {
  case_when(
    arm == "Placebo" ~ 0,
    arm == "Xanomeline Low Dose" ~ 54,
    arm == "Xanomeline High Dose" ~ 81
  )
}
adsl_020 <- adsl_010 |>
  mutate(
    TRT01P = ARM, TRT01PN = dose_of(ARM),
    TRT01A = ACTARM, TRT01AN = dose_of(ACTARM)
  )

# Step 030: TRTSDT, the date of the first dose, from EX
ex_dt <- ex |>
  mutate(EXSTDT = lubridate::ymd(EXSTDTC), EXENDT = lubridate::ymd(EXENDTC))
ex_trtsdt <- ex_dt |>
  summarise(TRTSDT = min(EXSTDT), .by = USUBJID)
adsl_030 <- adsl_020 |>
  left_join(ex_trtsdt, by = join_by(USUBJID))

# Step 031: TRTEDT, the date of the last dose. max() without na.rm gives NA
# when one EX record has no end date (an open dose record). Then the end of
# study, RFENDTC, is the end of treatment
ex_trtedt <- ex_dt |>
  summarise(EXLAST = max(EXENDT), .by = USUBJID)
adsl_031 <- adsl_030 |>
  left_join(ex_trtedt, by = join_by(USUBJID)) |>
  mutate(TRTEDT = coalesce(EXLAST, lubridate::ymd(RFENDTC)))

# The build log: every step keeps the same subjects
tibble(
  step = c("010", "020", "030", "031"),
  rows = c(nrow(adsl_010), nrow(adsl_020), nrow(adsl_030), nrow(adsl_031)),
  columns = c(ncol(adsl_010), ncol(adsl_020), ncol(adsl_030), ncol(adsl_031))
)

adsl_031 |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, TRT01P, TRT01AN, TRTSDT, TRTEDT)

# Planned and actual treatment differ for some subjects
adsl_031 |>
  count(TRT01P, TRT01A)

# The open dose records: TRTEDT is RFENDTC
adsl_031 |>
  filter(is.na(EXLAST)) |>
  select(USUBJID, RFENDTC, EXLAST, TRTEDT)

adsl_031 <- select(adsl_031, -EXLAST)
saveRDS(adsl_031, "data/adsl_031.rds")
