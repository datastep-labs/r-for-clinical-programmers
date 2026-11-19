# Answer 4-2: the number of subjects with an AE, and the subject with the most AE records
library(dplyr)

ae_n <- pharmaversesdtm::ae |>
  count(USUBJID)

nrow(ae_n)
ae_n |> slice_max(n, n = 1)
