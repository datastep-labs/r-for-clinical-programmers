# Answer 3-5: age at first treatment from the birth date, compared with AGE in DM
library(dplyr)
library(lubridate)

age_check <- pharmaversesdtm::dm |>
  filter(ARMCD != "Scrnfail") |>
  mutate(
    AGE_CALC = floor(time_length(interval(ymd(BRTHDTC), ymd(RFXSTDTC)), "years"))
  ) |>
  select(USUBJID, BRTHDTC, RFXSTDTC, AGE, AGE_CALC)

age_check |> filter(USUBJID == "01-701-1015")
age_check |> count(SAME = AGE == AGE_CALC)
