# Answer 2-5: AE start dates. Strict conversion first, then early imputation with a flag
library(dplyr)
library(lubridate)

ae <- pharmaversesdtm::ae |>
  select(USUBJID, AESTDTC) |>
  mutate(
    ASTDT_STRICT = as.Date(AESTDTC, format = "%Y-%m-%d"),
    ASTDTF = case_when(
      nchar(AESTDTC) == 7 ~ "D",
      nchar(AESTDTC) == 4 ~ "M"
    ),
    ASTDT = ymd(AESTDTC, truncated = 2)
  )

sum(is.na(ae$ASTDT_STRICT))
ae |> count(ASTDTF)
sum(is.na(ae$ASTDT))
