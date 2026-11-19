# Answer 24-3: the parameter code of the heart rate in ADVS is PULSE, not HR
summarise_param <- function(data, paramcd) {
  rows <- data[data$PARAMCD == paramcd, ]
  if (nrow(rows) == 0) stop("no records for ", paramcd)
  c(n = nrow(rows), mean = round(mean(rows$AVAL, na.rm = TRUE), 1))
}

advs <- pharmaverseadam::advs
summarise_param(advs, "PULSE")
