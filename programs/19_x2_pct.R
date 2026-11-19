# Answer 19-2: subjects with a percent of the big N, built on the library
library(dplyr)
pkgload::load_all("studylib", quiet = TRUE)

count_subj_pct <- function(data, adsl, by = TRT01A) {
  denom <- big_n(adsl, by = {{ by }})
  count_subj(data, {{ by }}) |>
    left_join(denom, by = join_by({{ by }})) |>
    mutate(pct = round(100 * n_subj / N, 1))
}

teae <- pharmaverseadam::adae |>
  filter(TRTEMFL == "Y")
res <- count_subj_pct(teae, pharmaverseadam::adsl)
res

# The tests: silent when they pass
testthat::expect_equal(res$pct[res$TRT01A == "Placebo"], 75.6)
testthat::expect_true(all(res$n_subj <= res$N))
