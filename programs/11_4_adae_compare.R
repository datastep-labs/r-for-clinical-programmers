# EXPECT: WARNING Not all Values Compared Equal
# Chapter 11: ADAE by hand against admiral, then against the reference ADAE
library(dplyr)
library(diffdf)

adae_hand <- readRDS("data/adae_hand.rds") |>
  haven::zap_label()
adae <- readRDS("data/adae.rds") |>
  haven::zap_label()

diffdf(adae_hand, adae, keys = c("USUBJID", "AESEQ"))

vars <- c("USUBJID", "AESEQ", "ASTDT", "ASTDTF", "AENDT", "ASTDY", "TRTEMFL")
ref <- pharmaverseadam::adae |>
  select(all_of(vars)) |>
  haven::zap_label()
ours <- adae |>
  select(all_of(vars))

diffdf(ours, ref, keys = c("USUBJID", "AESEQ"))

# The four events: the reference counts an event only up to 30 days after
# TRTEDT, and its TRTEDT ignores the open dose record (chapter 9)
adae |>
  filter(USUBJID == "01-705-1303") |>
  left_join(
    pharmaverseadam::adae |> select(USUBJID, AESEQ, TRTEDT_REF = TRTEDT),
    by = join_by(USUBJID, AESEQ)
  ) |>
  select(AESEQ, ASTDT, TRTEDT, TRTEDT_REF, TRTEMFL)
