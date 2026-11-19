# Chapter 7: match() finds the row of each key, a fast lookup on a big table
library(dplyr)

adsl <- pharmaverseadam::adsl |> select(USUBJID, TRTSDT)
vs <- pharmaversesdtm::vs |> select(USUBJID, VSTESTCD, VSDTC)

match(c("01-701-1023", "01-701-1015", "99-999-9999"), adsl$USUBJID)

vs$TRTSDT <- adsl$TRTSDT[match(vs$USUBJID, adsl$USUBJID)]
c(records = nrow(vs), no_date = sum(is.na(vs$TRTSDT)))

# the same with a join
vs2 <- pharmaversesdtm::vs |>
  select(USUBJID, VSTESTCD, VSDTC) |>
  left_join(adsl, by = join_by(USUBJID), relationship = "many-to-one")
sum(vs$TRTSDT != vs2$TRTSDT) # dates that differ
