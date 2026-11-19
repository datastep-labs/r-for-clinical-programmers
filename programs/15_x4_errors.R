# Answer 15-4: the log check also records an error, and then stops reading
library(dplyr)

check_log <- function(file) {
  found <- tibble(kind = character(), text = character())
  keep <- function(kind, cnd) {
    text <- gsub("\\s+", " ", conditionMessage(cnd))
    found <<- add_row(found, kind = kind, text = substr(text, 1, 60))
  }
  tryCatch(
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
    ),
    error = function(e) keep("ERROR", e)
  )
  found
}

prog <- tempfile(fileext = ".R")
writeLines(c(
  "x <- mean(c('a', 'b'))",
  "adsl <- dplyr::filter(pharmaverseadam::adsl, AEG > 80)",
  "y <- 1"
), prog)

check_log(prog)
