# EXPECT: ERROR not to throw any warnings
# Chapter 15: a log check. Run a program and collect every warning and message
library(dplyr)

check_log <- function(file) {
  found <- tibble(kind = character(), text = character())
  keep <- function(kind, cnd) {
    text <- gsub("\\s+", " ", conditionMessage(cnd))
    found <<- add_row(found, kind = kind, text = substr(text, 1, 60))
  }
  withCallingHandlers(
    source(file, local = new.env()),
    warning = function(w) {
      keep("WARNING", w)
      invokeRestart("muffleWarning")
    },
    message = function(m) {
      keep("MESSAGE", m)
      invokeRestart("muffleMessage")
    }
  )
  found
}

log <- check_log("15_logcheck/ae_counts.R")
log
count(log, kind)

# In a test, the same check is one line: this step must give no warning
testthat::expect_no_warning(
  pharmaverseadam::adae |> count(TRT01A, AESEV)
)
testthat::expect_no_warning(as.numeric("<5"))
