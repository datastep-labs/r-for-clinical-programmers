# Chapter 19: a debug session with debugonce(). R reads the commands from a
# script, line by line, as if you typed them at the console
commands <- c(
  'pkgload::load_all("studylib", quiet = TRUE)',
  "debugonce(big_n)",
  "big_n(pharmaverseadam::adsl)",
  "ls()", # the arguments of big_n()
  "pop",
  "n", # the next step
  "n",
  "nrow(adsl)",
  "c" # continue to the end
)
out <- system2(
  file.path(R.home("bin"), "R"), c("--vanilla", "--quiet"),
  input = commands, stdout = TRUE, stderr = TRUE,
  env = c(paste0("R_LIBS=", paste(.libPaths(), collapse = ":")), "LC_ALL=C")
)
# Leave out the notes of this machine about package builds; short paths
out <- out[!grepl("built under R version|^Warning message:$", out)]
writeLines(gsub(getwd(), ".", out, fixed = TRUE))
