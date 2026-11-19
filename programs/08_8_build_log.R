# Chapter 8: a function that writes one line of a build log
library(dplyr)

log_line <- function(file, program, step, data) {
  line <- sprintf("%-10s %-18s rows=%5d cols=%3d", program, step, nrow(data), ncol(data))
  cat(line, "\n", sep = "", file = file, append = TRUE)
  invisible(line)
}

log_file <- tempfile(fileext = ".log")

adsl <- pharmaverseadam::adsl
log_line(log_file, "adsl.R", "read ADSL", adsl)

saf <- adsl |> filter(SAFFL == "Y")
log_line(log_file, "adsl.R", "safety population", saf)

out <- saf |> select(USUBJID, TRT01A, AGE, SEX)
log_line(log_file, "adsl.R", "keep 4 columns", out)

readLines(log_file)
