# Answer 19-1: test first. A by column that does not exist: red, then green
library(dplyr)

copy <- file.path(tempdir(), "studylib_x1")
unlink(copy, recursive = TRUE)
dir.create(copy)
files <- list.files("studylib", full.names = TRUE)
invisible(file.copy(files, copy, recursive = TRUE))

# 1. The test, written before the code
test_file <- file.path(copy, "tests", "testthat", "test-by.R")
writeLines(c(
  'test_that("count_subj() names a by column that does not exist", {',
  '  adae <- pharmaverseadam::adae',
  '  expect_error(count_subj(adae, ARMX), "column of .*by.* is not in")',
  '})'
), test_file)

pkgload::load_all(copy, quiet = TRUE)
red <- testthat::test_file(test_file, reporter = "silent")
as_tibble(red) |> select(failed, error, passed)

# 2. The code: a new check in step 010
code_file <- file.path(copy, "R", "count_subj.R")
code <- readLines(code_file)
step_020 <- grep("# Step 020", code)
check <- c(
  "  by_cols <- try(dplyr::select(data, {{ by }}), silent = TRUE)",
  "  if (inherits(by_cols, \"try-error\")) {",
  "    cli::cli_abort(\"A column of {.arg by} is not in {.arg data}.\")",
  "  }",
  ""
)
writeLines(append(code, check, after = step_020 - 1), code_file)

pkgload::load_all(copy, quiet = TRUE)
green <- testthat::test_file(test_file, reporter = "silent")
as_tibble(green) |> select(failed, error, passed)
count_subj(pharmaverseadam::adae, ARMX) |> try()
