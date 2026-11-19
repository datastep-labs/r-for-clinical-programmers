# A small table program with three problems that a reviewer must see
library(dplyr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adae <- pharmaverseadam::adae |> filter(TRTEMFL == "Y")

# Problem 1: a lab-style value "<5" cannot become a number
dose <- as.numeric(c("54", "81", "<5"))

# Problem 2: summarise() by two groups keeps one of them
by_sev <- adae |>
  group_by(TRT01A, AESEV) |>
  summarise(n_subj = n_distinct(USUBJID))

# Problem 3: the join copies rows: many AEs per subject, many rows per subject
both <- adae |>
  select(USUBJID, AEDECOD) |>
  left_join(adae |> select(USUBJID, AESEV), by = join_by(USUBJID))
