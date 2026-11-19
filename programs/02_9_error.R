# EXPECT: ERROR object 'WEIGHT' not found
# Chapter 2: a column that does not exist stops the program with an error
library(dplyr)

pharmaversesdtm::dm |>
  filter(USUBJID == "01-701-1015") |>
  mutate(BMI = WEIGHT / (HEIGHT / 100)^2)
