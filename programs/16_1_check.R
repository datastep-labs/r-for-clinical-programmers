# Chapter 16: a check program. Test each assumption of the note before you derive
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTSDT)
weight <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "WEIGHT") |>
  select(USUBJID, VSSEQ, VISIT, VSDTC, VSSTRESN, VSSTRESU, VSBLFL) |>
  mutate(ADT = as.Date(substr(VSDTC, 1, 10))) |>
  inner_join(adsl, by = join_by(USUBJID))

# The rule of the note: the last weight on or before the first dose
rule <- weight |>
  filter(!is.na(VSSTRESN), ADT <= TRTSDT) |>
  arrange(USUBJID, ADT, VSSEQ) |>
  slice_tail(n = 1, by = USUBJID)
flag <- weight |>
  filter(VSBLFL == "Y")

no_weight <- anti_join(adsl, weight, by = join_by(USUBJID))
two_a_day <- count(weight, USUBJID, ADT) |> filter(n > 1)
no_rule <- anti_join(adsl, rule, by = join_by(USUBJID))
other_flag <- anti_join(rule, flag, by = join_by(USUBJID, VSSEQ))

tribble(
  ~check,                                      ~n,
  "1 subjects without any weight",             nrow(no_weight),
  "2 weights not in kg",                       sum(weight$VSSTRESU != "kg"),
  "3 weights without a value",                 sum(is.na(weight$VSSTRESN)),
  "4 weights without a full date",             sum(nchar(weight$VSDTC) != 10),
  "5 subjects with 2 weights on one date",     nrow(two_a_day),
  "6 subjects without a weight before dose",   nrow(no_rule),
  "7 rule weights on the day of the dose",     sum(rule$ADT == rule$TRTSDT),
  "8 subjects with VSBLFL on another row",     nrow(other_flag)
)
