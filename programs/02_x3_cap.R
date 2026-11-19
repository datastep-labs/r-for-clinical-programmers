# Answer 2-3: an imputed end date may not be later than 2014-03-31. Collected dates are not capped
library(dplyr)
library(lubridate)

cap <- as.Date("2014-03-31")

tibble(DTC = c("2014-03-15", "2014-03", "2014", "2014-06-30")) |>
  mutate(
    DTF = case_when(
      nchar(DTC) == 7 ~ "D",
      nchar(DTC) == 4 ~ "M"
    ),
    EARLY = ymd(DTC, truncated = 2),
    AENDT = case_when(
      DTF == "M" ~ make_date(year(EARLY), 12, 31),
      DTF == "D" ~ rollforward(EARLY),
      .default = EARLY
    ),
    AENDT_CAP = if_else(!is.na(DTF) & AENDT > cap, cap, AENDT)
  ) |>
  select(-EARLY)
