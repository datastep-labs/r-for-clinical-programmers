# Chapter 17: data masking. dplyr looks for a name in the data first
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")

# AGE is a column of adsl
adsl |> filter(AGE > 85) |> nrow()

# limit is not a column: dplyr then looks in the program
limit <- 85
adsl |> filter(AGE > limit) |> nrow()

# The trap: a variable with the same name as a column. The column wins
SEX <- "F"
adsl |> filter(SEX == SEX) |> nrow()

# The pronouns say where to look: .data is the data, .env is the program
adsl |> filter(.data$SEX == .env$SEX) |> nrow()
