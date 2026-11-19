# Answer 17-3: a column name made from a name and a value, with :=
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

n_over <- function(data, var, limit, by) {
  data |>
    summarise(
      "n_{{ var }}_over_{limit}" := sum({{ var }} > limit, na.rm = TRUE),
      .by = {{ by }}
    )
}
n_over(adsl, AGE, 80, ARM)
n_over(adsl, TRTDURD, 180, ARM)
