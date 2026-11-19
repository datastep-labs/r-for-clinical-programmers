# Chapter 7: look up a value: a join with a small table, or a named vector
library(dplyr)

dm <- pharmaversesdtm::dm |> select(USUBJID, ARMCD)

# 1. a lookup table, joined by the code
codes <- tribble(
  ~ARMCD, ~TRT01PN, ~TRT01P,
  "Pbo", 0, "Placebo",
  "Xan_Lo", 54, "Xanomeline Low Dose",
  "Xan_Hi", 81, "Xanomeline High Dose"
)
dm |>
  left_join(codes, by = join_by(ARMCD), relationship = "many-to-one") |>
  count(ARMCD, TRT01PN, TRT01P)

# 2. a named vector: the names are the codes
dose <- c(Pbo = 0, Xan_Lo = 54, Xan_Hi = 81)
dose["Xan_Lo"]
dm |>
  mutate(TRT01PN = unname(dose[ARMCD])) |>
  filter(USUBJID == "01-701-1015")
