# Chapter 19: roxygen2 writes NAMESPACE and the help pages from the #' comments
# Work on a copy in a temporary folder, so that the run writes every file anew
copy <- file.path(tempdir(), "studylib")
unlink(copy, recursive = TRUE)
invisible(file.copy("studylib", tempdir(), recursive = TRUE))
unlink(file.path(copy, c("NAMESPACE", "man")), recursive = TRUE)

roxygen2::roxygenise(copy)

list.files(copy, recursive = TRUE)
readLines(file.path(copy, "NAMESPACE"))
