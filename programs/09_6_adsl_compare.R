# Chapter 9: double programming. The ADSL by hand and the ADSL of admiral must agree
library(diffdf)

adsl_hand <- readRDS("data/adsl_hand.rds")
adsl <- readRDS("data/adsl.rds")

diffdf(adsl_hand, adsl, keys = "USUBJID")
