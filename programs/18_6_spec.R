# Chapter 18: a specification from the data. Check the labels, then set them
library(dplyr)
library(purrr)

# The specification: one row per variable, from the reference ADSL
ref <- pharmaverseadam::adsl
spec <- tibble(
  name = names(ref),
  type = map_chr(ref, \(x) class(x)[1]),
  label = map_chr(ref, \(x) attr(x, "label") %||% NA_character_)
) |>
  mutate(across(everything(), unname))
head(spec, 4)

# Our ADSL of chapter 9, against the specification
adsl <- readRDS("data/adsl.rds")
ours <- tibble(
  name = names(adsl),
  type = map_chr(adsl, \(x) class(x)[1]),
  label = map_chr(adsl, \(x) attr(x, "label") %||% NA_character_)
)
both <- inner_join(ours, spec, by = join_by(name), suffix = c("", "_spec"))
c(
  in_both = nrow(both),
  other_type = sum(both$type != both$type_spec),
  other_label = sum(!both$label %in% both$label_spec)
)
both |>
  filter(!label %in% label_spec) |>
  select(name, label, label_spec)

# The specification writes the labels: one loop over the shared variables
for (i in seq_len(nrow(both))) {
  attr(adsl[[both$name[i]]], "label") <- both$label_spec[i]
}
sum(map_chr(adsl[both$name], \(x) attr(x, "label")) != both$label_spec)
attr(adsl$TRTEDT, "label")
