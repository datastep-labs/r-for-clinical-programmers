# Chapter 13: the demographics table with rtables: a layout, then build_table()
library(dplyr)
library(rtables)

cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose"
)
adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(
    TRT = factor(TRT01A, levels = cols, labels = names(cols)),
    AGEGR1 = factor(AGEGR1, c("18-64", ">64")),
    SEX = factor(SEX),
    RACE = factor(RACE)
  )

# an analysis function returns the cells of its lines: values and a format
a_age <- function(x) {
  in_rows(
    "n" = length(x), "Mean (SD)" = c(mean(x), sd(x)), "Median" = median(x),
    "Min, Max" = range(x),
    .formats = c("xx", "xx.x (xx.xx)", "xx.x", "xx, xx")
  )
}
a_count <- function(x, .N_col) {
  counts <- as.list(table(x))
  in_rows(
    .list = lapply(counts, function(n) c(n, n / .N_col)),
    .formats = "xx (xx.x%)"
  )
}

lyt <- basic_table(show_colcounts = TRUE, round_type = "sas") |>
  split_cols_by("TRT") |>
  add_overall_col("Total") |>
  analyze("AGE", a_age, var_labels = "Age (years)", show_labels = "visible") |>
  analyze(
    c("AGEGR1", "SEX", "RACE"), a_count,
    var_labels = c("Age group", "Sex", "Race"), show_labels = "visible"
  )
demog <- build_table(lyt, adsl)
demog
saveRDS(demog, "output/t_demog_rtables.rds")

# the format rounds the percent: as R does by default, or as SAS does
formatters::format_value(c(6, 6 / 96), "xx (xx.x%)")
formatters::format_value(c(6, 6 / 96), "xx (xx.x%)", round_type = "sas")
