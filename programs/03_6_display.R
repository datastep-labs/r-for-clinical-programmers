# Chapter 3: sprintf() and format() turn numbers and dates into text for a table or a listing
library(dplyr)

ages <- pharmaversesdtm::dm |>
  filter(ARMCD != "Scrnfail") |>
  summarise(n = n(), n_old = sum(AGE > 80), mean = mean(AGE), sd = sd(AGE))
ages

sprintf("%.1f (%.2f)", ages$mean, ages$sd)
sprintf("%d (%.1f%%)", ages$n_old, 100 * ages$n_old / ages$n)
sprintf("%3d", c(5, 77, 254))
format(1234567.891, big.mark = ",", nsmall = 2)

trtsdt <- as.Date("2014-01-02")
format(trtsdt, "%d%b%Y")
toupper(format(trtsdt, "%d%b%Y"))
