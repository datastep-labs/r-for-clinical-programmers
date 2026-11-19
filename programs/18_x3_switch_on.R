# Answer 18-3: switch DIABP on in a copy of the parameter file, run again
library(dplyr)
library(purrr)

settings <- "data/18_run_settings.csv" |>
  readr::read_csv(show_col_types = FALSE) |>
  mutate(include = if_else(paramcd == "DIABP", "Y", include))
file <- tempfile(fileext = ".csv")
readr::write_csv(settings, file)

bl <- pharmaverseadam::advs |>
  filter(ABLFL == "Y", is.na(ATPTN) | ATPTN == 815)

readr::read_csv(file, show_col_types = FALSE) |>
  filter(include == "Y", paramcd == "DIABP") |>
  pwalk(\(paramcd, dec, title, ...) {
    cat(title, "\n")
    bl |>
      filter(PARAMCD == paramcd) |>
      summarise(
        n = n(),
        mean = formatC(mean(AVAL), format = "f", digits = dec + 1),
        .by = TRT01P
      ) |>
      arrange(TRT01P) |>
      print()
  })
