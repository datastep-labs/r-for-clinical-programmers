# Exercise 6-4: subjects with a concomitant medication but no AE
library(dplyr)

ae_subj <- pharmaversesdtm::ae |> distinct(USUBJID)
cm_subj <- pharmaversesdtm::cm |> distinct(USUBJID)

nrow(setdiff(cm_subj, ae_subj))
