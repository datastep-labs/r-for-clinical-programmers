# EXPECT: WARNING no non-missing arguments to max
# Answer 9-4: the simple rule "TRTEDT is the latest EX end date that exists"
library(dplyr)

adsl <- readRDS("data/adsl.rds")

simple <- pharmaversesdtm::ex |>
  mutate(EXENDT = lubridate::ymd(EXENDTC)) |>
  summarise(TRTEDT_MAX = max(EXENDT, na.rm = TRUE), .by = USUBJID)

adsl |>
  left_join(simple, by = join_by(USUBJID)) |>
  filter(TRTEDT != TRTEDT_MAX | is.infinite(TRTEDT_MAX)) |>
  select(USUBJID, TRTEDT, TRTEDT_MAX)
