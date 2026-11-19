# EXPECT: ERROR could not find function
# Chapter 22: two typos that dsr lint finds before you run the program
library(dplyr)

adsl_saf <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

adsl_saf |>
  group_by(TRT01A) |>
  summarise(subjects = n_distnct(USUBJID))

nrow(adsl_safe)
