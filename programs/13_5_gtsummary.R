# Chapter 13: the demographics table with gtsummary
library(dplyr)
library(gtsummary)

cols <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose"
)
adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(TRT = factor(TRT01A, levels = cols, labels = names(cols)))

demog <- adsl |>
  tbl_summary(
    by = TRT,
    include = c(AGE, AGEGR1, SEX, RACE),
    type = AGE ~ "continuous2",
    statistic = list(
      AGE ~ c("{N_nonmiss}", "{mean} ({sd})", "{median}", "{min}, {max}"),
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = list(AGE ~ c(0, 1, 2, 1, 0, 0), all_categorical() ~ c(0, 1)),
    label = list(
      AGE ~ "Age (years)", AGEGR1 ~ "Age group", SEX ~ "Sex", RACE ~ "Race"
    )
  ) |>
  add_overall(last = TRUE, col_label = "**Total**  \nN = {N}")
saveRDS(demog, "output/t_demog_gts.rds")

# the table as text: one row per printed line, one column per treatment
options(width = 90)
demog |>
  as_tibble(col_labels = FALSE) |>
  as.data.frame() |>
  print(na.print = "", right = FALSE, row.names = FALSE)
