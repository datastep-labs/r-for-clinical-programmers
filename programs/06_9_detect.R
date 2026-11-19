# Chapter 6: find text with str_detect(), and the regular expression trap
library(dplyr)
library(stringr)

cm <- pharmaversesdtm::cm

# the terms are in capitals: lower case finds nothing
cm |> filter(str_detect(CMTRT, "codeine")) |> nrow()
cm |> filter(str_detect(CMTRT, "CODEINE")) |> distinct(CMTRT)
cm |> filter(str_detect(CMTRT, regex("codeine", ignore_case = TRUE))) |> nrow()

# a pattern is a regular expression: "." means "any character"
cm |> filter(str_detect(CMTRT, ".")) |> nrow()
cm |> filter(str_detect(CMTRT, fixed("."))) |> distinct(CMTRT)
