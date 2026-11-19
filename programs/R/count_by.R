# count_by.R: count subjects and records per group
#
# Purpose:    Count the subjects (distinct values of `id`) and the records of a
#             data frame, for each combination of the columns in `by`.
# Arguments:  data  A data frame, for example pharmaverseadam::adae.
#             by    The columns to count by, without quotes: c(TRT01A, AESEV).
#             id    The name of the subject column, as text. Default "USUBJID".
# Returns:    A tibble with the `by` columns, n_subj and n_rec: one row per group.
# Example:    count_by(pharmaverseadam::adae, c(TRT01A, AESEV))
# Change log:
#   1.0  2026-11-19  First version.
#   1.1  2026-11-19  Checks of data and id, with clear messages.

count_by <- function(data, by, id = "USUBJID") {
  stopifnot(is.character(id), length(id) == 1)
  if (!is.data.frame(data)) {
    cli::cli_abort("{.arg data} must be a data frame, not {.obj_type_friendly {data}}.")
  }
  if (!id %in% names(data)) {
    cli::cli_abort(c(
      "Column {.field {id}} is not in {.arg data}.",
      "i" = "Give the subject column with {.code id = \"...\"}."
    ))
  }

  data |>
    dplyr::group_by(dplyr::pick({{ by }})) |>
    dplyr::summarise(
      n_subj = dplyr::n_distinct(.data[[id]]),
      n_rec = dplyr::n(),
      .groups = "drop"
    )
}
