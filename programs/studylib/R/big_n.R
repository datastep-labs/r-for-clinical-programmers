# big_n.R: the number of subjects per arm in a population (the big N)
#
# Change log:
#   0.1.0  2026-11-19  First version.

#' The big N of a population
#'
#' Counts the subjects of ADSL with `"Y"` in the population flag, per arm.
#'
#' @param adsl A data frame with one row per subject.
#' @param by The arm column, without quotes. Default `TRT01A`.
#' @param pop The name of the population flag, as text. Default `"SAFFL"`.
#' @return A tibble with the `by` column and `N`.
#' @examples
#' big_n(pharmaverseadam::adsl)
#' @export
big_n <- function(adsl, by = TRT01A, pop = "SAFFL") {
  # Step 010: check the arguments
  if (!pop %in% names(adsl)) {
    cli::cli_abort("Column {.field {pop}} is not in {.arg adsl}.")
  }
  if (anyDuplicated(adsl$USUBJID) > 0) {
    cli::cli_abort("{.arg adsl} must have one row per subject.")
  }

  # Step 020: the subjects of the population, per arm
  adsl |>
    dplyr::filter(.data[[pop]] == "Y") |>
    dplyr::count({{ by }}, name = "N")
}
