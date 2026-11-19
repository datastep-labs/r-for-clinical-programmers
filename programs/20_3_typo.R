# EXPECT: ERROR object 'AGEE' not found
# Chapter 20: a typo stops the run, and the verdict names the line
library(dplyr)

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  group_by(TRT01A) |>
  summarise(n = n(), mean_age = mean(AGEE))
