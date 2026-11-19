# Answer 12-2: time to the first treatment-emergent serious adverse event (TTSAE)
library(dplyr)
library(admiral)

adsl <- readRDS("data/adsl.rds") |>
  filter(SAFFL == "Y")
adae <- readRDS("data/adae.rds")

sae <- event_source(
  dataset_name = "adae",
  filter = TRTEMFL == "Y" & AESER == "Y",
  date = ASTDT,
  set_values_to = exprs(
    EVNTDESC = "Serious adverse event", SRCDOM = "ADAE", SRCVAR = "ASTDT"
  )
)
end_of_study <- censor_source(
  dataset_name = "adsl",
  date = RFENDT,
  set_values_to = exprs(
    EVNTDESC = "Study completion date", SRCDOM = "ADSL", SRCVAR = "RFENDT"
  )
)

derive_param_tte(
  dataset_adsl = adsl,
  event_conditions = list(sae),
  censor_conditions = list(end_of_study),
  source_datasets = list(adsl = adsl, adae = adae),
  set_values_to = exprs(
    PARAMCD = "TTSAE", PARAM = "Time to First Serious Adverse Event"
  )
) |>
  count(PARAMCD, CNSR, EVNTDESC)
