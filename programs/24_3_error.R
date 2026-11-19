# EXPECT: ERROR no records for HR
# Chapter 24: an error inside a function, and its frames stay open to look at
summarise_param <- function(data, paramcd) {
  rows <- data[data$PARAMCD == paramcd, ]
  if (nrow(rows) == 0) stop("no records for ", paramcd)
  c(n = nrow(rows), mean = round(mean(rows$AVAL, na.rm = TRUE), 1))
}

advs <- pharmaverseadam::advs
summarise_param(advs, "WEIGHT")
summarise_param(advs, "HR")
