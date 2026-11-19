# Chapter 19: load the study library with pkgload::load_all(), then use it
library(dplyr)
pkgload::load_all("studylib")

teae <- pharmaverseadam::adae |>
  filter(TRTEMFL == "Y")

count_subj(teae, TRT01A)
count_subj(teae, c(TRT01A, AESEV)) |>
  print(n = 3)
big_n(pharmaverseadam::adsl)
