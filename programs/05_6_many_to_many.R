# EXPECT: WARNING many-to-many relationship
# Chapter 5: two tables with repeated keys pair every row with every row
library(dplyr)

ae <- pharmaversesdtm::ae |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, AEDECOD)
cm <- pharmaversesdtm::cm |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, CMDECOD)

nrow(ae)
nrow(cm)

ae_cm <- left_join(ae, cm, by = join_by(USUBJID))
nrow(ae_cm)
