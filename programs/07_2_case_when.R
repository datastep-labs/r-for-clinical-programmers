# Chapter 7: case_when() chooses a value; the first true condition wins
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, AGE)

groups <- adsl |>
  mutate(
    AGEGR = case_when(
      is.na(AGE) ~ "Missing",
      AGE < 65 ~ "<65",
      AGE <= 80 ~ "65-80",
      .default = ">80"
    ),
    WRONG = case_when(
      AGE <= 80 ~ "65-80",
      AGE < 65 ~ "<65",
      .default = ">80"
    )
  )
groups |> count(AGEGR)
groups |> count(WRONG)
groups |> filter(USUBJID == "01-701-1015")
