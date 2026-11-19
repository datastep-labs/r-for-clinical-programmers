# Answer 10-3: the shift table as a function, called for ALT and for AST
library(dplyr)

adlb <- readRDS("data/adlb.rds")

shift_table <- function(adlb, paramcd) {
  adlb |>
    filter(PARAMCD == paramcd, AVISITN > 0, !is.na(ANRIND)) |>
    summarise(
      BNRIND = first(BNRIND),
      WORST = case_when(
        any(ANRIND == "HIGH") ~ "HIGH",
        any(ANRIND == "LOW") ~ "LOW",
        .default = "NORMAL"
      ),
      .by = USUBJID
    ) |>
    count(BNRIND, WORST) |>
    tidyr::pivot_wider(names_from = WORST, values_from = n, values_fill = 0)
}

shift_table(adlb, "ALT")
shift_table(adlb, "AST")
