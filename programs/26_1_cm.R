# Chapter 26: put SDTM CM into the session, to explore it with the data tools
library(dplyr)

cm <- pharmaversesdtm::cm

cm |>
  summarise(records = n(), subjects = n_distinct(USUBJID))
