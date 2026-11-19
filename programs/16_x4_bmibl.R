# Answer 16-4: BMIBL from WEIGHTBL and the height, compared with the reference
library(dplyr)
library(diffdf)

adsl_wt <- readRDS("data/16_adsl_weightbl.rds")

# Step 040: the height of each subject (one per subject: exercise 16-3)
height <- pharmaversesdtm::vs |>
  filter(VSTESTCD == "HEIGHT") |>
  select(USUBJID, HEIGHTBL = VSSTRESN)

# Step 050: BMI = weight in kg / (height in m) squared
ours <- adsl_wt |>
  left_join(height, by = join_by(USUBJID), relationship = "one-to-one") |>
  transmute(USUBJID, BMIBL = WEIGHTBL / (HEIGHTBL / 100)^2) |>
  haven::zap_label()
ours |>
  filter(USUBJID == "01-701-1015")

ref <- pharmaverseadam::advs |>
  filter(PARAMCD == "BMI", ABLFL == "Y") |>
  select(USUBJID, BMIBL = AVAL) |>
  haven::zap_label()
diffdf(ours, ref, keys = "USUBJID")
