# EXPECT: WARNING longer than user width
# Answer 14-4: a length in the specification that is too short for the data
library(dplyr)
library(xportr)

spec <- tribble(
  ~dataset, ~variable, ~type, ~length, ~label,
  "ADSL", "USUBJID", "character", 11, "Unique Subject Identifier",
  "ADSL", "TRT01A", "character", 10, "Actual Treatment for Period 01"
)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  select(USUBJID, TRT01A) |>
  xportr_metadata(spec, domain = "ADSL") |>
  xportr_type() |>
  xportr_length() |>
  xportr_label() |>
  xportr_write("output/adslshrt.xpt")

foreign::lookup.xport("output/adslshrt.xpt")$adsl$width
haven::read_xpt("output/adslshrt.xpt") |> distinct(TRT01A)
