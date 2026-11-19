# Chapter 24: count the subjects with a treatment-emergent adverse event, one severity at a time
library(dplyr)

adae <- pharmaverseadam::adae |>
  filter(TRTEMFL == "Y")
sevs <- c("MILD", "MODERATE", "SEVERE")
nsub <- integer(0)

for (i in seq_along(sevs)) {
  sev <- sevs[i]
  sub <- adae |>
    filter(AESEV == sev)
  # chapter 24 puts a pry() line here
  nsub[sev] <- n_distinct(sub$USUBJID)
}

nsub
