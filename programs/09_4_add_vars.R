# Chapter 9: ADSL by hand, part 2. The same join comes a third time: write it once
library(dplyr)

adsl_031 <- readRDS("data/adsl_031.rds")

# Add the columns of `add` to `data`. Each subject must have at most one row in
# both (else: an error), and the function writes one line of the build log
add_vars <- function(data, add, step) {
  out <- data |>
    left_join(add, by = join_by(USUBJID), relationship = "one-to-one")
  new <- setdiff(names(add), names(data))
  message(step, ": ", nrow(out), " rows, +", length(new), " variables: ",
          paste(new, collapse = " "))
  out
}

# Step 040: the population flags, from SUPPDM. No record means "N"
supp <- pharmaversesdtm::suppdm |>
  tidyr::pivot_wider(id_cols = USUBJID, names_from = QNAM, values_from = QVAL)
supp_flags <- adsl_031 |>
  select(USUBJID) |>
  add_vars(supp, "supp_031") |>
  transmute(
    USUBJID,
    SAFFL = if_else(SAFETY %in% "Y", "Y", "N"),
    ITTFL = if_else(ITT %in% "Y", "Y", "N"),
    EFFFL = if_else(EFFICACY %in% "Y", "Y", "N"),
    COMP24FL = if_else(COMPLT24 %in% "Y", "Y", "N")
  )
adsl_040 <- add_vars(adsl_031, supp_flags, "adsl_040")

# Step 050: end of study status and the reason to discontinue, from DS
ds_eos <- pharmaversesdtm::ds |>
  filter(DSCAT == "DISPOSITION EVENT") |>
  transmute(
    USUBJID,
    EOSSTT = if_else(DSDECOD == "COMPLETED", "COMPLETED", "DISCONTINUED"),
    DCSREAS = if_else(DSDECOD == "COMPLETED", NA, DSDECOD)
  )
adsl_050 <- add_vars(adsl_040, ds_eos, "adsl_050")

# Steps 060 and 061: values made from ADSL itself, with mutate()
adsl_hand <- adsl_050 |>
  mutate(
    AGEGR1 = case_when(AGE < 65 ~ "<65", AGE <= 80 ~ "65-80", AGE > 80 ~ ">80")
  ) |>
  mutate(RFENDT = lubridate::ymd(RFENDTC))

adsl_hand |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, SAFFL, ITTFL, EFFFL, COMP24FL, EOSSTT, AGEGR1, RFENDT)

adsl_hand |>
  count(EOSSTT, DCSREAS)

saveRDS(adsl_hand, "data/adsl_hand.rds")
