# EXPECT: WARNING Not all Values Compared Equal
# Chapter 15: the parts of a diffdf() report, on three subjects with planned changes
library(dplyr)
library(diffdf)

base <- readRDS("data/adsl.rds") |>
  filter(USUBJID %in% c("01-701-1015", "01-701-1023", "01-701-1028")) |>
  select(USUBJID, AGE, SEX, TRTSDT) |>
  haven::zap_label()

compare <- base |>
  filter(USUBJID != "01-701-1028") |> # a subject only in BASE
  mutate(
    SEX = if_else(USUBJID == "01-701-1023", "F", SEX), # a value differs
    AGE = as.integer(AGE), # another type
    COUNTRY = "USA" # a column only in COMPARE
  )

res <- diffdf(base, compare, keys = "USUBJID")
res

# The result is a list. A program can test it and use its parts
diffdf_has_issues(res)
names(res)
diffdf_issuerows(base, res)
