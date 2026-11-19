# Answer 19-4: stop in count_subj(), go to step 030, look at subj
commands <- c(
  'pkgload::load_all("studylib", quiet = TRUE)',
  'teae <- dplyr::filter(pharmaverseadam::adae, TRTEMFL == "Y")',
  "debugonce(count_subj)",
  "count_subj(teae, TRT01A)",
  "n", "n", "n", "n", # the three checks of step 010
  "n", # step 020 runs: now subj exists
  "nrow(subj)",
  "nrow(teae)",
  "c" # continue to the end
)
out <- system2(
  file.path(R.home("bin"), "R"), c("--vanilla", "--quiet"),
  input = commands, stdout = TRUE, stderr = TRUE,
  env = c(paste0("R_LIBS=", paste(.libPaths(), collapse = ":")), "LC_ALL=C")
)
out <- out[!grepl("built under R version|^Warning message:$", out)]
# Only the prompts and what they print, not the code of each step
out <- gsub(getwd(), ".", out, fixed = TRUE)
writeLines(grep("^(Browse|>)|^\\[1\\]|^debug at", out, value = TRUE))
