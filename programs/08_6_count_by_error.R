# EXPECT: ERROR Column
# Chapter 8: a wrong call stops with a message that says what to fix
library(dplyr)
source("R/count_by.R")

dm <- pharmaversesdtm::dm |> rename(SUBJECT = USUBJID)
count_by(dm, ARM)
