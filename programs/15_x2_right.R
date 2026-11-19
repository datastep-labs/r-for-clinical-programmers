# EXPECT: WARNING Not all Values Compared Equal
# Answer 15-2: cut() with right = FALSE moves the boundary to the other end
library(dplyr)
library(diffdf)

prod <- readRDS("data/adsl.rds") |>
  select(USUBJID, AGE, AGEGR1) |>
  haven::zap_label()

qc <- prod |>
  mutate(AGEGR1 = as.character(cut(
    AGE,
    breaks = c(-Inf, 65, 80, Inf), labels = c("<65", "65-80", ">80"),
    right = FALSE
  )))

res <- diffdf(prod, qc, keys = "USUBJID")
res$NumDiff
res$VarDiff_AGEGR1 |>
  left_join(prod |> select(USUBJID, AGE), by = join_by(USUBJID)) |>
  count(AGE, BASE, COMPARE)
