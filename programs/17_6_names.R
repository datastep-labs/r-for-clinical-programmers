# Chapter 17: build column names. across() with .names, and := with a glue string
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

# .names is a pattern: {.col} is the column, {.fn} the name of the function
funs <- list(
  mean = \(x) round(mean(x, na.rm = TRUE), 1),
  max = \(x) max(x, na.rm = TRUE)
)
adsl |>
  summarise(
    across(c(AGE, TRTDURD), funs, .names = "{.col}_{.fn}"),
    .by = ARM
  )

# := lets the left side be a glue string: {{ var }} is the name, {limit} a value
flag_over <- function(data, var, limit) {
  data |>
    mutate("{{ var }}_GT{limit}" := if_else({{ var }} > limit, "Y", "N"))
}
adsl |>
  flag_over(AGE, 80) |>
  count(AGE_GT80)

# A name in a text works the same way
new <- "SAFFL2"
adsl |>
  mutate("{new}" := SAFFL) |>
  select(USUBJID, SAFFL, SAFFL2) |>
  head(2)
