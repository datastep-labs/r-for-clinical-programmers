# Chapter 13: deliver the demographics table as HTML (gt) and Word (flextable)
library(dplyr)
library(gtsummary)
library(flextable)
library(officer)

# HTML: the gtsummary table of 13_5, through gt
readRDS("output/t_demog_gts.rds") |>
  as_gt() |>
  gt::tab_header(title = "Table 14.1.1 Demographics (safety population)") |>
  gt::gtsave("output/t_14_1_1_demog.html")

# Word: the table by hand of 13_2, with the big N in the column headers
layout <- readRDS("output/t_demog.rds")
arms <- c(
  "Placebo" = "Placebo", "Low Dose" = "Xanomeline Low Dose",
  "High Dose" = "Xanomeline High Dose", "Total" = "Total"
)
saf <- pharmaverseadam::adsl |> filter(SAFFL == "Y")
bign <- c(table(saf$TRT01A)[arms[1:3]], Total = nrow(saf))
headers <- setNames(paste0(arms, "\n(N=", bign, ")"), names(arms))
headers <- c(label = "", headers)
headers

ft <- layout |>
  as_grouped_data(groups = "section") |>
  as_flextable(hide_grouplabel = TRUE) |>
  set_header_labels(values = as.list(headers)) |>
  align(j = 2:5, align = "center", part = "all") |>
  bold(i = ~ !is.na(section), part = "body") |>
  autofit()

read_docx() |>
  body_add_par("Table 14.1.1 Demographics (safety population)",
    style = "heading 2"
  ) |>
  body_add_flextable(ft) |>
  print(target = "output/t_14_1_1_demog.docx")

file.exists(c("output/t_14_1_1_demog.html", "output/t_14_1_1_demog.docx"))

# read the Word file back: the header, then two lines of the table
word <- read_docx("output/t_14_1_1_demog.docx") |>
  docx_summary() |>
  filter(content_type == "table cell")
word |>
  filter(row_id == 1) |>
  pull(text)
word |>
  filter(row_id %in% 3:4) |>
  select(row_id, cell_id, text) |>
  tidyr::pivot_wider(names_from = cell_id, values_from = text)
