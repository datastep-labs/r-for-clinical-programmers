# Chapter 17: a value and a piece of code. quote() keeps code without running it
library(dplyr)

x <- 1 + 2
x

code <- quote(1 + 2)
code
class(code)
eval(code)

# A condition as code. eval() can run it inside a data frame
adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y")
cond <- quote(AGE > 85)
cond
sum(eval(cond, adsl))

# filter() does the same with the code you write: it runs AGE > 85 in adsl
adsl |>
  filter(AGE > 85) |>
  nrow()
