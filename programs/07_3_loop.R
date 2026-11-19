# Chapter 7: a for loop and a vectorised call give the same days
library(dplyr)

ex <- pharmaversesdtm::ex |>
  filter(USUBJID == "01-701-1015") |>
  mutate(EXSTDT = as.Date(EXSTDTC), EXENDT = as.Date(EXENDTC)) |>
  select(USUBJID, EXDOSE, EXSTDT, EXENDT)

# a loop: one row at a time
days <- numeric(nrow(ex))
for (i in seq_len(nrow(ex))) {
  days[i] <- as.numeric(ex$EXENDT[i] - ex$EXSTDT[i]) + 1
}
days

# vectorised: the whole column at once
ex <- ex |> mutate(DAYS = as.numeric(EXENDT - EXSTDT) + 1)
ex

# one row per day of each record: reframe() can return many rows per row
daily <- ex |>
  rowwise() |>
  reframe(USUBJID, EXDOSE, ADT = seq(EXSTDT, EXENDT, by = "day"))
nrow(daily)
