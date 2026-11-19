# Chapter 18: a table of settings drives the summary. One row per variable
library(dplyr)
library(purrr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

# The settings read like the table shell: variable, label, decimals of the data
settings <- tribble(
  ~var,      ~label,                           ~dec,
  "AGE",     "Age (years)",                    0,
  "TRTDURD", "Duration of treatment (days)",   0
)

# Mean with one decimal more than the data, SD with two more
summ_one <- function(var, label, dec) {
  adsl |>
    summarise(
      n = sum(!is.na(.data[[var]])),
      mean = mean(.data[[var]], na.rm = TRUE),
      sd = sd(.data[[var]], na.rm = TRUE),
      .by = TRT01P
    ) |>
    transmute(
      label, TRT01P, n,
      stat = paste0(
        formatC(mean, format = "f", digits = dec + 1), " (",
        formatC(sd, format = "f", digits = dec + 2), ")"
      )
    ) |>
    arrange(TRT01P)
}

# pmap() calls summ_one() once per row: the columns are the arguments
pmap(settings, summ_one) |>
  list_rbind()
