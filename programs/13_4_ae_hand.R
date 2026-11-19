# Chapter 13: an adverse event table by hand: subjects per SOC and PT
library(dplyr)
library(tidyr)

round_half_up <- function(x, digits = 0) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5 + 1e-9) / scale
}
n_pct <- function(n, N) sprintf("%d (%.1f%%)", n, round_half_up(100 * n / N, 1))

cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose", "Total" = "Total"
)
with_total <- function(data) {
  bind_rows(data, mutate(data, TRT01A = "Total")) |>
    mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))
}
bign <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  with_total() |>
  count(TRT, name = "N")
teae <- pharmaverseadam::adae |>
  filter(SAFFL == "Y", TRTEMFL == "Y") |>
  with_total()

# three levels, three counts of subjects: any TEAE, per SOC, per SOC and PT
any <- teae |>
  distinct(TRT, USUBJID) |>
  count(TRT)
soc <- teae |>
  distinct(TRT, AEBODSYS, USUBJID) |>
  count(TRT, AEBODSYS)
pt <- teae |>
  distinct(TRT, AEBODSYS, AEDECOD, USUBJID) |>
  count(TRT, AEBODSYS, AEDECOD)

# the order: most subjects in the Total column first, then the name
soc_order <- soc |>
  filter(TRT == "Total") |>
  select(AEBODSYS, soc_n = n)
pt_order <- pt |>
  filter(TRT == "Total") |>
  select(AEBODSYS, AEDECOD, pt_n = n)

layout <- bind_rows(mutate(any, AEBODSYS = "ANY TEAE"), soc, pt) |>
  complete(TRT, nesting(AEBODSYS, AEDECOD), fill = list(n = 0)) |>
  left_join(bign, by = "TRT") |>
  mutate(value = n_pct(n, N)) |>
  select(AEBODSYS, AEDECOD, TRT, value) |>
  pivot_wider(names_from = TRT, values_from = value) |>
  left_join(soc_order, by = "AEBODSYS") |>
  left_join(pt_order, by = c("AEBODSYS", "AEDECOD")) |>
  arrange(
    AEBODSYS != "ANY TEAE", desc(soc_n), AEBODSYS,
    !is.na(AEDECOD), desc(pt_n), AEDECOD
  ) |>
  mutate(label = if_else(is.na(AEDECOD), AEBODSYS, paste0("  ", AEDECOD)))
saveRDS(layout, "output/t_ae.rds")

# the first 10 lines (labels cut at 40 characters for the screen)
nrow(layout)
options(width = 90)
layout |>
  select(label, Placebo:Total) |>
  mutate(label = stringr::str_trunc(label, 40)) |>
  head(10) |>
  as.data.frame() |>
  print(right = FALSE, row.names = FALSE)

# subject 01-701-1015: three events, two SOCs
teae |>
  filter(USUBJID == "01-701-1015", TRT == "Placebo") |>
  select(AEBODSYS, AEDECOD)
