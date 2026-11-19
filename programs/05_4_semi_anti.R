# Chapter 5: semi_join() and anti_join() find who is missing where
library(dplyr)

dm <- tibble(USUBJID = c("S1", "S2", "S3", "S4"), AGE = c(63, 64, 71, 74))
ae <- tibble(
  USUBJID = c("S2", "S4", "S4", "S5"),
  AEDECOD = c("HEADACHE", "DIZZINESS", "NAUSEA", "RASH")
)

semi_join(dm, ae, by = join_by(USUBJID)) # DM subjects with an AE
anti_join(dm, ae, by = join_by(USUBJID)) # DM subjects with no AE
anti_join(ae, dm, by = join_by(USUBJID)) # AE records with no DM subject

# the same QC check on the pilot study
sdtm_dm <- pharmaversesdtm::dm
sdtm_ae <- pharmaversesdtm::ae
anti_join(sdtm_ae, sdtm_dm, by = join_by(USUBJID)) |> nrow()

sdtm_dm |>
  filter(ARMCD != "Scrnfail") |>
  anti_join(sdtm_ae, by = join_by(USUBJID)) |>
  nrow()
