# Chapter 18: a parameter file. A CSV decides what the run makes, not the code
library(dplyr)
library(purrr)

settings <- readr::read_csv("data/18_run_settings.csv", show_col_types = FALSE)
settings

bl <- pharmaverseadam::advs |>
  filter(ABLFL == "Y", is.na(ATPTN) | ATPTN == 815)

one_table <- function(paramcd, dec, title, ...) {
  cat("\n", title, "\n", sep = "")
  bl |>
    filter(PARAMCD == .env$paramcd) |>
    summarise(
      n = n(),
      mean = formatC(mean(AVAL), format = "f", digits = dec + 1),
      .by = TRT01P
    ) |>
    arrange(TRT01P) |>
    print()
  invisible(NULL)
}

# Only the rows with include = "Y". The ... of one_table() takes the rest
settings |>
  filter(include == "Y") |>
  pwalk(one_table)
