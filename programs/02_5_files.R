# Chapter 2: data written in the program with tribble(), then saved as CSV and .rds and read back
library(dplyr)
library(readr)

windows <- tribble(
  ~AVISITN, ~AWLO, ~AWTARGET, ~AWHI,
  2, 2, 15, 21,
  4, 22, 29, 35,
  6, 36, 43, 49,
  8, 50, 57, 70,
  12, 71, 85, 98,
  16, 99, 113, 126,
  20, 127, 141, 154,
  24, 155, 169, 175,
  26, 176, 183, NA
) |>
  mutate(AVISIT = paste("Week", AVISITN))
windows

csv_file <- file.path(tempdir(), "windows.csv")
write_csv(windows, csv_file)
read_lines(csv_file, n_max = 3)
windows_csv <- read_csv(csv_file)

rds_file <- file.path(tempdir(), "windows.rds")
saveRDS(windows, rds_file)
identical(readRDS(rds_file), windows)
