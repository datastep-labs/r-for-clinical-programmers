# Chapter 2: a factor gives groups their order (the job of a SAS format)
library(dplyr)

dm_rand <- pharmaversesdtm::dm |>
  filter(ARMCD != "Scrnfail") |>
  mutate(AGEGR = case_when(
    AGE < 65 ~ "<65",
    AGE <= 80 ~ "65-80",
    AGE > 80 ~ ">80"
  ))

dm_rand |> count(AGEGR)

dm_rand |>
  mutate(AGEGR = factor(AGEGR, levels = c("<65", "65-80", ">80"))) |>
  count(AGEGR) |>
  mutate(PCT = round(100 * n / sum(n), 1))
