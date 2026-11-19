# Chapter 17: a value is never code. Quotes, & and ; in a value need no protection
library(dplyr)

site <- "O'Brien Clinic"
dept <- "R&D"
note <- "Smith & Jones; 50% done"

paste0("Site: ", site, " (", dept, ")")
nchar(note)

# glue fills {name} with the value. Braces inside the value stay text
glue::glue("Footnote: {note}")
value <- "{AGE}"
glue::glue("The value is {value}")

# A value from the data goes into filter() as it is
arm <- "Xanomeline High Dose"
pharmaverseadam::adsl |>
  filter(ARM == arm) |>
  nrow()
