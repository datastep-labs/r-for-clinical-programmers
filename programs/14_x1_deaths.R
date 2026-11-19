# Answer 14-1: a listing of the deaths in the safety population
library(dplyr)
library(flextable)

deaths <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y", DTHFL == "Y") |>
  arrange(TRT01A, USUBJID) |>
  select(TRT01A, USUBJID, AGE, SEX, TRTEDT, DTHDT, DTHCAUS)

options(width = 100)
deaths |>
  as.data.frame() |>
  print(right = FALSE, row.names = FALSE)

deaths |>
  flextable() |>
  merge_v(j = "TRT01A") |>
  valign(valign = "top", part = "body") |>
  save_as_docx(path = "output/l_16_2_deaths.docx")
