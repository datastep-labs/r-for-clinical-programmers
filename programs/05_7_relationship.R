# EXPECT: ERROR Each row in `x` must match at most 1 row in `y`
# Chapter 5: count the rows before and after a join, and let R check the keys
library(dplyr)

ae <- pharmaversesdtm::ae
dm <- pharmaversesdtm::dm |> select(USUBJID, AGE, SEX)
ex <- pharmaversesdtm::ex |> select(USUBJID, EXTRT, EXSTDTC)

# DM has one row per subject: the join keeps the number of AE rows
ae_dm <- left_join(ae, dm, by = join_by(USUBJID), relationship = "many-to-one")
c(before = nrow(ae), after = nrow(ae_dm))

# EX has several rows per subject: the same promise is now broken
ae_ex <- left_join(ae, ex, by = join_by(USUBJID), relationship = "many-to-one")
