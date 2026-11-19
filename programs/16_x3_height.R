# Answer 16-3: the check program for HEIGHTBL, before any derivation
library(dplyr)

adsl <- readRDS("data/adsl.rds") |>
  select(USUBJID, TRTSDT)
height <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "HEIGHT") |>
  inner_join(adsl, by = join_by(USUBJID))

count(height, VISIT, VSSTRESU)
no_height <- anti_join(adsl, height, by = join_by(USUBJID))
two_heights <- count(height, USUBJID) |> filter(n > 1)
after_dose <- filter(height, as.Date(VSDTC) > TRTSDT)

tribble(
  ~check,                                 ~n,
  "subjects without a height",            nrow(no_height),
  "subjects with more than one height",   nrow(two_heights),
  "heights after the first dose",         nrow(after_dose),
  "heights without a value",              sum(is.na(height$VSSTRESN))
)
