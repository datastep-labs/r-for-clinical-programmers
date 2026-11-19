# EXPECT: ERROR In argument
# Chapter 18: code built as text. It works, but it is the last choice
library(dplyr)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")
var <- "AGE"

# 1. Code as a text, then parse() and eval(). Hard to read, hard to check
code <- paste0("adsl |> summarise(mean = mean(", var, "))")
code
eval(parse(text = code))

# 2. The same without text code: .data[[ ]] takes the name
adsl |> summarise(mean = mean(.data[[var]]))

# 3. A condition in a settings file is code by nature. Parse it once, then !!
where <- "SEX == 'F' & AGE > 80"
cond <- rlang::parse_expr(where)
adsl |> filter(!!cond) |> nrow()

# The risk: a typo in the text shows only when the code runs
where <- "SEX = 'F' & AGE > 80"
adsl |> filter(!!rlang::parse_expr(where)) |> nrow()
