# Chapter 25: a function that puts each age into a group (program 25_2 uses it)
age_group <- function(age) {
  grp <- rep(NA_character_, length(age))
  grp[age < 65] <- "<65"
  grp[age > 65 & age <= 80] <- "65-80"
  grp[age > 80] <- ">80"
  grp
}
