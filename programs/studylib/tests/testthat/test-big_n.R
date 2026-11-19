test_that("big_n() gives the safety population per arm", {
  res <- big_n(pharmaverseadam::adsl)
  expect_equal(sum(res$N), 254)
})

test_that("big_n() refuses a data set with two rows for a subject", {
  two <- rbind(pharmaverseadam::adsl[1, ], pharmaverseadam::adsl[1, ])
  expect_error(big_n(two), "one row per subject")
})
