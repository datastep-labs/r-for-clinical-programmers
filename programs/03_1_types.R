# Chapter 3: every value has a type, and one vector holds one type only
library(dplyr)

class("01-701-1015")
class(63)
class(63L)
class(TRUE)
class(as.Date("2014-01-02"))

c(63, "<65")
c(63, TRUE)

pharmaverseadam::adsl |>
  filter(USUBJID == "01-701-1015") |>
  select(USUBJID, AGE, TRTSDT, TRTSDTM) |>
  glimpse()
