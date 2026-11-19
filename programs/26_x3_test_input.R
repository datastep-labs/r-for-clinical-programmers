# Answer 26-3: the missing test, a text age must stop with a clear error
source("26_3_age_group.R")

testthat::test_that("a text age is an error", {
  testthat::expect_error(age_group("70"), "must be a number")
})
