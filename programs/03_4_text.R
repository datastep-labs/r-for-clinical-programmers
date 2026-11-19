# Chapter 3: the stringr functions you use every day, on the adverse events
library(dplyr)
library(stringr)

ae <- pharmaversesdtm::ae |>
  select(USUBJID, AEDECOD) |>
  mutate(
    SITE = str_sub(USUBJID, 4, 6),
    SUBJ = str_sub(USUBJID, 8, 11),
    PAIN = str_detect(AEDECOD, regex("pain", ignore_case = TRUE)),
    SHORT = str_replace(AEDECOD, "APPLICATION SITE", "APPL. SITE"),
    LABEL = str_c(USUBJID, " | ", str_to_lower(AEDECOD))
  )

sum(ae$PAIN)
nrow(ae)

ae |>
  filter(USUBJID == "01-701-1015") |>
  select(SITE, SUBJ, PAIN, SHORT, LABEL)
