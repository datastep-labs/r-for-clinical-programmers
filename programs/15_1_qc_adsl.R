# Chapter 15: the QC program. Same specification as chapter 9, other code
library(dplyr)

dm <- pharmaversesdtm::dm |>
  filter(ARMCD != "Scrnfail")
ex <- pharmaversesdtm::ex

# TRTSDT: sort the EX rows, keep the first row of each subject
first_dose <- ex |>
  arrange(USUBJID, EXSTDTC, EXSEQ) |>
  slice_head(n = 1, by = USUBJID) |>
  transmute(USUBJID, TRTSDT = as.Date(EXSTDTC))

# TRTEDT: a subject with an open dose row ends at RFENDTC, else at the
# latest EX end date. Text dates in ISO 8601 sort in date order
last_dose <- ex |>
  summarise(
    open = any(is.na(EXENDTC)),
    last_end = max(EXENDTC, na.rm = TRUE),
    .by = USUBJID
  )

qc <- dm |>
  select(USUBJID, AGE, RFENDTC) |>
  left_join(first_dose, by = join_by(USUBJID)) |>
  left_join(last_dose, by = join_by(USUBJID)) |>
  mutate(
    TRTEDT = as.Date(if_else(open, RFENDTC, last_end)),
    # whole years: (-Inf, 64] is "<65", (64, 80] is "65-80"
    AGEGR1 = as.character(cut(
      AGE,
      breaks = c(-Inf, 64, 80, Inf), labels = c("<65", "65-80", ">80")
    )),
    SAFFL = if_else(USUBJID %in% ex$USUBJID, "Y", "N")
  ) |>
  select(USUBJID, TRTSDT, TRTEDT, AGEGR1, SAFFL)

qc |>
  filter(USUBJID == "01-701-1015")
count(qc, AGEGR1, SAFFL)
saveRDS(qc, "data/15_qc_adsl.rds")
