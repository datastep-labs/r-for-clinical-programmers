# Answer 1-5: the age summary of the low dose arm
library(dplyr)

arm <- "Xanomeline Low Dose"

pharmaverseadam::adsl |>
  filter(SAFFL == "Y", ARM == arm) |>
  summarise(
    arm = arm,
    n = n(),
    mean = round(mean(AGE), 1),
    min = min(AGE),
    max = max(AGE)
  )
