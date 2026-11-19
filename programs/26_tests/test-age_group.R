# Chapter 26: the tests of age_group(), written before the fix
source("../26_3_age_group.R")

test_that("every age gets a group, also the edges 65 and 80", {
  expect_equal(
    age_group(c(64, 65, 66, 80, 81)),
    c("<65", "65-80", "65-80", "65-80", ">80")
  )
})

test_that("a missing age gets no group", {
  expect_equal(age_group(c(70, NA)), c("65-80", NA))
})
