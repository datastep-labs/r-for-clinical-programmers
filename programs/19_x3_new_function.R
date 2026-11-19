# Answer 19-3: a new function in the library: code, roxygen block, test
# A session can still hold the library from an earlier program: unload it, so the new copy is the only one
if ("studylib" %in% loadedNamespaces()) pkgload::unload("studylib")

copy <- file.path(tempdir(), "studylib_x3")
unlink(copy, recursive = TRUE)
dir.create(copy)
files <- list.files("studylib", full.names = TRUE)
invisible(file.copy(files, copy, recursive = TRUE))

writeLines(c(
  "# n_pct.R: a count and its percent as one text, such as 65 (75.6)",
  "#",
  "# Change log:",
  "#   0.2.0  2026-11-19  First version.",
  "",
  "#' A count with its percent",
  "#'",
  "#' @param n The counts.",
  "#' @param total The totals, as many as `n` or one.",
  "#' @param digits The decimals of the percent. Default 1.",
  "#' @return A text vector, such as `\"65 (75.6)\"`.",
  "#' @examples",
  "#' n_pct(65, 86)",
  "#' @export",
  "n_pct <- function(n, total, digits = 1) {",
  "  # Step 010: check the arguments",
  "  if (!is.numeric(n) || !is.numeric(total) || any(total <= 0)) {",
  "    cli::cli_abort(\"{.arg n} and {.arg total}: numbers, total > 0.\")",
  "  }",
  "  # Step 020: the text",
  "  pct <- formatC(100 * n / total, format = \"f\", digits = digits)",
  "  paste0(n, \" (\", pct, \")\")",
  "}"
), file.path(copy, "R", "n_pct.R"))

writeLines(c(
  'test_that("n_pct() writes the count and the percent", {',
  '  expect_equal(n_pct(65, 86), "65 (75.6)")',
  '  expect_equal(n_pct(c(1, 2), 4, digits = 0), c("1 (25)", "2 (50)"))',
  '  expect_error(n_pct(5, 0), "total > 0")',
  '})'
), file.path(copy, "tests", "testthat", "test-n_pct.R"))

roxygen2::roxygenise(copy)
readLines(file.path(copy, "NAMESPACE"))

# test_local() runs the tests inside the package, so a function of the same name in your workspace
# (chapter 13 made an n_pct() of its own) cannot hide the package's one (chapter 17: where R finds a name)
res <- testthat::test_local(copy, reporter = "silent", stop_on_failure = FALSE)
sum(as.data.frame(res)$failed)
studylib::n_pct(65, 86)
