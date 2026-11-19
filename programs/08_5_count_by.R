# Chapter 8: source() a file of functions, then call one
library(dplyr)
source("R/count_by.R")

teae <- pharmaverseadam::adae |> filter(SAFFL == "Y", TRTEMFL == "Y")

count_by(teae, TRT01A)
count_by(teae, c(TRT01A, AESEV))
count_by(teae |> filter(USUBJID == "01-701-1015"), AESOC)
