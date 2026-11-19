# Chapter 18: list-driven output. One file per parameter, the title from the label
library(dplyr)
library(purrr)

bl <- pharmaverseadam::advs |>
  filter(ABLFL == "Y", is.na(ATPTN) | ATPTN == 815)
labels <- bl |>
  distinct(PARAMCD, PARAM)

out_dir <- "output/18_baseline"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

write_one <- function(code, label) {
  tab <- bl |>
    filter(PARAMCD == code) |>
    summarise(n = n(), mean = round(mean(AVAL), 1), .by = TRT01P) |>
    arrange(TRT01P)
  file <- file.path(out_dir, paste0("t_bl_", tolower(code), ".csv"))
  write.csv(tab, file, row.names = FALSE)
  cat(sprintf("%-7s %-40s %s\n", code, label, basename(file)))
}

# walk2() gives the two columns, row by row, to write_one()
walk2(labels$PARAMCD, labels$PARAM, write_one)

list.files(out_dir)
read.csv(file.path(out_dir, "t_bl_weight.csv"))
