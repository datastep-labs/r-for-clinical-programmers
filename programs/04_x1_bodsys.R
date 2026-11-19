# Answer 4-1: one row per subject and system organ class. How many rows does distinct() remove?
library(dplyr)

ae <- pharmaversesdtm::ae
ae_soc <- ae |> distinct(USUBJID, AEBODSYS)

nrow(ae)
nrow(ae_soc)
nrow(ae) - nrow(ae_soc)
