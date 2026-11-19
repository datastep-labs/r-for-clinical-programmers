teae <- dplyr::filter(pharmaverseadam::adae, TRTEMFL == "Y")

test_that("count_subj() counts subjects, not records", {
  res <- count_subj(teae, TRT01A)
  expect_equal(res$n_subj, c(65, 68, 84))
  expect_lt(sum(res$n_subj), nrow(teae))
})

test_that("count_subj() gives one row per group", {
  res <- count_subj(teae, c(TRT01A, AESEV))
  expect_equal(nrow(res), nrow(dplyr::distinct(teae, TRT01A, AESEV)))
  expect_named(res, c("TRT01A", "AESEV", "n_subj"))
})

test_that("count_subj() follows 01-701-1015", {
  one <- dplyr::filter(teae, USUBJID == "01-701-1015")
  expect_equal(count_subj(one, TRT01A)$n_subj, 1)
})

test_that("count_subj() stops with a clear message", {
  expect_error(count_subj("adae", TRT01A), "must be a data frame")
  expect_error(count_subj(teae, TRT01A, id = "SUBJ"), "is not in")
  expect_error(count_subj(teae, TRT01A, id = c("A", "B")), "one text")
})

test_that("count_subj() gives no warning", {
  expect_no_warning(count_subj(teae, TRT01A))
})
