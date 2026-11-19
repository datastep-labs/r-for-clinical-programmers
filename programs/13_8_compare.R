# Chapter 13: compare the tables by hand with gtsummary and rtables
library(dplyr)
library(tidyr)
library(gtsummary)
library(rtables)

# every table as cells: one row per line and column, with the printed text
cells <- function(table) {
  table |>
    select(label, Placebo, `Low Dose`, `High Dose`, Total) |>
    mutate(label = trimws(label)) |>
    pivot_longer(-label, names_to = "column", values_to = "text")
}
from_gts <- function(gts) {
  as_tibble(gts, col_labels = FALSE) |>
    filter(!is.na(stat_1)) |>
    rename(
      Placebo = stat_1, `Low Dose` = stat_2, `High Dose` = stat_3,
      Total = stat_0
    ) |>
    mutate(label = if_else(label == "N Non-missing", "n", label))
}
compare <- function(a, b) {
  full_join(cells(a), cells(b), by = c("label", "column")) |>
    summarise(cells = n(), same = sum(text.x == text.y, na.rm = TRUE))
}

hand <- readRDS("output/t_demog.rds") # 13_2
gts <- readRDS("output/t_demog_gts.rds") |> from_gts() # 13_5
rtb <- readRDS("output/t_demog_rtables.rds") |> # 13_7
  as_result_df(data_format = "strings") |>
  rename(label = label_name)

compare(hand, gts)
compare(hand, rtb)

# the adverse event table: the same cells, and the same order of lines?
hand_ae <- readRDS("output/t_ae.rds") # 13_4
gts_ae <- readRDS("output/t_ae_gts.rds") |> from_gts() # 13_6
compare(hand_ae, gts_ae)
identical(trimws(hand_ae$label), gts_ae$label)
