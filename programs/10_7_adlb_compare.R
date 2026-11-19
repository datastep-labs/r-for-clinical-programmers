# Chapter 10: ADLB by hand against admiral, then against the reference ADLB
library(dplyr)
library(diffdf)

adlb_hand <- readRDS("data/adlb_hand.rds") |>
  haven::zap_label()
adlb <- readRDS("data/adlb.rds") |>
  haven::zap_label()

diffdf(adlb_hand, adlb, keys = c("USUBJID", "LBSEQ"))

# The reference: the rows of LB chemistry, by the same key
vars <- c(
  "USUBJID", "LBSEQ", "ADT", "ADY", "AVAL", "ANRLO", "ANRHI", "ANRIND",
  "ABLFL", "BASE", "BNRIND"
)
ref <- pharmaverseadam::adlb |>
  filter(LBCAT == "CHEMISTRY", is.na(DTYPE)) |>
  select(all_of(vars)) |>
  haven::zap_label()
ours <- adlb |>
  select(all_of(vars))

diffdf(ours, ref, keys = c("USUBJID", "LBSEQ"))

# CHG: the reference gives every visit an AVISITN (from VISITNUM), so it
# computes CHG at unscheduled visits too. Count the rows with a CHG in one
# data set only
chg <- inner_join(
  adlb |> select(USUBJID, LBSEQ, VISIT, CHG),
  pharmaverseadam::adlb |> select(USUBJID, LBSEQ, CHG_REF = CHG),
  by = join_by(USUBJID, LBSEQ)
)
chg |>
  filter(is.na(CHG) != is.na(CHG_REF)) |>
  count(
    visit = stringr::word(VISIT, 1),
    ours = !is.na(CHG),
    reference = !is.na(CHG_REF)
  )
