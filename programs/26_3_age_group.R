# Chapter 26: age_group() with the fix of chapter 25 and a check of its input
age_group <- function(age) {
  if (!is.numeric(age)) {
    stop("age must be a number, not ", class(age)[1])
  }
  grp <- rep(NA_character_, length(age))
  grp[age < 65] <- "<65"
  grp[age >= 65 & age <= 80] <- "65-80"
  grp[age > 80] <- ">80"
  grp
}
