# Chapter 15: one QC run over three data sets: the number of differences per variable
library(dplyr)
library(purrr)
library(diffdf)

# The differences of one comparison as a tibble: one row per variable
qc_diff <- function(ours, ref, keys, vars) {
  ours <- haven::zap_label(select(ours, all_of(c(keys, vars))))
  ref <- haven::zap_label(select(ref, all_of(c(keys, vars))))
  res <- diffdf(ours, ref, keys = keys, suppress_warnings = TRUE)
  tibble(
    variable = vars,
    n_ours = nrow(ours),
    n_diff = map_int(vars, \(v) {
      nrow(res[[paste0("VarDiff_", v)]] %||% tibble())
    })
  )
}

ref_adlb <- pharmaverseadam::adlb |>
  filter(LBCAT == "CHEMISTRY", is.na(DTYPE))

bind_rows(
  ADSL = qc_diff(
    readRDS("data/adsl.rds"),
    filter(pharmaverseadam::adsl, ARMCD != "Scrnfail"),
    keys = "USUBJID", vars = c("TRTSDT", "TRTEDT", "AGEGR1", "SAFFL")
  ),
  ADAE = qc_diff(
    readRDS("data/adae.rds"), pharmaverseadam::adae,
    keys = c("USUBJID", "AESEQ"), vars = c("ASTDT", "AENDT", "TRTEMFL")
  ),
  ADLB = qc_diff(
    readRDS("data/adlb.rds"), ref_adlb,
    keys = c("USUBJID", "LBSEQ"), vars = c("AVAL", "BASE", "CHG")
  ),
  .id = "dataset"
)

# Where are the 777 CHG differences? At visits that are not a scheduled week
inner_join(
  readRDS("data/adlb.rds") |> select(USUBJID, LBSEQ, VISIT, CHG),
  ref_adlb |> select(USUBJID, LBSEQ, CHG_REF = CHG),
  by = join_by(USUBJID, LBSEQ)
) |>
  filter(is.na(CHG) != is.na(CHG_REF)) |>
  count(
    visit = stringr::word(VISIT, 1), ours = !is.na(CHG), ref = !is.na(CHG_REF)
  )
