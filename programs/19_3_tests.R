# Chapter 19: run the tests of the library. Each expectation passes or fails
library(dplyr)
pkgload::load_all("studylib", quiet = TRUE)

res <- testthat::test_dir("studylib/tests/testthat", reporter = testthat::SummaryReporter$new(show_praise = FALSE))

# The result as a table: one row per test_that(), nb = number of expectations
as_tibble(res) |>
  select(file, test, nb, failed)
