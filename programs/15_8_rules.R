# Chapter 15: a QC program for data rules. Each rule is one row: PASS or FAIL
library(dplyr)

adsl <- readRDS("data/adsl.rds")
adae <- readRDS("data/adae.rds")
advs <- readRDS("data/advs.rds")

# A rule: its name, its data set, and the number of rows that break it
rule <- function(name, dataset, n_bad) {
  result <- if_else(n_bad == 0, "PASS", "FAIL")
  tibble(rule = name, dataset, n_bad, result)
}
n_dup <- function(data, ...) sum(duplicated(select(data, ...)))

agegr1 <- c("<65", "65-80", ">80")
lost <- anti_join(adae, adsl, by = join_by(USUBJID))

checks <- bind_rows(
  rule("one row per subject", "ADSL", n_dup(adsl, USUBJID)),
  rule("TRTSDT is not missing", "ADSL", sum(is.na(adsl$TRTSDT))),
  rule("TRTEDT >= TRTSDT", "ADSL", sum(adsl$TRTEDT < adsl$TRTSDT)),
  rule("AGEGR1 in its codelist", "ADSL", sum(!adsl$AGEGR1 %in% agegr1)),
  rule("USUBJID, AESEQ is a key", "ADAE", n_dup(adae, USUBJID, AESEQ)),
  rule("every subject is in ADSL", "ADAE", nrow(lost)),
  rule("TRTEMFL is Y or empty", "ADAE", sum(!adae$TRTEMFL %in% c("Y", NA))),
  rule("USUBJID, VSSEQ is a key", "ADVS", n_dup(advs, USUBJID, VSSEQ)),
  rule("AVAL is not missing", "ADVS", sum(is.na(advs$AVAL)))
)
checks

# A FAIL is a question for the data, not yet a bug: look at the rows in VS
advs |>
  filter(is.na(AVAL)) |>
  left_join(
    pharmaversesdtm::vs |> select(USUBJID, VSSEQ, VSSTAT),
    by = join_by(USUBJID, VSSEQ)
  ) |>
  count(PARAMCD, VSSTAT)
