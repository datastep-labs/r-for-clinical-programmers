# Chapter 7: a factor gives values an order and a label, the job of a format
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(AGEGR = case_when(AGE < 65 ~ "<65", AGE <= 80 ~ "65-80", .default = ">80"))

# text sorts character by character: "6" comes before "<"
adsl |> count(AGEGR)

# a factor sorts by its levels
adsl |>
  mutate(AGEGR = factor(AGEGR, levels = c("<65", "65-80", ">80"))) |>
  count(AGEGR)

# the position of a level is a number that sorts by severity
sev <- c("MILD", "MODERATE", "SEVERE")
pharmaversesdtm::ae |>
  mutate(AESEVN = as.integer(factor(AESEV, levels = sev))) |>
  count(AESEVN, AESEV)

# levels and labels from a lookup table: codes in, text out
codes <- tibble(
  code = c("Pbo", "Xan_Lo", "Xan_Hi"),
  label = c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")
)
pharmaversesdtm::dm |>
  filter(ARMCD != "Scrnfail") |>
  mutate(TRT = factor(ARMCD, levels = codes$code, labels = codes$label)) |>
  count(TRT)
