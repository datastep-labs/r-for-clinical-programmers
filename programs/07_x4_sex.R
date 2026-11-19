# Exercise 7-4: a named vector turns the codes of SEX into text
library(dplyr)

sex_text <- c(F = "Female", M = "Male")

pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(SEXT = unname(sex_text[SEX])) |>
  count(SEX, SEXT)
