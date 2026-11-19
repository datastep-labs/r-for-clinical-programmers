# EXPECT: ERROR Each row in `x` must match at most 1 row in `y`
# Answer 9-3: a join with EX, which has several rows per subject
library(dplyr)

adsl <- readRDS("data/adsl.rds")
ex <- pharmaversesdtm::ex |>
  select(USUBJID, EXDOSE)

# without a promise: no message, but the rows are copied
check_1 <- left_join(adsl, ex, by = join_by(USUBJID))
nrow(check_1)

# the keys with more than one row, found before the join
ex |>
  count(USUBJID) |>
  filter(n > 1) |>
  nrow()

# with the promise of add_vars(): R stops
check_2 <- adsl |>
  left_join(ex, by = join_by(USUBJID), relationship = "one-to-one")
