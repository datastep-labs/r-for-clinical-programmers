# Chapter 14: a listing of serious adverse events, printed and written to Word
library(dplyr)
library(flextable)
library(officer)

cols <- c(
  "Placebo" = "Placebo", "Xanomeline Low Dose" = "Xanomeline Low Dose",
  "Xanomeline High Dose" = "Xanomeline High Dose"
)
sae <- pharmaverseadam::adae |>
  filter(SAFFL == "Y", AESER == "Y") |>
  mutate(TRT = factor(TRT01A, levels = cols)) |>
  arrange(TRT, USUBJID, ASTDT, AEDECOD) |>
  select(TRT, USUBJID, AEDECOD, ASTDT, AENDT, AESEV, AEOUT)

nrow(sae)
options(width = 110) # a listing is wide: landscape in Word
sae |>
  select(TRT, USUBJID, AEDECOD, ASTDT, AESEV) |>
  as.data.frame() |>
  print(right = FALSE, row.names = FALSE)

# the listing: a value of TRT and USUBJID once per group, wrapped text
ft <- sae |>
  mutate(TRT = as.character(TRT)) |>
  flextable() |>
  set_header_labels(
    TRT = "Treatment", USUBJID = "Subject", AEDECOD = "Preferred term",
    ASTDT = "Start", AENDT = "End", AESEV = "Severity", AEOUT = "Outcome"
  ) |>
  merge_v(j = c("TRT", "USUBJID")) |>
  valign(valign = "top", part = "body") |>
  width(j = c("TRT", "AEDECOD", "AEOUT"), width = c(1.6, 2.4, 1.8)) |>
  add_footer_lines(paste("Records listed:", nrow(sae))) |>
  theme_booktabs()

landscape <- prop_section(page_size = page_size(orient = "landscape"))
save_as_docx(
  "Listing 16.2.7 Serious adverse events (safety population)" = ft,
  path = "output/l_16_2_7_sae.docx", pr_section = landscape
)
file.exists("output/l_16_2_7_sae.docx")
