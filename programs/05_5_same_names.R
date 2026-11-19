# Chapter 5: name the key, or R joins by every column that has the same name
library(dplyr)

dm <- pharmaversesdtm::dm |>
  select(STUDYID, DOMAIN, USUBJID, AGE, SEX)
ae <- pharmaversesdtm::ae |>
  filter(USUBJID == "01-701-1015") |>
  select(STUDYID, DOMAIN, USUBJID, AESEQ, AEDECOD)

# no by =: DOMAIN is "AE" on one side and "DM" on the other, so nothing matches
left_join(ae, dm)

# by = the key: the other same-named columns get .x and .y
left_join(ae, dm, by = join_by(USUBJID))

# better: take from DM only the columns that you need
left_join(ae, dm |> select(USUBJID, AGE, SEX), by = join_by(USUBJID))
