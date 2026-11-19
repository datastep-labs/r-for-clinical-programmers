# Chapter 6: union(), intersect() and setdiff() on the subject keys
library(dplyr)

ae_subj <- pharmaversesdtm::ae |> distinct(USUBJID)
cm_subj <- pharmaversesdtm::cm |> distinct(USUBJID)

c(ae = nrow(ae_subj), cm = nrow(cm_subj))

nrow(union(ae_subj, cm_subj)) # an AE or a medication
nrow(intersect(ae_subj, cm_subj)) # an AE and a medication
nrow(setdiff(ae_subj, cm_subj)) # an AE, but no medication

setdiff(ae_subj, cm_subj) |> head(3)
