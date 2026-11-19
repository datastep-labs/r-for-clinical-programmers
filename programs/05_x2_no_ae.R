# Exercise 5-2: subjects of the safety population with no record in ADAE
library(dplyr)

adsl <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
adae <- pharmaverseadam::adae

no_ae <- anti_join(adsl, adae, by = join_by(USUBJID))
nrow(no_ae)
no_ae |> count(TRT01A)
