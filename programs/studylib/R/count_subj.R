# count_subj.R: count the subjects per group
#
# Change log:
#   0.1.0  2026-11-19  First version.

#' Count the subjects per group
#'
#' Counts the distinct subjects of `data` for each combination of the `by`
#' columns. A subject with many records counts once per group.
#'
#' @param data A data frame with one row per record, such as ADAE.
#' @param by The columns to count by, without quotes: `TRT01A` or
#'   `c(TRT01A, AESEV)`.
#' @param id The name of the subject column, as text. Default `"USUBJID"`.
#' @return A tibble with the `by` columns and `n_subj`, one row per group,
#'   sorted by the `by` columns.
#' @examples
#' teae <- dplyr::filter(pharmaverseadam::adae, TRTEMFL == "Y")
#' count_subj(teae, TRT01A)
#' @export
count_subj <- function(data, by, id = "USUBJID") {
  # Step 010: check the arguments before any work
  if (!is.data.frame(data)) {
    cli::cli_abort(
      "{.arg data} must be a data frame, not {.obj_type_friendly {data}}."
    )
  }
  if (!rlang::is_string(id)) {
    cli::cli_abort("{.arg id} must be one text, such as {.val USUBJID}.")
  }
  if (!id %in% names(data)) {
    cli::cli_abort(c(
      "Column {.field {id}} is not in {.arg data}.",
      "i" = "Give the subject column with {.code id = \"...\"}."
    ))
  }

  # Step 020: one row per group and subject
  subj <- data |>
    dplyr::distinct(dplyr::pick({{ by }}), .data[[id]])

  # Step 030: count the subjects of each group
  subj |>
    dplyr::count(dplyr::pick({{ by }}), name = "n_subj")
}
