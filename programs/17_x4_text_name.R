# Answer 17-4: mean_of() for a name in a text, with .data[[ ]]
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

mean_of_text <- function(data, var) {
  data |> summarise(mean = round(mean(.data[[var]]), 1))
}
mean_of_text(adsl, "AGE")

# Or turn the text into a name first: rlang::sym(), then !!
mean_of <- function(data, var) {
  data |> summarise(mean = round(mean({{ var }}), 1))
}
mean_of(adsl, !!rlang::sym("AGE"))
